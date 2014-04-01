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

module fmcjesdadc1_spi (

  // master clock

  sys_clk,

  // 4-wire spi interface

  spi4_csn,
  spi4_clk,
  spi4_mosi,
  spi4_miso,

  // 3-wire spi interface

  spi3_csn,
  spi3_clk,
  spi3_sdio);

  // parameters

  localparam  FMC27X_CPLD = 8'h00;
  localparam  FMC27X_AD9517 = 8'h84;
  localparam  FMC27X_AD9250_0 = 8'h80;
  localparam  FMC27X_AD9250_1 = 8'h81;
  localparam  FMC27X_AD9129_0 = 8'h82;
  localparam  FMC27X_AD9129_1 = 8'h83;

  // master clock

  input           sys_clk;

  // 4-wire spi interface

  input           spi4_csn;
  input           spi4_clk;
  input           spi4_mosi;
  output          spi4_miso;

  // 3-wire spi interface

  output          spi3_csn;
  output          spi3_clk;
  inout           spi3_sdio;

  // internal registers

  reg             spi4_clk_d = 'd0;
  reg             spi4_csn_d = 'd0;
  reg     [ 5:0]  spi4_clkcnt = 'd0;
  reg     [ 6:0]  spi4_bitcnt = 'd0;
  reg     [ 7:0]  spi4_devid = 'd0;
  reg             spi4_rwn = 'd0;
  reg             spi3_enable = 'd0;

  // pass through most of the stuff (no need to change clock or miso or mosi)

  assign spi4_miso = spi3_sdio;
  assign spi3_csn = spi4_csn;
  assign spi3_clk = spi4_clk;
  assign spi3_sdio = ((spi4_csn == 1'b0) && (spi3_enable == 1'b1)) ? 1'bz : spi4_mosi;

  // the spi4 format is a preamble that selects a particular device, so all we need
  // to do is collect the first 8 bits, then control the tristate based on the
  // device's address and data widths. the details of the spi formats can be found
  // in the data sheet of the devices.

  always @(posedge sys_clk) begin
    spi4_clk_d <= spi4_clk;
    spi4_csn_d <= spi4_csn;
    if ((spi4_clk == 1'b1) && (spi4_clk_d == 1'b0)) begin
      spi4_clkcnt <= 6'd0;
    end else begin
      spi4_clkcnt <= spi4_clkcnt + 1'b1;
    end
    if ((spi4_csn == 1'b1) && (spi4_csn_d == 1'b0)) begin
      spi4_bitcnt <= 7'd0;
      spi4_devid <= 8'd0;
      spi4_rwn <= 1'd0;
    end else if ((spi4_clk == 1'b1) && (spi4_clk_d == 1'b0)) begin
      spi4_bitcnt <= spi4_bitcnt + 1'b1;
      if (spi4_bitcnt < 8) begin
        spi4_devid <= {spi4_devid[6:0], spi4_mosi};
      end
      if (spi4_bitcnt == 8) begin
        spi4_rwn <= spi4_mosi;
      end
    end
    if (spi4_csn == 1'b0) begin
      if ((spi4_devid == FMC27X_CPLD) || (spi4_devid == FMC27X_AD9129_0) ||
        (spi4_devid == FMC27X_AD9129_1)) begin
        if ((spi4_bitcnt == 16) && (spi4_clkcnt == 8)) begin
          spi3_enable <= spi4_rwn;
        end
      end else if ((spi4_devid == FMC27X_AD9517) || (spi4_devid == FMC27X_AD9250_0) || 
        (spi4_devid == FMC27X_AD9250_1)) begin
        if ((spi4_bitcnt == 24) && (spi4_clkcnt == 8)) begin
          spi3_enable <= spi4_rwn;
        end
      end
    end else begin
      spi3_enable <= 1'b0;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
