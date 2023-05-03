`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module mod_bit_tb;
	logic l_reset;
	logic l_clk = 0;
	logic [`MOD_BIT_CMD_WIDTH:0] l_cmd;

	wire w_scl;
	wire w_sdi;
	wire w_push_pull_en;
	wire w_sda;
	wire w_sdo;
	wire w_sdo_valid;
	wire w_cmd_tick;
	wire w_clk_quarter;

	clk_quarter dut_clk_quarter(
		.i_reset(l_reset),
		.i_clk(l_clk),
		.o_clk(w_clk_quarter)
	);

	mod_bit dut_mod_bit (
		.i_reset(l_reset),
		.i_clk(l_clk),
		.i_clk_quarter(w_clk_quarter),
		.i_cmd(l_cmd),
		.o_cmd_tick(w_cmd_tick),

		.o_scl(w_scl),
		.o_sdi(w_sdi),
		.o_push_pull_en(w_push_pull_en)
	);

	phy_sda dut_phy_sda (
		.o_sdo(w_sdo),
		.i_sdi(w_sdi),
		.i_push_pull_en(w_push_pull_en),

		.io_sda(w_sda)
	);

	always #2 l_clk = ~l_clk;

	task wr_tri_state(input [1:0] condition, input expected_sda);
		begin;

			l_cmd = {3'b011, condition[1], condition[0]};
			@(posedge w_cmd_tick);
			@(posedge l_clk);
			if (w_sda !== expected_sda) begin
				$display("Test failed: push_pull_en = %b, sdi = %b, got sda = %b, expected sda = %b", condition[1], condition[0], w_sda, expected_sda);
				$finish;
			end
		end
	endtask

	task rd_state();
		begin
			l_cmd = `MOD_BIT_CMD_READ;
			@(posedge w_cmd_tick)
			@(posedge l_clk);
			if (w_sda !== 1'bZ) begin
				$display("Test failed: got sda = %b, expected sda = %b", w_sda, 1'bZ);
				$finish;
			end
		end
	endtask

	initial begin
		l_reset = 1'b1;
		l_cmd = `MOD_BIT_CMD_NOP;

		@(posedge l_clk);
		@(posedge l_clk);
		l_reset = 1'b0;

		l_cmd = `MOD_BIT_CMD_START_OD;
		@(posedge w_cmd_tick)

		wr_tri_state({1'b0, 1'b1}, 1'bZ);
		wr_tri_state({1'b1, 1'b1}, 1'b1);
		wr_tri_state({1'b0, 1'b0}, 1'b0);
		wr_tri_state({1'b1, 1'b0}, 1'b0);
		rd_state();

		l_cmd = `MOD_BIT_CMD_STOP;
		@(posedge w_cmd_tick)
		@(posedge l_clk);

		l_cmd = `MOD_BIT_CMD_NOP;
		#25

		$display("Test passed.");
		$finish;
	end

endmodule
