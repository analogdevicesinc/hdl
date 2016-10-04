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

`timescale 1ns/100ps

module fmcadc2_spi (

  spi_adf4355,
  spi_adf4355_ce,

  spi_clk,
  spi_csn,
  spi_mosi,
  spi_miso,

  spi_adc_csn,
  spi_adc_clk,
  spi_adc_sdio,

  spi_adf4355_data_or_csn_0,
  spi_adf4355_clk_or_csn_1,
  spi_adf4355_le_or_clk,
  spi_adf4355_ce_or_sdio);

  // select (adf4355 = 0x1), (normal = 0x0)

  input           spi_adf4355;
  input           spi_adf4355_ce;

  // 4 wire

  input           spi_clk;
  input   [ 2:0]  spi_csn;
  input           spi_mosi;
  output          spi_miso;

  // adc interface (3 wire)

  output          spi_adc_csn;
  output          spi_adc_clk;
  inout           spi_adc_sdio;

  // adf4355 or normal (AMP/EXT)

  output          spi_adf4355_data_or_csn_0;
  output          spi_adf4355_clk_or_csn_1;
  output          spi_adf4355_le_or_clk;
  inout           spi_adf4355_ce_or_sdio;

  // internal registers

  reg     [ 5:0]  spi_count = 'd0;
  reg             spi_rd_wr_n = 'd0;
  reg             spi_enable = 'd0;

  // internal signals

  wire            spi_csn_s;
  wire            spi_enable_s;

  // check on rising edge and change on falling edge

  assign spi_csn_s = & spi_csn;
  assign spi_enable_s = spi_enable & ~spi_csn_s;

  always @(posedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s == 1'b1) begin
      spi_count <= 6'd0;
      spi_rd_wr_n <= 1'd0;
    end else begin
      spi_count <= (spi_count < 6'h3f) ? spi_count + 1'b1 : spi_count;
      if (spi_count == 6'd0) begin
        spi_rd_wr_n <= spi_mosi;
      end
    end
  end

  always @(negedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s == 1'b1) begin
      spi_enable <= 1'b0;
    end else begin
      if (spi_count == 6'd16) begin
        spi_enable <= spi_rd_wr_n;
      end
    end
  end

  assign spi_miso = ((spi_adc_sdio & ~spi_csn[0]) | (~spi_adf4355 &
    spi_adf4355_ce_or_sdio & ~(spi_csn[1] & spi_csn[2])));

  // adc interface (3 wire)

  assign spi_adc_csn = spi_csn[0];
  assign spi_adc_clk = spi_clk;
  assign spi_adc_sdio = (spi_enable_s == 1'b0) ? spi_mosi : 1'bz;

  // adf4355 or normal (AMP/EXT)

  assign spi_adf4355_data_or_csn_0 = (spi_adf4355 == 1'b1) ? spi_mosi : spi_csn[1];
  assign spi_adf4355_clk_or_csn_1 = (spi_adf4355 == 1'b1) ? spi_clk : spi_csn[2];
  assign spi_adf4355_le_or_clk = (spi_adf4355 == 1'b1) ? spi_csn[1] : spi_clk;
  assign spi_adf4355_ce_or_sdio = (spi_adf4355 == 1'b1) ? spi_adf4355_ce :
    ((spi_enable_s == 1'b0) ? spi_mosi : 1'bz);

endmodule

// ***************************************************************************
// ***************************************************************************
