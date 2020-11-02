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

module jesd204_up_rx_lane (
  input up_clk,
  input up_reset_synchronizer,

  input up_rreq,
  input [2:0] up_raddr,
  output reg [31:0] up_rdata,

  input [1:0] up_status_cgs_state,
  input [31:0] up_status_err_statistics_cnt,
  input [2:0] up_status_emb_state,
  input [7:0] up_status_lane_frame_align_err_cnt,

  input core_clk,
  input core_reset,

  input core_ilas_config_valid,
  input [1:0] core_ilas_config_addr,
  input [31:0] core_ilas_config_data,

  input core_status_ifs_ready,
  input [13:0] core_status_latency
);

wire [1:0] up_status_ctrl_state;

wire up_status_ifs_ready;
reg [13:0] up_status_latency = 'h00;

wire [31:0] up_ilas_rdata;
wire up_ilas_ready;

sync_bits #(
  .NUM_OF_BITS(1)
) i_cdc_status_ready (
  .in_bits({
    core_status_ifs_ready
  }),
  .out_clk(up_clk),
  .out_resetn(1'b1),
  .out_bits({
    up_status_ifs_ready
  })
);

always @(posedge up_clk) begin
  if (up_reset_synchronizer == 1'b1) begin
    up_status_latency <= 'h00;
  end else begin
    if (up_status_ifs_ready == 1'b1) begin
      up_status_latency <= core_status_latency;
    end
  end
end

always @(*) begin
  if (up_raddr[2] == 1'b1) begin
    if (up_ilas_ready == 1'b1) begin
      up_rdata = up_ilas_rdata;
    end else begin
      up_rdata = 'h00;
    end
  end else begin
    case (up_raddr[1:0])
    2'b00: up_rdata = {
      /* 11-31 */ 21'h0, /* Reserved for future use */
      /* 08-10 */ up_status_emb_state,
      /* 06-07 */ 2'h00,
      /*    05 */ up_ilas_ready,
      /*    04 */ up_status_ifs_ready,
      /* 02-03 */ 2'b00, /* Reserved for future extensions of cgs_state */
      /* 00-01 */ up_status_cgs_state
    };
    2'b01: up_rdata = {
      /* 14-31 */ 18'h00, /* Reserved for future use */
      /* 00-13 */ up_status_latency
    };
    2'b10: up_rdata = {
      /* 00-31 */ up_status_err_statistics_cnt
    };
    2'b11: up_rdata = {
      /* 08-31 */ 24'h0, /* Reserved for future use */
      /* 00-07 */ up_status_lane_frame_align_err_cnt
    };
    default: up_rdata = 'h00;
    endcase
  end
end

jesd204_up_ilas_mem i_ilas_mem (
  .up_clk(up_clk),

  .up_rreq(up_rreq),
  .up_raddr(up_raddr[1:0]),
  .up_rdata(up_ilas_rdata),
  .up_ilas_ready(up_ilas_ready),

  .core_clk(core_clk),
  .core_reset(core_reset),

  .core_ilas_config_valid(core_ilas_config_valid),
  .core_ilas_config_addr(core_ilas_config_addr),
  .core_ilas_config_data(core_ilas_config_data)
);

endmodule
