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

module error_monitor #(
  parameter EVENT_WIDTH = 16,
  parameter CNT_WIDTH = 32
) (
  input clk,
  input reset,
  input active,
  input [EVENT_WIDTH-1:0] error_event,
  input [EVENT_WIDTH-1:0] error_event_mask,
  output reg [CNT_WIDTH-1:0] status_err_cnt = 'h0
);

localparam EVENT_WIDTH_LOG = $clog2(EVENT_WIDTH);

reg  [EVENT_WIDTH-1:0] err;

function [EVENT_WIDTH_LOG-1:0] num_set_bits;
input [EVENT_WIDTH-1:0] x;
integer j;
begin
  num_set_bits = 0;
  for (j = 0; j < EVENT_WIDTH; j = j + 1) begin
    num_set_bits = num_set_bits + x[j];
  end
end
endfunction

always @(posedge clk) begin
  if (active == 1'b1) begin
    err <= (~error_event_mask) & error_event;
  end else begin
    err <= {EVENT_WIDTH{1'b0}};
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    status_err_cnt <= 'h0;
  end else if (~&status_err_cnt[CNT_WIDTH-1:EVENT_WIDTH_LOG]) begin
    status_err_cnt <= status_err_cnt + num_set_bits(err);
  end
end

endmodule
