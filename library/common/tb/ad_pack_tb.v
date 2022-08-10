`timescale 1ns/100ps

module ad_pack_tb;
  parameter VCD_FILE = "ad_pack_tb.vcd";

  parameter I_W = 4;   // Width of input channel
  parameter O_W = 6;   // Width of output channel
  parameter UNIT_W = 8;
  parameter VECT_W = 1024*8;  // Multiple of 8

  `include "tb_base.v"

  reg [I_W*UNIT_W-1 : 0]  idata;
  wire [O_W*UNIT_W-1 : 0] odata;
  reg                     ivalid = 'b0;
  reg [VECT_W-1:0] input_vector;
  reg [VECT_W-1:0] output_vector;

  integer i=0;
  integer j=0;

  ad_pack #(
    .I_W(I_W),
    .O_W(O_W),
    .UNIT_W(UNIT_W)
  ) DUT (
    .clk(clk),
    .reset(reset),
    .idata(idata),
    .ivalid(ivalid),
    .odata(odata),
    .ovalid(ovalid));

  task test(input random_n);
  begin
    @(posedge clk);
    i = 0;
    j = 0;
    while (i < (VECT_W/(I_W*UNIT_W) + (VECT_W%(I_W*UNIT_W)>0))) begin
      @(posedge clk);
      if ($urandom % 2 == 0 | random_n) begin
        idata <= input_vector[i*(I_W*UNIT_W) +: (I_W*UNIT_W)];
        ivalid <= 1'b1;
        i = i + 1;
      end else begin
        idata <= 'bx;
        ivalid <= 1'b0;
      end
    end
    @(posedge clk);
    idata <= 'bx;
    ivalid <= 1'b0;

    // Check output vector
    repeat (20) @(posedge clk);
    for (i=0; i<(VECT_W/(O_W*UNIT_W))*(O_W*UNIT_W)/8; i=i+1) begin
      if (input_vector[i*8+:8] !== output_vector[i*8+:8]) begin
        failed <= 1'b1;
        $display("i=%d Expected=%x Found=%x",i,input_vector[i*8+:8],output_vector[i*8+:8]);
      end
    end
    // Clear output vector
    for (i=0; i<VECT_W/8; i=i+1) begin
      output_vector[i*8+:8] = 8'bx;
    end

  end
  endtask

  initial begin

    @(negedge reset);

    // Test with incremental data
    for (i=0; i<VECT_W/8; i=i+1) begin
      input_vector[i*8+:8] = i[7:0];
    end

    test(1);

    do_trigger_reset();
    @(negedge reset);

    test(0);

    do_trigger_reset();
    @(negedge reset);

    // Test with randomized data
    for (i=0; i<VECT_W/8; i=i+1) begin
      input_vector[i*8+:8] = $urandom;
    end

    test(0);

  end

  always @(posedge clk) begin
    if (ovalid) begin
      if (j < VECT_W/(O_W*UNIT_W)) begin
        output_vector[j*(O_W*UNIT_W) +: (O_W*UNIT_W)] = odata;
        j = j + 1;
      end
    end
  end

endmodule
