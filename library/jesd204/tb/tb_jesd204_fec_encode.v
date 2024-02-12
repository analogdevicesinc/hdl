`timescale 1ns / 100ps
`default_nettype none

module tb_jesd204_fec_encode;

  localparam FEC_WIDTH = 26;
  localparam DATA_WIDTH = 64;

  // localparam INPUT_DATA_WIDTH = 64;
  // localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = 64'h8001020305050423;
  localparam INPUT_DATA_WIDTH = 2048;
  localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = {1'b1, 2047'b0};

  logic [INPUT_DATA_WIDTH-1:0]    DATA_VALUE_REVERSED;
  logic [DATA_WIDTH-1:0]          data;

  logic [FEC_WIDTH-1:0]           fec;
  reg                             clk = 1'b0;
  logic                           rst;
  logic                           shift_en;
  logic [DATA_WIDTH-1:0]          data_in;

  int                             data_in_cnt;
  int ii;

  always #5 clk = ~clk;

  initial begin
    // Shift data in MSb-first by reversing the data
    for(ii = 0; ii < INPUT_DATA_WIDTH; ii = ii + 1) begin
      DATA_VALUE_REVERSED[ii] = DATA_VALUE[INPUT_DATA_WIDTH-1-ii];
    end
    rst = 1'b1;
    #100ns;
    rst = 1'b0;
  end

  always_ff @(posedge clk) begin
    if(rst) begin
      shift_en <= 1'b0;
      data <= DATA_VALUE_REVERSED;
      data_in_cnt <= '0;
    end else begin
      if(data_in_cnt < INPUT_DATA_WIDTH) begin
        data_in <= data[0+:DATA_WIDTH];
        data <= data >> DATA_WIDTH;
        shift_en <= 1'b1;
        data_in_cnt <= data_in_cnt + DATA_WIDTH;
      end else begin
        shift_en <= 1'b0;
      end
    end
  end

  jesd204_fec_encode #(
    .DATA_WIDTH     (DATA_WIDTH)
  ) jesd204_fec_encode (
    .fec         (fec),
    .clk         (clk),
    .rst         (rst),
    .shift_en    (shift_en),
    .data_in     (data_in)
  );

endmodule

`default_nettype wire
