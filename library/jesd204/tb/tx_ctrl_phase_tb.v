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

/*
 * Regardless of the phase relationship between LMFC and sync the output of the
 * ctrl core should be the same as long as the sync signal is in the same lmfc
 * cycle.
 */

`timescale 1ns/100ps

module tx_ctrl_phase_tb;
  parameter VCD_FILE = "tx_ctrl_phase.vcd";
  parameter NUM_LANES = 1;
  parameter BEATS_PER_LMFC = 20;

  `include "tb_base.v"

  reg lmfc_edge = 1'b0;
  reg a_sync = 1'b0;
  reg b_sync = 1'b0;

  wire [31:0] a_ilas_data;
  wire [3:0] a_ilas_charisk;
  wire [1:0] a_ilas_config_addr;
  wire a_ilas_config_rd;
  wire a_tx_ready;
  wire a_lane_cgs_enable;

  wire [31:0] b_ilas_data;
  wire [3:0] b_ilas_charisk;
  wire [1:0] b_ilas_config_addr;
  wire b_ilas_config_rd;
  wire b_tx_ready;
  wire b_lane_cgs_enable;

  reg reset2 = 1'b1;

  integer reset_counter = 0;
  integer beat_counter = 0;
  integer lmfc_counter = 0;
  integer b_offset = 0;

  always @(posedge clk) begin
    if (reset2 == 1'b1) begin
      if (reset_counter == 7) begin
        reset2 <= 1'b0;
        reset_counter <= 0;
      end else begin
        reset_counter <= reset_counter + 1;
      end
    end

    if (reset2 == 1'b1) begin
      beat_counter <= 0;
      a_sync <= 1'b0;
      b_sync <= 1'b0;
    end else begin
      beat_counter <= beat_counter + 1'b1;
      if (beat_counter == BEATS_PER_LMFC*2) begin
        a_sync <= 1'b1;
      end

      if (beat_counter == BEATS_PER_LMFC*2 + b_offset) begin
        b_sync <= 1'b1;
      end

      if (beat_counter == BEATS_PER_LMFC*9) begin
        b_offset <= b_offset + 1;
        reset2 <= 1'b1;
      end
    end

    if (reset2 == 1'b1) begin
      lmfc_counter <= BEATS_PER_LMFC-3;
    end else begin
      lmfc_counter <= lmfc_counter + 1;
      if (lmfc_counter == BEATS_PER_LMFC-1) begin
        lmfc_counter <= 0;
        lmfc_edge <= 1'b1;
      end else begin
        lmfc_edge <= 1'b0;
      end
    end
  end

  jesd204_tx_ctrl i_tx_ctrl_a (
    .clk(clk),
    .reset(reset2),

    .sync(a_sync),
    .lmfc_edge(lmfc_edge),

    .lane_cgs_enable(a_lane_cgs_enable),

    .tx_ready(a_tx_ready),

    .ilas_data(a_ilas_data),
    .ilas_charisk(a_ilas_charisk),

    .ilas_config_addr(a_ilas_config_addr),
    .ilas_config_rd(a_ilas_config_rd),
    .ilas_config_data('h00),

    .ctrl_manual_sync_request(1'b0),

    .cfg_continuous_cgs(1'b0),
    .cfg_continuous_ilas(1'b0),
    .cfg_skip_ilas(1'b0),
    .cfg_mframes_per_ilas(8'h3)
  );

  jesd204_tx_ctrl i_tx_ctrl_b (
    .clk(clk),
    .reset(reset2),

    .sync(b_sync),
    .lmfc_edge(lmfc_edge),

    .lane_cgs_enable(b_lane_cgs_enable),

    .tx_ready(b_tx_ready),

    .ilas_data(b_ilas_data),
    .ilas_charisk(b_ilas_charisk),

    .ilas_config_addr(b_ilas_config_addr),
    .ilas_config_rd(b_ilas_config_rd),
    .ilas_config_data('h00),

    .ctrl_manual_sync_request(1'b0),

    .cfg_continuous_cgs(1'b0),
    .cfg_continuous_ilas(1'b0),
    .cfg_skip_ilas(1'b0),
    .cfg_mframes_per_ilas(8'h3)
  );

  reg status = 1'b1;

  always @(*) begin
    if (reset2 == 1'b1) begin
      status <= 1'b1;
    end else if (a_ilas_data != b_ilas_data ||
      a_ilas_charisk != b_ilas_charisk ||
      a_ilas_config_addr != b_ilas_config_addr ||
      a_ilas_config_rd != b_ilas_config_rd ||
      a_lane_cgs_enable != b_lane_cgs_enable ||
      a_tx_ready != b_tx_ready) begin
      status <= 1'b0;
    end
  end

  reg message_shown = 1'b0;

  always @(posedge clk) begin
    if (status == 1'b0 && message_shown == 1'b0 && b_offset < BEATS_PER_LMFC) begin
      $display("FAILED at offset %0d", b_offset);
      message_shown <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (b_offset == BEATS_PER_LMFC+1) begin
      if (message_shown == 1'b0)
        $display("SUCCESS");
      $finish;
    end
  end

endmodule
