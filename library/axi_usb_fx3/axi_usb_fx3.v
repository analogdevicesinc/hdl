// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_usb_fx3 (

  // gpif ii

  input                   dma_rdy,
  input                   dma_wmk,

  input       [ 3:0]      fifo_rdy,

  output                  pclk,

  inout       [31:0]      data,
  output      [ 1:0]      addr,

  output                  slcs_n,
  output                  slrd_n,
  output                  sloe_n,
  output                  slwr_n,
  output                  pktend_n,
  output                  epswitch_n,

  // irq

  output                  irq,

  // DEBUG

  output      [74:0]      debug_fx32dma,
  output      [73:0]      debug_dma2fx3,
  output      [14:0]      debug_status,

  // s2mm

  input       [31:0]      s_axis_tdata,
  input       [ 3:0]      s_axis_tkeep,
  input                   s_axis_tlast,
  input                   s_axis_tvalid,
  output                  s_axis_tready,

  // mm2s

  input                   m_axis_tready,
  output      [31:0]      m_axis_tdata,
  output      [ 3:0]      m_axis_tkeep,
  output                  m_axis_tlast,
  output                  m_axis_tvalid,

  // axi lite

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready);

  // internal clocks & resets

  wire            up_rstn;
  wire            up_clk;

  // internal signals

  wire    [13:0]  up_raddr;
  wire    [31:0]  up_rdata;
  wire            up_rack;
  wire            up_wack;
  wire            up_wreq;
  wire    [13:0]  up_waddr;
  wire    [31:0]  up_wdata;
  wire            up_rreq_s;

  wire    [ 7:0]  fifo0_header_size;
  wire    [15:0]  fifo0_buffer_size;
  wire    [ 7:0]  fifo1_header_size;
  wire    [15:0]  fifo1_buffer_size;
  wire    [ 7:0]  fifo2_header_size;
  wire    [15:0]  fifo2_buffer_size;
  wire    [ 7:0]  fifo3_header_size;
  wire    [15:0]  fifo3_buffer_size;
  wire    [ 7:0]  fifo4_header_size;
  wire    [15:0]  fifo4_buffer_size;
  wire    [ 7:0]  fifo5_header_size;
  wire    [15:0]  fifo5_buffer_size;
  wire    [ 7:0]  fifo6_header_size;
  wire    [15:0]  fifo6_buffer_size;
  wire    [ 7:0]  fifo7_header_size;
  wire    [15:0]  fifo7_buffer_size;
  wire    [ 7:0]  fifo8_header_size;
  wire    [15:0]  fifo8_buffer_size;
  wire    [ 7:0]  fifo9_header_size;
  wire    [15:0]  fifo9_buffer_size;
  wire    [ 7:0]  fifoa_header_size;
  wire    [15:0]  fifoa_buffer_size;
  wire            fifo0_direction;
  wire            fifo1_direction;
  wire            fifo2_direction;
  wire            fifo3_direction;
  wire            fifo4_direction;
  wire            fifo5_direction;
  wire            fifo6_direction;
  wire            fifo7_direction;
  wire            fifo8_direction;
  wire            fifo9_direction;
  wire            fifoa_direction;
  wire    [10:0]  fifo_direction;

  wire            fx32dma_valid;
  wire            fx32dma_ready;
  wire    [31:0]  fx32dma_data;
  wire            fx32dma_sop;
  wire            fx32dma_eop;

  wire            dma2fx3_ready;
  wire            dma2fx3_valid;
  wire    [31:0]  dma2fx3_data;
  wire            dma2fx3_eop;

  wire    [ 2:0]  test_mode_tpm;
  wire    [ 2:0]  test_mode_tpg;
  wire            monitor_error;
  wire            eot_fx32dma;
  wire            eot_dma2fx3;

  wire            error;
  wire    [ 4:0]  fifo_num;
  wire    [10:0]  fifo_ready;

  wire    [31:0]  length_fx32dma;
  wire    [31:0]  length_dma2fx3;

  wire            trig;
  wire            zlp;

  // signal name changes

  assign up_clk   = s_axi_aclk;
  assign pclk     = s_axi_aclk;
  assign up_rstn  = s_axi_aresetn;

  assign fifo_direction = {fifo9_direction, fifo8_direction, fifo7_direction, fifo6_direction, fifo5_direction, fifo4_direction, fifo3_direction, fifo2_direction, fifo1_direction, fifo0_direction};

  // DEBUG

  assign debug_dma2fx3  = {s_axis_tdata, dma2fx3_data, s_axis_tkeep, s_axis_tlast, s_axis_tvalid, s_axis_tready, dma2fx3_ready, dma2fx3_valid, dma2fx3_eop};
  assign debug_fx32dma  = {fx32dma_eop, m_axis_tdata, fx32dma_data, m_axis_tkeep, m_axis_tlast, m_axis_tvalid, m_axis_tready, fx32dma_ready, fx32dma_valid, fx32dma_sop};
  assign debug_status   = {irq, error, monitor_error, test_mode_tpg, test_mode_tpm, trig, fifo_num};

  // packetizer, TPM/TPG and DMA interface

  axi_usb_fx3_core ep_packetizer(
    .clk(pclk),
    .reset(!up_rstn),

    .s_axis_tdata(s_axis_tdata),
    .s_axis_tkeep(s_axis_tkeep),
    .s_axis_tlast(s_axis_tlast),
    .s_axis_tready(s_axis_tready),
    .s_axis_tvalid(s_axis_tvalid),

    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tready(m_axis_tready),
    .m_axis_tvalid(m_axis_tvalid),

    .fifo0_header_size(fifo0_header_size),
    .fifo0_buffer_size(fifo0_buffer_size),
    .fifo1_header_size(fifo1_header_size),
    .fifo1_buffer_size(fifo1_buffer_size),
    .fifo2_header_size(fifo2_header_size),
    .fifo2_buffer_size(fifo2_buffer_size),
    .fifo3_header_size(fifo3_header_size),
    .fifo3_buffer_size(fifo3_buffer_size),
    .fifo4_header_size(fifo4_header_size),
    .fifo4_buffer_size(fifo4_buffer_size),
    .fifo5_header_size(fifo5_header_size),
    .fifo5_buffer_size(fifo5_buffer_size),
    .fifo6_header_size(fifo6_header_size),
    .fifo6_buffer_size(fifo6_buffer_size),
    .fifo7_header_size(fifo7_header_size),
    .fifo7_buffer_size(fifo7_buffer_size),
    .fifo8_header_size(fifo8_header_size),
    .fifo8_buffer_size(fifo8_buffer_size),
    .fifo9_header_size(fifo9_header_size),
    .fifo9_buffer_size(fifo9_buffer_size),
    .fifoa_header_size(fifoa_header_size),
    .fifoa_buffer_size(fifoa_buffer_size),

    .fifob_header_size(0),
    .fifob_buffer_size(0),
    .fifoc_header_size(0),
    .fifoc_buffer_size(0),
    .fifod_header_size(0),
    .fifod_buffer_size(0),
    .fifoe_header_size(0),
    .fifoe_buffer_size(0),
    .fifof_header_size(0),
    .fifof_buffer_size(0),

    .length_fx32dma(length_fx32dma),
    .length_dma2fx3(length_dma2fx3),

    .fx32dma_valid(fx32dma_valid),
    .fx32dma_ready(fx32dma_ready),
    .fx32dma_data(fx32dma_data),
    .fx32dma_sop(fx32dma_sop),
    .fx32dma_eop(fx32dma_eop),

    .dma2fx3_ready(dma2fx3_ready),
    .dma2fx3_valid(dma2fx3_valid),
    .dma2fx3_data(dma2fx3_data),
    .dma2fx3_eop(dma2fx3_eop),

    .error(error),
    .eot_fx32dma(eot_fx32dma),
    .eot_dma2fx3(eot_dma2fx3),

    .test_mode_tpm(test_mode_tpm),
    .test_mode_tpg(test_mode_tpg),
    .monitor_error(monitor_error),

    .zlp(zlp),

    .fifo_num(fifo_num));

  // register map

  axi_usb_fx3_reg fx3_registers(

    .fifo_rdy(fifo_ready),

    .eot_fx32dma(eot_fx32dma),
    .eot_dma2fx3(eot_dma2fx3),
    .trig(trig),
    .zlp(zlp),
    .fifo_num(fifo_num),

    .error(error),

    .test_mode_tpm(test_mode_tpm),
    .test_mode_tpg(test_mode_tpg),
    .monitor_error(monitor_error),

    .irq(irq),

    .fifo0_direction(fifo0_direction),
    .fifo0_header_size(fifo0_header_size),
    .fifo0_buffer_size(fifo0_buffer_size),

    .fifo1_direction(fifo1_direction),
    .fifo1_header_size(fifo1_header_size),
    .fifo1_buffer_size(fifo1_buffer_size),

    .fifo2_direction(fifo2_direction),
    .fifo2_header_size(fifo2_header_size),
    .fifo2_buffer_size(fifo2_buffer_size),

    .fifo3_direction(fifo3_direction),
    .fifo3_header_size(fifo3_header_size),
    .fifo3_buffer_size(fifo3_buffer_size),

    .fifo4_direction(fifo4_direction),
    .fifo4_header_size(fifo4_header_size),
    .fifo4_buffer_size(fifo4_buffer_size),

    .fifo5_direction(fifo5_direction),
    .fifo5_header_size(fifo5_header_size),
    .fifo5_buffer_size(fifo5_buffer_size),

    .fifo6_direction(fifo6_direction),
    .fifo6_header_size(fifo6_header_size),
    .fifo6_buffer_size(fifo6_buffer_size),

    .fifo7_direction(fifo7_direction),
    .fifo7_header_size(fifo7_header_size),
    .fifo7_buffer_size(fifo7_buffer_size),

    .fifo8_direction(fifo8_direction),
    .fifo8_header_size(fifo8_header_size),
    .fifo8_buffer_size(fifo8_buffer_size),

    .fifo9_direction(fifo9_direction),
    .fifo9_header_size(fifo9_header_size),
    .fifo9_buffer_size(fifo9_buffer_size),

    .fifoa_direction(fifoa_direction),
    .fifoa_header_size(fifoa_header_size),
    .fifoa_buffer_size(fifoa_buffer_size),

    .length_fx32dma(length_fx32dma),
    .length_dma2fx3(length_dma2fx3),

    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack));

  // GPIF II interface

  axi_usb_fx3_if fx3_if(

    .pclk(pclk),              //output clk 100 Mhz and 180 phase shift
    .reset_n(up_rstn),

    .dma_rdy(dma_rdy),
    .dma_wmk(dma_wmk),
    .fifo_rdy(fifo_rdy),
    .data(data),
    .addr(addr),              //output fifo address
    .slcs_n(slcs_n),          //output chip select
    .slrd_n(slrd_n),          //output read select
    .sloe_n(sloe_n),          //output output enable select
    .slwr_n(slwr_n),          //output write select
    .pktend_n(pktend_n),      //output pkt end
    .epswitch_n(epswitch_n),  //output pkt end

    .fifo_ready(fifo_ready),

    .fifo_num(fifo_num),
    .fifo_direction(fifo_direction),
    .trig(trig),

    .fx32dma_valid(fx32dma_valid),
    .fx32dma_ready(fx32dma_ready),
    .fx32dma_data(fx32dma_data),
    .fx32dma_sop(fx32dma_sop),
    .fx32dma_eop(fx32dma_eop),
    .eot_fx32dma(eot_fx32dma),

    .dma2fx3_ready(dma2fx3_ready),
    .dma2fx3_valid(dma2fx3_valid),
    .dma2fx3_data(dma2fx3_data),
    .dma2fx3_eop(dma2fx3_eop));

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
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
