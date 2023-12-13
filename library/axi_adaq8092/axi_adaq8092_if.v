// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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
// This is the LVDS/DDR interface, note that overrange is independent of data path,
// software will not be able to relate overrange to a specific sample!

`timescale 1ns/100ps

module axi_adaq8092_if #(

  parameter          FPGA_TECHNOLOGY = 0,
  parameter          IO_DELAY_GROUP = "adc_if_delay_group",
  parameter          DELAY_REFCLK_FREQUENCY = 200,
  parameter   [27:0] POLARITY_MASK ='hfffffff,
  parameter          OUTPUT_MODE = 0
) (

  // adc interface (clk, data, over-range)
  // nominal clock 80 MHz, up to 105 MHz

  input                    adc_clk_in_p,
  input                    adc_clk_in_n,

  input       [13:0]       lvds_adc_data_p,
  input       [13:0]       lvds_adc_data_n,
  input                    lvds_adc_or_p,
  input                    lvds_adc_or_n,

  input       [27:0]       cmos_adc_data,
  input                    cmos_adc_data_or_1,
  input                    cmos_adc_data_or_2,

  // up control SDR or DDR

  input                    sdr_or_ddr,

  // interface outputs

  output                  adc_clk,
  output  reg [27:0]      adc_data,
  output  reg             adc_or,
  output  reg             adc_status,

  // delay control signals

  input                   up_clk,
  input       [29:0]      up_dld,
  input       [149:0]     up_dwdata,
  output      [149:0]     up_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked
);

  // internal registers

  reg      [27:0]   adc_data_s='b0;

  // internal signals

  wire    [13:0]  lvds_adc_data_p_s;
  wire    [13:0]  lvds_adc_data_n_s;
  wire    [27:0]  cmos_adc_data_p_s;
  wire    [27:0]  cmos_adc_data_n_s;
  wire            adc_or_s_1;
  wire            adc_or_s_2;
  wire            adc_or_s_1_p;
  wire            adc_or_s_1_n;
  wire            adc_or_s_2_p;
  wire            adc_or_s_2_n;
  wire    [27:0]  adc_data_if_out;

  genvar          l_inst;

  // LOCAL parameters

  localparam LVDS =  0;
  localparam CMOS =  1;

  always @(posedge adc_clk) begin

    adc_status <= 1'b1;

    if (OUTPUT_MODE == LVDS) begin

      adc_or <= adc_or_s_1 | adc_or_s_2;
      adc_data <= POLARITY_MASK ^ adc_data_s;
      adc_data_s <= { lvds_adc_data_n_s[13], lvds_adc_data_p_s[13],
                      lvds_adc_data_n_s[12], lvds_adc_data_p_s[12],
                      lvds_adc_data_n_s[11], lvds_adc_data_p_s[11],
                      lvds_adc_data_n_s[10], lvds_adc_data_p_s[10],
                      lvds_adc_data_n_s[9],  lvds_adc_data_p_s[9],
                      lvds_adc_data_n_s[8],  lvds_adc_data_p_s[8],
                      lvds_adc_data_n_s[7],  lvds_adc_data_p_s[7],
                      lvds_adc_data_n_s[6],  lvds_adc_data_p_s[6],
                      lvds_adc_data_n_s[5],  lvds_adc_data_p_s[5],
                      lvds_adc_data_n_s[4],  lvds_adc_data_p_s[4],
                      lvds_adc_data_n_s[3],  lvds_adc_data_p_s[3],
                      lvds_adc_data_n_s[2],  lvds_adc_data_p_s[2],
                      lvds_adc_data_n_s[1],  lvds_adc_data_p_s[1],
                      lvds_adc_data_n_s[0],  lvds_adc_data_p_s[0]};

    end else if (OUTPUT_MODE == CMOS) begin
      adc_data <= adc_data_s;
      if (sdr_or_ddr == 0) begin            //DDR_CMOS
        adc_or <= adc_or_s_1_p | adc_or_s_1_n;
        adc_data_s <= { cmos_adc_data_n_s[27], cmos_adc_data_p_s[27],
                        cmos_adc_data_n_s[25], cmos_adc_data_p_s[25],
                        cmos_adc_data_n_s[23], cmos_adc_data_p_s[23],
                        cmos_adc_data_n_s[21], cmos_adc_data_p_s[21],
                        cmos_adc_data_n_s[19], cmos_adc_data_p_s[19],
                        cmos_adc_data_n_s[17], cmos_adc_data_p_s[17],
                        cmos_adc_data_n_s[15], cmos_adc_data_p_s[15],
                        cmos_adc_data_n_s[13], cmos_adc_data_p_s[13],
                        cmos_adc_data_n_s[11], cmos_adc_data_p_s[11],
                        cmos_adc_data_n_s[9],  cmos_adc_data_p_s[9],
                        cmos_adc_data_n_s[7],  cmos_adc_data_p_s[7],
                        cmos_adc_data_n_s[5],  cmos_adc_data_p_s[5],
                        cmos_adc_data_n_s[3],  cmos_adc_data_p_s[3],
                        cmos_adc_data_n_s[1],  cmos_adc_data_p_s[1]};
      end else if (sdr_or_ddr == 1) begin    //SDR_CMOS
        adc_or <= adc_or_s_1_p | adc_or_s_2_p;
        adc_data_s <= { cmos_adc_data_p_s[27], cmos_adc_data_p_s[26],
                        cmos_adc_data_p_s[25], cmos_adc_data_p_s[24],
                        cmos_adc_data_p_s[23], cmos_adc_data_p_s[22],
                        cmos_adc_data_p_s[21], cmos_adc_data_p_s[20],
                        cmos_adc_data_p_s[19], cmos_adc_data_p_s[18],
                        cmos_adc_data_p_s[17], cmos_adc_data_p_s[16],
                        cmos_adc_data_p_s[15], cmos_adc_data_p_s[14],
                        cmos_adc_data_p_s[13], cmos_adc_data_p_s[12],
                        cmos_adc_data_p_s[11], cmos_adc_data_p_s[10],
                        cmos_adc_data_p_s[9],  cmos_adc_data_p_s[8],
                        cmos_adc_data_p_s[7],  cmos_adc_data_p_s[6],
                        cmos_adc_data_p_s[5],  cmos_adc_data_p_s[4],
                        cmos_adc_data_p_s[3],  cmos_adc_data_p_s[2],
                        cmos_adc_data_p_s[1],  cmos_adc_data_p_s[0]};
      end
    end
  end

  // data interface

  generate
    if (OUTPUT_MODE == LVDS) begin
      for (l_inst = 0; l_inst <= 13; l_inst = l_inst + 1) begin : lvds_adc_if  // DDR LVDS INTERFACE
        ad_data_in #(
          .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
          .IODELAY_CTRL (0),
          .IODELAY_GROUP (IO_DELAY_GROUP),
          .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY),
          .IDDR_CLK_EDGE("OPPOSITE_EDGE")
        ) i_adc_data (
          .rx_clk (adc_clk),
          .rx_data_in_p (lvds_adc_data_p[l_inst]),
          .rx_data_in_n (lvds_adc_data_n[l_inst]),
          .rx_data_p (lvds_adc_data_p_s[l_inst]),
          .rx_data_n (lvds_adc_data_n_s[l_inst]),
          .up_clk (up_clk),
          .up_dld (up_dld[l_inst]),
          .up_dwdata (up_dwdata[((l_inst*5)+4):(l_inst*5)]),
          .up_drdata (up_drdata[((l_inst*5)+4):(l_inst*5)]),
          .delay_clk (delay_clk),
          .delay_rst (delay_rst),
          .delay_locked ());
      end
    end else if (OUTPUT_MODE == CMOS) begin

       for (l_inst = 0; l_inst <= 27; l_inst = l_inst + 1) begin : cmos_adc_if  //  CMOS INTERFACE
        ad_data_in #(
          .SINGLE_ENDED(1),
          .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
          .IODELAY_CTRL (0),
          .IODELAY_GROUP (IO_DELAY_GROUP),
          .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY),
          .IDDR_CLK_EDGE("OPPOSITE_EDGE")
        ) i_adc_data (
          .rx_clk (adc_clk),
          .rx_data_in_p (cmos_adc_data[l_inst]),
          .rx_data_in_n (),
          .rx_data_p (cmos_adc_data_p_s[l_inst]),
          .rx_data_n (cmos_adc_data_n_s[l_inst]),
          .up_clk (up_clk),
          .up_dld (up_dld[l_inst]),
          .up_dwdata (up_dwdata[((l_inst*5)+4):(l_inst*5)]),
          .up_drdata (up_drdata[((l_inst*5)+4):(l_inst*5)]),
          .delay_clk (delay_clk),
          .delay_rst (delay_rst),
          .delay_locked ());
      end
    end
  endgenerate

  // over-range interface

  if (OUTPUT_MODE == LVDS) begin
    ad_data_in #(
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .IODELAY_CTRL (1),
      .IODELAY_GROUP (IO_DELAY_GROUP),
      .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY),
      .IDDR_CLK_EDGE("OPPOSITE_EDGE")
    ) i_adc_or_lvds (
      .rx_clk (adc_clk),
      .rx_data_in_p (lvds_adc_or_p),
      .rx_data_in_n (lvds_adc_or_n),
      .rx_data_p (adc_or_s_1),
      .rx_data_n (adc_or_s_2),
      .up_clk (up_clk),
      .up_dld (up_dld[14]),
      .up_dwdata (up_dwdata[74:70]),
      .up_drdata (up_drdata[74:70]),
      .delay_clk (delay_clk),
      .delay_rst (delay_rst),
      .delay_locked (delay_locked));
  end else if (OUTPUT_MODE == CMOS) begin
    ad_data_in #(
      .SINGLE_ENDED(1),
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .IODELAY_CTRL (1),
      .IODELAY_GROUP (IO_DELAY_GROUP),
      .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY),
      .IDDR_CLK_EDGE("OPPOSITE_EDGE")
    ) i_adc_or_cmos_1 (
      .rx_clk (adc_clk),
      .rx_data_in_p (cmos_adc_data_or_1),
      .rx_data_in_n (),
      .rx_data_p (adc_or_s_1_p),
      .rx_data_n (adc_or_s_1_n),
      .up_clk (up_clk),
      .up_dld (up_dld[28]),
      .up_dwdata (up_dwdata[144:140]),
      .up_drdata (up_drdata[144:140]),
      .delay_clk (delay_clk),
      .delay_rst (delay_rst),
      .delay_locked ());

    ad_data_in #(
      .SINGLE_ENDED(1),
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .IODELAY_CTRL (1),
      .IODELAY_GROUP (IO_DELAY_GROUP),
      .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY),
      .IDDR_CLK_EDGE("OPPOSITE_EDGE")
    ) i_adc_or_cmos_2 (
      .rx_clk (adc_clk),
      .rx_data_in_p (cmos_adc_data_or_2),
      .rx_data_in_n (),
      .rx_data_p (adc_or_s_2_p),
      .rx_data_n (adc_or_s_2_n),
      .up_clk (up_clk),
      .up_dld (up_dld[29]),
      .up_dwdata (up_dwdata[149:145]),
      .up_drdata (up_drdata[149:145]),
      .delay_clk (delay_clk),
      .delay_rst (delay_rst),
      .delay_locked ());
  end

  // clock

  ad_data_clk i_adc_clk (
    .rst (1'b0),
    .locked (),
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk));

endmodule
