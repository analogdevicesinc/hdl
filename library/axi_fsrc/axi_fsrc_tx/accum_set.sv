//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Accumulator with set and overflow
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module accum_set #(
  parameter WIDTH = 32
)(
  input  wire               clk,

  input  wire  [WIDTH-1:0]  set_val,
  input  wire               set,
  
  input  wire  [WIDTH-1:0]  add_val,
  input  wire               add,

  output logic [WIDTH-1:0]  accum,
  output logic              overflow
);

  always_ff @(posedge clk) begin
    if(set) begin
      accum <= set_val;
      overflow <= 1'b0;
    end else if(add) begin
      {overflow, accum} <= accum + add_val;
    end
  end

endmodule

`default_nettype wire
