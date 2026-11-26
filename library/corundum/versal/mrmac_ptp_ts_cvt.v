// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * Both formats are unsigned, wrapping {ns, fractional ns} fixed point with a
 * 1 ns integer LSB:
 *   Corundum: FNS_WIDTH = 16 (LSB 2^-16 ns). The 48-bit relative
 *     timestamp {ns[31:0], fns[15:0]} is carried in an 80-bit container, high
 *     bits 0.
 *   MRMAC: 55 bits {ns[46:0], fns[7:0]}, LSB 2^-8 ns (bits [62:8] of the
 *     IEEE 1588-2008 correction field). Bit 54 of the stat readback is a
 *     capture-edge indicator.
 */

`timescale 1ns/100ps
`default_nettype none

module mrmac_ptp_ts_cvt #(
    parameter COR_TS_WIDTH   = 80,
    parameter COR_FNS_WIDTH  = 16,
    parameter MRMAC_TS_WIDTH = 55,
    parameter MRMAC_FNS_WIDTH = 8
) (
    input  wire [COR_TS_WIDTH-1:0]    cor_ts_in,
    output wire [MRMAC_TS_WIDTH-1:0]  mrmac_ts_out,

    input  wire [MRMAC_TS_WIDTH-1:0]  mrmac_ts_in,
    output wire [COR_TS_WIDTH-1:0]    cor_ts_out
);

localparam FRAC_SHIFT = COR_FNS_WIDTH - MRMAC_FNS_WIDTH;

initial begin
    if (COR_FNS_WIDTH < MRMAC_FNS_WIDTH) begin
        $error("Error: mrmac_ptp_ts_cvt assumes COR_FNS_WIDTH >= MRMAC_FNS_WIDTH (instance %m)");
        $finish;
    end
end

wire [COR_TS_WIDTH-1:0] cor_shifted = cor_ts_in >> FRAC_SHIFT;
assign mrmac_ts_out = cor_shifted[MRMAC_TS_WIDTH-1:0];

wire [MRMAC_TS_WIDTH+FRAC_SHIFT-1:0] mrmac_shifted =
    {{FRAC_SHIFT{1'b0}}, mrmac_ts_in} << FRAC_SHIFT;

generate
    if (COR_TS_WIDTH >= MRMAC_TS_WIDTH+FRAC_SHIFT) begin : g_widen
        assign cor_ts_out =
            {{(COR_TS_WIDTH-(MRMAC_TS_WIDTH+FRAC_SHIFT)){1'b0}}, mrmac_shifted};
    end else begin : g_narrow
        assign cor_ts_out = mrmac_shifted[COR_TS_WIDTH-1:0];
    end
endgenerate

endmodule

`default_nettype wire
