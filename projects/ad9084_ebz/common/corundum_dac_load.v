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

`timescale 1ns/100ps
`timescale 1ns/100ps

// Selects the source of the DAC data offload: the TX DMA, or the Corundum
// application core loading it from the network. In application mode a LOAD
// forwards LENGTH beats, flags the last one, and holds init_req for the
// duration as the DMA's xfer_req does: the offload starts its cyclic replay
// only if init_req drops before its first read pass ends. With the offload in
// bypass, LENGTH 0 streams until STOP, and a LOAD written during a load is
// queued and follows it without a gap; only the end of the run is flagged.
//
// The application stream cannot be stalled (it would back up into Corundum's
// sync RX path, which the MRMAC cannot hold off), so a load goes through a
// FIFO_DEPTH-beat FIFO and pause_req asks the link partner to stop sending
// while it is filled past PAUSE_ON, until it drains below PAUSE_OFF. Beats
// that find the FIFO full are dropped and counted. The FIFO only starts to
// feed the DAC once it holds START_LEVEL beats, so a slow start does not
// underflow the DAC.

module corundum_dac_load #(
  parameter DATA_WIDTH = 512,
  parameter FIFO_DEPTH = 8192
) (
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s_axi:s_dma_axis:s_app_axis:m_axis, ASSOCIATED_RESET resetn" *)
  input  wire                    clk,
  input  wire                    resetn,

  input  wire                    s_axi_awvalid,
  input  wire [15:0]             s_axi_awaddr,
  input  wire [ 2:0]             s_axi_awprot,
  output wire                    s_axi_awready,
  input  wire                    s_axi_wvalid,
  input  wire [31:0]             s_axi_wdata,
  input  wire [ 3:0]             s_axi_wstrb,
  output wire                    s_axi_wready,
  output wire                    s_axi_bvalid,
  output wire [ 1:0]             s_axi_bresp,
  input  wire                    s_axi_bready,
  input  wire                    s_axi_arvalid,
  input  wire [15:0]             s_axi_araddr,
  input  wire [ 2:0]             s_axi_arprot,
  output wire                    s_axi_arready,
  output wire                    s_axi_rvalid,
  output wire [ 1:0]             s_axi_rresp,
  output wire [31:0]             s_axi_rdata,
  input  wire                    s_axi_rready,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_dma_axis TVALID" *)
  input  wire                    s_dma_axis_tvalid,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_dma_axis TREADY" *)
  output wire                    s_dma_axis_tready,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_dma_axis TDATA" *)
  input  wire [DATA_WIDTH-1:0]   s_dma_axis_tdata,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_dma_axis TKEEP" *)
  input  wire [DATA_WIDTH/8-1:0] s_dma_axis_tkeep,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_dma_axis TLAST" *)
  input  wire                    s_dma_axis_tlast,
  input  wire                    dma_xfer_req,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_app_axis TVALID" *)
  input  wire                    s_app_axis_tvalid,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_app_axis TREADY" *)
  output wire                    s_app_axis_tready,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_app_axis TDATA" *)
  input  wire [DATA_WIDTH-1:0]   s_app_axis_tdata,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *)
  output wire                    m_axis_tvalid,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *)
  input  wire                    m_axis_tready,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *)
  output wire [DATA_WIDTH-1:0]   m_axis_tdata,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TKEEP" *)
  output wire [DATA_WIDTH/8-1:0] m_axis_tkeep,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *)
  output wire                    m_axis_tlast,
  output wire                    init_req,

  output reg                     pause_req = 1'b0,

  // util_upack2 fifo_rd_valid / fifo_rd_underflow, on the DAC device clock
  input  wire                    dac_clk,
  input  wire                    dac_rd_valid,
  input  wire                    dac_rd_underflow
);

  localparam [31:0] VERSION = 32'h00030000;
  localparam LEVEL_W = $clog2(FIFO_DEPTH) + 1;

  // PAUSE_ON leaves room for what is in flight when the pause goes out:
  // about 300 beats were measured past it at 100GE. PAUSE_OFF leaves the
  // partner tens of microseconds to resume before the FIFO runs dry.
  localparam [LEVEL_W-1:0] PAUSE_ON_DEF  = FIFO_DEPTH - (FIFO_DEPTH >= 4096 ? 512 : FIFO_DEPTH / 8);
  localparam [LEVEL_W-1:0] PAUSE_OFF_DEF = FIFO_DEPTH / 8 * 5;
  localparam [LEVEL_W-1:0] START_DEF     = FIFO_DEPTH / 2;

  wire        up_wreq;
  wire [13:0] up_waddr;
  wire [31:0] up_wdata;
  reg         up_wack = 1'b0;
  wire        up_rreq;
  wire [13:0] up_raddr;
  reg  [31:0] up_rdata = 32'd0;
  reg         up_rack = 1'b0;

  reg  [31:0] up_scratch = 32'd0;
  reg         source_app = 1'b0;
  reg  [31:0] length = 32'd0;
  reg  [LEVEL_W-1:0] pause_on = PAUSE_ON_DEF;
  reg  [LEVEL_W-1:0] pause_off = PAUSE_OFF_DEF;
  reg  [LEVEL_W-1:0] start_level = START_DEF;
  reg         reprime = 1'b0;

  reg         busy = 1'b0;
  reg         queued = 1'b0;
  reg         continuous = 1'b0;
  reg  [31:0] last_index = 32'd0;
  reg  [63:0] count = 64'd0;
  reg  [31:0] loads = 32'd0;
  reg         primed = 1'b0;

  wire        wr_load;
  wire        wr_stop;
  wire        app_start;
  wire        app_beat;
  wire        app_last;
  wire        app_chain;
  wire        pending;

  wire                  fifo_full;
  wire                  fifo_empty;
  wire                  fifo_wr_rst_busy;
  wire                  fifo_rd_rst_busy;
  wire                  fifo_rd;
  wire [DATA_WIDTH:0]   fifo_dout;
  reg  [LEVEL_W-1:0]    level = 'd0;
  reg  [LEVEL_W-1:0]    peak = 'd0;
  reg  [31:0]           dropped = 32'd0;
  reg  [31:0]           starved = 32'd0;
  reg  [31:0]           pauses = 32'd0;

  reg                   unf_en = 1'b0;
  wire                  dac_unf_en;
  reg                   dac_armed = 1'b0;
  reg  [31:0]           dac_unf_count = 32'd0;
  wire [31:0]           unf_count;
  reg  [31:0]           unf_base = 32'd0;

  localparam SLICE_W = DATA_WIDTH + DATA_WIDTH/8 + 1;

  wire               sel_valid;
  wire               sel_ready;
  wire [SLICE_W-1:0] sel_data;

  reg                out_valid = 1'b0;
  reg  [SLICE_W-1:0] out_data;
  reg                skid_valid = 1'b0;
  reg  [SLICE_W-1:0] skid_data;

  up_axi i_up_axi (
    .up_rstn (resetn),
    .up_clk (clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  // 0x00 VERSION, 0x02 SCRATCH
  // 0x10 SOURCE      [0] 0: TX DMA, 1: application (not changed while pending)
  // 0x11 LOAD        write [0] = 1: start a load, or queue the next one during
  //                  a load; [1] = 1: stop (ends the load and drops the queue)
  //                  read [0] pending (until the FIFO has drained), [1] queued,
  //                  [2] feeding the DAC, [3] continuous
  // 0x12 LENGTH      length of the next load in DATA_WIDTH beats, 0: until stop
  // 0x13 COUNT       beats taken in by the current or last load, [31:0]
  // 0x14 PAUSE_ON    pause while the FIFO holds more than this many beats
  // 0x15 PAUSE_OFF   release the pause below this many beats
  // 0x16 LEVEL       beats in the FIFO now
  // 0x17 PEAK        highest LEVEL of the run
  // 0x18 DROPPED     beats dropped on a full FIFO in the run
  // 0x19 STARVED     clock cycles the run, once feeding the DAC, had no beat at
  //                  the FIFO output while the offload could take one
  // 0x1A PAUSES      pause requests raised in the run
  // 0x1B START_LEVEL beats the FIFO holds before it feeds the DAC
  // 0x1C CONTROL     [0] stop feeding the DAC when the FIFO runs empty, until
  //                  it holds START_LEVEL again
  // 0x1D UNDERFLOW   DAC clock cycles the DAC read no data in the run, from
  //                  its first sample until the run has drained
  // 0x1E COUNT_HI    COUNT [63:32]
  // 0x1F LOADS       loads in the run
  // A run is a LOAD from idle and the loads queued after it; its counters
  // restart with it.
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      up_wack <= 1'b0;
      up_scratch <= 32'd0;
      source_app <= 1'b0;
      length <= 32'd0;
      pause_on <= PAUSE_ON_DEF;
      pause_off <= PAUSE_OFF_DEF;
      start_level <= START_DEF;
      reprime <= 1'b0;
    end else begin
      up_wack <= up_wreq;
      if (up_wreq && up_waddr == 14'h02) begin
        up_scratch <= up_wdata;
      end
      if (up_wreq && up_waddr == 14'h10 && !pending) begin
        source_app <= up_wdata[0];
      end
      if (up_wreq && up_waddr == 14'h12) begin
        length <= up_wdata;
      end
      if (up_wreq && up_waddr == 14'h14) begin
        pause_on <= up_wdata[LEVEL_W-1:0];
      end
      if (up_wreq && up_waddr == 14'h15) begin
        pause_off <= up_wdata[LEVEL_W-1:0];
      end
      if (up_wreq && up_waddr == 14'h1b) begin
        start_level <= up_wdata[LEVEL_W-1:0];
      end
      if (up_wreq && up_waddr == 14'h1c) begin
        reprime <= up_wdata[0];
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      up_rack <= 1'b0;
      up_rdata <= 32'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq) begin
        case (up_raddr)
          14'h00: up_rdata <= VERSION;
          14'h02: up_rdata <= up_scratch;
          14'h10: up_rdata <= {31'd0, source_app};
          14'h11: up_rdata <= {28'd0, continuous, primed, queued, pending};
          14'h12: up_rdata <= length;
          14'h13: up_rdata <= count[31:0];
          14'h14: up_rdata <= pause_on;
          14'h15: up_rdata <= pause_off;
          14'h16: up_rdata <= level;
          14'h17: up_rdata <= peak;
          14'h18: up_rdata <= dropped;
          14'h19: up_rdata <= starved;
          14'h1a: up_rdata <= pauses;
          14'h1b: up_rdata <= start_level;
          14'h1c: up_rdata <= {31'd0, reprime};
          14'h1d: up_rdata <= unf_count - unf_base;
          14'h1e: up_rdata <= count[63:32];
          14'h1f: up_rdata <= loads;
          default: up_rdata <= 32'd0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  assign wr_load = up_wreq && up_waddr == 14'h11 && up_wdata[0] && !up_wdata[1];
  assign wr_stop = up_wreq && up_waddr == 14'h11 && up_wdata[1];
  assign app_start = wr_load && source_app && !pending;
  assign app_beat = source_app && busy && s_app_axis_tvalid &&
                    !fifo_full && !fifo_wr_rst_busy;
  // count stays below LENGTH unless continuous, so its low half is enough
  assign app_last = !continuous && count[31:0] == last_index;
  assign app_chain = app_last && queued;
  assign pending = busy || level != 'd0;

  always @(posedge clk) begin
    if (resetn == 1'b0 || wr_stop) begin
      busy <= 1'b0;
      queued <= 1'b0;
    end else if (app_start) begin
      busy <= 1'b1;
      queued <= 1'b0;
      continuous <= length == 32'd0;
      last_index <= length - 32'd1;
      count <= 64'd0;
      loads <= 32'd1;
    end else begin
      if (wr_load && busy && !continuous) begin
        queued <= 1'b1;
      end
      if (app_beat && app_chain) begin
        queued <= wr_load && length != 32'd0;
        continuous <= length == 32'd0;
        last_index <= length - 32'd1;
        count <= 64'd0;
        loads <= loads + 32'd1;
      end else if (app_beat) begin
        busy <= !app_last;
        count <= count + 64'd1;
      end
    end
  end

  // Feeding stops for a fresh run until the FIFO holds START_LEVEL beats; the
  // end of a short load, or a pause request (START_LEVEL above PAUSE_ON),
  // starts it too.
  always @(posedge clk) begin
    if (resetn == 1'b0 || app_start) begin
      primed <= 1'b0;
    end else if (!primed) begin
      if (level >= start_level || pause_req || !busy) begin
        primed <= 1'b1;
      end
    end else if (reprime && busy && level == 'd0) begin
      primed <= 1'b0;
    end
  end

  // Outside a load the application stream is discarded: holding it back would
  // stall Corundum's sync RX path, and the host traffic with it.
  assign s_app_axis_tready = 1'b1;

  xpm_fifo_sync #(
    .FIFO_MEMORY_TYPE ("ultra"),
    .FIFO_WRITE_DEPTH (FIFO_DEPTH),
    .WRITE_DATA_WIDTH (DATA_WIDTH + 1),
    .READ_DATA_WIDTH (DATA_WIDTH + 1),
    .READ_MODE ("fwft"),
    .FIFO_READ_LATENCY (0),
    .USE_ADV_FEATURES ("0000")
  ) i_app_fifo (
    .rst (!resetn),
    .wr_clk (clk),
    .wr_en (app_beat),
    .din ({app_last && !app_chain, s_app_axis_tdata}),
    .full (fifo_full),
    .wr_rst_busy (fifo_wr_rst_busy),
    .rd_en (fifo_rd),
    .dout (fifo_dout),
    .empty (fifo_empty),
    .rd_rst_busy (fifo_rd_rst_busy),
    .sleep (1'b0),
    .injectsbiterr (1'b0),
    .injectdbiterr (1'b0),
    .prog_full (),
    .wr_data_count (),
    .overflow (),
    .wr_ack (),
    .almost_full (),
    .prog_empty (),
    .rd_data_count (),
    .underflow (),
    .data_valid (),
    .almost_empty (),
    .sbiterr (),
    .dbiterr ());

  assign fifo_rd = source_app && primed && !fifo_empty && !fifo_rd_rst_busy && sel_ready;

  // Counted here rather than taken from the FIFO, whose fwft flags lag a write
  // by a few cycles: the load is pending until the last beat leaves.
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      level <= 'd0;
      pause_req <= 1'b0;
    end else begin
      level <= level + app_beat - fifo_rd;
      if (!source_app || level < pause_off) begin
        pause_req <= 1'b0;
      end else if (level > pause_on) begin
        pause_req <= 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0 || app_start) begin
      peak <= 'd0;
      dropped <= 32'd0;
      starved <= 32'd0;
      pauses <= 32'd0;
    end else begin
      if (level > peak) begin
        peak <= level;
      end
      if (source_app && busy && s_app_axis_tvalid && !app_beat) begin
        dropped <= dropped + 32'd1;
      end
      if (source_app && busy && primed && fifo_empty && sel_ready) begin
        starved <= starved + 32'd1;
      end
      if (source_app && !pause_req && level > pause_on && level >= pause_off) begin
        pauses <= pauses + 32'd1;
      end
    end
  end

  // DAC underflow, counted on the DAC clock from the first sample the run
  // brings to the DAC until the run has drained. The count is free-running
  // and crosses back in Gray code; the run's count is taken from a base.
  always @(posedge clk) begin
    unf_en <= source_app && primed && pending;
    if (app_start) begin
      unf_base <= unf_count;
    end
  end

  xpm_cdc_single #(
    .DEST_SYNC_FF (3),
    .SRC_INPUT_REG (1)
  ) i_unf_en_sync (
    .src_clk (clk),
    .src_in (unf_en),
    .dest_clk (dac_clk),
    .dest_out (dac_unf_en));

  always @(posedge dac_clk) begin
    dac_armed <= dac_unf_en && (dac_armed || dac_rd_valid);
    if (dac_armed && dac_rd_underflow) begin
      dac_unf_count <= dac_unf_count + 32'd1;
    end
  end

  xpm_cdc_gray #(
    .DEST_SYNC_FF (3),
    .WIDTH (32)
  ) i_unf_count_sync (
    .src_clk (dac_clk),
    .src_in_bin (dac_unf_count),
    .dest_clk (clk),
    .dest_out_bin (unf_count));

  assign s_dma_axis_tready = !source_app && sel_ready;

  assign sel_valid = source_app ? primed && !fifo_empty && !fifo_rd_rst_busy : s_dma_axis_tvalid;
  assign sel_data  = source_app ? {fifo_dout[DATA_WIDTH], {DATA_WIDTH/8{1'b1}}, fifo_dout[DATA_WIDTH-1:0]} :
                                  {s_dma_axis_tlast, s_dma_axis_tkeep, s_dma_axis_tdata};

  // Full-throughput register slice: at 350 MHz the 512-bit source mux cannot
  // sit between the source FIFOs and the offload storage. A beat that arrives
  // while the output is stalled waits in skid_data, so sel_ready is a register.
  assign sel_ready = !skid_valid;

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      out_valid <= 1'b0;
      skid_valid <= 1'b0;
    end else if (skid_valid) begin
      if (m_axis_tready) begin
        skid_valid <= 1'b0;
      end
    end else if (!out_valid || m_axis_tready) begin
      out_valid <= sel_valid;
    end else if (sel_valid) begin
      skid_valid <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (skid_valid) begin
      if (m_axis_tready) begin
        out_data <= skid_data;
      end
    end else if (!out_valid || m_axis_tready) begin
      out_data <= sel_data;
    end else begin
      skid_data <= sel_data;
    end
  end

  assign m_axis_tvalid = out_valid;
  assign {m_axis_tlast, m_axis_tkeep, m_axis_tdata} = out_data;

  // The offload's write ends on tlast, not on init_req, so init_req may drop
  // while the last beats are still in the slice.
  assign init_req = source_app ? pending : dma_xfer_req;

endmodule
