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
  parameter ADDRESS_WIDTH = 5,
  parameter M_DATA_WIDTH = 128,
  parameter M_AXIS_REGISTERED = 1,
  parameter ALMOST_EMPTY_THRESHOLD = 4,
  parameter ALMOST_FULL_THRESHOLD = 4,
  parameter TLAST_EN = 0,
  parameter TKEEP_EN = 0,
  parameter REDUCED_FIFO = 1
) (
  input m_axis_aclk,
  input m_axis_aresetn,
  input m_axis_ready,
  output m_axis_valid,
  output [M_DATA_WIDTH-1:0] m_axis_data,
  output [M_DATA_WIDTH/8-1:0] m_axis_tkeep,
  output m_axis_tlast,
  output m_axis_empty,
  output m_axis_almost_empty,
  output [ADDRESS_WIDTH-1:0] m_axis_level,

  input s_axis_aclk,
  input s_axis_aresetn,
  output s_axis_ready,
  input s_axis_valid,
  input [S_DATA_WIDTH-1:0] s_axis_data,
  input [S_DATA_WIDTH/8-1:0] s_axis_tkeep,
  input s_axis_tlast,
  output s_axis_full,
  output s_axis_almost_full,
  output [ADDRESS_WIDTH-1:0] s_axis_room
);

  // define which interface has a wider bus
  localparam RATIO_TYPE = (S_DATA_WIDTH >= M_DATA_WIDTH) ? 1 : 0;

  // bus width ratio
  localparam RATIO = (RATIO_TYPE) ? S_DATA_WIDTH/M_DATA_WIDTH : M_DATA_WIDTH/S_DATA_WIDTH;

  // atomic parameters
  localparam A_WIDTH = (RATIO_TYPE) ? M_DATA_WIDTH : S_DATA_WIDTH;
  localparam A_ADDRESS = (REDUCED_FIFO) ? (ADDRESS_WIDTH-$clog2(RATIO)) : ADDRESS_WIDTH;
  localparam A_ALMOST_FULL_THRESHOLD = (REDUCED_FIFO) ? ((ALMOST_FULL_THRESHOLD+RATIO-1)/RATIO) : ALMOST_FULL_THRESHOLD;
  localparam A_ALMOST_EMPTY_THRESHOLD = (REDUCED_FIFO) ? ((ALMOST_EMPTY_THRESHOLD+RATIO-1)/RATIO) : ALMOST_EMPTY_THRESHOLD;

  // slave and master sequencers
  reg [$clog2(RATIO)-1:0] s_axis_counter;
  reg [$clog2(RATIO)-1:0] m_axis_counter;

  wire [RATIO-1:0] m_axis_ready_int_s;
  wire [RATIO-1:0] m_axis_valid_int_s;
  wire [RATIO*A_WIDTH-1:0] m_axis_data_int_s;
  wire [RATIO*A_WIDTH/8-1:0] m_axis_tkeep_int_s;
  wire [RATIO-1:0] m_axis_tlast_int_s;
  wire [RATIO-1:0] m_axis_empty_int_s;
  wire [RATIO-1:0] m_axis_almost_empty_int_s;
  wire [RATIO*A_ADDRESS-1:0] m_axis_level_int_s;

  wire [RATIO-1:0] s_axis_ready_int_s;
  wire [RATIO-1:0] s_axis_valid_int_s;
  wire [RATIO*A_WIDTH-1:0] s_axis_data_int_s;
  wire [RATIO*A_WIDTH/8-1:0] s_axis_tkeep_int_s;
  wire [RATIO-1:0] s_axis_tlast_int_s;
  wire [RATIO-1:0] s_axis_full_int_s;
  wire [RATIO-1:0] s_axis_almost_full_int_s;
  wire [RATIO*A_ADDRESS-1:0] s_axis_room_int_s;

  wire m_axis_valid_int;

  // instantiate the FIFOs
  genvar i;
  generate
    for (i=0; i<RATIO; i=i+1) begin: gen_fifo_instances
      util_axis_fifo #(
        .DATA_WIDTH (A_WIDTH),
        .ADDRESS_WIDTH (A_ADDRESS),
        .ASYNC_CLK (ASYNC_CLK),
        .M_AXIS_REGISTERED (M_AXIS_REGISTERED),
        .ALMOST_EMPTY_THRESHOLD (A_ALMOST_EMPTY_THRESHOLD),
        .ALMOST_FULL_THRESHOLD (A_ALMOST_FULL_THRESHOLD),
        .TKEEP_EN (TKEEP_EN),
        .TLAST_EN (TLAST_EN),
        .REMOVE_NULL_BEAT_EN(0)
      ) i_fifo (
        .m_axis_aclk    (m_axis_aclk),
        .m_axis_aresetn (m_axis_aresetn),
        .m_axis_ready   (m_axis_ready_int_s[i]),
        .m_axis_valid   (m_axis_valid_int_s[i]),
        .m_axis_data    (m_axis_data_int_s[A_WIDTH*i+:A_WIDTH]),
        .m_axis_tlast   (m_axis_tlast_int_s[i]),
        .m_axis_tkeep   (m_axis_tkeep_int_s[A_WIDTH/8*i+:A_WIDTH/8]),
        .m_axis_level   (m_axis_level_int_s[A_ADDRESS*i+:A_ADDRESS]),
        .m_axis_empty   (m_axis_empty_int_s[i]),
        .m_axis_almost_empty (m_axis_almost_empty_int_s[i]),
        .s_axis_aclk    (s_axis_aclk),
        .s_axis_aresetn (s_axis_aresetn),
        .s_axis_ready   (s_axis_ready_int_s[i]),
        .s_axis_valid   (s_axis_valid_int_s[i]),
        .s_axis_data    (s_axis_data_int_s[A_WIDTH*i+:A_WIDTH]),
        .s_axis_tkeep   (s_axis_tkeep_int_s[A_WIDTH/8*i+:A_WIDTH/8]),
        .s_axis_tlast   (s_axis_tlast_int_s[i]),
        .s_axis_room    (s_axis_room_int_s[A_ADDRESS*i+:A_ADDRESS]),
        .s_axis_full    (s_axis_full_int_s[i]),
        .s_axis_almost_full (s_axis_almost_full_int_s[i]));
    end
  endgenerate

  // write or slave logic
  generate

    if (RATIO_TYPE) begin : big_slave

      for (i=0; i<RATIO; i=i+1) begin: gen_tlast_big_slave
        assign s_axis_valid_int_s[i] = s_axis_valid & s_axis_ready;

        if (TKEEP_EN) begin

          assign s_axis_tlast_int_s[i] = (i==RATIO-1) ? ((|s_axis_tkeep[M_DATA_WIDTH/8*i+:M_DATA_WIDTH/8]) ? s_axis_tlast : 1'b0) :
            (((|s_axis_tkeep[M_DATA_WIDTH/8*i+:M_DATA_WIDTH/8]) & (~(|s_axis_tkeep[M_DATA_WIDTH/8*(i+1)+:M_DATA_WIDTH/8]))) ? s_axis_tlast : 1'b0);

        end else begin

          assign s_axis_tlast_int_s[i] = (i==RATIO-1) ? s_axis_tlast : 1'b0;

        end
      end

      assign s_axis_tkeep_int_s = s_axis_tkeep;
      assign s_axis_data_int_s = s_axis_data;
      // if every instance is ready, the interface is ready
      assign s_axis_ready = &(s_axis_ready_int_s);
      // if one of the atomic instance is full, s_axis_full is asserted
      assign s_axis_full = |s_axis_full_int_s;
      assign s_axis_almost_full = |s_axis_almost_full_int_s;
      // the FIFO has the same room as the atomic FIFO
      assign s_axis_room = s_axis_room_int_s[A_ADDRESS-1:0];

    end else begin : small_slave

      reg [RATIO-1:0] s_axis_valid_int_d = {RATIO{1'b0}};

      for (i=0; i<RATIO; i=i+1) begin: gen_tlast_small_slave
        assign s_axis_data_int_s[A_WIDTH*i+:A_WIDTH] = s_axis_data;
        assign s_axis_tkeep_int_s[A_WIDTH/8*i+:A_WIDTH/8] = (s_axis_counter == i) ? s_axis_tkeep : {A_WIDTH/8{1'b0}};
        assign s_axis_tlast_int_s[i] = (s_axis_counter == i) ? s_axis_tlast : 1'b0;
      end

      // insert invalid writes (TKEEP==0) in case if the TLAST arrives before the RATIO
      // boundary
      always @(*) begin
        case ({s_axis_valid, s_axis_tlast})
          2'b00 : s_axis_valid_int_d = {RATIO{1'b0}};
          2'b01 : s_axis_valid_int_d = {RATIO{1'b0}};
          2'b10 : s_axis_valid_int_d = {{RATIO-1{1'b0}}, 1'b1} << s_axis_counter;
          2'b11 : s_axis_valid_int_d = {RATIO{&(s_axis_ready_int_s)}} << s_axis_counter;
        endcase
      end
      assign s_axis_valid_int_s = s_axis_valid_int_d;

      // disable read enable if the TLAST arrives before address handshake occurs
      assign s_axis_ready = (s_axis_tlast) ? &(s_axis_ready_int_s) : s_axis_ready_int_s >> s_axis_counter;

      // FULL/ALMOST_FULL is driven by the current atomic instance
      assign s_axis_almost_full = s_axis_almost_full_int_s >> s_axis_counter;

      // the FIFO has the same room as the last atomic instance
      // (NOTE: this is not the real room value, rather the value will be updated
      // after every RATIO number of writes)
      assign s_axis_full = s_axis_full_int_s[RATIO-1];
      assign s_axis_room = {s_axis_room_int_s[A_ADDRESS*(RATIO-1)+:A_ADDRESS], {$clog2(RATIO){1'b1}}};

    end

  endgenerate

  // read or slave logic
  generate
    if (RATIO_TYPE) begin : small_master

      for (i=0; i<RATIO; i=i+1) begin: gen_ready_small_master
        assign m_axis_ready_int_s[i] = (m_axis_counter == i) ? m_axis_ready : 1'b0;
      end

      assign m_axis_data = m_axis_data_int_s >> (m_axis_counter*A_WIDTH) ;
      assign m_axis_tkeep = m_axis_tkeep_int_s >> (m_axis_counter*A_WIDTH/8) ;

      // VALID/EMPTY/ALMOST_EMPTY is driven by the current atomic instance
      assign m_axis_valid_int = m_axis_valid_int_s >> m_axis_counter;
      assign m_axis_valid = m_axis_valid_int & (|m_axis_tkeep);
      assign m_axis_tlast = m_axis_tlast_int_s >> m_axis_counter;

      // the FIFO has the same level as the last atomic instance
      // (NOTE: this is not the real level value, rather the value will be updated
      // after every RATIO number of reads)
      assign m_axis_level = {m_axis_level_int_s[A_ADDRESS-1:0], {$clog2(RATIO){1'b0}}};
      assign m_axis_almost_empty = m_axis_almost_empty_int_s[RATIO-1];
      assign m_axis_empty = m_axis_empty_int_s[RATIO-1];

    end else begin : big_master

      for (i=0; i<RATIO; i=i+1) begin: gen_ready_big_master
        assign m_axis_ready_int_s[i] = m_axis_ready & (&m_axis_valid_int_s);
      end

      for (i=0; i<RATIO; i=i+1) begin: gen_tkeep_big_master
        assign m_axis_tkeep[i*A_WIDTH/8+:A_WIDTH/8] = ((m_axis_tlast_int_s[i:0] == 0) ||
                                                      (m_axis_tlast_int_s[i])) ?
                                                    m_axis_tkeep_int_s[i*A_WIDTH/8+:A_WIDTH/8] :
                                                    {(A_WIDTH/8){1'b0}};
      end

      assign m_axis_data = m_axis_data_int_s;
      // if every instance has a valid data, the interface has valid data,
      // otherwise valid is asserted only if TLAST is asserted
      // assign m_axis_valid_int = (|(m_axis_tlast_int_s & m_axis_valid_int_s)) ? |m_axis_valid_int_s : &m_axis_valid_int_s;
      if (TLAST_EN) begin
        assign m_axis_valid_int = (|(m_axis_tlast_int_s & m_axis_valid_int_s)) ? |m_axis_valid_int_s : &m_axis_valid_int_s;
      end else begin
        assign m_axis_valid_int = &m_axis_valid_int_s;
      end
      assign m_axis_valid = m_axis_valid_int;
      // if one of the atomic instance is empty, m_axis_empty should be asserted
      assign m_axis_empty = |m_axis_empty_int_s;
      assign m_axis_almost_empty = |m_axis_almost_empty_int_s;

      // the FIFO has the same room as the atomic FIFO
      assign m_axis_level = m_axis_level_int_s[A_ADDRESS-1:0];

      assign m_axis_tlast = (m_axis_valid) ? |m_axis_tlast_int_s : 1'b0;

    end

  endgenerate

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
              if (s_axis_tlast) begin
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
          if (m_axis_ready && m_axis_valid_int) begin
            m_axis_counter <= m_axis_counter + 1'b1;
          end
        end
      end
    end
  endgenerate

endmodule
