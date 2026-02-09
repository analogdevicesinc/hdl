// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns/100ps

module rtp_engine_regmap #(
  parameter         VERSION = 1
  ) (

  // control signals

  output      [31:0]      dest_addr_hb,
  output      [15:0]      dest_addr_lb,
  output      [31:0]      source_addr_hb,
  output      [15:0]      source_addr_lb,
  output      [31:0]      src_ip_addr,
  output      [31:0]      dest_ip_addr,
  output      [7:0]       ip_qos,
  output      [15:0]      udp_src_port,
  output      [15:0]      udp_dest_port,
  output      [11:0]      num_lines,
  output      [11:0]      num_px_p_line,
  output                  custom_timestamp,
  output                  custom_timestamp_96b,
  output                  timestamp_s_eof,
  output                  timestamp_network_pwm_genval,

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output reg              up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output reg  [31:0]      up_rdata,
  output reg              up_rack
);

  // internal registers

  reg  [31:0]     up_dest_addr_hb = 'h0;
  reg  [15:0]     up_dest_addr_lb = 'h0;
  reg  [31:0]     up_source_addr_hb = 'h0;
  reg  [15:0]     up_source_addr_lb = 'h0;
  reg  [31:0]     up_src_ip_addr = 'h0;
  reg  [31:0]     up_dest_ip_addr = 'h0;
  reg  [7:0]      up_ip_qos = 'h0;
  reg  [15:0]     up_udp_src_port = 'h0;
  reg  [15:0]     up_udp_dest_port = 'h0;
  reg  [11:0]     up_num_lines = 'h0;
  reg  [11:0]     up_num_px_p_line = 'h0;
  reg             up_custom_timestamp = 1'b0;
  reg             up_custom_timestamp_96b = 1'b0;
  reg             up_timestamp_s_eof = 1'b0;
  reg             up_timestamp_network_pwm_genval = 1'b0;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dest_addr_hb <= 'h0;
      up_dest_addr_lb <= 'h0;
      up_source_addr_hb <= 'h0;
      up_source_addr_lb <= 'h0;
      up_src_ip_addr <= 'h0;
      up_dest_ip_addr <= 'h0;
      up_ip_qos <= 'h0;
      up_udp_src_port <= 'h0;
      up_udp_dest_port <= 'h0;
      up_num_lines <= 'h0;
      up_num_px_p_line <= 'h0;
      up_custom_timestamp <= 1'b0;
      up_custom_timestamp_96b <= 1'b0;
      up_timestamp_s_eof <= 1'b0;
      up_timestamp_network_pwm_genval <= 1'b0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h1)) begin
        up_dest_addr_hb<= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h2)) begin
        up_dest_addr_lb <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h3)) begin
        up_source_addr_hb <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h4)) begin
        up_source_addr_lb <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h5)) begin
        up_src_ip_addr <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h6)) begin
        up_dest_ip_addr <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h7)) begin
        up_ip_qos <= up_wdata[7:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h8)) begin
        up_udp_src_port <= up_wdata[31:16];
        up_udp_dest_port <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h9)) begin
        up_num_lines <= up_wdata[11:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'ha)) begin
        up_num_px_p_line <= up_wdata[11:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'hb)) begin
        up_custom_timestamp <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'hc)) begin
        up_custom_timestamp_96b <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'hd)) begin
        up_timestamp_s_eof <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'he)) begin
        up_timestamp_network_pwm_genval <= up_wdata[0];
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        if (up_raddr[13:5] == 10'd0) begin
          case (up_raddr) inside
            14'h0: up_rdata <= VERSION;
            14'h1: up_rdata <= up_dest_addr_hb;
            14'h2: up_rdata <= {15'd0,up_dest_addr_lb};
            14'h3: up_rdata <= up_source_addr_hb;
            14'h4: up_rdata <= {15'd0,up_source_addr_lb};
            14'h5: up_rdata <= up_src_ip_addr;
            14'h6: up_rdata <= up_dest_ip_addr;
            14'h7: up_rdata <= {24'd0,up_ip_qos};
            14'h8: up_rdata <= {up_udp_src_port,up_udp_dest_port};
            14'h9: up_rdata <= {20'd0, up_num_lines};
            14'ha: up_rdata <= {20'd0, up_num_px_p_line};
            14'hb: up_rdata <= {31'd0, up_custom_timestamp};
            14'hc: up_rdata <= {31'd0, up_custom_timestamp_96b};
            14'hd: up_rdata <= {31'd0, up_timestamp_s_eof};
            14'he: up_rdata <= {31'd0, up_timestamp_network_pwm_genval};
            default: up_rdata <= 0;
          endcase
        end else begin
          up_rdata <= 32'd0;
        end
      end
    end
  end

  assign dest_addr_hb = up_dest_addr_hb;
  assign dest_addr_lb = up_dest_addr_lb;
  assign source_addr_hb = up_source_addr_hb;
  assign source_addr_lb = up_source_addr_lb;
  assign dest_ip_addr = up_dest_ip_addr;
  assign src_ip_addr = up_src_ip_addr;
  assign dest_ip_addr = up_dest_ip_addr;
  assign ip_qos = up_ip_qos;
  assign udp_src_port = up_udp_src_port;
  assign udp_dest_port = up_udp_dest_port;
  assign num_lines = up_num_lines;
  assign num_px_p_line = up_num_px_p_line;
  assign custom_timestamp = up_custom_timestamp;
  assign custom_timestamp_96b = up_custom_timestamp_96b;
  assign timestamp_s_eof = up_timestamp_s_eof;
  assign timestamp_network_pwm_genval = up_timestamp_network_pwm_genval;

endmodule