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

module jesd204_rx_header (
  input clk,
  input reset,

  input sh_lock,
  input [1:0] header,

  input [1:0] cfg_header_mode,  // 0 - CRC12 ; 1 - CRC3; 2 - FEC; 3 - CMD
  input [4:0] cfg_rx_thresh_emb_err,
  input [7:0] cfg_beats_per_multiframe,

  output emb_lock,

  output valid_eomb,
  output valid_eoemb,
  // Received header data qualified by valid_eomb
  output [11:0] crc12,
  output [2:0] crc3,
  output [25:0] fec,
  output [18:0] cmd,
  output reg [7:0] sh_count = 'h0,

  output [2:0] status_lane_emb_state,
  output reg event_invalid_header,
  output reg event_unexpected_eomb,
  output reg event_unexpected_eoemb

);

localparam STATE_EMB_INIT = 3'b001;
localparam STATE_EMB_HUNT = 3'b010;
localparam STATE_EMB_LOCK = 3'b100;

localparam BIT_EMB_INIT = 0;
localparam BIT_EMB_HUNT = 1;
localparam BIT_EMB_LOCK = 2;

reg [2:0] state = STATE_EMB_INIT;
reg [2:0] next_state;

reg [31:0] sync_word = 'h0;

wire header_bit;
wire invalid_sequence;
wire invalid_eoemb;
wire invalid_eomb;
wire [6:0] cmd0;
wire [6:0] cmd1;
wire [18:0] cmd3;
wire eoemb;
wire eomb;

assign header_bit = header == 2'b01;

always @(posedge clk) begin
  sync_word <= {sync_word[30:0],header_bit};
end

assign crc12 = {sync_word[31:29],sync_word[27:25],
                sync_word[23:21],sync_word[19:17]};
assign crc3 = {sync_word[31:29]};
assign cmd0 = {sync_word[15:13],sync_word[11],
               sync_word[7:5]};
assign cmd1 = {sync_word[27:25],
               sync_word[19:17],
               sync_word[11]};
assign cmd3 = {sync_word[31:29],sync_word[27:25],
               sync_word[23:21],sync_word[19:17],
               sync_word[15:13],sync_word[11],
               sync_word[7:5]};

assign cmd = cfg_header_mode == 0 ? {12'b0,cmd0} :
             cfg_header_mode == 1 ? {12'b0,cmd1} :
             cfg_header_mode == 3 ? cmd3 : 'b0;

assign fec = {sync_word[31:10],sync_word[8:5]};


assign eomb  = sync_word[4:0] == 5'b00001;
assign eoemb = sync_word[9] & eomb;


always @(posedge clk) begin
  if (next_state[BIT_EMB_INIT] || sh_count == cfg_beats_per_multiframe) begin
    sh_count <= 'h0;
  end else begin
    sh_count <= sh_count + 8'b1;
  end
end

reg [1:0] emb_vcount = 'b0;
always @(posedge clk) begin
  if (state[BIT_EMB_INIT]) begin
    emb_vcount <= 'b0;
  end else if (state[BIT_EMB_HUNT] && (sh_count == 0 && eoemb)) begin
    emb_vcount <= emb_vcount + 'b1;
  end
end

reg [4:0] emb_icount = 'b0;
always @(posedge clk) begin
  if (state[BIT_EMB_INIT]) begin
    emb_icount <= 'b0;
  end else if (state[BIT_EMB_LOCK]) begin
    if (sh_count == 0 && eoemb) begin
      emb_icount <= 'b0;
    end else if (invalid_eoemb || invalid_eomb) begin
      emb_icount <= emb_icount + 5'b1;
    end
  end
end


always @(*) begin
  next_state = state;
  case (state)
    STATE_EMB_INIT:
      if (eoemb) begin
        next_state = STATE_EMB_HUNT;
      end
    STATE_EMB_HUNT:
      if (invalid_sequence) begin
        next_state = STATE_EMB_INIT;
      end else if (eoemb && emb_vcount == 2'd3) begin
        next_state = STATE_EMB_LOCK;
      end
    STATE_EMB_LOCK:
      if (emb_icount == cfg_rx_thresh_emb_err) begin
        next_state = STATE_EMB_INIT;
      end
  endcase
  if (sh_lock == 1'b0) next_state = STATE_EMB_INIT;
end

assign invalid_eoemb = (sh_count == 0 && ~eoemb);
assign invalid_eomb = (sh_count[4:0] == 0 && ~eomb);
assign valid_eomb = next_state[BIT_EMB_LOCK] && eomb;
assign valid_eoemb = next_state[BIT_EMB_LOCK] && eoemb;

assign invalid_sequence = (invalid_eoemb || invalid_eomb);

always @(posedge clk) begin
  if (reset == 1'b1) begin
    state <= STATE_EMB_INIT;
  end else begin
    state <= next_state;
  end
end

assign emb_lock = next_state[BIT_EMB_LOCK];

// Status & error events
assign status_lane_emb_state = state;

always @(posedge clk) begin
  event_invalid_header <= (~state[BIT_EMB_INIT]) && (header[0] == header[1]);
  event_unexpected_eomb <= (~state[BIT_EMB_INIT]) && (sh_count[4:0] != 0 && eomb);
  event_unexpected_eoemb <= (~state[BIT_EMB_INIT]) && invalid_eoemb;
end

endmodule
