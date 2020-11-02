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

module axi_jesd204_rx #(
  parameter ID = 0,
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter LINK_MODE = 1, // 2 - 64B/66B;  1 - 8B/10B
  parameter ENABLE_LINK_STATS = 0
) (
  input s_axi_aclk,
  input s_axi_aresetn,

  input s_axi_awvalid,
  input [13:0] s_axi_awaddr,
  output s_axi_awready,
  input [2:0] s_axi_awprot,
  input s_axi_wvalid,
  input [31:0] s_axi_wdata,
  input [3:0] s_axi_wstrb,
  output s_axi_wready,
  output s_axi_bvalid,
  output [1:0] s_axi_bresp,
  input s_axi_bready,
  input s_axi_arvalid,
  input [13:0] s_axi_araddr,
  output s_axi_arready,
  input [2:0] s_axi_arprot,
  output s_axi_rvalid,
  input s_axi_rready,
  output [ 1:0] s_axi_rresp,
  output [31:0] s_axi_rdata,

  output irq,

  input core_clk,
  input core_reset_ext,
  output core_reset,

  output [NUM_LANES-1:0] core_cfg_lanes_disable,
  output [NUM_LINKS-1:0] core_cfg_links_disable,
  output [7:0] core_cfg_beats_per_multiframe,
  output [7:0] core_cfg_octets_per_frame,
  output core_cfg_disable_scrambler,
  output core_cfg_disable_char_replacement,
  output [7:0] core_cfg_lmfc_offset,
  output core_cfg_sysref_oneshot,
  output core_cfg_sysref_disable,
  output core_cfg_buffer_early_release,
  output [7:0] core_cfg_buffer_delay,
  output [7:0] core_cfg_frame_align_err_threshold,

  input [NUM_LANES-1:0] core_ilas_config_valid,
  input [2*NUM_LANES-1:0] core_ilas_config_addr,
  input [32*NUM_LANES-1:0] core_ilas_config_data,

  input core_event_sysref_alignment_error,
  input core_event_sysref_edge,
  input core_event_frame_alignment_error,
  input core_event_unexpected_lane_state_error,

  output [6:0] core_ctrl_err_statistics_mask,
  output core_ctrl_err_statistics_reset,

  input [32*NUM_LANES-1:0] core_status_err_statistics_cnt,

  input [1:0] core_status_ctrl_state,
  input [2*NUM_LANES-1:0] core_status_lane_cgs_state,
  input [3*NUM_LANES-1:0] core_status_lane_emb_state,
  input [NUM_LANES-1:0] core_status_lane_ifs_ready,
  input [14*NUM_LANES-1:0] core_status_lane_latency,
  input [8*NUM_LANES-1:0] core_status_lane_frame_align_err_cnt
);

localparam PCORE_VERSION = 32'h00010461; // 1.04.a
localparam PCORE_MAGIC = 32'h32303452; // 204R

localparam DATA_PATH_WIDTH = LINK_MODE == 2 ? 3 : 2;

/* Register interface signals */
reg [31:0] up_rdata = 'h0;
reg up_wack = 1'b0;
reg up_rack = 1'b0;
reg up_rreq_d1 = 1'b0;
wire up_wreq;
wire up_rreq;
wire [31:0] up_wdata;
wire [11:0] up_waddr;
wire [11:0] up_raddr;
wire [31:0] up_rdata_common;
wire [31:0] up_rdata_sysref;
wire [31:0] up_rdata_rx;

wire [4:0] up_irq_trigger;

wire up_cfg_is_writeable;
wire up_cfg_sysref_oneshot;
wire up_cfg_sysref_disable;
wire up_cfg_buffer_early_release;
wire [7:0] up_cfg_buffer_delay;
wire [7:0] up_cfg_lmfc_offset;
wire [7:0] up_cfg_frame_align_err_threshold;

wire up_reset;
wire up_reset_synchronizer;
wire up_event_frame_alignment_error;
wire up_event_unexpected_lane_state_error;

sync_event #(
  .NUM_OF_EVENTS (2)
) i_sync_frame_align_err (
  .in_clk(core_clk),
  .in_event({core_event_unexpected_lane_state_error,
             core_event_frame_alignment_error}),
  .out_clk(s_axi_aclk),
  .out_event({up_event_unexpected_lane_state_error,
              up_event_frame_alignment_error})
);

assign up_irq_trigger = {3'b0,
                         up_event_unexpected_lane_state_error,
                         up_event_frame_alignment_error} &
                        {5{~up_cfg_is_writeable}};

up_axi #(
  .AXI_ADDRESS_WIDTH (14)
) i_up_axi (
  .up_rstn(~up_reset),
  .up_clk(s_axi_aclk),
  .up_axi_awvalid(s_axi_awvalid),
  .up_axi_awaddr(s_axi_awaddr),
  .up_axi_awready(s_axi_awready),
  .up_axi_wvalid(s_axi_wvalid),
  .up_axi_wdata(s_axi_wdata),
  .up_axi_wstrb(s_axi_wstrb),
  .up_axi_wready(s_axi_wready),
  .up_axi_bvalid(s_axi_bvalid),
  .up_axi_bresp(s_axi_bresp),
  .up_axi_bready(s_axi_bready),
  .up_axi_arvalid(s_axi_arvalid),
  .up_axi_araddr(s_axi_araddr),
  .up_axi_arready(s_axi_arready),
  .up_axi_rvalid(s_axi_rvalid),
  .up_axi_rresp(s_axi_rresp),
  .up_axi_rdata(s_axi_rdata),
  .up_axi_rready(s_axi_rready),
  .up_wreq(up_wreq),
  .up_waddr(up_waddr),
  .up_wdata(up_wdata),
  .up_wack(up_wack),
  .up_rreq(up_rreq),
  .up_raddr(up_raddr),
  .up_rdata(up_rdata),
  .up_rack(up_rack)
);

jesd204_up_common #(
  .PCORE_VERSION(PCORE_VERSION),
  .PCORE_MAGIC(PCORE_MAGIC),
  .ID(ID),
  .NUM_LANES(NUM_LANES),
  .NUM_LINKS(NUM_LINKS),
  .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
  .NUM_IRQS(5),
  .EXTRA_CFG_WIDTH(27),
  .LINK_MODE(LINK_MODE),
  .ENABLE_LINK_STATS(ENABLE_LINK_STATS)
) i_up_common (
  .up_clk(s_axi_aclk),
  .ext_resetn(s_axi_aresetn),

  .up_reset(up_reset),
  .up_reset_synchronizer(up_reset_synchronizer),

  .core_clk(core_clk),
  .core_reset_ext(core_reset_ext),
  .core_reset(core_reset),

  .up_raddr(up_raddr),
  .up_rdata(up_rdata_common),
  .up_wreq(up_wreq),
  .up_waddr(up_waddr),
  .up_wdata(up_wdata),

  .up_cfg_is_writeable(up_cfg_is_writeable),

  .up_irq_trigger(up_irq_trigger),
  .irq(irq),

  .core_cfg_beats_per_multiframe(core_cfg_beats_per_multiframe),
  .core_cfg_octets_per_frame(core_cfg_octets_per_frame),
  .core_cfg_lanes_disable(core_cfg_lanes_disable),
  .core_cfg_links_disable(core_cfg_links_disable),
  .core_cfg_disable_scrambler(core_cfg_disable_scrambler),
  .core_cfg_disable_char_replacement(core_cfg_disable_char_replacement),

  .up_extra_cfg({
    /* 19-26 */ up_cfg_frame_align_err_threshold,
    /*    18 */ up_cfg_sysref_disable,
    /*    17 */ up_cfg_sysref_oneshot,
    /*    16 */ up_cfg_buffer_early_release,
    /* 08-15 */ up_cfg_buffer_delay,
    /* 00-07 */ up_cfg_lmfc_offset
  }),
  .core_extra_cfg({
    /* 19-26 */ core_cfg_frame_align_err_threshold,
    /*    18 */ core_cfg_sysref_disable,
    /*    17 */ core_cfg_sysref_oneshot,
    /*    16 */ core_cfg_buffer_early_release,
    /* 08-15 */ core_cfg_buffer_delay,
    /* 00-07 */ core_cfg_lmfc_offset
  })
);

jesd204_up_sysref #(
  .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
) i_up_sysref (
  .up_clk(s_axi_aclk),
  .up_reset(up_reset),

  .core_clk(core_clk),
  .core_event_sysref_edge(core_event_sysref_edge),
  .core_event_sysref_alignment_error(core_event_sysref_alignment_error),

  .up_raddr(up_raddr),
  .up_rdata(up_rdata_sysref),
  .up_wreq(up_wreq),
  .up_waddr(up_waddr),
  .up_wdata(up_wdata),

  .up_cfg_is_writeable(up_cfg_is_writeable),

  .up_cfg_lmfc_offset(up_cfg_lmfc_offset),
  .up_cfg_sysref_oneshot(up_cfg_sysref_oneshot),
  .up_cfg_sysref_disable(up_cfg_sysref_disable)
);

jesd204_up_rx #(
  .NUM_LANES(NUM_LANES),
  .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
) i_up_rx (
  .up_clk(s_axi_aclk),
  .up_reset(up_reset),
  .up_reset_synchronizer(up_reset_synchronizer),

  .core_clk(core_clk),
  .core_reset(core_reset),

  .up_rreq(up_rreq),
  .up_raddr(up_raddr),
  .up_rdata(up_rdata_rx),
  .up_wreq(up_wreq),
  .up_waddr(up_waddr),
  .up_wdata(up_wdata),

  .up_cfg_is_writeable(up_cfg_is_writeable),

  .up_cfg_buffer_early_release(up_cfg_buffer_early_release),
  .up_cfg_buffer_delay(up_cfg_buffer_delay),

  .up_cfg_frame_align_err_threshold(up_cfg_frame_align_err_threshold),

  .core_ctrl_err_statistics_reset(core_ctrl_err_statistics_reset),
  .core_ctrl_err_statistics_mask(core_ctrl_err_statistics_mask),

  .core_status_ctrl_state(core_status_ctrl_state),
  .core_status_lane_cgs_state(core_status_lane_cgs_state),
  .core_status_lane_emb_state(core_status_lane_emb_state),
  .core_status_lane_ifs_ready(core_status_lane_ifs_ready),
  .core_status_lane_latency(core_status_lane_latency),
  .core_status_lane_frame_align_err_cnt(core_status_lane_frame_align_err_cnt),

  .core_status_err_statistics_cnt(core_status_err_statistics_cnt),

  .core_ilas_config_valid(core_ilas_config_valid),
  .core_ilas_config_addr(core_ilas_config_addr),
  .core_ilas_config_data(core_ilas_config_data)
);

always @(posedge s_axi_aclk) begin
  up_wack <= up_wreq;

  // ILAS memory takes one clock cycle before the data is ready, hence the extra
  // delay.
  up_rreq_d1 <= up_rreq;
  up_rack <= up_rreq_d1;
  if (up_rreq_d1 == 1'b1) begin
    up_rdata <= up_rdata_common | up_rdata_sysref | up_rdata_rx;
  end
end

endmodule
