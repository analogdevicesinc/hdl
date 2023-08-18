// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module soft_pcs_loopback_tb;
  parameter VCD_FILE = "soft_pcs_loopback_tb.vcd";
  parameter DATA_PATH_WIDTH = 4;
  parameter LANE_INVERT = 0;

  `include "tb_base.v"

  reg [7:0] tx_char = {3'd5,5'd28};
  reg tx_charisk = 1'b1;
  reg [8*DATA_PATH_WIDTH-1:0] tx_char_pcs = 'h00;
  reg [DATA_PATH_WIDTH-1:0] tx_charisk_pcs = 'h00;

  wire [7:0] rx_char;
  wire rx_charisk;
  wire rx_notintable;
  wire rx_disperr;
  wire [8*DATA_PATH_WIDTH-1:0] rx_char_pcs;
  wire [DATA_PATH_WIDTH-1:0] rx_charisk_pcs;
  wire [DATA_PATH_WIDTH-1:0] rx_notintable_pcs;
  wire [DATA_PATH_WIDTH-1:0] rx_disperr_pcs;
  reg rx_pattern_align_en = 1'b1;

  wire [10*DATA_PATH_WIDTH-1:0] data_aligned;
  wire [10*DATA_PATH_WIDTH+9:0] data_aligned_full;
  reg [8:0] data_aligned_d1 = 'h00;
  reg [10*DATA_PATH_WIDTH-1:0] data_unaligned = 'h00;
  reg [3:0] bitshift = 'h00;

  integer clk_div = 0;
  wire pcs_clk = clk_div < DATA_PATH_WIDTH / 2 ? 1'b1 : 1'b0;
  reg pcs_reset = 1'b1;

  always @(posedge pcs_clk) begin
    pcs_reset <= 1'b0;
  end

  always @(posedge clk) begin
    if (clk_div == DATA_PATH_WIDTH - 1) begin
      clk_div <= 0;
    end else begin
      clk_div <= clk_div + 1;
    end
  end

  always @(posedge pcs_clk) begin
    data_aligned_d1 <= data_aligned[DATA_PATH_WIDTH*10-1:DATA_PATH_WIDTH*10-9];
  end

  assign data_aligned_full = {data_aligned,data_aligned_d1};

  always @(*) begin
    data_unaligned <= data_aligned_full[bitshift+:DATA_PATH_WIDTH*10];
  end

  jesd204_soft_pcs_tx #(
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .INVERT_OUTPUTS(LANE_INVERT)
  ) i_soft_pcs_tx (
    .clk(pcs_clk),
    .reset(pcs_reset),

    .char(tx_char_pcs),
    .charisk(tx_charisk_pcs),

    .data(data_aligned));

  jesd204_soft_pcs_rx #(
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .INVERT_INPUTS(LANE_INVERT)
  ) i_soft_pcs_rx (
    .clk(pcs_clk),
    .reset(pcs_reset),

    .patternalign_en(rx_pattern_align_en),
    .data(data_unaligned),

    .char(rx_char_pcs),
    .charisk(rx_charisk_pcs),
    .notintable(rx_notintable_pcs),
    .disperr(rx_disperr_pcs));

  always @(posedge clk) begin
    tx_char_pcs <= {tx_char,tx_char_pcs[DATA_PATH_WIDTH*8-1:8]};
    tx_charisk_pcs <= {tx_charisk,tx_charisk_pcs[DATA_PATH_WIDTH-1:1]};
  end

  integer rx_mux_select = 0;

  always @(posedge clk) begin
    if (rx_mux_select == DATA_PATH_WIDTH - 1) begin
      rx_mux_select <= 0;
    end else begin
      rx_mux_select <= rx_mux_select + 1;
    end
  end

  assign rx_charisk = rx_charisk_pcs[rx_mux_select];
  assign rx_notintable = rx_notintable_pcs[rx_mux_select];
  assign rx_disperr = rx_disperr_pcs[rx_mux_select];

  generate
  genvar i;
  for (i = 0; i < 8; i = i + 1) begin
    assign rx_char[i] = rx_char_pcs[rx_mux_select*8+i];
  end
  endgenerate

  integer counter = 0;

  localparam STATE_SEND_ALIGN = 0;
  localparam STATE_SEND_DATA = 1;
  reg state = STATE_SEND_ALIGN;
  reg [7:0] rx_compare = 'h00;

  always @(posedge clk) begin
    case(state)
    STATE_SEND_ALIGN: begin
      tx_char <= {3'd5,5'd28};
      tx_charisk <= 1'b1;

      // Worst case alignment time is 40 * DATA_PATH_WIDTH
      if (counter < DATA_PATH_WIDTH * 60) begin
        rx_pattern_align_en <= 1'b1;
      end else begin
        rx_pattern_align_en <= 1'b0;
      end

      if (counter == DATA_PATH_WIDTH * 64) begin
        state <= STATE_SEND_DATA;
        counter <= 0;
        rx_compare <= 'h00;
      end else begin
        counter <= counter + 1'b1;
      end
    end
    STATE_SEND_DATA: begin
      if (tx_charisk == 1'b1) begin
        tx_char <= 'h00;
      end else begin
        tx_char <= tx_char + 1'b1;
      end
      tx_charisk <= 1'b0;

      if (rx_charisk == 1'b0) begin
        rx_compare <= rx_compare + 1'b1;
        if (rx_char != rx_compare || rx_disperr == 1'b1 || rx_notintable == 1'b1) begin
          failed <= 1'b1;
        end
      end else begin
        rx_compare <= 'h00;
      end

      if (rx_char == 'd255) begin
        state <= STATE_SEND_ALIGN;
        bitshift <= {$random} % 10;
      end
    end
    endcase
  end

endmodule
