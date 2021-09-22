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

`timescale 1ns/100ps

module ad_data_out #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   SINGLE_ENDED = 0,
  parameter   IODELAY_ENABLE = 0,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group",
  parameter   REFCLK_FREQUENCY = 200) (

  // data interface

  input               tx_clk,
  input               tx_data_p,
  input               tx_data_n,
  output              tx_data_out_p,
  output              tx_data_out_n,

  // delay-data interface

  input               up_clk,
  input               up_dld,
  input       [ 4:0]  up_dwdata,
  output      [ 4:0]  up_drdata,

  // delay-cntrl interface

  input               delay_clk,
  input               delay_rst,
  output              delay_locked);

  // internal parameters
  
  // local parameters

  localparam CYCLONE5 = 101;
  localparam ARRIA10  = 103;
  
  // defaults
  
  assign locked = 1'b1;

  // instantiations

  generate
  if (FPGA_TECHNOLOGY == CYCLONE5) begin
    //don't have one to test .. altddio_out
    assign rx_data_p = 0;
    assign rx_data_n = 0;
    assign up_drdata = 0;
    assign delay_locked = 0;
  end
  endgenerate
  
  generate
  if (FPGA_TECHNOLOGY == ARRIA10) begin
    wire s_oddr_o;

    reg rp_tx_data_p;
    reg rp_tx_data_n;
    
//     reg rn_tx_data_p;
//     reg rn_tx_data_n;
    
    reg r_delay_locked;
    reg [4:0] r_up_dwdata = 'd0;
    
    assign delay_locked = 1'b1;
    
    assign up_drdata = r_up_dwdata;
    
    always @(posedge up_clk) begin
      if(up_dld == 1'b1) begin
        r_up_dwdata <= up_dwdata;
      end
    end
    
//     always @(negedge tx_clk) begin
//       rn_tx_data_p <= tx_data_p;
//       rn_tx_data_n <= tx_data_n;
//     end;
    
    always @(posedge tx_clk) begin
      rp_tx_data_p <= tx_data_p;
      rp_tx_data_n <= tx_data_n;
    end;
    
    twentynm_ddio_out #(
      .half_rate_mode("false"),
      .async_mode("none"),
      .sync_mode("none")) 
    oddr (
      .ena(1'b1),
      .areset(1'b0),
      .sreset(1'b0),
      .datainhi(rp_tx_data_p),
      .datainlo(rp_tx_data_n),
      .dataout(s_oddr_o),
      .clk (tx_clk));
      
    if (SINGLE_ENDED == 1) begin
      assign tx_data_out_n = 1'b0;
      
      twentynm_io_obuf #(
        .differential_mode("false"),
        .bus_hold("false")) 
      obuf (
        .i(s_oddr_o),
        .o(tx_data_out_p));  
    end else begin
      twentynm_io_obuf #(
        .differential_mode("true"),
        .bus_hold("false")) 
      obuf (
        .i(s_oddr_o),
        .o(tx_data_out_p),
        .obar(tx_data_out_n));  
    end
  end
  endgenerate
endmodule

// ***************************************************************************
// ***************************************************************************
