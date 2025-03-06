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

  inout   [31:0]  gpio_bd, // in Common zed constr file

  output          hdmi_out_clk, // in Common zed constr file
  output          hdmi_vsync, // in Common zed constr file
  output          hdmi_hsync, // in Common zed constr file
  output          hdmi_data_e, // in Common zed constr file
  output  [15:0]  hdmi_data, // in Common zed constr file

  output          i2s_mclk, // in Common zed constr file
  output          i2s_bclk, // in Common zed constr file
  output          i2s_lrclk, // in Common zed constr file
  output          i2s_sdata_out, // in Common zed constr file
  input           i2s_sdata_in, // in Common zed constr file

  output          spdif, // in Common zed constr file

  inout           iic_scl, // in Common zed constr file
  inout           iic_sda, // in Common zed constr file
  inout   [ 1:0]  iic_mux_scl, // in Common zed constr file
  inout   [ 1:0]  iic_mux_sda, // in Common zed constr file

  input           otg_vbusoc, // in Common zed constr file

  // FMC connector
  // LVDS data interace

  input           dco_p, // in project constr file
  input           dco_n, // in project constr file
  input           da_p, // in project constr file
  input           da_n, // in project constr file
  input           db_p, // in project constr file
  input           db_n, // in project constr file
  input           cnv_in_p, // in project constr file
  input           cnv_in_n, // in project constr file

  input           fpgaclk_p, // in project constr file
  input           fpgaclk_n,

  input           clk_p, // in project constr file
  input           clk_n,

  // GPIOs

  input           doa_fmc, // in project constr file
  input           dob_fmc, // in project constr file
  input           doc_fmc, // in project constr file
  input           dod_fmc, // in project constr file

  output          gp0_dir, // in project constr file
  output          gp1_dir, // in project constr file
  output          gp2_dir, // in project constr file
  output          gp3_dir, // in project constr file
  input           gpio1_fmc, // in project constr file
  output          gpio2_fmc, // in project constr file
  input           gpio3_fmc, // in project constr file

  input           pwrgd,
  input           adf435x_lock, // in project constr file
  output          en_psu,
  output          pd_v33b,
  output          osc_en,
  output          ad9508_sync, // in project constr file

  // ADC SPI

  input           ad4080_miso, // in project constr file
  output          ad4080_sclk, // in project constr file
  output          ad4080_csn, // in project constr file
  output          ad4080_mosi, // in project constr file

  // Clock SPI

  input           ad9508_adf4350_miso, // in project constr file
  output          ad9508_adf4350_sclk, // in project constr file
  output          ad9508_adf4350_mosi, // in project constr file
  output          ad9508_csn, // in project constr file
  output          adf4350_csn // in project constr file
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
 
  wire    [ 1:0]  iic_mux_scl_i_s; // input 
  wire    [ 1:0]  iic_mux_scl_o_s; // in Common zed constr file
  wire            iic_mux_scl_t_s; //in Common zed constr file
  wire    [ 1:0]  iic_mux_sda_i_s; //in Common zed constr file
  wire    [ 1:0]  iic_mux_sda_o_s; //in Common zed constr file
  wire            iic_mux_sda_t_s; //in Common zed constr file

  wire            filter_data_ready_n;
  wire            fpga_100_clk; // output of clock buffer - IBUFDS i_fpga_100_clk
  wire            fpga_ref_clk;// output of clock buffer - IBUFDS i_fpga_clk

  assign gp0_dir        = 1'b0; // in project constr file
  assign gp1_dir        = 1'b0; // in project constr file
  assign gp2_dir        = 1'b1; // in project constr file
  assign gp3_dir        = 1'b0; // in project constr file

  assign filter_data_ready_n  = gpio1_fmc; // in project constr file
  assign gpio_i[34]           = gpio3_fmc; // in project constr file
  assign gpio2_fmc            = gpio_o[33]; // in project constr file

  assign en_psu         = 1'b1;
  assign osc_en         = pwrgd;
  assign pd_v33b        = 1'b1;
  assign ad9508_sync    = ~gpio_o[37]; // in project constr file
  assign gpio_i[35]     = adf435x_lock; // in project constr file
  assign gpio_i[36]     = pwrgd;
  assign gpio_i[63:38]  = gpio_o[63:38];

  IBUFDS i_fpga_clk (
    .I (clk_p), // in project constr file
    .IB (clk_n), // not in proj contraints file - auto zero if not connected?
    .O (fpga_ref_clk)); // output goes to system wrapper section

  IBUFDS i_fpga_100_clk (
    .I (fpgaclk_p), // in project constr file
    .IB (fpgaclk_n), // not in proj contraints file - auto zero if not connected?
    .O (fpga_100_clk)); // output goes to system wrapper section

  ad_iobuf #(
    .DATA_WIDTH(32)
  ) i_gpio_bd ( // in Common zed constr file
    .dio_t({gpio_t[31:0]}),
    .dio_i({gpio_o[31:0]}),
    .dio_o({gpio_i[31:0]}),
    .dio_p({gpio_bd[31:0]})); // in Common zed constr file

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf_iic_scl ( 
    .dio_t ({iic_mux_scl_t_s,iic_mux_scl_t_s}), // why 2?
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
    .hdmi_data (hdmi_data), // in Common zed constr file
    .hdmi_data_e (hdmi_data_e),// in Common zed constr file
    .hdmi_hsync (hdmi_hsync), // in Common zed constr file
    .hdmi_out_clk (hdmi_out_clk), // in Common zed constr file
    .hdmi_vsync (hdmi_vsync),// in Common zed constr file
    .i2s_bclk (i2s_bclk), // in Common zed constr file
    .i2s_lrclk (i2s_lrclk), // in Common zed constr file
    .i2s_mclk (i2s_mclk), // in Common zed constr file
    .i2s_sdata_in (i2s_sdata_in), // in Common zed constr file
    .i2s_sdata_out (i2s_sdata_out), // in Common zed constr file
    .iic_fmc_scl_io (iic_scl), // in Common zed constr file
    .iic_fmc_sda_io (iic_sda), // in Common zed constr file
    .iic_mux_scl_i (iic_mux_scl_i_s),
    .iic_mux_scl_o (iic_mux_scl_o_s),
    .iic_mux_scl_t (iic_mux_scl_t_s),
    .iic_mux_sda_i (iic_mux_sda_i_s),
    .iic_mux_sda_o (iic_mux_sda_o_s),
    .iic_mux_sda_t (iic_mux_sda_t_s),
    .otg_vbusoc (otg_vbusoc), // in Common zed constr file
    .spdif (spdif), // in Common zed constr file
    .spi0_clk_i (1'b0),
    .spi0_clk_o (ad4080_sclk), // in project constr file
    .spi0_csn_0_o (ad4080_csn), // in project constr file
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (ad4080_miso), // in project constr file
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (ad4080_mosi), // in project constr file
    .spi1_clk_i (1'b0),
    .spi1_clk_o (ad9508_adf4350_sclk), // in project constr file,
    .spi1_csn_0_o (ad9508_csn), // in project constr file
    .spi1_csn_1_o (adf4350_csn), // in project constr file
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (ad9508_adf4350_miso), // in project constr file
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (ad9508_adf4350_mosi), // in project constr file
    .dco_p (dco_p), // in project constr file
    .dco_n (dco_n), // in project constr file
    .da_p (da_p), // in project constr file
    .da_n (da_n), // in project constr file
    .db_p (db_p), // in project constr file
    .db_n (db_n), // in project constr file
    .cnv_in_p(cnv_in_p),// in project constr file
    .cnv_in_n(cnv_in_n),// in project constr file
    .filter_data_ready_n(filter_data_ready_n),
    .sync_n (ad9508_sync), // in project constr file
    .fpga_ref_clk(fpga_ref_clk), // created in this file via "IBUFDS i_fpga_clk" block using clk_p as an input from constraints file
    .fpga_100_clk(fpga_100_clk)); // created in this file via "IBUFDS i_fpga_100_clk" block using fpgaclk_p as an input from constraints file

endmodule
