// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024, 2026 Analog Devices, Inc. All rights reserved.
// Short identifier: ADIJESD204
//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have by
// using this source code/core.
//
// The JESD204 HDL, is copyright (C) 2016-2026 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask questions
// about and improve this core. Distribution of source, or resulting binaries
// (including those inside an FPGA or ASIC) require you to release the source of
// the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary. If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License (e.g. they do
// not require you to accompany any image (FPGA or ASIC) using the JESD204 core
// with any corresponding source code). For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a license
// to use this core in a commercial setting without releasing their source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required to
// do so; it is up to your common sense to decide whether you want to comply with
// this request or not.) For general publications, we suggest referencing: "The
// design and implementation of the JESD204 HDL Core used in this project is
// copyright (C) 2016-2026, Analog Devices, Inc."
// ***************************************************************************
// ***************************************************************************

module lane_align (
  input         usr_clk,
  input  [31:0] rxdata,
  input         en_char_align,
  output        rx_slide
);

  localparam K_CHARACTER = 32'hBCBCBCBC;

  localparam WAIT_FOR_CHAR_ALIGN = 0;
  localparam CHECK_ALIGNMENT = 1;
  localparam PULSE_SLIDE = 2;
  localparam WAIT_DELAY  = 3;

  reg  [2:0] state = WAIT_FOR_CHAR_ALIGN;
  reg  [2:0] next_state;
  reg  [5:0] counter = 0;
  reg  [5:0] next_counter;
  reg        en_char_align_d1;
  reg        en_char_align_d2;
  wire       en_char_align_edge;
  wire       rx_slide_s;

  always @(posedge usr_clk) begin
    en_char_align_d2 <= en_char_align;
    en_char_align_d1 <= en_char_align_d2;
  end

  assign en_char_align_edge = ~en_char_align_d2 & ~en_char_align_d1 & en_char_align;

  always @(posedge usr_clk) begin
    if (en_char_align_edge) begin
      state <= CHECK_ALIGNMENT;
      counter <= 'd0;
    end else begin
      state <= next_state;
      counter <= next_counter;
    end
  end

  always @(*) begin
    next_counter <= counter;
    case (state)
      WAIT_FOR_CHAR_ALIGN: begin
        if (en_char_align) begin
          next_state <= CHECK_ALIGNMENT;
        end else begin
          next_state <= WAIT_FOR_CHAR_ALIGN;
        end
      end
      CHECK_ALIGNMENT: begin
        if (rxdata == K_CHARACTER) begin
          next_state <= WAIT_FOR_CHAR_ALIGN;
        end else begin
          next_counter <= 'd0;
          next_state <= PULSE_SLIDE;
        end
      end
      PULSE_SLIDE: begin // a pulse is valid only if it takes 2 usr_clk cycles
        if (counter == 'd1) begin
          next_state <= WAIT_DELAY;
          next_counter <= 'd0;
        end else begin
          next_state <= PULSE_SLIDE;
          next_counter <= counter + 1'b1;
        end
      end
      WAIT_DELAY: begin // wait 32 usr_clk cycles between each pulse
        if (counter[5]) begin
          next_state <= CHECK_ALIGNMENT;
        end else begin
          next_state <= WAIT_DELAY;
          next_counter <= counter + 1'b1;
        end
      end
    endcase
  end

  assign rx_slide_s = (state == PULSE_SLIDE)? 1'b1 : 1'b0;

  assign rx_slide = rx_slide_s;

endmodule
