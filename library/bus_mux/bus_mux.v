module bus_mux(
    input         sel,
    input  [63:0] data_a,
    input         data_a_valid,
    input  [63:0] data_b,
    input         data_b_valid,
    output [63:0] data_out,
    output        data_out_valid
);

reg [63:0] reg_data;
reg        reg_data_valid;

assign data_out       = reg_data;
assign data_out_valid = reg_data_valid;

always @ (sel or data_a or data_b) begin
    if (sel == 0) begin
        reg_data       <= data_a;
        reg_data_valid <= data_a_valid;
    end else begin
        reg_data       <= data_b;
        reg_data_valid <= data_b_valid;
    end
end

endmodule