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

module ad_gt_es (

  // drp interface

  up_rstn,
  up_clk,
  up_es_drp_sel,
  up_es_drp_wr,
  up_es_drp_addr,
  up_es_drp_wdata,
  up_es_drp_rdata,
  up_es_drp_ready,

  // axi4 interface

  axi_awvalid,
  axi_awaddr,
  axi_awprot,
  axi_awready,
  axi_wvalid,
  axi_wdata,
  axi_wstrb,
  axi_wready,
  axi_bvalid,
  axi_bresp,
  axi_bready,
  axi_arvalid,
  axi_araddr,
  axi_arprot,
  axi_arready,
  axi_rvalid,
  axi_rresp,
  axi_rdata,
  axi_rready,

  // processor interface

  up_lpm_dfe_n,
  up_es_start,
  up_es_stop,
  up_es_init,
  up_es_sdata0,
  up_es_sdata1,
  up_es_sdata2,
  up_es_sdata3,
  up_es_sdata4,
  up_es_qdata0,
  up_es_qdata1,
  up_es_qdata2,
  up_es_qdata3,
  up_es_qdata4,
  up_es_prescale,
  up_es_hoffset_min,
  up_es_hoffset_max,
  up_es_hoffset_step,
  up_es_voffset_min,
  up_es_voffset_max,
  up_es_voffset_step,
  up_es_voffset_range,
  up_es_start_addr,
  up_es_dmaerr,
  up_es_status);

  // parameters

  parameter   GTH_GTX_N = 0;

  // gt address

  localparam  ES_DRP_CTRL_ADDR    = (GTH_GTX_N == 1) ? 12'h03c : 12'h03d; // GTH-7 12'h03d 
  localparam  ES_DRP_SDATA0_ADDR  = (GTH_GTX_N == 1) ? 12'h049 : 12'h036; // GTH-7 12'h036 
  localparam  ES_DRP_SDATA1_ADDR  = (GTH_GTX_N == 1) ? 12'h04a : 12'h037; // GTH-7 12'h037 
  localparam  ES_DRP_SDATA2_ADDR  = (GTH_GTX_N == 1) ? 12'h04b : 12'h038; // GTH-7 12'h038 
  localparam  ES_DRP_SDATA3_ADDR  = (GTH_GTX_N == 1) ? 12'h04c : 12'h039; // GTH-7 12'h039 
  localparam  ES_DRP_SDATA4_ADDR  = (GTH_GTX_N == 1) ? 12'h04d : 12'h03a; // GTH-7 12'h03a 
  localparam  ES_DRP_QDATA0_ADDR  = (GTH_GTX_N == 1) ? 12'h044 : 12'h031; // GTH-7 12'h031 
  localparam  ES_DRP_QDATA1_ADDR  = (GTH_GTX_N == 1) ? 12'h045 : 12'h032; // GTH-7 12'h032 
  localparam  ES_DRP_QDATA2_ADDR  = (GTH_GTX_N == 1) ? 12'h046 : 12'h033; // GTH-7 12'h033 
  localparam  ES_DRP_QDATA3_ADDR  = (GTH_GTX_N == 1) ? 12'h047 : 12'h034; // GTH-7 12'h034 
  localparam  ES_DRP_QDATA4_ADDR  = (GTH_GTX_N == 1) ? 12'h048 : 12'h035; // GTH-7 12'h035 
  localparam  ES_DRP_HOFFSET_ADDR = (GTH_GTX_N == 1) ? 12'h04f : 12'h03c; // GTH-7 12'h03c 
  localparam  ES_DRP_VOFFSET_ADDR = (GTH_GTX_N == 1) ? 12'h097 : 12'h03b; // GTH-7 12'h03b 
  localparam  ES_DRP_STATUS_ADDR  = (GTH_GTX_N == 1) ? 12'h153 : 12'h151; // GTH-7 12'h153 
  localparam  ES_DRP_SCNT_ADDR    = (GTH_GTX_N == 1) ? 12'h152 : 12'h150; // GTH-7 12'h152 
  localparam  ES_DRP_ECNT_ADDR    = (GTH_GTX_N == 1) ? 12'h151 : 12'h14f; // GTH-7 12'h151 

  // state machine

  localparam  ES_FSM_IDLE             = 6'h00;
  localparam  ES_FSM_STATUS           = 6'h01;
  localparam  ES_FSM_INIT             = 6'h02;
  localparam  ES_FSM_CTRLINIT_READ    = 6'h03;
  localparam  ES_FSM_CTRLINIT_RRDY    = 6'h04;
  localparam  ES_FSM_CTRLINIT_WRITE   = 6'h05;
  localparam  ES_FSM_CTRLINIT_WRDY    = 6'h06;
  localparam  ES_FSM_SDATA0_WRITE     = 6'h07;
  localparam  ES_FSM_SDATA0_WRDY      = 6'h08;
  localparam  ES_FSM_SDATA1_WRITE     = 6'h09;
  localparam  ES_FSM_SDATA1_WRDY      = 6'h0a;
  localparam  ES_FSM_SDATA2_WRITE     = 6'h0b;
  localparam  ES_FSM_SDATA2_WRDY      = 6'h0c;
  localparam  ES_FSM_SDATA3_WRITE     = 6'h0d;
  localparam  ES_FSM_SDATA3_WRDY      = 6'h0e;
  localparam  ES_FSM_SDATA4_WRITE     = 6'h0f;
  localparam  ES_FSM_SDATA4_WRDY      = 6'h10;
  localparam  ES_FSM_QDATA0_WRITE     = 6'h11;
  localparam  ES_FSM_QDATA0_WRDY      = 6'h12;
  localparam  ES_FSM_QDATA1_WRITE     = 6'h13;
  localparam  ES_FSM_QDATA1_WRDY      = 6'h14;
  localparam  ES_FSM_QDATA2_WRITE     = 6'h15;
  localparam  ES_FSM_QDATA2_WRDY      = 6'h16;
  localparam  ES_FSM_QDATA3_WRITE     = 6'h17;
  localparam  ES_FSM_QDATA3_WRDY      = 6'h18;
  localparam  ES_FSM_QDATA4_WRITE     = 6'h19;
  localparam  ES_FSM_QDATA4_WRDY      = 6'h1a;
  localparam  ES_FSM_HOFFSET_READ     = 6'h1b;
  localparam  ES_FSM_HOFFSET_RRDY     = 6'h1c;
  localparam  ES_FSM_HOFFSET_WRITE    = 6'h1d;
  localparam  ES_FSM_HOFFSET_WRDY     = 6'h1e;
  localparam  ES_FSM_VOFFSET_READ     = 6'h1f;
  localparam  ES_FSM_VOFFSET_RRDY     = 6'h20;
  localparam  ES_FSM_VOFFSET_WRITE    = 6'h21;
  localparam  ES_FSM_VOFFSET_WRDY     = 6'h22;
  localparam  ES_FSM_CTRLSTART_READ   = 6'h23;
  localparam  ES_FSM_CTRLSTART_RRDY   = 6'h24;
  localparam  ES_FSM_CTRLSTART_WRITE  = 6'h25;
  localparam  ES_FSM_CTRLSTART_WRDY   = 6'h26;
  localparam  ES_FSM_STATUS_READ      = 6'h27;
  localparam  ES_FSM_STATUS_RRDY      = 6'h28;
  localparam  ES_FSM_CTRLSTOP_READ    = 6'h29;
  localparam  ES_FSM_CTRLSTOP_RRDY    = 6'h2a;
  localparam  ES_FSM_CTRLSTOP_WRITE   = 6'h2b;
  localparam  ES_FSM_CTRLSTOP_WRDY    = 6'h2c;
  localparam  ES_FSM_SCNT_READ        = 6'h2d;
  localparam  ES_FSM_SCNT_RRDY        = 6'h2e;
  localparam  ES_FSM_ECNT_READ        = 6'h2f;
  localparam  ES_FSM_ECNT_RRDY        = 6'h30;
  localparam  ES_FSM_DMA_WRITE        = 6'h31;
  localparam  ES_FSM_DMA_READY        = 6'h32;
  localparam  ES_FSM_UPDATE           = 6'h33;

  // drp interface

  input           up_rstn;
  input           up_clk;
  output          up_es_drp_sel;
  output          up_es_drp_wr;
  output  [11:0]  up_es_drp_addr;
  output  [15:0]  up_es_drp_wdata;
  input   [15:0]  up_es_drp_rdata;
  input           up_es_drp_ready;

  // axi4 interface

  output          axi_awvalid;
  output  [31:0]  axi_awaddr;
  output  [ 2:0]  axi_awprot;
  input           axi_awready;
  output          axi_wvalid;
  output  [31:0]  axi_wdata;
  output  [ 3:0]  axi_wstrb;
  input           axi_wready;
  input           axi_bvalid;
  input   [ 1:0]  axi_bresp;
  output          axi_bready;
  output          axi_arvalid;
  output  [31:0]  axi_araddr;
  output  [ 2:0]  axi_arprot;
  input           axi_arready;
  input           axi_rvalid;
  input   [31:0]  axi_rdata;
  input   [ 1:0]  axi_rresp;
  output          axi_rready;

  // processor interface

  input           up_lpm_dfe_n;
  input           up_es_start;
  input           up_es_stop;
  input           up_es_init;
  input   [15:0]  up_es_sdata0;
  input   [15:0]  up_es_sdata1;
  input   [15:0]  up_es_sdata2;
  input   [15:0]  up_es_sdata3;
  input   [15:0]  up_es_sdata4;
  input   [15:0]  up_es_qdata0;
  input   [15:0]  up_es_qdata1;
  input   [15:0]  up_es_qdata2;
  input   [15:0]  up_es_qdata3;
  input   [15:0]  up_es_qdata4;
  input   [ 4:0]  up_es_prescale;
  input   [11:0]  up_es_hoffset_min;
  input   [11:0]  up_es_hoffset_max;
  input   [11:0]  up_es_hoffset_step;
  input   [ 7:0]  up_es_voffset_min;
  input   [ 7:0]  up_es_voffset_max;
  input   [ 7:0]  up_es_voffset_step;
  input   [ 1:0]  up_es_voffset_range;
  input   [31:0]  up_es_start_addr;
  output          up_es_dmaerr;
  output          up_es_status;

  // internal registers

  reg             axi_awvalid = 'd0;
  reg     [31:0]  axi_awaddr = 'd0;
  reg             axi_wvalid = 'd0;
  reg     [31:0]  axi_wdata = 'd0;
  reg             up_es_dmaerr = 'd0;
  reg             up_es_status = 'd0;
  reg             up_es_ut = 'd0;
  reg     [31:0]  up_es_dma_addr = 'd0;
  reg     [11:0]  up_es_hoffset = 'd0;
  reg     [ 7:0]  up_es_voffset = 'd0;
  reg     [15:0]  up_es_hoffset_rdata = 'd0;
  reg     [15:0]  up_es_voffset_rdata = 'd0;
  reg     [15:0]  up_es_ctrl_rdata = 'd0;
  reg     [15:0]  up_es_scnt_rdata = 'd0;
  reg     [15:0]  up_es_ecnt_rdata = 'd0;
  reg     [ 5:0]  up_es_fsm = 'd0;
  reg             up_es_drp_sel = 'd0;
  reg             up_es_drp_wr = 'd0;
  reg     [11:0]  up_es_drp_addr = 'd0;
  reg     [15:0]  up_es_drp_wdata = 'd0;

  // internal signals

  wire            up_es_heos_s;
  wire            up_es_eos_s;
  wire            up_es_ut_s;
  wire    [ 7:0]  up_es_voffset_2_s;
  wire    [ 7:0]  up_es_voffset_n_s;
  wire    [ 7:0]  up_es_voffset_s;

  // axi write interface

  assign axi_awprot = 3'd0;
  assign axi_wstrb = 4'hf;
  assign axi_bready = 1'd1;
  assign axi_arvalid = 1'd0;
  assign axi_araddr = 32'd0;
  assign axi_arprot = 3'd0;
  assign axi_rready = 1'd1;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      axi_awvalid <= 'b0;
      axi_awaddr <= 'd0;
      axi_wvalid <= 'b0;
      axi_wdata <= 'd0;
    end else begin
      if ((axi_awvalid == 1'b1) && (axi_awready == 1'b1)) begin
        axi_awvalid <= 1'b0;
        axi_awaddr <= 32'd0;
      end else if (up_es_fsm == ES_FSM_DMA_WRITE) begin
        axi_awvalid <= 1'b1;
        axi_awaddr <= up_es_dma_addr;
      end
      if ((axi_wvalid == 1'b1) && (axi_wready == 1'b1)) begin
        axi_wvalid <= 1'b0;
        axi_wdata <= 32'd0;
      end else if (up_es_fsm == ES_FSM_DMA_WRITE) begin
        axi_wvalid <= 1'b1;
        axi_wdata <= {up_es_scnt_rdata, up_es_ecnt_rdata};
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_es_dmaerr <= 'd0;
    end else begin
      if (axi_bvalid == 1'b1) begin
        up_es_dmaerr <= axi_bresp[1] | axi_bresp[0];
      end
    end
  end

  // prescale, horizontal and vertical offsets

  assign up_es_heos_s = (up_es_hoffset == up_es_hoffset_max) ? up_es_ut : 1'b0;
  assign up_es_eos_s = (up_es_voffset == up_es_voffset_max) ? up_es_heos_s : 1'b0;

  assign up_es_ut_s = up_es_ut & ~up_lpm_dfe_n;
  assign up_es_voffset_2_s = ~up_es_voffset + 1'b1;
  assign up_es_voffset_n_s = {1'b1, up_es_voffset_2_s[6:0]};
  assign up_es_voffset_s = (up_es_voffset[7] == 1'b1) ? up_es_voffset_n_s : up_es_voffset;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_es_status <= 1'b0;
      up_es_ut <= 'd0;
      up_es_dma_addr <= 'd0;
      up_es_hoffset <= 'd0;
      up_es_voffset <= 'd0;
    end else begin
      if (up_es_fsm == ES_FSM_IDLE) begin
        up_es_status <= 1'b0;
      end else begin
        up_es_status <= 1'b1;
      end
      if (up_es_fsm == ES_FSM_IDLE) begin
        up_es_ut <= up_lpm_dfe_n;
        up_es_dma_addr <= up_es_start_addr;
        up_es_hoffset <= up_es_hoffset_min;
        up_es_voffset <= up_es_voffset_min;
      end else if (up_es_fsm == ES_FSM_UPDATE) begin
        up_es_ut <= ~up_es_ut | up_lpm_dfe_n;
        up_es_dma_addr <= up_es_dma_addr + 3'd4;
        if (up_es_heos_s == 1'b1) begin
          up_es_hoffset <= up_es_hoffset_min;
        end else if (up_es_ut == 1'b1) begin
          up_es_hoffset <= up_es_hoffset + up_es_hoffset_step;
        end
        if (up_es_heos_s == 1'b1) begin
          up_es_voffset <= up_es_voffset + up_es_voffset_step;
        end
      end
    end
  end

  // read-modify-write parameters (gt's are full of mixed up controls)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_es_hoffset_rdata <= 'd0;
      up_es_voffset_rdata <= 'd0;
      up_es_ctrl_rdata <= 'd0;
      up_es_scnt_rdata <= 'd0;
      up_es_ecnt_rdata <= 'd0;
    end else begin
      if ((up_es_fsm == ES_FSM_HOFFSET_RRDY) && (up_es_drp_ready == 1'b1)) begin
        up_es_hoffset_rdata <= up_es_drp_rdata;
      end
      if ((up_es_fsm == ES_FSM_VOFFSET_RRDY) && (up_es_drp_ready == 1'b1)) begin
        up_es_voffset_rdata <= up_es_drp_rdata;
      end
      if (((up_es_fsm == ES_FSM_CTRLINIT_RRDY) || (up_es_fsm == ES_FSM_CTRLSTART_RRDY) ||
        (up_es_fsm == ES_FSM_CTRLSTOP_RRDY)) && (up_es_drp_ready == 1'b1)) begin
        up_es_ctrl_rdata <= up_es_drp_rdata;
      end
      if ((up_es_fsm == ES_FSM_SCNT_RRDY) && (up_es_drp_ready == 1'b1)) begin
        up_es_scnt_rdata <= up_es_drp_rdata;
      end
      if ((up_es_fsm == ES_FSM_ECNT_RRDY) && (up_es_drp_ready == 1'b1)) begin
        up_es_ecnt_rdata <= up_es_drp_rdata;
      end
    end
  end

  // eye scan state machine- write vertical and horizontal offsets
  // and read back sample and error counters

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_es_fsm <= ES_FSM_IDLE;
    end else begin
      if (up_es_stop == 1'b1) begin
        up_es_fsm <= ES_FSM_IDLE;
      end else begin
        case (up_es_fsm)
          ES_FSM_IDLE: begin // idle
            if (up_es_start == 1'b1) begin
              up_es_fsm <= ES_FSM_STATUS;
            end else begin
              up_es_fsm <= ES_FSM_IDLE;
            end
          end
       
          ES_FSM_STATUS: begin // set status
            up_es_fsm <= ES_FSM_INIT;
          end
       
          ES_FSM_INIT: begin // initialize
            if (up_es_init == 1'b1) begin
              up_es_fsm <= ES_FSM_CTRLINIT_READ;
            end else begin
              up_es_fsm <= ES_FSM_HOFFSET_READ;
            end
          end
       
          ES_FSM_CTRLINIT_READ: begin // control read
            up_es_fsm <= ES_FSM_CTRLINIT_RRDY;
          end
          ES_FSM_CTRLINIT_RRDY: begin // control ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_CTRLINIT_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_CTRLINIT_RRDY;
            end
          end
          ES_FSM_CTRLINIT_WRITE: begin // control write
            up_es_fsm <= ES_FSM_CTRLINIT_WRDY;
          end
          ES_FSM_CTRLINIT_WRDY: begin // control ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_SDATA0_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_CTRLINIT_WRDY;
            end
          end
      
          ES_FSM_SDATA0_WRITE: begin // sdata write
            up_es_fsm <= ES_FSM_SDATA0_WRDY;
          end
          ES_FSM_SDATA0_WRDY: begin // sdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_SDATA1_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_SDATA0_WRDY;
            end
          end
          ES_FSM_SDATA1_WRITE: begin // sdata write
            up_es_fsm <= ES_FSM_SDATA1_WRDY;
          end
          ES_FSM_SDATA1_WRDY: begin // sdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_SDATA2_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_SDATA1_WRDY;
            end
          end
          ES_FSM_SDATA2_WRITE: begin // sdata write
            up_es_fsm <= ES_FSM_SDATA2_WRDY;
          end
          ES_FSM_SDATA2_WRDY: begin // sdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_SDATA3_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_SDATA2_WRDY;
            end
          end
          ES_FSM_SDATA3_WRITE: begin // sdata write
            up_es_fsm <= ES_FSM_SDATA3_WRDY;
          end
          ES_FSM_SDATA3_WRDY: begin // sdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_SDATA4_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_SDATA3_WRDY;
            end
          end
          ES_FSM_SDATA4_WRITE: begin // sdata write
            up_es_fsm <= ES_FSM_SDATA4_WRDY;
          end
          ES_FSM_SDATA4_WRDY: begin // sdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_QDATA0_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_SDATA4_WRDY;
            end
          end
      
          ES_FSM_QDATA0_WRITE: begin // qdata write
            up_es_fsm <= ES_FSM_QDATA0_WRDY;
          end
          ES_FSM_QDATA0_WRDY: begin // qdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_QDATA1_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_QDATA0_WRDY;
            end
          end
          ES_FSM_QDATA1_WRITE: begin // qdata write
            up_es_fsm <= ES_FSM_QDATA1_WRDY;
          end
          ES_FSM_QDATA1_WRDY: begin // qdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_QDATA2_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_QDATA1_WRDY;
            end
          end
          ES_FSM_QDATA2_WRITE: begin // qdata write
            up_es_fsm <= ES_FSM_QDATA2_WRDY;
          end
          ES_FSM_QDATA2_WRDY: begin // qdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_QDATA3_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_QDATA2_WRDY;
            end
          end
          ES_FSM_QDATA3_WRITE: begin // qdata write
            up_es_fsm <= ES_FSM_QDATA3_WRDY;
          end
          ES_FSM_QDATA3_WRDY: begin // qdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_QDATA4_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_QDATA3_WRDY;
            end
          end
          ES_FSM_QDATA4_WRITE: begin // qdata write
            up_es_fsm <= ES_FSM_QDATA4_WRDY;
          end
          ES_FSM_QDATA4_WRDY: begin // qdata ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_HOFFSET_READ;
            end else begin
              up_es_fsm <= ES_FSM_QDATA4_WRDY;
            end
          end
      
          ES_FSM_HOFFSET_READ: begin // horizontal offset read
            up_es_fsm <= ES_FSM_HOFFSET_RRDY;
          end
          ES_FSM_HOFFSET_RRDY: begin // horizontal offset ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_HOFFSET_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_HOFFSET_RRDY;
            end
          end
          ES_FSM_HOFFSET_WRITE: begin // horizontal offset write
            up_es_fsm <= ES_FSM_HOFFSET_WRDY;
          end
          ES_FSM_HOFFSET_WRDY: begin // horizontal offset ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_VOFFSET_READ;
            end else begin
              up_es_fsm <= ES_FSM_HOFFSET_WRDY;
            end
          end
      
          ES_FSM_VOFFSET_READ: begin // vertical offset read
            up_es_fsm <= ES_FSM_VOFFSET_RRDY;
          end
          ES_FSM_VOFFSET_RRDY: begin // vertical offset ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_VOFFSET_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_VOFFSET_RRDY;
            end
          end
          ES_FSM_VOFFSET_WRITE: begin // vertical offset write
            up_es_fsm <= ES_FSM_VOFFSET_WRDY;
          end
          ES_FSM_VOFFSET_WRDY: begin // vertical offset ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_CTRLSTART_READ;
            end else begin
              up_es_fsm <= ES_FSM_VOFFSET_WRDY;
            end
          end
      
          ES_FSM_CTRLSTART_READ: begin // control read
            up_es_fsm <= ES_FSM_CTRLSTART_RRDY;
          end
          ES_FSM_CTRLSTART_RRDY: begin // control ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_CTRLSTART_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_CTRLSTART_RRDY;
            end
          end
          ES_FSM_CTRLSTART_WRITE: begin // control write
            up_es_fsm <= ES_FSM_CTRLSTART_WRDY;
          end
          ES_FSM_CTRLSTART_WRDY: begin // control ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_STATUS_READ;
            end else begin
              up_es_fsm <= ES_FSM_CTRLSTART_WRDY;
            end
          end
      
          ES_FSM_STATUS_READ: begin // status read
            up_es_fsm <= ES_FSM_STATUS_RRDY;
          end
          ES_FSM_STATUS_RRDY: begin // status ready
            if (up_es_drp_ready == 1'b0) begin
              up_es_fsm <= ES_FSM_STATUS_RRDY;
            end else if (up_es_drp_rdata[3:0] == 4'b0101) begin
              up_es_fsm <= ES_FSM_CTRLSTOP_READ;
            end else begin
              up_es_fsm <= ES_FSM_STATUS_READ;
            end
          end
      
          ES_FSM_CTRLSTOP_READ: begin // control read
            up_es_fsm <= ES_FSM_CTRLSTOP_RRDY;
          end
          ES_FSM_CTRLSTOP_RRDY: begin // control ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_CTRLSTOP_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_CTRLSTOP_RRDY;
            end
          end
          ES_FSM_CTRLSTOP_WRITE: begin // control write
            up_es_fsm <= ES_FSM_CTRLSTOP_WRDY;
          end
          ES_FSM_CTRLSTOP_WRDY: begin // control ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_SCNT_READ;
            end else begin
              up_es_fsm <= ES_FSM_CTRLSTOP_WRDY;
            end
          end
      
          ES_FSM_SCNT_READ: begin // read sample count
            up_es_fsm <= ES_FSM_SCNT_RRDY;
          end
          ES_FSM_SCNT_RRDY: begin // sample count ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_ECNT_READ;
            end else begin
              up_es_fsm <= ES_FSM_SCNT_RRDY;
            end
          end
      
          ES_FSM_ECNT_READ: begin // read error count
            up_es_fsm <= ES_FSM_ECNT_RRDY;
          end
          ES_FSM_ECNT_RRDY: begin // error count ready
            if (up_es_drp_ready == 1'b1) begin
              up_es_fsm <= ES_FSM_DMA_WRITE;
            end else begin
              up_es_fsm <= ES_FSM_ECNT_RRDY;
            end
          end
       
          ES_FSM_DMA_WRITE: begin // dma write
            up_es_fsm <= ES_FSM_DMA_READY;
          end
          ES_FSM_DMA_READY: begin // dma ack
            if (axi_bvalid == 1'b1) begin
              up_es_fsm <= ES_FSM_UPDATE;
            end else begin
              up_es_fsm <= ES_FSM_DMA_READY;
            end
          end
      
          ES_FSM_UPDATE: begin // update
            if (up_es_eos_s == 1'b1) begin
              up_es_fsm <= ES_FSM_IDLE;
            end else if (up_es_ut == 1'b1) begin
              up_es_fsm <= ES_FSM_HOFFSET_READ;
            end else begin
              up_es_fsm <= ES_FSM_VOFFSET_READ;
            end
          end
      
          default: begin
            up_es_fsm <= ES_FSM_IDLE;
          end
        endcase
      end
    end
  end

  // drp signals controlled by the fsm

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_es_drp_sel <= 'd0;
      up_es_drp_wr <= 'd0;
      up_es_drp_addr <= 'd0;
      up_es_drp_wdata <= 'd0;
    end else begin
      case (up_es_fsm)
        ES_FSM_CTRLINIT_READ: begin 
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= ES_DRP_CTRL_ADDR;
          up_es_drp_wdata <= 16'h0000;
        end
        ES_FSM_CTRLINIT_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_CTRL_ADDR;
          if (GTH_GTX_N == 1) begin
          up_es_drp_wdata <= {up_es_ctrl_rdata[15:10], 2'b11, up_es_ctrl_rdata[7:5], up_es_prescale};
          end else begin
          up_es_drp_wdata <= {up_es_ctrl_rdata[15:10], 2'b11, up_es_ctrl_rdata[7:0]};
          end
        end
        ES_FSM_SDATA0_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_SDATA0_ADDR;
          up_es_drp_wdata <= up_es_sdata0;
        end
        ES_FSM_SDATA1_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_SDATA1_ADDR;
          up_es_drp_wdata <= up_es_sdata1;
        end
        ES_FSM_SDATA2_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_SDATA2_ADDR;
          up_es_drp_wdata <= up_es_sdata2;
        end
        ES_FSM_SDATA3_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_SDATA3_ADDR;
          up_es_drp_wdata <= up_es_sdata3;
        end
        ES_FSM_SDATA4_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_SDATA4_ADDR;
          up_es_drp_wdata <= up_es_sdata4;
        end
        ES_FSM_QDATA0_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_QDATA0_ADDR;
          up_es_drp_wdata <= up_es_qdata0;
        end
        ES_FSM_QDATA1_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_QDATA1_ADDR;
          up_es_drp_wdata <= up_es_qdata1;
        end
        ES_FSM_QDATA2_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_QDATA2_ADDR;
          up_es_drp_wdata <= up_es_qdata2;
        end
        ES_FSM_QDATA3_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_QDATA3_ADDR;
          up_es_drp_wdata <= up_es_qdata3;
        end
        ES_FSM_QDATA4_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_QDATA4_ADDR;
          up_es_drp_wdata <= up_es_qdata4;
        end
        ES_FSM_HOFFSET_READ: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= ES_DRP_HOFFSET_ADDR;
          up_es_drp_wdata <= 16'h0000;
        end
        ES_FSM_HOFFSET_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_HOFFSET_ADDR;
          if (GTH_GTX_N == 1) begin
          up_es_drp_wdata <= {up_es_hoffset, up_es_hoffset_rdata[3:0]};
          end else begin
          up_es_drp_wdata <= {up_es_hoffset_rdata[15:12], up_es_hoffset};
          end
        end
        ES_FSM_VOFFSET_READ: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= ES_DRP_VOFFSET_ADDR;
          up_es_drp_wdata <= 16'h0000;
        end
        ES_FSM_VOFFSET_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_VOFFSET_ADDR;
          if (GTH_GTX_N == 1) begin
          up_es_drp_wdata <= {up_es_voffset_rdata[15:11], up_es_voffset_s[7], up_es_ut_s, up_es_voffset_s[6:0], up_es_voffset_range};
          end else begin
          up_es_drp_wdata <= {up_es_prescale, up_es_voffset_rdata[10:9], up_es_ut_s, up_es_voffset_s};
          end
        end
        ES_FSM_CTRLSTART_READ: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= ES_DRP_CTRL_ADDR;
          up_es_drp_wdata <= 16'h0000;
        end
        ES_FSM_CTRLSTART_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_CTRL_ADDR;
          if (GTH_GTX_N == 1) begin
          up_es_drp_wdata <= {6'd1, up_es_ctrl_rdata[9:0]};
          end else begin
          up_es_drp_wdata <= {up_es_ctrl_rdata[15:6], 6'd1};
          end
        end
        ES_FSM_STATUS_READ: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= ES_DRP_STATUS_ADDR;
          up_es_drp_wdata <= 16'h0000;
        end
        ES_FSM_CTRLSTOP_READ: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= ES_DRP_CTRL_ADDR;
          up_es_drp_wdata <= 16'h0000;
        end
        ES_FSM_CTRLSTOP_WRITE: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b1;
          up_es_drp_addr <= ES_DRP_CTRL_ADDR;
          if (GTH_GTX_N == 1) begin
          up_es_drp_wdata <= {6'd0, up_es_ctrl_rdata[9:0]};
          end else begin
          up_es_drp_wdata <= {up_es_ctrl_rdata[15:6], 6'd0};
          end
        end
        ES_FSM_SCNT_READ: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= ES_DRP_SCNT_ADDR;
          up_es_drp_wdata <= 16'h0000;
        end
        ES_FSM_ECNT_READ: begin
          up_es_drp_sel <= 1'b1;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= ES_DRP_ECNT_ADDR;
          up_es_drp_wdata <= 16'h0000;
        end
        default: begin
          up_es_drp_sel <= 1'b0;
          up_es_drp_wr <= 1'b0;
          up_es_drp_addr <= 9'h000;
          up_es_drp_wdata <= 16'h0000;
        end
      endcase
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
