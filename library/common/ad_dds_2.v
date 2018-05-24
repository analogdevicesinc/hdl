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

module ad_dds #(

  // Disable DDS
  parameter   DISABLE = 0,
  // Range = 8-24
  parameter   DDS_DW = 16,
  // Set 1 for CORDIC or 2 for Polynomial
  parameter   DDS_TYPE = 1,
  // Range = 8-24
  parameter   CORDIC_DW = 16,
  // Range = 8-24 ( make sure CORDIC_PHASE_DW < CORDIC_DW)
  parameter   CORDIC_PHASE_DW = 16) (

  // interface

  input                 clk,
  input                 dds_format,
  input   [      15:0]  dds_phase_0,
  input   [      15:0]  dds_scale_0,
  input   [      15:0]  dds_phase_1,
  input   [      15:0]  dds_scale_1,
  output  [DDS_DW-1:0]  dds_data);

 // Local parameters

 localparam CORDIC = 1;
 localparam POLYNOMIAL = 2;

 // The width for Polynomial DDS is fixed (16)
 localparam DDS_D_DW = (DDS_TYPE == CORDIC) ? CORDIC_DW : 16;
 localparam DDS_P_DW = (DDS_TYPE == CORDIC) ? CORDIC_PHASE_DW : 16;
 // concatenation or truncation width
 localparam C_T_WIDTH = (DDS_D_DW > DDS_DW) ? (DDS_D_DW - DDS_DW) : (DDS_DW - DDS_D_DW);

  // internal registers

  reg     [  DDS_DW-1:0]  dds_data_width = 0;
  reg     [DDS_D_DW-1:0]  dds_data_rownd = 0;
  reg     [DDS_D_DW-1:0]  dds_data_int = 0;
  reg     [        15:0]  dds_scale_0_d = 0;
  reg     [        15:0]  dds_scale_1_d = 0;
  reg     [  DDS_DW-1:0]  dds_data_out = 0;

  // internal signals

  wire    [15:0]  dds_data_0_s;
  wire    [15:0]  dds_data_1_s;

  // disable DDS
  generate
    if (DISABLE == 1) begin
      // assign 0 for the exact buss width to avoid warnings
      assign dds_data = {DDS_DW{1'b0}};
    end else begin

      // dds channel output
      assign dds_data = dds_data_out;

      // output data format
      always @(posedge clk) begin
        dds_data_out[DDS_DW-1] <= dds_data_width[DDS_DW-1] ^ dds_format;
        dds_data_out[DDS_DW-2: 0] <= dds_data_width[DDS_DW-2: 0];
      end

      // set desired data width
      always @(posedge clk) begin
        if (DDS_DW <= DDS_D_DW) begin // truncation
          // fair rownding
          dds_data_rownd <= dds_data_int + {(C_T_WIDTH){dds_data_int[DDS_D_DW-1]}};
          dds_data_width <= dds_data_rownd[DDS_D_DW-1:DDS_D_DW-DDS_DW];
        end else begin // concatenation
          dds_data_width <= dds_data_int << C_T_WIDTH;
        end
      end

      // dual tone
      always @(posedge clk) begin
        dds_data_int <= dds_data_0_s + dds_data_1_s;
      end

       always @(posedge clk) begin
         dds_scale_0_d <= dds_scale_0;
         dds_scale_1_d <= dds_scale_1;
       end

       // dds-1

       ad_dds_1 #(
         .DDS_TYPE(DDS_TYPE),
         .CORDIC_DW(CORDIC_DW),
         .CORDIC_PHASE_DW(CORDIC_PHASE_DW))
       i_dds_1_0 (
         .clk (clk),
         .angle (dds_phase_0),
         .scale (dds_scale_0_d),
         .dds_data (dds_data_0_s));

       // dds-2

       ad_dds_1 #(
         .DDS_TYPE(DDS_TYPE),
         .CORDIC_DW(CORDIC_DW),
         .CORDIC_PHASE_DW(CORDIC_PHASE_DW))
       i_dds_1_1 (
         .clk (clk),
         .angle (dds_phase_1),
         .scale (dds_scale_1_d),
         .dds_data (dds_data_1_s));
    end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
