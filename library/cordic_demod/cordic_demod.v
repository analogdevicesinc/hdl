// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module cordic_demod (
  input clk,
  input resetn,

  input s_axis_valid,
  output s_axis_ready,
  input [63:0] s_axis_data,

  output m_axis_valid,
  input m_axis_ready,
  output [63:0] m_axis_data
);

reg [4:0] step_counter;
reg [4:0] shift_counter;
reg [30:0] phase;
reg [2:0] state;

reg [32:0] i;
reg [32:0] q;
reg [32:0] i_shift;
reg [32:0] q_shift;

assign s_axis_ready = state == STATE_IDLE;
assign m_axis_data = {q[32:1],i[32:1]};
assign m_axis_valid = state == STATE_DONE;

localparam STATE_IDLE = 0;
localparam STATE_SHIFT_LOAD = 1;
localparam STATE_SHIFT = 2;
localparam STATE_ADD = 3;
localparam STATE_DONE = 4;

reg [31:0] angle[0:30];

initial begin
  angle[0] = 32'h20000000;
  angle[1] = 32'h12e4051e;
  angle[2] = 32'h09fb385b;
  angle[3] = 32'h051111d4;
  angle[4] = 32'h028b0d43;
  angle[5] = 32'h0145d7e1;
  angle[6] = 32'h00a2f61e;
  angle[7] = 32'h00517c55;
  angle[8] = 32'h0028be53;
  angle[9] = 32'h00145f2f;
  angle[10] = 32'h000a2f98;
  angle[11] = 32'h000517cc;
  angle[12] = 32'h00028be6;
  angle[13] = 32'h000145f3;
  angle[14] = 32'h0000a2fa;
  angle[15] = 32'h0000517d;
  angle[16] = 32'h000028be;
  angle[17] = 32'h0000145f;
  angle[18] = 32'h00000a30;
  angle[19] = 32'h00000518;
  angle[20] = 32'h0000028c;
  angle[21] = 32'h00000146;
  angle[22] = 32'h000000a3;
  angle[23] = 32'h00000051;
  angle[24] = 32'h00000029;
  angle[25] = 32'h00000014;
  angle[26] = 32'h0000000a;
  angle[27] = 32'h00000005;
  angle[28] = 32'h00000003;
  angle[29] = 32'h00000001;
  angle[30] = 32'h00000001;
end

always @(posedge clk) begin
  if (resetn == 1'b0) begin
    state <= STATE_IDLE;
  end else begin
    case (state)
    STATE_IDLE: begin
      if (s_axis_valid == 1'b1) begin
        state <= STATE_SHIFT_LOAD;
      end
    end
    STATE_SHIFT_LOAD: begin
      if (step_counter == 'h00) begin
        state <= STATE_ADD;
      end else begin
        state <= STATE_SHIFT;
      end
    end
    STATE_SHIFT: begin
      if (shift_counter == 'h01) begin
        state <= STATE_ADD;
      end
    end
    STATE_ADD: begin
      if (step_counter == 'd30) begin
        state <= STATE_DONE;
      end else begin
        state <= STATE_SHIFT_LOAD;
      end
    end
    STATE_DONE: begin
      if (m_axis_ready == 1'b1)
        state <= STATE_IDLE;
    end
    endcase
  end
end

always @(posedge clk) begin
  case(state)
  STATE_SHIFT_LOAD: begin
    shift_counter <= step_counter;
  end
  STATE_SHIFT: begin
    shift_counter <= shift_counter - 1'b1;
  end
  endcase
end

always @(posedge clk)
begin
  case(state)
  STATE_IDLE:
    if (s_axis_valid == 1'b1) begin
      step_counter <= 'h00;
      phase <= {1'b0,s_axis_data[61:32]};
      step_counter <= 'h00;
      case (s_axis_data[63:62])
      2'b00: begin
        i <= {s_axis_data[31],s_axis_data[31:0]};
        q <= 'h00;
      end
      2'b01: begin
        i <= 'h00;
        q <= ~{s_axis_data[31],s_axis_data[31:0]};
      end
      2'b10: begin
        i <= ~{s_axis_data[31],s_axis_data[31:0]};
        q <= 'h00;
      end
      2'b11: begin
        i <= 'h00;
        q <= {s_axis_data[31],s_axis_data[31:0]};
      end
      endcase
    end
  STATE_SHIFT_LOAD: begin
    i_shift <= i;
    q_shift <= q;
  end
  STATE_SHIFT: begin
    i_shift <= {i_shift[32],i_shift[32:1]};
    q_shift <= {q_shift[32],q_shift[32:1]};
  end
  STATE_ADD: begin
    if (phase[30] == 1'b0) begin
      i <= i + q_shift;
      q <= q - i_shift;
      phase <= phase - angle[step_counter];
    end else begin
      i <= i - q_shift;
      q <= q + i_shift;
      phase <= phase + angle[step_counter];
    end
    step_counter <= step_counter + 1'b1;
  end
  endcase
end

endmodule
