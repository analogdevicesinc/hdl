`timescale 1ns / 1ps

module tb_qspi_slave;

    // System clock: 200 MHz (5 ns period) — faster than SCLK
    localparam SYS_CLK_PERIOD = 5;
    // QSPI clock: 100 MHz (10 ns period)
    localparam SCLK_PERIOD = 10;

    reg        sys_clk;
    reg        sys_rst_n;
    wire       ready;

    reg        sclk;
    reg        cs_n;
    reg  [3:0] io_i;
    wire [3:0] io_o;
    wire       io_oe;

    integer errors;
    integer i;

    // DUT
    qspi_slave #(
        .DEFAULT_READ_LENGTH(8'd1)
    ) dut (
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),
        .ready     (ready),
        .sclk      (sclk),
        .cs_n      (cs_n),
        .io_i      (io_i),
        .io_o      (io_o),
        .io_oe     (io_oe)
    );

    // --- Clock generation ---
    initial sys_clk = 0;
    always #(SYS_CLK_PERIOD/2.0) sys_clk = ~sys_clk;

    // SCLK is driven by tasks (not free-running)
    initial sclk = 0;

    // --- VCD dump ---
    initial begin
        $dumpfile("tb_qspi_slave.vcd");
        $dumpvars(0, tb_qspi_slave);
    end

    // =====================================================================
    // Helper tasks
    // =====================================================================

    task sclk_cycle;
        begin
            #(SCLK_PERIOD/2) sclk = 1;  // posedge
            #(SCLK_PERIOD/2) sclk = 0;  // negedge
        end
    endtask

    // Send 8 bits on IO0 (MSB first), one bit per SCLK posedge
    task send_byte_spi(input [7:0] data);
        integer b;
        begin
            for (b = 7; b >= 0; b = b - 1) begin
                io_i[0] = data[b];
                sclk_cycle;
            end
        end
    endtask

    // Send command byte
    task send_cmd(input [7:0] cmd);
        begin
            send_byte_spi(cmd);
        end
    endtask

    // Send address byte
    task send_addr(input [7:0] addr);
        begin
            send_byte_spi(addr);
        end
    endtask

    // Read one byte from quad output (2 SCLK cycles: high nibble, low nibble)
    // Master samples io_o on posedge sclk
    task read_byte_quad(output [7:0] data);
        begin
            #(SCLK_PERIOD/2) sclk = 1;        // posedge — sample high nibble
            data[7:4] = io_o;
            #(SCLK_PERIOD/2) sclk = 0;        // negedge
            #(SCLK_PERIOD/2) sclk = 1;        // posedge — sample low nibble
            data[3:0] = io_o;
            #(SCLK_PERIOD/2) sclk = 0;        // negedge
        end
    endtask

    // Full register write transaction
    task write_register(input [7:0] addr, input [7:0] data);
        begin
            cs_n = 0;
            #(SCLK_PERIOD);
            send_cmd(8'h02);
            send_addr(addr);
            send_byte_spi(data);
            #(SCLK_PERIOD);
            cs_n = 1;
            #(SCLK_PERIOD * 4);  // inter-transaction gap
        end
    endtask

    // Full read transaction: reads num_bytes from quad output, checks counter pattern
    task do_read(input integer num_bytes);
        reg [7:0] rx_data;
        reg [7:0] expected;
        integer byte_idx;
        begin
            cs_n = 0;
            #(SCLK_PERIOD);
            send_cmd(8'h01);
            send_addr(8'h00);  // address ignored for read

            expected = 8'd0;
            for (byte_idx = 0; byte_idx < num_bytes; byte_idx = byte_idx + 1) begin
                read_byte_quad(rx_data);
                if (rx_data !== expected) begin
                    $display("ERROR: byte[%0d] = 0x%02x, expected 0x%02x",
                             byte_idx, rx_data, expected);
                    errors = errors + 1;
                end
                expected = expected + 8'd1;  // wraps at 255→0
            end

            #(SCLK_PERIOD);
            cs_n = 1;
            #(SCLK_PERIOD * 4);
        end
    endtask

    // Wait for ready signal to reach expected value in sys domain
    task wait_ready(input expected, input integer timeout_cycles);
        integer cyc;
        begin
            cyc = 0;
            while (ready !== expected && cyc < timeout_cycles) begin
                @(posedge sys_clk);
                cyc = cyc + 1;
            end
            if (ready !== expected) begin
                $display("ERROR: ready did not reach %0b within %0d sys_clk cycles",
                         expected, timeout_cycles);
                errors = errors + 1;
            end
        end
    endtask

    // =====================================================================
    // Main test sequence
    // =====================================================================
    initial begin
        errors   = 0;
        cs_n     = 1;
        io_i     = 4'd0;
        sys_rst_n = 0;
        sclk     = 0;

        // Reset
        #100;
        sys_rst_n = 1;
        #100;

        // ------------------------------------------------------------------
        // Test 1: Check ready is high after reset
        // ------------------------------------------------------------------
        $display("--- Test 1: ready after reset ---");
        if (ready !== 1'b1) begin
            $display("ERROR: ready should be 1 after reset, got %b", ready);
            errors = errors + 1;
        end else begin
            $display("PASS: ready=1 after reset");
        end

        // ------------------------------------------------------------------
        // Test 2: Default read (1 KB = 1024 bytes)
        // ------------------------------------------------------------------
        $display("--- Test 2: Read 1 KB (default) ---");
        do_read(1024);

        // Check ready returned high after read
        wait_ready(1'b1, 100);
        $display("PASS: 1 KB read completed, ready restored");

        // ------------------------------------------------------------------
        // Test 3: Write read_length register to 2 (= 2 KB)
        // ------------------------------------------------------------------
        $display("--- Test 3: Write read_length = 2 ---");
        write_register(8'h00, 8'd2);

        // Verify ready is still high after register write
        #200;
        if (ready !== 1'b1) begin
            $display("ERROR: ready should be 1 after register write, got %b", ready);
            errors = errors + 1;
        end else begin
            $display("PASS: ready=1 after register write");
        end

        // ------------------------------------------------------------------
        // Test 4: Read 2 KB
        // ------------------------------------------------------------------
        $display("--- Test 4: Read 2 KB ---");
        do_read(2048);
        wait_ready(1'b1, 100);
        $display("PASS: 2 KB read completed, ready restored");

        // ------------------------------------------------------------------
        // Test 5: Verify ready goes low during read
        // ------------------------------------------------------------------
        $display("--- Test 5: ready goes low during read ---");
        // Start a read and check ready goes low
        cs_n = 0;
        #(SCLK_PERIOD);
        send_cmd(8'h01);
        send_addr(8'h00);

        // After entering read phase, wait for CDC to propagate
        wait_ready(1'b0, 100);
        $display("PASS: ready=0 during read");

        // Read a few bytes to prove it stays low
        begin : read_partial
            reg [7:0] rx_tmp;
            for (i = 0; i < 16; i = i + 1) begin
                read_byte_quad(rx_tmp);
            end
        end
        if (ready !== 1'b0) begin
            $display("ERROR: ready should still be 0 during partial read, got %b", ready);
            errors = errors + 1;
        end else begin
            $display("PASS: ready remains 0 during active read");
        end

        // Abort by deasserting cs_n
        cs_n = 1;
        #(SCLK_PERIOD * 4);
        // ready may or may not return high after abort (depends on toggle state)
        // The toggle only happens at read completion, not on cs_n abort, so
        // read_active_q returns to 0 via cs_n reset, which propagates via CDC
        wait_ready(1'b1, 100);
        $display("PASS: ready restored after CS abort");

        // ------------------------------------------------------------------
        // Test 6: io_oe only asserted during read data phase
        // ------------------------------------------------------------------
        $display("--- Test 6: io_oe behavior ---");
        cs_n = 0;
        #(SCLK_PERIOD);
        if (io_oe !== 1'b0) begin
            $display("ERROR: io_oe should be 0 during CMD phase");
            errors = errors + 1;
        end
        send_cmd(8'h01);
        if (io_oe !== 1'b0) begin
            $display("ERROR: io_oe should be 0 during ADDR phase");
            errors = errors + 1;
        end
        send_addr(8'h00);
        if (io_oe !== 1'b1) begin
            $display("ERROR: io_oe should be 1 after entering READ_DATA");
            errors = errors + 1;
        end else begin
            $display("PASS: io_oe asserted in read data phase");
        end
        cs_n = 1;
        #(SCLK_PERIOD * 4);
        if (io_oe !== 1'b0) begin
            $display("ERROR: io_oe should be 0 after CS deassert");
            errors = errors + 1;
        end else begin
            $display("PASS: io_oe deasserted after CS");
        end

        // ------------------------------------------------------------------
        // Summary
        // ------------------------------------------------------------------
        #200;
        $display("========================================");
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d error(s)", errors);
        $display("========================================");
        $finish;
    end

    // Timeout watchdog
    initial begin
        #10_000_000;
        $display("ERROR: Simulation timeout");
        $finish;
    end

endmodule
