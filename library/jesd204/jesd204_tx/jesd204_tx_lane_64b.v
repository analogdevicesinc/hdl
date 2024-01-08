// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022, 2025 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_tx_lane_64b #(
  parameter ENABLE_FEC = 1'b0
) (
  input clk,
  input reset,

  input [63:0] tx_data,
  input tx_ready,

  output reg [63:0] phy_data,
  output     [1:0] phy_header,

  input lmc_edge,
  input lmc_quarter_edge,
  input eoemb,

  // Scrambling mandatory in 64bxxb, keep this for debugging purposes
  input cfg_disable_scrambler,
  input [1:0] cfg_header_mode,
  input cfg_lane_disable
);

  reg [63:0] scrambled_data;
  reg [63:0] scrambled_data_d1;
  reg lmc_edge_d1 = 'b0;
  reg lmc_edge_d2 = 'b0;
  reg lmc_edge_d3 = 'b0;
  reg lmc_quarter_edge_d1 = 'b0;
  reg lmc_quarter_edge_d2 = 'b0;
  reg lmc_quarter_edge_d3 = 'b0;
  reg tx_ready_d1 = 'b0;
  reg tx_ready_d2 = 'b0;
  reg eoemb_d1 = 'b0;
  reg [11:0] crc12_d1 = 'b0;

  wire [63:0] tx_data_msb_s;
  wire [63:0] scrambled_data_r;
  wire [11:0] crc12;
  wire [25:0] fec;

  /* Reorder octets MSB first */
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 8) begin: g_link_data
      assign tx_data_msb_s[i+:8] = tx_data[64-1-i-:8];
    end
  endgenerate

  jesd204_scrambler_64b #(
    .WIDTH(64),
    .DESCRAMBLE(0)
  ) i_scrambler (
    .clk(clk),
    .reset(reset),
    .enable(~cfg_disable_scrambler),
    .data_in(tx_data_msb_s),
    .data_out(scrambled_data_r));

  always @(posedge clk) begin
    lmc_edge_d1 <= lmc_edge;
    lmc_edge_d2 <= lmc_edge_d1;
    lmc_edge_d3 <= lmc_edge_d2;
    lmc_quarter_edge_d1 <= lmc_quarter_edge;
    lmc_quarter_edge_d2 <= lmc_quarter_edge_d1;
    lmc_quarter_edge_d3 <= lmc_quarter_edge_d2;
  end

  always @(posedge clk) begin
    scrambled_data <= scrambled_data_r;
    scrambled_data_d1 <= scrambled_data;
    phy_data <= scrambled_data_d1;
  end

  always @(posedge clk) begin
    tx_ready_d1 <= tx_ready;
    tx_ready_d2 <= tx_ready_d1;
    eoemb_d1 <= eoemb;
    crc12_d1 <= crc12;
  end

  jesd204_crc12 i_crc12 (
    .clk(clk),
    .reset(~tx_ready_d1),
    .init(lmc_edge_d2),
    .data_in(scrambled_data),
    .crc12(crc12));

  if(ENABLE_FEC) begin : gen_fec
    jesd204_fec_encode #(
      .DATA_WIDTH     (64)
    ) jesd204_fec_encode (
      .fec         (fec),
      .clk         (clk),
      .rst         (~tx_ready),
      .shift_en    (tx_ready_d2),
      .eomb        (lmc_edge_d2),
      .data_in     (scrambled_data)
    );
  end else begin : gen_no_fec
    assign fec = 26'b0;
  end

  jesd204_tx_header i_header_gen (
    .clk(clk),
    .reset(~tx_ready | cfg_lane_disable),

    .cfg_header_mode(cfg_header_mode),

    .lmc_edge(lmc_edge_d3),
    .lmc_quarter_edge(lmc_quarter_edge_d3),

    // Header content to be sent must be valid during lmc_edge
    .eoemb(eoemb_d1),
    .crc3(3'b0),
    .crc12(crc12_d1),
    .fec(fec),
    .cmd(19'b0),

    .header(phy_header));

endmodule
