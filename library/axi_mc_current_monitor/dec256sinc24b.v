// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1 ns / 100 ps //Use a timescale that is best for simulation.

//------------------------------------------------------------------------------
//----------- Module Declaration -----------------------------------------------
//------------------------------------------------------------------------------
module dec256sinc24b
(
    input                       reset_i,
    input                       mclkout_i,
    input                       mdata_i,

    output                      data_rdy_o,     // signals when new data is available
    output reg  [15:0]          data_o          // outputs filtered data
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------

reg [23:0]  ip_data1;
reg [23:0]  acc1;
reg [23:0]  acc2;
reg [23:0]  acc3;
reg [23:0]  acc3_d1;
reg [23:0]  acc3_d2;
reg [23:0]  diff1;
reg [23:0]  diff2;
reg [23:0]  diff3;
reg [23:0]  diff1_d;
reg [23:0]  diff2_d;
reg [7:0]   word_count;
reg         word_clk;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

assign data_rdy_o = word_clk;

/* Perform the Sinc ACTION */
always @(mdata_i)
begin
    if(mdata_i == 0)
    begin
        ip_data1    <= 0;
    end
    else
    begin
        ip_data1    <= 1;
    end
end

/*ACCUMULATOR (INTEGRATOR)
* Perform the accumulation (IIR) at the speed of the modulator.
* mclkout_i = modulators conversion bit rate */
always @(negedge mclkout_i or posedge reset_i)
begin
    if( reset_i == 1'b1 )
    begin
        /*initialize acc registers on reset*/
        acc1    <= 0;
        acc2    <= 0;
        acc3    <= 0;
    end
    else
    begin
        /*perform accumulation process*/
        acc1    <= acc1 + ip_data1;
        acc2    <= acc2 + acc1;
        acc3    <= acc3 + acc2;
    end
end

/*DECIMATION STAGE (MCLKOUT_I/ WORD_CLK) */
always@(posedge mclkout_i or posedge reset_i )
begin
    if(reset_i == 1'b1)
    begin
        word_count  <= 0;
    end
    else
    begin
        word_count <= word_count + 1;
    end
end

always @(word_count)
begin
    word_clk <= word_count[7];
end

/*DIFFERENTIATOR (including decimation stage)
* Perform the differentiation stage (FIR) at a lower speed.
WORD_CLK = output word rate */
always @(posedge word_clk or posedge reset_i)
begin
    if(reset_i == 1'b1)
    begin
        acc3_d2 <= 0;
        diff1_d <= 0;
        diff2_d <= 0;
        diff1   <= 0;
        diff2   <= 0;
        diff3   <= 0;
    end
    else
    begin
        diff1   <= acc3 - acc3_d2;
        diff2   <= diff1 - diff1_d;
        diff3   <= diff2 - diff2_d;
        acc3_d2 <= acc3;
        diff1_d <= diff1;
        diff2_d <= diff2;
    end
end

/*  Clock the Sinc output into an output register
    Clocking Sinc Output into an Output Register
WORD_CLK = output word rate */
always @(posedge word_clk)
begin
    data_o[15]  <= diff3[23];
    data_o[14]  <= diff3[22];
    data_o[13]  <= diff3[21];
    data_o[12]  <= diff3[20];
    data_o[11]  <= diff3[19];
    data_o[10]  <= diff3[18];
    data_o[9]   <= diff3[17];
    data_o[8]   <= diff3[16];
    data_o[7]   <= diff3[15];
    data_o[6]   <= diff3[14];
    data_o[5]   <= diff3[13];
    data_o[4]   <= diff3[12];
    data_o[3]   <= diff3[11];
    data_o[2]   <= diff3[10];
    data_o[1]   <= diff3[9];
    data_o[0]   <= diff3[8];
end

endmodule
