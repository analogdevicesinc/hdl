/**
 * Divides input clock by 4, to match mod_bit.v timing
 */

`timescale 1ns / 1ps

module clk_quarter(
	input  wire i_reset,
	input  wire i_clk,
	output wire o_clk
	);

	reg [1:0] r_clk_div;
	always @(posedge i_clk) begin
		if (i_reset)
			r_clk_div <= 2'b00;
		else
			r_clk_div <= r_clk_div + 1;
	end

	assign o_clk = r_clk_div[1];
endmodule
