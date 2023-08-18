// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_rx #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter NUM_INPUT_PIPELINE = 1,
  parameter NUM_OUTPUT_PIPELINE = 1,
  parameter LINK_MODE = 1, // 2 - 64B/66B;  1 - 8B/10B
  /* Only 4 is supported at the moment for 8b/10b and 8 for 64b */
  parameter DATA_PATH_WIDTH = LINK_MODE == 2 ? 8 : 4,
  parameter ENABLE_FRAME_ALIGN_CHECK = 1,
  parameter ENABLE_FRAME_ALIGN_ERR_RESET = 0,
  parameter ENABLE_CHAR_REPLACE = 0,
  parameter ASYNC_CLK = 1,
  parameter TPL_DATA_PATH_WIDTH = LINK_MODE == 2 ? 8 : 4
) (
  input clk,   // Link clock, lane rate / 40 or lane rate / 20 or lane rate / 66
  input reset,

  input device_clk, // Integer multiple of frame clock
  input device_reset,

  input [DATA_PATH_WIDTH*8*NUM_LANES-1:0] phy_data,
  input [2*NUM_LANES-1:0] phy_header,
  input [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_charisk,
  input [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_notintable,
  input [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_disperr,
  input [NUM_LANES-1:0] phy_block_sync,

  input sysref,
  output lmfc_edge,
  output lmfc_clk,

  output device_event_sysref_alignment_error,
  output device_event_sysref_edge,
  output event_frame_alignment_error,
  output event_unexpected_lane_state_error,

  output [NUM_LINKS-1:0] sync,

  output phy_en_char_align,

  output [TPL_DATA_PATH_WIDTH*8*NUM_LANES-1:0] rx_data,
  output rx_valid,
  output [TPL_DATA_PATH_WIDTH-1:0] rx_eof,
  output [TPL_DATA_PATH_WIDTH-1:0] rx_sof,
  output [TPL_DATA_PATH_WIDTH-1:0] rx_eomf,
  output [TPL_DATA_PATH_WIDTH-1:0] rx_somf,

  input [NUM_LANES-1:0] cfg_lanes_disable,
  input [NUM_LINKS-1:0] cfg_links_disable,
  input [9:0] cfg_octets_per_multiframe,
  input [7:0] cfg_octets_per_frame,
  input cfg_disable_scrambler,
  input cfg_disable_char_replacement,
  input [7:0] cfg_frame_align_err_threshold,

  input [9:0] device_cfg_octets_per_multiframe,
  input [7:0] device_cfg_octets_per_frame,
  input [7:0] device_cfg_beats_per_multiframe,
  input [7:0] device_cfg_lmfc_offset,
  input device_cfg_sysref_oneshot,
  input device_cfg_sysref_disable,
  input device_cfg_buffer_early_release,
  input [7:0] device_cfg_buffer_delay,

  input ctrl_err_statistics_reset,
  input [6:0] ctrl_err_statistics_mask,

  output [32*NUM_LANES-1:0] status_err_statistics_cnt,

  output [NUM_LANES-1:0] ilas_config_valid,
  output [NUM_LANES*2-1:0] ilas_config_addr,
  output [NUM_LANES*DATA_PATH_WIDTH*8-1:0] ilas_config_data,

  output [1:0] status_ctrl_state,
  output [2*NUM_LANES-1:0] status_lane_cgs_state,
  output [NUM_LANES-1:0] status_lane_ifs_ready,
  output [14*NUM_LANES-1:0] status_lane_latency,
  output [3*NUM_LANES-1:0] status_lane_emb_state,
  output [8*NUM_LANES-1:0] status_lane_frame_align_err_cnt,

  output [31:0] status_synth_params0,
  output [31:0] status_synth_params1,
  output [31:0] status_synth_params2
);

  /*
   * Can be used to enable additional pipeline stages to ease timing. Usually not
   * necessary.
   */
  localparam CHAR_INFO_REGISTERED = 0;
  localparam ALIGN_MUX_REGISTERED = 1;
  localparam SCRAMBLER_REGISTERED = 0;

  /*
   * Maximum number of octets per multiframe for ADI JESD204 DACs is 256 (Adjust
   * as necessary). Divide by data path width.
   */
  localparam MAX_OCTETS_PER_FRAME = 32;
  localparam MAX_OCTETS_PER_MULTIFRAME =
    (MAX_OCTETS_PER_FRAME * 32) > 1024 ? 1024 : (MAX_OCTETS_PER_FRAME * 32);
  localparam MAX_BEATS_PER_MULTIFRAME = MAX_OCTETS_PER_MULTIFRAME / DATA_PATH_WIDTH;
  localparam ELASTIC_BUFFER_SIZE = MAX_BEATS_PER_MULTIFRAME;
  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;

  localparam LMFC_COUNTER_WIDTH = MAX_BEATS_PER_MULTIFRAME > 256 ? 9 :
    MAX_BEATS_PER_MULTIFRAME > 128 ? 8 :
    MAX_BEATS_PER_MULTIFRAME > 64 ? 7 :
    MAX_BEATS_PER_MULTIFRAME > 32 ? 6 :
    MAX_BEATS_PER_MULTIFRAME > 16 ? 5 :
    MAX_BEATS_PER_MULTIFRAME > 8 ? 4 :
    MAX_BEATS_PER_MULTIFRAME > 4 ? 3 :
    MAX_BEATS_PER_MULTIFRAME > 2 ? 2 : 1;

  /* Helper for common expressions */
  localparam DW = 8*DATA_PATH_WIDTH*NUM_LANES;
  localparam ODW = 8*TPL_DATA_PATH_WIDTH*NUM_LANES;
  localparam CW = DATA_PATH_WIDTH*NUM_LANES;
  localparam HW = 2*NUM_LANES;

  wire [7:0] cfg_beats_per_multiframe = cfg_octets_per_multiframe >> DPW_LOG2;
  wire [7:0] device_cfg_beats_per_multiframe_s;

  wire [NUM_LANES-1:0] cgs_reset;
  wire [NUM_LANES-1:0] cgs_ready;
  wire [NUM_LANES-1:0] ifs_reset;

  reg buffer_release_n = 1'b1;
  reg buffer_release_d1 = 1'b0;
  wire [NUM_LANES-1:0] buffer_ready_n;
  wire all_buffer_ready_n;
  wire dev_all_buffer_ready_n;

  reg eof_reset = 1'b1;

  wire [DW-1:0] phy_data_r;
  wire [HW-1:0] phy_header_r;
  wire [CW-1:0] phy_charisk_r;
  wire [CW-1:0] phy_notintable_r;
  wire [CW-1:0] phy_disperr_r;
  wire [NUM_LANES-1:0] phy_block_sync_r;

  wire [ODW-1:0] rx_data_s;

  wire rx_valid_s = buffer_release_d1;

  wire [7:0] lmfc_counter;
  wire latency_monitor_reset;

  wire [3*NUM_LANES-1:0] frame_align;
  wire [NUM_LANES-1:0] ifs_ready;

  wire event_data_phase;
  wire err_statistics_reset;

  wire lmfc_edge_synced;

  reg [NUM_LANES-1:0] frame_align_err_thresh_met = {NUM_LANES{1'b0}};
  reg [NUM_LANES-1:0] event_frame_alignment_error_per_lane = {NUM_LANES{1'b0}};

  reg buffer_release_opportunity = 1'b0;

  always @(posedge device_clk) begin
    if (lmfc_counter == device_cfg_buffer_delay ||
        device_cfg_buffer_early_release == 1'b1) begin
      buffer_release_opportunity <= 1'b1;
    end else begin
      buffer_release_opportunity <= 1'b0;
    end
  end

  assign all_buffer_ready_n = |(buffer_ready_n & ~cfg_lanes_disable);

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK(ASYNC_CLK)
  ) i_all_buffer_ready_cdc (
    .in_bits(all_buffer_ready_n),
    .out_clk(device_clk),
    .out_resetn(1'b1),
    .out_bits(dev_all_buffer_ready_n));

  always @(posedge device_clk) begin
    if (device_reset == 1'b1) begin
      buffer_release_n <= 1'b1;
    end else begin
      if (buffer_release_opportunity == 1'b1) begin
        buffer_release_n <= dev_all_buffer_ready_n;
      end
    end
    buffer_release_d1 <= ~buffer_release_n;
    eof_reset <= buffer_release_n;
  end

  pipeline_stage #(
    .WIDTH(NUM_LANES + (3 * CW) + HW + DW),
    .REGISTERED(NUM_INPUT_PIPELINE)
  ) i_input_pipeline_stage (
    .clk(clk),
    .in({
      phy_data,
      phy_header,
      phy_charisk,
      phy_notintable,
      phy_disperr,
      phy_block_sync
    }),
    .out({
      phy_data_r,
      phy_header_r,
      phy_charisk_r,
      phy_notintable_r,
      phy_disperr_r,
      phy_block_sync_r
    }));

  pipeline_stage #(
    .WIDTH(ODW+2),
    .REGISTERED(NUM_OUTPUT_PIPELINE)
  ) i_output_pipeline_stage (
    .clk(device_clk),
    .in({
      eof_reset,
      rx_data_s,
      rx_valid_s
    }),
    .out({
      eof_reset_d,
      rx_data,
      rx_valid
    }));

  // If input and output widths are symmetric keep the calculation for backwards
  // compatibility of the software.
  assign device_cfg_beats_per_multiframe_s = (TPL_DATA_PATH_WIDTH == DATA_PATH_WIDTH) ?
                                     device_cfg_octets_per_multiframe >> DPW_LOG2 :
                                     device_cfg_beats_per_multiframe;

  jesd204_lmfc #(
    .LINK_MODE (LINK_MODE),
    .DATA_PATH_WIDTH (TPL_DATA_PATH_WIDTH)
  ) i_lmfc (
    .clk (device_clk),
    .reset (device_reset),

    .cfg_octets_per_multiframe (device_cfg_octets_per_multiframe),
    .cfg_beats_per_multiframe (device_cfg_beats_per_multiframe_s),
    .cfg_lmfc_offset (device_cfg_lmfc_offset),
    .cfg_sysref_oneshot (device_cfg_sysref_oneshot),
    .cfg_sysref_disable (device_cfg_sysref_disable),

    .sysref (sysref),
    .lmfc_edge (lmfc_edge),
    .lmfc_clk (lmfc_clk),
    .lmfc_counter (lmfc_counter),
    .lmc_edge (),
    .lmc_quarter_edge (),
    .eoemb (),

    .sysref_edge (device_event_sysref_edge),
    .sysref_alignment_error (device_event_sysref_alignment_error));

  jesd204_frame_mark #(
    .DATA_PATH_WIDTH (TPL_DATA_PATH_WIDTH)
  ) i_frame_mark (
    .clk (device_clk),
    .reset (eof_reset_d),
    .cfg_beats_per_multiframe (device_cfg_beats_per_multiframe_s),
    .cfg_octets_per_multiframe (device_cfg_octets_per_multiframe),
    .cfg_octets_per_frame (device_cfg_octets_per_frame),
    .sof (rx_sof),
    .eof (rx_eof),
    .somf (rx_somf),
    .eomf (rx_eomf));

  generate
  genvar i;

  sync_event #(
    .NUM_OF_EVENTS (1),
    .ASYNC_CLK(ASYNC_CLK)
  ) i_sync_lmfc (
    .in_clk(device_clk),
    .in_event(lmfc_edge),
    .out_clk(clk),
    .out_event(lmfc_edge_synced));

  if (LINK_MODE[0] == 1) begin : mode_8b10b

  wire unexpected_lane_state_error;
  reg unexpected_lane_state_error_d = 1'b0;

  jesd204_rx_ctrl #(
    .NUM_LANES (NUM_LANES),
    .NUM_LINKS (NUM_LINKS),
    .ENABLE_FRAME_ALIGN_ERR_RESET (ENABLE_FRAME_ALIGN_ERR_RESET)
  ) i_rx_ctrl (
    .clk (clk),
    .reset (reset),

    .cfg_lanes_disable (cfg_lanes_disable),
    .cfg_links_disable (cfg_links_disable),

    .phy_ready (1'b1),
    .phy_en_char_align (phy_en_char_align),

    .lmfc_edge (lmfc_edge_synced),
    .frame_align_err_thresh_met (frame_align_err_thresh_met),
    .sync (sync),

    .latency_monitor_reset (latency_monitor_reset),

    .cgs_reset (cgs_reset),
    .cgs_ready (cgs_ready),

    .ifs_reset (ifs_reset),

    .status_state (status_ctrl_state),

    .event_data_phase (event_data_phase));

  assign err_statistics_reset = ctrl_err_statistics_reset ||
                                event_data_phase;

  for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane

    localparam D_START = i * DATA_PATH_WIDTH*8;
    localparam D_STOP = D_START + DATA_PATH_WIDTH*8-1;
    localparam OD_START = i * TPL_DATA_PATH_WIDTH*8;
    localparam OD_STOP = OD_START + TPL_DATA_PATH_WIDTH*8-1;
    localparam C_START = i * DATA_PATH_WIDTH;
    localparam C_STOP = C_START + DATA_PATH_WIDTH-1;

    jesd204_rx_lane #(
      .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
      .TPL_DATA_PATH_WIDTH(TPL_DATA_PATH_WIDTH),
      .CHAR_INFO_REGISTERED(CHAR_INFO_REGISTERED),
      .ALIGN_MUX_REGISTERED(ALIGN_MUX_REGISTERED),
      .SCRAMBLER_REGISTERED(SCRAMBLER_REGISTERED),
      .ELASTIC_BUFFER_SIZE(ELASTIC_BUFFER_SIZE),
      .ENABLE_FRAME_ALIGN_CHECK(ENABLE_FRAME_ALIGN_CHECK),
      .ENABLE_CHAR_REPLACE(ENABLE_CHAR_REPLACE),
      .ASYNC_CLK(ASYNC_CLK)
    ) i_lane (
      .clk(clk),
      .reset(reset),

      .device_clk(device_clk),
      .device_reset(device_reset),

      .phy_data(phy_data_r[D_STOP:D_START]),
      .phy_charisk(phy_charisk_r[C_STOP:C_START]),
      .phy_notintable(phy_notintable_r[C_STOP:C_START]),
      .phy_disperr(phy_disperr_r[C_STOP:C_START]),

      .cgs_reset(cgs_reset[i]),
      .cgs_ready(cgs_ready[i]),

      .ifs_reset(ifs_reset[i]),

      .rx_data(rx_data_s[OD_STOP:OD_START]),

      .buffer_release_n(buffer_release_n),
      .buffer_ready_n(buffer_ready_n[i]),

      .cfg_octets_per_multiframe(cfg_octets_per_multiframe),
      .cfg_octets_per_frame(cfg_octets_per_frame),
      .cfg_disable_char_replacement(cfg_disable_char_replacement),
      .cfg_disable_scrambler(cfg_disable_scrambler),

      .err_statistics_reset(err_statistics_reset),
      .ctrl_err_statistics_mask(ctrl_err_statistics_mask[2:0]),
      .status_err_statistics_cnt(status_err_statistics_cnt[32*i+31:32*i]),

      .ilas_config_valid(ilas_config_valid[i]),
      .ilas_config_addr(ilas_config_addr[2*i+1:2*i]),
      .ilas_config_data(ilas_config_data[D_STOP:D_START]),

      .status_cgs_state(status_lane_cgs_state[2*i+1:2*i]),
      .status_ifs_ready(ifs_ready[i]),
      .status_frame_align(frame_align[3*i+2:3*i]),

      .status_frame_align_err_cnt(status_lane_frame_align_err_cnt[8*i+7:8*i]));

    if(ENABLE_FRAME_ALIGN_CHECK) begin : gen_frame_align_err_thresh
      always @(posedge clk) begin
        if (reset) begin
          frame_align_err_thresh_met[i] <= 1'b0;
          event_frame_alignment_error_per_lane[i] <= 1'b0;
        end else begin
          if (status_lane_frame_align_err_cnt[8*i+7:8*i] >= cfg_frame_align_err_threshold) begin
            frame_align_err_thresh_met[i] <= cgs_ready[i];
            event_frame_alignment_error_per_lane[i] <= ~frame_align_err_thresh_met[i];
          end else begin
            frame_align_err_thresh_met[i] <= 1'b0;
            event_frame_alignment_error_per_lane[i] <= 1'b0;
          end
        end
      end
    end else begin : gen_no_frame_align_err_thresh
      always @(*) begin
        frame_align_err_thresh_met[i] <= 1'b0;
        event_frame_alignment_error_per_lane[i] <= 1'b0;
      end
    end
  end

  assign event_frame_alignment_error = |event_frame_alignment_error_per_lane;

  /* If one of the enabled lanes falls out of DATA phase while the link is in DATA phase
   * report an error event */
  assign unexpected_lane_state_error = |(~(cgs_ready|cfg_lanes_disable)) & &status_ctrl_state;
  always @(posedge clk) begin
    unexpected_lane_state_error_d <= unexpected_lane_state_error;
  end
  assign event_unexpected_lane_state_error = unexpected_lane_state_error & ~unexpected_lane_state_error_d;

  /* Delay matching based on the number of pipeline stages */
  reg [NUM_LANES-1:0] ifs_ready_d1 = 1'b0;
  reg [NUM_LANES-1:0] ifs_ready_d2 = 1'b0;
  reg [NUM_LANES-1:0] ifs_ready_mux;

  always @(posedge clk) begin
    ifs_ready_d1 <= ifs_ready;
    ifs_ready_d2 <= ifs_ready_d1;
  end

  always @(*) begin
    case (SCRAMBLER_REGISTERED + ALIGN_MUX_REGISTERED)
    1: ifs_ready_mux = ifs_ready_d1;
    2: ifs_ready_mux = ifs_ready_d2;
    default: ifs_ready_mux = ifs_ready;
    endcase
  end

  jesd204_lane_latency_monitor #(
    .NUM_LANES(NUM_LANES),
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
  ) i_lane_latency_monitor (
    .clk(clk),
    .reset(latency_monitor_reset),

    .lane_ready(ifs_ready_mux),
    .lane_frame_align(frame_align),
    .lane_latency_ready(status_lane_ifs_ready),
    .lane_latency(status_lane_latency));

  assign status_lane_emb_state = 'b0;

  end

  if (LINK_MODE[1] == 1) begin : mode_64b66b

  wire [NUM_LANES-1:0] emb_lock;
  wire link_buffer_release_n;

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK(ASYNC_CLK)
  ) i_buffer_release_cdc (
    .in_bits(buffer_release_n),
    .out_clk(clk),
    .out_resetn(1'b1),
    .out_bits(link_buffer_release_n));

  jesd204_rx_ctrl_64b  #(
    .NUM_LANES(NUM_LANES)
  ) i_jesd204_rx_ctrl_64b (
    .clk(clk),
    .reset(reset),

    .cfg_lanes_disable(cfg_lanes_disable),

    .phy_block_sync(phy_block_sync_r),
    .emb_lock(emb_lock),

    .all_emb_lock(all_emb_lock),
    .buffer_release_n(link_buffer_release_n),

    .status_state(status_ctrl_state),
    .event_unexpected_lane_state_error(event_unexpected_lane_state_error));

  for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane

    localparam D_START = i * DATA_PATH_WIDTH*8;
    localparam D_STOP = D_START + DATA_PATH_WIDTH*8-1;
    localparam TPL_D_START = i * TPL_DATA_PATH_WIDTH*8;
    localparam TPL_D_STOP = TPL_D_START + TPL_DATA_PATH_WIDTH*8-1;
    localparam H_START = i * 2;
    localparam H_STOP = H_START + 2-1;

    wire [7:0] status_lane_skew;

    jesd204_rx_lane_64b #(
      .ELASTIC_BUFFER_SIZE(ELASTIC_BUFFER_SIZE),
      .TPL_DATA_PATH_WIDTH(TPL_DATA_PATH_WIDTH),
      .ASYNC_CLK(ASYNC_CLK)
    ) i_lane (
      .clk(clk),
      .reset(reset),

      .device_clk(device_clk),
      .device_reset(device_reset),

      .phy_data(phy_data_r[D_STOP:D_START]),
      .phy_header(phy_header_r[H_STOP:H_START]),
      .phy_block_sync(phy_block_sync_r[i]),

      .cfg_disable_scrambler(cfg_disable_scrambler),
      .cfg_header_mode(2'b0),
      .cfg_rx_thresh_emb_err(5'd8),
      .cfg_beats_per_multiframe(cfg_beats_per_multiframe),

      .rx_data(rx_data_s[TPL_D_STOP:TPL_D_START]),

      .buffer_release_n(buffer_release_n),
      .buffer_ready_n(buffer_ready_n[i]),
      .all_buffer_ready_n(all_buffer_ready_n),

      .lmfc_edge(lmfc_edge_synced),
      .emb_lock(emb_lock[i]),

      .ctrl_err_statistics_reset(ctrl_err_statistics_reset),
      .ctrl_err_statistics_mask(ctrl_err_statistics_mask[6:3]),
      .status_err_statistics_cnt(status_err_statistics_cnt[32*i+31:32*i]),

      .status_lane_emb_state(status_lane_emb_state[3*i+2:3*i]),
      .status_lane_skew(status_lane_skew));

  assign status_lane_latency[14*(i+1)-1:14*i] = {3'b0,status_lane_skew,3'b0};

  end

  // Assign unused outputs
  assign sync = 'b0;
  assign phy_en_char_align = 1'b0;

  assign ilas_config_valid ='b0;
  assign ilas_config_addr = 'b0;
  assign ilas_config_data = 'b0;
  assign status_lane_cgs_state = 'b0;
  assign status_lane_ifs_ready = {NUM_LANES{1'b1}};
  assign event_frame_alignment_error = 1'b0;

  end

  endgenerate

  // Core static parameters
  assign status_synth_params0 = {NUM_LANES};
  assign status_synth_params1 = {
                   /*31:16 */  16'b0,
                   /*15: 8 */  1'b0,TPL_DATA_PATH_WIDTH[6:0],
                   /* 7: 0 */  4'b0,DPW_LOG2[3:0]};
  assign status_synth_params2 = {
                   /*31:19 */  13'b0,
                   /*   18 */  ENABLE_CHAR_REPLACE[0],
                   /*   17 */  ENABLE_FRAME_ALIGN_ERR_RESET[0],
                   /*   16 */  ENABLE_FRAME_ALIGN_CHECK[0],
                   /*15:13 */  3'b0,
                   /*   12 */  ASYNC_CLK[0],
                   /*11:10 */  2'b0,
                   /* 9: 8 */  LINK_MODE[1:0],
                   /* 7: 0 */  NUM_LINKS[7:0]};

endmodule
