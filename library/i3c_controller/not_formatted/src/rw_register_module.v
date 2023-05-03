/**
 * Does write/read register of peripheral.
 *
 * The process is:
 * Controller       | Peripheral  | Flow
 * -----------------|-------------|------
 * S,0x7e,RnW=0     |             |    │
 *                  | ACK         |    │
 * Sr               |             |    │
 * Addr,RnW=1       |             |    │
 *                  | ACK         |    │
 *                  | Data...     | ┌─►▼
 * ACK              | T           | └─ A
 *                  |             |    │
 *                  |             |    ▼
 * P                |             |    B
 *
 * Notes
 * At A, the peripheral sends T-bit=1, indicating there is more data to send
 * or T-bit=0, indicating it finished; at *this* bit, the controller shall keep
 * the line released (NACK) to continue or pull low (ACK) to stop (P).
 * The controller writes in push-pull mode, except when it's ACK response
 */

`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module rw_register_module(
	input wire i_reset,
	input wire i_clk,
	input wire i_clk_quarter,
	input wire i_start,
	output reg o_start_ready,
	// TODO: use extra bit to indicate r/w and implement i_transfer,
	// for the not yet implemented write mode.
	input wire [7:0] i_address,
	input wire i_terminate,

	output reg [7:0] o_transfer,
	output reg o_transfer_valid,
	output reg o_transfer_last,

	input wire i_sdo,
	output reg [`MOD_BIT_CMD_WIDTH:0] o_cmd,

	output reg o_error
	);

	reg [3:0] r_i;

	reg r_start;
	reg r_reset;
	reg r_transfer_valid;
	reg r2_transfer_valid;
	reg r_transfer_last;
	reg r2_transfer_last;

	reg r_clk_quarter;
	reg r2_clk_quarter;
	reg r3_clk_quarter;

	reg [7:0] r_address;
	reg r_terminate;

	wire [8:0] w_address_rnw1;

	localparam [6:0]
		I3C_RESERVED = 7'h7e;
	localparam [7:0]
		I3C_RESERVED_RNW0	= {I3C_RESERVED, 1'b0}; // Concat RnW

	reg [3:0] r_sm;
	localparam [3:0]
		idle			= 0,
		i3c_mode_a		= 1, // S
		i3c_mode_b		= 2, // 0x7e,RnW=0
		i3c_mode_c		= 3, // ACK
		target_addr_a	= 4, // Sr
		target_addr_b	= 5, // Target addr + T-bit
		target_addr_c	= 6, // ACK
		transfer_a		= 7, // Data byte MSB
		transfer_b		= 8, // Data byte others
		transfer_c		= 9; // T-bit

	always @(posedge i_clk) begin
		if (i_reset)
		begin
			o_start_ready <= 1'b0;
			r_start <= 1'b0;
			r_reset <= 1'b1;
			r_terminate <= 1'b0;
		end else begin
			case (r_sm)
				idle: begin
					if (i_start == 1'b1) begin
						o_start_ready <= 1'b0;
						r_start <= 1'b1;
					end else begin
						o_start_ready <= 1'b1;
					end
				end
				default:
					o_start_ready <= 1'b0;
			endcase
			if (~r3_clk_quarter && r2_clk_quarter) begin
				r_reset <= 1'b0;
				r_start <= 1'b0;
			end
		end
		// Ensure single ticks with edge detection
		r2_transfer_valid <= r_transfer_valid;
		o_transfer_valid <= ~r2_transfer_valid && r_transfer_valid ? 1'b1 : 1'b0;
		r2_transfer_last <= r_transfer_last;
		o_transfer_last <= ~r2_transfer_last && r_transfer_last ? 1'b1 : 1'b0;
		// Allow setting target_addr on idle only
		r_address <= r_sm == idle ? i_address : r_address;
		// Delay clocks
		r_clk_quarter <= i_clk_quarter;
		r2_clk_quarter <= r_clk_quarter;
		r3_clk_quarter <= r2_clk_quarter;
	end

	always @(posedge r2_clk_quarter) begin
		if (r_reset) begin
			o_transfer <= 8'h00;
			r_transfer_valid <= 1'b0;
			r_transfer_last <= 1'b0;
			o_error <= 1'b0;

			r_sm <= idle;
			o_cmd <= `MOD_BIT_CMD_NOP;
		end else begin
			o_error <= 1'b0;
			r_transfer_valid <= 1'b0;
			r_transfer_last <= 1'b0;
			r_sm <= r_sm + 1;
			case (r_sm)
				idle: begin
					if (r_start == 1'b1) begin
						r_sm <= i3c_mode_a;
					end else begin
						r_sm <= idle;
					end
					o_cmd <= `MOD_BIT_CMD_NOP;
				end
				i3c_mode_a: begin // S
					o_cmd <= `MOD_BIT_CMD_START_PP;
					r_i <= 7;
				end
				i3c_mode_b: begin // 0x7e,RnW=0
					if (r_i != 0) begin
						r_i <= r_i - 1;
						r_sm <= r_sm;
					end
					o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,I3C_RESERVED_RNW0[r_i[2:0]]};
				end
				i3c_mode_c: begin // ACK
					o_cmd <= `MOD_BIT_CMD_READ;
				end
				target_addr_a: begin // Sr
					if (i_sdo == 1'b0) begin // ACK => Sr
						o_cmd <= `MOD_BIT_CMD_START_PP;
						r_i <= 8;
					end else begin // NACK => ERROR
						o_cmd <= `MOD_BIT_CMD_STOP;
						r_sm <= idle;
						o_error <= 1'b1;
					end
				end
				target_addr_b: begin // Address + RnW=1
					if (r_i != 0) begin
						r_sm <= r_sm;
					end
					o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,w_address_rnw1[r_i]};
					r_i <= r_i - 1;
				end
				target_addr_c: begin // ACK
					o_cmd <= `MOD_BIT_CMD_READ;
				end
				transfer_a: begin // Data byte MSB
					if (i_sdo == 1'b0) begin // ACK => Init data transfer
						o_cmd <= `MOD_BIT_CMD_READ;
						r_i <= 7;
					end else begin // NACK => ERROR
						o_cmd <= `MOD_BIT_CMD_STOP;
						r_sm <= idle;
						o_error <= 1'b1;
					end
				end
				transfer_b: begin // Data byte others
					if (r_i == 0) begin // T-bit
						if (r_terminate)
							o_cmd <= `MOD_BIT_CMD_WRITE_OD_0;
						else
							o_cmd <= `MOD_BIT_CMD_READ;
					end else begin
						o_cmd <= `MOD_BIT_CMD_READ;
						r_sm <= r_sm;
					end
					r_i <= r_i - 1;
					o_transfer[r_i[2:0]] <= i_sdo;
				end
				transfer_c: begin // T-bit
					o_cmd <= `MOD_BIT_CMD_READ;
					r_transfer_valid <= 1'b1;
					if (i_sdo !== 1'b0) begin // Read bits
						r_sm <= transfer_b;
					end else begin // Transfer terminated (controller or peripheral)
						o_cmd <= `MOD_BIT_CMD_STOP;
						r_sm <= idle;
						r_transfer_last <= 1'b1;
					end
					r_i <= 7;
				end
				default: begin
					r_sm <= idle;
				end
			endcase
		end
	end

	always @(posedge i_clk) begin
		if (r_reset) begin
			r_terminate <= 1'b0;
		end else begin
			case (r_sm)
				transfer_a,
				transfer_b,
				transfer_c:
					// Allow to terminate transfer during transfer
					if (i_terminate)
						r_terminate <= 1'b1;
				default: begin
				end
			endcase
		end
	end
	assign w_address_rnw1 = {r_address, 1'b1};
endmodule
