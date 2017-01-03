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

`timescale 1ns/100ps

module system_top (

  input             sys_rst,
  input             sys_clk_p,
  input             sys_clk_n,

  input             uart_sin,
  output            uart_sout,

  output  [ 13:0]   ddr3_addr,
  output  [  2:0]   ddr3_ba,
  output            ddr3_cas_n,
  output  [  0:0]   ddr3_ck_n,
  output  [  0:0]   ddr3_ck_p,
  output  [  0:0]   ddr3_cke,
  output  [  0:0]   ddr3_cs_n,
  output  [  7:0]   ddr3_dm,
  inout   [ 63:0]   ddr3_dq,
  inout   [  7:0]   ddr3_dqs_n,
  inout   [  7:0]   ddr3_dqs_p,
  output  [  0:0]   ddr3_odt,
  output            ddr3_ras_n,
  output            ddr3_reset_n,
  output            ddr3_we_n,

  input             sgmii_rxp,
  input             sgmii_rxn,
  output            sgmii_txp,
  output            sgmii_txn,

  output            phy_rstn,
  input             mgt_clk_p,
  input             mgt_clk_n,
  output            mdio_mdc,
  inout             mdio_mdio,

  output            fan_pwm,

  output  [26:1]    linear_flash_addr,
  output            linear_flash_adv_ldn,
  output            linear_flash_ce_n,
  output            linear_flash_oen,
  output            linear_flash_wen,
  inout   [15:0]    linear_flash_dq_io,

  inout   [  6:0]   gpio_lcd,
  inout   [ 20:0]   gpio_bd,

  output            iic_rstn,
  inout             iic_scl,
  inout             iic_sda,

  input             rx_ref_clk_0_p,
  input             rx_ref_clk_0_n,
  input   [  7:0]   rx_data_0_p,
  input   [  7:0]   rx_data_0_n,
  input             rx_ref_clk_1_p,
  input             rx_ref_clk_1_n,
  input   [  7:0]   rx_data_1_p,
  input   [  7:0]   rx_data_1_n,
  output            rx_sysref_p,
  output            rx_sysref_n,
  output            rx_sync_0_p,
  output            rx_sync_0_n,
  output            rx_sync_1_p,
  output            rx_sync_1_n,

  output            spi_csn_0,
  output            spi_csn_1,
  output            spi_clk,
  inout             spi_sdio,
  output            spi_dirn,
  output            dac_clk,
  output            dac_data,
  output            dac_sync_0,
  output            dac_sync_1,

  output            psync_0,
  output            psync_1,
  input             trig_p,
  input             trig_n,
  output            vdither_p,
  output            vdither_n,
  inout             pwr_good,
  inout             fd_1,
  inout             irq_1,
  inout             fd_0,
  inout             irq_0,
  inout             pwdn_1,
  inout             rst_1,
  output            drst_1,
  output            arst_1,
  inout             pwdn_0,
  inout             rst_0,
  output            drst_0,
  output            arst_0);

  // internal registers

  reg     [  4:0]   gpio_o_60_56_d = 'd0;
  reg               gpio_dld = 'd0;

  // internal signals

  wire              delay_clk;
  wire              delay_rst;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire    [ 63:0]   gpio_t;
  wire    [  7:0]   spi_csn;
  wire              spi_clk;
  wire              spi_mosi;
  wire              spi_miso;
  wire              rx_clk;
  wire              rx_ref_clk_0;
  wire              rx_ref_clk_1;
  wire              rx_sync_0;
  wire              rx_sync_1;
  wire              up_rstn;
  wire              up_clk;
  wire              rx_sysref_int;

  // spi

  assign iic_rstn = 1'b1;
  assign fan_pwm = 1'b1;
  assign dac_clk = spi_clk;
  assign dac_data = spi_mosi;
  assign dac_sync_1 = spi_csn[3];
  assign dac_sync_0 = spi_csn[2];
  assign spi_csn_1 = spi_csn[1];
  assign spi_csn_0 = spi_csn[0];
  assign drst_1 = 1'b0;
  assign arst_1 = 1'b0;
  assign drst_0 = 1'b0;
  assign arst_0 = 1'b0;

  // sysref iob

  always @(posedge up_clk or negedge up_rstn) begin
    if (up_rstn == 1'b0) begin
      gpio_o_60_56_d <= 5'd0;
      gpio_dld <= 1'b0;
    end else begin
      gpio_o_60_56_d <= gpio_o[60:56];
      if (gpio_o[60:56] == gpio_o_60_56_d) begin
        gpio_dld <= 1'b0;
      end else begin
        gpio_dld <= 1'b1;
      end
    end
  end

  // sysref internal

  ad_sysref_gen i_sysref (
    .core_clk (rx_clk),
    .sysref_en (gpio_o[32]),
    .sysref_out (rx_sysref_int));

  // instantiations

  ad_lvds_out #(
    .DEVICE_TYPE (0),
    .SINGLE_ENDED (0),
    .IODELAY_ENABLE (1),
    .IODELAY_CTRL (1),
    .IODELAY_GROUP ("FMCADC5_SYSREF_IODELAY_GROUP"))
  i_rx_sysref (
    .tx_clk (rx_clk),
    .tx_data_p (rx_sysref_int),
    .tx_data_n (rx_sysref_int),
    .tx_data_out_p (rx_sysref_p),
    .tx_data_out_n (rx_sysref_n),
    .up_clk (up_clk),
    .up_dld (gpio_dld),
    .up_dwdata (gpio_o[60:56]),
    .up_drdata (gpio_i[60:56]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (gpio_i[61]));

  IBUFDS_GTE2 i_ibufds_rx_ref_clk_0 (
    .CEB (1'd0),
    .I (rx_ref_clk_0_p),
    .IB (rx_ref_clk_0_n),
    .O (rx_ref_clk_0),
    .ODIV2 ());

  IBUFDS_GTE2 i_ibufds_rx_ref_clk_1 (
    .CEB (1'd0),
    .I (rx_ref_clk_1_p),
    .IB (rx_ref_clk_1_n),
    .O (rx_ref_clk_1),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sync_0 (
    .I (rx_sync_0),
    .O (rx_sync_0_p),
    .OB (rx_sync_0_n));

  OBUFDS i_obufds_rx_sync_1 (
    .I (rx_sync_1),
    .O (rx_sync_1_p),
    .OB (rx_sync_1_n));

  IBUFDS i_ibufds_trig (
    .I (trig_p),
    .IB (trig_n),
    .O (gpio_i[46]));

  OBUFDS i_obufds_vdither (
    .I (gpio_o[45]),
    .O (vdither_p),
    .OB (vdither_n));

  fmcadc5_psync i_fmcadc5_psync (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .psync_0 (psync_0),
    .psync_1 (psync_1));

  fmcadc5_spi i_fmcadc5_spi (
    .spi_csn_0 (spi_csn[0]),
    .spi_csn_1 (spi_csn[1]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio),
    .spi_dirn (spi_dirn));

  ad_iobuf #(.DATA_WIDTH(9)) i_iobuf (
    .dio_t ({gpio_t[44:40], gpio_t[39:38], gpio_t[35:34]}),
    .dio_i ({gpio_o[44:40], gpio_o[39:38], gpio_o[35:34]}),
    .dio_o ({gpio_i[44:40], gpio_i[39:38], gpio_i[35:34]}),
    .dio_p ({ pwr_good,       // 44
              fd_1,           // 43
              irq_1,          // 42
              fd_0,           // 41
              irq_0,          // 40
              pwdn_1,         // 39
              rst_1,          // 38
              pwdn_0,         // 35
              rst_0}));       // 34

  ad_iobuf #(.DATA_WIDTH(21)) i_iobuf_bd (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_odt (ddr3_odt),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_we_n (ddr3_we_n),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio_lcd_tri_io (gpio_lcd),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .linear_flash_addr (linear_flash_addr),
    .linear_flash_adv_ldn (linear_flash_adv_ldn),
    .linear_flash_ce_n (linear_flash_ce_n),
    .linear_flash_dq_io(linear_flash_dq_io),
    .linear_flash_oen (linear_flash_oen),
    .linear_flash_wen (linear_flash_wen),
    .mb_intr_06 (1'b0),
    .mb_intr_07 (1'b0),
    .mb_intr_08 (1'b0),
    .mb_intr_13 (1'b0),
    .mb_intr_14 (1'b0),
    .mb_intr_15 (1'b0),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .mgt_clk_clk_n (mgt_clk_n),
    .mgt_clk_clk_p (mgt_clk_p),
    .phy_rstn (phy_rstn),
    .phy_sd (1'b1),
    .rx_clk (rx_clk),
    .rx_data_0_n (rx_data_0_n[0]),
    .rx_data_0_p (rx_data_0_p[0]),
    .rx_data_1_0_n (rx_data_1_n[0]),
    .rx_data_1_0_p (rx_data_1_p[0]),
    .rx_data_1_1_n (rx_data_1_n[1]),
    .rx_data_1_1_p (rx_data_1_p[1]),
    .rx_data_1_2_n (rx_data_1_n[2]),
    .rx_data_1_2_p (rx_data_1_p[2]),
    .rx_data_1_3_n (rx_data_1_n[3]),
    .rx_data_1_3_p (rx_data_1_p[3]),
    .rx_data_1_4_n (rx_data_1_n[4]),
    .rx_data_1_4_p (rx_data_1_p[4]),
    .rx_data_1_5_n (rx_data_1_n[5]),
    .rx_data_1_5_p (rx_data_1_p[5]),
    .rx_data_1_6_n (rx_data_1_n[6]),
    .rx_data_1_6_p (rx_data_1_p[6]),
    .rx_data_1_7_n (rx_data_1_n[7]),
    .rx_data_1_7_p (rx_data_1_p[7]),
    .rx_data_1_n (rx_data_0_n[1]),
    .rx_data_1_p (rx_data_0_p[1]),
    .rx_data_2_n (rx_data_0_n[2]),
    .rx_data_2_p (rx_data_0_p[2]),
    .rx_data_3_n (rx_data_0_n[3]),
    .rx_data_3_p (rx_data_0_p[3]),
    .rx_data_4_n (rx_data_0_n[4]),
    .rx_data_4_p (rx_data_0_p[4]),
    .rx_data_5_n (rx_data_0_n[5]),
    .rx_data_5_p (rx_data_0_p[5]),
    .rx_data_6_n (rx_data_0_n[6]),
    .rx_data_6_p (rx_data_0_p[6]),
    .rx_data_7_n (rx_data_0_n[7]),
    .rx_data_7_p (rx_data_0_p[7]),
    .rx_ref_clk_0 (rx_ref_clk_0),
    .rx_ref_clk_1 (rx_ref_clk_1),
    .rx_sync_0 (rx_sync_0),
    .rx_sync_1_0 (rx_sync_1),
    .rx_sysref_0 (rx_sysref_int),
    .rx_sysref_1_0 (rx_sysref_int),
    .sgmii_rxn (sgmii_rxn),
    .sgmii_rxp (sgmii_rxp),
    .sgmii_txn (sgmii_txn),
    .sgmii_txp (sgmii_txp),
    .spi_clk_i (1'b0),
    .spi_clk_o (spi_clk),
    .spi_csn_i (8'hff),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (1'b0),
    .spi_sdo_o (spi_mosi),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .up_clk (up_clk),
    .up_rstn (up_rstn));

endmodule

// ***************************************************************************
// ***************************************************************************
