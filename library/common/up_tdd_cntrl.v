// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
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
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/100ps

module up_tdd_cntrl (

  clk,

  //rf tdd interface control

  tdd_enable,
  tdd_start,
  tdd_rst,
  tdd_counter_reset,
  tdd_update_regs,
  tdd_secondary,
  tdd_burst_en,
  tdd_burst_count,
  tdd_infinite_burst,
  tdd_counter_init,
  tdd_frame_length,
  tdd_tx_dp_delay,
  tdd_vco_rx_on_1,
  tdd_vco_rx_off_1,
  tdd_vco_tx_on_1,
  tdd_vco_tx_off_1,
  tdd_rx_on_1,
  tdd_rx_off_1,
  tdd_tx_on_1,
  tdd_tx_off_1,
  tdd_tx_dp_on_1,
  tdd_tx_dp_off_1,
  tdd_vco_rx_on_2,
  tdd_vco_rx_off_2,
  tdd_vco_tx_on_2,
  tdd_vco_tx_off_2,
  tdd_rx_on_2,
  tdd_rx_off_2,
  tdd_tx_on_2,
  tdd_tx_off_2,
  tdd_tx_dp_on_2,
  tdd_tx_dp_off_2,

  tdd_status,

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

  localparam  PCORE_VERSION = 32'h00010001;
  parameter   PCORE_ID = 0;

  input           clk;

  output          tdd_enable;
  output          tdd_start;
  output          tdd_rst;
  output          tdd_update_regs;
  output          tdd_counter_reset;
  output          tdd_secondary;
  output  [21:0]  tdd_counter_init;
  output  [21:0]  tdd_frame_length;

  output          tdd_burst_en;
  output  [ 5:0]  tdd_burst_count;
  output          tdd_infinite_burst;

  output  [ 7:0]  tdd_tx_dp_delay;
  output  [21:0]  tdd_vco_rx_on_1;
  output  [21:0]  tdd_vco_rx_off_1;
  output  [21:0]  tdd_vco_tx_on_1;
  output  [21:0]  tdd_vco_tx_off_1;
  output  [21:0]  tdd_rx_on_1;
  output  [21:0]  tdd_rx_off_1;
  output  [21:0]  tdd_tx_on_1;
  output  [21:0]  tdd_tx_off_1;
  output  [21:0]  tdd_tx_dp_on_1;
  output  [21:0]  tdd_tx_dp_off_1;
  output  [21:0]  tdd_vco_rx_on_2;
  output  [21:0]  tdd_vco_rx_off_2;
  output  [21:0]  tdd_vco_tx_on_2;
  output  [21:0]  tdd_vco_tx_off_2;
  output  [21:0]  tdd_rx_on_2;
  output  [21:0]  tdd_rx_off_2;
  output  [21:0]  tdd_tx_on_2;
  output  [21:0]  tdd_tx_off_2;
  output  [21:0]  tdd_tx_dp_on_2;
  output  [21:0]  tdd_tx_dp_off_2;

  input   [ 7:0]  tdd_status;

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

  reg             up_wack = 1'h0;
  reg     [31:0]  up_scratch = 32'h0;
  reg             up_resetn = 1'h0;
  reg             up_rack = 1'h0;
  reg     [31:0]  up_rdata = 32'h0;

  reg             up_tdd_enable = 1'h0;
  reg             up_tdd_start = 1'h0;
  reg             up_tdd_update_regs = 1'h0;
  reg             up_tdd_counter_reset = 1'h0;
  reg             up_tdd_secondary = 1'h0;
  reg     [21:0]  up_tdd_counter_init = 22'h0;
  reg     [21:0]  up_tdd_frame_length = 22'h0;

  reg             up_tdd_burst_en = 1'h0;
  reg     [ 5:0]  up_tdd_burst_count = 6'h0;
  reg             up_tdd_infinite_burst = 1'h0;
  reg     [ 7:0]  up_tdd_tx_dp_delay = 8'h0;

  reg     [21:0]  up_tdd_vco_rx2tx_1 = 22'h0;
  reg     [21:0]  up_tdd_vco_tx2rx_1 = 22'h0;
  reg     [21:0]  up_tdd_vco_rx_on_1 = 22'h0;
  reg     [21:0]  up_tdd_vco_rx_off_1 = 22'h0;
  reg     [21:0]  up_tdd_vco_tx_on_1 = 22'h0;
  reg     [21:0]  up_tdd_vco_tx_off_1 = 22'h0;
  reg     [21:0]  up_tdd_rx_on_1 = 22'h0;
  reg     [21:0]  up_tdd_rx_off_1 = 22'h0;
  reg     [21:0]  up_tdd_tx_on_1 = 22'h0;
  reg     [21:0]  up_tdd_tx_off_1 = 22'h0;
  reg     [21:0]  up_tdd_tx_dp_on_1 = 22'h0;
  reg     [21:0]  up_tdd_tx_dp_off_1 = 22'h0;
  reg     [21:0]  up_tdd_vco_rx_on_2 = 22'h0;
  reg     [21:0]  up_tdd_vco_rx_off_2 = 22'h0;
  reg     [21:0]  up_tdd_vco_tx_on_2 = 22'h0;
  reg     [21:0]  up_tdd_vco_tx_off_2 = 22'h0;
  reg     [21:0]  up_tdd_rx_on_2 = 22'h0;
  reg     [21:0]  up_tdd_rx_off_2 = 22'h0;
  reg     [21:0]  up_tdd_tx_on_2 = 22'h0;
  reg     [21:0]  up_tdd_tx_off_2 = 22'h0;
  reg     [21:0]  up_tdd_tx_dp_on_2 = 22'h0;
  reg     [21:0]  up_tdd_tx_dp_off_2 = 22'h0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire            up_preset_s;
  wire            tdd_rst;
  wire            up_cntrl_xfer_done;

  wire    [ 7:0]  up_tdd_status_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == 6'h20) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == 6'h20) ? up_rreq : 1'b0;
  assign up_preset_s = ~up_resetn;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 1'h0;
      up_scratch <= 32'h0;
      up_resetn <= 1'h0;
      up_tdd_start <= 1'h0;
      up_tdd_update_regs <= 1'h0;
      up_tdd_counter_reset <= 1'h0;
      up_tdd_enable <= 1'h0;
      up_tdd_secondary <= 1'h0;
      up_tdd_counter_init <= 22'h0;
      up_tdd_frame_length <= 22'h0;
      up_tdd_burst_en <= 1'h0;
      up_tdd_burst_count <= 6'h0;
      up_tdd_infinite_burst <= 1'h0;
      up_tdd_vco_rx_on_1 <= 22'h0;
      up_tdd_vco_rx_off_1 <= 22'h0;
      up_tdd_vco_tx_on_1 <= 22'h0;
      up_tdd_vco_tx_off_1 <= 22'h0;
      up_tdd_rx_on_1 <= 22'h0;
      up_tdd_rx_off_1 <= 22'h0;
      up_tdd_tx_on_1 <= 22'h0;
      up_tdd_tx_off_1 <= 22'h0;
      up_tdd_tx_dp_on_1 <= 22'h0;
      up_tdd_vco_rx_on_2 <= 22'h0;
      up_tdd_vco_rx_off_2 <= 22'h0;
      up_tdd_vco_tx_on_2 <= 22'h0;
      up_tdd_vco_tx_off_2 <= 22'h0;
      up_tdd_rx_on_2 <= 22'h0;
      up_tdd_rx_off_2 <= 22'h0;
      up_tdd_tx_on_2 <= 22'h0;
      up_tdd_tx_off_2 <= 22'h0;
      up_tdd_tx_dp_on_2 <= 22'h0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h10)) begin
        up_resetn <= up_wdata[0];
      end
      if (up_tdd_update_regs == 1'b1) begin
        if (up_cntrl_xfer_done == 1) begin
          up_tdd_update_regs <= 1'h0;
        end
      end else if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h11)) begin
          up_tdd_update_regs <= up_wdata[3];
          up_tdd_counter_reset <= up_wdata[2];
          up_tdd_enable <= up_wdata[0];
      end
      if (up_tdd_start == 1) begin
        if (up_cntrl_xfer_done == 1) begin
          up_tdd_start <= 1'h0;
        end
      end else if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h11)) begin
        up_tdd_start <= up_wdata[1];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h12)) begin
        up_tdd_burst_count <= up_wdata[21:16];
        up_tdd_infinite_burst <= up_wdata[2];
        up_tdd_burst_en <= up_wdata[1];
        up_tdd_secondary <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h13)) begin
        up_tdd_counter_init <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h14)) begin
        up_tdd_frame_length <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h15)) begin
        up_tdd_tx_dp_delay <= up_wdata[ 7:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h20)) begin
        up_tdd_vco_rx_on_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h21)) begin
        up_tdd_vco_rx_off_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h22)) begin
        up_tdd_vco_tx_on_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h23)) begin
        up_tdd_vco_tx_off_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h24)) begin
        up_tdd_rx_on_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h25)) begin
        up_tdd_rx_off_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h26)) begin
        up_tdd_tx_on_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h27)) begin
        up_tdd_tx_off_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h28)) begin
        up_tdd_tx_dp_on_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h29)) begin
        up_tdd_tx_dp_off_1 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h20)) begin
        up_tdd_vco_rx_on_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h21)) begin
        up_tdd_vco_rx_off_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h22)) begin
        up_tdd_vco_tx_on_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h23)) begin
        up_tdd_vco_tx_off_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h32)) begin
        up_tdd_rx_on_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h33)) begin
        up_tdd_rx_off_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h34)) begin
        up_tdd_tx_on_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h35)) begin
        up_tdd_tx_off_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h36)) begin
        up_tdd_tx_dp_on_2 <= up_wdata[21:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h37)) begin
        up_tdd_tx_dp_off_2 <= up_wdata[21:0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 1'b0;
      up_rdata <= 1'b0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[7:0])
          8'h00: up_rdata <= PCORE_VERSION;
          8'h01: up_rdata <= PCORE_ID;
          8'h02: up_rdata <= up_scratch;
          8'h10: up_rdata <= {31'h0, up_resetn};
          8'h11: up_rdata <= {28'h0, up_tdd_update_regs, up_tdd_counter_reset, up_tdd_start, up_tdd_enable};
          8'h12: up_rdata <= {10'h0, up_tdd_burst_count, 13'h0, up_tdd_infinite_burst, up_tdd_burst_en, up_tdd_secondary};
          8'h13: up_rdata <= {10'h0, up_tdd_counter_init};
          8'h14: up_rdata <= {10'h0, up_tdd_frame_length};
          8'h15: up_rdata <= {24'h0, up_tdd_tx_dp_delay};
          8'h1A: up_rdata <= {24'h0, up_tdd_status_s};
          8'h20: up_rdata <= {10'h0, up_tdd_vco_rx_on_1};
          8'h21: up_rdata <= {10'h0, up_tdd_vco_rx_off_1};
          8'h22: up_rdata <= {10'h0, up_tdd_vco_tx_on_1};
          8'h23: up_rdata <= {10'h0, up_tdd_vco_tx_off_1};
          8'h24: up_rdata <= {10'h0, up_tdd_rx_on_1};
          8'h25: up_rdata <= {10'h0, up_tdd_rx_off_1};
          8'h26: up_rdata <= {10'h0, up_tdd_tx_on_1};
          8'h27: up_rdata <= {10'h0, up_tdd_tx_off_1};
          8'h28: up_rdata <= {10'h0, up_tdd_tx_dp_on_1};
          8'h29: up_rdata <= {10'h0, up_tdd_tx_dp_off_1};
          8'h30: up_rdata <= {10'h0, up_tdd_vco_rx_on_2};
          8'h31: up_rdata <= {10'h0, up_tdd_vco_rx_off_2};
          8'h32: up_rdata <= {10'h0, up_tdd_vco_tx_on_2};
          8'h33: up_rdata <= {10'h0, up_tdd_vco_tx_off_2};
          8'h34: up_rdata <= {10'h0, up_tdd_rx_on_2};
          8'h35: up_rdata <= {10'h0, up_tdd_rx_off_2};
          8'h36: up_rdata <= {10'h0, up_tdd_tx_on_2};
          8'h37: up_rdata <= {10'h0, up_tdd_tx_off_2};
          8'h38: up_rdata <= {10'h0, up_tdd_tx_dp_on_2};
          8'h39: up_rdata <= {10'h0, up_tdd_tx_dp_off_2};
          default: up_rdata <= 32'h0;
        endcase
      end
    end
  end

  // resets

  ad_rst i_rf_rst_reg (
    .preset(up_preset_s),
    .clk(clk),
    .rst(tdd_rst)
  );

  // rf tdd control signal CDC

  up_xfer_cntrl #(.DATA_WIDTH(13)) i_tdd_control (
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_data_cntrl({up_tdd_enable,
                    up_tdd_counter_reset,
                    up_tdd_update_regs,
                    up_tdd_secondary,
                    up_tdd_start,
                    up_tdd_burst_en,
                    up_tdd_burst_count,
                    up_tdd_infinite_burst
    }),
    .up_xfer_done(up_cntrl_xfer_done),
    .d_rst(tdd_rst),
    .d_clk(clk),
    .d_data_cntrl({tdd_enable,
                   tdd_counter_reset,
                   tdd_update_regs,
                   tdd_secondary,
                   tdd_start,
                   tdd_burst_en,
                   tdd_burst_count,
                   tdd_infinite_burst
    }));

  up_xfer_cntrl #(.DATA_WIDTH(492)) i_tdd_counter_values (
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_data_cntrl({up_tdd_counter_init,
                    up_tdd_frame_length,
                    up_tdd_tx_dp_delay,
                    up_tdd_vco_rx_on_1,
                    up_tdd_vco_rx_off_1,
                    up_tdd_vco_tx_on_1,
                    up_tdd_vco_tx_off_1,
                    up_tdd_rx_on_1,
                    up_tdd_rx_off_1,
                    up_tdd_tx_on_1,
                    up_tdd_tx_off_1,
                    up_tdd_tx_dp_on_1,
                    up_tdd_tx_dp_off_1,
                    up_tdd_vco_rx_on_2,
                    up_tdd_vco_rx_off_2,
                    up_tdd_vco_tx_on_2,
                    up_tdd_vco_tx_off_2,
                    up_tdd_rx_on_2,
                    up_tdd_rx_off_2,
                    up_tdd_tx_on_2,
                    up_tdd_tx_off_2,
                    up_tdd_tx_dp_on_2,
                    up_tdd_tx_dp_off_2
    }),
    .up_xfer_done(),
    .d_rst(tdd_rst),
    .d_clk(clk),
    .d_data_cntrl({tdd_counter_init,
                   tdd_frame_length,
                   tdd_tx_dp_delay,
                   tdd_vco_rx_on_1,
                   tdd_vco_rx_off_1,
                   tdd_vco_tx_on_1,
                   tdd_vco_tx_off_1,
                   tdd_rx_on_1,
                   tdd_rx_off_1,
                   tdd_tx_on_1,
                   tdd_tx_off_1,
                   tdd_tx_dp_on_1,
                   tdd_tx_dp_off_1,
                   tdd_vco_rx_on_2,
                   tdd_vco_rx_off_2,
                   tdd_vco_tx_on_2,
                   tdd_vco_tx_off_2,
                   tdd_rx_on_2,
                   tdd_rx_off_2,
                   tdd_tx_on_2,
                   tdd_tx_off_2,
                   tdd_tx_dp_on_2,
                   tdd_tx_dp_off_2
    }));


  up_xfer_status #(.DATA_WIDTH(8)) i_tdd_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status (up_tdd_status_s),
    .d_rst (tdd_rst),
    .d_clk (clk),
    .d_data_status (tdd_status));

endmodule

// ***************************************************************************
// ***************************************************************************
