`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module _system_top_mod_bit(
	input wire i_reset,
	input wire i_clk,
	input wire [`MOD_BIT_CMD_WIDTH:0] i_cmd,
	output wire o_cmd_tick,

	output wire o_scl,
	inout wire io_sda
	);

	wire w_sdi;
	wire w_sdo;
	wire w_push_pull_en;
	wire w_clk_quarter;

	clk_quarter dut_clk_quarter(
		.i_reset(i_reset),
		.i_clk(i_clk),
		.o_clk(w_clk_quarter)
	);

	mod_bit dut_mod_bit(
		.i_reset(i_reset),
		.i_clk(i_clk),
		.i_clk_quarter(w_clk_quarter),
		.i_cmd(i_cmd),
		.o_cmd_tick(o_cmd_tick),

		.o_scl(o_scl),
		.o_sdi(w_sdi),
		.o_push_pull_en(w_push_pull_en)
	);

	phy_sda dut_phy_sda(
		.o_sdo(w_sdo),
		.i_sdi(w_sdi),
		.i_push_pull_en(w_push_pull_en),

		.io_sda(io_sda)
	);
endmodule
