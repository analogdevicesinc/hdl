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

module frame_align_tb;
  parameter VCD_FILE = "frame_align_tb.vcd";
  parameter NUM_LANES = 4;
  parameter NUM_LINKS = 1;
  parameter OCTETS_PER_FRAME = 4;
  parameter FRAMES_PER_MULTIFRAME = 16;
  parameter ENABLE_SCRAMBLER = 1;
  parameter BUFFER_EARLY_RELEASE = 1;
  parameter LANE_DELAY = 1;
  parameter ALIGN_ERROR_PERCENT = 50;

  localparam BEATS_PER_MULTIFRAME = OCTETS_PER_FRAME * FRAMES_PER_MULTIFRAME / 4;
  localparam TX_LATENCY = 3;
  localparam RX_LATENCY = 3;
  localparam BASE_LATENCY = TX_LATENCY + RX_LATENCY;

  `define TIMEOUT 1000000

  `include "tb_base.v"

  reg [5:0] tx_counter = 'h00;
  reg [5:0] rx_counter = 'h00;
  reg [NUM_LANES*32-1:0] rx_mask = 'hffff0000;
  wire tx_ready;
  wire rx_valid;
  wire [NUM_LANES*32-1:0] rx_data;
  reg data_mismatch = 1'b1;
  wire [NUM_LINKS-1:0] sync;

  always @(posedge clk) begin
    if (sync == 1'b0) begin
      tx_counter <= 'h00000000;
    end else if (tx_ready == 1'b1) begin
      tx_counter <= tx_counter + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (sync == 1'b0) begin
      rx_counter <= 'h00000000;
      if (ENABLE_SCRAMBLER == 1'b1) begin
        rx_mask <= {NUM_LANES{32'hffff0000}}; // First two octets are invalid due to scrambling
      end else begin
        rx_mask <= {NUM_LANES{32'hffffffff}};
      end
    end else if (rx_valid == 1'b1) begin
      rx_counter <= rx_counter + 1'b1;
      rx_mask <= {NUM_LANES{32'hffffffff}};
    end
  end

  wire [31:0] tx_data = {tx_counter,2'h3,tx_counter,2'h2,tx_counter,2'h1,tx_counter,2'h0};
  wire [31:0] rx_ref_data = {rx_counter,2'h3,rx_counter,2'h2,rx_counter,2'h1,rx_counter,2'h0};

  wire [NUM_LANES*32-1:0] phy_data_out;
  wire [NUM_LANES*4-1:0] phy_charisk_out;
  wire [NUM_LANES*32-1:0] phy_data_delayed;
  wire [NUM_LANES*4-1:0] phy_charisk_delayed;
  reg [NUM_LANES*32-1:0] phy_data_in;
  reg [NUM_LANES*4-1:0] phy_charisk_in;

  reg align_err_mf;
  reg align_err_f;
  reg cur_err;

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
  reg [36*NUM_LANES-1:0] phy_delay_fifo[0:MAX_LANE_DELAY-1];

  always @(posedge clk) begin
    phy_delay_fifo[phy_delay_fifo_wr] <= {phy_charisk_out,phy_data_out};

    if (reset == 1'b1 || phy_delay_fifo_wr == MAX_LANE_DELAY-1) begin
      phy_delay_fifo_wr <= 'h00;
    end else begin
      phy_delay_fifo_wr <= phy_delay_fifo_wr + 1'b1;
    end
  end

  initial begin
    align_err_mf = 1'b0;
    align_err_f = 1'b0;

    #100000;
    align_err_f = 1'b1;
    #50000;
    align_err_f = 1'b0;
    #100000;

    align_err_mf = 1'b1;
    #50000;
    align_err_mf = 1'b0;
    #100000;

    align_err_f = 1'b1;
    align_err_mf = 1'b1;
    #50000;
    align_err_f = 1'b0;
    align_err_mf = 1'b0;
    #100000;
  end

  always @(posedge clk) begin
    if(ALIGN_ERROR_PERCENT != 0) begin
      cur_err <= $urandom_range(99) < ALIGN_ERROR_PERCENT;
    end else begin
      cur_err <= 1'b0;
    end
  end

  genvar i;
  generate for (i = 0; i < NUM_LANES; i = i + 1) begin
    localparam OFF = MAX_LANE_DELAY - (i + LANE_DELAY);
    assign phy_data_delayed[32*i+31:32*i] =
      phy_delay_fifo[(phy_delay_fifo_wr + OFF) % MAX_LANE_DELAY][32*i+31:32*i];
    assign phy_charisk_delayed[4*i+3:4*i] =
      phy_delay_fifo[(phy_delay_fifo_wr + OFF) % MAX_LANE_DELAY][4*i+3+NUM_LANES*32:4*i+32*NUM_LANES];
  end endgenerate

  always @(*) begin
    phy_data_in = phy_data_delayed;
    phy_charisk_in = phy_charisk_delayed;

    if(cur_err) begin
      if(align_err_mf) begin
        phy_data_in = {NUM_LANES*4{8'h7C}};
        phy_charisk_in = {NUM_LANES*4{1'b1}};
      end else if(align_err_f) begin
        phy_data_in = {NUM_LANES*4{8'hFC}};
        phy_charisk_in = {NUM_LANES*4{1'b1}};
      end
    end
  end


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
    .SCR(ENABLE_SCRAMBLER)
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
    .NUM_LINKS(NUM_LINKS)
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

    .sync(sync),
    .sysref(sysref_tx),

    .phy_data(phy_data_out),
    .phy_charisk(phy_charisk_out)
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
  wire [NUM_LANES-1:0] rx_status_lane_ifs_ready;
  wire [NUM_LANES*14-1:0] rx_status_lane_latency;
  wire [NUM_LANES*8-1:0] rx_status_lane_frame_align_err_cnt;
  wire [7:0] rx_cfg_frame_align_err_threshold;

  jesd204_rx_static_config #(
    .NUM_LANES(NUM_LANES),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME),
    .SCR(ENABLE_SCRAMBLER),
    .BUFFER_EARLY_RELEASE(BUFFER_EARLY_RELEASE)
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
    .cfg_buffer_early_release(rx_cfg_buffer_early_release),
    .cfg_frame_align_err_threshold(rx_cfg_frame_align_err_threshold)
  );

  jesd204_rx #(
    .NUM_LANES(NUM_LANES),
    .ENABLE_FRAME_ALIGN_CHECK(1),
    .ENABLE_FRAME_ALIGN_ERR_RESET(1)
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
    .cfg_frame_align_err_threshold(rx_cfg_frame_align_err_threshold),

    .sync(sync),
    .sysref(sysref_rx),

    .rx_data(rx_data),
    .rx_valid(rx_valid),

    .phy_data(phy_data_in),
    .phy_charisk(phy_charisk_in),
    .phy_notintable({NUM_LANES{4'b0000}}),
    .phy_disperr({NUM_LANES{4'b0000}}),

    .status_lane_ifs_ready(rx_status_lane_ifs_ready),
    .status_lane_latency(rx_status_lane_latency),
    .status_lane_frame_align_err_cnt(rx_status_lane_frame_align_err_cnt)
  );

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_mismatch <= 1'b0;
    end else if (rx_valid == 1'b1) begin
      if ((rx_data & rx_mask) !== ({NUM_LANES{rx_ref_data}} & rx_mask)) begin
        data_mismatch <= 1'b1;
      end
    end
  end

  reg [NUM_LANES-1:0] lane_latency_match;

  generate for (i = 0; i < NUM_LANES; i = i + 1) begin
    localparam LANE_OFFSET = BASE_LATENCY + LANE_DELAY + BEATS_PER_MULTIFRAME + i;

    always @(posedge clk) begin
      if (rx_status_lane_ifs_ready[i] == 1'b1 &&
          rx_status_lane_latency[i*14+13:i*14+2] == LANE_OFFSET) begin
        lane_latency_match[i] <= 1'b1;
      end else begin
        lane_latency_match[i] <= 1'b0;
      end
    end
  end endgenerate

  always @(*) begin
    if (rx_valid !== 1'b1 || tx_ready !== 1'b1 || data_mismatch == 1'b1 ||
        &lane_latency_match != 1'b1) begin
      failed <= 1'b1;
    end else begin
      failed <= 1'b0;
    end
  end
endmodule
