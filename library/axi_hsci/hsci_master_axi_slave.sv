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

module hsci_master_axi_slave #(
  parameter integer REGMAP_ADDR_WIDTH  = 10
) (
  input  wire                                 axi_clk,
  input  wire                                 axi_resetn,

  axi4_lite.slave                             axi,

  output  wire [REGMAP_ADDR_WIDTH-1:0]        regmap_raddr,
  output  wire                                regmap_rd_en,
  output  wire [REGMAP_ADDR_WIDTH-1:0]        regmap_waddr,
  output  wire [31:0]                         regmap_wdata,
  output  wire                                regmap_wr_en,
  input   wire [31:0]                         regmap_rdata,

  output  wire [REGMAP_ADDR_WIDTH-1:0]        bram_addr,
  output  wire [31:0]                         bram_wdata,
  input        [31:0]                         bram_rdata,
  output  wire                                bram_we
);

  localparam                        AXI_STATE_WIDTH      = 3;
  localparam [AXI_STATE_WIDTH-1:0]  AXI_STATE_IDLE       = 0;
  localparam [AXI_STATE_WIDTH-1:0]  AXI_STATE_WRD        = 1;
  localparam [AXI_STATE_WIDTH-1:0]  AXI_STATE_WRR        = 2;
  localparam [AXI_STATE_WIDTH-1:0]  AXI_STATE_RDD        = 3;  // gives us 2 cyc latency to latch the data
  localparam [AXI_STATE_WIDTH-1:0]  AXI_STATE_DELAY_RDR  = 4;  // gives us another 1 cycle latency
  localparam [AXI_STATE_WIDTH-1:0]  AXI_STATE_RDR        = 5;
  localparam [17:0]                 BRAM_END             = 'h8000;

  reg  [AXI_STATE_WIDTH-1:0]        axi_last, axi_curr, axi_next;

  reg [REGMAP_ADDR_WIDTH-1:0]       regaddr;
  reg [31:0]                        regdata;
  reg                               en_bram;
  reg                               en_regmap;

  wire   axi_rdd        = (axi_curr == AXI_STATE_RDD);
  assign axi.awready    = (axi_curr == AXI_STATE_IDLE);
  assign axi.arready    = (axi_curr == AXI_STATE_IDLE);
  assign axi.wready     = (axi_curr == AXI_STATE_WRD);
  assign axi.bvalid     = (axi_curr == AXI_STATE_WRR);
  assign axi.rvalid     = (axi_curr == AXI_STATE_RDR);
  assign axi.bresp      = 2'b00;
  assign axi.rresp      = 2'b00;

  assign axi.rdata      = (en_bram) ? bram_rdata:regdata;

  assign regmap_waddr   = regaddr;
  assign regmap_wdata   = regdata;
  assign regmap_wr_en   = en_regmap & (axi_last == AXI_STATE_WRD) & (axi_curr == AXI_STATE_WRR);
  assign regmap_raddr   = regaddr;
  assign regmap_rd_en   = en_regmap & (axi_last == AXI_STATE_IDLE) & (axi_curr == AXI_STATE_RDD);

  assign bram_addr      = regaddr - 16'b1; // to map BRAM start at address  'h0000
  assign bram_wdata     = regdata;

  assign bram_we        = en_bram & (axi_last == AXI_STATE_WRD) & (axi_curr == AXI_STATE_WRR) ;

  always @(posedge axi_clk) axi_last  <= axi_curr;
  always @(posedge axi_clk) axi_curr  <= ~axi_resetn ? AXI_STATE_IDLE : axi_next;
  always @* begin
    axi_next = AXI_STATE_IDLE;
    case(axi_curr)
    AXI_STATE_IDLE  : axi_next  = (axi.awvalid & axi.awready)
    ? AXI_STATE_WRD
    : (axi.arvalid & axi.arready) ? AXI_STATE_RDD : AXI_STATE_IDLE;
    AXI_STATE_WRD   : axi_next  = axi.wvalid ? AXI_STATE_WRR  : AXI_STATE_WRD;
    AXI_STATE_WRR   : axi_next  = axi.bready ? AXI_STATE_IDLE : AXI_STATE_WRR;
    AXI_STATE_RDD   : axi_next  = AXI_STATE_DELAY_RDR;
    AXI_STATE_DELAY_RDR :  axi_next  = AXI_STATE_RDR;
    AXI_STATE_RDR   : axi_next  = axi.rready ? AXI_STATE_IDLE : AXI_STATE_RDR;
  endcase
  end

  always @(posedge axi_clk)
    regaddr  <= ~axi_resetn ? {REGMAP_ADDR_WIDTH{1'b0}}: (axi.awvalid & axi.awready) ? axi.awaddr[2+:REGMAP_ADDR_WIDTH]
    : (axi.arvalid & axi.arready) ? axi.araddr[2+:REGMAP_ADDR_WIDTH] : regaddr;

  always @(posedge axi_clk) regdata  <= (axi.wvalid & axi.wready) ? axi.wdata : (axi_rdd ? regmap_rdata : regdata);

  // Decode Logic
  always @(posedge axi_clk) begin
    if((regaddr == 'h00000) | (regaddr > BRAM_END)) begin
      en_bram   <= 0;
      en_regmap <= 1;
    end else begin
      en_bram   <= 1;
      en_regmap <= 0;
    end
  end

endmodule
