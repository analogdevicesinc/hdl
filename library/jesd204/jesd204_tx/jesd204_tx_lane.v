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

module jesd204_tx_lane #(
  parameter DATA_PATH_WIDTH = 4,
  parameter ENABLE_CHAR_REPLACE = 1'b0
) (
  input clk,

  input [DATA_PATH_WIDTH-1:0] eof,
  input [DATA_PATH_WIDTH-1:0] eomf,

  input cgs_enable,

  input [DATA_PATH_WIDTH*8-1:0] ilas_data,
  input [DATA_PATH_WIDTH-1:0] ilas_charisk,

  input [DATA_PATH_WIDTH*8-1:0] tx_data,
  input tx_ready,

  output reg [DATA_PATH_WIDTH*8-1:0] phy_data,
  output reg [DATA_PATH_WIDTH-1:0] phy_charisk,

  input [7:0] cfg_octets_per_frame,
  input cfg_disable_char_replacement,
  input cfg_disable_scrambler
);

  wire [DATA_PATH_WIDTH*8-1:0] scrambled_data;
  wire [DATA_PATH_WIDTH*8-1:0] scrambled_data_d;
  wire                         cgs_enable_d;
  wire                         tx_ready_d;
  wire [DATA_PATH_WIDTH-1:0]   eof_d;
  wire [DATA_PATH_WIDTH-1:0]   eomf_d;
  wire [DATA_PATH_WIDTH*8-1:0] ilas_data_d;
  wire [DATA_PATH_WIDTH-1:0]   ilas_charisk_d;
  wire [DATA_PATH_WIDTH*8-1:0] data_replaced;
  wire [DATA_PATH_WIDTH-1:0]   charisk_replaced;
  wire [7:0]                   scrambled_char[0:DATA_PATH_WIDTH-1];
  reg  [7:0]                   char_align[0:DATA_PATH_WIDTH-1];

  jesd204_scrambler #(
    .WIDTH (DATA_PATH_WIDTH*8),
    .DESCRAMBLE (0)
  ) i_scrambler (
    .clk (clk),
    .reset (~tx_ready),
    .enable (~cfg_disable_scrambler),
    .data_in (tx_data),
    .data_out (scrambled_data));

  pipeline_stage #(
    .WIDTH ((DATA_PATH_WIDTH*19) + 2),
    .REGISTERED (1)
  ) i_lane_pipeline_stage (
    .clk(clk),
    .in({
      cgs_enable,
      tx_ready,
      eof,
      eomf,
      scrambled_data,
      ilas_data,
      ilas_charisk
    }),
    .out({
      cgs_enable_d,
      tx_ready_d,
      eof_d,
      eomf_d,
      scrambled_data_d,
      ilas_data_d,
      ilas_charisk_d
    }));

  jesd204_frame_align_replace #(
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
    .IS_RX (1'b0),
    .ENABLED (ENABLE_CHAR_REPLACE)
  ) i_align_replace (
    .clk (clk),
    .reset (~tx_ready_d),
    .cfg_octets_per_frame (cfg_octets_per_frame),
    .cfg_disable_char_replacement (cfg_disable_char_replacement),
    .cfg_disable_scrambler (cfg_disable_scrambler),
    .data (scrambled_data_d),
    .eof (eof_d),
    .rx_char_is_a ({DATA_PATH_WIDTH{1'b0}}),
    .rx_char_is_f ({DATA_PATH_WIDTH{1'b0}}),
    .tx_eomf (eomf_d),
    .data_out (data_replaced),
    .charisk_out (charisk_replaced));

  generate
  genvar i;

  for (i = 0; i < DATA_PATH_WIDTH; i = i + 1) begin: gen_char
    assign scrambled_char[i] = scrambled_data_d[i*8+7:i*8];

    always @(*) begin
      if (eomf_d[i]) begin
        char_align[i] = 8'h7c; // /A/
      end else begin
        char_align[i] = 8'hfc; // /F/
      end
    end

    always @(posedge clk) begin
      if (cgs_enable_d) begin
        phy_charisk[i] <= 1'b1;
      end else if (tx_ready_d) begin
        if(!cfg_disable_scrambler) begin
          phy_charisk[i] <= eof_d[i] && (scrambled_char[i] == char_align[i]);
        end else begin
          phy_charisk[i] <= charisk_replaced[i];
        end
      end else begin
        phy_charisk[i] <= ilas_charisk_d[i];
      end
    end
  end

  endgenerate

  always @(posedge clk) begin
    if (cgs_enable_d) begin
      phy_data <= {DATA_PATH_WIDTH{8'hbc}};
    end else begin
      if(tx_ready_d) begin
        phy_data <= data_replaced;
      end else begin
        phy_data <= ilas_data_d;
      end
    end
  end

endmodule
