// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

  // inout   [31:0]  gpio_bd,

  output          hdmi_out_clk,
  output          hdmi_vsync,
  output          hdmi_hsync,
  output          hdmi_data_e,
  output  [15:0]  hdmi_data,

  output          spdif,

  output          i2s_mclk,
  output          i2s_bclk,
  output          i2s_lrclk,
  output          i2s_sdata_out,
  input           i2s_sdata_in,

  inout           iic_scl,
  inout           iic_sda,
  inout   [ 1:0]  iic_mux_scl,
  inout   [ 1:0]  iic_mux_sda,

  input           otg_vbusoc,

   // qspi interface
 inout   [ 3:0]  qspi_data,
 input           sclk,
 input           cs_n,
 output          ready,
 output          sys_rst_n_100m


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

  assign gpio_i[63:33] = gpio_o[63:33];



  // QSPI slave interface

  wire       sys_rst_n_100m;
  wire       sys_200M_clk;
  wire [3:0] io_i;
  wire [3:0] io_o;
  wire       io_oe;
  wire cs_n_deb;
  wire sclk_ibuf;
  wire sclk_bufg;
  wire sclk_mmcm_out;
  wire sclk_fb_out;
  wire sclk_fb_in;
  (* mark_debug = "true" *) wire mmcm_locked;

  // MMCM insertion-delay compensation for the source-synchronous sclk path.
  //
  // Problem: at 100 MHz sclk (5 ns launch-to-sample budget) the pin-to-launch-FF
  // clock insertion delay (~4 ns through IBUF + BUFG) alone consumes almost the
  // entire budget, leaving nothing for tCO and master tSU.
  //
  // Fix: bring sclk through an MMCM in ZHOLD compensation mode. ZHOLD aligns the
  // MMCM output-clock edge with the *input pin* edge, effectively cancelling the
  // insertion delay so the launch FF fires when sclk crosses the pin, not 4 ns
  // later. Feedback goes CLKFBOUT → BUFG → CLKFBIN so the compensation matches
  // the delay of a BUFG on the output side.
  //
  // Trade-offs: ~300-500 ps of added jitter, ~50-cycle lock time after sclk
  // starts toggling. LOCKED is exposed as a debug signal but not used to gate
  // the FSM — the FSM only advances on sclk edges, and MMCM locks well within
  // typical tCSS of a GPIO-bit-banged master.
  IBUF sclk_ibuf_inst (.I(sclk), .O(sclk_ibuf));

  MMCME2_ADV #(
    .BANDWIDTH        ("OPTIMIZED"),
    .COMPENSATION     ("ZHOLD"),
    .CLKIN1_PERIOD    (10.000),      // 100 MHz
    .CLKFBOUT_MULT_F  (10.000),      // VCO = 1000 MHz
    .CLKFBOUT_PHASE   (0.000),
    .DIVCLK_DIVIDE    (1),
    .CLKOUT0_DIVIDE_F (10.000),      // 100 MHz out
    .CLKOUT0_PHASE    (0.000),
    .CLKOUT0_DUTY_CYCLE (0.500),
    .STARTUP_WAIT     ("FALSE"),
    .REF_JITTER1      (0.010)
  ) sclk_mmcm_inst (
    .CLKIN1     (sclk_ibuf),
    .CLKIN2     (1'b0),
    .CLKINSEL   (1'b1),
    .CLKFBIN    (sclk_fb_in),
    .CLKFBOUT   (sclk_fb_out),
    .CLKFBOUTB  (),
    .CLKOUT0    (sclk_mmcm_out),
    .CLKOUT0B   (),
    .CLKOUT1    (), .CLKOUT1B (),
    .CLKOUT2    (), .CLKOUT2B (),
    .CLKOUT3    (), .CLKOUT3B (),
    .CLKOUT4    (),
    .CLKOUT5    (),
    .CLKOUT6    (),
    .LOCKED     (mmcm_locked),
    .DCLK       (1'b0),
    .DEN        (1'b0),
    .DWE        (1'b0),
    .DADDR      (7'b0),
    .DI         (16'b0),
    .DO         (), .DRDY (),
    .PSCLK      (1'b0),
    .PSEN       (1'b0),
    .PSINCDEC   (1'b0),
    .PSDONE     (),
    .PWRDWN     (1'b0),
    .RST        (1'b0),
    .CLKINSTOPPED (),
    .CLKFBSTOPPED ()
  );

  BUFG sclk_fb_bufg_inst  (.I(sclk_fb_out),   .O(sclk_fb_in));
  BUFG sclk_out_bufg_inst (.I(sclk_mmcm_out), .O(sclk_bufg));
  // QSPI INTERFACE

assign sys_rst_n_100m = gpio_o[32];

  // cs_n glitch filter: 2-FF synchronizer + N-sample stability counter.
  // Only propagates a level change after N consecutive matching samples in
  // sys_clk (200 MHz, 5 ns period). N=16 => 80 ns rejection window — filters
  // typical GPIO/trace noise, negligible against microsecond-scale tCSS from
  // a bit-banged master. Bump N if ILA still shows glitches passing through.
  localparam [3:0] CS_DEB_N = 4'd15;  // require N+1 = 16 stable samples

  (* ASYNC_REG = "TRUE" *) reg [1:0] cs_sync = 2'b11;
  reg [3:0] cs_cnt   = 4'd0;
  reg       cs_deb   = 1'b1;

  always @(posedge qspi_sys_clk) begin
    cs_sync <= {cs_sync[0], cs_n};
    if (cs_sync[1] == cs_deb) begin
      cs_cnt <= 4'd0;
    end else if (cs_cnt == CS_DEB_N) begin
      cs_deb <= cs_sync[1];
      cs_cnt <= 4'd0;
    end else begin
      cs_cnt <= cs_cnt + 4'd1;
    end
  end

  assign cs_n_deb = cs_deb;




  ad_iobuf #(
    .DATA_WIDTH (4)
  ) qspi_iobuf (
    .dio_t ({~io_oe, ~io_oe, ~io_oe, ~io_oe}),
    .dio_i (io_o),
    .dio_o (io_i),
    .dio_p (qspi_data));

  qspi_slave # (
    .DEFAULT_READ_LENGTH(8'd1)
  ) qspi_slave_inst (
    .sys_clk(qspi_sys_clk),
    .sys_rst_n(sys_rst_n_100m),
    .ready(ready),
    .sclk(sclk_bufg),
    .cs_n(cs_n_deb),
    .io_i(io_i),
    .io_o(io_o),
    .io_oe(io_oe)
  );


  ad_iobuf #(
    .DATA_WIDTH (2)
  ) i_iic_mux_scl (
    .dio_t ({iic_mux_scl_t_s, iic_mux_scl_t_s}),
    .dio_i (iic_mux_scl_o_s),
    .dio_o (iic_mux_scl_i_s),
    .dio_p (iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH (2)
  ) i_iic_mux_sda (
    .dio_t ({iic_mux_sda_t_s, iic_mux_sda_t_s}),
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

    .spdif (spdif),

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

    .spi0_clk_i (1'b0),
    .spi0_clk_o (),
    .spi0_csn_0_o (),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (1'b0),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (),
    .qspi_sys_clk(qspi_sys_clk));

endmodule
