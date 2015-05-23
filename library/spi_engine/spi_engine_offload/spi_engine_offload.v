
module spi_engine_offload (
	input ctrl_clk,

	input ctrl_cmd_wr_en,
	input [15:0] ctrl_cmd_wr_data,

	input ctrl_sdo_wr_en,
	input [7:0] ctrl_sdo_wr_data,

	input ctrl_enable,
	output ctrl_enabled,
	input ctrl_mem_reset,

	input spi_clk,
	input spi_resetn,

	input trigger,

	output cmd_valid,
	input cmd_ready,
	output [15:0] cmd,

	output sdo_data_valid,
	input sdo_data_ready,
	output [7:0] sdo_data,

	input sdi_data_valid,
	output sdi_data_ready,
	input [7:0] sdi_data,

	input sync_valid,
	output sync_ready,
	input [7:0] sync_data,

	output offload_sdi_valid,
	input offload_sdi_ready,
	output [7:0] offload_sdi_data
);

parameter SPI_CLK_ASYNC = 0;
parameter CMD_MEM_ADDR_WIDTH = 4;
parameter SDO_MEM_ADDR_WIDTH = 4;

reg spi_active = 1'b0;

reg [CMD_MEM_ADDR_WIDTH-1:0] ctrl_cmd_wr_addr = 'h00;
reg [CMD_MEM_ADDR_WIDTH-1:0] spi_cmd_rd_addr = 'h00;
reg [SDO_MEM_ADDR_WIDTH-1:0] ctrl_sdo_wr_addr = 'h00;
reg [SDO_MEM_ADDR_WIDTH-1:0] spi_sdo_rd_addr = 'h00;

reg [15:0] cmd_mem[0:2**CMD_MEM_ADDR_WIDTH-1];
reg [7:0] sdo_mem[0:2**SDO_MEM_ADDR_WIDTH-1];

wire [CMD_MEM_ADDR_WIDTH-1:0] spi_cmd_rd_addr_next;
wire spi_enable;

assign cmd_valid = spi_active;
assign sdo_data_valid = spi_active;
assign sync_ready = 1'b1;

assign offload_sdi_valid = sdi_data_valid;
assign sdi_data_ready = offload_sdi_ready;
assign offload_sdi_data = sdi_data;

assign cmd = cmd_mem[spi_cmd_rd_addr];
assign sdo_data = sdo_mem[spi_sdo_rd_addr];

generate if (SPI_CLK_ASYNC) begin

/*
 * The synchronization circuit takes care that there are no glitches on the
 * ctrl_enabled signal. ctrl_do_enable is asserted whenever ctrl_enable is
 * asserted, but only deasserted once the signal has been synchronized back from
 * the SPI domain. This makes sure that we can't end up in a state where the
 * enable signal in the SPI domain is asserted, but neither enable nor enabled
 * is asserted in the control domain.
 */

reg ctrl_do_enable = 1'b0;
wire ctrl_is_enabled;
reg spi_enabled = 1'b0;

always @(posedge ctrl_clk) begin
	if (ctrl_enable == 1'b1) begin
		ctrl_do_enable <= 1'b1;
	end else if (ctrl_is_enabled == 1'b1) begin
		ctrl_do_enable <= 1'b0;
	end
end

assign ctrl_enabled = ctrl_is_enabled | ctrl_do_enable;

always @(posedge spi_clk) begin
	spi_enabled <= spi_enable | spi_active;	
end

sync_bits # (
    .NUM_BITS(1),
    .CLK_ASYNC(1)
) i_sync_enable (
    .in(ctrl_do_enable),
    .out_clk(spi_clk),
    .out_resetn(1'b1),
    .out(spi_enable)
);

sync_bits # (
    .NUM_BITS(1),
    .CLK_ASYNC(1)
) i_sync_enabled (
    .in(spi_enabled),
    .out_clk(ctrl_clk),
    .out_resetn(1'b1),
    .out(ctrl_is_enabled)
);

end else begin
assign spi_enable = ctrl_enable;
assign ctrl_enabled = spi_enable | spi_active;
end endgenerate

assign spi_cmd_rd_addr_next = spi_cmd_rd_addr + 1;

always @(posedge spi_clk) begin
	if (spi_resetn == 1'b0) begin
		spi_active <= 1'b0;
	end else begin
		if (spi_active == 1'b0) begin
			if (trigger == 1'b1 && spi_enable == 1'b1)
				spi_active <= 1'b1;
		end else if (cmd_ready == 1'b1 && spi_cmd_rd_addr_next == ctrl_cmd_wr_addr) begin
			spi_active <= 1'b0;
		end
	end
end

always @(posedge spi_clk) begin
	if (cmd_valid == 1'b0) begin
		spi_cmd_rd_addr <= 'h00;
	end else if (cmd_ready == 1'b1) begin
		spi_cmd_rd_addr <= spi_cmd_rd_addr_next;
	end
end

always @(posedge spi_clk) begin
	if (spi_active == 1'b0) begin
		spi_sdo_rd_addr <= 'h00;
	end else if (sdo_data_ready == 1'b1) begin
		spi_sdo_rd_addr <= spi_sdo_rd_addr + 1'b1;
	end
end

always @(posedge ctrl_clk) begin
	if (ctrl_mem_reset == 1'b1)
		ctrl_cmd_wr_addr <= 'h00;
	else if (ctrl_cmd_wr_en == 1'b1)
		ctrl_cmd_wr_addr <= ctrl_cmd_wr_addr + 1'b1;
end

always @(posedge ctrl_clk) begin
	if (ctrl_cmd_wr_en == 1'b1)
		cmd_mem[ctrl_cmd_wr_addr] <= ctrl_cmd_wr_data;
end

always @(posedge ctrl_clk) begin
	if (ctrl_mem_reset == 1'b1)
		ctrl_sdo_wr_addr <= 'h00;
	else if (ctrl_sdo_wr_en == 1'b1)
		ctrl_sdo_wr_addr <= ctrl_sdo_wr_addr + 1'b1;
end

always @(posedge ctrl_clk) begin
	if (ctrl_sdo_wr_en == 1'b1)
		sdo_mem[ctrl_sdo_wr_addr] <= ctrl_sdo_wr_data;
end

endmodule
