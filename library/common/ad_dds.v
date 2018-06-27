// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
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

// single channel dds (dual tone)
module ad_dds #(

  parameter DISABLE = 0,
  // range 8-24
  parameter DDS_DW = 16,
  // range 8-16 (FIX ME)
  parameter PHASE_DW = 16,
  // set 1 for CORDIC or 2 for Polynomial
  parameter DDS_TYPE = 1,
  // range 8-24
  parameter CORDIC_DW = 16,
  // range 8-24 (make sure CORDIC_PHASE_DW < CORDIC_DW)
  parameter CORDIC_PHASE_DW = 16,
  // the clock radtio between the device clock(sample rate) and the dac_core clock
  // 2^N, 1<N<6
  parameter CLK_RATIO = 1) (

  // interface

  input                               clk,
  input                               dac_dds_format,
  input                               dac_data_sync,
  input                               dac_valid,
  input       [                15:0]  tone_1_scale,
  input       [                15:0]  tone_2_scale,
  input       [                15:0]  tone_1_init_offset,
  input       [                15:0]  tone_2_init_offset,
  input       [        PHASE_DW-1:0]  tone_1_freq_word,
  input       [        PHASE_DW-1:0]  tone_2_freq_word,
  output  reg [DDS_DW*CLK_RATIO-1:0]  dac_dds_data
  );

  wire [DDS_DW*CLK_RATIO-1:0] dac_dds_data_s;

  always @(posedge clk) begin
    dac_dds_data <= dac_dds_data_s;
  end

  genvar i;
  generate

    if (DISABLE == 1) begin
      assign dac_dds_data_s = {(DDS_DW*CLK_RATIO-1){1'b0}};
    end else begin

      // enable dds

      reg  [PHASE_DW-1:0]  dac_dds_phase_0[1:CLK_RATIO];
      reg  [PHASE_DW-1:0]  dac_dds_phase_1[1:CLK_RATIO];
      reg  [PHASE_DW-1:0]  dac_dds_incr_0 = 'd0;
      reg  [PHASE_DW-1:0]  dac_dds_incr_1 = 'd0;

      always @(posedge clk) begin
        dac_dds_incr_0 <= tone_1_freq_word * CLK_RATIO;
        dac_dds_incr_1 <= tone_2_freq_word * CLK_RATIO;
      end

      //  phase accumulator
      for (i=1; i <= CLK_RATIO; i=i+1) begin: dds_phase
        always @(posedge clk) begin
          if (dac_data_sync == 1'b1) begin
            if (i == 1) begin
              dac_dds_phase_0[1] <= tone_1_init_offset;
              dac_dds_phase_1[1] <= tone_2_init_offset;
            end else if (CLK_RATIO > 1)begin
              dac_dds_phase_0[i] <= dac_dds_phase_0[i-1] + tone_1_freq_word;
              dac_dds_phase_1[i] <= dac_dds_phase_1[i-1] + tone_2_freq_word;
            end
          end else if (dac_valid == 1'b1) begin
            dac_dds_phase_0[i] <= dac_dds_phase_0[i] + dac_dds_incr_0;
            dac_dds_phase_1[i] <= dac_dds_phase_1[i] + dac_dds_incr_1;
          end
        end

        // phase to amplitude convertor
         ad_dds_2 #(
           .DDS_DW (DDS_DW),
           .PHASE_DW (PHASE_DW),
           .DDS_TYPE (DDS_TYPE),
           .CORDIC_DW (CORDIC_DW),
           .CORDIC_PHASE_DW (CORDIC_PHASE_DW))
         i_dds_2 (
          .clk (clk),
          .dds_format (dac_dds_format),
          .dds_phase_0 (dac_dds_phase_0[i]),
          .dds_scale_0 (tone_1_scale),
          .dds_phase_1 (dac_dds_phase_1[i]),
          .dds_scale_1 (tone_2_scale),
          .dds_data (dac_dds_data_s[(DDS_DW*i)-1:DDS_DW*(i-1)]));
      end
    end
  endgenerate

endmodule
