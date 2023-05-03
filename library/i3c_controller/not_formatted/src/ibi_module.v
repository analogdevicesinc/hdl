/**
* Does in-bus interrupt IBI, which occurs when the bus at Bus Available
 * Condition.
 *
 * The IBI process is:
 * Controller       | Peripheral | Flow
 * -----------------|------------|--------
 * S                |            |  │
 *                  | ADDRESS    |  │
 *                  | RnW=1      |  │
 * ACK              |            |  A ──┐
 *                  | MDB        |  │   │
 *                  | AD...      |  │   │
 * P/Sr             |            |  ▼ ◄─┘
 *
 * Notes
 * After receiving the ADDRESS (dynamic or static), the module requests
 * BCR[2] and addition bytes (AD) length.
 * At A, if BCR[2] is 1'b0, the IBI exits with a P/Sr;
 * if it is 1'b1, on MDB and Additional Bytes may follow (the controller knows
 * the number of bytes to wait), and then exits with a P/Sr.
 */

`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module ibi_module(
	input wire i_reset,
	input wire i_clk,
	input wire i_clk_quarter,
	input wire i_start,
	output reg o_start_ready,
	input wire [7:0] i_highest_addr,

	input wire i_sdo,
	output reg [`MOD_BIT_CMD_WIDTH:0] o_cmd,

	output reg [7:0] o_transfer, // Received {address,RnW=1}/data
	output reg o_transfer_valid,
	output reg o_transfer_last,
	output reg o_transfer_first,

	// This interface has no _ready signal because must receive the _valid
	// 4 clks after o_transfer_first and o_transfer_valid
	input wire i_bcr_2, // BCR[2], also used as valid signal for i_ab_length
	input wire [3:0] i_ab_length // TODO: check max bytes length and unlimited case
	);

	reg [2:0] r_i;
	reg [3:0] r_j;

	reg r_start;
	reg r_reset;
	reg r_transfer_valid;
	reg r2_transfer_valid;
	reg r_transfer_last;
	reg r2_transfer_last;
	reg r_transfer_first;
	reg r2_transfer_first;

	reg r_clk_quarter;
	reg r2_clk_quarter;
	reg r3_clk_quarter;

	// If no one is winning arbitration against r_highest_addr, the process is
	// terminated early
	reg [7:0] r_highest_addr;
	reg r_highest_addr_ctrl;

	reg [2:0] r_sm;
	localparam [2:0]
		idle		= 0,
		start		= 1, // S
		address_a	= 2, // Address MSB
		address_b	= 3, // Address others + RnW=1, ACK
		transfer_a	= 4, // MDB MSB
		transfer_b	= 5; // MDB others + AD

	always @(posedge i_clk) begin
		if (i_reset) begin
			o_start_ready <= 1'b0;
			r_start <= 1'b0;
			r_reset <= 1'b1;
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
		r2_transfer_first <= r_transfer_first;
		o_transfer_first <= ~r2_transfer_first && r_transfer_first ? 1'b1 : 1'b0;
		r2_transfer_last <= r_transfer_last;
		o_transfer_last <= ~r2_transfer_last && r_transfer_last ? 1'b1 : 1'b0;
		// Allow setting highest_addr on idle only
		r_highest_addr <= r_sm == idle ? i_highest_addr : r_highest_addr;
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
			r_transfer_first <= 1'b0;

			r_sm <= idle;
			o_cmd <= `MOD_BIT_CMD_NOP;
		end else begin
			r_transfer_first <= 1'b0;
			r_transfer_valid <= 1'b0;
			r_transfer_last <= 1'b0;
			case (r_sm)
				idle: begin
					if (r_start == 1'b1) begin
						r_sm <= start;
					end else begin
						r_sm <= idle;
					end
					r_highest_addr_ctrl <= 1'b1;
					o_cmd <= `MOD_BIT_CMD_NOP;
				end
				start: begin // S
					o_cmd <= `MOD_BIT_CMD_START_OD;
					r_sm <= r_sm + 1;
				end
				address_a: begin // Address MSB
					o_cmd <= `MOD_BIT_CMD_READ;
					r_i <= 7;
					r_sm <= r_sm + 1;
				end
				address_b: begin // Sample Address MSB, read Address others + RnW=1
					if (r_i == 0) begin // ACK (Controller)
						// Even though a RnW=0 constitues a error case,
						// the error will be handled by the memory,
						// yielding i_bcr_2=0 and stopping.
						// Push to request # bytes to read
						// TODO: Remember to sync the memory i_bcr_2 with next sm
						r_transfer_first <= 1'b1;
						r_transfer_valid <= 1'b1;
						o_cmd <= `MOD_BIT_CMD_WRITE_OD_0;
						r_sm <= r_sm + 1;
					end else if (r_highest_addr_ctrl && r_highest_addr[r_i] == 1'b0 && i_sdo !== 1'b0) begin
						o_cmd <= `MOD_BIT_CMD_STOP;
						r_sm <= idle;
					end else begin
						o_cmd <= `MOD_BIT_CMD_READ;
						r_sm <= r_sm;
					end
					if (i_sdo === 1'b0 && r_highest_addr[r_i] == 1'b1)
						r_highest_addr_ctrl <= 1'b0;
					r_i <= r_i == 0 ? 7 : r_i - 1;
					o_transfer[r_i] <= i_sdo;
				end
				transfer_a: begin // MDB MSB
					o_cmd <= `MOD_BIT_CMD_READ;
					if (i_bcr_2) begin // BCR[2] == 1 => read bytes
						r_j <= i_ab_length;
						r_sm <= r_sm + 1;
					end else begin // BCR[2] == 0 => P
						o_cmd <= `MOD_BIT_CMD_STOP;
						r_sm <= idle;
					end
				end
				transfer_b: begin // MDB others + AD
					r_i <= r_i == 0 ? 7 : r_i - 1;

					if (r_i == 0) begin
						r_transfer_valid <= 1'b1;
						r_j <= r_j - 1;
					end
					if (r_i == 0 && r_j == 0) begin // P
						o_cmd <= `MOD_BIT_CMD_STOP;
						r_sm <= idle;
						r_transfer_last <= 1'b1;
					end else begin
						o_cmd <= `MOD_BIT_CMD_READ;
						r_sm <= r_sm;
					end

					o_transfer[r_i] <= i_sdo;
				end
				default: begin
					o_cmd <= `MOD_BIT_CMD_NOP;
					r_sm <= idle;
				end
			endcase
		end
	end
endmodule
