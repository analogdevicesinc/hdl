// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/1ps

module util_fifo2axi_bridge #(

  parameter          SRC_DATA_WIDTH = 64,
  parameter          SRC_ADDR_WIDTH = 8,
  parameter          DST_DATA_WIDTH = 128,
  parameter          DST_ADDR_WIDTH = 7,
  parameter          AXI_DATA_WIDTH = 512,
  parameter          AXI_ADDR_WIDTH = 32,
  parameter          AXI_ADDRESS = 32'h00000000,
  parameter          AXI_ADDRESS_LIMIT = 32'hffffffff,
  parameter          REMOVE_NULL_BEAT_EN = 0

) (

  input                                       fifo_src_clk,
  input                                       fifo_src_resetn,
  input                                       fifo_src_wen,
  input       [SRC_ADDR_WIDTH-1:0]            fifo_src_waddr,
  input       [SRC_DATA_WIDTH-1:0]            fifo_src_wdata,
  input                                       fifo_src_wlast,

  input                                       fifo_dst_clk,
  input                                       fifo_dst_resetn,
  input                                       fifo_dst_ren,
  input       [DST_ADDR_WIDTH-1:0]            fifo_dst_raddr,
  output      [DST_DATA_WIDTH-1:0]            fifo_dst_rdata,

  // Signal to the controller, that the bridge is ready to push data to the
  // destination
  output                                      fifo_dst_ready,

  // Status signals
  output                                      fifo_src_full,    // FULL asserts when SOURCE data rate (e.g. ADC) is higher than DDR data rate
  output                                      fifo_dst_empty,   // EMPTY asserts when DESTINATION data rate (e.g. DAC) is higher than DDR data rate

  // AXI4 interface

  input                                       axi_clk,
  input                                       axi_resetn,
  output  reg                                 axi_awvalid = 1'b0,
  output      [ 3:0]                          axi_awid,
  output      [ 1:0]                          axi_awburst,
  output                                      axi_awlock,
  output      [ 3:0]                          axi_awcache,
  output      [ 2:0]                          axi_awprot,
  output      [ 3:0]                          axi_awqos,
  output      [ 7:0]                          axi_awlen,
  output      [ 2:0]                          axi_awsize,
  output  reg [(AXI_ADDR_WIDTH-1):0]          axi_awaddr = {AXI_ADDR_WIDTH{1'b0}},
  input                                       axi_awready,
  output  reg                                 axi_wvalid = 1'b0,
  output      [(AXI_DATA_WIDTH-1):0]          axi_wdata,
  output      [(AXI_DATA_WIDTH/8-1):0]        axi_wstrb,
  output                                      axi_wlast,
  input                                       axi_wready,
  input                                       axi_bvalid,
  input       [ 3:0]                          axi_bid,
  input       [ 1:0]                          axi_bresp,
  output  reg                                 axi_bready = 1'b1,  // always ready for write response
  output  reg                                 axi_arvalid = 1'b0,
  output      [ 3:0]                          axi_arid,
  output      [ 1:0]                          axi_arburst,
  output                                      axi_arlock,
  output      [ 3:0]                          axi_arcache,
  output      [ 2:0]                          axi_arprot,
  output      [ 3:0]                          axi_arqos,
  output      [ 7:0]                          axi_arlen,
  output      [ 2:0]                          axi_arsize,
  output  reg [(AXI_ADDR_WIDTH-1):0]          axi_araddr = {AXI_ADDR_WIDTH{1'b0}},
  input                                       axi_arready,
  input                                       axi_rvalid,
  input       [ 3:0]                          axi_rid,
  input       [ 1:0]                          axi_rresp,
  input                                       axi_rlast,
  input       [(AXI_DATA_WIDTH-1):0]          axi_rdata,
  output                                      axi_rready

);

// AXI Memory Mapped related parameters
localparam AXI_BYTE_WIDTH = AXI_DATA_WIDTH/8;
localparam AXI_SIZE = (AXI_BYTE_WIDTH > 64) ? 3'b111 :
                      (AXI_BYTE_WIDTH > 32) ? 3'b110 :
                      (AXI_BYTE_WIDTH > 16) ? 3'b101 :
                      (AXI_BYTE_WIDTH >  8) ? 3'b100 :
                      (AXI_BYTE_WIDTH >  4) ? 3'b011 :
                      (AXI_BYTE_WIDTH >  2) ? 3'b010 :
                      (AXI_BYTE_WIDTH >  1) ? 3'b001 : 3'b000;

// we are using the max burst length by default, respecting the 4kbyte
// boundary defined by the AXI4 standard
localparam AXI_LENGTH = 4096/AXI_BYTE_WIDTH - 1;
localparam AXI_LENGTH_INDEX = $clog2(AXI_LENGTH);
localparam AXI_ADDR_INCR = (AXI_LENGTH + 1) * AXI_BYTE_WIDTH;

// CDC FIFO's must be capable to store a 2 x 4Kbytes
// WARNING: Changing this depth will brake other part of the bridge
localparam FOUR_KB = 4096 * 8;
localparam  [31:0]  AXI_CDC_ADDR_WIDTH = $clog2(((2 * FOUR_KB) / AXI_DATA_WIDTH) - 1);
localparam  [31:0]  SRC_CDC_ADDR_WIDTH = $clog2(((2 * FOUR_KB) / SRC_DATA_WIDTH) - 1);
localparam  [31:0]  DST_CDC_ADDR_WIDTH = $clog2(((2 * FOUR_KB) / DST_DATA_WIDTH) - 1);

localparam SRC_4KB_BYTE = FOUR_KB/SRC_DATA_WIDTH;
localparam DST_4KB_BYTE = FOUR_KB/DST_DATA_WIDTH;
localparam DST_4KB_BYTE_INDEX = $clog2(FOUR_KB/DST_DATA_WIDTH);
localparam AXI_4KB_BYTE = FOUR_KB/AXI_DATA_WIDTH;

// almost full and almost empty thresholds for the CDC FIFO's
localparam WR_CDC_ALMOST_EMPTY_THRESHOLD = (SRC_DATA_WIDTH < AXI_DATA_WIDTH) ?
                                            AXI_4KB_BYTE :
                                            AXI_4KB_BYTE/(SRC_DATA_WIDTH/AXI_DATA_WIDTH);
localparam RD_CDC_ALMOST_EMPTY_THRESHOLD = (DST_DATA_WIDTH > AXI_DATA_WIDTH) ?
                                            DST_4KB_BYTE :
                                            DST_4KB_BYTE/(DST_DATA_WIDTH/AXI_DATA_WIDTH);

//internal register and signals

wire  [AXI_DATA_WIDTH-1:0]     axi_wdata_int_s;
wire  [AXI_DATA_WIDTH/8-1:0]   axi_wkeep_int_s;
wire                           axi_wlast_int_s;
wire                           axi_fifo_src_last_received_s;
wire                           axi_wcdc_almost_empty;
wire                           axi_wcdc_empty;
wire  [AXI_CDC_ADDR_WIDTH-1:0] axi_wcdc_level_s;
wire                           axi_wdata_en_s;
wire                           axi_fifo_src_resetn;
wire                           axi_fifo_dst_resetn;
wire                           axi_rxfer_start_s;
wire                           axi_src_resetn;
wire                           axi_dst_resetn;

reg                            fifo_src_last_received = 1'b0;

reg                            axi_wxfer_active = 1'b0;
reg                            axi_rxfer_active = 1'b0;
reg                            axi_rdata_en = 1'b0;
reg   [ 7:0]                   axi_awlen_d = 1'b0;
reg   [ 7:0]                   axi_wbeat_counter = 8'b0;
reg   [31:0]                   axi_wburst_counter = 32'b0;
reg   [31:0]                   axi_rburst_counter = 32'b0;
reg   [AXI_CDC_ADDR_WIDTH-1:0] axi_last_burst_length = {AXI_CDC_ADDR_WIDTH{1'b0}};
reg   [ 1:0]                   axi_wxfer_active_d = 1'b0;
reg                            axi_write_done = 1'b0;
reg                            axi_rxfer_active_d = 1'b0;


//-----------------------------------------------------------------------------
// Source side logic - CDC FIFO instance
//-----------------------------------------------------------------------------

// Source CDC FIFO - source clock domain to storage unit's clock domain
util_axis_fifo_asym #(
  .S_DATA_WIDTH (SRC_DATA_WIDTH),
  .S_ADDRESS_WIDTH (SRC_CDC_ADDR_WIDTH),
  .M_DATA_WIDTH (AXI_DATA_WIDTH),
  .ASYNC_CLK (1),
  .ALMOST_FULL_THRESHOLD (1),
  .ALMOST_EMPTY_THRESHOLD (WR_CDC_ALMOST_EMPTY_THRESHOLD),
  .TLAST_EN (1),
  .TKEEP_EN (1))
i_source_cdc_fifo (
  .s_axis_aclk    (fifo_src_clk),
  .s_axis_aresetn (fifo_src_resetn),
  .s_axis_ready   (),                       // TODO: check for overflow
  .s_axis_valid   (fifo_src_wen),           // first positive edge generate address
  .s_axis_data    (fifo_src_wdata),
  .s_axis_tkeep   ({SRC_DATA_WIDTH{1'b1}}),
  .s_axis_tlast   (fifo_src_wlast),
  .s_axis_room    (),
  .s_axis_full    (fifo_src_full),          // if asserted the memory can not keep up with the ADC
  .s_axis_almost_full (),
  .m_axis_aclk    (axi_clk),
  .m_axis_aresetn (axi_resetn),
  .m_axis_ready   (axi_wready_int_s),
  .m_axis_valid   (axi_wvalid_int_s),
  .m_axis_data    (axi_wdata_int_s),
  .m_axis_tkeep   (axi_wkeep_int_s),
  .m_axis_tlast   (axi_wlast_int_s),
  .m_axis_level   (axi_wcdc_level_s),
  .m_axis_empty   (axi_wcdc_empty),
  .m_axis_almost_empty (axi_wcdc_almost_empty) // almost empty should be set to a full burst
);

// save the last TKEEP for read
// NOTE: we are writing invalid data to the memory in case of a fractional last beat
reg [AXI_DATA_WIDTH/8-1:0] axi_wlast_tkeep;
always @(posedge axi_clk) begin
  if (axi_src_resetn == 1'b0) begin
    axi_wlast_tkeep <= 0;
  end else begin
    if (axi_wvalid_int_s & axi_wlast_int_s)
      axi_wlast_tkeep <= axi_wkeep_int_s;
  end
end

// it helps to flush the source CDC FIFO
always @(posedge fifo_src_clk) begin
  if (fifo_src_resetn == 1'b0) begin
    fifo_src_last_received <= 1'b0;
  end else begin
    if (fifo_src_wen && fifo_src_wlast) begin
      fifo_src_last_received <= 1'b1;
    end
  end
end

sync_bits #(
  .NUM_OF_BITS (1),
  .ASYNC_CLK (1))
i_axi_fifo_src_last_received_sync (
  .in_bits (fifo_src_last_received),
  .out_clk (axi_clk),
  .out_resetn (axi_resetn),
  .out_bits (axi_fifo_src_last_received_s));

// transfer FIFO resets to AXI clock domain
sync_bits #(
  .NUM_OF_BITS (2),
  .ASYNC_CLK (1))
i_axi_fifo_resetn_sync (
  .in_bits ({fifo_src_resetn, fifo_dst_resetn}),
  .out_clk (axi_clk),
  .out_resetn (axi_resetn),
  .out_bits ({axi_fifo_src_resetn, axi_fifo_dst_resetn}));

//-----------------------------------------------------------------------------
// Storage side logic - AXI WRITE control and data path
//-----------------------------------------------------------------------------

// AXI write reset
assign axi_src_resetn = axi_resetn & axi_fifo_src_resetn;

// Make sure that the CDC FIFO contains enough data for a full burst,
// otherwise wait until the last data beat is received
assign axi_wdata_en_s = ~axi_wcdc_almost_empty | (axi_fifo_src_last_received_s & axi_wvalid_int_s);

always @(posedge axi_clk) begin
  if (axi_src_resetn == 1'b0) begin
    axi_write_done <= 1'b0;
  end else begin
    if (axi_wlast && axi_wlast_int_s) begin
      axi_write_done <= 1'b1;
    end
  end
end

always @(posedge axi_clk) begin
  if (axi_src_resetn == 1'b0) begin
    axi_wxfer_active <= 1'b0;
  end else begin
    if (~axi_wxfer_active) begin
      axi_wxfer_active <= axi_wdata_en_s;
    end else if (axi_wready & axi_wvalid & axi_wlast) begin
      axi_wxfer_active <= 1'b0;
    end
  end
end

always @(posedge axi_clk) begin
  axi_wxfer_active_d <= {axi_wxfer_active_d, axi_wxfer_active};
end

// WRITE address and data channel control
always @(posedge axi_clk) begin : awvalid_control
  if (axi_resetn == 1'b0) begin
    axi_awvalid <= 1'b0;
  end else begin
    if (~axi_wxfer_active_d[0] & axi_wxfer_active) begin
      axi_awvalid <= 1'b1;
    end else if (axi_awready) begin
      axi_awvalid <= 1'b0;
    end
  end
end /* awvalid_control */

always @(posedge axi_clk) begin : wvalid_control
  if (axi_resetn == 1'b0) begin
    axi_wvalid <= 1'b0;
  end else begin
    if (~axi_wxfer_active_d[1] & axi_wxfer_active_d[0]) begin
      axi_wvalid <= axi_wvalid_int_s;
    end else if (axi_wready && axi_wlast) begin
      axi_wvalid <= 1'b0;
    end
  end
end /* wvalid_control */

always @(posedge axi_clk) begin : awaddr_control
  if (axi_resetn == 1'b0) begin
    axi_awaddr <= AXI_ADDRESS;
  end else begin
    if (axi_awvalid && axi_awready) begin
      axi_awaddr <= axi_awaddr + AXI_ADDR_INCR;
    end
  end
end

assign axi_awid = 4'b0000;
assign axi_awburst = 2'b01;           // INCR (Incrementing address burst)
assign axi_awlock = 1'b0;             // Normal access
assign axi_awcache = 4'b0010;         // Cacheable, but not allocate
assign axi_awprot = 3'b000;           // Normal, secure, data access
assign axi_awqos = 4'b0000;           // Not used

// 4KB by default, adjust at the last burst
assign axi_awlen = (axi_fifo_src_last_received_s & ~axi_wcdc_level_s[AXI_CDC_ADDR_WIDTH-1] &
                    axi_awvalid & axi_awready) ?
                    axi_wcdc_level_s : AXI_LENGTH;
assign axi_awsize = AXI_SIZE;

// assert write_ready when the MIG/EMIF is ready and write FSM is in one of the DATA state
assign axi_wready_int_s = axi_wvalid & axi_wready & axi_wxfer_active_d[1];
assign axi_wstrb = {AXI_BYTE_WIDTH{1'b1}};
assign axi_wlast = (axi_wbeat_counter == axi_awlen_d) ? axi_wvalid : 1'b0;
assign axi_wdata = (axi_wxfer_active) ? axi_wdata_int_s : {AXI_DATA_WIDTH{1'b0}};

// latch AWLEN for WLAST generation

always @(posedge axi_clk) begin
  if (axi_awvalid & axi_awready)
    axi_awlen_d <= axi_awlen;
end

// WRITE beat counter to assert WLAST at the right time
always @(posedge axi_clk) begin
  if ((axi_resetn == 1'b0) || (axi_wxfer_active == 1'b0)) begin
    axi_wbeat_counter <= 0;
  end else begin
    if (axi_wvalid && axi_wready) begin
      axi_wbeat_counter <= axi_wbeat_counter + 1'b1;
    end
  end
end

// NOTE: the write CDC FIFO has a 2x4KB depth, so we need to save the last
// burst length when the level is less than 4KB
// WARNING: if the CDC depth changes for some reason this will brake
always @(posedge axi_clk) begin
  if (axi_fifo_src_last_received_s & ~axi_wcdc_level_s[SRC_CDC_ADDR_WIDTH-1] &
      axi_awvalid & axi_awready) begin
    axi_last_burst_length <= axi_wcdc_level_s;
  end
end

//-----------------------------------------------------------------------------
// Storage side logic - READ control and data path
//-----------------------------------------------------------------------------

// AXI read reset
assign axi_dst_resetn = axi_resetn & axi_fifo_dst_resetn;

// the bridge is in a constant read state after the write was finished, until
// resets (e.g. before the next initialization/write)
always @(posedge axi_clk) begin
  if (axi_dst_resetn == 1'b0) begin
    axi_rdata_en <= 1'b0;
  end if (axi_write_done) begin
    axi_rdata_en <= 1'b1;
  end
end

// status flag to indicate an active read transfer
always @(posedge axi_clk) begin
  if (axi_dst_resetn == 1'b0) begin
    axi_rxfer_active <= 1'b0;
    axi_rxfer_active_d <= 1'b0;
  end else begin
    if (axi_rdata_en & ~axi_rxfer_active) begin
      axi_rxfer_active <= 1'b1;
    end if (axi_rvalid & axi_rready & axi_rlast)  begin
      axi_rxfer_active <= 1'b0;
    end
    axi_rxfer_active_d <= axi_rxfer_active;
  end
end

// Read address and data channel control
assign axi_rxfer_start_s = axi_rxfer_active & ~axi_rxfer_active_d;
always @(posedge axi_clk) begin
  if (axi_resetn == 1'b0) begin
    axi_arvalid <= 1'b0;
  end else begin
    if (axi_rxfer_start_s) begin
      axi_arvalid <= 1'b1;
    end else if (axi_arready) begin
      axi_arvalid <= 1'b0;
    end
  end
end

// the bridge needs to predict the last read burst to specify its length
// this is done by counting the write and read burst, and presuming that after
// a X number of write burst will follow n*X number of read burst, where n is
// an integer number

always @(posedge axi_clk) begin
  if (axi_resetn == 1'b0) begin
    axi_wburst_counter <= 0;
  end else begin
    if (axi_awvalid && axi_awready) begin
      axi_wburst_counter <= axi_wburst_counter + 1'b1;
    end
  end
end

always @(posedge axi_clk) begin
  if (axi_resetn == 1'b0) begin
    axi_rburst_counter <= 0;
  end else begin
    if (axi_arvalid && axi_arready) begin
      axi_rburst_counter <= (axi_rburst_counter == axi_wburst_counter) ? 32'b0 : axi_rburst_counter + 1'b1;
    end
  end
end

// READ address generation
always @(posedge axi_clk) begin
  if (axi_resetn == 1'b0) begin
    axi_araddr <= {AXI_ADDR_WIDTH{1'b0}};
  end else begin
    if (axi_arvalid && axi_arready) begin
      axi_araddr <= (axi_rburst_counter == axi_wburst_counter) ? AXI_ADDRESS : axi_araddr + AXI_ADDR_INCR;
    end
  end
end

// READ burst length generation
assign axi_arlen = (axi_arvalid & axi_arready &
                   (axi_rburst_counter == axi_wburst_counter - 1)) ?
                    axi_last_burst_length : AXI_LENGTH;

assign axi_arid = 4'b0000;
assign axi_arburst = 2'b01;
assign axi_arlock = 1'b0;
assign axi_arcache = 4'b0010;
assign axi_arprot = 3'b000;
assign axi_arqos = 4'b0000;
assign axi_arsize = AXI_SIZE;

wire [AXI_DATA_WIDTH/8:0] axi_rlast_keep_s = (axi_rlast) ? axi_wlast_tkeep : {AXI_DATA_WIDTH/8{1'b1}};

wire  [DST_DATA_WIDTH/8-1:0]  fifo_dst_tkeep_int_s;
wire  [DST_DATA_WIDTH-1:0]    fifo_dst_tdata_int_s;
wire                          fifo_dst_tready_int_s;
wire                          fifo_dst_tvalid_int_s;
wire                          fifo_dst_almost_empty_s;
wire                          fifo_dst_empty_s;

// Destination CDC FIFO - storage unit's clock domain to destination clock
// domain
util_axis_fifo_asym #(
  .S_DATA_WIDTH (AXI_DATA_WIDTH),
  .S_ADDRESS_WIDTH (AXI_CDC_ADDR_WIDTH),
  .M_DATA_WIDTH (DST_DATA_WIDTH),
  .ASYNC_CLK (1),
  .ALMOST_FULL_THRESHOLD (AXI_4KB_BYTE),
  .ALMOST_EMPTY_THRESHOLD (DST_4KB_BYTE),
  .TKEEP_EN (1),
  .TLAST_EN (1))
i_destination_cdc_fifo (
  .s_axis_aclk    (axi_clk),
  .s_axis_aresetn (axi_resetn),
  .s_axis_ready   (axi_rready),
  .s_axis_valid   (axi_rvalid),
  .s_axis_data    (axi_rdata),
  .s_axis_tkeep   (axi_rlast_keep_s),
  .s_axis_tlast   (axi_rlast),
  .s_axis_full    (),
  .s_axis_almost_full (),
  .m_axis_aclk    (fifo_dst_clk),
  .m_axis_aresetn (fifo_dst_resetn),
  .m_axis_ready   (fifo_dst_tready_int_s & fifo_dst_cdc_ready),
  .m_axis_valid   (fifo_dst_tvalid_int_s),
  .m_axis_data    (fifo_dst_tdata_int_s),
  .m_axis_tkeep   (fifo_dst_tkeep_int_s),
  .m_axis_tlast   (),
  .m_axis_almost_empty (fifo_dst_almost_empty_s),
  .m_axis_empty   (fifo_dst_empty_s)                                           // if asserted the memory can not keep up with the DAC rate
);

// Assuming that the EMIF has a higher bandwidth than the destination
// interface, load at least one burst into CDC FIFO
reg fifo_dst_cdc_ready = 0;
always @(posedge fifo_dst_clk) begin
  if (fifo_dst_resetn == 1'b0) begin
    fifo_dst_cdc_ready <= 1'b0;
  end else begin
    if (~fifo_dst_almost_empty_s) begin
      fifo_dst_cdc_ready <= 1'b1;
    end else if (fifo_dst_empty_s) begin
      fifo_dst_cdc_ready <= 1'b0;
    end
  end
end

generate
  if (REMOVE_NULL_BEAT_EN) begin : null_beat_filter

    wire fifo_nf_ready;
    wire fifo_nf_almost_empty;

    reg  fifo_dst_almost_empty_d = 0;
    reg  fifo_nf_resetn = 0;

    // NULL filter FIFO will come out of reset after the CDC FIFO has at least
    // one full AXIS4 burst (4KByte)
    always @(posedge fifo_dst_clk) begin
      fifo_dst_almost_empty_d <= fifo_dst_almost_empty_s;
    end

    always @(posedge fifo_dst_clk) begin
      if (~fifo_dst_resetn) begin
        fifo_nf_resetn <= 0;
      end else begin
        if (fifo_dst_almost_empty_d & ~fifo_dst_almost_empty_s) begin
          fifo_nf_resetn <= 1;
        end
      end
    end

    util_axis_fifo #(
      .DATA_WIDTH (DST_DATA_WIDTH),
      .ADDRESS_WIDTH (4),
      .ASYNC_CLK (0),
      .ALMOST_EMPTY_THRESHOLD (12),
      .ALMOST_FULL_THRESHOLD (8),
      .REMOVE_NULL_BEAT_EN (1),
      .TKEEP_EN (1),
      .TLAST_EN (0))
    i_null_filter_fifo (
      .s_axis_aclk    (fifo_dst_clk),
      .s_axis_aresetn (fifo_nf_resetn),
      .s_axis_ready   (fifo_dst_tready_int_s),
      .s_axis_valid   (fifo_dst_tvalid_int_s),
      .s_axis_data    (fifo_dst_tdata_int_s),
      .s_axis_tkeep   (fifo_dst_tkeep_int_s),
      .s_axis_tlast   (),
      .s_axis_full    (),
      .s_axis_almost_full (),
      .m_axis_aclk    (fifo_dst_clk),
      .m_axis_aresetn (fifo_nf_resetn),
      .m_axis_ready   (fifo_dst_ren), // FIFO is ready after CDC FIFO is ready and it's almost empty
      .m_axis_valid   (),
      .m_axis_data    (fifo_dst_rdata),
      .m_axis_tkeep   (),
      .m_axis_tlast   (),
      .m_axis_almost_empty (fifo_nf_almost_empty),
      .m_axis_empty   ()                    // if asserted the memory can not keep up with the DAC rate
    );

    reg fifo_dst_ready_int = 1'b0;
    always @(posedge fifo_dst_clk) begin
      if (fifo_dst_resetn == 1'b0) begin
        fifo_dst_ready_int <= 1'b0;
      end else begin
        // bridge is ready when null filter FIFO is ready
        if (fifo_dst_cdc_ready & ~fifo_nf_almost_empty) begin
          fifo_dst_ready_int <= 1'b1;
        end
      end
    end

    assign fifo_dst_ready = fifo_dst_ready_int;
    assign fifo_dst_empty = fifo_dst_empty_s | fifo_nf_almost_empty;

  end else begin

    assign fifo_dst_tready_int_s = fifo_dst_ren;
    assign fifo_dst_ready = fifo_dst_cdc_ready;
    assign fifo_dst_rdata = fifo_dst_tdata_int_s;
    assign fifo_dst_empty = fifo_dst_empty_s;

  end
  endgenerate

endmodule

