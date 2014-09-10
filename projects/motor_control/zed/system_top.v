// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  DDR_addr,
  DDR_ba,
  DDR_cas_n,
  DDR_ck_n,
  DDR_ck_p,
  DDR_cke,
  DDR_cs_n,
  DDR_dm,
  DDR_dq,
  DDR_dqs_n,
  DDR_dqs_p,
  DDR_odt,
  DDR_ras_n,
  DDR_reset_n,
  DDR_we_n,

  FIXED_IO_ddr_vrn,
  FIXED_IO_ddr_vrp,
  FIXED_IO_mio,
  FIXED_IO_ps_clk,
  FIXED_IO_ps_porb,
  FIXED_IO_ps_srstb,

  gpio_bd,

  hdmi_out_clk,
  hdmi_vsync,
  hdmi_hsync,
  hdmi_data_e,
  hdmi_data,

  adc_ia_clk_d_o,
  adc_ia_clk_o,
  adc_ia_dat_d_i,
  adc_ia_dat_i,
  adc_ib_clk_d_o,
  adc_ib_clk_o,
  adc_ib_dat_d_i,
  adc_ib_dat_i,
  adc_it_clk_d_o,
  adc_it_clk_o,
  adc_it_dat_d_i,
  adc_it_dat_i,
  adc_vbus_clk_o,
  adc_vbus_dat_i,
  fmc_m1_en_o,
  fmc_m1_fault_i,
  gpo_o,
  position_i,
  pwm_ah_o,
  pwm_al_o,
  pwm_bh_o,
  pwm_bl_o,
  pwm_ch_o,
  pwm_cl_o,

  vauxn0,
  vauxn8,
  vauxp0,
  vauxp8,
  vn_in,
  vp_in,
  muxaddr_out,

  i2s_mclk,
  i2s_bclk,
  i2s_lrclk,
  i2s_sdata_out,
  i2s_sdata_in,

  spdif,

  iic_scl,
  iic_sda,
  iic_mux_scl,
  iic_mux_sda,

  otg_vbusoc);

  inout   [14:0]  DDR_addr;
  inout   [ 2:0]  DDR_ba;
  inout           DDR_cas_n;
  inout           DDR_ck_n;
  inout           DDR_ck_p;
  inout           DDR_cke;
  inout           DDR_cs_n;
  inout   [ 3:0]  DDR_dm;
  inout   [31:0]  DDR_dq;
  inout   [ 3:0]  DDR_dqs_n;
  inout   [ 3:0]  DDR_dqs_p;
  inout           DDR_odt;
  inout           DDR_ras_n;
  inout           DDR_reset_n;
  inout           DDR_we_n;

  inout           FIXED_IO_ddr_vrn;
  inout           FIXED_IO_ddr_vrp;
  inout   [53:0]  FIXED_IO_mio;
  inout           FIXED_IO_ps_clk;
  inout           FIXED_IO_ps_porb;
  inout           FIXED_IO_ps_srstb;

  inout   [31:0]  gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;

  output          adc_ia_clk_d_o;
  output          adc_ia_clk_o;
  input           adc_ia_dat_d_i;
  input           adc_ia_dat_i;
  output          adc_ib_clk_d_o;
  output          adc_ib_clk_o;
  input           adc_ib_dat_d_i;
  input           adc_ib_dat_i;
  output          adc_it_clk_d_o;
  output          adc_it_clk_o;
  input           adc_it_dat_d_i;
  input           adc_it_dat_i;
  output          adc_vbus_clk_o;
  input           adc_vbus_dat_i;
  output          fmc_m1_en_o;
  input           fmc_m1_fault_i;
  output [7:0]    gpo_o;
  input  [2:0]    position_i;
  output          pwm_ah_o;
  output          pwm_al_o;
  output          pwm_bh_o;
  output          pwm_bl_o;
  output          pwm_ch_o;
  output          pwm_cl_o;

  input vauxn0;
  input vauxn8;
  input vauxp0;
  input vauxp8;
  input vn_in;
  input vp_in;
  output [3:0]muxaddr_out;

  output          spdif;

  output          i2s_mclk;
  output          i2s_bclk;
  output          i2s_lrclk;
  output          i2s_sdata_out;
  input           i2s_sdata_in;


  inout           iic_scl;
  inout           iic_sda;
  inout   [ 1:0]  iic_mux_scl;
  inout   [ 1:0]  iic_mux_sda;

  input           otg_vbusoc;

  // internal signals

  wire    [31:0]  gpio_i;
  wire    [31:0]  gpio_o;
  wire    [31:0]  gpio_t;
  wire    [ 1:0]  iic_mux_scl_i_s;
  wire    [ 1:0]  iic_mux_scl_o_s;
  wire            iic_mux_scl_t_s;
  wire    [ 1:0]  iic_mux_sda_i_s;
  wire    [ 1:0]  iic_mux_sda_o_s;
  wire            iic_mux_sda_t_s;

  // instantiations

  genvar n;
  generate
  for (n = 0; n <= 31; n = n + 1) begin: g_iobuf_gpio_bd
  IOBUF i_iobuf_gpio_bd (
    .I (gpio_o[n]),
    .O (gpio_i[n]),
    .T (gpio_t[n]),
    .IO (gpio_bd[n]));
  end
  endgenerate

  IOBUF i_iic_mux_scl_0 (.I(iic_mux_scl_o_s[0]), .O(iic_mux_scl_i_s[0]), .T(iic_mux_scl_t_s), .IO(iic_mux_scl[0]));
  IOBUF i_iic_mux_scl_1 (.I(iic_mux_scl_o_s[1]), .O(iic_mux_scl_i_s[1]), .T(iic_mux_scl_t_s), .IO(iic_mux_scl[1]));
  IOBUF i_iic_mux_sda_0 (.I(iic_mux_sda_o_s[0]), .O(iic_mux_sda_i_s[0]), .T(iic_mux_sda_t_s), .IO(iic_mux_sda[0]));
  IOBUF i_iic_mux_sda_1 (.I(iic_mux_sda_o_s[1]), .O(iic_mux_sda_i_s[1]), .T(iic_mux_sda_t_s), .IO(iic_mux_sda[1]));

  system_wrapper i_system_wrapper (
    .DDR_addr (DDR_addr),
    .DDR_ba (DDR_ba),
    .DDR_cas_n (DDR_cas_n),
    .DDR_ck_n (DDR_ck_n),
    .DDR_ck_p (DDR_ck_p),
    .DDR_cke (DDR_cke),
    .DDR_cs_n (DDR_cs_n),
    .DDR_dm (DDR_dm),
    .DDR_dq (DDR_dq),
    .DDR_dqs_n (DDR_dqs_n),
    .DDR_dqs_p (DDR_dqs_p),
    .DDR_odt (DDR_odt),
    .DDR_ras_n (DDR_ras_n),
    .DDR_reset_n (DDR_reset_n),
    .DDR_we_n (DDR_we_n),
    .FIXED_IO_ddr_vrn (FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp (FIXED_IO_ddr_vrp),
    .FIXED_IO_mio (FIXED_IO_mio),
    .FIXED_IO_ps_clk (FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb (FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb (FIXED_IO_ps_srstb),
    .GPIO_I (gpio_i),
    .GPIO_O (gpio_o),
    .GPIO_T (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .adc_ia_clk_d_o(adc_ia_clk_d_o),
    .adc_ia_clk_o(adc_ia_clk_o),
    .adc_ia_dat_d_i(adc_ia_dat_d_i),
    .adc_ia_dat_i(adc_ia_dat_i),
    .adc_ib_clk_d_o(adc_ib_clk_d_o),
    .adc_ib_clk_o(adc_ib_clk_o),
    .adc_ib_dat_d_i(adc_ib_dat_d_i),
    .adc_ib_dat_i(adc_ib_dat_i),
    .adc_it_clk_d_o(adc_it_clk_d_o),
    .adc_it_clk_o(adc_it_clk_o),
    .adc_it_dat_d_i(adc_it_dat_d_i),
    .adc_it_dat_i(adc_it_dat_i),
    .adc_vbus_clk_o(adc_vbus_clk_o),
    .adc_vbus_dat_i(adc_vbus_dat_i),
    .fmc_m1_en_o(fmc_m1_en_o),
    .fmc_m1_fault_i(fmc_m1_fault_i),
    .gpo_o(gpo_o),
    .position_i(position_i),
    .pwm_ah_o(pwm_ah_o),
    .pwm_al_o(pwm_al_o),
    .pwm_bh_o(pwm_bh_o),
    .pwm_bl_o(pwm_bl_o),
    .pwm_ch_o(pwm_ch_o),
    .pwm_cl_o(pwm_cl_o),
    .vauxn0(vauxn0),
    .vauxn8(vauxn8),
    .vauxp0(vauxp0),
    .vauxp8(vauxp8),
    .vn_in(vn_in),
    .vp_in(vp_in),
    .muxaddr_out(muxaddr_out),
    .i2s_bclk (i2s_bclk),
    .i2s_lrclk (i2s_lrclk),
    .i2s_mclk (i2s_mclk),
    .i2s_sdata_in (i2s_sdata_in),
    .i2s_sdata_out (i2s_sdata_out),
    .iic_fmc_scl_io (iic_scl),
    .iic_fmc_sda_io (iic_sda),
    .iic_mux_scl_I (iic_mux_scl_i_s),
    .iic_mux_scl_O (iic_mux_scl_o_s),
    .iic_mux_scl_T (iic_mux_scl_t_s),
    .iic_mux_sda_I (iic_mux_sda_i_s),
    .iic_mux_sda_O (iic_mux_sda_o_s),
    .iic_mux_sda_T (iic_mux_sda_t_s),
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif));

endmodule

// ***************************************************************************
// ***************************************************************************
