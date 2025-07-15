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

  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     m_axis_sync_rx_tdata,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     m_axis_sync_rx_tkeep,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tready,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tlast,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]  m_axis_sync_rx_tuser,

  // Input data
  input  wire                            output_clk,
  input  wire                            output_rstn,

  output wire [CHANNELS*SAMPLES_PER_CHANNEL*SAMPLE_DATA_WIDTH-1:0] output_axis_tdata,
  output wire                                                      output_axis_tvalid,
  input  wire                                                      output_axis_tready,

  input  wire [CHANNELS-1:0]             output_enable,

  input  wire                            start_app,

  // Ethernet header
  input  wire [48-1:0]                   ethernet_destination_MAC,
  input  wire [48-1:0]                   ethernet_source_MAC,
  input  wire [16-1:0]                   ethernet_type,

  // IPv4 header
  input  wire [4-1:0]                    ip_version,
  input  wire [4-1:0]                    ip_header_length,
  input  wire [8-1:0]                    ip_type_of_service,
  input  wire [16-1:0]                   ip_identification,
  input  wire [3-1:0]                    ip_flags,
  input  wire [13-1:0]                   ip_fragment_offset,
  input  wire [8-1:0]                    ip_time_to_live,
  input  wire [8-1:0]                    ip_protocol,
  input  wire [32-1:0]                   ip_source_IP_address,
  input  wire [32-1:0]                   ip_destination_IP_address,

  // UDP header
  input  wire [16-1:0]                   udp_source,
  input  wire [16-1:0]                   udp_destination,
  input  wire [16-1:0]                   udp_checksum,

  // Sample count per channel
  input  wire [15:0]                     sample_count,

  // BER
  input  wire                            ber_test,
  input  wire                            reset_ber,

  output wire [63:0]                     total_bits,
  output wire [63:0]                     error_bits_total,
  output wire [31:0]                     out_of_sync_total
);

  localparam OUTPUT_WIDTH = CHANNELS*SAMPLES_PER_CHANNEL*SAMPLE_DATA_WIDTH;
  localparam HEADER_LENGTH = 336;

  wire [CHANNELS-1:0] output_enable_cdc;

  sync_data #(
    .NUM_OF_BITS(CHANNELS)
  ) sync_data_output_enable (
    .in_clk(output_clk),
    .in_data(output_enable),
    .out_clk(clk),
    .out_data(output_enable_cdc));

  ////----------------------------------------Arbiter-------------------------//
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

  // header creation
  wire [64-1:0] udp_header_part;
  wire [15:0] udp_length;

  reg [15:0] udp_payload_size;

  always @(posedge clk)
  begin
    udp_payload_size <= sample_count * converters(output_enable_cdc) * (SAMPLE_DATA_WIDTH/8);
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
    .ip_total_length(),
    .ip_identification(ip_identification),
    .ip_flags(ip_flags),
    .ip_fragment_offset(ip_fragment_offset),
    .ip_time_to_live(ip_time_to_live),
    .ip_protocol(ip_protocol),
    .ip_header_checksum(),
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

  wire [HEADER_LENGTH-1:0] complete_header;

  assign complete_header = {
    udp_header_part,
    ip_header_part,
    ethernet_header_part};

  // header routing mask creation
  wire [64-1:0] udp_header_routing_mask_part;

  udp_header_mask udp_header_routing_mask_inst (
    .udp_source(1'b0),
    .udp_destination(1'b0),
    .udp_length(1'b0),
    .udp_checksum(1'b0),
    .header_mask(udp_header_routing_mask_part));

  wire [160-1:0] ip_header_routing_mask_part;

  ip_header_mask ip_header_routing_mask_inst (
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
    .ip_source_IP_address(1'b1),
    .ip_destination_IP_address(1'b1),
    .header_mask(ip_header_routing_mask_part));

  wire [112-1:0] ethernet_header_routing_mask_part;

  ethernet_header_mask ethernet_header_routing_mask_inst (
    .ethernet_destination_MAC(1'b0),
    .ethernet_source_MAC(1'b0),
    .ethernet_type(1'b0),
    .header_mask(ethernet_header_routing_mask_part));

  wire [HEADER_LENGTH-1:0] complete_header_routing_mask;

  assign complete_header_routing_mask = {
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
    udp_header_validation_mask_part,
    ip_header_validation_mask_part,
    ethernet_header_validation_mask_part};

  wire valid;
  wire switch;

  rx_arbiter #(
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .HEADER_LENGTH(HEADER_LENGTH),
    .VALIDATION_EN(1)
  ) rx_arbiter_inst (
    .clk(clk),
    .rstn(rstn),
    .start_app(start_app),
    .header(complete_header),
    .header_routing_list(complete_header_routing_mask),
    .header_validation_list(complete_header_validation_mask),
    .input_axis_tvalid(s_axis_sync_rx_tvalid),
    .input_axis_tready(s_axis_sync_rx_tready),
    .input_axis_tdata(s_axis_sync_rx_tdata),
    .input_axis_tlast(s_axis_sync_rx_tlast),
    .valid(valid),
    .switch(switch));

  ////----------------------------------------Datapath switch-----------------//
  //////////////////////////////////////////////////
  reg [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]    axis_sync_rx_tdata_reg;
  reg [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]    axis_sync_rx_tkeep_reg;
  reg [IF_COUNT*PORTS_PER_IF-1:0]                    axis_sync_rx_tvalid_reg;
  reg [IF_COUNT*PORTS_PER_IF-1:0]                    axis_sync_rx_tready_reg;
  reg [IF_COUNT*PORTS_PER_IF-1:0]                    axis_sync_rx_tlast_reg;
  reg [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0] axis_sync_rx_tuser_reg;

  always @(posedge clk)
  begin
    if (!rstn) begin
      axis_sync_rx_tdata_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
      axis_sync_rx_tkeep_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
      axis_sync_rx_tvalid_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      axis_sync_rx_tlast_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      axis_sync_rx_tuser_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH{1'b0}};
    end else begin
      axis_sync_rx_tdata_reg <= s_axis_sync_rx_tdata;
      axis_sync_rx_tkeep_reg <= s_axis_sync_rx_tkeep;
      axis_sync_rx_tvalid_reg <= s_axis_sync_rx_tvalid;
      axis_sync_rx_tlast_reg <= s_axis_sync_rx_tlast;
      axis_sync_rx_tuser_reg <= s_axis_sync_rx_tuser;
    end
  end

  reg [HEADER_LENGTH-1:0] bypass_axis_tdata_reg;
  reg [HEADER_LENGTH-1:0] bypass_axis_tkeep_reg;

  reg [AXIS_DATA_WIDTH-HEADER_LENGTH-1:0]   temp_axis_tdata_reg;
  reg [AXIS_KEEP_WIDTH-HEADER_LENGTH/8-1:0] temp_axis_tkeep_reg;

  always @(*)
  begin
    bypass_axis_tdata_reg = axis_sync_rx_tdata_reg[HEADER_LENGTH-1:0];
    bypass_axis_tkeep_reg = axis_sync_rx_tkeep_reg[HEADER_LENGTH/8-1:0];
  end

  always @(posedge clk)
  begin
    temp_axis_tdata_reg <= axis_sync_rx_tdata_reg[AXIS_DATA_WIDTH-1:HEADER_LENGTH];
    temp_axis_tkeep_reg <= axis_sync_rx_tkeep_reg[AXIS_DATA_WIDTH/8-1:HEADER_LENGTH/8];
  end

  reg [AXIS_DATA_WIDTH-1:0] buffer_axis_tdata_reg;
  reg [AXIS_KEEP_WIDTH-1:0] buffer_axis_tkeep_reg;

  reg [IF_COUNT*PORTS_PER_IF-1:0] input_axis_tvalid_reg [1:0];
  reg [IF_COUNT*PORTS_PER_IF-1:0] input_axis_tready_reg;
  reg [IF_COUNT*PORTS_PER_IF-1:0] input_axis_tlast_reg;

  always @(posedge clk)
  begin
    if (!rstn) begin
      m_axis_sync_rx_tdata <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
      m_axis_sync_rx_tkeep <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
      m_axis_sync_rx_tvalid <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      axis_sync_rx_tready_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      m_axis_sync_rx_tlast <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      m_axis_sync_rx_tuser <= {IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH{1'b0}};
    end else begin
      if (!switch) begin
        m_axis_sync_rx_tdata <= axis_sync_rx_tdata_reg;
        m_axis_sync_rx_tkeep <= axis_sync_rx_tkeep_reg;
        m_axis_sync_rx_tvalid <= axis_sync_rx_tvalid_reg;
        m_axis_sync_rx_tlast <= axis_sync_rx_tlast_reg;
        m_axis_sync_rx_tuser <= axis_sync_rx_tuser_reg;

        buffer_axis_tdata_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
        buffer_axis_tkeep_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};

        input_axis_tvalid_reg[0] <= {IF_COUNT*PORTS_PER_IF{1'b0}};
        input_axis_tvalid_reg[1] <= {IF_COUNT*PORTS_PER_IF{1'b0}};

        input_axis_tlast_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};

        axis_sync_rx_tready_reg <= m_axis_sync_rx_tready;
      end else begin
        m_axis_sync_rx_tdata <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
        m_axis_sync_rx_tkeep <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
        m_axis_sync_rx_tvalid <= {IF_COUNT*PORTS_PER_IF{1'b0}};
        m_axis_sync_rx_tlast <= {IF_COUNT*PORTS_PER_IF{1'b0}};
        m_axis_sync_rx_tuser <= {IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH{1'b0}};

        if (!valid) begin
          buffer_axis_tdata_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
          buffer_axis_tkeep_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};

          input_axis_tvalid_reg[0] <= {IF_COUNT*PORTS_PER_IF{1'b0}};
          input_axis_tvalid_reg[1] <= {IF_COUNT*PORTS_PER_IF{1'b0}};

          input_axis_tlast_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};

          axis_sync_rx_tready_reg <= {IF_COUNT*PORTS_PER_IF{1'b1}};
        end else begin
          // header extraction
          buffer_axis_tdata_reg <= {bypass_axis_tdata_reg, temp_axis_tdata_reg};
          buffer_axis_tkeep_reg <= {bypass_axis_tkeep_reg, temp_axis_tkeep_reg};

          input_axis_tvalid_reg[0] <= axis_sync_rx_tvalid_reg;
          input_axis_tvalid_reg[1] <= input_axis_tvalid_reg[0] && !input_axis_tlast_reg;

          input_axis_tlast_reg <= axis_sync_rx_tlast_reg;

          axis_sync_rx_tready_reg <= input_axis_tready_reg;
        end
      end
    end
  end

  assign s_axis_sync_rx_tready = axis_sync_rx_tready_reg;

  ////----------------------------------------Buffer, CDC and Scaling FIFO----//
  //////////////////////////////////////////////////

  wire                       jesd_axis_tready;
  reg                        jesd_axis_tvalid;
  reg  [AXIS_DATA_WIDTH-1:0] jesd_axis_tdata;

  util_axis_fifo_asym #(
    .ASYNC_CLK(1),
    .S_DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH($clog2(2**13 * 8 / OUTPUT_WIDTH)+1),
    .M_DATA_WIDTH(OUTPUT_WIDTH),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(0),
    .ALMOST_FULL_THRESHOLD(0),
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
    .s_axis_almost_full(),
    .s_axis_room());

  ////----------------------------------------BER----//
  //////////////////////////////////////////////////

  wire                       ber_axis_tready;
  reg                        ber_axis_tvalid;
  reg  [AXIS_DATA_WIDTH-1:0] ber_axis_tdata;

  reg ber_enable;

  always @(posedge clk)
  begin
    ber_enable <= start_app && ber_test;
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
      jesd_axis_tvalid = input_axis_tvalid_reg[1];
      jesd_axis_tdata = buffer_axis_tdata_reg;

      ber_axis_tvalid = 1'b0;
      ber_axis_tdata = {AXIS_DATA_WIDTH{1'b0}};

      input_axis_tready_reg = jesd_axis_tready;
    end else begin
      jesd_axis_tvalid = 1'b0;
      jesd_axis_tdata = {AXIS_DATA_WIDTH{1'b0}};

      ber_axis_tvalid = input_axis_tvalid_reg[1];
      ber_axis_tdata = buffer_axis_tdata_reg;

      input_axis_tready_reg = ber_axis_tready;
    end
  end

endmodule
