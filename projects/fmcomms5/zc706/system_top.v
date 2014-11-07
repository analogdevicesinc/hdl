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

  spdif,

  iic_scl,
  iic_sda,

  rx_clk_in_0_p,
  rx_clk_in_0_n,
  rx_frame_in_0_p,
  rx_frame_in_0_n,
  rx_data_in_0_p,
  rx_data_in_0_n,
  tx_clk_out_0_p,
  tx_clk_out_0_n,
  tx_frame_out_0_p,
  tx_frame_out_0_n,
  tx_data_out_0_p,
  tx_data_out_0_n,
  gpio_status_0,
  gpio_ctl_0,
  gpio_en_agc_0,
  mcs_sync,
  gpio_resetb_0,
  gpio_enable_0,
  gpio_txnrx_0,
  gpio_debug_1_0,
  gpio_debug_2_0,
  gpio_calsw_1_0,
  gpio_calsw_2_0,
  gpio_ad5355_rfen,
  gpio_ad5355_lock,

  rx_clk_in_1_p,
  rx_clk_in_1_n,
  rx_frame_in_1_p,
  rx_frame_in_1_n,
  rx_data_in_1_p,
  rx_data_in_1_n,
  tx_clk_out_1_p,
  tx_clk_out_1_n,
  tx_frame_out_1_p,
  tx_frame_out_1_n,
  tx_data_out_1_p,
  tx_data_out_1_n,
  gpio_status_1,
  gpio_ctl_1,
  gpio_en_agc_1,
  gpio_resetb_1,
  gpio_enable_1,
  gpio_txnrx_1,
  gpio_debug_3_1,
  gpio_debug_4_1,
  gpio_calsw_3_1,
  gpio_calsw_4_1,

  spi_ad9361_0,
  spi_ad9361_1,
  spi_ad5355,
  spi_clk,
  spi_mosi,
  spi_miso,

  ref_clk_p,
  ref_clk_n);

  inout   [ 14:0] DDR_addr;
  inout   [  2:0] DDR_ba;
  inout           DDR_cas_n;
  inout           DDR_ck_n;
  inout           DDR_ck_p;
  inout           DDR_cke;
  inout           DDR_cs_n;
  inout   [  3:0] DDR_dm;
  inout   [ 31:0] DDR_dq;
  inout   [  3:0] DDR_dqs_n;
  inout   [  3:0] DDR_dqs_p;
  inout           DDR_odt;
  inout           DDR_ras_n;
  inout           DDR_reset_n;
  inout           DDR_we_n;

  inout           FIXED_IO_ddr_vrn;
  inout           FIXED_IO_ddr_vrp;
  inout   [ 53:0] FIXED_IO_mio;
  inout           FIXED_IO_ps_clk;
  inout           FIXED_IO_ps_porb;
  inout           FIXED_IO_ps_srstb;

  inout   [ 14:0] gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [ 23:0] hdmi_data;

  output          spdif;

  inout           iic_scl;
  inout           iic_sda;

  input           rx_clk_in_0_p;
  input           rx_clk_in_0_n;
  input           rx_frame_in_0_p;
  input           rx_frame_in_0_n;
  input   [  5:0] rx_data_in_0_p;
  input   [  5:0] rx_data_in_0_n;
  output          tx_clk_out_0_p;
  output          tx_clk_out_0_n;
  output          tx_frame_out_0_p;
  output          tx_frame_out_0_n;
  output  [  5:0] tx_data_out_0_p;
  output  [  5:0] tx_data_out_0_n;
  inout   [  7:0] gpio_status_0;
  inout   [  3:0] gpio_ctl_0;
  inout           gpio_en_agc_0;
  output          mcs_sync;
  inout           gpio_resetb_0;
  inout           gpio_enable_0;
  inout           gpio_txnrx_0;
  inout           gpio_debug_1_0;
  inout           gpio_debug_2_0;
  inout           gpio_calsw_1_0;
  inout           gpio_calsw_2_0;
  inout           gpio_ad5355_rfen;
  inout           gpio_ad5355_lock;

  input           rx_clk_in_1_p;
  input           rx_clk_in_1_n;
  input           rx_frame_in_1_p;
  input           rx_frame_in_1_n;
  input   [  5:0] rx_data_in_1_p;
  input   [  5:0] rx_data_in_1_n;
  output          tx_clk_out_1_p;
  output          tx_clk_out_1_n;
  output          tx_frame_out_1_p;
  output          tx_frame_out_1_n;
  output  [  5:0] tx_data_out_1_p;
  output  [  5:0] tx_data_out_1_n;
  inout   [  7:0] gpio_status_1;
  inout   [  3:0] gpio_ctl_1;
  inout           gpio_en_agc_1;
  inout           gpio_resetb_1;
  inout           gpio_enable_1;
  inout           gpio_txnrx_1;
  inout           gpio_debug_3_1;
  inout           gpio_debug_4_1;
  inout           gpio_calsw_3_1;
  inout           gpio_calsw_4_1;

  output          spi_ad9361_0;
  output          spi_ad9361_1;
  output          spi_ad5355;
  output          spi_clk;
  output          spi_mosi;
  input           spi_miso;

  input           ref_clk_p;
  input           ref_clk_n;

  // internal registers

  reg     [  2:0] mcs_sync_m = 'd0;
  reg             mcs_sync = 'd0;

  // internal signals

  wire            sys_100m_resetn;
  wire            sys_100m_clk;
  wire            ref_clk_s;
  wire            ref_clk;
  wire    [ 63:0] gpio_i;
  wire    [ 63:0] gpio_o;
  wire    [ 63:0] gpio_t;
  wire            gpio_open_45_45;
  wire            gpio_open_44_44;
  wire            gpio_open_15_15;
  wire    [15:0]  ps_intrs;

  // multi-chip synchronization

  always @(posedge ref_clk or negedge sys_100m_resetn) begin
    if (sys_100m_resetn == 1'b0) begin
      mcs_sync_m <= 3'd0;
      mcs_sync <= 1'd0;
    end else begin
      mcs_sync_m <= {mcs_sync_m[1:0], gpio_o[45]};
      mcs_sync <= mcs_sync_m[2] & ~mcs_sync_m[1];
    end
  end

  // instantiations

  IBUFGDS i_ref_clk_ibuf (
    .I (ref_clk_p),
    .IB (ref_clk_n),
    .O (ref_clk_s));

  BUFR #(.BUFR_DIVIDE("BYPASS")) i_ref_clk_rbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (ref_clk_s),
    .O (ref_clk));

  ad_iobuf #(.DATA_WIDTH(60)) i_iobuf (
    .dt (gpio_t[59:0]),
    .di (gpio_o[59:0]),
    .do (gpio_i[59:0]),
    .dio ({ gpio_resetb_1,    // 59
            gpio_ad5355_lock, // 58
            gpio_ad5355_rfen, // 57
            gpio_calsw_4_1,   // 56
            gpio_calsw_3_1,   // 55
            gpio_calsw_2_0,   // 54
            gpio_calsw_1_0,   // 53
            gpio_txnrx_1,     // 52
            gpio_enable_1,    // 51
            gpio_en_agc_1,    // 50
            gpio_txnrx_0,     // 49
            gpio_enable_0,    // 48
            gpio_en_agc_0,    // 47
            gpio_resetb_0,    // 46
            gpio_open_45_45,  // 45
            gpio_open_44_44,  // 44
            gpio_debug_4_1,   // 43
            gpio_debug_3_1,   // 42
            gpio_debug_2_0,   // 41
            gpio_debug_1_0,   // 40
            gpio_ctl_1,       // 36
            gpio_ctl_0,       // 32
            gpio_status_1,    // 24
            gpio_status_0,    // 16
            gpio_open_15_15,  // 15
            gpio_bd}));       //  0

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
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .ps_intr_0 (ps_intrs[0]),
    .ps_intr_1 (ps_intrs[1]),
    .ps_intr_10 (ps_intrs[10]),
    .ps_intr_11 (ps_intrs[11]),
    .ps_intr_12 (ps_intrs[12]),
    .ps_intr_13 (ps_intrs[13]),
    .ps_intr_2 (ps_intrs[2]),
    .ps_intr_3 (ps_intrs[3]),
    .ps_intr_4 (ps_intrs[4]),
    .ps_intr_5 (ps_intrs[5]),
    .ps_intr_6 (ps_intrs[6]),
    .ps_intr_7 (ps_intrs[7]),
    .ps_intr_8 (ps_intrs[8]),
    .ps_intr_9 (ps_intrs[9]),
    .ad9361_dac_dma_irq (ps_intrs[12]),
    .ad9361_adc_dma_irq (ps_intrs[13]),
    .fmcomms5_gpio_irq(),
    .fmcomms5_spi_irq(),
    .rx_clk_in_0_n (rx_clk_in_0_n),
    .rx_clk_in_0_p (rx_clk_in_0_p),
    .rx_clk_in_1_n (rx_clk_in_1_n),
    .rx_clk_in_1_p (rx_clk_in_1_p),
    .rx_data_in_0_n (rx_data_in_0_n),
    .rx_data_in_0_p (rx_data_in_0_p),
    .rx_data_in_1_n (rx_data_in_1_n),
    .rx_data_in_1_p (rx_data_in_1_p),
    .rx_frame_in_0_n (rx_frame_in_0_n),
    .rx_frame_in_0_p (rx_frame_in_0_p),
    .rx_frame_in_1_n (rx_frame_in_1_n),
    .rx_frame_in_1_p (rx_frame_in_1_p),
    .spdif (spdif),
    .spi_csn_0_i (1'b1),
    .spi_csn_0_o (spi_ad9361_0),
    .spi_csn_1_o (spi_ad9361_1),
    .spi_csn_2_o (spi_ad5355),
    .spi_miso_i (spi_miso),
    .spi_mosi_i (1'b0),
    .spi_mosi_o (spi_mosi),
    .spi_sclk_i (1'b0),
    .spi_sclk_o (spi_clk),
    .sys_100m_clk (sys_100m_clk),
    .sys_100m_resetn (sys_100m_resetn),
    .tx_clk_out_0_n (tx_clk_out_0_n),
    .tx_clk_out_0_p (tx_clk_out_0_p),
    .tx_clk_out_1_n (tx_clk_out_1_n),
    .tx_clk_out_1_p (tx_clk_out_1_p),
    .tx_data_out_0_n (tx_data_out_0_n),
    .tx_data_out_0_p (tx_data_out_0_p),
    .tx_data_out_1_n (tx_data_out_1_n),
    .tx_data_out_1_p (tx_data_out_1_p),
    .tx_frame_out_0_n (tx_frame_out_0_n),
    .tx_frame_out_0_p (tx_frame_out_0_p),
    .tx_frame_out_1_n (tx_frame_out_1_n),
    .tx_frame_out_1_p (tx_frame_out_1_p));

endmodule

// ***************************************************************************
// ***************************************************************************
