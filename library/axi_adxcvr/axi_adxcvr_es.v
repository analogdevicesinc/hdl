// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_adxcvr_es (

  // up interface

  input           up_rstn,
  input           up_clk,
  output          up_es_enb,
  output  [11:0]  up_es_addr,
  output          up_es_wr,
  output  [15:0]  up_es_wdata,
  input   [15:0]  up_es_rdata,
  input           up_es_ready,
  input           up_ch_lpm_dfe_n,
  input           up_es_req,
  output          up_es_ack,
  input   [ 4:0]  up_es_pscale,
  input   [ 1:0]  up_es_vrange,
  input   [ 7:0]  up_es_vstep,
  input   [ 7:0]  up_es_vmax,
  input   [ 7:0]  up_es_vmin,
  input   [11:0]  up_es_hmax,
  input   [11:0]  up_es_hmin,
  input   [11:0]  up_es_hstep,
  input   [31:0]  up_es_saddr,
  output          up_es_status,

  // axi interface

  output          up_axi_awvalid,
  output  [31:0]  up_axi_awaddr,
  output  [ 2:0]  up_axi_awprot,
  input           up_axi_awready,
  output          up_axi_wvalid,
  output  [31:0]  up_axi_wdata,
  output  [ 3:0]  up_axi_wstrb,
  input           up_axi_wready,
  input           up_axi_bvalid,
  input   [ 1:0]  up_axi_bresp,
  output          up_axi_bready,
  output          up_axi_arvalid,
  output  [31:0]  up_axi_araddr,
  output  [ 2:0]  up_axi_arprot,
  input           up_axi_arready,
  input           up_axi_rvalid,
  input   [31:0]  up_axi_rdata,
  input   [ 1:0]  up_axi_rresp,
  output          up_axi_rready);

  // parameters

  parameter   integer GTH_OR_GTX_N = 0;
  parameter   integer TX_OR_RX_N = 0;

  // addresses

  localparam  [11:0]  ES_DRP_CTRL_ADDR    = (GTH_OR_GTX_N == 1) ? 12'h03c : 12'h03d; // GTH-7 12'h03d 
  localparam  [11:0]  ES_DRP_HOFFSET_ADDR = (GTH_OR_GTX_N == 1) ? 12'h04f : 12'h03c; // GTH-7 12'h03c 
  localparam  [11:0]  ES_DRP_VOFFSET_ADDR = (GTH_OR_GTX_N == 1) ? 12'h097 : 12'h03b; // GTH-7 12'h03b 
  localparam  [11:0]  ES_DRP_STATUS_ADDR  = (GTH_OR_GTX_N == 1) ? 12'h153 : 12'h151; // GTH-7 12'h153 
  localparam  [11:0]  ES_DRP_SCNT_ADDR    = (GTH_OR_GTX_N == 1) ? 12'h152 : 12'h150; // GTH-7 12'h152 
  localparam  [11:0]  ES_DRP_ECNT_ADDR    = (GTH_OR_GTX_N == 1) ? 12'h151 : 12'h14f; // GTH-7 12'h151 

  // fsm-states

  localparam  [ 4:0]  ES_FSM_IDLE             = 6'h00;
  localparam  [ 4:0]  ES_FSM_HOFFSET_READ     = 6'h01;
  localparam  [ 4:0]  ES_FSM_HOFFSET_RRDY     = 6'h02;
  localparam  [ 4:0]  ES_FSM_HOFFSET_WRITE    = 6'h03;
  localparam  [ 4:0]  ES_FSM_HOFFSET_WRDY     = 6'h04;
  localparam  [ 4:0]  ES_FSM_VOFFSET_READ     = 6'h05;
  localparam  [ 4:0]  ES_FSM_VOFFSET_RRDY     = 6'h06;
  localparam  [ 4:0]  ES_FSM_VOFFSET_WRITE    = 6'h07;
  localparam  [ 4:0]  ES_FSM_VOFFSET_WRDY     = 6'h08;
  localparam  [ 4:0]  ES_FSM_CTRL_READ        = 6'h09;
  localparam  [ 4:0]  ES_FSM_CTRL_RRDY        = 6'h0a;
  localparam  [ 4:0]  ES_FSM_START_WRITE      = 6'h0b;
  localparam  [ 4:0]  ES_FSM_START_WRDY       = 6'h0c;
  localparam  [ 4:0]  ES_FSM_STATUS_READ      = 6'h0d;
  localparam  [ 4:0]  ES_FSM_STATUS_RRDY      = 6'h0e;
  localparam  [ 4:0]  ES_FSM_STOP_WRITE       = 6'h0f;
  localparam  [ 4:0]  ES_FSM_STOP_WRDY        = 6'h10;
  localparam  [ 4:0]  ES_FSM_SCNT_READ        = 6'h11;
  localparam  [ 4:0]  ES_FSM_SCNT_RRDY        = 6'h12;
  localparam  [ 4:0]  ES_FSM_ECNT_READ        = 6'h13;
  localparam  [ 4:0]  ES_FSM_ECNT_RRDY        = 6'h14;
  localparam  [ 4:0]  ES_FSM_AXI_WRITE        = 6'h15;
  localparam  [ 4:0]  ES_FSM_AXI_READY        = 6'h16;
  localparam  [ 4:0]  ES_FSM_UPDATE           = 6'h17;

  // internal registers

  reg             up_awvalid = 'd0;
  reg     [31:0]  up_awaddr = 'd0;
  reg             up_wvalid = 'd0;
  reg     [31:0]  up_wdata = 'd0;
  reg             up_status = 'd0;
  reg             up_ut = 'd0;
  reg     [31:0]  up_daddr = 'd0;
  reg     [11:0]  up_hindex = 'd0;
  reg     [ 7:0]  up_vindex = 'd0;
  reg     [15:0]  up_hdata = 'd0;
  reg     [15:0]  up_vdata = 'd0;
  reg     [15:0]  up_cdata = 'd0;
  reg     [15:0]  up_sdata = 'd0;
  reg     [15:0]  up_edata = 'd0;
  reg             up_req_d = 'd0;
  reg             up_ack = 'd0;
  reg     [ 4:0]  up_fsm = 'd0;
  reg             up_enb = 'd0;
  reg     [11:0]  up_addr = 'd0;
  reg             up_wr = 'd0;
  reg     [15:0]  up_data = 'd0;

  // internal signals

  wire            up_heos_s;
  wire            up_eos_s;
  wire            up_ut_s;
  wire    [ 7:0]  up_vindex_m_s;
  wire    [ 7:0]  up_vindex_n_s;
  wire    [ 7:0]  up_vindex_s;
  wire            up_start_s;

  // axi interface

  generate
  if (TX_OR_RX_N == 1) begin
  assign up_axi_awvalid = 1'b0;
  assign up_axi_awaddr = 32'd0;
  assign up_axi_awprot = 3'd0;
  assign up_axi_wvalid = 1'b0;
  assign up_axi_wdata = 32'd0;
  assign up_axi_wstrb = 4'hf;
  assign up_axi_bready = 1'b1;
  assign up_axi_arvalid = 1'b0;
  assign up_axi_araddr = 32'd0;
  assign up_axi_arprot = 3'd0;
  assign up_axi_rready = 1'b1;
  end else begin
  assign up_axi_awvalid = up_awvalid;
  assign up_axi_awaddr = up_awaddr;
  assign up_axi_awprot = 3'd0;
  assign up_axi_wvalid = up_wvalid;
  assign up_axi_wdata = up_wdata;
  assign up_axi_wstrb = 4'hf;
  assign up_axi_bready = 1'b1;
  assign up_axi_arvalid = 1'b0;
  assign up_axi_araddr = 32'd0;
  assign up_axi_arprot = 3'd0;
  assign up_axi_rready = 1'b1;
  end
  endgenerate

  // reconfig interface

  generate
  if (TX_OR_RX_N == 1) begin
  assign up_es_ack = 1'b1;
  assign up_es_enb = 1'b0;
  assign up_es_addr = 12'd0;
  assign up_es_wr = 1'd0;
  assign up_es_wdata = 16'd0;
  assign up_es_status = 1'd0;
  end else begin
  assign up_es_ack = up_ack;
  assign up_es_enb = up_enb;
  assign up_es_addr = up_addr;
  assign up_es_wr = up_wr;
  assign up_es_wdata = up_data;
  assign up_es_status = up_status;
  end
  endgenerate

  // axi write

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_awvalid <= 'b0;
      up_awaddr <= 'd0;
      up_wvalid <= 'b0;
      up_wdata <= 'd0;
      up_status <= 'd0;
    end else begin
      if ((up_awvalid == 1'b1) && (up_axi_awready == 1'b1)) begin
        up_awvalid <= 1'b0;
        up_awaddr <= 32'd0;
      end else if (up_fsm == ES_FSM_AXI_WRITE) begin
        up_awvalid <= 1'b1;
        up_awaddr <= up_daddr;
      end
      if ((up_wvalid == 1'b1) && (up_axi_wready == 1'b1)) begin
        up_wvalid <= 1'b0;
        up_wdata <= 32'd0;
      end else if (up_fsm == ES_FSM_AXI_WRITE) begin
        up_wvalid <= 1'b1;
        up_wdata <= {up_sdata, up_edata};
      end
      if (up_axi_bvalid == 1'b1) begin
        up_status <= | up_axi_bresp;
      end
    end
  end

  // prescale, horizontal and vertical offsets

  assign up_heos_s = (up_hindex == up_es_hmax) ? up_ut : 1'b0;
  assign up_eos_s = (up_vindex == up_es_vmax) ? up_heos_s : 1'b0;

  assign up_ut_s = up_ut & ~up_ch_lpm_dfe_n;
  assign up_vindex_m_s = ~up_vindex + 1'b1;
  assign up_vindex_n_s = {1'b1, up_vindex_m_s[6:0]};
  assign up_vindex_s = (up_vindex[7] == 1'b1) ? up_vindex_n_s : up_vindex;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_ut <= 'd0;
      up_daddr <= 'd0;
      up_hindex <= 'd0;
      up_vindex <= 'd0;
    end else begin
      if (up_fsm == ES_FSM_IDLE) begin
        up_ut <= up_ch_lpm_dfe_n;
        up_daddr <= up_es_saddr;
        up_hindex <= up_es_hmin;
        up_vindex <= up_es_vmin;
      end else if (up_fsm == ES_FSM_UPDATE) begin
        up_ut <= ~up_ut | up_ch_lpm_dfe_n;
        up_daddr <= up_daddr + 3'd4;
        if (up_heos_s == 1'b1) begin
          up_hindex <= up_es_hmin;
        end else if (up_ut == 1'b1) begin
          up_hindex <= up_hindex + up_es_hstep;
        end
        if (up_heos_s == 1'b1) begin
          up_vindex <= up_vindex + up_es_vstep;
        end
      end
    end
  end

  // read-modify-write

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_hdata <= 'd0;
      up_vdata <= 'd0;
      up_cdata <= 'd0;
      up_sdata <= 'd0;
      up_edata <= 'd0;
    end else begin
      if ((up_fsm == ES_FSM_HOFFSET_RRDY) && (up_es_ready == 1'b1)) begin
        up_hdata <= up_es_rdata;
      end
      if ((up_fsm == ES_FSM_VOFFSET_RRDY) && (up_es_ready == 1'b1)) begin
        up_vdata <= up_es_rdata;
      end
      if ((up_fsm == ES_FSM_CTRL_RRDY) && (up_es_ready == 1'b1)) begin
        up_cdata <= up_es_rdata;
      end
      if ((up_fsm == ES_FSM_SCNT_RRDY) && (up_es_ready == 1'b1)) begin
        up_sdata <= up_es_rdata;
      end
      if ((up_fsm == ES_FSM_ECNT_RRDY) && (up_es_ready == 1'b1)) begin
        up_edata <= up_es_rdata;
      end
    end
  end

  // request, start and ack

  assign up_start_s = up_es_req & ~up_req_d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_req_d <= 1'b0;
      up_ack <= 1'b0;
    end else begin
      up_req_d <= up_es_req;
      if (up_fsm == ES_FSM_UPDATE) begin 
        up_ack <= up_eos_s | ~up_es_req;
      end else begin
        up_ack <= 1'b0;
      end
    end
  end

  // es-fsm

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_fsm <= ES_FSM_IDLE;
    end else begin
      case (up_fsm)
        ES_FSM_IDLE: begin 
          if (up_start_s == 1'b1) begin
            up_fsm <= ES_FSM_HOFFSET_READ;
          end else begin
            up_fsm <= ES_FSM_IDLE;
          end
        end
        ES_FSM_HOFFSET_READ: begin 
          up_fsm <= ES_FSM_HOFFSET_RRDY;
        end
        ES_FSM_HOFFSET_RRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_HOFFSET_WRITE;
          end else begin
            up_fsm <= ES_FSM_HOFFSET_RRDY;
          end
        end
        ES_FSM_HOFFSET_WRITE: begin 
          up_fsm <= ES_FSM_HOFFSET_WRDY;
        end
        ES_FSM_HOFFSET_WRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_VOFFSET_READ;
          end else begin
            up_fsm <= ES_FSM_HOFFSET_WRDY;
          end
        end
        ES_FSM_VOFFSET_READ: begin 
          up_fsm <= ES_FSM_VOFFSET_RRDY;
        end
        ES_FSM_VOFFSET_RRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_VOFFSET_WRITE;
          end else begin
            up_fsm <= ES_FSM_VOFFSET_RRDY;
          end
        end
        ES_FSM_VOFFSET_WRITE: begin 
          up_fsm <= ES_FSM_VOFFSET_WRDY;
        end
        ES_FSM_VOFFSET_WRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_CTRL_READ;
          end else begin
            up_fsm <= ES_FSM_VOFFSET_WRDY;
          end
        end
        ES_FSM_CTRL_READ: begin 
          up_fsm <= ES_FSM_CTRL_RRDY;
        end
        ES_FSM_CTRL_RRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_START_WRITE;
          end else begin
            up_fsm <= ES_FSM_CTRL_RRDY;
          end
        end
        ES_FSM_START_WRITE: begin 
          up_fsm <= ES_FSM_START_WRDY;
        end
        ES_FSM_START_WRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_STATUS_READ;
          end else begin
            up_fsm <= ES_FSM_START_WRDY;
          end
        end
        ES_FSM_STATUS_READ: begin 
          up_fsm <= ES_FSM_STATUS_RRDY;
        end
        ES_FSM_STATUS_RRDY: begin 
          if (up_es_ready == 1'b0) begin
            up_fsm <= ES_FSM_STATUS_RRDY;
          end else if (up_es_rdata[3:0] == 4'b0101) begin
            up_fsm <= ES_FSM_STOP_WRITE;
          end else begin
            up_fsm <= ES_FSM_STATUS_READ;
          end
        end
        ES_FSM_STOP_WRITE: begin 
          up_fsm <= ES_FSM_STOP_WRDY;
        end
        ES_FSM_STOP_WRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_SCNT_READ;
          end else begin
            up_fsm <= ES_FSM_STOP_WRDY;
          end
        end
        ES_FSM_SCNT_READ: begin 
          up_fsm <= ES_FSM_SCNT_RRDY;
        end
        ES_FSM_SCNT_RRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_ECNT_READ;
          end else begin
            up_fsm <= ES_FSM_SCNT_RRDY;
          end
        end
        ES_FSM_ECNT_READ: begin 
          up_fsm <= ES_FSM_ECNT_RRDY;
        end
        ES_FSM_ECNT_RRDY: begin 
          if (up_es_ready == 1'b1) begin
            up_fsm <= ES_FSM_AXI_WRITE;
          end else begin
            up_fsm <= ES_FSM_ECNT_RRDY;
          end
        end
        ES_FSM_AXI_WRITE: begin 
          up_fsm <= ES_FSM_AXI_READY;
        end
        ES_FSM_AXI_READY: begin 
          if (up_axi_bvalid == 1'b1) begin
            up_fsm <= ES_FSM_UPDATE;
          end else begin
            up_fsm <= ES_FSM_AXI_READY;
          end
        end
        ES_FSM_UPDATE: begin 
          if ((up_eos_s == 1'b1) || (up_es_req == 1'b0)) begin
            up_fsm <= ES_FSM_IDLE;
          end else if (up_ut == 1'b1) begin
            up_fsm <= ES_FSM_HOFFSET_READ;
          end else begin
            up_fsm <= ES_FSM_VOFFSET_READ;
          end
        end
        default: begin
          up_fsm <= ES_FSM_IDLE;
        end
      endcase
    end
  end

  // channel access

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_enb <= 'd0;
      up_addr <= 'd0;
      up_wr <= 'd0;
      up_data <= 'd0;
    end else begin
      case (up_fsm)
        ES_FSM_HOFFSET_READ: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_HOFFSET_ADDR;
          up_wr <= 1'b0;
          up_data <= 16'h0000;
        end
        ES_FSM_HOFFSET_WRITE: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_HOFFSET_ADDR;
          up_wr <= 1'b1;
          if (GTH_OR_GTX_N == 1) begin
          up_data <= {up_hindex, up_hdata[3:0]};
          end else begin
          up_data <= {up_hdata[15:12], up_hindex};
          end
        end
        ES_FSM_VOFFSET_READ: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_VOFFSET_ADDR;
          up_wr <= 1'b0;
          up_data <= 16'h0000;
        end
        ES_FSM_VOFFSET_WRITE: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_VOFFSET_ADDR;
          up_wr <= 1'b1;
          if (GTH_OR_GTX_N == 1) begin
          up_data <= {up_vdata[15:11], up_vindex_s[7], up_ut_s, up_vindex_s[6:0], up_es_vrange};
          end else begin
          up_data <= {up_es_pscale, up_vdata[10:9], up_ut_s, up_vindex_s};
          end
        end
        ES_FSM_CTRL_READ: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_CTRL_ADDR;
          up_wr <= 1'b0;
          up_data <= 16'h0000;
        end
        ES_FSM_START_WRITE: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_CTRL_ADDR;
          up_wr <= 1'b1;
          if (GTH_OR_GTX_N == 1) begin
          up_data <= {6'd1, 2'b11, up_cdata[7:5], up_es_pscale};
          end else begin
          up_data <= {up_cdata[15:10], 2'b11, up_cdata[7:6], 6'd1};
          end
        end
        ES_FSM_STATUS_READ: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_STATUS_ADDR;
          up_wr <= 1'b0;
          up_data <= 16'h0000;
        end
        ES_FSM_STOP_WRITE: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_CTRL_ADDR;
          up_wr <= 1'b1;
          if (GTH_OR_GTX_N == 1) begin
          up_data <= {6'd0, 2'b11, up_cdata[7:5], up_es_pscale};
          end else begin
          up_data <= {up_cdata[15:10], 2'b11, up_cdata[7:6], 6'd0};
          end
        end
        ES_FSM_SCNT_READ: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_SCNT_ADDR;
          up_wr <= 1'b0;
          up_data <= 16'h0000;
        end
        ES_FSM_ECNT_READ: begin
          up_enb <= 1'b1;
          up_addr <= ES_DRP_ECNT_ADDR;
          up_wr <= 1'b0;
          up_data <= 16'h0000;
        end
        default: begin
          up_enb <= 1'b0;
          up_addr <= 9'h000;
          up_wr <= 1'b0;
          up_data <= 16'h0000;
        end
      endcase
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
