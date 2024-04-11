module async_cdc_fifo #(
  parameter DATA_WIDTH = 32,
  parameter CLK_DIV = 20,
  parameter FIFO_DEPTH = (CLK_DIV <= 2) ? 4 : 2 ** $clog2(CLK_DIV)
) (
  input wire wr_clk,
  input wire rd_clk,
  input wire rstn,
  input wire [DATA_WIDTH-1:0] wr_data,
  input wire wr_en,
  input wire rd_en,
  output reg [DATA_WIDTH-1:0] rd_data,
  output wire fifo_full,
  output wire fifo_empty,
  output wire rd_data_valid
);

localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);

reg [DATA_WIDTH-1:0] fifo[FIFO_DEPTH-1:0];
reg [ADDR_WIDTH-0:0] wr_ptr_gray = 0, rd_ptr_gray = 0;
reg [ADDR_WIDTH-0:0] wr_ptr_bin = 0, rd_ptr_bin = 0;
reg                  rd_data_valid_s = 0;

function [ADDR_WIDTH:0] bin2gray (input [ADDR_WIDTH:0] binary);
  bin2gray = binary ^ (binary >> 1);
endfunction

function [ADDR_WIDTH:0] gray2bin (input [ADDR_WIDTH:0] gray);
integer i;
begin
  gray2bin = gray;
  for (i = 1; i <= ADDR_WIDTH; i = i + 1) begin
    gray2bin = gray2bin ^ (gray >> i);
  end
end
endfunction

always @(posedge wr_clk) begin
  if (!rstn) begin
    wr_ptr_gray <= 0;
    wr_ptr_bin <= 0;
  end else if (wr_en && !fifo_full) begin
    fifo[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
    wr_ptr_bin <= wr_ptr_bin + 1;
    wr_ptr_gray <= bin2gray(wr_ptr_bin + 1);
  end
end

always @(posedge rd_clk) begin
  if (!rstn) begin
    rd_ptr_gray <= 0;
    rd_ptr_bin <= 0;
    rd_data_valid_s <= 0;
  end else if (rd_en && !fifo_empty) begin
    rd_data_valid_s <= 1;
    rd_data <= fifo[rd_ptr_bin[ADDR_WIDTH-1:0]];
    rd_ptr_bin <= rd_ptr_bin + 1;
    rd_ptr_gray <= bin2gray(rd_ptr_bin + 1);
  end else begin
    rd_data_valid_s <= 0;
  end
end

assign fifo_full = (bin2gray(wr_ptr_bin + 1) == {~rd_ptr_gray[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray[ADDR_WIDTH-2:0]});
assign fifo_empty = (wr_ptr_gray == rd_ptr_gray);
assign rd_data_valid = rd_data_valid_s;

endmodule
