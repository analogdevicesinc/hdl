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
// serial data output interface: serdes(x8)

`timescale 1ps/1ps

module ad_serdes_clk (

  // clock and divided clock

  mmcm_rst,
  clk_in_p,
  clk_in_n,

  clk,
  div_clk,
  out_clk,
  loaden,
  phase,

  // drp interface

  up_clk,
  up_rstn,
  up_drp_sel,
  up_drp_wr,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,
  up_drp_locked);

  // parameters

  parameter       MODE = "TX";

  // clock and divided clock

  input           mmcm_rst;
  input           clk_in_p;
  input           clk_in_n;

  output          clk;
  output          div_clk;
  output          out_clk;
  output          loaden;
  output  [ 7:0]  phase;

  // drp interface

  input           up_clk;
  input           up_rstn;
  input           up_drp_sel;
  input           up_drp_wr;
  input   [11:0]  up_drp_addr;
  input   [15:0]  up_drp_wdata;
  output  [15:0]  up_drp_rdata;
  output          up_drp_ready;
  output          up_drp_locked;

  wire            locked;

  // ground the unused outputs

  assign up_drp_rdata = 15'b0;
  assign up_drp_ready = 1'b0;
  assign up_drp_locked = locked;

  generate if (MODE == "TX") begin

    assign phase = 8'h0;

    alt_clk i_alt_clk (
      .locked (locked),         // locked.export
      .outclk_0 (clk),          // outclk0.clk
      .outclk_1 (loaden),       // outclk1.clk
      .outclk_2 (div_clk),      // outclk2.clk
      .outclk_3 (out_clk),      // outclk3.clk
      .reconfig_from_pll (),    // reconfig_from_pll.reconfig_from_pll
      .reconfig_to_pll (),      // reconfig_to_pll.reconfig_to_pll
      .refclk (clk_in_p),       // refclk.clk
      .rst (mmcm_rst)           // reset.reset
    );

    // TODO: Add Altera PLL Reconfig IP

  end else begin

  alt_clk i_alt_clk (
    .locked (locked),         // locked.export
    .outclk_0 (clk),          // outclk0.clk
    .outclk_1 (loaden),       // outclk1.clk
    .outclk_2 (div_clk),      // outclk2.clk
    .outclk_3 (out_clk),      // outclk3.clk
    .reconfig_from_pll (),    // reconfig_from_pll.reconfig_from_pll
    .reconfig_to_pll (),      // reconfig_to_pll.reconfig_to_pll
    .phout (phase),
    .refclk (clk_in_p),       // refclk.clk
    .rst (mmcm_rst)           // reset.reset
  );

  end
  endgenerate

endmodule
