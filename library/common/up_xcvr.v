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

module up_xcvr (

  // common reset

  rst,

  // receive interface

  rx_clk,
  rx_rstn,
  rx_ext_sysref,
  rx_sysref,
  rx_ip_sync,
  rx_sync,
  rx_status,

  // transmit interface

  tx_clk,
  tx_rstn,
  tx_ext_sysref,
  tx_sysref,
  tx_sync,
  tx_ip_sync,
  tx_status,

  // bus interface

  up_rstn,
  up_clk,
  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack);

  // parameters

  localparam  PCORE_VERSION = 32'h00060162;
  parameter   ID = 0;
  parameter   DEVICE_TYPE = 0;

  // common reset

  output          rst;

  // receive interface

  input           rx_clk;
  output          rx_rstn;
  input           rx_ext_sysref;
  output          rx_sysref;
  input           rx_ip_sync;
  output          rx_sync;
  input   [ 7:0]  rx_status;

  // transmit interface

  input           tx_clk;
  output          tx_rstn;
  input           tx_ext_sysref;
  output          tx_sysref;
  input           tx_sync;
  output          tx_ip_sync;
  input   [ 7:0]  tx_status;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           up_wreq;
  input   [13:0]  up_waddr;
  input   [31:0]  up_wdata;
  output          up_wack;
  input           up_rreq;
  input   [13:0]  up_raddr;
  output  [31:0]  up_rdata;
  output          up_rack;

  // internal registers

  reg             up_reset = 'd1;
  reg             up_rx_reset = 'd1;
  reg             up_tx_reset = 'd1;
  reg             up_wack = 'd0;
  reg     [31:0]  up_scratch = 'd0;
  reg             up_resetn = 'd0;
  reg             up_rx_sysref_sel = 'd0;
  reg             up_rx_sysref = 'd0;
  reg             up_rx_sync = 'd0;
  reg             up_rx_resetn = 'd0;
  reg             up_tx_sysref_sel = 'd0;
  reg             up_tx_sysref = 'd0;
  reg             up_tx_sync = 'd0;
  reg             up_tx_resetn = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             rx_rstn = 'd0;
  reg             rx_sysref_sel_m1 = 'd0;
  reg             rx_sysref_sel = 'd0;
  reg             rx_up_sysref_m1 = 'd0;
  reg             rx_up_sysref = 'd0;
  reg             rx_sysref = 'd0;
  reg             rx_up_sync_m1 = 'd0;
  reg             rx_up_sync = 'd0;
  reg             rx_sync = 'd0;
  reg             tx_rstn = 'd0;
  reg             tx_sysref_sel_m1 = 'd0;
  reg             tx_sysref_sel = 'd0;
  reg             tx_up_sysref_m1 = 'd0;
  reg             tx_up_sysref = 'd0;
  reg             tx_sysref = 'd0;
  reg             tx_up_sync_m1 = 'd0;
  reg             tx_up_sync = 'd0;
  reg             tx_ip_sync = 'd0;
  reg     [ 8:0]  up_rx_status_m1 = 'd0;
  reg     [ 8:0]  up_rx_status = 'd0;
  reg     [ 8:0]  up_tx_status_m1 = 'd0;
  reg     [ 8:0]  up_tx_status = 'd0;

  // internal signals

  wire            rx_rst;
  wire            tx_rst;
  wire            up_wreq_s;
  wire            up_rreq_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == 6'h00) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == 6'h00) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_reset <= 1'b1;
      up_rx_reset <= 1'b1;
      up_tx_reset <= 1'b1;
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_resetn <= 'd0;
      up_rx_sysref_sel <= 'd0;
      up_rx_sysref <= 'd0;
      up_rx_sync <= 'd0;
      up_rx_resetn <= 'd0;
      up_tx_sysref_sel <= 'd0;
      up_tx_sysref <= 'd0;
      up_tx_sync <= 'd0;
      up_tx_resetn <= 'd0;
    end else begin
      up_reset <= ~up_resetn;
      up_rx_reset <= ~(up_resetn & up_rx_resetn);
      up_tx_reset <= ~(up_resetn & up_tx_resetn);
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h03)) begin
        up_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h10)) begin
        up_rx_sysref_sel <= up_wdata[1];
        up_rx_sysref <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h11)) begin
        up_rx_sync <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h13)) begin
        up_rx_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h20)) begin
        up_tx_sysref_sel <= up_wdata[1];
        up_tx_sysref <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h21)) begin
        up_tx_sync <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h23)) begin
        up_tx_resetn <= up_wdata[0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[7:0])
          8'h00: up_rdata <= PCORE_VERSION;
          8'h01: up_rdata <= ID;
          8'h02: up_rdata <= up_scratch;
          8'h03: up_rdata <= {31'd0, up_resetn};
          8'h10: up_rdata <= {30'd0, up_rx_sysref_sel, up_rx_sysref};
          8'h11: up_rdata <= {31'd0, up_rx_sync};
          8'h12: up_rdata <= {23'd0, up_rx_status};
          8'h13: up_rdata <= {31'd0, up_rx_resetn};
          8'h20: up_rdata <= {30'd0, up_tx_sysref_sel, up_tx_sysref};
          8'h21: up_rdata <= {31'd0, up_tx_sync};
          8'h22: up_rdata <= {23'd0, up_tx_status};
          8'h23: up_rdata <= {31'd0, up_tx_resetn};
          8'h30: up_rdata <= DEVICE_TYPE;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // resets

  assign rst = up_reset;

  ad_rst i_rx_rst_reg (.preset(up_rx_reset), .clk(rx_clk), .rst(rx_rst));
  ad_rst i_tx_rst_reg (.preset(up_tx_reset), .clk(tx_clk), .rst(tx_rst));

  // rx sysref & sync

  always @(posedge rx_clk or posedge rx_rst) begin
    if (rx_rst == 1'b1) begin
      rx_rstn <= 'd0;
      rx_sysref_sel_m1 <= 'd0;
      rx_sysref_sel <= 'd0;
      rx_up_sysref_m1 <= 'd0;
      rx_up_sysref <= 'd0;
      rx_sysref <= 'd0;
      rx_up_sync_m1 <= 'd0;
      rx_up_sync <= 'd0;
      rx_sync <= 'd0;
    end else begin
      rx_rstn <= 1'd1;
      rx_sysref_sel_m1 <= up_rx_sysref_sel;
      rx_sysref_sel <= rx_sysref_sel_m1;
      rx_up_sysref_m1 <= up_rx_sysref;
      rx_up_sysref <= rx_up_sysref_m1;
      if (rx_sysref_sel == 1'b1) begin
        rx_sysref <= rx_ext_sysref;
      end else begin
        rx_sysref <= rx_up_sysref;
      end
      rx_up_sync_m1 <= up_rx_sync;
      rx_up_sync <= rx_up_sync_m1;
      rx_sync <= rx_up_sync & rx_ip_sync;
    end
  end

  // tx sysref & sync

  always @(posedge tx_clk or posedge tx_rst) begin
    if (tx_rst == 1'b1) begin
      tx_rstn <= 'd0;
      tx_sysref_sel_m1 <= 'd0;
      tx_sysref_sel <= 'd0;
      tx_up_sysref_m1 <= 'd0;
      tx_up_sysref <= 'd0;
      tx_sysref <= 'd0;
      tx_up_sync_m1 <= 'd0;
      tx_up_sync <= 'd0;
      tx_ip_sync <= 'd0;
    end else begin
      tx_rstn <= 1'd1;
      tx_sysref_sel_m1 <= up_tx_sysref_sel;
      tx_sysref_sel <= tx_sysref_sel_m1;
      tx_up_sysref_m1 <= up_tx_sysref;
      tx_up_sysref <= tx_up_sysref_m1;
      if (tx_sysref_sel == 1'b1) begin
        tx_sysref <= tx_ext_sysref;
      end else begin
        tx_sysref <= tx_up_sysref;
      end
      tx_up_sync_m1 <= up_tx_sync;
      tx_up_sync <= tx_up_sync_m1;
      tx_ip_sync <= tx_up_sync & tx_sync;
    end
  end

  // status

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rx_status_m1 <= 'd0;
      up_rx_status <= 'd0;
      up_tx_status_m1 <= 'd0;
      up_tx_status <= 'd0;
    end else begin
      up_rx_status_m1 <= {rx_sync, rx_status};
      up_rx_status <= up_rx_status_m1;
      up_tx_status_m1 <= {tx_ip_sync, tx_status};
      up_tx_status <= up_tx_status_m1;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
