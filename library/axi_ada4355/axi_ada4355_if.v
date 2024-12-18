// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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
// This is the LVDS/DDR interface, note that overrange is independent of data path,
// software will not be able to relate overrange to a specific sample!

 `timescale 1ns/100ps

 module axi_ada4355_if #(
   parameter FPGA_TECHNOLOGY = 1,
   parameter IO_DELAY_GROUP = "adc_if_delay_group",
   parameter IODELAY_CTRL = 1,
   parameter DRP_WIDTH = 5,
   parameter NUM_LANES = 2  // Max number of lanes is 2
 ) (
   // device interface

   input       dco_p,
   input       dco_n,
   input       da_p,
   input       da_n,
   input       db_p,
   input       db_n,
   input       data_frame_p,
   input       data_frame_n,
   input       clk_in_p,
   input       clk_in_n,

   input       sync_n,
   //input [4:0] num_lanes,
   input       bitslip_enable,

   // delay interface(for IDELAY macros)
   input                             up_clk,
   input   [NUM_LANES-1:0]           up_adc_dld,
   input   [DRP_WIDTH*NUM_LANES-1:0] up_adc_dwdata,
   output  [DRP_WIDTH*NUM_LANES-1:0] up_adc_drdata,
   input                             delay_clk,
   input                             delay_rst,
   output                            delay_locked,

   // frame

   output  [DRP_WIDTH*1-1:0] up_adc_drdata_frame,
   output                    delay_locked_frame,

   // internal reset and clocks
   input                             adc_rst,
   output                            adc_clk,

   // Output data
   output      [31:0]                adc_data,
   output                            adc_valid,

   // Synchronization signals used when CNV signal is not present
   output                            sync_status
);

  // Use always DDR mode for SERDES, useful for SDR mode to adjust capture
   localparam DDR_OR_SDR_N    = 1;
   localparam CMOS_LVDS_N     = 0; // Use always LVDS mode
   localparam SEVEN_SERIES    = 1;

   wire                 adc_clk_in_fast;
   wire [7:0]           serdes_frame;
   wire                 adc_clk_div = 1'b1;
   wire [ 7:0]          serdes_data_0;
   wire [ 7:0]          serdes_data_1;
   wire [19:0]          pattern_value;
   wire [ 4:0]          shift_cnt_value;
   wire [15:0]          serdes_data;

   wire [NUM_LANES-1:0] serdes_in_p;
   wire [NUM_LANES-1:0] serdes_in_n;
   wire                 clk_in_s;

   wire [NUM_LANES-1:0] data_s0;
   wire [NUM_LANES-1:0] data_s1;
   wire [NUM_LANES-1:0] data_s2;
   wire [NUM_LANES-1:0] data_s3;
   wire [NUM_LANES-1:0] data_s4;
   wire [NUM_LANES-1:0] data_s5;
   wire [NUM_LANES-1:0] data_s6;
   wire [NUM_LANES-1:0] data_s7;

   wire  data_s0_frame;
   wire  data_s1_frame;
   wire  data_s2_frame;
   wire  data_s3_frame;
   wire  data_s4_frame;
   wire  data_s5_frame;
   wire  data_s6_frame;
   wire  data_s7_frame;

   reg  [5:0]  serdes_reset = 6'b000110;
   reg         sync_status_int = 1'b0;
   reg         packed_data_valid_d;
   reg         packed_data_valid;
   reg  [15:0] adc_data_shifted;
   reg  [19:0] packed_data_d;
   reg  [19:0] packed_data;
   reg  [1:0]  serdes_valid = 2'b00;
   reg  [1:0]  serdes_valid_d = 2'b00;
   reg         slip_dd;
   reg         slip_d;
   reg         shift_cnt_en = 1'b0;
   reg  [ 4:0] shift_cnt = 5'd0;
   
   reg  [15:0] serdes_data_16;
   reg  [15:0] serdes_data_16_d;
   reg  [7:0]  data_frame_shifted;
   reg  [7:0]  serdes_data_frame;
   reg  [7:0]  serdes_data_frame_d;

   assign sync_status       = sync_status_int;
   assign adc_clk           = adc_clk_div;
   assign pattern_value     = 8'hF0;
   assign shift_cnt_value   = 'd15;

   IBUFGDS i_clk_in_ibuf(
    .I(dco_p),
    .IB(dco_n),
    .O(clk_in_s));

   generate
    if(FPGA_TECHNOLOGY == SEVEN_SERIES) begin

      BUFIO i_clk_buf(
        .I(clk_in_s),
        .O(adc_clk_in_fast));

      /*BUFR #(
        .BUFR_DIVIDE("4")
      ) i_div_clk_buf (
        .CLR(~sync_n),
        .CE(1'b1),
        .I(clk_in_s),
        .O(adc_clk_div)); */

    end
    endgenerate

    assign serdes_in_p = {db_p, da_p};
    assign serdes_in_n = {db_n, da_n};

    always @(posedge adc_clk_div or negedge sync_n) begin
        if(~sync_n) begin
          serdes_reset <= 6'b000110;
        end else begin
          serdes_reset <= {serdes_reset[4:0],1'b0};
        end
      end
      assign serdes_reset_s = serdes_reset[5];

    //serdes for data

   ad_serdes_in #(
    .CMOS_LVDS_N(CMOS_LVDS_N),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_CTRL(IODELAY_CTRL),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(DDR_OR_SDR_N),
    .DATA_WIDTH(NUM_LANES),
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
    .data_in_p(serdes_in_p),
    .data_in_n(serdes_in_n),
    .up_clk(up_clk),
    .up_dld(up_adc_dld),
    .up_dwdata(up_adc_dwdata),
    .up_drdata(up_adc_drdata),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked));

    // serdes for frame
    
    ad_serdes_in #(
    .CMOS_LVDS_N(CMOS_LVDS_N),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_CTRL(IODELAY_CTRL),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(DDR_OR_SDR_N),
    .DATA_WIDTH(1),
    .DRP_WIDTH(DRP_WIDTH),
    .SERDES_FACTOR(8),
    .EXT_SERDES_RESET(1)
    ) i_serdes_frame(
    .rst(serdes_reset_s),
    .ext_serdes_rst(serdes_reset_s),
    .clk(adc_clk_in_fast),
    .div_clk(adc_clk_div),
    .data_s0(data_s0_frame),
    .data_s1(data_s1_frame),
    .data_s2(data_s2_frame),
    .data_s3(data_s3_frame),
    .data_s4(data_s4_frame),
    .data_s5(data_s5_frame),
    .data_s6(data_s6_frame),
    .data_s7(data_s7_frame),
    .data_in_p(data_frame_p),
    .data_in_n(data_frame_n),
    .up_clk(up_clk),
    .up_dld(up_adc_dld),
    .up_dwdata(up_adc_dwdata),
    .up_drdata(up_adc_drdata_frame),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked_frame));

   assign {serdes_data_1[0],serdes_data_0[0]} = data_s0;  // f-e latest bit received
   assign {serdes_data_1[1],serdes_data_0[1]} = data_s1;  // r-e
   assign {serdes_data_1[2],serdes_data_0[2]} = data_s2;  // f-e
   assign {serdes_data_1[3],serdes_data_0[3]} = data_s3;  // r-e
   assign {serdes_data_1[4],serdes_data_0[4]} = data_s4;  // f-e
   assign {serdes_data_1[5],serdes_data_0[5]} = data_s5;  // r-e
   assign {serdes_data_1[6],serdes_data_0[6]} = data_s6;  // f-e
   assign {serdes_data_1[7],serdes_data_0[7]} = data_s7;  // r-e oldest bit received

  // Assert serdes valid after 2 clock cycles is pulled out of reset

 always @(posedge adc_clk_div) begin
    if(serdes_reset_s) begin
      serdes_valid <= 2'b00;
    end else begin
      serdes_valid <= {serdes_valid[0],1'b1};
    end
  end

  // For DDR dual lane interleave the two sedres outputs;

  assign serdes_data =    {serdes_data_0[7],
                           serdes_data_1[7],
                           serdes_data_0[6],
                           serdes_data_1[6],
                           serdes_data_0[5],
                           serdes_data_1[5],
                           serdes_data_0[4],
                           serdes_data_1[4],
                           serdes_data_0[3],
                           serdes_data_1[3],
                           serdes_data_0[2],
                           serdes_data_1[2],
                           serdes_data_0[1],
                           serdes_data_1[1],
                           serdes_data_0[0],
                           serdes_data_1[0]};

  assign serdes_frame =      {data_s0_frame,
                              data_s1_frame,
                              data_s2_frame,
                              data_s3_frame,
                              data_s4_frame,
                              data_s5_frame,
                              data_s6_frame,
                              data_s7_frame};

always @(*) begin
  serdes_data_16 = serdes_data;
end

always @(*) begin
  serdes_data_frame = serdes_frame;
end

always @(posedge adc_clk_div) begin
  if(serdes_valid[1]) begin
    serdes_data_16_d <= serdes_data_16;
  end
end

always @(posedge adc_clk_div) begin
  if(serdes_valid[1]) begin
    serdes_data_frame_d <= serdes_data_frame;
  end
end

// enable bitslip
always @(posedge adc_clk_div) begin
  slip_d <= bitslip_enable;
  slip_dd <= slip_d;
  if(serdes_reset_s || data_frame_shifted == pattern_value)
    shift_cnt_en <= 1'b0;
  else if(slip_d & ~slip_dd)
    shift_cnt_en <= 1'b1;
end

// find offset
always @(posedge adc_clk_div) begin
  if(shift_cnt_en) begin
    if(shift_cnt == shift_cnt_value || serdes_reset_s) begin
      shift_cnt <= 0;
      sync_status_int <= 1'b0;
    end //else if( serdes_data_frame != pattern_value &&(serdes_valid_d & ~serdes_valid) ) begin
      else if( data_frame_shifted != pattern_value /*&&(serdes_valid)*/) begin
      shift_cnt <= shift_cnt + 1;
    end
    if(data_frame_shifted == pattern_value) begin
      sync_status_int <= 1'b1;
    end
  end
end

always @(posedge adc_clk_div) begin
  adc_data_shifted <= {serdes_data_16_d,serdes_data_16} >> shift_cnt;
  data_frame_shifted <= {serdes_data_frame, serdes_data_frame_d} >> shift_cnt;
  serdes_valid_d <= serdes_valid;
  end

  assign adc_data = adc_data_shifted;

endmodule
