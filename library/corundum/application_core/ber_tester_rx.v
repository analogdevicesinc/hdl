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

// Uses Ficonacci style LFSR

`timescale 1ns/100ps

module ber_tester_rx #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,

  // Ethernet interface configuration (direct, async)
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_RX_USER_WIDTH = 17
) (

  input  wire                                                      ber_test,
  input  wire                                                      reset_ber,

  output reg  [63:0]                                               total_bits,
  output reg  [63:0]                                               error_bits_total,
  output reg  [31:0]                                               out_of_sync_total,

  // Ethernet (direct MAC interface - lowest latency raw traffic)
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_rx_clk,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_rx_rst,

  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          s_axis_direct_rx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          s_axis_direct_rx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tvalid,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]       s_axis_direct_rx_tuser,

  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          m_axis_direct_rx_tdata,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          m_axis_direct_rx_tkeep,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tready,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tlast,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]       m_axis_direct_rx_tuser
);

  localparam DATA_WIDTH = IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH;
  localparam KEEP_WIDTH = IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH;
  localparam RX_USER_WIDTH = IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH;

  wire direct_rx_rstn;
  wire ber_test_cdc;

  assign direct_rx_rstn = ~direct_rx_rst;

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_ber_test (
    .in_bits(ber_test),
    .out_resetn(direct_rx_rstn),
    .out_clk(direct_rx_clk),
    .out_bits(ber_test_cdc)
  );

  reg ber_test_cdc_old;
  reg init_prbs;

  always @(posedge direct_rx_clk)
  begin
    if (!direct_rx_rstn) begin
      ber_test_cdc_old <= 1'b0;
      init_prbs <= 1'b0;
    end else begin
      ber_test_cdc_old <= ber_test_cdc;
      if (!ber_test_cdc_old && ber_test_cdc) begin
        init_prbs <= 1'b1;
      end else begin
        init_prbs <= 1'b0;
      end
    end
  end

  localparam PRBS_DATA_WIDTH = 64;
  localparam PRBS_POLYNOMIAL_WIDTH = 48;
  localparam PRBS_INST = DATA_WIDTH/PRBS_DATA_WIDTH;
  localparam DATA_WIDTH_2 = 2**$clog2(PRBS_INST);

  reg  [DATA_WIDTH-1:0]                                  prbs_data;
  reg                                                    prbs_valid;

  wire [PRBS_INST-1:0]                                   out_of_sync;
  reg  [$clog2(PRBS_INST+1)-1:0]                         out_of_sync_counter [DATA_WIDTH_2-2:0];

  wire [$clog2(PRBS_DATA_WIDTH+1)-1:0]                   error_bits [PRBS_INST-1:0];
  reg  [$clog2(PRBS_DATA_WIDTH+1)+$clog2(PRBS_INST)-1:0] bit_error_counter [DATA_WIDTH_2-2:0];

  genvar i;

  generate

    for (i = 0; i < PRBS_INST; i = i + 1) begin

      // check configuration
      initial begin
        if (PRBS_DATA_WIDTH < PRBS_POLYNOMIAL_WIDTH) begin
          $error("Data width: %0d < Polynomial width: %0d (instance %m)", PRBS_DATA_WIDTH, PRBS_POLYNOMIAL_WIDTH);
          $finish;
        end
      end

      prbs_mon #(
        .DATA_WIDTH(PRBS_DATA_WIDTH),
        .POLYNOMIAL_WIDTH(PRBS_POLYNOMIAL_WIDTH),
        .OUT_OF_SYNC_THRESHOLD(16)
      ) prbs_mon_inst (
        .clk(direct_rx_clk),
        .rstn(direct_rx_rstn),
        .init(init_prbs),
        .input_data(prbs_data[i*PRBS_DATA_WIDTH +: PRBS_DATA_WIDTH]),
        .input_valid(prbs_valid),
        .error_sample(),
        .error_bits(error_bits[i]),
        .out_of_sync(out_of_sync[i]),
        .out_of_sync_total_error_bit(),
        .polynomial(48'hC00000000000),
        .inverted(1'b0)
      );

    end

    // count the number of error bits
    integer j, k;
    integer new_block, last_block;

    always @(posedge direct_rx_clk)
    begin
      if (direct_rx_rst) begin
        for (j = 0; j < DATA_WIDTH_2-1; j = j + 1) begin
          out_of_sync_counter[j] <= {$clog2(PRBS_INST+1){1'b0}};
          bit_error_counter[j] <= {$clog2(PRBS_DATA_WIDTH+PRBS_INST+1){1'b0}};
        end
      end else begin
        if (!init_prbs) begin
          for (j = 0; j < DATA_WIDTH_2-1; j = j + 1) begin
            out_of_sync_counter[j] <= {$clog2(PRBS_INST+1){1'b0}};
            bit_error_counter[j] <= {$clog2(PRBS_DATA_WIDTH+PRBS_INST+1){1'b0}};
          end
        end else begin
          if (prbs_valid) begin
            for (k = 0; k < DATA_WIDTH_2/2; k = k + 1) begin
              out_of_sync_counter[k] <= out_of_sync[k*2] + out_of_sync[k*2 + 1];
              bit_error_counter[k] <= error_bits[k*2] + error_bits[k*2 + 1];
            end
            last_block = DATA_WIDTH_2/2;

            for (j = 1; j < $clog2(DATA_WIDTH_2); j = j + 1) begin
              new_block = DATA_WIDTH_2/(2**(j+1));
              for (k = 0; k < new_block; k = k + 1) begin
                out_of_sync_counter[last_block + k] <= out_of_sync_counter[last_block - k*2 - 1] + out_of_sync_counter[last_block - k*2 - 2];
                bit_error_counter[last_block + k] <= bit_error_counter[last_block - k*2 - 1] + bit_error_counter[last_block - k*2 - 2];
              end
              last_block = last_block + new_block;
            end
          end
        end
      end
    end

  endgenerate

  wire reset_ber_cdc;

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_reset_ber (
    .in_bits(reset_ber),
    .out_resetn(direct_rx_rstn),
    .out_clk(direct_rx_clk),
    .out_bits(reset_ber_cdc)
  );

  always @(posedge direct_rx_clk)
  begin
    if (direct_rx_rst) begin
      total_bits <= {64{1'b0}};
      out_of_sync_total <= {32{1'b0}};
      error_bits_total <= {64{1'b0}};
    end else begin
      if (reset_ber_cdc) begin
        total_bits <= {64{1'b0}};
        out_of_sync_total <= {32{1'b0}};
        error_bits_total <= {64{1'b0}};
      end else begin
        if (prbs_valid) begin
          total_bits <= total_bits + DATA_WIDTH;
          out_of_sync_total <= out_of_sync_total + out_of_sync_counter[DATA_WIDTH_2-2];
          error_bits_total <= error_bits_total + bit_error_counter[DATA_WIDTH_2-2];
        end
      end
    end
  end

  // Datapath switch
  reg datapath_switch; // 0 - OS
                       // 1 - BER

  always @(posedge direct_rx_clk)
  begin
    if (direct_rx_rst) begin
      datapath_switch <= 1'b0;
    end else begin
      if (ber_test_cdc && (!s_axis_direct_rx_tvalid || (s_axis_direct_rx_tvalid && s_axis_direct_rx_tready && s_axis_direct_rx_tlast))) begin
        datapath_switch <= 1'b1;
      end else if (!ber_test_cdc) begin
        datapath_switch <= 1'b0;
      end
    end
  end

  always @(*)
  begin
    if (!datapath_switch) begin
      m_axis_direct_rx_tdata = s_axis_direct_rx_tdata;
      m_axis_direct_rx_tkeep = s_axis_direct_rx_tkeep;
      m_axis_direct_rx_tvalid = s_axis_direct_rx_tvalid;
      m_axis_direct_rx_tlast = s_axis_direct_rx_tlast;
      m_axis_direct_rx_tuser = s_axis_direct_rx_tuser;

      s_axis_direct_rx_tready = m_axis_direct_rx_tready;

      prbs_valid = 1'b0;
      prbs_data = {DATA_WIDTH{1'b0}};
    end else begin
      m_axis_direct_rx_tdata = {DATA_WIDTH{1'b0}};
      m_axis_direct_rx_tkeep = {KEEP_WIDTH{1'b0}};
      m_axis_direct_rx_tvalid = 1'b0;
      m_axis_direct_rx_tlast = 1'b0;
      m_axis_direct_rx_tuser = {RX_USER_WIDTH{1'b0}};

      s_axis_direct_rx_tready = 1'b1;

      prbs_valid = s_axis_direct_rx_tvalid;
      prbs_data = s_axis_direct_rx_tdata;
    end
  end

endmodule
