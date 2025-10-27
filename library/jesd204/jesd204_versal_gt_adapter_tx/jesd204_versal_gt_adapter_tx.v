// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2019, 2021, 2024-2025 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module  jesd204_versal_gt_adapter_tx #(
  parameter TRANSCEIVER = "GTY",
  parameter LINK_MODE = 2 // 1 - 8B10B, 2 - 64B66B
) (
  output  [127 : 0] txdata,
  output  [  5 : 0] txheader,
  output  [ 15 : 0] txctrl0,
  output  [ 15 : 0] txctrl1,
  output  [  7 : 0] txctrl2,

  input             phy_clk,
  input             phy_rstn,

  // Interface to Link layer core
  input   [ 63 : 0] tx_data,
  input   [  1 : 0] tx_header,
  input   [  3 : 0] tx_charisk,

  input             usr_clk
);
  wire i_reset;
  wire o_reset;

  sync_bits #(
    .NUM_OF_BITS(1),
    .ASYNC_CLK(1)
  ) i_sync_i_reset (
    .in_bits(~phy_rstn),
    .out_clk(phy_clk),
    .out_resetn(1'b1),
    .out_bits(i_reset));

  sync_bits #(
    .NUM_OF_BITS(1),
    .ASYNC_CLK(1)
  ) i_sync_o_reset (
    .in_bits(~phy_rstn),
    .out_clk(usr_clk),
    .out_resetn(1'b1),
    .out_bits(o_reset));

  generate if (TRANSCEIVER == "GTM") begin
    if (LINK_MODE == 2) begin
      wire        i_fifo_empty;
      wire        i_gb_read;
      wire [63:0] o_gb_data;
      wire [63:0] o_data;
      wire [ 1:0] o_header;;

      wire        o_fifo_full;
      reg  [63:0] o_phy_data_r;
      reg  [ 1:0] o_phy_header_r;
      wire [63:0] o_phy_data_rev;
      wire [ 1:0] o_phy_header_rev;

      wire         wr_rst_busy;
      wire         rd_rst_busy;
      wire  [65:0] rd_data;

      wire  [65:0] wr_data;
      wire         wr_en;
      wire         rd_en;

      reg   [63:0] txdata_d;

      // Register the input data to ease timing
      always @(posedge usr_clk) begin
        o_phy_data_r <= tx_data;
        o_phy_header_r <= tx_header;
      end

      genvar i;
      for (i=0; i < 64; i=i+1) begin
        assign o_phy_data_rev[63-i] = o_phy_data_r[i];
      end
      assign o_phy_header_rev = {o_phy_header_r[0], o_phy_header_r[1]};

      // CDC from LR / 66 to LR / 64
      assign wr_en = ~o_fifo_full & ~wr_rst_busy;
      assign rd_en = i_gb_read & ~i_fifo_empty & ~rd_rst_busy;

      xpm_fifo_async #(
        .CASCADE_HEIGHT(0),
        .CDC_SYNC_STAGES(2),
        .DOUT_RESET_VALUE("0"),
        .ECC_MODE("no_ecc"),
        .EN_SIM_ASSERT_ERR("warning"),
        .FIFO_MEMORY_TYPE("auto"),
        .FIFO_READ_LATENCY(1),
        .FIFO_WRITE_DEPTH(32),
        .FULL_RESET_VALUE(0),
        .PROG_EMPTY_THRESH(10),
        .PROG_FULL_THRESH(10),
        .RD_DATA_COUNT_WIDTH(1),
        .READ_DATA_WIDTH(66),
        .READ_MODE("std"),
        .RELATED_CLOCKS(0),
        .SIM_ASSERT_CHK(0),
        .USE_ADV_FEATURES("0707"),
        .WAKEUP_TIME(0),
        .WRITE_DATA_WIDTH(66),
        .WR_DATA_COUNT_WIDTH(1)
      ) i_async_fifo (
        .sleep (1'b0),
        .injectdbiterr (1'b0),
        .injectsbiterr (1'b0),
        .rd_rst_busy (rd_rst_busy),
        .rd_clk (phy_clk),
        .rd_en (rd_en),
        .dout(rd_data),
        .empty (i_fifo_empty),
        .wr_rst_busy (wr_rst_busy),
        .wr_clk (usr_clk),
        .wr_en (wr_en),
        .din ({o_phy_data_rev, o_phy_header_rev}),
        .full (o_fifo_full),
        .rst (o_reset));

      // In LR / 64 domain
      gearbox_66b64b i_gearbox (
        .clk (phy_clk),
        .reset (i_reset),
        .i_data (rd_data),
        .i_valid (~i_fifo_empty & i_gb_read),
        .o_data (o_gb_data),
        .o_rd_en (i_gb_read));

      always @(posedge phy_clk) begin
        txdata_d <= o_gb_data;
      end

      assign txdata = txdata_d;
      assign txheader = 'b0;
      assign txctrl0 = 'b0;
      assign txctrl1 = 'b0;
      assign txctrl2 = 'b0;
    end else begin
      wire [39:0] tx_data_40b;
      reg  [39:0] txdata_d;

      jesd204_soft_pcs_tx #(
        .NUM_LANES (1),
        .DATA_PATH_WIDTH (4),
        .INVERT_OUTPUTS (0),
        .IFC_TYPE (0)
      ) i_jesd204_soft_pcs_tx (
        .clk (usr_clk),
        .reset (o_reset),
        .char (tx_data),
        .charisk (tx_charisk),
        .data (tx_data_40b));

      always @(posedge usr_clk) begin
        txdata_d <= tx_data_40b;
      end

      assign txdata = txdata_d;
      assign txheader = 'b0;
      assign txctrl0 = 'b0;
      assign txctrl1 = 'b0;
      assign txctrl2 = 'b0;
    end
  end else begin
    reg [63:0]   txdata_d;
    reg [ 1:0]   txheader_d;
    reg [ 3:0]   txcharisk_d;

    always @(posedge usr_clk) begin
      txdata_d <= tx_data;
      txheader_d <= tx_header;
      txcharisk_d <= tx_charisk;
    end

    if (LINK_MODE == 2) begin
      wire [63:0] tx_data_flip;
      wire [ 1:0] tx_header_flip;
      genvar i;
      for (i = 0; i < 64; i=i+1) begin
        assign tx_data_flip[63-i] = txdata_d[i];
      end
      assign tx_header_flip = {txheader_d[0], txheader_d[1]};

      // Flip header bits and data
      assign txdata   = {64'b0, tx_data_flip};
      assign txheader = {4'b0, tx_header_flip};

      assign txctrl0  = 16'b0;
      assign txctrl1  = 16'b0;
      assign txctrl2  = 16'b0;
    end else begin
      assign txdata   = {96'b0, txdata_d[31:0]};
      assign txheader = {4'b0, txheader_d};
      assign txctrl2  = {4'b0, txcharisk_d};
      assign txctrl0  = 16'b0;
      assign txctrl1  = 16'b0;
    end
  end
  endgenerate

endmodule
