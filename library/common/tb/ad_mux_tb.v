`timescale 1ns/100ps

module ad_mux_tb;
  parameter VCD_FILE = "ad_mux_tb.vcd";

  parameter CH_W = 16;   // Width of input channel
  parameter CH_CNT = 64;  // Number of input channels
  parameter REQ_MUX_SZ = 8;  // Size of mux which acts as a building block
  parameter EN_REG = 1;   // Enable register at output of each mux

  localparam MUX_SZ = CH_CNT < REQ_MUX_SZ ? CH_CNT : REQ_MUX_SZ;
  localparam NUM_STAGES = $clog2(CH_CNT) / $clog2(MUX_SZ) + |($clog2(CH_CNT) % $clog2(MUX_SZ));
  localparam DW = CH_W*CH_CNT;

  `include "tb_base.v"

  reg [CH_W*CH_CNT-1:0] data_in = 'h0;
  reg [$clog2(CH_CNT)-1:0] ch_sel = 'h0;
  wire [CH_W-1:0] data_out;

  ad_mux #(
    .CH_W(CH_W),
    .CH_CNT(CH_CNT),
    .REQ_MUX_SZ(REQ_MUX_SZ),
    .EN_REG(EN_REG)
  ) DUT (
    .clk(clk),
    .data_in(data_in),
    .ch_sel(ch_sel),
    .data_out(data_out)
  );

  wire [CH_W-1:0] ref_data;
  generate
  if (EN_REG) begin
    integer ii;
    reg [CH_W*CH_CNT-1:0] mux_pln [1:NUM_STAGES];
    always @(posedge clk) begin
      mux_pln[1] <= data_in >> ch_sel*CH_W;
      for (ii=2; ii<=NUM_STAGES; ii=ii+1) begin
        mux_pln[ii] <= mux_pln[ii-1];
      end
    end
    assign ref_data = mux_pln[NUM_STAGES];
  end else begin
    assign ref_data = data_in >> ch_sel*CH_W;
  end
  endgenerate

  integer i;
  initial begin
    for (i=0; i<CH_W*CH_CNT/8; i=i+1) begin
      data_in[i*8+:8] = i[7:0];
    end

    for (i=0; i<CH_CNT; i=i+1) begin
      @(posedge clk);
      ch_sel <= ch_sel + 1;
    end
  end

  wire mismatch;
  assign mismatch = ref_data !== data_out;

  always @(posedge clk) begin
    if (mismatch) begin
      failed <= 1'b1;
    end
  end

endmodule
