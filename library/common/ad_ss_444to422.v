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
// ***************************************************************************
// ***************************************************************************
// Input must be RGB or CrYCb in that order, output is CrY/CbY

module ad_ss_444to422 (

  // 444 inputs

  clk,
  s444_de,
  s444_sync,
  s444_data,

  // 422 outputs

  s422_sync,
  s422_data);

  // parameters

  parameter   CR_CB_N = 0;
  parameter   DELAY_DATA_WIDTH = 16;
  localparam  DW = DELAY_DATA_WIDTH - 1;

  // 444 inputs

  input           clk;
  input           s444_de;
  input   [DW:0]  s444_sync;
  input   [23:0]  s444_data;

  // 422 outputs

  output  [DW:0]  s422_sync;
  output  [15:0]  s422_data;

  // internal registers

  reg             s444_de_d = 'd0;
  reg     [DW:0]  s444_sync_d = 'd0;
  reg     [23:0]  s444_data_d = 'd0;
  reg             s444_de_2d = 'd0;
  reg     [DW:0]  s444_sync_2d = 'd0;
  reg     [23:0]  s444_data_2d = 'd0;
  reg             s444_de_3d = 'd0;
  reg     [DW:0]  s444_sync_3d = 'd0;
  reg     [23:0]  s444_data_3d = 'd0;
  reg     [ 7:0]  cr = 'd0;
  reg     [ 7:0]  cb = 'd0;
  reg             cr_cb_sel = 'd0;
  reg     [DW:0]  s422_sync = 'd0;
  reg     [15:0]  s422_data = 'd0;

  // internal wires

  wire    [ 9:0]  cr_s;
  wire    [ 9:0]  cb_s;

  // fill the data pipe lines, hold the last data on edges 

  always @(posedge clk) begin
    s444_de_d <= s444_de;
    s444_sync_d <= s444_sync;
    if (s444_de == 1'b1) begin
      s444_data_d <= s444_data;
    end
    s444_de_2d <= s444_de_d;
    s444_sync_2d <= s444_sync_d;
    if (s444_de_d == 1'b1) begin
      s444_data_2d <= s444_data_d;
    end
    s444_de_3d <= s444_de_2d;
    s444_sync_3d <= s444_sync_2d;
    if (s444_de_2d == 1'b1) begin
      s444_data_3d <= s444_data_2d;
    end
  end

  // get the average 0.25*s(n-1) + 0.5*s(n) + 0.25*s(n+1)

  assign cr_s = {2'd0, s444_data_d[23:16]} +
                {2'd0, s444_data_3d[23:16]} +
                {1'd0, s444_data_2d[23:16], 1'd0};

  assign cb_s = {2'd0, s444_data_d[7:0]} +
                {2'd0, s444_data_3d[7:0]} +
                {1'd0, s444_data_2d[7:0], 1'd0};

  always @(posedge clk) begin
    cr <= cr_s[9:2];
    cb <= cb_s[9:2];
    if (s444_de_3d == 1'b1) begin
      cr_cb_sel <= ~cr_cb_sel;
    end else begin
      cr_cb_sel <= CR_CB_N;
    end
  end

  // 422 outputs

  always @(posedge clk) begin
    s422_sync <= s444_sync_3d;
    if (s444_de_3d == 1'b0) begin
      s422_data <= 'd0;
    end else if (cr_cb_sel == 1'b1) begin
      s422_data <= {cr, s444_data_3d[15:8]};
    end else begin
      s422_data <= {cb, s444_data_3d[15:8]};
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
