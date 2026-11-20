// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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
    input         MMUART_0_RXD_F2M,
    input         MMUART_1_RXD_F2M,
    input         REFCLK,
    input         REFCLK_N,
    input         REF_CLK_PAD_P,
    input         REF_CLK_PAD_N,
    input         SD_CD_EMMC_STRB,
    input         SD_WP_EMMC_RSTN,
    input         SGMII_RX0_N,
    input         SGMII_RX0_P,
    input         SGMII_RX1_N,
    input         SGMII_RX1_P,
    input         USB_CLK,
    input         USB_DIR,
    input         USB_NXT,
    input         RX_CLK_P,
    input         RX_CLK_N,
    input  [6:0]  RXD,
    input  [6:0]  RXD_N,
    output [5:0]  CA,
    output        CK,
    output        CKE,
    output        CK_N,
    output        CS,
    output [3:0]  DM,
    output        MAC_0_MDC,
    output        MMUART_0_TXD_M2F,
    output        MMUART_1_TXD_M2F,
    output        ODT,
    output        RESET_N,
    output        SDIO_SW_EN_N,
    output        SDIO_SW_SEL0,
    output        SDIO_SW_SEL1,
    output        SD_CLK_EMMC_CLK,
    output        SD_POW_EMMC_DATA4,
    output        SD_VOLT_CMD_DIR_EMMC_DATA7,
    output        SD_VOLT_DIR_0_EMMC_UNUSED,
    output        SD_VOLT_DIR_1_3_EMMC_UNUSED,
    output        SD_VOLT_EN_EMMC_DATA6,
    output        SD_VOLT_SEL_EMMC_DATA5,
    output        SGMII_TX0_N,
    output        SGMII_TX0_P,
    output        SGMII_TX1_N,
    output        SGMII_TX1_P,
    output        USB_STP,
    output        USB_ULPI_RESET_N,
    output        VSC_8662_CMODE3,
    output        VSC_8662_CMODE4,
    output        VSC_8662_CMODE5,
    output        VSC_8662_CMODE6,
    output        VSC_8662_CMODE7,
    output        VSC_8662_RESETN,
    output        VSC_8662_SRESET,
    output        TX_CLK,
    output        TX_CLK_N,
    output [6:0]  TXD,
    output [6:0]  TXD_N,
    output        enable,
    output        spi0_clk,
    output        spi0_csn,
    output        spi0_mosi,
    output        txnrx,
    inout         gpio_resetb,
    inout         gpio_sync,
    inout         gpio_en_agc,
    inout  [3:0]  gpio_ctl,
    inout  [7:0]  gpio_status,
    inout         i2c0_scl_io,
    inout         i2c0_sda_io,
    inout  [31:0] DQ,
    inout  [3:0]  DQS,
    inout  [3:0]  DQS_N,
    inout         MAC_0_MDIO,
    inout         SD_CMD_EMMC_CMD,
    inout         SD_DATA0_EMMC_DATA0,
    inout         SD_DATA1_EMMC_DATA1,
    inout         SD_DATA2_EMMC_DATA2,
    inout         SD_DATA3_EMMC_DATA3,
    inout         USB_DATA0,
    inout         USB_DATA1,
    inout         USB_DATA2,
    inout         USB_DATA3,
    inout         USB_DATA4,
    inout         USB_DATA5,
    inout         USB_DATA6,
    inout         USB_DATA7,
    input         spi0_miso
);

  wire [31:0] gpio2_i;
  wire [31:0] gpio2_o;
  wire [31:0] gpio2_oe;
  wire        i2c0_scl_i_s;
  wire        i2c0_sda_i_s;
  wire        i2c0_scl_oe_s;
  wire        i2c0_sda_oe_s;

  // GPIO2 bits follow the Microchip reference devicetree:
  // [7:0] ctrl_out, [11:8] ctrl_in, [13] en_agc, [14] sync, [15] resetb,
  // [16] up_enable, [17] up_txnrx
  assign gpio2_i[31:16] = gpio2_o[31:16];
  assign gpio2_i[12] = gpio2_o[12];

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_gpio (
    .dio_t ({~gpio2_oe[15:13], ~gpio2_oe[11:0]}),
    .dio_i ({gpio2_o[15:13], gpio2_o[11:0]}),
    .dio_o ({gpio2_i[15:13], gpio2_i[11:0]}),
    .dio_p ({gpio_resetb, gpio_sync, gpio_en_agc, gpio_ctl, gpio_status})
  );

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_iobuf_i2c0_scl (
    .dio_t (~i2c0_scl_oe_s),
    .dio_i (1'b0),
    .dio_o (i2c0_scl_i_s),
    .dio_p (i2c0_scl_io));

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_iobuf_i2c0_sda (
    .dio_t (~i2c0_sda_oe_s),
    .dio_i (1'b0),
    .dio_o (i2c0_sda_i_s),
    .dio_p (i2c0_sda_io));

  system_lb i_system_lb (
    .MMUART_0_RXD_F2M(MMUART_0_RXD_F2M),
    .MMUART_1_RXD_F2M(MMUART_1_RXD_F2M),
    .REFCLK(REFCLK),
    .REFCLK_N(REFCLK_N),
    .REF_CLK_PAD_P(REF_CLK_PAD_P),
    .REF_CLK_PAD_N(REF_CLK_PAD_N),
    .spi0_clk(spi0_clk),
    .spi0_csn(spi0_csn),
    .spi0_miso(spi0_miso),
    .spi0_mosi(spi0_mosi),
    .i2c0_scl_i(i2c0_scl_i_s),
    .i2c0_sda_i(i2c0_sda_i_s),
    .i2c0_scl_oe(i2c0_scl_oe_s),
    .i2c0_sda_oe(i2c0_sda_oe_s),
    .i2c1_scl_i(),
    .i2c1_sda_i(),
    .i2c1_scl_oe(),
    .i2c1_sda_oe(),
    .SD_CD_EMMC_STRB(SD_CD_EMMC_STRB),
    .SD_WP_EMMC_RSTN(SD_WP_EMMC_RSTN),
    .SGMII_RX0_N(SGMII_RX0_N),
    .SGMII_RX0_P(SGMII_RX0_P),
    .SGMII_RX1_N(SGMII_RX1_N),
    .SGMII_RX1_P(SGMII_RX1_P),
    .USB_CLK(USB_CLK),
    .USB_DIR(USB_DIR),
    .USB_NXT(USB_NXT),
    .RX_CLK_P(RX_CLK_P),
    .RX_CLK_N(RX_CLK_N),
    .RXD(RXD),
    .RXD_N(RXD_N),
    .up_enable(gpio2_o[16]),
    .up_txnrx(gpio2_o[17]),
    .tdd_sync_i(1'b0),
    .CA(CA),
    .CK(CK),
    .CKE(CKE),
    .CK_N(CK_N),
    .CS(CS),
    .DM(DM),
    .MAC_0_MDC(MAC_0_MDC),
    .MMUART_0_TXD_M2F(MMUART_0_TXD_M2F),
    .MMUART_1_TXD_M2F(MMUART_1_TXD_M2F),
    .ODT(ODT),
    .RESET_N(RESET_N),
    .SDIO_SW_EN_N(SDIO_SW_EN_N),
    .SDIO_SW_SEL0(SDIO_SW_SEL0),
    .SDIO_SW_SEL1(SDIO_SW_SEL1),
    .SD_CLK_EMMC_CLK(SD_CLK_EMMC_CLK),
    .SD_POW_EMMC_DATA4(SD_POW_EMMC_DATA4),
    .SD_VOLT_CMD_DIR_EMMC_DATA7(SD_VOLT_CMD_DIR_EMMC_DATA7),
    .SD_VOLT_DIR_0_EMMC_UNUSED(SD_VOLT_DIR_0_EMMC_UNUSED),
    .SD_VOLT_DIR_1_3_EMMC_UNUSED(SD_VOLT_DIR_1_3_EMMC_UNUSED),
    .SD_VOLT_EN_EMMC_DATA6(SD_VOLT_EN_EMMC_DATA6),
    .SD_VOLT_SEL_EMMC_DATA5(SD_VOLT_SEL_EMMC_DATA5),
    .SGMII_TX0_N(SGMII_TX0_N),
    .SGMII_TX0_P(SGMII_TX0_P),
    .SGMII_TX1_N(SGMII_TX1_N),
    .SGMII_TX1_P(SGMII_TX1_P),
    .USB_STP(USB_STP),
    .USB_ULPI_RESET_N(USB_ULPI_RESET_N),
    .VSC_8662_CMODE3(VSC_8662_CMODE3),
    .VSC_8662_CMODE4(VSC_8662_CMODE4),
    .VSC_8662_CMODE5(VSC_8662_CMODE5),
    .VSC_8662_CMODE6(VSC_8662_CMODE6),
    .VSC_8662_CMODE7(VSC_8662_CMODE7),
    .VSC_8662_RESETN(VSC_8662_RESETN),
    .VSC_8662_SRESET(VSC_8662_SRESET),
    .TX_CLK(TX_CLK),
    .TX_CLK_N(TX_CLK_N),
    .TXD(TXD),
    .TXD_N(TXD_N),
    .enable(enable),
    .spi1_clk(),
    .spi1_csn(),
    .spi1_mosi(),
    .spi1_miso(),
    .txnrx(txnrx),
    .tdd_sync_o(),
    .tdd_sync_t(),
    .DQ(DQ),
    .DQS(DQS),
    .DQS_N(DQS_N),
    .gpio2_i(gpio2_i),
    .gpio2_o(gpio2_o),
    .gpio2_oe(gpio2_oe),
    .MAC_0_MDIO(MAC_0_MDIO),
    .SD_CMD_EMMC_CMD(SD_CMD_EMMC_CMD),
    .SD_DATA0_EMMC_DATA0(SD_DATA0_EMMC_DATA0),
    .SD_DATA1_EMMC_DATA1(SD_DATA1_EMMC_DATA1),
    .SD_DATA2_EMMC_DATA2(SD_DATA2_EMMC_DATA2),
    .SD_DATA3_EMMC_DATA3(SD_DATA3_EMMC_DATA3),
    .USB_DATA0(USB_DATA0),
    .USB_DATA1(USB_DATA1),
    .USB_DATA2(USB_DATA2),
    .USB_DATA3(USB_DATA3),
    .USB_DATA4(USB_DATA4),
    .USB_DATA5(USB_DATA5),
    .USB_DATA6(USB_DATA6),
    .USB_DATA7(USB_DATA7)
  );

endmodule
