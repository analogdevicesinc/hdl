// -----------------------------------------------------------------------------
//
// Copyright 2013(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//  - Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//  - Neither the name of Analog Devices, Inc. nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//  - The use of this software may or may not infringe the patent rights
//    of one or more patent holders.  This license does not release you
//    from the requirement that you obtain separate licenses from these
//    patent holders to use this software.
//  - Use of the software either in source or binary form, must be run
//    on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// -----------------------------------------------------------------------------
// FILE NAME : dec256sinc24b.v
// MODULE NAME : dec256sinc24b
// -----------------------------------------------------------------------------
// KEYWORDS : sigma-delta modulator
// -----------------------------------------------------------------------------
// PURPOSE : Implements a SINC filter for a sigma-delta modulator
// -----------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy      :
// Clock Domains       :
// Critical Timing     :
// Test Features       :
// Asynchronous I/F    :
// Instantiations      :
// Synthesizable (y/n) :
// Target Device       :
// Other               :
// -----------------------------------------------------------------------------

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
