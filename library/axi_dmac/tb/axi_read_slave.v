
module axi_read_slave #(
  parameter DATA_WIDTH = 32,
  parameter READ_ACCEPTANCE = 4,
  parameter MIN_LATENCY = 48,
  parameter MAX_LATENCY = 48
) (
  input clk,
  input reset,

  input arvalid,
  output arready,
  input [31:0] araddr,
  input [7:0] arlen,
  input [2:0] arsize,
  input [1:0] arburst,
  input [2:0] arprot,
  input [3:0] arcache,

  output rvalid,
  input rready,
  output [DATA_WIDTH-1:0] rdata,
  output [1:0] rresp,
  output rlast
);

reg [DATA_WIDTH-1:0] data = 'h00;

assign rresp = 2'b00;
//assign rdata = data;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    data <= 'h00;
  end else if (rvalid == 1'b1 && rready == 1'b1) begin
    data <= data + 1'b1;
  end
end

axi_slave #(
  .ACCEPTANCE(READ_ACCEPTANCE),
  .MIN_LATENCY(MIN_LATENCY),
  .MAX_LATENCY(MAX_LATENCY)
) i_axi_slave (
  .clk(clk),
  .reset(reset),

  .valid(arvalid),
  .ready(arready),
  .addr(araddr),
  .len(arlen),
  .size(arsize),
  .burst(arburst),
  .prot(arprot),
  .cache(arcache),

  .beat_stb(rvalid),
  .beat_ack(rvalid & rready),
  .beat_last(rlast),
  .beat_addr(rdata)
);

endmodule
