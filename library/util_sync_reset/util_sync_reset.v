

module util_sync_reset (
	input async_resetn,
	input clk,
	output sync_resetn
);

// Keep it asserted for three clock cycles
reg [2:0] reset = 3'b111;

assign sync_resetn = reset[2];

always @(posedge clk or negedge async_resetn) begin
	if (async_resetn == 1'b0) begin
		reset <= 3'b111;
	end else begin
		reset <= {reset[1:0], 1'b0};
	end

end

endmodule
