// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns/1ps

module util_axis_fifo #(
  parameter ASYNC_CLK = 1,
  parameter DATA_WIDTH = 64,
  parameter ADDRESS_WIDTH = 5,
  parameter M_AXIS_REGISTERED = 1,
  parameter [ADDRESS_WIDTH-1:0] ALMOST_EMPTY_THRESHOLD = 16,
  parameter [ADDRESS_WIDTH-1:0] ALMOST_FULL_THRESHOLD = 16,
  parameter TKEEP_EN = 0,
  parameter TSTRB_EN = 0,
  parameter TLAST_EN = 0,
  parameter TUSER_EN = 0,
  parameter TID_EN = 0,
  parameter TDEST_EN = 0,
  parameter TUSER_WIDTH = 1,
  parameter TID_WIDTH = 1,
  parameter TDEST_WIDTH = 1
) (
  input                      m_axis_aclk,
  input                      m_axis_aresetn,
  input                      m_axis_ready,
  output                     m_axis_valid,
  output [DATA_WIDTH-1:0]    m_axis_data,
  output [DATA_WIDTH/8-1:0]  m_axis_tkeep,
  output [DATA_WIDTH/8-1:0]  m_axis_tstrb,
  output                     m_axis_tlast,
  output [TUSER_WIDTH-1:0]   m_axis_tuser,
  output [TID_WIDTH-1:0]     m_axis_tid,
  output [TDEST_WIDTH-1:0]   m_axis_tdest,
  output [ADDRESS_WIDTH-1:0] m_axis_level,
  output                     m_axis_empty,
  output                     m_axis_almost_empty,
  output                     m_axis_full,
  output                     m_axis_almost_full,

  input                      s_axis_aclk,
  input                      s_axis_aresetn,
  output                     s_axis_ready,
  input                      s_axis_valid,
  input  [DATA_WIDTH-1:0]    s_axis_data,
  input  [DATA_WIDTH/8-1:0]  s_axis_tkeep,
  input  [DATA_WIDTH/8-1:0]  s_axis_tstrb,
  input                      s_axis_tlast,
  input  [TUSER_WIDTH-1:0]   s_axis_tuser,
  input  [TID_WIDTH-1:0]     s_axis_tid,
  input  [TDEST_WIDTH-1:0]   s_axis_tdest,
  output [ADDRESS_WIDTH-1:0] s_axis_room,
  output                     s_axis_empty,
  output                     s_axis_almost_empty,
  output                     s_axis_full,
  output                     s_axis_almost_full
);

  localparam MEM_WORD = DATA_WIDTH +
                        ((TKEEP_EN) ? (DATA_WIDTH/8) : 0) +
                        ((TSTRB_EN) ? (DATA_WIDTH/8) : 0) +
                        ((TLAST_EN) ? 1              : 0) +
                        ((TUSER_EN) ? TUSER_WIDTH    : 0) +
                        ((TID_EN)   ? TID_WIDTH      : 0) +
                        ((TDEST_EN) ? TDEST_WIDTH    : 0);

  wire [MEM_WORD-1:0] s_axis_data_int_s;
  wire [MEM_WORD-1:0] m_axis_data_int_s;

  generate if (ADDRESS_WIDTH == 0) begin : zerodeep /* it's not a real FIFO, just a 1 stage pipeline */

    if (ASYNC_CLK) begin

      (* KEEP = "yes" *) reg [DATA_WIDTH-1:0] cdc_sync_fifo_ram;
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
        .out_bits(m_axis_waddr));

      sync_bits #(
        .NUM_OF_BITS(1),
        .ASYNC_CLK(ASYNC_CLK)
      ) i_raddr_sync (
        .out_clk(s_axis_aclk),
        .out_resetn(s_axis_aresetn),
        .in_bits(m_axis_raddr),
        .out_bits(s_axis_raddr));

      assign m_axis_valid = m_axis_raddr != m_axis_waddr;
      assign m_axis_level = ~m_axis_ready;
      assign m_axis_empty = 0;
      assign m_axis_almost_empty = 0;
      assign m_axis_full = 0;
      assign m_axis_almost_full = 0;

      assign s_axis_ready = s_axis_raddr == s_axis_waddr;
      assign s_axis_empty = 0;
      assign s_axis_almost_empty = 0;
      assign s_axis_full = 0;
      assign s_axis_almost_full = 0;
      assign s_axis_room = s_axis_ready;

      always @(posedge s_axis_aclk) begin
        if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
          cdc_sync_fifo_ram <= s_axis_data;
        end
      end

      always @(posedge s_axis_aclk) begin
        if (s_axis_aresetn == 1'b0) begin
          s_axis_waddr <= 1'b0;
        end else begin
          if (s_axis_ready & s_axis_valid) begin
            s_axis_waddr <= s_axis_waddr + 1'b1;
          end
        end
      end

      always @(posedge m_axis_aclk) begin
        if (m_axis_aresetn == 1'b0) begin
          m_axis_raddr <= 1'b0;
        end else begin
          if (m_axis_valid & m_axis_ready) begin
            m_axis_raddr <= m_axis_raddr + 1'b1;
          end
        end
      end

      assign m_axis_data = cdc_sync_fifo_ram;

      // TKEEP support
      if (TKEEP_EN) begin
        reg [DATA_WIDTH/8-1:0] axis_tkeep_d;

        always @(posedge s_axis_aclk) begin
          if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
            axis_tkeep_d <= s_axis_tkeep;
          end
        end
        assign m_axis_tkeep = axis_tkeep_d;
      end else begin
        assign m_axis_tkeep = {DATA_WIDTH/8{1'b1}};
      end

      // TSTRB support
      if (TSTRB_EN) begin
        reg [DATA_WIDTH/8-1:0] axis_tstrb_d;

        always @(posedge s_axis_aclk) begin
          if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
            axis_tstrb_d <= s_axis_tstrb;
          end
        end
        assign m_axis_tstrb = axis_tstrb_d;
      end else begin
        if (TKEEP_EN) begin
          reg [DATA_WIDTH/8-1:0] axis_tkeep_d;

          always @(posedge s_axis_aclk) begin
            if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
              axis_tkeep_d <= s_axis_tkeep;
            end
          end
          assign m_axis_tstrb = axis_tkeep_d;
        end else begin
          assign m_axis_tstrb = {DATA_WIDTH/8{1'b1}};
        end
      end

      // TLAST support
      if (TLAST_EN) begin
        reg axis_tlast_d;

        always @(posedge s_axis_aclk) begin
          if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
            axis_tlast_d <= s_axis_tlast;
          end
        end
        assign m_axis_tlast = axis_tlast_d;
      end else begin
        assign m_axis_tlast = 1'b1;
      end

      // TUSER support
      if (TUSER_EN) begin
        reg [TUSER_WIDTH-1:0] axis_tuser_d;

        always @(posedge s_axis_aclk) begin
          if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
            axis_tuser_d <= s_axis_tuser;
          end
        end
        assign m_axis_tuser = axis_tuser_d;
      end else begin
        assign m_axis_tuser = {TUSER_WIDTH{1'b0}};
      end

      // TID support
      if (TID_EN) begin
        reg [TID_WIDTH-1:0] axis_tid_d;

        always @(posedge s_axis_aclk) begin
          if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
            axis_tid_d <= s_axis_tid;
          end
        end
        assign m_axis_tid = axis_tid_d;
      end else begin
        assign m_axis_tid = {TID_WIDTH{1'b0}};
      end

      // TDEST support
      if (TDEST_EN) begin
        reg [TDEST_WIDTH-1:0] axis_tdest_d;

        always @(posedge s_axis_aclk) begin
          if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
            axis_tdest_d <= s_axis_tdest;
          end
        end
        assign m_axis_tdest = axis_tdest_d;
      end else begin
        assign m_axis_tdest = {TDEST_WIDTH{1'b0}};
      end

    end /* zerodeep */

    else

    begin /* !ASYNC_CLK */

      // Note: In this mode, the write and read interface must have a symmetric
      // aspect ratio
      reg [DATA_WIDTH-1:0] axis_data_d;
      reg                  axis_valid_d;

      always @(posedge s_axis_aclk) begin
        if (!s_axis_aresetn) begin
          axis_data_d <= {DATA_WIDTH{1'b0}};
          axis_valid_d <= 1'b0;
        end else begin
          if (s_axis_ready) begin
            axis_data_d <= s_axis_data;
            axis_valid_d <= s_axis_valid;
          end
        end
      end

      assign m_axis_data = axis_data_d;
      assign m_axis_valid = axis_valid_d;
      assign s_axis_ready = m_axis_ready | ~m_axis_valid;
      assign m_axis_empty = 1'b0;
      assign m_axis_almost_empty = 1'b0;
      assign m_axis_full = 1'b0;
      assign m_axis_almost_full = 1'b0;
      assign m_axis_level = 1'b0;

      assign s_axis_empty  = 1'b0;
      assign s_axis_almost_empty  = 1'b0;
      assign s_axis_full  = 1'b0;
      assign s_axis_almost_full  = 1'b0;
      assign s_axis_room  = 1'b0;

      // TKEEP support
      if (TKEEP_EN) begin
        reg [DATA_WIDTH/8-1:0] axis_tkeep_d;

        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            axis_tkeep_d <= {DATA_WIDTH/8{1'b0}};
          end else begin
            if (s_axis_ready) begin
              axis_tkeep_d <= s_axis_tkeep;
            end
          end
        end
        assign m_axis_tkeep = axis_tkeep_d;
      end else begin
        assign m_axis_tkeep = {DATA_WIDTH/8{1'b1}};
      end

      // TSTRB support
      if (TSTRB_EN) begin
        reg [DATA_WIDTH/8-1:0] axis_tstrb_d;

        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            axis_tstrb_d <= {DATA_WIDTH/8{1'b0}};
          end else begin
            if (s_axis_ready) begin
              axis_tstrb_d <= s_axis_tstrb;
            end
          end
        end
        assign m_axis_tstrb = axis_tstrb_d;
      end else begin
        if (TKEEP_EN) begin
          reg [DATA_WIDTH/8-1:0] axis_tkeep_d;

          always @(posedge s_axis_aclk) begin
            if (!s_axis_aresetn) begin
              axis_tkeep_d <= {DATA_WIDTH/8{1'b0}};
            end else begin
              if (s_axis_ready) begin
                axis_tkeep_d <= s_axis_tkeep;
              end
            end
          end
          assign m_axis_tstrb = axis_tkeep_d;
        end else begin
          assign m_axis_tstrb = {DATA_WIDTH/8{1'b1}};
        end
      end

      // TLAST support
      if (TLAST_EN) begin
        reg  axis_tlast_d;

        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            axis_tlast_d <= 1'b0;
          end else begin
            if (s_axis_ready) begin
              axis_tlast_d <= s_axis_tlast;
            end
          end
        end
        assign m_axis_tlast = axis_tlast_d;
      end else begin
        assign m_axis_tlast = 1'b1;
      end

      // TUSER support
      if (TUSER_EN) begin
        reg [TUSER_WIDTH-1:0] axis_tuser_d;

        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            axis_tuser_d <= {TUSER_WIDTH{1'b0}};
          end else begin
            if (s_axis_ready) begin
              axis_tuser_d <= s_axis_tuser;
            end
          end
        end
        assign m_axis_tuser = axis_tuser_d;
      end else begin
        assign m_axis_tuser = {TUSER_WIDTH{1'b0}};
      end

      // TID support
      if (TID_EN) begin
        reg [TID_WIDTH-1:0] axis_tid_d;

        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            axis_tid_d <= {TID_WIDTH{1'b0}};
          end else begin
            if (s_axis_ready) begin
              axis_tid_d <= s_axis_tid;
            end
          end
        end
        assign m_axis_tid = axis_tid_d;
      end else begin
        assign m_axis_tid = {TID_WIDTH{1'b0}};
      end

      // TDEST support
      if (TDEST_EN) begin
        reg [TDEST_WIDTH-1:0] axis_tdest_d;

        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            axis_tdest_d <= {TDEST_WIDTH{1'b0}};
          end else begin
            if (s_axis_ready) begin
              axis_tdest_d <= s_axis_tdest;
            end
          end
        end
        assign m_axis_tdest = axis_tdest_d;
      end else begin
        assign m_axis_tdest = {TDEST_WIDTH{1'b0}};
      end

    end /* !ASYNC_CLK */

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
        if (_m_axis_valid) begin
          valid <= 1'b1;
        end else begin
          if (m_axis_ready) begin
            valid <= 1'b0;
          end
        end
      end
    end

    assign s_mem_write = s_axis_ready & s_axis_valid;
    assign m_mem_read = (~valid || m_axis_ready) && _m_axis_valid;

    util_axis_fifo_address_generator #(
      .ASYNC_CLK(ASYNC_CLK),
      .ADDRESS_WIDTH(ADDRESS_WIDTH),
      .ALMOST_EMPTY_THRESHOLD (ALMOST_EMPTY_THRESHOLD),
      .ALMOST_FULL_THRESHOLD (ALMOST_FULL_THRESHOLD)
    ) i_address_gray (
      .m_axis_aclk(m_axis_aclk),
      .m_axis_aresetn(m_axis_aresetn),
      .m_axis_ready(_m_axis_ready),
      .m_axis_valid(_m_axis_valid),
      .m_axis_raddr(m_axis_raddr),
      .m_axis_level(m_axis_level),
      .m_axis_empty(m_axis_empty),
      .m_axis_almost_empty(m_axis_almost_empty),
      .m_axis_full(m_axis_full),
      .m_axis_almost_full(m_axis_almost_full),
      .s_axis_aclk(s_axis_aclk),
      .s_axis_aresetn(s_axis_aresetn),
      .s_axis_ready(s_axis_ready),
      .s_axis_valid(s_axis_valid),
      .s_axis_empty(s_axis_empty),
      .s_axis_almost_empty(s_axis_almost_empty),
      .s_axis_full(s_axis_full),
      .s_axis_almost_full(s_axis_almost_full),
      .s_axis_waddr(s_axis_waddr),
      .s_axis_room(s_axis_room));

    // TLAST, TKEEP, TSTRB, TUSER, TID and TDEST support
    localparam MEM_WORD_KEEP = DATA_WIDTH +
                              ((TKEEP_EN) ? (DATA_WIDTH/8) : 0);

    localparam MEM_WORD_STRB = MEM_WORD_KEEP +
                              ((TSTRB_EN) ? (DATA_WIDTH/8) : 0);

    localparam MEM_WORD_LAST = MEM_WORD_STRB +
                              ((TLAST_EN) ? 1 : 0);

    localparam MEM_WORD_USER = MEM_WORD_LAST +
                              ((TUSER_EN) ? TUSER_WIDTH : 0);

    localparam MEM_WORD_ID = MEM_WORD_USER +
                            ((TID_EN) ? TID_WIDTH : 0);

    localparam MEM_WORD_DEST = MEM_WORD_ID +
                              ((TDEST_EN) ? TDEST_WIDTH : 0);

    assign s_axis_data_int_s[DATA_WIDTH-1-:DATA_WIDTH] = s_axis_data;
    assign m_axis_data = m_axis_data_int_s[DATA_WIDTH-1-:DATA_WIDTH];

    if (TKEEP_EN) begin
      assign s_axis_data_int_s[MEM_WORD_KEEP-1-:DATA_WIDTH/8] = s_axis_tkeep;
      assign m_axis_tkeep = m_axis_data_int_s[MEM_WORD_KEEP-1-:DATA_WIDTH/8];
    end else begin
      assign m_axis_tkeep = {DATA_WIDTH/8{1'b1}};
    end

    if (TSTRB_EN) begin
      assign s_axis_data_int_s[MEM_WORD_STRB-1-:DATA_WIDTH/8] = s_axis_tstrb;
      assign m_axis_tstrb = m_axis_data_int_s[MEM_WORD_STRB-1-:DATA_WIDTH/8];
    end else begin
      if (TKEEP_EN) begin
        assign m_axis_tstrb = m_axis_tkeep;
      end else begin
        assign m_axis_tstrb = {DATA_WIDTH/8{1'b1}};
      end
    end

    if (TLAST_EN) begin
      assign s_axis_data_int_s[MEM_WORD_LAST-1-:1] = s_axis_tlast;
      assign m_axis_tlast = m_axis_data_int_s[MEM_WORD_LAST-1-:1];
    end else begin
      assign m_axis_tlast = 1'b1;
    end

    if (TUSER_EN) begin
      assign s_axis_data_int_s[MEM_WORD_USER-1-:TUSER_WIDTH] = s_axis_tuser;
      assign m_axis_tuser = m_axis_data_int_s[MEM_WORD_USER-1-:TUSER_WIDTH];
    end else begin
      assign m_axis_tuser = {TUSER_WIDTH{1'b0}};
    end

    if (TID_EN) begin
      assign s_axis_data_int_s[MEM_WORD_ID-1-:TID_WIDTH] = s_axis_tid;
      assign m_axis_tid = m_axis_data_int_s[MEM_WORD_ID-1-:TID_WIDTH];
    end else begin
      assign m_axis_tid = {TID_WIDTH{1'b0}};
    end

    if (TDEST_EN) begin
      assign s_axis_data_int_s[MEM_WORD_DEST-1-:TDEST_WIDTH] = s_axis_tdest;
      assign m_axis_tdest = m_axis_data_int_s[MEM_WORD_DEST-1-:TDEST_WIDTH];
    end else begin
      assign m_axis_tdest = {TDEST_WIDTH{1'b0}};
    end

    if (ASYNC_CLK == 1) begin : async_clocks /* Asynchronous WRITE/READ clocks */

      // The assumption is that in this mode the M_AXIS_REGISTERED is 1
      // When the clocks are asynchronous instantiate a block RAM
      // regardless of the requested size to make sure we threat the
      // clock crossing correctly
      ad_mem #(
        .DATA_WIDTH (MEM_WORD),
        .ADDRESS_WIDTH (ADDRESS_WIDTH)
      ) i_mem (
        .clka(s_axis_aclk),
        .wea(s_mem_write),
        .addra(s_axis_waddr),
        .dina(s_axis_data_int_s),
        .clkb(m_axis_aclk),
        .reb(m_mem_read),
        .addrb(m_axis_raddr),
        .doutb(m_axis_data_int_s));

      assign _m_axis_ready = ~valid || m_axis_ready;
      assign m_axis_valid = valid;

    end else begin : sync_clocks /* Synchronous WRITE/READ clocks */

      reg [MEM_WORD-1:0] ram[0:2**ADDRESS_WIDTH-1];

      // When the clocks are synchronous use behavioral modeling for the SDP RAM
      // Let the synthesizer decide what to infer (distributed or block RAM)
      always @(posedge s_axis_aclk) begin
        if (s_mem_write) begin
          ram[s_axis_waddr] <= s_axis_data_int_s;
        end
      end

      if (M_AXIS_REGISTERED == 1) begin

        reg [MEM_WORD-1:0] data;

        always @(posedge m_axis_aclk) begin
          if (m_mem_read) begin
            data <= ram[m_axis_raddr];
          end
        end

        assign _m_axis_ready = ~valid || m_axis_ready;
        assign m_axis_data_int_s = data;
        assign m_axis_valid = valid;

      end else begin

        assign _m_axis_ready = m_axis_ready;
        assign m_axis_valid = _m_axis_valid;
        assign m_axis_data_int_s = ram[m_axis_raddr];

      end
    end

  end /* fifo */

  endgenerate

endmodule
