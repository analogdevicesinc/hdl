// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MODE="1x100G": one 100GE port, 512b to fpga_core, 384b (6x64) to the MRMAC.
 * MODE="4x25G": one 25GE port, 64b on both sides.
 * MODE="1x40G": one 40GE port, 256b on both sides (4x64 MRMAC words).
 */

`timescale 1ns/100ps

module mrmac_gty_wrapper #(
  parameter MODE = "1x100G",
  parameter AXIS_DATA_WIDTH = (MODE == "4x25G") ? 64 : (MODE == "1x40G") ? 256 : 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter SEG_COUNT   = (MODE == "4x25G") ? 1 : (MODE == "1x40G") ? 4 : 6,
  parameter SEG_WIDTH   = 64,
  parameter KUSER_WIDTH = 11,
  parameter NARROW      = SEG_COUNT*SEG_WIDTH,
  parameter NARROW_KEEP = NARROW/8,
  parameter NECK        = 1536,
  parameter NECK_KEEP   = NECK/8,
  // Depths are in bytes.
  parameter RX_FIFO_DEPTH = 16384,
  parameter TX_FIFO_DEPTH = 16384,
  // Corundum carries its rel timestamp in an 80-bit CMAC-compatible field
  // (low 48 bits used); the MRMAC PTP timer/timestamp is 55-bit.
  parameter PTP_TS_WIDTH   = 80,
  parameter COR_FNS_WIDTH  = 16,    // Corundum fractional-ns bits
  parameter MRMAC_TS_WIDTH = 55,
  parameter MRMAC_FNS_WIDTH = 8,    // MRMAC fractional-ns bits (LSB = 2^-8 ns)
  // Clocks between MRMAC PTP st_sync transitions.
  parameter PTP_SYNC_CYCLES = 32
) (
  input  wire                        tx_axi_clk,
  input  wire                        rx_axi_clk,

  input  wire                        tx_reset_in,
  input  wire                        rx_reset_in,

  output wire                        tx_clk,
  output wire                        tx_rst,

  input  wire [AXIS_DATA_WIDTH-1:0]  tx_axis_tdata,
  input  wire [AXIS_KEEP_WIDTH-1:0]  tx_axis_tkeep,
  input  wire                        tx_axis_tvalid,
  output wire                        tx_axis_tready,
  input  wire                        tx_axis_tlast,
  input  wire [16+1-1:0]             tx_axis_tuser,   // {tag[15:0], error}

  input  wire [79:0]                 tx_ptp_time,
  output wire [79:0]                 tx_ptp_ts,
  output wire [15:0]                 tx_ptp_ts_tag,
  output wire                        tx_ptp_ts_valid,

  input  wire                        tx_enable,
  input  wire                        tx_lfc_en,
  input  wire                        tx_lfc_req,
  input  wire [7:0]                  tx_pfc_en,
  input  wire [7:0]                  tx_pfc_req,

  output wire                        rx_clk,
  output wire                        rx_rst,

  output wire [AXIS_DATA_WIDTH-1:0]  rx_axis_tdata,
  output wire [AXIS_KEEP_WIDTH-1:0]  rx_axis_tkeep,
  output wire                        rx_axis_tvalid,
  output wire                        rx_axis_tlast,
  output wire [80+1-1:0]             rx_axis_tuser,   // {ptp_ts[79:0], error}

  output wire                        rx_ptp_clk,
  output wire                        rx_ptp_rst,
  input  wire [79:0]                 rx_ptp_time,

  input  wire                        rx_enable,
  output wire                        rx_status,
  input  wire                        rx_lfc_en,
  output wire                        rx_lfc_req,
  input  wire                        rx_lfc_ack,
  input  wire [7:0]                  rx_pfc_en,
  output wire [7:0]                  rx_pfc_req,
  input  wire [7:0]                  rx_pfc_ack,

  // SEG_COUNT x 64b words, word 0 in the low bits; 11b tkeep_user per word.
  output wire [SEG_COUNT*SEG_WIDTH-1:0]   mrmac_tx_axis_tdata,
  output wire [SEG_COUNT*KUSER_WIDTH-1:0] mrmac_tx_axis_tkeep_user,
  output wire                             mrmac_tx_axis_tvalid,
  input  wire                             mrmac_tx_axis_tready,
  output wire                             mrmac_tx_axis_tlast,

  input  wire [SEG_COUNT*SEG_WIDTH-1:0]   mrmac_rx_axis_tdata,
  input  wire [SEG_COUNT*KUSER_WIDTH-1:0] mrmac_rx_axis_tkeep_user,
  input  wire                             mrmac_rx_axis_tvalid,
  input  wire                             mrmac_rx_axis_tlast,

  input  wire                        mrmac_stat_rx_status,
  output wire                        ctl_tx_enable,
  output wire                        ctl_rx_enable,

  // Pause: 9-bit {lfc, pfc[7:0]} per direction, the same layout as CMAC.
  output wire [8:0]                  mrmac_ctl_tx_pause_enable,
  output wire [8:0]                  mrmac_ctl_tx_pause_req,
  output wire [8:0]                  mrmac_ctl_rx_pause_enable,
  output wire [8:0]                  mrmac_ctl_rx_pause_ack,
  input  wire [8:0]                  mrmac_stat_rx_pause_req,

  input  wire [MRMAC_TS_WIDTH-1:0]   mrmac_rx_ptp_tstamp,

  output wire [1:0]                  mrmac_tx_ptp_1588op,
  output wire [15:0]                 mrmac_tx_ptp_tag_field,
  input  wire [MRMAC_TS_WIDTH-1:0]   mrmac_tx_ptp_tstamp,
  input  wire [15:0]                 mrmac_tx_ptp_tstamp_tag,
  input  wire                        mrmac_tx_ptp_tstamp_valid,

  output wire [MRMAC_TS_WIDTH-1:0]   mrmac_tx_ptp_systemtimer,
  output wire                        mrmac_tx_ptp_st_sync,
  output wire                        mrmac_tx_ptp_st_overwrite,
  output wire [MRMAC_TS_WIDTH-1:0]   mrmac_rx_ptp_systemtimer,
  output wire                        mrmac_rx_ptp_st_sync,
  output wire                        mrmac_rx_ptp_st_overwrite,

  output wire                        rx_fifo_overflow
);

  initial begin
    if (MODE != "1x100G" && MODE != "4x25G" && MODE != "1x40G") begin
      $error("Error: MODE must be \"1x100G\", \"4x25G\" or \"1x40G\" (instance %m)");
      $finish;
    end
  end

  // tuser: TX {tag[15:0], error}; RX {ptp_ts[79:0], error}
  localparam TX_USER_WIDTH = 16 + 1;
  localparam RX_USER_WIDTH = PTP_TS_WIDTH + 1;

  assign tx_clk = tx_axi_clk;
  assign rx_clk = rx_axi_clk;
  assign rx_ptp_clk = rx_axi_clk;

  sync_reset #(
    .N(4)
  ) tx_rst_sync_i (
    .clk(tx_axi_clk),
    .rst(tx_reset_in),
    .out(tx_rst)
  );
  sync_reset #(
    .N(4)
  ) rx_rst_sync_i (
    .clk(rx_axi_clk),
    .rst(rx_reset_in),
    .out(rx_rst)
  );
  sync_reset #(
    .N(4)
  ) rx_ptp_rst_sync_i (
    .clk(rx_axi_clk),
    .rst(rx_reset_in),
    .out(rx_ptp_rst)
  );

  assign ctl_tx_enable = tx_enable;
  assign ctl_rx_enable = rx_enable;
  assign rx_status = mrmac_stat_rx_status;

  wire [NARROW-1:0]          tx_pf_tdata;
  wire [NARROW_KEEP-1:0]     tx_pf_tkeep;
  wire                       tx_pf_tvalid;
  wire                       tx_pf_tready;
  wire                       tx_pf_tlast;
  wire [TX_USER_WIDTH-1:0]   tx_pf_tuser;

  generate
  if (MODE == "1x100G") begin : g_tx_100g
    wire [AXIS_DATA_WIDTH-1:0] pad_tdata;
    wire [AXIS_KEEP_WIDTH-1:0] pad_tkeep;
    wire                       pad_tvalid, pad_tready, pad_tlast;
    wire [TX_USER_WIDTH-1:0]   pad_tuser;

    cmac_pad #(
      .DATA_WIDTH(AXIS_DATA_WIDTH),
      .KEEP_WIDTH(AXIS_KEEP_WIDTH),
      .USER_WIDTH(TX_USER_WIDTH)
    ) cmac_pad_i (
      .clk(tx_clk),
      .rst(tx_rst),
      .s_axis_tdata(tx_axis_tdata),
      .s_axis_tkeep(tx_axis_tkeep),
      .s_axis_tvalid(tx_axis_tvalid),
      .s_axis_tready(tx_axis_tready),
      .s_axis_tlast(tx_axis_tlast),
      .s_axis_tuser(tx_axis_tuser),
      .m_axis_tdata(pad_tdata),
      .m_axis_tkeep(pad_tkeep),
      .m_axis_tvalid(pad_tvalid),
      .m_axis_tready(pad_tready),
      .m_axis_tlast(pad_tlast),
      .m_axis_tuser(pad_tuser)
    );

    wire [NECK-1:0]          tx_neck_tdata;
    wire [NECK_KEEP-1:0]     tx_neck_tkeep;
    wire                     tx_neck_tvalid, tx_neck_tready, tx_neck_tlast;
    wire [TX_USER_WIDTH-1:0] tx_neck_tuser;

    axis_adapter #(
      .S_DATA_WIDTH(AXIS_DATA_WIDTH),
      .S_KEEP_ENABLE(1),
      .S_KEEP_WIDTH(AXIS_KEEP_WIDTH),
      .M_DATA_WIDTH(NECK),
      .M_KEEP_ENABLE(1),
      .M_KEEP_WIDTH(NECK_KEEP),
      .ID_ENABLE(0),
      .DEST_ENABLE(0),
      .USER_ENABLE(1),
      .USER_WIDTH(TX_USER_WIDTH)
    ) tx_512_neck_i (
      .clk(tx_clk),
      .rst(tx_rst),
      .s_axis_tdata(pad_tdata),
      .s_axis_tkeep(pad_tkeep),
      .s_axis_tvalid(pad_tvalid),
      .s_axis_tready(pad_tready),
      .s_axis_tlast(pad_tlast),
      .s_axis_tid(8'd0),
      .s_axis_tdest(8'd0),
      .s_axis_tuser(pad_tuser),
      .m_axis_tdata(tx_neck_tdata),
      .m_axis_tkeep(tx_neck_tkeep),
      .m_axis_tvalid(tx_neck_tvalid),
      .m_axis_tready(tx_neck_tready),
      .m_axis_tlast(tx_neck_tlast),
      .m_axis_tid(),
      .m_axis_tdest(),
      .m_axis_tuser(tx_neck_tuser)
    );

    axis_adapter #(
      .S_DATA_WIDTH(NECK),
      .S_KEEP_ENABLE(1),
      .S_KEEP_WIDTH(NECK_KEEP),
      .M_DATA_WIDTH(NARROW),
      .M_KEEP_ENABLE(1),
      .M_KEEP_WIDTH(NARROW_KEEP),
      .ID_ENABLE(0),
      .DEST_ENABLE(0),
      .USER_ENABLE(1),
      .USER_WIDTH(TX_USER_WIDTH)
    ) tx_neck_384_i (
      .clk(tx_clk),
      .rst(tx_rst),
      .s_axis_tdata(tx_neck_tdata),
      .s_axis_tkeep(tx_neck_tkeep),
      .s_axis_tvalid(tx_neck_tvalid),
      .s_axis_tready(tx_neck_tready),
      .s_axis_tlast(tx_neck_tlast),
      .s_axis_tid(8'd0),
      .s_axis_tdest(8'd0),
      .s_axis_tuser(tx_neck_tuser),
      .m_axis_tdata(tx_pf_tdata),
      .m_axis_tkeep(tx_pf_tkeep),
      .m_axis_tvalid(tx_pf_tvalid),
      .m_axis_tready(tx_pf_tready),
      .m_axis_tlast(tx_pf_tlast),
      .m_axis_tid(),
      .m_axis_tdest(),
      .m_axis_tuser(tx_pf_tuser)
    );
  end else begin : g_tx_pad
    localparam [3:0] PAD_LAST_IDX = 59 / AXIS_KEEP_WIDTH;
    localparam [AXIS_KEEP_WIDTH-1:0] PAD_LAST_KEEP =
      {AXIS_KEEP_WIDTH{1'b1}} >> (AXIS_KEEP_WIDTH - (60 - PAD_LAST_IDX*AXIS_KEEP_WIDTH));
    reg [3:0]               pad_idx = 4'd0;
    reg                     pad_ext = 1'b0;
    reg [TX_USER_WIDTH-1:0] pad_tuser = {TX_USER_WIDTH{1'b0}};

    wire pad_in_short = tx_axis_tlast && pad_idx < PAD_LAST_IDX;

    assign tx_pf_tvalid = pad_ext || tx_axis_tvalid;
    assign tx_axis_tready = !pad_ext && tx_pf_tready;

    genvar pk;
    for (pk = 0; pk < AXIS_KEEP_WIDTH; pk = pk + 1) begin : g_pad
      assign tx_pf_tdata[pk*8 +: 8] = (!pad_ext && tx_axis_tkeep[pk]) ?
                                      tx_axis_tdata[pk*8 +: 8] : 8'd0;
    end

    assign tx_pf_tkeep = pad_ext ? ((pad_idx == PAD_LAST_IDX) ? PAD_LAST_KEEP :
                                                          {AXIS_KEEP_WIDTH{1'b1}}) :
                         pad_in_short ? {AXIS_KEEP_WIDTH{1'b1}} :
                         (tx_axis_tlast && pad_idx == PAD_LAST_IDX) ? (tx_axis_tkeep | PAD_LAST_KEEP) :
                         tx_axis_tkeep;
    assign tx_pf_tlast = pad_ext ? (pad_idx == PAD_LAST_IDX) :
                         (tx_axis_tlast && pad_idx >= PAD_LAST_IDX);
    assign tx_pf_tuser = pad_ext ? pad_tuser : tx_axis_tuser;

    always @(posedge tx_clk) begin
      if (tx_pf_tvalid && tx_pf_tready) begin
        if (!pad_ext)
          pad_tuser <= tx_axis_tuser;
        if (pad_ext) begin
          pad_idx <= (pad_idx == PAD_LAST_IDX) ? 4'd0 : pad_idx + 4'd1;
          pad_ext <= (pad_idx != PAD_LAST_IDX);
        end else if (tx_axis_tlast) begin
          pad_idx <= pad_in_short ? pad_idx + 4'd1 : 4'd0;
          pad_ext <= pad_in_short;
        end else if (pad_idx != (PAD_LAST_IDX + 4'd1)) begin
          pad_idx <= pad_idx + 4'd1;
        end
      end

      if (tx_rst) begin
        pad_idx <= 4'd0;
        pad_ext <= 1'b0;
      end
    end
  end
  endgenerate

  wire [NARROW-1:0]        tx_n_tdata;
  wire [NARROW_KEEP-1:0]   tx_n_tkeep;
  wire                     tx_n_tvalid;
  wire                     tx_n_tready;
  wire                     tx_n_tlast;
  wire [TX_USER_WIDTH-1:0] tx_n_tuser;

  axis_fifo #(
    .DEPTH(TX_FIFO_DEPTH),
    .DATA_WIDTH(NARROW),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(NARROW_KEEP),
    .LAST_ENABLE(1),
    .USER_ENABLE(1),
    .USER_WIDTH(TX_USER_WIDTH),
    .FRAME_FIFO(1),
    .DROP_OVERSIZE_FRAME(0),
    .DROP_BAD_FRAME(0),
    .DROP_WHEN_FULL(0)
  ) tx_frame_fifo_i (
    .clk(tx_clk),
    .rst(tx_rst),
    .s_axis_tdata(tx_pf_tdata),
    .s_axis_tkeep(tx_pf_tkeep),
    .s_axis_tvalid(tx_pf_tvalid),
    .s_axis_tready(tx_pf_tready),
    .s_axis_tlast(tx_pf_tlast),
    .s_axis_tuser(tx_pf_tuser),
    .m_axis_tdata(tx_n_tdata),
    .m_axis_tkeep(tx_n_tkeep),
    .m_axis_tvalid(tx_n_tvalid),
    .m_axis_tready(tx_n_tready),
    .m_axis_tlast(tx_n_tlast),
    .m_axis_tuser(tx_n_tuser)
  );

  mrmac_tx_adapt #(
    .MODE(MODE),
    .SEG_COUNT(SEG_COUNT),
    .SEG_WIDTH(SEG_WIDTH),
    .KUSER_WIDTH(KUSER_WIDTH),
    .DATA_WIDTH(NARROW),
    .KEEP_WIDTH(NARROW_KEEP),
    .USER_WIDTH(1)
  ) tx_adapt_i (
    .s_axis_tdata(tx_n_tdata),
    .s_axis_tkeep(tx_n_tkeep),
    .s_axis_tvalid(tx_n_tvalid),
    .s_axis_tready(tx_n_tready),
    .s_axis_tlast(tx_n_tlast),
    .s_axis_tuser(tx_n_tuser[0]),   // error bit -> MRMAC per-word ERR
    .tx_axis_tdata(mrmac_tx_axis_tdata),
    .tx_axis_tkeep_user(mrmac_tx_axis_tkeep_user),
    .tx_axis_tvalid(mrmac_tx_axis_tvalid),
    .tx_axis_tready(mrmac_tx_axis_tready),
    .tx_axis_tlast(mrmac_tx_axis_tlast)
  );

  // 2-step timestamp request
  assign mrmac_tx_ptp_1588op    = 2'b10;
  assign mrmac_tx_ptp_tag_field = tx_n_tuser[16:1];

  mrmac_ptp_ts_cvt #(
    .COR_TS_WIDTH(PTP_TS_WIDTH),
    .COR_FNS_WIDTH(COR_FNS_WIDTH),
    .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH),
    .MRMAC_FNS_WIDTH(MRMAC_FNS_WIDTH)
  ) tx_ts_cvt_i (
    .cor_ts_in({PTP_TS_WIDTH{1'b0}}),
    .mrmac_ts_out(),
    .mrmac_ts_in(mrmac_tx_ptp_tstamp),
    .cor_ts_out(tx_ptp_ts)
  );
  assign tx_ptp_ts_tag   = mrmac_tx_ptp_tstamp_tag;
  assign tx_ptp_ts_valid = mrmac_tx_ptp_tstamp_valid;

  wire [NARROW-1:0]      rx_n_tdata;
  wire [NARROW_KEEP-1:0] rx_n_tkeep;
  wire                   rx_n_tvalid;
  wire                   rx_n_tlast;
  wire                   rx_n_tuser;   // bad frame, from MRMAC word 0

  mrmac_rx_adapt #(
    .MODE(MODE),
    .SEG_COUNT(SEG_COUNT),
    .SEG_WIDTH(SEG_WIDTH),
    .KUSER_WIDTH(KUSER_WIDTH),
    .DATA_WIDTH(NARROW),
    .KEEP_WIDTH(NARROW_KEEP)
  ) rx_adapt_i (
    .rx_axis_tdata(mrmac_rx_axis_tdata),
    .rx_axis_tkeep_user(mrmac_rx_axis_tkeep_user),
    .rx_axis_tvalid(mrmac_rx_axis_tvalid),
    .rx_axis_tlast(mrmac_rx_axis_tlast),
    .m_axis_tdata(rx_n_tdata),
    .m_axis_tkeep(rx_n_tkeep),
    .m_axis_tvalid(rx_n_tvalid),
    .m_axis_tlast(rx_n_tlast),
    .m_axis_tuser(rx_n_tuser)
  );

  wire [PTP_TS_WIDTH-1:0] rx_ptp_ts_cor;
  mrmac_ptp_ts_cvt #(
    .COR_TS_WIDTH(PTP_TS_WIDTH),
    .COR_FNS_WIDTH(COR_FNS_WIDTH),
    .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH),
    .MRMAC_FNS_WIDTH(MRMAC_FNS_WIDTH)
  ) rx_ts_cvt_i (
    .cor_ts_in({PTP_TS_WIDTH{1'b0}}),
    .mrmac_ts_out(),
    .mrmac_ts_in(mrmac_rx_ptp_tstamp),
    .cor_ts_out(rx_ptp_ts_cor)
  );

  wire [NARROW-1:0]         rx_ins_tdata;
  wire [NARROW_KEEP-1:0]    rx_ins_tkeep;
  wire                      rx_ins_tvalid;
  wire                      rx_ins_tlast;
  wire [RX_USER_WIDTH-1:0]  rx_ins_tuser;

  mac_ts_insert #(
    .PTP_TS_WIDTH(PTP_TS_WIDTH),
    .DATA_WIDTH(NARROW),
    .KEEP_WIDTH(NARROW_KEEP),
    .S_USER_WIDTH(1),
    .M_USER_WIDTH(RX_USER_WIDTH)
  ) rx_ts_insert_i (
    .clk(rx_clk),
    .rst(rx_rst),
    .ptp_ts(rx_ptp_ts_cor),
    .s_axis_tdata(rx_n_tdata),
    .s_axis_tkeep(rx_n_tkeep),
    .s_axis_tvalid(rx_n_tvalid),
    .s_axis_tready(),
    .s_axis_tlast(rx_n_tlast),
    .s_axis_tuser(rx_n_tuser),
    .m_axis_tdata(rx_ins_tdata),
    .m_axis_tkeep(rx_ins_tkeep),
    .m_axis_tvalid(rx_ins_tvalid),
    .m_axis_tready(1'b1),
    .m_axis_tlast(rx_ins_tlast),
    .m_axis_tuser(rx_ins_tuser)
  );

  // The bad-frame value/mask apply to the error bit, tuser[0].
  wire [NARROW-1:0]         rxf_tdata;
  wire [NARROW_KEEP-1:0]    rxf_tkeep;
  wire                      rxf_tvalid;
  wire                      rxf_tready;
  wire                      rxf_tlast;
  wire [RX_USER_WIDTH-1:0]  rxf_tuser;

  axis_fifo #(
    .DEPTH(RX_FIFO_DEPTH),
    .DATA_WIDTH(NARROW),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(NARROW_KEEP),
    .LAST_ENABLE(1),
    .USER_ENABLE(1),
    .USER_WIDTH(RX_USER_WIDTH),
    .FRAME_FIFO(1),
    .DROP_OVERSIZE_FRAME(1),
    .DROP_WHEN_FULL(1),
    .DROP_BAD_FRAME(0),
    .USER_BAD_FRAME_VALUE(1'b1),
    .USER_BAD_FRAME_MASK(1'b1)
  ) rx_fifo_i (
    .clk(rx_clk),
    .rst(rx_rst),
    .s_axis_tdata(rx_ins_tdata),
    .s_axis_tkeep(rx_ins_tkeep),
    .s_axis_tvalid(rx_ins_tvalid),
    .s_axis_tready(),
    .s_axis_tlast(rx_ins_tlast),
    .s_axis_tuser(rx_ins_tuser),
    .m_axis_tdata(rxf_tdata),
    .m_axis_tkeep(rxf_tkeep),
    .m_axis_tvalid(rxf_tvalid),
    .m_axis_tready(rxf_tready),
    .m_axis_tlast(rxf_tlast),
    .m_axis_tuser(rxf_tuser),
    .status_overflow(rx_fifo_overflow)
  );

  wire [AXIS_DATA_WIDTH-1:0] rx_w_tdata;
  wire [AXIS_KEEP_WIDTH-1:0] rx_w_tkeep;
  wire                       rx_w_tvalid;
  wire                       rx_w_tlast;
  wire [RX_USER_WIDTH-1:0]   rx_w_tuser;

  generate
  if (MODE == "1x100G") begin : g_rx_100g
    wire [NECK-1:0]          rx_neck_tdata;
    wire [NECK_KEEP-1:0]     rx_neck_tkeep;
    wire                     rx_neck_tvalid, rx_neck_tready, rx_neck_tlast;
    wire [RX_USER_WIDTH-1:0] rx_neck_tuser;

    axis_adapter #(
      .S_DATA_WIDTH(NARROW),
      .S_KEEP_ENABLE(1),
      .S_KEEP_WIDTH(NARROW_KEEP),
      .M_DATA_WIDTH(NECK),
      .M_KEEP_ENABLE(1),
      .M_KEEP_WIDTH(NECK_KEEP),
      .ID_ENABLE(0),
      .DEST_ENABLE(0),
      .USER_ENABLE(1),
      .USER_WIDTH(RX_USER_WIDTH)
    ) rx_384_neck_i (
      .clk(rx_clk),
      .rst(rx_rst),
      .s_axis_tdata(rxf_tdata),
      .s_axis_tkeep(rxf_tkeep),
      .s_axis_tvalid(rxf_tvalid),
      .s_axis_tready(rxf_tready),
      .s_axis_tlast(rxf_tlast),
      .s_axis_tid(8'd0),
      .s_axis_tdest(8'd0),
      .s_axis_tuser(rxf_tuser),
      .m_axis_tdata(rx_neck_tdata),
      .m_axis_tkeep(rx_neck_tkeep),
      .m_axis_tvalid(rx_neck_tvalid),
      .m_axis_tready(rx_neck_tready),
      .m_axis_tlast(rx_neck_tlast),
      .m_axis_tid(),
      .m_axis_tdest(),
      .m_axis_tuser(rx_neck_tuser)
    );

    axis_adapter #(
      .S_DATA_WIDTH(NECK),
      .S_KEEP_ENABLE(1),
      .S_KEEP_WIDTH(NECK_KEEP),
      .M_DATA_WIDTH(AXIS_DATA_WIDTH),
      .M_KEEP_ENABLE(1),
      .M_KEEP_WIDTH(AXIS_KEEP_WIDTH),
      .ID_ENABLE(0),
      .DEST_ENABLE(0),
      .USER_ENABLE(1),
      .USER_WIDTH(RX_USER_WIDTH)
    ) rx_neck_512_i (
      .clk(rx_clk),
      .rst(rx_rst),
      .s_axis_tdata(rx_neck_tdata),
      .s_axis_tkeep(rx_neck_tkeep),
      .s_axis_tvalid(rx_neck_tvalid),
      .s_axis_tready(rx_neck_tready),
      .s_axis_tlast(rx_neck_tlast),
      .s_axis_tid(8'd0),
      .s_axis_tdest(8'd0),
      .s_axis_tuser(rx_neck_tuser),
      .m_axis_tdata(rx_w_tdata),
      .m_axis_tkeep(rx_w_tkeep),
      .m_axis_tvalid(rx_w_tvalid),
      .m_axis_tready(1'b1),
      .m_axis_tlast(rx_w_tlast),
      .m_axis_tid(),
      .m_axis_tdest(),
      .m_axis_tuser(rx_w_tuser)
    );
  end else begin : g_rx_direct
    assign rx_w_tdata  = rxf_tdata;
    assign rx_w_tkeep  = rxf_tkeep;
    assign rx_w_tvalid = rxf_tvalid;
    assign rx_w_tlast  = rxf_tlast;
    assign rx_w_tuser  = rxf_tuser;
    assign rxf_tready  = 1'b1;
  end
  endgenerate

  assign rx_axis_tdata  = rx_w_tdata;
  assign rx_axis_tkeep  = rx_w_tkeep;
  assign rx_axis_tvalid = rx_w_tvalid;
  assign rx_axis_tlast  = rx_w_tlast;
  assign rx_axis_tuser  = rx_w_tuser;

  wire [MRMAC_TS_WIDTH-1:0] tx_ptp_time_mrmac;
  wire [MRMAC_TS_WIDTH-1:0] rx_ptp_time_mrmac;

  mrmac_ptp_ts_cvt #(
    .COR_TS_WIDTH(PTP_TS_WIDTH),
    .COR_FNS_WIDTH(COR_FNS_WIDTH),
    .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH),
    .MRMAC_FNS_WIDTH(MRMAC_FNS_WIDTH)
  ) tx_time_cvt_i (
    .cor_ts_in(tx_ptp_time),
    .mrmac_ts_out(tx_ptp_time_mrmac),
    .mrmac_ts_in({MRMAC_TS_WIDTH{1'b0}}),
    .cor_ts_out()
  );

  mrmac_ptp_ts_cvt #(
    .COR_TS_WIDTH(PTP_TS_WIDTH),
    .COR_FNS_WIDTH(COR_FNS_WIDTH),
    .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH),
    .MRMAC_FNS_WIDTH(MRMAC_FNS_WIDTH)
  ) rx_time_cvt_i (
    .cor_ts_in(rx_ptp_time),
    .mrmac_ts_out(rx_ptp_time_mrmac),
    .mrmac_ts_in({MRMAC_TS_WIDTH{1'b0}}),
    .cor_ts_out()
  );

  mrmac_ptp_sync #(
    .TS_WIDTH(MRMAC_TS_WIDTH),
    .SYNC_CYCLES(PTP_SYNC_CYCLES)
  ) tx_ptp_sync_i (
    .clk(tx_axi_clk),
    .rst(tx_rst),
    .systemtime_in(tx_ptp_time_mrmac),
    .systemtimer(mrmac_tx_ptp_systemtimer),
    .st_sync(mrmac_tx_ptp_st_sync),
    .st_overwrite(mrmac_tx_ptp_st_overwrite)
  );

  mrmac_ptp_sync #(
    .TS_WIDTH(MRMAC_TS_WIDTH),
    .SYNC_CYCLES(PTP_SYNC_CYCLES)
  ) rx_ptp_sync_i (
    .clk(rx_axi_clk),
    .rst(rx_rst),
    .systemtime_in(rx_ptp_time_mrmac),
    .systemtimer(mrmac_rx_ptp_systemtimer),
    .st_sync(mrmac_rx_ptp_st_sync),
    .st_overwrite(mrmac_rx_ptp_st_overwrite)
  );

  assign mrmac_ctl_tx_pause_enable = {tx_lfc_en,  tx_pfc_en};
  assign mrmac_ctl_tx_pause_req    = {tx_lfc_req, tx_pfc_req};
  assign mrmac_ctl_rx_pause_enable = {rx_lfc_en,  rx_pfc_en};
  assign mrmac_ctl_rx_pause_ack    = {rx_lfc_ack, rx_pfc_ack};
  assign {rx_lfc_req, rx_pfc_req}  = mrmac_stat_rx_pause_req;

endmodule
