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

module jesd204_tx #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter NUM_OUTPUT_PIPELINE = 0,
  parameter LINK_MODE = 1, // 2 - 64B/66B;  1 - 8B/10B
  /* Only 4 is supported at the moment for 8b/10b and 8 for 64b */
  parameter DATA_PATH_WIDTH = LINK_MODE[1] ? 8 : 4
) (
  input clk,
  input reset,

  output [DATA_PATH_WIDTH*8*NUM_LANES-1:0] phy_data,
  output [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_charisk,
  output [2*NUM_LANES-1:0] phy_header,

  input sysref,
  output lmfc_edge,
  output lmfc_clk,

  input [NUM_LINKS-1:0] sync,

  input [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_data,
  output tx_ready,
  input tx_valid,

  input [NUM_LANES-1:0] cfg_lanes_disable,
  input [NUM_LINKS-1:0] cfg_links_disable,
  input [7:0] cfg_beats_per_multiframe,
  input [7:0] cfg_octets_per_frame,
  input [7:0] cfg_lmfc_offset,
  input cfg_sysref_oneshot,
  input cfg_sysref_disable,
  input cfg_continuous_cgs,
  input cfg_continuous_ilas,
  input cfg_skip_ilas,
  input [7:0] cfg_mframes_per_ilas,
  input cfg_disable_char_replacement,
  input cfg_disable_scrambler,

  output ilas_config_rd,
  output [1:0] ilas_config_addr,
  input [32*NUM_LANES-1:0] ilas_config_data,

  input ctrl_manual_sync_request,

  output event_sysref_edge,
  output event_sysref_alignment_error,

  output [NUM_LINKS-1:0] status_sync,
  output [1:0] status_state
);


localparam MAX_OCTETS_PER_FRAME = 8;
localparam MAX_OCTETS_PER_MULTIFRAME =
  (MAX_OCTETS_PER_FRAME * 32) > 1024 ? 1024 : (MAX_OCTETS_PER_FRAME * 32);
localparam MAX_BEATS_PER_MULTIFRAME = MAX_OCTETS_PER_MULTIFRAME / DATA_PATH_WIDTH;

localparam LMFC_COUNTER_WIDTH = MAX_BEATS_PER_MULTIFRAME > 256 ? 9 :
  MAX_BEATS_PER_MULTIFRAME > 128 ? 8 :
  MAX_BEATS_PER_MULTIFRAME > 64 ? 7 :
  MAX_BEATS_PER_MULTIFRAME > 32 ? 6 :
  MAX_BEATS_PER_MULTIFRAME > 16 ? 5 :
  MAX_BEATS_PER_MULTIFRAME > 8 ? 4 :
  MAX_BEATS_PER_MULTIFRAME > 4 ? 3 :
  MAX_BEATS_PER_MULTIFRAME > 2 ? 2 : 1;

localparam DW = DATA_PATH_WIDTH * 8 * NUM_LANES;
localparam CW = DATA_PATH_WIDTH * NUM_LANES;
localparam HW = 2 * NUM_LANES;



wire [DW-1:0] phy_data_r;
wire [CW-1:0] phy_charisk_r;
wire [HW-1:0] phy_header_r;

wire lmc_edge;
wire lmc_quarter_edge;
wire eoemb;

jesd204_lmfc i_lmfc (
  .clk(clk),
  .reset(reset),

  .cfg_beats_per_multiframe(cfg_beats_per_multiframe),
  .cfg_lmfc_offset(cfg_lmfc_offset),
  .cfg_sysref_oneshot(cfg_sysref_oneshot),
  .cfg_sysref_disable(cfg_sysref_disable),

  .sysref(sysref),

  .sysref_edge(event_sysref_edge),
  .sysref_alignment_error(event_sysref_alignment_error),

  .lmfc_edge(lmfc_edge),
  .lmfc_clk(lmfc_clk),
  .lmfc_counter(),
  .lmc_edge(lmc_edge),
  .lmc_quarter_edge(lmc_quarter_edge),
  .eoemb(eoemb)
);

generate
genvar i;

if (LINK_MODE[0] == 1) begin : mode_8b10b

wire eof_gen_reset;
wire [DATA_PATH_WIDTH-1:0] eof;
wire eomf;

wire [NUM_LANES-1:0] lane_cgs_enable;

wire [DW-1:0] ilas_data;
wire [DATA_PATH_WIDTH-1:0] ilas_charisk;

wire cfg_generate_eomf = 1'b1;

jesd204_tx_ctrl #(
  .NUM_LANES(NUM_LANES),
  .NUM_LINKS(NUM_LINKS),
  .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
) i_tx_ctrl (
  .clk(clk),
  .reset(reset),

  .sync(sync),
  .lmfc_edge(lmfc_edge),

  .lane_cgs_enable(lane_cgs_enable),
  .eof_reset(eof_gen_reset),

  .tx_ready(tx_ready),

  .ilas_data(ilas_data),
  .ilas_charisk(ilas_charisk),

  .ilas_config_addr(ilas_config_addr),
  .ilas_config_rd(ilas_config_rd),
  .ilas_config_data(ilas_config_data),

  .cfg_lanes_disable(cfg_lanes_disable),
  .cfg_links_disable(cfg_links_disable),
  .cfg_continuous_cgs(cfg_continuous_cgs),
  .cfg_continuous_ilas(cfg_continuous_ilas),
  .cfg_skip_ilas(cfg_skip_ilas),
  .cfg_mframes_per_ilas(cfg_mframes_per_ilas),
  .cfg_disable_char_replacement(cfg_disable_char_replacement),

  .ctrl_manual_sync_request(ctrl_manual_sync_request),

  .status_sync(status_sync),
  .status_state(status_state)
);

jesd204_eof_generator #(
  .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
  .MAX_OCTETS_PER_FRAME(MAX_OCTETS_PER_FRAME)
) i_eof_gen (
  .clk(clk),
  .reset(eof_gen_reset),

  .cfg_octets_per_frame(cfg_octets_per_frame),
  .cfg_generate_eomf(cfg_generate_eomf),

  .lmfc_edge(lmfc_edge),
  .sof(),
  .eof(eof),
  .eomf(eomf)
);



for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane

  localparam D_START = i * DATA_PATH_WIDTH*8;
  localparam D_STOP = D_START + DATA_PATH_WIDTH*8-1;
  localparam C_START = i * DATA_PATH_WIDTH;
  localparam C_STOP = C_START + DATA_PATH_WIDTH-1;

  jesd204_tx_lane #(
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
  ) i_lane (
    .clk(clk),

    .eof(eof),
    .eomf(eomf),

    .cgs_enable(lane_cgs_enable[i]),

    .ilas_data(ilas_data[D_STOP:D_START]),
    .ilas_charisk(ilas_charisk),

    .tx_data(tx_data[D_STOP:D_START]),
    .tx_ready(tx_ready),

    .phy_data(phy_data_r[D_STOP:D_START]),
    .phy_charisk(phy_charisk_r[C_STOP:C_START]),

    .cfg_disable_scrambler(cfg_disable_scrambler)
  );
end

assign phy_header_r = 'h0;

end

if (LINK_MODE[1] == 1) begin : mode_64b66b
  reg tx_ready_loc;

  for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane
    localparam D_START = i * DATA_PATH_WIDTH*8;
    localparam D_STOP = D_START + DATA_PATH_WIDTH*8-1;
    localparam H_START = i * 2;
    localparam H_STOP = H_START + 2 -1;
    jesd204_tx_lane_64b i_lane(
      .clk(clk),
      .reset(reset),

      .tx_data(tx_data[D_STOP:D_START]),
      .tx_ready(tx_ready_loc),

      .phy_data(phy_data_r[D_STOP:D_START]),
      .phy_header(phy_header_r[H_STOP:H_START]),

      .lmc_edge(lmc_edge),
      .lmc_quarter_edge(lmc_quarter_edge),
      .eoemb(eoemb),

      .cfg_disable_scrambler(cfg_disable_scrambler),
      .cfg_header_mode(2'b0),
      .cfg_lane_disable(cfg_lanes_disable[i])
    );
  end

  always @(posedge clk) begin
    if (reset) begin
      tx_ready_loc <= 1'b0;
    end else if (lmfc_edge) begin
      tx_ready_loc <= 1'b1;
    end
  end

  assign tx_ready = tx_ready_loc;
  // Link considered in DATA phase when SYSREF received and LEMC clock started
  // running
  assign status_state = {2{tx_ready_loc}};


  assign phy_charisk_r = 'h0;
  assign ilas_config_rd = 'h0;
  assign ilas_config_addr = 'h0;
  assign status_sync = 'h0;

end

endgenerate

pipeline_stage #(
  .WIDTH(CW + DW + HW),
  .REGISTERED(NUM_OUTPUT_PIPELINE)
) i_output_pipeline_stage (
  .clk(clk),
  .in({
    phy_data_r,
    phy_charisk_r,
    phy_header_r
  }),
  .out({
    phy_data,
    phy_charisk,
    phy_header
  })
);

endmodule
