// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

module lane_align (
  input         usr_clk,
  input  [31:0] rxdata,
  input         en_char_align,
  output        rx_slide
);

  localparam K_CHARACTER = 32'hBCBCBCBC;

  localparam WAIT_FOR_CHAR_ALIGN = 0;
  localparam CHECK_ALIGNMENT = 1;
  localparam PULSE_SLIDE = 2;
  localparam WAIT_DELAY  = 3;

  reg  [2:0] state = WAIT_FOR_CHAR_ALIGN;
  reg  [2:0] next_state;
  reg  [5:0] counter = 0;
  reg  [5:0] next_counter;
  reg        en_char_align_d1;
  reg        en_char_align_d2;
  wire       en_char_align_edge;
  wire       rx_slide_s;

  always @(posedge usr_clk) begin
    en_char_align_d2 <= en_char_align;
    en_char_align_d1 <= en_char_align_d2;
  end

  assign en_char_align_edge = ~en_char_align_d2 & ~en_char_align_d1 & en_char_align;

  always @(posedge usr_clk) begin
    if (en_char_align_edge) begin
      state <= CHECK_ALIGNMENT;
      counter <= 'd0;
    end else begin
      state <= next_state;
      counter <= next_counter;
    end
  end

  always @(*) begin
    next_counter <= counter;
    case (state)
      WAIT_FOR_CHAR_ALIGN: begin
        if (en_char_align) begin
          next_state <= CHECK_ALIGNMENT;
        end else begin
          next_state <= WAIT_FOR_CHAR_ALIGN;
        end
      end
      CHECK_ALIGNMENT: begin
        if (rxdata == K_CHARACTER) begin
          next_state <= WAIT_FOR_CHAR_ALIGN;
        end else begin
          next_counter <= 'd0;
          next_state <= PULSE_SLIDE;
        end
      end
      PULSE_SLIDE: begin // a pulse is valid only if it takes 2 usr_clk cycles
        if (counter == 'd1) begin
          next_state <= WAIT_DELAY;
          next_counter <= 'd0;
        end else begin
          next_state <= PULSE_SLIDE;
          next_counter <= counter + 1'b1;
        end
      end
      WAIT_DELAY: begin // wait 32 usr_clk cycles between each pulse
        if (counter[5]) begin
          next_state <= CHECK_ALIGNMENT;
        end else begin
          next_state <= WAIT_DELAY;
          next_counter <= counter + 1'b1;
        end
      end
    endcase
  end

  assign rx_slide_s = (state == PULSE_SLIDE)? 1'b1 : 1'b0;

  assign rx_slide = rx_slide_s;

endmodule
