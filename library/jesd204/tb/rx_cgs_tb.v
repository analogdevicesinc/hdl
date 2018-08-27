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

module rx_cgs_tb;
  parameter VCD_FILE = "rx_cgs_tb.vcd";

  `define TIMEOUT 1000
  `include "tb_base.v"

  reg [3:0] char_is_error = 4'b0000;
  reg [3:0] char_is_cgs = 4'b1111;

  integer counter = 'h00;
  wire ready;
  reg ready_prev = 1'b0;
/*
  always @(posedge clk) begin
    if ($random % 2 == 0)
      char_is_error <= 4'b1111;
    else
      char_is_error <= 4'b0000;
  end
*/
  always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 'h20) begin
      char_is_cgs <= 4'b0001;
    end else if (counter > 'h20) begin
      char_is_cgs <= 4'b0000;
    end
  end

  jesd204_rx_cgs i_rx_cgs (
    .clk(clk),
    .reset(reset),
    .char_is_cgs(char_is_cgs),
    .char_is_error(char_is_error),

    .ready(ready)
  );

  reg lost_sync = 1'b0;

  always @(posedge clk) begin
    ready_prev <= ready;
    if (ready_prev == 1'b1 && ready == 1'b0) begin
      lost_sync <= 1'b1;
    end
    failed <= lost_sync | ~ready;
  end

endmodule
