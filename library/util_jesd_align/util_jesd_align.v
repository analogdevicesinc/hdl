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

module util_jesd_align (

  // xcvr interface

  rx_clk,
  rx_ip_sof,
  rx_ip_data,
  rx_sof,
  rx_data);

  // parameters

  parameter   NUM_OF_LANES = 2;

  // xcvr interface

  input                               rx_clk;
  input   [ 3:0]                      rx_ip_sof;
  input   [((NUM_OF_LANES*32)-1):0]   rx_ip_data;
  output  [((NUM_OF_LANES* 1)-1):0]   rx_sof;
  output  [((NUM_OF_LANES*32)-1):0]   rx_data;

  // only for altera, xcvr+jesd do not frame align

  genvar n;
  generate
  for (n = 0; n < NUM_OF_LANES; n = n + 1) begin: g_lane
  ad_jesd_align i_jesd_align (
    .rx_clk (rx_clk),
    .rx_ip_sof (rx_ip_sof),
    .rx_ip_data (rx_ip_data[n*32+31:n*32]),
    .rx_sof (rx_sof[n]),
    .rx_data (rx_data[n*32+31:n*32]));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
