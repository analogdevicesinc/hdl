
`timescale 1ns / 1ps

module bsync_generator (
  input logic        clk,
  input logic        rstn,
  input logic        direction,
  input logic        bsync_in,
  input logic        disable_internal_bsync,
  output             bsync_ready,
  output     [ 4:0]  bsync_delay,
  output     [15:0]  bsync_ratio,
  output             bsync_alignment_error,
  output             bsync_captured,
  output     [ 2:0]  bsync_state,
  output             bsync_event,
  output             bsync_out
);

  localparam                   STATE_WIDTH            = 3;
  localparam [STATE_WIDTH-1:0] IDLE                   = 0;
  localparam [STATE_WIDTH-1:0] BSYNC_EDGE             = 1;
  localparam [STATE_WIDTH-1:0] CALIB                  = 2;
  localparam [STATE_WIDTH-1:0] BSYNC_GEN              = 3;
  localparam [STATE_WIDTH-1:0] BSYNC_ALIGNMENT_ERROR  = 4;

  logic  [STATE_WIDTH-1:0] curr_state = IDLE;
  logic  [STATE_WIDTH-1:0] next_state;
  logic  [15:0]            ratio_counter;
  logic  [15:0]            bsync_counter;
  logic                    calib_done;
  logic                    b_edge;
  logic                    b_captured;
  logic                    bsync_buf;
  logic                    bsync_r  = 1'b0;
  logic                    bsync_d1 = 1'b0;
  logic                    bsync_d2 = 1'b0;
  logic                    bsync_d3 = 1'b0;
  logic [4:0]              bsync_alignment;
  logic                    bsync_misaligned;
  logic [4:0]              bsync_next_alignment;
  logic                    dir_changed = 1'b0;
  logic                    direction_r = 1'b0;
  logic                    direction_s;
  logic                    bsync_edge;

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_control_signals (
    .in_bits (direction),
    .out_clk (clk),
    .out_resetn (1'b1),
    .out_bits (direction_s));

  always @* begin
    next_state = curr_state;
    case (curr_state)
      IDLE : begin     
        if (b_captured) begin
         next_state = BSYNC_EDGE;
        end
      end

      BSYNC_EDGE : begin
        if(bsync_edge) begin
          next_state = CALIB;
        end
      end

      CALIB : begin 
        if (calib_done) begin
          next_state = BSYNC_GEN;
        end
      end
 
      BSYNC_GEN : begin
        if (bsync_misaligned) begin
          next_state = BSYNC_ALIGNMENT_ERROR;
        end
      end

      BSYNC_ALIGNMENT_ERROR : begin
        next_state = BSYNC_ALIGNMENT_ERROR;
      end

      default : next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      curr_state <= IDLE;
    end else begin
      curr_state <= next_state;
    end
  end

  always @(posedge clk) begin
    bsync_r <= bsync_in;
    bsync_edge <= (bsync_in && !bsync_r);
  end

  /*
   * Unfortunately setup and hold are often ignored on the bsync signal relative
   * to the device clock. The device will often still work fine, just not
   * deterministic. Reduce the probability that the meta-stability creeps into the
   * reset of the system and causes non-reproducible issues.
   */

  always @(posedge clk) begin
    bsync_d1 <= bsync_r;
    bsync_d2 <= bsync_d1;
    bsync_d3 <= bsync_d2;
  end

  always @(posedge clk) begin
    if (bsync_d3 == 1'b0 && bsync_d2 == 1'b1) begin
      b_edge <= 1'b1;
    end else begin
      b_edge <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (rstn == 1'b0 || direction_s == 1'b0) begin
      b_captured <= 1'b0;
    end else if (b_edge == 1'b1) begin
      b_captured <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      calib_done <= 1'b0;
      ratio_counter <= 'h0001;
      bsync_counter <= 1'b0;
    end else begin
      if (curr_state == CALIB) begin
        if (bsync_in) begin
          ratio_counter <= ratio_counter + 1'b1;
        end else begin
          if (bsync_counter < ratio_counter) begin
            bsync_counter <= bsync_counter + 1'b1;
          end else begin
            bsync_counter <= 0;
            calib_done <= 1'b1;
          end
        end
      end else if (curr_state == BSYNC_GEN) begin
        if (bsync_counter < (ratio_counter * 2) - 1) begin
          bsync_counter <= bsync_counter + 1'b1;
        end else begin   
          bsync_counter <= 'h0000;
        end
      end else if (curr_state == BSYNC_ALIGNMENT_ERROR) begin
        calib_done <= 1'b0;
      end
    end
  end

  assign bsync_ready = calib_done;
  assign bsync_ratio = ratio_counter;

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      bsync_buf <= 1'b1;
    end else begin
      if (calib_done) begin
        if (bsync_counter == (ratio_counter - 1) || bsync_counter == (ratio_counter * 2) - 1) begin
          bsync_buf <= !bsync_buf;
        end  
      end
    end
  end

  assign bsync_out = (curr_state == BSYNC_GEN && !disable_internal_bsync) ? bsync_buf : 1'b0;

  always @(posedge clk) begin
    direction_r <= direction_s;
    if (direction_s && !direction_r) begin
      dir_changed <= 1'b1;
    end else begin
      if (b_captured && bsync_edge) begin
        dir_changed <= 1'b0;
      end
    end  
  end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      bsync_alignment <= 'h000;
      bsync_next_alignment <= 'h000;
    end else begin
      if (curr_state == BSYNC_GEN && bsync_edge) begin
        if (dir_changed) begin
          bsync_alignment <= bsync_counter[4:0];
          bsync_next_alignment <= bsync_counter[4:0];
        end else begin
          bsync_next_alignment <= bsync_counter[4:0];
        end
      end
    end
  end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      bsync_misaligned <= 1'b0;
    end else begin
      if (bsync_alignment != bsync_next_alignment) begin
        bsync_misaligned <= 1'b1;
      end
    end
  end

  assign bsync_delay = ((ratio_counter * 2) - bsync_next_alignment);
  assign bsync_alignment_error = bsync_misaligned;
  assign bsync_captured = b_captured;
  assign bsync_state = curr_state;
  assign bsync_event = bsync_edge;

endmodule
