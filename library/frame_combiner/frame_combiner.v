// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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

module frame_combiner #(
    parameter PIXELS_PER_CLOCK = 2,
    parameter DATA_WIDTH = 32*PIXELS_PER_CLOCK
)(
  input                   axis_resetn,

  output                  fsync_fb,

  input                   s_in_axis_aclk,
  output                  s_in_axis_ready,
  input                   s_in_axis_valid,
  input  [DATA_WIDTH-1:0] s_in_axis_data,
  input  [0:0]            s_in_axis_user,
  input                   s_in_axis_last,

  input                   s_fb_in_axis_aclk,
  output                  s_fb_in_axis_ready,
  input                   s_fb_in_axis_valid,
  input  [DATA_WIDTH-1:0] s_fb_in_axis_data,
  input  [0:0]            s_fb_in_axis_user,
  input                   s_fb_in_axis_last,

  input                   m_out_axis_aclk,
  input                   m_out_axis_ready,
  output                  m_out_axis_valid,
  output [DATA_WIDTH-1:0] m_out_axis_data,
  output [0:0]            m_out_axis_user,
  output                  m_out_axis_last,

  input                   m_fb_out_axis_aclk,
  input                   m_fb_out_axis_ready,
  output                  m_fb_out_axis_valid,
  output [DATA_WIDTH-1:0] m_fb_out_axis_data,
  output [0:0]            m_fb_out_axis_user,
  output                  m_fb_out_axis_last,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready
);

  reg       ctrl_enable = 1'b0;
  reg       ctrl_select = 1'h0;
  reg [1:0] init_buffer = 2'b11;

  reg             up_wack;
  reg     [31:0]  up_rdata;
  reg             up_rack;

  wire            up_wreq;
  wire    [13:0]  up_waddr;
  wire    [31:0]  up_wdata;
  wire            up_rreq;
  wire    [13:0]  up_raddr;
  wire ready;
  wire valid;
  wire [DATA_WIDTH-1:0] combined_data;

  // During first frame don't wait for data from the reader
  always @(posedge s_fb_in_axis_aclk) begin
    if (~ctrl_enable) begin
      init_buffer <= 2'b11;
    end else if (s_in_axis_user & s_in_axis_ready & s_in_axis_valid) begin
      init_buffer <= {init_buffer[0],1'b0};
    end
  end

  assign fsync_fb = s_in_axis_user & ~init_buffer[0];

  // Pixel combining logic
  genvar i,j;
  generate
    for (i=0; i< PIXELS_PER_CLOCK; i = i+1) begin : genloop
      for (j=0; j< 4; j = j+1) begin : genloop
        localparam LSB = (32*i)+(8*j);
        wire [8:0] data;
        assign data = ({1'b0,s_fb_in_axis_data[LSB +: 8]} -
                       {4'b0,s_fb_in_axis_data[LSB+3 +: 8-3]}) +    // 7/8
                      {4'b0,s_in_axis_data[LSB+3 +: 8-3]};          // 1/8
        assign combined_data[LSB +: 8] = data[7:0];
      end
    end
  endgenerate

  splitter #(
   .NUM_M(2)
  ) out_splitter (

  .clk (s_in_axis_aclk),
  .resetn (axis_resetn),

  .s_valid (valid),
  .s_ready (ready),

  .m_valid ({m_out_axis_valid,m_fb_out_axis_valid}),
  .m_ready ({m_out_axis_ready,m_fb_out_axis_ready})
  );

  // uP interface

  up_axi i_up_axi (
  .up_rstn (s_axi_aresetn),
  .up_clk (s_axi_aclk),
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
  .up_wreq (up_wreq),
  .up_waddr (up_waddr),
  .up_wdata (up_wdata),
  .up_wack (up_wack),
  .up_rreq (up_rreq),
  .up_raddr (up_raddr),
  .up_rdata (up_rdata),
  .up_rack (up_rack));

  // Register Interface

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      ctrl_enable <= 1'b0;
      ctrl_select <= 1'h0;
      up_wack <= 1'b0;
    end else begin
      up_wack <= up_wreq;

      if (up_wreq == 1'b1) begin
        case (up_waddr)
          14'h100: {ctrl_select, ctrl_enable} <= up_wdata[1:0];
        endcase
      end
    end
  end

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_rack <= 'd0;
    end else begin
      up_rack <= up_rreq;
    end
  end

  always @(posedge s_axi_aclk) begin
    if (up_rreq == 1'b1) begin
      case (up_raddr)
        14'h100: up_rdata <= {30'h0, ctrl_select, ctrl_enable};
        default: up_rdata <= 'h0;
      endcase
    end
  end

  assign m_out_axis_data  = ctrl_select ? s_in_axis_data : combined_data;
  assign m_out_axis_last  = s_in_axis_last & s_fb_in_axis_last;
  assign m_out_axis_user  = s_in_axis_user;

  assign m_fb_out_axis_data  = combined_data;
  assign m_fb_out_axis_last  = s_in_axis_last;
  assign m_fb_out_axis_user  = m_out_axis_user;

  assign s_in_axis_ready    = ready & valid & ctrl_enable;
  assign s_fb_in_axis_ready = ready & valid & ctrl_enable;
  assign valid = s_in_axis_valid & (s_fb_in_axis_valid |
                                    init_buffer == 2'b11 |
                                    ((init_buffer == 2'b10) & ~s_in_axis_user));

endmodule
