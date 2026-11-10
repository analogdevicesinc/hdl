// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */

`timescale 1ns/100ps
`default_nettype none

module mrmac_ptp_sync #(
    parameter TS_WIDTH = 55,
    parameter SYNC_CYCLES = 32,
    // MRMAC 2^-8 ns units
    parameter [TS_WIDTH-1:0] OFFSET_ADJ = 0
) (
    input  wire                 clk,
    input  wire                 rst,

    // MRMAC {ns,fns8} units
    input  wire [TS_WIDTH-1:0]  systemtime_in,

    output reg  [TS_WIDTH-1:0]  systemtimer,
    output reg                  st_sync,
    output wire                 st_overwrite
);

    initial begin
        if (SYNC_CYCLES < 10) begin
            $error("Error: SYNC_CYCLES must be >= 10 per PG314 (instance %m)");
            $finish;
        end
    end

    localparam CW = (SYNC_CYCLES <= 2) ? 1 : $clog2(SYNC_CYCLES);

    reg [CW-1:0] cnt = 0;

    assign st_overwrite = 1'b1;

    initial begin
        systemtimer = 0;
        st_sync = 1'b0;
    end

    always @(posedge clk) begin
        if (cnt == SYNC_CYCLES-1) begin
            cnt         <= 0;
            st_sync     <= ~st_sync;
            systemtimer <= systemtime_in + OFFSET_ADJ;
        end else begin
            cnt <= cnt + 1;
        end

        if (rst) begin
            cnt         <= 0;
            st_sync     <= 1'b0;
            systemtimer <= 0;
        end
    end

endmodule

`default_nettype wire
