// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
/**
 * Does dynamic address assigment DAA, which occurs at bus initialization.
 *
 * The DAA process is:
 * Controller       | Peripheral  | Flow
 * -----------------|-------------|---------
 * S,0x7e,RnW=0     |             |    │
 *                  | ACK         |    │
 * ENTDAA,T         |             |    │
 * Sr               |             | ┌─►│
 * 0x7e,RnW=1       |             | │  ▼
 *                  | ACK         | │  A──┐
 *                  | PID+BCR+DCR | │  │  │
 * DA, Par          |             | │  ▼  │
 *                  | ACK         | └──B  │
 * P                |             |    C◄─┘
 *
 * Notes
 * From A with ACK, continue flow to B, or with NACK, goto C Stop,
 * finishing the DAA. At B, goto on sm state before A, Sr.
 * The first and last ACK are mandatory in the flowchart, if a NACK is received,
 * it is considered an error and the module resets.
 * The controller writes in push-pull mode.
 */

`timescale 1ns/100ps
`default_nettype none
`include "i3c_controller_bit_mod_cmd.v"

module i3c_controller_daa #(
  parameter DA_LENGTH = 4,
  parameter DA_LENGTH_WIDTH = 2,
  // See I3C Target Address Restrictions for valid values
  parameter [7*DA_LENGTH-1:0] DA = {7'h08, 7'h09, 7'h0a, 7'h0b}
)(
  input wire reset_n,
  input wire clk,
  input wire clk_quarter,

  // Command interface

  input  wire cmdp_do_daa,
  output wire cmdp_do_daa_ready,

  input wire sdo,
  output reg [`MOD_BIT_CMD_WIDTH:0] cmd,

  // Unused

  output wire [63:0] o_pid_bcr_dcr,
  output reg  [6:0] o_da,
  output reg  o_pid_da_valid,

  output reg error
  );

  reg [5:0] i;

  reg start;
  reg reset;
  reg [63:0] r_pid_bcr_dcr; // buffer PID+BCR+DCR
  reg [DA_LENGTH_WIDTH-1:0] r_da; // buffer DA
  reg r_pid_da_valid;
  reg r2_pid_da_valid;
  reg r_arbitration_first; // differentiator for arbitration_a/Sr

  reg r_clk_quarter;
  reg r2_clk_quarter;
  reg r3_clk_quarter;

  localparam [6:0]
    I3C_RESERVED = 7'h7e;
  localparam [7:0]
    I3C_RESERVED_RNW0  = {I3C_RESERVED, 1'b0}, // Concat RnW
    I3C_RESERVED_RNW1  = {I3C_RESERVED, 1'b1}, // Concat RnW
    CCC_ENTDAA      = 'h03;
  localparam [8:0]
    CCC_ENTDAA_PAR  = {CCC_ENTDAA, 1'b0}; // Concat const pariety

  reg [1:0] sm;
  localparam [1:0]
    idle         = 0,
    i3c_mode_    = 1,
    ccc_entdaa   = 2,
    arbitration  = 3;


  reg [1:0] i3c_mode;
  localparam [1:0]
    i3c_mode_a  = 0, // S
    i3c_mode_b  = 1, // 0x7e,RnW=0
    i3c_mode_c  = 2; // ACK

  reg [0:0] r_ccc_entdaa;
  localparam [0:0]
    ccc_entdaa_a = 0, // CCC ENTDAA MSB bit
    ccc_entdaa_b = 1; // CCC ENTDAA others + T-bit

  reg [2:0] r_arbitration;
  localparam [2:0]
    arbitration_a = 0, // Sr
    arbitration_b = 1, // 0x7e,RnW=1
    arbitration_c = 2, // ACK
    arbitration_d = 3, // PID
    arbitration_e = 4, // DA
    arbitration_f = 5, // DA others
    arbitration_g = 6, // Par
    arbitration_h = 7; // ACK

  always @(posedge clk) begin
    if (!reset_n) begin
      start <= 1'b0;
      reset <= 1'b0;
    end else begin
      case (sm)
        idle: begin
          if (cmdp_do_daa == 1'b1) begin
            start <= 1'b1;
          end
        end
        default: begin
        end
      endcase
      if (~r3_clk_quarter && r2_clk_quarter) begin
        reset <= 1'b1;
        start <= 1'b0;
      end
    end
    // Ensure single ticks with edge detection
    r2_pid_da_valid <= r_pid_da_valid;
    o_pid_da_valid <= ~r2_pid_da_valid && r_pid_da_valid ? 1'b1 : 1'b0;
    // Delay clocks
    r_clk_quarter <= clk_quarter;
    r2_clk_quarter <= r_clk_quarter;
    r3_clk_quarter <= r2_clk_quarter;
  end

  always @(posedge r2_clk_quarter) begin
    if (!reset) begin
      r_pid_da_valid <= 1'b0;
      r_arbitration_first <= 1'b1;
      r_pid_bcr_dcr <=  0;
      r_da <= 0;
      o_da <= 0;
      error <= 1'b0;

      sm <= idle;
      i3c_mode <= i3c_mode_a;
      r_ccc_entdaa <= ccc_entdaa_a;
      r_arbitration <= arbitration_a;
      cmd <= `MOD_BIT_CMD_NOP;
    end else begin
      error <= 1'b0;
      case (sm)
        idle: begin
          if (start == 1'b1) begin
            sm <= i3c_mode_;
          end else begin
            sm <= idle;
          end
          cmd <= `MOD_BIT_CMD_NOP;
        end
        i3c_mode_: begin
          i3c_mode <= i3c_mode + 1;
          case (i3c_mode)
            i3c_mode_a: begin // S
              cmd <= `MOD_BIT_CMD_START_PP;
              i <= 7;
            end
            i3c_mode_b: begin // 0x7e,RnW=0
              if (i != 0) begin
                i <= i - 1;
                i3c_mode <= i3c_mode;
              end
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,I3C_RESERVED_RNW0[i[2:0]]};
            end
            i3c_mode_c: begin // ACK
              cmd <= `MOD_BIT_CMD_READ;
              i3c_mode <= i3c_mode_a;
              sm <= sm + 1;
            end
            default: begin
            end
          endcase
        end
        ccc_entdaa: begin
          r_ccc_entdaa <= r_ccc_entdaa + 1;
          case (r_ccc_entdaa)
            ccc_entdaa_a: begin // CCC ENTDAA MSB bit
              if (sdo == 1'b0) begin // ACK => CCC ENTDAA MSB bit
                cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,CCC_ENTDAA_PAR[8]};
                i <= 7;
              end else begin // NACK => ERROR
                cmd <= `MOD_BIT_CMD_STOP;
                sm <= idle;
                error <= 1'b1;
              end
            end
            ccc_entdaa_b: begin // CCC ENTDAA others  + T-bit
              if (i != 0) begin
                i <= i - 1;
                r_ccc_entdaa <= r_ccc_entdaa;
              end else begin
                r_ccc_entdaa <= ccc_entdaa_a;
                sm <= sm + 1;
              end
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,CCC_ENTDAA_PAR[i[3:0]]};
            end
          endcase
        end
        arbitration: begin
          r_arbitration <= r_arbitration + 1;
          case (r_arbitration)
            arbitration_a: begin // Sr
              if (r_arbitration_first) begin
                r_arbitration_first <= 1'b0;
                cmd <= `MOD_BIT_CMD_START_PP;
              end else begin
                if (sdo == 1'b0) begin // ACK => Sr
                  cmd <= `MOD_BIT_CMD_START_PP;
                  r_pid_da_valid <= 1'b1; // push assigment to engine
                  o_da <= DA[7*r_da +:7];
                  r_da <= r_da + 1;
                end else begin // NACK => ERROR
                  cmd <= `MOD_BIT_CMD_STOP;
                  sm <= idle;
                  error <= 1'b1;
                end
              end
              i <= 7;
            end
            arbitration_b: begin // 0x7e,RnW=1
              if (i != 0) begin
                i <= i - 1;
                r_arbitration <= r_arbitration;
              end
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,I3C_RESERVED_RNW1[i[2:0]]};
            end
            arbitration_c: begin // ACK
              cmd <= `MOD_BIT_CMD_READ;
              i <= 63;
            end
            arbitration_d: begin // PID
              if (sdo == 1'b0) begin // ACK => read PID MSB "B"
                cmd <= `MOD_BIT_CMD_READ;
              end else begin // NACK => P "C"
                cmd <= `MOD_BIT_CMD_STOP;
                r_arbitration <= arbitration_a;
                sm <= idle;
              end
            end
            arbitration_e: begin // Sample PID MSB, read PID others
              if (i != 0) begin
                r_arbitration <= r_arbitration;
                cmd <= `MOD_BIT_CMD_READ;
                i <= i - 1;
              end else begin // write DA MSB
                cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,DA[7*(r_da+1)-1]};
                i <= 5;
              end
              r_pid_bcr_dcr[i] <= sdo;
            end
            arbitration_f: begin // write DA others
              if (i != 0) begin
                i <= i - 1;
                r_arbitration <= r_arbitration;
              end
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b1, DA[7*(r_da+1)-i]};
            end
            arbitration_g: begin // Write odd pariety
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,~^DA[7*r_da +:7]};
            end
            arbitration_h: begin // ACK
              cmd <= `MOD_BIT_CMD_READ;
              r_arbitration <= arbitration_a;
            end
          endcase
        end
        default: begin
          cmd <= `MOD_BIT_CMD_NOP;
          sm <= idle;
        end
      endcase
    end
  end
  assign o_pid_bcr_dcr = r_pid_bcr_dcr [63:0];
  assign cmdp_do_daa_ready = sm == idle;
endmodule
