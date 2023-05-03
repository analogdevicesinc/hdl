// Translate simple commands into SCL/SDA transitions
// Each command has 4 states and shall jump to a new command
// without returning to idle, A/B/C/D/*, where * is a next command
// first state A or idle.
//
// start:	SCL	~~~~~~~~~~\____
//			SDA	~~~~~~~~\______
//			 x | A | B | C | D | *
//
// repstart	SCL	____/~~~~\___
//			SDA	__/~~~\______
//			 x | A | B | C | D | *
//
// stop		SCL	____/~~~~~~~~
//			SDA	==\____/~~~~~
//			 x | A | B | C | D | *
//
// write	SCL	____/~~~~\____
//			SDA	==X=========X=
//		 	x | A | B | C | D | *
//
// read		SCL	____/~~~~\____
//			SDA	XXXX=====XXXX
//		 	x | A | B | C | D | *

`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module mod_bit(
	input wire i_reset,
	input wire i_clk,
	input wire i_clk_quarter,
	// Command from byte controller
	// "cmd_valid" is embed in known enum values
	input wire [`MOD_BIT_CMD_WIDTH:0] i_cmd,
	output reg o_cmd_tick, // indicate sample window

	output reg o_scl,
	output reg o_sdi,
	output reg o_push_pull_en
	);

	wire [2:0] key;
	reg r_clk_quarter;

	reg [4:0] r_sm;
	localparam [4:0]
		idle	= 0,
		start_b	= 1,
		start_c	= 2,
		start_d	= 3,
		stop_b	= 4,
		stop_c	= 5,
		stop_d	= 6,
		rd_b	= 7,
		rd_c	= 8,
		rd_d	= 9,
		wr_b	= 10,
		wr_c	= 11,
		wr_d	= 12,
		thigh_b = 13,
		thigh_c = 14;

	always @(posedge i_clk) begin
		if (i_reset)
		begin
			o_cmd_tick <= 1'b0;
			o_scl <= 1'b1;
			o_sdi <= 1'b1;
			r_sm <= idle;
		end
		else
		begin
			o_cmd_tick <= 1'b0;
			o_cmd_tick <= ~r_clk_quarter && i_clk_quarter ? 1'b1 : 1'b0;
			case (r_sm)
				idle:
				begin
					if (~r_clk_quarter && i_clk_quarter) begin
						case (key)
							`MOD_BIT_CMD_START_:
							begin
								r_sm <= start_b;
								o_push_pull_en <= i_cmd[1];
								o_scl <= o_scl;
								o_sdi <= 1'b1;
							end
							`MOD_BIT_CMD_STOP_:
							begin
								r_sm <= stop_b;
								o_push_pull_en <= 1'b0;
								o_scl <= 1'b0;
								o_sdi <= 1'b0;
							end
							`MOD_BIT_CMD_READ_:
							begin
								r_sm <= rd_b;
								o_push_pull_en <= 1'b0;
								o_scl <= 1'b0;
								o_sdi <= 1'b1;
							end
							`MOD_BIT_CMD_WRITE_:
							begin
								r_sm <= wr_b;
								o_push_pull_en <= i_cmd[1];
								o_scl <= 1'b0;
								o_sdi <= i_cmd[0];
							end
							default: begin
								r_sm <= idle;
								o_push_pull_en <= 1'b0;
								o_sdi <= o_sdi;
								o_scl <= o_scl;
							end
						endcase
					end
				end
				start_b, start_c,
				stop_b, stop_c,
				rd_b, rd_c,
				wr_b, wr_c,
				thigh_b:
				begin
					r_sm <= r_sm + 1;
				end
				start_d, stop_d,
				rd_d, wr_d,
				thigh_c:
				begin
					r_sm <= idle;
				end
				default:
				begin
					r_sm <= idle;
				end
			endcase

			case (r_sm)
				idle: begin
				end
				start_b: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b1;
				end
				start_c: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b0;
				end
				start_d: begin
					o_scl <= 1'b0;
					o_sdi <= 1'b0;
				end
				stop_b: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b0;
				end
				stop_c: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b0;
				end
				stop_d: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b1;
				end
				rd_b: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b1;
				end
				rd_c: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b1;
				end
				rd_d: begin
					o_scl <= 1'b0;
					o_sdi <= 1'b1;
				end
				wr_b: begin
					o_scl <= 1'b1;
					o_sdi <= o_sdi;
				end
				wr_c: begin
					o_scl <= 1'b1;
					o_sdi <= o_sdi;
				end
				wr_d: begin
					o_scl <= 1'b0;
					o_sdi <= o_sdi;
				end
				thigh_b: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b1;
				end
				thigh_c: begin
					o_scl <= 1'b1;
					o_sdi <= 1'b1;
				end
				default:
					r_sm <= idle;
			endcase
		end
		r_clk_quarter <= i_clk_quarter;
	end

	assign key = i_cmd[`MOD_BIT_CMD_WIDTH:2];
endmodule
