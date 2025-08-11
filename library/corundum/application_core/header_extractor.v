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

`include "macro_definitions.vh"

module header_extractor #(

  // Ethernet interface configuration (direct, sync)
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_RX_USER_WIDTH = 17,

  parameter HEADER_WIDTH = 336
) (

  input  wire                            clk,
  input  wire                            rstn,

  // Input stream
  input  wire [AXIS_DATA_WIDTH-1:0]     input_axis_tdata,
  input  wire [AXIS_KEEP_WIDTH-1:0]     input_axis_tkeep,
  input  wire                           input_axis_tvalid,
  output wire                           input_axis_tready,
  input  wire                           input_axis_tlast,
  input  wire [AXIS_RX_USER_WIDTH-1:0]  input_axis_tuser,

  // OS interface
  output wire [AXIS_DATA_WIDTH-1:0]     os_axis_tdata,
  output wire [AXIS_KEEP_WIDTH-1:0]     os_axis_tkeep,
  output wire                           os_axis_tvalid,
  input  wire                           os_axis_tready,
  output wire                           os_axis_tlast,
  output wire [AXIS_RX_USER_WIDTH-1:0]  os_axis_tuser,

  // Raw output data stream
  output wire [AXIS_DATA_WIDTH-1:0]     raw_axis_tdata,
  output wire [AXIS_KEEP_WIDTH-1:0]     raw_axis_tkeep,
  output wire                           raw_axis_tvalid,
  input  wire                           raw_axis_tready,
  output wire                           raw_axis_tlast,
  output wire [AXIS_RX_USER_WIDTH-1:0]  raw_axis_tuser,

  input  wire datapath_switch,
  input  wire datapath_switch_valid,

  input  wire header_validated,
  input  wire header_validated_valid
);

  localparam HEADER_PARTS = HEADER_WIDTH/AXIS_DATA_WIDTH+8;

  localparam SPLIT_PAYLOAD = (HEADER_WIDTH % AXIS_DATA_WIDTH) ? 1 : 0;

  localparam BYPASS_WIDTH = (HEADER_WIDTH < AXIS_DATA_WIDTH) ? HEADER_WIDTH :
    ((SPLIT_PAYLOAD) ? HEADER_WIDTH % AXIS_DATA_WIDTH : AXIS_DATA_WIDTH);

  localparam TEMP_WIDTH = AXIS_DATA_WIDTH-BYPASS_WIDTH;

  ////----------------------------------------Input buffer-----------------//
  //////////////////////////////////////////////////

  wire [AXIS_DATA_WIDTH-1:0]    os_buffered_axis_tdata;
  wire [AXIS_KEEP_WIDTH-1:0]    os_buffered_axis_tkeep;
  wire                          os_buffered_axis_tvalid;
  wire                          os_buffered_axis_tready;
  wire                          os_buffered_axis_tlast;
  wire [AXIS_RX_USER_WIDTH-1:0] os_buffered_axis_tuser;

  reg                           os_buffered_axis_tvalid_gated;
  reg                           os_buffered_axis_tready_gated;

  reg [AXIS_DATA_WIDTH-1:0]    raw_axis_tdata_first;
  reg [AXIS_KEEP_WIDTH-1:0]    raw_axis_tkeep_first;
  reg                          raw_axis_tvalid_first;
  reg                          raw_axis_tlast_first;
  reg [AXIS_RX_USER_WIDTH-1:0] raw_axis_tuser_first;

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH+AXIS_KEEP_WIDTH+1+AXIS_RX_USER_WIDTH),
    .ADDRESS_WIDTH($clog2(HEADER_PARTS)),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(),
    .ALMOST_FULL_THRESHOLD(),
    .TLAST_EN(0),
    .TKEEP_EN(0),
    .REMOVE_NULL_BEAT_EN(0)
  ) input_os_data_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(os_buffered_axis_tready_gated),
    .m_axis_valid(os_buffered_axis_tvalid),
    .m_axis_data({os_buffered_axis_tdata, os_buffered_axis_tkeep, os_buffered_axis_tlast, os_buffered_axis_tuser}),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_full(),
    .m_axis_almost_full(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(input_axis_tready),
    .s_axis_valid(input_axis_tvalid),
    .s_axis_data({input_axis_tdata, input_axis_tkeep, input_axis_tlast, input_axis_tuser}),
    .s_axis_tkeep('d0),
    .s_axis_tlast(1'b0),
    .s_axis_room(),
    .s_axis_empty(),
    .s_axis_almost_empty(),
    .s_axis_full(),
    .s_axis_almost_full());

  always @(posedge clk)
  begin
    if (!rstn) begin
      raw_axis_tdata_first <= {AXIS_DATA_WIDTH{1'b0}};
      raw_axis_tkeep_first <= {AXIS_KEEP_WIDTH{1'b0}};
      raw_axis_tvalid_first <= 1'b0;
      raw_axis_tlast_first <= 1'b0;
      raw_axis_tuser_first <= {AXIS_RX_USER_WIDTH{1'b0}};
    end else begin
      raw_axis_tdata_first <= input_axis_tdata;
      raw_axis_tkeep_first <= input_axis_tkeep;
      raw_axis_tvalid_first <= input_axis_tvalid;
      raw_axis_tlast_first <= input_axis_tlast;
      raw_axis_tuser_first <= input_axis_tuser;
    end
  end

  ////----------------------------------------Datapath switch/header extraction-----------------//
  //////////////////////////////////////////////////

  reg [BYPASS_WIDTH-1:0]   bypass_axis_tdata;
  reg [BYPASS_WIDTH/8-1:0] bypass_axis_tkeep;
  // reg [BYPASS_WIDTH-1:0] bypass_axis_tuser;

  always @(*)
  begin
    bypass_axis_tdata = raw_axis_tdata_first[BYPASS_WIDTH-1:0];
    bypass_axis_tkeep = raw_axis_tkeep_first[BYPASS_WIDTH/8-1:0];
    // bypass_axis_tuser = raw_axis_tuser_first[BYPASS_WIDTH/8-1:0];
  end

  reg [AXIS_DATA_WIDTH-1:0]    buffer_axis_tdata;
  reg [AXIS_KEEP_WIDTH-1:0]    buffer_axis_tkeep;
  reg                          buffer_axis_tvalid;
  reg                          buffer_axis_tlast;
  reg [AXIS_RX_USER_WIDTH-1:0] buffer_axis_tuser;

  reg datapath_switch_d;
  reg datapath_switch_valid_d;

  reg header_validated_d;
  reg header_validated_valid_d;

  always @(posedge clk)
  begin
    if (!rstn) begin
      datapath_switch_d <= 1'b0;
      datapath_switch_valid_d <= 1'b0;
    end else begin
      if (!datapath_switch_valid_d) begin
        datapath_switch_d <= datapath_switch;
        datapath_switch_valid_d <= datapath_switch_valid;
      end else begin
        if (os_buffered_axis_tready_gated && os_buffered_axis_tvalid && os_buffered_axis_tlast) begin
          datapath_switch_d <= datapath_switch;
          datapath_switch_valid_d <= datapath_switch_valid;
        end
      end
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      os_buffered_axis_tvalid_gated <= 1'b0;
      os_buffered_axis_tready_gated <= 1'b0;
    end else begin
      // don't drive anything by default
      os_buffered_axis_tvalid_gated <= 1'b0;
      os_buffered_axis_tready_gated <= 1'b0;

      if (datapath_switch_valid_d) begin
        if (!datapath_switch_d) begin
          os_buffered_axis_tvalid_gated <= os_buffered_axis_tvalid;
          os_buffered_axis_tready_gated <= os_buffered_axis_tready;
        end else begin
          os_buffered_axis_tready_gated <= 1'b1;
        end
      end
    end
  end

  generate

    if (SPLIT_PAYLOAD) begin

      reg                    temp_axis_tvalid;
      reg [TEMP_WIDTH-1:0]   temp_axis_tdata;
      reg [TEMP_WIDTH/8-1:0] temp_axis_tkeep;
      // reg [AXIS_RX_USER_WIDTH-BYPASS_WIDTH/8-1:0] temp_axis_tuser;

      always @(posedge clk)
      begin
        temp_axis_tvalid <= raw_axis_tvalid_first;
        temp_axis_tdata <= raw_axis_tdata_first[AXIS_DATA_WIDTH-1:BYPASS_WIDTH];
        temp_axis_tkeep <= raw_axis_tkeep_first[AXIS_DATA_WIDTH/8-1:BYPASS_WIDTH/8];
        // temp_axis_tuser <= raw_axis_tuser_first[AXIS_RX_USER_WIDTH/8-1:BYPASS_WIDTH/8];
      end

      reg no_remainder;
      reg no_remainder_d;

      always @(*)
      begin
        if (bypass_axis_tkeep == {BYPASS_WIDTH/8{1'b0}}) begin
          no_remainder = 1'b1;
        end else begin
          no_remainder = 1'b0;
        end
      end

      always @(posedge clk)
      begin
        if (raw_axis_tlast_first) begin
          no_remainder_d <= no_remainder;
        end else if (buffer_axis_tlast) begin
          no_remainder_d <= 1'b0;
        end
      end

      always @(posedge clk)
      begin
        if (!rstn) begin
          buffer_axis_tdata <= {AXIS_DATA_WIDTH{1'b0}};
          buffer_axis_tkeep <= {AXIS_KEEP_WIDTH{1'b0}};
          buffer_axis_tvalid <= 1'b0;
          buffer_axis_tlast <= 1'b0;
          // buffer_axis_tuser <= {AXIS_KEEP_WIDTH{1'b0}};
        end else begin
          // don't drive anything by default
          buffer_axis_tdata <= {AXIS_DATA_WIDTH{1'b0}};
          buffer_axis_tkeep <= {AXIS_KEEP_WIDTH{1'b0}};
          buffer_axis_tvalid <= 1'b0;
          buffer_axis_tlast <= 1'b0;
          // buffer_axis_tuser <= {AXIS_KEEP_WIDTH{1'b0}};

          if (datapath_switch_valid) begin
            if (datapath_switch) begin
              if (header_validated && header_validated_valid) begin
                // header extraction
                buffer_axis_tdata <= {bypass_axis_tdata, temp_axis_tdata};
                buffer_axis_tkeep <= {bypass_axis_tkeep, temp_axis_tkeep};
                buffer_axis_tvalid <= temp_axis_tvalid && !buffer_axis_tlast && !no_remainder_d;
                buffer_axis_tlast <= raw_axis_tlast_first && !no_remainder || no_remainder_d;
                // buffer_axis_tuser <= {bypass_axis_tuser, temp_axis_tuser};
              end
            end
          end
        end
      end

    end else begin

      always @(posedge clk)
      begin
        if (!rstn) begin
          buffer_axis_tdata <= {AXIS_DATA_WIDTH{1'b0}};
          buffer_axis_tkeep <= {AXIS_KEEP_WIDTH{1'b0}};
          buffer_axis_tvalid <= 1'b0;
          buffer_axis_tlast <= 1'b0;
          // buffer_axis_tuser <= {AXIS_KEEP_WIDTH{1'b0}};
        end else begin
          // don't drive anything by default
          buffer_axis_tdata <= {AXIS_DATA_WIDTH{1'b0}};
          buffer_axis_tkeep <= {AXIS_KEEP_WIDTH{1'b0}};
          buffer_axis_tvalid <= 1'b0;
          buffer_axis_tlast <= 1'b0;
          // buffer_axis_tuser <= {AXIS_KEEP_WIDTH{1'b0}};

          if (datapath_switch_valid) begin
            if (datapath_switch) begin
              if (header_validated && header_validated_valid) begin
                // header extraction
                buffer_axis_tdata <= bypass_axis_tdata;
                buffer_axis_tkeep <= bypass_axis_tkeep;
                buffer_axis_tvalid <= raw_axis_tvalid_first;
                buffer_axis_tlast <= raw_axis_tlast_first;
                // buffer_axis_tuser <= bypass_axis_tuser;
              end
            end
          end
        end
      end

    end

  endgenerate

  ////----------------------------------------Output Buffer FIFO----//
  //////////////////////////////////////////////////

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH+AXIS_KEEP_WIDTH+1+AXIS_RX_USER_WIDTH),
    .ADDRESS_WIDTH(2),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(),
    .ALMOST_FULL_THRESHOLD(),
    .TLAST_EN(0),
    .TKEEP_EN(0),
    .REMOVE_NULL_BEAT_EN(0)
  ) of_data_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(os_axis_tready),
    .m_axis_valid(os_axis_tvalid),
    .m_axis_data({os_axis_tdata, os_axis_tkeep, os_axis_tlast, os_axis_tuser}),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_full(),
    .m_axis_almost_full(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(os_buffered_axis_tready),
    .s_axis_valid(os_buffered_axis_tvalid_gated),
    .s_axis_data({os_buffered_axis_tdata, os_buffered_axis_tkeep, os_buffered_axis_tlast, os_buffered_axis_tuser}),
    .s_axis_tkeep('d0),
    .s_axis_tlast(1'b0),
    .s_axis_room(),
    .s_axis_empty(),
    .s_axis_almost_empty(),
    .s_axis_full(),
    .s_axis_almost_full());

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH(2),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(),
    .ALMOST_FULL_THRESHOLD(),
    .TLAST_EN(1),
    .TKEEP_EN(1),
    .REMOVE_NULL_BEAT_EN(0)
  ) raw_data_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(raw_axis_tready),
    .m_axis_valid(raw_axis_tvalid),
    .m_axis_data(raw_axis_tdata),
    .m_axis_tkeep(raw_axis_tkeep),
    .m_axis_tlast(raw_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_full(),
    .m_axis_almost_full(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(),
    .s_axis_valid(buffer_axis_tvalid),
    .s_axis_data(buffer_axis_tdata),
    .s_axis_tkeep(buffer_axis_tkeep),
    .s_axis_tlast(buffer_axis_tlast),
    .s_axis_room(),
    .s_axis_empty(),
    .s_axis_almost_empty(),
    .s_axis_full(),
    .s_axis_almost_full());

endmodule
