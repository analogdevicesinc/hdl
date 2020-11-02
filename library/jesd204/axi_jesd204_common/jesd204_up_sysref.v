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

module jesd204_up_sysref #(
  parameter DATA_PATH_WIDTH = 2
) (
  input up_clk,
  input up_reset,

  input core_clk,

  input [11:0] up_raddr,
  output reg [31:0] up_rdata,

  input up_wreq,
  input [11:0] up_waddr,
  input [31:0] up_wdata,

  input up_cfg_is_writeable,

  output reg up_cfg_sysref_oneshot,
  output reg [7:0] up_cfg_lmfc_offset,
  output reg up_cfg_sysref_disable,

  input core_event_sysref_alignment_error,
  input core_event_sysref_edge
);

reg [1:0] up_sysref_status;
reg [1:0] up_sysref_status_clear;
wire [1:0] up_sysref_event;

sync_event #(
  .NUM_OF_EVENTS(2)
) i_cdc_sysref_event (
  .in_clk(core_clk),
  .in_event({
    core_event_sysref_alignment_error,
    core_event_sysref_edge
  }),
  .out_clk(up_clk),
  .out_event(up_sysref_event)
);

always @(posedge up_clk) begin
  if (up_reset == 1'b1) begin
    up_sysref_status <= 2'b00;
  end else begin
    up_sysref_status <= (up_sysref_status & ~up_sysref_status_clear) | up_sysref_event;
  end
end

always @(*) begin
  case (up_raddr)
  /* JESD SYSREF configuraton */
  12'h040: up_rdata = {
    /* 02-31 */ 30'h00, /* Reserved for future use */
    /*    01 */ up_cfg_sysref_oneshot,
    /*    00 */ up_cfg_sysref_disable
  };
  12'h041: up_rdata = {
    /* 10-31 */ 22'h00, /* Reserved for future use */
    /* 02-09 */ up_cfg_lmfc_offset,
    /* 00-01 */ 2'b00 /* data path alignment for cfg_lmfc_offset */
  };
  12'h042: up_rdata = {
    /* 02-31 */ 30'h00,
    /* 00-01 */ up_sysref_status
  };
  default: up_rdata = 32'h00000000;
  endcase
end

always @(posedge up_clk) begin
  if (up_reset == 1'b1) begin
    up_cfg_sysref_oneshot <= 1'b0;
    up_cfg_lmfc_offset <= 'h00;
    up_cfg_sysref_disable <= 1'b0;
  end else if (up_wreq == 1'b1 && up_cfg_is_writeable == 1'b1) begin
    case (up_waddr)
    /* JESD SYSREF configuraton */
    12'h040: begin
      up_cfg_sysref_oneshot <= up_wdata[1];
      up_cfg_sysref_disable <= up_wdata[0];
    end
    12'h041: begin
      /* Aligned to data path width */
      up_cfg_lmfc_offset <= up_wdata[9:DATA_PATH_WIDTH];
    end
    endcase
  end
end

always @(*) begin
  if (up_wreq == 1'b1 && up_waddr == 12'h042) begin
    up_sysref_status_clear = up_wdata[1:0];
  end else begin
    up_sysref_status_clear = 2'b00;
  end
end

endmodule
