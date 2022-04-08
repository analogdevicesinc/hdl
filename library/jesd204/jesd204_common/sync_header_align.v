//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have
// by using this source code/core.
//
// The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask
// questions about and improve this core. Distribution of source, or resulting
// binaries (including those inside an FPGA or ASIC) require you to release the
// source of the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary.  If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License. (e.g. they
// do not require you to accompany any image (FPGA or ASIC) using the JESD204
// core with any corresponding source code.) For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a
// license to use this core in a commercial setting without releasing their
// source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required
// to do so; it is up to your common sense to decide whether you want to comply
// with this request or not.) For general publications, we suggest referencing :
// The design and implementation of the JESD204 HDL Core used in this project
// is copyright © 2016-2017, Analog Devices, Inc.
//

`timescale 1ns/100ps

module sync_header_align (
  input clk,
  input reset,

  input [65:0] i_data,
  output i_slip,
  input i_slip_done,

  output [63:0] o_data,
  output [1:0] o_header,
  output o_block_sync
);

  assign {o_header,o_data} = i_data;

  // TODO : Add alignment FSM
  localparam STATE_SH_HUNT = 3'b001;
  localparam STATE_SH_SLIP = 3'b010;
  localparam STATE_SH_LOCK = 3'b100;

  localparam BIT_SH_HUNT = 0;
  localparam BIT_SH_SLIP = 1;
  localparam BIT_SH_LOCK = 2;

  localparam RX_THRESH_SH_ERR = 16;
  localparam LOG2_RX_THRESH_SH_ERR = $clog2(RX_THRESH_SH_ERR);

  reg [2:0] state = STATE_SH_HUNT;
  reg [2:0] next_state;

  reg [7:0] header_vcnt = 8'h0;
  reg [LOG2_RX_THRESH_SH_ERR:0] header_icnt = 'h0;

  wire valid_header;
  assign valid_header = ^o_header;

  always @(posedge clk) begin
    if (reset | ~valid_header) begin
      header_vcnt <= 'b0;
    end else if (state[BIT_SH_HUNT] & ~header_vcnt[7]) begin
      header_vcnt <= header_vcnt + 'b1;
    end
  end

  always @(posedge clk) begin
    if (reset | valid_header) begin
      header_icnt <= 'b0;
    end else if (state[BIT_SH_LOCK] & ~header_icnt[LOG2_RX_THRESH_SH_ERR]) begin
      header_icnt <= header_icnt + 'b1;
    end
  end

  always @(*) begin
    next_state = state;
    case (state)
      STATE_SH_HUNT:
        if (valid_header) begin
          if (header_vcnt[7]) begin
            next_state = STATE_SH_LOCK;
          end
        end else begin
          next_state = STATE_SH_SLIP;
        end
      STATE_SH_SLIP:
        if (i_slip_done) begin
          next_state = STATE_SH_HUNT;
        end
      STATE_SH_LOCK:
        if (~valid_header) begin
          if (header_icnt[LOG2_RX_THRESH_SH_ERR]) begin
            next_state = STATE_SH_HUNT;
          end
        end
    endcase
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      state <= STATE_SH_HUNT;
    end else begin
      state <= next_state;
    end
  end

  assign o_block_sync = state[BIT_SH_LOCK];
  assign i_slip = state[BIT_SH_SLIP];

endmodule
