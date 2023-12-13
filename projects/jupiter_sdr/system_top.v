// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module system_top (

  output                  spi_do,
  input                   spi_di,
  output                  spi_clk,
  output                  spi_enb,

  output                  usb_pd_reset,
  output                  usb_flash_prog_en,
  output                  fan_en,
  output                  fan_ctl,
  output                  adrv9002_mcssrc,

  inout      [15:0]       ext_gpio,
  inout      [14:0]       add_on_gpio,
  output                  add_on_power,
  inout      [11:0]       dgpio,

  input                   gp_int,
  output                  mode,
  output                  resetb,
  output                  clksrc,

  input                   vin_poe_valid_n,
  input                   vin_usb2_valid_n,
  input                   vin_usb1_valid_n,

  input                   fpga_ref_clk_n,
  input                   fpga_ref_clk_p,

  input                   fpga_mcs_in_n,
  input                   fpga_mcs_in_p,
  output                  dev_mcs_fpga_out_n,
  output                  dev_mcs_fpga_out_p,

  input                   rx1_dclk_in_n,
  input                   rx1_dclk_in_p,
  output                  rx1_enable,
  input                   rx1_idata_in_n,
  input                   rx1_idata_in_p,
  input                   rx1_qdata_in_n,
  input                   rx1_qdata_in_p,
  input                   rx1_strobe_in_n,
  input                   rx1_strobe_in_p,

  input                   rx2_dclk_in_n,
  input                   rx2_dclk_in_p,
  output                  rx2_enable,
  input                   rx2_idata_in_n,
  input                   rx2_idata_in_p,
  input                   rx2_qdata_in_n,
  input                   rx2_qdata_in_p,
  input                   rx2_strobe_in_n,
  input                   rx2_strobe_in_p,

  output                  tx1_dclk_out_n,
  output                  tx1_dclk_out_p,
  input                   tx1_dclk_in_n,
  input                   tx1_dclk_in_p,
  output                  tx1_enable,
  output                  tx1_idata_out_n,
  output                  tx1_idata_out_p,
  output                  tx1_qdata_out_n,
  output                  tx1_qdata_out_p,
  output                  tx1_strobe_out_n,
  output                  tx1_strobe_out_p,

  output                  tx2_dclk_out_n,
  output                  tx2_dclk_out_p,
  input                   tx2_dclk_in_n,
  input                   tx2_dclk_in_p,
  output                  tx2_enable,
  output                  tx2_idata_out_n,
  output                  tx2_idata_out_p,
  output                  tx2_qdata_out_n,
  output                  tx2_qdata_out_p,
  output                  tx2_strobe_out_n,
  output                  tx2_strobe_out_p,

  output                  rf_rx1a_mux_ctl,
  output                  rf_rx1b_mux_ctl,
  output                  rf_rx2a_mux_ctl,
  output                  rf_rx2b_mux_ctl,
  output                  rf_tx1_mux_ctl1,
  output                  rf_tx1_mux_ctl2,
  output                  rf_tx2_mux_ctl1,
  output                  rf_tx2_mux_ctl2,

  input                   s_1p0_rf_sns_p,
  input                   s_1p0_rf_sns_n,
  input                   s_1p8_rf_sns_p,
  input                   s_1p8_rf_sns_n,
  input                   s_1p3_rf_sns_p,
  input                   s_1p3_rf_sns_n,
  input                   s_5v0_rf_sns_p,
  input                   s_5v0_rf_sns_n,
  input                   s_2v5_sns_p,
  input                   s_2v5_sns_n,
  input                   s_vtt_ps_ddr4_sns_p,
  input                   s_vtt_ps_ddr4_sns_n,
  input                   s_1v2_ps_ddr4_sns_p,
  input                   s_1v2_ps_ddr4_sns_n,

  input                   s_0v85_mgtravcc_sns_p,
  input                   s_0v85_mgtravcc_sns_n,
  input                   s_5v0_sns_p,
  input                   s_5v0_sns_n,
  input                   s_1v2_sns_p,
  input                   s_1v2_sns_n,
  input                   s_1v8_mgtravtt_sns_p,
  input                   s_1v8_mgtravtt_sns_n
);

  // internal registers

  reg         mcs_sync_m = 'd0;
  reg [31:0]  mcs_sync_pulse_period = 32'd1000; // 26us    (ref_clk = 38.4M clk)
  reg [31:0]  mcs_sync_pulse_delay = 32'd4000;  // 104.1us (ref_clk = 38.4M clk)
  reg [31:0]  mcs_sync_pulse_period_cnt = 32'd0;
  reg [31:0]  mcs_sync_pulse_delay_cnt = 32'd0;
  reg [ 2:0]  mcs_sync_pulse_num = 3'd0;
  reg         mcs_sync_busy = 1'b0;
  reg         mcs_out = 1'b0;

  // internal signals

  wire  [94:0]  gpio_i;
  wire  [94:0]  gpio_o;
  wire  [94:0]  gpio_t;
  wire          spi0_csn;

  wire          fpga_ref_clk;
  wire          fpga_mcs_in;
  wire          mssi_sync;
  wire          mcs_start;
  wire          system_sync;
  wire          mcs_or_system_sync_n;

  wire          gpio_rx1_enable_in;
  wire          gpio_rx2_enable_in;
  wire          gpio_tx1_enable_in;
  wire          gpio_tx2_enable_in;

  // assignments

  assign gpio_i[94:68] = gpio_o[94:68];
  assign gpio_i[64] = gpio_o[64];
  assign gpio_i[15:7] = gpio_o[15:7];
  assign gpio_i[3:1] = gpio_o[3:1];

  assign gpio_i[0] = gp_int;
  assign clksrc = gpio_o[1];
  assign mode   = gpio_o[2];
  assign resetb = gpio_o[3];

  assign gpio_i[4] = vin_poe_valid_n;
  assign gpio_i[5] = vin_usb2_valid_n;
  assign gpio_i[6] = vin_usb1_valid_n;

  assign mssi_sync = mcs_sync_busy | gpio_o[7];

  assign usb_pd_reset = 1'b0;
  assign adrv9002_mcssrc = gpio_o[65];
  assign usb_flash_prog_en = gpio_o[66];
  assign fan_en  = 1'b1;
  assign fan_ctl = gpio_o[67];

  assign rf_rx1a_mux_ctl = gpio_o[ 8];
  assign rf_rx1b_mux_ctl = gpio_o[ 9];
  assign rf_rx2a_mux_ctl = gpio_o[10];
  assign rf_rx2b_mux_ctl = gpio_o[11];
  assign rf_tx1_mux_ctl1 = gpio_o[12];
  assign rf_tx1_mux_ctl2 = gpio_o[13];
  assign rf_tx2_mux_ctl1 = gpio_o[14];
  assign rf_tx2_mux_ctl2 = gpio_o[15];

  assign spi_enb = spi0_csn;

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(16)
  ) i_ext_gpio_buf (
    .dio_t (gpio_t[31:16]),
    .dio_i (gpio_o[31:16]),
    .dio_o (gpio_i[31:16]),
    .dio_p (ext_gpio));

  ad_iobuf #(
    .DATA_WIDTH(16)
  ) i_iobuf (
    .dio_t ({gpio_t[47:32]}),
    .dio_i ({gpio_o[47:32]}),
    .dio_o ({gpio_i[47:32]}),
    .dio_p ({gpio_rx1_enable_in, // 47
             gpio_rx2_enable_in, // 46
             gpio_tx1_enable_in, // 45
             gpio_tx2_enable_in, // 44
             dgpio[11:0]}));     // 43:32

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_addon (
    .dio_t ({gpio_t[62:48]}),
    .dio_i ({gpio_o[62:48]}),
    .dio_o ({gpio_i[62:48]}),
    .dio_p (add_on_gpio));

  assign add_on_power = gpio_o[63];

  IBUFDS i_ibufgs_fpga_ref_clk (
    .I (fpga_ref_clk_p),
    .IB (fpga_ref_clk_n),
    .O (fpga_ref_clk));

  IBUFDS i_ibufgs_fpga_mcs_in (
    .I (fpga_mcs_in_p),
    .IB (fpga_mcs_in_n),
    .O (fpga_mcs_in));

  OBUFDS i_obufds_dev_mcs_fpga_in (
    .I (mcs_out),
    .O (dev_mcs_fpga_out_p),
    .OB (dev_mcs_fpga_out_n));

  // multi-chip or system synchronization

  // consider fpga_ref_clk = 38.4M (26.042n)
  // the MCS sync requires 6 pulses of min 10us with a in between delay of min 100us
  always @(posedge fpga_ref_clk) begin
    mcs_sync_m <= fpga_mcs_in;
    if (mcs_start) begin
      mcs_sync_busy <= 1'b1;
      mcs_sync_pulse_period_cnt <= mcs_sync_pulse_period;
      mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_delay;
      mcs_sync_pulse_num <= 3'd0;
      mcs_out <= 1'b0;
    end else if (mcs_sync_busy == 1'b1) begin
      if (mcs_sync_pulse_period_cnt != 32'd0) begin
        mcs_sync_pulse_period_cnt <= mcs_sync_pulse_period_cnt - 32'd1;
        mcs_out <= 1'b1;
      end else if (mcs_sync_pulse_delay_cnt != 32'd0) begin
        mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_delay_cnt - 32'd1;
        mcs_out <= 1'b0;
      end else begin
        if (mcs_sync_pulse_num < 5) begin
          mcs_sync_pulse_num <= mcs_sync_pulse_num + 3'd1;
          mcs_sync_pulse_period_cnt <= mcs_sync_pulse_period;
          mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_delay;
        end else begin
          mcs_sync_busy <= 1'b0;
        end
        mcs_out <= 1'b0;
      end
    end
  end

  assign mcs_start = !mcs_sync_m & fpga_mcs_in & !mcs_sync_busy & mcs_or_system_sync_n;
  assign system_sync = fpga_mcs_in & !mcs_or_system_sync_n;
  assign mcs_or_system_sync_n = gpio_o[64];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .spi0_csn(spi0_csn),
    .spi0_miso(spi_di),
    .spi0_mosi(spi_do),
    .spi0_sclk(spi_clk),

    .ref_clk (fpga_ref_clk),
    .mssi_sync (mssi_sync),
    .system_sync (system_sync),

    .tx_output_enable (1'b1),

    .rx1_dclk_in_n (rx1_dclk_in_n),
    .rx1_dclk_in_p (rx1_dclk_in_p),
    .rx1_idata_in_n (rx1_idata_in_n),
    .rx1_idata_in_p (rx1_idata_in_p),
    .rx1_qdata_in_n (rx1_qdata_in_n),
    .rx1_qdata_in_p (rx1_qdata_in_p),
    .rx1_strobe_in_n (rx1_strobe_in_n),
    .rx1_strobe_in_p (rx1_strobe_in_p),

    .rx2_dclk_in_n (rx2_dclk_in_n),
    .rx2_dclk_in_p (rx2_dclk_in_p),
    .rx2_idata_in_n (rx2_idata_in_n),
    .rx2_idata_in_p (rx2_idata_in_p),
    .rx2_qdata_in_n (rx2_qdata_in_n),
    .rx2_qdata_in_p (rx2_qdata_in_p),
    .rx2_strobe_in_n (rx2_strobe_in_n),
    .rx2_strobe_in_p (rx2_strobe_in_p),

    .tx1_dclk_out_n (tx1_dclk_out_n),
    .tx1_dclk_out_p (tx1_dclk_out_p),
    .tx1_dclk_in_n (tx1_dclk_in_n),
    .tx1_dclk_in_p (tx1_dclk_in_p),
    .tx1_idata_out_n (tx1_idata_out_n),
    .tx1_idata_out_p (tx1_idata_out_p),
    .tx1_qdata_out_n (tx1_qdata_out_n),
    .tx1_qdata_out_p (tx1_qdata_out_p),
    .tx1_strobe_out_n (tx1_strobe_out_n),
    .tx1_strobe_out_p (tx1_strobe_out_p),

    .tx2_dclk_out_n (tx2_dclk_out_n),
    .tx2_dclk_out_p (tx2_dclk_out_p),
    .tx2_dclk_in_n (tx2_dclk_in_n),
    .tx2_dclk_in_p (tx2_dclk_in_p),
    .tx2_idata_out_n (tx2_idata_out_n),
    .tx2_idata_out_p (tx2_idata_out_p),
    .tx2_qdata_out_n (tx2_qdata_out_n),
    .tx2_qdata_out_p (tx2_qdata_out_p),
    .tx2_strobe_out_n (tx2_strobe_out_n),
    .tx2_strobe_out_p (tx2_strobe_out_p),

    .rx1_enable (rx1_enable),
    .rx2_enable (rx2_enable),
    .tx1_enable (tx1_enable),
    .tx2_enable (tx2_enable),

    .gpio_rx1_enable_in (gpio_rx1_enable_in),
    .gpio_rx2_enable_in (gpio_rx2_enable_in),
    .gpio_tx1_enable_in (gpio_tx1_enable_in),
    .gpio_tx2_enable_in (gpio_tx2_enable_in),

    .s_1p0_rf_sns_p (s_1p0_rf_sns_p),
    .s_1p0_rf_sns_n (s_1p0_rf_sns_n),
    .s_1p8_rf_sns_p (s_1p8_rf_sns_p),
    .s_1p8_rf_sns_n (s_1p8_rf_sns_n),
    .s_1p3_rf_sns_p (s_1p3_rf_sns_p),
    .s_1p3_rf_sns_n (s_1p3_rf_sns_n),
    .s_5v0_rf_sns_p (s_5v0_rf_sns_p),
    .s_5v0_rf_sns_n (s_5v0_rf_sns_n),
    .s_2v5_sns_p (s_2v5_sns_p),
    .s_2v5_sns_n (s_2v5_sns_n),
    .s_vtt_ps_ddr4_sns_p (s_vtt_ps_ddr4_sns_p),
    .s_vtt_ps_ddr4_sns_n (s_vtt_ps_ddr4_sns_n),
    .s_1v2_ps_ddr4_sns_p (s_1v2_ps_ddr4_sns_p),
    .s_1v2_ps_ddr4_sns_n (s_1v2_ps_ddr4_sns_n),

    .s_0v85_mgtravcc_sns_p (s_0v85_mgtravcc_sns_p),
    .s_0v85_mgtravcc_sns_n (s_0v85_mgtravcc_sns_n),
    .s_5v0_sns_p (s_5v0_sns_p),
    .s_5v0_sns_n (s_5v0_sns_n),
    .s_1v2_sns_p (s_1v2_sns_p),
    .s_1v2_sns_n (s_1v2_sns_n),
    .s_1v8_mgtravtt_sns_p (s_1v8_mgtravtt_sns_p),
    .s_1v8_mgtravtt_sns_n (s_1v8_mgtravtt_sns_n));

endmodule
