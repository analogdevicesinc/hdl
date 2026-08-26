// Stub for Xilinx IOBUFDS_DCIEN (Verilator-safe, ASCII only).
//
// Xilinx polarity: T=0 = output enabled (drives IO/IOB from I)
//                  T=1 = tristate / input mode (O reads from IO)
//
// axi_adf4030 instantiates this with T=direction (1=TX, 0=RX),
// IBUFDISABLE=!direction.  Match that convention for simulation:
//   direction=1 (master TX): T=1, drives bus from I
//   direction=0 (slave  RX): T=0, tristate, O reads bus
`timescale 1ns/1ps

module IOBUFDS_DCIEN #(
  parameter SIM_DEVICE      = "ULTRASCALE",
  parameter USE_IBUFDISABLE = "TRUE"
) (
  output logic O,
  input  logic I,
  input  logic IBUFDISABLE,
  input  logic DCITERMDISABLE,
  inout  wire  IO,
  inout  wire  IOB,
  input  logic T
);
  assign IO  = T ? I  : 1'bz;
  assign IOB = T ? ~I : 1'bz;
  assign O   = (USE_IBUFDISABLE == "TRUE" && IBUFDISABLE) ? 1'b0 : IO;

endmodule
