// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_rx_cgs #(
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input [DATA_PATH_WIDTH-1:0] char_is_cgs,
  input [DATA_PATH_WIDTH-1:0] char_is_error,

  output ready,

  output [1:0] status_state
);

  localparam CGS_STATE_INIT = 2'b00;
  localparam CGS_STATE_CHECK = 2'b01;
  localparam CGS_STATE_DATA = 2'b10;

  reg [1:0] state = CGS_STATE_INIT;
  reg rdy = 1'b0;
  reg [1:0] beat_error_count = 'h00;

  wire beat_is_cgs = &char_is_cgs;
  wire beat_has_error = |char_is_error;
  wire beat_is_all_error = &char_is_error;

  assign ready = rdy;
  assign status_state = state;

  always @(posedge clk) begin
    if (state == CGS_STATE_INIT) begin
      beat_error_count <= 'h00;
    end else begin
      if (beat_has_error == 1'b1) begin
        beat_error_count <= beat_error_count + 1'b1;
      end else begin
        beat_error_count <= 'h00;
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      state <= CGS_STATE_INIT;
    end else begin
      case (state)
      CGS_STATE_INIT: begin
        if (beat_is_cgs == 1'b1) begin
          state <= CGS_STATE_CHECK;
        end
      end
      CGS_STATE_CHECK: begin
        if (beat_has_error == 1'b1) begin
          if (beat_error_count == 'h3 ||
              beat_is_all_error == 1'b1) begin
            state <= CGS_STATE_INIT;
          end
        end else begin
          state <= CGS_STATE_DATA;
        end
      end
      CGS_STATE_DATA: begin
        if (beat_has_error == 1'b1) begin
          state <= CGS_STATE_CHECK;
        end
      end
      endcase
    end
  end

  always @(posedge clk) begin
    case (state)
    CGS_STATE_INIT: rdy <= 1'b0;
    CGS_STATE_DATA: rdy <= 1'b1;
    default: rdy <= rdy;
    endcase
  end

endmodule
