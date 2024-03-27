// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2024 Analog Devices, Inc. All rights reserved.
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

module axi_selmap #(
  parameter DATA_WIDTH = 8
) (

  // select map interface
  output  [DATA_WIDTH-1:0] data,
  output                   cclk,
  output                   program_b,
  output                   rdwr_b,
  output                   csi_b,
  input                    init_b,
  input                    done,

  // axi interface
  input                    s_axi_aclk,
  input                    s_axi_aresetn,
  input                    s_axi_awvalid,
  input   [15:0]           s_axi_awaddr,
  input   [ 2:0]           s_axi_awprot,
  output                   s_axi_awready,
  input                    s_axi_wvalid,
  input   [31:0]           s_axi_wdata,
  input   [ 3:0]           s_axi_wstrb,
  output                   s_axi_wready,
  output                   s_axi_bvalid,
  output  [ 1:0]           s_axi_bresp,
  input                    s_axi_bready,
  input                    s_axi_arvalid,
  input   [15:0]           s_axi_araddr,
  input   [ 2:0]           s_axi_arprot,
  output                   s_axi_arready,
  output                   s_axi_rvalid,
  output  [ 1:0]           s_axi_rresp,
  output  [31:0]           s_axi_rdata,
  input                    s_axi_rready
);

  // internal signals
  wire           up_clk;
  wire           up_rstn;
  wire           up_rreq_s;
  wire           up_wack_s;
  wire           up_rack_s;
  wire   [13:0]  up_raddr_s;
  wire   [31:0]  up_rdata_s;
  wire           up_wreq_s;
  wire   [13:0]  up_waddr_s;
  wire   [31:0]  up_wdata_s;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  wire                    up_reset;
  wire   [DATA_WIDTH-1:0] up_data;
  wire                    up_data_written;
  wire                    up_csi_b;
  wire                    up_program_b;
  wire                    up_cclk;
  reg                     up_init_b;
  reg                     up_device_ready;
  reg                     up_done;

  reg                     prev_init_b;

  assign up_cclk = up_clk; // For now use the axi clk

  always @(posedge up_clk) begin
    if (!up_rstn || !up_reset) begin
      up_done <= 1'b0;
      prev_init_b <= 1'b1;
      up_init_b <= 1'b1;
      up_device_ready <= 1'b0;
    end else begin
      up_done <= done;
      up_init_b <= init_b;
      prev_init_b <= up_init_b;
    end

    if (prev_init_b && !up_init_b) begin
      up_device_ready <= 1'b1;
    end
  end

  axi_selmap_regmap #(
    .DATA_WIDTH (DATA_WIDTH)
  ) i_regmap (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s),
    .device_ready (up_device_ready),
    .done (up_done),
    .reset (up_reset),
    .data (up_data),
    .data_written (up_data_written),
    .csi_b (up_csi_b),
    .program_b (up_program_b)
  );

  up_axi  #(
    .AXI_ADDRESS_WIDTH (16)
  ) i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  assign rdwr_b    = 1'b0;
  assign csi_b     = up_csi_b;
  assign program_b = up_program_b;
  assign cclk      = up_cclk & up_data_written;

  /* Selmap bit mapping */
  genvar i;
  generate if (DATA_WIDTH >= 8) begin
    for (i = 0; i < 8; i = i + 1) begin
      assign data[7-i] = up_data[i];
    end
  end
  endgenerate
  generate if (DATA_WIDTH >= 16) begin
    for (i = 0; i < 8; i = i + 1) begin
      assign data[15-i] = up_data[8+i];
    end
  end
  endgenerate
  generate if (DATA_WIDTH == 32) begin
    for (i = 0; i < 8; i = i + 1) begin
      assign data[23-i] = up_data[16+i];
      assign data[31-i] = up_data[24+i];
    end
  end
  endgenerate
endmodule
