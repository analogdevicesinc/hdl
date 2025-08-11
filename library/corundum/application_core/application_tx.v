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

module application_tx #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,

  // Ethernet interface configuration (direct, sync)
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_TX_USER_WIDTH = 17,

  // Input stream
  parameter CHANNELS = 4,
  parameter SAMPLES_PER_CHANNEL = 16,
  parameter SAMPLE_DATA_WIDTH = 16
) (

  input  wire                            clk,
  input  wire                            rstn,

  // Ethernet (synchronous MAC interface - low latency raw traffic)
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     s_axis_sync_tx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     s_axis_sync_tx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_tx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_tx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_tx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_TX_USER_WIDTH-1:0]  s_axis_sync_tx_tuser,

  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     m_axis_sync_tx_tdata,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     m_axis_sync_tx_tkeep,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_tx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_tx_tready,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_tx_tlast,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_TX_USER_WIDTH-1:0]  m_axis_sync_tx_tuser,

  // Input data
  input  wire                            input_clk,
  input  wire                            input_rstn,

  input  wire [CHANNELS*SAMPLES_PER_CHANNEL*SAMPLE_DATA_WIDTH-1:0] input_axis_tdata,
  input  wire                                                      input_axis_tvalid,
  output wire                                                      input_axis_tready,

  input  wire [CHANNELS-1:0]             input_enable,
  output reg                             input_packer_reset,

  input  wire                            start_app,

  // Ethernet header
  input  wire [48-1:0]                   ethernet_destination_MAC,
  input  wire [48-1:0]                   ethernet_source_MAC,
  input  wire [16-1:0]                   ethernet_type,

  // IPv4 header
  input  wire [4-1:0]                    ip_version,
  input  wire [4-1:0]                    ip_header_length,
  input  wire [8-1:0]                    ip_type_of_service,
  output wire [16-1:0]                   ip_total_length,
  input  wire [16-1:0]                   ip_identification,
  input  wire [3-1:0]                    ip_flags,
  input  wire [13-1:0]                   ip_fragment_offset,
  input  wire [8-1:0]                    ip_time_to_live,
  input  wire [8-1:0]                    ip_protocol,
  output wire [16-1:0]                   ip_header_checksum,
  input  wire [32-1:0]                   ip_source_IP_address,
  input  wire [32-1:0]                   ip_destination_IP_address,

  // UDP header
  input  wire [16-1:0]                   udp_source,
  input  wire [16-1:0]                   udp_destination,
  output wire [16-1:0]                   udp_length,
  input  wire [16-1:0]                   udp_checksum,

  // Sample count per channel
  input  wire [15:0]                     sample_count,

  // BER
  input  wire                            ber_test,
  input  wire                            insert_bit_error
);

  localparam INPUT_WIDTH = CHANNELS*SAMPLES_PER_CHANNEL*SAMPLE_DATA_WIDTH;

  ////----------------------------------------Start application---------------//
  //////////////////////////////////////////////////

  reg  run_packetizer;
  wire run_packetizer_cdc;

  wire input_rstn_gated;
  wire rstn_output_gated;

  wire input_axis_tready_fifo;

  wire packet_axis_tlast;

  always @(posedge clk)
  begin
    if (!rstn) begin
      run_packetizer <= 1'b0;
    end else begin
      if (start_app) begin
        run_packetizer <= 1'b1;
      end else if (packet_axis_tlast) begin
        run_packetizer <= 1'b0;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_run_packetizer (
    .in_bits(run_packetizer),
    .out_resetn(input_rstn),
    .out_clk(input_clk),
    .out_bits(run_packetizer_cdc));

  reg  packet_generated;
  wire packet_generated_cdc;

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_packet_generated (
    .in_bits(packet_generated),
    .out_resetn(input_rstn),
    .out_clk(input_clk),
    .out_bits(packet_generated_cdc));

  assign input_rstn_gated = input_rstn && !packet_generated_cdc;
  assign rstn_output_gated = rstn && !packet_generated;

  assign input_axis_tready = input_axis_tready_fifo && run_packetizer_cdc;

  ////----------------------------------------Buffer, CDC and Scaling FIFO----//
  //////////////////////////////////////////////////

  function [$clog2(CHANNELS):0] converters(input [CHANNELS-1:0] input_enable);
    integer i;
    begin
      converters = 0;
      for (i=0; i<CHANNELS; i=i+1) begin
        converters = converters + input_enable[i];
      end
    end
  endfunction

  wire [CHANNELS-1:0] input_enable_cdc;

  sync_data #(
    .NUM_OF_BITS(CHANNELS)
  ) sync_data_input_enable (
    .in_clk(input_clk),
    .in_data(input_enable),
    .out_clk(clk),
    .out_data(input_enable_cdc));

  wire [15:0] sample_count_cdc;

  sync_data #(
    .NUM_OF_BITS(16)
  ) sync_data_sample_count (
    .in_clk(clk),
    .in_data(sample_count),
    .out_clk(input_clk),
    .out_data(sample_count_cdc));

  // calculate the number of inputs base on enabled channels and requested samples
  reg  [31:0] input_counter;
  reg  [31:0] input_sample_total_requested;
  wire [31:0] input_count_requested;

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      input_sample_total_requested <= 32'h0;
    end else begin
      input_sample_total_requested <= converters(input_enable) * sample_count_cdc;
    end
  end

  assign input_count_requested = input_sample_total_requested / (INPUT_WIDTH/SAMPLE_DATA_WIDTH) +
    ((INPUT_WIDTH > AXIS_DATA_WIDTH) ? ((input_sample_total_requested % (INPUT_WIDTH/SAMPLE_DATA_WIDTH) != 'd0) ? 1 : 0) : 0);

  wire input_axis_tvalid_buffered;

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      input_counter <= 'd1;
    end else begin
      if (input_counter >= input_count_requested) begin
        input_counter <= 'd1;
      end else begin
        if (input_axis_tvalid_buffered && input_axis_tready_fifo && !input_packer_reset) begin
          input_counter <= input_counter + 1;
        end
      end
    end
  end

  // packetizer reset logic
  wire input_fifo_almost_empty;
  wire input_fifo_almost_full;

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      input_packer_reset <= 1'b0;
    end else begin
      if (input_fifo_almost_empty) begin
        input_packer_reset <= 1'b0;
      end else begin
        if (input_counter == input_count_requested && input_fifo_almost_full) begin
          input_packer_reset <= 1'b1;
        end
      end
    end
  end

  assign input_axis_tvalid_buffered = input_axis_tvalid && !input_packer_reset;

  // calculate the number of inputs base on enabled channels and requested samples
  reg  [31:0] output_counter;
  reg  [31:0] output_count_requested;
  wire [31:0] output_count_requested_max;
  reg         output_sent;

  always @(posedge clk)
  begin
    if (!rstn) begin
      output_count_requested <= 32'h0;
    end else begin
      output_count_requested <= converters(input_enable_cdc) * sample_count / (AXIS_DATA_WIDTH/SAMPLE_DATA_WIDTH);
    end
  end

  assign output_count_requested_max = output_count_requested +
    ((INPUT_WIDTH > AXIS_DATA_WIDTH) ? ((output_count_requested % (INPUT_WIDTH/AXIS_DATA_WIDTH) != 'd0) ? ((INPUT_WIDTH/AXIS_DATA_WIDTH) - output_count_requested % (INPUT_WIDTH/AXIS_DATA_WIDTH)) : 0) : 0);

  wire [AXIS_DATA_WIDTH-1:0] cdc_axis_tdata;
  wire [AXIS_KEEP_WIDTH-1:0] cdc_axis_tkeep;
  wire                       cdc_axis_tvalid;
  reg                        cdc_axis_tready;
  reg                        cdc_axis_tvalid_gated;
  reg                        cdc_axis_tready_gated;

  always @(posedge clk)
  begin
    if (!rstn) begin
      output_counter <= 'd1;
    end else begin
      if (output_counter >= output_count_requested_max) begin
        output_counter <= 'd1;
      end else begin
        if (cdc_axis_tvalid && cdc_axis_tready) begin
          output_counter <= output_counter + 1;
        end
      end
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      output_sent <= 1'b0;
    end else begin
      if (output_counter >= output_count_requested_max) begin
        output_sent <= 1'b0;
      end else begin
        if (cdc_axis_tvalid && cdc_axis_tready && output_counter >= output_count_requested) begin
          output_sent <= 1'b1;
        end
      end
    end
  end

  always @(*)
  begin
    cdc_axis_tvalid_gated = (output_sent) ? 1'b0 : cdc_axis_tvalid && !packet_generated;
    cdc_axis_tready_gated = output_sent || cdc_axis_tready;
  end

  util_axis_fifo_asym #(
    .ASYNC_CLK(1),
    .S_DATA_WIDTH(INPUT_WIDTH),
    .ADDRESS_WIDTH($clog2(2**13 * 8 / INPUT_WIDTH)+1),
    .M_DATA_WIDTH(AXIS_DATA_WIDTH),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(4096/INPUT_WIDTH),
    .ALMOST_FULL_THRESHOLD($clog2(2**13 * 8 / INPUT_WIDTH)),
    .TLAST_EN(0),
    .TKEEP_EN(1),
    .FIFO_LIMITED(0),
    .ADDRESS_WIDTH_PERSPECTIVE(1)
  ) cdc_scale_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn_output_gated),
    .m_axis_ready(cdc_axis_tready_gated),
    .m_axis_valid(cdc_axis_tvalid),
    .m_axis_data(cdc_axis_tdata),
    .m_axis_tkeep(cdc_axis_tkeep),
    .m_axis_tlast(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_full(),
    .m_axis_almost_full(),
    .m_axis_level(),

    .s_axis_aclk(input_clk),
    .s_axis_aresetn(input_rstn_gated),
    .s_axis_ready(input_axis_tready_fifo),
    .s_axis_valid(input_axis_tvalid_buffered),
    .s_axis_data(input_axis_tdata),
    .s_axis_tkeep({INPUT_WIDTH/8{1'b1}}),
    .s_axis_tlast(1'b0),
    .s_axis_empty(),
    .s_axis_almost_empty(input_fifo_almost_empty),
    .s_axis_full(),
    .s_axis_almost_full(input_fifo_almost_full),
    .s_axis_room());

  ////----------------------------------------BER--------------------//
  //////////////////////////////////////////////////

  reg                        ber_axis_tready;
  wire                       ber_axis_tvalid;
  wire [AXIS_DATA_WIDTH-1:0] ber_axis_tdata;
  wire [AXIS_KEEP_WIDTH-1:0] ber_axis_tkeep;

  ber_tester_tx #(
    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH)
  ) ber_tester_tx_inst (
    .clk(clk),
    .rstn(rstn),
    .ber_test(ber_test),
    .insert_bit_error(insert_bit_error),
    .m_axis_output_tdata(ber_axis_tdata),
    .m_axis_output_tkeep(ber_axis_tkeep),
    .m_axis_output_tvalid(ber_axis_tvalid),
    .m_axis_output_tready(ber_axis_tready));

  ////----------------------------------------JESD-BER switch--------------------//
  //////////////////////////////////////////////////

  wire                       packetizer_axis_tready;
  reg                        packetizer_axis_tvalid;
  reg  [AXIS_DATA_WIDTH-1:0] packetizer_axis_tdata;
  reg  [AXIS_KEEP_WIDTH-1:0] packetizer_axis_tkeep;

  always @(*)
  begin
    if (!ber_test) begin
      packetizer_axis_tvalid = cdc_axis_tvalid_gated;
      packetizer_axis_tdata = cdc_axis_tdata;
      packetizer_axis_tkeep = cdc_axis_tkeep;

      cdc_axis_tready = packetizer_axis_tready;

      ber_axis_tready = 1'b0;
    end else begin
      packetizer_axis_tvalid = ber_axis_tvalid;
      packetizer_axis_tdata = ber_axis_tdata;
      packetizer_axis_tkeep = ber_axis_tkeep;

      cdc_axis_tready = 1'b0;

      ber_axis_tready = packetizer_axis_tready;
    end
  end

  ////----------------------------------------Packetizer--------------------//
  //////////////////////////////////////////////////

  wire                       packet_axis_tready;
  wire                       packet_axis_tvalid;
  wire [AXIS_DATA_WIDTH-1:0] packet_axis_tdata;
  wire [AXIS_KEEP_WIDTH-1:0] packet_axis_tkeep;

  reg [31:0] packet_size;

  always @(posedge clk)
  begin
    packet_size <= sample_count * converters(input_enable_cdc) / (AXIS_DATA_WIDTH/SAMPLE_DATA_WIDTH);
  end

  packetizer #(
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH)
  ) packetizer_inst (
    .clk(clk),
    .rstn(rstn_output_gated),
    .input_axis_tready(packetizer_axis_tready),
    .input_axis_tvalid(packetizer_axis_tvalid),
    .input_axis_tdata(packetizer_axis_tdata),
    .input_axis_tkeep(packetizer_axis_tkeep),

    .output_axis_tready(packet_axis_tready),
    .output_axis_tvalid(packet_axis_tvalid),
    .output_axis_tdata(packet_axis_tdata),
    .output_axis_tkeep(packet_axis_tkeep),
    .output_axis_tlast(packet_axis_tlast),

    .packet_size(packet_size));

  ////----------------------------------------Header Inserter---------------//
  //////////////////////////////////////////////////

  wire [64-1:0] udp_header_part;

  reg [15:0] udp_payload_size;

  always @(posedge clk)
  begin
    udp_payload_size <= sample_count * converters(input_enable_cdc) * (SAMPLE_DATA_WIDTH/8);
  end

  udp_header udp_header_inst (
    .clk(clk),
    .rstn(rstn),
    .udp_source(udp_source),
    .udp_destination(udp_destination),
    .udp_length(udp_length),
    .udp_checksum(udp_checksum),
    .payload_length(udp_payload_size),
    .header(udp_header_part));

  wire [160-1:0] ip_header_part;

  ip_header ip_header_inst (
    .clk(clk),
    .rstn(rstn),
    .ip_version(ip_version),
    .ip_header_length(ip_header_length),
    .ip_type_of_service(ip_type_of_service),
    .ip_total_length(ip_total_length),
    .ip_identification(ip_identification),
    .ip_flags(ip_flags),
    .ip_fragment_offset(ip_fragment_offset),
    .ip_time_to_live(ip_time_to_live),
    .ip_protocol(ip_protocol),
    .ip_header_checksum(ip_header_checksum),
    .ip_source_IP_address(ip_source_IP_address),
    .ip_destination_IP_address(ip_destination_IP_address),
    .payload_length(udp_length),
    .header(ip_header_part));

  wire [112-1:0] ethernet_header_part;

  ethernet_header ethernet_header_inst (
    .ethernet_destination_MAC(ethernet_destination_MAC),
    .ethernet_source_MAC(ethernet_source_MAC),
    .ethernet_type(ethernet_type),
    .header(ethernet_header_part));

  wire [336-1:0] complete_header;

  assign complete_header = {
    udp_header_part,
    ip_header_part,
    ethernet_header_part};

  wire                       header_axis_tvalid;
  wire                       header_axis_tready;
  wire [AXIS_DATA_WIDTH-1:0] header_axis_tdata;
  wire [AXIS_KEEP_WIDTH-1:0] header_axis_tkeep;
  wire                       header_axis_tlast;

  header_inserter #(
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .HEADER_WIDTH(336)
  ) header_inserter_inst (
    .clk(clk),
    .rstn(rstn_output_gated),
    .header(complete_header),

    .input_axis_tready(packet_axis_tready),
    .input_axis_tvalid(packet_axis_tvalid),
    .input_axis_tdata(packet_axis_tdata),
    .input_axis_tkeep(packet_axis_tkeep),
    .input_axis_tlast(packet_axis_tlast),

    .output_axis_tready(header_axis_tready),
    .output_axis_tvalid(header_axis_tvalid),
    .output_axis_tdata(header_axis_tdata),
    .output_axis_tkeep(header_axis_tkeep),
    .output_axis_tlast(header_axis_tlast));

  ////----------------------------------------Packet Buffer FIFO----------------------//
  //////////////////////////////////////////////////

  wire                       header_buffer_axis_tvalid;
  reg                        header_buffer_axis_tready;
  wire [AXIS_DATA_WIDTH-1:0] header_buffer_axis_tdata;
  wire [AXIS_KEEP_WIDTH-1:0] header_buffer_axis_tkeep;
  wire                       header_buffer_axis_tlast;

  wire                       header_buffer_axis_tvalid_gated;
  wire                       header_buffer_axis_tready_gated;

  wire packet_buffer_almost_full;
  wire packet_buffer_almost_empty;

  reg [7:0] packet_counter;
  reg packet_valid;

  wire input_packet_last;
  wire output_packet_last;

  assign input_packet_last = header_axis_tlast && header_axis_tready && header_axis_tvalid;
  assign output_packet_last = header_buffer_axis_tlast && header_buffer_axis_tready && header_buffer_axis_tvalid_gated;

  assign header_buffer_axis_tready_gated = header_buffer_axis_tready && packet_valid;

  always @(posedge clk)
  begin
    if (!rstn) begin
      packet_counter <= 8'd0;
    end else begin
      if (packet_generated) begin
        packet_counter <= 8'd0;
      end else begin
        case ({output_packet_last, input_packet_last})
          2'b01: packet_counter <= packet_counter + 1;
          2'b10: packet_counter <= packet_counter - 1;
          default:;
        endcase
      end
    end
  end

  always @(*)
  begin
    if (packet_counter != 8'd0) begin
      packet_valid = 1'b1;
    end else begin
      packet_valid = 1'b0;
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      packet_generated <= 1'b1;
    end else begin
      if (run_packetizer) begin
        packet_generated <= 1'b0;
      end else if (output_packet_last) begin
        packet_generated <= 1'b1;
      end
    end
  end

  assign header_buffer_axis_tvalid_gated = header_buffer_axis_tvalid && rstn_output_gated && packet_valid;

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH($clog2(2**13 * 8 / AXIS_DATA_WIDTH)+1),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(8192/AXIS_DATA_WIDTH),
    .ALMOST_FULL_THRESHOLD(8192/AXIS_DATA_WIDTH),
    .TLAST_EN(1),
    .TKEEP_EN(1),
    .REMOVE_NULL_BEAT_EN(0)
  ) header_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn_output_gated),
    .m_axis_ready(header_buffer_axis_tready_gated),
    .m_axis_valid(header_buffer_axis_tvalid),
    .m_axis_data(header_buffer_axis_tdata),
    .m_axis_tkeep(header_buffer_axis_tkeep),
    .m_axis_tlast(header_buffer_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(packet_buffer_almost_empty),
    .m_axis_full(),
    .m_axis_almost_full(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn_output_gated),
    .s_axis_ready(header_axis_tready),
    .s_axis_valid(header_axis_tvalid),
    .s_axis_data(header_axis_tdata),
    .s_axis_tkeep(header_axis_tkeep),
    .s_axis_tlast(header_axis_tlast),
    .s_axis_room(),
    .s_axis_empty(),
    .s_axis_almost_empty(),
    .s_axis_full(),
    .s_axis_almost_full(packet_buffer_almost_full));

  ////----------------------------------------OS Buffer FIFO----------------------//
  //////////////////////////////////////////////////

  reg                           os_buffer_axis_tready;
  wire                          os_buffer_axis_tvalid;
  wire [AXIS_DATA_WIDTH-1:0]    os_buffer_axis_tdata;
  wire [AXIS_KEEP_WIDTH-1:0]    os_buffer_axis_tkeep;
  wire                          os_buffer_axis_tlast;
  wire [AXIS_TX_USER_WIDTH-1:0] os_buffer_axis_tuser;

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH + AXIS_KEEP_WIDTH + AXIS_TX_USER_WIDTH),
    .ADDRESS_WIDTH($clog2(12288/AXIS_DATA_WIDTH)+1),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(),
    .ALMOST_FULL_THRESHOLD(),
    .TLAST_EN(1),
    .TKEEP_EN(0),
    .REMOVE_NULL_BEAT_EN(0)
  ) os_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(os_buffer_axis_tready),
    .m_axis_valid(os_buffer_axis_tvalid),
    .m_axis_data({os_buffer_axis_tdata, os_buffer_axis_tkeep, os_buffer_axis_tuser}),
    .m_axis_tkeep(),
    .m_axis_tlast(os_buffer_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_full(),
    .m_axis_almost_full(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(s_axis_sync_tx_tready),
    .s_axis_valid(s_axis_sync_tx_tvalid),
    .s_axis_data({s_axis_sync_tx_tdata, s_axis_sync_tx_tkeep, s_axis_sync_tx_tuser}),
    .s_axis_tkeep(),
    .s_axis_tlast(s_axis_sync_tx_tlast),
    .s_axis_room(),
    .s_axis_empty(),
    .s_axis_almost_empty(),
    .s_axis_full(),
    .s_axis_almost_full());

  // Datapath switch
  reg datapath_switch; // 0 - OS
                       // 1 - Packet
  reg os_datapath_lock;
  reg jesd_datapath_lock;

  always @(posedge clk)
  begin
    if (!rstn) begin
      os_datapath_lock <= 1'b0;
    end else begin
      if (!datapath_switch && os_buffer_axis_tvalid && os_buffer_axis_tready) begin
        if (os_buffer_axis_tlast) begin
          os_datapath_lock <= 1'b0;
        end else begin
          os_datapath_lock <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      jesd_datapath_lock <= 1'b0;
    end else begin
      if (datapath_switch && header_buffer_axis_tvalid_gated && header_buffer_axis_tready) begin
        if (header_buffer_axis_tlast) begin
          jesd_datapath_lock <= 1'b0;
        end else begin
          jesd_datapath_lock <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      datapath_switch <= 1'b1;
    end else begin
      if (!datapath_switch) begin
        if ((os_buffer_axis_tready && os_buffer_axis_tvalid && os_buffer_axis_tlast && header_buffer_axis_tvalid_gated) || (!os_datapath_lock && !os_buffer_axis_tvalid && header_buffer_axis_tvalid_gated)) begin
          datapath_switch <= 1'b1;
        end
      end else begin
        if ((header_buffer_axis_tready && header_buffer_axis_tvalid_gated && header_buffer_axis_tlast && os_buffer_axis_tvalid) || (!jesd_datapath_lock && !header_buffer_axis_tvalid_gated && os_buffer_axis_tvalid)) begin
          datapath_switch <= 1'b0;
        end
      end
    end
  end

  always @(*)
  begin
    if (!datapath_switch) begin
      m_axis_sync_tx_tdata = os_buffer_axis_tdata;
      m_axis_sync_tx_tkeep = os_buffer_axis_tkeep;
      m_axis_sync_tx_tvalid = os_buffer_axis_tvalid;
      m_axis_sync_tx_tlast = os_buffer_axis_tlast;
      m_axis_sync_tx_tuser = os_buffer_axis_tuser;

      os_buffer_axis_tready = m_axis_sync_tx_tready;

      header_buffer_axis_tready = 1'b0;
    end else begin
      m_axis_sync_tx_tdata = header_buffer_axis_tdata;
      m_axis_sync_tx_tkeep = header_buffer_axis_tkeep;
      m_axis_sync_tx_tvalid = header_buffer_axis_tvalid_gated;
      m_axis_sync_tx_tlast = header_buffer_axis_tlast;
      m_axis_sync_tx_tuser = 1'b0;

      os_buffer_axis_tready = 1'b0;

      header_buffer_axis_tready = m_axis_sync_tx_tready;
    end
  end

endmodule
