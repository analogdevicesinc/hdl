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

module axi_time_regmap #(
  parameter  ID = 0,
  parameter  COUNT_WIDTH = 64,
  parameter  SYNC_EXTERNAL = 0,
  parameter  SYNC_EXTERNAL_CDC = 0
) (

  // time clock
  input  logic                         time_clk,
  input  logic                         time_resetn,

  // time interface control
  output logic                         time_enable,
  output logic                         time_sync_ext,
  output logic                         time_sync_soft,
  input  logic                         time_running_rx,
  input  logic                         time_underrun_rx,
  input  logic                         time_running_tx,
  input  logic                         time_underrun_tx,

  // counter values
  output logic [COUNT_WIDTH-1:0]       time_overwrite,
  input  logic [COUNT_WIDTH-1:0]       time_rx_capture,
  output logic [COUNT_WIDTH-1:0]       time_rx_trigger,
  input  logic [COUNT_WIDTH-1:0]       time_tx_capture,
  output logic [COUNT_WIDTH-1:0]       time_tx_trigger,

  // counter values control
  input  logic                         time_overwrite_ready,
  output logic                         time_overwrite_valid,
  input  logic                         time_rx_capture_valid,
  input  logic                         time_rx_trigger_ready,
  output logic                         time_rx_trigger_valid,
  input  logic                         time_tx_capture_valid,
  input  logic                         time_tx_trigger_ready,
  output logic                         time_tx_trigger_valid,

  // bus interface
  input  logic                         up_rstn,
  input  logic                         up_clk,
  input  logic                         up_wreq,
  input  logic [ 7:0]                  up_waddr,
  input  logic [31:0]                  up_wdata,
  output logic                         up_wack,
  input  logic                         up_rreq,
  input  logic [ 7:0]                  up_raddr,
  output logic [31:0]                  up_rdata,
  output logic                         up_rack
);

  // package import
  import axi_time_pkg::*;

  // internal registers
  logic [31:0]                  up_scratch;
  logic                         up_time_enable;
  logic                         up_time_sync_ext;
  logic                         up_time_sync_soft;
  logic [31:0]                  up_cnt_ovwr_low;
  logic [31:0]                  up_rx_capt_low;
  logic [31:0]                  up_rx_trig_low;
  logic [31:0]                  up_tx_capt_low;
  logic [31:0]                  up_tx_trig_low;

  // internal wires
  logic [31:0]                  status_synth_params_s;
  logic                         time_rx_capture_ready;
  logic                         time_tx_capture_ready;
  logic [63:0]                  up_cnt_ovwr;
  logic [63:0]                  up_rx_capt;
  logic [63:0]                  up_rx_trig;
  logic [63:0]                  up_tx_capt;
  logic [63:0]                  up_tx_trig;
  logic [31:0]                  up_cnt_ovwr_high_s;
  logic [31:0]                  up_rx_capt_high_s;
  logic [31:0]                  up_rx_trig_high_s;
  logic [31:0]                  up_tx_capt_high_s;
  logic [31:0]                  up_tx_trig_high_s;
  logic                         up_cnt_ovwr_valid;
  logic                         up_cnt_ovwr_ready;
  logic                         up_rx_capt_valid;
  logic                         up_rx_capt_ready;
  logic                         up_rx_trig_valid;
  logic                         up_rx_trig_ready;
  logic                         up_tx_capt_valid;
  logic                         up_tx_capt_ready;
  logic                         up_tx_trig_valid;
  logic                         up_tx_trig_ready;
  logic                         up_rx_time_running;
  logic                         up_rx_time_underrun;
  logic                         up_tx_time_running;
  logic                         up_tx_time_underrun;
  logic                         up_rx_time_underrun_s;
  logic                         up_rx_time_underrun_clear;
  logic                         up_tx_time_underrun_s;
  logic                         up_tx_time_underrun_clear;

  // initial values
  initial begin
    up_rdata = 32'b0;
    up_wack = 1'b0;
    up_rack = 1'b0;
    up_scratch = 32'b0;
    up_time_enable = 1'b0;
    up_time_sync_ext = 1'b0;
    up_time_sync_soft = 1'b0;
    up_rx_time_underrun = 1'b0;
    up_tx_time_underrun = 1'b0;
    up_cnt_ovwr_low = 32'b0;
    up_rx_trig_low = 32'b0;
    up_tx_trig_low = 32'b0;
  end

  //read-only synthesis parameters
  assign status_synth_params_s = {
                 /*31: 8 */  24'b0,
                 /* 7: 0 */  1'(SYNC_EXTERNAL_CDC),
                             1'(SYNC_EXTERNAL),
                             5'(COUNT_WIDTH-1)};

  // processor write interface
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 1'b0;
      up_scratch <= 32'b0;
      up_time_enable <= 1'b0;
      up_time_sync_ext <= 1'b0;
      up_time_sync_soft <= 1'b0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_SCRATCH)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_CONTROL)) begin
        up_time_sync_soft <= up_wdata[2];
        up_time_sync_ext <= up_wdata[1] & SYNC_EXTERNAL;
        up_time_enable   <= up_wdata[0];
      end else begin
        up_time_sync_soft <= 1'b0;
        up_time_sync_ext <= up_time_sync_ext;
        up_time_enable   <= up_time_enable;
      end
    end
  end

  assign up_rx_time_underrun_clear = ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_STATUS)) ? up_wdata[1] : 1'b0;
  assign up_tx_time_underrun_clear = ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_STATUS)) ? up_wdata[3] : 1'b0;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rx_time_underrun <= 1'b0;
      up_tx_time_underrun <= 1'b0;
    end else begin
      up_rx_time_underrun <= up_rx_time_underrun_s | (up_rx_time_underrun & ~up_rx_time_underrun_clear);
      up_tx_time_underrun <= up_tx_time_underrun_s | (up_tx_time_underrun & ~up_tx_time_underrun_clear);
    end
  end

  // counter values generation (low and high)
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_cnt_ovwr_low <= 32'b0;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_CNT_OVWR_LOW)) begin
        up_cnt_ovwr_low <= up_wdata;
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rx_trig_low <= 32'b0;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_RX_TRIG_LOW)) begin
        up_rx_trig_low <= up_wdata;
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_tx_trig_low <= 32'b0;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_TX_TRIG_LOW)) begin
        up_tx_trig_low <= up_wdata;
      end
    end
  end

  assign up_rx_capt_low = up_rx_capt[31:0];
  assign up_tx_capt_low = up_tx_capt[31:0];

  generate
    if (COUNT_WIDTH>32) begin

      logic [(COUNT_WIDTH-32-1):0] up_cnt_ovwr_high = 'h0;
      logic [(COUNT_WIDTH-32-1):0] up_rx_trig_high = 'h0;
      logic [(COUNT_WIDTH-32-1):0] up_tx_trig_high = 'h0;

      always @(posedge up_clk) begin
        if (up_rstn == 0) begin
          up_cnt_ovwr_high <= '0;
        end else begin
          if ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_CNT_OVWR_HIGH)) begin
            up_cnt_ovwr_high <= up_wdata[(COUNT_WIDTH-32-1):0];
          end
        end
      end

      always @(posedge up_clk) begin
        if (up_rstn == 0) begin
          up_rx_trig_high <= '0;
        end else begin
          if ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_RX_TRIG_HIGH)) begin
            up_rx_trig_high <= up_wdata[(COUNT_WIDTH-32-1):0];
          end
        end
      end

      always @(posedge up_clk) begin
        if (up_rstn == 0) begin
          up_tx_trig_high <= '0;
        end else begin
          if ((up_wreq == 1'b1) && (up_waddr == ADDR_TIME_TX_TRIG_HIGH)) begin
            up_tx_trig_high <= up_wdata[(COUNT_WIDTH-32-1):0];
          end
        end
      end

      assign up_cnt_ovwr_high_s = {{(64-COUNT_WIDTH){1'b0}}, up_cnt_ovwr_high};
      assign up_rx_trig_high_s = {{(64-COUNT_WIDTH){1'b0}}, up_rx_trig_high};
      assign up_rx_capt_high_s = {{(64-COUNT_WIDTH){1'b0}}, up_rx_capt[COUNT_WIDTH-1:32]};
      assign up_tx_trig_high_s = {{(64-COUNT_WIDTH){1'b0}}, up_tx_trig_high};
      assign up_tx_capt_high_s = {{(64-COUNT_WIDTH){1'b0}}, up_tx_capt[COUNT_WIDTH-1:32]};

    end else begin

      assign up_cnt_ovwr_high_s = 32'b0;
      assign up_rx_trig_high_s = 32'b0;
      assign up_rx_capt_high_s = 32'b0;
      assign up_tx_trig_high_s = 32'b0;
      assign up_tx_capt_high_s = 32'b0;

    end
  endgenerate

  assign up_cnt_ovwr = {up_cnt_ovwr_high_s, up_wdata};
  assign up_rx_trig = {up_rx_trig_high_s, up_wdata};
  assign up_tx_trig = {up_tx_trig_high_s, up_wdata};

  assign up_cnt_ovwr_valid = up_wreq & (up_waddr == ADDR_TIME_CNT_OVWR_LOW);
  assign up_rx_capt_ready = up_rreq & (up_raddr == ADDR_TIME_RX_CAPT_LOW);
  assign up_rx_trig_valid = up_wreq & (up_waddr == ADDR_TIME_RX_TRIG_LOW);
  assign up_tx_capt_ready = up_rreq & (up_raddr == ADDR_TIME_TX_CAPT_LOW);
  assign up_tx_trig_valid = up_wreq & (up_waddr == ADDR_TIME_TX_TRIG_LOW);

  // processor read interface
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 1'b0;
      up_rdata <= 32'b0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          ADDR_TIME_VERSION        : up_rdata <= PCORE_VERSION;
          ADDR_TIME_ID             : up_rdata <= ID[31:0];
          ADDR_TIME_SCRATCH        : up_rdata <= up_scratch;
          ADDR_TIME_IDENTIFICATION : up_rdata <= PCORE_MAGIC;
          ADDR_TIME_INTERFACE      : up_rdata <= status_synth_params_s;
          ADDR_TIME_CONTROL        : up_rdata <= {29'b0, up_time_sync_soft,
                                                         up_time_sync_ext,
                                                         up_time_enable};
          ADDR_TIME_STATUS         : up_rdata <= {28'b0, up_tx_time_underrun,
                                                         up_tx_time_running,
                                                         up_rx_time_underrun,
                                                         up_rx_time_running};
          ADDR_TIME_CNT_OVWR_LOW   : up_rdata <= up_cnt_ovwr_low;
          ADDR_TIME_CNT_OVWR_HIGH  : up_rdata <= up_cnt_ovwr_high_s;
          ADDR_TIME_RX_CAPT_LOW    : up_rdata <= up_rx_capt_low;
          ADDR_TIME_RX_CAPT_HIGH   : up_rdata <= up_rx_capt_high_s;
          ADDR_TIME_RX_TRIG_LOW    : up_rdata <= up_rx_trig_low;
          ADDR_TIME_RX_TRIG_HIGH   : up_rdata <= up_rx_trig_high_s;
          ADDR_TIME_TX_CAPT_LOW    : up_rdata <= up_tx_capt_low;
          ADDR_TIME_TX_CAPT_HIGH   : up_rdata <= up_tx_capt_high_s;
          ADDR_TIME_TX_TRIG_LOW    : up_rdata <= up_tx_trig_low;
          ADDR_TIME_TX_TRIG_HIGH   : up_rdata <= up_tx_trig_high_s;
          default: up_rdata <= 32'b0;
        endcase
      end else begin
        up_rdata <= 32'b0;
      end
    end
  end

  // control signals CDC
  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_time_control_sync (
    .in_bits ({up_time_sync_ext,
               up_time_enable}),
    .out_resetn (time_resetn),
    .out_clk (time_clk),
    .out_bits ({time_sync_ext,
                time_enable}));

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_up_running_sync (
    .in_bits ({time_running_tx,
               time_running_rx}),
    .out_resetn (up_rstn),
    .out_clk (up_clk),
    .out_bits ({up_tx_time_running,
                up_rx_time_running}));

  sync_event #(
    .NUM_OF_EVENTS (1),
    .ASYNC_CLK (1)
  ) i_time_soft_sync (
    .in_clk (up_clk),
    .in_event (up_time_sync_soft),
    .out_clk (time_clk),
    .out_event (time_sync_soft));

  sync_event #(
    .NUM_OF_EVENTS (2),
    .ASYNC_CLK (1)
  ) i_up_underrun_sync (
    .in_clk (time_clk),
    .in_event ({time_underrun_tx,
               time_underrun_rx}),
    .out_clk (up_clk),
    .out_event ({up_tx_time_underrun_s,
                 up_rx_time_underrun_s}));

  util_axis_fifo #(
    .DATA_WIDTH(COUNT_WIDTH),
    .ADDRESS_WIDTH(0),
    .ASYNC_CLK(1)
  ) i_write_cnt_ovwr_fifo (
    .s_axis_aclk(up_clk),
    .s_axis_aresetn(up_rstn),
    .s_axis_valid(up_cnt_ovwr_valid & up_cnt_ovwr_ready),
    .s_axis_ready(up_cnt_ovwr_ready),
    .s_axis_full(),
    .s_axis_data(up_cnt_ovwr[COUNT_WIDTH-1:0]),
    .s_axis_room(),

    .m_axis_aclk(time_clk),
    .m_axis_aresetn(time_resetn),
    .m_axis_valid(time_overwrite_valid),
    .m_axis_ready(time_overwrite_ready),
    .m_axis_data(time_overwrite),
    .m_axis_level(),
    .m_axis_empty ());

  util_axis_fifo #(
    .DATA_WIDTH(COUNT_WIDTH),
    .ADDRESS_WIDTH(0),
    .ASYNC_CLK(1)
  ) i_write_rx_trig_fifo (
    .s_axis_aclk(up_clk),
    .s_axis_aresetn(up_rstn),
    .s_axis_valid(up_rx_trig_valid & up_rx_trig_ready),
    .s_axis_ready(up_rx_trig_ready),
    .s_axis_full(),
    .s_axis_data(up_rx_trig[COUNT_WIDTH-1:0]),
    .s_axis_room(),

    .m_axis_aclk(time_clk),
    .m_axis_aresetn(time_resetn),
    .m_axis_valid(time_rx_trigger_valid),
    .m_axis_ready(time_rx_trigger_ready),
    .m_axis_data(time_rx_trigger),
    .m_axis_level(),
    .m_axis_empty ());

  util_axis_fifo #(
    .DATA_WIDTH(COUNT_WIDTH),
    .ADDRESS_WIDTH(0),
    .ASYNC_CLK(1)
  ) i_write_tx_trig_fifo (
    .s_axis_aclk(up_clk),
    .s_axis_aresetn(up_rstn),
    .s_axis_valid(up_tx_trig_valid & up_tx_trig_ready),
    .s_axis_ready(up_tx_trig_ready),
    .s_axis_full(),
    .s_axis_data(up_tx_trig[COUNT_WIDTH-1:0]),
    .s_axis_room(),

    .m_axis_aclk(time_clk),
    .m_axis_aresetn(time_resetn),
    .m_axis_valid(time_tx_trigger_valid),
    .m_axis_ready(time_tx_trigger_ready),
    .m_axis_data(time_tx_trigger),
    .m_axis_level(),
    .m_axis_empty ());

  util_axis_fifo #(
    .DATA_WIDTH(COUNT_WIDTH),
    .ADDRESS_WIDTH(1),
    .ASYNC_CLK(1)
  ) i_read_rx_capt_fifo (
    .s_axis_aclk(time_clk),
    .s_axis_aresetn(time_resetn),
    .s_axis_valid(time_rx_capture_valid & time_rx_capture_ready),
    .s_axis_ready(time_rx_capture_ready),
    .s_axis_full(),
    .s_axis_data(time_rx_capture),
    .s_axis_room(),

    .m_axis_aclk(up_clk),
    .m_axis_aresetn(up_rstn),
    .m_axis_valid(up_rx_capt_valid),
    .m_axis_ready(up_rx_capt_ready),
    .m_axis_data(up_rx_capt[COUNT_WIDTH-1:0]),
    .m_axis_level(),
    .m_axis_empty ());

  util_axis_fifo #(
    .DATA_WIDTH(COUNT_WIDTH),
    .ADDRESS_WIDTH(1),
    .ASYNC_CLK(1)
  ) i_read_tx_capt_fifo (
    .s_axis_aclk(time_clk),
    .s_axis_aresetn(time_resetn),
    .s_axis_valid(time_tx_capture_valid & time_tx_capture_ready),
    .s_axis_ready(time_tx_capture_ready),
    .s_axis_full(),
    .s_axis_data(time_tx_capture),
    .s_axis_room(),

    .m_axis_aclk(up_clk),
    .m_axis_aresetn(up_rstn),
    .m_axis_valid(up_tx_capt_valid),
    .m_axis_ready(up_tx_capt_ready),
    .m_axis_data(up_tx_capt[COUNT_WIDTH-1:0]),
    .m_axis_level(),
    .m_axis_empty ());

endmodule
