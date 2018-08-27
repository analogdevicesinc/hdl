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

module jesd204_ilas_monitor #(
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input [DATA_PATH_WIDTH*8-1:0] data,
  input [DATA_PATH_WIDTH-1:0] charisk28,

  output reg ilas_config_valid,
  output reg [1:0] ilas_config_addr,
  output reg [DATA_PATH_WIDTH*8-1:0] ilas_config_data,

  output data_ready_n
);

reg [3:0] multi_frame_counter = 'h00;
reg [7:0] frame_counter = 'h00;
reg [7:0] length = 'h00;

localparam STATE_ILAS = 1'b1;
localparam STATE_DATA = 1'b0;

reg state = STATE_ILAS;
reg next_state;
reg prev_was_last = 1'b0;
reg frame_length_error = 1'b0;

assign data_ready_n = next_state;

always @(*) begin
  next_state <= state;
  if (reset == 1'b0 && prev_was_last == 1'b1) begin
    if (charisk28[0] != 1'b1 || data[7:5] != 3'h0) begin
      next_state <= STATE_DATA;
    end
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    state <= STATE_ILAS;
  end else begin
    state <= next_state;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1 || (charisk28[3] == 1'b1 && data[31:29] == 3'h3)) begin
    prev_was_last <= 1'b1;
  end else begin
    prev_was_last <= 1'b0;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    multi_frame_counter <= 'h00;
  end else if (charisk28[0] == 1'b1 && data[7:5] == 3'h0 && state == STATE_ILAS) begin
    multi_frame_counter <= multi_frame_counter + 1'b1;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    length <= 'h00;
  end else if (prev_was_last == 1'b1) begin
    if (length == 'h00) begin
      length <= frame_counter;
    end
  end
end

always @(posedge clk) begin
  frame_length_error <= 1'b0;
  if (prev_was_last == 1'b1) begin
    if (length != 'h00 && length != frame_counter) begin
      frame_length_error <= 1'b1;
    end
  end
end

always @(posedge clk) begin
  if (prev_was_last == 1'b1) begin
    frame_counter <= 'h00;
  end else begin
    frame_counter <= frame_counter + 1'b1;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    ilas_config_valid <= 1'b0;
  end else if (state == STATE_ILAS) begin
    if (charisk28[1] == 1'b1 && data[15:13] == 3'h4) begin
      ilas_config_valid <= 1'b1;
    end else if (ilas_config_addr == 'h3) begin
      ilas_config_valid <= 1'b0;
    end
  end
end

always @(posedge clk) begin
  if (ilas_config_valid == 1'b0) begin
    ilas_config_addr <= 1'b0;
  end else if (ilas_config_valid == 1'b1) begin
    ilas_config_addr <= ilas_config_addr + 1'b1;
  end
end

always @(posedge clk) begin
  ilas_config_data <= data;
end

endmodule
