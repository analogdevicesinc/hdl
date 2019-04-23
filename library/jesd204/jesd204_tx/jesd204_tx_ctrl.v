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

module jesd204_tx_ctrl #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input [NUM_LINKS-1:0] sync,
  input lmfc_edge,

  output reg [NUM_LANES-1:0] lane_cgs_enable,
  output reg eof_reset,

  output reg tx_ready,

  output reg [DATA_PATH_WIDTH*8*NUM_LANES-1:0] ilas_data,
  output reg [DATA_PATH_WIDTH-1:0] ilas_charisk,

  output reg [1:0] ilas_config_addr,
  output reg ilas_config_rd,
  input [DATA_PATH_WIDTH*8*NUM_LANES-1:0] ilas_config_data,

  input [NUM_LANES-1:0] cfg_lanes_disable,
  input [NUM_LINKS-1:0] cfg_links_disable,
  input cfg_continuous_cgs,
  input cfg_continuous_ilas,
  input cfg_skip_ilas,
  input [7:0] cfg_mframes_per_ilas,
  input cfg_disable_char_replacement,

  input ctrl_manual_sync_request,

  output [NUM_LINKS-1:0] status_sync,
  output reg [1:0] status_state
);

reg lmfc_edge_d1 = 1'b0;
reg lmfc_edge_d2 = 1'b0;
reg ilas_reset = 1'b1;
reg ilas_data_reset = 1'b1;
reg sync_request = 1'b0;
reg sync_request_received = 1'b0;
reg [7:0] mframe_counter = 'h00;
reg [5:0] ilas_counter = 'h00;
reg ilas_config_rd_d1 = 1'b1;
reg last_ilas_mframe = 1'b0;
reg cgs_enable = 1'b1;

wire [NUM_LINKS-1:0] status_sync_masked;

sync_bits #(
  .NUM_OF_BITS (NUM_LINKS))
i_cdc_sync (
  .in_bits(sync),
  .out_clk(clk),
  .out_resetn(1'b1),
  .out_bits(status_sync)
);
assign status_sync_masked = status_sync | cfg_links_disable;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    sync_request <= {NUM_LINKS{1'b0}};
  end else begin
    /* TODO: SYNC must be asserted at least 4 frames before interpreted as a
     * sync request and the /K28.5/ symbol generation has lasted for at
     * least 1 frame + 9 octets */
    if (cfg_continuous_cgs == 1'b1) begin
      sync_request <= 1'b1;
    end else begin
      sync_request <= ~(&status_sync_masked) | ctrl_manual_sync_request;
    end
  end
end

always @(posedge clk) begin
  if (sync_request == 1'b0 && sync_request_received == 1'b1) begin
    lmfc_edge_d1 <= lmfc_edge;
    lmfc_edge_d2 <= lmfc_edge_d1;
  end else begin
    lmfc_edge_d1 <= 1'b0;
    lmfc_edge_d2 <= 1'b0;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    sync_request_received <= 1'b0;
  end else if (sync_request == 1'b1) begin
    sync_request_received <= 1'b1;
  end
end

always @(posedge clk) begin
  if (cfg_skip_ilas == 1'b1 ||
    mframe_counter == cfg_mframes_per_ilas) begin
    last_ilas_mframe <= 1'b1;
  end else begin
    last_ilas_mframe <= 1'b0;
  end
end

localparam STATE_WAIT = 2'b00;
localparam STATE_CGS = 2'b01;
localparam STATE_ILAS = 2'b10;
localparam STATE_DATA = 2'b11;

/* Timeline
 *
 * #1 lmfc_edge == 1, ilas_reset update
 * #2 eof_reset update
 * #3 {lane_,}cgs_enable, tx_ready update
 *
 * One multi-frame should at least be 3 clock cycles (TBD 64-bit data path)
 */

always @(posedge clk) begin
  if (sync_request == 1'b1 || reset == 1'b1) begin
    cgs_enable <= 1'b1;
    lane_cgs_enable <= {NUM_LANES{1'b1}};
    tx_ready <= 1'b0;
    eof_reset <= 1'b1;
    ilas_reset <= 1'b1;
    ilas_data_reset <= 1'b1;

    if (sync_request_received == 1'b0) begin
      status_state <= STATE_WAIT;
    end else begin
      status_state <= STATE_CGS;
    end
  end else if (sync_request_received == 1'b1) begin
    if (lmfc_edge == 1'b1 && last_ilas_mframe == 1'b1) begin
      ilas_reset <= 1'b1;
      status_state <= STATE_DATA;
    end else if (lmfc_edge_d1 == 1'b1 && (cfg_continuous_ilas == 1'b1 ||
      cgs_enable == 1'b1)) begin
      ilas_reset <= 1'b0;
      status_state <= STATE_ILAS;
    end

    if (lmfc_edge_d1 == 1'b1) begin
      if (last_ilas_mframe == 1'b1 && cfg_continuous_ilas == 1'b0) begin
        eof_reset <= cfg_disable_char_replacement;
        ilas_data_reset <= 1'b1;
      end else if (cgs_enable == 1'b1) begin
        ilas_data_reset <= 1'b0;
      end
    end

    if (lmfc_edge_d2 == 1'b1) begin
      lane_cgs_enable <= cfg_lanes_disable;
      cgs_enable <= 1'b0;
      if (last_ilas_mframe == 1'b1 && cfg_continuous_ilas == 1'b0) begin
        tx_ready <= 1'b1;
      end
    end
  end
end

always @(posedge clk) begin
  if (ilas_reset == 1'b1) begin
    mframe_counter <= 'h00;
  end else if (lmfc_edge_d1 == 1'b1) begin
    mframe_counter <= mframe_counter + 1'b1;
  end
end

always @(posedge clk) begin
  if (ilas_reset == 1'b1) begin
    ilas_config_rd <= 1'b0;
  end else if (mframe_counter == 'h00 && lmfc_edge == 1'b1) begin
    ilas_config_rd <= 1'b1;
  end else if (ilas_config_addr == 'h3) begin
    ilas_config_rd <= 1'b0;
  end
  ilas_config_rd_d1 <= ilas_config_rd;
end

always @(posedge clk) begin
  if (ilas_config_rd == 1'b0) begin
    ilas_config_addr <= 'h00;
  end else begin
    ilas_config_addr <= ilas_config_addr + 1'b1;
  end
end

always @(posedge clk) begin
  if (ilas_reset == 1'b1) begin
    ilas_counter <= 'h00;
  end else begin
    ilas_counter <= ilas_counter + 1'b1;
  end
end

wire [31:0] ilas_default_data = {
  ilas_counter,2'h3,
  ilas_counter,2'h2,
  ilas_counter,2'h1,
  ilas_counter,2'h0
};

always @(posedge clk) begin
  if (ilas_data_reset == 1'b1) begin
    ilas_data <= {NUM_LANES{32'h00}};
    ilas_charisk <= 4'b0000;
  end else begin
    if (ilas_config_rd_d1 == 1'b1) begin
      case (ilas_config_addr)
      2'h1: begin
        ilas_data <= (ilas_config_data & {NUM_LANES{32'hffff0000}}) |
          {NUM_LANES{16'h00,8'h9c,8'h1c}}; // /Q/ /R/
        ilas_charisk <= 4'b0011;
      end
      default: begin
        ilas_data <= ilas_config_data;
        ilas_charisk <= 4'b0000;
      end
      endcase
    end else if (lmfc_edge_d2 == 1'b1) begin
      ilas_data <= {NUM_LANES{ilas_default_data[31:8],8'h1c}}; // /R/
      ilas_charisk <= 4'b0001;
    end else if (lmfc_edge_d1 == 1'b1) begin
      ilas_data <= {NUM_LANES{8'h7c,ilas_default_data[23:0]}}; // /A/
      ilas_charisk <= 4'b1000;
    end else begin
      ilas_data <= {NUM_LANES{ilas_default_data}};
      ilas_charisk <= 4'b0000;
    end
  end
end

endmodule
