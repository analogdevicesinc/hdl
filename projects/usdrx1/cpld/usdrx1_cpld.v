// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

//`timescale 1n/100ps;

module usdrx1_cpld (

  // Bank 1.8 V
  input       [13:0]      fmc_dac_db,
  input                   fmc_dac_sleep,
  input                   fmc_clkd_spi_sclk,
  input                   fmc_clkd_spi_csb,
  inout                   fmc_clkd_spi_sdio,

  input                   fmc_clkd_syncn,
  input                   fmc_clkd_resetn,
  //fmc_clkd_status,

  //tbd1
  //tbd2
  //tbd3

  // Bank 3.3 V
  output      [13:0]      dac_db,
  output                  dac_sleep,

  output                  clkd_spi_sclk,
  output                  clkd_spi_csb,
  inout                   clkd_spi_sdio,
  //clkd_status,
  output                  clkd_syncn,
  output                  clkd_resetn);

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
