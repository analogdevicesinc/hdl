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

  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso,

  spi_sdio);

  // parameters

  localparam  FMC27X_CPLD = 8'h00;
  localparam  FMC27X_AD9517 = 8'h84;
  localparam  FMC27X_AD9250_0 = 8'h80;
  localparam  FMC27X_AD9250_1 = 8'h81;
  localparam  FMC27X_AD9129_0 = 8'h82;
  localparam  FMC27X_AD9129_1 = 8'h83;

  // 4-wire

  input           spi_csn;
  input           spi_clk;
  input           spi_mosi;
  output          spi_miso;

  // 3-wire

  inout           spi_sdio;

  // internal registers

  reg     [ 7:0]  spi_devid = 'd0;
  reg     [ 5:0]  spi_count = 'd0;
  reg             spi_rd_wr_n = 'd0;
  reg             spi_enable = 'd0;

  // internal signals

  wire            spi_enable_s;

  // check on rising edge and change on falling edge

  assign spi_enable_s = spi_enable & ~spi_csn;

  always @(posedge spi_clk or posedge spi_csn) begin
    if (spi_csn == 1'b1) begin
      spi_count <= 6'd0;
      spi_devid <= 8'd0;
      spi_rd_wr_n <= 1'd0;
    end else begin
      spi_count <= spi_count + 1'b1;
      if (spi_count <= 6'd7) begin
        spi_devid <= {spi_devid[6:0], spi_mosi};
      end
      if (spi_count == 6'd8) begin
        spi_rd_wr_n <= spi_mosi;
      end
    end
  end

  always @(negedge spi_clk or posedge spi_csn) begin
    if (spi_csn == 1'b1) begin
      spi_enable <= 1'b0;
    end else begin
      if (((spi_count == 6'd16) && (spi_devid == FMC27X_CPLD)) ||
          ((spi_count == 6'd16) && (spi_devid == FMC27X_AD9129_0)) ||
          ((spi_count == 6'd16) && (spi_devid == FMC27X_AD9129_1)) ||
          ((spi_count == 6'd24) && (spi_devid == FMC27X_AD9517)) ||
          ((spi_count == 6'd24) && (spi_devid == FMC27X_AD9250_0)) ||
          ((spi_count == 6'd24) && (spi_devid == FMC27X_AD9250_1))) begin
        spi_enable <= spi_rd_wr_n;
      end
    end
  end

  assign spi_miso = spi_sdio;
  assign spi_sdio = (spi_enable_s == 1'b1) ? 1'bz : spi_mosi;

endmodule

// ***************************************************************************
// ***************************************************************************
