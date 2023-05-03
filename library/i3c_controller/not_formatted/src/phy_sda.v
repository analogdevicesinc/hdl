module phy_sda(
	output wire o_sdo,
	input  wire i_sdi,
	input  wire i_push_pull_en,
	inout  wire io_sda
	);

	assign io_sda = i_push_pull_en ? i_sdi : (i_sdi ? 1'bZ : 1'b0);
	assign o_sdo = io_sda;

endmodule
