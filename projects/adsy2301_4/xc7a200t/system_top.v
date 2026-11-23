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
  input  clk_122_p,
  input  clk_122_n,

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
  // input  BF_PWR_EN_01,
  output BF_PWR_EN_01,
  input  VGG_PA_PG_N1,

  // BF GPIO 02
  output BF_PA_ON_02,
  // input  BF_PWR_EN_02,
  output BF_PWR_EN_02,
  input  VGG_PA_PG_N2,

  // BF GPIO 03
  output BF_PA_ON_03,
  // input  BF_PWR_EN_03,
  output BF_PWR_EN_03,
  input  VGG_PA_PG_N3,

  // BF GPIO 04
  output BF_PA_ON_04,
  // input  BF_PWR_EN_04,
  output BF_PWR_EN_04,
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
  input  UDC_5P0V_LDO_PG,
  input  UDC_3P3V_LDO_PG,

  // SPI link from the zcu102
  input  link_sclk,
  input  link_cs,
  input  link_mosi,
  output link_miso
);

  wire clk;

  wire link_miso_o;
  wire link_miso_t;

  assign link_miso = link_miso_t ? 1'bz : link_miso_o;

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
  wire [ 7:0] gpio_o3;
  wire [16:0] gpio_i;

  // SPI translator GPIOs: out1, out2, out3, in, then 32 outputs looped back
  // into 32 inputs. An output reads back its own level.
  wire [150:0] translator_gpio_i;
  wire [150:0] translator_gpio_o;
  wire [150:0] translator_gpio_t;

  assign {gpio_o3, gpio_o2, gpio_o1} = translator_gpio_o[69:0];

  assign translator_gpio_i[69:0] = translator_gpio_o[69:0];
  assign translator_gpio_i[86:70] = gpio_i;
  assign translator_gpio_i[118:87] = translator_gpio_o[118:87];
  assign translator_gpio_i[150:119] = translator_gpio_o[118:87];

  // downstream SPI engines, engine 0 has 8 chip selects, engine 1 has one
  wire       trx_spi_sclk;
  wire       trx_spi_mosi;
  wire       trx_spi_miso;
  wire [7:0] trx_spi_csb;
  wire [7:0] lo_spi_csb;

  // TX (cs[3:0]) and RX (cs[7:4]) share the bus: the MISO of the selected one
  assign TX_SPI_SCLK = trx_spi_sclk;
  assign RX_SPI_SCLK = trx_spi_sclk;
  assign TX_SPI_MOSI = trx_spi_mosi;
  assign RX_SPI_MOSI = trx_spi_mosi;
  assign {TX_SPI_CSB4, TX_SPI_CSB3, TX_SPI_CSB2, TX_SPI_CSB1} = trx_spi_csb[3:0];
  assign {RX_SPI_CSB4, RX_SPI_CSB3, RX_SPI_CSB2, RX_SPI_CSB1} = trx_spi_csb[7:4];
  assign trx_spi_miso = (trx_spi_csb[3:0] != 4'hf) ? TX_SPI_MISO : RX_SPI_MISO;

  assign LO_SPI_CSB = lo_spi_csb[0];

  // BF SPI and RF FL SPI are not controlled for now: idle, chip selects high
  assign BF_SPI_SCLK_01 = 1'b0;
  assign BF_SPI_MOSI_01 = 1'b0;
  assign BF_SPI_CSB_01  = 1'b1;
  assign BF_SPI_SCLK_02 = 1'b0;
  assign BF_SPI_MOSI_02 = 1'b0;
  assign BF_SPI_CSB_02  = 1'b1;
  assign BF_SPI_SCLK_03 = 1'b0;
  assign BF_SPI_MOSI_03 = 1'b0;
  assign BF_SPI_CSB_03  = 1'b1;
  assign BF_SPI_SCLK_04 = 1'b0;
  assign BF_SPI_MOSI_04 = 1'b0;
  assign BF_SPI_CSB_04  = 1'b1;
  assign RF_FL_SPI_SCLK = 1'b0;
  assign RF_FL_SPI_MOSI = 1'b0;
  assign {RF_FL_SPI_CSB4, RF_FL_SPI_CSB3, RF_FL_SPI_CSB2, RF_FL_SPI_CSB1} = 4'hf;

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
  assign BF_PWR_EN_01    = gpio_o3[4];
  assign BF_PWR_EN_02    = gpio_o3[5];
  assign BF_PWR_EN_03    = gpio_o3[6];
  assign BF_PWR_EN_04    = gpio_o3[7];

  assign gpio_i[0]  = 1'b0; // BF_PWR_EN_01 is an output
  assign gpio_i[1]  = VGG_PA_PG_N1;
  assign gpio_i[2]  = 1'b0; // BF_PWR_EN_02 is an output
  assign gpio_i[3]  = VGG_PA_PG_N2;
  assign gpio_i[4]  = 1'b0; // BF_PWR_EN_03 is an output
  assign gpio_i[5]  = VGG_PA_PG_N3;
  assign gpio_i[6]  = 1'b0; // BF_PWR_EN_04 is an output
  assign gpio_i[7]  = VGG_PA_PG_N4;
  assign gpio_i[8]  = MUXOUT;
  assign gpio_i[9]  = PG_CARRIER;
  assign gpio_i[10] = GT_PGOOD_1V;
  assign gpio_i[11] = UDC_PG;
  assign gpio_i[12] = N6P0V_PG;
  assign gpio_i[13] = UDC_ALERT_N_LTC2945;
  assign gpio_i[14] = FPGA_TRIG;
  assign gpio_i[15] = UDC_5P0V_LDO_PG;
  assign gpio_i[16] = UDC_3P3V_LDO_PG;

  system_wrapper i_system_wrapper (
    .clk_in_clk_p (clk_122_p),
    .clk_in_clk_n (clk_122_n),
    .clk_out (clk),
    .ext_rst (FPGA_TRIG),
    .link_sclk (link_sclk),
    .link_cs (link_cs),
    .link_mosi (link_mosi),
    .link_miso (link_miso_o),
    .link_miso_t (link_miso_t),
    .gpio_i (translator_gpio_i),
    .gpio_o (translator_gpio_o),
    .gpio_t (translator_gpio_t),
    .spi_0_sclk (trx_spi_sclk),
    .spi_0_sdo (trx_spi_mosi),
    .spi_0_sdo_t (),
    .spi_0_sdi (trx_spi_miso),
    .spi_0_cs (trx_spi_csb),
    .spi_0_three_wire (),
    .spi_1_sclk (LO_SPI_SCLK),
    .spi_1_sdo (LO_SPI_MOSI),
    .spi_1_sdo_t (),
    .spi_1_sdi (LO_SPI_MISO),
    .spi_1_cs (lo_spi_csb),
    .spi_1_three_wire ());

endmodule
