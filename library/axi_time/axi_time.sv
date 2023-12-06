// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

module axi_time #(

  // Peripheral ID
  parameter         ID = 0,

  // Master counter width. Keeps track of time.
  parameter         COUNT_WIDTH = 64,

  // Data path width.
  parameter         DATA_WIDTH = 64,

  // Enable external synchronization resetting.
  parameter         SYNC_EXTERNAL = 1,

  // Whether to insert a CDC stage for the external synchronization input.
  parameter         SYNC_EXTERNAL_CDC = 1
) (

  input  logic                     clk,
  input  logic                     resetn,

  // Sync signal
  input  logic                     sync_in,

  // Input FIFO interface
  input  logic                     fifo_wr_in_en,
  input  logic [DATA_WIDTH-1:0]    fifo_wr_in_data,
  output logic                     fifo_wr_in_overflow,
  input  logic                     fifo_wr_in_sync,
  output logic                     fifo_wr_in_xfer_req,

  // Output FIFO interface
  output logic                     fifo_wr_out_en,
  output logic [DATA_WIDTH-1:0]    fifo_wr_out_data,
  input  logic                     fifo_wr_out_overflow,
  output logic                     fifo_wr_out_sync,
  input  logic                     fifo_wr_out_xfer_req,

  // AXI BUS
  input  logic                     s_axi_aresetn,
  input  logic                     s_axi_aclk,
  input  logic                     s_axi_awvalid,
  input  logic [ 9:0]              s_axi_awaddr,
  input  logic [ 2:0]              s_axi_awprot,
  output logic                     s_axi_awready,
  input  logic                     s_axi_wvalid,
  input  logic [31:0]              s_axi_wdata,
  input  logic [ 3:0]              s_axi_wstrb,
  output logic                     s_axi_wready,
  output logic                     s_axi_bvalid,
  output logic [ 1:0]              s_axi_bresp,
  input  logic                     s_axi_bready,
  input  logic                     s_axi_arvalid,
  input  logic [ 9:0]              s_axi_araddr,
  input  logic [ 2:0]              s_axi_arprot,
  output logic                     s_axi_arready,
  output logic                     s_axi_rvalid,
  output logic [ 1:0]              s_axi_rresp,
  output logic [31:0]              s_axi_rdata,
  input  logic                     s_axi_rready
);

  // Package import
  import axi_time_pkg::*;

  // Internal up bus, translated by up_axi
  logic                         up_rstn;
  logic                         up_clk;
  logic                         up_wreq;
  logic [ 7:0]                  up_waddr;
  logic [31:0]                  up_wdata;
  logic                         up_wack;
  logic                         up_rreq;
  logic [ 7:0]                  up_raddr;
  logic [31:0]                  up_rdata;
  logic                         up_rack;

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // Control signals
  logic                         time_enable;
  logic                         time_running;
  logic                         time_sync_ext;
  logic                         time_sync_soft;
  logic                         time_underrun;

  // Current counter value
  logic  [COUNT_WIDTH-1:0]      time_counter;

  // Timestamp values
  logic  [COUNT_WIDTH-1:0]      time_overwrite;
  logic  [COUNT_WIDTH-1:0]      time_rx_capture;
  logic  [COUNT_WIDTH-1:0]      time_rx_trigger;

  // Control signals
  logic                         time_overwrite_ready;
  logic                         time_overwrite_valid;
  logic                         time_rx_capture_valid;
  logic                         time_rx_trigger_ready;
  logic                         time_rx_trigger_valid;

  axi_time_regmap #(
    .ID               (ID),
    .COUNT_WIDTH      (COUNT_WIDTH),
    .SYNC_EXTERNAL    (SYNC_EXTERNAL),
    .SYNC_EXTERNAL_CDC(SYNC_EXTERNAL_CDC)
  ) i_regmap (
    .up_rstn               (up_rstn),
    .up_clk                (up_clk),

    .up_wreq               (up_wreq),
    .up_waddr              (up_waddr),
    .up_wdata              (up_wdata),
    .up_wack               (up_wack),
    .up_rreq               (up_rreq),
    .up_raddr              (up_raddr),
    .up_rdata              (up_rdata),
    .up_rack               (up_rack),

    .time_clk              (clk),
    .time_resetn           (resetn),

    .time_enable           (time_enable),
    .time_sync_ext         (time_sync_ext),
    .time_sync_soft        (time_sync_soft),
    .time_running          (time_running),
    .time_underrun         (time_underrun),

    .time_overwrite        (time_overwrite),
    .time_rx_capture       (time_rx_capture),
    .time_rx_trigger       (time_rx_trigger),

    .time_overwrite_ready  (time_overwrite_ready),
    .time_overwrite_valid  (time_overwrite_valid),
    .time_rx_capture_valid (time_rx_capture_valid),
    .time_rx_trigger_ready (time_rx_trigger_ready),
    .time_rx_trigger_valid (time_rx_trigger_valid));

  axi_time_counter #(
    .COUNT_WIDTH      (COUNT_WIDTH),
    .SYNC_EXTERNAL    (SYNC_EXTERNAL),
    .SYNC_EXTERNAL_CDC(SYNC_EXTERNAL_CDC)
  ) i_counter (
    .clk                   (clk),
    .resetn                (resetn),

    .sync_in               (sync_in),

    .time_enable           (time_enable),
    .time_sync_ext         (time_sync_ext),
    .time_sync_soft        (time_sync_soft),

    .time_overwrite_ready  (time_overwrite_ready),
    .time_overwrite_valid  (time_overwrite_valid),

    .time_overwrite        (time_overwrite),
    .time_counter          (time_counter));

  axi_time_rx #(
    .COUNT_WIDTH(COUNT_WIDTH),
    .DATA_WIDTH (DATA_WIDTH)
  ) i_rx_time (
    .clk                   (clk),
    .resetn                (resetn),

    .time_enable           (time_enable),
    .time_running          (time_running),
    .time_underrun         (time_underrun),

    .time_counter          (time_counter),
    .time_capture          (time_rx_capture),
    .time_trigger          (time_rx_trigger),

    .time_capture_valid    (time_rx_capture_valid),
    .time_trigger_ready    (time_rx_trigger_ready),
    .time_trigger_valid    (time_rx_trigger_valid),

    .fifo_wr_in_en         (fifo_wr_in_en),
    .fifo_wr_in_data       (fifo_wr_in_data),
    .fifo_wr_in_overflow   (fifo_wr_in_overflow),
    .fifo_wr_in_sync       (fifo_wr_in_sync),
    .fifo_wr_in_xfer_req   (fifo_wr_in_xfer_req),

    .fifo_wr_out_en        (fifo_wr_out_en),
    .fifo_wr_out_data      (fifo_wr_out_data),
    .fifo_wr_out_overflow  (fifo_wr_out_overflow),
    .fifo_wr_out_sync      (fifo_wr_out_sync),
    .fifo_wr_out_xfer_req  (fifo_wr_out_xfer_req));

  up_axi #(
    .AXI_ADDRESS_WIDTH(10)
  ) i_up_axi (
    .up_rstn(s_axi_aresetn),
    .up_clk(s_axi_aclk),

    .up_axi_awvalid(s_axi_awvalid),
    .up_axi_awaddr(s_axi_awaddr),
    .up_axi_awready(s_axi_awready),
    .up_axi_wvalid(s_axi_wvalid),
    .up_axi_wdata(s_axi_wdata),
    .up_axi_wstrb(s_axi_wstrb),
    .up_axi_wready(s_axi_wready),
    .up_axi_bvalid(s_axi_bvalid),
    .up_axi_bresp(s_axi_bresp),
    .up_axi_bready(s_axi_bready),
    .up_axi_arvalid(s_axi_arvalid),
    .up_axi_araddr(s_axi_araddr),
    .up_axi_arready(s_axi_arready),
    .up_axi_rvalid(s_axi_rvalid),
    .up_axi_rresp(s_axi_rresp),
    .up_axi_rdata(s_axi_rdata),
    .up_axi_rready(s_axi_rready),

    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack));

endmodule
