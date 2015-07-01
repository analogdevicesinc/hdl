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

module usdrx1_spi (

  spi_afe_csn,
  spi_clk_csn,
  spi_clk,
  spi_mosi,
  spi_miso,

  spi_afe_sdio,
  spi_clk_sdio);

  // 4 wire

  input   [ 3:0]  spi_afe_csn;
  input           spi_clk_csn;
  input           spi_clk;
  input           spi_mosi;
  output          spi_miso;

  // 3 wire

  inout           spi_afe_sdio;
  inout           spi_clk_sdio;

  // internal registers

  reg     [ 5:0]  spi_count = 'd0;
  reg             spi_rd_wr_n = 'd0;
  reg             spi_enable = 'd0;

  // internal signals

  wire    [ 1:0]  spi_csn_3_s;
  wire            spi_csn_s;
  wire            spi_enable_s;
  wire            spi_afe_miso_s;
  wire            spi_clk_miso_s;

  // check on rising edge and change on falling edge

  assign spi_csn_3_s[1] = & spi_afe_csn;
  assign spi_csn_3_s[0] = spi_clk_csn;
  assign spi_csn_s = & spi_csn_3_s;
  assign spi_enable_s = spi_enable & ~spi_csn_s;

  always @(posedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s == 1'b1) begin
      spi_count <= 6'd0;
      spi_rd_wr_n <= 1'd0;
    end else begin
      spi_count <= spi_count + 1'b1;
      if (spi_count == 6'd0) begin
        spi_rd_wr_n <= spi_mosi;
      end
    end
  end

  always @(negedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s == 1'b1) begin
      spi_enable <= 1'b0;
    end else begin
      if (((spi_count == 6'd16)  && (spi_csn_3_s[1] == 1'b0)) ||
          ((spi_count == 6'd16) && (spi_csn_3_s[0] == 1'b0))) begin
        spi_enable <= spi_rd_wr_n;
      end
    end
  end

  assign spi_miso =  ((spi_afe_miso_s  & ~spi_csn_3_s[1]) |
                      (spi_clk_miso_s  & ~spi_csn_3_s[0]));

  // io buffers

  assign spi_afe_miso_s = spi_afe_sdio;
  assign spi_afe_sdio = (spi_enable_s == 1'b1) ? 1'bz : spi_mosi;

  assign spi_clk_miso_s = spi_clk_sdio;
  assign spi_clk_sdio = (spi_enable_s == 1'b1) ? 1'bz : spi_mosi;

endmodule

// ***************************************************************************
// ***************************************************************************
