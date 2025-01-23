// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022, 2024-2025 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_tx #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter NUM_OUTPUT_PIPELINE = 0,
  parameter LINK_MODE = 1, // 2 - 64B/66B;  1 - 8B/10B
  /* Only 4 is supported at the moment for 8b/10b and 8 for 64b */
  parameter DATA_PATH_WIDTH = LINK_MODE[1] ? 8 : 4,
  parameter TPL_DATA_PATH_WIDTH = LINK_MODE[1] ? 8 : 4,
  parameter ENABLE_CHAR_REPLACE = 1'b0,
  parameter ASYNC_CLK = 1
) (
  input clk,
  input reset,

  input device_clk,
  input device_reset,

  output [DATA_PATH_WIDTH*8*NUM_LANES-1:0] phy_data,
  output [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_charisk,
  output [2*NUM_LANES-1:0] phy_header,

  input sysref,
  output lmfc_edge,
  output lmfc_clk,

  input [NUM_LINKS-1:0] sync,

  input [TPL_DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_data,
  output tx_ready,
  output [TPL_DATA_PATH_WIDTH-1:0] tx_eof,
  output [TPL_DATA_PATH_WIDTH-1:0] tx_sof,
  output [TPL_DATA_PATH_WIDTH-1:0] tx_somf,
  output [TPL_DATA_PATH_WIDTH-1:0] tx_eomf,
  input tx_valid,

  input [NUM_LANES-1:0] cfg_lanes_disable,
  input [NUM_LINKS-1:0] cfg_links_disable,
  input [9:0] cfg_octets_per_multiframe,
  input [7:0] cfg_octets_per_frame,
  input cfg_continuous_cgs,
  input cfg_continuous_ilas,
  input cfg_skip_ilas,
  input [7:0] cfg_mframes_per_ilas,
  input cfg_disable_char_replacement,
  input cfg_disable_scrambler,

  input [9:0] device_cfg_octets_per_multiframe,
  input [7:0] device_cfg_octets_per_frame,
  input [7:0] device_cfg_beats_per_multiframe,
  input [7:0] device_cfg_lmfc_offset,
  input device_cfg_sysref_oneshot,
  input device_cfg_sysref_disable,

  output ilas_config_rd,
  output [1:0] ilas_config_addr,
  input [NUM_LANES*DATA_PATH_WIDTH*8-1:0] ilas_config_data,

  input ctrl_manual_sync_request,

  output device_event_sysref_edge,
  output device_event_sysref_alignment_error,

  output [NUM_LINKS-1:0] status_sync,
  output [1:0] status_state,

  output [31:0] status_synth_params0,
  output [31:0] status_synth_params1,
  output [31:0] status_synth_params2
);

  localparam MAX_OCTETS_PER_FRAME = 32;
  localparam MAX_OCTETS_PER_MULTIFRAME =
    (MAX_OCTETS_PER_FRAME * 32) > 1024 ? 1024 : (MAX_OCTETS_PER_FRAME * 32);
  localparam MAX_BEATS_PER_MULTIFRAME = MAX_OCTETS_PER_MULTIFRAME / DATA_PATH_WIDTH;

  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;

  localparam LMFC_COUNTER_WIDTH = MAX_BEATS_PER_MULTIFRAME > 256 ? 9 :
    MAX_BEATS_PER_MULTIFRAME > 128 ? 8 :
    MAX_BEATS_PER_MULTIFRAME > 64 ? 7 :
    MAX_BEATS_PER_MULTIFRAME > 32 ? 6 :
    MAX_BEATS_PER_MULTIFRAME > 16 ? 5 :
    MAX_BEATS_PER_MULTIFRAME > 8 ? 4 :
    MAX_BEATS_PER_MULTIFRAME > 4 ? 3 :
    MAX_BEATS_PER_MULTIFRAME > 2 ? 2 : 1;

  localparam DW = DATA_PATH_WIDTH * 8 * NUM_LANES;
  localparam CW = DATA_PATH_WIDTH * NUM_LANES;
  localparam HW = 2 * NUM_LANES;

  wire [DW-1:0] phy_data_r;
  wire [CW-1:0] phy_charisk_r;
  wire [HW-1:0] phy_header_r;

  wire eof_gen_reset;
  wire tx_ready_64b_next;
  reg tx_ready_64b = 1'b0;
  wire frame_mark_reset;
  wire [DATA_PATH_WIDTH-1:0] tx_sof_fm;
  wire [DATA_PATH_WIDTH-1:0] tx_eof_fm;
  wire [DATA_PATH_WIDTH-1:0] tx_somf_fm;
  wire [DATA_PATH_WIDTH-1:0] tx_eomf_fm;
  reg [DATA_PATH_WIDTH-1:0] tx_sof_fm_d1;
  reg [DATA_PATH_WIDTH-1:0] tx_eof_fm_d1;
  reg [DATA_PATH_WIDTH-1:0] tx_somf_fm_d1;
  reg [DATA_PATH_WIDTH-1:0] tx_eomf_fm_d1;
  reg [DATA_PATH_WIDTH-1:0] tx_sof_fm_d2;
  reg [DATA_PATH_WIDTH-1:0] tx_eof_fm_d2;
  reg [DATA_PATH_WIDTH-1:0] tx_somf_fm_d2;
  reg [DATA_PATH_WIDTH-1:0] tx_eomf_fm_d2;
  wire lmfc_edge_synced;
  wire lmc_edge;
  wire lmc_quarter_edge;
  wire eoemb;
  wire [DATA_PATH_WIDTH*8*NUM_LANES-1:0] gearbox_data;
  wire tx_ready_nx;
  wire link_lmfc_edge;
  wire link_lmfc_clk;
  wire device_lmfc_edge;
  wire device_lmfc_clk;
  wire device_lmc_edge;
  wire device_lmc_quarter_edge;
  wire device_eoemb;
  wire tx_next_mf_ready;
  wire link_tx_ready;

  wire [7:0] cfg_beats_per_multiframe = cfg_octets_per_multiframe >> DPW_LOG2;
  wire [7:0] device_cfg_beats_per_multiframe_s;

  // If input and output widths are symmetric keep the calculation for backwards
  // compatibility of the software.
  assign device_cfg_beats_per_multiframe_s = (TPL_DATA_PATH_WIDTH == DATA_PATH_WIDTH) ?
                                     device_cfg_octets_per_multiframe >> DPW_LOG2 :
                                     device_cfg_beats_per_multiframe;

  jesd204_lmfc #(
    .LINK_MODE(LINK_MODE),
    .DATA_PATH_WIDTH(TPL_DATA_PATH_WIDTH)
  ) i_lmfc (
    .clk(device_clk),
    .reset(device_reset),

    .cfg_octets_per_multiframe(device_cfg_octets_per_multiframe),
    .cfg_lmfc_offset(device_cfg_lmfc_offset),
    .cfg_beats_per_multiframe(device_cfg_beats_per_multiframe_s),
    .cfg_sysref_oneshot(device_cfg_sysref_oneshot),
    .cfg_sysref_disable(device_cfg_sysref_disable),

    .sysref(sysref),

    .sysref_edge(device_event_sysref_edge),
    .sysref_alignment_error(device_event_sysref_alignment_error),

    .lmfc_edge(device_lmfc_edge),
    .lmfc_clk(device_lmfc_clk),
    .lmfc_counter(),
    .lmc_edge(device_lmc_edge),
    .lmc_quarter_edge(device_lmc_quarter_edge),
    .eoemb(device_eoemb));

  generate
  if (ASYNC_CLK) begin : dual_lmfc_mode

    reg link_lmfc_reset = 1'b1;
    reg device_tx_ready = 1'b0;

    jesd204_lmfc #(
      .LINK_MODE(LINK_MODE),
      .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
    ) i_link_lmfc (
      .clk(clk),
      .reset(link_lmfc_reset),

      .cfg_octets_per_multiframe(cfg_octets_per_multiframe),
      .cfg_lmfc_offset('h0),
      .cfg_beats_per_multiframe(cfg_beats_per_multiframe),
      .cfg_sysref_oneshot(1'b0),
      .cfg_sysref_disable(1'b1),

      .sysref(sysref),

      .sysref_edge(),
      .sysref_alignment_error(),

      .lmfc_edge(link_lmfc_edge),
      .lmfc_clk(link_lmfc_clk),
      .lmfc_counter(),
      .lmc_edge(lmc_edge),
      .lmc_quarter_edge(lmc_quarter_edge),
      .eoemb(eoemb));

    sync_bits #(
      .NUM_OF_BITS (1),
      .ASYNC_CLK(ASYNC_CLK)
    ) i_link_reset_done_cdc (
      .in_bits(~reset),
      .out_clk(device_clk),
      .out_resetn(~device_reset),
      .out_bits(link_reset_n));

    sync_event #(
      .NUM_OF_EVENTS (1)
    ) i_sync_lmfc (
      .in_clk(device_clk),
      .in_event(device_lmfc_edge & link_reset_n),
      .out_clk(clk),
      .out_event(lmfc_edge_synced));

    always @(posedge clk) begin
      if (reset) begin
        link_lmfc_reset <= 1'b1;
      end else if (lmfc_edge_synced) begin
        link_lmfc_reset <= 1'b0;
      end
    end

    jesd204_tx_gearbox #(
      .IN_DATA_PATH_WIDTH(TPL_DATA_PATH_WIDTH),
      .OUT_DATA_PATH_WIDTH(DATA_PATH_WIDTH),
      .NUM_LANES(NUM_LANES),
      .DEPTH(8)
    ) i_tx_gearbox (
      .link_clk(clk),
      .reset(reset),
      .device_clk(device_clk),
      .device_reset(device_reset),
      .device_data(tx_data),
      .device_lmfc_edge(device_lmfc_edge),
      .link_data(gearbox_data),
      .output_ready(tx_ready_nx));

    sync_bits #(
      .NUM_OF_BITS (1),
      .ASYNC_CLK(ASYNC_CLK)
    ) i_next_mf_ready_cdc (
      .in_bits(tx_next_mf_ready),
      .out_clk(device_clk),
      .out_resetn(1'b1),
      .out_bits(device_tx_next_mf_ready));

    always @(posedge device_clk) begin
      if (device_reset) begin
        device_tx_ready <= 1'b0;
      end else if (device_lmfc_edge & device_tx_next_mf_ready) begin
        device_tx_ready <= 1'b1;
      end
    end

    jesd204_frame_mark #(
      .DATA_PATH_WIDTH(TPL_DATA_PATH_WIDTH)
    ) i_device_frame_mark (
      .clk(device_clk),
      .reset(~device_tx_ready),
      .cfg_octets_per_multiframe(device_cfg_octets_per_multiframe),
      .cfg_beats_per_multiframe(device_cfg_beats_per_multiframe_s),
      .cfg_octets_per_frame(device_cfg_octets_per_frame),
      .sof(tx_sof),
      .eof(tx_eof),
      .somf(tx_somf),
      .eomf(tx_eomf));

    assign tx_ready = device_tx_ready;

  end else begin
    assign link_lmfc_edge = device_lmfc_edge;
    assign link_lmfc_clk = device_lmfc_clk;
    assign lmc_edge = device_lmc_edge;
    assign lmc_quarter_edge = device_lmc_quarter_edge;
    assign eoemb = device_eoemb;
    assign gearbox_data = tx_data;

    assign tx_sof = (LINK_MODE == 1) ? tx_sof_fm_d2 : tx_sof_fm;
    assign tx_eof = (LINK_MODE == 1) ? tx_eof_fm_d2 : tx_eof_fm;
    assign tx_somf = (LINK_MODE == 1) ? tx_somf_fm_d2 : tx_somf_fm;
    assign tx_eomf = (LINK_MODE == 1) ? tx_eomf_fm_d2 : tx_eomf_fm;
    assign tx_ready = link_tx_ready;

  end
  endgenerate

  assign lmfc_edge = device_lmfc_edge;
  assign lmfc_clk = device_lmfc_clk;

  assign frame_mark_reset = (LINK_MODE == 1) ? eof_gen_reset : ~tx_ready_64b_next;

  jesd204_frame_mark #(
    .DATA_PATH_WIDTH            (DATA_PATH_WIDTH)
  ) i_frame_mark (
    .clk                        (clk),
    .reset                      (frame_mark_reset),
    .cfg_octets_per_multiframe  (cfg_octets_per_multiframe),
    .cfg_beats_per_multiframe   (cfg_beats_per_multiframe),
    .cfg_octets_per_frame       (cfg_octets_per_frame),
    .sof                        (tx_sof_fm),
    .eof                        (tx_eof_fm),
    .somf                       (tx_somf_fm),
    .eomf                       (tx_eomf_fm));

  always @(posedge clk) begin
    tx_sof_fm_d1  <= tx_sof_fm;
    tx_eof_fm_d1  <= tx_eof_fm;
    tx_somf_fm_d1 <= tx_somf_fm;
    tx_eomf_fm_d1 <= tx_eomf_fm;
    tx_sof_fm_d2  <= tx_sof_fm_d1;
    tx_eof_fm_d2  <= tx_eof_fm_d1;
    tx_somf_fm_d2 <= tx_somf_fm_d1;
    tx_eomf_fm_d2 <= tx_eomf_fm_d1;
  end

  generate
  genvar i;

  if (LINK_MODE[0] == 1) begin : mode_8b10b

  reg [DATA_PATH_WIDTH-1:0] tx_eof_fm_d3;
  reg [DATA_PATH_WIDTH-1:0] tx_eomf_fm_d3;
  wire [NUM_LANES-1:0] lane_cgs_enable;
  wire [DW-1:0] ilas_data;
  wire [DATA_PATH_WIDTH*NUM_LANES-1:0] ilas_charisk;

  wire cfg_generate_eomf = 1'b1;

  always @(posedge clk) begin
    tx_eof_fm_d3 <= tx_eof_fm_d2;
    tx_eomf_fm_d3 <= tx_eomf_fm_d2;
  end

  jesd204_tx_ctrl #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
  ) i_tx_ctrl (
    .clk(clk),
    .reset(reset),

    .sync(sync),
    .lmfc_edge(link_lmfc_edge),
    .somf(tx_somf_fm_d2),
    .somf_early2(tx_somf_fm),
    .eomf(tx_eomf_fm_d2),

    .lane_cgs_enable(lane_cgs_enable),
    .eof_reset(eof_gen_reset),

    .tx_ready(link_tx_ready),
    .tx_ready_nx(tx_ready_nx),
    .tx_next_mf_ready(tx_next_mf_ready),

    .ilas_data(ilas_data),
    .ilas_charisk(ilas_charisk),

    .ilas_config_addr(ilas_config_addr),
    .ilas_config_rd(ilas_config_rd),
    .ilas_config_data(ilas_config_data),

    .cfg_lanes_disable(cfg_lanes_disable),
    .cfg_links_disable(cfg_links_disable),
    .cfg_continuous_cgs(cfg_continuous_cgs),
    .cfg_continuous_ilas(cfg_continuous_ilas),
    .cfg_skip_ilas(cfg_skip_ilas),
    .cfg_mframes_per_ilas(cfg_mframes_per_ilas),
    .cfg_octets_per_multiframe(cfg_octets_per_multiframe),
    .ctrl_manual_sync_request(ctrl_manual_sync_request),

    .status_sync(status_sync),
    .status_state(status_state));

  for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane

    localparam D_START = i * DATA_PATH_WIDTH*8;
    localparam D_STOP = D_START + DATA_PATH_WIDTH*8-1;
    localparam C_START = i * DATA_PATH_WIDTH;
    localparam C_STOP = C_START + DATA_PATH_WIDTH-1;

    jesd204_tx_lane #(
      .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
      .ENABLE_CHAR_REPLACE(ENABLE_CHAR_REPLACE)
    ) i_lane (
      .clk(clk),

      .eof(tx_eof_fm_d3),
      .eomf(tx_eomf_fm_d3),

      .cgs_enable(lane_cgs_enable[i]),

      .ilas_data(ilas_data[D_STOP:D_START]),
      .ilas_charisk(ilas_charisk[C_STOP:C_START]),

      .tx_data(gearbox_data[D_STOP:D_START]),
      .tx_ready(link_tx_ready),

      .phy_data(phy_data_r[D_STOP:D_START]),
      .phy_charisk(phy_charisk_r[C_STOP:C_START]),

      .cfg_octets_per_frame(cfg_octets_per_frame),
      .cfg_disable_char_replacement(cfg_disable_char_replacement),
      .cfg_disable_scrambler(cfg_disable_scrambler));
  end

  assign phy_header_r = 'h0;

  end

  if (LINK_MODE[1] == 1) begin : mode_64b66b

    for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane
      localparam D_START = i * DATA_PATH_WIDTH*8;
      localparam D_STOP = D_START + DATA_PATH_WIDTH*8-1;
      localparam H_START = i * 2;
      localparam H_STOP = H_START + 2 -1;

      jesd204_tx_lane_64b i_lane (
        .clk(clk),
        .reset(reset),

        .tx_data(gearbox_data[D_STOP:D_START]),
        .tx_ready(tx_ready_64b),

        .phy_data(phy_data_r[D_STOP:D_START]),
        .phy_header(phy_header_r[H_STOP:H_START]),

        .lmc_edge(lmc_edge),
        .lmc_quarter_edge(lmc_quarter_edge),
        .eoemb(eoemb),

        .cfg_disable_scrambler(cfg_disable_scrambler),
        .cfg_header_mode(2'b0),
        .cfg_lane_disable(cfg_lanes_disable[i]));
    end

    assign tx_ready_64b_next = reset ? 1'b0 : (link_lmfc_edge || tx_ready_64b);

    always @(posedge clk) begin
      if (reset) begin
        tx_ready_64b <= 1'b0;
      end else begin
        tx_ready_64b <= tx_ready_64b_next;
      end
    end

    assign tx_ready_nx = tx_ready_64b_next;
    assign tx_next_mf_ready = 1'b1;

    assign link_tx_ready = tx_ready_64b;
    // Link considered in DATA phase when SYSREF received and LEMC clock started
    // running
    assign status_state = {2{tx_ready_64b}};

    assign phy_charisk_r = 'h0;
    assign ilas_config_rd = 'h0;
    assign ilas_config_addr = 'h0;
    assign status_sync = 'h0;

  end

  endgenerate

  util_pipeline_stage #(
    .WIDTH(CW + DW + HW),
    .REGISTERED(NUM_OUTPUT_PIPELINE)
  ) i_output_pipeline_stage (
    .clk(clk),
    .in({
      phy_data_r,
      phy_charisk_r,
      phy_header_r
    }),
    .out({
      phy_data,
      phy_charisk,
      phy_header
    }));

  // Core static parameters
  assign status_synth_params0 = {NUM_LANES};
  assign status_synth_params1 = {
                   /*31:16 */  16'b0,
                   /*15: 8 */  1'b0,TPL_DATA_PATH_WIDTH[6:0],
                   /* 7: 0 */  4'b0,DPW_LOG2[3:0]};
  assign status_synth_params2 = {
                   /*31:19 */  13'b0,
                   /*   18 */  ENABLE_CHAR_REPLACE[0],
                   /*17:13 */  5'b0,
                   /*   12 */  ASYNC_CLK[0],
                   /*11:10 */  2'b0,
                   /* 9: 8 */  LINK_MODE[1:0],
                   /* 7: 0 */  NUM_LINKS[7:0]};

endmodule
