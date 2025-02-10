module ramp(
    input         clk,
    input         rst,
    input         ready,
    output [63:0] data_out,
    output        data_valid
);

reg [63:0] data_ramp = 0;
reg data_ramp_valid = 0;

assign data_out   = data_ramp;
assign data_valid = data_ramp_valid;

// ramp generator
always @(posedge clk) begin
    if (rst) begin
        data_ramp       <= 0;
        data_ramp_valid <= 1'b0;
    end else begin
        if (data_ramp == 64'd8999) begin
            data_ramp       <= 0;
        end else begin
            if (ready) begin
                data_ramp   <= data_ramp + 1'b1;
            end
        end
        data_ramp_valid <= 1'b1;   
    end
  end

endmodule