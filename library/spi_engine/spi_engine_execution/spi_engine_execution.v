
module spi_engine_execution (
	input clk,
	input resetn,

	output reg active,

	output cmd_ready,
	input cmd_valid,
	input [15:0] cmd,

	input sdo_data_valid,
	output reg sdo_data_ready,
	input [7:0] sdo_data,

	input sdi_data_ready,
	output reg sdi_data_valid,
	output [7:0] sdi_data,

	input sync_ready,
	output reg sync_valid,
	output [7:0] sync,

	output reg sclk,
	output sdo,
	output reg sdo_t,
	input sdi,
	output reg [NUM_CS-1:0] cs,
	output reg three_wire
);

parameter NUM_CS = 1;
parameter DEFAULT_SPI_CFG = 0;
parameter DEFAULT_CLK_DIV = 0;

localparam CMD_TRANSFER	= 2'b00;
localparam CMD_CHIPSELECT = 2'b01;
localparam CMD_WRITE = 2'b10;
localparam CMD_MISC = 2'b11;

localparam MISC_SYNC = 1'b0;
localparam MISC_SLEEP = 1'b1;

localparam REG_CLK_DIV = 1'b0;
localparam REG_CONFIG = 1'b1;

reg idle;

reg [7:0] clk_div_counter = 'h00;
reg [7:0] clk_div_counter_next = 'h00;
reg clk_div_last;

reg [11:0] counter = 'h00;

wire [7:0] sleep_counter = counter[11:4];
wire [1:0] cs_sleep_counter = counter[5:4];
wire [2:0] cs_sleep_counter2 = counter[6:4];
wire [2:0] bit_counter = counter[3:1];
wire [7:0] transfer_counter = counter[11:4];
wire ntx_rx = counter[0];

reg trigger = 1'b0;
reg trigger_next = 1'b0;
reg wait_for_io = 1'b0;
reg transfer_active = 1'b0;

wire last_bit;
wire first_bit;
reg last_transfer;
wire end_of_word;

assign first_bit = bit_counter == 'h0;
assign last_bit = bit_counter == 'h7;
assign end_of_word = last_bit == 1'b1 && ntx_rx == 1'b1 && clk_div_last == 1'b1;

reg [15:0] cmd_d1;

reg cpha = DEFAULT_SPI_CFG[0];
reg cpol = DEFAULT_SPI_CFG[1];
reg [7:0] clk_div = DEFAULT_CLK_DIV;

wire sdo_enabled = cmd_d1[8];
wire sdi_enabled = cmd_d1[9];

reg [8:0] data_shift = 'h0;

wire [1:0] inst = cmd[13:12];
wire [1:0] inst_d1 = cmd_d1[13:12];

wire exec_cmd = cmd_ready && cmd_valid;
wire exec_transfer_cmd = exec_cmd && inst == CMD_TRANSFER;
wire exec_write_cmd = exec_cmd && inst == CMD_WRITE;
wire exec_chipselect_cmd = exec_cmd && inst == CMD_CHIPSELECT;
wire exec_misc_cmd = exec_cmd && inst == CMD_MISC;
wire exec_sync_cmd = exec_misc_cmd && cmd[8] == MISC_SYNC;

assign cmd_ready = idle;

always @(posedge clk) begin
	if (cmd_ready)
		cmd_d1 <= cmd;
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		active <= 1'b0;
	end else begin
		if (exec_cmd == 1'b1)
			active <= 1'b1;
		else if (sync_ready == 1'b1 && sync_valid == 1'b1)
			active <= 1'b0;
	end
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		cpha <= DEFAULT_SPI_CFG[0];
		cpol <= DEFAULT_SPI_CFG[1];
		three_wire <= DEFAULT_SPI_CFG[2];
		clk_div <= DEFAULT_CLK_DIV;
	end else if (exec_write_cmd == 1'b1) begin
		 if (cmd[8] == REG_CONFIG) begin
			cpha <= cmd[0];
			cpol <= cmd[1];
			three_wire <= cmd[2];
		end else if (cmd[8] == REG_CLK_DIV) begin
			clk_div <= cmd[7:0];
		end
	end
end

always @(posedge clk) begin
	if ((clk_div_last == 1'b0 && idle == 1'b0 && wait_for_io == 1'b0 &&
		clk_div_counter == 'h01) || clk_div == 'h00)
		clk_div_last <= 1'b1;
	else
		clk_div_last <= 1'b0;
end

always @(posedge clk) begin
	if (clk_div_last == 1'b1 || idle == 1'b1 || wait_for_io == 1'b1) begin
		clk_div_counter <= clk_div;
		trigger <= 1'b1;
	end else begin
		clk_div_counter <= clk_div_counter - 1'b1;
		trigger <= 1'b0;
	end
end

wire trigger_tx = trigger == 1'b1 && ntx_rx == 1'b0;
wire trigger_rx = trigger == 1'b1 && ntx_rx == 1'b1;

wire sleep_counter_compare = sleep_counter == cmd_d1[7:0] && clk_div_last == 1'b1;
wire cs_sleep_counter_compare = cs_sleep_counter == cmd_d1[9:8] && clk_div_last == 1'b1;
wire cs_sleep_counter_compare2 = cs_sleep_counter2 == {cmd_d1[9:8],1'b1} && clk_div_last == 1'b1;

always @(posedge clk) begin
	if (idle == 1'b1)
		counter <= 'h00;
	else if (clk_div_last == 1'b1 && wait_for_io == 1'b0)
		counter <= counter + (transfer_active ? 'h1 : 'h10);
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		idle <= 1'b1;
	end else begin
		if (exec_transfer_cmd || exec_chipselect_cmd || exec_misc_cmd) begin
			idle <= 1'b0;
		end else begin
			case (inst_d1)
			CMD_TRANSFER: begin
				if (transfer_active == 1'b0 && wait_for_io == 1'b0)
					idle <= 1'b1;
			end
			CMD_CHIPSELECT: begin
				if (cs_sleep_counter_compare2)
					idle <= 1'b1;
			end
			CMD_MISC: begin
				case (cmd_d1[8])
				MISC_SLEEP: begin
					if (sleep_counter_compare)
						idle <= 1'b1;
				end
				MISC_SYNC: begin
					if (sync_ready)
						idle <= 1'b1;
				end
				endcase
			end
			endcase
		end
	end
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		cs <= 'hff;
	end else if (inst_d1 == CMD_CHIPSELECT && cs_sleep_counter_compare == 1'b1) begin
		cs <= cmd_d1[NUM_CS-1:0];
	end
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		sync_valid <= 1'b0;
	end else begin
		if (exec_sync_cmd == 1'b1) begin
			sync_valid <= 1'b1;
		end else if (sync_ready == 1'b1) begin
			sync_valid <= 1'b0;
		end
	end
end

assign sync = cmd_d1[7:0];

always @(posedge clk) begin
	if (resetn == 1'b0)
		sdo_data_ready <= 1'b0;
	else if (sdo_enabled == 1'b1 && first_bit == 1'b1 && trigger_tx == 1'b1 &&
		transfer_active == 1'b1)
		sdo_data_ready <= 1'b1;
	else if (sdo_data_valid == 1'b1)
		sdo_data_ready <= 1'b0;
end

always @(posedge clk) begin
	if (resetn == 1'b0)
		sdi_data_valid <= 1'b0;
	else if (sdi_enabled == 1'b1 && last_bit == 1'b1 && trigger_rx == 1'b1 &&
		transfer_active == 1'b1)
		sdi_data_valid <= 1'b1;
	else if (sdi_data_ready == 1'b1)
		sdi_data_valid <= 1'b0;
end

wire io_ready1 = (sdi_data_valid == 1'b0 || sdi_data_ready == 1'b1) &&
	(sdo_enabled == 1'b0 || last_transfer == 1'b1 || sdo_data_valid == 1'b1);
wire io_ready2 = (sdi_enabled == 1'b0 || sdi_data_ready == 1'b1) &&
	(sdo_enabled == 1'b0 || last_transfer == 1'b1 || sdo_data_valid == 1'b1);

always @(posedge clk) begin
	if (idle == 1'b1) begin
		last_transfer <= 1'b0;
	end else if (trigger_tx == 1'b1 && transfer_active == 1'b1) begin
		if (transfer_counter == cmd_d1[7:0])
			last_transfer <= 1'b1;
		else
			last_transfer <= 1'b0;
	end
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		transfer_active <= 1'b0;
		wait_for_io <= 1'b0;
	end else begin
		if (exec_transfer_cmd == 1'b1) begin
			wait_for_io <= 1'b1;
			transfer_active <= 1'b0;
		end else if (wait_for_io == 1'b1 && io_ready1 == 1'b1) begin
			wait_for_io <= 1'b0;
			if (last_transfer == 1'b0)
				transfer_active <= 1'b1;
			else
				transfer_active <= 1'b0;
		end else if (transfer_active == 1'b1 && end_of_word == 1'b1) begin
			if (last_transfer == 1'b1 || io_ready2 == 1'b0)
				transfer_active <= 1'b0;
			if (io_ready2 == 1'b0)
				wait_for_io <= 1'b1;
		end
	end
end

always @(posedge clk) begin
	if (transfer_active == 1'b1 || wait_for_io == 1'b1)
	begin
		sdo_t <= ~sdo_enabled;
	end else begin
		sdo_t <= 1'b1;
	end
end

always @(posedge clk) begin
	if (transfer_active == 1'b1 && trigger_tx == 1'b1) begin
		if (first_bit == 1'b1)
			data_shift[8:1] <= sdo_data;
		else
			data_shift[8:1] <= data_shift[7:0];
	end
end

assign sdo = data_shift[8];
assign sdi_data = data_shift[7:0];

always @(posedge clk) begin
	if (trigger_rx == 1'b1) begin
		data_shift[0] <= sdi;
	end
end

always @(posedge clk) begin
	if (transfer_active == 1'b1) begin
		sclk <= cpol ^ cpha ^ ntx_rx;
	end else begin
		sclk <= cpol;
	end
end

endmodule
