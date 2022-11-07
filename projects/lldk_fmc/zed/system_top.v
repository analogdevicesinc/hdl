// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

  inout       [14:0]      ddr_addr,
  inout       [ 2:0]      ddr_ba,
  inout                   ddr_cas_n,
  inout                   ddr_ck_n,
  inout                   ddr_ck_p,
  inout                   ddr_cke,
  inout                   ddr_cs_n,
  inout       [ 3:0]      ddr_dm,
  inout       [31:0]      ddr_dq,
  inout       [ 3:0]      ddr_dqs_n,
  inout       [ 3:0]      ddr_dqs_p,
  inout                   ddr_odt,
  inout                   ddr_ras_n,
  inout                   ddr_reset_n,
  inout                   ddr_we_n,

  inout                   fixed_io_ddr_vrn,
  inout                   fixed_io_ddr_vrp,
  inout       [53:0]      fixed_io_mio,
  inout                   fixed_io_ps_clk,
  inout                   fixed_io_ps_porb,
  inout                   fixed_io_ps_srstb,

  inout       [31:0]      gpio_bd,

  output                  hdmi_out_clk,
  output                  hdmi_vsync,
  output                  hdmi_hsync,
  output                  hdmi_data_e,
  output      [15:0]      hdmi_data,

  output                  i2s_mclk,
  output                  i2s_bclk,
  output                  i2s_lrclk,
  output                  i2s_sdata_out,
  input                   i2s_sdata_in,

  output                  spdif,

  inout                   iic_scl,
  inout                   iic_sda,
  inout       [ 1:0]      iic_mux_scl,
  inout       [ 1:0]      iic_mux_sda,

  input                   otg_vbusoc,

  // project specific signals

  output      [ 3:0]      rx_clk_p,
  output      [ 3:0]      rx_clk_n,

  output      [ 3:0]      rx_cnv_p,
  output      [ 3:0]      rx_cnv_n,

  input       [ 3:0]      rx_dco_p,
  input       [ 3:0]      rx_dco_n,

  input       [ 3:0]      rx_db_p,
  input       [ 3:0]      rx_db_n,

  input       [ 3:0]      rx_da_p,
  input       [ 3:0]      rx_da_n,

  input                   spi_miso,
  output                  spi_mosi,
  output                  spi_sck,
  output                  spi_csb,

  input                   fmc_la14_p,
  input                   fmc_la14_n,
  input                   fmc_la30_p,
  input                   fmc_la30_n,
  input                   fmc_la31_p,
  input                   fmc_la31_n,
  output                  direction,
  output                  reset,

  inout                   dac_0_alert,
  inout                   dac_0_ldac,
  inout                   dac_1_alert,
  inout                   dac_1_ldac,

  output                  dac_0_spi_cs,
  output                  dac_0_spi_sclk,
  inout       [ 3:0]      dac_0_spi_sdio,

  output                  dac_1_spi_cs,
  output                  dac_1_spi_sclk,
  inout       [ 3:0]      dac_1_spi_sdio
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

  wire    [ 3:0]  rx_cnv_s;
  wire    [ 3:0]  rx_cnv;

  wire            clk_gate;
  wire            sampling_clk_s;

  wire    [ 3:0]  ltc_clk;

  wire    [ 3:0]  dac_0_spi_sdo;
  wire    [ 3:0]  dac_0_spi_sdi;
  wire            dac_0_spi_sdo_t;

  wire    [ 3:0]  dac_1_spi_sdo;
  wire    [ 3:0]  dac_1_spi_sdi;
  wire            dac_1_spi_sdo_t;

  wire            dec_0_valid_a;
  wire            dec_0_valid_b;
  wire    [31:0]  dac_0_axis_tdata;
  wire    [15:0]  dec_0_data_a;
  wire    [15:0]  dec_0_data_b;

  wire            dec_1_valid_a;
  wire    [31:0]  dac_1_axis_tdata;
  wire    [15:0]  dec_1_data_a;
  wire    [15:0]  dec_1_data_b;

  assign gpio_i[63:37] = gpio_o[63:37];
  assign direction = dac_1_spi_cs == 1'h0 ? ~dac_1_spi_sdo_t : ~dac_0_spi_sdo_t;

  //  assign dac_0_axis_tdata [31] = ~dec_0_data_b [15];
  //  assign dac_0_axis_tdata [30:16] = dec_0_data_b [14:0];
  //  assign dac_0_axis_tdata [15] = ~dec_0_data_a [15];
  //  assign dac_0_axis_tdata [14:0] = dec_0_data_a [14:0];

  //  assign dac_1_axis_tdata [31] = ~dec_1_data_b [15];
  //  assign dac_1_axis_tdata [30:16] = dec_1_data_b [14:0];
  //  assign dac_1_axis_tdata [15] = ~dec_1_data_a [15];
  //  assign dac_1_axis_tdata [14:0] = dec_1_data_a [14:0];

//   reg [31:0] delay_cnt;
//   reg [31:0] pulse_cnt;
//   reg [15:0] dac_0_comp_dec_data;
//   reg [15:0] delay_dec_data;
//   reg q_adc_1_value_change;
//   //reg qq_adc_1_value_change;
//   reg delay_cnt_en;
//   reg pulse_cnt_en;
//   reg adc_1_value_change;

//   wire adc_1_passed_threshhold;

//   assign adc_1_passed_threshhold = !q_adc_1_value_change && adc_1_value_change;

//   always @(posedge sampling_clk_s) begin
//     q_adc_1_value_change <= adc_1_value_change;
//     //qq_adc_1_value_change <= q_adc_1_value_change;
//     if (adc_1_passed_threshhold) begin
//       delay_cnt_en <= 1'b1;
//     end
//     if (delay_cnt == 32'h00B71B00) begin
//       delay_cnt_en <= 1'b0;
//       pulse_cnt_en <= 1'b1;
//     end
//     if (pulse_cnt == 32'h00B71B00) begin
//       pulse_cnt_en <= 1'b0;
//     end
//   end
  
//   always @(posedge sampling_clk_s) begin
//     if (delay_cnt_en) begin
//       delay_cnt <= delay_cnt + 1'h1;
//       if (delay_cnt == 32'h00B71B00) begin
//         delay_dec_data <= 16'h0000;
//         delay_cnt <= 32'h00000000;
//       end
//     end
//     if (pulse_cnt_en) begin
//       pulse_cnt <= pulse_cnt + 1'h1;
//       if (pulse_cnt == 32'h00B71B00) begin
//         delay_dec_data <= 16'h4639;
//         pulse_cnt <= 32'h00000000;
//       end
//     end
//  end

//  // 0V -> 0000 DAC
//  // ~2.5V -> 2000 ADC
//  // ~5V  -> 4639 DAC
//  always @(posedge sampling_clk_s) begin
//   if (dec_0_valid_b) begin
//     if (!dec_0_data_b[15] && (dec_0_data_b >= 16'h2000)) begin
//       adc_1_value_change <= 1'b1;
//     end
//     else begin
//       adc_1_value_change <= 1'b0;
//     end
//   end
//   dac_0_comp_dec_data <= 16'h4639;
//   if (dec_0_valid_a) begin
//     if (!dec_0_data_a[15] && (dec_0_data_a >= 16'h2000)) begin
//       dac_0_comp_dec_data <= 16'h0000;
//     end else begin
//       dac_0_comp_dec_data <= 16'h4639;
//     end
//   end
//  end

//  assign dac_0_axis_tdata = {~delay_dec_data[15], delay_dec_data[14:0], ~dac_0_comp_dec_data[15], dac_0_comp_dec_data[14:0]};
//  assign dac_1_axis_tdata = {~delay_dec_data[15], delay_dec_data[14:0], ~dac_0_comp_dec_data[15], dac_0_comp_dec_data[14:0]};

// instantiations

  ad_iobuf #(
    .DATA_WIDTH(5)
  ) i_ad3552r_iobuf (
    .dio_t(gpio_t[36:32]),
    .dio_i(gpio_o[36:32]),
    .dio_o(gpio_i[36:32]),
    .dio_p({reset,
            dac_0_alert,
            dac_1_alert,
            dac_0_ldac,
            dac_1_ldac
            }));

  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_dac_0_spi_iobuf (
    .dio_t({dac_0_spi_sdo_t,
            dac_0_spi_sdo_t,
            dac_0_spi_sdo_t,
            dac_0_spi_sdo_t}),
    .dio_i(dac_0_spi_sdo),
    .dio_o(dac_0_spi_sdi),
    .dio_p(dac_0_spi_sdio));

  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_dac_1_spi_iobuf (
    .dio_t({dac_1_spi_sdo_t,
            dac_1_spi_sdo_t,
            dac_1_spi_sdo_t,
            dac_1_spi_sdo_t}),
    .dio_i(dac_1_spi_sdo),
    .dio_o(dac_1_spi_sdi),
    .dio_p(dac_1_spi_sdio));

  ad_iobuf #(
    .DATA_WIDTH(32)
  ) i_iobuf (
    .dio_t(gpio_t[31:0]),
    .dio_i(gpio_o[31:0]),
    .dio_o(gpio_i[31:0]),
    .dio_p(gpio_bd));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iic_mux_scl (
    .dio_t({iic_mux_scl_t_s, iic_mux_scl_t_s}),
    .dio_i(iic_mux_scl_o_s),
    .dio_o(iic_mux_scl_i_s),
    .dio_p(iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iic_mux_sda (
    .dio_t({iic_mux_sda_t_s, iic_mux_sda_t_s}),
    .dio_i(iic_mux_sda_o_s),
    .dio_o(iic_mux_sda_i_s),
    .dio_p(iic_mux_sda));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_clk_oddr0 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_clk[0]));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_clk_oddr1 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_clk[1]));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_clk_oddr2 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_clk[2]));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_clk_oddr3 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_clk[3]));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_cnv_oddr0 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_cnv[0]),
    .D2 (rx_cnv[0]),
    .Q (rx_cnv_s[0]));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_cnv_oddr1 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_cnv[1]),
    .D2 (rx_cnv[1]),
    .Q (rx_cnv_s[1]));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_cnv_oddr2 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_cnv[2]),
    .D2 (rx_cnv[2]),
    .Q (rx_cnv_s[2]));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_cnv_oddr3 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_cnv[3]),
    .D2 (rx_cnv[3]),
    .Q (rx_cnv_s[3]));

  OBUFDS i_tx_data_obuf0 (
    .I (ltc_clk[0]),
    .O (rx_clk_p[0]),
    .OB (rx_clk_n[0]));

  OBUFDS i_tx_data_obuf1 (
    .I (ltc_clk[1]),
    .O (rx_clk_p[1]),
    .OB (rx_clk_n[1]));

  OBUFDS i_tx_data_obuf2 (
    .I (ltc_clk[2]),
    .O (rx_clk_p[2]),
    .OB (rx_clk_n[2]));

  OBUFDS i_tx_data_obuf3 (
    .I (ltc_clk[3]),
    .O (rx_clk_p[3]),
    .OB (rx_clk_n[3]));

  OBUFDS OBUFDS_cnv0 (
    .O(rx_cnv_p[0]),
    .OB(rx_cnv_n[0]),
    .I(rx_cnv_s[0]));

  OBUFDS OBUFDS_cnv1 (
    .O(rx_cnv_p[1]),
    .OB(rx_cnv_n[1]),
    .I(rx_cnv_s[1]));

  OBUFDS OBUFDS_cnv2 (
    .O(rx_cnv_p[2]),
    .OB(rx_cnv_n[2]),
    .I(rx_cnv_s[2]));

  OBUFDS OBUFDS_cnv3 (
    .O(rx_cnv_p[3]),
    .OB(rx_cnv_n[3]),
    .I(rx_cnv_s[3]));

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
    .spi0_clk_o (),
    .spi0_csn_0_o (),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (),
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

    .max_spi_clk_i(spi_sck),
    .max_spi_clk_o(spi_sck),
    .max_spi_sdo_i(spi_mosi),
    .max_spi_sdo_o(spi_mosi),
    .max_spi_sdi_i(spi_miso),
    .max_spi_csn_i(spi_csb),
    .max_spi_csn_o(spi_csb),

    .rx_0_dco_p   (rx_dco_p[0]),
    .rx_0_dco_n   (rx_dco_n[0]),
    .rx_0_cnv     (rx_cnv[0]),
    .rx_0_da_p    (rx_da_p[0]),
    .rx_0_da_n    (rx_da_n[0]),
    .rx_0_db_p    (rx_db_p[0]),
    .rx_0_db_n    (rx_db_n[0]),
    .rx_1_dco_p   (rx_dco_p[1]),
    .rx_1_dco_n   (rx_dco_n[1]),
    .rx_1_cnv     (rx_cnv[1]),
    .rx_1_da_p    (rx_da_p[1]),
    .rx_1_da_n    (rx_da_n[1]),
    .rx_1_db_p    (rx_db_p[1]),
    .rx_1_db_n    (rx_db_n[1]),
    .rx_2_dco_p   (rx_dco_p[2]),
    .rx_2_dco_n   (rx_dco_n[2]),
    .rx_2_cnv     (rx_cnv[2]),
    .rx_2_da_p    (rx_da_p[2]),
    .rx_2_da_n    (rx_da_n[2]),
    .rx_2_db_p    (rx_db_p[2]),
    .rx_2_db_n    (rx_db_n[2]),
    .rx_3_dco_p   (rx_dco_p[3]),
    .rx_3_dco_n   (rx_dco_n[3]),
    .rx_3_cnv     (rx_cnv[3]),
    .rx_3_da_p    (rx_da_p[3]),
    .rx_3_da_n    (rx_da_n[3]),
    .rx_3_db_p    (rx_db_p[3]),
    .rx_3_db_n    (rx_db_n[3]),
    .clk_gate     (clk_gate),

    // .dac_0_axis_tdata (dac_0_axis_tdata),
    // .dac_0_axis_tvalid (dec_0_valid_a),
    // .dec_0_valid_a (dec_0_valid_a),
    // .dec_0_valid_b (dec_0_valid_b),
    // .dec_0_data_a (dec_0_data_a),
    // .dec_0_data_b (dec_0_data_b),

    // .dac_1_axis_tdata (dac_1_axis_tdata),
    // .dac_1_axis_tvalid (dec_1_valid_a),
    // .dec_1_valid_a (dec_1_valid_a),
    // .dec_1_data_a (dec_1_data_a),
    // .dec_1_data_b (dec_1_data_b),

    .dac_0_spi_cs         (dac_0_spi_cs),
    .dac_0_spi_sclk       (dac_0_spi_sclk),
    .dac_0_spi_sdi        (dac_0_spi_sdi),
    .dac_0_spi_sdo        (dac_0_spi_sdo),
    .dac_0_spi_sdo_t      (dac_0_spi_sdo_t),
    .dac_0_spi_three_wire (),

    .dac_1_spi_cs         (dac_1_spi_cs),
    .dac_1_spi_sclk       (dac_1_spi_sclk),
    .dac_1_spi_sdi        (dac_1_spi_sdi),
    .dac_1_spi_sdo        (dac_1_spi_sdo),
    .dac_1_spi_sdo_t      (dac_1_spi_sdo_t),
    .dac_1_spi_three_wire (),

    .sampling_clk(sampling_clk_s)
);

endmodule

// ***************************************************************************
// ***************************************************************************
