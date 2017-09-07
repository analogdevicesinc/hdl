
module axi_write_slave #(
  parameter DATA_WIDTH = 32,
  parameter WRITE_ACCEPTANCE = 3
) (
  input clk,
  input reset,

  input awvalid,
  output awready,
  input [31:0] awaddr,
  input [7:0] awlen,
  input [2:0] awsize,
  input [1:0] awburst,
  input [2:0] awprot,
  input [3:0] awcache,

  input wvalid,
  output wready,
  input [DATA_WIDTH-1:0] wdata,
  input [DATA_WIDTH/8-1:0] wstrb,
  input wlast,

  output reg bvalid,
  input bready,
  output [1:0] bresp
);

wire beat_last;

axi_slave #(
  .ACCEPTANCE(WRITE_ACCEPTANCE)
) i_axi_slave (
  .clk(clk),
  .reset(reset),

  .valid(awvalid),
  .ready(awready),
  .addr(awaddr),
  .len(awlen),
  .size(awsize),
  .burst(awburst),
  .prot(awprot),
  .cache(awcache),

  .beat_stb(wready),
  .beat_ack(wvalid & wready),
  .beat_last(beat_last)
);

reg [4:0] resp_count = 'h00;
wire [4:0] resp_count_next;

assign bresp = 2'b00;

wire resp_count_dec = bvalid & bready == 1'b1 ? 1'b1 : 1'b0;
wire resp_count_inc = wvalid == 1'b1 && wready == 1'b1 && beat_last == 1'b1 ? 1'b1 : 1'b0;
assign resp_count_next = resp_count - resp_count_dec + resp_count_inc;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    resp_count <= 'h00;
  end else begin
    resp_count <= resp_count - resp_count_dec + resp_count_inc;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    bvalid <= 1'b0;
  end else if (bvalid == 1'b0 || bready == 1'b1) begin
    if (resp_count_next != 'h00) begin
      bvalid <= {$random} % 4 == 0;
    end else begin
      bvalid <= 1'b0;
    end
  end
end

endmodule
