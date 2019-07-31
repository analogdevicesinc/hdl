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

module axi_dacfifo_rd #(

  parameter   AXI_DATA_WIDTH = 512,
  parameter   AXI_SIZE = 2,
  parameter   AXI_LENGTH = 15,
  parameter   AXI_ADDRESS = 32'h00000000,
  parameter   DAC_DATA_WIDTH = 64,
  parameter   DAC_MEM_ADDRESS_WIDTH = 8) (

 // xfer last for read/write synchronization

  input                               axi_xfer_req,
  input       [31:0]                  axi_last_raddr,
  input       [ 7:0]                  axi_last_beats,

  // axi read address and read data channels

  input                               axi_clk,
  input                               axi_resetn,
  output  reg                         axi_arvalid,
  output      [ 3:0]                  axi_arid,
  output      [ 1:0]                  axi_arburst,
  output                              axi_arlock,
  output      [ 3:0]                  axi_arcache,
  output      [ 2:0]                  axi_arprot,
  output      [ 3:0]                  axi_arqos,
  output      [ 7:0]                  axi_arlen,
  output      [ 2:0]                  axi_arsize,
  output  reg [31:0]                  axi_araddr,
  input                               axi_arready,
  input                               axi_rvalid,
  input       [ 3:0]                  axi_rid,
  input       [ 1:0]                  axi_rresp,
  input                               axi_rlast,
  input       [(AXI_DATA_WIDTH-1):0]  axi_rdata,
  output  reg                         axi_rready,

  // axi status

  output  reg                         axi_rerror,

  // DAC interface

  input       [ 3:0]                  dma_last_beats,

  input                               dac_clk,
  input                               dac_rst,
  input                               dac_valid,
  output      [(DAC_DATA_WIDTH-1):0]  dac_data,
  output                              dac_xfer_out,
  output  reg                         dac_dunf);

  localparam  AXI_BYTE_WIDTH = AXI_DATA_WIDTH/8;
  localparam  AXI_ARINCR = (AXI_LENGTH + 1) * AXI_BYTE_WIDTH;
  localparam  MEM_RATIO = AXI_DATA_WIDTH/DAC_DATA_WIDTH;
  localparam  AXI_MEM_ADDRESS_WIDTH = (MEM_RATIO == 1) ? DAC_MEM_ADDRESS_WIDTH :
                                      (MEM_RATIO == 2) ? (DAC_MEM_ADDRESS_WIDTH - 1) :
                                      (MEM_RATIO == 4) ? (DAC_MEM_ADDRESS_WIDTH - 2) :
                                                         (DAC_MEM_ADDRESS_WIDTH - 3);
  localparam  AXI_BUF_THRESHOLD_HI = 2 * (AXI_LENGTH+1);
  localparam  DAC_BUF_THRESHOLD_HI = 2 * (AXI_LENGTH+1) * MEM_RATIO;

  localparam  IDLE                    = 5'b00001;
  localparam  XFER_STAGING            = 5'b00010;
  localparam  XFER_FULL_BURST         = 5'b00100;
  localparam  XFER_PARTIAL_BURST      = 5'b01000;
  localparam  XFER_END                = 5'b10000;

  // internal registers

  reg                                   axi_data_req = 1'b0;
  reg     [ 4:0]                        axi_read_state = 5'b0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0] axi_mem_waddr = 'd0;
 (* dont_touch = "true" *) reg     [(AXI_MEM_ADDRESS_WIDTH-1):0] axi_mem_laddr = 'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] axi_mem_waddr_g = 'd0;
 (* dont_touch = "true" *) reg                                  axi_mem_laddr_toggle = 1'b0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] axi_mem_raddr = 'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] axi_mem_raddr_m1 = 'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] axi_mem_raddr_m2 = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0] axi_mem_addr_diff = 'd0;
  reg     [31:0]                        axi_araddr_prev = 'd0;

  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_raddr = 'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_raddr_g = 'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_waddr = 'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_waddr_m1 = 'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_waddr_m2 = 'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_laddr = 'd0;
  reg     [ 3:0]                        dac_mem_laddr_toggle_m = 4'd0;
  reg     [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_laddr_b = 'd0;
  reg                                   dac_mem_valid = 1'b0;
  reg                                   dac_mem_enable = 1'b0;
  reg     [ 2:0]                        dac_xfer_req_m = 3'b0;
  reg     [ 3:0]                        dac_last_beats = 4'b0;
  reg     [ 3:0]                        dac_last_beats_m = 4'b0;

  // internal signals

  wire                                  axi_fifo_reset_s;
  wire                                  axi_dvalid_s;
  wire                                  axi_dlast_s;
  wire    [ AXI_MEM_ADDRESS_WIDTH:0]    axi_mem_addr_diff_s;
  wire    [(AXI_MEM_ADDRESS_WIDTH-1):0] axi_mem_raddr_s;
  wire    [(DAC_MEM_ADDRESS_WIDTH-1):0] axi_mem_waddr_s;
  wire    [(DAC_MEM_ADDRESS_WIDTH-1):0] axi_mem_laddr_s;
  wire    [(DAC_MEM_ADDRESS_WIDTH-1):0] axi_mem_waddr_b2g_s;
  wire    [(DAC_MEM_ADDRESS_WIDTH-1):0] axi_mem_raddr_m2_g2b_s;

  wire    [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_raddr_b2g_s;
  wire    [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_waddr_m2_g2b_s;
  wire    [    DAC_MEM_ADDRESS_WIDTH:0] dac_mem_addr_diff_s;
  wire    [(DAC_MEM_ADDRESS_WIDTH-1):0] dac_mem_laddr_s;

  // Asymmetric memory to transfer data from AXI_MM interface to DAC FIFO
  // interface

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (AXI_MEM_ADDRESS_WIDTH),
    .A_DATA_WIDTH (AXI_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DAC_MEM_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DAC_DATA_WIDTH))
  i_mem_asym (
    .clka (axi_clk),
    .wea (axi_dvalid_s),
    .addra (axi_mem_waddr),
    .dina (axi_rdata),
    .clkb (dac_clk),
    .reb (1'b1),
    .addrb (dac_mem_raddr),
    .doutb (dac_data));

  // reset signals

  assign axi_fifo_reset_s = (axi_resetn == 1'b0) || (axi_xfer_req == 1'b0);
  assign dac_fifo_reset_s = (dac_rst == 1'b1) || (dac_xfer_req_m[2] == 1'b0);

  // FSM to generate the all the AXI Read transactions

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_read_state <= IDLE;
    end else begin
      case (axi_read_state)
        IDLE : begin
          if (axi_data_req == 1'b1) begin
            axi_read_state <= XFER_STAGING;
          end else begin
            axi_read_state <= IDLE;
          end
        end
        XFER_STAGING : begin
          if (axi_araddr + AXI_ARINCR <= axi_last_raddr) begin
            axi_read_state <= XFER_FULL_BURST;
          end else begin
            axi_read_state <= XFER_PARTIAL_BURST;
          end
        end
        XFER_FULL_BURST : begin
          if (axi_rready && axi_rvalid && axi_rlast) begin
            if (axi_araddr_prev == axi_last_raddr) begin
              axi_read_state <= XFER_END;
            end else begin
              axi_read_state <= IDLE;
            end
          end else begin
            axi_read_state <= XFER_FULL_BURST;
          end
        end
        XFER_PARTIAL_BURST : begin
          if (axi_rready && axi_rvalid && axi_rlast) begin
            axi_read_state <= XFER_END;
          end else begin
            axi_read_state <= XFER_PARTIAL_BURST;
          end
        end
        XFER_END : begin
          axi_read_state <= IDLE;
        end
        default : begin
            axi_read_state <= IDLE;
        end
      endcase
    end
  end

  // AXI read address channel

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_arvalid <= 'd0;
      axi_araddr <= AXI_ADDRESS;
      axi_araddr_prev <= AXI_ADDRESS;
    end else begin
      if (axi_arvalid == 1'b1) begin
        if (axi_arready == 1'b1) begin
          axi_arvalid <= 1'b0;
        end
      end else begin
        if (axi_read_state == XFER_STAGING) begin
          axi_arvalid <= 1'b1;
        end
      end
      // AXI read address generation
      if ((axi_arvalid == 1'b1) && (axi_arready == 1'b1)) begin
        axi_araddr <= (axi_read_state == XFER_FULL_BURST) ? (axi_araddr + AXI_ARINCR) :
                      (axi_read_state == XFER_PARTIAL_BURST) ? AXI_ADDRESS : axi_araddr;
        axi_araddr_prev <= axi_araddr;
      end
    end
  end

  assign axi_arid = 4'b0000;
  assign axi_arburst = 2'b01;
  assign axi_arlock = 1'b0;
  assign axi_arcache = 4'b0010;
  assign axi_arprot = 3'b000;
  assign axi_arqos = 4'b0000;
  assign axi_arlen = (axi_read_state == XFER_FULL_BURST) ? AXI_LENGTH :
                     (axi_read_state == XFER_PARTIAL_BURST) ? axi_last_beats : AXI_LENGTH;
  assign axi_arsize = AXI_SIZE;

  // AXI read data channel

  assign axi_dvalid_s = axi_rvalid & axi_rready & axi_xfer_req;
  assign axi_dlast_s = (axi_araddr_prev == axi_last_raddr) ? axi_rlast : 0;

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_rready <= 1'b0;
      axi_rerror <= 'd0;
    end else begin
      axi_rready <= axi_rvalid;
      axi_rerror <= axi_rvalid & axi_rresp[1];
    end
  end

  // ASYNC MEM write control

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_mem_waddr <= 'd0;
      axi_mem_waddr_g <= 'd0;
      axi_mem_laddr <= {AXI_MEM_ADDRESS_WIDTH{1'b1}};
      axi_mem_laddr_toggle <= 0;
    end else begin
      if (axi_dvalid_s == 1'b1) begin
        axi_mem_waddr <= axi_mem_waddr + 1'b1;
        if (axi_dlast_s == 1'b1) begin
          axi_mem_laddr <= axi_mem_waddr;
          axi_mem_laddr_toggle <= ~axi_mem_laddr_toggle;
        end
      end
      axi_mem_waddr_g <= axi_mem_waddr_b2g_s;
    end
  end

  ad_b2g # (
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_axi_mem_waddr_b2g (
    .din (axi_mem_waddr_s),
    .dout (axi_mem_waddr_b2g_s));

  assign axi_mem_raddr_s = (MEM_RATIO == 1) ? axi_mem_raddr :
                           (MEM_RATIO == 2) ? axi_mem_raddr[(DAC_MEM_ADDRESS_WIDTH-1):1] :
                           (MEM_RATIO == 4) ? axi_mem_raddr[(DAC_MEM_ADDRESS_WIDTH-1):2] :
                                              axi_mem_raddr[(DAC_MEM_ADDRESS_WIDTH-1):3];
  assign axi_mem_waddr_s = (MEM_RATIO == 1) ? axi_mem_waddr :
                           (MEM_RATIO == 2) ? {axi_mem_waddr, 1'b0} :
                           (MEM_RATIO == 4) ? {axi_mem_waddr, 2'b0} :
                                              {axi_mem_waddr, 3'b0};
   assign axi_mem_laddr_s = (MEM_RATIO == 1) ? axi_mem_laddr :
                            (MEM_RATIO == 2) ? {axi_mem_laddr, 1'b0} :
                            (MEM_RATIO == 4) ? {axi_mem_laddr, 2'b0} :
                                               {axi_mem_laddr, 3'b0};
  assign axi_mem_addr_diff_s = {1'b1, axi_mem_waddr} - axi_mem_raddr_s;

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_mem_addr_diff <= 'd0;
      axi_mem_raddr <= 'd0;
      axi_mem_raddr_m1 <= 'd0;
      axi_mem_raddr_m2 <= 'd0;
      axi_data_req <= 'd0;
    end else begin
      axi_mem_raddr_m1 <= dac_mem_raddr_g;
      axi_mem_raddr_m2 <= axi_mem_raddr_m1;
      axi_mem_raddr <= axi_mem_raddr_m2_g2b_s;
      axi_mem_addr_diff <= axi_mem_addr_diff_s[AXI_MEM_ADDRESS_WIDTH-1:0];
      // requesting AXI read access from the memory, if there is enough space
      // for a full burst in the async buffer
      if (axi_mem_addr_diff >= AXI_BUF_THRESHOLD_HI) begin
        axi_data_req <= 1'b0;
      end else  begin
        axi_data_req <= 1'b1;
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

  assign dac_xfer_out = dac_xfer_req_m[2] & dac_mem_valid;

  // CDC for write addresses from the DDRx clock domain
  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_mem_waddr <= 'b0;
      dac_mem_waddr_m1 <= 'b0;
      dac_mem_waddr_m2 <= 'b0;
      dac_mem_laddr_toggle_m <= 4'b0;
      dac_mem_laddr <= 'b0;
    end else begin
      dac_mem_waddr_m1 <= axi_mem_waddr_g;
      dac_mem_waddr_m2 <= dac_mem_waddr_m1;
      dac_mem_waddr <= dac_mem_waddr_m2_g2b_s;
      dac_mem_laddr_toggle_m <= {dac_mem_laddr_toggle_m[2:0], axi_mem_laddr_toggle};
      dac_mem_laddr <= (dac_mem_laddr_toggle_m[2] ^ dac_mem_laddr_toggle_m[1]) ?
                                                      axi_mem_laddr_s :
                                                      dac_mem_laddr;
    end
  end

  assign dac_laddr_wea = dac_mem_laddr_toggle_m[3] ^ dac_mem_laddr_toggle_m[2];
  assign dac_laddr_rea = ((dac_mem_raddr == dac_mem_laddr_b) &&
                          (dac_xfer_out == 1'b1)) ? 1'b1 :1'b0;

  axi_dacfifo_address_buffer #(
    .ADDRESS_WIDTH (4),
    .DATA_WIDTH (DAC_MEM_ADDRESS_WIDTH))
  i_laddress_buffer (
    .clk (dac_clk),
    .rst (dac_fifo_reset_s),
    .wea (dac_laddr_wea),
    .din (dac_mem_laddr),
    .rea (dac_laddr_rea),
    .dout (dac_mem_laddr_s));

  ad_g2b #(
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_dac_mem_waddr_m2_g2b (
    .din (dac_mem_waddr_m2),
    .dout (dac_mem_waddr_m2_g2b_s));

  assign dac_mem_addr_diff_s = {1'b1, dac_mem_waddr} - dac_mem_raddr;

  // ASYNC MEM read control

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_mem_enable <= 1'b0;
      dac_mem_valid <= 1'b0;
    end else begin
      if (dac_mem_dunf_s == 1'b1) begin
        dac_mem_enable <= 1'b0;
      end else if (dac_mem_addr_diff_s[(DAC_MEM_ADDRESS_WIDTH-1):0] >= DAC_BUF_THRESHOLD_HI) begin
        dac_mem_enable <= 1'b1;
      end
      dac_mem_valid <= (dac_mem_enable) ? dac_valid : 1'b0;
    end
  end

  // CDC for the dma_last_beats

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_last_beats <= 4'b0;
      dac_last_beats_m <= 4'b0;
    end else begin
      dac_last_beats_m <= dma_last_beats;
      dac_last_beats <= dac_last_beats_m;
    end
  end

  // If the MEM_RATIO is grater than one, it can happen that not all the DAC beats from
  // an AXI beat are valid. In this case the invalid data is dropped.
  // The axi_dlast indicates the last AXI beat. The valid number of DAC beats on the last AXI beat
  // commes from the AXI write module. (axi_dacfifo_wr.v)

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_mem_raddr <= 'd0;
      dac_mem_laddr_b <= 'd0;
      dac_mem_raddr_g <= 'd0;
    end else begin
      dac_mem_laddr_b <= dac_mem_laddr_s;
      if (dac_mem_valid == 1'b1) begin
        if ((dac_last_beats != 0) &&
            (dac_mem_raddr == (dac_mem_laddr_b + dac_last_beats - 1))) begin
          dac_mem_raddr <= dac_mem_raddr + (MEM_RATIO - (dac_last_beats - 1));
        end else begin
          dac_mem_raddr <= dac_mem_raddr + 1'b1;
        end
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

  assign dac_mem_dunf_s = (dac_mem_addr_diff_s[(DAC_MEM_ADDRESS_WIDTH-1):0] == 0) ? 1'b1 : 1'b0;

  always @(posedge dac_clk) begin
    if(dac_fifo_reset_s == 1'b1) begin
      dac_dunf <= 1'b0;
    end else begin
      dac_dunf <= dac_mem_dunf_s;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
