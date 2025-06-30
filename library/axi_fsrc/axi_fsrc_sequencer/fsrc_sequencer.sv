
//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Controls sequence for TX FSRC.
// Sequence:
//  User sets next_ctrl_value, first_trig_cnt
//  User asserts start
//  data_start_0 asserted
//  Counter start at 0, increments when sysref_int is asserted
//  When counter equals ctrl_change_cnt, set ctrl = next_ctrl_value
//  When counter equals first_trig_cnt, pulse trig
//  When counter equals accum_reset_cnt, data_start_0 deasserted
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ps / 1ps
`default_nettype none

module fsrc_sequencer #(
  parameter CTRL_WIDTH = 40,
  parameter COUNTER_WIDTH = 4,
  parameter NUM_TRIG = 4
)(
  input  wire                                      clk,
  input  wire                                      reset,
  input  wire                                      sysref_int,
  input  wire                                      reg_start,            // Regmap alternative start
  input  wire [CTRL_WIDTH-1:0]                     next_ctrl_value,      // Set before start is asserted, hold the value until ctrl value is changed
  input  wire [COUNTER_WIDTH-1:0]                  ctrl_change_cnt,
  input  wire [NUM_TRIG-1:0] [COUNTER_WIDTH-1:0]   first_trig_cnt,
  input  wire [COUNTER_WIDTH-1:0]                  accum_reset_cnt,  // -> data_start_0    // Must be greater than first_trig_cnt
  input  wire                                      seq_trig_in,
  input  wire                                      ext_trig_en,

  output logic [NUM_TRIG-1:0]                      trig_out, // first
  output logic                                     data_start_0
);

  localparam TRIG_PULSE_WIDTH = 4;

  logic                                         sysref_int_d;
  logic                                         count_en;
  logic [NUM_TRIG-1:0]                          trig_pulse;
  logic [NUM_TRIG-1:0] [TRIG_PULSE_WIDTH-1:0]   trig_shift;
  logic [COUNTER_WIDTH-1:0]                     count; // -> data_start_0 ; trig_out
  logic                                         seq_trig_in_d;
  logic                                         seq_trig_re;
  logic                                         trig_start_pulse;
  logic                                         trig_start;


  always_ff @(posedge clk) begin
    if(reset) begin
      sysref_int_d <= 1'b0;
    end else begin
      sysref_int_d <= sysref_int;
    end
  end

  // Posedge detect for seq_trig_in
  always_ff @(posedge clk) begin
      seq_trig_in_d <= seq_trig_in;
  end

  assign seq_trig_re = seq_trig_in & ~seq_trig_in_d;

  assign trig_start_pulse = (ext_trig_en & seq_trig_re) | reg_start;

  pulse_sync trig_start_sync(
      .dout        (trig_start),
      .inclk       (clk),
      .rst_inclk   (reset),
      .outclk      (sysref_int),
      .rst_outclk  (reset),
      .din         (trig_start_pulse)
   );

  // Counter and count enable for data_start_0 and trigs
  always_ff @(posedge clk) begin
    if (reset) begin
      count_en <= 1'b0;
      count <= '0;
    end else begin
      if (trig_start) begin
        count_en <= 1'b1;
        count <= '0;
      end else if (count_en) begin
        // Disable counter when it reaches accum_reset_cnt
        if (count == accum_reset_cnt) begin
          count_en <= 1'b0;
          count <= '0;
        end
        if (sysref_int) begin
          count <= count + 1'b1;
        end
      end
    end
  end

  // Pulse data_start_0 when count equals accum_reset_cnt
  always_ff @(posedge clk) begin
    if (reset) begin
      data_start_0 <= 1'b0;
    end else begin
      data_start_0 <= 1'b0;
      if (accum_reset_cnt == 0) begin
        data_start_0 <= 1'b1;
      end else if (sysref_int_d && (count == accum_reset_cnt)) begin
        data_start_0 <= 1'b1;
      end
    end
  end

  genvar ii;
  for (ii=0; ii<NUM_TRIG; ii=ii+1) begin

   // Pulse trigger when count equals first_trig_cnt
   always_ff @(posedge clk) begin
      if(reset) begin
         trig_pulse[ii] <= 1'b0;
      end else begin
         trig_pulse[ii] <= 1'b0;
         if (sysref_int_d && ((count == first_trig_cnt[ii]))) begin
         trig_pulse[ii] <= 1'b1;
         end
      end
   end

   // Stretch trig pulse to TRIG_PULSE_WIDTH cycles
   always_ff @(posedge clk) begin
      if (reset) begin
         trig_shift[ii] <= '0;
      end else begin
         trig_shift[ii] <= {trig_shift[ii][TRIG_PULSE_WIDTH-2:0], trig_pulse[ii]};
      end
   end

   // Trigger output
   always_ff @(posedge clk) begin
      if(reset) begin
         trig_out[ii] <= 1'b0;
      end else begin
         trig_out[ii] <= |trig_shift[ii];
      end
   end

  end

endmodule

`default_nettype wire
