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

`timescale 1ns/1ps

module axi_adxcvr_mdrp (

  input           up_rstn,
  input           up_clk,

  input   [ 7:0]  up_sel,
  input           up_enb,
  input   [15:0]  up_rdata_in,
  input           up_ready_in,
  input   [15:0]  up_rdata,
  input           up_ready,
  output  [15:0]  up_rdata_out,
  output          up_ready_out);

  // parameters

  parameter   integer XCVR_ID = 0;
  parameter   integer NUM_OF_LANES = 8;

  // internal registers

  reg     [15:0]  up_rdata_int = 'd0;
  reg             up_ready_int = 'd0;
  reg             up_ready_mi = 'd0;
  reg     [15:0]  up_rdata_i = 'd0;
  reg             up_ready_i = 'd0;
  reg     [15:0]  up_rdata_m = 'd0;
  reg             up_ready_m = 'd0;

  // internal signals

  wire            up_ready_s;
  wire    [15:0]  up_rdata_mi_s;
  wire            up_ready_mi_s;

  // disable if not selected

  assign up_rdata_out = up_rdata_int;
  assign up_ready_out = up_ready_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata_int <= 16'd0;
      up_ready_int <= 1'b0;
    end else begin
      case (up_sel)
        8'hff: begin
          up_rdata_int <= up_rdata_mi_s;
          up_ready_int <= up_ready_mi_s & ~up_ready_mi;
        end
        XCVR_ID: begin
          up_rdata_int <= up_rdata;
          up_ready_int <= up_ready;
        end
        default: begin
          up_rdata_int <= up_rdata_in;
          up_ready_int <= up_ready_in;
        end
      endcase
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_ready_mi <= 1'b0;
    end else begin
      up_ready_mi <= up_ready_mi_s;
    end
  end

  assign up_rdata_mi_s = up_rdata_m | up_rdata_i;
  assign up_ready_mi_s = up_ready_m & up_ready_i;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata_i <= 16'd0;
      up_ready_i <= 1'b0;
    end else begin
      if (up_ready_in == 1'b1) begin
        up_rdata_i <= up_rdata_in;
        up_ready_i <= 1'b1;
      end else if (up_enb == 1'b1) begin
        up_rdata_i <= 16'd0;
        up_ready_i <= 1'b0;
      end
    end
  end

  generate
  if (XCVR_ID < NUM_OF_LANES) begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata_m <= 16'd0;
      up_ready_m <= 1'b0;
    end else begin
      if (up_ready == 1'b1) begin
        up_rdata_m <= up_rdata;
        up_ready_m <= 1'b1;
      end else if (up_enb == 1'b1) begin
        up_rdata_m <= 16'd0;
        up_ready_m <= 1'b0;
      end
    end
  end
  end else begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata_m <= 16'd0;
      up_ready_m <= 1'b0;
    end else begin
      up_rdata_m <= 16'd0;
      up_ready_m <= 1'b1;
    end
  end
  end
  endgenerate

endmodule     

// ***************************************************************************
// ***************************************************************************

