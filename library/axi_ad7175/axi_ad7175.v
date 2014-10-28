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

module axi_ad7175 (

  // adc interface (clk, data, over-range)
  
  adc_sdo_i,
  adc_sdi_o,
  adc_cs_o,
  adc_sclk_o,
  adc_clk_i,
  led_clk_o,

  // dma interface

  adc_clk,
  adc_valid_0,
  adc_enable_0,
  adc_data_0,
  adc_valid_1,
  adc_enable_1,
  adc_data_1,
  adc_valid_2,
  adc_enable_2,
  adc_data_2,
  adc_valid_3,
  adc_enable_3,
  adc_data_3,
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
  s_axi_rready);

  // parameters

  parameter PCORE_ID = 0;
  parameter PCORE_DEVICE_TYPE = 0;
  parameter PCORE_ADC_DP_DISABLE = 0;
  parameter PCORE_IODELAY_GROUP = "adc_if_delay_group";
  parameter C_S_AXI_MIN_SIZE = 32'hffff;

  // adc interface (clk, data, over-range)

  input 			adc_sdo_i;
  output 			adc_sdi_o;
  output 			adc_cs_o;
  output 			adc_sclk_o;
  input				adc_clk_i;
  output			led_clk_o;

  // dma interface

  output          adc_clk;
  output          adc_valid_0;
  output          adc_enable_0;
  output  [31:0]  adc_data_0;
  output          adc_valid_1;
  output          adc_enable_1;
  output  [31:0]  adc_data_1;
  output          adc_valid_2;
  output          adc_enable_2;
  output  [31:0]  adc_data_2;
  output          adc_valid_3;
  output          adc_enable_3;
  output  [31:0]  adc_data_3;  
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

  // internal registers

  reg     [31:0]  up_rdata = 'd0;
  reg             up_rack = 'd0;
  reg             up_wack = 'd0;

  // internal clocks & resets

  wire            adc_rst;
  wire            up_rstn;
  wire            up_clk;
  wire    [13:0]  up_waddr_s;
  wire    [13:0]  up_raddr_s;

  // internal signals

  wire            adc_status_s;
  wire            up_sel_s;
  wire            up_wr_s;
  wire    [13:0]  up_addr_s;
  wire    [31:0]  up_wdata_s;
  wire    [31:0]  up_rdata_s[0:4];
  wire            up_rack_s[0:4];
  wire            up_wack_s[0:4];
  
  wire    [31:0]   adc_data_s;
  wire 	  [ 1:0]   adc_reg_rw_s;
  wire    [31:0]   adc_reg_address_s;
  wire    [31:0]   adc_reg_data_w_s;
  wire    [31:0]   adc_rx_data_s;
  wire             adc_rx_data_rdy_s;
  wire			   adc_tx_data_rdy_s;
  wire    [31:0]   adc_gpio_out;
  
  wire             clk_div_update_rdy_s;
  wire    [23:0]   phase_data_s;

  // signal name changes
  assign adc_clk = s_axi_aclk;
  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin      
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] | up_rdata_s[3] | up_rdata_s[4];
      up_rack <= up_rack_s[0] | up_rack_s[1] | up_rack_s[2] | up_rack_s[3] | up_rack_s[4];
      up_wack <= up_wack_s[0] | up_wack_s[1] | up_wack_s[2] | up_wack_s[3] | up_wack_s[4];
    end
  end

  // channel

  axi_ad7175_channel #(
    .CHID(0),
    .DP_DISABLE (PCORE_ADC_DP_DISABLE))
  i_channel_0 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data ({8'b0, adc_data_s[23:0]}),
	.adc_valid_in(data_rd_ready_s && (adc_data_s[25:24] == 2'b0)),
    .adc_data_out (adc_data_0),
	.adc_valid (adc_valid_0),
    .adc_enable (adc_enable_0),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));
	
// channel

  axi_ad7175_channel #(
    .CHID(1),
    .DP_DISABLE (PCORE_ADC_DP_DISABLE))
  i_channel_1 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data ({8'b0, phase_data_s}),
	.adc_valid_in(data_rd_ready_s && (adc_data_s[25:24] == 2'b0)),
    .adc_data_out (adc_data_1),
	.adc_valid (adc_valid_1),
    .adc_enable (adc_enable_1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));	

  // channel

  axi_ad7175_channel #(
    .CHID(3),
    .DP_DISABLE (PCORE_ADC_DP_DISABLE))
  i_channel_2 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data ({8'b0, adc_data_s[23:0]}),
	.adc_valid_in(data_rd_ready_s && (adc_data_s[25:24] == 2'b1)),
    .adc_data_out (adc_data_2),
	.adc_valid (adc_valid_2),
    .adc_enable (adc_enable_2),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

  axi_ad7175_channel #(
    .CHID(4),
    .DP_DISABLE (PCORE_ADC_DP_DISABLE))
  i_channel_3 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data ({8'b0, phase_data_s}),
	.adc_valid_in(data_rd_ready_s && (adc_data_s[25:24] == 2'b1)),
    .adc_data_out (adc_data_3),
	.adc_valid (adc_valid_3),
    .adc_enable (adc_enable_3),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[3]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[3]),
    .up_rack (up_rack_s[3]));

  // clock divider
    clk_div clk_div_i (
    .clk_i(s_axi_aclk),
	.reset_n_i(up_rstn),
	.new_div_i(adc_reg_rw_s[1] && (adc_reg_address_s[7:0] == 8'h40)),
	.div_i(adc_reg_data_w_s[31:0]),
	.new_phase_inc_i(adc_reg_rw_s[1] && (adc_reg_address_s[7:0] == 8'h41)),
	.phase_inc_i(adc_reg_data_w_s[31:0]),
	.reg_update_rdy_o(clk_div_update_rdy_s),
	.clk_o(led_clk_o),
	.phase_o(phase_data_s));	
	
  // main (device interface)

  ad7175_if ad7175_if_i(
	.fpga_clk_i(s_axi_aclk),
    .adc_clk_i(adc_clk_i),
    .reset_n_i(~adc_rst),
	
	.start_conversion_i(adc_gpio_out[0]),
    .dma_data_o(adc_data_s),
    .dma_data_rdy_o(data_rd_ready_s),
	
	.start_transmission_i(adc_reg_rw_s[1] && (adc_reg_address_s[7:0] < 8'h39)),
	.tx_data_i({adc_reg_address_s[7:0], adc_reg_data_w_s[23:0]}),
	.tx_data_rdy_o(adc_tx_data_rdy_s),
	
	.start_read_i(adc_reg_rw_s[0] && (adc_reg_address_s[7:0] < 8'h39)),       
	.rx_data_o(adc_rx_data_s),
	.rx_data_rdy_o(adc_rx_data_rdy_s),
    
	.adc_sdo_i(adc_sdo_i),
    .adc_sdi_o(adc_sdi_o),
    .adc_cs_o(adc_cs_o),
    .adc_sclk_o(adc_sclk_o),
    .adc_status_o(adc_status_s));
	
  // common processor control

  up_adc_common #(.PCORE_ID(PCORE_ID)) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status_s),
    .adc_status_ovf (adc_dovf),
    .adc_status_unf (adc_dunf),
    .adc_clk_ratio (32'd1),

	.adc_reg_address(adc_reg_address_s),
    .adc_reg_data_r(adc_rx_data_s),
    .adc_reg_data_w(adc_reg_data_w_s),
    .adc_reg_rw(adc_reg_rw_s),
    .adc_reg_done(adc_tx_data_rdy_s | adc_rx_data_rdy_s | clk_div_update_rdy_s),  

    .up_status_pn_err (1'b0),
    .up_status_pn_oos (1'b0),
    .up_status_or (1'b0),
    .delay_clk (),
    .delay_rst (),
    .delay_sel (),
    .delay_rwn (),
    .delay_addr (),
    .delay_wdata (),
    .delay_rdata (),
    .delay_ack_t (),
    .delay_locked (),
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
    .up_adc_gpio_in (),
    .up_adc_gpio_out (adc_gpio_out),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[4]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[4]),
    .up_rack (up_rack_s[4]));

  // up bus interface

  up_axi i_up_axi (
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
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************

