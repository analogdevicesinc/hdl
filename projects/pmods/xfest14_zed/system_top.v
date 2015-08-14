// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
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

  i2s_mclk,
  i2s_bclk,
  i2s_lrclk,
  i2s_sdata_out,
  i2s_sdata_in,

  spdif,

  pmod_ja1,
  pmod_ja2,
  pmod_ja3,
  pmod_ja4,
  pmod_ja7,
  pmod_ja8,
  pmod_ja9,
  pmod_ja10,

  pmod_jb1,
  pmod_jb2,
  pmod_jb3,
  pmod_jb4,
  pmod_jb7,
  pmod_jb8,
  pmod_jb9,
  pmod_jb10,

  pmod_jc1,
  pmod_jc2,
  pmod_jc3,
  pmod_jc4,
  pmod_jc7,
  pmod_jc8,
  pmod_jc9,
  pmod_jc10,

  pmod_jd1,
  pmod_jd2,
  pmod_jd3,
  pmod_jd4,
  pmod_jd7,
  pmod_jd8,
  pmod_jd9,
  pmod_jd10,

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

  output          spdif;

  output          i2s_mclk;
  output          i2s_bclk;
  output          i2s_lrclk;
  output          i2s_sdata_out;
  input           i2s_sdata_in;

  output          pmod_ja1;
  output          pmod_ja2;
  input           pmod_ja3;
  output          pmod_ja4;
  inout           pmod_ja7;
  inout           pmod_ja8;
  inout           pmod_ja9;
  inout           pmod_ja10;

  output          pmod_jb1;
  output          pmod_jb2;
  input           pmod_jb3;
  output          pmod_jb4;
  inout           pmod_jb7;
  inout           pmod_jb8;
  inout           pmod_jb9;
  inout           pmod_jb10;

  output          pmod_jc1;
  output          pmod_jc2;
  input           pmod_jc3;
  output          pmod_jc4;
  input           pmod_jc7;
  output          pmod_jc8;
  input           pmod_jc9;
  output          pmod_jc10;

  output          pmod_jd1;
  output          pmod_jd2;
  input           pmod_jd3;
  output          pmod_jd4;
  inout           pmod_jd7;
  inout           pmod_jd8;
  inout           pmod_jd9;
  inout           pmod_jd10;

  inout           iic_scl;
  inout           iic_sda;
  inout   [ 1:0]  iic_mux_scl;
  inout   [ 1:0]  iic_mux_sda;

  input           otg_vbusoc;

  // internal signals

  wire    [48:0]  gpio_i;
  wire    [48:0]  gpio_o;
  wire    [48:0]  gpio_t;
  wire            ref_clk;
  wire            oddr_ref_clk;

  wire    [ 1:0]  iic_mux_scl_i_s;
  wire    [ 1:0]  iic_mux_scl_o_s;
  wire            iic_mux_scl_t_s;
  wire    [ 1:0]  iic_mux_sda_i_s;
  wire    [ 1:0]  iic_mux_sda_o_s;
  wire            iic_mux_sda_t_s;

  // instantiations

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_oddr_ref_clk (
    .S (1'b0),
    .CE (1'b1),
    .R (1'b0),
    .C (ref_clk),
    .D1 (1'b1),
    .D2 (1'b0),
    .Q (oddr_ref_clk));

  OBUFDS i_obufds_ref_clk (
    .I (oddr_ref_clk),
    .O (ref_clk_out_p),
    .OB (ref_clk_out_n));

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

// For debugging the ADIS16k CS BUSY conflict
// OBUF i_pmod_jb7 (.I(pmod_ja1 == 1'b0 && gpio_i[34] == 1'b0), .O(pmod_jb7));

  IOBUF i_iic_mux_scl_0 (.I(iic_mux_scl_o_s[0]), .O(iic_mux_scl_i_s[0]), .T(iic_mux_scl_t_s), .IO(iic_mux_scl[0]));
  IOBUF i_iic_mux_scl_1 (.I(iic_mux_scl_o_s[1]), .O(iic_mux_scl_i_s[1]), .T(iic_mux_scl_t_s), .IO(iic_mux_scl[1]));
  IOBUF i_iic_mux_sda_0 (.I(iic_mux_sda_o_s[0]), .O(iic_mux_sda_i_s[0]), .T(iic_mux_sda_t_s), .IO(iic_mux_sda[0]));
  IOBUF i_iic_mux_sda_1 (.I(iic_mux_sda_o_s[1]), .O(iic_mux_sda_i_s[1]), .T(iic_mux_sda_t_s), .IO(iic_mux_sda[1]));

  IOBUF i_pmod_ja7  (.IO(pmod_ja7), .I(gpio_o[32]), .O(gpio_i[32]), .T(gpio_t[32]));
  IOBUF i_pmod_ja8  (.IO(pmod_ja8), .I(gpio_o[33]), .O(gpio_i[33]), .T(gpio_t[33]));
  IOBUF i_pmod_ja9  (.IO(pmod_ja9), .I(gpio_o[34]), .O(gpio_i[34]), .T(gpio_t[34]));
  IOBUF i_pmod_ja10 (.IO(pmod_ja10), .I(gpio_o[35]), .O(gpio_i[35]), .T(gpio_t[35]));

  IOBUF i_pmod_jb7  (.IO(pmod_jb7), .I(gpio_o[36]), .O(gpio_i[36]), .T(gpio_t[36]));
  IOBUF i_pmod_jb8  (.IO(pmod_jb8), .I(gpio_o[37]), .O(gpio_i[37]), .T(gpio_t[37]));
  IOBUF i_pmod_jb9  (.IO(pmod_jb9), .I(gpio_o[38]), .O(gpio_i[38]), .T(gpio_t[38]));
  IOBUF i_pmod_jb10 (.IO(pmod_jb10), .I(gpio_o[39]), .O(gpio_i[39]), .T(gpio_t[39]));

/*
  IOBUF i_pmod_jc7  (.IO(pmod_jc7), .I(gpio_o[40]), .O(gpio_i[40]), .T(gpio_t[40]));
  IOBUF i_pmod_jc8  (.IO(pmod_jc8), .I(gpio_o[41]), .O(gpio_i[41]), .T(gpio_t[41]));
  IOBUF i_pmod_jc9  (.IO(pmod_jc9), .I(gpio_o[42]), .O(gpio_i[42]), .T(gpio_t[42]));
  IOBUF i_pmod_jc10 (.IO(pmod_jc10), .I(gpio_o[43]), .O(gpio_i[43]), .T(gpio_t[43]));
*/

  IOBUF i_pmod_jd7  (.IO(pmod_jd7), .I(gpio_o[44]), .O(gpio_i[44]), .T(gpio_t[44]));
  IOBUF i_pmod_jd8  (.IO(pmod_jd8), .I(gpio_o[45]), .O(gpio_i[45]), .T(gpio_t[45]));
  IOBUF i_pmod_jd9  (.IO(pmod_jd9), .I(gpio_o[46]), .O(gpio_i[46]), .T(gpio_t[46]));
  IOBUF i_pmod_jd10 (.IO(pmod_jd10), .I(gpio_o[47]), .O(gpio_i[47]), .T(gpio_t[47]));

  // On the AD7173 MISO also acts as a interrupt signal, so we need to route it
  // to both the GPIO and SPI controller
  assign gpio_i[48] = pmod_jc3;

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
    .pmod_ja1 (pmod_ja1),
    .pmod_ja2 (pmod_ja2),
    .pmod_ja3 (pmod_ja3),
    .pmod_ja4 (pmod_ja4),
    .pmod_jb1 (pmod_jb1),
    .pmod_jb2 (pmod_jb2),
    .pmod_jb3 (pmod_jb3),
    .pmod_jb4 (pmod_jb4),
    .pmod_jc1 (pmod_jc1),
    .pmod_jc2 (pmod_jc2),
    .pmod_jc3 (pmod_jc3),
    .pmod_jc4 (pmod_jc4),
	.pmod_jc7 (pmod_jc7),
	.pmod_jc8 (pmod_jc8),
	.pmod_jc9 (pmod_jc9),
	.pmod_jc10 (pmod_jc10),
    .pmod_jd1 (pmod_jd1),
    .pmod_jd2 (pmod_jd2),
    .pmod_jd3 (pmod_jd3),
    .pmod_jd4 (pmod_jd4),
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif));

endmodule

// ***************************************************************************
// ***************************************************************************
