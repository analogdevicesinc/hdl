// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad7616 (

  // physical data interface

  rx_sclk,
  rx_cs_n,
  rx_sdo,
  rx_sdi_0,
  rx_sdi_1,

  rx_db_o,
  rx_db_i,
  rx_db_t,
  rx_rd_n,
  rx_wr_n,

  // physical control interface

  rx_cnvst,
  rx_busy,

  // AXI Slave Memory Map

  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awprot,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arprot,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rresp,
  s_axi_rdata,
  s_axi_rready,

  // Write FIFO interface

  adc_valid,
  adc_data,
  adc_sync,

  irq
);

  // parameters

  parameter       ID = 0;
  parameter       IF_TYPE = 1;

  // local parameters

  localparam      NUM_OF_SDI = 2;
  localparam      SERIAL = 0;
  localparam      PARALLEL = 1;
  localparam      NEG_EDGE = 1;
  localparam      UP_ADDRESS_WIDTH = 14;

  // IO definitions

  output                            rx_sclk;
  output                            rx_cs_n;
  output                            rx_sdo;
  input                             rx_sdi_0;
  input                             rx_sdi_1;

  output  [15:0]                    rx_db_o;
  input   [15:0]                    rx_db_i;
  output                            rx_db_t;
  output                            rx_rd_n;
  output                            rx_wr_n;

  output                            rx_cnvst;
  input                             rx_busy;

  input                             s_axi_aclk;
  input                             s_axi_aresetn;
  input                             s_axi_awvalid;
  input   [31:0]                    s_axi_awaddr;
  output                            s_axi_awready;
  input                             s_axi_wvalid;
  input   [31:0]                    s_axi_wdata;
  input   [ 3:0]                    s_axi_wstrb;
  output                            s_axi_wready;
  output                            s_axi_bvalid;
  output  [ 1:0]                    s_axi_bresp;
  input                             s_axi_bready;
  input                             s_axi_arvalid;
  input   [31:0]                    s_axi_araddr;
  output                            s_axi_arready;
  output                            s_axi_rvalid;
  output  [ 1:0]                    s_axi_rresp;
  output  [31:0]                    s_axi_rdata;
  input                             s_axi_rready;
  input   [ 2:0]                    s_axi_awprot;
  input   [ 2:0]                    s_axi_arprot;


  output                            adc_valid;
  output  [15:0]                    adc_data;
  output                            adc_sync;

  output                            irq;

  // internal registers

  reg                               up_wack = 1'b0;
  reg                               up_rack = 1'b0;
  reg     [31:0]                    up_rdata = 32'b0;

  // internal signals

  wire                              up_clk;
  wire                              up_rstn;
  wire                              up_rst;
  wire                              up_rreq_s;
  wire    [(UP_ADDRESS_WIDTH-1):0]  up_raddr_s;
  wire                              up_wreq_s;
  wire    [(UP_ADDRESS_WIDTH-1):0]  up_waddr_s;
  wire    [31:0]                    up_wdata_s;

  wire                              up_wack_if_s;
  wire                              up_rack_if_s;
  wire    [31:0]                    up_rdata_if_s;
  wire                              up_wack_cntrl_s;
  wire                              up_rack_cntrl_s;
  wire    [31:0]                    up_rdata_cntrl_s;

  wire                              trigger_s;

  wire                              rd_req_s;
  wire                              wr_req_s;
  wire    [15:0]                    wr_data_s;
  wire    [15:0]                    rd_data_s;
  wire                              rd_valid_s;
  wire    [ 4:0]                    burst_length_s;
  wire                              m_axis_ready_s;
  wire                              m_axis_valid_s;
  wire    [15:0]                    m_axis_data_s;
  wire                              m_axis_xfer_req_s;

  // defaults

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign up_rst = ~s_axi_aresetn;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= up_wack_if_s | up_wack_cntrl_s;
      up_rack <= up_rack_if_s | up_rack_cntrl_s;
      up_rdata <= up_rdata_if_s | up_rdata_cntrl_s;
    end
  end

  generate if (IF_TYPE == SERIAL) begin

    // ground all parallel interface signals

    assign rx_db_o = 16'b0;
    assign rx_rd_n = 1'b0;
    assign rx_wr_n = 1'b0;

    // SPI Framework instances and logic

    wire                                    spi_resetn_s;
    wire                                    s0_cmd_ready_s;
    wire                                    s0_cmd_valid_s;
    wire  [15:0]                            s0_cmd_data_s;
    wire                                    s0_sdo_data_ready_s;
    wire                                    s0_sdo_data_valid_s;
    wire  [ 7:0]                            s0_sdo_data_s;
    wire                                    s0_sdi_data_ready_s;
    wire                                    s0_sdi_data_valid_s;
    wire  [15:0]                            s0_sdi_data_s;
    wire                                    s0_sync_ready_s;
    wire                                    s0_sync_valid_s;
    wire  [ 7:0]                            s0_sync_s;
    wire                                    s1_cmd_ready_s;
    wire                                    s1_cmd_valid_s;
    wire  [15:0]                            s1_cmd_data_s;
    wire                                    s1_sdo_data_ready_s;
    wire                                    s1_sdo_data_valid_s;
    wire  [ 7:0]                            s1_sdo_data_s;
    wire                                    s1_sdi_data_ready_s;
    wire                                    s1_sdi_data_valid_s;
    wire  [15:0]                            s1_sdi_data_s;
    wire                                    s1_sync_ready_s;
    wire                                    s1_sync_valid_s;
    wire  [ 7:0]                            s1_sync_s;
    wire                                    m_cmd_ready_s;
    wire                                    m_cmd_valid_s;
    wire  [15:0]                            m_cmd_data_s;
    wire                                    m_sdo_data_ready_s;
    wire                                    m_sdo_data_valid_s;
    wire  [7:0]                             m_sdo_data_s;
    wire                                    m_sdi_data_ready_s;
    wire                                    m_sdi_data_valid_s;
    wire  [15:0]                            m_sdi_data_s;
    wire                                    m_sync_ready_s;
    wire                                    m_sync_valid_s;
    wire  [ 7:0]                            m_sync_s;
    wire                                    offload0_cmd_wr_en_s;
    wire  [15:0]                            offload0_cmd_wr_data_s;
    wire                                    offload0_sdo_wr_en_s;
    wire  [ 7:0]                            offload0_sdo_wr_data_s;
    wire                                    offload0_mem_reset_s;
    wire                                    offload0_enable_s;
    wire                                    offload0_enabled_s;

    axi_spi_engine #(
      .DATA_WIDTH (8),
      .NUM_OF_SDI (NUM_OF_SDI),
      .NUM_OFFLOAD(1),
      .MM_IF_TYPE(1),
      .UP_ADDRESS_WIDTH (UP_ADDRESS_WIDTH)
    ) i_axi_spi_engine (
      .up_clk (up_clk),
      .up_rstn (up_rstn),
      .up_wreq (up_wreq_s),
      .up_waddr (up_waddr_s),
      .up_wdata (up_wdata_s),
      .up_wack (up_wack_if_s),
      .up_rreq (up_rreq_s),
      .up_raddr (up_raddr_s),
      .up_rdata (up_rdata_if_s),
      .up_rack (up_rack_if_s),
      .irq (irq),
      .spi_clk (up_clk),
      .spi_resetn (spi_resetn_s),
      .cmd_ready (s0_cmd_ready_s),
      .cmd_valid (s0_cmd_valid_s),
      .cmd_data (s0_cmd_data_s),
      .sdo_data_ready (s0_sdo_data_ready_s),
      .sdo_data_valid (s0_sdo_data_valid_s),
      .sdo_data (s0_sdo_data_s),
      .sdi_data_ready (s0_sdi_data_ready_s),
      .sdi_data_valid (s0_sdi_data_valid_s),
      .sdi_data (s0_sdi_data_s),
      .sync_ready (s0_sync_ready_s),
      .sync_valid (s0_sync_valid_s),
      .sync_data (s0_sync_s),
      .offload0_cmd_wr_en (offload0_cmd_wr_en_s),
      .offload0_cmd_wr_data (offload0_cmd_wr_data_s),
      .offload0_sdo_wr_en (offload0_sdo_wr_en_s),
      .offload0_sdo_wr_data (offload0_sdo_wr_data_s),
      .offload0_mem_reset (offload0_mem_reset_s),
      .offload0_enable (offload0_enable_s),
      .offload0_enabled(offload0_enabled_s));

    spi_engine_offload #(
      .DATA_WIDTH (8),
      .NUM_OF_SDI (NUM_OF_SDI)
    ) i_spi_engine_offload (
      .ctrl_clk (up_clk),
      .ctrl_cmd_wr_en (offload0_cmd_wr_en_s),
      .ctrl_cmd_wr_data (offload0_cmd_wr_data_s),
      .ctrl_sdo_wr_en (offload0_sdo_wr_en_s),
      .ctrl_sdo_wr_data (offload0_sdo_wr_data_s),
      .ctrl_enable (offload0_enable_s),
      .ctrl_enabled (offload0_enabled_s),
      .ctrl_mem_reset (offload0_mem_reset_s),
      .spi_clk (up_clk),
      .spi_resetn (spi_resetn_s),
      .trigger (trigger_s),
      .cmd_valid (s1_cmd_valid_s),
      .cmd_ready (s1_cmd_ready_s),
      .cmd (s1_cmd_data_s),
      .sdo_data_valid (s1_sdo_data_valid_s),
      .sdo_data_ready (s1_sdo_data_ready_s),
      .sdo_data (s1_sdo_data_s),
      .sdi_data_valid (s1_sdi_data_valid_s),
      .sdi_data_ready (s1_sdi_data_ready_s),
      .sdi_data (s1_sdi_data_s),
      .sync_valid (s1_sync_valid_s),
      .sync_ready (s1_sync_ready_s),
      .sync_data (s1_sync_s),
      .offload_sdi_valid (m_axis_valid_s),
      .offload_sdi_ready (m_axis_ready_s),
      .offload_sdi_data (m_axis_data_s));

    spi_engine_interconnect #(
      .DATA_WIDTH (8),
      .NUM_OF_SDI (NUM_OF_SDI)
    ) i_spi_engine_interconnect (
      .clk (up_clk),
      .resetn (spi_resetn_s),
      .m_cmd_valid (m_cmd_valid_s),
      .m_cmd_ready (m_cmd_ready_s),
      .m_cmd_data (m_cmd_data_s),
      .m_sdo_valid (m_sdo_data_valid_s),
      .m_sdo_ready (m_sdo_data_ready_s),
      .m_sdo_data (m_sdo_data_s),
      .m_sdi_valid (m_sdi_data_valid_s),
      .m_sdi_ready (m_sdi_data_ready_s),
      .m_sdi_data (m_sdi_data_s),
      .m_sync_valid (m_sync_valid_s),
      .m_sync_ready (m_sync_ready_s),
      .m_sync (m_sync_s),
      .s0_cmd_valid (s0_cmd_valid_s),
      .s0_cmd_ready (s0_cmd_ready_s),
      .s0_cmd_data (s0_cmd_data_s),
      .s0_sdo_valid (s0_sdo_data_valid_s),
      .s0_sdo_ready (s0_sdo_data_ready_s),
      .s0_sdo_data (s0_sdo_data_s),
      .s0_sdi_valid (s0_sdi_data_valid_s),
      .s0_sdi_ready (s0_sdi_data_ready_s),
      .s0_sdi_data (s0_sdi_data_s),
      .s0_sync_valid (s0_sync_valid_s),
      .s0_sync_ready (s0_sync_ready_s),
      .s0_sync (s0_sync_s),
      .s1_cmd_valid (s1_cmd_valid_s),
      .s1_cmd_ready (s1_cmd_ready_s),
      .s1_cmd_data (s1_cmd_data_s),
      .s1_sdo_valid (s1_sdo_data_valid_s),
      .s1_sdo_ready (s1_sdo_data_ready_s),
      .s1_sdo_data (s1_sdo_data_s),
      .s1_sdi_valid (s1_sdi_data_valid_s),
      .s1_sdi_ready (s1_sdi_data_ready_s),
      .s1_sdi_data (s1_sdi_data_s),
      .s1_sync_valid (s1_sync_valid_s),
      .s1_sync_ready (s1_sync_ready_s),
      .s1_sync (s1_sync_s));

    spi_engine_execution #(
      .DATA_WIDTH (8),
      .NUM_OF_SDI (NUM_OF_SDI)
    ) i_spi_engine_execution (
      .clk (up_clk),
      .resetn (spi_resetn_s),
      .active (),
      .cmd_ready (m_cmd_ready_s),
      .cmd_valid (m_cmd_valid_s),
      .cmd (m_cmd_data_s),
      .sdo_data_valid (m_sdo_data_valid_s),
      .sdo_data_ready (m_sdo_data_ready_s),
      .sdo_data (m_sdo_data_s),
      .sdi_data_ready (m_sdi_data_ready_s),
      .sdi_data_valid (m_sdi_data_valid_s),
      .sdi_data (m_sdi_data_s),
      .sync_ready (m_sync_ready_s),
      .sync_valid (m_sync_valid_s),
      .sync (m_sync_s),
      .sclk (rx_sclk),
      .sdo (rx_sdo),
      .sdo_t (),
      .sdi (rx_sdi_0),
      .sdi_1 (rx_sdi_1),
      .sdi_2 (1'b0),
      .sdi_3 (1'b0),
      .cs (rx_cs_n),
      .three_wire ());

    axi_ad7616_maxis2wrfifo #(
      .DATA_WIDTH(16)
    ) i_maxis2wrfifo (
      .clk(up_clk),
      .rstn(up_rstn),
      .sync_in(trigger_s),
      .m_axis_data(m_axis_data_s),
      .m_axis_ready(m_axis_ready_s),
      .m_axis_valid(m_axis_valid_s),
      .fifo_wr_en(adc_valid),
      .fifo_wr_data(adc_data),
      .fifo_wr_sync(adc_sync)
    );

  end
  endgenerate

  generate if (IF_TYPE == PARALLEL) begin

    assign rx_sclk = 1'h0;
    assign rx_sdo = 1'h0;
    assign irq = 1'h0;

    assign up_wack_if_s = 1'h0;
    assign up_rack_if_s = 1'h0;
    assign up_rdata_if_s = 1'h0;

    axi_ad7616_pif i_ad7616_parallel_interface (
      .cs_n (rx_cs_n),
      .db_o (rx_db_o),
      .db_i (rx_db_i),
      .db_t (rx_db_t),
      .rd_n (rx_rd_n),
      .wr_n (rx_wr_n),
      .adc_data (adc_data),
      .adc_valid (adc_valid),
      .adc_sync (adc_sync),
      .end_of_conv (trigger_s),
      .burst_length(burst_length_s),
      .clk (up_clk),
      .rstn (up_rstn),
      .rd_req (rd_req_s),
      .wr_req (wr_req_s),
      .wr_data (wr_data_s),
      .rd_data (rd_data_s),
      .rd_valid (rd_valid_s)
    );

  end
  endgenerate

  axi_ad7616_control #(
    .ID(ID),
    .IF_TYPE(IF_TYPE)
  ) i_ad7616_control (
    .cnvst (rx_cnvst),
    .busy (rx_busy),
    .up_burst_length (burst_length_s),
    .up_read_data (rd_data_s),
    .up_read_valid (rd_valid_s),
    .up_write_data (wr_data_s),
    .up_read_req (rd_req_s),
    .up_write_req (wr_req_s),
    .end_of_conv (trigger_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_cntrl_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_cntrl_s),
    .up_rack (up_rack_cntrl_s));

  // up bus interface

  up_axi #(
    .ADDRESS_WIDTH (UP_ADDRESS_WIDTH)
  ) i_up_axi (
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
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
