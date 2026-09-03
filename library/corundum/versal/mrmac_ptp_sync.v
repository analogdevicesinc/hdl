// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MRMAC PTP system-timer discipline FSM.
 *
 * WHY THIS EXISTS
 *   On the VCU118 (CMAC), Corundum is the PTP master: it feeds its current time
 *   continuously into ctl_{tx,rx}_systemtimerin, and the MAC timestamps directly
 *   against that bus (zero offset from the Corundum PHC, modulo a fixed capture
 *   pipeline). The Versal MRMAC does NOT accept a continuous time input: it owns
 *   an internal free-running PTP timer, and ctl_*_ptp_systemtimer is only LOADED
 *   into that timer through a sync handshake (PG314). To reproduce the VCU118
 *   behaviour (MAC timestamps expressed in Corundum's timebase) we must
 *   continuously DISCIPLINE the MRMAC timer to Corundum's time.
 *
 * PROTOCOL (PG314, Table "Timestamp Control Signal Descriptions")
 *   - ctl_*_ptp_st_sync : a TRANSITION (DDR phase detector) marks the systemtimer
 *       value as valid. Transitions must be >= 10 clock cycles apart (typical
 *       64 ns). The systemtimer bus must be stable ~10 ns AFTER the transition;
 *       MRMAC captures it >= 4 clocks after the edge.
 *   - ctl_*_ptp_st_overwrite : when asserted, at the next st_sync transition the
 *       MRMAC timer is overwritten with the systemtimer value IF the difference
 *       exceeds an internal threshold. Held high here so the timer re-aligns to
 *       Corundum whenever it drifts past threshold, and free-runs (on its
 *       configured auto-increment) otherwise. On the first sync after reset the
 *       MRMAC timer (~0) differs from Corundum by more than threshold, so it
 *       snaps into alignment automatically.
 *   - st_adjust* : NOT used here. The auto-increment is set once by the IP's
 *       TIMESTAMP_CLK_PERIOD_NS config; we only load/realign, never trim the rate.
 *
 * IMPLEMENTATION
 *   Every SYNC_CYCLES clocks we (a) latch Corundum's current time into the
 *   held systemtimer register and (b) TOGGLE st_sync. Holding the latched value
 *   for the whole window guarantees it is stable across and after the edge.
 *   Because MRMAC captures a few clocks after the edge while Corundum's time
 *   keeps advancing, the loaded value lags Corundum by a small fixed amount;
 *   OFFSET_ADJ (in MRMAC 2^-8 ns units) can pre-compensate that constant lag
 *   (default 0 — analogous to CMAC's own uncompensated capture pipeline).
 *
 * CLOCK DOMAINS
 *   This FSM runs in the caller's clock (the MRMAC tx/rx_axi_clk = 390.625 MHz
 *   AXIS domain), so systemtime_in (Corundum's *_ptp_time) needs no CDC on the
 *   way in. MRMAC's PTP timer, however, samples ctl_*_ptp_systemtimer/st_sync in
 *   its own tx/rx_ts_clk domain (a SEPARATE, slower clock: MRMAC caps the ts-clk
 *   at 50-350 MHz, so it cannot be the 390.625 MHz AXIS clock; the reference runs
 *   it at 250 MHz). That axi_clk -> ts_clk crossing is safe by construction: the
 *   systemtimer bus is held stable for the entire SYNC_CYCLES window and st_sync
 *   only TOGGLES once per window, which is exactly PG314's DDR-phase handshake
 *   (edges must be >= 10 ts_clk cycles apart; SYNC_CYCLES=32 axi cycles = 81.9 ns
 *   ~= 20 ts_clk cycles at 250 MHz, 2x margin). No extra synchronizer is required
 *   on this side. See corundum_vpk180_mac.tcl section 10 for the clock wiring.
 */

`timescale 1ns/100ps
`default_nettype none

module mrmac_ptp_sync #(
    // MRMAC systemtimer width (PG314: 55).
    parameter TS_WIDTH = 55,
    // Clocks between st_sync transitions. PG314 requires >= 10; ~64 ns typical.
    parameter SYNC_CYCLES = 32,
    // Fixed pre-compensation added to the loaded time (MRMAC 2^-8 ns units) to
    // offset MRMAC's post-edge capture latency. 0 = none (CMAC-faithful default).
    parameter [TS_WIDTH-1:0] OFFSET_ADJ = 0
) (
    input  wire                 clk,
    input  wire                 rst,

    // Corundum current time, already in MRMAC {ns,fns8} units (continuous).
    input  wire [TS_WIDTH-1:0]  systemtime_in,

    // To MRMAC ctl_*_ptp_systemtimer / st_sync / st_overwrite.
    output reg  [TS_WIDTH-1:0]  systemtimer,
    output reg                  st_sync,
    output wire                 st_overwrite
);

    // check configuration
    initial begin
        if (SYNC_CYCLES < 10) begin
            $error("Error: SYNC_CYCLES must be >= 10 per PG314 (instance %m)");
            $finish;
        end
    end

    localparam CW = (SYNC_CYCLES <= 2) ? 1 : $clog2(SYNC_CYCLES);

    reg [CW-1:0] cnt = 0;

    // Always allow the MRMAC timer to re-align when it drifts past threshold.
    assign st_overwrite = 1'b1;

    initial begin
        systemtimer = 0;
        st_sync = 1'b0;
    end

    always @(posedge clk) begin
        if (cnt == SYNC_CYCLES-1) begin
            cnt         <= 0;
            st_sync     <= ~st_sync;                    // one sync event (edge)
            systemtimer <= systemtime_in + OFFSET_ADJ;  // latch + hold stable
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
