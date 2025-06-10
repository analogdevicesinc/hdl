//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Accumulator with set and overflow
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module tx_fsrc_sample_en_gen #(
  parameter ACCUM_WIDTH = 64,
  parameter NUM_SAMPLES = 8
)(
  input  wire                                     clk,
  input  wire                                     en,

  output logic [NUM_SAMPLES-1:0]                  sample_en,
  input  wire  [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0] set_val,
  input  wire                                     set,
  input  wire  [ACCUM_WIDTH-1:0]                  add_val
);

  genvar ii;

  for(ii=0; ii<NUM_SAMPLES; ii=ii+1) begin : accum_gen
    accum_set #(
      .WIDTH  (ACCUM_WIDTH)
    ) accum_set (
      .clk         (clk),
      .set_val     (set_val[ii]),
      .set         (set),
      .add_val     (add_val),
      .add         (en),
      .accum       (),
      .overflow    (sample_en[ii])
    );
end

endmodule

`default_nettype wire
