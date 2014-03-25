
module util_sync_reset (
	input async_resetn,
	input clk,
	output sync_resetn
);

// Keep it asserted for three clock cycles
reg [2:0] resetn = 3'b000;

assign sync_resetn = resetn[2];

always @(posedge clk or negedge async_resetn) begin
	if (async_resetn == 1'b0) begin
		resetn <= 3'b000;
	end else begin
		resetn <= {resetn[1:0], 1'b1};
	end

end

endmodule
