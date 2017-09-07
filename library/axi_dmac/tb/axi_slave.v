
module axi_slave #(
  parameter ACCEPTANCE = 3,
  parameter MIN_LATENCY = 16,
  parameter MAX_LATENCY = 32
) (
  input clk,
  input reset,

  input valid,
  output ready,
  input [31:0] addr,
  input [7:0] len,
  input [2:0] size,
  input [1:0] burst,
  input [2:0] prot,
  input [3:0] cache,

  output beat_stb,
  input beat_ack,
  output [31:0] beat_addr,
  output beat_last
);

reg [31:0] timestamp = 'h00;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    timestamp <= 'h00;
  end else begin
    timestamp <= timestamp + 1'b1;
  end
end

reg [32+32+8-1:0] req_fifo[0:15];
reg [3:0] req_fifo_rd = 'h00;
reg [3:0] req_fifo_wr = 'h00;
wire [3:0] req_fifo_level = req_fifo_wr - req_fifo_rd;

assign ready = req_fifo_level < ACCEPTANCE;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    req_fifo_wr <= 'h00;
  end else begin
    if (valid == 1'b1 && ready == 1'b1) begin
      req_fifo[req_fifo_wr][71:40] <= timestamp + {$random} % (MAX_LATENCY - MIN_LATENCY + 1) + MIN_LATENCY;
      req_fifo[req_fifo_wr][39:0] <= {addr,len};
      req_fifo_wr <= req_fifo_wr + 1'b1;
    end
  end
end

reg [7:0] beat_counter = 'h00;

assign beat_stb = req_fifo_level != 0 && timestamp > req_fifo[req_fifo_rd][71:40];
assign beat_last = beat_stb ? beat_counter == req_fifo[req_fifo_rd][0+:8] : 1'b0;
assign beat_addr = req_fifo[req_fifo_rd][8+:32] + beat_counter * 4;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    beat_counter <= 'h00;
    req_fifo_rd <= 'h00;
  end else begin
    if (beat_ack == 1'b1) begin
      if (beat_last == 1'b1) begin
        beat_counter <= 'h00;
        req_fifo_rd <= req_fifo_rd + 1'b1;
      end else begin
        beat_counter <= beat_counter + 1'b1;
      end
    end
  end
end

endmodule
