// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  input                   uart_sin,
  output                  uart_sout,

  output                  ddr4_act_n,
  output      [16:0]      ddr4_addr,
  output      [ 1:0]      ddr4_ba,
  output      [ 0:0]      ddr4_bg,
  output                  ddr4_ck_p,
  output                  ddr4_ck_n,
  output      [ 0:0]      ddr4_cke,
  output      [ 0:0]      ddr4_cs_n,
  inout       [ 7:0]      ddr4_dm_n,
  inout       [63:0]      ddr4_dq,
  inout       [ 7:0]      ddr4_dqs_p,
  inout       [ 7:0]      ddr4_dqs_n,
  output      [ 0:0]      ddr4_odt,
  output                  ddr4_reset_n,

  output                  mdio_mdc,
  inout                   mdio_mdio,
  input                   phy_clk_p,
  input                   phy_clk_n,
  output                  phy_rst_n,
  input                   phy_rx_p,
  input                   phy_rx_n,
  output                  phy_tx_p,
  output                  phy_tx_n,

  inout       [16:0]      gpio_bd,

  output                  iic_rstn,
  inout                   iic_scl,
  inout                   iic_sda,

  // ADI CMAC design

  // GT REF CLK
  input          qsfp_mgt_refclk_p,
  input          qsfp_mgt_refclk_n,

  output [3:0]   qsfp_tx_p,
  output [3:0]   qsfp_tx_n,
  input  [3:0]   qsfp_rx_p,
  input  [3:0]   qsfp_rx_n,

  // Corundum design

  /*
  * QSPI
  */
  inout  wire [3:0]   qspi1_dq,
  output wire         qspi1_cs,

  /*
  * Ethernet: QSFP28
  */
  output wire         qsfp_modsell,
  output wire         qsfp_resetl,
  input  wire         qsfp_modprsl,
  input  wire         qsfp_intl,
  output wire         qsfp_lpmode
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  
  wire            spi_clk;
  wire    [ 7:0]  spi_csn;
  wire            spi_sdo;
  wire            spi_sdio;

  assign iic_rstn = 1'b1;

  ad_iobuf #(
    .DATA_WIDTH(17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:40] = gpio_o[63:40];
  assign gpio_i[31:17] = gpio_o[31:17];

  // QSFP
  wire [0:0] qsfp_gtpowergood;
  wire [0:0] qsfp_mgt_refclk;
  wire [0:0] qsfp_mgt_refclk_bufg;
  wire [0:0] qsfp_rst;
  
  wire ptp_rst;

  assign ptp_rst = qsfp_rst[0];

  IBUFDS_GTE4 ibufds_gte4_qsfp_mgt_refclk_0_inst (
      .I     (qsfp_mgt_refclk_p),
      .IB    (qsfp_mgt_refclk_n),
      .CEB   (1'b0),
      .O     (qsfp_mgt_refclk),
      .ODIV2 (qsfp_mgt_refclk_int)
  );

  BUFG_GT bufg_gt_qsfp_mgt_refclk_0_inst (
      .CE      (qsfp_gtpowergood),
      .CEMASK  (1'b1),
      .CLR     (1'b0),
      .CLRMASK (1'b1),
      .DIV     (3'd0),
      .I       (qsfp_mgt_refclk_int),
      .O       (qsfp_mgt_refclk_bufg)
  );

  // Flash
  wire clk_125mhz;
  wire clk_250mhz;
  
  wire qspi_clk_int;
  wire [3:0] qspi0_dq_int;
  wire [3:0] qspi0_dq_i_int;
  wire [3:0] qspi0_dq_o_int;
  wire [3:0] qspi0_dq_oe_int;
  wire qspi0_cs_int;
  wire [3:0] qspi1_dq_i_int;
  wire [3:0] qspi1_dq_o_int;
  wire [3:0] qspi1_dq_oe_int;
  wire qspi1_cs_int;
  
  reg qspi_clk_reg;
  reg [3:0] qspi0_dq_o_reg;
  reg [3:0] qspi0_dq_oe_reg;
  reg qspi0_cs_reg;
  reg [3:0] qspi1_dq_o_reg;
  reg [3:0] qspi1_dq_oe_reg;
  reg qspi1_cs_reg;
  
  always @(posedge clk_250mhz) begin
      qspi_clk_reg <= qspi_clk_int;
      qspi0_dq_o_reg <= qspi0_dq_o_int;
      qspi0_dq_oe_reg <= qspi0_dq_oe_int;
      qspi0_cs_reg <= qspi0_cs_int;
      qspi1_dq_o_reg <= qspi1_dq_o_int;
      qspi1_dq_oe_reg <= qspi1_dq_oe_int;
      qspi1_cs_reg <= qspi1_cs_int;
  end
  
  assign qspi1_dq[0] = qspi1_dq_oe_reg[0] ? qspi1_dq_o_reg[0] : 1'bz;
  assign qspi1_dq[1] = qspi1_dq_oe_reg[1] ? qspi1_dq_o_reg[1] : 1'bz;
  assign qspi1_dq[2] = qspi1_dq_oe_reg[2] ? qspi1_dq_o_reg[2] : 1'bz;
  assign qspi1_dq[3] = qspi1_dq_oe_reg[3] ? qspi1_dq_o_reg[3] : 1'bz;
  assign qspi1_cs = qspi1_cs_reg;
  
  sync_signal #(
      .WIDTH(8),
      .N(2)
  )
  flash_sync_signal_inst (
      .clk(clk_250mhz),
      .in({qspi1_dq, qspi0_dq_int}),
      .out({qspi1_dq_i_int, qspi0_dq_i_int})
  );
  
  STARTUPE3
  startupe3_inst (
      .CFGCLK(),
      .CFGMCLK(),
      .DI(qspi0_dq_int),
      .DO(qspi0_dq_o_reg),
      .DTS(~qspi0_dq_oe_reg),
      .EOS(),
      .FCSBO(qspi0_cs_reg),
      .FCSBTS(1'b0),
      .GSR(1'b0),
      .GTS(1'b0),
      .KEYCLEARB(1'b1),
      .PACK(1'b0),
      .PREQ(),
      .USRCCLKO(qspi_clk_reg),
      .USRCCLKTS(1'b0),
      .USRDONEO(1'b0),
      .USRDONETS(1'b1)
  );
  
  // FPGA boot
  wire fpga_boot;
  
  reg fpga_boot_sync_reg_0 = 1'b0;
  reg fpga_boot_sync_reg_1 = 1'b0;
  reg fpga_boot_sync_reg_2 = 1'b0;
  
  wire icap_avail;
  reg [2:0] icap_state = 0;
  reg icap_csib_reg = 1'b1;
  reg icap_rdwrb_reg = 1'b0;
  reg [31:0] icap_di_reg = 32'hffffffff;
  
  wire [31:0] icap_di_rev;
  
  assign icap_di_rev[ 7] = icap_di_reg[ 0];
  assign icap_di_rev[ 6] = icap_di_reg[ 1];
  assign icap_di_rev[ 5] = icap_di_reg[ 2];
  assign icap_di_rev[ 4] = icap_di_reg[ 3];
  assign icap_di_rev[ 3] = icap_di_reg[ 4];
  assign icap_di_rev[ 2] = icap_di_reg[ 5];
  assign icap_di_rev[ 1] = icap_di_reg[ 6];
  assign icap_di_rev[ 0] = icap_di_reg[ 7];
  
  assign icap_di_rev[15] = icap_di_reg[ 8];
  assign icap_di_rev[14] = icap_di_reg[ 9];
  assign icap_di_rev[13] = icap_di_reg[10];
  assign icap_di_rev[12] = icap_di_reg[11];
  assign icap_di_rev[11] = icap_di_reg[12];
  assign icap_di_rev[10] = icap_di_reg[13];
  assign icap_di_rev[ 9] = icap_di_reg[14];
  assign icap_di_rev[ 8] = icap_di_reg[15];
  
  assign icap_di_rev[23] = icap_di_reg[16];
  assign icap_di_rev[22] = icap_di_reg[17];
  assign icap_di_rev[21] = icap_di_reg[18];
  assign icap_di_rev[20] = icap_di_reg[19];
  assign icap_di_rev[19] = icap_di_reg[20];
  assign icap_di_rev[18] = icap_di_reg[21];
  assign icap_di_rev[17] = icap_di_reg[22];
  assign icap_di_rev[16] = icap_di_reg[23];
  
  assign icap_di_rev[31] = icap_di_reg[24];
  assign icap_di_rev[30] = icap_di_reg[25];
  assign icap_di_rev[29] = icap_di_reg[26];
  assign icap_di_rev[28] = icap_di_reg[27];
  assign icap_di_rev[27] = icap_di_reg[28];
  assign icap_di_rev[26] = icap_di_reg[29];
  assign icap_di_rev[25] = icap_di_reg[30];
  assign icap_di_rev[24] = icap_di_reg[31];
  
  always @(posedge clk_125mhz) begin
      case (icap_state)
          0: begin
              icap_state <= 0;
              icap_csib_reg <= 1'b1;
              icap_rdwrb_reg <= 1'b0;
              icap_di_reg <= 32'hffffffff; // dummy word
  
              if (fpga_boot_sync_reg_2 && icap_avail) begin
                  icap_state <= 1;
                  icap_csib_reg <= 1'b0;
                  icap_rdwrb_reg <= 1'b0;
                  icap_di_reg <= 32'hffffffff; // dummy word
              end
          end
          1: begin
              icap_state <= 2;
              icap_csib_reg <= 1'b0;
              icap_rdwrb_reg <= 1'b0;
              icap_di_reg <= 32'hAA995566; // sync word
          end
          2: begin
              icap_state <= 3;
              icap_csib_reg <= 1'b0;
              icap_rdwrb_reg <= 1'b0;
              icap_di_reg <= 32'h20000000; // type 1 noop
          end
          3: begin
              icap_state <= 4;
              icap_csib_reg <= 1'b0;
              icap_rdwrb_reg <= 1'b0;
              icap_di_reg <= 32'h30008001; // write 1 word to CMD
          end
          4: begin
              icap_state <= 5;
              icap_csib_reg <= 1'b0;
              icap_rdwrb_reg <= 1'b0;
              icap_di_reg <= 32'h0000000F; // IPROG
          end
          5: begin
              icap_state <= 0;
              icap_csib_reg <= 1'b0;
              icap_rdwrb_reg <= 1'b0;
              icap_di_reg <= 32'h20000000; // type 1 noop
          end
      endcase
  
      fpga_boot_sync_reg_0 <= fpga_boot;
      fpga_boot_sync_reg_1 <= fpga_boot_sync_reg_0;
      fpga_boot_sync_reg_2 <= fpga_boot_sync_reg_1;
  end
  
  ICAPE3
  icape3_inst (
      .AVAIL(icap_avail),
      .CLK(clk_125mhz),
      .CSIB(icap_csib_reg),
      .I(icap_di_rev),
      .O(),
      .PRDONE(),
      .PRERROR(),
      .RDWRB(icap_rdwrb_reg)
  );
  
  system_wrapper i_system_wrapper (
    .clk_125mhz (clk_125mhz),
    .clk_250mhz (clk_250mhz),
    .ddr4_act_n (ddr4_act_n),
    .ddr4_adr (ddr4_addr),
    .ddr4_ba (ddr4_ba),
    .ddr4_bg (ddr4_bg),
    .ddr4_ck_c (ddr4_ck_n),
    .ddr4_ck_t (ddr4_ck_p),
    .ddr4_cke (ddr4_cke),
    .ddr4_cs_n (ddr4_cs_n),
    .ddr4_dm_n (ddr4_dm_n),
    .ddr4_dq (ddr4_dq),
    .ddr4_dqs_c (ddr4_dqs_n),
    .ddr4_dqs_t (ddr4_dqs_p),
    .ddr4_odt (ddr4_odt),
    .ddr4_reset_n (ddr4_reset_n),
    .fpga_boot (fpga_boot),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    // .i2c_scl_io (i2c_scl_io),
    // .i2c_sda_io (i2c_sda_io),
    // .iic_main_scl_io (iic_scl),
    // .iic_main_sda_io (iic_sda),
    .i2c_scl_io (iic_scl),
    .i2c_sda_io (iic_sda),
    .iic_main_scl_io (),
    .iic_main_sda_io (),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .sgmii_phyclk_clk_n (phy_clk_n),
    .sgmii_phyclk_clk_p (phy_clk_p),
    .phy_rst_n (phy_rst_n),
    .phy_sd (1'b1),
    .ptp_rst (ptp_rst),
    .qsfp_gtpowergood (qsfp_gtpowergood),
    .qsfp_intl (qsfp_intl),
    .qsfp_lpmode (qsfp_lpmode),
    .qsfp_mgt_refclk (qsfp_mgt_refclk),
    .qsfp_mgt_refclk_bufg (qsfp_mgt_refclk_bufg),
    .qsfp_modprsl (qsfp_modprsl),
    .qsfp_modsell (qsfp_modsell),
    .qsfp_resetl (qsfp_resetl),
    .qsfp_rst (qsfp_rst),
    .qsfp_rx_n (qsfp_rx_n),
    .qsfp_rx_p (qsfp_rx_p),
    .qsfp_tx_n (qsfp_tx_n),
    .qsfp_tx_p (qsfp_tx_p),
    .qspi0_cs (qspi0_cs),
    .qspi0_dq_i (qspi0_dq_i),
    .qspi0_dq_o (qspi0_dq_o),
    .qspi0_dq_oe (qspi0_dq_oe),
    .qspi1_cs (qspi1_cs),
    .qspi1_dq_i (qspi1_dq_i),
    .qspi1_dq_o (qspi1_dq_o),
    .qspi1_dq_oe (qspi1_dq_oe),
    .qspi_clk (qspi_clk),
    .sgmii_rxn (phy_rx_n),
    .sgmii_rxp (phy_rx_p),
    .sgmii_txn (phy_tx_n),
    .sgmii_txp (phy_tx_p),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_sdo),
    .spi_sdo_i (spi_sdio),
    .spi_sdo_o (spi_sdio),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

endmodule
