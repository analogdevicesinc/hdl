// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

// Limitations:
//   DATA_PATH_WIDTH = 4, 8
//   F=1,2,3,4,6, and multiples of DATA_PATH_WIDTH

`timescale 1ns/100ps

module jesd204_frame_align_replace #(
  parameter DATA_PATH_WIDTH = 4,
  parameter IS_RX = 1'b1,
  parameter ENABLED = 1'b1
) (
  input                             clk,
  input                             reset,

  input [7:0]                       cfg_octets_per_frame,
  input                             cfg_disable_char_replacement,
  input                             cfg_disable_scrambler,

  input [DATA_PATH_WIDTH*8-1:0]     data,
  input [DATA_PATH_WIDTH-1:0]       eof,
  input [DATA_PATH_WIDTH-1:0]       rx_char_is_a,
  input [DATA_PATH_WIDTH-1:0]       rx_char_is_f,
  input [DATA_PATH_WIDTH-1:0]       tx_eomf,

  output [DATA_PATH_WIDTH*8-1:0]    data_out,
  output [DATA_PATH_WIDTH-1:0]      charisk_out
);

  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;

  wire                                  single_eof = cfg_octets_per_frame >= (DATA_PATH_WIDTH-1);
  reg  [DATA_PATH_WIDTH*8-1:0]          data_d1;
  reg  [DATA_PATH_WIDTH*8-1:0]          data_d2;
  wire [DATA_PATH_WIDTH-1:0]            char_is_align;
  reg  [DATA_PATH_WIDTH-1:0]            char_is_align_d1;
  reg  [DATA_PATH_WIDTH-1:0]            char_is_align_d2;
  wire [((DATA_PATH_WIDTH*2)+4)*8-1:0]  saved_data;
  wire [((DATA_PATH_WIDTH*2)+4)-1:0]    saved_char_is_align;
  wire [DATA_PATH_WIDTH*8-1:0]          data_replaced;
  wire [DATA_PATH_WIDTH*8-1:0]          data_prev_eof;
  wire [DATA_PATH_WIDTH*8-1:0]          data_prev_prev_eof;
  reg  [7:0]                            data_prev_eof_single;
  reg  [7:0]                            data_prev_eof_single_int;
  reg                                   char_is_align_prev_single;

  wire [DATA_PATH_WIDTH*8-1:0]          prev_data_1;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_prev_data_1;
  wire [DATA_PATH_WIDTH-1:0]            prev_char_is_align_1;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_data_2;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_prev_data_2;
  wire [DATA_PATH_WIDTH-1:0]            prev_char_is_align_2;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_data_3;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_prev_data_3;
  wire [DATA_PATH_WIDTH-1:0]            prev_char_is_align_3;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_data_4;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_prev_data_4;
  wire [DATA_PATH_WIDTH-1:0]            prev_char_is_align_4;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_data_6;
  wire [DATA_PATH_WIDTH*8-1:0]          prev_prev_data_6;
  wire [DATA_PATH_WIDTH-1:0]            prev_char_is_align_6;
  reg  [DATA_PATH_WIDTH*8-1:0]          prev_data;
  reg  [DATA_PATH_WIDTH*8-1:0]          prev_prev_data;
  reg  [DATA_PATH_WIDTH-1:0]            prev_char_is_align;
  reg  [DPW_LOG2:0]                     jj;
  reg  [DPW_LOG2:0]                     ll;

  always @(posedge clk) begin
    data_d1 <= data;
    data_d2 <= data_d1;
  end

  always @(posedge clk) begin
    if(reset) begin
      char_is_align_d1 <= 'b0;
      char_is_align_d2 <= 'b0;
    end else begin
      char_is_align_d1 <= char_is_align;
      char_is_align_d2 <= char_is_align_d1;
    end
  end

  // Capture single EOF in current cycle

  always @(eof, data) begin
    data_prev_eof_single_int = 'b0;
    for(ll = 0; ll < DATA_PATH_WIDTH; ll=ll+1) begin
      data_prev_eof_single_int = data_prev_eof_single_int | (data[ll*8 +: 8] & {8{eof[ll]}});
    end
  end

  always @(posedge clk) begin
    if(reset) begin
      data_prev_eof_single <= 'b0;
    end else begin
      if(|eof && (!IS_RX || !(|char_is_align))) begin
        data_prev_eof_single <= data_prev_eof_single_int;
      end
    end
  end

  always @(posedge clk) begin
    if(reset) begin
      char_is_align_prev_single <= 'b0;
    end else begin
      if(|eof) begin
        char_is_align_prev_single <= |char_is_align;
      end
    end
  end

  assign saved_data = {data, data_d1, data_d2[(DATA_PATH_WIDTH*8)-1:(DATA_PATH_WIDTH-4)*8]};
  assign saved_char_is_align = {char_is_align, char_is_align_d1, char_is_align_d2[DATA_PATH_WIDTH-1:DATA_PATH_WIDTH-4]};

  genvar ii;
  generate
  for (ii = 0; ii < DATA_PATH_WIDTH; ii = ii + 1) begin: gen_replace_byte
    assign prev_data_1[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH+3+ii)*8 +: 8];
    assign prev_data_2[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH+2+ii)*8 +: 8];
    assign prev_data_3[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH+1+ii)*8 +: 8];
    assign prev_prev_data_1[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH+2+ii)*8 +: 8];
    assign prev_prev_data_2[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH+ii)*8 +: 8];
    assign prev_prev_data_3[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH-2+ii)*8 +: 8];
    assign prev_char_is_align_1[ii] = saved_char_is_align[(DATA_PATH_WIDTH+3+ii)];
    assign prev_char_is_align_2[ii] = saved_char_is_align[(DATA_PATH_WIDTH+2+ii)];
    assign prev_char_is_align_3[ii] = saved_char_is_align[(DATA_PATH_WIDTH+1+ii)];

    if(DATA_PATH_WIDTH == 8) begin : gen_dp_8
      assign prev_data_4[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH+ii)*8 +: 8];
      assign prev_data_6[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH-2+ii)*8 +: 8];
      assign prev_prev_data_4[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH-4+ii)*8 +: 8];
      assign prev_prev_data_6[ii*8 +:8] = saved_data[(DATA_PATH_WIDTH-8+ii)*8 +: 8];
      assign prev_char_is_align_4[ii] = saved_char_is_align[(DATA_PATH_WIDTH+ii)];
      assign prev_char_is_align_6[ii] = saved_char_is_align[(DATA_PATH_WIDTH-2+ii)];
    end else begin
      assign prev_data_4[ii*8 +:8] = 'bX;
      assign prev_data_6[ii*8 +:8] = 'bX;
      assign prev_prev_data_4[ii*8 +:8] = 'bX;
      assign prev_prev_data_6[ii*8 +:8] = 'bX;
      assign prev_char_is_align_4[ii] = 'bX;
      assign prev_char_is_align_6[ii] = 'bX;
    end

    always @(*) begin
      case(cfg_octets_per_frame)
        0:
          begin
            prev_data[ii*8 +:8] = prev_data_1[ii*8 +:8];
            prev_prev_data[ii*8 +:8] = prev_prev_data_1[ii*8 +:8];
            prev_char_is_align[ii] = prev_char_is_align_1[ii];
          end
        1:
          begin
            prev_data[ii*8 +:8] = prev_data_2[ii*8 +:8];
            prev_prev_data[ii*8 +:8] = prev_prev_data_2[ii*8 +:8];
            prev_char_is_align[ii] = prev_char_is_align_2[ii];
          end
        2:
          begin
            prev_data[ii*8 +:8] = prev_data_3[ii*8 +:8];
            prev_prev_data[ii*8 +:8] = prev_prev_data_3[ii*8 +:8];
            prev_char_is_align[ii] = prev_char_is_align_3[ii];
          end
        3:
          begin
            prev_data[ii*8 +:8] = prev_data_4[ii*8 +:8];
            prev_prev_data[ii*8 +:8] = prev_prev_data_4[ii*8 +:8];
            prev_char_is_align[ii] = prev_char_is_align_4[ii];
          end
        5:
          begin
            prev_data[ii*8 +:8] = prev_data_6[ii*8 +:8];
            prev_prev_data[ii*8 +:8] = prev_prev_data_6[ii*8 +:8];
            prev_char_is_align[ii] = prev_char_is_align_6[ii];
          end
        default:
          begin
            prev_data[ii*8 +:8] = 'bX;
            prev_prev_data[ii*8 +:8] = 'bX;
            prev_char_is_align[ii] = 1'bX;
          end
      endcase
    end

    if(IS_RX) begin : gen_rx
      // RX
      assign char_is_align[ii] = !reset && (rx_char_is_a[ii] | rx_char_is_f[ii]);
      assign data_replaced[ii*8 +: 8] = char_is_align[ii] ? data_prev_eof[ii*8 +: 8] : data[ii*8 +: 8];
      assign data_prev_eof[ii*8 +: 8] = single_eof ? data_prev_eof_single : prev_char_is_align[ii] ? data_prev_prev_eof[ii*8 +: 8] : prev_data[ii*8 +: 8];
      assign data_prev_prev_eof[ii*8 +: 8] = prev_prev_data[ii*8 +: 8];
    end else begin : gen_tx
      // TX
      assign data_prev_eof[ii*8 +: 8] = single_eof ? data_prev_eof_single : prev_data[ii*8 +: 8];
      assign char_is_align[ii] = !reset && (tx_eomf[ii] || (eof[ii] && !(single_eof ? char_is_align_prev_single : prev_char_is_align[ii]))) && (data[ii*8 +: 8] == data_prev_eof[ii*8 +: 8]);
      assign data_replaced[ii*8 +: 8] = char_is_align[ii] ? (tx_eomf[ii] ? 8'h7c : 8'hfc) : data[ii*8 +: 8];
    end
  end
  endgenerate

  assign data_out = (cfg_disable_char_replacement || !cfg_disable_scrambler || ENABLED==0) ? data : data_replaced;
  assign charisk_out = (IS_RX || !cfg_disable_scrambler || cfg_disable_char_replacement || ENABLED==0) ? 'b0 : char_is_align;

endmodule
