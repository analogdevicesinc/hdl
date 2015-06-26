// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
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

//`timescale 1n/100ps;

module usdrx1_cpld (

  // Bank 1.8 V
  fmc_dac_db,
  fmc_dac_sleep,
  fmc_clkd_spi_sclk,
  fmc_clkd_spi_csb,
  fmc_clkd_spi_sdio,

  fmc_clkd_syncn,
  fmc_clkd_resetn,
  //fmc_clkd_status,

  //tbd1
  //tbd2
  //tbd3

  // Bank 3.3 V
  dac_db,
  dac_sleep,

  clkd_spi_sclk,
  clkd_spi_csb,
  clkd_spi_sdio,
  //clkd_status,
  clkd_syncn,
  clkd_resetn
);

// Bank 1.8 V
  input [13:0]  fmc_dac_db;
  input         fmc_dac_sleep;
  input         fmc_clkd_spi_sclk;
  input         fmc_clkd_spi_csb;
  inout         fmc_clkd_spi_sdio;

  input         fmc_clkd_syncn;
  input         fmc_clkd_resetn;
  //output       fmc_clkd_status;

  //tbd1;
  //tbd2;
  //tbd3;

  // Bank 3.3 V
  output  [13:0]  dac_db;
  output          dac_sleep;

  output          clkd_spi_sclk;
  output          clkd_spi_csb;
  inout           clkd_spi_sdio;
  //input          clkd_status;
  output          clkd_syncn;
  output          clkd_resetn;

  reg [15:0]  cnt ;
  reg         fpga_to_clkd ; // 1 if fpga sends data to ad9517, 0 if fpga reads data from ad9517
  reg         spi_r_wn ;

  assign dac_db             = fmc_dac_db;
  assign dac_sleep          = fmc_dac_sleep;

  assign clkd_spi_sclk      = fmc_clkd_spi_sclk;
  assign clkd_spi_csb       = fmc_clkd_spi_csb;

  assign clkd_spi_sdio      = fpga_to_clkd ? fmc_clkd_spi_sdio : 1'bZ;
  assign fmc_clkd_spi_sdio  = fpga_to_clkd ? 1'bZ :clkd_spi_sdio;

  assign clkd_syncn         = fmc_clkd_syncn;
  assign clkd_resetn        = fmc_clkd_resetn;

  //assign fmc_clkd_status  = clkd_status;

  always @ (posedge fmc_clkd_spi_sclk or posedge fmc_clkd_spi_csb)
  begin
    if (fmc_clkd_spi_csb == 1'b1)
    begin
      cnt           <= 0;
      spi_r_wn      <= 1;
    end
    else
    begin
      cnt <= cnt + 1;
      if (cnt == 0)
      begin
        spi_r_wn <= fmc_clkd_spi_sdio;
      end
    end
  end

  always @(negedge fmc_clkd_spi_sclk or posedge fmc_clkd_spi_csb)
  begin
    if (fmc_clkd_spi_csb == 1'b1)
    begin
      fpga_to_clkd <= 1;
    end
    else
    begin
      if (cnt == 16)
      begin
        fpga_to_clkd <= ~spi_r_wn;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
