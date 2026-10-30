// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

// Join FIFO with separate ports for 1 to 64 channels, for block designs.
// The ports above NUM_CHANNELS are unused. See ad_sample_join_fifo.

`timescale 1ns/100ps

module util_sample_join_fifo #(
  parameter NUM_CHANNELS = 2,
  parameter DATA_WIDTH = 32,
  parameter ADDRESS_WIDTH = 4,
  parameter XFER_REQ_ENABLE = 0,
  parameter OVERFLOW_XFER_REQ = 0,
  parameter CHANNEL_ENABLE_XFER_HOLD = 0
) (
  input                       async_resetn,
  input                       xfer_req,

  input                       clk_0,
  input                       reset_0,
  input                       valid_0,
  input      [DATA_WIDTH-1:0] data_0,
  input                       enable_0,
  output                      overflow_0,

  input                       clk_1,
  input                       reset_1,
  input                       valid_1,
  input      [DATA_WIDTH-1:0] data_1,
  input                       enable_1,
  output                      overflow_1,

  input                       clk_2,
  input                       reset_2,
  input                       valid_2,
  input      [DATA_WIDTH-1:0] data_2,
  input                       enable_2,
  output                      overflow_2,

  input                       clk_3,
  input                       reset_3,
  input                       valid_3,
  input      [DATA_WIDTH-1:0] data_3,
  input                       enable_3,
  output                      overflow_3,

  input                       clk_4,
  input                       reset_4,
  input                       valid_4,
  input      [DATA_WIDTH-1:0] data_4,
  input                       enable_4,
  output                      overflow_4,

  input                       clk_5,
  input                       reset_5,
  input                       valid_5,
  input      [DATA_WIDTH-1:0] data_5,
  input                       enable_5,
  output                      overflow_5,

  input                       clk_6,
  input                       reset_6,
  input                       valid_6,
  input      [DATA_WIDTH-1:0] data_6,
  input                       enable_6,
  output                      overflow_6,

  input                       clk_7,
  input                       reset_7,
  input                       valid_7,
  input      [DATA_WIDTH-1:0] data_7,
  input                       enable_7,
  output                      overflow_7,

  input                       clk_8,
  input                       reset_8,
  input                       valid_8,
  input      [DATA_WIDTH-1:0] data_8,
  input                       enable_8,
  output                      overflow_8,

  input                       clk_9,
  input                       reset_9,
  input                       valid_9,
  input      [DATA_WIDTH-1:0] data_9,
  input                       enable_9,
  output                      overflow_9,

  input                       clk_10,
  input                       reset_10,
  input                       valid_10,
  input      [DATA_WIDTH-1:0] data_10,
  input                       enable_10,
  output                      overflow_10,

  input                       clk_11,
  input                       reset_11,
  input                       valid_11,
  input      [DATA_WIDTH-1:0] data_11,
  input                       enable_11,
  output                      overflow_11,

  input                       clk_12,
  input                       reset_12,
  input                       valid_12,
  input      [DATA_WIDTH-1:0] data_12,
  input                       enable_12,
  output                      overflow_12,

  input                       clk_13,
  input                       reset_13,
  input                       valid_13,
  input      [DATA_WIDTH-1:0] data_13,
  input                       enable_13,
  output                      overflow_13,

  input                       clk_14,
  input                       reset_14,
  input                       valid_14,
  input      [DATA_WIDTH-1:0] data_14,
  input                       enable_14,
  output                      overflow_14,

  input                       clk_15,
  input                       reset_15,
  input                       valid_15,
  input      [DATA_WIDTH-1:0] data_15,
  input                       enable_15,
  output                      overflow_15,

  input                       clk_16,
  input                       reset_16,
  input                       valid_16,
  input      [DATA_WIDTH-1:0] data_16,
  input                       enable_16,
  output                      overflow_16,

  input                       clk_17,
  input                       reset_17,
  input                       valid_17,
  input      [DATA_WIDTH-1:0] data_17,
  input                       enable_17,
  output                      overflow_17,

  input                       clk_18,
  input                       reset_18,
  input                       valid_18,
  input      [DATA_WIDTH-1:0] data_18,
  input                       enable_18,
  output                      overflow_18,

  input                       clk_19,
  input                       reset_19,
  input                       valid_19,
  input      [DATA_WIDTH-1:0] data_19,
  input                       enable_19,
  output                      overflow_19,

  input                       clk_20,
  input                       reset_20,
  input                       valid_20,
  input      [DATA_WIDTH-1:0] data_20,
  input                       enable_20,
  output                      overflow_20,

  input                       clk_21,
  input                       reset_21,
  input                       valid_21,
  input      [DATA_WIDTH-1:0] data_21,
  input                       enable_21,
  output                      overflow_21,

  input                       clk_22,
  input                       reset_22,
  input                       valid_22,
  input      [DATA_WIDTH-1:0] data_22,
  input                       enable_22,
  output                      overflow_22,

  input                       clk_23,
  input                       reset_23,
  input                       valid_23,
  input      [DATA_WIDTH-1:0] data_23,
  input                       enable_23,
  output                      overflow_23,

  input                       clk_24,
  input                       reset_24,
  input                       valid_24,
  input      [DATA_WIDTH-1:0] data_24,
  input                       enable_24,
  output                      overflow_24,

  input                       clk_25,
  input                       reset_25,
  input                       valid_25,
  input      [DATA_WIDTH-1:0] data_25,
  input                       enable_25,
  output                      overflow_25,

  input                       clk_26,
  input                       reset_26,
  input                       valid_26,
  input      [DATA_WIDTH-1:0] data_26,
  input                       enable_26,
  output                      overflow_26,

  input                       clk_27,
  input                       reset_27,
  input                       valid_27,
  input      [DATA_WIDTH-1:0] data_27,
  input                       enable_27,
  output                      overflow_27,

  input                       clk_28,
  input                       reset_28,
  input                       valid_28,
  input      [DATA_WIDTH-1:0] data_28,
  input                       enable_28,
  output                      overflow_28,

  input                       clk_29,
  input                       reset_29,
  input                       valid_29,
  input      [DATA_WIDTH-1:0] data_29,
  input                       enable_29,
  output                      overflow_29,

  input                       clk_30,
  input                       reset_30,
  input                       valid_30,
  input      [DATA_WIDTH-1:0] data_30,
  input                       enable_30,
  output                      overflow_30,

  input                       clk_31,
  input                       reset_31,
  input                       valid_31,
  input      [DATA_WIDTH-1:0] data_31,
  input                       enable_31,
  output                      overflow_31,

  input                       clk_32,
  input                       reset_32,
  input                       valid_32,
  input      [DATA_WIDTH-1:0] data_32,
  input                       enable_32,
  output                      overflow_32,

  input                       clk_33,
  input                       reset_33,
  input                       valid_33,
  input      [DATA_WIDTH-1:0] data_33,
  input                       enable_33,
  output                      overflow_33,

  input                       clk_34,
  input                       reset_34,
  input                       valid_34,
  input      [DATA_WIDTH-1:0] data_34,
  input                       enable_34,
  output                      overflow_34,

  input                       clk_35,
  input                       reset_35,
  input                       valid_35,
  input      [DATA_WIDTH-1:0] data_35,
  input                       enable_35,
  output                      overflow_35,

  input                       clk_36,
  input                       reset_36,
  input                       valid_36,
  input      [DATA_WIDTH-1:0] data_36,
  input                       enable_36,
  output                      overflow_36,

  input                       clk_37,
  input                       reset_37,
  input                       valid_37,
  input      [DATA_WIDTH-1:0] data_37,
  input                       enable_37,
  output                      overflow_37,

  input                       clk_38,
  input                       reset_38,
  input                       valid_38,
  input      [DATA_WIDTH-1:0] data_38,
  input                       enable_38,
  output                      overflow_38,

  input                       clk_39,
  input                       reset_39,
  input                       valid_39,
  input      [DATA_WIDTH-1:0] data_39,
  input                       enable_39,
  output                      overflow_39,

  input                       clk_40,
  input                       reset_40,
  input                       valid_40,
  input      [DATA_WIDTH-1:0] data_40,
  input                       enable_40,
  output                      overflow_40,

  input                       clk_41,
  input                       reset_41,
  input                       valid_41,
  input      [DATA_WIDTH-1:0] data_41,
  input                       enable_41,
  output                      overflow_41,

  input                       clk_42,
  input                       reset_42,
  input                       valid_42,
  input      [DATA_WIDTH-1:0] data_42,
  input                       enable_42,
  output                      overflow_42,

  input                       clk_43,
  input                       reset_43,
  input                       valid_43,
  input      [DATA_WIDTH-1:0] data_43,
  input                       enable_43,
  output                      overflow_43,

  input                       clk_44,
  input                       reset_44,
  input                       valid_44,
  input      [DATA_WIDTH-1:0] data_44,
  input                       enable_44,
  output                      overflow_44,

  input                       clk_45,
  input                       reset_45,
  input                       valid_45,
  input      [DATA_WIDTH-1:0] data_45,
  input                       enable_45,
  output                      overflow_45,

  input                       clk_46,
  input                       reset_46,
  input                       valid_46,
  input      [DATA_WIDTH-1:0] data_46,
  input                       enable_46,
  output                      overflow_46,

  input                       clk_47,
  input                       reset_47,
  input                       valid_47,
  input      [DATA_WIDTH-1:0] data_47,
  input                       enable_47,
  output                      overflow_47,

  input                       clk_48,
  input                       reset_48,
  input                       valid_48,
  input      [DATA_WIDTH-1:0] data_48,
  input                       enable_48,
  output                      overflow_48,

  input                       clk_49,
  input                       reset_49,
  input                       valid_49,
  input      [DATA_WIDTH-1:0] data_49,
  input                       enable_49,
  output                      overflow_49,

  input                       clk_50,
  input                       reset_50,
  input                       valid_50,
  input      [DATA_WIDTH-1:0] data_50,
  input                       enable_50,
  output                      overflow_50,

  input                       clk_51,
  input                       reset_51,
  input                       valid_51,
  input      [DATA_WIDTH-1:0] data_51,
  input                       enable_51,
  output                      overflow_51,

  input                       clk_52,
  input                       reset_52,
  input                       valid_52,
  input      [DATA_WIDTH-1:0] data_52,
  input                       enable_52,
  output                      overflow_52,

  input                       clk_53,
  input                       reset_53,
  input                       valid_53,
  input      [DATA_WIDTH-1:0] data_53,
  input                       enable_53,
  output                      overflow_53,

  input                       clk_54,
  input                       reset_54,
  input                       valid_54,
  input      [DATA_WIDTH-1:0] data_54,
  input                       enable_54,
  output                      overflow_54,

  input                       clk_55,
  input                       reset_55,
  input                       valid_55,
  input      [DATA_WIDTH-1:0] data_55,
  input                       enable_55,
  output                      overflow_55,

  input                       clk_56,
  input                       reset_56,
  input                       valid_56,
  input      [DATA_WIDTH-1:0] data_56,
  input                       enable_56,
  output                      overflow_56,

  input                       clk_57,
  input                       reset_57,
  input                       valid_57,
  input      [DATA_WIDTH-1:0] data_57,
  input                       enable_57,
  output                      overflow_57,

  input                       clk_58,
  input                       reset_58,
  input                       valid_58,
  input      [DATA_WIDTH-1:0] data_58,
  input                       enable_58,
  output                      overflow_58,

  input                       clk_59,
  input                       reset_59,
  input                       valid_59,
  input      [DATA_WIDTH-1:0] data_59,
  input                       enable_59,
  output                      overflow_59,

  input                       clk_60,
  input                       reset_60,
  input                       valid_60,
  input      [DATA_WIDTH-1:0] data_60,
  input                       enable_60,
  output                      overflow_60,

  input                       clk_61,
  input                       reset_61,
  input                       valid_61,
  input      [DATA_WIDTH-1:0] data_61,
  input                       enable_61,
  output                      overflow_61,

  input                       clk_62,
  input                       reset_62,
  input                       valid_62,
  input      [DATA_WIDTH-1:0] data_62,
  input                       enable_62,
  output                      overflow_62,

  input                       clk_63,
  input                       reset_63,
  input                       valid_63,
  input      [DATA_WIDTH-1:0] data_63,
  input                       enable_63,
  output                      overflow_63,

  input                       out_clk,
  output                      out_reset,
  output                      out_valid,
  output     [DATA_WIDTH-1:0] out_data_0,
  output                      out_enable_0,
  output     [DATA_WIDTH-1:0] out_data_1,
  output                      out_enable_1,
  output     [DATA_WIDTH-1:0] out_data_2,
  output                      out_enable_2,
  output     [DATA_WIDTH-1:0] out_data_3,
  output                      out_enable_3,
  output     [DATA_WIDTH-1:0] out_data_4,
  output                      out_enable_4,
  output     [DATA_WIDTH-1:0] out_data_5,
  output                      out_enable_5,
  output     [DATA_WIDTH-1:0] out_data_6,
  output                      out_enable_6,
  output     [DATA_WIDTH-1:0] out_data_7,
  output                      out_enable_7,
  output     [DATA_WIDTH-1:0] out_data_8,
  output                      out_enable_8,
  output     [DATA_WIDTH-1:0] out_data_9,
  output                      out_enable_9,
  output     [DATA_WIDTH-1:0] out_data_10,
  output                      out_enable_10,
  output     [DATA_WIDTH-1:0] out_data_11,
  output                      out_enable_11,
  output     [DATA_WIDTH-1:0] out_data_12,
  output                      out_enable_12,
  output     [DATA_WIDTH-1:0] out_data_13,
  output                      out_enable_13,
  output     [DATA_WIDTH-1:0] out_data_14,
  output                      out_enable_14,
  output     [DATA_WIDTH-1:0] out_data_15,
  output                      out_enable_15,
  output     [DATA_WIDTH-1:0] out_data_16,
  output                      out_enable_16,
  output     [DATA_WIDTH-1:0] out_data_17,
  output                      out_enable_17,
  output     [DATA_WIDTH-1:0] out_data_18,
  output                      out_enable_18,
  output     [DATA_WIDTH-1:0] out_data_19,
  output                      out_enable_19,
  output     [DATA_WIDTH-1:0] out_data_20,
  output                      out_enable_20,
  output     [DATA_WIDTH-1:0] out_data_21,
  output                      out_enable_21,
  output     [DATA_WIDTH-1:0] out_data_22,
  output                      out_enable_22,
  output     [DATA_WIDTH-1:0] out_data_23,
  output                      out_enable_23,
  output     [DATA_WIDTH-1:0] out_data_24,
  output                      out_enable_24,
  output     [DATA_WIDTH-1:0] out_data_25,
  output                      out_enable_25,
  output     [DATA_WIDTH-1:0] out_data_26,
  output                      out_enable_26,
  output     [DATA_WIDTH-1:0] out_data_27,
  output                      out_enable_27,
  output     [DATA_WIDTH-1:0] out_data_28,
  output                      out_enable_28,
  output     [DATA_WIDTH-1:0] out_data_29,
  output                      out_enable_29,
  output     [DATA_WIDTH-1:0] out_data_30,
  output                      out_enable_30,
  output     [DATA_WIDTH-1:0] out_data_31,
  output                      out_enable_31,
  output     [DATA_WIDTH-1:0] out_data_32,
  output                      out_enable_32,
  output     [DATA_WIDTH-1:0] out_data_33,
  output                      out_enable_33,
  output     [DATA_WIDTH-1:0] out_data_34,
  output                      out_enable_34,
  output     [DATA_WIDTH-1:0] out_data_35,
  output                      out_enable_35,
  output     [DATA_WIDTH-1:0] out_data_36,
  output                      out_enable_36,
  output     [DATA_WIDTH-1:0] out_data_37,
  output                      out_enable_37,
  output     [DATA_WIDTH-1:0] out_data_38,
  output                      out_enable_38,
  output     [DATA_WIDTH-1:0] out_data_39,
  output                      out_enable_39,
  output     [DATA_WIDTH-1:0] out_data_40,
  output                      out_enable_40,
  output     [DATA_WIDTH-1:0] out_data_41,
  output                      out_enable_41,
  output     [DATA_WIDTH-1:0] out_data_42,
  output                      out_enable_42,
  output     [DATA_WIDTH-1:0] out_data_43,
  output                      out_enable_43,
  output     [DATA_WIDTH-1:0] out_data_44,
  output                      out_enable_44,
  output     [DATA_WIDTH-1:0] out_data_45,
  output                      out_enable_45,
  output     [DATA_WIDTH-1:0] out_data_46,
  output                      out_enable_46,
  output     [DATA_WIDTH-1:0] out_data_47,
  output                      out_enable_47,
  output     [DATA_WIDTH-1:0] out_data_48,
  output                      out_enable_48,
  output     [DATA_WIDTH-1:0] out_data_49,
  output                      out_enable_49,
  output     [DATA_WIDTH-1:0] out_data_50,
  output                      out_enable_50,
  output     [DATA_WIDTH-1:0] out_data_51,
  output                      out_enable_51,
  output     [DATA_WIDTH-1:0] out_data_52,
  output                      out_enable_52,
  output     [DATA_WIDTH-1:0] out_data_53,
  output                      out_enable_53,
  output     [DATA_WIDTH-1:0] out_data_54,
  output                      out_enable_54,
  output     [DATA_WIDTH-1:0] out_data_55,
  output                      out_enable_55,
  output     [DATA_WIDTH-1:0] out_data_56,
  output                      out_enable_56,
  output     [DATA_WIDTH-1:0] out_data_57,
  output                      out_enable_57,
  output     [DATA_WIDTH-1:0] out_data_58,
  output                      out_enable_58,
  output     [DATA_WIDTH-1:0] out_data_59,
  output                      out_enable_59,
  output     [DATA_WIDTH-1:0] out_data_60,
  output                      out_enable_60,
  output     [DATA_WIDTH-1:0] out_data_61,
  output                      out_enable_61,
  output     [DATA_WIDTH-1:0] out_data_62,
  output                      out_enable_62,
  output     [DATA_WIDTH-1:0] out_data_63,
  output                      out_enable_63,
  input                       out_overflow
);

  localparam MAX_CHANNELS = 64;
  localparam N  = NUM_CHANNELS;
  localparam DW = DATA_WIDTH;

  wire [MAX_CHANNELS-1:0]    clk_s;
  wire [MAX_CHANNELS-1:0]    reset_s;
  wire [MAX_CHANNELS-1:0]    valid_s;
  wire [MAX_CHANNELS*DW-1:0] data_s;
  wire [MAX_CHANNELS-1:0]    enable_s;
  wire [MAX_CHANNELS*DW-1:0] out_data_s;
  wire [MAX_CHANNELS-1:0]    overflow_s;
  wire [MAX_CHANNELS-1:0]    out_enable_s;

  assign clk_s = {clk_63, clk_62, clk_61, clk_60, clk_59, clk_58, clk_57, clk_56,
                  clk_55, clk_54, clk_53, clk_52, clk_51, clk_50, clk_49, clk_48,
                  clk_47, clk_46, clk_45, clk_44, clk_43, clk_42, clk_41, clk_40,
                  clk_39, clk_38, clk_37, clk_36, clk_35, clk_34, clk_33, clk_32,
                  clk_31, clk_30, clk_29, clk_28, clk_27, clk_26, clk_25, clk_24,
                  clk_23, clk_22, clk_21, clk_20, clk_19, clk_18, clk_17, clk_16,
                  clk_15, clk_14, clk_13, clk_12, clk_11, clk_10, clk_9, clk_8,
                  clk_7, clk_6, clk_5, clk_4, clk_3, clk_2, clk_1, clk_0};

  assign reset_s = {reset_63, reset_62, reset_61, reset_60, reset_59, reset_58, reset_57, reset_56,
                    reset_55, reset_54, reset_53, reset_52, reset_51, reset_50, reset_49, reset_48,
                    reset_47, reset_46, reset_45, reset_44, reset_43, reset_42, reset_41, reset_40,
                    reset_39, reset_38, reset_37, reset_36, reset_35, reset_34, reset_33, reset_32,
                    reset_31, reset_30, reset_29, reset_28, reset_27, reset_26, reset_25, reset_24,
                    reset_23, reset_22, reset_21, reset_20, reset_19, reset_18, reset_17, reset_16,
                    reset_15, reset_14, reset_13, reset_12, reset_11, reset_10, reset_9, reset_8,
                    reset_7, reset_6, reset_5, reset_4, reset_3, reset_2, reset_1, reset_0};

  assign valid_s = {valid_63, valid_62, valid_61, valid_60, valid_59, valid_58, valid_57, valid_56,
                    valid_55, valid_54, valid_53, valid_52, valid_51, valid_50, valid_49, valid_48,
                    valid_47, valid_46, valid_45, valid_44, valid_43, valid_42, valid_41, valid_40,
                    valid_39, valid_38, valid_37, valid_36, valid_35, valid_34, valid_33, valid_32,
                    valid_31, valid_30, valid_29, valid_28, valid_27, valid_26, valid_25, valid_24,
                    valid_23, valid_22, valid_21, valid_20, valid_19, valid_18, valid_17, valid_16,
                    valid_15, valid_14, valid_13, valid_12, valid_11, valid_10, valid_9, valid_8,
                    valid_7, valid_6, valid_5, valid_4, valid_3, valid_2, valid_1, valid_0};

  assign data_s = {data_63, data_62, data_61, data_60, data_59, data_58, data_57, data_56,
                   data_55, data_54, data_53, data_52, data_51, data_50, data_49, data_48,
                   data_47, data_46, data_45, data_44, data_43, data_42, data_41, data_40,
                   data_39, data_38, data_37, data_36, data_35, data_34, data_33, data_32,
                   data_31, data_30, data_29, data_28, data_27, data_26, data_25, data_24,
                   data_23, data_22, data_21, data_20, data_19, data_18, data_17, data_16,
                   data_15, data_14, data_13, data_12, data_11, data_10, data_9, data_8,
                   data_7, data_6, data_5, data_4, data_3, data_2, data_1, data_0};

  assign enable_s = {enable_63, enable_62, enable_61, enable_60, enable_59, enable_58, enable_57, enable_56,
                     enable_55, enable_54, enable_53, enable_52, enable_51, enable_50, enable_49, enable_48,
                     enable_47, enable_46, enable_45, enable_44, enable_43, enable_42, enable_41, enable_40,
                     enable_39, enable_38, enable_37, enable_36, enable_35, enable_34, enable_33, enable_32,
                     enable_31, enable_30, enable_29, enable_28, enable_27, enable_26, enable_25, enable_24,
                     enable_23, enable_22, enable_21, enable_20, enable_19, enable_18, enable_17, enable_16,
                     enable_15, enable_14, enable_13, enable_12, enable_11, enable_10, enable_9, enable_8,
                     enable_7, enable_6, enable_5, enable_4, enable_3, enable_2, enable_1, enable_0};

  generate
  if (N < MAX_CHANNELS) begin : g_unused
    assign out_data_s[MAX_CHANNELS*DW-1:N*DW] = 'd0;
    assign overflow_s[MAX_CHANNELS-1:N] = 'd0;
    assign out_enable_s[MAX_CHANNELS-1:N] = 'd0;
  end
  endgenerate

  assign {out_data_63, out_data_62, out_data_61, out_data_60, out_data_59, out_data_58, out_data_57, out_data_56,
          out_data_55, out_data_54, out_data_53, out_data_52, out_data_51, out_data_50, out_data_49, out_data_48,
          out_data_47, out_data_46, out_data_45, out_data_44, out_data_43, out_data_42, out_data_41, out_data_40,
          out_data_39, out_data_38, out_data_37, out_data_36, out_data_35, out_data_34, out_data_33, out_data_32,
          out_data_31, out_data_30, out_data_29, out_data_28, out_data_27, out_data_26, out_data_25, out_data_24,
          out_data_23, out_data_22, out_data_21, out_data_20, out_data_19, out_data_18, out_data_17, out_data_16,
          out_data_15, out_data_14, out_data_13, out_data_12, out_data_11, out_data_10, out_data_9, out_data_8,
          out_data_7, out_data_6, out_data_5, out_data_4, out_data_3, out_data_2, out_data_1, out_data_0} = out_data_s;

  assign {overflow_63, overflow_62, overflow_61, overflow_60, overflow_59, overflow_58, overflow_57, overflow_56,
          overflow_55, overflow_54, overflow_53, overflow_52, overflow_51, overflow_50, overflow_49, overflow_48,
          overflow_47, overflow_46, overflow_45, overflow_44, overflow_43, overflow_42, overflow_41, overflow_40,
          overflow_39, overflow_38, overflow_37, overflow_36, overflow_35, overflow_34, overflow_33, overflow_32,
          overflow_31, overflow_30, overflow_29, overflow_28, overflow_27, overflow_26, overflow_25, overflow_24,
          overflow_23, overflow_22, overflow_21, overflow_20, overflow_19, overflow_18, overflow_17, overflow_16,
          overflow_15, overflow_14, overflow_13, overflow_12, overflow_11, overflow_10, overflow_9, overflow_8,
          overflow_7, overflow_6, overflow_5, overflow_4, overflow_3, overflow_2, overflow_1, overflow_0} = overflow_s;

  assign {out_enable_63, out_enable_62, out_enable_61, out_enable_60, out_enable_59, out_enable_58, out_enable_57, out_enable_56,
          out_enable_55, out_enable_54, out_enable_53, out_enable_52, out_enable_51, out_enable_50, out_enable_49, out_enable_48,
          out_enable_47, out_enable_46, out_enable_45, out_enable_44, out_enable_43, out_enable_42, out_enable_41, out_enable_40,
          out_enable_39, out_enable_38, out_enable_37, out_enable_36, out_enable_35, out_enable_34, out_enable_33, out_enable_32,
          out_enable_31, out_enable_30, out_enable_29, out_enable_28, out_enable_27, out_enable_26, out_enable_25, out_enable_24,
          out_enable_23, out_enable_22, out_enable_21, out_enable_20, out_enable_19, out_enable_18, out_enable_17, out_enable_16,
          out_enable_15, out_enable_14, out_enable_13, out_enable_12, out_enable_11, out_enable_10, out_enable_9, out_enable_8,
          out_enable_7, out_enable_6, out_enable_5, out_enable_4, out_enable_3, out_enable_2, out_enable_1, out_enable_0} = out_enable_s;

  ad_sample_join_fifo #(
    .NUM_CHANNELS(N),
    .DATA_WIDTH(DW),
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .XFER_REQ_ENABLE(XFER_REQ_ENABLE),
    .OVERFLOW_XFER_REQ(OVERFLOW_XFER_REQ),
    .CHANNEL_ENABLE_XFER_HOLD(CHANNEL_ENABLE_XFER_HOLD)
  ) i_join (
    .async_resetn(async_resetn),
    .xfer_req(xfer_req),
    .clk(clk_s[N-1:0]),
    .reset(reset_s[N-1:0]),
    .valid(valid_s[N-1:0]),
    .data(data_s[N*DW-1:0]),
    .enable(enable_s[N-1:0]),
    .overflow(overflow_s[N-1:0]),
    .out_clk(out_clk),
    .out_reset(out_reset),
    .out_valid(out_valid),
    .out_data(out_data_s[N*DW-1:0]),
    .out_enable(out_enable_s[N-1:0]),
    .out_overflow(out_overflow));

endmodule
