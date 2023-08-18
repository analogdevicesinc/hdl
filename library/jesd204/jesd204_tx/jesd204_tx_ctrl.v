// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2019, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_tx_ctrl #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input [NUM_LINKS-1:0] sync,
  input lmfc_edge,
  input [DATA_PATH_WIDTH-1:0] somf,
  input [DATA_PATH_WIDTH-1:0] somf_early2,
  input [DATA_PATH_WIDTH-1:0] eomf,

  output reg [NUM_LANES-1:0] lane_cgs_enable,
  output reg eof_reset,

  output reg tx_ready,
  output tx_ready_nx,
  output tx_next_mf_ready,

  output reg [DATA_PATH_WIDTH*8*NUM_LANES-1:0] ilas_data,
  output reg [DATA_PATH_WIDTH*NUM_LANES-1:0] ilas_charisk,

  output reg [1:0] ilas_config_addr,
  output reg ilas_config_rd,
  input [DATA_PATH_WIDTH*8*NUM_LANES-1:0] ilas_config_data,

  input [NUM_LANES-1:0] cfg_lanes_disable,
  input [NUM_LINKS-1:0] cfg_links_disable,
  input cfg_continuous_cgs,
  input cfg_continuous_ilas,
  input cfg_skip_ilas,
  input [7:0] cfg_mframes_per_ilas,
  input [9:0] cfg_octets_per_multiframe,
  input ctrl_manual_sync_request,

  output [NUM_LINKS-1:0] status_sync,
  output reg [1:0] status_state
);

  localparam ILAS_DATA_LENGTH = (DATA_PATH_WIDTH == 4) ? 4 : 2;
  localparam ILAS_COUNTER_WIDTH = (DATA_PATH_WIDTH == 4) ? 6 : 5;
  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;
  localparam BEATS_PER_MF_WIDTH = 10-DPW_LOG2;

  // For DATA_PATH_WIDTH = 8, special case if F*K%8=4
  //   Multiframe boundaries can occur in the middle of a beat
  //   jesd204_lmfc will assert lmfc_edge once per two LMFC periods
  //   cfg_mframes_per_ilas must be even
  wire [BEATS_PER_MF_WIDTH-1:0] cfg_beats_per_multiframe = cfg_octets_per_multiframe[9:DPW_LOG2];
  wire octets_per_mf_4_mod_8 = (DATA_PATH_WIDTH == 8) && ~cfg_octets_per_multiframe[2];
  wire [7:0] cfg_lmfc_per_ilas = octets_per_mf_4_mod_8 ? cfg_mframes_per_ilas/2 : cfg_mframes_per_ilas;
  reg lmfc_edge_d1 = 1'b0;
  reg lmfc_edge_d2 = 1'b0;
  reg eof_reset_d;
  reg ilas_reset = 1'b1;
  reg ilas_data_reset = 1'b1;
  reg sync_request = 1'b0;
  reg sync_request_received = 1'b0;
  reg last_ilas_mframe = 1'b0;
  reg [7:0] mframe_counter = 'h00;
  reg [ILAS_COUNTER_WIDTH-1:0] ilas_counter = 'h00;
  wire ilas_config_rd_start;
  reg ilas_config_rd_d1 = 1'b1;
  reg cgs_enable = 1'b1;
  wire [DATA_PATH_WIDTH*8-1:0] ilas_default_data;

  wire [NUM_LINKS-1:0] status_sync_masked;

  genvar ii;
  genvar jj;

  sync_bits #(
    .NUM_OF_BITS (NUM_LINKS)
  ) i_cdc_sync (
    .in_bits(sync),
    .out_clk(clk),
    .out_resetn(1'b1),
    .out_bits(status_sync));

  assign status_sync_masked = status_sync | cfg_links_disable;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      sync_request <= {NUM_LINKS{1'b0}};
    end else begin
      /* TODO: SYNC must be asserted at least 4 frames before interpreted as a
       * sync request and the /K28.5/ symbol generation has lasted for at
       * least 1 frame + 9 octets */
      if (cfg_continuous_cgs == 1'b1) begin
        sync_request <= 1'b1;
      end else begin
        sync_request <= ~(&status_sync_masked) | ctrl_manual_sync_request;
      end
    end
  end

  always @(posedge clk) begin
    if (sync_request == 1'b0 && sync_request_received == 1'b1) begin
      lmfc_edge_d1 <= lmfc_edge;
      lmfc_edge_d2 <= lmfc_edge_d1;
    end else begin
      lmfc_edge_d1 <= 1'b0;
      lmfc_edge_d2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      sync_request_received <= 1'b0;
    end else if (sync_request == 1'b1) begin
      sync_request_received <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (cfg_skip_ilas == 1'b1 ||
      mframe_counter == cfg_lmfc_per_ilas) begin
      last_ilas_mframe <= 1'b1;
    end else begin
      last_ilas_mframe <= 1'b0;
    end
  end

  always @(*) begin
    if (sync_request == 1'b1 || reset == 1'b1) begin
      eof_reset = 1'b1;
    end else if (lmfc_edge == 1'b1 && sync_request_received == 1'b1) begin
      eof_reset = 1'b0;
    end else begin
      eof_reset = eof_reset_d;
    end
  end

  always @(posedge clk) begin
    eof_reset_d <= eof_reset;
  end

  localparam STATE_WAIT = 2'b00;
  localparam STATE_CGS = 2'b01;
  localparam STATE_ILAS = 2'b10;
  localparam STATE_DATA = 2'b11;

  /* Timeline
   *
   * #1 lmfc_edge == 1, ilas_reset update
   * #3 {lane_,}cgs_enable, tx_ready update
   *
   * One multi-frame should at least be 3 clock cycles (TBD 64-bit data path)
   */

  always @(posedge clk) begin
    if (sync_request == 1'b1 || reset == 1'b1) begin
      cgs_enable <= 1'b1;
      lane_cgs_enable <= {NUM_LANES{1'b1}};
      tx_ready <= 1'b0;
      ilas_reset <= 1'b1;
      ilas_data_reset <= 1'b1;

      if (sync_request_received == 1'b0) begin
        status_state <= STATE_WAIT;
      end else begin
        status_state <= STATE_CGS;
      end
    end else if (sync_request_received == 1'b1) begin
      if (lmfc_edge == 1'b1 && last_ilas_mframe == 1'b1) begin
        ilas_reset <= 1'b1;
        status_state <= STATE_DATA;
      end else if (lmfc_edge_d1 == 1'b1 && (cfg_continuous_ilas == 1'b1 ||
        cgs_enable == 1'b1)) begin
        ilas_reset <= 1'b0;
        status_state <= STATE_ILAS;
      end

      if (lmfc_edge_d1 == 1'b1) begin
        if (last_ilas_mframe == 1'b1 && cfg_continuous_ilas == 1'b0) begin
          ilas_data_reset <= 1'b1;
        end else if (cgs_enable == 1'b1) begin
          ilas_data_reset <= 1'b0;
        end
      end

      if (lmfc_edge_d2 == 1'b1) begin
        lane_cgs_enable <= cfg_lanes_disable;
        cgs_enable <= 1'b0;
        if (last_ilas_mframe == 1'b1 && cfg_continuous_ilas == 1'b0) begin
          tx_ready <= 1'b1;
        end
      end
    end
  end

  assign tx_next_mf_ready = sync_request_received & last_ilas_mframe & ~cfg_continuous_ilas;
  assign tx_ready_nx = tx_ready | (tx_next_mf_ready & lmfc_edge_d2);

  always @(posedge clk) begin
    if (ilas_reset == 1'b1) begin
      mframe_counter <= 'h00;
    end else if (lmfc_edge_d1 == 1'b1) begin
      mframe_counter <= mframe_counter + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (ilas_reset == 1'b1) begin
      ilas_config_rd <= 1'b0;
    end else if (ilas_config_rd_start == 1'b1) begin
      ilas_config_rd <= 1'b1;
    end else if (ilas_config_addr == (ILAS_DATA_LENGTH-1)) begin
      ilas_config_rd <= 1'b0;
    end
    ilas_config_rd_d1 <= ilas_config_rd;
  end

  always @(posedge clk) begin
    if (ilas_config_rd == 1'b0) begin
      ilas_config_addr <= 'h00;
    end else begin
      ilas_config_addr <= ilas_config_addr + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (ilas_reset == 1'b1) begin
      ilas_counter <= 'h00;
    end else begin
      ilas_counter <= ilas_counter + 1'b1;
    end
  end

  generate
  for(ii = 0; ii < DATA_PATH_WIDTH; ii=ii+1) begin : gen_default_data
  wire [(8-ILAS_COUNTER_WIDTH)-1:0] ii_sig = ii;
  assign ilas_default_data[(ii*8)+7:ii*8] = {ilas_counter, ii_sig};
  end
  endgenerate

  generate
  if(DATA_PATH_WIDTH == 4) begin : gen_dp4

  assign ilas_config_rd_start = mframe_counter == 'h00 && somf_early2[0];

  always @(posedge clk) begin
    if (ilas_data_reset == 1'b1) begin
      ilas_data <= {NUM_LANES{32'h00}};
      ilas_charisk <= {NUM_LANES{4'b0000}};
    end else begin
      if (ilas_config_rd_d1 == 1'b1) begin
        case (ilas_config_addr)
        2'h1: begin
          ilas_data <= (ilas_config_data & {NUM_LANES{32'hffff0000}}) |
            {NUM_LANES{16'h00,8'h9c,8'h1c}}; // /Q/ /R/
          ilas_charisk <= {NUM_LANES{4'b0011}};
        end
        default: begin
          ilas_data <= ilas_config_data;
          ilas_charisk <= {NUM_LANES{4'b0000}};
        end
        endcase
      end else if (lmfc_edge_d2 == 1'b1) begin
        ilas_data <= {NUM_LANES{ilas_default_data[31:8],8'h1c}}; // /R/
        ilas_charisk <= {NUM_LANES{4'b0001}};
      end else if (lmfc_edge_d1 == 1'b1) begin
        ilas_data <= {NUM_LANES{8'h7c,ilas_default_data[23:0]}}; // /A/
        ilas_charisk <= {NUM_LANES{4'b1000}};
      end else begin
        ilas_data <= {NUM_LANES{ilas_default_data}};
        ilas_charisk <= {NUM_LANES{4'b0000}};
      end
    end
  end

  end else if(DATA_PATH_WIDTH == 8) begin : gen_dp8

  reg [63:0] ilas_config_data_d[NUM_LANES-1:0];
  reg ilas_config_rd_d2 = 1'b0;

  always @(posedge clk) begin
    ilas_config_rd_d2 <= ilas_config_rd_d1;
  end

  for(jj = 0; jj < NUM_LANES; jj = jj + 1) begin : gen_dp8_lane

  assign ilas_config_rd_start = (mframe_counter == 'h00) && (octets_per_mf_4_mod_8 ? somf_early2[4] : somf_early2[0]);

  always @(posedge clk) begin
    ilas_config_data_d[jj] <= {32'b0, ilas_config_data[(jj*64)+32+:32]};
  end

  for(ii = 0; ii < DATA_PATH_WIDTH; ii=ii+1) begin : gen_ilas_data

  always @(posedge clk) begin
    if (ilas_data_reset) begin
      ilas_data[(jj*64)+(ii*8)+:8] <= 8'h00;
      ilas_charisk[(jj*8)+ii] <= 1'b0;
    end else begin
      if(somf[ii]) begin
        ilas_data[(jj*64)+(ii*8)+:8] <= 8'h1c; // /R/
        ilas_charisk[(jj*8)+ii] <= 1'b1;
      end else if(eomf[ii]) begin
        ilas_data[(jj*64)+(ii*8)+:8] <= 8'h7c; // /A/
        ilas_charisk[(jj*8)+ii] <= 1'b1;
      end else if (ilas_config_rd_d1 &&
                   (ilas_config_addr == 2'h1) &&
                   ((octets_per_mf_4_mod_8 && (ii == 5)) ||
                     (!octets_per_mf_4_mod_8 && (ii == 1)))) begin
          ilas_data[(jj*64)+(ii*8)+:8] <= 8'h9c; // /Q/
          ilas_charisk[(jj*8)+ii] <= 1'b1;
      end else if (octets_per_mf_4_mod_8 && ilas_config_rd_d2 && (ii < 4)) begin
        ilas_data[(jj*64)+(ii*8)+:8] <= ilas_config_data_d[jj][ii*8+:8];
        ilas_charisk[(jj*8)+ii] <= 1'b0;
      end else if (octets_per_mf_4_mod_8 && ilas_config_rd_d1 && (ii >= 4)) begin
        ilas_data[(jj*64)+(ii*8)+:8] <= ilas_config_data[(jj*64)+((ii-4)*8)+:8];
        ilas_charisk[(jj*8)+ii] <= 1'b0;
      end else if (!octets_per_mf_4_mod_8 && ilas_config_rd_d1) begin
        ilas_data[(jj*64)+(ii*8)+:8] <= ilas_config_data[(jj*64)+(ii*8)+:8];
        ilas_charisk[(jj*8)+ii] <= 1'b0;
      end else begin
        ilas_data[(jj*64)+(ii*8)+:8] <= ilas_default_data[ii*8+:8];
        ilas_charisk[(jj*8)+ii] <= 1'b0;
      end
    end
  end

  end
  end
  end
  endgenerate

endmodule
