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

module jesd204_rx_lane #(
  parameter DATA_PATH_WIDTH = 4,
  parameter CHAR_INFO_REGISTERED = 0,
  parameter ALIGN_MUX_REGISTERED = 0,
  parameter SCRAMBLER_REGISTERED = 0,
  parameter ELASTIC_BUFFER_SIZE = 256,
  parameter ENABLE_FRAME_ALIGN_CHECK = 0
) (
  input clk,
  input reset,

  input [DATA_PATH_WIDTH*8-1:0] phy_data,
  input [DATA_PATH_WIDTH-1:0] phy_charisk,
  input [DATA_PATH_WIDTH-1:0] phy_notintable,
  input [DATA_PATH_WIDTH-1:0] phy_disperr,

  input cgs_reset,
  output cgs_ready,

  input ifs_reset,

  output [DATA_PATH_WIDTH*8-1:0] rx_data,

  output buffer_ready_n,
  input buffer_release_n,

  input [7:0] cfg_beats_per_multiframe,
  input [7:0] cfg_octets_per_frame,
  input cfg_disable_scrambler,

  output ilas_config_valid,
  output [1:0] ilas_config_addr,
  output [DATA_PATH_WIDTH*8-1:0] ilas_config_data,

  input err_statistics_reset,
  input [2:0]ctrl_err_statistics_mask,
  output reg [31:0] status_err_statistics_cnt,

  output [1:0] status_cgs_state,
  output status_ifs_ready,
  output [1:0] status_frame_align,
  output [7:0] status_frame_align_err_cnt
);

localparam MAX_DATA_PATH_WIDTH = 8;

wire [7:0] char[0:DATA_PATH_WIDTH-1];
wire [DATA_PATH_WIDTH-1:0] char_is_valid;
reg [DATA_PATH_WIDTH-1:0] char_is_cgs = 1'b0;        // K28.5 /K/

reg [DATA_PATH_WIDTH-1:0] char_is_error = 1'b0;
reg [DATA_PATH_WIDTH-1:0] charisk28 = 4'b0000;

wire cgs_beat_is_cgs = &char_is_cgs;
wire cgs_beat_has_error = |char_is_error;

reg ifs_ready = 1'b0;
reg [1:0] frame_align = 'h00;

wire [DATA_PATH_WIDTH*8-1:0] phy_data_s;
wire [DATA_PATH_WIDTH-1:0] charisk28_aligned_s;
wire [DATA_PATH_WIDTH*8-1:0] data_aligned_s;
wire [DATA_PATH_WIDTH-1:0] charisk28_aligned;
wire [DATA_PATH_WIDTH*8-1:0] data_aligned;
wire [DATA_PATH_WIDTH*8-1:0] data_scrambled_s;
wire [DATA_PATH_WIDTH*8-1:0] data_scrambled;

reg  [DATA_PATH_WIDTH-1:0] unexpected_char;
reg  [DATA_PATH_WIDTH-1:0] phy_char_err;

wire ilas_monitor_reset_s;
wire ilas_monitor_reset;
wire buffer_ready_n_s;

assign status_ifs_ready = ifs_ready;
assign status_frame_align = frame_align;

genvar i;
generate

for (i = 0; i < DATA_PATH_WIDTH; i = i + 1) begin: gen_char
  assign char[i] = phy_data[i*8+7:i*8];
  assign char_is_valid[i] = ~(phy_notintable[i] | phy_disperr[i]);

  always @(*) begin
    char_is_error[i] = ~char_is_valid[i];

    char_is_cgs[i] = 1'b0;
    charisk28[i] = 1'b0;
    unexpected_char[i] = 1'b0;

    if (phy_charisk[i] == 1'b1 && char_is_valid[i] == 1'b1) begin
      if (char[i][4:0] == 'd28) begin
        charisk28[i] = 1'b1;
        if (char[i][7:5] == 'd5) begin
          char_is_cgs[i] = 1'b1;
        end
      end else begin
        unexpected_char[i] = 1'b1;
      end
    end
  end
end
endgenerate

always @(posedge clk) begin
  if (cgs_ready == 1'b1) begin
    /*
     * Set the bit in phy_char_err if at least one of the monitored error
     * conditions has occured.
     */
    phy_char_err <= (~{DATA_PATH_WIDTH{ctrl_err_statistics_mask[0]}} & phy_disperr) |
                    (~{DATA_PATH_WIDTH{ctrl_err_statistics_mask[1]}} & phy_notintable) |
                    (~{DATA_PATH_WIDTH{ctrl_err_statistics_mask[2]}} & unexpected_char);
  end else begin
    phy_char_err <= {DATA_PATH_WIDTH{1'b0}};
  end
end

function [7:0] num_set_bits;
input [DATA_PATH_WIDTH-1:0] x;
integer j;
begin
  num_set_bits = 0;
  for (j = 0; j < DATA_PATH_WIDTH; j = j + 1) begin
    num_set_bits = num_set_bits + x[j];
  end
end
endfunction

always @(posedge clk) begin
  if (reset == 1'b1 || err_statistics_reset == 1'b1) begin
    status_err_statistics_cnt <= 32'h0;
  end else if (status_err_statistics_cnt[31:5] != 27'h7ffffff) begin
    status_err_statistics_cnt <= status_err_statistics_cnt + num_set_bits(phy_char_err);
  end
end

always @(posedge clk) begin
  if (ifs_reset == 1'b1) begin
    ifs_ready <= 1'b0;
  end else if (cgs_beat_is_cgs == 1'b0 && cgs_beat_has_error == 1'b0) begin
    ifs_ready <= 1'b1;
  end
end

always @(posedge clk) begin
  if (ifs_ready == 1'b0) begin
    if (char_is_cgs[0] == 1'b0) begin
      frame_align <= 'h0;
    end else if (char_is_cgs[1] == 1'b0) begin
      frame_align <= 'h1;
    end else if (char_is_cgs[2] == 1'b0) begin
      frame_align <= 'h2;
    end else begin
      frame_align <= 'h3;
    end
  end
end

pipeline_stage #(
  .WIDTH(DATA_PATH_WIDTH*8),
  .REGISTERED(CHAR_INFO_REGISTERED)
) i_pipeline_stage0 (
  .clk(clk),
  .in(phy_data),
  .out(phy_data_s)
);

align_mux i_align_mux (
  .clk(clk),
  .align(frame_align),
  .in_data(phy_data_s),
  .out_data(data_aligned_s),
  .in_charisk(charisk28),
  .out_charisk(charisk28_aligned_s)
);

assign ilas_monitor_reset_s = ~ifs_ready;

pipeline_stage #(
  .WIDTH(1 + DATA_PATH_WIDTH * (8 + 1)),
  .REGISTERED(ALIGN_MUX_REGISTERED)
) i_pipeline_stage1 (
  .clk(clk),
  .in({
      ilas_monitor_reset_s,
      data_aligned_s,
      charisk28_aligned_s
    }),
  .out({
      ilas_monitor_reset,
      data_aligned,
      charisk28_aligned
    })
);

generate
if(ENABLE_FRAME_ALIGN_CHECK) begin : gen_frame_align_monitor
jesd204_rx_frame_align_monitor #(
  .DATA_PATH_WIDTH  (DATA_PATH_WIDTH)
) i_align_monitor (
  .clk                        (clk),
  .reset                      (buffer_ready_n_s),
  .cfg_beats_per_multiframe   (cfg_beats_per_multiframe),
  .cfg_octets_per_frame       (cfg_octets_per_frame),
  .cfg_disable_scrambler      (cfg_disable_scrambler),
  .charisk28                  (charisk28_aligned),
  .data                       (data_aligned),
  .align_err_cnt              (status_frame_align_err_cnt)
);

end else begin : gen_no_frame_align_monitor
  assign status_frame_align_err_cnt = 32'd0;
end
endgenerate

jesd204_scrambler #(
  .WIDTH(DATA_PATH_WIDTH*8),
  .DESCRAMBLE(1)
) i_descrambler (
  .clk(clk),
  .reset(buffer_ready_n_s),
  .enable(~cfg_disable_scrambler),
  .data_in(data_aligned),
  .data_out(data_scrambled_s)
);

pipeline_stage #(
  .WIDTH(1 + DATA_PATH_WIDTH * 8),
  .REGISTERED(SCRAMBLER_REGISTERED)
) i_pipeline_stage2 (
  .clk(clk),
  .in({
      buffer_ready_n_s,
      data_scrambled_s
    }),
  .out({
      buffer_ready_n,
      data_scrambled
    })
);

elastic_buffer #(
  .WIDTH(DATA_PATH_WIDTH*8),
  .SIZE(ELASTIC_BUFFER_SIZE)
) i_elastic_buffer (
  .clk(clk),
  .reset(reset),

  .wr_data(data_scrambled),
  .rd_data(rx_data),

  .ready_n(buffer_ready_n),
  .do_release_n(buffer_release_n)
);

jesd204_ilas_monitor #(
  .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
) i_ilas_monitor (
  .clk(clk),
  .reset(ilas_monitor_reset),
  .data(data_aligned),
  .charisk28(charisk28_aligned),

  .data_ready_n(buffer_ready_n_s),

  .ilas_config_valid(ilas_config_valid),
  .ilas_config_addr(ilas_config_addr),
  .ilas_config_data(ilas_config_data)
);

jesd204_rx_cgs #(
  .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
) i_cgs (
  .clk(clk),
  .reset(cgs_reset),

  .char_is_cgs(char_is_cgs),
  .char_is_error(char_is_error),

  .ready(cgs_ready),

  .status_state(status_cgs_state)
);

endmodule
