module rx_gearbox_64b66b #(
  parameter SIZE = 4,
  parameter I_WIDTH = 64,
  parameter O_WIDTH = 66
) (
  input i_clk,
  input [I_WIDTH-1:0] i_data,
  input i_reset,

  input o_clk,
  output reg [O_WIDTH-1:0] o_data,
  output o_valid
);

localparam ADDR_WIDTH = $clog2(SIZE);


reg [O_WIDTH-1:0] mem[0:SIZE - 1];
reg [ADDR_WIDTH:0] wr_addr = 'h00;
reg [ADDR_WIDTH:0] rd_addr = 'h00;

wire mem_wr;
wire [O_WIDTH-1:0] mem_wr_data;
wire o_ready;

ad_pack #(
  .I_W(I_WIDTH),
  .O_W(O_WIDTH),
  .UNIT_W(1)
) i_ad_pack (
  .clk(i_clk),
  .reset(i_reset),
  .idata(i_data),
  .ivalid(1'b1),

  .odata(mem_wr_data),
  .ovalid(mem_wr)
);

always @(posedge i_clk) begin
  if (i_reset) begin
    wr_addr <= 'h00;
  end else if (mem_wr) begin
    mem[wr_addr] <= mem_wr_data;
    wr_addr <= wr_addr + 1'b1;
  end
end

sync_bits i_sync_ready (
  .in_bits(i_reset),
  .out_resetn(1'b0),
  .out_clk(o_clk),
  .out_bits(o_ready)
);

always @(posedge o_clk) begin
  if (o_ready == 1'b0) begin
    rd_addr <= 'h00;
    o_valid <= 1'b0;
  end else begin
    rd_addr <= rd_addr + 1'b1;
    o_data <= mem[rd_addr];
    o_valid <= 1'b1;
  end
end

endmodule
