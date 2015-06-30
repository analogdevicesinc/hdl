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
// Transmit HDMI, video dma data in, hdmi separate syncs data out.

module axi_hdmi_tx_es (

  // hdmi interface

  hdmi_clk,
  hdmi_hs_de,
  hdmi_vs_de,
  hdmi_data_de,
  hdmi_data);

  // parameters

  parameter   DATA_WIDTH = 32;
  localparam  BYTE_WIDTH = DATA_WIDTH/8;

  // hdmi interface

  input                       hdmi_clk;
  input                       hdmi_hs_de;
  input                       hdmi_vs_de;
  input   [(DATA_WIDTH-1):0]  hdmi_data_de;
  output  [(DATA_WIDTH-1):0]  hdmi_data;

  // internal registers

  reg                         hdmi_hs_de_d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_d = 'd0;
  reg                         hdmi_hs_de_2d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_2d = 'd0;
  reg                         hdmi_hs_de_3d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_3d = 'd0;
  reg                         hdmi_hs_de_4d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_4d = 'd0;
  reg                         hdmi_hs_de_5d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_5d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data = 'd0;

  // internal wires

  wire    [(DATA_WIDTH-1):0]  hdmi_sav_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_eav_s;

  // hdmi embedded sync insertion

  assign hdmi_sav_s = (hdmi_vs_de == 1) ? {BYTE_WIDTH{8'h80}} : {BYTE_WIDTH{8'hab}};
  assign hdmi_eav_s = (hdmi_vs_de == 1) ? {BYTE_WIDTH{8'h9d}} : {BYTE_WIDTH{8'hb6}};

  always @(posedge hdmi_clk) begin
    hdmi_hs_de_d <= hdmi_hs_de;
    case ({hdmi_hs_de_4d, hdmi_hs_de_3d, hdmi_hs_de_2d,
      hdmi_hs_de_d, hdmi_hs_de})
      5'b11000: hdmi_data_d <= {BYTE_WIDTH{8'h00}};
      5'b11100: hdmi_data_d <= {BYTE_WIDTH{8'h00}};
      5'b11110: hdmi_data_d <= {BYTE_WIDTH{8'hff}};
      5'b10000: hdmi_data_d <= hdmi_eav_s;
      default: hdmi_data_d <= hdmi_data_de;
    endcase
    hdmi_hs_de_2d <= hdmi_hs_de_d;
    hdmi_data_2d <= hdmi_data_d;
    hdmi_hs_de_3d <= hdmi_hs_de_2d;
    hdmi_data_3d <= hdmi_data_2d;
    hdmi_hs_de_4d <= hdmi_hs_de_3d;
    hdmi_data_4d <= hdmi_data_3d;
    hdmi_hs_de_5d <= hdmi_hs_de_4d;
    hdmi_data_5d <= hdmi_data_4d;
    case ({hdmi_hs_de_5d, hdmi_hs_de_4d, hdmi_hs_de_3d,
      hdmi_hs_de_2d, hdmi_hs_de_d})
      5'b00111: hdmi_data <= {BYTE_WIDTH{8'h00}};
      5'b00011: hdmi_data <= {BYTE_WIDTH{8'h00}};
      5'b00001: hdmi_data <= {BYTE_WIDTH{8'hff}};
      5'b01111: hdmi_data <= hdmi_sav_s;
      default:  hdmi_data <= hdmi_data_5d;
    endcase
  end

endmodule

// ***************************************************************************
// ***************************************************************************
