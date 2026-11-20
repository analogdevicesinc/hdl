// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ps

module axi_ad9361_lvds_if_tb;

	localparam real RX_HALF_PERIOD_NS = 4.0;
	localparam integer NUM_TX_SAMPLES = 3;
	localparam integer REQUIRED_LOOPBACK_MATCHES = 9;
	localparam integer LOOPBACK_TIMEOUT_CYCLES = 1024;

	reg rx_clk_in_p = 1'b0;
	wire rx_clk_in_n;
	wire rx_frame_in_p;
	wire rx_frame_in_n;
	wire [5:0] rx_data_in_p;
	wire [5:0] rx_data_in_n;

	wire tx_clk_out_p;
	wire tx_clk_out_n;
	wire tx_frame_out_p;
	wire tx_frame_out_n;
	wire [5:0] tx_data_out_p;
	wire [5:0] tx_data_out_n;
	wire enable;
	wire txnrx;
	wire l_clk;

	reg rst = 1'b1;
	wire adc_valid;
	wire [47:0] adc_data;
	wire adc_status;
	reg adc_r1_mode = 1'b0;
	reg adc_ddr_edgesel = 1'b0;

	reg dac_valid = 1'b0;
	reg [47:0] dac_data = 48'd0;
	reg dac_clksel = 1'b0;
	reg dac_r1_mode = 1'b0;

	reg tdd_enable = 1'b0;
	reg tdd_txnrx = 1'b0;
	reg tdd_mode = 1'b0;

	reg mmcm_rst = 1'b0;
	reg up_rstn = 1'b0;
	reg up_enable = 1'b0;
	reg up_txnrx = 1'b0;
	reg [6:0] up_adc_dld = 7'd0;
	reg [34:0] up_adc_dwdata = 35'd0;
	wire [34:0] up_adc_drdata;
	reg [9:0] up_dac_dld = 10'd0;
	reg [49:0] up_dac_dwdata = 50'd0;
	wire [49:0] up_dac_drdata;
	reg delay_rst = 1'b1;
	wire delay_locked;

	reg up_drp_sel = 1'b0;
	reg up_drp_wr = 1'b0;
	reg [11:0] up_drp_addr = 12'd0;
	reg [31:0] up_drp_wdata = 32'd0;
	wire [31:0] up_drp_rdata;
	wire up_drp_ready;
	wire up_drp_locked;

	reg [47:0] tx_samples [0:NUM_TX_SAMPLES-1];

	integer adc_sample_count = 0;
	integer adc_expected_index = 0;
	integer adc_search_index = 0;
	integer adc_match_index = 0;
	integer tx_clk_edge_count = 0;
	integer loopback_wait_cycles = 0;
	reg capture_started = 1'b0;
	reg capture_synced = 1'b0;
	reg adc_valid_d = 1'b0;

	assign rx_clk_in_n = ~rx_clk_in_p;
	assign rx_frame_in_p = tx_frame_out_p;
	assign rx_frame_in_n = tx_frame_out_n;
	assign rx_data_in_p = tx_data_out_p;
	assign rx_data_in_n = tx_data_out_n;

	axi_ad9361_lvds_if #(
		.DAC_IODELAY_ENABLE (0),
		.CLK_DESKEW (0),
		.USE_SSI_CLK (1),
		.DELAY_REFCLK_FREQUENCY (200)
	) dut (
		.rx_clk_in_p (rx_clk_in_p),
		.rx_clk_in_n (rx_clk_in_n),
		.rx_frame_in_p (rx_frame_in_p),
		.rx_frame_in_n (rx_frame_in_n),
		.rx_data_in_p (rx_data_in_p),
		.rx_data_in_n (rx_data_in_n),
		.tx_clk_out_p (tx_clk_out_p),
		.tx_clk_out_n (tx_clk_out_n),
		.tx_frame_out_p (tx_frame_out_p),
		.tx_frame_out_n (tx_frame_out_n),
		.tx_data_out_p (tx_data_out_p),
		.tx_data_out_n (tx_data_out_n),
		.enable (enable),
		.txnrx (txnrx),
		.rst (rst),
		.clk (l_clk),
		.l_clk (l_clk),
		.adc_valid (adc_valid),
		.adc_data (adc_data),
		.adc_status (adc_status),
		.adc_r1_mode (adc_r1_mode),
		.adc_ddr_edgesel (adc_ddr_edgesel),
		.dac_valid (dac_valid),
		.dac_data (dac_data),
		.dac_clksel (dac_clksel),
		.dac_r1_mode (dac_r1_mode),
		.tdd_enable (tdd_enable),
		.tdd_txnrx (tdd_txnrx),
		.tdd_mode (tdd_mode),
		.mmcm_rst (mmcm_rst),
		.up_clk (l_clk),
		.up_rstn (up_rstn),
		.up_enable (up_enable),
		.up_txnrx (up_txnrx),
		.up_adc_dld (up_adc_dld),
		.up_adc_dwdata (up_adc_dwdata),
		.up_adc_drdata (up_adc_drdata),
		.up_dac_dld (up_dac_dld),
		.up_dac_dwdata (up_dac_dwdata),
		.up_dac_drdata (up_dac_drdata),
		.delay_clk (l_clk),
		.delay_rst (delay_rst),
		.delay_locked (delay_locked),
		.up_drp_sel (up_drp_sel),
		.up_drp_wr (up_drp_wr),
		.up_drp_addr (up_drp_addr),
		.up_drp_wdata (up_drp_wdata),
		.up_drp_rdata (up_drp_rdata),
		.up_drp_ready (up_drp_ready),
		.up_drp_locked (up_drp_locked)
	);

	always #(RX_HALF_PERIOD_NS) rx_clk_in_p = ~rx_clk_in_p;

	always @(tx_clk_out_p) begin
		if ((delay_rst == 1'b0) && !$isunknown(tx_clk_out_p)) begin
			tx_clk_edge_count = tx_clk_edge_count + 1;
		end
	end

	always @(posedge l_clk) begin
		if ((capture_started == 1'b1) && (adc_valid === 1'b1)) begin
			if (capture_synced == 1'b0) begin
				adc_match_index = -1;
				for (adc_search_index = 0; adc_search_index < NUM_TX_SAMPLES; adc_search_index = adc_search_index + 1) begin
					if ((adc_match_index == -1) && (adc_data === tx_samples[adc_search_index])) begin
						adc_match_index = adc_search_index;
					end
				end

				$display("ADC_PROBE time=%0t data=0x%012h status=%0b frame=%02b prev=%02b",
					$time,
					adc_data,
					adc_status,
					dut.rx_frame_s,
					dut.rx_frame);

				if (adc_match_index != -1) begin
					capture_synced <= 1'b1;
					adc_expected_index <= (adc_match_index + 1) % NUM_TX_SAMPLES;
					adc_sample_count = adc_sample_count + 1;
					$display("ADC_LOOPBACK_SYNC time=%0t sample_index=%0d data=0x%012h",
						$time,
						adc_match_index,
						adc_data);
				end
			end else begin
				if (adc_data !== tx_samples[adc_expected_index]) begin
					$fatal(1,
						"Loopback mismatch at sample %0d: got 0x%012h expected 0x%012h",
						adc_sample_count,
						adc_data,
						tx_samples[adc_expected_index]);
				end

				$display("ADC_LOOPBACK[%0d] time=%0t data=0x%012h expected=0x%012h status=%0b",
					adc_sample_count,
					$time,
					adc_data,
					tx_samples[adc_expected_index],
					adc_status);

				adc_sample_count = adc_sample_count + 1;
				adc_expected_index <= (adc_expected_index + 1) % NUM_TX_SAMPLES;
			end
		end
	end

	always @(posedge l_clk) begin
		if (capture_started == 1'b1) begin
			if ((adc_valid !== adc_valid_d) && !$isunknown(adc_valid)) begin
				$display("ADC_VALID_EDGE time=%0t valid=%0b status=%0b ext_frame=%0b rx_frame_s=%02b rx_frame_d=%02b",
					$time,
					adc_valid,
					adc_status,
					rx_frame_in_p,
					dut.rx_frame_s,
					dut.rx_frame);
			end

			adc_valid_d <= adc_valid;
		end
	end

	task automatic send_tx_sample;
		input [47:0] sample;
		begin
			@(posedge l_clk);
			dac_data <= sample;
			dac_valid <= 1'b1;
			@(posedge l_clk);
			dac_valid <= 1'b0;
			repeat (2) @(posedge l_clk);
		end
	endtask

	task automatic drive_tx_stream_forever;
		integer tx_index;
		begin
			forever begin
				for (tx_index = 0; tx_index < NUM_TX_SAMPLES; tx_index = tx_index + 1) begin
					send_tx_sample(tx_samples[tx_index]);
				end
			end
		end
	endtask

	task automatic wait_for_delay_lock;
		integer timeout;
		begin
			timeout = 0;
			while ((delay_locked !== 1'b1) && (timeout < 128)) begin
				@(posedge rx_clk_in_p);
				timeout = timeout + 1;
			end

			if (delay_locked !== 1'b1) begin
				$fatal(1, "delay_locked did not assert");
			end
		end
	endtask

	initial begin
		tx_samples[0] = 48'h0123_4567_89ab;
		tx_samples[1] = 48'h1357_9bdf_2468;
		tx_samples[2] = 48'ha5a5_5a5a_33cc;

		$display("Starting axi_ad9361_lvds_if fmcomms-style clocked direct frame/data loopback testbench");

		repeat (6) @(negedge rx_clk_in_p);
		rst <= 1'b0;
		delay_rst <= 1'b0;
		up_rstn <= 1'b1;

		wait_for_delay_lock();
		repeat (8) @(posedge l_clk);

		capture_started <= 1'b1;
		fork
			begin
				drive_tx_stream_forever();
			end
		join_none

		while ((adc_sample_count < REQUIRED_LOOPBACK_MATCHES) &&
		       (loopback_wait_cycles < LOOPBACK_TIMEOUT_CYCLES)) begin
			@(posedge l_clk);
			loopback_wait_cycles = loopback_wait_cycles + 1;
		end

		if (adc_sample_count < REQUIRED_LOOPBACK_MATCHES) begin
			$fatal(1,
				"Loopback did not complete: synced=%0b samples=%0d wait_cycles=%0d rx_frame_s=%02b rx_frame_d=%02b",
				capture_synced,
				adc_sample_count,
				loopback_wait_cycles,
				dut.rx_frame_s,
				dut.rx_frame);
		end

		if (tx_clk_edge_count < 16) begin
			$fatal(1, "TX clock output did not toggle enough times: %0d", tx_clk_edge_count);
		end

		$display("LVDS_IF_LOOPBACK_PASS adc_samples=%0d tx_clk_edges=%0d", adc_sample_count, tx_clk_edge_count);
		$finish;
	end

endmodule
