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

  drp_rst,
  drp_clk,
  es_sel,
  es_wr,
  es_addr,
  es_wdata,
  es_rdata,
  es_ready,

  // axi4 interface

  axi_rstn,
  axi_clk,
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

  es_start,
  es_stop,
  es_init,
  es_sdata0,
  es_sdata1,
  es_sdata2,
  es_sdata3,
  es_sdata4,
  es_qdata0,
  es_qdata1,
  es_qdata2,
  es_qdata3,
  es_qdata4,
  es_prescale,
  es_hoffset_min,
  es_hoffset_max,
  es_hoffset_step,
  es_voffset_min,
  es_voffset_max,
  es_voffset_step,
  es_voffset_range,
  es_start_addr,
  es_dmaerr,
  es_status,

  // debug interface

  es_dbg_trigger,
  es_dbg_data);

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

  parameter ES_FSM_IDLE             = 6'h00;
  parameter ES_FSM_STATUS           = 6'h30;
  parameter ES_FSM_INIT             = 6'h31;
  parameter ES_FSM_CTRLINIT_READ    = 6'h01;
  parameter ES_FSM_CTRLINIT_RRDY    = 6'h02;
  parameter ES_FSM_CTRLINIT_WRITE   = 6'h03;
  parameter ES_FSM_CTRLINIT_WRDY    = 6'h04;
  parameter ES_FSM_SDATA0_WRITE     = 6'h05;
  parameter ES_FSM_SDATA0_WRDY      = 6'h06;
  parameter ES_FSM_SDATA1_WRITE     = 6'h07;
  parameter ES_FSM_SDATA1_WRDY      = 6'h08;
  parameter ES_FSM_SDATA2_WRITE     = 6'h09;
  parameter ES_FSM_SDATA2_WRDY      = 6'h0a;
  parameter ES_FSM_SDATA3_WRITE     = 6'h0b;
  parameter ES_FSM_SDATA3_WRDY      = 6'h0c;
  parameter ES_FSM_SDATA4_WRITE     = 6'h0d;
  parameter ES_FSM_SDATA4_WRDY      = 6'h0e;
  parameter ES_FSM_QDATA0_WRITE     = 6'h0f;
  parameter ES_FSM_QDATA0_WRDY      = 6'h10;
  parameter ES_FSM_QDATA1_WRITE     = 6'h11;
  parameter ES_FSM_QDATA1_WRDY      = 6'h12;
  parameter ES_FSM_QDATA2_WRITE     = 6'h13;
  parameter ES_FSM_QDATA2_WRDY      = 6'h14;
  parameter ES_FSM_QDATA3_WRITE     = 6'h15;
  parameter ES_FSM_QDATA3_WRDY      = 6'h16;
  parameter ES_FSM_QDATA4_WRITE     = 6'h17;
  parameter ES_FSM_QDATA4_WRDY      = 6'h18;
  parameter ES_FSM_HOFFSET_READ     = 6'h19;
  parameter ES_FSM_HOFFSET_RRDY     = 6'h1a;
  parameter ES_FSM_HOFFSET_WRITE    = 6'h1b;
  parameter ES_FSM_HOFFSET_WRDY     = 6'h1c;
  parameter ES_FSM_VOFFSET_READ     = 6'h1d;
  parameter ES_FSM_VOFFSET_RRDY     = 6'h1e;
  parameter ES_FSM_VOFFSET_WRITE    = 6'h1f;
  parameter ES_FSM_VOFFSET_WRDY     = 6'h20;
  parameter ES_FSM_CTRLSTART_READ   = 6'h21;
  parameter ES_FSM_CTRLSTART_RRDY   = 6'h22;
  parameter ES_FSM_CTRLSTART_WRITE  = 6'h23;
  parameter ES_FSM_CTRLSTART_WRDY   = 6'h24;
  parameter ES_FSM_STATUS_READ      = 6'h25;
  parameter ES_FSM_STATUS_RRDY      = 6'h26;
  parameter ES_FSM_CTRLSTOP_READ    = 6'h27;
  parameter ES_FSM_CTRLSTOP_RRDY    = 6'h28;
  parameter ES_FSM_CTRLSTOP_WRITE   = 6'h29;
  parameter ES_FSM_CTRLSTOP_WRDY    = 6'h2a;
  parameter ES_FSM_SCNT_READ        = 6'h2b;
  parameter ES_FSM_SCNT_RRDY        = 6'h2c;
  parameter ES_FSM_ECNT_READ        = 6'h2d;
  parameter ES_FSM_ECNT_RRDY        = 6'h2e;
  parameter ES_FSM_DATA             = 6'h2f;

  // drp interface

  input           drp_rst;
  input           drp_clk;
  output          es_sel;
  output          es_wr;
  output  [11:0]  es_addr;
  output  [15:0]  es_wdata;
  input   [15:0]  es_rdata;
  input           es_ready;

  // axi4 interface

  input           axi_rstn;
  input           axi_clk;
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

  input           es_start;
  input           es_stop;
  input           es_init;
  input   [15:0]  es_sdata0;
  input   [15:0]  es_sdata1;
  input   [15:0]  es_sdata2;
  input   [15:0]  es_sdata3;
  input   [15:0]  es_sdata4;
  input   [15:0]  es_qdata0;
  input   [15:0]  es_qdata1;
  input   [15:0]  es_qdata2;
  input   [15:0]  es_qdata3;
  input   [15:0]  es_qdata4;
  input   [ 4:0]  es_prescale;
  input   [11:0]  es_hoffset_min;
  input   [11:0]  es_hoffset_max;
  input   [11:0]  es_hoffset_step;
  input   [ 7:0]  es_voffset_min;
  input   [ 7:0]  es_voffset_max;
  input   [ 7:0]  es_voffset_step;
  input   [ 1:0]  es_voffset_range;
  input   [31:0]  es_start_addr;
  output          es_dmaerr;
  output          es_status;

  // debug interface

  output [275:0]  es_dbg_data;
  output  [ 7:0]  es_dbg_trigger;

  // internal registers

  reg             axi_req_toggle_m1 = 'd0;
  reg             axi_req_toggle_m2 = 'd0;
  reg             axi_req_toggle_m3 = 'd0;
  reg             axi_awvalid = 'd0;
  reg     [31:0]  axi_awaddr = 'd0;
  reg             axi_wvalid = 'd0;
  reg     [31:0]  axi_wdata = 'd0;
  reg             axi_err = 'd0;
  reg             es_dmaerr_m1 = 'd0;
  reg             es_dmaerr = 'd0;
  reg             es_dma_req_toggle = 'd0;
  reg     [31:0]  es_dma_addr = 'd0;
  reg     [31:0]  es_dma_data = 'd0;
  reg             es_status = 'd0;
  reg             es_ut = 'd0;
  reg     [31:0]  es_dma_addr_int = 'd0;
  reg     [11:0]  es_hoffset = 'd0;
  reg     [ 7:0]  es_voffset = 'd0;
  reg     [15:0]  es_hoffset_rdata = 'd0;
  reg     [15:0]  es_voffset_rdata = 'd0;
  reg     [15:0]  es_ctrl_rdata = 'd0;
  reg     [15:0]  es_scnt_rdata = 'd0;
  reg     [15:0]  es_ecnt_rdata = 'd0;
  reg     [ 5:0]  es_fsm = 'd0;
  reg             es_sel = 'd0;
  reg             es_wr = 'd0;
  reg     [11:0]  es_addr = 'd0;
  reg     [15:0]  es_wdata = 'd0;

  // internal signals

  wire            axi_req_s;
  wire            es_heos_s;
  wire            es_eos_s;
  wire    [ 7:0]  es_voffset_2_s;
  wire    [ 7:0]  es_voffset_n_s;
  wire    [ 7:0]  es_voffset_s;

  // debug interface

  assign es_dbg_trigger = {es_start, es_eos_s, es_fsm};

  assign es_dbg_data[  0:  0] = es_sel;
  assign es_dbg_data[  1:  1] = es_wr;
  assign es_dbg_data[ 13:  2] = es_addr;
  assign es_dbg_data[ 29: 14] = es_wdata;
  assign es_dbg_data[ 45: 30] = es_rdata;
  assign es_dbg_data[ 46: 46] = es_ready;
  assign es_dbg_data[ 47: 47] = axi_awvalid;
  assign es_dbg_data[ 79: 48] = axi_awaddr;
  assign es_dbg_data[ 80: 80] = axi_awready;
  assign es_dbg_data[ 81: 81] = axi_wvalid;
  assign es_dbg_data[113: 82] = axi_wdata;
  assign es_dbg_data[117:114] = axi_wstrb;
  assign es_dbg_data[118:118] = axi_wready;
  assign es_dbg_data[119:119] = axi_bvalid;
  assign es_dbg_data[121:120] = axi_bresp;
  assign es_dbg_data[122:122] = axi_bready;
  assign es_dbg_data[123:123] = es_dmaerr;
  assign es_dbg_data[124:124] = es_start;
  assign es_dbg_data[125:125] = es_init;
  assign es_dbg_data[126:126] = es_status;
  assign es_dbg_data[127:127] = es_ut;
  assign es_dbg_data[159:128] = es_dma_addr_int;
  assign es_dbg_data[171:160] = es_hoffset;
  assign es_dbg_data[179:172] = es_voffset;
  assign es_dbg_data[195:180] = es_hoffset_rdata;
  assign es_dbg_data[211:196] = es_voffset_rdata;
  assign es_dbg_data[227:212] = es_ctrl_rdata;
  assign es_dbg_data[243:228] = es_scnt_rdata;
  assign es_dbg_data[259:244] = es_ecnt_rdata;
  assign es_dbg_data[265:260] = es_fsm;
  assign es_dbg_data[266:266] = es_heos_s;
  assign es_dbg_data[267:267] = es_eos_s;
  assign es_dbg_data[275:268] = es_voffset_s;

  // axi write interface

  assign axi_awprot = 3'd0;
  assign axi_wstrb = 4'hf;
  assign axi_bready = 1'd1;
  assign axi_arvalid = 1'd0;
  assign axi_araddr = 32'd0;
  assign axi_arprot = 3'd0;
  assign axi_rready = 1'd1;

  assign axi_req_s = axi_req_toggle_m3 ^ axi_req_toggle_m2;

  always @(negedge axi_rstn or posedge axi_clk) begin
    if (axi_rstn == 0) begin
      axi_req_toggle_m1 <= 'd0;
      axi_req_toggle_m2 <= 'd0;
      axi_req_toggle_m3 <= 'd0;
      axi_awvalid <= 'b0;
      axi_awaddr <= 'd0;
      axi_wvalid <= 'b0;
      axi_wdata <= 'd0;
      axi_err <= 'd0;
    end else begin
      axi_req_toggle_m1 <= es_dma_req_toggle;
      axi_req_toggle_m2 <= axi_req_toggle_m1;
      axi_req_toggle_m3 <= axi_req_toggle_m2;
      if ((axi_awvalid == 1'b1) && (axi_awready == 1'b1)) begin
        axi_awvalid <= 1'b0;
        axi_awaddr <= 32'd0;
      end else if (axi_req_s == 1'b1) begin
        axi_awvalid <= 1'b1;
        axi_awaddr <= es_dma_addr;
      end
      if ((axi_wvalid == 1'b1) && (axi_wready == 1'b1)) begin
        axi_wvalid <= 1'b0;
        axi_wdata <= 32'd0;
      end else if (axi_req_s == 1'b1) begin
        axi_wvalid <= 1'b1;
        axi_wdata <= es_dma_data;
      end
      if (axi_bvalid == 1'b1) begin
        axi_err <= axi_bresp[1] | axi_bresp[0];
      end
    end
  end

  always @(posedge drp_clk) begin
    if (drp_rst == 1'b1) begin
      es_dmaerr_m1 <= 'd0;
      es_dmaerr <= 'd0;
      es_dma_req_toggle <= 'd0;
      es_dma_addr <= 'd0;
      es_dma_data <= 'd0;
    end else begin
      es_dmaerr_m1 <= axi_err;
      es_dmaerr <= es_dmaerr_m1;
      if (es_fsm == ES_FSM_DATA) begin
        es_dma_req_toggle <= ~es_dma_req_toggle;
        es_dma_addr <= es_dma_addr_int;
        es_dma_data <= {es_scnt_rdata, es_ecnt_rdata};
      end
    end
  end

  // prescale, horizontal and vertical offsets

  assign es_heos_s = (es_hoffset == es_hoffset_max) ? es_ut : 1'b0;
  assign es_eos_s = (es_voffset == es_voffset_max) ? es_heos_s : 1'b0;

  assign es_voffset_2_s = ~es_voffset + 1'b1;
  assign es_voffset_n_s = {1'b1, es_voffset_2_s[6:0]};
  assign es_voffset_s = (es_voffset[7] == 1'b1) ? es_voffset_n_s : es_voffset;

  always @(posedge drp_clk) begin
    if (es_fsm == ES_FSM_IDLE) begin
      es_status <= 1'b0;
    end else begin
      es_status <= 1'b1;
    end
    if (es_fsm == ES_FSM_IDLE) begin
      es_ut <= 1'b0;
      es_dma_addr_int <= es_start_addr;
      es_hoffset <= es_hoffset_min;
      es_voffset <= es_voffset_min;
    end else if (es_fsm == ES_FSM_DATA) begin
      es_ut <= ~es_ut;
      es_dma_addr_int <= es_dma_addr_int + 3'd4;
      if (es_heos_s == 1'b1) begin
        es_hoffset <= es_hoffset_min;
      end else if (es_ut == 1'b1) begin
        es_hoffset <= es_hoffset + es_hoffset_step;
      end
      if (es_heos_s == 1'b1) begin
        es_voffset <= es_voffset + es_voffset_step;
      end
    end
  end

  // read-modify-write parameters (gt's are full of mixed up controls)

  always @(posedge drp_clk) begin
    if ((es_fsm == ES_FSM_HOFFSET_RRDY) && (es_ready == 1'b1)) begin
      es_hoffset_rdata <= es_rdata;
    end
    if ((es_fsm == ES_FSM_VOFFSET_RRDY) && (es_ready == 1'b1)) begin
      es_voffset_rdata <= es_rdata;
    end
    if (((es_fsm == ES_FSM_CTRLINIT_RRDY) || (es_fsm == ES_FSM_CTRLSTART_RRDY) ||
      (es_fsm == ES_FSM_CTRLSTOP_RRDY)) && (es_ready == 1'b1)) begin
      es_ctrl_rdata <= es_rdata;
    end
    if ((es_fsm == ES_FSM_SCNT_RRDY) && (es_ready == 1'b1)) begin
      es_scnt_rdata <= es_rdata;
    end
    if ((es_fsm == ES_FSM_ECNT_RRDY) && (es_ready == 1'b1)) begin
      es_ecnt_rdata <= es_rdata;
    end
  end

  // eye scan state machine- write vertical and horizontal offsets
  // and read back sample and error counters

  always @(posedge drp_clk) begin
    if ((drp_rst == 1'b1) || (es_stop == 1'b1)) begin
      es_fsm <= ES_FSM_IDLE;
    end else begin
      case (es_fsm)
        ES_FSM_IDLE: begin // idle
          if (es_start == 1'b1) begin
            es_fsm <= ES_FSM_STATUS;
          end else begin
            es_fsm <= ES_FSM_IDLE;
          end
        end

        ES_FSM_STATUS: begin // set status
          es_fsm <= ES_FSM_INIT;
        end

        ES_FSM_INIT: begin // initialize
          if (es_init == 1'b1) begin
            es_fsm <= ES_FSM_CTRLINIT_READ;
          end else begin
            es_fsm <= ES_FSM_HOFFSET_READ;
          end
        end

        ES_FSM_CTRLINIT_READ: begin // control read
          es_fsm <= ES_FSM_CTRLINIT_RRDY;
        end
        ES_FSM_CTRLINIT_RRDY: begin // control ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_CTRLINIT_WRITE;
          end else begin
            es_fsm <= ES_FSM_CTRLINIT_RRDY;
          end
        end
        ES_FSM_CTRLINIT_WRITE: begin // control write
          es_fsm <= ES_FSM_CTRLINIT_WRDY;
        end
        ES_FSM_CTRLINIT_WRDY: begin // control ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_SDATA0_WRITE;
          end else begin
            es_fsm <= ES_FSM_CTRLINIT_WRDY;
          end
        end
     
        ES_FSM_SDATA0_WRITE: begin // sdata write
          es_fsm <= ES_FSM_SDATA0_WRDY;
        end
        ES_FSM_SDATA0_WRDY: begin // sdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_SDATA1_WRITE;
          end else begin
            es_fsm <= ES_FSM_SDATA0_WRDY;
          end
        end
        ES_FSM_SDATA1_WRITE: begin // sdata write
          es_fsm <= ES_FSM_SDATA1_WRDY;
        end
        ES_FSM_SDATA1_WRDY: begin // sdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_SDATA2_WRITE;
          end else begin
            es_fsm <= ES_FSM_SDATA1_WRDY;
          end
        end
        ES_FSM_SDATA2_WRITE: begin // sdata write
          es_fsm <= ES_FSM_SDATA2_WRDY;
        end
        ES_FSM_SDATA2_WRDY: begin // sdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_SDATA3_WRITE;
          end else begin
            es_fsm <= ES_FSM_SDATA2_WRDY;
          end
        end
        ES_FSM_SDATA3_WRITE: begin // sdata write
          es_fsm <= ES_FSM_SDATA3_WRDY;
        end
        ES_FSM_SDATA3_WRDY: begin // sdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_SDATA4_WRITE;
          end else begin
            es_fsm <= ES_FSM_SDATA3_WRDY;
          end
        end
        ES_FSM_SDATA4_WRITE: begin // sdata write
          es_fsm <= ES_FSM_SDATA4_WRDY;
        end
        ES_FSM_SDATA4_WRDY: begin // sdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_QDATA0_WRITE;
          end else begin
            es_fsm <= ES_FSM_SDATA4_WRDY;
          end
        end
     
        ES_FSM_QDATA0_WRITE: begin // qdata write
          es_fsm <= ES_FSM_QDATA0_WRDY;
        end
        ES_FSM_QDATA0_WRDY: begin // qdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_QDATA1_WRITE;
          end else begin
            es_fsm <= ES_FSM_QDATA0_WRDY;
          end
        end
        ES_FSM_QDATA1_WRITE: begin // qdata write
          es_fsm <= ES_FSM_QDATA1_WRDY;
        end
        ES_FSM_QDATA1_WRDY: begin // qdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_QDATA2_WRITE;
          end else begin
            es_fsm <= ES_FSM_QDATA1_WRDY;
          end
        end
        ES_FSM_QDATA2_WRITE: begin // qdata write
          es_fsm <= ES_FSM_QDATA2_WRDY;
        end
        ES_FSM_QDATA2_WRDY: begin // qdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_QDATA3_WRITE;
          end else begin
            es_fsm <= ES_FSM_QDATA2_WRDY;
          end
        end
        ES_FSM_QDATA3_WRITE: begin // qdata write
          es_fsm <= ES_FSM_QDATA3_WRDY;
        end
        ES_FSM_QDATA3_WRDY: begin // qdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_QDATA4_WRITE;
          end else begin
            es_fsm <= ES_FSM_QDATA3_WRDY;
          end
        end
        ES_FSM_QDATA4_WRITE: begin // qdata write
          es_fsm <= ES_FSM_QDATA4_WRDY;
        end
        ES_FSM_QDATA4_WRDY: begin // qdata ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_HOFFSET_READ;
          end else begin
            es_fsm <= ES_FSM_QDATA4_WRDY;
          end
        end
     
        ES_FSM_HOFFSET_READ: begin // horizontal offset read
          es_fsm <= ES_FSM_HOFFSET_RRDY;
        end
        ES_FSM_HOFFSET_RRDY: begin // horizontal offset ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_HOFFSET_WRITE;
          end else begin
            es_fsm <= ES_FSM_HOFFSET_RRDY;
          end
        end
        ES_FSM_HOFFSET_WRITE: begin // horizontal offset write
          es_fsm <= ES_FSM_HOFFSET_WRDY;
        end
        ES_FSM_HOFFSET_WRDY: begin // horizontal offset ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_VOFFSET_READ;
          end else begin
            es_fsm <= ES_FSM_HOFFSET_WRDY;
          end
        end
     
        ES_FSM_VOFFSET_READ: begin // vertical offset read
          es_fsm <= ES_FSM_VOFFSET_RRDY;
        end
        ES_FSM_VOFFSET_RRDY: begin // vertical offset ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_VOFFSET_WRITE;
          end else begin
            es_fsm <= ES_FSM_VOFFSET_RRDY;
          end
        end
        ES_FSM_VOFFSET_WRITE: begin // vertical offset write
          es_fsm <= ES_FSM_VOFFSET_WRDY;
        end
        ES_FSM_VOFFSET_WRDY: begin // vertical offset ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_CTRLSTART_READ;
          end else begin
            es_fsm <= ES_FSM_VOFFSET_WRDY;
          end
        end
     
        ES_FSM_CTRLSTART_READ: begin // control read
          es_fsm <= ES_FSM_CTRLSTART_RRDY;
        end
        ES_FSM_CTRLSTART_RRDY: begin // control ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_CTRLSTART_WRITE;
          end else begin
            es_fsm <= ES_FSM_CTRLSTART_RRDY;
          end
        end
        ES_FSM_CTRLSTART_WRITE: begin // control write
          es_fsm <= ES_FSM_CTRLSTART_WRDY;
        end
        ES_FSM_CTRLSTART_WRDY: begin // control ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_STATUS_READ;
          end else begin
            es_fsm <= ES_FSM_CTRLSTART_WRDY;
          end
        end
     
        ES_FSM_STATUS_READ: begin // status read
          es_fsm <= ES_FSM_STATUS_RRDY;
        end
        ES_FSM_STATUS_RRDY: begin // status ready
          if (es_ready == 1'b0) begin
            es_fsm <= ES_FSM_STATUS_RRDY;
          end else if (es_rdata[3:0] == 4'b0101) begin
            es_fsm <= ES_FSM_CTRLSTOP_READ;
          end else begin
            es_fsm <= ES_FSM_STATUS_READ;
          end
        end
     
        ES_FSM_CTRLSTOP_READ: begin // control read
          es_fsm <= ES_FSM_CTRLSTOP_RRDY;
        end
        ES_FSM_CTRLSTOP_RRDY: begin // control ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_CTRLSTOP_WRITE;
          end else begin
            es_fsm <= ES_FSM_CTRLSTOP_RRDY;
          end
        end
        ES_FSM_CTRLSTOP_WRITE: begin // control write
          es_fsm <= ES_FSM_CTRLSTOP_WRDY;
        end
        ES_FSM_CTRLSTOP_WRDY: begin // control ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_SCNT_READ;
          end else begin
            es_fsm <= ES_FSM_CTRLSTOP_WRDY;
          end
        end
     
        ES_FSM_SCNT_READ: begin // read sample count
          es_fsm <= ES_FSM_SCNT_RRDY;
        end
        ES_FSM_SCNT_RRDY: begin // sample count ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_ECNT_READ;
          end else begin
            es_fsm <= ES_FSM_SCNT_RRDY;
          end
        end
     
        ES_FSM_ECNT_READ: begin // read error count
          es_fsm <= ES_FSM_ECNT_RRDY;
        end
        ES_FSM_ECNT_RRDY: begin // error count ready
          if (es_ready == 1'b1) begin
            es_fsm <= ES_FSM_DATA;
          end else begin
            es_fsm <= ES_FSM_ECNT_RRDY;
          end
        end
     
        ES_FSM_DATA: begin // data phase
          if (es_eos_s == 1'b1) begin
            es_fsm <= ES_FSM_IDLE;
          end else if (es_ut == 1'b1) begin
            es_fsm <= ES_FSM_HOFFSET_READ;
          end else begin
            es_fsm <= ES_FSM_VOFFSET_READ;
          end
        end
     
        default: begin
          es_fsm <= ES_FSM_IDLE;
        end
      endcase
    end
  end

  // drp signals controlled by the fsm

  always @(posedge drp_clk) begin
    case (es_fsm)
      ES_FSM_CTRLINIT_READ: begin 
        es_sel <= 1'b1;
        es_wr <= 1'b0;
        es_addr <= ES_DRP_CTRL_ADDR;
        es_wdata <= 16'h0000;
      end
      ES_FSM_CTRLINIT_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_CTRL_ADDR;
        if (GTH_GTX_N == 1) begin
        es_wdata <= {es_ctrl_rdata[15:10], 2'b11, es_ctrl_rdata[7:5], es_prescale};
        end else begin
        es_wdata <= {es_ctrl_rdata[15:10], 2'b11, es_ctrl_rdata[7:0]};
        end
      end
      ES_FSM_SDATA0_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_SDATA0_ADDR;
        es_wdata <= es_sdata0;
      end
      ES_FSM_SDATA1_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_SDATA1_ADDR;
        es_wdata <= es_sdata1;
      end
      ES_FSM_SDATA2_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_SDATA2_ADDR;
        es_wdata <= es_sdata2;
      end
      ES_FSM_SDATA3_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_SDATA3_ADDR;
        es_wdata <= es_sdata3;
      end
      ES_FSM_SDATA4_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_SDATA4_ADDR;
        es_wdata <= es_sdata4;
      end
      ES_FSM_QDATA0_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_QDATA0_ADDR;
        es_wdata <= es_qdata0;
      end
      ES_FSM_QDATA1_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_QDATA1_ADDR;
        es_wdata <= es_qdata1;
      end
      ES_FSM_QDATA2_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_QDATA2_ADDR;
        es_wdata <= es_qdata2;
      end
      ES_FSM_QDATA3_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_QDATA3_ADDR;
        es_wdata <= es_qdata3;
      end
      ES_FSM_QDATA4_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_QDATA4_ADDR;
        es_wdata <= es_qdata4;
      end
      ES_FSM_HOFFSET_READ: begin
        es_sel <= 1'b1;
        es_wr <= 1'b0;
        es_addr <= ES_DRP_HOFFSET_ADDR;
        es_wdata <= 16'h0000;
      end
      ES_FSM_HOFFSET_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_HOFFSET_ADDR;
        if (GTH_GTX_N == 1) begin
        es_wdata <= {es_hoffset, es_hoffset_rdata[3:0]};
        end else begin
        es_wdata <= {es_hoffset_rdata[15:12], es_hoffset};
        end
      end
      ES_FSM_VOFFSET_READ: begin
        es_sel <= 1'b1;
        es_wr <= 1'b0;
        es_addr <= ES_DRP_VOFFSET_ADDR;
        es_wdata <= 16'h0000;
      end
      ES_FSM_VOFFSET_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_VOFFSET_ADDR;
        if (GTH_GTX_N == 1) begin
        es_wdata <= {es_voffset_rdata[15:11], es_voffset_s[7], es_ut, es_voffset_s[6:0], es_voffset_range};
        end else begin
        es_wdata <= {es_prescale, es_voffset_rdata[10:9], es_ut, es_voffset_s};
        end
      end
      ES_FSM_CTRLSTART_READ: begin
        es_sel <= 1'b1;
        es_wr <= 1'b0;
        es_addr <= ES_DRP_CTRL_ADDR;
        es_wdata <= 16'h0000;
      end
      ES_FSM_CTRLSTART_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_CTRL_ADDR;
        if (GTH_GTX_N == 1) begin
        es_wdata <= {6'd1, es_ctrl_rdata[9:0]};
        end else begin
        es_wdata <= {es_ctrl_rdata[15:6], 6'd1};
        end
      end
      ES_FSM_STATUS_READ: begin
        es_sel <= 1'b1;
        es_wr <= 1'b0;
        es_addr <= ES_DRP_STATUS_ADDR;
        es_wdata <= 16'h0000;
      end
      ES_FSM_CTRLSTOP_READ: begin
        es_sel <= 1'b1;
        es_wr <= 1'b0;
        es_addr <= ES_DRP_CTRL_ADDR;
        es_wdata <= 16'h0000;
      end
      ES_FSM_CTRLSTOP_WRITE: begin
        es_sel <= 1'b1;
        es_wr <= 1'b1;
        es_addr <= ES_DRP_CTRL_ADDR;
        if (GTH_GTX_N == 1) begin
        es_wdata <= {6'd0, es_ctrl_rdata[9:0]};
        end else begin
        es_wdata <= {es_ctrl_rdata[15:6], 6'd0};
        end
      end
      ES_FSM_SCNT_READ: begin
        es_sel <= 1'b1;
        es_wr <= 1'b0;
        es_addr <= ES_DRP_SCNT_ADDR;
        es_wdata <= 16'h0000;
      end
      ES_FSM_ECNT_READ: begin
        es_sel <= 1'b1;
        es_wr <= 1'b0;
        es_addr <= ES_DRP_ECNT_ADDR;
        es_wdata <= 16'h0000;
      end
      default: begin
        es_sel <= 1'b0;
        es_wr <= 1'b0;
        es_addr <= 9'h000;
        es_wdata <= 16'h0000;
      end
    endcase
  end

endmodule

// ***************************************************************************
// ***************************************************************************
