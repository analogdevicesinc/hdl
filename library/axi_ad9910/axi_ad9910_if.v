// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9910_if #(

  parameter FPGA_TECHNOLOGY = 0,
  parameter DELAY_REFCLK_FREQ = 200,
  parameter IODELAY_ENABLE = 1,
  parameter IODELAY_CTRL = 1,
  parameter IODELAY_GROUP = "dev_if_delay_group"
) (

  output                  pd_clk_out,
  input                   reset_pd,
  input                   enable_if,
  input                   sync_clk,

  input                   trig_transfer_ext,
  input                   transfer_trig_mode,
  input                   load_new_rate,
  input       [31:0]      update_rate_in,

  input                   ext_sync_disarm,
  input                   ext_sync_arm,

  // physical interface

  input                   pd_clk_in,
  output      [15:0]      db_o,
  output                  tx_enable,

  // axis lite

  input                   s_axis_aclk,
  input                   s_axis_aresetn,
  input                   s_axis_tvalid,
  input                   s_axis_tlast,
  input       [15:0]      s_axis_tdata,
  output                  s_axis_tready,

  // delay interface (for IDELAY macros)

  input                   up_clk,
  input       [18:0]      up_dld,
  input       [94:0]      up_dwdata,
  output      [94:0]      up_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked
);

  localparam FIFO_ADDR_W = 4;
  localparam FIFO_PTR_W = FIFO_ADDR_W + 1;

  // internal registers

  reg         [31:0]      update_rate;
  reg                     enable_sync_m;
  reg                     enable_sync;
  reg                     transfer_m1;
  reg                     transfer_m2;
  reg                     transfer_m3;
  reg         [31:0]      transfer_rate_cnt;
  reg                     transfer_init;
  reg                     wait_for_trig;
  reg         [15:0]      dds_data;
  reg                     fifo_rd_valid;
  reg                     fifo_rd_valid_d;
  reg                     transfer_armed_d;
  reg                     enable;
  reg                     arm_transfer_m;
  reg                     arm_transfer;
  reg    [FIFO_PTR_W-1:0] fifo_wr_ptr_bin;
  reg    [FIFO_PTR_W-1:0] fifo_wr_ptr_gray;
  reg    [FIFO_PTR_W-1:0] fifo_rd_ptr_bin;
  reg    [FIFO_PTR_W-1:0] fifo_rd_ptr_gray;
  reg    [FIFO_PTR_W-1:0] fifo_rd_ptr_gray_sync1;
  reg    [FIFO_PTR_W-1:0] fifo_rd_ptr_gray_sync2;
  reg    [FIFO_PTR_W-1:0] fifo_wr_ptr_gray_sync1;
  reg    [FIFO_PTR_W-1:0] fifo_wr_ptr_gray_sync2;

  // internal wires

  wire                    fifo_full_next;
  wire                    fifo_empty_next;
  wire                    pd_clk;
  wire                    transfer_armed;
  wire                    fifo_wr_en;
  wire                    fifo_rd_en;
  wire        [15:0]      fifo_rd_data;
  wire   [FIFO_ADDR_W-1:0]fifo_wr_addr;
  wire   [FIFO_ADDR_W-1:0]fifo_rd_addr;
  wire   [FIFO_PTR_W-1:0] fifo_wr_ptr_bin_next;
  wire   [FIFO_PTR_W-1:0] fifo_wr_ptr_gray_next;
  wire   [FIFO_PTR_W-1:0] fifo_rd_ptr_bin_next;
  wire   [FIFO_PTR_W-1:0] fifo_rd_ptr_gray_next;
  reg                     fifo_full_reg;
  reg                     fifo_empty_reg;
  wire   [FIFO_PTR_W-1:0] fifo_wr_ptr_bin_sync;
  wire   [FIFO_PTR_W-1:0] fifo_level;
  wire                    fifo_has_cfg_words;
  wire                    start_transfer;
  wire                    transfer_armed_fall;
  wire                    transfer_word_en;

  // DMA data transfer

  assign fifo_wr_en = s_axis_tvalid & s_axis_tready;
  assign fifo_wr_addr = fifo_wr_ptr_bin[FIFO_ADDR_W-1:0];
  assign fifo_rd_addr = fifo_rd_ptr_bin[FIFO_ADDR_W-1:0];

  assign fifo_wr_ptr_bin_next = fifo_wr_ptr_bin +
                                {{(FIFO_PTR_W-1){1'b0}}, fifo_wr_en};
  assign fifo_wr_ptr_gray_next = (fifo_wr_ptr_bin_next >> 1) ^ fifo_wr_ptr_bin_next;
  assign fifo_rd_ptr_bin_next = fifo_rd_ptr_bin +
                                {{(FIFO_PTR_W-1){1'b0}}, fifo_rd_en};
  assign fifo_rd_ptr_gray_next = (fifo_rd_ptr_bin_next >> 1) ^ fifo_rd_ptr_bin_next;

  assign fifo_full_next = (fifo_wr_ptr_gray_next ==
                      {~fifo_rd_ptr_gray_sync2[FIFO_ADDR_W:FIFO_ADDR_W-1],
                       fifo_rd_ptr_gray_sync2[FIFO_ADDR_W-2:0]});
  assign fifo_empty_next = (fifo_rd_ptr_gray_next == fifo_wr_ptr_gray_sync2);

  assign s_axis_tready = !fifo_full_reg;

  assign transfer_word_en = enable & start_transfer & fifo_has_cfg_words;
  assign fifo_rd_en = transfer_word_en & !fifo_empty_reg;

  function [FIFO_PTR_W-1:0] gray_to_bin;
    input [FIFO_PTR_W-1:0] gray;
    integer j;
    begin
      gray_to_bin[FIFO_PTR_W-1] = gray[FIFO_PTR_W-1];
      for (j = FIFO_PTR_W-2; j >= 0; j = j - 1) begin
        gray_to_bin[j] = gray_to_bin[j+1] ^ gray[j];
      end
    end
  endfunction

  assign fifo_wr_ptr_bin_sync = gray_to_bin(fifo_wr_ptr_gray_sync2);
  assign fifo_level = fifo_wr_ptr_bin_sync - fifo_rd_ptr_bin;
  assign fifo_has_cfg_words = (fifo_level >= {{(FIFO_PTR_W-3){1'b0}}, 2'd1});

  always @(posedge s_axis_aclk) begin
    if (!s_axis_aresetn) begin
      fifo_wr_ptr_bin <= 'd0;
      fifo_wr_ptr_gray <= 'd0;
      fifo_rd_ptr_gray_sync1 <= 'd0;
      fifo_rd_ptr_gray_sync2 <= 'd0;
      fifo_full_reg <= 1'b0;
    end else begin
      fifo_rd_ptr_gray_sync1 <= fifo_rd_ptr_gray;
      fifo_rd_ptr_gray_sync2 <= fifo_rd_ptr_gray_sync1;
      if (fifo_wr_en) begin
        fifo_wr_ptr_bin <= fifo_wr_ptr_bin_next;
        fifo_wr_ptr_gray <= fifo_wr_ptr_gray_next;
      end
      fifo_full_reg <= fifo_full_next;
    end
  end

  always @(posedge pd_clk) begin
    if (reset_pd == 1'b1) begin
      fifo_rd_ptr_bin <= 'd0;
      fifo_rd_ptr_gray <= 'd0;
      fifo_wr_ptr_gray_sync1 <= 'd0;
      fifo_wr_ptr_gray_sync2 <= 'd0;
      fifo_rd_valid <= 1'b0;
      fifo_rd_valid_d <= 1'b0;
      fifo_empty_reg <= 1'b1;
      dds_data <= 16'd0;
    end else begin
      fifo_wr_ptr_gray_sync1 <= fifo_wr_ptr_gray;
      fifo_wr_ptr_gray_sync2 <= fifo_wr_ptr_gray_sync1;
      fifo_rd_valid_d <= fifo_rd_valid;
      fifo_rd_valid <= fifo_rd_en;
      if (fifo_rd_en) begin
        fifo_rd_ptr_bin <= fifo_rd_ptr_bin_next;
        fifo_rd_ptr_gray <= fifo_rd_ptr_gray_next;
      end
      fifo_empty_reg <= fifo_empty_next;
      if (fifo_rd_valid) begin
        dds_data <= fifo_rd_data[15:0];
      end
    end
  end

  ad_mem #(
    .ADDRESS_WIDTH (FIFO_ADDR_W),
    .DATA_WIDTH (16)
  ) i_dma_fifo (
    .clka (s_axis_aclk),
    .wea (fifo_wr_en),
    .addra (fifo_wr_addr),
    .dina (s_axis_tdata),
    .clkb (pd_clk),
    .reb (fifo_rd_en),
    .addrb (fifo_rd_addr),
    .doutb (fifo_rd_data));

  assign transfer_armed_fall = transfer_armed_d & !transfer_armed;
  assign start_transfer = transfer_trig_mode ? transfer_armed_fall :
                                               transfer_init;

  always @(posedge pd_clk) begin
    if (reset_pd == 1'b1) begin
      enable <= 1'b0;
    end else begin
      enable <= enable_if;
    end
  end

  // external trigger

  always @(posedge pd_clk) begin
    if (reset_pd == 1'b1) begin
      transfer_m1 <= 1'b0;
      transfer_m2 <= 1'b0;
      transfer_m3 <= 1'b0;
    end else begin
      transfer_m1 <= trig_transfer_ext;
      transfer_m2 <= transfer_m1;
      transfer_m3 <= transfer_m2;
    end
  end

  util_ext_sync #(
    .ENABLED (1'b1)
  ) i_util_ext_sync (
    .clk (pd_clk),
    .ext_sync_arm (ext_sync_arm),
    .ext_sync_disarm (ext_sync_disarm),
    .sync_in (trig_transfer_ext),
    .sync_armed (transfer_armed));

  // load transfer  cnt config

  always @(posedge pd_clk) begin
    if (load_new_rate) begin
      update_rate <= update_rate_in;
    end
  end

  // transfer trigger using internal cnt logic

  always @(posedge pd_clk) begin
    if (reset_pd == 1'b1) begin
      transfer_rate_cnt <= 'b0;
      transfer_init <= 1'b0;
    end else if (enable) begin
      if (transfer_trig_mode) begin
        transfer_rate_cnt <= load_new_rate ? update_rate_in : update_rate;
        transfer_init <= 1'b0;
      end else if (load_new_rate) begin
        transfer_rate_cnt <= update_rate_in;
        transfer_init <= 1'b0;
      end else if (transfer_rate_cnt != 'd0) begin
        transfer_rate_cnt <= transfer_rate_cnt - 'b1;
        transfer_init <= 1'b0;
      end else begin
        transfer_rate_cnt <= update_rate;
        transfer_init <= 1'b1;
      end
    end else begin
      transfer_init <= 1'b0;
    end
  end

  // transfer one configuration word

  always @(posedge pd_clk) begin
    if (reset_pd == 1'b1) begin
      transfer_armed_d <= 1'b0;
    end else if (enable) begin
      transfer_armed_d <= transfer_armed;
    end
  end

  // enable, oddr -> obuf

  ad_data_out #(
    .SINGLE_ENDED (1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IODELAY_ENABLE (IODELAY_ENABLE),
    .IODELAY_CTRL (IODELAY_CTRL),
    .IODELAY_GROUP (IODELAY_GROUP),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQ)
  ) i_enable (
    .tx_clk (pd_clk),
    .tx_data_p (fifo_rd_valid_d),
    .tx_data_n (fifo_rd_valid_d),
    .tx_data_out_p (tx_enable),
    .tx_data_out_n (),
    .up_clk (up_clk),
    .up_dld (up_dld[18]),
    .up_dwdata (up_dwdata[94:90]),
    .up_drdata (up_drdata[94:90]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // transmit data interface, oddr -> obuf

  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin: g_dds_data
    ad_data_out #(
      .SINGLE_ENDED (1),
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .IODELAY_ENABLE (IODELAY_ENABLE),
      .IODELAY_CTRL (0),
      .IODELAY_GROUP (IODELAY_GROUP),
      .REFCLK_FREQUENCY (DELAY_REFCLK_FREQ)
    ) i_tx_data (
      .tx_clk (pd_clk),
      .tx_data_p (dds_data[i]),
      .tx_data_n (dds_data[i]),
      .tx_data_out_p (db_o[i]),
      .tx_data_out_n (),
      .up_clk (up_clk),
      .up_dld (up_dld[i]),
      .up_dwdata (up_dwdata[((i*5)+4):(i*5)]),
      .up_drdata (up_drdata[((i*5)+4):(i*5)]),
      .delay_clk (delay_clk),
      .delay_rst (delay_rst),
      .delay_locked ());
    end
  endgenerate

  // device parallel clock interface (receive clock)

  ad_data_clk #(
    .SINGLE_ENDED (1)
  ) i_clk (
    .rst (1'd0),
    .locked (),
    .clk_in_p (pd_clk_in),
    .clk_in_n (1'd0),
    .clk (pd_clk));

  assign pd_clk_out = pd_clk;

endmodule
