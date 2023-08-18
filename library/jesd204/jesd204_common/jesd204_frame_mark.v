// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

// Limitations:
//  for DATA_PATH_WIDTH = 4, 8
//    F*K=4, multiples of DATA_PATH_WIDTH
//    F=1,2,3,4,6, and multiples of DATA_PATH_WIDTH
//  for DATA_PATH_WIDTH = 6
//    F=3,6
//  for DATA_PATH_WIDTH = 12
//    F=3,6,12

`timescale 1ns/100ps

module jesd204_frame_mark #(
  parameter DATA_PATH_WIDTH = 4
) (
  input                             clk,
  input                             reset,
  input [9:0]                       cfg_octets_per_multiframe,
  input [7:0]                       cfg_beats_per_multiframe,
  input [7:0]                       cfg_octets_per_frame,

  output reg [DATA_PATH_WIDTH-1:0]  sof,
  output reg [DATA_PATH_WIDTH-1:0]  eof,
  output reg [DATA_PATH_WIDTH-1:0]  somf,
  output reg [DATA_PATH_WIDTH-1:0]  eomf
);

  localparam MAX_OCTETS_PER_FRAME = 32;
  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;
  localparam CW = MAX_OCTETS_PER_FRAME > 128 ? 8 :
    MAX_OCTETS_PER_FRAME > 64 ? 7 :
    MAX_OCTETS_PER_FRAME > 32 ? 6 :
    MAX_OCTETS_PER_FRAME > 16 ? 5 :
    MAX_OCTETS_PER_FRAME > 8 ? 4 :
    MAX_OCTETS_PER_FRAME > 4 ? 3 :
    MAX_OCTETS_PER_FRAME > 2 ? 2 : 1;
  localparam BEATS_PER_FRAME_WIDTH = CW-DPW_LOG2;
  localparam BEATS_PER_MF_WIDTH = 10-DPW_LOG2;

  // For DATA_PATH_WIDTH = 8, special case if F*K%8=4
  wire                              octets_per_mf_4_mod_8 = (DATA_PATH_WIDTH == 8) && ~cfg_octets_per_multiframe[2];
  reg [BEATS_PER_MF_WIDTH-1:0]      cur_beats_per_multiframe;
  reg                               mf_phase;
  reg [1:0]                         beat_cnt_mod_3;
  reg [BEATS_PER_FRAME_WIDTH-1:0]   beat_cnt_frame;
  wire                              cur_sof;
  wire                              cur_eof;
  reg [BEATS_PER_MF_WIDTH-1:0]      beat_cnt_mf;
  wire                              cur_somf;
  wire                              cur_eomf;
  wire [DATA_PATH_WIDTH-1:0]        default_sof;
  wire [DATA_PATH_WIDTH-1:0]        default_eof;

  wire [BEATS_PER_FRAME_WIDTH-1:0]  cfg_beats_per_frame = cfg_octets_per_frame[CW-1:DPW_LOG2];
  reg [DATA_PATH_WIDTH-1:0] sof_f_3[2:0];
  reg [DATA_PATH_WIDTH-1:0] eof_f_3[2:0];
  reg [DATA_PATH_WIDTH-1:0] sof_f_6[2:0];
  reg [DATA_PATH_WIDTH-1:0] eof_f_6[2:0];
  reg [DATA_PATH_WIDTH-1:0] sof_f_12[2:0];
  reg [DATA_PATH_WIDTH-1:0] eof_f_12[2:0];

  generate
  if(DATA_PATH_WIDTH == 4) begin : gen_dp_4
  initial begin
    sof_f_3[0] = {4'b1001};
    sof_f_3[1] = {4'b0100};
    sof_f_3[2] = {4'b0010};
    eof_f_3[0] = {4'b0100};
    eof_f_3[1] = {4'b0010};
    eof_f_3[2] = {4'b1001};
    sof_f_6[0] = {4'b0001};
    sof_f_6[1] = {4'b0100};
    sof_f_6[2] = {4'b0000};
    eof_f_6[0] = {4'b0000};
    eof_f_6[1] = {4'b0010};
    eof_f_6[2] = {4'b1000};
  end
  end else if(DATA_PATH_WIDTH == 6) begin : gen_dp_6
  initial begin
    sof_f_3[0] = {6'b001001};
    sof_f_3[1] = {6'b001001};
    sof_f_3[2] = {6'b001001};
    eof_f_3[0] = {6'b100100};
    eof_f_3[1] = {6'b100100};
    eof_f_3[2] = {6'b100100};
    sof_f_6[0] = {6'b000001};
    sof_f_6[1] = {6'b000001};
    sof_f_6[2] = {6'b000001};
    eof_f_6[0] = {6'b100000};
    eof_f_6[1] = {6'b100000};
    eof_f_6[2] = {6'b100000};
  end
  end else if(DATA_PATH_WIDTH == 8) begin : gen_dp_8
  initial begin
    sof_f_3[0]  = {8'b01001001};
    sof_f_3[1]  = {8'b10010010};
    sof_f_3[2]  = {8'b00100100};
    eof_f_3[0]  = {8'b00100100};
    eof_f_3[1]  = {8'b01001001};
    eof_f_3[2]  = {8'b10010010};
    sof_f_6[0]  = {8'b01000001};
    sof_f_6[1]  = {8'b00010000};
    sof_f_6[2]  = {8'b00000100};
    eof_f_6[0]  = {8'b00100000};
    eof_f_6[1]  = {8'b00001000};
    eof_f_6[2]  = {8'b10000010};
    sof_f_12[0] = {8'b00000001};
    sof_f_12[1] = {8'b00010000};
    sof_f_12[2] = {8'b00000000};
    eof_f_12[0] = {8'b00000000};
    eof_f_12[1] = {8'b00001000};
    eof_f_12[2] = {8'b10000000};
  end
  end
  // Beat count % 3, to support F=3, 6, 12
  always @(posedge clk) begin
    if(reset) begin
      beat_cnt_mod_3 <= 2'd0;
    end else begin
      if(beat_cnt_mod_3 == 2'd2) begin
        beat_cnt_mod_3 <= 2'd0;
      end else begin
        beat_cnt_mod_3 <= beat_cnt_mod_3 + 1'b1;
      end
    end
  end

  // Beat count per frame
  always @(posedge clk) begin
    if(reset) begin
      beat_cnt_frame <= {BEATS_PER_FRAME_WIDTH{1'b0}};
    end else begin
      if(beat_cnt_frame == cfg_beats_per_frame) begin
        beat_cnt_frame <= {BEATS_PER_FRAME_WIDTH{1'b0}};
      end else begin
        beat_cnt_frame <= beat_cnt_frame + 1'b1;
      end
    end
  end

  assign cur_sof = beat_cnt_frame == 0;
  assign cur_eof = beat_cnt_frame == cfg_beats_per_frame;

  assign default_sof = {{DATA_PATH_WIDTH-1{1'b0}}, cur_sof};
  assign default_eof = {cur_eof, {DATA_PATH_WIDTH-1{1'b0}}};

  // cfg_octets_per_frame must be a multiple of DATA_PATH_WIDTH
  // except for the following supported special cases
  always @(*) begin
    case(cfg_octets_per_frame)
      8'd0:
        begin
          sof = {DATA_PATH_WIDTH{1'b1}};
          eof = {DATA_PATH_WIDTH{1'b1}};
        end
      8'd1:
        begin
          sof = {DATA_PATH_WIDTH/2{2'b01}};
          eof = {DATA_PATH_WIDTH/2{2'b10}};
        end
      8'd2:
        begin
          sof = sof_f_3[beat_cnt_mod_3];
          eof = eof_f_3[beat_cnt_mod_3];
        end
      8'd3:
        begin
          sof = {DATA_PATH_WIDTH/4{4'b0001}};
          eof = {DATA_PATH_WIDTH/4{4'b1000}};
        end
      8'd5:
        begin
          sof = sof_f_6[beat_cnt_mod_3];
          eof = eof_f_6[beat_cnt_mod_3];
        end
      8'd11:
        begin
          sof = (DATA_PATH_WIDTH == 4) ? default_sof : sof_f_12[beat_cnt_mod_3];
          eof = (DATA_PATH_WIDTH == 4) ? default_eof : eof_f_12[beat_cnt_mod_3];
        end
      default:
        begin
          sof = default_sof;
          eof = default_eof;
        end
    endcase
  end

  // Beat count per multiframe
  // Only support F*K%4=0
  // If DATA_PATH_WIDTH == 4, or if DATA_PATH_WIDTH == 8 and F*K%8=0,
  // then multiframes always start/end at the first/last octet in the data bus
  // Otherwise, start/end of multiframe have more complicated patterns
  always @(posedge clk) begin
    if(reset) begin
      beat_cnt_mf <= 8'b0;
      mf_phase <= 1'b0;
    end else begin
      if(beat_cnt_mf == cur_beats_per_multiframe) begin
        beat_cnt_mf <= 8'b0;
        mf_phase <= ~mf_phase;
      end else begin
        beat_cnt_mf <= beat_cnt_mf + 1'b1;
      end
    end
  end

  assign cur_somf = beat_cnt_mf == 0;
  assign cur_eomf = beat_cnt_mf == cur_beats_per_multiframe;

  if(DATA_PATH_WIDTH == 4 || DATA_PATH_WIDTH == 6) begin : gen_mf_dp_4_6
  always @(*) begin
    cur_beats_per_multiframe = cfg_beats_per_multiframe;
    somf = {{DATA_PATH_WIDTH-1{1'b0}}, cur_somf};
    eomf = {cur_eomf, {DATA_PATH_WIDTH-1{1'b0}}};
  end
  end else if(DATA_PATH_WIDTH == 8) begin : gen_mf_dp_8
  always @(*) begin
     // cfg_octets_per_multiframe = 4
     if(cfg_octets_per_multiframe[9:2] == 0) begin
       cur_beats_per_multiframe = 8'hXX;
       somf = 8'h11;
       eomf = 8'h88;
     end else if(~octets_per_mf_4_mod_8) begin
       cur_beats_per_multiframe = cfg_beats_per_multiframe;
       somf = {{DATA_PATH_WIDTH-1{1'b0}}, cur_somf};
       eomf = {cur_eomf, {DATA_PATH_WIDTH-1{1'b0}}};
     end else begin
        cur_beats_per_multiframe = cfg_beats_per_multiframe - mf_phase;
        if((mf_phase == 0) && (beat_cnt_mf == 0)) begin
          somf = 8'h01;
        end else if((mf_phase == 0) && (beat_cnt_mf == cur_beats_per_multiframe)) begin
          somf = 8'h10;
        end else begin
          somf = 8'b0;
        end

        if((mf_phase == 0) && (beat_cnt_mf == cur_beats_per_multiframe)) begin
          eomf = 8'h08;
        end else if((mf_phase == 1) && (beat_cnt_mf == cur_beats_per_multiframe)) begin
          eomf = 8'h80;
        end else begin
          eomf = 8'b0;
        end
     end
  end
  end
  endgenerate

endmodule
