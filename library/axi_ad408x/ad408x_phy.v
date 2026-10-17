// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2026 Analog Devices, Inc. All rights reserved.
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

module ad408x_phy #(
  parameter FPGA_TECHNOLOGY = 0,
  parameter DRP_WIDTH = 5,
  parameter NUM_LANES = 2,  // Max number of lanes is 2
  parameter IODELAY_CTRL = 1,
  parameter IO_DELAY_GROUP = "dev_if_delay_group",
  // built bit depths, at least one
  parameter ENABLE_20BIT = 1,
  parameter ENABLE_16BIT = 1,
  parameter ENABLE_14BIT = 1,
  // filter_rdy_n deserialized beside the data; 0 if not on a data bank pin
  parameter EN_FILTER_RDY = 1,
  // 16 bit slots, the earliest sample in the low bits; the DMA source width
  // must match this
  parameter ADC_DATA_WIDTH = ((ENABLE_20BIT != 0) || ((ENABLE_14BIT != 0) && (NUM_LANES == 2))) ? 32 : 16
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
  input                             up_filter_dld,
  input   [DRP_WIDTH-1:0]           up_filter_dwdata,
  output  [DRP_WIDTH-1:0]           up_filter_drdata,
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

  localparam CMOS_LVDS_N     = 0; // Use always LVDS mode
  localparam SEVEN_SERIES    = 1;
  localparam ULTRASCALE      = 2;
  localparam ULTRASCALE_PLUS = 3;

  localparam NUM_DEPTHS = ((ENABLE_20BIT != 0) ? 1 : 0) +
                          ((ENABLE_16BIT != 0) ? 1 : 0) +
                          ((ENABLE_14BIT != 0) ? 1 : 0);
  localparam ONLY_CODE  = (ENABLE_20BIT != 0) ? 2'h0 :
                          (ENABLE_16BIT != 0) ? 2'h1 : 2'h2;

  localparam MIN_DATA_WIDTH = ((ENABLE_20BIT != 0) || ((ENABLE_14BIT != 0) && (NUM_LANES == 2))) ? 32 : 16;

  localparam SERDES_FACTOR = 8;
  localparam BUFGCE_DIV    = 4;
  localparam BUFR_DIV      = "4";

  // fabric word width, samples per 14 bit packer output
  localparam I_W  = 8*NUM_LANES;
  localparam K14  = (NUM_LANES == 2) ? 2 : 1;

  // unit width ({data, filter_rdy_n} or data), serdes lines, filter line index
  localparam UW      = (EN_FILTER_RDY != 0) ? 2 : 1;
  localparam SER_W   = (EN_FILTER_RDY != 0) ? NUM_LANES + 1 : NUM_LANES;
  localparam FILT_LN = NUM_LANES;

// Sync
//  sync_n resets the clock divider; the fast serdes clock keeps running. The
//  fabric word boundary follows the divider restart, so the offset found by
//  the pattern search holds from sync to sync if sync_n deasserts on the same
//  phase of the DCO/4 period.
//
// Serdes reset
//  When deasserted synchronously with CLKDIV, internal logic re-times this
//  deassertion to the first rising edge of CLK. After deassertion the output
//  is not valid until after two CLKDIV cycles.
//
// Serdes factor
//  Every lane is deserialized by 8 on adc_clk_div = DCO/4: an 8 bit word per
//  cycle on one lane, 16 bits on two lanes. The 14 bit depth on two lanes gets
//  up to two samples per cycle. A two lane build runs two lanes only when
//  num_lanes is 2; otherwise, also after reset, it joins two lane A words
//  into one 16 bit word.
//
// Bit alignment
//  shift_cnt bits are removed in front of the packers, so the packers deliver
//  samples on fixed bit positions. The offset is selected from a delay line
//  and takes effect with the next word.
//
// Latency
//  The alignment delay line holds 4 words on one lane and 2 on two lanes; the
//  packers, the sample selection and the output add their registers, plus
//  the wait for the second sample of a word on the 32 bit bus.

  wire                 adc_clk_in_fast;
  wire                 adc_clk_div;
  wire                 clk_in_s;
  wire                 serdes_reset_s;
  wire [NUM_LANES-1:0] serdes_in_p;
  wire [NUM_LANES-1:0] serdes_in_n;
  wire [SER_W-1:0]     data_s [0:7];
  wire [UW*I_W-1:0]    unit_word;

  genvar k;
  wire [UW*I_W-1:0]    aln_data;
  wire                 aln_valid;
  wire [ 1:0]          device_code_i;
  wire [ 4:0]          shift_cnt_max;
  wire [ 1:0]          keep;

  wire [31:0]          d_slots [0:2];
  wire [ 1:0]          d_pres  [0:2];
  wire [ 1:0]          d_filt_rdy [0:2];
  wire                 d_pattern_match [0:2];
  wire                 d_valid [0:2];

  reg  [1:0]  serdes_reset = 2'b11;
  reg  [1:0]  serdes_valid = 2'b00;
  reg  [31:0] smp_slots = 32'd0;
  reg  [ 1:0] smp_pres = 2'd0;
  reg  [ 1:0] smp_filt_rdy = 2'd0;
  reg         smp_valid = 1'b0;
  reg         pattern_match = 1'b0;
  reg  [3:0]  match_delay_cnt = 4'd0;
  reg  [4:0]  shift_cnt = 5'd0;
  reg         shift_cnt_en = 1'b0;
  reg         sync_status_int = 1'b0;
  reg         slip_d = 1'b0;
  reg         slip_dd = 1'b0;

  assign sync_status = sync_status_int;
  assign adc_clk     = adc_clk_div;

  // a single built depth ignores device_code

  assign device_code_i = (NUM_DEPTHS == 1) ? ONLY_CODE : device_code;

  assign shift_cnt_max = device_code_i == 2'h0 ? 'd19:
                         device_code_i == 2'h1 ? 'd15:
                                                 'd13;

  generate
  if (NUM_DEPTHS == 0) begin : g_cfg_error
    $error("ad408x_phy: no converter bit depth enabled, set at least one of ENABLE_20BIT, ENABLE_16BIT, ENABLE_14BIT");
    ad408x_phy_ERROR_no_bit_depth_enabled i_cfg_error ();
  end
  if ((ADC_DATA_WIDTH < MIN_DATA_WIDTH) || ((ADC_DATA_WIDTH & (ADC_DATA_WIDTH - 1)) != 0)) begin : g_width_error
    $error("ad408x_phy: ADC_DATA_WIDTH must be a power of two and at least 32 with the 20 bit depth or the 14 bit depth on two lanes, else at least 16");
    ad408x_phy_ERROR_adc_data_width_not_a_power_of_two_or_below_minimum i_cfg_error ();
  end
  endgenerate

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
      .BUFR_DIVIDE(BUFR_DIV)
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
      .BUFGCE_DIVIDE(BUFGCE_DIV),
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

  generate
  if (NUM_LANES == 2) begin
    assign serdes_in_p = {data_b_in_p, data_a_in_p};
    assign serdes_in_n = {data_b_in_n, data_a_in_n};
  end else begin
    assign serdes_in_p = data_a_in_p;
    assign serdes_in_n = data_a_in_n;
  end
  endgenerate

  // serdes reset: adc_rst and two adc_clk_div cycles after it

  always @(posedge adc_clk_div) begin
    if(adc_rst) begin
      serdes_reset <= 2'b11;
    end else begin
      serdes_reset <= serdes_reset << 1;
    end
  end
  assign serdes_reset_s = serdes_reset[1];

  // data lanes, LVDS

  wire [NUM_LANES-1:0] dat_s [0:7];

  ad_serdes_in #(
    .CMOS_LVDS_N(CMOS_LVDS_N),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_CTRL(IODELAY_CTRL),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .IODELAY_ENABLE(1),
    .DDR_OR_SDR_N(1),
    .DATA_WIDTH(NUM_LANES),
    .DRP_WIDTH(DRP_WIDTH),
    .SERDES_FACTOR(SERDES_FACTOR),
    .EXT_SERDES_RESET(1)
  ) i_serdes (
    .rst(serdes_reset_s),
    .ext_serdes_rst(serdes_reset_s),
    .clk(adc_clk_in_fast),
    .div_clk(adc_clk_div),
    .data_s0(dat_s[0]),
    .data_s1(dat_s[1]),
    .data_s2(dat_s[2]),
    .data_s3(dat_s[3]),
    .data_s4(dat_s[4]),
    .data_s5(dat_s[5]),
    .data_s6(dat_s[6]),
    .data_s7(dat_s[7]),
    .data_in_p(serdes_in_p),
    .data_in_n(serdes_in_n),
    .up_clk(up_clk),
    .up_dld(up_adc_dld),
    .up_dwdata(up_adc_dwdata),
    .up_drdata(up_adc_drdata),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked));

  // filter_rdy_n, single ended, deserialized like the data lanes; the delay
  // control is the one of the data serdes (same delay group)

  generate
  if (EN_FILTER_RDY != 0) begin : g_ser_filt

    wire filt_s [0:7];

    ad_serdes_in #(
      .CMOS_LVDS_N(1),
      .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
      .IODELAY_CTRL(0),
      .IODELAY_GROUP(IO_DELAY_GROUP),
      .IODELAY_ENABLE(1),
      .DDR_OR_SDR_N(1),
      .DATA_WIDTH(1),
      .DRP_WIDTH(DRP_WIDTH),
      .SERDES_FACTOR(SERDES_FACTOR),
      .EXT_SERDES_RESET(1)
    ) i_serdes_filt (
      .rst(serdes_reset_s),
      .ext_serdes_rst(serdes_reset_s),
      .clk(adc_clk_in_fast),
      .div_clk(adc_clk_div),
      .data_s0(filt_s[0]),
      .data_s1(filt_s[1]),
      .data_s2(filt_s[2]),
      .data_s3(filt_s[3]),
      .data_s4(filt_s[4]),
      .data_s5(filt_s[5]),
      .data_s6(filt_s[6]),
      .data_s7(filt_s[7]),
      .data_in_p(filter_rdy_n),
      .data_in_n(1'b0),
      .up_clk(up_clk),
      .up_dld(up_filter_dld),
      .up_dwdata(up_filter_dwdata),
      .up_drdata(up_filter_drdata),
      .delay_clk(delay_clk),
      .delay_rst(delay_rst),
      .delay_locked());

    for (k = 0; k < 8; k = k + 1) begin : g_slot
      assign data_s[k] = {filt_s[k], dat_s[k]};
    end

  end else begin : g_ser_data

    for (k = 0; k < 8; k = k + 1) begin : g_slot
      assign data_s[k] = dat_s[k];
    end
    assign up_filter_drdata = {DRP_WIDTH{1'b0}};

  end
  endgenerate

  // Assert serdes valid two clock cycles after sync_n deasserts

  always @(posedge adc_clk_div or negedge sync_n) begin
    if(~sync_n) begin
      serdes_valid <= 2'b00;
    end else begin
      serdes_valid <= {serdes_valid[0],1'b1};
    end
  end

  // Unit word: oldest unit in the MSB, lane A before lane B in each slot.

  genvar l;
  generate
  for (k = 0; k < 8; k = k + 1) begin : g_slot
    for (l = 0; l < NUM_LANES; l = l + 1) begin : g_lane
      localparam U = NUM_LANES*k + (NUM_LANES-1-l);
      if (UW == 2) begin : g_mark
        assign unit_word[UW*U +: UW] = {data_s[k][l], data_s[k][FILT_LN]};
      end else begin : g_data
        assign unit_word[UW*U +: UW] = data_s[k][l];
      end
    end
  end
  endgenerate

  // A dual lane build with the converter on one lane: two lane A words, the
  // older one in the MSBs, make one unit word, valid every second cycle. Two
  // lanes only when num_lanes is 2, so the reset value 0 selects one lane
  // without a driver write.

  wire [UW*I_W-1:0] aln_in;
  wire              aln_in_valid;

  generate
  if (NUM_LANES == 2) begin : g_gear

    wire [UW*8-1:0] lane_a;
    reg  [UW*8-1:0] lane_a_d = 'd0;
    reg             half = 1'b0;

    for (k = 0; k < 8; k = k + 1) begin : g_slot
      assign lane_a[UW*k +: UW] = unit_word[UW*(2*k+1) +: UW];
    end

    always @(posedge adc_clk_div) begin
      lane_a_d <= lane_a;
    end

    always @(posedge adc_clk_div or negedge serdes_valid[1]) begin
      if (~serdes_valid[1]) begin
        half <= 1'b0;
      end else begin
        half <= ~half;
      end
    end

    wire one_lane = (num_lanes != 5'd2);

    assign aln_in       = one_lane ? {lane_a_d, lane_a} : unit_word;
    assign aln_in_valid = one_lane ? half : 1'b1;

  end else begin : g_no_gear

    assign aln_in       = unit_word;
    assign aln_in_valid = 1'b1;

  end
  endgenerate

  // bit alignment

  ad_bitslip_align #(
    .I_W(I_W),
    .UNIT_W(UW),
    .SHIFT_W(5),
    .ASYNC_RESET(1)
  ) i_align (
    .clk(adc_clk_div),
    .reset(~serdes_valid[1]),
    .idata(aln_in),
    .ivalid(aln_in_valid),
    .shift(shift_cnt),
    .odata(aln_data),
    .ovalid(aln_valid));

  // Sample packers, one per built depth. Each one provides
  //   d_slots         : samples in 16 bit slots, sign extended, earliest in
  //                     slot 0; a 20 bit sample fills both slots
  //   d_pres          : present samples
  //   d_filt_rdy      : filter_rdy_n in the middle of each sample
  //   d_pattern_match : first sample equals the pattern

  localparam [2:0] DEPTH_EN = {(ENABLE_14BIT != 0), (ENABLE_16BIT != 0), (ENABLE_20BIT != 0)};

  genvar d;
  generate
  for (d = 0; d < 3; d = d + 1) begin : g_depth

    localparam N  = (d == 0) ? 20 : (d == 1) ? 16 : 14;
    localparam K  = (d == 2) ? K14 : 1;
    localparam [19:0] PATTERN = (d == 0) ? 20'hAC5D6 : (d == 1) ? 20'h0AC5D : 20'h02B17;

    if (DEPTH_EN[d]) begin : g_on

      wire [UW*N*K-1:0] odata;
      wire              pack_valid;
      wire [N*K-1:0]    bits;
      wire [N*K-1:0]    filt_rdy;
      wire [N-1:0]      s0;
      wire [N-1:0]      s1;
      wire              m0 = filt_rdy[N*K-N+N/2];
      wire              m1 = filt_rdy[N/2];

      ad_pack #(
        .I_W(I_W),
        .O_W(N*K),
        .UNIT_W(UW),
        .I_REG(0),
        .ALIGN_TO_MSB(1)
      ) i_ad_pack (
        .clk(adc_clk_div),
        .reset(~serdes_valid[1]),
        .idata(aln_data),
        .ivalid(aln_valid),
        .odata(odata),
        .ovalid(pack_valid));

      // the packer resets synchronously; serdes_valid (async on sync_n) drops
      // the valid also while adc_clk_div is stopped
      assign d_valid[d] = pack_valid & serdes_valid[1];

      for (k = 0; k < N*K; k = k + 1) begin : g_bit
        assign bits[k] = odata[UW*k + UW-1];
        if (UW == 2) begin : g_mark
          assign filt_rdy[k] = odata[UW*k];
        end else begin : g_nomark
          assign filt_rdy[k] = 1'b1;
        end
      end

      assign s0         = bits[N*K-1 -: N];
      assign s1         = bits[N-1:0];
      assign d_pattern_match[d] = (s0 == PATTERN[N-1:0]);

      if (N == 20) begin : g_w32
        assign d_slots[d] = {{12{s0[N-1]}}, s0};
        assign d_pres[d]  = 2'b01;
        assign d_filt_rdy[d] = {1'b0, m0};
      end else if (K == 2) begin : g_two
        assign d_slots[d] = {{(16-N){s1[N-1]}}, s1, {(16-N){s0[N-1]}}, s0};
        assign d_pres[d]  = 2'b11;
        assign d_filt_rdy[d] = {m1, m0};
      end else begin : g_one
        assign d_slots[d] = {16'd0, {(16-N){s0[N-1]}}, s0};
        assign d_pres[d]  = 2'b01;
        assign d_filt_rdy[d] = {1'b0, m0};
      end

    end else begin : g_off
      assign d_slots[d] = 32'd0;
      assign d_pres[d]  = 2'b00;
      assign d_filt_rdy[d] = 2'b00;
      assign d_pattern_match[d] = 1'b0;
      assign d_valid[d] = 1'b0;
    end

  end
  endgenerate

  // depth selection, device code 3 selects the 14 bit depth

  wire [1:0] dsel = (device_code_i == 2'h3) ? 2'h2 : device_code_i;

  always @(posedge adc_clk_div) begin
    smp_slots     <= d_slots[dsel];
    smp_filt_rdy  <= d_filt_rdy[dsel];
    pattern_match <= d_pattern_match[dsel];
  end

  always @(posedge adc_clk_div or negedge sync_n) begin
    if (~sync_n) begin
      smp_valid <= 1'b0;
      smp_pres  <= 2'b00;
    end else begin
      smp_valid <= d_valid[dsel];
      smp_pres  <= d_valid[dsel] ? d_pres[dsel] : 2'b00;
    end
  end

  // Pattern search
  //
  //  request   : rising edge of bitslip_enable. Clears sync_status and starts
  //              comparing at the current shift_cnt.
  //  compare   : every valid sample while searching, except during the match
  //              delay.
  //  match     : sync_status is set and the search stops.
  //  mismatch  : shift_cnt moves to the next offset, wrapping after
  //              shift_cnt_max, and the match delay starts.
  //
  //  match delay: after a mismatch the next MATCH_DELAY valid samples are not
  //  compared. It is the data that has to pass after the shift change before
  //  a sample is made of the new offset only.
  //  10 leaves margin.

  localparam [3:0] MATCH_DELAY = 10;

  wire slip_req = slip_d & ~slip_dd;
  wire compare  = shift_cnt_en && smp_valid && (match_delay_cnt == 'd0);

  always @(posedge adc_clk_div) begin
    slip_d  <= bitslip_enable;
    slip_dd <= slip_d;

    // search state and status
    if (adc_rst) begin
      shift_cnt_en    <= 1'b0;
      sync_status_int <= 1'b0;
    end else if (slip_req) begin
      shift_cnt_en    <= 1'b1;
      sync_status_int <= 1'b0;
    end else if (compare && pattern_match) begin
      shift_cnt_en    <= 1'b0;
      sync_status_int <= 1'b1;
    end

    // offset: cleared by adc_rst, kept through sync_n; the next one on a
    // mismatch
    if (adc_rst) begin
      shift_cnt <= 5'd0;
    end else if (compare && !pattern_match) begin
      shift_cnt <= (shift_cnt >= shift_cnt_max) ? 5'd0 : shift_cnt + 5'd1;
    end

    // match delay after a mismatch
    if (compare && !pattern_match) begin
      match_delay_cnt <= MATCH_DELAY;
    end else if (smp_valid && (match_delay_cnt != 'd0)) begin
      match_delay_cnt <= match_delay_cnt - 1'b1;
    end
  end

  // Filter. With the filter the first sample after every falling edge of
  // filter_rdy_n is kept, one per decimation period.

  generate
  if (EN_FILTER_RDY != 0) begin : g_edge

    wire [ 1:0] edge_keep;

    ad_sample_edge_select #(
      .SAMPLES(2),
      .EDGE("FALL"),
      .ASYNC_RESET(1)
    ) i_edge_select (
      .clk(adc_clk_div),
      .reset(~serdes_valid[1]),
      .ipresent(smp_pres),
      .ilevel(smp_filt_rdy),
      .okeep(edge_keep));

    assign keep = smp_pres & (edge_keep | {2{~filter_enable}});

  end else begin : g_no_edge
    assign keep = smp_pres;
  end
  endgenerate

  // Output words: 16 bit slots, the earliest in the low bits. A 20 bit sample
  // takes two slots, a 16 or 14 bit sample one. One sample per word (16 bit
  // bus, or 32 bit with only the 20 bit depth) goes out directly, otherwise
  // the kept samples are compacted into full words.

  localparam SLOTS   = ADC_DATA_WIDTH / 16;
  localparam COMPACT = SLOTS > (((ENABLE_16BIT != 0) || (ENABLE_14BIT != 0)) ? 1 : 2);

  generate
  if (COMPACT) begin : g_compact

    wire [1:0] slot_keep = (device_code_i == 2'h0) ? {2{keep[0]}} : keep;

    ad_sample_compact #(
      .SLOT_W(16),
      .IN_SLOTS(2),
      .OUT_SLOTS(SLOTS),
      .ASYNC_RESET(1)
    ) i_compact (
      .clk(adc_clk_div),
      .reset(~serdes_valid[1]),
      .idata(smp_slots),
      .ikeep(slot_keep),
      .odata(adc_data),
      .ovalid(adc_valid));

  end else begin : g_direct

    reg [ADC_DATA_WIDTH-1:0] data_r  = 'd0;
    reg                      valid_r = 1'b0;

    always @(posedge adc_clk_div) begin
      data_r <= smp_slots[ADC_DATA_WIDTH-1:0];
    end

    always @(posedge adc_clk_div or negedge serdes_valid[1]) begin
      if (~serdes_valid[1]) begin
        valid_r <= 1'b0;
      end else begin
        valid_r <= keep[0];
      end
    end

    assign adc_data  = data_r;
    assign adc_valid = valid_r;

  end
  endgenerate

endmodule
