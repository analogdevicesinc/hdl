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

module application_rx #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,

  // Ethernet interface configuration (direct, sync)
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_RX_USER_WIDTH = 17,

  // Input stream
  parameter CHANNELS = 4,
  parameter SAMPLES_PER_CHANNEL = 16,
  parameter SAMPLE_DATA_WIDTH = 16
) (

  input  wire                            clk,
  input  wire                            rstn,

  // Ethernet (synchronous MAC interface - low latency raw traffic)
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     s_axis_sync_rx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     s_axis_sync_rx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_rx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_rx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_rx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]  s_axis_sync_rx_tuser,

  output wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     m_axis_sync_rx_tdata,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     m_axis_sync_rx_tkeep,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tready,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tlast,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]  m_axis_sync_rx_tuser,

  input  wire                            output_clk,
  input  wire                            output_rstn,

  output wire [CHANNELS*SAMPLES_PER_CHANNEL*SAMPLE_DATA_WIDTH-1:0] output_axis_tdata,
  output wire                                                      output_axis_tvalid,
  input  wire                                                      output_axis_tready,

  input  wire                            rx_enable,
  output reg  [31:0]                     rx_frames_dropped,

  // Addresses of the FPGA side (TX source) and of the host side (TX destination)
  input  wire [32-1:0]                   ip_source_IP_address,
  input  wire [32-1:0]                   ip_destination_IP_address,
  input  wire [16-1:0]                   udp_source,
  input  wire [16-1:0]                   udp_destination,

  // BER
  input  wire                            ber_test,
  input  wire                            reset_ber,

  output wire [63:0]                     total_bits,
  output wire [63:0]                     error_bits_total,
  output wire [31:0]                     out_of_sync_total
);

  localparam OUTPUT_WIDTH = CHANNELS*SAMPLES_PER_CHANNEL*SAMPLE_DATA_WIDTH;

  // Ethernet, IPv4, UDP and the 64-bit frame timestamp, as sent by application_tx
  localparam HEADER_LENGTH = 112+160+64+64;

  ////----------------------------------------Arbiter-------------------------//
  //////////////////////////////////////////////////

  // Frames addressed to the FPGA go to the DAC. In BER mode the FPGA's own
  // packets are expected back through a loopback, so the TX destination is
  // matched instead.
  reg [32-1:0] match_ip_destination;
  reg [16-1:0] match_udp_destination;

  always @(posedge clk)
  begin
    match_ip_destination <= ber_test ? ip_destination_IP_address : ip_source_IP_address;
    match_udp_destination <= ber_test ? udp_destination : udp_source;
  end

  wire [64-1:0] udp_header_part;

  udp_header udp_header_inst (
    .clk(clk),
    .rstn(rstn),
    .udp_source(16'd0),
    .udp_destination(match_udp_destination),
    .udp_length(),
    .udp_checksum(16'd0),
    .payload_length(16'd0),
    .header(udp_header_part));

  wire [160-1:0] ip_header_part;

  ip_header ip_header_inst (
    .clk(clk),
    .rstn(rstn),
    .ip_version(4'h4),
    .ip_header_length(4'h5),
    .ip_type_of_service(8'h00),
    .ip_total_length(),
    .ip_identification(16'h0000),
    .ip_flags(3'h0),
    .ip_fragment_offset(13'h0000),
    .ip_time_to_live(8'h00),
    .ip_protocol(8'h11),
    .ip_header_checksum(),
    .ip_source_IP_address(32'd0),
    .ip_destination_IP_address(match_ip_destination),
    .payload_length(16'd0),
    .header(ip_header_part));

  wire [112-1:0] ethernet_header_part;

  ethernet_header ethernet_header_inst (
    .ethernet_destination_MAC(48'd0),
    .ethernet_source_MAC(48'd0),
    .ethernet_type(16'h0800),
    .header(ethernet_header_part));

  wire [HEADER_LENGTH-1:0] complete_header;

  assign complete_header = {
    64'd0,
    udp_header_part,
    ip_header_part,
    ethernet_header_part};

  // header routing mask creation
  wire [64-1:0] udp_header_routing_mask_part;

  udp_header_mask udp_header_routing_mask_inst (
    .udp_source(1'b0),
    .udp_destination(1'b1),
    .udp_length(1'b0),
    .udp_checksum(1'b0),
    .header_mask(udp_header_routing_mask_part));

  wire [160-1:0] ip_header_routing_mask_part;

  ip_header_mask ip_header_routing_mask_inst (
    .ip_version(1'b1),
    .ip_header_length(1'b1),
    .ip_type_of_service(1'b0),
    .ip_total_length(1'b0),
    .ip_identification(1'b0),
    .ip_flags(1'b0),
    .ip_fragment_offset(1'b0),
    .ip_time_to_live(1'b0),
    .ip_protocol(1'b1),
    .ip_header_checksum(1'b0),
    .ip_source_IP_address(1'b0),
    .ip_destination_IP_address(1'b1),
    .header_mask(ip_header_routing_mask_part));

  wire [112-1:0] ethernet_header_routing_mask_part;

  ethernet_header_mask ethernet_header_routing_mask_inst (
    .ethernet_destination_MAC(1'b0),
    .ethernet_source_MAC(1'b0),
    .ethernet_type(1'b1),
    .header_mask(ethernet_header_routing_mask_part));

  wire [HEADER_LENGTH-1:0] complete_header_routing_mask;

  assign complete_header_routing_mask = {
    64'd0,
    udp_header_routing_mask_part,
    ip_header_routing_mask_part,
    ethernet_header_routing_mask_part};

  // header validation mask creation
  wire [64-1:0] udp_header_validation_mask_part;

  udp_header_mask udp_header_validation_mask_inst (
    .udp_source(1'b0),
    .udp_destination(1'b0),
    .udp_length(1'b0),
    .udp_checksum(1'b0),
    .header_mask(udp_header_validation_mask_part));

  wire [160-1:0] ip_header_validation_mask_part;

  ip_header_mask ip_header_validation_mask_inst (
    .ip_version(1'b0),
    .ip_header_length(1'b0),
    .ip_type_of_service(1'b0),
    .ip_total_length(1'b0),
    .ip_identification(1'b0),
    .ip_flags(1'b0),
    .ip_fragment_offset(1'b0),
    .ip_time_to_live(1'b0),
    .ip_protocol(1'b0),
    .ip_header_checksum(1'b0),
    .ip_source_IP_address(1'b0),
    .ip_destination_IP_address(1'b0),
    .header_mask(ip_header_validation_mask_part));

  wire [112-1:0] ethernet_header_validation_mask_part;

  ethernet_header_mask ethernet_header_validation_mask_inst (
    .ethernet_destination_MAC(1'b0),
    .ethernet_source_MAC(1'b0),
    .ethernet_type(1'b0),
    .header_mask(ethernet_header_validation_mask_part));

  wire [HEADER_LENGTH-1:0] complete_header_validation_mask;

  assign complete_header_validation_mask = {
    64'd0,
    udp_header_validation_mask_part,
    ip_header_validation_mask_part,
    ethernet_header_validation_mask_part};

  wire valid;
  wire switch;

  // Keeps s_axis_sync_rx_tready registered at full throughput: a beat accepted
  // while the output is stalled is parked in the temp register.
  localparam SKID_WIDTH = IF_COUNT*PORTS_PER_IF*(AXIS_DATA_WIDTH+AXIS_KEEP_WIDTH+1+AXIS_RX_USER_WIDTH);

  wire [SKID_WIDTH-1:0] skid_input_data;
  reg                   skid_input_tready;
  wire                  skid_input_tready_early;

  reg                   skid_output_tvalid;
  wire                  skid_output_tready;
  reg  [SKID_WIDTH-1:0] skid_output_data;

  reg                   skid_temp_tvalid;
  reg  [SKID_WIDTH-1:0] skid_temp_data;

  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]    skid_axis_tdata;
  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]    skid_axis_tkeep;
  wire                                                skid_axis_tlast;
  wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0] skid_axis_tuser;

  assign skid_input_data = {s_axis_sync_rx_tuser, s_axis_sync_rx_tlast, s_axis_sync_rx_tkeep, s_axis_sync_rx_tdata};
  assign {skid_axis_tuser, skid_axis_tlast, skid_axis_tkeep, skid_axis_tdata} = skid_output_data;

  assign s_axis_sync_rx_tready = skid_input_tready;

  assign skid_input_tready_early = skid_output_tready ||
    (!skid_temp_tvalid && (!skid_output_tvalid || !s_axis_sync_rx_tvalid));

  always @(posedge clk)
  begin
    if (!rstn) begin
      skid_input_tready <= 1'b0;
      skid_output_tvalid <= 1'b0;
      skid_temp_tvalid <= 1'b0;
    end else begin
      skid_input_tready <= skid_input_tready_early;
      if (skid_input_tready) begin
        if (skid_output_tready || !skid_output_tvalid) begin
          skid_output_tvalid <= s_axis_sync_rx_tvalid;
        end else begin
          skid_temp_tvalid <= s_axis_sync_rx_tvalid;
        end
      end else if (skid_output_tready) begin
        skid_output_tvalid <= skid_temp_tvalid;
        skid_temp_tvalid <= 1'b0;
      end
    end
  end

  always @(posedge clk)
  begin
    if (skid_input_tready) begin
      if (skid_output_tready || !skid_output_tvalid) begin
        skid_output_data <= skid_input_data;
      end else begin
        skid_temp_data <= skid_input_data;
      end
    end else if (skid_output_tready) begin
      skid_output_data <= skid_temp_data;
    end
  end

  rx_arbiter #(
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .HEADER_LENGTH(HEADER_LENGTH),
    .VALIDATION_EN(1)
  ) rx_arbiter_inst (
    .clk(clk),
    .rstn(rstn),
    .enable(rx_enable),
    .header(complete_header),
    .header_routing_list(complete_header_routing_mask),
    .header_validation_list(complete_header_validation_mask),
    .input_axis_tvalid(skid_output_tvalid),
    .input_axis_tready(skid_output_tready),
    .input_axis_tdata(skid_axis_tdata),
    .input_axis_tlast(skid_axis_tlast),
    .valid(valid),
    .switch(switch));

  ////----------------------------------------Datapath switch-----------------//
  //////////////////////////////////////////////////

  // rx_arbiter registers switch/valid on the same handshake that loads this
  // stage, so they always describe the frame the stage currently holds.
  reg [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]    rx_axis_tdata;
  reg [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]    rx_axis_tkeep;
  reg                                                rx_axis_tvalid;
  wire                                               rx_axis_tready;
  reg                                                rx_axis_tlast;
  reg [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0] rx_axis_tuser;

  assign skid_output_tready = !rx_axis_tvalid || rx_axis_tready;

  always @(posedge clk)
  begin
    if (!rstn) begin
      rx_axis_tvalid <= 1'b0;
    end else if (skid_output_tready) begin
      rx_axis_tvalid <= skid_output_tvalid;
    end
  end

  always @(posedge clk)
  begin
    if (skid_output_tready) begin
      rx_axis_tdata <= skid_axis_tdata;
      rx_axis_tkeep <= skid_axis_tkeep;
      rx_axis_tlast <= skid_axis_tlast;
      rx_axis_tuser <= skid_axis_tuser;
    end
  end

  assign m_axis_sync_rx_tdata = rx_axis_tdata;
  assign m_axis_sync_rx_tkeep = rx_axis_tkeep;
  assign m_axis_sync_rx_tvalid = rx_axis_tvalid && !switch;
  assign m_axis_sync_rx_tlast = rx_axis_tlast;
  assign m_axis_sync_rx_tuser = rx_axis_tuser;

  // header removal: each output beat is the low part of the current beat
  // above the high part of the previous one
  //
  // The app path always accepts, so a stalled DAC side cannot block the
  // traffic shared with the host. A frame is dropped whole when the FIFO
  // cannot take a full-size frame at its start, and the remainder of a frame
  // is dropped if the FIFO still overflows.
  wire strip_axis_tvalid;

  reg                                       strip_first;
  reg  [AXIS_DATA_WIDTH-HEADER_LENGTH-1:0]  strip_temp;

  reg                                       app_axis_tvalid;
  wire                                      app_axis_tready;
  reg  [AXIS_DATA_WIDTH-1:0]                app_axis_tdata;
  wire                                      app_axis_almost_full;

  reg                                       app_drop;

  wire app_frame_start = strip_axis_tvalid && strip_first;
  wire app_frame_drop = app_frame_start && app_axis_almost_full;
  wire app_overflow = app_axis_tvalid && !app_drop && !app_axis_tready;

  assign rx_axis_tready = !switch ? m_axis_sync_rx_tready : 1'b1;

  assign strip_axis_tvalid = rx_axis_tvalid && switch && valid;

  always @(posedge clk)
  begin
    if (!rstn) begin
      strip_first <= 1'b1;
      app_axis_tvalid <= 1'b0;
      app_drop <= 1'b0;
      rx_frames_dropped <= 32'd0;
    end else begin
      app_axis_tvalid <= strip_axis_tvalid && !strip_first;
      if (strip_axis_tvalid) begin
        strip_first <= rx_axis_tlast;
      end
      if (app_frame_start) begin
        app_drop <= app_axis_almost_full;
      end else if (app_overflow) begin
        app_drop <= 1'b1;
      end
      rx_frames_dropped <= rx_frames_dropped + app_frame_drop + app_overflow;
    end
  end

  // The part of the last beat above HEADER_LENGTH is dropped: payloads are
  // expected to be a multiple of the bus width.
  always @(posedge clk)
  begin
    if (strip_axis_tvalid) begin
      strip_temp <= rx_axis_tdata[AXIS_DATA_WIDTH-1:HEADER_LENGTH];
      if (!strip_first) begin
        app_axis_tdata <= {rx_axis_tdata[HEADER_LENGTH-1:0], strip_temp};
      end
    end
  end

  ////----------------------------------------Buffer, CDC and Scaling FIFO----//
  //////////////////////////////////////////////////

  localparam MAX_FRAME_BEATS = 2**13*8/AXIS_DATA_WIDTH;

  // The threshold counts entries of each atomic FIFO. With a wider output,
  // input beats are spread over RATIO of them, which differ by up to one entry.
  localparam FIFO_RATIO = (OUTPUT_WIDTH > AXIS_DATA_WIDTH) ? OUTPUT_WIDTH/AXIS_DATA_WIDTH : 1;
  localparam FIFO_FRAME_THRESHOLD = MAX_FRAME_BEATS/FIFO_RATIO + 2;

  wire                       jesd_axis_tready;
  reg                        jesd_axis_tvalid;
  reg  [AXIS_DATA_WIDTH-1:0] jesd_axis_tdata;
  wire                       jesd_axis_almost_full;

  util_axis_fifo_asym #(
    .ASYNC_CLK(1),
    .S_DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH($clog2(2**13 * 8 / OUTPUT_WIDTH)+1),
    .M_DATA_WIDTH(OUTPUT_WIDTH),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(0),
    .ALMOST_FULL_THRESHOLD(FIFO_FRAME_THRESHOLD),
    .TLAST_EN(0),
    .TKEEP_EN(0),
    .REDUCED_FIFO(0)
  ) cdc_scale_fifo (
    .m_axis_aclk(output_clk),
    .m_axis_aresetn(output_rstn),
    .m_axis_ready(output_axis_tready),
    .m_axis_valid(output_axis_tvalid),
    .m_axis_data(output_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_full(),
    .m_axis_almost_full(),
    .m_axis_level(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(jesd_axis_tready),
    .s_axis_valid(jesd_axis_tvalid),
    .s_axis_data(jesd_axis_tdata),
    .s_axis_tkeep(),
    .s_axis_tlast(1'b0),
    .s_axis_empty(),
    .s_axis_almost_empty(),
    .s_axis_full(),
    .s_axis_almost_full(jesd_axis_almost_full),
    .s_axis_room());

  ////----------------------------------------BER----//
  //////////////////////////////////////////////////

  wire                       ber_axis_tready;
  reg                        ber_axis_tvalid;
  reg  [AXIS_DATA_WIDTH-1:0] ber_axis_tdata;

  reg ber_enable;

  always @(posedge clk)
  begin
    ber_enable <= rx_enable && ber_test;
  end

  ber_tester_rx #(
    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH)
  ) ber_tester_rx_inst (
    .clk(clk),
    .rstn(rstn),
    .ber_test(ber_enable),
    .reset_ber(reset_ber),
    .total_bits(total_bits),
    .error_bits_total(error_bits_total),
    .out_of_sync_total(out_of_sync_total),
    .s_axis_output_tdata(ber_axis_tdata),
    .s_axis_output_tvalid(ber_axis_tvalid),
    .s_axis_output_tready(ber_axis_tready));

  ////----------------------------------------Datapath switch----//
  //////////////////////////////////////////////////

  always @(*)
  begin
    if (!ber_test) begin
      jesd_axis_tvalid = app_axis_tvalid && !app_drop;
      jesd_axis_tdata = app_axis_tdata;

      ber_axis_tvalid = 1'b0;
      ber_axis_tdata = {AXIS_DATA_WIDTH{1'b0}};
    end else begin
      jesd_axis_tvalid = 1'b0;
      jesd_axis_tdata = {AXIS_DATA_WIDTH{1'b0}};

      ber_axis_tvalid = app_axis_tvalid && !app_drop;
      ber_axis_tdata = app_axis_tdata;
    end
  end

  assign app_axis_tready = ber_test ? ber_axis_tready : jesd_axis_tready;
  assign app_axis_almost_full = ber_test ? 1'b0 : jesd_axis_almost_full;

endmodule
