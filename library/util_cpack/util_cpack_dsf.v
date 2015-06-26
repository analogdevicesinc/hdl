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

module util_cpack_dsf (

  // adc interface

  adc_clk,
  adc_valid,
  adc_enable,
  adc_data,

  // dma interface

  adc_dsf_valid,
  adc_dsf_sync,
  adc_dsf_data);

  // parameters

  parameter   CH_DW   = 32;
  parameter   CH_ICNT =  4;
  parameter   CH_MCNT =  8;
  parameter   P_CNT   =  4;

  localparam  CH_DCNT = P_CNT - CH_ICNT;
  localparam  I_WIDTH = CH_DW*CH_ICNT;
  localparam  P_WIDTH = CH_DW*P_CNT;
  localparam  M_WIDTH = CH_DW*CH_MCNT;

  // adc interface

  input                     adc_clk;
  input                     adc_valid;
  input                     adc_enable;
  input   [(I_WIDTH-1):0]   adc_data;

  // dma interface

  output                    adc_dsf_valid;
  output                    adc_dsf_sync;
  output  [(P_WIDTH-1):0]   adc_dsf_data;

  // internal registers

  reg     [  2:0]           adc_samples_int = 'd0;
  reg     [(M_WIDTH-1):0]   adc_data_int = 'd0;
  reg                       adc_dsf_enable = 'd0;
  reg                       adc_dsf_valid_int = 'd0;
  reg                       adc_dsf_sync_int = 'd0;
  reg     [(P_WIDTH-1):0]   adc_dsf_data_int = 'd0;
  reg                       adc_dsf_valid = 'd0;
  reg                       adc_dsf_sync = 'd0;
  reg     [(P_WIDTH-1):0]   adc_dsf_data = 'd0;

  // internal signals

  wire    [(M_WIDTH-1):0]   adc_data_s;

  // bypass 

  generate
  if (CH_ICNT == P_CNT) begin
  assign adc_data_s = 'd0;

  always @(posedge adc_clk) begin
    adc_samples_int <= 'd0;
    adc_data_int <= 'd0;
    adc_dsf_enable <= 'd0;
    adc_dsf_valid_int <= 'd0;
    adc_dsf_sync_int <= 'd0;
    adc_dsf_data_int <= 'd0;
    if (adc_enable == 1'b1) begin
      adc_dsf_valid <= adc_valid;
      adc_dsf_sync <= 1'b1;
      adc_dsf_data <= adc_data;
    end else begin
      adc_dsf_valid <= 'b0;
      adc_dsf_sync <= 'b0;
      adc_dsf_data <= 'd0;
    end
  end
  end
  endgenerate

  // data store & forward

  generate
  if (P_CNT > CH_ICNT) begin
  assign adc_data_s[(M_WIDTH-1):I_WIDTH] = 'd0;
  assign adc_data_s[(I_WIDTH-1):0] = adc_data;

  always @(posedge adc_clk) begin
    if (adc_valid == 1'b1) begin
      if (adc_samples_int >= CH_DCNT) begin
        adc_samples_int <= adc_samples_int - CH_DCNT;
      end else begin
        adc_samples_int <= adc_samples_int + CH_ICNT;
      end
      adc_data_int <= {adc_data_s[(I_WIDTH-1):0],
        adc_data_int[(M_WIDTH-1):I_WIDTH]};
    end
  end

  always @(posedge adc_clk) begin
    adc_dsf_enable <= adc_enable;
    if (adc_samples_int >= CH_DCNT) begin
      adc_dsf_valid_int <= adc_valid;
    end else begin
      adc_dsf_valid_int <= 1'b0;
    end
    if (adc_dsf_sync_int == 1'b1) begin
      if (adc_dsf_valid_int == 1'b1) begin
        adc_dsf_sync_int <= 1'b0;
      end
    end else begin
      if (adc_samples_int == 3'd0) begin
        adc_dsf_sync_int <= 1'b1;
      end
    end
  end

  always @(posedge adc_clk) begin
    if (adc_valid == 1'b1) begin
      case (adc_samples_int)
        3'b111:  adc_dsf_data_int <= {adc_data_s[((CH_DW*1)-1):0],
                    adc_data_int[((CH_DW*8)-1):(CH_DW*1)]};
        3'b110:  adc_dsf_data_int <= {adc_data_s[((CH_DW*2)-1):0],
                    adc_data_int[((CH_DW*8)-1):(CH_DW*2)]};
        3'b101:  adc_dsf_data_int <= {adc_data_s[((CH_DW*3)-1):0],
                    adc_data_int[((CH_DW*8)-1):(CH_DW*3)]};
        3'b100:  adc_dsf_data_int <= {adc_data_s[((CH_DW*4)-1):0],
                    adc_data_int[((CH_DW*8)-1):(CH_DW*4)]};
        3'b011:  adc_dsf_data_int <= {adc_data_s[((CH_DW*5)-1):0],
                    adc_data_int[((CH_DW*8)-1):(CH_DW*5)]};
        3'b010:  adc_dsf_data_int <= {adc_data_s[((CH_DW*6)-1):0],
                    adc_data_int[((CH_DW*8)-1):(CH_DW*6)]};
        3'b001:  adc_dsf_data_int <= {adc_data_s[((CH_DW*7)-1):0],
                    adc_data_int[((CH_DW*8)-1):(CH_DW*7)]};
        3'b000:  adc_dsf_data_int <= adc_data_s;
        default: adc_dsf_data_int <= 'd0;
      endcase
    end
  end

  always @(posedge adc_clk) begin
    if (adc_enable == 1'b1) begin
      adc_dsf_valid <= adc_dsf_valid_int;
      adc_dsf_sync <= adc_dsf_sync_int;
      adc_dsf_data <= adc_dsf_data_int[(P_WIDTH-1):0];
    end else begin
      adc_dsf_valid <= 'b0;
      adc_dsf_sync <= 'b0;
      adc_dsf_data <= 'd0;
    end
  end
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
