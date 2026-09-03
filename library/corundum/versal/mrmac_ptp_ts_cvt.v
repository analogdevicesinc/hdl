// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MRMAC <-> Corundum PTP timestamp / system-time format converter.
 *
 * PURPOSE
 *   Corundum and the AMD Versal MRMAC express PTP time in the SAME layout
 *   ({nanoseconds, fractional-nanoseconds}, unsigned, wrapping) but with a
 *   DIFFERENT number of fractional bits, so translating between them is a pure
 *   left/right shift plus a width fit. This module packages both directions so
 *   the wrapper (mrmac_gty_wrapper) stays readable and the arithmetic lives in
 *   one unit-tested place.
 *
 * FORMATS
 *   Corundum relative timestamp (ptp_clock.v output_ts_64):
 *       [ (NS+FNS-1) : FNS ] = nanoseconds   (integer ns, wraps at the field top)
 *       [ FNS-1      : 0   ] = fractional ns  (FNS bits; LSB = 2^-FNS ns)
 *     Corundum uses FNS_WIDTH = 16 (LSB = 2^-16 ns). PTP_TS_WIDTH = 48 selects
 *     the low 48 bits {ns[31:0], fns[15:0]} of that fixed-point value; the
 *     wrapper carries it in an 80-bit container (CMAC-faithful), high bits 0.
 *
 *   MRMAC PTP systemtimer / timestamp (PG314):
 *       unsigned fixed-point with LSB = 2^-8 ns, i.e. FNS = 8 fractional bits,
 *       mapping to bits [62:8] of the IEEE-1588-2008 correction field (the low 8
 *       correction-field bits are always 0). The port is 55 bits wide:
 *       {ns[46:0], fns[7:0]}. Bit[54] of the *stat* readback is overloaded as a
 *       capture-edge indicator (handled by the caller, not here).
 *
 * CONVERSION
 *   Both are {ns, fns} fixed-point sharing the same ns LSB (1 ns). Only the
 *   fractional resolution differs, by (COR_FNS_WIDTH - MRMAC_FNS_WIDTH) = 8 bits:
 *     corundum -> mrmac : value >> 8   (drop the 8 extra low fractional bits)
 *     mrmac -> corundum : value << 8   (zero-extend the finer fractional field)
 *   then fit/zero-extend to the destination width. This is exact for the ns
 *   field and truncates/zero-fills only the sub-2^-8 ns fractional part, which
 *   neither side can represent on the other.
 *
 * This module is COMBINATIONAL (no clock): it is a fixed rewiring of bits. The
 * caller registers/pipelines and provides the clock domain.
 */

`timescale 1ns/100ps
`default_nettype none

module mrmac_ptp_ts_cvt #(
    // Corundum-side container width (wrapper carries the 48-bit rel TS in an
    // 80-bit CMAC-faithful field; only the low COR_TS_WIDTH bits are meaningful).
    parameter COR_TS_WIDTH   = 80,
    // Corundum fractional-ns bits (FNS_WIDTH in ptp_clock.v).
    parameter COR_FNS_WIDTH  = 16,
    // MRMAC-side systemtimer / timestamp width (PG314: 55).
    parameter MRMAC_TS_WIDTH = 55,
    // MRMAC fractional-ns bits (PG314: LSB = 2^-8 ns).
    parameter MRMAC_FNS_WIDTH = 8
) (
    // Corundum-format time in  -> MRMAC systemtimer out (discipline / TX 1588 path)
    input  wire [COR_TS_WIDTH-1:0]    cor_ts_in,
    output wire [MRMAC_TS_WIDTH-1:0]  mrmac_ts_out,

    // MRMAC timestamp in       -> Corundum-format time out (RX insert / TX completion)
    input  wire [MRMAC_TS_WIDTH-1:0]  mrmac_ts_in,
    output wire [COR_TS_WIDTH-1:0]    cor_ts_out
);

// The two formats differ only in fractional resolution. Guard the assumption
// that Corundum is the finer of the two (it is: 16 vs 8), so cor->mrmac is a
// right shift and mrmac->cor is a left shift.
localparam FRAC_SHIFT = COR_FNS_WIDTH - MRMAC_FNS_WIDTH;

initial begin
    if (COR_FNS_WIDTH < MRMAC_FNS_WIDTH) begin
        $error("Error: mrmac_ptp_ts_cvt assumes COR_FNS_WIDTH >= MRMAC_FNS_WIDTH (instance %m)");
        $finish;
    end
end

// -------------------------------------------------------------------------
// Corundum -> MRMAC: drop the extra low fractional bits, then fit to width.
//   cor_ts_in is {ns, fns16} in its low COR_TS_WIDTH bits; >> FRAC_SHIFT aligns
//   the fractional LSB to 2^-8 ns. The result's low MRMAC_TS_WIDTH bits are the
//   MRMAC {ns, fns8} value (ns wraps naturally in the narrower field).
// -------------------------------------------------------------------------
wire [COR_TS_WIDTH-1:0] cor_shifted = cor_ts_in >> FRAC_SHIFT;
assign mrmac_ts_out = cor_shifted[MRMAC_TS_WIDTH-1:0];

// -------------------------------------------------------------------------
// MRMAC -> Corundum: zero-extend the finer fractional field (<< FRAC_SHIFT),
//   then zero-fill to the Corundum container width. The MRMAC value's ns field
//   lands in the Corundum ns field; sub-2^-8 ns bits are 0 (MRMAC cannot
//   represent them).
// -------------------------------------------------------------------------
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
