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

module application_regmap #(

  // AXI lite interface (control to NIC)
  parameter AXIL_CTRL_DATA_WIDTH = 32,
  parameter AXIL_CTRL_ADDR_WIDTH = 16,
  parameter AXIL_CTRL_STRB_WIDTH = (AXIL_CTRL_DATA_WIDTH/8)
) (

  input  wire                            clk,
  input  wire                            rstn,

  // AXI-Lite slave interface (control from host)
  input  wire [AXIL_CTRL_ADDR_WIDTH-1:0] s_axil_ctrl_awaddr,
  input  wire [2:0]                      s_axil_ctrl_awprot,
  input  wire                            s_axil_ctrl_awvalid,
  output wire                            s_axil_ctrl_awready,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0] s_axil_ctrl_wdata,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0] s_axil_ctrl_wstrb,
  input  wire                            s_axil_ctrl_wvalid,
  output wire                            s_axil_ctrl_wready,
  output wire [1:0]                      s_axil_ctrl_bresp,
  output wire                            s_axil_ctrl_bvalid,
  input  wire                            s_axil_ctrl_bready,
  input  wire [AXIL_CTRL_ADDR_WIDTH-1:0] s_axil_ctrl_araddr,
  input  wire [2:0]                      s_axil_ctrl_arprot,
  input  wire                            s_axil_ctrl_arvalid,
  output wire                            s_axil_ctrl_arready,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0] s_axil_ctrl_rdata,
  output wire [1:0]                      s_axil_ctrl_rresp,
  output wire                            s_axil_ctrl_rvalid,
  input  wire                            s_axil_ctrl_rready,

  output reg                             start_app,
  output reg                             start_counter_reg,
  input  wire [31:0]                     counter_reg,

  // Ethernet header
  output reg  [48-1:0]                   ethernet_destination_MAC,
  output reg  [48-1:0]                   ethernet_source_MAC,
  output reg  [16-1:0]                   ethernet_type,

  // IPv4 header
  output reg  [4-1:0]                    ip_version,
  output reg  [4-1:0]                    ip_header_length,
  output reg  [8-1:0]                    ip_type_of_service,
  input  wire [16-1:0]                   ip_total_length,
  output reg  [16-1:0]                   ip_identification,
  output reg  [3-1:0]                    ip_flags,
  output reg  [13-1:0]                   ip_fragment_offset,
  output reg  [8-1:0]                    ip_time_to_live,
  output reg  [8-1:0]                    ip_protocol,
  input  wire [16-1:0]                   ip_header_checksum,
  output reg  [32-1:0]                   ip_source_IP_address,
  output reg  [32-1:0]                   ip_destination_IP_address,

  // UDP header
  output reg  [16-1:0]                   udp_source,
  output reg  [16-1:0]                   udp_destination,
  input  wire [16-1:0]                   udp_length,
  output reg  [16-1:0]                   udp_checksum,

  output reg                             ber_test,
  output reg                             reset_ber,
  output reg                             insert_bit_error,

  input  wire [63:0]                     total_bits,
  input  wire [63:0]                     error_bits_total,
  input  wire [31:0]                     out_of_sync_total,

  // Sample count per channel
  output reg  [15:0]                     sample_count
);

  wire                              up_wreq;
  wire [(AXIL_CTRL_ADDR_WIDTH-3):0] up_waddr;
  wire [31:0]                       up_wdata;
  reg                               up_wack;
  wire                              up_rreq;
  wire [(AXIL_CTRL_ADDR_WIDTH-3):0] up_raddr;
  reg  [31:0]                       up_rdata;
  reg                               up_rack;

  // Generic
  reg [31:0] version_reg = 'h1234ABCD;
  reg [31:0] scratch_reg;

  always @(posedge clk)
  begin
    if (rstn == 1'b0) begin
      up_wack <= 1'b0;
      up_rack <= 1'b0;

      // Generic
      scratch_reg <= 'h0;
      start_counter_reg <= 1'b0;
      // Data generator
      start_app <= 1'b0;
      // Ethernet header
      ethernet_destination_MAC <= 48'hB83FD22A0BF1;
      ethernet_source_MAC <= 48'h000A35000102;
      ethernet_type <= 16'h0800;
      // IPv4 header
      ip_version <= 4'h4;
      ip_header_length <= 4'h5;
      ip_type_of_service <= 8'h00;
      ip_identification <= 16'h0000;
      ip_flags <= 3'h0;
      ip_fragment_offset <= 13'h0000;
      ip_time_to_live <= 8'h80;
      ip_protocol <= 8'h11;
      ip_source_IP_address <= {8'd192, 8'd168, 8'd0, 8'd69};
      ip_destination_IP_address <= {8'd192, 8'd168, 8'd0, 8'd10};
      // UDP header
      udp_source <= 16'h1234;
      udp_destination <= 16'h5678;
      udp_checksum <= 16'h0000;
      // BER testing
      ber_test <= 1'b0;
      reset_ber <= 1'b0;
      insert_bit_error <= 1'b0;
      // Sample count per channel
      sample_count <= 16'd64;
    end else begin
      up_wack <= up_wreq;
      up_rack <= up_rreq;

      if (up_wreq == 1'b1) begin
        case (up_waddr)
          // Generic
          'h1: scratch_reg <= up_wdata;
          'h2: start_counter_reg <= up_wdata[0];
          // Data generator
          'h5: start_app <= up_wdata[0];
          // Ethernet header
          'h7: ethernet_destination_MAC[48-1:32] <= up_wdata[16-1:0];
          'h8: ethernet_destination_MAC[31:0] <= up_wdata;
          'h9: ethernet_source_MAC[48-1:32] <= up_wdata[16-1:0];
          'hA: ethernet_source_MAC[31:0] <= up_wdata;
          'hB: ethernet_type <= up_wdata[16-1:0];
          // IPv4 header
          'hC: ip_version <= up_wdata[4-1:0];
          'hD: ip_header_length <= up_wdata[4-1:0];
          'hE: ip_type_of_service <= up_wdata[8-1:0];
          'h10: ip_identification <= up_wdata[16-1:0];
          'h11: ip_flags <= up_wdata[3-1:0];
          'h12: ip_fragment_offset <= up_wdata[13-1:0];
          'h13: ip_time_to_live <= up_wdata[8-1:0];
          'h14: ip_protocol <= up_wdata[8-1:0];
          'h16: ip_source_IP_address <= up_wdata[32-1:0];
          'h17: ip_destination_IP_address <= up_wdata[32-1:0];
          // UDP header
          'h18: udp_source <= up_wdata[16-1:0];
          'h19: udp_destination <= up_wdata[16-1:0];
          'h1B: udp_checksum <= up_wdata[16-1:0];
          // BER testing
          'h1C: ber_test <= up_wdata[0];
          'h1D: reset_ber <= up_wdata[0];
          'h23: insert_bit_error <= up_wdata[0];
          // Sample count per channel
          'h24: sample_count <= up_wdata[15:0];
          default: ;
        endcase
      end else begin
        start_counter_reg <= 1'b0;
        reset_ber <= 1'b0;
        insert_bit_error <= 1'b0;
      end

      if (up_rreq == 1'b1) begin
        case (up_raddr)
          // Generic
          'h0: up_rdata <= version_reg;
          'h1: up_rdata <= scratch_reg;
          'h2: up_rdata <= {{31{1'b0}}, start_counter_reg};
          'h4: up_rdata <= counter_reg;
          // Data generator
          'h5: up_rdata <= {{31{1'b0}}, start_app};
          // Ethernet header
          'h7: up_rdata <= {{16{1'b0}}, ethernet_destination_MAC[48-1:32]};
          'h8: up_rdata <= ethernet_destination_MAC[31:0];
          'h9: up_rdata <= {{16{1'b0}}, ethernet_source_MAC[48-1:32]};
          'hA: up_rdata <= ethernet_source_MAC[31:0];
          'hB: up_rdata <= {{16{1'b0}}, ethernet_type};
          // IPv4 header
          'hC: up_rdata <= {{28{1'b0}}, ip_version};
          'hD: up_rdata <= {{28{1'b0}}, ip_header_length};
          'hE: up_rdata <= {{24{1'b0}}, ip_type_of_service};
          'hF: up_rdata <= {{16{1'b0}}, ip_total_length};
          'h10: up_rdata <= {{16{1'b0}}, ip_identification};
          'h11: up_rdata <= {{29{1'b0}}, ip_flags};
          'h12: up_rdata <= {{19{1'b0}}, ip_fragment_offset};
          'h13: up_rdata <= {{24{1'b0}}, ip_time_to_live};
          'h14: up_rdata <= {{24{1'b0}}, ip_protocol};
          'h15: up_rdata <= {{16{1'b0}}, ip_header_checksum};
          'h16: up_rdata <= ip_source_IP_address;
          'h17: up_rdata <= ip_destination_IP_address;
          // UDP header
          'h18: up_rdata <= {{16{1'b0}}, udp_source};
          'h19: up_rdata <= {{16{1'b0}}, udp_destination};
          'h1A: up_rdata <= {{16{1'b0}}, udp_length};
          'h1B: up_rdata <= {{16{1'b0}}, udp_checksum};
          // BER testing
          'h1C: up_rdata <= {{31{1'b0}}, ber_test};
          'h1D: up_rdata <= {{31{1'b0}}, reset_ber};
          'h1E: up_rdata <= total_bits[63:32];
          'h1F: up_rdata <= total_bits[31:0];
          'h20: up_rdata <= error_bits_total[63:32];
          'h21: up_rdata <= error_bits_total[31:0];
          'h22: up_rdata <= out_of_sync_total;
          'h23: up_rdata <= {{31{1'b0}}, insert_bit_error};
          // Sample count per channel
          'h24: up_rdata <= {{16{1'b0}}, sample_count};
          default: up_rdata <= 32'd0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  up_axi #(
    .AXI_ADDRESS_WIDTH(AXIL_CTRL_ADDR_WIDTH)
  ) i_up_axi (
    .up_rstn            (rstn),
    .up_clk             (clk),
    .up_axi_awvalid     (s_axil_ctrl_awvalid),
    .up_axi_awaddr      (s_axil_ctrl_awaddr),
    .up_axi_awready     (s_axil_ctrl_awready),
    .up_axi_wvalid      (s_axil_ctrl_wvalid),
    .up_axi_wdata       (s_axil_ctrl_wdata),
    .up_axi_wstrb       (s_axil_ctrl_wstrb),
    .up_axi_wready      (s_axil_ctrl_wready),
    .up_axi_bvalid      (s_axil_ctrl_bvalid),
    .up_axi_bresp       (s_axil_ctrl_bresp),
    .up_axi_bready      (s_axil_ctrl_bready),
    .up_axi_arvalid     (s_axil_ctrl_arvalid),
    .up_axi_araddr      (s_axil_ctrl_araddr),
    .up_axi_arready     (s_axil_ctrl_arready),
    .up_axi_rvalid      (s_axil_ctrl_rvalid),
    .up_axi_rresp       (s_axil_ctrl_rresp),
    .up_axi_rdata       (s_axil_ctrl_rdata),
    .up_axi_rready      (s_axil_ctrl_rready),
    .up_wreq            (up_wreq),
    .up_waddr           (up_waddr),
    .up_wdata           (up_wdata),
    .up_wack            (up_wack),
    .up_rreq            (up_rreq),
    .up_raddr           (up_raddr),
    .up_rdata           (up_rdata),
    .up_rack            (up_rack));

endmodule
