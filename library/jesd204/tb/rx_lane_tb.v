// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module rx_lane_tb;
  parameter VCD_FILE = "rx_lane_tb.vcd";

  `include "tb_base.v"

  reg [31:0] data = {4{{3'd5,5'd28}}};
  reg [3:0] disperr = 4'b0000;
  reg [3:0] notintable = 4'b0000;
  reg [3:0] charisk = 4'b1111;

  wire ilas_config_valid;
  wire [1:0] ilas_config_addr;
  wire [4*8-1:0] ilas_config_data;
  wire [31:0] status_err_statistics_cnt;

  wire [4*8-1:0] rx_data;

  wire [1:0] status_cgs_state;
  wire status_ifs_ready;
  wire [2:0] status_frame_align;

  integer counter = 'h00;
  wire [31:0] counter2 = (counter - 'h20) * 4;

  always @(posedge clk) begin
    if ($urandom % 400 == 0)
      disperr <= 4'b1111;
    else if ($urandom % 400 == 1)
      disperr <= 4'b0001;
    else if ($urandom % 400 == 2)
      disperr <= 4'b0011;
    else if ($urandom % 400 == 3)
      disperr <= 4'b0111;
    else
      disperr <= 4'b0000;
  end

  always @(posedge clk) begin
    if ($random % 500 == 0)
      notintable <= 4'b1111;
    else
      notintable <= 4'b0000;
  end

  always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 'h20) begin
      charisk <= 'h0001;
      data[31:8] <= {{24'h020100}};
    end else if (counter == 'h21) begin
      charisk <= 'h0000;
      data[31:0] <= {{32'h06050403}};
    end else if (counter > 'h21) begin
      data <= (counter2 + 'h2) << 24 |
              (counter2 + 'h1) << 16 |
          (counter2 + 'h0) << 8 |
          (counter2 - 'h1);
      charisk <= 4'b0000;
    end
  end

  reg buffer_release_n = 1'b0;
  wire buffer_ready_n;

  always @(posedge clk) begin
    buffer_release_n <= buffer_ready_n;
  end

  jesd204_rx_lane i_rx_lane (
    .clk(clk),
    .reset(1'b0),

    .device_clk(clk),
    .device_reset(1'b0),

    .phy_data(data),
    .phy_charisk(charisk),
    .phy_disperr(disperr),
    .phy_notintable(notintable),

    .cgs_reset(reset),
    .cgs_ready(),

    .ifs_reset(1'b0),

    .rx_data(rx_data),

    .buffer_release_n(buffer_release_n),
    .buffer_ready_n(buffer_ready_n),

    .cfg_octets_per_multiframe(10'd31),
    .cfg_octets_per_frame(8'd3),
    .cfg_disable_char_replacement(1'b0),
    .cfg_disable_scrambler(1'b0),

    .ilas_config_valid(ilas_config_valid),
    .ilas_config_addr(ilas_config_addr),
    .ilas_config_data(ilas_config_data),

    .err_statistics_reset(1'b0),
    .ctrl_err_statistics_mask(3'h7),
    .status_err_statistics_cnt(status_err_statistics_cnt),

    .status_cgs_state(status_cgs_state),
    .status_ifs_ready(status_ifs_ready),
    .status_frame_align(status_frame_align),
    .status_frame_align_err_cnt());

endmodule
