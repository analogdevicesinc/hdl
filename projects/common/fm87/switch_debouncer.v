//                       Open             Bouncing    Closed
// Signal from switch  11111111111111111???????????000000000000
// After synchonizer   1111111111111111100100101100000000000000
// Sampled (s)         s--------s--------s--------s--------s
// Output                1111111111111111110000000000000000000

`timescale 1ns/100ps

module switch_debouncer (
  input      clk,
  input      reset_n,
  input      data_in,
  output reg data_out
);
localparam counter_max = 100000;
localparam ctr_width  =  21;

reg [3:0] data_in_;
reg [ctr_width-1:0]  counter;

always @(posedge clk or negedge reset_n) begin
  if  (!reset_n) begin
    data_out <=  0;
    counter  <=  counter_max;
    data_in_ <= 4'd0;
  end else begin
    if  (counter == 0) begin
      data_out <=  data_in_[3];
      counter  <=  counter_max;
    end else begin
      counter  <=  counter - 1'b1;
    end
    data_in_  <=  {data_in_[2:0], data_in};
  end
end

endmodule
