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

// Testbench of the FMCOMMS2 system_top: the LVDS TX pins loop back to RX.
`timescale 1ns/1ps

module system_tb;

  reg refclk_p = 1'b0;
  wire refclk_n = ~refclk_p;
  reg rx_clk_p = 1'b0;
  wire rx_clk_n = ~rx_clk_p;
  wire [6:0] tx_data_p;
  wire [6:0] tx_data_n;
  wire tx_clk_p;
  wire tx_clk_n;

  // the pins with pull-ups or pull-downs on the board side
  wire i2c0_scl;
  wire i2c0_sda;
  wire gpio_resetb;
  wire gpio_sync;
  wire gpio_en_agc;
  wire [3:0] gpio_ctl;
  wire [7:0] gpio_status;

  pullup (i2c0_scl);
  pullup (i2c0_sda);
  pulldown (gpio_resetb);
  pulldown (gpio_sync);
  pulldown (gpio_en_agc);
  pulldown pd_ctl[3:0] (gpio_ctl);
  pulldown pd_status[7:0] (gpio_status);
  integer tx_clk_edges = 0;
  integer tx_frame_edges = 0;
  integer loopback_expected_index = 0;
  integer loopback_match_count = 0;
  reg loopback_synced = 1'b0;

  localparam [47:0] LOOPBACK_SAMPLE_0 = 48'h0123_4567_89ab;
  localparam [47:0] LOOPBACK_SAMPLE_1 = 48'h1357_9bdf_2468;
  localparam [47:0] LOOPBACK_SAMPLE_2 = 48'ha5a5_5a5a_33cc;

  // fabric reference clock, 148.5 MHz (XCVR_2B_REFCLK oscillator)
  always #3.367 refclk_p = ~refclk_p;
  always #4.069 rx_clk_p = ~rx_clk_p;

  always @(tx_clk_p) begin
    if ((tx_clk_p === 1'b0) || (tx_clk_p === 1'b1)) begin
      tx_clk_edges = tx_clk_edges + 1;
    end
  end

  always @(tx_data_p[6]) begin
    if ((tx_data_p[6] === 1'b0) || (tx_data_p[6] === 1'b1)) begin
      tx_frame_edges = tx_frame_edges + 1;
    end
  end

  always @(posedge dut.i_system_lb.axi_ad9361_0_inst_0.l_clk) begin
    if ((loopback_match_count < 9) &&
      (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_valid === 1'b1)) begin
      if (loopback_synced == 1'b0) begin
        if (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data === LOOPBACK_SAMPLE_0) begin
          loopback_synced <= 1'b1;
          loopback_expected_index <= 1;
          loopback_match_count = loopback_match_count + 1;
          $display("FMCOMMS2_LOOPBACK_SYNC data=%012h", dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data);
        end else if (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data === LOOPBACK_SAMPLE_1) begin
          loopback_synced <= 1'b1;
          loopback_expected_index <= 2;
          loopback_match_count = loopback_match_count + 1;
          $display("FMCOMMS2_LOOPBACK_SYNC data=%012h", dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data);
        end else if (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data === LOOPBACK_SAMPLE_2) begin
          loopback_synced <= 1'b1;
          loopback_expected_index <= 0;
          loopback_match_count = loopback_match_count + 1;
          $display("FMCOMMS2_LOOPBACK_SYNC data=%012h", dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data);
        end
      end else begin
        if ((dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data === LOOPBACK_SAMPLE_0) ||
            (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data === LOOPBACK_SAMPLE_1) ||
            (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data === LOOPBACK_SAMPLE_2)) begin
          case (loopback_expected_index)
            0: if (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data !== LOOPBACK_SAMPLE_0) $fatal(1, "FMCOMMS2 loopback mismatch got=%012h expected=%012h", dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data, LOOPBACK_SAMPLE_0);
            1: if (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data !== LOOPBACK_SAMPLE_1) $fatal(1, "FMCOMMS2 loopback mismatch got=%012h expected=%012h", dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data, LOOPBACK_SAMPLE_1);
            2: if (dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data !== LOOPBACK_SAMPLE_2) $fatal(1, "FMCOMMS2 loopback mismatch got=%012h expected=%012h", dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data, LOOPBACK_SAMPLE_2);
          endcase
          loopback_match_count = loopback_match_count + 1;
          $display("FMCOMMS2_LOOPBACK_MATCH sample=%0d data=%012h",
            loopback_match_count,
            dut.i_system_lb.axi_ad9361_0_inst_0.i_original.genblk2.i_dev_if.adc_data);
          if (loopback_match_count == 9) begin
            $display("FMCOMMS2_LOOPBACK_PASS samples=%0d", loopback_match_count);
          end
          loopback_expected_index <= (loopback_expected_index == 2) ? 0 : loopback_expected_index + 1;
        end
      end
    end
  end

  initial begin
    #100000;
    if (loopback_match_count < 9) begin
      $fatal(1, "FMCOMMS2 loopback did not synchronize: samples=%0d", loopback_match_count);
    end
    $display("FMCOMMS2_LOOPBACK_ACTIVITY tx_clk_edges=%0d tx_frame_edges=%0d tx_frame=%b",
      tx_clk_edges, tx_frame_edges, tx_data_p[6]);
  end

  system_top dut (
    .MMUART_0_RXD_F2M(1'b1),
    .MMUART_1_RXD_F2M(1'b1),
    .REFCLK(refclk_p),
    .REFCLK_N(refclk_n),
    .REF_CLK_PAD_P(refclk_p),
    .REF_CLK_PAD_N(refclk_n),
    .SGMII_RX0_N(1'b0),
    .SGMII_RX0_P(1'b0),
    .SGMII_RX1_N(1'b0),
    .SGMII_RX1_P(1'b0),
    .SD_CD_EMMC_STRB(1'b0),
    .SD_WP_EMMC_RSTN(1'b0),
    .USB_CLK(1'b0),
    .USB_DIR(1'b0),
    .USB_NXT(1'b0),
    .RX_CLK_P(rx_clk_p),
    .RX_CLK_N(rx_clk_n),
    .RXD(tx_data_p),
    .RXD_N(tx_data_n),
    .TX_CLK(tx_clk_p),
    .TX_CLK_N(tx_clk_n),
    .TXD(tx_data_p),
    .TXD_N(tx_data_n),
    .spi0_miso(1'b0),
    .i2c0_scl_io(i2c0_scl),
    .i2c0_sda_io(i2c0_sda),
    .gpio_resetb(gpio_resetb),
    .gpio_sync(gpio_sync),
    .gpio_en_agc(gpio_en_agc),
    .gpio_ctl(gpio_ctl),
    .gpio_status(gpio_status)
  );

endmodule
