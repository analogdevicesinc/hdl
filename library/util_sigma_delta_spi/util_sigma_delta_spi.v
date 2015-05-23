
module util_sigma_delta_spi (
	input clk,
	input resetn,

	input spi_active,

	input s_sclk,
	input s_sdo,
	input s_sdo_t,
	output s_sdi,
	input [NUM_CS-1:0] s_cs,

	output m_sclk,
	output m_sdo,
	output m_sdo_t,
	input m_sdi,
	output [NUM_CS-1:0] m_cs,

	output reg data_ready
);

parameter NUM_CS = 1;
parameter CS_PIN = 0;
parameter IDLE_TIMEOUT = 63;

/*
 * For converters from the ADI SigmaDelta family the data ready interrupt signal
 * uses the same physical wire as the the DOUT signal for the SPI bus. This
 * module extracts the data ready signal from the SPI bus and makes sure to
 * suppress false positives. The data ready signal is indicated by the converter
 * by pulling DOUT low. This will only happen if the CS pin for the converter is
 * low and no SPI transfer is active. There is a small delay between the end of
 * the SPI transfer and the point where the converter starts to indicate the
 * data ready signal. IDLE_TIMEOUT allows to specify the amount of clock cycles
 * the bus needs to be idle before the data ready signal is detected.
 */

assign m_sclk = s_sclk;
assign m_sdo = s_sdo;
assign m_sdo_t = s_sdo_t;
assign s_sdi = m_sdi;
assign m_cs = s_cs;

reg [$clog2(IDLE_TIMEOUT)-1:0] counter = IDLE_TIMEOUT;
reg [2:0] sdi_d = 'h00;

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		counter <= IDLE_TIMEOUT;
	end else begin
		if (s_cs[CS_PIN] == 1'b0 && spi_active == 1'b0) begin
			if (counter != 'h00)
				counter <= counter - 1'b1;
		end else begin
			counter <= IDLE_TIMEOUT;
		end
	end
end

always @(posedge clk) begin
	/* The data ready signal is fully asynchronous */
	sdi_d <= {sdi_d[1:0], m_sdi};
end

always @(posedge clk) begin
	if (counter == 'h00 && sdi_d[2] == 1'b0) begin
		data_ready <= 1'b1;
	end else begin
		data_ready <= 1'b0;
	end
end

endmodule
