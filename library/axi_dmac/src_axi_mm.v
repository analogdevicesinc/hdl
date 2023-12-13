// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module src_axi_mm #(

  parameter ID_WIDTH = 3,
  parameter DMA_DATA_WIDTH = 64,
  parameter DMA_ADDR_WIDTH = 32,
  parameter BYTES_PER_BEAT_WIDTH = 3,
  parameter BEATS_PER_BURST_WIDTH = 4,
  parameter AXI_LENGTH_WIDTH = 8
) (
  input                           m_axi_aclk,
  input                           m_axi_aresetn,

  input                           req_valid,
  output                          req_ready,
  input [DMA_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH] req_address,
  input [BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,
  input [BYTES_PER_BEAT_WIDTH-1:0]  req_last_beat_bytes,

  input                            enable,
  output reg                       enabled = 1'b0,

  output                           bl_valid,
  input                            bl_ready,
  output [BEATS_PER_BURST_WIDTH-1:0] measured_last_burst_length,
/*
  output                          response_valid,
  input                           response_ready,
  output [1:0]                    response_resp,
*/

  input  [ID_WIDTH-1:0]            request_id,
  output [ID_WIDTH-1:0]            response_id,

  output [ID_WIDTH-1:0]            data_id,
  output [ID_WIDTH-1:0]            address_id,
  input                            address_eot,

  output                           fifo_valid,
  output [DMA_DATA_WIDTH-1:0]      fifo_data,
  output [BYTES_PER_BEAT_WIDTH-1:0] fifo_valid_bytes,
  output                           fifo_last,

  // Read address
  input                            m_axi_arready,
  output                           m_axi_arvalid,
  output [DMA_ADDR_WIDTH-1:0]      m_axi_araddr,
  output [AXI_LENGTH_WIDTH-1:0]    m_axi_arlen,
  output [ 2:0]                    m_axi_arsize,
  output [ 1:0]                    m_axi_arburst,
  output [ 2:0]                    m_axi_arprot,
  output [ 3:0]                    m_axi_arcache,

  // Read data and response
  input  [DMA_DATA_WIDTH-1:0]      m_axi_rdata,
  output                           m_axi_rready,
  input                            m_axi_rvalid,
  input                            m_axi_rlast,
  input  [ 1:0]                    m_axi_rresp
);

  `include "inc_id.vh"

  reg [ID_WIDTH-1:0] id = 'h00;

  wire address_enabled;
  wire req_ready_ag;
  wire req_valid_ag;
  wire bl_ready_ag;
  wire bl_valid_ag;

  assign data_id = id;
  assign response_id = id;

  assign measured_last_burst_length = req_last_burst_length;

  reg [BYTES_PER_BEAT_WIDTH-1:0] last_beat_bytes;
  reg [BYTES_PER_BEAT_WIDTH-1:0] last_beat_bytes_mem[0:2**ID_WIDTH-1];

  assign fifo_valid_bytes = last_beat_bytes_mem[data_id];

  always @(posedge m_axi_aclk) begin
    if (bl_ready_ag == 1'b1 && bl_valid_ag == 1'b1) begin
      last_beat_bytes <= req_last_beat_bytes;
    end
  end

  always @(posedge m_axi_aclk) begin
    last_beat_bytes_mem[address_id] <= address_eot ? last_beat_bytes :
                                                     {BYTES_PER_BEAT_WIDTH{1'b1}};
  end

  splitter #(
    .NUM_M(3)
  ) i_req_splitter (
    .clk(m_axi_aclk),
    .resetn(m_axi_aresetn),
    .s_valid(req_valid),
    .s_ready(req_ready),
    .m_valid({
      bl_valid,
      bl_valid_ag,
      req_valid_ag}),
    .m_ready({
      bl_ready,
      bl_ready_ag,
      req_ready_ag}));

  address_generator #(
    .ID_WIDTH(ID_WIDTH),
    .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH),
    .BYTES_PER_BEAT_WIDTH(BYTES_PER_BEAT_WIDTH),
    .DMA_DATA_WIDTH(DMA_DATA_WIDTH),
    .LENGTH_WIDTH(AXI_LENGTH_WIDTH),
    .DMA_ADDR_WIDTH(DMA_ADDR_WIDTH)
  ) i_addr_gen (
    .clk(m_axi_aclk),
    .resetn(m_axi_aresetn),

    .enable(enable),
    .enabled(address_enabled),

    .request_id(request_id),
    .id(address_id),

    .req_valid(req_valid_ag),
    .req_ready(req_ready_ag),
    .req_address(req_address),

    .bl_valid(bl_valid_ag),
    .bl_ready(bl_ready_ag),
    .measured_last_burst_length(req_last_burst_length),

    .eot(address_eot),

    .addr_ready(m_axi_arready),
    .addr_valid(m_axi_arvalid),
    .addr(m_axi_araddr),
    .len(m_axi_arlen),
    .size(m_axi_arsize),
    .burst(m_axi_arburst),
    .prot(m_axi_arprot),
    .cache(m_axi_arcache));

  assign fifo_valid = m_axi_rvalid;
  assign fifo_data = m_axi_rdata;
  assign fifo_last = m_axi_rlast;

  /*
   * There is a requirement that data_id <= address_id (modulo 2**ID_WIDTH).  We
   * know that we will never receive data before we have requested it so there is
   * an implicit dependency between data_id and address_id and no need to
   * explicitly track it.
   */
  always @(posedge m_axi_aclk) begin
    if (m_axi_aresetn == 1'b0) begin
      id <= 'h00;
    end else if (m_axi_rvalid == 1'b1 && m_axi_rlast == 1'b1) begin
      id <= inc_id(id);
    end
  end

  /*
   * We won't be receiving data before we've requested it and we won't request
   * data unless there is room in the store-and-forward memory.
   */
  assign m_axi_rready = 1'b1;

  /*
   * We need to complete all bursts for which an address has been put onto the
   * AXI-MM interface.
   */
  always @(posedge m_axi_aclk) begin
    if (m_axi_aresetn == 1'b0) begin
      enabled <= 1'b0;
    end else if (address_enabled == 1'b1) begin
      enabled <= 1'b1;
    end else if (id == address_id) begin
      enabled <= 1'b0;
    end
  end

  /* TODO
  `include "resp.vh"

  assign response_valid = 1'b0;
  assign response_resp = RESP_OKAY;

  reg [1:0] rresp;

  always @(posedge m_axi_aclk)
  begin
    if (m_axi_rvalid && m_axi_rready) begin
      if (m_axi_rresp != 2'b0)
        rresp <= m_axi_rresp;
    end
  end
  */

endmodule
