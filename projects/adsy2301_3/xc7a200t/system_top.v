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

  // Input reference clock
  input  clk_125_p,
  input  clk_125_n,

  // BF SPI 01
  output BF_SPI_SCLK_01,
  output BF_SPI_CSB_01,
  output BF_SPI_MOSI_01,
  input  BF_SPI_MISO_01,

  // BF SPI 02
  output BF_SPI_SCLK_02,
  output BF_SPI_CSB_02,
  output BF_SPI_MOSI_02,
  input  BF_SPI_MISO_02,

  // BF SPI 03
  output BF_SPI_SCLK_03,
  output BF_SPI_CSB_03,
  output BF_SPI_MOSI_03,
  input  BF_SPI_MISO_03,

  // BF SPI 04
  output BF_SPI_SCLK_04,
  output BF_SPI_CSB_04,
  output BF_SPI_MOSI_04,
  input  BF_SPI_MISO_04,

  // RF FL SPI
  output RF_FL_SPI_SCLK,
  output RF_FL_SPI_CSB1,
  output RF_FL_SPI_CSB2,
  output RF_FL_SPI_CSB3,
  output RF_FL_SPI_CSB4,
  output RF_FL_SPI_MOSI,
  input  RF_FL_SPI_MISO,

  // LO SPI
  output LO_SPI_SCLK,
  output LO_SPI_CSB,
  output LO_SPI_MOSI,
  input  LO_SPI_MISO,

  // TX SPI
  output TX_SPI_SCLK,
  output TX_SPI_CSB1,
  output TX_SPI_CSB2,
  output TX_SPI_CSB3,
  output TX_SPI_CSB4,
  output TX_SPI_MOSI,
  input  TX_SPI_MISO,

  // RX SPI
  output RX_SPI_SCLK,
  output RX_SPI_CSB1,
  output RX_SPI_CSB2,
  output RX_SPI_CSB3,
  output RX_SPI_CSB4,
  output RX_SPI_MOSI,
  input  RX_SPI_MISO,

  // BF I2C 01
  inout  BF_SCL_01,
  inout  BF_SDA_01,

  // BF I2C 02
  inout  BF_SCL_02,
  inout  BF_SDA_02,

  // BF I2C 03
  inout  BF_SCL_03,
  inout  BF_SDA_03,

  // BF I2C 04
  inout  BF_SCL_04,
  inout  BF_SDA_04,

  // UDC I2C
  inout  UDC_SCL,
  inout  UDC_SDA,

  // TX Load
  input  TX_LOAD,
  output BF_TX_LOAD_01,
  output BF_TX_LOAD_02,
  output BF_TX_LOAD_03,
  output BF_TX_LOAD_04,

  // RX Load
  input  RX_LOAD,
  output BF_RX_LOAD_01,
  output BF_RX_LOAD_02,
  output BF_RX_LOAD_03,
  output BF_RX_LOAD_04,

  // TR Pulse
  input  TR_PULSE,
  output BF_TR_01,
  output BF_TR_02,
  output BF_TR_03,
  output BF_TR_04,

  // BF GPIO 01
  output BF_PA_ON_01,
  input  BF_ALARM_01,
  input  VGG_PA_PG_N1,

  // BF GPIO 02
  output BF_PA_ON_02,
  input  BF_ALARM_02,
  input  VGG_PA_PG_N2,

  // BF GPIO 03
  output BF_PA_ON_03,
  input  BF_ALARM_03,
  input  VGG_PA_PG_N3,

  // BF GPIO 04
  output BF_PA_ON_04,
  input  BF_ALARM_04,
  input  VGG_PA_PG_N4,

  // ADRF5030 GPIO
  output ADRF5030_CTRL1,
  output ADRF5030_CTRL2,
  output ADRF5030_CTRL3,
  output ADRF5030_CTRL4,
  output ADRF5030_EN1,
  output ADRF5030_EN2,
  output ADRF5030_EN3,
  output ADRF5030_EN4,

  // RF FL GPIO
  output RF_FL_LDO_EN,
  output RF_FL_SFL,
  output RF_FL_PS_N,
  output RF_FL_RST_N,
  output [3:0] RF_FL_HPF,
  output [3:0] RF_FL_LPF,

  // LO GPIO
  output LO_CE,
  output DELSTR,
  output DELADJ,
  input  MUXOUT,

  // Converter TX GPIO
  output TX_CEN1,
  output TX_LOAD1,
  output TX_RSTB1,
  output TX_CEN2,
  output TX_LOAD2,
  output TX_RSTB2,
  output TX_CEN3,
  output TX_LOAD3,
  output TX_RSTB3,
  output TX_CEN4,
  output TX_LOAD4,
  output TX_RSTB4,

  // Converter RX GPIO
  output RX_CEN1,
  output RX_LOAD1,
  output RX_RSTB1,
  output RX_CEN2,
  output RX_LOAD2,
  output RX_RSTB2,
  output RX_CEN3,
  output RX_LOAD3,
  output RX_RSTB3,
  output RX_CEN4,
  output RX_LOAD4,
  output RX_RSTB4,

  // ADMV GPIO
  output [4:0] ADMVXX20_ADDF,
  output [5:0] ADMVXX20_ADDG,

  // Other GPIO
  output N6P0V_EN,
  output UDC_NEG_PWR_EN,
  output UDC_3P3V_PWR_EN,
  output UDC_5P0V_PWR_EN,
  input  PG_CARRIER,
  input  GT_PGOOD_1V,
  input  UDC_PG,
  input  N6P0V_PG,
  input  UDC_ALERT_N_LTC2945,
  input  FPGA_TRIG,

  // FLASH SPI
  // output FLASH_SPI_SCLK,
  // output FLASH_SPI_CSB,
  // input  FLASH_SPI_DQ0,
  // input  FLASH_SPI_DQ1,
  // input  FLASH_SPI_DQ2,
  // input  FLASH_SPI_DQ3,

  // Aurora
  input        aurora_refclk_p,
  input        aurora_refclk_n,
  output [1:0] aurora_txp,
  output [1:0] aurora_txn,
  input  [1:0] aurora_rxp,
  input  [1:0] aurora_rxn
);

  wire clk;

  reg [3:0] gpio_tx_load;
  reg [3:0] gpio_rx_load;
  reg [3:0] gpio_tr_pulse;

  always @(posedge clk) begin
    gpio_tx_load <= {4{TX_LOAD}};
    gpio_rx_load <= {4{RX_LOAD}};
    gpio_tr_pulse <= {4{TR_PULSE}};
  end

  assign {BF_TX_LOAD_01, BF_TX_LOAD_02, BF_TX_LOAD_03, BF_TX_LOAD_04} = gpio_tx_load;
  assign {BF_RX_LOAD_01, BF_RX_LOAD_02, BF_RX_LOAD_03, BF_RX_LOAD_04} = gpio_rx_load;
  assign {BF_TR_01, BF_TR_02, BF_TR_03, BF_TR_04} = gpio_tr_pulse;

  wire [29:0] gpio_o1;
  wire [31:0] gpio_o2;
  wire [3:0]  gpio_o3;
  wire [14:0] gpio_i;

  assign BF_PA_ON_01      = gpio_o1[0];
  assign BF_PA_ON_02      = gpio_o1[1];
  assign BF_PA_ON_03      = gpio_o1[2];
  assign BF_PA_ON_04      = gpio_o1[3];
  assign RF_FL_LDO_EN     = gpio_o1[4];
  assign RF_FL_SFL        = gpio_o1[5];
  assign RF_FL_PS_N       = gpio_o1[6];
  assign RF_FL_RST_N      = gpio_o1[7];
  assign RF_FL_HPF[0]     = gpio_o1[8];
  assign RF_FL_HPF[1]     = gpio_o1[9];
  assign RF_FL_HPF[2]     = gpio_o1[10];
  assign RF_FL_HPF[3]     = gpio_o1[11];
  assign RF_FL_LPF[0]     = gpio_o1[12];
  assign RF_FL_LPF[1]     = gpio_o1[13];
  assign RF_FL_LPF[2]     = gpio_o1[14];
  assign RF_FL_LPF[3]     = gpio_o1[15];
  assign LO_CE            = gpio_o1[16];
  assign DELSTR           = gpio_o1[17];
  assign DELADJ           = gpio_o1[18];
  assign ADMVXX20_ADDF[0] = gpio_o1[19];
  assign ADMVXX20_ADDF[1] = gpio_o1[20];
  assign ADMVXX20_ADDF[2] = gpio_o1[21];
  assign ADMVXX20_ADDF[3] = gpio_o1[22];
  assign ADMVXX20_ADDF[4] = gpio_o1[23];
  assign ADMVXX20_ADDG[0] = gpio_o1[24];
  assign ADMVXX20_ADDG[1] = gpio_o1[25];
  assign ADMVXX20_ADDG[2] = gpio_o1[26];
  assign ADMVXX20_ADDG[3] = gpio_o1[27];
  assign ADMVXX20_ADDG[4] = gpio_o1[28];
  assign ADMVXX20_ADDG[5] = gpio_o1[29];

  assign TX_CEN1        = gpio_o2[0];
  assign TX_LOAD1       = gpio_o2[1];
  assign TX_RSTB1       = gpio_o2[2];
  assign TX_CEN2        = gpio_o2[3];
  assign TX_LOAD2       = gpio_o2[4];
  assign TX_RSTB2       = gpio_o2[5];
  assign TX_CEN3        = gpio_o2[6];
  assign TX_LOAD3       = gpio_o2[7];
  assign TX_RSTB3       = gpio_o2[8];
  assign TX_CEN4        = gpio_o2[9];
  assign TX_LOAD4       = gpio_o2[10];
  assign TX_RSTB4       = gpio_o2[11];
  assign RX_CEN1        = gpio_o2[12];
  assign RX_LOAD1       = gpio_o2[13];
  assign RX_RSTB1       = gpio_o2[14];
  assign RX_CEN2        = gpio_o2[15];
  assign RX_LOAD2       = gpio_o2[16];
  assign RX_RSTB2       = gpio_o2[17];
  assign RX_CEN3        = gpio_o2[18];
  assign RX_LOAD3       = gpio_o2[19];
  assign RX_RSTB3       = gpio_o2[20];
  assign RX_CEN4        = gpio_o2[21];
  assign RX_LOAD4       = gpio_o2[22];
  assign RX_RSTB4       = gpio_o2[23];
  assign ADRF5030_CTRL1 = gpio_o2[24];
  assign ADRF5030_CTRL2 = gpio_o2[25];
  assign ADRF5030_CTRL3 = gpio_o2[26];
  assign ADRF5030_CTRL4 = gpio_o2[27];
  assign ADRF5030_EN1   = gpio_o2[28];
  assign ADRF5030_EN2   = gpio_o2[29];
  assign ADRF5030_EN3   = gpio_o2[30];
  assign ADRF5030_EN4   = gpio_o2[31];

  assign N6P0V_EN        = gpio_o3[0];
  assign UDC_NEG_PWR_EN  = gpio_o3[1];
  assign UDC_3P3V_PWR_EN = gpio_o3[2];
  assign UDC_5P0V_PWR_EN = gpio_o3[3];

  assign gpio_i[0]  = BF_ALARM_01;
  assign gpio_i[1]  = VGG_PA_PG_N1;
  assign gpio_i[2]  = BF_ALARM_02;
  assign gpio_i[3]  = VGG_PA_PG_N2;
  assign gpio_i[4]  = BF_ALARM_03;
  assign gpio_i[5]  = VGG_PA_PG_N3;
  assign gpio_i[6]  = BF_ALARM_04;
  assign gpio_i[7]  = VGG_PA_PG_N4;
  assign gpio_i[8]  = MUXOUT;
  assign gpio_i[9]  = PG_CARRIER;
  assign gpio_i[10] = GT_PGOOD_1V;
  assign gpio_i[11] = UDC_PG;
  assign gpio_i[12] = N6P0V_PG;
  assign gpio_i[13] = UDC_ALERT_N_LTC2945;
  assign gpio_i[14] = FPGA_TRIG;

  system_wrapper i_system_wrapper (
    .clk_in_clk_p (clk_125_p),
    .clk_in_clk_n (clk_125_n),
    .clk_out (clk),
    .ext_rst (FPGA_TRIG),
    .bf_spi_sclk_01(BF_SPI_SCLK_01),
    .bf_spi_csb_01(BF_SPI_CSB_01),
    .bf_spi_mosi_01(BF_SPI_MOSI_01),
    .bf_spi_miso_01(BF_SPI_MISO_01),
    .bf_spi_sclk_02(BF_SPI_SCLK_02),
    .bf_spi_csb_02(BF_SPI_CSB_02),
    .bf_spi_mosi_02(BF_SPI_MOSI_02),
    .bf_spi_miso_02(BF_SPI_MISO_02),
    .bf_spi_sclk_03(BF_SPI_SCLK_03),
    .bf_spi_csb_03(BF_SPI_CSB_03),
    .bf_spi_mosi_03(BF_SPI_MOSI_03),
    .bf_spi_miso_03(BF_SPI_MISO_03),
    .bf_spi_sclk_04(BF_SPI_SCLK_04),
    .bf_spi_csb_04(BF_SPI_CSB_04),
    .bf_spi_mosi_04(BF_SPI_MOSI_04),
    .bf_spi_miso_04(BF_SPI_MISO_04),
    .rf_fl_spi_sclk(RF_FL_SPI_SCLK),
    .rf_fl_spi_csb({RF_FL_SPI_CSB4, RF_FL_SPI_CSB3, RF_FL_SPI_CSB2, RF_FL_SPI_CSB1}),
    .rf_fl_spi_mosi(RF_FL_SPI_MOSI),
    .rf_fl_spi_miso(RF_FL_SPI_MISO),
    .lo_spi_sclk(LO_SPI_SCLK),
    .lo_spi_csb(LO_SPI_CSB),
    .lo_spi_mosi(LO_SPI_MOSI),
    .lo_spi_miso(LO_SPI_MISO),
    .tx_spi_sclk(TX_SPI_SCLK),
    .tx_spi_csb({TX_SPI_CSB4, TX_SPI_CSB3, TX_SPI_CSB2, TX_SPI_CSB1}),
    .tx_spi_mosi(TX_SPI_MOSI),
    .tx_spi_miso(TX_SPI_MISO),
    .rx_spi_sclk(RX_SPI_SCLK),
    .rx_spi_csb({RX_SPI_CSB4, RX_SPI_CSB3, RX_SPI_CSB2, RX_SPI_CSB1}),
    .rx_spi_mosi(RX_SPI_MOSI),
    .rx_spi_miso(RX_SPI_MISO),
    // .flash_spi_sclk(FLASH_SPI_SCLK),
    // .flash_spi_csb(FLASH_SPI_CSB),
    // .flash_spi_mosi(FLASH_SPI_DQ0),
    // .flash_spi_miso(FLASH_SPI_DQ1),
    // .flash_spi_miso(FLASH_SPI_DQ2),
    // .flash_spi_miso(FLASH_SPI_DQ3),
    .bf_iic_01_scl_io(BF_SCL_01),
    .bf_iic_01_sda_io(BF_SDA_01),
    .bf_iic_02_scl_io(BF_SCL_02),
    .bf_iic_02_sda_io(BF_SDA_02),
    .bf_iic_03_scl_io(BF_SCL_03),
    .bf_iic_03_sda_io(BF_SDA_03),
    .bf_iic_04_scl_io(BF_SCL_04),
    .bf_iic_04_sda_io(BF_SDA_04),
    .udc_iic_scl_io(UDC_SCL),
    .udc_iic_sda_io(UDC_SDA),
    .gpio_out1_tri_o(gpio_o1),
    .gpio_out2_tri_o(gpio_o2),
    .gpio_out3_tri_o(gpio_o3),
    .gpio_in_tri_i(gpio_i),
    .gt_diff_refclk_clk_p(aurora_refclk_p),
    .gt_diff_refclk_clk_n(aurora_refclk_n),
    .gt_serial_tx_txp(aurora_txp),
    .gt_serial_tx_txn(aurora_txn),
    .gt_serial_rx_rxp(aurora_rxp),
    .gt_serial_rx_rxn(aurora_rxn));

endmodule
