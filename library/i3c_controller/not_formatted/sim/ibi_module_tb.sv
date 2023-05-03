`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module ibi_module_tb;
	logic l_reset;
	logic l_clk = 0;
	logic l_start;
	logic l_bcr_2 = 0;
	logic [3:0] l_ab_length = 4'b0000;

	wire w_start_ready;
	wire w_scl;
	wire w_sdi;
	wire w_sdo;
	wire w_sda;
	wire w_push_pull_en;
	wire w_error;
	wire [`MOD_BIT_CMD_WIDTH:0] w_cmd;
	wire w_cmd_tick;
	wire [7:0] w_transfer;
	wire w_transfer_valid;
	wire w_transfer_last;
	wire w_transfer_first;
	wire w_clk_quarter;

	logic [7:0] l_highest_addr = 8'b01111111;
	logic [7:0] l_address_rnw1 = 8'b00000101;
	int t_i = 7;

	clk_quarter dut_clk_quarter(
		.i_reset(l_reset),
		.i_clk(l_clk),
		.o_clk(w_clk_quarter)
	);

	ibi_module dut_ibi_module(
		.i_reset(l_reset),
		.i_clk(l_clk),
		.i_clk_quarter(w_clk_quarter),
		.i_start(l_start),
		.o_start_ready(w_start_ready),

		.i_sdo(w_sdo),
		.o_cmd(w_cmd),

		.o_transfer(w_transfer),
		.o_transfer_valid(w_transfer_valid),
		.o_transfer_last(w_transfer_last),
		.o_transfer_first(w_transfer_first),

		.i_bcr_2(l_bcr_2),
		.i_ab_length(l_ab_length),

		.i_highest_addr(l_highest_addr)
	);

	mod_bit dut_mod_bit(
		.i_reset(l_reset),
		.i_clk(l_clk),
		.i_clk_quarter(w_clk_quarter),
		.i_cmd(w_cmd),
		.o_cmd_tick(w_cmd_tick),

		.o_scl(w_scl),
		.o_sdi(w_sdi),
		.o_push_pull_en(w_push_pull_en)
	);

	phy_sda dut_phy_sda(
		.o_sdo(w_sdo),
		.i_sdi(w_sdi),
		.i_push_pull_en(w_push_pull_en),

		.io_sda(w_sda)
	);

	always #2 l_clk = ~l_clk;

	`define DUT $root.ibi_module_tb.dut_ibi_module
	`define TASK_CLOCK_EDGE posedge `DUT.r_clk_quarter
	task write_address();
		begin
			`define WRITE_ADDRESS_CONDITION w_cmd == `MOD_BIT_CMD_READ && `DUT.r_sm == 3'h3
			forever begin // Seek condition
				if(`WRITE_ADDRESS_CONDITION)
					break;
				else
					@(`TASK_CLOCK_EDGE);
			end
			forever begin // Execute write
				if(`WRITE_ADDRESS_CONDITION) begin
					force w_sdo = l_address_rnw1[t_i];
					@(`TASK_CLOCK_EDGE);
					t_i -= 1;
				end else begin
					release w_sdo;
					t_i = 7;
					break;
				end
			end
		end
	endtask

	task write_ab_length_bcr_2();
		begin
			`define WRITE_AB_LENGTH_BCR2_CONDITION w_cmd == `MOD_BIT_CMD_WRITE_OD_0 && `DUT.r_sm == 3'h4
			forever begin // Execute logic or seek condition
				if(`WRITE_AB_LENGTH_BCR2_CONDITION) begin
					l_bcr_2 = 1'b1;
					l_ab_length = 4'b0011;
					break;
				end else
					@(`TASK_CLOCK_EDGE);
			end
		end
	endtask

	initial begin
		l_reset = 1'b1;
		l_start = 1'b0;

		# 10
		@(posedge l_clk);
		l_reset = 1'b0;

		@(posedge l_clk);
		@(posedge l_clk);
		@(posedge l_clk);
		@(posedge l_clk);
		@(posedge l_clk);
		l_start = 1'b1;
		@(posedge l_clk);
		l_start = 1'b0;
		@(posedge l_clk);

		#150
		@(posedge l_clk);
		l_start = 1'b1;
		@(posedge l_clk);
		l_start = 1'b0;

		write_address();
		write_ab_length_bcr_2();

		#800

		$display("Test passed.");
		$finish;
	end

endmodule
