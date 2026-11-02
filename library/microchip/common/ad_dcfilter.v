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
// dc filter - y(n) = c*x(n) + (1-c)*y(n-1)
//
// The DC estimate y is the P register of the MACC_PA (y = P[32:17], c is
// dcfilt_coeff / 2^17), updated each clock cycle from its own value:
//
//   P = C + (B - D) * A
//     = P + (data_d - P[32:17]) * dcfilt_coeff_d
//
// The P register is held in reset while the filter is disabled, so the
// estimate starts from 0 when it is enabled.

`timescale 1ps/1ps

module ad_dcfilter #(

  parameter   DISABLE = 0
) (

  input               clk,
  input               valid,
  input       [15:0]  data,
  output              valid_out,
  output      [15:0]  data_out,

  input               dcfilt_enb,
  input       [15:0]  dcfilt_coeff,
  input       [15:0]  dcfilt_offset
);

  reg     [15:0]  dcfilt_coeff_d = 16'd0;
  reg             valid_d = 1'b0;
  reg     [15:0]  data_d = 16'd0;
  reg             valid_2d = 1'b0;
  reg     [15:0]  data_2d = 16'd0;
  reg     [15:0]  data_dcfilt = 16'd0;
  reg             valid_int = 1'b0;
  reg     [15:0]  data_int = 16'd0;

  wire    [47:0]  dc_offset_s;
  wire    [17:0]  macc_a;
  wire    [17:0]  macc_b;
  wire    [17:0]  macc_d;

  // sign-extend the 16-bit operands to the 18-bit MACC_PA ports
  assign macc_a = {{2{dcfilt_coeff_d[15]}}, dcfilt_coeff_d};
  assign macc_b = {{2{data_d[15]}},         data_d};
  assign macc_d = {{2{dc_offset_s[32]}},    dc_offset_s[32:17]};

  assign valid_out = (DISABLE == 1) ? valid : valid_int;
  assign data_out  = (DISABLE == 1) ? data  : data_int;

  always @(posedge clk) begin
    dcfilt_coeff_d <= dcfilt_coeff;

    valid_d <= valid;
    if (valid == 1'b1) begin
      data_d <= data + dcfilt_offset;
    end
    valid_2d    <= valid_d;
    data_2d     <= data_d;
    data_dcfilt <= data_d - dc_offset_s[32:17];

    valid_int <= valid_2d;
    if (dcfilt_enb == 1'b1) begin
      data_int <= data_dcfilt;
    end else begin
      data_int <= data_2d;
    end
  end

  MACC_PA i_macc (
    .CLK                  (clk),
    .AL_N                 (1'b1),

    // multiplier operand A
    .A                    (macc_a),
    .A_EN                 (1'b1),
    .A_SRST_N             (1'b1),
    .A_BYPASS             (1'b1),

    // pre-adder minuend B
    .B                    (macc_b),
    .B_EN                 (1'b1),
    .B_SRST_N             (1'b1),
    .B_BYPASS             (1'b1),

    // accumulator addend C = P
    .C                    (dc_offset_s),
    .C_ARST_N             (1'b1),
    .C_EN                 (1'b1),
    .C_SRST_N             (1'b1),
    .C_BYPASS             (1'b1),

    .CARRYIN              (1'b0),

    // pre-adder subtrahend D = P[32:17]
    .D                    (macc_d),
    .D_ARST_N             (1'b1),
    .D_EN                 (1'b1),
    .D_SRST_N             (1'b1),
    .D_BYPASS             (1'b1),

    // P register: drives dc_offset_s, in reset while the filter is disabled
    .P_EN                 (1'b1),
    .P_SRST_N             (dcfilt_enb),
    .P_BYPASS             (1'b0),

    // cascade input - unused
    .CDIN                 (48'd0),

    // pre-adder subtract: f = B - D
    .PASUB                (1'b1),
    .PASUB_EN             (1'b0),
    .PASUB_SL_N           (1'b1),
    .PASUB_AD_N           (1'b1),
    .PASUB_SD_N           (1'b1),
    .PASUB_BYPASS         (1'b1),

    // accumulator addend select: e = 0, use C only (no internal feedback,
    // no CDIN); C is the P register itself
    .CDIN_FDBK_SEL        (2'b00),
    .CDIN_FDBK_SEL_EN     (1'b0),
    .CDIN_FDBK_SEL_SL_N   (1'b1),
    .CDIN_FDBK_SEL_AD_N   (2'b11),
    .CDIN_FDBK_SEL_SD_N   (2'b11),
    .CDIN_FDBK_SEL_BYPASS (1'b1),

    // no arithmetic right-shift
    .ARSHFT17             (1'b0),
    .ARSHFT17_EN          (1'b0),
    .ARSHFT17_SL_N        (1'b1),
    .ARSHFT17_AD_N        (1'b1),
    .ARSHFT17_SD_N        (1'b1),
    .ARSHFT17_BYPASS      (1'b1),

    // accumulator add (not subtract)
    .SUB                  (1'b0),
    .SUB_EN               (1'b0),
    .SUB_SL_N             (1'b1),
    .SUB_AD_N             (1'b1),
    .SUB_SD_N             (1'b1),
    .SUB_BYPASS           (1'b1),

    // single 48-bit mode (no SIMD, no dot-product)
    .SIMD                 (1'b0),
    .DOTP                 (1'b0),
    .OVFL_CARRYOUT_SEL    (1'b0),

    .OVFL_CARRYOUT        (),
    .P                    (dc_offset_s),
    .CDOUT                ()
  );

endmodule
