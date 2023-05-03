`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module _system_top_ibi_module(
	input wire i_reset,
	input wire i_clk,
	input wire i_start,

	output wire [7:0] o_transfer,
	output wire o_transfer_valid,
	output wire o_transfer_last,
	output wire o_transfer_first,

	input wire i_bcr_2,
	input wire [3:0] i_ab_length,

	input wire [7:0] i_highest_addr,

	output wire o_scl,
	inout  wire io_sda
	);

	wire w_start_ready;
	wire w_sdi;
	wire w_sdo;
	wire w_push_pull_en;
	wire [`MOD_BIT_CMD_WIDTH:0] w_cmd;
	wire w_cmd_tick;
	wire w_clk_quarter;

	clk_quarter dut_clk_quarter(
		.i_reset(i_reset),
		.i_clk(i_clk),
		.o_clk(w_clk_quarter)
	);

	ibi_module dut_ibi_module(
		.i_reset(i_reset),
		.i_clk(i_clk),
		.i_clk_quarter(w_clk_quarter),
		.i_start(i_start),
		.o_start_ready(w_start_ready),

		.i_sdo(w_sdo),
		.o_cmd(w_cmd),

		.o_transfer(o_transfer),
		.o_transfer_valid(o_transfer_valid),
		.o_transfer_last(o_transfer_last),
		.o_transfer_first(o_transfer_first),

		.i_bcr_2(i_bcr_2),
		.i_ab_length(i_ab_length),

		.i_highest_addr(i_highest_addr)
	);

	mod_bit dut_mod_bit(
		.i_reset(i_reset),
		.i_clk(i_clk),
		.i_clk_quarter(w_clk_quarter),
		.i_cmd(w_cmd),
		.o_cmd_tick(w_cmd_tick),

		.o_scl(o_scl),
		.o_sdi(w_sdi),
		.o_push_pull_en(w_push_pull_en)
	);

	phy_sda dut_phy_sda (
		.o_sdo(w_sdo),
		.i_sdi(w_sdi),
		.i_push_pull_en(w_push_pull_en),

		.io_sda(io_sda)
	);

endmodule
