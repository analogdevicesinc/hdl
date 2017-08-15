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

module dmac_src_mm_axi #(

  parameter ID_WIDTH = 3,
  parameter DMA_DATA_WIDTH = 64,
  parameter DMA_ADDR_WIDTH = 32,
  parameter BYTES_PER_BEAT_WIDTH = 3,
  parameter BEATS_PER_BURST_WIDTH = 4,
  parameter AXI_LENGTH_WIDTH = 8)(

  input                           m_axi_aclk,
  input                           m_axi_aresetn,

  input                           req_valid,
  output                          req_ready,
  input [DMA_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH] req_address,
  input [BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,

  input                           enable,
  output                          enabled,
  input                           sync_id,
  output                          sync_id_ret,

/*
  output                          response_valid,
  input                           response_ready,
  output [1:0]                    response_resp,
*/

  input  [ID_WIDTH-1:0]         request_id,
  output [ID_WIDTH-1:0]         response_id,

  output [ID_WIDTH-1:0]         data_id,
  output [ID_WIDTH-1:0]         address_id,
  input                           data_eot,
  input                           address_eot,

  output                          fifo_valid,
  input                           fifo_ready,
  output [DMA_DATA_WIDTH-1:0]   fifo_data,

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
  input  [DMA_DATA_WIDTH-1:0]    m_axi_rdata,
  output                           m_axi_rready,
  input                            m_axi_rvalid,
  input  [ 1:0]                    m_axi_rresp
);

wire address_enabled;

wire address_req_valid;
wire address_req_ready;
wire data_req_valid;
wire data_req_ready;

assign sync_id_ret = sync_id;
assign response_id = data_id;

splitter #(
  .NUM_M(2)
) i_req_splitter (
  .clk(m_axi_aclk),
  .resetn(m_axi_aresetn),
  .s_valid(req_valid),
  .s_ready(req_ready),
  .m_valid({
    address_req_valid,
    data_req_valid
  }),
  .m_ready({
    address_req_ready,
    data_req_ready
  })
);

dmac_address_generator #(
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
  .sync_id(sync_id),

  .request_id(request_id),
  .id(address_id),

  .req_valid(address_req_valid),
  .req_ready(address_req_ready),
  .req_address(req_address),
  .req_last_burst_length(req_last_burst_length),

  .eot(address_eot),

  .addr_ready(m_axi_arready),
  .addr_valid(m_axi_arvalid),
  .addr(m_axi_araddr),
  .len(m_axi_arlen),
  .size(m_axi_arsize),
  .burst(m_axi_arburst),
  .prot(m_axi_arprot),
  .cache(m_axi_arcache)
);

dmac_data_mover # (
  .ID_WIDTH(ID_WIDTH),
  .DATA_WIDTH(DMA_DATA_WIDTH),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH)
) i_data_mover (
  .clk(m_axi_aclk),
  .resetn(m_axi_aresetn),

  .enable(address_enabled),
  .enabled(enabled),
  .sync_id(sync_id),

  .xfer_req(),

  .request_id(address_id),
  .response_id(data_id),
  .eot(data_eot),

  .req_valid(data_req_valid),
  .req_ready(data_req_ready),
  .req_last_burst_length(req_last_burst_length),

  .s_axi_valid(m_axi_rvalid),
  .s_axi_ready(m_axi_rready),
  .s_axi_data(m_axi_rdata),
  .m_axi_valid(fifo_valid),
  .m_axi_ready(fifo_ready),
  .m_axi_data(fifo_data),
  .m_axi_last()
);

/* TODO
`include "resp.h"

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
