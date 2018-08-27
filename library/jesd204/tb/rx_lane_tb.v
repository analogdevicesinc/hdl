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

module rx_lane_tb;
  parameter VCD_FILE = "rx_lane_tb.vcd";

  `include "tb_base.v"

  reg [31:0] data = {4{{3'd5,5'd28}}};
  reg [3:0] disperr = 4'b0000;
  reg [3:0] notintable = 4'b0000;
  reg [3:0] charisk = 4'b1111;

  wire ilas_config_valid;
  wire [1:0] ilas_config_addr;
  wire [4*8-1:0] ilas_config_data;
  wire [31:0] status_err_statistics_cnt;

  wire [4*8-1:0] rx_data;

  wire [1:0] status_cgs_state;
  wire status_ifs_ready;
  wire [1:0] status_frame_align;

  integer counter = 'h00;
  wire [31:0] counter2 = (counter - 'h20) * 4;

  always @(posedge clk) begin
    if ($urandom % 400 == 0)
      disperr <= 4'b1111;
    else if ($urandom % 400 == 1)
      disperr <= 4'b0001;
    else if ($urandom % 400 == 2)
      disperr <= 4'b0011;
    else if ($urandom % 400 == 3)
      disperr <= 4'b0111;
    else
      disperr <= 4'b0000;
  end

  always @(posedge clk) begin
    if ($random % 500 == 0)
      notintable <= 4'b1111;
    else
      notintable <= 4'b0000;
  end

  always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 'h20) begin
      charisk <= 'h0001;
      data[31:8] <= {{24'h020100}};
    end else if (counter == 'h21) begin
      charisk <= 'h0000;
      data[31:0] <= {{32'h06050403}};
    end else if (counter > 'h21) begin
      data <= (counter2 + 'h2) << 24 |
              (counter2 + 'h1) << 16 |
          (counter2 + 'h0) << 8 |
          (counter2 - 'h1);
      charisk <= 4'b0000;
    end
  end

  reg buffer_release_n = 1'b0;
  wire buffer_ready_n;

  always @(posedge clk) begin
    buffer_release_n <= buffer_ready_n;
  end

  jesd204_rx_lane i_rx_lane (
    .clk(clk),
    .reset(1'b0),

    .phy_data(data),
    .phy_charisk(charisk),
    .phy_disperr(disperr),
    .phy_notintable(notintable),

    .cgs_reset(reset),
    .cgs_ready(),

    .ifs_reset(1'b0),

    .rx_data(rx_data),

    .buffer_release_n(buffer_release_n),
    .buffer_ready_n(buffer_ready_n),

    .cfg_disable_scrambler(1'b0),
    .ilas_config_valid(ilas_config_valid),
    .ilas_config_addr(ilas_config_addr),
    .ilas_config_data(ilas_config_data),

    .ctrl_err_statistics_reset(1'b0),
    .ctrl_err_statistics_mask(3'h7),
    .status_err_statistics_cnt(status_err_statistics_cnt),

    .status_cgs_state(status_cgs_state),
    .status_ifs_ready(status_ifs_ready),
    .status_frame_align(status_frame_align)
  );

endmodule
