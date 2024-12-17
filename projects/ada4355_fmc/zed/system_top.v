// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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
  input           frame_clock_p,
  input           frame_clock_n,

  input           fpgaclk_p,
  input           fpgaclk_n,

  input           clk_p,
  input           clk_n,

  // GPIOs

  //input           doa_fmc,
  //input           dob_fmc,
  //input           doc_fmc,
  //input           dod_fmc,

  //output          gp0_dir,
  //output          gp1_dir,
  //output          gp2_dir,
  //output          gp3_dir,
  input           gain_sel0,
  output          gain_sel1,
  input           gain_sel2,

  input           fsel,
  input           gpio_1p8vd_en,
  input           gpio_1p8va_en,

  // input           pwrgd,
  //input           adf435x_lock,
  // output          en_psu,
  // output          pd_v33b,
  // output          osc_en,
  output          ad9508_sync,

  // ADC SPI

  input           ada4355_miso,
  output          ada4355_sclk,
  output          ada4355_csn,
  output          ada4355_mosi,

  input           miso_pot,
  output          sclk_pot,
  output          mosi_pot,
  output          csb_ld_pot,
  output          csb_apd_pot
 
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

  //wire            fpga_100_clk;
  //wire            fpga_ref_clk;

  // assign gp0_dir        = 1'b0;
  // assign gp1_dir        = 1'b0;
  // assign gp2_dir        = 1'b1;
  // assign gp3_dir        = 1'b0;

  //assign gpio_i[34]           = gpio3_fmc;
  //assign gpio2_fmc            = gpio_o[33];

  //assign en_psu         = 1'b1;
  //assign osc_en         = pwrgd;
  //assign pd_v33b        = 1'b1;
  assign ad9508_sync    = ~gpio_o[37];
  //assign gpio_i[35]     = adf435x_lock;
  //assign gpio_i[36]     = pwrgd;
  assign gpio_i[63:38]  = gpio_o[63:38];

  /*IBUFDS i_fpga_clk (
    .I (clk_p),
    .IB (clk_n),
    .O (fpga_ref_clk)); */

  /*IBUFDS i_fpga_100_clk (
    .I (fpgaclk_p),
    .IB (fpgaclk_n),
    .O (fpga_100_clk)); */

  ad_iobuf #(
    .DATA_WIDTH(32)
  ) i_gpio_bd (
    .dio_t({gpio_t[31:0]}),
    .dio_i({gpio_o[31:0]}),
    .dio_o({gpio_i[31:0]}),
    .dio_p({gpio_bd[31:0]}));

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
    .spi0_clk_o (ada4355_sclk),
    .spi0_csn_0_o (ada4355_csn),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (ada4355_miso),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (ada4355_mosi),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (/*ad9508_adf4350_sclk*/),
    .spi1_csn_0_o (/*ad9508_csn*/),
    .spi1_csn_1_o (/*adf4350_csn*/),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (/*ad9508_adf4350_miso*/),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (/*ad9508_adf4350_mosi*/),
    .dco_p (dco_p),
    .dco_n (dco_n),
    .da_p (da_p),
    .da_n (da_n),
    .db_p (db_p),
    .db_n (db_n),
    .frame_clock_p(frame_clock_p),
    .frame_clock_n(frame_clock_n),
    .sync_n (ad9508_sync));
    //.fpga_ref_clk(fpga_ref_clk),
    //.fpga_100_clk(fpga_100_clk));

endmodule
