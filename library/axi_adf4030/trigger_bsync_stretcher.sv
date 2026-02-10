`timescale 1ns / 1ps;
module trigger_bsync_stretcher (
    input  logic external_bsync,
    input  logic trigger,
    output logic sync_start
);

  logic trigger_stretched = 1'b0;
  logic trigger_captured;
  logic sync_start_debug;

  always @(posedge trigger or posedge trigger_captured) begin
    if (trigger_captured)
      trigger_stretched <= 1'b0;
    else
      trigger_stretched <= 1'b1;
  end

  logic trigger_sync1 = 1'b0;
  logic trigger_sync2 = 1'b0;

  always @(posedge external_bsync) begin
    trigger_sync1 <= trigger_stretched;
    trigger_sync2 <= trigger_sync1;
  end

  assign trigger_captured = trigger_sync2;

  assign sync_start_debug = trigger_sync1 & ~trigger_sync2;
  assign sync_start = sync_start_debug & external_bsync;
endmodule