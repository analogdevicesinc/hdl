// QSPI Slave — 4-lane quad read, configurable read length, 8-bit counter output
//
// Protocol (SPI Mode 0, CPOL=0 CPHA=0):
//   CMD phase:   8 bits on IO0 (single), MSB first
//   ADDR phase:  8 bits on IO0 (single), MSB first
//   DATA phase:  quad IO[3:0] for read, single IO0 for register write
//
// Commands:
//   0x01  Read  — slave outputs counter bytes (0-255 wrapping) on IO[3:0],
//                  high nibble first, 2 SCLK cycles per byte
//   0x02  Write — master writes 8-bit value on IO0 to register at ADDR
//
// Registers:
//   0x00  Read length in KB (1-255), default 1

module qspi_slave #(
    parameter DEFAULT_READ_LENGTH = 8'd1
) (
    input  wire        sys_clk,
    input  wire        sys_rst_n,
    output wire        ready,         // sys_clk domain: 1=idle, 0=read active

    input  wire        sclk,
    input  wire        cs_n,
    input  wire [3:0]  io_i,
    output reg  [3:0]  io_o,
    output reg         io_oe
);

    // =========================================================================
    // QSPI clock domain
    // =========================================================================

    localparam [2:0] ST_CMD        = 3'd0,
                     ST_ADDR       = 3'd1,
                     ST_READ_DATA  = 3'd2,
                     ST_WRITE_DATA = 3'd3,
                     ST_DONE       = 3'd4;

    localparam [7:0] CMD_READ      = 8'h01,
                     CMD_WRITE_REG = 8'h02;

    // --- FSM registers (posedge sclk, async reset on cs_n) ---
    reg [2:0]  state;
    reg [2:0]  bit_cnt;
    reg [7:0]  shift_reg;
    reg [7:0]  cmd_reg;
    reg [7:0]  sample_counter;
    reg [20:0] byte_counter;
    reg        nibble_sel;
    reg        read_active_q;

    // --- Config/CDC registers (posedge sclk, async reset on sys_rst_n) ---
    reg        reg_wr_toggle;
    reg [7:0]  reg_wr_data;
    reg [7:0]  read_length_q;

    wire [20:0] read_limit = {read_length_q, 10'd0} - 21'd1;

    // Combinational conditions evaluated at posedge sclk (use pre-update values)
    wire addr_last_bit = (state == ST_ADDR) && (bit_cnt == 3'd7);
    wire read_byte_end = (state == ST_READ_DATA) && nibble_sel;
    wire read_done     = read_byte_end && (byte_counter == read_limit);
    wire wr_data_done  = (state == ST_WRITE_DATA) && (bit_cnt == 3'd7);

    // --- FSM: posedge sclk, async reset on cs_n ---
    always @(posedge sclk or posedge cs_n) begin
        if (cs_n) begin
            state          <= ST_CMD;
            bit_cnt        <= 3'd0;
            shift_reg      <= 8'd0;
            cmd_reg        <= 8'd0;
            sample_counter <= 8'd0;
            byte_counter   <= 21'd0;
            nibble_sel     <= 1'b0;
            read_active_q  <= 1'b0;
            io_oe          <= 1'b0;
        end else begin
            case (state)
                ST_CMD: begin
                    shift_reg <= {shift_reg[6:0], io_i[0]};
                    bit_cnt   <= bit_cnt + 3'd1;
                    if (bit_cnt == 3'd7) begin
                        cmd_reg   <= {shift_reg[6:0], io_i[0]};
                        state     <= ST_ADDR;
                        bit_cnt   <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                ST_ADDR: begin
                    shift_reg <= {shift_reg[6:0], io_i[0]};
                    bit_cnt   <= bit_cnt + 3'd1;
                    if (addr_last_bit) begin
                        bit_cnt <= 3'd0;
                        if (cmd_reg == CMD_READ) begin
                            state          <= ST_READ_DATA;
                            io_oe          <= 1'b1;
                            sample_counter <= 8'd0;
                            byte_counter   <= 21'd0;
                            nibble_sel     <= 1'b0;
                            read_active_q  <= 1'b1;
                        end else if (cmd_reg == CMD_WRITE_REG) begin
                            state     <= ST_WRITE_DATA;
                            shift_reg <= 8'd0;
                        end else begin
                            state <= ST_DONE;
                        end
                    end
                end

                ST_READ_DATA: begin
                    nibble_sel <= ~nibble_sel;
                    if (nibble_sel) begin
                        if (byte_counter == read_limit) begin
                            state         <= ST_DONE;
                            io_oe         <= 1'b0;
                            read_active_q <= 1'b0;
                        end else begin
                            byte_counter   <= byte_counter + 21'd1;
                            sample_counter <= sample_counter + 8'd1;
                        end
                    end
                end

                ST_WRITE_DATA: begin
                    shift_reg <= {shift_reg[6:0], io_i[0]};
                    bit_cnt   <= bit_cnt + 3'd1;
                    if (bit_cnt == 3'd7)
                        state <= ST_DONE;
                end

                ST_DONE: begin
                    // wait for cs_n deassert
                end

                default: state <= ST_DONE;
            endcase
        end
    end

    // --- Config/CDC regs: posedge sclk, async reset on sys_rst_n ---
    // Separate always block avoids dual-async-reset on FPGA FFs.
    // These regs persist across cs_n cycles.
    always @(posedge sclk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            reg_wr_toggle <= 1'b0;
            reg_wr_data   <= 8'd0;
            read_length_q <= DEFAULT_READ_LENGTH;
        end else if (!cs_n) begin
            if (wr_data_done) begin
                reg_wr_toggle <= ~reg_wr_toggle;
                reg_wr_data   <= {shift_reg[6:0], io_i[0]};
                read_length_q <= {shift_reg[6:0], io_i[0]};
            end
        end
    end

    // --- Output data: negedge sclk (master samples on posedge) ---
    always @(negedge sclk or posedge cs_n) begin
        if (cs_n) begin
            io_o <= 4'd0;
        end else if (state == ST_READ_DATA) begin
            io_o <= nibble_sel ? sample_counter[3:0] : sample_counter[7:4];
        end else begin
            io_o <= 4'd0;
        end
    end

    // =========================================================================
    // System clock domain
    // =========================================================================

    // --- CDC: read_active_q level → sys domain (2-FF synchronizer) ---
    reg [1:0] ra_sync;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            ra_sync <= 2'b00;
        else
            ra_sync <= {ra_sync[0], read_active_q};
    end

    assign ready = ~ra_sync[1];

    // --- CDC: reg_wr_toggle → sys domain (toggle synchronizer) ---
    reg [2:0] rwt_sync;
    reg [7:0] read_length_sys;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            rwt_sync        <= 3'b000;
            read_length_sys <= DEFAULT_READ_LENGTH;
        end else begin
            rwt_sync <= {rwt_sync[1:0], reg_wr_toggle};
            if (rwt_sync[2] != rwt_sync[1])
                read_length_sys <= reg_wr_data;
        end
    end

endmodule
