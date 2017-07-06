// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

module axi_dacfifo_dac #(

  parameter   AXI_DATA_WIDTH = 512,
  parameter   AXI_LENGTH = 15,
  parameter   DAC_DATA_WIDTH = 64) (

  input                   axi_clk,
  input                   axi_dvalid,
  input       [(AXI_DATA_WIDTH-1):0]  axi_ddata,
  output  reg             axi_dready,
  input                   axi_dlast,
  input                   axi_xfer_req,

  input       [ 3:0]      dma_last_beats,

  input                   dac_clk,
  input                   dac_rst,
  input                   dac_valid,
  output      [(DAC_DATA_WIDTH-1):0]  dac_data,
  output                  dac_xfer_out,
  output  reg             dac_dunf);


  localparam  MEM_RATIO = AXI_DATA_WIDTH/DAC_DATA_WIDTH;
  localparam  DAC_ADDRESS_WIDTH = 10;
  localparam  AXI_ADDRESS_WIDTH = (MEM_RATIO == 1) ? DAC_ADDRESS_WIDTH :
                                  (MEM_RATIO == 2) ? (DAC_ADDRESS_WIDTH - 1) :
                                  (MEM_RATIO == 4) ? (DAC_ADDRESS_WIDTH - 2) :
                                                     (DAC_ADDRESS_WIDTH - 3);

  localparam  AXI_BUF_THRESHOLD_LO = 3 * (AXI_LENGTH+1);
  localparam  AXI_BUF_THRESHOLD_HI = {(AXI_ADDRESS_WIDTH){1'b1}} - (AXI_LENGTH+1);
  localparam  DAC_BUF_THRESHOLD_LO = 3 * (AXI_LENGTH+1) * MEM_RATIO;
  localparam  DAC_BUF_THRESHOLD_HI = {(DAC_ADDRESS_WIDTH){1'b1}} - (AXI_LENGTH+1) * MEM_RATIO;
  localparam  DAC_ARINCR = (AXI_LENGTH+1) * MEM_RATIO;

  // internal registers

  reg     [(AXI_ADDRESS_WIDTH-1):0]   axi_mem_waddr = 'd0;
  reg     [(AXI_ADDRESS_WIDTH-1):0]   axi_mem_laddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_waddr_g = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_laddr_g = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_raddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_raddr_m1 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_raddr_m2 = 'd0;
  reg     [(AXI_ADDRESS_WIDTH-1):0]   axi_mem_addr_diff = 'd0;

  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_raddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_raddr_g = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_waddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_waddr_m1 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_waddr_m2 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_laddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_laddr_m1 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_laddr_m2 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_addr_diff = 'd0;
  reg                                 dac_mem_init = 1'b0;
  reg                                 dac_mem_init_d = 1'b0;
  reg                                 dac_mem_enable = 1'b0;

  reg     [ 2:0]                      dac_xfer_req_m = 3'b0;
  reg                                 dac_xfer_init = 1'b0;

  reg     [ 3:0]                      dac_last_beats = 4'b0;
  reg     [ 3:0]                      dac_last_beats_m = 4'b0;
  reg     [ 3:0]                      dac_beat_cnt = 4'b0;
  reg                                 dac_dlast = 1'b0;
  reg                                 dac_dlast_m1 = 1'b0;
  reg                                 dac_dlast_m2 = 1'b0;
  reg                                 dac_dlast_inmem = 1'b0;
  reg                                 dac_mem_valid = 1'b0;

  // internal signals

  wire    [AXI_ADDRESS_WIDTH:0]     axi_mem_addr_diff_s;
  wire    [(AXI_ADDRESS_WIDTH-1):0] axi_mem_raddr_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0] axi_mem_waddr_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0] axi_mem_laddr_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0] axi_mem_waddr_b2g_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0] axi_mem_laddr_b2g_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0] axi_mem_raddr_m2_g2b_s;

  wire    [DAC_ADDRESS_WIDTH:0]     dac_mem_addr_diff_s;
  wire                              dac_xfer_init_s;
  wire                              dac_last_axi_beats_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0] dac_mem_raddr_b2g_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0] dac_mem_waddr_m2_g2b_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0] dac_mem_laddr_m2_g2b_s;

  // write interface

  always @(posedge axi_clk) begin
    if (axi_xfer_req == 1'b0) begin
      axi_mem_waddr <= 'd0;
      axi_mem_waddr_g <= 'd0;
      axi_mem_laddr <= {AXI_ADDRESS_WIDTH{1'b1}};
    end else begin
      if (axi_dvalid == 1'b1) begin
        axi_mem_waddr <= axi_mem_waddr + 1'b1;
        axi_mem_laddr <= (axi_dlast == 1'b1) ? axi_mem_waddr : axi_mem_laddr;
      end
      axi_mem_waddr_g <= axi_mem_waddr_b2g_s;
      axi_mem_laddr_g <= axi_mem_laddr_b2g_s;
    end
  end

  ad_b2g # (
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_axi_mem_waddr_b2g (
    .din (axi_mem_waddr_s),
    .dout (axi_mem_waddr_b2g_s));

  ad_b2g # (
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_axi_mem_laddr_b2g (
    .din (axi_mem_laddr_s),
    .dout (axi_mem_laddr_b2g_s));

  // scale the axi_mem_* addresses

  assign axi_mem_raddr_s = (MEM_RATIO == 1) ? axi_mem_raddr :
                           (MEM_RATIO == 2) ? axi_mem_raddr[(DAC_ADDRESS_WIDTH-1):1] :
                           (MEM_RATIO == 4) ? axi_mem_raddr[(DAC_ADDRESS_WIDTH-1):2] :
                                              axi_mem_raddr[(DAC_ADDRESS_WIDTH-1):3];
  assign axi_mem_waddr_s = (MEM_RATIO == 1) ? axi_mem_waddr :
                           (MEM_RATIO == 2) ? {axi_mem_waddr, 1'b0} :
                           (MEM_RATIO == 4) ? {axi_mem_waddr, 2'b0} :
                                              {axi_mem_waddr, 3'b0};
   assign axi_mem_laddr_s = (MEM_RATIO == 1) ? axi_mem_laddr :
                            (MEM_RATIO == 2) ? {axi_mem_laddr, 1'b0} :
                            (MEM_RATIO == 4) ? {axi_mem_laddr, 2'b0} :
                                               {axi_mem_laddr, 3'b0};

  // incomming data flow control

  assign axi_mem_addr_diff_s = {1'b1, axi_mem_waddr} - axi_mem_raddr_s;

  always @(posedge axi_clk) begin
    if (axi_xfer_req == 1'b0) begin
      axi_mem_addr_diff <= 'd0;
      axi_mem_raddr <= 'd0;
      axi_mem_raddr_m1 <= 'd0;
      axi_mem_raddr_m2 <= 'd0;
      axi_dready <= 'd0;
    end else begin
      axi_mem_raddr_m1 <= dac_mem_raddr_g;
      axi_mem_raddr_m2 <= axi_mem_raddr_m1;
      axi_mem_raddr <= axi_mem_raddr_m2_g2b_s;
      axi_mem_addr_diff <= axi_mem_addr_diff_s[AXI_ADDRESS_WIDTH-1:0];
      if (axi_mem_addr_diff >= AXI_BUF_THRESHOLD_HI) begin
        axi_dready <= 1'b0;
      end else if (axi_mem_addr_diff <= AXI_BUF_THRESHOLD_LO) begin
        axi_dready <= 1'b1;
      end
    end
  end

  ad_g2b #(
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_axi_mem_raddr_m2_g2b (
    .din (axi_mem_raddr_m2),
    .dout (axi_mem_raddr_m2_g2b_s));

  // CDC for xfer_req signal

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_xfer_req_m <= 3'b0;
    end else begin
      dac_xfer_req_m <= {dac_xfer_req_m[1:0], axi_xfer_req};
    end
  end

  assign dac_xfer_out = dac_xfer_req_m[2];
  assign dac_xfer_init_s = ~dac_xfer_req_m[2] & dac_xfer_req_m[1];

  // read interface

  always @(posedge dac_clk) begin
    if (dac_xfer_out == 1'b0) begin
      dac_mem_init <= 1'b0;
      dac_mem_init_d <= 1'b0;
      dac_mem_enable <= 1'b0;
    end else begin
      if (dac_xfer_init == 1'b1) begin
        dac_mem_init <= 1'b1;
      end
      if ((dac_mem_init == 1'b1) && (dac_mem_addr_diff > DAC_BUF_THRESHOLD_LO)) begin
        dac_mem_init <= 1'b0;
      end
      dac_mem_init_d <= dac_mem_init;
      // memory is ready when the initial fill up is done
      dac_mem_enable <= (dac_mem_init_d & ~dac_mem_init) ? 1'b1 : dac_mem_enable;
    end
    dac_xfer_init <= dac_xfer_init_s;
  end

  always @(posedge dac_clk) begin
    if (dac_xfer_out == 1'b0) begin
      dac_mem_waddr <= 'b0;
      dac_mem_waddr_m1 <= 'b0;
      dac_mem_waddr_m2 <= 'b0;
      dac_mem_laddr <= 'b0;
      dac_mem_laddr_m1 <= 'b0;
      dac_mem_laddr_m2 <= 'b0;
      dac_dlast <= 1'b0;
      dac_dlast_m1 <= 1'b0;
      dac_dlast_m2 <= 1'b0;
    end else begin
      dac_mem_waddr_m1 <= axi_mem_waddr_g;
      dac_mem_waddr_m2 <= dac_mem_waddr_m1;
      dac_mem_waddr <= dac_mem_waddr_m2_g2b_s;
      dac_mem_laddr_m1 <= axi_mem_laddr_g;
      dac_mem_laddr_m2 <= dac_mem_laddr_m1;
      dac_mem_laddr <= dac_mem_laddr_m2_g2b_s;
      dac_dlast_m1 <= axi_dlast;
      dac_dlast_m2 <= dac_dlast_m1;
      dac_dlast <= dac_dlast_m2;
    end
  end

  ad_g2b #(
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_dac_mem_waddr_m2_g2b (
    .din (dac_mem_waddr_m2),
    .dout (dac_mem_waddr_m2_g2b_s));

  ad_g2b #(
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_dac_mem_laddr_m2_g2b (
    .din (dac_mem_laddr_m2),
    .dout (dac_mem_laddr_m2_g2b_s));

  assign dac_mem_addr_diff_s = {1'b1, dac_mem_waddr} - dac_mem_raddr;
  always @(posedge dac_clk) begin
    dac_mem_valid <= (dac_mem_enable) ? dac_valid : 1'b0;
  end

  // CDC for the dma_last_beats

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_last_beats <= 32'b0;
      dac_last_beats_m <= 32'b0;
    end else begin
      dac_last_beats_m <= dma_last_beats;
      dac_last_beats <= dac_last_beats_m;
    end
  end

  // If the MEM_RATIO is grater than one, it can happen that not all the DAC beats from
  // an AXI beat are valid. In this case the invalid data is dropped.
  // The axi_dlast indicates the last AXI beat. The valid number of DAC beats on the last AXI beat
  // commes from the AXI write module. (axi_dacfifo_wr.v)

  assign dac_last_axi_beats_s = ((dac_dlast_inmem == 1'b1) && (dac_mem_raddr >= dac_mem_laddr) && (dac_mem_raddr < dac_mem_laddr + MEM_RATIO)) ? 1'b1 : 1'b0;

  always @(posedge dac_clk) begin
    if (dac_xfer_out == 1'b0) begin
      dac_mem_raddr <= 'd0;
      dac_beat_cnt <= 'd0;
      dac_dlast_inmem <= 1'b0;
    end else begin
      if (dac_dlast == 1'b1) begin
        dac_dlast_inmem <= 1'b1;
      end else if (dac_mem_raddr == dac_mem_laddr + MEM_RATIO) begin
        dac_dlast_inmem <= 1'b0;
      end
      if (dac_mem_valid == 1'b1) begin
        dac_beat_cnt <= ((dac_beat_cnt >= MEM_RATIO-1) ||
                         ((dac_last_beats > 1'b1) && (dac_last_axi_beats_s > 1'b0) && (dac_beat_cnt == dac_last_beats-1))) ? 0 : dac_beat_cnt + 1;
        dac_mem_raddr <= ((dac_last_axi_beats_s) && (dac_beat_cnt == dac_last_beats-1)) ? (dac_mem_laddr + MEM_RATIO) : dac_mem_raddr + 1'b1;
      end
      dac_mem_raddr_g <= dac_mem_raddr_b2g_s;
    end
  end

  ad_b2g # (
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_dac_mem_raddr_b2g (
    .din (dac_mem_raddr),
    .dout (dac_mem_raddr_b2g_s));

  // underflow generation, there is no overflow

  always @(posedge dac_clk) begin
    if(dac_xfer_out == 1'b0) begin
      dac_mem_addr_diff <= 'b0;
      dac_dunf <= 1'b0;
    end else begin
      dac_mem_addr_diff <= dac_mem_addr_diff_s[DAC_ADDRESS_WIDTH-1:0];
      dac_dunf <= (dac_mem_addr_diff == 1'b0) ? 1'b1 : 1'b0;
    end
  end

  // instantiations

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (AXI_ADDRESS_WIDTH),
    .A_DATA_WIDTH (AXI_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DAC_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DAC_DATA_WIDTH))
  i_mem_asym (
    .clka (axi_clk),
    .wea (axi_dvalid),
    .addra (axi_mem_waddr),
    .dina (axi_ddata),
    .clkb (dac_clk),
    .addrb (dac_mem_raddr),
    .doutb (dac_data));

endmodule

// ***************************************************************************
// ***************************************************************************

