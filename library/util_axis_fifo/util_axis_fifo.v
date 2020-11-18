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

module util_axis_fifo #(
  parameter DATA_WIDTH = 64,
  parameter ADDRESS_WIDTH = 5,
  parameter ASYNC_CLK = 1,
  parameter M_AXIS_REGISTERED = 1
) (
  input m_axis_aclk,
  input m_axis_aresetn,
  input m_axis_ready,
  output m_axis_valid,
  output [DATA_WIDTH-1:0] m_axis_data,
  output [ADDRESS_WIDTH-1:0] m_axis_level,
  output m_axis_empty,

  input s_axis_aclk,
  input s_axis_aresetn,
  output s_axis_ready,
  input s_axis_valid,
  input [DATA_WIDTH-1:0] s_axis_data,
  output [ADDRESS_WIDTH-1:0] s_axis_room,
  output s_axis_full
);

generate if (ADDRESS_WIDTH == 0) begin : zerodeep /* it's not a real FIFO, just a 1 stage pipeline */

  if (ASYNC_CLK) begin

      reg [DATA_WIDTH-1:0] cdc_sync_fifo_ram;
      reg s_axis_waddr = 1'b0;
      reg m_axis_raddr = 1'b0;

      wire m_axis_waddr;
      wire s_axis_raddr;

      sync_bits #(
        .NUM_OF_BITS(1),
        .ASYNC_CLK(ASYNC_CLK)
      ) i_waddr_sync (
        .out_clk(m_axis_aclk),
        .out_resetn(m_axis_aresetn),
        .in_bits(s_axis_waddr),
        .out_bits(m_axis_waddr)
      );

      sync_bits #(
        .NUM_OF_BITS(1),
        .ASYNC_CLK(ASYNC_CLK)
      ) i_raddr_sync (
        .out_clk(s_axis_aclk),
        .out_resetn(s_axis_aresetn),
        .in_bits(m_axis_raddr),
        .out_bits(s_axis_raddr)
      );

      assign m_axis_valid = m_axis_raddr != m_axis_waddr;
      assign m_axis_level = ~m_axis_ready;
      assign s_axis_ready = s_axis_raddr == s_axis_waddr;
      assign s_axis_empty = ~s_axis_valid;
      assign s_axis_room = s_axis_ready;

      always @(posedge s_axis_aclk) begin
        if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1)
          cdc_sync_fifo_ram <= s_axis_data;
      end

      always @(posedge s_axis_aclk) begin
        if (s_axis_aresetn == 1'b0) begin
          s_axis_waddr <= 1'b0;
        end else if (s_axis_ready & s_axis_valid) begin
          s_axis_waddr <= s_axis_waddr + 1'b1;
        end
      end

      always @(posedge m_axis_aclk) begin
        if (m_axis_aresetn == 1'b0) begin
          m_axis_raddr <= 1'b0;
        end else begin
        if (m_axis_valid & m_axis_ready)
          m_axis_raddr <= m_axis_raddr + 1'b1;
        end
      end

      assign m_axis_data = cdc_sync_fifo_ram;

  end else begin /* !ASYNC_CLK */

    // Note: In this mode, the write and read interface must have a symmetric
    // aspect ratio
    reg [DATA_WIDTH-1:0] axis_data_d;
    reg                  axis_valid_d;

    always @(posedge s_axis_aclk) begin
      if (!s_axis_aresetn) begin
        axis_data_d <= {DATA_WIDTH{1'b0}};
        axis_valid_d <= 1'b0;
      end else if (s_axis_ready) begin
        axis_data_d <= s_axis_data;
        axis_valid_d <= s_axis_valid;
      end
    end

    assign m_axis_data = axis_data_d;
    assign m_axis_valid = axis_valid_d;
    assign s_axis_ready = m_axis_ready | ~m_axis_valid;
    assign m_axis_empty = 1'b0;
    assign m_axis_level = 1'b0;
    assign s_axis_full  = 1'b0;
    assign s_axis_room  = 1'b0;

  end

end else begin : fifo /* ADDRESS_WIDTH != 0 - this is a real FIFO implementation */

  wire [ADDRESS_WIDTH-1:0] s_axis_waddr;
  wire [ADDRESS_WIDTH-1:0] m_axis_raddr;
  wire _m_axis_ready;
  wire _m_axis_valid;

  wire s_mem_write;
  wire m_mem_read;

  reg valid = 1'b0;

  /* Control for first falls through */
  always @(posedge m_axis_aclk) begin
    if (m_axis_aresetn == 1'b0) begin
      valid <= 1'b0;
    end else begin
      if (_m_axis_valid)
        valid <= 1'b1;
      else if (m_axis_ready)
        valid <= 1'b0;
    end
  end

  assign s_mem_write = s_axis_ready & s_axis_valid;
  assign m_mem_read = (~valid || m_axis_ready) && _m_axis_valid;

  util_axis_fifo_address_generator #(
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(ADDRESS_WIDTH))
  i_address_gray (
    .m_axis_aclk(m_axis_aclk),
    .m_axis_aresetn(m_axis_aresetn),
    .m_axis_ready(_m_axis_ready),
    .m_axis_valid(_m_axis_valid),
    .m_axis_raddr(m_axis_raddr),
    .m_axis_level(m_axis_level),
    .m_axis_empty(m_axis_empty),
    .s_axis_aclk(s_axis_aclk),
    .s_axis_aresetn(s_axis_aresetn),
    .s_axis_ready(s_axis_ready),
    .s_axis_valid(s_axis_valid),
    .s_axis_full(s_axis_full),
    .s_axis_waddr(s_axis_waddr),
    .s_axis_room(s_axis_room)
  );

  if (ASYNC_CLK == 1) begin : async_clocks /* Asynchronous WRITE/READ clocks */

    // The assumption is that in this mode the M_AXIS_REGISTERED is 1
    // When the clocks are asynchronous instantiate a block RAM
    // regardless of the requested size to make sure we threat the
    // clock crossing correctly
    ad_mem #(
      .DATA_WIDTH (DATA_WIDTH),
      .ADDRESS_WIDTH (ADDRESS_WIDTH))
    i_mem (
      .clka(s_axis_aclk),
      .wea(s_mem_write),
      .addra(s_axis_waddr),
      .dina(s_axis_data),
      .clkb(m_axis_aclk),
      .reb(m_mem_read),
      .addrb(m_axis_raddr),
      .doutb(m_axis_data)
    );

    assign _m_axis_ready = ~valid || m_axis_ready;
    assign m_axis_valid = valid;

  end else begin : sync_clocks /* Synchronous WRITE/READ clocks */

    reg [DATA_WIDTH-1:0] ram[0:2**ADDRESS_WIDTH-1];

    // When the clocks are synchronous use behavioral modeling for the SDP RAM
    // Let the synthesizer decide what to infer (distributed or block RAM)
    always @(posedge s_axis_aclk) begin
      if (s_mem_write)
        ram[s_axis_waddr] <= s_axis_data;
    end

    if (M_AXIS_REGISTERED == 1) begin

      reg [DATA_WIDTH-1:0] data;

      always @(posedge m_axis_aclk) begin
        if (m_mem_read)
          data <= ram[m_axis_raddr];
      end

      assign _m_axis_ready = ~valid || m_axis_ready;
      assign m_axis_data = data;
      assign m_axis_valid = valid;

    end else begin

      assign _m_axis_ready = m_axis_ready;
      assign m_axis_valid = _m_axis_valid;
      assign m_axis_data = ram[m_axis_raddr];

    end
  end
end /* fifo */
endgenerate

endmodule
