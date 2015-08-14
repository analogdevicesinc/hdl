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

module ad_jesd_align (

  // jesd interface

  rx_clk,
  rx_ip_sof,
  rx_ip_data,
  rx_sof,
  rx_data);

  // jesd interface

  input           rx_clk;
  input   [ 3:0]  rx_ip_sof;
  input   [31:0]  rx_ip_data;

  // aligned data

  output          rx_sof;
  output  [31:0]  rx_data;

  // internal registers

  reg     [31:0]  rx_ip_data_d = 'd0;
  reg     [ 3:0]  rx_ip_sof_hold = 'd0;
  reg             rx_sof = 'd0;
  reg             rx_ip_sof_d = 'd0;
  reg     [31:0]  rx_data = 'd0;

  // dword may contain more than one frame per clock
  always @(posedge rx_clk) begin
    rx_ip_data_d <= rx_ip_data;
    rx_ip_sof_d <= rx_ip_sof;
    if (rx_ip_sof != 4'h0) begin
      rx_ip_sof_hold <= rx_ip_sof;
    end
    rx_sof <= |rx_ip_sof_d;
    if (rx_ip_sof_hold[0] == 1'b1) begin
      rx_data <= rx_ip_data;
    end else if (rx_ip_sof_hold[1] == 1'b1) begin
      rx_data <= {rx_ip_data[ 7:0], rx_ip_data_d[31: 8]};
    end else if (rx_ip_sof_hold[2] == 1'b1) begin
      rx_data <= {rx_ip_data[15:0], rx_ip_data_d[31:16]};
    end else if (rx_ip_sof_hold[3] == 1'b1) begin
      rx_data <= {rx_ip_data[23:0], rx_ip_data_d[31:24]};
    end else begin
      rx_data <= 32'd0;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
