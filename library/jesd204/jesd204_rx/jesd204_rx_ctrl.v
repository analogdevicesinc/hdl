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

module jesd204_rx_ctrl #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1
) (
  input clk,
  input reset,

  input [NUM_LANES-1:0] cfg_lanes_disable,
  input [NUM_LINKS-1:0] cfg_links_disable,

  input phy_ready,

  output phy_en_char_align,

  output [NUM_LANES-1:0] cgs_reset,
  input [NUM_LANES-1:0] cgs_ready,

  output [NUM_LANES-1:0] ifs_reset,

  input lmfc_edge,

  output [NUM_LINKS-1:0] sync,
  output reg latency_monitor_reset,

  output [1:0] status_state,
  output event_data_phase
);

localparam STATE_RESET = 0;
localparam STATE_WAIT_FOR_PHY = 1;
localparam STATE_CGS = 2;
localparam STATE_SYNCHRONIZED = 3;

reg [2:0] state = STATE_RESET;
reg [2:0] next_state = STATE_RESET;

reg [NUM_LANES-1:0] cgs_rst = {NUM_LANES{1'b1}};
reg [NUM_LANES-1:0] ifs_rst = {NUM_LANES{1'b1}};
reg [NUM_LINKS-1:0] sync_n = {NUM_LINKS{1'b1}};
reg en_align = 1'b0;
reg state_good = 1'b0;

reg [7:0] good_counter = 'h00;

wire [7:0] good_cnt_limit_s;
wire       good_cnt_limit_reached_s;

assign cgs_reset = cgs_rst;
assign ifs_reset = ifs_rst;
assign sync = sync_n;
assign phy_en_char_align = en_align;

assign status_state = state;

always @(posedge clk) begin
  case (state)
  STATE_RESET: begin
    cgs_rst <= {NUM_LANES{1'b1}};
    ifs_rst <= {NUM_LANES{1'b1}};
    sync_n <= {NUM_LINKS{1'b1}};
    latency_monitor_reset <= 1'b1;
  end
  STATE_CGS: begin
    sync_n <= cfg_links_disable;
    cgs_rst <= cfg_lanes_disable;
  end
  STATE_SYNCHRONIZED: begin
    if (lmfc_edge == 1'b1) begin
      sync_n <= {NUM_LINKS{1'b1}};
      ifs_rst <= cfg_lanes_disable;
      latency_monitor_reset <= 1'b0;
    end
  end
  endcase
end

always @(*) begin
  case (state)
  STATE_RESET: state_good = 1'b1;
  STATE_WAIT_FOR_PHY: state_good = phy_ready;
  STATE_CGS: state_good = &(cgs_ready | cfg_lanes_disable);
  STATE_SYNCHRONIZED: state_good = 1'b1;
  default: state_good = 1'b0;
  endcase
end

assign good_cnt_limit_s = (state == STATE_CGS) ? 'hff : 'h7;
assign good_cnt_limit_reached_s = good_counter == good_cnt_limit_s;

always @(posedge clk) begin
  if (reset) begin
    good_counter <= 'h00;
  end else if (state_good == 1'b1) begin
    if (good_cnt_limit_reached_s) begin
      good_counter <= 'h00;
    end else begin
      good_counter <= good_counter + 1'b1;
    end
  end else begin
    good_counter <= 'h00;
  end
end

always @(posedge clk) begin
  case (state)
  STATE_CGS: en_align <= 1'b1;
  default: en_align <= 1'b0;
  endcase
end

always @(*) begin
  case (state)
  STATE_RESET: next_state = STATE_WAIT_FOR_PHY;
  STATE_WAIT_FOR_PHY: next_state = STATE_CGS;
  STATE_CGS: next_state = STATE_SYNCHRONIZED;
  default: next_state = state_good ? state : STATE_RESET;
  endcase
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    state <= STATE_RESET;
  end else begin
    if (good_cnt_limit_reached_s) begin
      state <= next_state;
    end
  end
end

assign event_data_phase = state == STATE_CGS &&
                          next_state == STATE_SYNCHRONIZED &&
                          good_cnt_limit_reached_s;

endmodule
