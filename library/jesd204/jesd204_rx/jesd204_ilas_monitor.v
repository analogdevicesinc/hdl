// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_ilas_monitor #(
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input [9:0] cfg_octets_per_multiframe,
  input [DATA_PATH_WIDTH*8-1:0] data,
  input [DATA_PATH_WIDTH-1:0] charisk28,

  output reg ilas_config_valid,
  output reg [1:0] ilas_config_addr,
  output reg [DATA_PATH_WIDTH*8-1:0] ilas_config_data,

  output data_ready_n
);

  localparam STATE_ILAS = 1'b1;
  localparam STATE_DATA = 1'b0;
  localparam ILAS_DATA_LENGTH = (DATA_PATH_WIDTH == 4) ? 4 : 2;

  wire octets_per_mf_4_mod_8 = (DATA_PATH_WIDTH == 8) && ~cfg_octets_per_multiframe[2];
  reg state = STATE_ILAS;
  reg next_state;
  reg prev_was_last = 1'b0;
  wire ilas_config_start;
  reg ilas_config_valid_i;
  reg [1:0] ilas_config_addr_i;
  reg [DATA_PATH_WIDTH*8-1:0] ilas_config_data_i;

  assign data_ready_n = next_state;

  always @(*) begin
    next_state = state;
    if (reset == 1'b0 && prev_was_last == 1'b1) begin
      if (charisk28[0] != 1'b1 || data[7:5] != 3'h0) begin
        next_state = STATE_DATA;
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      state <= STATE_ILAS;
    end else begin
      state <= next_state;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1 || (charisk28[DATA_PATH_WIDTH-1] == 1'b1 && data[(DATA_PATH_WIDTH*8)-1:(DATA_PATH_WIDTH*8)-3] == 3'h3)) begin
      prev_was_last <= 1'b1;
    end else begin
      prev_was_last <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      ilas_config_valid_i <= 1'b0;
    end else if (state == STATE_ILAS) begin
      if (ilas_config_start) begin
        ilas_config_valid_i <= 1'b1;
      end else if (ilas_config_addr_i == (ILAS_DATA_LENGTH-1)) begin
        ilas_config_valid_i <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (ilas_config_valid_i == 1'b0) begin
      ilas_config_addr_i <= 1'b0;
    end else if (ilas_config_valid_i == 1'b1) begin
      ilas_config_addr_i <= ilas_config_addr_i + 1'b1;
    end
  end

  always @(posedge clk) begin
    ilas_config_data_i <= data;
  end

  generate
  if(DATA_PATH_WIDTH == 4) begin : gen_dp_4

  assign ilas_config_start = charisk28[1] && (data[15:13] == 3'h4);

  always @(*) begin
    ilas_config_valid = ilas_config_valid_i;
    ilas_config_addr = ilas_config_addr_i;
    ilas_config_data = ilas_config_data_i;
  end

  end else begin : gen_dp_8

  assign ilas_config_start = octets_per_mf_4_mod_8 ?
    (charisk28[5] && (data[47:45] == 3'h4)) :
    (charisk28[1] && (data[15:13] == 3'h4));

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      ilas_config_valid <= 1'b0;
    end else begin
      ilas_config_valid <= ilas_config_valid_i;
    end
  end

  always @(posedge clk) begin
    ilas_config_addr <= ilas_config_addr_i;
    ilas_config_data <= octets_per_mf_4_mod_8 ? {data[31:0], ilas_config_data_i[63:32]} : ilas_config_data_i;
  end
  end
  endgenerate

endmodule
