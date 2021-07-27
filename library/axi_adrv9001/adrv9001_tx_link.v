// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2020 (c) Analog Devices, Inc. All rights reserved.
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

module adrv9001_tx_link  #(
  parameter CMOS_LVDS_N = 0,
  parameter CLK_DIV_IS_FAST_CLK = 0
) (
  input         dac_clk_div,
  output  [7:0] dac_data_0,
  output  [7:0] dac_data_1,
  output  [7:0] dac_data_2,
  output  [7:0] dac_data_3,
  output  [7:0] dac_data_strobe,
  output  [7:0] dac_data_clk,
  output        dac_data_valid,

  // upper layer data interface
  output         tx_clk,
  input          tx_rst,
  input          tx_data_valid,
  input   [15:0] tx_data_i,
  input   [15:0] tx_data_q,

  // Config interface
  input          tx_sdr_ddr_n,
  input          tx_single_lane,
  input          tx_symb_op,                
  input          tx_symb_8_16b                 
);                                                           

  assign tx_clk = dac_clk_div;

  wire [7:0] data32sdr;
  wire [7:0] strobe32sdr;
  wire [7:0] data16sdr_0;
  wire [7:0] strobe16sdr;

  wire [7:0] data8sdr_0;
  wire [7:0] data8sdr_1;
  wire [7:0] data8sdr_2;
  wire [7:0] data8sdr_3;
  wire [7:0] strobe8sdr;
  
  wire       ld_next;

  reg [31:0] data32 = 32'b0;
  reg [31:0] strobe32 = 32'b0;
  reg [15:0] data16_0 = 16'b0;
  reg [15:0] data16_1 = 16'b0;
  reg [15:0] strobe16 = 16'b0;
  reg [7:0] data8_0 = 8'b0;
  reg [7:0] data8_1 = 8'b0;
  reg [7:0] data8_2 = 8'b0;
  reg [7:0] data8_3 = 8'b0;
  reg [7:0] strobe8 = 8'b0;
  reg [3:0] valid_gen = 4'b0;

  // Serialization factor Per data lane 32
  always @(posedge tx_clk) begin
    if (tx_data_valid) begin
      data32 <= {tx_data_i,tx_data_q};
      strobe32 <= {1'b1,31'b0};
    end else if (ld_next) begin
      if (tx_sdr_ddr_n) begin
        data32 <= {data32,4'b0};
        strobe32 <= {strobe32,4'b0};
      end else begin
        data32 <= {data32,8'b0};
        strobe32 <= {strobe32,8'b0};
      end
    end
  end

  // Double each bit due the DDR PHY
  assign data32sdr = {data32[31],data32[31],
                      data32[30],data32[30],
                      data32[29],data32[29],
                      data32[28],data32[28]};
  assign strobe32sdr = {strobe32[31],strobe32[31],
                        strobe32[30],strobe32[30],
                        strobe32[29],strobe32[29],
                        strobe32[28],strobe32[28]};

  // Serialization factor Per data lane 16
  always @(posedge tx_clk) begin
    if (tx_data_valid) begin
      data16_0 <= tx_data_i;
      data16_1 <= tx_data_q;
      strobe16 <= {1'b1,15'b0};
    end else if (ld_next) begin
     if(tx_sdr_ddr_n) begin
       data16_0 <= {data16_0,4'b0};
       data16_1 <= {data16_1,4'b0};
       strobe16 <= {strobe16,4'b0};
     end else begin
       data16_0 <= {data16_0,8'b0};
       data16_1 <= {data16_1,8'b0};
       strobe16 <= {strobe16,8'b0};
     end
    end
  end

  // Double each bit due to the DDR PHY
  assign data16sdr_0 = {data16_0[15],data16_0[15],
                        data16_0[14],data16_0[14],
                        data16_0[13],data16_0[13],
                        data16_0[12],data16_0[12]}; 
  assign strobe16sdr = {strobe16[15],strobe16[15],
                        strobe16[14],strobe16[14],
                        strobe16[13],strobe16[13],
                        strobe16[12],strobe16[12]};

  // Serialization factor Per data lane 8
  always @(posedge tx_clk) begin
    if (tx_data_valid) begin
      data8_0 <= tx_data_i[7:0];
      data8_1 <= tx_data_i[15:8];
      data8_2 <= tx_data_q[7:0];
      data8_3 <= tx_data_q[15:8];
      strobe8 <= {1'b1,7'b0};
    end else if (ld_next) begin
      data8_0 <= {data8_0,4'b0};
      data8_1 <= {data8_1,4'b0};
      data8_2 <= {data8_2,4'b0};
      data8_3 <= {data8_3,4'b0};
      strobe8 <= {strobe16,4'b0};
    end
  end

  // Double each bit due the DDR PHY
  assign data8sdr_0 = {data8_0[7],data8_0[7],
                       data8_0[6],data8_0[6],
                       data8_0[5],data8_0[5],
                       data8_0[4],data8_0[4]};
  assign data8sdr_1 = {data8_1[7],data8_1[7],
                       data8_1[6],data8_1[6],
                       data8_1[5],data8_1[5],
                       data8_1[4],data8_1[4]};
  assign data8sdr_2 = {data8_2[7],data8_2[7],
                       data8_2[6],data8_2[6],
                       data8_2[5],data8_2[5],
                       data8_2[4],data8_2[4]};
  assign data8sdr_3 = {data8_3[7],data8_3[7],
                       data8_3[6],data8_3[6],
                       data8_3[5],data8_3[5],
                       data8_3[4],data8_3[4]};
  assign strobe8sdr = {strobe8[7],strobe8[7],
                       strobe8[6],strobe8[6],
                       strobe8[5],strobe8[5],
                       strobe8[4],strobe8[4]};

  assign dac_data_0 = tx_single_lane ? (tx_symb_op ? (tx_sdr_ddr_n ? data16sdr_0 : data16_0[15-:8]) :
                           (tx_sdr_ddr_n ? data32sdr : data32[31-:8])) :
                           (CMOS_LVDS_N ? (tx_sdr_ddr_n ? data8sdr_0 : data8_0) : data16_0[15-:8]);

  assign dac_data_1 = tx_single_lane ? 'b0 :
                           (CMOS_LVDS_N ? (tx_sdr_ddr_n ? data8sdr_1 : data8_1) :
                           data16_1[15-:8]);

  assign dac_data_2 = tx_single_lane ? 'b0 :
                           (CMOS_LVDS_N ? (tx_sdr_ddr_n ? data8sdr_2 : data8_2) :
                           1'b0);

  assign dac_data_3 = tx_single_lane ? 'b0 :
                           (CMOS_LVDS_N ? (tx_sdr_ddr_n ? data8sdr_3 : data8_3) :
                           1'b0);
 
  assign dac_data_strobe = tx_single_lane ? (tx_symb_op ? (tx_symb_8_16b ? (tx_sdr_ddr_n ? strobe8sdr : strobe8) :
                           (tx_sdr_ddr_n ? strobe16sdr : strobe16[15-:8])):
                           (tx_sdr_ddr_n ? strobe32sdr : strobe32[31-:8])) :
                           (CMOS_LVDS_N ? (tx_sdr_ddr_n ? strobe8sdr : strobe8) : strobe16[15-:8]);

  assign dac_data_clk = {4{1'b1,1'b0}};

  assign dac_data_valid = (CLK_DIV_IS_FAST_CLK == 0) ? 1'b1 : valid_gen[3];

  always @(posedge tx_clk) begin
    if (tx_data_valid) begin
      valid_gen <= 4'b1000;
    end else begin
      valid_gen <= {valid_gen[2:0],valid_gen[3]};
    end
  end
 assign ld_next = (CLK_DIV_IS_FAST_CLK == 0) ? 1'b1 : valid_gen[2];

endmodule
