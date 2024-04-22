// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  inout   [14:0]  ddr_addr,
  inout   [ 2:0]  ddr_ba,
  inout           ddr_cas_n,
  inout           ddr_ck_n,
  inout           ddr_ck_p,
  inout           ddr_cke,
  inout           ddr_cs_n,
  inout   [ 3:0]  ddr_dm,
  inout   [31:0]  ddr_dq,
  inout   [ 3:0]  ddr_dqs_n,
  inout   [ 3:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [53:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  inout   [31:0]  gpio_bd,

  output          hdmi_out_clk,
  output          hdmi_vsync,
  output          hdmi_hsync,
  output          hdmi_data_e,
  output  [15:0]  hdmi_data,

  output          i2s_mclk,
  output          i2s_bclk,
  output          i2s_lrclk,
  output          i2s_sdata_out,
  input           i2s_sdata_in,

  output          spdif,

  inout           iic_scl,
  inout           iic_sda,
  inout   [ 1:0]  iic_mux_scl,
  inout   [ 1:0]  iic_mux_sda,

  input           otg_vbusoc,

  // FMC connector
  // LVDS data interace

  input           dco_p,
  input           dco_n,
  input           da_p,
  input           da_n,
  input           db_p,
  input           db_n,
  input           cnv_in_p,
  input           cnv_in_n,

  // SPI data interface

  input           doa_fmc,
  input           dob_fmc,
  input           doc_fmc,
  input           dod_fmc,

  output          gp0_dir,
  output          gp1_dir,
  output          gp2_dir,
  output          gp3_dir,
  inout           gpio1_fmc,
  inout           gpio2_fmc,
  inout           gpio3_fmc,

  input           pwrgd,
  input           adf435x_lock,
  output          en_psu,
  output          pd_v33b,
  output          osc_en,
  output          ad9508_sync,
  inout   [8:0]   pbio,

  // ADC SPI

  input           gpio0_fmc,
  output          sclk_src,
  output          cs_n_src,
  output          sdio_src,

  // Clock chips SPI

  input           sdo_1, //ad9508
  output          sclk1,
  output          sdin1,
  output          cs1_0, //ad9508
  output          cs1_1  //adf4350
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  wire    [ 1:0]  iic_mux_scl_i_s;
  wire    [ 1:0]  iic_mux_scl_o_s;
  wire            iic_mux_scl_t_s;
  wire    [ 1:0]  iic_mux_sda_i_s;
  wire    [ 1:0]  iic_mux_sda_o_s;
  wire            iic_mux_sda_t_s;


  wire            filter_data_ready_n;
  wire            sys_cpu_out_clk;

  reg             ad9508_sync_s = 1'b1;
  reg     [ 3:0]  sync_req_d    = 4'b0;
  reg     [26:0]  dbg_cnt       =  'b0;
  reg     [26:0]  dbg_cnt_f     =  'b0;
  reg     [26:0]  dbg_cnt_100_f =  'b0;

  assign ad9508_sync   = ad9508_sync_s;
  assign gpio_i[35]    = adf435x_lock;
  assign gpio_i[36]    = pwrgd;
  assign gpio_i[63:37] = gpio_o[63:37];

  assign gp0_dir  = 1'b0;
  assign gp1_dir  = 1'b0;
  assign gp2_dir  = 1'b0;
  assign gp3_dir  = 1'b0;
  assign en_psu   = 1'b1;
  assign osc_en   = pwrgd;
  assign sync_req = gpio_o[42];
  assign pd_v33b  = 1'b1;

  // always @(posedge sys_cpu_out_clk) begin
    // sync_req_d <= {sync_req_d[2:0],sync_req};
    // if (sync_req_d[2] & ~sync_req_d[3]) begin
      // ad9508_sync_s <= 1'b0;
    // end else if (~sync_req_d[2] & sync_req_d[3]) begin
      // ad9508_sync_s <= 1'b1;
    // end
  // end

  // Dummy function to prevent sys_cpu_out_clk optimization
  // Even if the clock is not used the diff termination should help signal
  // integrity

  always @(posedge sys_cpu_out_clk) begin
    dbg_cnt <= dbg_cnt + 1;
  end

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_gpio_3_2_mach1 (
    .dio_t(gpio_t[34:33]),
    .dio_i(gpio_o[34:33]),
    .dio_o(gpio_i[34:33]),
    .dio_p({gpio3_fmc,gpio2_fmc}));

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_gpio_1_mach1 (
    .dio_t(1'b1),
    .dio_i(1'b0),
    .dio_o(filter_data_ready_n),
    .dio_p(gpio1_fmc));

  ad_iobuf #(
    .DATA_WIDTH(29)
  ) i_gpio_bd (
    .dio_t({gpio_t[31:22],gpio_t[18:0]}),
    .dio_i({gpio_o[31:22],gpio_o[18:0]}),
    .dio_o({gpio_i[31:22],gpio_i[18:0]}),
    .dio_p({gpio_bd[31:22],gpio_bd[18:0]}));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf_iic_scl (
    .dio_t ({iic_mux_scl_t_s,iic_mux_scl_t_s}),
    .dio_i (iic_mux_scl_o_s),
    .dio_o (iic_mux_scl_i_s),
    .dio_p (iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf_iic_sda (
    .dio_t ({iic_mux_sda_t_s,iic_mux_sda_t_s}),
    .dio_i (iic_mux_sda_o_s),
    .dio_o (iic_mux_sda_i_s),
    .dio_p (iic_mux_sda));

  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .i2s_bclk (i2s_bclk),
    .i2s_lrclk (i2s_lrclk),
    .i2s_mclk (i2s_mclk),
    .i2s_sdata_in (i2s_sdata_in),
    .i2s_sdata_out (i2s_sdata_out),
    .iic_fmc_scl_io (iic_scl),
    .iic_fmc_sda_io (iic_sda),
    .iic_mux_scl_i (iic_mux_scl_i_s),
    .iic_mux_scl_o (iic_mux_scl_o_s),
    .iic_mux_scl_t (iic_mux_scl_t_s),
    .iic_mux_sda_i (iic_mux_sda_i_s),
    .iic_mux_sda_o (iic_mux_sda_o_s),
    .iic_mux_sda_t (iic_mux_sda_t_s),
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif),
    .spi0_clk_i (1'b0),
    .spi0_clk_o (sclk_src),
    .spi0_csn_0_o (cs_n_src),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (gpio0_fmc),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (sdio_src),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (sclk1),
    .spi1_csn_0_o (cs1_0),
    .spi1_csn_1_o (cs1_1),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (sdo_1),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (sdin1),
    .dco_p (dco_p),
    .dco_n (dco_n),
    .da_p (da_p),
    .da_n (da_n),
    .db_p (db_p),
    .db_n (db_n),
    .cnv_in_p(cnv_in_p),
    .cnv_in_n(cnv_in_n),
    .filter_data_ready_n(filter_data_ready_n),
    .sync_n (ad9508_sync),
    .sys_cpu_out_clk (sys_cpu_out_clk));

endmodule
