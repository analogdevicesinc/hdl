// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module axi_fsrc_tx #(
  parameter NUM_OF_CHANNELS = 4,
  parameter SAMPLES_PER_CHANNEL = 1,
  parameter SAMPLE_DATA_WIDTH = 16,
  parameter ACCUM_WIDTH = 64
) (
  input clk,
  input reset,
  input start,

  input data_in_valid,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_0,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_1,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_2,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_3,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_4,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_5,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_6,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_7,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_8,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_9,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_10,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_11,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_12,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_13,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_14,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_15,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_16,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_17,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_18,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_19,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_20,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_21,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_22,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_23,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_24,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_25,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_26,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_27,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_28,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_29,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_30,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_31,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_32,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_33,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_34,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_35,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_36,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_37,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_38,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_39,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_40,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_41,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_42,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_43,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_44,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_45,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_46,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_47,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_48,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_49,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_50,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_51,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_52,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_53,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_54,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_55,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_56,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_57,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_58,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_59,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_60,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_61,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_62,
  input [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_in_63,

  output reg data_out_valid,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_0,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_1,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_2,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_3,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_4,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_5,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_6,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_7,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_8,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_9,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_10,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_11,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_12,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_13,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_14,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_15,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_16,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_17,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_18,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_19,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_20,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_21,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_22,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_23,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_24,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_25,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_26,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_27,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_28,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_29,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_30,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_31,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_32,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_33,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_34,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_35,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_36,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_37,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_38,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_39,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_40,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_41,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_42,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_43,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_44,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_45,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_46,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_47,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_48,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_49,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_50,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_51,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_52,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_53,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_54,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_55,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_56,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_57,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_58,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_59,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_60,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_61,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_62,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] data_out_63,

  // axi interface
  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready
);

  localparam [31:0] CORE_VERSION = {16'h0000,     /* MAJOR */
                                     8'h01,       /* MINOR */
                                     8'h00};      /* PATCH */
  localparam [31:0] CORE_MAGIC = 32'h504c5347;    // FSRC

  localparam CHANNEL_WIDTH = SAMPLES_PER_CHANNEL * SAMPLE_DATA_WIDTH;
  localparam NUM_SAMPLES = NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL;

  wire data_out_valid_s;
  wire [CHANNEL_WIDTH*NUM_OF_CHANNELS-1:0] in_data;
  wire [CHANNEL_WIDTH*NUM_OF_CHANNELS-1:0] out_data;
  wire [CHANNEL_WIDTH*64-1:0] data_in_s;
  wire [CHANNEL_WIDTH*64-1:0] data_out_s;

  reg [CHANNEL_WIDTH*NUM_OF_CHANNELS-1:0] out_data_reg;


  // internal signals

  wire        up_clk;
  wire        up_rstn;
  wire        up_rreq_s;
  wire        up_wack_s;
  wire        up_rack_s;
  wire [13:0] up_raddr_s;
  wire [31:0] up_rdata_s;
  wire        up_wreq_s;
  wire [13:0] up_waddr_s;
  wire [31:0] up_wdata_s;

  wire        enable;
  wire        ext_trig_en;
  wire        stop;
  wire        reg_start_s;
  wire        start_s;
  wire        accum_set;
  wire [15:0] conv_mask;
  wire [31:0] debug_flags;
  wire [ACCUM_WIDTH-1:0] accum_add_val;
  wire [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0] accum_set_val;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  axi_fsrc_tx_regmap #(
    .ID (0),
    .CORE_VERSION (CORE_VERSION),
    .CORE_MAGIC (CORE_MAGIC),
    .ACCUM_WIDTH (ACCUM_WIDTH),
    .NUM_SAMPLES(NUM_SAMPLES)
  ) i_regmap (
    .clk (clk),
    .reset (reset),
    .enable (enable),
    .ext_trig_en (ext_trig_en),
    .start (reg_start_s),
    .stop (stop),
    .change_rate (),
    .accum_set (accum_set),
    .conv_mask (conv_mask),
    .accum_add_val (accum_add_val),
    .accum_set_val (accum_set_val),
    .debug_flags (debug_flags),

    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  tx_fsrc #(
    .NUM_OF_CHANNELS (NUM_OF_CHANNELS),
    .SAMPLE_DATA_WIDTH (SAMPLE_DATA_WIDTH),
    .DATA_WIDTH (NUM_OF_CHANNELS * CHANNEL_WIDTH),
    .ACCUM_WIDTH (ACCUM_WIDTH),
    .NUM_SAMPLES (NUM_SAMPLES)
  ) i_tx_fsrc (
    .clk (clk),
    .reset (reset),

    .debug_flags (debug_flags),

    .enable (enable),
    .start (start_s),
    .stop (stop),
    .conv_mask (conv_mask),
    .accum_set_val (accum_set_val),
    .accum_set (accum_set),
    .accum_add_val (accum_add_val),

    .in_ready (),
    .in_data (in_data),
    .in_valid (data_in_valid),

    .out_data (out_data),
    .out_valid (data_out_valid_s),
    .out_ready (1'b1));

  always @(posedge clk) begin
    out_data_reg <= out_data;
    data_out_valid <= data_out_valid_s;
  end

  assign start_s = (start & ext_trig_en) | reg_start_s;

  assign in_data = data_in_s[CHANNEL_WIDTH*NUM_OF_CHANNELS-1:0];
  assign data_out_s = {{(64-NUM_OF_CHANNELS)*CHANNEL_WIDTH{1'b0}}, out_data_reg};

  assign data_in_s[CHANNEL_WIDTH*0+:CHANNEL_WIDTH] = data_in_0;
  assign data_in_s[CHANNEL_WIDTH*1+:CHANNEL_WIDTH] = data_in_1;
  assign data_in_s[CHANNEL_WIDTH*2+:CHANNEL_WIDTH] = data_in_2;
  assign data_in_s[CHANNEL_WIDTH*3+:CHANNEL_WIDTH] = data_in_3;
  assign data_in_s[CHANNEL_WIDTH*4+:CHANNEL_WIDTH] = data_in_4;
  assign data_in_s[CHANNEL_WIDTH*5+:CHANNEL_WIDTH] = data_in_5;
  assign data_in_s[CHANNEL_WIDTH*6+:CHANNEL_WIDTH] = data_in_6;
  assign data_in_s[CHANNEL_WIDTH*7+:CHANNEL_WIDTH] = data_in_7;
  assign data_in_s[CHANNEL_WIDTH*8+:CHANNEL_WIDTH] = data_in_8;
  assign data_in_s[CHANNEL_WIDTH*9+:CHANNEL_WIDTH] = data_in_9;
  assign data_in_s[CHANNEL_WIDTH*10+:CHANNEL_WIDTH] = data_in_10;
  assign data_in_s[CHANNEL_WIDTH*11+:CHANNEL_WIDTH] = data_in_11;
  assign data_in_s[CHANNEL_WIDTH*12+:CHANNEL_WIDTH] = data_in_12;
  assign data_in_s[CHANNEL_WIDTH*13+:CHANNEL_WIDTH] = data_in_13;
  assign data_in_s[CHANNEL_WIDTH*14+:CHANNEL_WIDTH] = data_in_14;
  assign data_in_s[CHANNEL_WIDTH*15+:CHANNEL_WIDTH] = data_in_15;
  assign data_in_s[CHANNEL_WIDTH*16+:CHANNEL_WIDTH] = data_in_16;
  assign data_in_s[CHANNEL_WIDTH*17+:CHANNEL_WIDTH] = data_in_17;
  assign data_in_s[CHANNEL_WIDTH*18+:CHANNEL_WIDTH] = data_in_18;
  assign data_in_s[CHANNEL_WIDTH*19+:CHANNEL_WIDTH] = data_in_19;
  assign data_in_s[CHANNEL_WIDTH*20+:CHANNEL_WIDTH] = data_in_20;
  assign data_in_s[CHANNEL_WIDTH*21+:CHANNEL_WIDTH] = data_in_21;
  assign data_in_s[CHANNEL_WIDTH*22+:CHANNEL_WIDTH] = data_in_22;
  assign data_in_s[CHANNEL_WIDTH*23+:CHANNEL_WIDTH] = data_in_23;
  assign data_in_s[CHANNEL_WIDTH*24+:CHANNEL_WIDTH] = data_in_24;
  assign data_in_s[CHANNEL_WIDTH*25+:CHANNEL_WIDTH] = data_in_25;
  assign data_in_s[CHANNEL_WIDTH*26+:CHANNEL_WIDTH] = data_in_26;
  assign data_in_s[CHANNEL_WIDTH*27+:CHANNEL_WIDTH] = data_in_27;
  assign data_in_s[CHANNEL_WIDTH*28+:CHANNEL_WIDTH] = data_in_28;
  assign data_in_s[CHANNEL_WIDTH*29+:CHANNEL_WIDTH] = data_in_29;
  assign data_in_s[CHANNEL_WIDTH*30+:CHANNEL_WIDTH] = data_in_30;
  assign data_in_s[CHANNEL_WIDTH*31+:CHANNEL_WIDTH] = data_in_31;
  assign data_in_s[CHANNEL_WIDTH*32+:CHANNEL_WIDTH] = data_in_32;
  assign data_in_s[CHANNEL_WIDTH*33+:CHANNEL_WIDTH] = data_in_33;
  assign data_in_s[CHANNEL_WIDTH*34+:CHANNEL_WIDTH] = data_in_34;
  assign data_in_s[CHANNEL_WIDTH*35+:CHANNEL_WIDTH] = data_in_35;
  assign data_in_s[CHANNEL_WIDTH*36+:CHANNEL_WIDTH] = data_in_36;
  assign data_in_s[CHANNEL_WIDTH*37+:CHANNEL_WIDTH] = data_in_37;
  assign data_in_s[CHANNEL_WIDTH*38+:CHANNEL_WIDTH] = data_in_38;
  assign data_in_s[CHANNEL_WIDTH*39+:CHANNEL_WIDTH] = data_in_39;
  assign data_in_s[CHANNEL_WIDTH*40+:CHANNEL_WIDTH] = data_in_40;
  assign data_in_s[CHANNEL_WIDTH*41+:CHANNEL_WIDTH] = data_in_41;
  assign data_in_s[CHANNEL_WIDTH*42+:CHANNEL_WIDTH] = data_in_42;
  assign data_in_s[CHANNEL_WIDTH*43+:CHANNEL_WIDTH] = data_in_43;
  assign data_in_s[CHANNEL_WIDTH*44+:CHANNEL_WIDTH] = data_in_44;
  assign data_in_s[CHANNEL_WIDTH*45+:CHANNEL_WIDTH] = data_in_45;
  assign data_in_s[CHANNEL_WIDTH*46+:CHANNEL_WIDTH] = data_in_46;
  assign data_in_s[CHANNEL_WIDTH*47+:CHANNEL_WIDTH] = data_in_47;
  assign data_in_s[CHANNEL_WIDTH*48+:CHANNEL_WIDTH] = data_in_48;
  assign data_in_s[CHANNEL_WIDTH*49+:CHANNEL_WIDTH] = data_in_49;
  assign data_in_s[CHANNEL_WIDTH*50+:CHANNEL_WIDTH] = data_in_50;
  assign data_in_s[CHANNEL_WIDTH*51+:CHANNEL_WIDTH] = data_in_51;
  assign data_in_s[CHANNEL_WIDTH*52+:CHANNEL_WIDTH] = data_in_52;
  assign data_in_s[CHANNEL_WIDTH*53+:CHANNEL_WIDTH] = data_in_53;
  assign data_in_s[CHANNEL_WIDTH*54+:CHANNEL_WIDTH] = data_in_54;
  assign data_in_s[CHANNEL_WIDTH*55+:CHANNEL_WIDTH] = data_in_55;
  assign data_in_s[CHANNEL_WIDTH*56+:CHANNEL_WIDTH] = data_in_56;
  assign data_in_s[CHANNEL_WIDTH*57+:CHANNEL_WIDTH] = data_in_57;
  assign data_in_s[CHANNEL_WIDTH*58+:CHANNEL_WIDTH] = data_in_58;
  assign data_in_s[CHANNEL_WIDTH*59+:CHANNEL_WIDTH] = data_in_59;
  assign data_in_s[CHANNEL_WIDTH*60+:CHANNEL_WIDTH] = data_in_60;
  assign data_in_s[CHANNEL_WIDTH*61+:CHANNEL_WIDTH] = data_in_61;
  assign data_in_s[CHANNEL_WIDTH*62+:CHANNEL_WIDTH] = data_in_62;
  assign data_in_s[CHANNEL_WIDTH*63+:CHANNEL_WIDTH] = data_in_63;

  assign data_out_0 = data_out_s[CHANNEL_WIDTH*0+:CHANNEL_WIDTH];
  assign data_out_1 = data_out_s[CHANNEL_WIDTH*1+:CHANNEL_WIDTH];
  assign data_out_2 = data_out_s[CHANNEL_WIDTH*2+:CHANNEL_WIDTH];
  assign data_out_3 = data_out_s[CHANNEL_WIDTH*3+:CHANNEL_WIDTH];
  assign data_out_4 = data_out_s[CHANNEL_WIDTH*4+:CHANNEL_WIDTH];
  assign data_out_5 = data_out_s[CHANNEL_WIDTH*5+:CHANNEL_WIDTH];
  assign data_out_6 = data_out_s[CHANNEL_WIDTH*6+:CHANNEL_WIDTH];
  assign data_out_7 = data_out_s[CHANNEL_WIDTH*7+:CHANNEL_WIDTH];
  assign data_out_8 = data_out_s[CHANNEL_WIDTH*8+:CHANNEL_WIDTH];
  assign data_out_9 = data_out_s[CHANNEL_WIDTH*9+:CHANNEL_WIDTH];
  assign data_out_10 = data_out_s[CHANNEL_WIDTH*10+:CHANNEL_WIDTH];
  assign data_out_11 = data_out_s[CHANNEL_WIDTH*11+:CHANNEL_WIDTH];
  assign data_out_12 = data_out_s[CHANNEL_WIDTH*12+:CHANNEL_WIDTH];
  assign data_out_13 = data_out_s[CHANNEL_WIDTH*13+:CHANNEL_WIDTH];
  assign data_out_14 = data_out_s[CHANNEL_WIDTH*14+:CHANNEL_WIDTH];
  assign data_out_15 = data_out_s[CHANNEL_WIDTH*15+:CHANNEL_WIDTH];
  assign data_out_16 = data_out_s[CHANNEL_WIDTH*16+:CHANNEL_WIDTH];
  assign data_out_17 = data_out_s[CHANNEL_WIDTH*17+:CHANNEL_WIDTH];
  assign data_out_18 = data_out_s[CHANNEL_WIDTH*18+:CHANNEL_WIDTH];
  assign data_out_19 = data_out_s[CHANNEL_WIDTH*19+:CHANNEL_WIDTH];
  assign data_out_20 = data_out_s[CHANNEL_WIDTH*20+:CHANNEL_WIDTH];
  assign data_out_21 = data_out_s[CHANNEL_WIDTH*21+:CHANNEL_WIDTH];
  assign data_out_22 = data_out_s[CHANNEL_WIDTH*22+:CHANNEL_WIDTH];
  assign data_out_23 = data_out_s[CHANNEL_WIDTH*23+:CHANNEL_WIDTH];
  assign data_out_24 = data_out_s[CHANNEL_WIDTH*24+:CHANNEL_WIDTH];
  assign data_out_25 = data_out_s[CHANNEL_WIDTH*25+:CHANNEL_WIDTH];
  assign data_out_26 = data_out_s[CHANNEL_WIDTH*26+:CHANNEL_WIDTH];
  assign data_out_27 = data_out_s[CHANNEL_WIDTH*27+:CHANNEL_WIDTH];
  assign data_out_28 = data_out_s[CHANNEL_WIDTH*28+:CHANNEL_WIDTH];
  assign data_out_29 = data_out_s[CHANNEL_WIDTH*29+:CHANNEL_WIDTH];
  assign data_out_30 = data_out_s[CHANNEL_WIDTH*30+:CHANNEL_WIDTH];
  assign data_out_31 = data_out_s[CHANNEL_WIDTH*31+:CHANNEL_WIDTH];
  assign data_out_32 = data_out_s[CHANNEL_WIDTH*32+:CHANNEL_WIDTH];
  assign data_out_33 = data_out_s[CHANNEL_WIDTH*33+:CHANNEL_WIDTH];
  assign data_out_34 = data_out_s[CHANNEL_WIDTH*34+:CHANNEL_WIDTH];
  assign data_out_35 = data_out_s[CHANNEL_WIDTH*35+:CHANNEL_WIDTH];
  assign data_out_36 = data_out_s[CHANNEL_WIDTH*36+:CHANNEL_WIDTH];
  assign data_out_37 = data_out_s[CHANNEL_WIDTH*37+:CHANNEL_WIDTH];
  assign data_out_38 = data_out_s[CHANNEL_WIDTH*38+:CHANNEL_WIDTH];
  assign data_out_39 = data_out_s[CHANNEL_WIDTH*39+:CHANNEL_WIDTH];
  assign data_out_40 = data_out_s[CHANNEL_WIDTH*40+:CHANNEL_WIDTH];
  assign data_out_41 = data_out_s[CHANNEL_WIDTH*41+:CHANNEL_WIDTH];
  assign data_out_42 = data_out_s[CHANNEL_WIDTH*42+:CHANNEL_WIDTH];
  assign data_out_43 = data_out_s[CHANNEL_WIDTH*43+:CHANNEL_WIDTH];
  assign data_out_44 = data_out_s[CHANNEL_WIDTH*44+:CHANNEL_WIDTH];
  assign data_out_45 = data_out_s[CHANNEL_WIDTH*45+:CHANNEL_WIDTH];
  assign data_out_46 = data_out_s[CHANNEL_WIDTH*46+:CHANNEL_WIDTH];
  assign data_out_47 = data_out_s[CHANNEL_WIDTH*47+:CHANNEL_WIDTH];
  assign data_out_48 = data_out_s[CHANNEL_WIDTH*48+:CHANNEL_WIDTH];
  assign data_out_49 = data_out_s[CHANNEL_WIDTH*49+:CHANNEL_WIDTH];
  assign data_out_50 = data_out_s[CHANNEL_WIDTH*50+:CHANNEL_WIDTH];
  assign data_out_51 = data_out_s[CHANNEL_WIDTH*51+:CHANNEL_WIDTH];
  assign data_out_52 = data_out_s[CHANNEL_WIDTH*52+:CHANNEL_WIDTH];
  assign data_out_53 = data_out_s[CHANNEL_WIDTH*53+:CHANNEL_WIDTH];
  assign data_out_54 = data_out_s[CHANNEL_WIDTH*54+:CHANNEL_WIDTH];
  assign data_out_55 = data_out_s[CHANNEL_WIDTH*55+:CHANNEL_WIDTH];
  assign data_out_56 = data_out_s[CHANNEL_WIDTH*56+:CHANNEL_WIDTH];
  assign data_out_57 = data_out_s[CHANNEL_WIDTH*57+:CHANNEL_WIDTH];
  assign data_out_58 = data_out_s[CHANNEL_WIDTH*58+:CHANNEL_WIDTH];
  assign data_out_59 = data_out_s[CHANNEL_WIDTH*59+:CHANNEL_WIDTH];
  assign data_out_60 = data_out_s[CHANNEL_WIDTH*60+:CHANNEL_WIDTH];
  assign data_out_61 = data_out_s[CHANNEL_WIDTH*61+:CHANNEL_WIDTH];
  assign data_out_62 = data_out_s[CHANNEL_WIDTH*62+:CHANNEL_WIDTH];
  assign data_out_63 = data_out_s[CHANNEL_WIDTH*63+:CHANNEL_WIDTH];

endmodule
