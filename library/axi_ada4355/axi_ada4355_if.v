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

`timescale 1ns/100ps

module axi_ada4355_if #(
  parameter FPGA_TECHNOLOGY = 1,
  parameter IO_DELAY_GROUP = "adc_if_delay_group",
  parameter IODELAY_CTRL = 1,
  parameter DRP_WIDTH = 5,
  parameter NUM_LANES = 3,  // 2 lanes of data, 1 frame
  parameter FPGA_FAMILY = 1,
  parameter BUFMRCE_EN = 0
) (

  // device interface
  input dco_p,
  input dco_n,
  input d0a_p,
  input d0a_n,
  input d1a_p,
  input d1a_n,
  input fco_p,
  input fco_n,
  input sync_n,
  input aresetn,

  // delay interface(for IDELAY macros)
  input                              up_clk,
  input  [NUM_LANES-1:0]             up_adc_dld,
  input  [(DRP_WIDTH*NUM_LANES)-1:0] up_adc_dwdata,
  output [(DRP_WIDTH*NUM_LANES)-1:0] up_adc_drdata,
  input                              delay_clk,
  input                              delay_rst,
  output                             delay_locked,

  // frame
  output                             delay_locked_frame,

  // internal reset and clocks
  input                              adc_rst,
  output                             adc_clk,

  // Output data
  output [15:0]                      adc_data,
  output                             adc_valid,
  output                             adc_pn_err,
  input  [ 2:0]                      enable_error
);

  // Use always DDR mode for SERDES, useful for SDR mode to adjust capture
  localparam        DDR_OR_SDR_N = 1;
  localparam        CMOS_LVDS_N  = 0; // Use always LVDS mode

  localparam [ 2:0] INIT = 3'h0,
                    CNT_UPDATE = 3'h1,
                    FRAME_SHIFTED = 3'h2,
                    RESET = 3'h3;
  localparam [ 7:0] pattern_value = 8'hF0;
  localparam [15:0] expected_pattern_lane_0 = 16'h5554;
  localparam [15:0] expected_pattern_lane_1 = 16'hAAA8;
  localparam [15:0] lane_0_mask = 16'h5555;
  localparam [15:0] lane_1_mask = 16'hAAAA;

  wire                 clk_in_s;
  wire                 out_ibufmrce_clock;
  wire                 adc_clk_in_fast;
  wire                 adc_clk_in_fast_frame;
  wire                 adc_clk_div;
  wire                 adc_clk_div_frame;
  wire [ 7:0]          data_0;
  wire [ 7:0]          data_1;
  wire [NUM_LANES-2:0] data_in_p;
  wire [NUM_LANES-2:0] data_in_n;

  wire [NUM_LANES-2:0] data_s0;
  wire [NUM_LANES-2:0] data_s1;
  wire [NUM_LANES-2:0] data_s2;
  wire [NUM_LANES-2:0] data_s3;
  wire [NUM_LANES-2:0] data_s4;
  wire [NUM_LANES-2:0] data_s5;
  wire [NUM_LANES-2:0] data_s6;
  wire [NUM_LANES-2:0] data_s7;

  wire frame_s0;
  wire frame_s1;
  wire frame_s2;
  wire frame_s3;
  wire frame_s4;
  wire frame_s5;
  wire frame_s6;
  wire frame_s7;

  reg [ 9:0] serdes_reset = 10'b0000000110;
  reg [ 1:0] serdes_valid = 2'b00;
  reg [ 1:0] serdes_valid_d = 2'b00;
  reg [ 2:0] shift_cnt = 3'h0;
  reg [ 4:0] delay = 5'h0;
  reg [15:0] serdes_data;
  reg [15:0] serdes_data_d;
  reg [ 7:0] serdes_frame;
  reg [ 7:0] serdes_frame_d;
  reg [15:0] adc_data_shifted;
  reg [ 7:0] frame_shifted;
  reg [ 2:0] reg_test;
  reg        bufr_alignment;
  reg        bufr_alignment_bufr;
  reg [ 2:0] state = 3'h0;
  reg        frame_err_r;
  reg        data_err_lane_0_r;
  reg        data_err_lane_1_r;
  reg [15:0] test_pattern;

  IBUFGDS i_clk_in_ibuf(
    .I(dco_p),
    .IB(dco_n),
    .O(clk_in_s));

  generate
  if(FPGA_TECHNOLOGY == FPGA_FAMILY) begin
    if (BUFMRCE_EN == 0) begin
      BUFIO i_clk_buf (
        .I(clk_in_s),
        .O(adc_clk_in_fast));

    assign adc_clk_in_fast_frame = adc_clk_in_fast;

      BUFR #(
        .BUFR_DIVIDE("4")
      ) i_div_clk_buf (
        .CLR(1'b0),
        .CE(1'b1),
        .I(clk_in_s),
        .O(adc_clk_div));

    assign adc_clk_div_frame = adc_clk_div;

    end else begin
      BUFMRCE i_bufmrce (
        .I(clk_in_s),
        .O(out_ibufmrce_clock),
        .CE(bufr_alignment));

      BUFIO i_clk_buf(
        .I(out_ibufmrce_clock),
        .O(adc_clk_in_fast));

      BUFIO i_clk_buf_frame(
        .I(out_ibufmrce_clock),
        .O(adc_clk_in_fast_frame));

      BUFR #(
        .BUFR_DIVIDE("4")
      ) i_div_clk_buf (
        .CLR(bufr_alignment_bufr),
        .CE(1'b1),
        .I(out_ibufmrce_clock),
        .O(adc_clk_div));

      BUFR #(
        .BUFR_DIVIDE("4")
      ) i_div_clk_buf_frame (
        .CLR(bufr_alignment_bufr),
        .CE(1'b1),
        .I(out_ibufmrce_clock),
        .O(adc_clk_div_frame));
    end
  end
  endgenerate

  //serdes for data

  ad_serdes_in #(
    .CMOS_LVDS_N(CMOS_LVDS_N),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_CTRL(IODELAY_CTRL),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(DDR_OR_SDR_N),
    .DATA_WIDTH(NUM_LANES-1),
    .DRP_WIDTH(DRP_WIDTH),
    .SERDES_FACTOR(8),
    .EXT_SERDES_RESET(1)
  ) i_serdes(
    .rst(serdes_reset_s),
    .ext_serdes_rst(serdes_reset_s),
    .clk(adc_clk_in_fast),
    .div_clk(adc_clk_div),
    .data_s0(data_s0),
    .data_s1(data_s1),
    .data_s2(data_s2),
    .data_s3(data_s3),
    .data_s4(data_s4),
    .data_s5(data_s5),
    .data_s6(data_s6),
    .data_s7(data_s7),
    .data_in_p(data_in_p),
    .data_in_n(data_in_n),
    .up_clk(up_clk),
    .up_dld(up_adc_dld[1:0]),
    .up_dwdata(up_adc_dwdata[(DRP_WIDTH*(NUM_LANES-1))-1:0]),
    .up_drdata(up_adc_drdata[(DRP_WIDTH*(NUM_LANES-1))-1:0]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked));

  // serdes for frame

  ad_serdes_in #(
    .CMOS_LVDS_N(CMOS_LVDS_N),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_CTRL(0),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(DDR_OR_SDR_N),
    .DATA_WIDTH(1),
    .DRP_WIDTH(DRP_WIDTH),
    .SERDES_FACTOR(8),
    .EXT_SERDES_RESET(1)
  ) i_serdes_frame(
    .rst(serdes_reset_s),
    .ext_serdes_rst(serdes_reset_s),
    .clk(adc_clk_in_fast_frame),
    .div_clk(adc_clk_div_frame),
    .data_s0(frame_s0),
    .data_s1(frame_s1),
    .data_s2(frame_s2),
    .data_s3(frame_s3),
    .data_s4(frame_s4),
    .data_s5(frame_s5),
    .data_s6(frame_s6),
    .data_s7(frame_s7),
    .data_in_p(fco_p),
    .data_in_n(fco_n),
    .up_clk(up_clk),
    .up_dld(up_adc_dld[2]),
    .up_dwdata(up_adc_dwdata[((DRP_WIDTH*NUM_LANES)-1):(DRP_WIDTH*(NUM_LANES-1))]),
    .up_drdata(up_adc_drdata[((DRP_WIDTH*NUM_LANES)-1):(DRP_WIDTH*(NUM_LANES-1))]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked_frame));

  always @(posedge adc_clk_div or negedge sync_n) begin
    if(~sync_n) begin
      serdes_reset <= 10'b0000000110;
    end else begin
      serdes_reset <= {serdes_reset[8:0],1'b0};
    end
  end

  assign serdes_reset_s = serdes_reset[5];
  assign serdes_reset_d = serdes_reset[9];

  // Assert serdes valid after 2 clock cycles is pulled out of reset

  always @(posedge adc_clk_div) begin
    if(serdes_reset_s) begin
      serdes_valid <= 2'b00;
    end else begin
      serdes_valid <= {serdes_valid[0],1'b1};
    end
  end

  always @(posedge clk_in_s or negedge aresetn) begin
    if (aresetn == 0) begin
      // reset condition
      bufr_alignment <= 1'b0;
      bufr_alignment_bufr <= 1'b1;
    end else begin
      if (bufr_alignment) begin
        bufr_alignment_bufr <=0 ;
      end
      bufr_alignment <= 1'b1;
    end
  end

  assign adc_clk = adc_clk_div;
  assign adc_pn_err = ((data_err_lane_0_r & enable_error[0]) | (data_err_lane_1_r & enable_error[1]) |
                       (frame_err_r & enable_error[2]));

  assign data_in_p = {d1a_p, d0a_p};
  assign data_in_n = {d1a_n, d0a_n};

  assign {data_1[0],data_0[0]} = data_s0;  // f-e latest bit received
  assign {data_1[1],data_0[1]} = data_s1;  // r-e
  assign {data_1[2],data_0[2]} = data_s2;  // f-e
  assign {data_1[3],data_0[3]} = data_s3;  // r-e
  assign {data_1[4],data_0[4]} = data_s4;  // f-e
  assign {data_1[5],data_0[5]} = data_s5;  // r-e
  assign {data_1[6],data_0[6]} = data_s6;  // f-e
  assign {data_1[7],data_0[7]} = data_s7;  // r-e oldest bit received

  // For DDR dual lane interleave the two sedres outputs;

  always @(posedge adc_clk_div) begin
    serdes_data = {data_1[7],
                   data_0[7],
                   data_1[6],
                   data_0[6],
                   data_1[5],
                   data_0[5],
                   data_1[4],
                   data_0[4],
                   data_1[3],
                   data_0[3],
                   data_1[2],
                   data_0[2],
                   data_1[1],
                   data_0[1],
                   data_1[0],
                   data_0[0]};

    serdes_frame = {frame_s7,
                    frame_s6,
                    frame_s5,
                    frame_s4,
                    frame_s3,
                    frame_s2,
                    frame_s1,
                    frame_s0};
  end

  always @(posedge adc_clk_div) begin
    if(serdes_valid_d[1:0] == 2'b11) begin
      serdes_data_d <= serdes_data;
      serdes_frame_d <= serdes_frame;
    end
  end

  always @(posedge adc_clk_div) begin
    test_pattern <= adc_data_shifted;
  end

  always @(posedge adc_clk_div) begin
    if (serdes_reset_d) begin
      state <= INIT;
      shift_cnt <= 'h0;
      frame_shifted <= serdes_frame;
    end else begin
      case (state)
        INIT : begin
          if (frame_shifted != pattern_value) begin
            state <= CNT_UPDATE;
          end else begin
            frame_shifted <= {serdes_frame, serdes_frame_d} >> shift_cnt;
            if (expected_pattern_lane_0 == (test_pattern & lane_0_mask)) begin
              data_err_lane_0_r <= 1'b0;
            end else begin
              data_err_lane_0_r <= 1'b1;
            end
            if (expected_pattern_lane_1 == (test_pattern & lane_1_mask)) begin
              data_err_lane_1_r <= 1'b0;
            end else begin
              data_err_lane_1_r <= 1'b1;
            end
            state <= INIT;
          end
        end
        CNT_UPDATE : begin
          if (shift_cnt == 3'b111) begin
            frame_err_r <= 1'b1;
            state <= RESET;
          end
          else begin
            frame_err_r <= 1'b0;
          end
          shift_cnt <= shift_cnt + 1;
          state <= FRAME_SHIFTED;
        end
        FRAME_SHIFTED : begin
          frame_shifted <= {serdes_frame, serdes_frame_d} >> shift_cnt;
          state <= INIT;
        end
        RESET : begin
          shift_cnt <= 0;
          state <= INIT;
          frame_err_r <= 1'b0;
          data_err_lane_0_r <= 1'b0;
          data_err_lane_1_r <= 1'b0;
        end
        default: state <= INIT;
      endcase
    end
  end

  always @(posedge adc_clk_div) begin
    adc_data_shifted <= (({serdes_data_d,serdes_data} >> (shift_cnt)) >> (shift_cnt));
    serdes_valid_d <= serdes_valid;
  end

  assign adc_valid = !adc_rst;
  assign adc_data = adc_data_shifted;

endmodule
