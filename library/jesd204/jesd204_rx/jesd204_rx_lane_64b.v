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

module jesd204_rx_lane_64b #(
  parameter ELASTIC_BUFFER_SIZE = 256
) (
  input clk,
  input reset,

  input [63:0] phy_data,
  input [1:0] phy_header,
  input phy_block_sync,

  output [63:0] rx_data,

  output reg buffer_ready_n = 'b1,
  input all_buffer_ready_n,
  input buffer_release_n,

  input lmfc_edge,
  output emb_lock,

  input cfg_disable_scrambler,
  input [1:0] cfg_header_mode,  // 0 - CRC12 ; 1 - CRC3; 2 - FEC; 3 - CMD
  input [4:0] cfg_rx_thresh_emb_err,
  input [7:0] cfg_beats_per_multiframe,

  input ctrl_err_statistics_reset,
  input [3:0] ctrl_err_statistics_mask,
  output [31:0] status_err_statistics_cnt,

  output [2:0] status_lane_emb_state,
  output reg [7:0] status_lane_skew
);

reg [11:0] crc12_calculated_prev;

wire [63:0] data_descrambled_s;
wire [63:0] data_descrambled;
wire [11:0] crc12_received;
wire [11:0] crc12_calculated;

wire event_invalid_header;
wire event_unexpected_eomb;
wire event_unexpected_eoemb;
wire event_crc12_mismatch;
wire err_cnt_rst;

wire [63:0] rx_data_msb_s;

wire eomb;
wire eoemb;

wire [7:0] sh_count;

jesd204_rx_header i_rx_header (
  .clk(clk),
  .reset(reset),

  .sh_lock(phy_block_sync),
  .header(phy_header),

  .cfg_header_mode(cfg_header_mode),
  .cfg_rx_thresh_emb_err(cfg_rx_thresh_emb_err),
  .cfg_beats_per_multiframe(cfg_beats_per_multiframe),

  .emb_lock(emb_lock),
  
  .valid_eomb(eomb),
  .valid_eoemb(eoemb),
  .crc12(crc12_received),
  .crc3(),
  .fec(),
  .cmd(),
  .sh_count(sh_count),

  .status_lane_emb_state(status_lane_emb_state),
  .event_invalid_header(event_invalid_header),
  .event_unexpected_eomb(event_unexpected_eomb),
  .event_unexpected_eoemb(event_unexpected_eoemb)
);

jesd204_crc12 i_crc12 (
  .clk(clk),
  .reset(reset),
  .init(eomb),
  .data_in(phy_data),
  .crc12(crc12_calculated)
);

reg crc12_on = 'b0;
always @(posedge clk) begin
  if (reset == 1'b1) begin
    crc12_on <= 1'b0;
  end else if (eomb) begin
    crc12_on <= 1'b1;
  end
end

reg crc12_rdy = 'b0;
always @(posedge clk) begin
  if (reset == 1'b1) begin
    crc12_rdy <= 1'b0;
  end else if (crc12_on && eomb) begin
    crc12_rdy <= 1'b1;
  end
end

always @(posedge clk) begin
  if (eomb) begin
    crc12_calculated_prev <= crc12_calculated;
  end
end

assign event_crc12_mismatch = crc12_rdy && eomb && (crc12_calculated_prev != crc12_received);

assign err_cnt_rst = reset || ctrl_err_statistics_reset;

error_monitor #(
  .EVENT_WIDTH(4),
  .CNT_WIDTH(32)
) i_error_monitor (
  .clk(clk),
  .reset(err_cnt_rst),
  .active(1'b1),
  .error_event({
    event_invalid_header,
    event_unexpected_eomb,
    event_unexpected_eoemb,
    event_crc12_mismatch
  }),
  .error_event_mask(ctrl_err_statistics_mask),
  .status_err_cnt(status_err_statistics_cnt)
);

jesd204_scrambler_64b #(
  .WIDTH(64),
  .DESCRAMBLE(1)
) i_descrambler (
  .clk(clk),
  .reset(reset),
  .enable(~cfg_disable_scrambler),
  .data_in(phy_data),
  .data_out(data_descrambled_s)
);

pipeline_stage #(
  .WIDTH(64),
  .REGISTERED(1)
) i_pipeline_stage2 (
  .clk(clk),
  .in({
      data_descrambled_s
    }),
  .out({
      data_descrambled
    })
);

// Control when data is written to the elastic buffer
// Start writing to the buffer when current lane is multiblock locked, but if
// other lanes are not writing in the next half multiblock period stop
// writing.
// This limits the supported lane skew to half of the multiframe
always @(posedge clk) begin
  if (reset | ~emb_lock) begin
    buffer_ready_n <= 1'b1;
  end else if (sh_count == {1'b0,cfg_beats_per_multiframe[7:1]} && all_buffer_ready_n) begin
    buffer_ready_n <= 1'b1;
  end else if (eoemb) begin
    buffer_ready_n <= 1'b0;
  end
end


elastic_buffer #(
  .WIDTH(64),
  .SIZE(ELASTIC_BUFFER_SIZE)
) i_elastic_buffer (
  .clk(clk),
  .reset(reset),

  .wr_data(data_descrambled),
  .rd_data(rx_data_msb_s),

  .ready_n(buffer_ready_n),
  .do_release_n(buffer_release_n)
);

// Measure the delay from the eoemb to the next LMFC edge.
always @(posedge clk) begin
  if (lmfc_edge) begin
    status_lane_skew <= sh_count;
  end
end


/* Reorder octets LSB first */
genvar i;
generate
  for (i = 0; i < 64; i = i + 8) begin: g_link_data
    assign rx_data[i+:8] = rx_data_msb_s[64-1-i-:8];
  end
endgenerate


endmodule
