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
// “The design and implementation of the JESD204 HDL Core used in this project
// is copyright © 2016-2017, Analog Devices, Inc.”
//

`timescale 1ns/100ps

module jesd204_rx_ctrl_64b #(
  parameter NUM_LANES = 1
) (
  input clk,
  input reset,

  input [NUM_LANES-1:0] cfg_lanes_disable,

  input [NUM_LANES-1:0] phy_block_sync,

  input [NUM_LANES-1:0] emb_lock,

  output all_emb_lock,
  input buffer_release_n,

  output [1:0] status_state,
  output reg event_unexpected_lane_state_error
);


localparam STATE_RESET = 2'b00;
localparam STATE_WAIT_BS = 2'b01;
localparam STATE_BLOCK_SYNC = 2'b10;
localparam STATE_DATA = 2'b11;

reg [1:0] state = STATE_RESET;
reg [1:0] next_state;
reg [5:0] good_cnt;
reg rst_good_cnt;

wire [NUM_LANES-1:0] phy_block_sync_masked;
wire [NUM_LANES-1:0] emb_lock_masked;
wire all_block_sync;

assign phy_block_sync_masked = phy_block_sync | cfg_lanes_disable;
assign emb_lock_masked = emb_lock | cfg_lanes_disable;

assign all_block_sync = &phy_block_sync_masked;
assign all_emb_lock = &emb_lock_masked;

always @(*) begin
  next_state = state;
  rst_good_cnt = 1'b1;
  event_unexpected_lane_state_error = 1'b0;
  case (state)
    STATE_RESET:
      next_state = STATE_WAIT_BS;
    STATE_WAIT_BS:
      if (all_block_sync) begin
        rst_good_cnt = 1'b0;
        if (&good_cnt) begin
          next_state = STATE_BLOCK_SYNC;
        end
      end
    STATE_BLOCK_SYNC:
      if (~all_block_sync) begin
        next_state = STATE_WAIT_BS;
      end else if (all_emb_lock & ~buffer_release_n) begin
        rst_good_cnt = 1'b0;
        if (&good_cnt) begin
          next_state = STATE_DATA;
        end
      end
    STATE_DATA:
      if (~all_block_sync) begin
        next_state = STATE_WAIT_BS;
        event_unexpected_lane_state_error = 1'b1;
      end else if (~all_emb_lock | buffer_release_n) begin
        next_state = STATE_BLOCK_SYNC;
        event_unexpected_lane_state_error = 1'b1;
      end
  endcase
end

// Wait n consecutive valid cycles before jumping into next state
always @(posedge clk) begin
  if (reset || rst_good_cnt) begin
    good_cnt <= 'h0;
  end else begin
    good_cnt <= good_cnt + 1;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    state <= STATE_RESET;
  end else begin
    state <= next_state;
  end
end

assign status_state = state;

endmodule
