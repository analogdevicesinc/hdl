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

module up_adc_common #(

  // parameters

  parameter         ID = 0,
  parameter [ 7:0]  FPGA_TECHNOLOGY = 0,
  parameter [ 7:0]  FPGA_FAMILY = 0,
  parameter [ 7:0]  SPEED_GRADE = 0,
  parameter [ 7:0]  DEV_PACKAGE = 0,
  parameter         CONFIG = 0,
  parameter         COMMON_ID = 6'h00,
  parameter         DRP_DISABLE = 0,
  parameter         USERPORTS_DISABLE = 0,
  parameter         GPIO_DISABLE = 0,
  parameter         START_CODE_DISABLE = 0) (

  // clock reset

  output              mmcm_rst,

  // adc interface

  input               adc_clk,
  output              adc_rst,
  output              adc_r1_mode,
  output              adc_ddr_edgesel,
  output              adc_pin_mode,
  input               adc_status,
  input               adc_sync_status,
  input               adc_status_ovf,
  input       [31:0]  adc_clk_ratio,
  output      [31:0]  adc_start_code,
  output              adc_sref_sync,
  output              adc_sync,
  output       [4:0]  adc_num_lanes,
  output              adc_sdr_ddr_n,
  input       [31:0]  up_pps_rcounter,
  input               up_pps_status,
  output  reg         up_pps_irq_mask,
  output  reg         up_adc_r1_mode = 'd0,

  // channel interface

  output              up_adc_ce,
  input               up_status_pn_err,
  input               up_status_pn_oos,
  input               up_status_or,

  // drp interface

  output              up_drp_sel,
  output              up_drp_wr,
  output      [11:0]  up_drp_addr,
  output      [31:0]  up_drp_wdata,
  input       [31:0]  up_drp_rdata,
  input               up_drp_ready,
  input               up_drp_locked,

  // user channel control

  output      [ 7:0]  up_usr_chanmax_out,
  input       [ 7:0]  up_usr_chanmax_in,
  input       [31:0]  up_adc_gpio_in,
  output      [31:0]  up_adc_gpio_out,

  // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [13:0]  up_waddr,
  input       [31:0]  up_wdata,
  output              up_wack,
  input               up_rreq,
  input       [13:0]  up_raddr,
  output      [31:0]  up_rdata,
  output              up_rack);

  // parameters

  localparam  VERSION = 32'h000a0162;

  // internal registers

  reg                 up_adc_clk_enb_int = 'd1;
  reg                 up_core_preset = 'd1;
  reg                 up_mmcm_preset = 'd1;
  reg                 up_wack_int = 'd0;
  reg         [31:0]  up_scratch = 'd0;
  reg                 up_adc_clk_enb = 'd0;
  reg                 up_mmcm_resetn = 'd0;
  reg                 up_resetn = 'd0;
  reg                 up_adc_sync = 'd0;
  reg                 up_adc_sref_sync = 'd0;
  reg         [4:0]   up_adc_num_lanes = 'd0;
  reg                 up_adc_sdr_ddr_n = 'd0;
  reg                 up_adc_ddr_edgesel = 'd0;
  reg                 up_adc_pin_mode = 'd0;
  reg                 up_status_ovf = 'd0;
  reg         [ 7:0]  up_usr_chanmax_int = 'd0;
  reg         [31:0]  up_adc_start_code = 'd0;
  reg         [31:0]  up_adc_gpio_out_int = 'd0;
  reg         [31:0]  up_timer = 'd0;
  reg                 up_rack_int = 'd0;
  reg         [31:0]  up_rdata_int = 'd0;

  // internal signals

  wire                up_wreq_s;
  wire                up_rreq_s;
  wire                up_status_s;
  wire                up_sync_status_s;
  wire                up_status_ovf_s;
  wire                up_cntrl_xfer_done_s;
  wire        [31:0]  up_adc_clk_count_s;
  wire                up_drp_status_s;
  wire                up_drp_rwn_s;
  wire        [31:0]  up_drp_rdata_hold_s;

  wire                adc_rst_n;
  wire                adc_rst_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:7] == {COMMON_ID,1'b0}) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:7] == {COMMON_ID,1'b0}) ? up_rreq : 1'b0;

  // processor write interface

  assign up_wack = up_wack_int;
  assign up_adc_ce = up_adc_clk_enb_int;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_clk_enb_int <= 1'd1;
      up_core_preset <= 1'd1;
      up_mmcm_preset <= 1'd1;
      up_wack_int <= 'd0;
      up_scratch <= 'd0;
      up_adc_clk_enb <= 'd0;
      up_mmcm_resetn <= 'd0;
      up_resetn <= 'd0;
      up_adc_sync <= 'd0;
      up_adc_sref_sync <= 'd0;
      up_adc_num_lanes <= 'd0;
      up_adc_sdr_ddr_n <= 'd0;
      up_adc_r1_mode <= 'd0;
      up_adc_ddr_edgesel <= 'd0;
      up_adc_pin_mode <= 'd0;
      up_pps_irq_mask <= 1'b1;
    end else begin
      up_adc_clk_enb_int <= ~up_adc_clk_enb;
      up_core_preset <= ~up_resetn;
      up_mmcm_preset <= ~up_mmcm_resetn;
      up_wack_int <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h04)) begin
        up_pps_irq_mask <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h10)) begin
        up_adc_clk_enb <= up_wdata[2];
        up_mmcm_resetn <= up_wdata[1];
        up_resetn <= up_wdata[0];
      end
      if (up_adc_sync == 1'b1) begin
        if (up_cntrl_xfer_done_s == 1'b1) begin
          up_adc_sync <= 1'b0;
        end
      end else if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h11)) begin
        up_adc_sync <= up_wdata[3];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h11)) begin
        up_adc_sdr_ddr_n <= up_wdata[16];
        up_adc_num_lanes <= up_wdata[12:8];
        up_adc_sref_sync <= up_wdata[4];
        up_adc_r1_mode <= up_wdata[2];
        up_adc_ddr_edgesel <= up_wdata[1];
        up_adc_pin_mode <= up_wdata[0];
      end
    end
  end

  generate
  if (DRP_DISABLE == 1) begin

    assign up_drp_sel = 'd0;
    assign up_drp_wr = 'd0;
    assign up_drp_status_s = 'd0;
    assign up_drp_rwn_s = 'd0;
    assign up_drp_addr = 'd0;
    assign up_drp_wdata = 'd0;
    assign up_drp_rdata_hold_s = 'd0;

  end else begin

    reg          up_drp_sel_int = 'd0;
    reg          up_drp_wr_int = 'd0;
    reg          up_drp_status_int = 'd0;
    reg          up_drp_rwn_int = 'd0;
    reg  [11:0]  up_drp_addr_int = 'd0;
    reg  [31:0]  up_drp_wdata_int = 'd0;
    reg  [31:0]  up_drp_rdata_hold_int = 'd0;

    always @(posedge up_clk) begin
      if (up_rstn == 0) begin
        up_drp_sel_int <= 'd0;
        up_drp_wr_int <= 'd0;
        up_drp_status_int <= 'd0;
        up_drp_rwn_int <= 'd0;
        up_drp_addr_int <= 'd0;
        up_drp_wdata_int <= 'd0;
        up_drp_rdata_hold_int <= 'd0;
      end else begin
        if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h1c)) begin
          up_drp_sel_int <= 1'b1;
          up_drp_wr_int <= ~up_wdata[28];
        end else begin
          up_drp_sel_int <= 1'b0;
          up_drp_wr_int <= 1'b0;
        end
        if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h1c)) begin
          up_drp_status_int <= 1'b1;
        end else if (up_drp_ready == 1'b1) begin
          up_drp_status_int <= 1'b0;
        end
        if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h1c)) begin
          up_drp_rwn_int <= up_wdata[28];
          up_drp_addr_int <= up_wdata[27:16];
        end
        if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h1e)) begin
          up_drp_wdata_int <= up_wdata;
        end
        if (up_drp_ready == 1'b1) begin
          up_drp_rdata_hold_int <= up_drp_rdata;
        end
      end
    end

    assign up_drp_sel = up_drp_sel_int;
    assign up_drp_wr = up_drp_wr_int;
    assign up_drp_status_s = up_drp_status_int;
    assign up_drp_rwn_s = up_drp_rwn_int;
    assign up_drp_addr = up_drp_addr_int;
    assign up_drp_wdata = up_drp_wdata_int;
    assign up_drp_rdata_hold_s = up_drp_rdata_hold_int;

  end
  endgenerate

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_ovf <= 'd0;
    end else begin
      if (up_status_ovf_s == 1'b1) begin
        up_status_ovf <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h22)) begin
        up_status_ovf <= up_status_ovf & ~up_wdata[2];
      end
    end
  end

  assign up_usr_chanmax_out = up_usr_chanmax_int;

  generate
  if (USERPORTS_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_usr_chanmax_int <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_usr_chanmax_int <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h28)) begin
        up_usr_chanmax_int <= up_wdata[7:0];
      end
    end
  end
  end
  endgenerate

  assign up_adc_gpio_out = up_adc_gpio_out_int;

  generate
  if (GPIO_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_adc_gpio_out_int <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_gpio_out_int <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h2f)) begin
        up_adc_gpio_out_int <= up_wdata;
      end
    end
  end
  end
  endgenerate

  generate
  if (START_CODE_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_adc_start_code <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_start_code <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h29)) begin
        up_adc_start_code <= up_wdata[31:0];
      end
    end
  end
  end
  endgenerate

  // timer with premature termination

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_timer <= 32'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h40)) begin
        up_timer <= up_wdata;
      end else if (up_timer > 0) begin
        up_timer <= up_timer - 1'b1;
      end
    end
  end

  // processor read interface

  assign up_rack = up_rack_int;
  assign up_rdata = up_rdata_int;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
    end else begin
      up_rack_int <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[6:0])
          7'h00: up_rdata_int <= VERSION;
          7'h01: up_rdata_int <= ID;
          7'h02: up_rdata_int <= up_scratch;
          7'h03: up_rdata_int <= CONFIG;
          7'h04: up_rdata_int <= {31'b0, up_pps_irq_mask};
          7'h07: up_rdata_int <= {FPGA_TECHNOLOGY,FPGA_FAMILY,SPEED_GRADE,DEV_PACKAGE}; // [8,8,8,8]
          7'h10: up_rdata_int <= {29'd0, up_adc_clk_enb, up_mmcm_resetn, up_resetn};
          7'h11: up_rdata_int <= {15'd0, up_adc_sdr_ddr_n,
                                  3'd0, up_adc_num_lanes,
                                  3'd0, up_adc_sref_sync,
                                  up_adc_sync, up_adc_r1_mode, up_adc_ddr_edgesel, up_adc_pin_mode};
          7'h15: up_rdata_int <= up_adc_clk_count_s;
          7'h16: up_rdata_int <= adc_clk_ratio;
          7'h17: up_rdata_int <= {28'd0, up_status_pn_err, up_status_pn_oos, up_status_or, up_status_s};
          7'h1a: up_rdata_int <= {31'd0, up_sync_status_s};
          7'h1c: up_rdata_int <= {3'd0, up_drp_rwn_s, up_drp_addr, 16'b0};
          7'h1d: up_rdata_int <= {14'd0, up_drp_locked, up_drp_status_s, 16'b0};
          7'h1e: up_rdata_int <= up_drp_wdata;
          7'h1f: up_rdata_int <= up_drp_rdata_hold_s;
          7'h22: up_rdata_int <= {29'd0, up_status_ovf, 2'b0};
          7'h23: up_rdata_int <= 32'd8;
          7'h28: up_rdata_int <= {24'd0, up_usr_chanmax_in};
          7'h29: up_rdata_int <= up_adc_start_code;
          7'h2e: up_rdata_int <= up_adc_gpio_in;
          7'h2f: up_rdata_int <= up_adc_gpio_out_int;
          7'h30: up_rdata_int <= up_pps_rcounter;
          7'h31: up_rdata_int <= {31'b0, up_pps_status};
          7'h40: up_rdata_int <= up_timer;
          default: up_rdata_int <= 0;
        endcase
      end else begin
        up_rdata_int <= 32'd0;
      end
    end
  end

  // resets

  ad_rst i_mmcm_rst_reg (.rst_async(up_mmcm_preset), .clk(up_clk),  .rstn(), .rst(mmcm_rst));
  ad_rst i_core_rst_reg (.rst_async(up_core_preset), .clk(adc_clk), .rstn(), .rst(adc_rst_s));

  // adc control & status

  up_xfer_cntrl #(.DATA_WIDTH(44)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_adc_sdr_ddr_n,
                      up_adc_num_lanes,
                      up_adc_sref_sync,
                      up_adc_sync,
                      up_adc_start_code,
                      up_adc_r1_mode,
                      up_adc_ddr_edgesel,
                      up_adc_pin_mode,
                      up_resetn}),
    .up_xfer_done (up_cntrl_xfer_done_s),
    .d_rst (adc_rst_s),
    .d_clk (adc_clk),
    .d_data_cntrl ({  adc_sdr_ddr_n,
                      adc_num_lanes,
                      adc_sref_sync,
                      adc_sync,
                      adc_start_code,
                      adc_r1_mode,
                      adc_ddr_edgesel,
                      adc_pin_mode,
                      adc_rst_n}));

  // De-assert adc_rst together with an updated control set.
  // This allows writing the control registers before releasing the reset.
  // This is important at start-up when stable set of controls is required.
  assign adc_rst = ~adc_rst_n;

  up_xfer_status #(.DATA_WIDTH(3)) i_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_sync_status_s,
                      up_status_s,
                      up_status_ovf_s}),
    .d_rst (adc_rst_s),
    .d_clk (adc_clk),
    .d_data_status ({ adc_sync_status,
                      adc_status,
                      adc_status_ovf}));

  // adc clock monitor

  up_clock_mon i_clock_mon (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_d_count (up_adc_clk_count_s),
    .d_rst (adc_rst_s),
    .d_clk (adc_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
