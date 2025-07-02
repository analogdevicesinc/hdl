// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL(Verilog or VHDL) components. The individual modules are
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
//      of this repository(LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository(LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad408x_phy #(
  parameter FPGA_TECHNOLOGY = 0,
  parameter DRP_WIDTH = 5,
  parameter NUM_LANES = 2,  // Max number of lanes is 2
  parameter IODELAY_CTRL = 1,
  parameter IO_DELAY_GROUP = "dev_if_delay_group"
) (
  // device interface
  input                             dclk_in_n,
  input                             dclk_in_p,
  input                             data_a_in_n,
  input                             data_a_in_p,
  input                             data_b_in_n,
  input                             data_b_in_p,
  input                             cnv_in_p,
  input                             cnv_in_n,

  input                             sync_n,
  input        [4:0]                num_lanes,
  input                             self_sync,
  input                             bitslip_enable,
  input                             filter_enable,
  input                             filter_rdy_n,

  // delay interface(for IDELAY macros)
  input                             up_clk,
  input   [NUM_LANES-1:0]           up_adc_dld,
  input   [DRP_WIDTH*NUM_LANES-1:0] up_adc_dwdata,
  output  [DRP_WIDTH*NUM_LANES-1:0] up_adc_drdata,
  input                             delay_clk,
  input                             delay_rst,
  output                            delay_locked,

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
  localparam ULTRASCALE      = 2;
  localparam ULTRASCALE_PLUS = 3;

// Assumptions:
//  A replica of sync_n on the external board serves as a reset signal
//  for the clock received on the dclk_in_n/p pairs
//  Clock will stay low if sync_n is low, once sync_n deasserts after an
//  undefined amount of time the clock will start to toggle, glitch-less
//  having a smooth start.
//  Framing information will be reconstructed based on this assumption.
//
// Serdes reset
//
//  When deasserted synchronously with CLKDIV, internal logic re-times this
//  deassertion to the first rising edge of CLK
//  The reset signal should only be deasserted when it is known that CLK
//  and CLKDIV are stable and present, and should be a minimum of two CLKDIV pulses
//  wide. After deassertion of reset, the output is not valid until after two CLKDIV cycles.
// Serdes factor
//  A sample has 20 bits, this can be transferred either on one lane or two
//  lanes,DDR.
//
//                                             clk_div per sample
//   single_lane  | dclk per sample | /5    | /4
//   0            | 5               | 1     | 1.25
//   1            | 10              | 2     | 2.5
//
//   To accommodate all cases a serdes factor of 10 could be used in DDR mode
//   with a clock division of 5. This requires a cascaded serdes
//   configuration. However this will work only in 7 series devices.
//   Instead a serdes factor of 8 is used to support ultrascale devices too
//  (which do not have the cascaded mode with a factor of 10). This requires
//   additional packer circuitry from 4/8/16 bits to 20 bits depending on
//   mode.
//
// Serdes output valid
//   The latency of serdes in 7 series is two div_clk cycles. Output valid of
//   the serdes will assert two cock cycles later its reset de-asserts.

  wire                 fall_filter_ready;
  wire                 adc_clk_in_fast;
  wire [ 4:0]          shift_cnt_value;
  wire                 shift_cnt_en_s;
  wire [15:0]          serdes_data_16;
  wire [ 7:0]          serdes_data_0;
  wire [ 7:0]          serdes_data_1;
  wire [ 7:0]          serdes_data_8;
  wire [19:0]          pattern_value;
  wire [19:0]          packed_16_20;
  wire [19:0]          packed_8_20;
  wire                 pack16_valid;
  wire                 pack8_valid;
  wire                 adc_clk_div;
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

  reg  [5:0]  serdes_reset = 6'b000110;
  reg         sync_status_int = 1'b0;
  reg  [1:0]  serdes_valid = 2'b00;
  reg  [1:0]  filter_rdy_n_d = 'b0;
  reg         filter_ready = 1'b0;
  reg         shift_cnt_en = 1'b0;
  reg         packed_data_valid_d;
  reg         packed_data_valid;
  reg  [19:0] adc_data_shifted;
  reg  [ 4:0] shift_cnt = 5'd0;
  reg  [19:0] packed_data_d;
  reg  [19:0] packed_data;
  reg         slip_dd;
  reg         slip_d;

  assign fall_filter_ready = filter_rdy_n_d[1] & ~filter_rdy_n_d[0];
  assign sync_status       = sync_status_int;
  assign single_lane       = num_lanes[0];
  assign adc_clk           = adc_clk_div;
  assign pattern_value     = 20'hac5d6;
  assign shift_cnt_value   = 'd19;

  IBUFGDS i_clk_in_ibuf(
    .I(dclk_in_p),
    .IB(dclk_in_n),
    .O(clk_in_s));

  generate
  if(FPGA_TECHNOLOGY == SEVEN_SERIES) begin

    BUFIO i_clk_buf(
      .I(clk_in_s),
      .O(adc_clk_in_fast));

    BUFR #(
      .BUFR_DIVIDE("4")
    ) i_div_clk_buf (
      .CLR(~sync_n),
      .CE(1'b1),
      .I(clk_in_s),
      .O(adc_clk_div));

  end else begin

    BUFGCE #(
      .CE_TYPE("SYNC"),
      .IS_CE_INVERTED(1'b0),
      .IS_I_INVERTED(1'b0)
    ) i_clk_buf_fast(
      .O(adc_clk_in_fast),
      .CE(1'b1),
      .I(clk_in_s));

    BUFGCE_DIV #(
      .BUFGCE_DIVIDE(4),
      .IS_CE_INVERTED(1'b0),
      .IS_CLR_INVERTED(1'b0),
      .IS_I_INVERTED(1'b0)
    ) i_div_clk_buf(
      .O(adc_clk_div),
      .CE(1'b1),
      .CLR(~sync_n),
      .I(clk_in_s));

  end
  endgenerate

  assign serdes_in_p = {data_b_in_p, data_a_in_p};
  assign serdes_in_n = {data_b_in_n, data_a_in_n};

  // Min 2 div_clk cycles once div_clk is running after deassertion of sync
  // Control externally the reset of serdes for precise timing

  always @(posedge adc_clk_div or negedge sync_n) begin
    if(~sync_n) begin
      serdes_reset <= 6'b000110;
    end else begin
      serdes_reset <= {serdes_reset[4:0],1'b0};
    end
  end
  assign serdes_reset_s = serdes_reset[5];

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

  // for DDR(single lane) take data from a single lane

  assign serdes_data_8 = serdes_data_0;

  // For DDR dual lane interleave the two sedres outputs;

  assign serdes_data_16 = {serdes_data_0[7],
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

  ad_pack #(
    .I_W(8),
    .O_W(20),
    .UNIT_W(1),
    .ALIGN_TO_MSB(1)
  ) i_ad_pack_8 (
    .clk(adc_clk_div),
    .reset(~serdes_valid[0]),
    .idata(serdes_data_8),
    .ivalid(serdes_valid[1]),
    .odata(packed_8_20),
    .ovalid(pack8_valid));

  ad_pack #(
    .I_W(16),
    .O_W(20),
    .UNIT_W(1),
    .ALIGN_TO_MSB(1)
  ) i_ad_pack_16 (
    .clk(adc_clk_div),
    .reset(~serdes_valid[0]),
    .idata(serdes_data_16),
    .ivalid(serdes_valid[1]),
    .odata(packed_16_20),
    .ovalid(pack16_valid));

  always @(*) begin
    case(single_lane)
      1'b0 : packed_data = packed_16_20;
      1'b1 : packed_data = packed_8_20;
    endcase
  end

  always @(*) begin
    case(single_lane)
      1'b0 : packed_data_valid = pack16_valid;
      1'b1 : packed_data_valid = pack8_valid;
    endcase
  end

  // Align data
  // Use different rotations based on selected mode
  // Latency from first clock edge post sync_n deasertion to the first valid
  // output of the packer should be constant allowing for a constant rotation every time.

  always @(posedge adc_clk_div) begin
    if(packed_data_valid) begin
      packed_data_d <= packed_data;
    end
  end

  always @(posedge adc_clk_div) begin
    slip_d <= bitslip_enable;
    slip_dd <= slip_d;
    if(serdes_reset_s || adc_data_shifted == pattern_value)
      shift_cnt_en <= 1'b0;
    else if(slip_d & ~slip_dd)
      shift_cnt_en <= 1'b1;
  end

  always @(posedge adc_clk_div) begin
    if(shift_cnt_en) begin
      if(shift_cnt == shift_cnt_value || serdes_reset_s) begin
        shift_cnt <= 0;
        sync_status_int <= 1'b0;
      end else if( adc_data_shifted != pattern_value &&(packed_data_valid_d & ~packed_data_valid) ) begin
        shift_cnt <= shift_cnt + 1;
      end
      if(adc_data_shifted == pattern_value) begin
        sync_status_int <= 1'b1;
      end
    end
  end

  always @(posedge adc_clk_div) begin
    adc_data_shifted <= {packed_data_d,packed_data} >> shift_cnt;
    packed_data_valid_d <= packed_data_valid;
  end

  always @(posedge adc_clk_div) begin
   filter_rdy_n_d <= {filter_rdy_n_d[0], filter_rdy_n};
   if(fall_filter_ready) begin
     filter_ready <= 1'b1;
   end else if (packed_data_valid_d == 1'b1) begin
     filter_ready <= 1'b0;
   end
  end

  // Sign extend to 32 bits

  assign adc_data  = {{12{adc_data_shifted[19]}},adc_data_shifted};
  assign adc_valid = filter_enable ?  (packed_data_valid_d & filter_ready) : packed_data_valid_d;

endmodule
