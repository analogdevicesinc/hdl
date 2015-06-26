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
// This interface includes both the transmit and receive components -
// They both uses the same clock (sourced from the receiving side).

`timescale 1ns/100ps

module axi_ad9361_dev_if (

  // physical interface (receive)

  rx_clk_in_p,
  rx_clk_in_n,
  rx_frame_in_p,
  rx_frame_in_n,
  rx_data_in_p,
  rx_data_in_n,

  // physical interface (transmit)

  tx_clk_out_p,
  tx_clk_out_n,
  tx_frame_out_p,
  tx_frame_out_n,
  tx_data_out_p,
  tx_data_out_n,

  // clock (common to both receive and transmit)

  rst,
  clk,
  l_clk,

  // receive data path interface

  adc_valid,
  adc_data,
  adc_status,
  adc_r1_mode,
  adc_ddr_edgesel,

  // transmit data path interface

  dac_valid,
  dac_data,
  dac_r1_mode,

  // delay interface

  up_clk,
  up_adc_dld,
  up_adc_dwdata,
  up_adc_drdata,
  up_dac_dld,
  up_dac_dwdata,
  up_dac_drdata,
  delay_clk,
  delay_rst,
  delay_locked);

  // this parameter controls the buffer type based on the target device.

  parameter   PCORE_DEVICE_TYPE = 0;
  parameter   PCORE_DAC_IODELAY_ENABLE = 0;
  parameter   PCORE_IODELAY_GROUP = "dev_if_delay_group";
  localparam  PCORE_7SERIES = 0;
  localparam  PCORE_VIRTEX6 = 1;

  // physical interface (receive)

  input           rx_clk_in_p;
  input           rx_clk_in_n;
  input           rx_frame_in_p;
  input           rx_frame_in_n;
  input   [ 5:0]  rx_data_in_p;
  input   [ 5:0]  rx_data_in_n;

  // physical interface (transmit)

  output          tx_clk_out_p;
  output          tx_clk_out_n;
  output          tx_frame_out_p;
  output          tx_frame_out_n;
  output  [ 5:0]  tx_data_out_p;
  output  [ 5:0]  tx_data_out_n;

  // clock (common to both receive and transmit)

  input           rst;
  input           clk;
  output          l_clk;

  // receive data path interface

  output          adc_valid;
  output  [47:0]  adc_data;
  output          adc_status;
  input           adc_r1_mode;
  input           adc_ddr_edgesel;

  // transmit data path interface

  input           dac_valid;
  input   [47:0]  dac_data;
  input           dac_r1_mode;

  // delay interface

  input           up_clk;
  input   [ 6:0]  up_adc_dld;
  input   [34:0]  up_adc_dwdata;
  output  [34:0]  up_adc_drdata;
  input   [ 7:0]  up_dac_dld;
  input   [39:0]  up_dac_dwdata;
  output  [39:0]  up_dac_drdata;
  input           delay_clk;
  input           delay_rst;
  output          delay_locked;

  // internal registers

  reg     [ 5:0]  rx_data_p = 0;
  reg             rx_frame_p = 0;
  reg     [ 1:0]  rx_ccnt = 0;
  reg             rx_calign = 0;
  reg             rx_align = 0;
  reg     [11:0]  rx_data = 'd0;
  reg     [ 1:0]  rx_frame = 'd0;
  reg     [11:0]  rx_data_d = 'd0;
  reg     [ 1:0]  rx_frame_d = 'd0;
  reg             rx_error_r1 = 'd0;
  reg             rx_valid_r1 = 'd0;
  reg     [23:0]  rx_data_r1 = 'd0;
  reg             rx_error_r2 = 'd0;
  reg             rx_valid_r2 = 'd0;
  reg     [47:0]  rx_data_r2 = 'd0;
  reg             adc_p_valid = 'd0;
  reg     [47:0]  adc_p_data = 'd0;
  reg             adc_p_status = 'd0;
  reg             adc_n_valid = 'd0;
  reg     [47:0]  adc_n_data = 'd0;
  reg             adc_n_status = 'd0;
  reg             adc_valid_int = 'd0;
  reg     [47:0]  adc_data_int = 'd0;
  reg             adc_status_int = 'd0;
  reg             adc_valid = 'd0;
  reg     [47:0]  adc_data = 'd0;
  reg             adc_status = 'd0;
  reg     [ 2:0]  tx_data_cnt = 'd0;
  reg     [47:0]  tx_data = 'd0;
  reg             tx_frame = 'd0;
  reg     [ 5:0]  tx_data_p = 'd0;
  reg     [ 5:0]  tx_data_n = 'd0;
  reg             tx_n_frame = 'd0;
  reg     [ 5:0]  tx_n_data_p = 'd0;
  reg     [ 5:0]  tx_n_data_n = 'd0;
  reg             tx_p_frame = 'd0;
  reg     [ 5:0]  tx_p_data_p = 'd0;
  reg     [ 5:0]  tx_p_data_n = 'd0;

  // internal signals

  wire            rx_align_s;
  wire    [ 3:0]  rx_frame_s;
  wire    [ 3:0]  tx_data_sel_s;
  wire    [ 5:0]  rx_data_p_s;
  wire    [ 5:0]  rx_data_n_s;
  wire            rx_frame_p_s;
  wire            rx_frame_n_s;

  genvar          l_inst;

  // receive data path interface

  assign rx_align_s = rx_frame_n_s ^ rx_frame_p_s;

  always @(posedge l_clk) begin
    rx_data_p <= rx_data_p_s;
    rx_frame_p <= rx_frame_p_s;
    rx_ccnt <= rx_ccnt + 1'b1;
    if (rx_ccnt == 2'd0) begin
      rx_calign <= rx_align;
      rx_align <= rx_align_s;
    end else begin
      rx_calign <= rx_calign;
      rx_align <= rx_align | rx_align_s;
    end
  end

  assign rx_frame_s = {rx_frame_d, rx_frame};

  always @(posedge l_clk) begin
    if (rx_calign == 1'b1) begin
      rx_data <= {rx_data_p, rx_data_n_s};
      rx_frame <= {rx_frame_p, rx_frame_n_s};
    end else begin
      rx_data <= {rx_data_n_s, rx_data_p_s};
      rx_frame <= {rx_frame_n_s, rx_frame_p_s};
    end
    rx_data_d <= rx_data;
    rx_frame_d <= rx_frame;
  end

  // receive data path for single rf, frame is expected to qualify i/q msb only

  always @(posedge l_clk) begin
    rx_error_r1 <= ((rx_frame_s == 4'b1100) || (rx_frame_s == 4'b0011)) ? 1'b0 : 1'b1;
    rx_valid_r1 <= (rx_frame_s == 4'b1100) ? 1'b1 : 1'b0;
    if (rx_frame_s == 4'b1100) begin
      rx_data_r1[11: 0] <= {rx_data_d[11:6], rx_data[11:6]};
      rx_data_r1[23:12] <= {rx_data_d[ 5:0], rx_data[ 5:0]};
    end
  end

  // receive data path for dual rf, frame is expected to qualify i/q msb and lsb for rf-1 only

  always @(posedge l_clk) begin
    rx_error_r2 <= ((rx_frame_s == 4'b1111) || (rx_frame_s == 4'b1100) ||
      (rx_frame_s == 4'b0000) || (rx_frame_s == 4'b0011)) ? 1'b0 : 1'b1;
    rx_valid_r2 <= (rx_frame_s == 4'b0000) ? 1'b1 : 1'b0;
    if (rx_frame_s == 4'b1111) begin
      rx_data_r2[11: 0] <= {rx_data_d[11:6], rx_data[11:6]};
      rx_data_r2[23:12] <= {rx_data_d[ 5:0], rx_data[ 5:0]};
    end
    if (rx_frame_s == 4'b0000) begin
      rx_data_r2[35:24] <= {rx_data_d[11:6], rx_data[11:6]};
      rx_data_r2[47:36] <= {rx_data_d[ 5:0], rx_data[ 5:0]};
    end
  end

  // receive data path mux

  always @(posedge l_clk) begin
    if (adc_r1_mode == 1'b1) begin
      adc_p_valid <= rx_valid_r1;
      adc_p_data <= {24'd0, rx_data_r1};
      adc_p_status <= ~rx_error_r1;
    end else begin
      adc_p_valid <= rx_valid_r2;
      adc_p_data <= rx_data_r2;
      adc_p_status <= ~rx_error_r2;
    end
  end

  // transfer to a synchronous common clock

  always @(negedge l_clk) begin
    adc_n_valid <= adc_p_valid;
    adc_n_data <= adc_p_data;
    adc_n_status <= adc_p_status;
  end

  always @(posedge clk) begin
    adc_valid_int <= adc_n_valid;
    adc_data_int <= adc_n_data;
    adc_status_int <= adc_n_status;
    adc_valid <= adc_valid_int;
    if (adc_valid_int == 1'b1) begin
      adc_data <= adc_data_int;
    end
    adc_status <= adc_status_int;
  end

  // transmit data path mux (reverse of what receive does above)
  // the count simply selets the data muxing on the ddr outputs

  assign tx_data_sel_s = {tx_data_cnt[2], dac_r1_mode, tx_data_cnt[1:0]};

  always @(posedge clk) begin
    if (dac_valid == 1'b1) begin
      tx_data_cnt <= 3'b100;
    end else if (tx_data_cnt[2] == 1'b1) begin
      tx_data_cnt <= tx_data_cnt + 1'b1;
    end
    if (dac_valid == 1'b1) begin
      tx_data <= dac_data;
    end
    case (tx_data_sel_s)
      4'b1111: begin
        tx_frame <= 1'b0;
        tx_data_p <= tx_data[ 5: 0];
        tx_data_n <= tx_data[17:12];
      end
      4'b1110: begin
        tx_frame <= 1'b1;
        tx_data_p <= tx_data[11: 6];
        tx_data_n <= tx_data[23:18];
      end
      4'b1101: begin
        tx_frame <= 1'b0;
        tx_data_p <= tx_data[ 5: 0];
        tx_data_n <= tx_data[17:12];
      end
      4'b1100: begin
        tx_frame <= 1'b1;
        tx_data_p <= tx_data[11: 6];
        tx_data_n <= tx_data[23:18];
      end
      4'b1011: begin
        tx_frame <= 1'b0;
        tx_data_p <= tx_data[29:24];
        tx_data_n <= tx_data[41:36];
      end
      4'b1010: begin
        tx_frame <= 1'b0;
        tx_data_p <= tx_data[35:30];
        tx_data_n <= tx_data[47:42];
      end
      4'b1001: begin
        tx_frame <= 1'b1;
        tx_data_p <= tx_data[ 5: 0];
        tx_data_n <= tx_data[17:12];
      end
      4'b1000: begin
        tx_frame <= 1'b1;
        tx_data_p <= tx_data[11: 6];
        tx_data_n <= tx_data[23:18];
      end
      default: begin
        tx_frame <= 1'b0;
        tx_data_p <= 6'd0;
        tx_data_n <= 6'd0;
      end
    endcase
  end

  // transfer data from a synchronous clock (skew less than 2ns)

  always @(negedge clk) begin
    tx_n_frame <= tx_frame;
    tx_n_data_p <= tx_data_p;
    tx_n_data_n <= tx_data_n;
  end

  always @(posedge l_clk) begin
    tx_p_frame <= tx_n_frame;
    tx_p_data_p <= tx_n_data_p;
    tx_p_data_n <= tx_n_data_n;
  end

  // receive data interface, ibuf -> idelay -> iddr

  generate
  for (l_inst = 0; l_inst <= 5; l_inst = l_inst + 1) begin: g_rx_data
  ad_lvds_in #(
    .BUFTYPE (PCORE_DEVICE_TYPE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (PCORE_IODELAY_GROUP))
  i_rx_data (
    .rx_clk (l_clk),
    .rx_data_in_p (rx_data_in_p[l_inst]),
    .rx_data_in_n (rx_data_in_n[l_inst]),
    .rx_data_p (rx_data_p_s[l_inst]),
    .rx_data_n (rx_data_n_s[l_inst]),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[l_inst]),
    .up_dwdata (up_adc_dwdata[((l_inst*5)+4):(l_inst*5)]),
    .up_drdata (up_adc_drdata[((l_inst*5)+4):(l_inst*5)]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
  end
  endgenerate

  // receive frame interface, ibuf -> idelay -> iddr

  ad_lvds_in #(
    .BUFTYPE (PCORE_DEVICE_TYPE),
    .IODELAY_CTRL (1),
    .IODELAY_GROUP (PCORE_IODELAY_GROUP))
  i_rx_frame (
    .rx_clk (l_clk),
    .rx_data_in_p (rx_frame_in_p),
    .rx_data_in_n (rx_frame_in_n),
    .rx_data_p (rx_frame_p_s),
    .rx_data_n (rx_frame_n_s),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[6]),
    .up_dwdata (up_adc_dwdata[34:30]),
    .up_drdata (up_adc_drdata[34:30]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // transmit data interface, oddr -> obuf

  generate
  for (l_inst = 0; l_inst <= 5; l_inst = l_inst + 1) begin: g_tx_data
  ad_lvds_out #(
    .BUFTYPE (PCORE_DEVICE_TYPE),
    .IODELAY_ENABLE (PCORE_DAC_IODELAY_ENABLE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (PCORE_IODELAY_GROUP))
  i_tx_data (
    .tx_clk (l_clk),
    .tx_data_p (tx_p_data_p[l_inst]),
    .tx_data_n (tx_p_data_n[l_inst]),
    .tx_data_out_p (tx_data_out_p[l_inst]),
    .tx_data_out_n (tx_data_out_n[l_inst]),
    .up_clk (up_clk),
    .up_dld (up_dac_dld[l_inst]),
    .up_dwdata (up_dac_dwdata[((l_inst*5)+4):(l_inst*5)]),
    .up_drdata (up_dac_drdata[((l_inst*5)+4):(l_inst*5)]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
  end
  endgenerate

  // transmit frame interface, oddr -> obuf

  ad_lvds_out #(
    .BUFTYPE (PCORE_DEVICE_TYPE),
    .IODELAY_ENABLE (PCORE_DAC_IODELAY_ENABLE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (PCORE_IODELAY_GROUP))
  i_tx_frame (
    .tx_clk (l_clk),
    .tx_data_p (tx_p_frame),
    .tx_data_n (tx_p_frame),
    .tx_data_out_p (tx_frame_out_p),
    .tx_data_out_n (tx_frame_out_n),
    .up_clk (up_clk),
    .up_dld (up_dac_dld[6]),
    .up_dwdata (up_dac_dwdata[34:30]),
    .up_drdata (up_dac_drdata[34:30]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());

  // transmit clock interface, oddr -> obuf

  ad_lvds_out #(
    .BUFTYPE (PCORE_DEVICE_TYPE),
    .IODELAY_ENABLE (PCORE_DAC_IODELAY_ENABLE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (PCORE_IODELAY_GROUP))
  i_tx_clk (
    .tx_clk (l_clk),
    .tx_data_p (1'b0),
    .tx_data_n (1'b1),
    .tx_data_out_p (tx_clk_out_p),
    .tx_data_out_n (tx_clk_out_n),
    .up_clk (up_clk),
    .up_dld (up_dac_dld[7]),
    .up_dwdata (up_dac_dwdata[39:35]),
    .up_drdata (up_dac_drdata[39:35]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());

  // device clock interface (receive clock)

  ad_lvds_clk #(
    .BUFTYPE (PCORE_DEVICE_TYPE))
  i_clk (
    .clk_in_p (rx_clk_in_p),
    .clk_in_n (rx_clk_in_n),
    .clk (l_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
