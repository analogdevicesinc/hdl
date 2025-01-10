// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

`timescale 1ps / 1ps

module raw2udp #(
  parameter INPUT_WIDTH = 2048,
  parameter OUTPUT_WIDTH = 512
) (
  input  wire                      input_clk,
  input  wire                      input_rstn,

  input  wire                      output_clk,
  input  wire                      output_rstn,

  input  wire                      input_axis_tvalid,
  input  wire [INPUT_WIDTH-1:0]    input_axis_tdata,

  input  wire                      output_axis_tready,
  output reg                       output_axis_tvalid,
  output reg  [OUTPUT_WIDTH-1:0]   output_axis_tdata,
  output reg                       output_axis_tlast,
  output reg  [OUTPUT_WIDTH/8-1:0] output_axis_tkeep,

  // User Interface signals for 100G Controller
  input  wire                      s_axi_aresetn,
  input  wire                      s_axi_aclk,
  input  wire                      s_axi_awvalid,
  input  wire [10:0]               s_axi_awaddr,
  output wire                      s_axi_awready,
  input  wire [31:0]               s_axi_wdata,
  input  wire [3:0]                s_axi_wstrb,
  input  wire                      s_axi_wvalid,
  output wire                      s_axi_wready,
  output wire [1:0]                s_axi_bresp,
  output wire                      s_axi_bvalid,
  input  wire                      s_axi_bready,
  input  wire [10:0]               s_axi_araddr,
  input  wire                      s_axi_arvalid,
  output wire                      s_axi_arready,
  output wire [31:0]               s_axi_rdata,
  output wire [1:0]                s_axi_rresp,
  output wire                      s_axi_rvalid,
  input  wire                      s_axi_rready
);

  ////----------------------------------------Packetizer--------------------//
  //////////////////////////////////////////////////
  reg  [7:0] sample_counter;
  reg  [7:0] counter_limit = 8'd4;
  reg        packet_tlast;

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      sample_counter <= 8'd1;
      packet_tlast <= 1'b0;
    end else begin
      if (input_axis_tvalid) begin
        if (sample_counter < counter_limit-1) begin
          sample_counter <= sample_counter + 1;
          packet_tlast <= 1'b0;
        end else begin
          sample_counter <= 8'd0;
          packet_tlast <= 1'b1;
        end
      end
    end
  end
  
  ////----------------------------------------CDC and Scaling FIFO----------//
  //////////////////////////////////////////////////
  wire                    cdc_axis_tvalid;
  wire                    cdc_axis_tready;
  wire [OUTPUT_WIDTH-1:0] cdc_axis_tdata;
  wire                    cdc_axis_tlast;

  util_axis_fifo_asym #(
    .ASYNC_CLK(1),
    .S_DATA_WIDTH(INPUT_WIDTH),
    .ADDRESS_WIDTH(4),
    .M_DATA_WIDTH(OUTPUT_WIDTH),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(0),
    .ALMOST_FULL_THRESHOLD(0),
    .TLAST_EN(1),
    .TKEEP_EN(0),
    .FIFO_LIMITED(0),
    .ADDRESS_WIDTH_PERSPECTIVE(1)
  ) fifo_tx (
    .m_axis_aclk(output_clk),
    .m_axis_aresetn(output_rstn),
    .m_axis_ready(cdc_axis_tready),
    .m_axis_valid(cdc_axis_tvalid),
    .m_axis_data(cdc_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tlast(cdc_axis_tlast),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_level(),
  
    .s_axis_aclk(input_clk),
    .s_axis_aresetn(input_rstn),
    .s_axis_ready(),
    .s_axis_valid(input_axis_tvalid),
    .s_axis_data(input_axis_tdata),
    .s_axis_tkeep(),
    .s_axis_tlast(packet_tlast),
    .s_axis_full(),
    .s_axis_almost_full(),
    .s_axis_room()
  );
  
  ////----------------------------------------Header Inserter---------------//
  //////////////////////////////////////////////////
  reg  [31:0]               header = 32'h1234dead;
  reg  [31:0]               cdc_axis_tdata_reg;

  reg                       new_packet;
  reg                       tlast_sig;

  reg                       packet_axis_tvalid;
  reg                       packet_axis_tready;
  reg  [OUTPUT_WIDTH-1:0]   packet_axis_tdata;
  reg  [OUTPUT_WIDTH/8-1:0] packet_axis_tkeep;
  reg                       packet_axis_tlast;

  // temporary storage
  always @(posedge output_clk)
  begin
    if (!output_rstn) begin
      cdc_axis_tdata_reg <= 32'b0;
    end else begin
      if (cdc_axis_tvalid) begin
        cdc_axis_tdata_reg <= cdc_axis_tdata[OUTPUT_WIDTH-1:OUTPUT_WIDTH-32];
      end
    end
  end

  // header insertion
  assign cdc_axis_tready = ~tlast_sig;

  always @(posedge output_clk)
  begin
    if (!output_rstn) begin
      tlast_sig <= 1'b0;
    end else begin
      if (cdc_axis_tvalid) begin
        tlast_sig <= cdc_axis_tlast;
      end else begin
        tlast_sig <= 1'b0;
      end
    end
  end

  always @(posedge output_clk)
  begin
    if (!output_rstn) begin
      new_packet <= 1'b1;
    end else begin
      if (tlast_sig) begin
        new_packet <= 1'b1;
      end else if (cdc_axis_tvalid) begin
        new_packet <= 1'b0;
      end
    end
  end

  always @(posedge output_clk)
  begin
    if (!output_rstn) begin
      packet_axis_tvalid <= 1'b0;
      packet_axis_tdata <= {OUTPUT_WIDTH-1{1'b0}};
      packet_axis_tkeep <= {OUTPUT_WIDTH/8-1{1'b0}};
      packet_axis_tlast <= 1'b0;
    end else begin
      // valid
      if (cdc_axis_tvalid || tlast_sig) begin
        packet_axis_tvalid <= 1'b1;
      end else begin
        packet_axis_tvalid <= 1'b0;
      end
      // last
      packet_axis_tlast <= tlast_sig;
      // data and keep
      if (cdc_axis_tvalid) begin
        if (new_packet) begin
          packet_axis_tdata <= {cdc_axis_tdata[OUTPUT_WIDTH-1-32:0], header};
          packet_axis_tkeep <= {OUTPUT_WIDTH/8{1'b1}};
        end else begin
          packet_axis_tdata <= {cdc_axis_tdata[OUTPUT_WIDTH-1-32:0], cdc_axis_tdata_reg};
          packet_axis_tkeep <= {OUTPUT_WIDTH/8{1'b1}};
        end
      end else if (tlast_sig) begin
        packet_axis_tdata <= {{OUTPUT_WIDTH-32{1'b0}}, cdc_axis_tdata_reg};
        packet_axis_tkeep <= {{OUTPUT_WIDTH-32{1'b0}}, {32/8{1'b1}}};
      end
    end
  end
  
  ////----------------------------------------Register----------------------//
  //////////////////////////////////////////////////
  always @(posedge output_clk)
  begin
    // output_axis_tready <= packet_axis_tready;
    output_axis_tvalid <= packet_axis_tvalid;
    output_axis_tdata <= packet_axis_tdata;
    output_axis_tkeep <= packet_axis_tkeep;
    output_axis_tlast <= packet_axis_tlast;
  end

  ////----------------------------------------AXI Interface-----------------//
  //////////////////////////////////////////////////
  reg [31:0] regmap [4:0];

  wire            up_wreq;
  wire [(11-3):0] up_waddr;
  wire [31:0]     up_wdata;
  reg             up_wack;
  wire            up_rreq;
  wire [(11-3):0] up_raddr;
  reg  [31:0]     up_rdata;
  reg             up_rack;

  integer i;

  always @(posedge s_axi_aclk)
  begin
    if (s_axi_aresetn == 1'b0)
    begin
      up_wack <= 1'b0;
      up_rack <= 1'b0;
      for (i=0; i<4; i=i+1) begin
        regmap[i] <= 32'd0;
      end
    end else begin
      up_wack <= up_wreq;
      up_rack <= up_rreq;

      if (up_wreq == 1'b1 && up_waddr[(11-3):3] == 0) begin
        regmap[up_waddr[2:0]] <= up_wdata;
      end

      if (up_rreq == 1'b1) begin
        if (up_raddr[(11-3):3] == 0) begin
          up_rdata <= regmap[up_raddr[2:0]];
        end else begin
          up_rdata <= 32'd0;
        end
      end
    end
  end

  up_axi #(
    .AXI_ADDRESS_WIDTH(11)
  ) i_up_axi (
    .up_rstn            (s_axi_aresetn),
    .up_clk             (s_axi_aclk),
    .up_axi_awvalid     (s_axi_awvalid),
    .up_axi_awaddr      (s_axi_awaddr),
    .up_axi_awready     (s_axi_awready),
    .up_axi_wvalid      (s_axi_wvalid),
    .up_axi_wdata       (s_axi_wdata),
    .up_axi_wstrb       (s_axi_wstrb),
    .up_axi_wready      (s_axi_wready),
    .up_axi_bvalid      (s_axi_bvalid),
    .up_axi_bresp       (s_axi_bresp),
    .up_axi_bready      (s_axi_bready),
    .up_axi_arvalid     (s_axi_arvalid),
    .up_axi_araddr      (s_axi_araddr),
    .up_axi_arready     (s_axi_arready),
    .up_axi_rvalid      (s_axi_rvalid),
    .up_axi_rresp       (s_axi_rresp),
    .up_axi_rdata       (s_axi_rdata),
    .up_axi_rready      (s_axi_rready),
    .up_wreq            (up_wreq),
    .up_waddr           (up_waddr),
    .up_wdata           (up_wdata),
    .up_wack            (up_wack),
    .up_rreq            (up_rreq),
    .up_raddr           (up_raddr),
    .up_rdata           (up_rdata),
    .up_rack            (up_rack)
  );

endmodule
