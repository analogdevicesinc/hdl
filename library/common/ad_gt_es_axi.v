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

module ad_gt_es_axi (

  // es interface

  up_rstn,
  up_clk,
  up_es_dma_req_0,
  up_es_dma_addr_0,
  up_es_dma_data_0,
  up_es_dma_ack_0,
  up_es_dma_err_0,
  up_es_dma_req_1,
  up_es_dma_addr_1,
  up_es_dma_data_1,
  up_es_dma_ack_1,
  up_es_dma_err_1,
  up_es_dma_req_2,
  up_es_dma_addr_2,
  up_es_dma_data_2,
  up_es_dma_ack_2,
  up_es_dma_err_2,
  up_es_dma_req_3,
  up_es_dma_addr_3,
  up_es_dma_data_3,
  up_es_dma_ack_3,
  up_es_dma_err_3,
  up_es_dma_req_4,
  up_es_dma_addr_4,
  up_es_dma_data_4,
  up_es_dma_ack_4,
  up_es_dma_err_4,
  up_es_dma_req_5,
  up_es_dma_addr_5,
  up_es_dma_data_5,
  up_es_dma_ack_5,
  up_es_dma_err_5,
  up_es_dma_req_6,
  up_es_dma_addr_6,
  up_es_dma_data_6,
  up_es_dma_ack_6,
  up_es_dma_err_6,
  up_es_dma_req_7,
  up_es_dma_addr_7,
  up_es_dma_data_7,
  up_es_dma_ack_7,
  up_es_dma_err_7,

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
  axi_rready);

  // state machine (fair RR?)

  localparam  [ 3:0]  AXI_FSM_SCAN_0  = 4'h0;
  localparam  [ 3:0]  AXI_FSM_SCAN_1  = 4'h1;
  localparam  [ 3:0]  AXI_FSM_SCAN_2  = 4'h2;
  localparam  [ 3:0]  AXI_FSM_SCAN_3  = 4'h3;
  localparam  [ 3:0]  AXI_FSM_SCAN_4  = 4'h4;
  localparam  [ 3:0]  AXI_FSM_SCAN_5  = 4'h5;
  localparam  [ 3:0]  AXI_FSM_SCAN_6  = 4'h6;
  localparam  [ 3:0]  AXI_FSM_SCAN_7  = 4'h7;
  localparam  [ 3:0]  AXI_FSM_WRITE   = 4'h8;
  localparam  [ 3:0]  AXI_FSM_WAIT    = 4'h9;
  localparam  [ 3:0]  AXI_FSM_ACK     = 4'ha;

  // es interface

  input           up_rstn;
  input           up_clk;
  input           up_es_dma_req_0;
  input   [31:0]  up_es_dma_addr_0;
  input   [31:0]  up_es_dma_data_0;
  output          up_es_dma_ack_0;
  output          up_es_dma_err_0;
  input           up_es_dma_req_1;
  input   [31:0]  up_es_dma_addr_1;
  input   [31:0]  up_es_dma_data_1;
  output          up_es_dma_ack_1;
  output          up_es_dma_err_1;
  input           up_es_dma_req_2;
  input   [31:0]  up_es_dma_addr_2;
  input   [31:0]  up_es_dma_data_2;
  output          up_es_dma_ack_2;
  output          up_es_dma_err_2;
  input           up_es_dma_req_3;
  input   [31:0]  up_es_dma_addr_3;
  input   [31:0]  up_es_dma_data_3;
  output          up_es_dma_ack_3;
  output          up_es_dma_err_3;
  input           up_es_dma_req_4;
  input   [31:0]  up_es_dma_addr_4;
  input   [31:0]  up_es_dma_data_4;
  output          up_es_dma_ack_4;
  output          up_es_dma_err_4;
  input           up_es_dma_req_5;
  input   [31:0]  up_es_dma_addr_5;
  input   [31:0]  up_es_dma_data_5;
  output          up_es_dma_ack_5;
  output          up_es_dma_err_5;
  input           up_es_dma_req_6;
  input   [31:0]  up_es_dma_addr_6;
  input   [31:0]  up_es_dma_data_6;
  output          up_es_dma_ack_6;
  output          up_es_dma_err_6;
  input           up_es_dma_req_7;
  input   [31:0]  up_es_dma_addr_7;
  input   [31:0]  up_es_dma_data_7;
  output          up_es_dma_ack_7;
  output          up_es_dma_err_7;

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

  // internal registers

  reg             up_es_dma_ack_0 = 'd0;
  reg             up_es_dma_err_0 = 'd0;
  reg             up_es_dma_ack_1 = 'd0;
  reg             up_es_dma_err_1 = 'd0;
  reg             up_es_dma_ack_2 = 'd0;
  reg             up_es_dma_err_2 = 'd0;
  reg             up_es_dma_ack_3 = 'd0;
  reg             up_es_dma_err_3 = 'd0;
  reg             up_es_dma_ack_4 = 'd0;
  reg             up_es_dma_err_4 = 'd0;
  reg             up_es_dma_ack_5 = 'd0;
  reg             up_es_dma_err_5 = 'd0;
  reg             up_es_dma_ack_6 = 'd0;
  reg             up_es_dma_err_6 = 'd0;
  reg             up_es_dma_ack_7 = 'd0;
  reg             up_es_dma_err_7 = 'd0;
  reg             axi_awvalid = 'd0;
  reg     [31:0]  axi_awaddr = 'd0;
  reg             axi_wvalid = 'd0;
  reg     [31:0]  axi_wdata = 'd0;
  reg             axi_error = 'd0;
  reg     [ 2:0]  axi_sel = 'd0;
  reg     [ 3:0]  axi_fsm = 'd0;

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
      up_es_dma_ack_0 <= 1'b0;
      up_es_dma_err_0 <= 1'b0;
      up_es_dma_ack_1 <= 1'b0;
      up_es_dma_err_1 <= 1'b0;
      up_es_dma_ack_2 <= 1'b0;
      up_es_dma_err_2 <= 1'b0;
      up_es_dma_ack_3 <= 1'b0;
      up_es_dma_err_3 <= 1'b0;
      up_es_dma_ack_4 <= 1'b0;
      up_es_dma_err_4 <= 1'b0;
      up_es_dma_ack_5 <= 1'b0;
      up_es_dma_err_5 <= 1'b0;
      up_es_dma_ack_6 <= 1'b0;
      up_es_dma_err_6 <= 1'b0;
      up_es_dma_ack_7 <= 1'b0;
      up_es_dma_err_7 <= 1'b0;
    end else begin
      if ((axi_fsm == AXI_FSM_ACK) && (axi_sel == 3'd0)) begin
        up_es_dma_ack_0 <= 1'b1;
        up_es_dma_err_0 <= axi_error;
      end else begin
        up_es_dma_ack_0 <= 1'b0;
        up_es_dma_err_0 <= 1'b0;
      end
      if ((axi_fsm == AXI_FSM_ACK) && (axi_sel == 3'd1)) begin
        up_es_dma_ack_1 <= 1'b1;
        up_es_dma_err_1 <= axi_error;
      end else begin
        up_es_dma_ack_1 <= 1'b0;
        up_es_dma_err_1 <= 1'b0;
      end
      if ((axi_fsm == AXI_FSM_ACK) && (axi_sel == 3'd2)) begin
        up_es_dma_ack_2 <= 1'b1;
        up_es_dma_err_2 <= axi_error;
      end else begin
        up_es_dma_ack_2 <= 1'b0;
        up_es_dma_err_2 <= 1'b0;
      end
      if ((axi_fsm == AXI_FSM_ACK) && (axi_sel == 3'd3)) begin
        up_es_dma_ack_3 <= 1'b1;
        up_es_dma_err_3 <= axi_error;
      end else begin
        up_es_dma_ack_3 <= 1'b0;
        up_es_dma_err_3 <= 1'b0;
      end
      if ((axi_fsm == AXI_FSM_ACK) && (axi_sel == 3'd4)) begin
        up_es_dma_ack_4 <= 1'b1;
        up_es_dma_err_4 <= axi_error;
      end else begin
        up_es_dma_ack_4 <= 1'b0;
        up_es_dma_err_4 <= 1'b0;
      end
      if ((axi_fsm == AXI_FSM_ACK) && (axi_sel == 3'd5)) begin
        up_es_dma_ack_5 <= 1'b1;
        up_es_dma_err_5 <= axi_error;
      end else begin
        up_es_dma_ack_5 <= 1'b0;
        up_es_dma_err_5 <= 1'b0;
      end
      if ((axi_fsm == AXI_FSM_ACK) && (axi_sel == 3'd6)) begin
        up_es_dma_ack_6 <= 1'b1;
        up_es_dma_err_6 <= axi_error;
      end else begin
        up_es_dma_ack_6 <= 1'b0;
        up_es_dma_err_6 <= 1'b0;
      end
      if ((axi_fsm == AXI_FSM_ACK) && (axi_sel == 3'd7)) begin
        up_es_dma_ack_7 <= 1'b1;
        up_es_dma_err_7 <= axi_error;
      end else begin
        up_es_dma_ack_7 <= 1'b0;
        up_es_dma_err_7 <= 1'b0;
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      axi_awvalid <= 'b0;
      axi_awaddr <= 'd0;
      axi_wvalid <= 'b0;
      axi_wdata <= 'd0;
      axi_error <= 'd0;
    end else begin
      if ((axi_awvalid == 1'b1) && (axi_awready == 1'b1)) begin
        axi_awvalid <= 1'b0;
        axi_awaddr <= 32'd0;
      end else if (axi_fsm == AXI_FSM_WRITE) begin
        axi_awvalid <= 1'b1;
        case (axi_sel)
          3'b000:  axi_awaddr <= up_es_dma_addr_0;
          3'b001:  axi_awaddr <= up_es_dma_addr_1;
          3'b010:  axi_awaddr <= up_es_dma_addr_2;
          3'b011:  axi_awaddr <= up_es_dma_addr_3;
          3'b100:  axi_awaddr <= up_es_dma_addr_4;
          3'b101:  axi_awaddr <= up_es_dma_addr_5;
          3'b110:  axi_awaddr <= up_es_dma_addr_6;
          default: axi_awaddr <= up_es_dma_addr_7;
        endcase
      end
      if ((axi_wvalid == 1'b1) && (axi_wready == 1'b1)) begin
        axi_wvalid <= 1'b0;
        axi_wdata <= 32'd0;
      end else if (axi_fsm == AXI_FSM_WRITE) begin
        axi_wvalid <= 1'b1;
        case (axi_sel)
          3'b000:  axi_wdata <= up_es_dma_data_0;
          3'b001:  axi_wdata <= up_es_dma_data_1;
          3'b010:  axi_wdata <= up_es_dma_data_2;
          3'b011:  axi_wdata <= up_es_dma_data_3;
          3'b100:  axi_wdata <= up_es_dma_data_4;
          3'b101:  axi_wdata <= up_es_dma_data_5;
          3'b110:  axi_wdata <= up_es_dma_data_6;
          default: axi_wdata <= up_es_dma_data_7;
        endcase
      end
      if (axi_bvalid == 1'b1) begin
        axi_error <= axi_bresp[1] | axi_bresp[0];
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      axi_sel <= 3'd0;
      axi_fsm <= AXI_FSM_SCAN_0;
    end else begin
      case (axi_fsm)
        AXI_FSM_SCAN_0: begin
          axi_sel <= 3'd0;
          if (up_es_dma_req_0 == 1'b1) begin
            axi_fsm <= AXI_FSM_WRITE;
          end else begin
            axi_fsm <= AXI_FSM_SCAN_1;
          end
        end
        AXI_FSM_SCAN_1: begin
          axi_sel <= 3'd1;
          if (up_es_dma_req_1 == 1'b1) begin
            axi_fsm <= AXI_FSM_WRITE;
          end else begin
            axi_fsm <= AXI_FSM_SCAN_2;
          end
        end
        AXI_FSM_SCAN_2: begin
          axi_sel <= 3'd2;
          if (up_es_dma_req_2 == 1'b1) begin
            axi_fsm <= AXI_FSM_WRITE;
          end else begin
            axi_fsm <= AXI_FSM_SCAN_3;
          end
        end
        AXI_FSM_SCAN_3: begin
          axi_sel <= 3'd3;
          if (up_es_dma_req_3 == 1'b1) begin
            axi_fsm <= AXI_FSM_WRITE;
          end else begin
            axi_fsm <= AXI_FSM_SCAN_4;
          end
        end
        AXI_FSM_SCAN_4: begin
          axi_sel <= 3'd4;
          if (up_es_dma_req_4 == 1'b1) begin
            axi_fsm <= AXI_FSM_WRITE;
          end else begin
            axi_fsm <= AXI_FSM_SCAN_5;
          end
        end
        AXI_FSM_SCAN_5: begin
          axi_sel <= 3'd5;
          if (up_es_dma_req_5 == 1'b1) begin
            axi_fsm <= AXI_FSM_WRITE;
          end else begin
            axi_fsm <= AXI_FSM_SCAN_6;
          end
        end
        AXI_FSM_SCAN_6: begin
          axi_sel <= 3'd6;
          if (up_es_dma_req_6 == 1'b1) begin
            axi_fsm <= AXI_FSM_WRITE;
          end else begin
            axi_fsm <= AXI_FSM_SCAN_7;
          end
        end
        AXI_FSM_SCAN_7: begin
          axi_sel <= 3'd7;
          if (up_es_dma_req_7 == 1'b1) begin
            axi_fsm <= AXI_FSM_WRITE;
          end else begin
            axi_fsm <= AXI_FSM_SCAN_0;
          end
        end
  
        AXI_FSM_WRITE: begin
          axi_sel <= axi_sel;
          axi_fsm <= AXI_FSM_WAIT;
        end
        AXI_FSM_WAIT: begin
          axi_sel <= axi_sel;
          if (axi_bvalid == 1'b1) begin
            axi_fsm <= AXI_FSM_ACK;
          end else begin
            axi_fsm <= AXI_FSM_WAIT;
          end
        end
        AXI_FSM_ACK: begin
          axi_sel <= axi_sel;
          case (axi_sel)
            3'b000:  axi_fsm <= AXI_FSM_SCAN_1;
            3'b001:  axi_fsm <= AXI_FSM_SCAN_2;
            3'b010:  axi_fsm <= AXI_FSM_SCAN_3;
            3'b011:  axi_fsm <= AXI_FSM_SCAN_4;
            3'b100:  axi_fsm <= AXI_FSM_SCAN_5;
            3'b101:  axi_fsm <= AXI_FSM_SCAN_6;
            3'b110:  axi_fsm <= AXI_FSM_SCAN_7;
            default: axi_fsm <= AXI_FSM_SCAN_0;
          endcase
        end

        default: begin
          axi_fsm <= AXI_FSM_SCAN_0;
        end
      endcase
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
