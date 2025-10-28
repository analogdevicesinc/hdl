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
  parameter IO_DELAY_GROUP = "dev_if_delay_group",
  parameter ADC_DATA_WIDTH  = 32,
  parameter ADC_N_BITS  = 20
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
  input        [1:0]                device_code,
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
  output  [ADC_DATA_WIDTH-1:0]      adc_data,
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
  wire [7:0]           serdes_data_8;
  wire                 ad_pack_ovalid_8_20;
  wire                 ad_pack_ovalid_4_20;
  wire                 ad_pack_ovalid_8_16;
  wire                 ad_pack_ovalid_4_16;
  wire                 ad_pack_ovalid_8_14;
  wire                 ad_pack_ovalid_4_14;
  wire [ 3:0]          serdes_data_0;
  wire [ 3:0]          serdes_data_1;
  wire [ 3:0]          serdes_data_4;
  wire [19:0]          pattern_value;
  wire [19:0]          ad_pack_odata_8_20;
  wire [15:0]          ad_pack_odata_8_16;
  wire [13:0]          ad_pack_odata_8_14;
  wire [19:0]          ad_pack_odata_4_20;
  wire [15:0]          ad_pack_odata_4_16;
  wire [13:0]          ad_pack_odata_4_14;
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
  wire [19:0]          ad_pack_odata_20;
  wire [15:0]          ad_pack_odata_16;
  wire [13:0]          ad_pack_odata_14;
  wire [19:0]          adc_data_shifted_20;
  wire [15:0]          adc_data_shifted_16;
  wire [13:0]          adc_data_shifted_14;

  reg  [5:0]  serdes_reset = 6'b000110;
  reg         sync_status_int = 1'b0;
  reg  [1:0]  serdes_valid = 2'b00;
  reg  [1:0]  filter_rdy_n_d = 'b0;
  reg         filter_ready = 1'b0;
  reg         shift_cnt_en = 1'b0;
  reg         packed_data_valid_d;
  reg         packed_data_valid;
  reg  [19:0] adc_data_shifted;
  reg  [19:0] adc_data_shifted_s;
  reg  [ 4:0] shift_cnt = 5'd0;
  reg  [19:0] ad_pack_odata_20_d;
  reg  [15:0] ad_pack_odata_16_d;
  reg  [13:0] ad_pack_odata_14_d;
  reg         slip_dd;
  reg         slip_d;

  assign fall_filter_ready = filter_rdy_n_d[1] & ~filter_rdy_n_d[0];
  assign sync_status       = sync_status_int;
  assign single_lane       = num_lanes[0];
  assign adc_clk           = adc_clk_div;
  assign pattern_value     = device_code == 2'h0 ? 20'hAC5D6:
                             device_code == 2'h1 ? 20'h0AC5D:
                                                   20'h02B17;

  assign shift_cnt_value   = device_code == 2'h0 ? 'd19:
                             device_code == 2'h1 ? 'd15:
                                                   'd13;

  IBUFGDS i_clk_in_ibuf(
    .I(dclk_in_p),
    .IB(dclk_in_n),
    .O(clk_in_s));
    // 0x15 0x50 pttmode
  generate
  if(FPGA_TECHNOLOGY == SEVEN_SERIES) begin

    BUFIO i_clk_buf(
      .I(clk_in_s),
      .O(adc_clk_in_fast));
    if(DDR_OR_SDR_N == 1) begin
      BUFR #(
        .BUFR_DIVIDE("2")
      ) i_div_clk_buf (
        .CLR(~sync_n),
        .CE(1'b1),
        .I(clk_in_s),
        .O(adc_clk_div));
    end else if(DDR_OR_SDR_N == 0) begin
      BUFR #(
        .BUFR_DIVIDE("4")
      ) i_div_clk_buf (
        .CLR(~sync_n),
        .CE(1'b1),
        .I(clk_in_s),
        .O(adc_clk_div));
    end

  end else begin

    BUFGCE #(
      .CE_TYPE("SYNC"),
      .IS_CE_INVERTED(1'b0),
      .IS_I_INVERTED(1'b0)
    ) i_clk_buf_fast(
      .O(adc_clk_in_fast),
      .CE(1'b1),
      .I(clk_in_s));

    if(DDR_OR_SDR_N == 1) begin
      BUFGCE_DIV #(
        .BUFGCE_DIVIDE(2),
        .IS_CE_INVERTED(1'b0),
        .IS_CLR_INVERTED(1'b0),
        .IS_I_INVERTED(1'b0)
      ) i_div_clk_buf(
        .O(adc_clk_div),
        .CE(1'b1),
        .CLR(~sync_n),
        .I(clk_in_s));
    end else if(DDR_OR_SDR_N == 0) begin
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
    .SERDES_FACTOR(4),
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
  assign {serdes_data_1[3],serdes_data_0[3]} = data_s3;  // r-e oldest bit received

  // Assert serdes valid after 2 clock cycles is pulled out of reset

  always @(posedge adc_clk_div) begin
    if(serdes_reset_s) begin
      serdes_valid <= 2'b00;
    end else begin
      serdes_valid <= {serdes_valid[0],1'b1};
    end
  end

  // single lane wiring

  assign serdes_data_4 = serdes_data_0;

  // dual lane wiring

  assign serdes_data_8 = {serdes_data_0[3],
                          serdes_data_1[3],
                          serdes_data_0[2],
                          serdes_data_1[2],
                          serdes_data_0[1],
                          serdes_data_1[1],
                          serdes_data_0[0],
                          serdes_data_1[0]};

  generate
    if (ADC_DATA_WIDTH == 32) begin

      ad_pack #(
        .I_W(4),
        .O_W(20),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_4_20 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_4),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_4_20),
        .ovalid(ad_pack_ovalid_4_20));

      ad_pack #(
        .I_W(8),
        .O_W(20),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_8_20 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_8),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_8_20),
        .ovalid(ad_pack_ovalid_8_20));

      ad_pack #(
        .I_W(4),
        .O_W(16),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_4_16 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_4),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_4_16),
        .ovalid(ad_pack_ovalid_4_16));

      ad_pack #(
        .I_W(8),
        .O_W(16),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_8_16 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_8),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_8_16),
        .ovalid(ad_pack_ovalid_8_16));

      ad_pack #(
        .I_W(4),
        .O_W(14),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_4_14 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_4),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_4_14),
        .ovalid(ad_pack_ovalid_4_14));

      ad_pack #(
        .I_W(8),
        .O_W(14),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_8_14 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_8),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_8_14),
        .ovalid(ad_pack_ovalid_8_14));

      assign ad_pack_odata_20 = (single_lane) ? ad_pack_odata_4_20 : ad_pack_odata_8_20;
      assign ad_pack_odata_16 = (single_lane) ? ad_pack_odata_4_16 : ad_pack_odata_8_16;
      assign ad_pack_odata_14 = (single_lane) ? ad_pack_odata_4_14 : ad_pack_odata_8_14;

      assign adc_data_shifted_20 = {ad_pack_odata_20_d,ad_pack_odata_20} >> shift_cnt;
      assign adc_data_shifted_16 = {ad_pack_odata_16_d,ad_pack_odata_16} >> shift_cnt;
      assign adc_data_shifted_14 = {ad_pack_odata_14_d,ad_pack_odata_14} >> shift_cnt;

      always @(*) begin
        case(device_code)
          2'h0 : adc_data_shifted_s <= adc_data_shifted_20;
          2'h1 : adc_data_shifted_s <= {{4{1'b0}},adc_data_shifted_16};
          2'h2 : adc_data_shifted_s <= {{6{1'b0}},adc_data_shifted_14};
          default : adc_data_shifted_s <= 20'hdeadd;
        endcase
      end

      always @(*) begin
        case({device_code,single_lane})
          3'h0 : packed_data_valid = ad_pack_ovalid_8_20;
          3'h1 : packed_data_valid = ad_pack_ovalid_4_20;
          3'h2 : packed_data_valid = ad_pack_ovalid_8_16;
          3'h3 : packed_data_valid = ad_pack_ovalid_4_16;
          3'h4 : packed_data_valid = ad_pack_ovalid_8_14;
          3'h5 : packed_data_valid = ad_pack_ovalid_4_14;
          default : packed_data_valid = 1'b0;
        endcase
      end

      // Sign extend to 32 bits

      assign adc_data  = device_code == 2'h0 ? {{12{adc_data_shifted[19]}},adc_data_shifted}:
                         device_code == 2'h1 ? {{16{adc_data_shifted[15]}},adc_data_shifted[15:0]}:
                         device_code == 2'h2 ? {{18{adc_data_shifted[13]}},adc_data_shifted[13:0]}: 32'hdeaddead;

    end else if (ADC_DATA_WIDTH == 16) begin

      ad_pack #(
        .I_W(4),
        .O_W(16),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_4_16 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_4),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_4_16),
        .ovalid(ad_pack_ovalid_4_16));

      ad_pack #(
        .I_W(8),
        .O_W(16),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_8_16 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_8),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_8_16),
        .ovalid(ad_pack_ovalid_8_16));

      ad_pack #(
        .I_W(4),
        .O_W(14),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_4_14 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_4),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_4_14),
        .ovalid(ad_pack_ovalid_4_14));

      ad_pack #(
        .I_W(8),
        .O_W(14),
        .UNIT_W(1),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack_8_14 (
        .clk(adc_clk_div),
        .reset(~serdes_valid[0]),
        .idata(serdes_data_8),
        .ivalid(serdes_valid[1]),
        .odata(ad_pack_odata_8_14),
        .ovalid(ad_pack_ovalid_8_14));

      assign ad_pack_odata_16 = (single_lane) ? ad_pack_odata_4_16 : ad_pack_odata_8_16;
      assign ad_pack_odata_14 = (single_lane) ? ad_pack_odata_4_14 : ad_pack_odata_8_14;

      assign adc_data_shifted_16 = {ad_pack_odata_16_d,ad_pack_odata_16} >> shift_cnt;
      assign adc_data_shifted_14 = {ad_pack_odata_14_d,ad_pack_odata_14} >> shift_cnt;

      always @(*) begin
        case(device_code)
          2'h1 : adc_data_shifted_s <= {{4{1'b0}},adc_data_shifted_16};
          2'h2 : adc_data_shifted_s <= {{6{1'b0}},adc_data_shifted_14};
          default : adc_data_shifted_s <= 20'hdeadd;
        endcase
      end

      always @(*) begin
        case({device_code,single_lane})
          3'h2 : packed_data_valid = ad_pack_ovalid_8_16;
          3'h3 : packed_data_valid = ad_pack_ovalid_4_16;
          3'h4 : packed_data_valid = ad_pack_ovalid_8_14;
          3'h5 : packed_data_valid = ad_pack_ovalid_4_14;
          default : packed_data_valid = 1'b0;
        endcase
      end

      // Sign extend to 16 bits

      assign adc_data  = device_code == 2'h1 ? adc_data_shifted[15:0]:
                         device_code == 2'h2 ? {{2{adc_data_shifted[13]}}, adc_data_shifted[13:0]} : 16'hdead;

    end
  endgenerate

  // Align data
  // Use different rotations based on selected mode
  // Latency from first clock edge post sync_n deasertion to the first valid
  // output of the packer should be constant allowing for a constant rotation every time.

  always @(posedge adc_clk_div) begin
    if(packed_data_valid) begin
      ad_pack_odata_20_d <= ad_pack_odata_20;
      ad_pack_odata_16_d <= ad_pack_odata_16;
      ad_pack_odata_14_d <= ad_pack_odata_14;
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
      if(~serdes_reset_s) begin
        if( adc_data_shifted == pattern_value ) begin
          sync_status_int <= 1'b1;
        end else if( adc_data_shifted != pattern_value && packed_data_valid_d ) begin
          if(shift_cnt == shift_cnt_value) begin
            shift_cnt <= 0;
            sync_status_int <= 1'b0;
          end else begin
            shift_cnt <= shift_cnt + 1;
          end
        end
      end else begin
        shift_cnt <= 0;
        sync_status_int <= 1'b0;
      end
    end
  end

  always @(posedge adc_clk_div) begin
    adc_data_shifted <= adc_data_shifted_s;
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

  assign adc_valid = filter_enable ?  (packed_data_valid_d & filter_ready) : packed_data_valid_d;

endmodule
