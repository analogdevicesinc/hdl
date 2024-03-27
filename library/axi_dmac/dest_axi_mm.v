// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

module dest_axi_mm #(

  parameter ID_WIDTH = 3,
  parameter DMA_DATA_WIDTH = 64,
  parameter DMA_ADDR_WIDTH = 32,
  parameter BYTES_PER_BEAT_WIDTH = $clog2(DMA_DATA_WIDTH/8),
  parameter BEATS_PER_BURST_WIDTH = 4,
  parameter MAX_BYTES_PER_BURST = 128,
  parameter BYTES_PER_BURST_WIDTH = $clog2(MAX_BYTES_PER_BURST),
  parameter AXI_LENGTH_WIDTH = 8,
  parameter [3:0] AXI_AXCACHE = 4'b0011,
  parameter [2:0] AXI_AXPROT = 3'b000
) (
  input                               m_axi_aclk,
  input                               m_axi_aresetn,

  input                               req_valid,
  output                              req_ready,
  input [DMA_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH] req_address,

  input                             bl_valid,
  output                            bl_ready,
  input [BEATS_PER_BURST_WIDTH-1:0] measured_last_burst_length,

  input                               enable,
  output                              enabled,

  output                              response_valid,
  input                               response_ready,
  output [1:0]                        response_resp,
  output                              response_resp_eot,
  output                              response_resp_partial,
  output [BYTES_PER_BURST_WIDTH-1:0]  response_data_burst_length,

  input  [ID_WIDTH-1:0]             request_id,
  output [ID_WIDTH-1:0]             response_id,

  output [ID_WIDTH-1:0]             address_id,
  input                               address_eot,
  input                               response_eot,

  input                               fifo_valid,
  output                              fifo_ready,
  input [DMA_DATA_WIDTH-1:0]        fifo_data,
  input [DMA_DATA_WIDTH/8-1:0]        fifo_strb,
  input                               fifo_last,

  input [BYTES_PER_BURST_WIDTH-1:0] dest_burst_info_length,
  input                             dest_burst_info_partial,
  input [ID_WIDTH-1:0]              dest_burst_info_id,
  input                             dest_burst_info_write,
  // Write address
  input                               m_axi_awready,
  output                              m_axi_awvalid,
  output [DMA_ADDR_WIDTH-1:0]         m_axi_awaddr,
  output [AXI_LENGTH_WIDTH-1:0]       m_axi_awlen,
  output [ 2:0]                       m_axi_awsize,
  output [ 1:0]                       m_axi_awburst,
  output [ 2:0]                       m_axi_awprot,
  output [ 3:0]                       m_axi_awcache,

  // Write data
  output [DMA_DATA_WIDTH-1:0]     m_axi_wdata,
  output [(DMA_DATA_WIDTH/8)-1:0] m_axi_wstrb,
  input                               m_axi_wready,
  output                              m_axi_wvalid,
  output                              m_axi_wlast,

  // Write response
  input                               m_axi_bvalid,
  input  [ 1:0]                       m_axi_bresp,
  output                              m_axi_bready
);

  wire address_enabled;

  address_generator #(
    .ID_WIDTH(ID_WIDTH),
    .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH),
    .BYTES_PER_BEAT_WIDTH(BYTES_PER_BEAT_WIDTH),
    .DMA_DATA_WIDTH(DMA_DATA_WIDTH),
    .LENGTH_WIDTH(AXI_LENGTH_WIDTH),
    .DMA_ADDR_WIDTH(DMA_ADDR_WIDTH),
    .AXI_AXCACHE(AXI_AXCACHE),
    .AXI_AXPROT(AXI_AXPROT)
  ) i_addr_gen (
    .clk(m_axi_aclk),
    .resetn(m_axi_aresetn),

    .enable(enable),
    .enabled(address_enabled),

    .id(address_id),
    .request_id(request_id),

    .req_valid(req_valid),
    .req_ready(req_ready),
    .req_address(req_address),

    .bl_valid(bl_valid),
    .bl_ready(bl_ready),
    .measured_last_burst_length(measured_last_burst_length),

    .eot(address_eot),

    .addr_ready(m_axi_awready),
    .addr_valid(m_axi_awvalid),
    .addr(m_axi_awaddr),
    .len(m_axi_awlen),
    .size(m_axi_awsize),
    .burst(m_axi_awburst),
    .prot(m_axi_awprot),
    .cache(m_axi_awcache));

  assign m_axi_wvalid = fifo_valid;
  assign fifo_ready = m_axi_wready;
  assign m_axi_wlast = fifo_last;
  assign m_axi_wdata = fifo_data;
  assign m_axi_wstrb = fifo_strb;

  response_handler #(
    .ID_WIDTH(ID_WIDTH)
  ) i_response_handler (
    .clk(m_axi_aclk),
    .resetn(m_axi_aresetn),
    .bvalid(m_axi_bvalid),
    .bready(m_axi_bready),
    .bresp(m_axi_bresp),

    .enable(address_enabled),
    .enabled(enabled),

    .id(response_id),
    .request_id(address_id),

    .eot(response_eot),

    .resp_valid(response_valid),
    .resp_ready(response_ready),
    .resp_resp(response_resp),
    .resp_eot(response_resp_eot));

  reg [BYTES_PER_BURST_WIDTH+1-1:0] bl_mem [0:2**(ID_WIDTH)-1];

  assign {response_resp_partial,
          response_data_burst_length} = bl_mem[response_id];

  always @(posedge m_axi_aclk) begin
    if (dest_burst_info_write) begin
      bl_mem[dest_burst_info_id] <= {dest_burst_info_partial,
                                     dest_burst_info_length};
    end
  end

endmodule
