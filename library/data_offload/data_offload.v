// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
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
`timescale 1ns / 1ps

module data_offload #(

  parameter          ID = 0,
  parameter   [ 0:0] MEM_TYPE = 1'b0,               // 1'b0 -FPGA RAM; 1'b1 - external memory
  parameter   [33:0] MEM_SIZE = 1024,               // memory size in bytes -1 - max 16 GB
  parameter          MEMC_UIF_DATA_WIDTH = 512,
  parameter          MEMC_UIF_ADDRESS_WIDTH = 31,
  parameter   [31:0] MEMC_BADDRESS = 32'h00000000,

  parameter          TX_OR_RXN_PATH = 0,            // if set IP is used in TX path, other wise in RX path

  parameter          SRC_DATA_WIDTH = 64,
  parameter          SRC_RAW_DATA_EN = 1'b0,

  parameter          SRC_ADDR_WIDTH = 8,
  parameter          DST_ADDR_WIDTH = 7,

  parameter          DST_DATA_WIDTH = 128,
  parameter          DST_RAW_DATA_EN = 1'b0,        // TBD
  parameter          DST_CYCLIC_EN = 1'b0,          // 1'b1 - CYCLIC mode enabled; 1'b0 - CYCLIC mode disabled

  parameter          AUTO_BRINGUP = 1,
  parameter          SYNC_EXT_ADD_INTERNAL_CDC = 1) (

  // AXI4 Slave for configuration

  input                                       s_axi_aclk,
  input                                       s_axi_aresetn,
  input                                       s_axi_awvalid,
  input       [15:0]                          s_axi_awaddr,
  input       [ 2:0]                          s_axi_awprot,
  output                                      s_axi_awready,
  input                                       s_axi_wvalid,
  input       [31:0]                          s_axi_wdata,
  input       [ 3:0]                          s_axi_wstrb,
  output                                      s_axi_wready,
  output                                      s_axi_bvalid,
  output      [ 1:0]                          s_axi_bresp,
  input                                       s_axi_bready,
  input                                       s_axi_arvalid,
  input       [15:0]                          s_axi_araddr,
  input       [ 2:0]                          s_axi_arprot,
  output                                      s_axi_arready,
  output                                      s_axi_rvalid,
  input                                       s_axi_rready,
  output      [ 1:0]                          s_axi_rresp,
  output      [31:0]                          s_axi_rdata,

  // AXI4 stream slave for source stream (TX_DMA or ADC) -- Source interface

  input                                       s_axis_aclk,
  input                                       s_axis_aresetn,
  output                                      s_axis_ready,
  input                                       s_axis_valid,
  input  [SRC_DATA_WIDTH-1:0]                 s_axis_data,
  input                                       s_axis_last,
  input  [SRC_DATA_WIDTH/8-1:0]               s_axis_tkeep,

  // AXI4 stream master for destination stream (RX_DMA or DAC) -- Destination
  // interface

  input                                       m_axis_aclk,
  input                                       m_axis_aresetn,
  input                                       m_axis_ready,
  output                                      m_axis_valid,
  output  [DST_DATA_WIDTH-1:0]                m_axis_data,
  output                                      m_axis_last,
  output  [DST_DATA_WIDTH/8-1:0]              m_axis_tkeep,

  // initialization request interface

  input                                       init_req,
  output                                      init_ack,

  input                                       sync_ext,

  // FIFO interface - Memory UI

  output                                      fifo_src_wen,
  output                                      fifo_src_resetn,
  output  [SRC_ADDR_WIDTH-1:0]                fifo_src_waddr,
  output  [SRC_DATA_WIDTH-1:0]                fifo_src_wdata,
  output                                      fifo_src_wlast,

  output                                      fifo_dst_ren,
  input                                       fifo_dst_ready,
  output                                      fifo_dst_resetn,
  output  [DST_ADDR_WIDTH-1:0]                fifo_dst_raddr,
  input   [DST_DATA_WIDTH-1:0]                fifo_dst_rdata,

  // Status and monitor

  input                                       ddr_calib_done
);

  // local parameters -- to make the code more readable

  localparam  SRC_ADDR_WIDTH_BYPASS = (SRC_DATA_WIDTH > DST_DATA_WIDTH) ? 3 : 3 + $clog2(SRC_DATA_WIDTH/DST_DATA_WIDTH);
  localparam  DST_ADDR_WIDTH_BYPASS = (SRC_DATA_WIDTH <= DST_DATA_WIDTH) ? 3 + $clog2(DST_DATA_WIDTH/SRC_DATA_WIDTH) : 3;

  localparam SRC_BEAT_BYTE = $clog2(SRC_DATA_WIDTH/8);

  // NOTE: Clock domain prefixes
  //    src_*  - AXI4 Stream Slave interface's clock domain
  //    dst_*  - AXI4 Stream Master interface's clock domain

  // internal signals
  wire                                        up_clk;
  wire                                        up_rstn;
  wire                                        up_wreq_s;
  wire  [13:0]                                up_waddr_s;
  wire  [31:0]                                up_wdata_s;
  wire                                        up_rreq_s;
  wire  [13:0]                                up_raddr_s;
  wire                                        up_wack_s;
  wire                                        up_rack_s;
  wire  [31:0]                                up_rdata_s;

  wire                                        src_clk;
  wire                                        src_rstn;
  wire                                        src_valid_out_s;
  wire  [SRC_ADDR_WIDTH-1:0]                  src_wr_addr_s;
  wire                                        src_wr_ready_s;
  wire                                        src_wr_last_s;
  wire  [SRC_DATA_WIDTH/8-1:0]                src_wr_tkeep_s;

  wire                                        dst_clk;
  wire                                        dst_rstn;
  wire  [DST_ADDR_WIDTH-1:0]                  dst_raddr_s;
  wire  [DST_DATA_WIDTH-1:0]                  dst_mem_data_s;

  wire                                        src_bypass_s;
  wire                                        dst_bypass_s;
  wire                                        oneshot_s;
  wire  [63:0]                                sample_count_s;
  wire  [ 1:0]                                sync_config_s;
  wire                                        sync_int_s;
  wire                                        valid_bypass_s;
  wire  [DST_DATA_WIDTH-1:0]                  data_bypass_s;
  wire                                        ready_bypass_s;
  wire  [ 1:0]                                src_fsm_status_s;
  wire  [ 1:0]                                dst_fsm_status_s;
  wire                                        m_axis_valid_s;
  wire                                        m_axis_last_s;
  wire  [DST_DATA_WIDTH-1:0]                  m_axis_data_s;
  wire                                        dst_mem_valid_s;
  wire                                        dst_mem_valid_int_s;
  wire                                        m_axis_reset_int_s;

  wire  [33:0]                                src_transfer_length_s;
  wire                                        src_wr_last_int_s;
  wire  [33:0]                                src_wr_last_beat_s;

  wire                                        int_not_full;

  assign src_clk = s_axis_aclk;
  assign dst_clk = m_axis_aclk;

  // internal registers

  reg [33:0] src_data_counter = 0;
  reg        dst_mem_valid_d = 1'b0;

  generate
  if (TX_OR_RXN_PATH) begin
    assign src_wr_last_s = s_axis_last;
    assign src_wr_tkeep_s = s_axis_tkeep;
    assign m_axis_reset_int_s = ~dst_rstn;
  end else begin
    assign src_wr_last_s = src_wr_last_int_s;
    assign src_wr_tkeep_s = {(SRC_DATA_WIDTH/8){1'b1}};
    assign m_axis_reset_int_s = ~dst_rstn | ~init_req;
  end
  endgenerate
  assign fifo_src_wlast = src_wr_last_s;

  // Offload FSM and control
  data_offload_fsm #(
    .TX_OR_RXN_PATH (TX_OR_RXN_PATH),
    .WR_ADDRESS_WIDTH (SRC_ADDR_WIDTH),
    .WR_DATA_WIDTH (SRC_DATA_WIDTH),
    .RD_ADDRESS_WIDTH (DST_ADDR_WIDTH),
    .RD_DATA_WIDTH (DST_DATA_WIDTH),
    .SYNC_EXT_ADD_INTERNAL_CDC (SYNC_EXT_ADD_INTERNAL_CDC ))
  i_data_offload_fsm (
    .up_clk (up_clk),
    .wr_clk (src_clk),
    .wr_resetn_in (src_rstn),
    .wr_resetn_out (fifo_src_resetn),
    .wr_valid_in (s_axis_valid),
    .wr_valid_out (fifo_src_wen),
    .wr_ready (src_wr_ready_s),
    .wr_addr (fifo_src_waddr),
    .wr_last (src_wr_last_s),
    .wr_tkeep (src_wr_tkeep_s),
    .rd_clk (dst_clk),
    .rd_resetn_in (dst_rstn),
    .rd_resetn_out (fifo_dst_resetn),
    .rd_ready (fifo_dst_ready_int_s),
    .rd_valid (dst_mem_valid_s),
    .rd_addr (fifo_dst_raddr),
    .rd_last (),
    .rd_tkeep (m_axis_tkeep),
    .rd_oneshot (oneshot_s),
    .init_req (init_req),
    .init_ack (init_ack),
    .sync_config (sync_config_s),
    .sync_external (sync_ext),
    .sync_internal (sync_int_s),
    .wr_fsm_state (src_fsm_status_s),
    .rd_fsm_state (dst_fsm_status_s),
    .sample_count (sample_count_s)
  );

  // In case of external memory, read back can not start right after the write
  // was finished (because of the CDC FIFOs and the latency of the EMIF
  // interface)
  generate
  if (MEM_TYPE == 1'b1) begin
    assign dst_mem_valid_int_s = dst_mem_valid_s;
  end else begin
    // Compensate the 1 cycle READ latency of the BRAM
    always @(posedge m_axis_aclk) begin
      dst_mem_valid_d <= dst_mem_valid_s;
    end
    assign dst_mem_valid_int_s = dst_mem_valid_d;
  end
  endgenerate

  assign fifo_dst_ready_int_s = fifo_dst_ready & int_not_full;

  assign fifo_src_wdata = s_axis_data;
  assign fifo_dst_ren = dst_mem_valid_s;

  ad_axis_inf_rx #(
    .DATA_WIDTH (DST_DATA_WIDTH))
  i_rx_axis_inf (
    .clk (m_axis_aclk),
    .rst (m_axis_reset_int_s),
    .valid (dst_mem_valid_int_s),
    .data (fifo_dst_rdata),
    .last (1'b0),
    .inf_valid (m_axis_valid_s),
    .inf_last (m_axis_last_s),
    .inf_data (m_axis_data_s),
    .inf_ready (m_axis_ready),
    .int_not_full(int_not_full));

  assign m_axis_valid = (dst_bypass_s) ? valid_bypass_s : m_axis_valid_s;
  assign m_axis_data  = (dst_bypass_s) ? data_bypass_s  : m_axis_data_s;
  assign m_axis_last  = (dst_bypass_s) ? 1'b0           : m_axis_last_s;
  assign s_axis_ready = (src_bypass_s) ? ready_bypass_s : src_wr_ready_s;

  // Bypass module instance -- the same FIFO, just a smaller depth
  // NOTE: Generating an overflow is making sense just in BYPASS mode, and
  // it's supported just with the FIFO interface
  util_axis_fifo_asym #(
    .S_DATA_WIDTH (SRC_DATA_WIDTH),
    .S_ADDRESS_WIDTH (SRC_ADDR_WIDTH_BYPASS),
    .M_DATA_WIDTH (DST_DATA_WIDTH),
    .ASYNC_CLK (1))
  i_bypass_fifo (
    .m_axis_aclk (m_axis_aclk),
    .m_axis_aresetn (dst_rstn),
    .m_axis_ready (m_axis_ready),
    .m_axis_valid (valid_bypass_s),
    .m_axis_data  (data_bypass_s),
    .m_axis_tlast (),
    .m_axis_empty (),
    .m_axis_almost_empty (),
    .s_axis_aclk  (s_axis_aclk),
    .s_axis_aresetn (src_rstn),
    .s_axis_ready (ready_bypass_s),
    .s_axis_valid (s_axis_valid),
    .s_axis_data  (s_axis_data),
    .s_axis_tlast (),
    .s_axis_full  (),
    .s_axis_almost_full ()
  );

  // register map

  data_offload_regmap #(
    .ID (ID),
    .MEM_TYPE (MEM_TYPE),
    .MEM_SIZE (MEM_SIZE),
    .TX_OR_RXN_PATH (TX_OR_RXN_PATH),
    .AUTO_BRINGUP (AUTO_BRINGUP))
  i_regmap (
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_rreq (up_rreq_s),
    .up_rack (up_rack_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_wreq (up_wreq_s),
    .up_wack (up_wack_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .src_clk (s_axis_aclk),
    .dst_clk (m_axis_aclk),
    .src_sw_resetn (src_rstn),
    .dst_sw_resetn (dst_rstn),
    .ddr_calib_done (ddr_calib_done),
    .src_bypass (src_bypass_s),
    .dst_bypass (dst_bypass_s),
    .oneshot (oneshot_s),
    .sync (sync_int_s),
    .sync_config (sync_config_s),
    .src_transfer_length (src_transfer_length_s),
    .src_fsm_status (src_fsm_status_s),
    .dst_fsm_status (dst_fsm_status_s),
    .sample_count_msb (sample_count_s[63:32]),
    .sample_count_lsb (sample_count_s[31: 0])
  );

  // axi interface wrapper

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  up_axi #(
    .AXI_ADDRESS_WIDTH (16))
  i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
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
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

/* Beat counter on the source interface
*
 * The storage unit can have size of a couple of Gbyte, which in case of an RX
 * path would mean to fill up all that memory space before pushing over the
 * stream to the RX DMA. (ADC can not generate a tlast) To make things more
 * practical, user can set an arbitrary transfer length using the
 * transfer_length register, which will be used to generate an internal tlast
 * signal for the source FSM. If the register is set to zero, all the memory
 * will be filled up, before passing control to the destination FSM.
 *
 */

always @(posedge s_axis_aclk) begin
  if (fifo_src_resetn == 1'b0) begin       // counter should reset when source FMS resets
    src_data_counter <= 0;
  end else begin
    if (fifo_src_wen & src_wr_ready_s) begin
      src_data_counter <= src_data_counter + 1'b1;
    end
  end
end
// transfer length is in bytes, but counter monitors the source data beats
assign src_wr_last_beat_s = (src_transfer_length_s == 'h0) ? MEM_SIZE[33:SRC_BEAT_BYTE]-1 : src_transfer_length_s[33:SRC_BEAT_BYTE]-1;
assign src_wr_last_int_s = (src_data_counter == src_wr_last_beat_s) ?  1'b1 : 1'b0;

endmodule

