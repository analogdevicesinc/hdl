// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2024 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_dac_interpolate_reg(

  input               clk,

  output      [31:0]  dac_interpolation_ratio_a,
  output      [ 2:0]  dac_filter_mask_a,
  output      [31:0]  dac_interpolation_ratio_b,
  output      [ 2:0]  dac_filter_mask_b,
  output              dma_transfer_suspend,
  output              flush_dma_out,
  output      [ 1:0]  raw_transfer_en,
  output      [15:0]  dac_raw_ch_a_data,
  output      [15:0]  dac_raw_ch_b_data,
  output              start_sync_channels,
  output              stop_sync_channels,
  output              dac_correction_enable_a,
  output              dac_correction_enable_b,
  output      [15:0]  dac_correction_coefficient_a,
  output      [15:0]  dac_correction_coefficient_b,
  output      [20:0]  trigger_config,
 // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [ 4:0]  up_waddr,
  input       [31:0]  up_wdata,
  output reg          up_wack,
  input               up_rreq,
  input       [ 4:0]  up_raddr,
  output reg  [31:0]  up_rdata,
  output reg          up_rack
);

  // internal registers

  reg     [31:0]  up_version = {16'h0002,     /* MAJOR */
                                 8'h05,       /* MINOR */
                                 8'h00};      /* PATCH */
  reg     [31:0]  up_scratch = 32'h0;

  reg     [31:0]  up_interpolation_ratio_a = 32'h0;
  reg     [ 2:0]  up_filter_mask_a = 3'h0;
  reg     [31:0]  up_interpolation_ratio_b = 32'h0;
  reg     [ 2:0]  up_filter_mask_b = 3'h0;
  reg     [ 5:0]  up_flags = 6'ha;
  reg     [ 1:0]  up_config = 2'h0;
  reg     [15:0]  up_correction_coefficient_a = 16'h0;
  reg     [15:0]  up_correction_coefficient_b = 16'h0;
  reg     [20:0]  up_trigger_config = 21'h0;
  reg     [15:0]  up_dac_raw_ch_a_data;
  reg     [15:0]  up_dac_raw_ch_b_data;

  wire    [ 5:0]  flags;

  assign  dma_transfer_suspend = flags[0];
  assign  start_sync_channels = flags[1];
  assign  stop_sync_channels = flags[2];
  assign  flush_dma_out = flags[3];
  assign  raw_transfer_en = flags[5:4]; //5-b; 4-a

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_interpolation_ratio_a <= 'd0;
      up_filter_mask_a <= 'd0;
      up_interpolation_ratio_b <= 'd0;
      up_filter_mask_b <= 'd0;
      up_flags <= 'ha;
      up_config <= 'd0;
      up_correction_coefficient_a <= 'd0;
      up_correction_coefficient_b <= 'd0;
      up_trigger_config <= 'd0;
      up_dac_raw_ch_a_data <= 16'd0;
      up_dac_raw_ch_b_data <= 16'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h10)) begin
        up_interpolation_ratio_a <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h11)) begin
        up_filter_mask_a <= up_wdata[2:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h12)) begin
        up_interpolation_ratio_b <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h13)) begin
        up_filter_mask_b <= up_wdata[2:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h14)) begin
        up_flags <= up_wdata[5:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h15)) begin
        up_config <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h16)) begin
        up_correction_coefficient_a <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h17)) begin
        up_correction_coefficient_b <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h18)) begin
        up_trigger_config <= up_wdata[20:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h19)) begin
        up_dac_raw_ch_a_data <= up_wdata[15:0];
        up_dac_raw_ch_b_data <= up_wdata[31:16];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr[4:0])
          5'h0: up_rdata  <= up_version;
          5'h1: up_rdata  <= up_scratch;
          5'h10: up_rdata <= up_interpolation_ratio_a;
          5'h11: up_rdata <= {29'h0,up_filter_mask_a};
          5'h12: up_rdata <= up_interpolation_ratio_b;
          5'h13: up_rdata <= {29'h0,up_filter_mask_b};
          5'h14: up_rdata <= {26'h0,up_flags};
          5'h15: up_rdata <= {30'h0,up_config};
          5'h16: up_rdata <= {16'h0,up_correction_coefficient_a};
          5'h17: up_rdata <= {16'h0,up_correction_coefficient_b};
          5'h18: up_rdata <= {11'h0,up_trigger_config};
          5'h19: up_rdata <= {up_dac_raw_ch_b_data, up_dac_raw_ch_a_data};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  up_xfer_cntrl #(
    .DATA_WIDTH(163)
  ) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_config[1],               // 1
                      up_config[0],               // 1
                      up_correction_coefficient_b,// 16
                      up_correction_coefficient_a,// 16
                      up_trigger_config,          // 21
                      up_flags,                   //  6
                      up_dac_raw_ch_a_data,       // 16
                      up_dac_raw_ch_b_data,       // 16
                      up_interpolation_ratio_b,   // 32
                      up_interpolation_ratio_a,   // 32
                      up_filter_mask_b,           // 3
                      up_filter_mask_a}),         // 3

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_cntrl ({  dac_correction_enable_b,      // 1
                      dac_correction_enable_a,      // 1
                      dac_correction_coefficient_b, // 16
                      dac_correction_coefficient_a, // 16
                      trigger_config,               // 21
                      flags,                        // 6
                      dac_raw_ch_a_data,            // 16
                      dac_raw_ch_b_data,            // 16
                      dac_interpolation_ratio_b,    // 32
                      dac_interpolation_ratio_a,    // 32
                      dac_filter_mask_b,            // 3
                      dac_filter_mask_a}));         // 3

endmodule
