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

module rx_ctrl_tb;
  parameter VCD_FILE = "rx_ctrl_tb.vcd";

  `include "tb_base.v"

  integer phy_reset_counter = 'h00;
  integer align_counter = 'h00;
  integer cgs_counter = 'h00;

  reg phy_ready = 1'b0;
  reg aligned = 1'b0;
  reg cgs_ready = 1'b0;

  wire en_align;
  wire cgs_reset;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      phy_reset_counter <= 'h00;
      phy_ready <= 1'b0;
    end else begin
      if (phy_reset_counter == 'h7) begin
        phy_ready <= 1'b1;
      end else begin
        phy_reset_counter <= phy_reset_counter + 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      aligned <= 1'b0;
      align_counter <= 'h00;
    end else if (phy_ready == 1'b1) begin
      if (en_align == 1'b1) begin
        if (align_counter == 'h20) begin
          aligned <= 1'b1;
        end else begin
          align_counter <= align_counter + 1;
        end
      end
    end
  end


  always @(posedge clk or posedge cgs_reset) begin
    if (cgs_reset == 1'b1) begin
      cgs_counter <= 'h00;
      cgs_ready <= 1'b0;
    end else begin
      if (cgs_counter == 'h20) begin
        cgs_ready <= 1'b1;
      end else begin
        cgs_counter <= cgs_counter + 1;
      end
    end
  end

  jesd204_rx_ctrl i_rx_ctrl (
    .clk(clk),
    .reset(reset),
    .phy_ready(phy_ready),
    .phy_en_char_align(en_align),
    .cgs_reset(cgs_reset),
    .cgs_ready(cgs_ready)
  );

endmodule
