`timescale 1ns / 1ps
`default_nettype none
`include "../defs/mod_bit_cmd.vh"

module daa_module_tb;
	logic l_reset;
	logic l_clk = 0;
	logic l_start;

	int t_i = 63;

	wire w_start_ready;
	wire w_scl;
	wire w_sdi;
	wire w_sdo;
	wire w_sda;
	wire w_push_pull_en;
	wire w_error;
	wire [`MOD_BIT_CMD_WIDTH:0] w_cmd;
	wire w_cmd_tick;
	wire w_clk_quarter;
	wire [63:0] w_pid_bcr_dcr;
	wire [6:0] w_da;
	wire w_pid_da_valid;

	bit [63:0] generic_pid_bcr_dcr = 64'hDEADBEEFBEEFDEAD;

	clk_quarter dut_clk_quarter(
		.i_reset(l_reset),
		.i_clk(l_clk),
		.o_clk(w_clk_quarter)
	);

	daa_module dut_daa_module(
		.i_reset(l_reset),
		.i_clk(l_clk),
		.i_clk_quarter(w_clk_quarter),
		.i_start(l_start),
		.o_start_ready(w_start_ready),

		.i_sdo(w_sdo),
		.o_cmd(w_cmd),

		.o_pid_bcr_dcr(w_pid_bcr_dcr),
		.o_da(w_da),
		.o_pid_da_valid(w_pid_da_valid),

		.o_error(w_error)
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

	`define DUT $root.daa_module_tb.dut_daa_module
	`define TASK_CLOCK_EDGE posedge `DUT.r_clk_quarter
	task acknowledge();
		begin
			`define ACKNOWLEDGE_CONDITION \
				(`DUT.r_sm == 2 && `DUT.r_ccc_entdaa == 0) || \
				(`DUT.r_sm == 3 && `DUT.r_arbitration == 3)	|| \
				(`DUT.r_sm == 3 && `DUT.r_arbitration == 0 && `DUT.r_arbitration_first == 1'b0)
			forever begin // Acknowledge or seek condition
				if (`ACKNOWLEDGE_CONDITION) begin
					force w_sdo = 1'b0;
					@(`TASK_CLOCK_EDGE);
					release w_sdo;
					break;
				end else
					@(`TASK_CLOCK_EDGE);
			end
		end
	endtask

	task write_generic_pid_bcr_dcr();
		begin
			`define WRITE_GENERIC_PID_BCR_DCR_CONDITION `DUT.r_sm == 3 && `DUT.r_arbitration == 4
			forever begin // Seek condition
				if (`WRITE_GENERIC_PID_BCR_DCR_CONDITION)
					break;
				else
					@(`TASK_CLOCK_EDGE);
			end
			forever begin // Execute write
				if (`WRITE_GENERIC_PID_BCR_DCR_CONDITION) begin
					// Transfer generic_pid_bcr_dcr
					// Note: it would be more accurate to use Z instead of 1.
					force w_sdo = generic_pid_bcr_dcr[t_i];
					@(`TASK_CLOCK_EDGE);
					t_i -= 1;
				end else begin
					release w_sdo;
					t_i = 63;
					break;
				end
			end
		end
	endtask

	task assert_pid_bcr_dcr();
		begin
			if (w_pid_bcr_dcr != generic_pid_bcr_dcr) begin
				$display("Test failed: got o_pid_bcr_dcr = %h instead of %h ", w_pid_bcr_dcr, generic_pid_bcr_dcr);
				$finish;
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
		acknowledge(); // Required
		acknowledge(); // ACK: Continue, NACK: Stop
		write_generic_pid_bcr_dcr();
		acknowledge(); // Required
		assert_pid_bcr_dcr();

		#200

		$display("Test passed.");
		$finish;
	end

endmodule
