//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Simple dual-port distributed RAM with non-registered output
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module dual_port_dist_ram #(
  parameter RAM_WIDTH = 32,
  parameter RAM_ADDR_BITS = 4
)(
  output wire  [RAM_WIDTH-1:0]      rd_data,
  input  wire                       clk,
  input  wire                       wr_en,
  input  wire  [RAM_ADDR_BITS-1:0]  wr_addr,
  input  wire  [RAM_WIDTH-1:0]      wr_data,
  input  wire  [RAM_ADDR_BITS-1:0]  rd_addr
);

  (* ram_style="distributed" *)
  reg [RAM_WIDTH-1:0] ram [(2**RAM_ADDR_BITS)-1:0];

  always @(posedge clk)
    if (wr_en)
      ram[wr_addr] <= wr_data;

  assign rd_data = ram[rd_addr];

endmodule

`default_nettype wire
