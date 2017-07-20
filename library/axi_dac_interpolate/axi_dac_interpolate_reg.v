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

module axi_dac_interpolate_reg(

  input               clk,

  output      [31:0]  dac_interpolation_ratio_a,
  output      [31:0]  dac_filter_mask_a,
  output      [31:0]  dac_interpolation_ratio_b,
  output      [31:0]  dac_filter_mask_b,
  output              dma_transfer_suspend,

 // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [13:0]  up_waddr,
  input       [31:0]  up_wdata,
  output reg          up_wack,
  input               up_rreq,
  input       [13:0]  up_raddr,
  output reg  [31:0]  up_rdata,
  output reg          up_rack);

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;

  // internal registers

  reg     [31:0]  up_version = 32'h00020000;
  reg     [31:0]  up_scratch = 32'h0;

  reg     [31:0]  up_interpolation_ratio_a = 32'h0;
  reg     [31:0]  up_filter_mask_a  = 32'h0;
  reg     [31:0]  up_interpolation_ratio_b = 32'h0;
  reg     [31:0]  up_filter_mask_b  = 32'h0;
  reg     [31:0]  up_flags  = 32'h0;

  assign up_wreq_s = ((up_waddr[13:5] == 6'h00)) ? up_wreq : 1'b0;
  assign up_rreq_s = ((up_raddr[13:5] == 6'h00)) ? up_rreq : 1'b0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_interpolation_ratio_a <= 'd0;
      up_filter_mask_a <= 'd0;
      up_interpolation_ratio_b <= 'd0;
      up_filter_mask_b <= 'd0;
      up_flags <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h10)) begin
        up_interpolation_ratio_a <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h11)) begin
        up_filter_mask_a <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h12)) begin
        up_interpolation_ratio_b <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h13)) begin
        up_filter_mask_b <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h14)) begin
        up_flags <= up_wdata;
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
        case (up_raddr[4:0])
          5'h0: up_rdata  <= up_version;
          5'h1: up_rdata  <= up_scratch;
          5'h10: up_rdata <= up_interpolation_ratio_a;
          5'h11: up_rdata <= up_filter_mask_a;
          5'h12: up_rdata <= up_interpolation_ratio_b;
          5'h13: up_rdata <= up_filter_mask_b;
          5'h14: up_rdata <= up_flags;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

   up_xfer_cntrl #(.DATA_WIDTH(129)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_flags[0],              //  1
                      up_interpolation_ratio_b, // 32
                      up_interpolation_ratio_a, // 32
                      up_filter_mask_b,         // 32
                      up_filter_mask_a}),       // 32

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_cntrl ({  dma_transfer_suspend,       //  1
                      dac_interpolation_ratio_b,  // 32
                      dac_interpolation_ratio_a,  // 32
                      dac_filter_mask_b,          // 32
                      dac_filter_mask_a}));       // 32

endmodule

// ***************************************************************************
// ***************************************************************************

