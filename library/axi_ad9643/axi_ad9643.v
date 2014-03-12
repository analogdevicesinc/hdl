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

`timescale 1ns/100ps

module axi_ad9643 (

  // adc interface (clk, data, over-range)

  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_or_in_p,
  adc_or_in_n,

  // master-slave interface

  adc_start_out,
  adc_start_in,

  // delay interface

  delay_clk,

  // dma interface

  adc_clk,
  adc_dwr,
  adc_dsync,
  adc_ddata,
  adc_dovf,
  adc_dunf,

  // axi interface

  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rresp,
  s_axi_rdata,
  s_axi_rready,

  // debug signals

  adc_mon_valid,
  adc_mon_data);

  parameter PCORE_ID = 0;
  parameter PCORE_DEVICE_TYPE = 0;
  parameter PCORE_ADC_DP_DISABLE = 0;
  parameter PCORE_IODELAY_GROUP = "adc_if_delay_group";
  parameter C_S_AXI_MIN_SIZE = 32'hffff;
  parameter C_BASEADDR = 32'hffffffff;
  parameter C_HIGHADDR = 32'h00000000;

  // adc interface (clk, data, over-range)

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [13:0]  adc_data_in_p;
  input   [13:0]  adc_data_in_n;
  input           adc_or_in_p;
  input           adc_or_in_n;

  // master-slave interface

  output          adc_start_out;
  input           adc_start_in;

  // delay interface

  input           delay_clk;

  // dma interface

  output          adc_clk;
  output          adc_dwr;
  output          adc_dsync;
  output  [31:0]  adc_ddata;
  input           adc_dovf;
  input           adc_dunf;

  // axi interface

  input           s_axi_aclk;
  input           s_axi_aresetn;
  input           s_axi_awvalid;
  input   [31:0]  s_axi_awaddr;
  output          s_axi_awready;
  input           s_axi_wvalid;
  input   [31:0]  s_axi_wdata;
  input   [ 3:0]  s_axi_wstrb;
  output          s_axi_wready;
  output          s_axi_bvalid;
  output  [ 1:0]  s_axi_bresp;
  input           s_axi_bready;
  input           s_axi_arvalid;
  input   [31:0]  s_axi_araddr;
  output          s_axi_arready;
  output          s_axi_rvalid;
  output  [ 1:0]  s_axi_rresp;
  output  [31:0]  s_axi_rdata;
  input           s_axi_rready;

  // debug signals

  output          adc_mon_valid;
  output  [27:0]  adc_mon_data;

  // internal registers

  reg             adc_start_out = 'd0;
  reg             adc_data_cnt = 'd0;
  reg             adc_valid = 'd0;
  reg     [31:0]  adc_data = 'd0;
  reg             up_adc_status_pn_err = 'd0;
  reg             up_adc_status_pn_oos = 'd0;
  reg             up_adc_status_or = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_ack = 'd0;

  // internal clocks & resets

  wire            adc_rst;
  wire            up_rstn;
  wire            up_clk;

  // internal signals

  wire            adc_start_s;
  wire    [13:0]  adc_data_a_s;
  wire    [13:0]  adc_data_b_s;
  wire            adc_or_a_s;
  wire            adc_or_b_s;
  wire    [15:0]  adc_dcfilter_data_a_s;
  wire    [15:0]  adc_dcfilter_data_b_s;
  wire    [15:0]  adc_channel_data_a_s;
  wire    [15:0]  adc_channel_data_b_s;
  wire            adc_enable_a_s;
  wire            adc_enable_b_s;
  wire            up_adc_pn_err_a_s;
  wire            up_adc_pn_oos_a_s;
  wire            up_adc_or_a_s;
  wire            up_adc_pn_err_b_s;
  wire            up_adc_pn_oos_b_s;
  wire            up_adc_or_b_s;
  wire            adc_ddr_edgesel_s;
  wire            adc_pin_mode_s;
  wire            adc_status_s;
  wire            delay_rst_s;
  wire            delay_sel_s;
  wire            delay_rwn_s;
  wire    [ 7:0]  delay_addr_s;
  wire    [ 4:0]  delay_wdata_s;
  wire    [ 4:0]  delay_rdata_s;
  wire            delay_ack_t_s;
  wire            delay_locked_s;
  wire            up_sel_s;
  wire            up_wr_s;
  wire    [13:0]  up_addr_s;
  wire    [31:0]  up_wdata_s;
  wire    [31:0]  up_adc_common_rdata_s;
  wire            up_adc_common_ack_s;
  wire    [31:0]  up_adc_channel_rdata_a_s;
  wire            up_adc_channel_ack_a_s;
  wire    [31:0]  up_adc_channel_rdata_b_s;
  wire            up_adc_channel_ack_b_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // monitor signals

  assign adc_mon_valid = 1'b1;
  assign adc_mon_data[13: 0] = adc_data_a_s;
  assign adc_mon_data[27:14] = adc_data_b_s;

  // dma interface

  assign adc_dwr = adc_valid;
  assign adc_dsync = 1'b1;
  assign adc_ddata = adc_data;

  // multiple instances synchronization

  assign adc_start_s = (PCORE_ID == 32'd0) ? adc_start_out : adc_start_in;

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      adc_start_out <= 1'b0;
    end else begin
      adc_start_out <= 1'b1;
    end
  end

  // adc channels - dma interface

  always @(posedge adc_clk) begin
    adc_data_cnt <= ~adc_data_cnt;
    case ({adc_enable_b_s, adc_enable_a_s})
      2'b11: begin // both I and Q
        adc_valid <= adc_start_s;
        adc_data <= {adc_channel_data_b_s, adc_channel_data_a_s};
      end
      2'b10: begin // Q only
        adc_valid <= adc_data_cnt & adc_start_s;
        adc_data <= {adc_channel_data_b_s, adc_data[31:16]};
      end
      2'b01: begin // I only
        adc_valid <= adc_data_cnt & adc_start_s;
        adc_data <= {adc_channel_data_a_s, adc_data[31:16]};
      end
      default: begin // no channels
        adc_valid <= adc_start_s;
        adc_data <= {2{16'hdead}};
      end
    endcase
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_status_pn_err <= 'd0;
      up_adc_status_pn_oos <= 'd0;
      up_adc_status_or <= 'd0;
      up_rdata <= 'd0;
      up_ack <= 'd0;
    end else begin
      up_adc_status_pn_err <= up_adc_pn_err_a_s | up_adc_pn_err_b_s;
      up_adc_status_pn_oos <= up_adc_pn_oos_a_s | up_adc_pn_oos_b_s;
      up_adc_status_or <= up_adc_or_a_s | up_adc_or_b_s;
      up_rdata <= up_adc_common_rdata_s | up_adc_channel_rdata_a_s | up_adc_channel_rdata_b_s;
      up_ack <= up_adc_common_ack_s | up_adc_channel_ack_a_s | up_adc_channel_ack_b_s;
    end
  end

  // channel

  axi_ad9643_channel #(
    .IQSEL(0),
    .CHID(0),
    .DP_DISABLE (PCORE_ADC_DP_DISABLE))
  i_channel_0 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data (adc_data_a_s),
    .adc_or (adc_or_a_s),
    .adc_dcfilter_data_out (adc_dcfilter_data_a_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_b_s),
    .adc_iqcor_data (adc_channel_data_a_s),
    .adc_enable (adc_enable_a_s),
    .up_adc_pn_err (up_adc_pn_err_a_s),
    .up_adc_pn_oos (up_adc_pn_oos_a_s),
    .up_adc_or (up_adc_or_a_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_adc_channel_rdata_a_s),
    .up_ack (up_adc_channel_ack_a_s));

  // channel

  axi_ad9643_channel #(
    .IQSEL(1),
    .CHID(1),
    .DP_DISABLE (PCORE_ADC_DP_DISABLE))
  i_channel_1 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data (adc_data_b_s),
    .adc_or (adc_or_b_s),
    .adc_dcfilter_data_out (adc_dcfilter_data_b_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_a_s),
    .adc_iqcor_data (adc_channel_data_b_s),
    .adc_enable (adc_enable_b_s),
    .up_adc_pn_err (up_adc_pn_err_b_s),
    .up_adc_pn_oos (up_adc_pn_oos_b_s),
    .up_adc_or (up_adc_or_b_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_adc_channel_rdata_b_s),
    .up_ack (up_adc_channel_ack_b_s));

  // main (device interface)

  axi_ad9643_if #(
    .PCORE_DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .PCORE_IODELAY_GROUP (PCORE_IODELAY_GROUP))
  i_if (
    .adc_clk_in_p (adc_clk_in_p),
    .adc_clk_in_n (adc_clk_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_data_in_n (adc_data_in_n),
    .adc_or_in_p (adc_or_in_p),
    .adc_or_in_n (adc_or_in_n),
    .adc_clk (adc_clk),
    .adc_data_a (adc_data_a_s),
    .adc_data_b (adc_data_b_s),
    .adc_or_a (adc_or_a_s),
    .adc_or_b (adc_or_b_s),
    .adc_status (adc_status_s),
    .adc_ddr_edgesel (adc_ddr_edgesel_s),
    .adc_pin_mode (adc_pin_mode_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst_s),
    .delay_sel (delay_sel_s),
    .delay_rwn (delay_rwn_s),
    .delay_addr (delay_addr_s),
    .delay_wdata (delay_wdata_s),
    .delay_rdata (delay_rdata_s),
    .delay_ack_t (delay_ack_t_s),
    .delay_locked (delay_locked_s));

  // common processor control

  up_adc_common #(.PCORE_ID(PCORE_ID)) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (adc_ddr_edgesel_s),
    .adc_pin_mode (adc_pin_mode_s),
    .adc_status (adc_status_s),
    .adc_status_pn_err (up_adc_status_pn_err),
    .adc_status_pn_oos (up_adc_status_pn_oos),
    .adc_status_or (up_adc_status_or),
    .adc_status_ovf (adc_dovf),
    .adc_status_unf (adc_dunf),
    .adc_clk_ratio (32'd1),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst_s),
    .delay_sel (delay_sel_s),
    .delay_rwn (delay_rwn_s),
    .delay_addr (delay_addr_s),
    .delay_wdata (delay_wdata_s),
    .delay_rdata (delay_rdata_s),
    .delay_ack_t (delay_ack_t_s),
    .delay_locked (delay_locked_s),
    .drp_clk (1'd0),
    .drp_rst (),
    .drp_sel (),
    .drp_wr (),
    .drp_addr (),
    .drp_wdata (),
    .drp_rdata (16'd0),
    .drp_ready (1'd0),
    .drp_locked (1'd1),
    .up_usr_chanmax (),
    .adc_usr_chanmax (8'd0),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_adc_common_rdata_s),
    .up_ack (up_adc_common_ack_s));

  // up bus interface

  up_axi #(
    .PCORE_BASEADDR (C_BASEADDR),
    .PCORE_HIGHADDR (C_HIGHADDR))
  i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata),
    .up_ack (up_ack));

endmodule

// ***************************************************************************
// ***************************************************************************

