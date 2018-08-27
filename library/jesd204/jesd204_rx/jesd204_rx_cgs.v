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

module jesd204_rx_cgs #(
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input [DATA_PATH_WIDTH-1:0] char_is_cgs,
  input [DATA_PATH_WIDTH-1:0] char_is_error,

  output ready,

  output [1:0] status_state
);

localparam CGS_STATE_INIT = 2'b00;
localparam CGS_STATE_CHECK = 2'b01;
localparam CGS_STATE_DATA = 2'b10;

reg [1:0] state = CGS_STATE_INIT;
reg rdy = 1'b0;
reg [1:0] beat_error_count = 'h00;

wire beat_is_cgs = &char_is_cgs;
wire beat_has_error = |char_is_error;
wire beat_is_all_error = &char_is_error;

assign ready = rdy;
assign status_state = state;

always @(posedge clk) begin
  if (state == CGS_STATE_INIT) begin
    beat_error_count <= 'h00;
  end else begin
    if (beat_has_error == 1'b1) begin
      beat_error_count <= beat_error_count + 1'b1;
    end else begin
      beat_error_count <= 'h00;
    end
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    state <= CGS_STATE_INIT;
  end else begin
    case (state)
    CGS_STATE_INIT: begin
      if (beat_is_cgs == 1'b1) begin
        state <= CGS_STATE_CHECK;
      end
    end
    CGS_STATE_CHECK: begin
      if (beat_has_error == 1'b1) begin
        if (beat_error_count == 'h3 ||
            beat_is_all_error == 1'b1) begin
          state <= CGS_STATE_INIT;
        end
      end else begin
        state <= CGS_STATE_DATA;
      end
    end
    CGS_STATE_DATA: begin
      if (beat_has_error == 1'b1) begin
        state <= CGS_STATE_CHECK;
      end
    end
    endcase
  end
end

always @(posedge clk) begin
  case (state)
  CGS_STATE_INIT: rdy <= 1'b0;
  CGS_STATE_DATA: rdy <= 1'b1;
  default: rdy <= rdy;
  endcase
end

endmodule
