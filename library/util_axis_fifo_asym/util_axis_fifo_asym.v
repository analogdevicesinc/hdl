// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2025 Analog Devices, Inc. All rights reserved.
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

module util_axis_fifo_asym #(
  parameter ASYNC_CLK = 1,
  parameter S_DATA_WIDTH = 64,
  parameter M_DATA_WIDTH = 128,
  parameter ADDRESS_WIDTH = 5,
  parameter M_AXIS_REGISTERED = 1,
  parameter [ADDRESS_WIDTH-1:0] ALMOST_EMPTY_THRESHOLD = 4,
  parameter [ADDRESS_WIDTH-1:0] ALMOST_FULL_THRESHOLD = 4,
  parameter TKEEP_EN = 0,
  parameter TSTRB_EN = 0,
  parameter TLAST_EN = 0,
  parameter TUSER_EN = 0,
  parameter TID_EN = 0,
  parameter TDEST_EN = 0,
  parameter TUSER_BITS_PER_BYTE = 0,
  parameter TUSER_WIDTH = 1,
  parameter TID_WIDTH = 1,
  parameter TDEST_WIDTH = 1,
  parameter REDUCED_FIFO = 1
) (
  input                       m_axis_aclk,
  input                       m_axis_aresetn,
  input                       m_axis_ready,
  output                      m_axis_valid,
  output [M_DATA_WIDTH-1:0]   m_axis_data,
  output [M_DATA_WIDTH/8-1:0] m_axis_tkeep,
  output [M_DATA_WIDTH/8-1:0] m_axis_tstrb,
  output                      m_axis_tlast,
  output [TUSER_WIDTH-1:0]    m_axis_tuser,
  output [TID_WIDTH-1:0]      m_axis_tid,
  output [TDEST_WIDTH-1:0]    m_axis_tdest,
  output                      m_axis_empty,
  output                      m_axis_almost_empty,
  output                      m_axis_full,
  output                      m_axis_almost_full,
  output [ADDRESS_WIDTH+9:0]  m_axis_level,

  input                       s_axis_aclk,
  input                       s_axis_aresetn,
  output                      s_axis_ready,
  input                       s_axis_valid,
  input  [S_DATA_WIDTH-1:0]   s_axis_data,
  input  [S_DATA_WIDTH/8-1:0] s_axis_tkeep,
  input  [S_DATA_WIDTH/8-1:0] s_axis_tstrb,
  input                       s_axis_tlast,
  input  [TUSER_WIDTH-1:0]    s_axis_tuser,
  input  [TID_WIDTH-1:0]      s_axis_tid,
  input  [TDEST_WIDTH-1:0]    s_axis_tdest,
  output                      s_axis_empty,
  output                      s_axis_almost_empty,
  output                      s_axis_full,
  output                      s_axis_almost_full,
  output [ADDRESS_WIDTH+9:0]  s_axis_room
);

  // define which interface has a wider bus
  localparam RATIO_TYPE = (S_DATA_WIDTH >= M_DATA_WIDTH) ? 1 : 0;

  // bus width ratio
  localparam RATIO = (RATIO_TYPE) ? S_DATA_WIDTH/M_DATA_WIDTH : M_DATA_WIDTH/S_DATA_WIDTH;

  // atomic parameters
  localparam A_DATA_WIDTH = (RATIO_TYPE) ? M_DATA_WIDTH : S_DATA_WIDTH;
  localparam A_ADDRESS_WIDTH = (REDUCED_FIFO) ? (ADDRESS_WIDTH-$clog2(RATIO)) : ADDRESS_WIDTH;
  localparam A_ALMOST_FULL_THRESHOLD = (REDUCED_FIFO) ? ((ALMOST_FULL_THRESHOLD+RATIO-1)/RATIO) : ALMOST_FULL_THRESHOLD;
  localparam A_ALMOST_EMPTY_THRESHOLD = (REDUCED_FIFO) ? ((ALMOST_EMPTY_THRESHOLD+RATIO-1)/RATIO) : ALMOST_EMPTY_THRESHOLD;
  localparam A_TUSER_WIDTH = (TUSER_BITS_PER_BYTE) ? TUSER_WIDTH / RATIO : TUSER_WIDTH;

  // slave and master sequencers
  reg [$clog2(RATIO)-1:0] s_axis_counter;
  reg [$clog2(RATIO)-1:0] m_axis_counter;

  wire [RATIO-1:0]                 m_axis_ready_int_s;
  wire [RATIO-1:0]                 m_axis_valid_int_s;
  wire [RATIO*A_DATA_WIDTH-1:0]    m_axis_data_int_s;
  wire [RATIO*A_DATA_WIDTH/8-1:0]  m_axis_tkeep_int_s;
  wire [RATIO*A_DATA_WIDTH/8-1:0]  m_axis_tstrb_int_s;
  wire [RATIO-1:0]                 m_axis_tlast_int_s;
  wire [RATIO*A_TUSER_WIDTH-1:0]   m_axis_tuser_int_s;
  wire [RATIO*TID_WIDTH-1:0]       m_axis_tid_int_s;
  wire [RATIO*TDEST_WIDTH-1:0]     m_axis_tdest_int_s;
  wire [RATIO-1:0]                 m_axis_empty_int_s;
  wire [RATIO-1:0]                 m_axis_almost_empty_int_s;
  wire [RATIO-1:0]                 m_axis_full_int_s;
  wire [RATIO-1:0]                 m_axis_almost_full_int_s;
  wire [RATIO*A_ADDRESS_WIDTH-1:0] m_axis_level_int_s;

  wire [RATIO-1:0]                 s_axis_ready_int_s;
  wire [RATIO-1:0]                 s_axis_valid_int_s;
  wire [RATIO*A_DATA_WIDTH-1:0]    s_axis_data_int_s;
  wire [RATIO*A_DATA_WIDTH/8-1:0]  s_axis_tkeep_int_s;
  wire [RATIO*A_DATA_WIDTH/8-1:0]  s_axis_tstrb_int_s;
  wire [RATIO-1:0]                 s_axis_tlast_int_s;
  wire [RATIO*A_TUSER_WIDTH-1:0]   s_axis_tuser_int_s;
  wire [RATIO*TID_WIDTH-1:0]       s_axis_tid_int_s;
  wire [RATIO*TDEST_WIDTH-1:0]     s_axis_tdest_int_s;
  wire [RATIO-1:0]                 s_axis_empty_int_s;
  wire [RATIO-1:0]                 s_axis_almost_empty_int_s;
  wire [RATIO-1:0]                 s_axis_full_int_s;
  wire [RATIO-1:0]                 s_axis_almost_full_int_s;
  wire [RATIO*A_ADDRESS_WIDTH-1:0] s_axis_room_int_s;

  // instantiate the FIFOs
  genvar i;
  generate
    for (i=0; i<RATIO; i=i+1) begin: gen_fifo_instances
      util_axis_fifo #(
        .DATA_WIDTH(A_DATA_WIDTH),
        .ADDRESS_WIDTH(A_ADDRESS_WIDTH),
        .ASYNC_CLK(ASYNC_CLK),
        .M_AXIS_REGISTERED(M_AXIS_REGISTERED),
        .ALMOST_EMPTY_THRESHOLD(A_ALMOST_EMPTY_THRESHOLD),
        .ALMOST_FULL_THRESHOLD(A_ALMOST_FULL_THRESHOLD),
        .TLAST_EN(TLAST_EN),
        .TKEEP_EN(TKEEP_EN),
        .TSTRB_EN(TSTRB_EN),
        .TUSER_EN(TUSER_EN),
        .TID_EN(TID_EN),
        .TDEST_EN(TDEST_EN),
        .TUSER_WIDTH(A_TUSER_WIDTH),
        .TID_WIDTH(TID_WIDTH),
        .TDEST_WIDTH(TDEST_WIDTH)
      ) i_fifo (
        .m_axis_aclk(m_axis_aclk),
        .m_axis_aresetn(m_axis_aresetn),
        .m_axis_ready(m_axis_ready_int_s[i]),
        .m_axis_valid(m_axis_valid_int_s[i]),
        .m_axis_data(m_axis_data_int_s[A_DATA_WIDTH*i+:A_DATA_WIDTH]),
        .m_axis_tkeep(m_axis_tkeep_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8]),
        .m_axis_tstrb(m_axis_tstrb_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8]),
        .m_axis_tlast(m_axis_tlast_int_s[i]),
        .m_axis_tuser(m_axis_tuser_int_s[A_TUSER_WIDTH*i+:A_TUSER_WIDTH]),
        .m_axis_tid(m_axis_tid_int_s[TID_WIDTH*i+:TID_WIDTH]),
        .m_axis_tdest(m_axis_tdest_int_s[TDEST_WIDTH*i+:TDEST_WIDTH]),
        .m_axis_level(m_axis_level_int_s[A_ADDRESS_WIDTH*i+:A_ADDRESS_WIDTH]),
        .m_axis_empty(m_axis_empty_int_s[i]),
        .m_axis_almost_empty(m_axis_almost_empty_int_s[i]),
        .m_axis_full(m_axis_full_int_s[i]),
        .m_axis_almost_full(m_axis_almost_full_int_s[i]),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_ready(s_axis_ready_int_s[i]),
        .s_axis_valid(s_axis_valid_int_s[i]),
        .s_axis_data(s_axis_data_int_s[A_DATA_WIDTH*i+:A_DATA_WIDTH]),
        .s_axis_tkeep(s_axis_tkeep_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8]),
        .s_axis_tstrb(s_axis_tstrb_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8]),
        .s_axis_tlast(s_axis_tlast_int_s[i]),
        .s_axis_tuser(s_axis_tuser_int_s[A_TUSER_WIDTH*i+:A_TUSER_WIDTH]),
        .s_axis_tid(s_axis_tid_int_s[TID_WIDTH*i+:TID_WIDTH]),
        .s_axis_tdest(s_axis_tdest_int_s[TDEST_WIDTH*i+:TDEST_WIDTH]),
        .s_axis_room(s_axis_room_int_s[A_ADDRESS_WIDTH*i+:A_ADDRESS_WIDTH]),
        .s_axis_empty(s_axis_empty_int_s[i]),
        .s_axis_almost_empty(s_axis_almost_empty_int_s[i]),
        .s_axis_full(s_axis_full_int_s[i]),
        .s_axis_almost_full(s_axis_almost_full_int_s[i]));
    end
  endgenerate

  // write or slave logic
  generate

    if (RATIO_TYPE) begin : big_slave

      for (i=0; i<RATIO; i=i+1) begin: gen_tlast_big_slave
        assign s_axis_valid_int_s[i] = s_axis_valid & s_axis_ready;

        if (TLAST_EN) begin
          assign s_axis_tlast_int_s[i] = (i==RATIO-1) ? s_axis_tlast : 1'b0;
        end else begin
          assign s_axis_tlast_int_s[i] = 1'b1;
        end
      end

      if (TKEEP_EN) begin
        assign s_axis_tkeep_int_s = s_axis_tkeep;
      end else begin
        assign s_axis_tkeep_int_s = {S_DATA_WIDTH/8{1'b1}};
      end

      if (TSTRB_EN) begin
        assign s_axis_tstrb_int_s = s_axis_tstrb;
      end else begin
        if (TKEEP_EN) begin
          assign s_axis_tstrb_int_s = s_axis_tkeep;
        end else begin
          assign s_axis_tstrb_int_s = {S_DATA_WIDTH/8{1'b1}};
        end
      end

      if (TUSER_EN) begin
        if (TUSER_BITS_PER_BYTE) begin
          assign s_axis_tuser_int_s = s_axis_tuser;
        end else begin
          for (i=0; i<RATIO; i=i+1) begin
            assign s_axis_tuser_int_s[A_TUSER_WIDTH*i+:A_TUSER_WIDTH] = s_axis_tuser;
          end
        end
      end else begin
        assign s_axis_tuser_int_s = {RATIO*A_TUSER_WIDTH{1'b0}};
      end

      for (i=0; i<RATIO; i=i+1) begin
        if (TID_EN) begin
          assign s_axis_tid_int_s[TID_WIDTH*i+:TID_WIDTH] = s_axis_tid;
        end else begin
          assign s_axis_tid_int_s = {TID_WIDTH{1'b0}};
        end

        if (TDEST_EN) begin
          assign s_axis_tdest_int_s[TDEST_WIDTH*i+:TDEST_WIDTH] = s_axis_tdest;
        end else begin
          assign s_axis_tdest_int_s = {TDEST_WIDTH{1'b0}};
        end
      end

      assign s_axis_data_int_s = s_axis_data;

      // if every instance is ready, the interface is ready
      assign s_axis_ready = &(s_axis_ready_int_s);

      // if one of the atomic instance is full, s_axis_full is asserted
      assign s_axis_empty = |s_axis_empty_int_s;
      assign s_axis_almost_empty = |s_axis_almost_empty_int_s;
      assign s_axis_full = |s_axis_full_int_s;
      assign s_axis_almost_full = |s_axis_almost_full_int_s;
      // the FIFO has the same room as the atomic FIFO
      assign s_axis_room = s_axis_room_int_s[A_ADDRESS_WIDTH-1:0];

    end else begin : small_slave

      reg [RATIO-1:0] s_axis_valid_int_d = {RATIO{1'b0}};

      for (i=0; i<RATIO; i=i+1) begin
        assign s_axis_data_int_s[A_DATA_WIDTH*i+:A_DATA_WIDTH] = s_axis_data;

        if (TKEEP_EN) begin
          assign s_axis_tkeep_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8] = (s_axis_counter == i) ? s_axis_tkeep : {A_DATA_WIDTH/8{1'b0}};
        end else begin
          assign s_axis_tkeep_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8] = (s_axis_counter == i) ? {A_DATA_WIDTH/8{1'b1}} : {A_DATA_WIDTH/8{1'b0}};
        end

        if (TSTRB_EN) begin
          assign s_axis_tstrb_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8] = (s_axis_counter == i) ? s_axis_tstrb : {A_DATA_WIDTH/8{1'b0}};
        end else begin
          if (TKEEP_EN) begin
            assign s_axis_tstrb_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8] = (s_axis_counter == i) ? s_axis_tkeep : {A_DATA_WIDTH/8{1'b0}};
          end else begin
            assign s_axis_tstrb_int_s[A_DATA_WIDTH/8*i+:A_DATA_WIDTH/8] = (s_axis_counter == i) ? {A_DATA_WIDTH/8{1'b1}} : {A_DATA_WIDTH/8{1'b0}};
          end
        end

        if (TLAST_EN) begin
          assign s_axis_tlast_int_s[i] = (s_axis_counter == i) ? s_axis_tlast : 1'b0;
        end else begin
          assign s_axis_tlast_int_s[i] = 1'b1;
        end

        if (TUSER_EN) begin
          if (TUSER_BITS_PER_BYTE) begin
            assign s_axis_tuser_int_s[A_TUSER_WIDTH*i+:A_TUSER_WIDTH] = (s_axis_counter == i) ? s_axis_tuser[A_TUSER_WIDTH-1:0] : {A_TUSER_WIDTH{1'b0}};
          end else begin
            assign s_axis_tuser_int_s[A_TUSER_WIDTH*i+:A_TUSER_WIDTH] = (s_axis_counter == i) ? s_axis_tuser : {A_TUSER_WIDTH{1'b0}};
          end
        end else begin
          assign s_axis_tuser_int_s = {RATIO*A_TUSER_WIDTH{1'b0}};
        end

        if (TID_EN) begin
          assign s_axis_tid_int_s[TID_WIDTH*i+:TID_WIDTH] = (s_axis_counter == i) ? s_axis_tid : {TID_WIDTH{1'b0}};
        end else begin
          assign s_axis_tid_int_s = {TID_WIDTH{1'b0}};
        end

        if (TDEST_EN) begin
          assign s_axis_tdest_int_s[TDEST_WIDTH*i+:TDEST_WIDTH] = (s_axis_counter == i) ? s_axis_tdest : {TDEST_WIDTH{1'b0}};
        end else begin
          assign s_axis_tdest_int_s = {TDEST_WIDTH{1'b0}};
        end
      end

      // insert invalid writes (TKEEP==0) in case if the TLAST arrives before the RATIO
      // boundary
      if (TLAST_EN) begin
        always @(*) begin
          case ({s_axis_valid, s_axis_tlast})
            2'b00 : s_axis_valid_int_d = {RATIO{1'b0}};
            2'b01 : s_axis_valid_int_d = {RATIO{1'b0}};
            2'b10 : s_axis_valid_int_d = {{RATIO-1{1'b0}}, 1'b1} << s_axis_counter;
            2'b11 : s_axis_valid_int_d = {RATIO{&(s_axis_ready_int_s)}} << s_axis_counter;
          endcase
        end
      end else begin
        always @(*) begin
          if (s_axis_valid) begin
            s_axis_valid_int_d = {{RATIO-1{1'b0}}, 1'b1} << s_axis_counter;
          end else begin
            s_axis_valid_int_d = {RATIO{1'b0}};
          end
        end
      end
      assign s_axis_valid_int_s = s_axis_valid_int_d;

      // disable read enable if the TLAST arrives before address handshake occurs
      if (TLAST_EN) begin
        assign s_axis_ready = (s_axis_tlast) ? &(s_axis_ready_int_s) : s_axis_ready_int_s >> s_axis_counter;
      end else begin
        assign s_axis_ready = s_axis_ready_int_s >> s_axis_counter;
      end

      // FULL/ALMOST_FULL is driven by the current atomic instance
      assign s_axis_almost_empty = s_axis_almost_empty_int_s >> s_axis_counter;
      assign s_axis_almost_full = s_axis_almost_full_int_s >> s_axis_counter;
      // the FIFO has the same room as the last atomic instance
      // (NOTE: this is not the real room value, rather the value will be updated
      // after every RATIO number of writes)
      assign s_axis_empty = s_axis_empty_int_s[RATIO-1];
      assign s_axis_full = s_axis_full_int_s[RATIO-1];
      assign s_axis_room = {s_axis_room_int_s[A_ADDRESS_WIDTH*(RATIO-1)+:A_ADDRESS_WIDTH], {$clog2(RATIO){1'b1}}-s_axis_counter};

    end

  endgenerate

  // read or slave logic
  generate
    if (RATIO_TYPE) begin : small_master

      for (i=0; i<RATIO; i=i+1) begin: gen_ready_small_master
        assign m_axis_ready_int_s[i] = (m_axis_counter == i) ? m_axis_ready : 1'b0;
      end

      assign m_axis_data = m_axis_data_int_s >> (m_axis_counter*A_DATA_WIDTH) ;

      if (TKEEP_EN) begin
        assign m_axis_tkeep = m_axis_tkeep_int_s >> (m_axis_counter*A_DATA_WIDTH/8);
      end else begin
        assign m_axis_tkeep = {M_DATA_WIDTH/8{1'b1}};
      end

      if (TSTRB_EN) begin
        assign m_axis_tstrb = m_axis_tstrb_int_s >> (m_axis_counter*A_DATA_WIDTH/8);
      end else begin
        if (TKEEP_EN) begin
          assign m_axis_tstrb = m_axis_tkeep_int_s >> (m_axis_counter*A_DATA_WIDTH/8);
        end else begin
          assign m_axis_tstrb = {M_DATA_WIDTH/8{1'b1}};
        end
      end

      if (TUSER_EN) begin
        if (TUSER_BITS_PER_BYTE) begin
          assign m_axis_tuser[A_TUSER_WIDTH-1:0] = m_axis_tuser_int_s >> (m_axis_counter*A_TUSER_WIDTH);
        end else begin
          assign m_axis_tuser[A_TUSER_WIDTH-1:0] = m_axis_tuser_int_s >> (m_axis_counter*A_TUSER_WIDTH);
        end
      end else begin
        assign m_axis_tuser = {TUSER_WIDTH{1'b0}};
      end

      if (TID_EN) begin
        assign m_axis_tid = m_axis_tid_int_s >> (m_axis_counter*TID_WIDTH);
      end else begin
        assign m_axis_tid = {TID_WIDTH{1'b0}};
      end

      if (TDEST_EN) begin
        assign m_axis_tdest = m_axis_tdest_int_s >> (m_axis_counter*TDEST_WIDTH);
      end else begin
        assign m_axis_tdest = {TDEST_WIDTH{1'b0}};
      end

      // VALID/EMPTY/ALMOST_EMPTY is driven by the current atomic instance
      assign m_axis_valid = m_axis_valid_int_s >> m_axis_counter;

      if (TLAST_EN) begin
        assign m_axis_tlast = m_axis_tlast_int_s >> m_axis_counter;
      end else begin
        assign m_axis_tlast = 1'b1;
      end

      // the FIFO has the same level as the last atomic instance
      // (NOTE: this is not the real level value, rather the value will be updated
      // after every RATIO number of reads)
      assign m_axis_level = {m_axis_level_int_s[A_ADDRESS_WIDTH-1:0], m_axis_counter};
      assign m_axis_almost_empty = m_axis_almost_empty_int_s[RATIO-1];
      assign m_axis_empty = m_axis_empty_int_s[RATIO-1];
      assign m_axis_almost_full = m_axis_almost_full_int_s[RATIO-1];
      assign m_axis_full = m_axis_full_int_s[RATIO-1];

    end else begin : big_master

      for (i=0; i<RATIO; i=i+1) begin: gen_ready_big_master
        assign m_axis_ready_int_s[i] = m_axis_ready & (&m_axis_valid_int_s);
      end

      for (i=0; i<RATIO; i=i+1) begin
        if (TKEEP_EN) begin
          assign m_axis_tkeep[i*A_DATA_WIDTH/8+:A_DATA_WIDTH/8] = ((m_axis_tlast_int_s[i:0] == 0) ||
                                                                  (m_axis_tlast_int_s[i])) ?
                                                                  m_axis_tkeep_int_s[i*A_DATA_WIDTH/8+:A_DATA_WIDTH/8] :
                                                                  {(A_DATA_WIDTH/8){1'b0}};
        end else begin
          assign m_axis_tkeep[i*A_DATA_WIDTH/8+:A_DATA_WIDTH/8] = {A_DATA_WIDTH/8{1'b1}};
        end

        if (TSTRB_EN) begin
          assign m_axis_tstrb[i*A_DATA_WIDTH/8+:A_DATA_WIDTH/8] = ((m_axis_tlast_int_s[i:0] == 0) ||
                                                                  (m_axis_tlast_int_s[i])) ?
                                                                  m_axis_tstrb_int_s[i*A_DATA_WIDTH/8+:A_DATA_WIDTH/8] :
                                                                  {(A_DATA_WIDTH/8){1'b0}};
        end else begin
          if (TKEEP_EN) begin
            assign m_axis_tstrb[i*A_DATA_WIDTH/8+:A_DATA_WIDTH/8] = ((m_axis_tlast_int_s[i:0] == 0) ||
                                                                    (m_axis_tlast_int_s[i])) ?
                                                                    m_axis_tkeep_int_s[i*A_DATA_WIDTH/8+:A_DATA_WIDTH/8] :
                                                                    {(A_DATA_WIDTH/8){1'b0}};
          end else begin
            assign m_axis_tstrb[i*A_DATA_WIDTH/8+:A_DATA_WIDTH/8] = {A_DATA_WIDTH/8{1'b1}};
          end
        end

        if (TUSER_EN) begin
          if (TUSER_BITS_PER_BYTE) begin
            assign m_axis_tuser[i*A_TUSER_WIDTH+:A_TUSER_WIDTH] = ((m_axis_tlast_int_s[i:0] == 0) ||
                                                                (m_axis_tlast_int_s[i])) ?
                                                                m_axis_tuser_int_s[i*A_TUSER_WIDTH+:A_TUSER_WIDTH] :
                                                                {(A_TUSER_WIDTH){1'b0}};
          end else begin
            assign m_axis_tuser = m_axis_tuser_int_s[A_TUSER_WIDTH-1:0];
          end
        end else begin
          assign m_axis_tuser = {TUSER_WIDTH{1'b0}};
        end
      end

      if (TID_EN) begin
        assign m_axis_tid = m_axis_tid_int_s[TID_WIDTH-1:0];
      end else begin
        assign m_axis_tid = {TID_WIDTH{1'b0}};
      end

      if (TDEST_EN) begin
        assign m_axis_tdest = m_axis_tdest_int_s[TDEST_WIDTH-1:0];
      end else begin
        assign m_axis_tdest = {TDEST_WIDTH{1'b0}};
      end

      assign m_axis_data = m_axis_data_int_s;

      // if every instance has a valid data, the interface has valid data,
      // otherwise valid is asserted only if TLAST is asserted
      if (TLAST_EN) begin
        assign m_axis_valid = (|(m_axis_tlast_int_s & m_axis_valid_int_s)) ? 1'b1 : &m_axis_valid_int_s;
      end else begin
        assign m_axis_valid = &m_axis_valid_int_s;
      end

      // if one of the atomic instance is empty, m_axis_empty should be asserted
      assign m_axis_empty = |m_axis_empty_int_s;
      assign m_axis_almost_empty = |m_axis_almost_empty_int_s;
      assign m_axis_full = |m_axis_full_int_s;
      assign m_axis_almost_full = |m_axis_almost_full_int_s;
      // the FIFO has the same room as the atomic FIFO
      assign m_axis_level = m_axis_level_int_s[A_ADDRESS_WIDTH-1:0];

      if (TLAST_EN) begin
        assign m_axis_tlast = (m_axis_valid) ? |m_axis_tlast_int_s : 1'b0;
      end else begin
        assign m_axis_tlast = 1'b1;
      end

    end

  endgenerate

  // slave handshake counter

  generate
    if (RATIO == 1) begin
      initial begin
        s_axis_counter = 1'b1;
      end
    end else if (RATIO > 1) begin
      if (RATIO_TYPE) begin
        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            s_axis_counter <= 0;
          end else begin
            if (s_axis_ready && s_axis_valid) begin
              s_axis_counter <= s_axis_counter + 1'b1;
            end
          end
        end
      end else begin
        // in case of a small slave, after an active TLAST reset the counter
        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            s_axis_counter <= 0;
          end else begin
            if (s_axis_ready && s_axis_valid) begin
              if (s_axis_tlast && TLAST_EN) begin
                s_axis_counter <= 0;
              end else begin
                s_axis_counter <= s_axis_counter + 1'b1;
              end
            end
          end
        end
      end
    end
  endgenerate

  // master handshake sequencer

  generate
    if (RATIO == 1) begin
      initial begin
        m_axis_counter = 1'b0;
      end
    end else if (RATIO > 1) begin
      always @(posedge m_axis_aclk) begin
        if (!m_axis_aresetn) begin
          m_axis_counter <= 0;
        end else begin
          if (m_axis_ready && m_axis_valid) begin
            m_axis_counter <= m_axis_counter + 1'b1;
          end
        end
      end
    end
  endgenerate

endmodule
