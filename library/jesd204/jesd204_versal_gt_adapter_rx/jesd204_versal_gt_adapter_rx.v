// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022, 2024 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module  jesd204_versal_gt_adapter_rx #(
  parameter TRANSCEIVER = "GTY",
  parameter LINK_MODE = 2 // 1 - 8B10B, 2 - 64B66B
) (
  // Interface to Physical Layer
  input  [127 : 0] rxdata,
  input  [  5 : 0] rxheader,
  input  [ 15 : 0] rxctrl0,
  input  [ 15 : 0] rxctrl1,
  input  [  7 : 0] rxctrl2,
  input  [  7 : 0] rxctrl3,
  output           rxgearboxslip,
  input  [  1 : 0] rxheadervalid,
  output           rxslide,

  input            phy_clk,
  input            phy_rstn,

  // Interface to Link layer core
  output [ 63 : 0]  rx_data,
  output [  3 : 0]  rx_charisk,
  output [  3 : 0]  rx_disperr,
  output [  3 : 0]  rx_notintable,
  output [  1 : 0]  rx_header,
  output            rx_block_sync,
  input             en_char_align,

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
      reg  [63:0] i_data;
      wire        rd_rst_busy;
      wire        wr_rst_busy;
      wire        fifo_wr_en;
      wire        i_fifo_full;
      wire [65:0] fifo_rd_data;
      wire        fifo_rd_en;
      wire        fifo_empty;

      wire [65:0] i_gb_data;
      wire        i_gb_valid;

      wire [63:0] o_data_aligned;
      wire [ 1:0] o_header_aligned;
      wire [63:0] o_data_rev;
      wire [ 1:0] o_header_rev;
      wire        o_bitslip;
      wire        o_bitslip_done;

      always @(posedge phy_clk) begin
        i_data <= rxdata[63:0];
      end

      gearbox_64b66b i_gearbox (
        .clk (phy_clk),
        .reset (i_reset),
        .i_data (i_data),
        .o_data (i_gb_data),
        .o_valid (i_gb_valid));

      // CDC from LR / 64 to LR / 66
      assign fifo_wr_en = i_gb_valid & ~i_fifo_full & ~wr_rst_busy;
      assign fifo_rd_en = ~fifo_empty & ~rd_rst_busy;

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
        .rd_clk (usr_clk),
        .rd_en (fifo_rd_en),
        .dout (fifo_rd_data),
        .empty (fifo_empty),
        .wr_rst_busy (wr_rst_busy),
        .wr_clk (phy_clk),
        .wr_en (fifo_wr_en),
        .din (i_gb_data),
        .full (i_fifo_full),
        .rst (i_reset));

      // In LR / 66 domain
      bitslip i_bitslip (
        .clk (usr_clk),
        .reset (o_reset),
        .bitslip (o_bitslip),
        .data_in (fifo_rd_data),
        .bitslip_done (o_bitslip_done),
        .data_out ({o_data_aligned, o_header_aligned}));

      genvar i;
      for (i=0; i < 64; i=i+1) begin
        assign o_data_rev[63-i] = o_data_aligned[i];
      end
      assign o_header_rev = {o_header_aligned[0], o_header_aligned[1]};

      sync_header_align i_header_align (
        .clk (usr_clk),
        .reset (o_reset),
        .i_data ({o_header_rev, o_data_rev}),
        .i_slip (o_bitslip),
        .i_slip_done (o_bitslip_done),
        .o_data (rx_data),
        .o_header (rx_header),
        .o_block_sync (rx_block_sync));

      assign rx_disperr    = 4'b0;
      assign rx_charisk    = 4'b0;
      assign rx_notintable = 4'b0;
      assign rxslide       = 1'b0;
      assign rxgearboxslip = 1'b0;
    end else begin
      wire [39:0] rx_data_40b;

      jesd204_soft_pcs_rx #(
        .NUM_LANES (1),
        .DATA_PATH_WIDTH (4),
        .REGISTER_INPUTS (1),
        .INVERT_INPUTS (0),
        .IFC_TYPE (0)
      ) i_jesd204_soft_pcs_rx (
        .clk (usr_clk),
        .reset (o_reset),
        .patternalign_en (en_char_align),
        .data (rxdata[39:0]),
        .char (rx_data_40b),
        .charisk (rx_charisk),
        .notintable (rx_notintable),
        .disperr (rx_disperr));

      assign rx_data = {24'b0, rx_data_40b};
      assign rx_block_sync = 'b0;
      assign rxslide = 1'b0;
      assign rxgearboxslip = 1'b0;
    end
  end else begin
    reg [63:0] rxdata_d;
    reg [ 1:0] rxheader_d;
    reg        rxgearboxslip_d;
    reg [ 1:0] rxheadervalid_d;
    reg [15:0] rxctrl0_d;
    reg [15:0] rxctrl1_d;
    reg [ 7:0] rxctrl3_d;
    wire       rxgearboxslip_s;

    always @(posedge usr_clk) begin
      rxdata_d <= rxdata[63:0];
      rxheader_d <= rxheader[1:0];
      rxgearboxslip_d <= rxgearboxslip_s;
      rxheadervalid_d <= rxheadervalid;
      rxctrl0_d <= rxctrl0;
      rxctrl1_d <= rxctrl1;
      rxctrl3_d <= rxctrl3;
    end

    if (LINK_MODE == 2) begin
      // Sync header alignment
      wire rx_bitslip_req_s;
      reg [5:0] rx_bitslip_done_cnt = 'h0;
      always @(posedge usr_clk) begin
        if (rx_bitslip_done_cnt[5]) begin
          rx_bitslip_done_cnt <= 'b0;
        end else if (rx_bitslip_req_s & ~rx_bitslip_done_cnt[5]) begin
          rx_bitslip_done_cnt <= rx_bitslip_done_cnt + 1;
        end
      end

      reg rx_bitslip_req_s_d = 1'b0;
      always @(posedge usr_clk) begin
        rx_bitslip_req_s_d <= rx_bitslip_req_s;
      end

      assign rxgearboxslip_s = rx_bitslip_req_s & ~rx_bitslip_req_s_d;
      assign rxgearboxslip = rxgearboxslip_d;

      wire [63:0] rxdata_flip;
      wire [ 1:0] rxheader_flip;
      genvar i;
      for (i = 0; i < 64; i=i+1) begin
        assign rxdata_flip[63-i] = rxdata_d[i];
      end
      assign rxheader_flip = {rxheader_d[0], rxheader_d[1]};

      // Sync header alignment
      sync_header_align i_sync_header_align (
        .clk(usr_clk),
        .reset(~rxheadervalid_d[0]),
        // Flip header bits and data
        .i_data({rxheader_flip, rxdata_flip}),
        .i_slip(rx_bitslip_req_s),
        .i_slip_done(rx_bitslip_done_cnt[5]),
        .o_data(rx_data),
        .o_header(rx_header),
        .o_block_sync(rx_block_sync));

        assign rx_disperr    = 4'b0;
        assign rx_charisk    = 4'b0;
        assign rx_notintable = 4'b0;
        assign rxslide       = 1'b0;
    end else begin
      assign rx_data       = rxdata_d[31:0];
      assign rx_header     = rxheader_d[1:0];

      assign rx_charisk    = rxctrl0_d[3:0];
      assign rx_disperr    = rxctrl1_d[3:0];
      assign rx_notintable = rxctrl3_d[3:0];
      assign rx_block_sync = 1'b0;
      assign rxgearboxslip = 1'b0;

      lane_align i_lane_align (
        .usr_clk  (usr_clk),
        .rxdata   (rxdata_d[31:0]),
        .rx_slide (rxslide),
        .en_char_align (en_char_align));
    end
  end
  endgenerate

endmodule
