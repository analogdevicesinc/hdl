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
// Receive HDMI, hdmi embedded syncs data in, video dma data out.

module axi_hdmi_rx_es (

  // hdmi interface

  hdmi_clk,
  hdmi_data,
  hdmi_vs_de,
  hdmi_hs_de,
  hdmi_data_de);

  // parameters

  parameter   DATA_WIDTH = 32;
  localparam  BYTE_WIDTH = DATA_WIDTH/8;

  // hdmi interface

  input                       hdmi_clk;
  input   [(DATA_WIDTH-1):0]  hdmi_data;

  // dma interface

  output                      hdmi_vs_de;
  output                      hdmi_hs_de;
  output  [(DATA_WIDTH-1):0]  hdmi_data_de;

  // internal registers

  reg     [(DATA_WIDTH-1):0]  hdmi_data_d = 'd0;
  reg                         hdmi_hs_de_rcv_d = 'd0;
  reg                         hdmi_vs_de_rcv_d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_2d = 'd0;
  reg                         hdmi_hs_de_rcv_2d = 'd0;
  reg                         hdmi_vs_de_rcv_2d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_3d = 'd0;
  reg                         hdmi_hs_de_rcv_3d = 'd0;
  reg                         hdmi_vs_de_rcv_3d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_4d = 'd0;
  reg                         hdmi_hs_de_rcv_4d = 'd0;
  reg                         hdmi_vs_de_rcv_4d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_de = 'd0;
  reg                         hdmi_hs_de = 'd0;
  reg                         hdmi_vs_de = 'd0;
  reg     [ 1:0]              hdmi_preamble_cnt = 'd0;
  reg                         hdmi_hs_de_rcv = 'd0;
  reg                         hdmi_vs_de_rcv = 'd0;

  // internal signals

  wire    [(DATA_WIDTH-1):0]  hdmi_ff_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_00_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_b6_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_9d_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_ab_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_80_s;

  // es constants

  assign hdmi_ff_s = {BYTE_WIDTH{8'hff}};
  assign hdmi_00_s = {BYTE_WIDTH{8'h00}};
  assign hdmi_b6_s = {BYTE_WIDTH{8'hb6}};
  assign hdmi_9d_s = {BYTE_WIDTH{8'h9d}};
  assign hdmi_ab_s = {BYTE_WIDTH{8'hab}};
  assign hdmi_80_s = {BYTE_WIDTH{8'h80}};

  // delay to get rid of eav's 4 bytes

  always @(posedge hdmi_clk) begin
    hdmi_data_d <= hdmi_data;
    hdmi_hs_de_rcv_d <= hdmi_hs_de_rcv;
    hdmi_vs_de_rcv_d <= hdmi_vs_de_rcv;
    hdmi_data_2d <= hdmi_data_d;
    hdmi_hs_de_rcv_2d <= hdmi_hs_de_rcv_d;
    hdmi_vs_de_rcv_2d <= hdmi_vs_de_rcv_d;
    hdmi_data_3d <= hdmi_data_2d;
    hdmi_hs_de_rcv_3d <= hdmi_hs_de_rcv_2d;
    hdmi_vs_de_rcv_3d <= hdmi_vs_de_rcv_2d;
    hdmi_data_4d <= hdmi_data_3d;
    hdmi_hs_de_rcv_4d <= hdmi_hs_de_rcv_3d;
    hdmi_vs_de_rcv_4d <= hdmi_vs_de_rcv_3d;
    hdmi_data_de  <= hdmi_data_4d;
    hdmi_hs_de <= hdmi_hs_de_rcv & hdmi_hs_de_rcv_4d;
    hdmi_vs_de <= hdmi_vs_de_rcv & hdmi_vs_de_rcv_4d;
  end

  // check for sav and eav and generate the corresponding enables

  always @(posedge hdmi_clk) begin
    if ((hdmi_data == hdmi_ff_s) || (hdmi_data == hdmi_00_s)) begin
      hdmi_preamble_cnt <= hdmi_preamble_cnt + 1'b1;
    end else begin
      hdmi_preamble_cnt <= 'd0;
    end
    if (hdmi_preamble_cnt == 3'b11) begin
      if ((hdmi_data == hdmi_b6_s) || (hdmi_data == hdmi_9d_s)) begin
        hdmi_hs_de_rcv <= 1'b0;
      end else if ((hdmi_data == hdmi_ab_s) || (hdmi_data == hdmi_80_s)) begin
        hdmi_hs_de_rcv <= 1'b1;
      end
      if (hdmi_data == hdmi_b6_s) begin
        hdmi_vs_de_rcv <= 1'b0;
      end else if (hdmi_data == hdmi_9d_s) begin
        hdmi_vs_de_rcv <= 1'b1;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
