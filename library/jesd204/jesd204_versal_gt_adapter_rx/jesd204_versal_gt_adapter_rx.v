// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module  jesd204_versal_gt_adapter_rx #(
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

  // Interface to Link layer core
  output [ 63 : 0]  rx_data,
  output [  3 : 0]  rx_charisk,
  output [  3 : 0]  rx_disperr,
  output [  3 : 0]  rx_notintable,
  output [  1 : 0]  rx_header,
  output            rx_block_sync,
  input             en_char_align,

  input             resetn,
  input             usr_clk
);

  generate if (LINK_MODE == 2) begin
    // Sync header alignment
    wire rx_bitslip_req_s;
    reg [4:0] rx_bitslip_done_cnt = 'h0;
    always @(posedge usr_clk) begin
      if (rx_bitslip_done_cnt[4]) begin
        rx_bitslip_done_cnt <= 'b0;
      end else if (rx_bitslip_req_s & ~rx_bitslip_done_cnt[4]) begin
        rx_bitslip_done_cnt <= rx_bitslip_done_cnt + 1;
      end
    end

    reg rx_bitslip_req_s_d = 1'b0;
    always @(posedge usr_clk) begin
      rx_bitslip_req_s_d <= rx_bitslip_req_s;
    end
    assign rxgearboxslip = rx_bitslip_req_s & ~rx_bitslip_req_s_d;

    wire [63:0] rxdata_flip;
    genvar i;
    for (i = 0; i < 64; i=i+1) begin
      assign rxdata_flip[63-i] = rxdata[i];
    end

    // Sync header alignment
    sync_header_align i_sync_header_align (
      .clk(usr_clk),
      .reset(~rxheadervalid[0]),
      // Flip header bits and data
      .i_data({rxheader[0],rxheader[1],rxdata_flip[63:0]}),
      .i_slip(rx_bitslip_req_s),
      .i_slip_done(rx_bitslip_done_cnt[4]),
      .o_data(rx_data),
      .o_header(rx_header),
      .o_block_sync(rx_block_sync));

      assign rx_disperr    = 4'b0;
      assign rx_charisk    = 4'b0;
      assign rx_notintable = 4'b0;
      assign rxslide       = 1'b0;
    end else begin
      assign rx_data       = {32'b0, rxdata[31:0]};
      assign rx_header     = rxheader[1:0];

      assign rx_charisk    = rxctrl0[3:0];
      assign rx_disperr    = rxctrl1[3:0];
      assign rx_notintable = rxctrl3[3:0];
      assign rx_block_sync = 1'b0;
      assign rxgearboxslip = 1'b0;

      lane_align i_lane_align (
        .usr_clk  (usr_clk),
        .resetn   (resetn),
        .rxdata   (rxdata[31:0]),
        .rx_slide (rxslide),
        .en_char_align (en_char_align));
    end
  endgenerate

endmodule
