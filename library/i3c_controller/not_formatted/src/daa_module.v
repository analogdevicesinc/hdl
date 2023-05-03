/**
 * Does dynamic address assigment DAA, which occurs at bus initialization.
 *
 * The DAA process is:
 * Controller       | Peripheral  | Flow
 * -----------------|-------------|---------
 * S,0x7e,RnW=0     |             |    │
 *                  | ACK         |    │
 * ENTDAA,T         |             |    │
 * Sr               |             | ┌─►│
 * 0x7e,RnW=1       |             | │  ▼
 *                  | ACK         | │  A──┐
 *                  | PID+BCR+DCR | │  │  │
 * DA, Par          |             | │  ▼  │
 *                  | ACK         | └──B  │
 * P                |             |    C◄─┘
 *
 * Notes
 * From A with ACK, continue flow to B, or with NACK, goto C Stop,
 * finishing the DAA. At B, goto on sm state before A, Sr.
 * The first and last ACK are mandatory in the flowchart, if a NACK is received,
 * it is considered an error and the module resets.
 * The controller writes in push-pull mode.
 */

`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module daa_module(
	input wire i_reset,
	input wire i_clk,
	input wire i_clk_quarter,
	input wire i_start,
	output reg o_start_ready,

	input wire i_sdo,
	output reg [`MOD_BIT_CMD_WIDTH:0] o_cmd,

	output wire [63:0] o_pid_bcr_dcr,
	output reg [6:0] o_da,
	output reg o_pid_da_valid,

	output reg o_error
	);

	reg [5:0] r_i;

	reg r_start;
	reg r_reset;
	reg [63:0] r_pid_bcr_dcr; // buffer PID+BCR+DCR
	reg [6:0] r_da; // buffer DA
	reg r_pid_da_valid;
	reg r2_pid_da_valid;
	reg r_arbitration_first; // differentiator for arbitration_a/Sr

	reg r_clk_quarter;
	reg r2_clk_quarter;
	reg r3_clk_quarter;

	localparam [6:0]
		I3C_RESERVED = 7'h7e;
	localparam [7:0]
		I3C_RESERVED_RNW0	= {I3C_RESERVED, 1'b0}, // Concat RnW
		I3C_RESERVED_RNW1	= {I3C_RESERVED, 1'b1}, // Concat RnW
		CCC_ENTDAA			= 'h03;
	localparam [8:0]
		CCC_ENTDAA_PAR  = {CCC_ENTDAA, 1'b0}; // Concat const pariety

	reg [1:0] r_sm;
	localparam [1:0]
		idle		= 0,
		i3c_mode	= 1,
		ccc_entdaa	= 2,
		arbitration	= 3;


	reg [1:0] r_i3c_mode;
	localparam [1:0]
		i3c_mode_a	= 0, // S
		i3c_mode_b	= 1, // 0x7e,RnW=0
		i3c_mode_c	= 2; // ACK

	reg [0:0] r_ccc_entdaa;
	localparam [0:0]
		ccc_entdaa_a = 0, // CCC ENTDAA MSB bit
		ccc_entdaa_b = 1; // CCC ENTDAA others + T-bit

	reg [2:0] r_arbitration;
	localparam [2:0]
		arbitration_a = 0, // Sr
		arbitration_b = 1, // 0x7e,RnW=1
		arbitration_c = 2, // ACK
		arbitration_d = 3, // PID
		arbitration_e = 4, // DA
		arbitration_f = 5, // DA others
		arbitration_g = 6, // Par
		arbitration_h = 7; // ACK

	always @(posedge i_clk) begin
		if (i_reset)
		begin
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
		r2_pid_da_valid <= r_pid_da_valid;
		o_pid_da_valid <= ~r2_pid_da_valid && r_pid_da_valid ? 1'b1 : 1'b0;
		// Delay clocks
		r_clk_quarter <= i_clk_quarter;
		r2_clk_quarter <= r_clk_quarter;
		r3_clk_quarter <= r2_clk_quarter;
	end

	always @(posedge r2_clk_quarter) begin
		if (r_reset) begin
			r_pid_da_valid <= 1'b0;
			r_arbitration_first <= 1'b1;
			r_pid_bcr_dcr <=  0;
			r_da <= 1;
			o_da <= 0;
			o_error <= 1'b0;

			r_sm <= idle;
			r_i3c_mode <= i3c_mode_a;
			r_ccc_entdaa <= ccc_entdaa_a;
			r_arbitration <= arbitration_a;
			o_cmd <= `MOD_BIT_CMD_NOP;
		end else begin
			o_error <= 1'b0;
			case (r_sm)
				idle: begin
					if (r_start == 1'b1) begin
						r_sm <= i3c_mode;
					end else begin
						r_sm <= idle;
					end
					o_cmd <= `MOD_BIT_CMD_NOP;
				end
				i3c_mode: begin
					r_i3c_mode <= r_i3c_mode + 1;
					case (r_i3c_mode)
						i3c_mode_a: begin // S
							o_cmd <= `MOD_BIT_CMD_START_PP;
							r_i <= 7;
						end
						i3c_mode_b: begin // 0x7e,RnW=0
							if (r_i != 0) begin
								r_i <= r_i - 1;
								r_i3c_mode <= r_i3c_mode;
							end
							o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,I3C_RESERVED_RNW0[r_i[2:0]]};
						end
						i3c_mode_c: begin // ACK
							o_cmd <= `MOD_BIT_CMD_READ;
							r_i3c_mode <= i3c_mode_a;
							r_sm <= r_sm + 1;
						end
						default: begin
						end
					endcase
				end
				ccc_entdaa: begin
					r_ccc_entdaa <= r_ccc_entdaa + 1;
					case (r_ccc_entdaa)
						ccc_entdaa_a: begin // CCC ENTDAA MSB bit
							if (i_sdo == 1'b0) begin // ACK => CCC ENTDAA MSB bit
								o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,CCC_ENTDAA_PAR[8]};
								r_i <= 7;
							end else begin // NACK => ERROR
								o_cmd <= `MOD_BIT_CMD_STOP;
								r_sm <= idle;
								o_error <= 1'b1;
							end
						end
						ccc_entdaa_b: begin // CCC ENTDAA others  + T-bit
							if (r_i != 0) begin
								r_i <= r_i - 1;
								r_ccc_entdaa <= r_ccc_entdaa;
							end else begin
								r_ccc_entdaa <= ccc_entdaa_a;
								r_sm <= r_sm + 1;
							end
							o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,CCC_ENTDAA_PAR[r_i[3:0]]};
						end
					endcase
				end
				arbitration: begin
					r_arbitration <= r_arbitration + 1;
					case (r_arbitration)
						arbitration_a: begin // Sr
							if (r_arbitration_first) begin
								r_arbitration_first <= 1'b0;
								o_cmd <= `MOD_BIT_CMD_START_PP;
							end else begin
								if (i_sdo == 1'b0) begin // ACK => Sr
									o_cmd <= `MOD_BIT_CMD_START_PP;
									r_pid_da_valid <= 1'b1; // push assigment to engine
									o_da <= r_da;
									r_da <= r_da + 1;
								end else begin // NACK => ERROR
									o_cmd <= `MOD_BIT_CMD_STOP;
									r_sm <= idle;
									o_error <= 1'b1;
								end
							end
							r_i <= 7;
						end
						arbitration_b: begin // 0x7e,RnW=1
							if (r_i != 0) begin
								r_i <= r_i - 1;
								r_arbitration <= r_arbitration;
							end
							o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,I3C_RESERVED_RNW1[r_i[2:0]]};
						end
						arbitration_c: begin // ACK
							o_cmd <= `MOD_BIT_CMD_READ;
							r_i <= 63;
						end
						arbitration_d: begin // PID
							if (i_sdo == 1'b0) begin // ACK => read PID MSB "B"
								o_cmd <= `MOD_BIT_CMD_READ;
							end else begin // NACK => P "C"
								o_cmd <= `MOD_BIT_CMD_STOP;
								r_arbitration <= arbitration_a;
								r_sm <= idle;
							end
						end
						arbitration_e: begin // Sample PID MSB, read PID others
							if (r_i != 0) begin
								r_arbitration <= r_arbitration;
								o_cmd <= `MOD_BIT_CMD_READ;
								r_i <= r_i - 1;
							end else begin // write DA MSB
								o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,r_da[6]};
								r_i <= 5;
							end
							r_pid_bcr_dcr[r_i] <= i_sdo;
						end
						arbitration_f: begin // write DA others
							if (r_i != 0) begin
								r_i <= r_i - 1;
								r_arbitration <= r_arbitration;
							end
							o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,r_da[r_i[2:0]]};
						end
						arbitration_g: begin // Write odd pariety
							o_cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,~^r_da};
						end
						arbitration_h: begin // ACK
							o_cmd <= `MOD_BIT_CMD_READ;
							r_arbitration <= arbitration_a;
						end
					endcase
				end
				default: begin
					o_cmd <= `MOD_BIT_CMD_NOP;
					r_sm <= idle;
				end
			endcase
		end
	end
	assign o_pid_bcr_dcr = r_pid_bcr_dcr [63:0];
endmodule
