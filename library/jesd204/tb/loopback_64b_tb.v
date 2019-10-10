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

module loopback_64b_tb;
  parameter VCD_FILE = "loopback_64b_tb.vcd";
  parameter NUM_LANES = 4;
  parameter NUM_LINKS = 1;
  parameter OCTETS_PER_FRAME = 8;
  parameter FRAMES_PER_MULTIFRAME = 32;
  parameter ENABLE_SCRAMBLER = 1;
  parameter BUFFER_EARLY_RELEASE = 0;
  parameter LANE_DELAY = 1;

  localparam BEATS_PER_MULTIFRAME = OCTETS_PER_FRAME * FRAMES_PER_MULTIFRAME / 8;
  localparam TX_LATENCY = 3;
  localparam RX_LATENCY = 3;
  localparam BASE_LATENCY = TX_LATENCY + RX_LATENCY;

  `include "tb_base.v"

  reg [5:0] tx_counter = 'h00;
  reg [5:0] rx_counter = 'h00;
  wire tx_ready;
  wire rx_valid;
  wire [NUM_LANES*64-1:0] rx_data;
  reg data_mismatch = 1'b1;

  always @(posedge clk) begin
    if (tx_ready == 1'b1) begin
      tx_counter <= tx_counter + 1'b1;
    end
  end

  reg rx_valid_d1 = 1'b0;

  always @(posedge clk) begin
    rx_valid_d1 <= rx_valid;
    if (rx_valid == 1'b1) begin
      if (rx_valid_d1 == 1'b0) begin
        // Resynchronize counter to the first received data
        rx_counter <= rx_data[7:2] + 1'b1;
      end else begin
        rx_counter <= rx_counter + 1'b1;
      end
    end
  end

  wire [63:0] tx_data =
      {{tx_counter,2'h0,tx_counter,2'h1,tx_counter,2'h2,tx_counter,2'h3},
       {tx_counter,2'h3,tx_counter,2'h2,tx_counter,2'h1,tx_counter,2'h0}};
  wire [63:0] rx_ref_data =
      {{rx_counter,2'h0,rx_counter,2'h1,rx_counter,2'h2,rx_counter,2'h3},
       {rx_counter,2'h3,rx_counter,2'h2,rx_counter,2'h1,rx_counter,2'h0}};

  wire [NUM_LANES*64-1:0] phy_data_out;
  wire [NUM_LANES*2-1:0] phy_header_out;
  wire [NUM_LANES*64-1:0] phy_data_in;
  wire [NUM_LANES*2-1:0] phy_header_in;
  
  reg [NUM_LANES-1:0] phy_block_sync = {NUM_LANES{1'b1}};

  reg [5:0] sysref_counter = 'h00;
  reg sysref_rx = 1'b0;
  reg sysref_tx = 1'b0;

  always @(posedge clk) begin
    if (sysref_counter == 'h2f)
      sysref_rx <= ~sysref_rx;
    sysref_counter <= sysref_counter + 1'b1;
    sysref_tx <= sysref_rx;
  end

  localparam MAX_LANE_DELAY = LANE_DELAY + NUM_LANES;

  reg [10:0] phy_delay_fifo_wr;
  reg [(2+64)*NUM_LANES-1:0] phy_delay_fifo[0:MAX_LANE_DELAY-1];

  always @(posedge clk) begin
    phy_delay_fifo[phy_delay_fifo_wr] <= {phy_header_out,phy_data_out};

    if (reset == 1'b1 || phy_delay_fifo_wr == MAX_LANE_DELAY-1) begin
      phy_delay_fifo_wr <= 'h00;
    end else begin
      phy_delay_fifo_wr <= phy_delay_fifo_wr + 1'b1;
    end
  end

  genvar i;
  generate for (i = 0; i < NUM_LANES; i = i + 1) begin
    localparam OFF = MAX_LANE_DELAY - (i + LANE_DELAY);

    assign phy_data_in[64*i+63:64*i] =
      phy_delay_fifo[(phy_delay_fifo_wr + OFF) % MAX_LANE_DELAY][64*i+63:64*i];

    assign phy_header_in[2*i+1:2*i] =
      phy_delay_fifo[(phy_delay_fifo_wr + OFF) % MAX_LANE_DELAY][2*i+1+NUM_LANES*64 : 2*i+64*NUM_LANES];

  end endgenerate

  wire [NUM_LANES-1:0] tx_cfg_lanes_disable;
  wire [NUM_LINKS-1:0] tx_cfg_links_disable;
  wire [7:0] tx_cfg_beats_per_multiframe;
  wire [7:0] tx_cfg_octets_per_frame;
  wire [7:0] tx_cfg_lmfc_offset;
  wire tx_cfg_sysref_disable;
  wire tx_cfg_sysref_oneshot;
  wire tx_cfg_continuous_cgs;
  wire tx_cfg_continuous_ilas;
  wire tx_cfg_skip_ilas;
  wire [7:0] tx_cfg_mframes_per_ilas;
  wire tx_cfg_disable_char_replacement;
  wire tx_cfg_disable_scrambler;

  wire tx_ilas_config_rd;
  wire [1:0] tx_ilas_config_addr;
  wire [32*NUM_LANES-1:0] tx_ilas_config_data;

  jesd204_tx_static_config #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME),
    .SCR(ENABLE_SCRAMBLER),
    .LINK_MODE(2)
  ) i_tx_cfg (
    .clk(clk),

    .cfg_lanes_disable(tx_cfg_lanes_disable),
    .cfg_links_disable(tx_cfg_links_disable),
    .cfg_beats_per_multiframe(tx_cfg_beats_per_multiframe),
    .cfg_octets_per_frame(tx_cfg_octets_per_frame),
    .cfg_lmfc_offset(tx_cfg_lmfc_offset),
    .cfg_sysref_disable(tx_cfg_sysref_disable),
    .cfg_sysref_oneshot(tx_cfg_sysref_oneshot),
    .cfg_continuous_cgs(tx_cfg_continuous_cgs),
    .cfg_continuous_ilas(tx_cfg_continuous_ilas),
    .cfg_skip_ilas(tx_cfg_skip_ilas),
    .cfg_mframes_per_ilas(tx_cfg_mframes_per_ilas),
    .cfg_disable_char_replacement(tx_cfg_disable_char_replacement),
    .cfg_disable_scrambler(tx_cfg_disable_scrambler),

    .ilas_config_rd(tx_ilas_config_rd),
    .ilas_config_addr(tx_ilas_config_addr),
    .ilas_config_data(tx_ilas_config_data)
  );

  jesd204_tx #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .LINK_MODE(2)
  ) i_tx (
    .clk(clk),
    .reset(reset),

    .cfg_lanes_disable(tx_cfg_lanes_disable),
    .cfg_links_disable(tx_cfg_links_disable),
    .cfg_beats_per_multiframe(tx_cfg_beats_per_multiframe),
    .cfg_octets_per_frame(tx_cfg_octets_per_frame),
    .cfg_lmfc_offset(tx_cfg_lmfc_offset),
    .cfg_sysref_disable(tx_cfg_sysref_disable),
    .cfg_sysref_oneshot(tx_cfg_sysref_oneshot),
    .cfg_continuous_cgs(tx_cfg_continuous_cgs),
    .cfg_continuous_ilas(tx_cfg_continuous_ilas),
    .cfg_skip_ilas(tx_cfg_skip_ilas),
    .cfg_mframes_per_ilas(tx_cfg_mframes_per_ilas),
    .cfg_disable_char_replacement(tx_cfg_disable_char_replacement),
    .cfg_disable_scrambler(tx_cfg_disable_scrambler),

    .ilas_config_rd(tx_ilas_config_rd),
    .ilas_config_addr(tx_ilas_config_addr),
    .ilas_config_data(tx_ilas_config_data),

    .ctrl_manual_sync_request(1'b0),

    .tx_ready(tx_ready),
    .tx_data({NUM_LANES{tx_data}}),
    .tx_valid(),

    .sync(),
    .sysref(sysref_tx),

    .phy_data(phy_data_out),
    .phy_charisk(),
    .phy_header(phy_header_out),

    .lmfc_edge(),
    .lmfc_clk(),
    .event_sysref_edge(),
    .event_sysref_alignment_error(),
    .status_sync(),
    .status_state()
  );

  wire [NUM_LANES-1:0] rx_cfg_lanes_disable;
  wire [NUM_LINKS-1:0] rx_cfg_links_disable;
  wire [7:0] rx_cfg_beats_per_multiframe;
  wire [7:0] rx_cfg_octets_per_frame;
  wire [7:0] rx_cfg_lmfc_offset;
  wire rx_sysref_disable;
  wire rx_sysref_oneshot;
  wire rx_cfg_disable_scrambler;
  wire rx_cfg_disable_char_replacement;
  wire rx_cfg_buffer_early_release;
  wire [7:0] rx_cfg_buffer_delay;
  wire [NUM_LANES*3-1:0] status_lane_emb_state;

  jesd204_rx_static_config #(
    .NUM_LANES(NUM_LANES),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME),
    .SCR(ENABLE_SCRAMBLER),
    .BUFFER_EARLY_RELEASE(BUFFER_EARLY_RELEASE),
    .LINK_MODE(2)
  ) i_rx_cfg (
    .clk(clk),

    .cfg_lanes_disable(rx_cfg_lanes_disable),
    .cfg_links_disable(rx_cfg_links_disable),
    .cfg_beats_per_multiframe(rx_cfg_beats_per_multiframe),
    .cfg_octets_per_frame(rx_cfg_octets_per_frame),
    .cfg_lmfc_offset(rx_cfg_lmfc_offset),
    .cfg_sysref_disable(rx_cfg_sysref_disable),
    .cfg_sysref_oneshot(rx_cfg_sysref_oneshot),
    .cfg_disable_scrambler(rx_cfg_disable_scrambler),
    .cfg_disable_char_replacement(rx_cfg_disable_char_replacement),
    .cfg_buffer_delay(rx_cfg_buffer_delay),
    .cfg_buffer_early_release(rx_cfg_buffer_early_release)
  );

  jesd204_rx #(
    .NUM_LANES(NUM_LANES),
    .LINK_MODE(2)
  ) i_rx (
    .clk(clk),
    .reset(reset),

    .cfg_lanes_disable(rx_cfg_lanes_disable),
    .cfg_links_disable(rx_cfg_links_disable),
    .cfg_beats_per_multiframe(rx_cfg_beats_per_multiframe),
    .cfg_octets_per_frame(rx_cfg_octets_per_frame),
    .cfg_lmfc_offset(rx_cfg_lmfc_offset),
    .cfg_sysref_disable(rx_cfg_sysref_disable),
    .cfg_sysref_oneshot(rx_cfg_sysref_oneshot),
    .cfg_disable_scrambler(rx_cfg_disable_scrambler),
    .cfg_disable_char_replacement(rx_cfg_disable_char_replacement),
    .cfg_buffer_delay(rx_cfg_buffer_delay),
    .cfg_buffer_early_release(rx_cfg_buffer_early_release),

    .ctrl_err_statistics_reset (1'b0),
    .ctrl_err_statistics_mask(7'b0),

    .sync(),
    .sysref(sysref_rx),

    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .rx_eof(),
    .rx_sof(),

    .phy_data(phy_data_in),
    .phy_charisk({NUM_LANES{4'b0}}),
    .phy_notintable({NUM_LANES{4'b0000}}),
    .phy_disperr({NUM_LANES{4'b0000}}),
    .phy_header(phy_header_in),
    .phy_block_sync(phy_block_sync),

    .status_lane_ifs_ready(),
    .status_lane_latency(),
    .status_err_statistics_cnt(),

    .lmfc_edge(),
    .lmfc_clk(),
    .event_sysref_alignment_error(),
    .event_sysref_edge(),
    .phy_en_char_align(),
    .ilas_config_valid(),
    .ilas_config_addr(),
    .ilas_config_data(),
    .status_ctrl_state(),
    .status_lane_cgs_state(),
    .status_lane_emb_state(status_lane_emb_state)
  );

  integer ii;
  reg rx_status_mismatch = 1'b0;
  initial begin
    @(posedge rx_valid);
    for (ii=0;ii<NUM_LANES;ii=ii+1) begin
      #5000;
      if (status_lane_emb_state !== {NUM_LANES{3'b100}}) rx_status_mismatch = 1;
      phy_block_sync[ii] = 1'b0;
      #5000;
      phy_block_sync[ii] = 1'b1;
    end
    #5000;
    if (status_lane_emb_state !== {NUM_LANES{3'b100}}) rx_status_mismatch = 1;
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_mismatch <= 1'b0;
    end else if (rx_valid_d1 && rx_valid) begin
      if (rx_data !== {NUM_LANES{rx_ref_data}}) begin
        data_mismatch <= 1'b1;
      end
    end
  end


  always @(*) begin
    if (data_mismatch || rx_status_mismatch) begin
      failed <= 1'b1;
    end else begin
      failed <= 1'b0;
    end
  end
endmodule
