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

module axi_usb_fx3_reg (

  // gpif ii

  input       [10:0]      fifo_rdy,

  input                   eot_fx32dma,
  input                   eot_dma2fx3,
  output                  trig,
  output                  zlp,
  output      [ 4:0]      fifo_num,

  input                   error,

  output      [ 2:0]      test_mode_tpm,
  output      [ 2:0]      test_mode_tpg,
  input                   monitor_error,

  output                  irq,

  output                  fifo0_direction,
  output      [ 7:0]      fifo0_header_size,
  output      [15:0]      fifo0_buffer_size,

  output                  fifo1_direction,
  output      [ 7:0]      fifo1_header_size,
  output      [15:0]      fifo1_buffer_size,

  output                  fifo2_direction,
  output      [ 7:0]      fifo2_header_size,
  output      [15:0]      fifo2_buffer_size,

  output                  fifo3_direction,
  output      [ 7:0]      fifo3_header_size,
  output      [15:0]      fifo3_buffer_size,

  output                  fifo4_direction,
  output      [ 7:0]      fifo4_header_size,
  output      [15:0]      fifo4_buffer_size,

  output                  fifo5_direction,
  output      [ 7:0]      fifo5_header_size,
  output      [15:0]      fifo5_buffer_size,

  output                  fifo6_direction,
  output      [ 7:0]      fifo6_header_size,
  output      [15:0]      fifo6_buffer_size,

  output                  fifo7_direction,
  output      [ 7:0]      fifo7_header_size,
  output      [15:0]      fifo7_buffer_size,

  output                  fifo8_direction,
  output      [ 7:0]      fifo8_header_size,
  output      [15:0]      fifo8_buffer_size,

  output                  fifo9_direction,
  output      [ 7:0]      fifo9_header_size,
  output      [15:0]      fifo9_buffer_size,

  output                  fifoa_direction,
  output      [ 7:0]      fifoa_header_size,
  output      [15:0]      fifoa_buffer_size,

  input       [31:0]      length_fx32dma,
  input       [31:0]      length_dma2fx3,

  // bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output  reg             up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output  reg [31:0]      up_rdata,
  output  reg             up_rack);

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire            fifo0_enable;
  wire            fifo1_enable;
  wire            fifo2_enable;
  wire            fifo3_enable;
  wire            fifo4_enable;
  wire            fifo5_enable;
  wire            fifo6_enable;
  wire            fifo7_enable;
  wire            fifo8_enable;
  wire            fifo9_enable;
  wire            fifoa_enable;

  // internal registers

  reg     [31:0]  fifo0_config = 32'h0;
  reg     [31:0]  fifo1_config = 32'h0;
  reg     [31:0]  fifo2_config = 32'h0;
  reg     [31:0]  fifo3_config = 32'h0;
  reg     [31:0]  fifo4_config = 32'h0;
  reg     [31:0]  fifo5_config = 32'h0;
  reg     [31:0]  fifo6_config = 32'h0;
  reg     [31:0]  fifo7_config = 32'h0;
  reg     [31:0]  fifo8_config = 32'h0;
  reg     [31:0]  fifo9_config = 32'h0;
  reg     [31:0]  fifoa_config = 32'h0;
  reg     [31:0]  fifo_status = 32'h0;
  reg     [31:0]  irq_config = 32'h0; // bit 1 - enable error interrupt, bit 0 - enable ready interrupt
  reg     [31:0]  transfer_config = 32'h0;
  reg     [31:0]  transfer_status = 32'h0;
  reg     [31:0]  tpm_config = 32'h0;
  reg     [31:0]  tpm_status = 32'h0;
  reg     [31:0]  tpg_config = 32'h0;
  reg     [31:0]  tpg_status = 32'h0;

  assign up_wreq_s = ((up_waddr[13:8] == 6'h00)) ? up_wreq : 1'b0;
  assign up_rreq_s = ((up_raddr[13:8] == 6'h00)) ? up_rreq : 1'b0;

  assign trig       = transfer_config[31];
  assign zlp        = transfer_config[30];
  assign fifo_num   = transfer_config[4:0];

  assign test_mode_tpm = tpm_config[2:0];
  assign test_mode_tpg = tpg_config[2:0];

  assign fifo0_enable       = fifo0_config[31];
  assign fifo0_direction    = fifo0_config[30];
  assign fifo0_header_size  = fifo0_config[23:16];
  assign fifo0_buffer_size  = fifo0_config[15:0];

  assign fifo1_enable       = fifo1_config[31];
  assign fifo1_direction    = fifo1_config[30];
  assign fifo1_header_size  = fifo1_config[23:16];
  assign fifo1_buffer_size  = fifo1_config[15:0];

  assign fifo2_enable       = fifo2_config[31];
  assign fifo2_direction    = fifo2_config[30];
  assign fifo2_header_size  = fifo2_config[23:16];
  assign fifo2_buffer_size  = fifo2_config[15:0];

  assign fifo3_enable       = fifo3_config[31];
  assign fifo3_direction    = fifo3_config[30];
  assign fifo3_header_size  = fifo3_config[23:16];
  assign fifo3_buffer_size  = fifo3_config[15:0];

  assign fifo4_enable       = fifo4_config[31];
  assign fifo4_direction    = fifo4_config[30];
  assign fifo4_header_size  = fifo4_config[23:16];
  assign fifo4_buffer_size  = fifo4_config[15:0];

  assign fifo5_enable       = fifo5_config[31];
  assign fifo5_direction    = fifo5_config[30];
  assign fifo5_header_size  = fifo5_config[23:16];
  assign fifo5_buffer_size  = fifo5_config[15:0];

  assign fifo6_enable       = fifo6_config[31];
  assign fifo6_direction    = fifo6_config[30];
  assign fifo6_header_size  = fifo6_config[23:16];
  assign fifo6_buffer_size  = fifo6_config[15:0];

  assign fifo7_enable       = fifo7_config[31];
  assign fifo7_direction    = fifo7_config[30];
  assign fifo7_header_size  = fifo7_config[23:16];
  assign fifo7_buffer_size  = fifo7_config[15:0];

  assign fifo8_enable       = fifo8_config[31];
  assign fifo8_direction    = fifo8_config[30];
  assign fifo8_header_size  = fifo8_config[23:16];
  assign fifo8_buffer_size  = fifo8_config[15:0];

  assign fifo9_enable       = fifo9_config[31];
  assign fifo9_direction    = fifo9_config[30];
  assign fifo9_header_size  = fifo9_config[23:16];
  assign fifo9_buffer_size  = fifo9_config[15:0];

  assign fifoa_enable       = fifoa_config[31];
  assign fifoa_direction    = fifoa_config[30];
  assign fifoa_header_size  = fifoa_config[23:16];
  assign fifoa_buffer_size  = fifoa_config[15:0];

  // generate interrupt if fifo is enabled and fifo is ready
  // or if an error has been encountered and irq is enabled
  assign irq = ( ((fifo0_enable & fifo_rdy[0]) | (fifo1_enable & fifo_rdy[1]) |
                  (fifo2_enable & fifo_rdy[2]) | (fifo3_enable & fifo_rdy[3]) |
                  (fifo4_enable & fifo_rdy[4]) | (fifo5_enable & fifo_rdy[5]) |
                  (fifo6_enable & fifo_rdy[6]) | (fifo7_enable & fifo_rdy[7]) |
                  (fifo8_enable & fifo_rdy[8]) | (fifo9_enable & fifo_rdy[9]) |
                  (fifoa_enable & fifo_rdy[10])) & irq_config[0] ) | (error & irq_config[1] ) ;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      fifo0_config <= 32'h00100400;
      fifo1_config <= 32'h00100400;
      fifo2_config <= 32'h00100400;
      fifo3_config <= 32'h00100400;
      fifo4_config <= 32'h00100400;
      fifo5_config <= 32'h00100400;
      fifo6_config <= 32'h00100400;
      fifo7_config <= 32'h00100400;
      fifo8_config <= 32'h00100400;
      fifo9_config <= 32'h00100400;
      fifoa_config <= 32'h00100400;
      irq_config <= 32'h0;
      transfer_config <= 32'h0;
      transfer_status <= 32'h0;
      tpm_config <= 32'h0;
      tpm_status <= 32'h0;
      tpg_config <= 32'h0;
      tpg_status <= 32'h0;
      fifo_status <= 32'h0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h0)) begin
        fifo0_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
        fifo1_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h2)) begin
        fifo2_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h3)) begin
        fifo3_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h4)) begin
        fifo4_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h5)) begin
        fifo5_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h6)) begin
        fifo6_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h7)) begin
        fifo7_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h8)) begin
        fifo8_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h9)) begin
        fifo9_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'ha)) begin
        fifoa_config <= up_wdata;
      end
      fifo_status[10:0] <= fifo_rdy;
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h11)) begin
        irq_config <= up_wdata;
      end
      if (eot_fx32dma == 1'b1 || eot_dma2fx3 == 1'b1 || error == 1'b1) begin
        transfer_config[31] <= 1'b0;
        transfer_config[30] <= 1'b0;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h12)) begin
        transfer_config <= up_wdata;
      end
      if (error == 1'b1) begin
        transfer_status[0] <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h13)) begin
        transfer_status[0] <= transfer_status[0] & ~up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h14)) begin
        tpm_config <= up_wdata;
      end
      if (monitor_error == 1'b1) begin
        tpm_status[0] <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h15)) begin
        tpm_status[0] <= tpm_status[0] & ~up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h16)) begin
        tpg_config <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h17)) begin
        tpg_status <= up_wdata;
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[4:0])
          5'h0: up_rdata <= fifo0_config;
          5'h1: up_rdata <= fifo1_config;
          5'h2: up_rdata <= fifo2_config;
          5'h3: up_rdata <= fifo3_config;
          5'h4: up_rdata <= fifo4_config;
          5'h5: up_rdata <= fifo5_config;
          5'h6: up_rdata <= fifo6_config;
          5'h7: up_rdata <= fifo7_config;
          5'h8: up_rdata <= fifo8_config;
          5'h9: up_rdata <= fifo9_config;
          5'ha: up_rdata <= fifoa_config;
          5'h10: up_rdata <= fifo_status;
          5'h11: up_rdata <= irq_config;
          5'h12: up_rdata <= transfer_config;
          5'h13: up_rdata <= transfer_status;
          5'h14: up_rdata <= tpm_config;
          5'h15: up_rdata <= tpm_status;
          5'h16: up_rdata <= tpg_config;
          5'h17: up_rdata <= tpg_status;
          5'h18: up_rdata <= length_fx32dma;
          5'h19: up_rdata <= length_dma2fx3;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
