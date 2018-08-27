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

module jesd204_lmfc (
  input clk,
  input reset,

  input sysref,

  input [7:0] cfg_beats_per_multiframe,
  input [7:0] cfg_lmfc_offset,
  input cfg_sysref_oneshot,
  input cfg_sysref_disable,

  output reg lmfc_edge,
  output reg lmfc_clk,
  output reg [7:0] lmfc_counter,

  output reg sysref_edge,
  output reg sysref_alignment_error
);

reg sysref_r = 1'b0;
reg sysref_d1 = 1'b0;
reg sysref_d2 = 1'b0;
reg sysref_d3 = 1'b0;

reg sysref_captured;

/* lmfc_octet_counter = lmfc_counter * (char_clock_rate / device_clock_rate) */
reg [7:0] lmfc_counter_next = 'h00;

reg lmfc_clk_p1 = 1'b1;

reg lmfc_active = 1'b0;

always @(posedge clk) begin
  sysref_r <= sysref;
end

/*
 * Unfortunately setup and hold are often ignored on the sysref signal relative
 * to the device clock. The device will often still work fine, just not
 * deterministic. Reduce the probability that the meta-stability creeps into the
 * reset of the system and causes non-reproducible issues.
 */
always @(posedge clk) begin
  sysref_d1 <= sysref_r;
  sysref_d2 <= sysref_d1;
  sysref_d3 <= sysref_d2;
end

always @(posedge clk) begin
  if (sysref_d3 == 1'b0 && sysref_d2 == 1'b1 && cfg_sysref_disable == 1'b0) begin
    sysref_edge <= 1'b1;
  end else begin
    sysref_edge <= 1'b0;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    sysref_captured <= 1'b0;
  end else if (sysref_edge == 1'b1) begin
    sysref_captured <= 1'b1;
  end
end

/*
 * The configuration must be static when the core is out of reset. Otherwise
 * undefined behaviour might occur.
 * E.g. lmfc_counter > beats_per_multiframe
 *
 * To change the configuration first assert reset, then update the configuration
 * setting, finally deassert reset.
 */

always @(*) begin
  if (lmfc_counter == cfg_beats_per_multiframe) begin
    lmfc_counter_next <= 'h00;
  end else begin
    lmfc_counter_next <= lmfc_counter + 1'b1;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    lmfc_counter <= 'h01;
    lmfc_active <= cfg_sysref_disable;
  end else begin
    /*
     * In oneshot mode only the first occurence of the
     * SYSREF signal is used for alignment.
     */
    if (sysref_edge == 1'b1 &&
        (cfg_sysref_oneshot == 1'b0 || sysref_captured == 1'b0)) begin
      lmfc_counter <= cfg_lmfc_offset;
      lmfc_active <= 1'b1;
    end else begin
      lmfc_counter <= lmfc_counter_next;
    end
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    sysref_alignment_error <= 1'b0;
  end else begin
    /*
     * Alignement error is reported regardless of oneshot mode
     * setting.
     */
    sysref_alignment_error <= 1'b0;
    if (sysref_edge == 1'b1 && lmfc_active == 1'b1 &&
        lmfc_counter_next != cfg_lmfc_offset) begin
      sysref_alignment_error <= 1'b1;
    end
  end
end

always @(posedge clk) begin
  if (lmfc_counter == 'h00 && lmfc_active == 1'b1) begin
    lmfc_edge <= 1'b1;
  end else begin
    lmfc_edge <= 1'b0;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    lmfc_clk_p1 <= 1'b0;
  end else if (lmfc_active == 1'b1) begin
    if (lmfc_counter == cfg_beats_per_multiframe) begin
      lmfc_clk_p1 <= 1'b1;
    end else if (lmfc_counter == cfg_beats_per_multiframe[7:1]) begin
      lmfc_clk_p1 <= 1'b0;
    end
  end

  lmfc_clk <= lmfc_clk_p1;
end

endmodule
