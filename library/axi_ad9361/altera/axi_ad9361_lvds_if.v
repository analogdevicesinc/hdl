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

module axi_ad9361_lvds_if #(

  parameter   DEVICE_TYPE = 0,
  parameter   DAC_IODELAY_ENABLE = 0,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group") (

  // physical interface (receive)

  input               rx_clk_in_p,
  input               rx_clk_in_n,
  input               rx_frame_in_p,
  input               rx_frame_in_n,
  input   [ 5:0]      rx_data_in_p,
  input   [ 5:0]      rx_data_in_n,

  // physical interface (transmit)

  output              tx_clk_out_p,
  output              tx_clk_out_n,
  output              tx_frame_out_p,
  output              tx_frame_out_n,
  output  [ 5:0]      tx_data_out_p,
  output  [ 5:0]      tx_data_out_n,

  // ensm control

  output              enable,
  output              txnrx,

  // clock (common to both receive and transmit)

  input               rst,
  input               clk,
  output              l_clk,

  // receive data path interface

  output  reg         adc_valid,
  output  reg [47:0]  adc_data,
  output  reg         adc_status,
  input               adc_r1_mode,
  input               adc_ddr_edgesel,

  // transmit data path interface

  input               dac_valid,
  input   [47:0]      dac_data,
  input               dac_clksel,
  input               dac_r1_mode,

  // tdd interface

  input               tdd_enable,
  input               tdd_txnrx,
  input               tdd_mode,

  // delay interface

  input               mmcm_rst,
  input               up_clk,
  input               up_rstn,
  input               up_enable,
  input               up_txnrx,
  input   [ 6:0]      up_adc_dld,
  input   [34:0]      up_adc_dwdata,
  output  [34:0]      up_adc_drdata,
  input   [ 9:0]      up_dac_dld,
  input   [49:0]      up_dac_dwdata,
  output  [49:0]      up_dac_drdata,
  input               delay_clk,
  input               delay_rst,
  output              delay_locked,

  // drp interface

  input               up_drp_sel,
  input               up_drp_wr,
  input   [11:0]      up_drp_addr,
  input   [31:0]      up_drp_wdata,
  output  [31:0]      up_drp_rdata,
  output              up_drp_ready,
  output              up_drp_locked);

  // internal registers

  reg     [ 3:0]  rx_frame = 'd0;
  reg             rx_error = 'd0;
  reg             rx_valid = 'd0;
  reg     [ 5:0]  rx_data_3 = 'd0;
  reg     [ 5:0]  rx_data_2 = 'd0;
  reg     [ 5:0]  rx_data_1 = 'd0;
  reg     [ 5:0]  rx_data_0 = 'd0;
  reg     [23:0]  rx_data = 'd0;
  reg     [ 3:0]  tx_frame = 'd0;
  reg     [ 3:0]  tx_p_frame = 'd0;
  reg     [ 3:0]  tx_n_frame = 'd0;
  reg     [ 5:0]  tx_data_d_0 = 'd0;
  reg     [ 5:0]  tx_data_d_1 = 'd0;
  reg     [ 5:0]  tx_data_d_2 = 'd0;
  reg     [ 5:0]  tx_data_d_3 = 'd0;
  reg             tx_data_sel  = 'd0;
  reg             up_enable_int = 'd0;
  reg             up_txnrx_int = 'd0;
  reg             enable_up_m1 = 'd0;
  reg             txnrx_up_m1 = 'd0;
  reg             enable_up = 'd0;
  reg             txnrx_up = 'd0;
  reg             enable_int = 'd0;
  reg             txnrx_int = 'd0;
  reg             enable_n_int = 'd0;
  reg             txnrx_n_int = 'd0;
  reg             enable_p_int = 'd0;
  reg             txnrx_p_int = 'd0;
  reg    [ 5:0]   tx_p_data_d_0 = 'd0;
  reg    [ 5:0]   tx_p_data_d_1 = 'd0;
  reg    [ 5:0]   tx_p_data_d_2 = 'd0;
  reg    [ 5:0]   tx_p_data_d_3 = 'd0;
  reg    [ 5:0]   tx_n_data_d_0 = 'd0;
  reg    [ 5:0]   tx_n_data_d_1 = 'd0;
  reg    [ 5:0]   tx_n_data_d_2 = 'd0;
  reg    [ 5:0]   tx_n_data_d_3 = 'd0;
  reg             adc_n_valid = 'd0;
  reg             adc_p_valid = 'd0;
  reg             adc_n_status = 'd0;
  reg             adc_p_status = 'd0;
  reg    [47:0]   adc_n_data = 'd0;
  reg    [47:0]   adc_p_data = 'd0;

  // internal signals

  wire            s_clk;
  wire            loaden;
  wire    [ 7:0]  phase_s;
  wire    [ 3:0]  rx_frame_s;
  wire    [ 5:0]  rx_data_s_3;
  wire    [ 5:0]  rx_data_s_2;
  wire    [ 5:0]  rx_data_s_1;
  wire    [ 5:0]  rx_data_s_0;
  wire    [ 3:0]  rx_frame_inv_s;

  // unused interface signals

  assign up_adc_drdata = 35'b0;
  assign up_dac_drdata = 50'b0;
  assign delay_locked = 1'b1;

  assign rx_frame_inv_s = ~rx_frame;

  always @(posedge l_clk) begin
    rx_frame <= rx_frame_s;
    rx_data_3 <= rx_data_s_3;
    rx_data_2 <= rx_data_s_2;
    rx_data_1 <= rx_data_s_1;
    rx_data_0 <= rx_data_s_0;
    if (rx_frame_inv_s == rx_frame_s) begin
      rx_error <= 1'b0;
    end else begin
      rx_error <= 1'b1;
    end
    case ({adc_r1_mode, rx_frame})
      // R2 Mode
      5'b01111: begin
        rx_valid <= 1'b1;
        rx_data[23:12] <= {rx_data_1,   rx_data_3};
        rx_data[11: 0] <= {rx_data_0,   rx_data_2};
      end
      5'b01110: begin
        rx_valid <= 1'b1;
        rx_data[23:12] <= {rx_data_2,   rx_data_s_0};
        rx_data[11: 0] <= {rx_data_1,   rx_data_3};
      end
      5'b01100: begin
        rx_valid <= 1'b1;
        rx_data[23:12] <= {rx_data_3,   rx_data_s_1};
        rx_data[11: 0] <= {rx_data_2,   rx_data_s_0};
      end
      5'b01000: begin
        rx_valid <= 1'b1;
        rx_data[23:12] <= {rx_data_s_0, rx_data_s_2};
        rx_data[11: 0] <= {rx_data_3,   rx_data_s_1};
      end
      5'b00000: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= {rx_data_1,   rx_data_3};
        rx_data[11: 0] <= {rx_data_0,   rx_data_2};
      end
      5'b00001: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= {rx_data_2,   rx_data_s_0};
        rx_data[11: 0] <= {rx_data_1,   rx_data_3};
      end
      5'b00011: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= {rx_data_3,   rx_data_s_1};
        rx_data[11: 0] <= {rx_data_2,   rx_data_s_0};
      end
      5'b00111: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= {rx_data_s_0, rx_data_s_2};
        rx_data[11: 0] <= {rx_data_3,   rx_data_s_1};
      end
      // R1 Mode
      5'b11100: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= {rx_data_s_1, rx_data_s_3};
        rx_data[11: 0] <= {rx_data_s_0, rx_data_s_2};
      end
      5'b10110: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= {rx_data_2, rx_data_s_0};
        rx_data[11: 0] <= {rx_data_1, rx_data_3};
      end
      5'b11001: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= {rx_data_s_0, rx_data_s_2};
        rx_data[11: 0] <= {rx_data_3, rx_data_s_1};
      end
      5'b10011: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= {rx_data_3, rx_data_s_1};
        rx_data[11: 0] <= {rx_data_2, rx_data_s_0};
      end
      default: begin
        rx_valid <= 1'b0;
        rx_data[23:12] <= 12'd0;
        rx_data[11: 0] <= 12'd0;
      end
    endcase
    if (rx_valid == 1'b1) begin
      adc_p_valid <= 1'b0;
      adc_p_data <= {24'd0, rx_data};
    end else begin
      adc_p_valid <= 1'b1;
      adc_p_data <= (adc_r1_mode) ? {24'd0, rx_data} : {rx_data, adc_p_data[23:0]};
    end
    adc_p_status <= ~rx_error & up_drp_locked;
  end

  // transfer to a synchronous common clock

  always @(negedge l_clk) begin
    adc_n_valid <= adc_p_valid;
    adc_n_data <= adc_p_data;
    adc_n_status <= adc_p_status;
  end

  always @(posedge clk) begin
    adc_valid <= adc_n_valid;
    adc_data <= adc_n_data;
    adc_status <= adc_n_status;
  end

  always @(posedge clk) begin
    if (dac_r1_mode == 1'b0) begin
      tx_data_sel <= ~tx_data_sel;
    end else begin
      tx_data_sel <= 1'b0;
    end

    case ({dac_r1_mode, tx_data_sel})
      2'b10: begin
         tx_frame <= 4'b1100;
         tx_data_d_0 <= dac_data[11: 6]; // i msb
         tx_data_d_1 <= dac_data[23:18]; // q msb
         tx_data_d_2 <= dac_data[ 5: 0]; // i lsb
         tx_data_d_3 <= dac_data[17:12]; // q lsb
      end
      2'b00: begin
         tx_frame <= 4'b1111;
         tx_data_d_0 <= dac_data[11: 6]; // i msb 0
         tx_data_d_1 <= dac_data[23:18]; // q msb 0
         tx_data_d_2 <= dac_data[ 5: 0]; // i lsb 0
         tx_data_d_3 <= dac_data[17:12]; // q lsb 0
      end
      2'b01: begin
         tx_frame <= 4'b0000;
         tx_data_d_0 <= dac_data[35:30]; // i msb 1
         tx_data_d_1 <= dac_data[47:42]; // q msb 1
         tx_data_d_2 <= dac_data[29:24]; // i lsb 1
         tx_data_d_3 <= dac_data[41:36]; // q lsb 1
      end
    endcase

  end

  // transfer data from a synchronous clock (skew less than 2ns)

  always @(negedge clk) begin
    tx_n_frame <= tx_frame;
    tx_n_data_d_0 <= tx_data_d_0;
    tx_n_data_d_1 <= tx_data_d_1;
    tx_n_data_d_2 <= tx_data_d_2;
    tx_n_data_d_3 <= tx_data_d_3;
  end

  always @(posedge l_clk) begin
    tx_p_frame <= tx_n_frame;
    tx_p_data_d_0 <= tx_n_data_d_0;
    tx_p_data_d_1 <= tx_n_data_d_1;
    tx_p_data_d_2 <= tx_n_data_d_2;
    tx_p_data_d_3 <= tx_n_data_d_3;
  end

  // tdd/ensm control

  always @(posedge up_clk) begin
    up_enable_int <= up_enable;
    up_txnrx_int <= up_txnrx;
  end

  always @(posedge clk or posedge rst) begin
    if (rst == 1'b1) begin
      enable_up_m1 <= 1'b0;
      txnrx_up_m1 <= 1'b0;
      enable_up <= 1'b0;
      txnrx_up <= 1'b0;
    end else begin
      enable_up_m1 <= up_enable_int;
      txnrx_up_m1 <= up_txnrx_int;
      enable_up <= enable_up_m1;
      txnrx_up <= txnrx_up_m1;
    end
  end

  always @(posedge clk) begin
    if (tdd_mode == 1'b1) begin
      enable_int <= tdd_enable;
      txnrx_int <= tdd_txnrx;
    end else begin
      enable_int <= enable_up;
      txnrx_int <= txnrx_up;
    end
  end

  always @(negedge clk) begin
    enable_n_int <= enable_int;
    txnrx_n_int <= txnrx_int;
  end

  always @(posedge l_clk) begin
    enable_p_int <= enable_n_int;
    txnrx_p_int <= txnrx_n_int;
  end

  // receive data path interface

  ad_serdes_in #(
    .DATA_WIDTH (6),
    .SERDES_FACTOR (4),
    .DEVICE_TYPE (DEVICE_TYPE))
  ad_serdes_data_in (
    .rst (mmcm_rst),
    .clk (s_clk),
    .div_clk (l_clk),
    .loaden (loaden),
    .locked (up_drp_locked),
    .phase (phase_s),
    .data_s0 (rx_data_s_0),
    .data_s1 (rx_data_s_1),
    .data_s2 (rx_data_s_2),
    .data_s3 (rx_data_s_3),
    .data_s4 (),
    .data_s5 (),
    .data_s6 (),
    .data_s7 (),
    .data_in_p (rx_data_in_p),
    .data_in_n (rx_data_in_n),
    .up_clk (1'd0),
    .up_dld (6'd0),
    .up_dwdata (30'd0),
    .up_drdata (),
    .delay_clk (1'd0),
    .delay_rst (1'd0),
    .delay_locked ());

  // receive frame interface

  ad_serdes_in #(
    .DATA_WIDTH (1),
    .SERDES_FACTOR (4),
    .DEVICE_TYPE (DEVICE_TYPE))
  ad_serdes_frame_in (
    .rst (mmcm_rst),
    .clk (s_clk),
    .div_clk (l_clk),
    .loaden (loaden),
    .locked (up_drp_locked),
    .phase (phase_s),
    .data_s0 (rx_frame_s[0]),
    .data_s1 (rx_frame_s[1]),
    .data_s2 (rx_frame_s[2]),
    .data_s3 (rx_frame_s[3]),
    .data_s4 (),
    .data_s5 (),
    .data_s6 (),
    .data_s7 (),
    .data_in_p (rx_frame_in_p),
    .data_in_n (rx_frame_in_n),
    .up_clk (1'd0),
    .up_dld (1'd0),
    .up_dwdata (5'd0),
    .up_drdata (),
    .delay_clk (1'd0),
    .delay_rst (1'd0),
    .delay_locked ());

  // transmit data interface

  ad_serdes_out #(
    .DATA_WIDTH (6),
    .SERDES_FACTOR (4),
    .DEVICE_TYPE (DEVICE_TYPE))
  ad_serdes_data_out (
    .rst (mmcm_rst),
    .clk (s_clk),
    .div_clk (l_clk),
    .loaden (loaden),
    .data_s0 (tx_p_data_d_0),
    .data_s1 (tx_p_data_d_1),
    .data_s2 (tx_p_data_d_2),
    .data_s3 (tx_p_data_d_3),
    .data_s4 (6'd0),
    .data_s5 (6'd0),
    .data_s6 (6'd0),
    .data_s7 (6'd0),
    .data_out_p (tx_data_out_p),
    .data_out_n (tx_data_out_n));

  // transmit frame interface

  ad_serdes_out #(
    .DATA_WIDTH (1),
    .SERDES_FACTOR (4),
    .DEVICE_TYPE (DEVICE_TYPE))
  ad_serdes_frame_out (
    .rst (mmcm_rst),
    .clk (s_clk),
    .div_clk (l_clk),
    .loaden (loaden),
    .data_s0 (tx_p_frame[0]),
    .data_s1 (tx_p_frame[1]),
    .data_s2 (tx_p_frame[2]),
    .data_s3 (tx_p_frame[3]),
    .data_s4 (1'd0),
    .data_s5 (1'd0),
    .data_s6 (1'd0),
    .data_s7 (1'd0),
    .data_out_p (tx_frame_out_p),
    .data_out_n (tx_frame_out_n));

  // transmit clock interface

  ad_serdes_out #(
    .DATA_WIDTH(1),
    .SERDES_FACTOR(4),
    .DEVICE_TYPE(DEVICE_TYPE))
  ad_serdes_tx_clock_out(
    .rst (mmcm_rst),
    .clk (s_clk),
    .div_clk (l_clk),
    .loaden (loaden),
    .data_s0 (dac_clksel),
    .data_s1 (~dac_clksel),
    .data_s2 (dac_clksel),
    .data_s3 (~dac_clksel),
    .data_s4 (1'd0),
    .data_s5 (1'd0),
    .data_s6 (1'd0),
    .data_s7 (1'd0),
    .data_out_p (tx_clk_out_p),
    .data_out_n (tx_clk_out_n));

  // serdes clock interface

  ad_serdes_clk #(
    .DEVICE_TYPE (DEVICE_TYPE))
  ad_serdes_clk (
    .rst (mmcm_rst),
    .clk_in_p (rx_clk_in_p),
    .clk_in_n (rx_clk_in_n),
    .clk (s_clk),
    .div_clk (l_clk),
    .out_clk (),
    .loaden (loaden),
    .phase (phase_s),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked));

 // enable

  ad_cmos_out #(
    .DEVICE_TYPE (DEVICE_TYPE))
  i_enable (
    .tx_clk (l_clk),
    .tx_data_p (enable_p_int),
    .tx_data_n (enable_p_int),
    .tx_data_out (enable));

  // txnrx

  ad_cmos_out #(
    .DEVICE_TYPE (DEVICE_TYPE))
  i_txnrx (
    .tx_clk (l_clk),
    .tx_data_p (txnrx_p_int),
    .tx_data_n (txnrx_p_int),
    .tx_data_out (txnrx));

endmodule

// ***************************************************************************
// ***************************************************************************
