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
// This interface includes both the transmit and receive components -
// They both uses the same clock (sourced from the receiving side).

`timescale 1ns/100ps

module axi_ad9361_pnlb_1 (

  // device interface

  clk,
  adc_valid_in,
  adc_data_in,
  dac_valid_in,
  dac_data_in,

  // dac outputs

  adc_valid,
  adc_data,
  dac_valid,
  dac_data,

  // control signals

  adc_lb_enb,
  dac_lb_enb,
  dac_pn_enb,

  // status signals

  adc_pn_oos,
  adc_pn_err);

  // parameters

  parameter   PRBS_SEL  = 0;
  localparam  PRBS_P09  = 0;
  localparam  PRBS_P11  = 1;
  localparam  PRBS_P15  = 2;
  localparam  PRBS_P20  = 3;

  // device interface

  input           clk;
  input           adc_valid_in;
  input   [11:0]  adc_data_in;
  input           dac_valid_in;
  input   [11:0]  dac_data_in;

  // dac outputs

  output          adc_valid;
  output  [11:0]  adc_data;
  output          dac_valid;
  output  [11:0]  dac_data;

  // control signals

  input           adc_lb_enb;
  input           dac_lb_enb;
  input           dac_pn_enb;

  // status signals

  output          adc_pn_oos;
  output          adc_pn_err;

  // internal registers

  reg             dac_valid_t = 'd0;
  reg     [23:0]  dac_pn = 'd0;
  reg     [11:0]  dac_lb = 'd0;
  reg             dac_valid = 'd0;
  reg     [11:0]  dac_data = 'd0;
  reg     [11:0]  adc_lb = 'd0;
  reg             adc_valid = 'd0;
  reg     [11:0]  adc_data = 'd0;
  reg             adc_valid_t = 'd0;
  reg     [11:0]  adc_data_in_d = 'd0;
  reg     [23:0]  adc_pn_data = 'd0;
  reg             adc_pn_err = 'd0;
  reg             adc_pn_oos = 'd0;
  reg     [ 3:0]  adc_pn_oos_count = 'd0;

  // internal signals

  wire            dac_valid_t_s;
  wire            adc_valid_t_s;
  wire    [23:0]  adc_data_in_s;
  wire            adc_pn_err_s;
  wire            adc_pn_update_s;
  wire            adc_pn_match_s;
  wire            adc_pn_match_z_s;
  wire            adc_pn_match_d_s;
  wire    [23:0]  adc_pn_data_s;

  // prbs functions

  function [23:0] pn;
    input [23:0] din;
    reg   [23:0] dout;
    begin
      case (PRBS_SEL)
        PRBS_P09: begin
          dout[23] = din[ 8] ^ din[ 4];
          dout[22] = din[ 7] ^ din[ 3];
          dout[21] = din[ 6] ^ din[ 2];
          dout[20] = din[ 5] ^ din[ 1];
          dout[19] = din[ 4] ^ din[ 0];
          dout[18] = din[ 3] ^ din[ 8] ^ din[ 4];
          dout[17] = din[ 2] ^ din[ 7] ^ din[ 3];
          dout[16] = din[ 1] ^ din[ 6] ^ din[ 2];
          dout[15] = din[ 0] ^ din[ 5] ^ din[ 1];
          dout[14] = din[ 8] ^ din[ 0];
          dout[13] = din[ 7] ^ din[ 8] ^ din[ 4];
          dout[12] = din[ 6] ^ din[ 7] ^ din[ 3];
          dout[11] = din[ 5] ^ din[ 6] ^ din[ 2];
          dout[10] = din[ 4] ^ din[ 5] ^ din[ 1];
          dout[ 9] = din[ 3] ^ din[ 4] ^ din[ 0];
          dout[ 8] = din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
          dout[ 7] = din[ 1] ^ din[ 2] ^ din[ 7] ^ din[ 3];
          dout[ 6] = din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 2];
          dout[ 5] = din[ 8] ^ din[ 0] ^ din[ 4] ^ din[ 5] ^ din[ 1];
          dout[ 4] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 0];
          dout[ 3] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 8] ^ din[ 4];
          dout[ 2] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 7] ^ din[ 3];
          dout[ 1] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6] ^ din[ 2];
          dout[ 0] = din[ 3] ^ din[ 8] ^ din[ 5] ^ din[ 1];
        end
        PRBS_P11: begin
          dout[23] = din[10] ^ din[ 8];
          dout[22] = din[ 9] ^ din[ 7];
          dout[21] = din[ 8] ^ din[ 6];
          dout[20] = din[ 7] ^ din[ 5];
          dout[19] = din[ 6] ^ din[ 4];
          dout[18] = din[ 5] ^ din[ 3];
          dout[17] = din[ 4] ^ din[ 2];
          dout[16] = din[ 3] ^ din[ 1];
          dout[15] = din[ 2] ^ din[ 0];
          dout[14] = din[ 1] ^ din[10] ^ din[ 8];
          dout[13] = din[ 0] ^ din[ 9] ^ din[ 7];
          dout[12] = din[10] ^ din[ 6];
          dout[11] = din[ 9] ^ din[ 5];
          dout[10] = din[ 8] ^ din[ 4];
          dout[ 9] = din[ 7] ^ din[ 3];
          dout[ 8] = din[ 6] ^ din[ 2];
          dout[ 7] = din[ 5] ^ din[ 1];
          dout[ 6] = din[ 4] ^ din[ 0];
          dout[ 5] = din[ 3] ^ din[10] ^ din[ 8];
          dout[ 4] = din[ 2] ^ din[ 9] ^ din[ 7];
          dout[ 3] = din[ 1] ^ din[ 8] ^ din[ 6];
          dout[ 2] = din[ 0] ^ din[ 7] ^ din[ 5];
          dout[ 1] = din[10] ^ din[ 6] ^ din[ 8] ^ din[ 4];
          dout[ 0] = din[ 9] ^ din[ 5] ^ din[ 7] ^ din[ 3];
        end
        PRBS_P15: begin
          dout[23] = din[14] ^ din[13];
          dout[22] = din[13] ^ din[12];
          dout[21] = din[12] ^ din[11];
          dout[20] = din[11] ^ din[10];
          dout[19] = din[10] ^ din[ 9];
          dout[18] = din[ 9] ^ din[ 8];
          dout[17] = din[ 8] ^ din[ 7];
          dout[16] = din[ 7] ^ din[ 6];
          dout[15] = din[ 6] ^ din[ 5];
          dout[14] = din[ 5] ^ din[ 4];
          dout[13] = din[ 4] ^ din[ 3];
          dout[12] = din[ 3] ^ din[ 2];
          dout[11] = din[ 2] ^ din[ 1];
          dout[10] = din[ 1] ^ din[ 0];
          dout[ 9] = din[ 0] ^ din[14] ^ din[13];
          dout[ 8] = din[14] ^ din[12];
          dout[ 7] = din[13] ^ din[11];
          dout[ 6] = din[12] ^ din[10];
          dout[ 5] = din[11] ^ din[ 9];
          dout[ 4] = din[10] ^ din[ 8];
          dout[ 3] = din[ 9] ^ din[ 7];
          dout[ 2] = din[ 8] ^ din[ 6];
          dout[ 1] = din[ 7] ^ din[ 5];
          dout[ 0] = din[ 6] ^ din[ 4];
        end
        PRBS_P20: begin
          dout[23] = din[19] ^ din[ 2];
          dout[22] = din[18] ^ din[ 1];
          dout[21] = din[17] ^ din[ 0];
          dout[20] = din[16] ^ din[19] ^ din[ 2];
          dout[19] = din[15] ^ din[18] ^ din[ 1];
          dout[18] = din[14] ^ din[17] ^ din[ 0];
          dout[17] = din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[16] = din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[15] = din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[14] = din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[13] = din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[12] = din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[11] = din[ 7] ^ din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[10] = din[ 6] ^ din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[ 9] = din[ 5] ^ din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[ 8] = din[ 4] ^ din[ 7] ^ din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[ 7] = din[ 3] ^ din[ 6] ^ din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[ 6] = din[ 2] ^ din[ 5] ^ din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[ 5] = din[ 1] ^ din[ 4] ^ din[ 7] ^ din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[ 4] = din[ 0] ^ din[ 3] ^ din[ 6] ^ din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[ 3] = din[19] ^ din[ 5] ^ din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[ 2] = din[18] ^ din[ 4] ^ din[ 7] ^ din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[ 1] = din[17] ^ din[ 3] ^ din[ 6] ^ din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[ 0] = din[16] ^ din[ 2] ^ din[ 5] ^ din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
        end
      endcase
      pn = dout;
    end
  endfunction

  // prbs generators run at 24bits wide

  assign dac_valid_t_s = dac_valid_in & dac_valid_t;

  always @(posedge clk) begin
    if (dac_valid_in == 1'b1) begin
      dac_valid_t <= ~dac_valid_t;
    end
    if (dac_pn_enb == 1'b0) begin
      dac_pn <= 24'hffffff;
    end else if (dac_valid_t_s == 1'b1) begin
      dac_pn <= pn(dac_pn);
    end
  end

  // hold adc data for loopback, it is assumed that there is a one to one mapping
  // of receive and transmit (the rates are the same).

  always @(posedge clk) begin
    if (dac_valid_in == 1'b1) begin
      dac_lb <= adc_data_in;
    end
  end

  // dac outputs-

  always @(posedge clk) begin
    dac_valid <= dac_valid_in;
    if (dac_pn_enb == 1'b1) begin
      if (dac_valid_t == 1'b1) begin
        dac_data <= dac_pn[11:0];
      end else begin
        dac_data <= dac_pn[23:12];
      end
    end else if (dac_lb_enb == 1'b1) begin
      dac_data <= dac_lb;
    end else begin
      dac_data <= dac_data_in;
    end
  end

  // hold dac data for loopback, it is assumed that there is a one to one mapping
  // of receive and transmit (the rates are the same).

  always @(posedge clk) begin
    if (adc_valid_in == 1'b1) begin
      adc_lb <= dac_data_in;
    end
  end

  // adc outputs-

  always @(posedge clk) begin
    adc_valid <= adc_valid_in;
    if (adc_lb_enb == 1'b1) begin
      adc_data <= adc_lb;
    end else begin
      adc_data <= adc_data_in;
    end
  end

  // adc pn monitoring

  assign adc_valid_t_s = adc_valid_in & adc_valid_t;
  assign adc_data_in_s = {adc_data_in_d, adc_data_in};
  assign adc_pn_err_s = ~(adc_pn_oos | adc_pn_match_s);
  assign adc_pn_update_s = ~(adc_pn_oos ^ adc_pn_match_s);
  assign adc_pn_match_s = adc_pn_match_d_s & adc_pn_match_z_s;
  assign adc_pn_match_z_s = (adc_data_in_s == 24'd0) ? 1'b0 : 1'b1;
  assign adc_pn_match_d_s = (adc_data_in_s == adc_pn_data) ? 1'b1 : 1'b0;
  assign adc_pn_data_s = (adc_pn_oos == 1'b1) ? adc_data_in_s : adc_pn_data;

  // adc pn running sequence

  always @(posedge clk) begin
    if (adc_valid_in == 1'b1) begin
      adc_valid_t <= ~adc_valid_t;
      adc_data_in_d <= adc_data_in;
    end
    if (adc_valid_t_s == 1'b1) begin
      adc_pn_data <= pn(adc_pn_data_s);
    end
  end

  // pn oos and counters (16 to clear and set).

  always @(posedge clk) begin
    if (adc_valid_t_s == 1'b1) begin
      adc_pn_err <= adc_pn_err_s;
      if ((adc_pn_update_s == 1'b1) && (adc_pn_oos_count >= 15)) begin
        adc_pn_oos <= ~adc_pn_oos;
      end
      if (adc_pn_update_s == 1'b1) begin
        adc_pn_oos_count <= adc_pn_oos_count + 1'b1;
      end else begin
        adc_pn_oos_count <= 'd0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
