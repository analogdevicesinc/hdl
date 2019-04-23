// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_dmac_burst_memory #(
  parameter DATA_WIDTH_SRC = 64,
  parameter DATA_WIDTH_DEST = 64,
  parameter ID_WIDTH = 3,
  parameter MAX_BYTES_PER_BURST = 128,
  parameter ASYNC_CLK = 1,
  parameter BYTES_PER_BEAT_WIDTH_SRC = $clog2(DATA_WIDTH_SRC/8),
  parameter BYTES_PER_BURST_WIDTH = $clog2(MAX_BYTES_PER_BURST),
  parameter DMA_LENGTH_ALIGN = 3,
  parameter ENABLE_DIAGNOSTICS_IF = 0,
  parameter ALLOW_ASYM_MEM = 0
) (
  input src_clk,
  input src_reset,

  input src_data_valid,
  input [DATA_WIDTH_SRC-1:0] src_data,
  input src_data_last,
  input [BYTES_PER_BEAT_WIDTH_SRC-1:0] src_data_valid_bytes,
  input src_data_partial_burst,

  output [ID_WIDTH-1:0] src_data_request_id,

  input dest_clk,
  input dest_reset,

  output dest_data_valid,
  input dest_data_ready,
  output [DATA_WIDTH_DEST-1:0] dest_data,
  output dest_data_last,
  output [DATA_WIDTH_DEST/8-1:0] dest_data_strb,

  output [BYTES_PER_BURST_WIDTH-1:0] dest_burst_info_length,
  output dest_burst_info_partial,
  output [ID_WIDTH-1:0] dest_burst_info_id,
  output reg dest_burst_info_write = 1'b0,

  output [ID_WIDTH-1:0] dest_request_id,
  input [ID_WIDTH-1:0] dest_data_request_id,
  output [ID_WIDTH-1:0] dest_data_response_id,

  // Diagnostics interface
  output  [7:0] dest_diag_level_bursts
);

localparam DATA_WIDTH_MEM = DATA_WIDTH_SRC > DATA_WIDTH_DEST ?
  DATA_WIDTH_SRC : DATA_WIDTH_DEST;
localparam MEM_RATIO = DATA_WIDTH_SRC > DATA_WIDTH_DEST ?
  DATA_WIDTH_SRC / DATA_WIDTH_DEST : DATA_WIDTH_DEST / DATA_WIDTH_SRC;

/* A burst can have up to 256 beats */
localparam BURST_LEN = MAX_BYTES_PER_BURST / (DATA_WIDTH_MEM / 8);
localparam BURST_LEN_WIDTH = BURST_LEN > 128 ? 8 :
  BURST_LEN > 64 ? 7 :
  BURST_LEN > 32 ? 6 :
  BURST_LEN > 16 ? 5 :
  BURST_LEN > 8 ? 4 :
  BURST_LEN > 4 ? 3 :
  BURST_LEN > 2 ? 2 : 1;

localparam AUX_FIFO_SIZE = 2**(ID_WIDTH-1);

localparam MEM_RATIO_WIDTH =
    (ALLOW_ASYM_MEM == 0 || MEM_RATIO == 1) ? 0 :
    MEM_RATIO == 2 ? 1 :
    MEM_RATIO == 4 ? 2 : 3;

localparam BURST_LEN_WIDTH_SRC = BURST_LEN_WIDTH +
  (DATA_WIDTH_SRC < DATA_WIDTH_MEM ? MEM_RATIO_WIDTH : 0);
localparam BURST_LEN_WIDTH_DEST = BURST_LEN_WIDTH +
  (DATA_WIDTH_DEST < DATA_WIDTH_MEM ? MEM_RATIO_WIDTH : 0);
localparam DATA_WIDTH_MEM_SRC = DATA_WIDTH_MEM >>
  (DATA_WIDTH_SRC < DATA_WIDTH_MEM ? MEM_RATIO_WIDTH : 0);
localparam DATA_WIDTH_MEM_DEST = DATA_WIDTH_MEM >>
  (DATA_WIDTH_DEST < DATA_WIDTH_MEM ? MEM_RATIO_WIDTH : 0);

localparam ADDRESS_WIDTH_SRC = BURST_LEN_WIDTH_SRC + ID_WIDTH - 1;
localparam ADDRESS_WIDTH_DEST = BURST_LEN_WIDTH_DEST + ID_WIDTH - 1;

localparam BYTES_PER_BEAT_WIDTH_MEM_SRC = BYTES_PER_BURST_WIDTH - BURST_LEN_WIDTH_SRC;
localparam BYTES_PER_BEAT_WIDTH_DEST = BYTES_PER_BURST_WIDTH - BURST_LEN_WIDTH_DEST;

/*
 * The burst memory is separated into 2**(ID_WIDTH-1) segments. Each segment can
 * hold up to BURST_LEN beats. The addresses that are used to access the memory
 * are split into two parts. The MSBs index the segment and the LSBs index a
 * beat in a specific segment.
 *
 * src_id and dest_id are used to index the segment of the burst memory on the
 * write and read side respectively. The IDs are 1 bit wider than the address of
 * the burst memory. So we can't use them directly as an index into the burst
 * memory.  Since the IDs are gray counted we also can't just leave out the MSB
 * like with a binary counter. But XOR-ing the two MSBs of a gray counter gives
 * us a gray counter of 1 bit less. Use this to generate the segment index.
 * These addresses are captured in the src_id_reduced and dest_id_reduced
 * signals.
 *
 * src_beat_counter and dest_beat_counter are used to index the beat on the
 * write and read side respectively. They will be incremented for each beat that
 * is written/read. Note that the beat counters are not reset to 0 on the last
 * beat of a burst. This means the first beat of a burst might not be stored at
 * offset 0 in the segment memory. But this is OK since the beat counter
 * increments modulo the segment size and both the write and read side agree on
 * the order.
 */

reg [ID_WIDTH-1:0] src_id_next;
reg [ID_WIDTH-1:0] src_id = 'h0;
reg src_id_reduced_msb = 1'b0;
reg [BURST_LEN_WIDTH_SRC-1:0] src_beat_counter = 'h00;

reg [ID_WIDTH-1:0] dest_id_next = 'h0;
reg dest_id_reduced_msb_next = 1'b0;
reg dest_id_reduced_msb = 1'b0;
reg [ID_WIDTH-1:0] dest_id = 'h0;
reg [BURST_LEN_WIDTH_DEST-1:0] dest_beat_counter = 'h00;
wire [BURST_LEN_WIDTH_DEST-1:0] dest_burst_len;
reg dest_valid = 1'b0;
reg dest_mem_data_valid = 1'b0;
reg dest_mem_data_last = 1'b0;
reg [DATA_WIDTH_MEM_DEST/8-1:0] dest_mem_data_strb = {DATA_WIDTH_MEM_DEST/8{1'b1}};

reg [BYTES_PER_BURST_WIDTH+1-1-DMA_LENGTH_ALIGN:0] burst_len_mem[0:AUX_FIFO_SIZE-1];

wire [BYTES_PER_BURST_WIDTH+1-1:0] src_burst_len_data;
reg [BYTES_PER_BURST_WIDTH+1-1:0] dest_burst_len_data = {DMA_LENGTH_ALIGN{1'b1}};

wire src_beat;
wire src_last_beat;
wire [ID_WIDTH-1:0] src_dest_id;
wire [ADDRESS_WIDTH_SRC-1:0] src_waddr;
wire [ID_WIDTH-2:0] src_id_reduced;
wire src_mem_data_valid;
wire src_mem_data_last;
wire [DATA_WIDTH_MEM_SRC-1:0] src_mem_data;
wire [BYTES_PER_BEAT_WIDTH_MEM_SRC-1:0] src_mem_data_valid_bytes;
wire src_mem_data_partial_burst;

wire dest_beat;
wire dest_last_beat;
wire dest_last;
wire [ID_WIDTH-1:0] dest_src_id;
wire [ADDRESS_WIDTH_DEST-1:0] dest_raddr;
wire [ID_WIDTH-2:0] dest_id_reduced_next;
wire [ID_WIDTH-1:0] dest_id_next_inc;
wire [ID_WIDTH-2:0] dest_id_reduced;
wire dest_burst_valid;
wire dest_burst_ready;
wire dest_ready;
wire [DATA_WIDTH_MEM_DEST-1:0] dest_mem_data;
wire dest_mem_data_ready;

`include "inc_id.vh"

generate if (ID_WIDTH >= 3) begin
  assign src_id_reduced = {src_id_reduced_msb,src_id[ID_WIDTH-3:0]};
  assign dest_id_reduced_next = {dest_id_reduced_msb_next,dest_id_next[ID_WIDTH-3:0]};
  assign dest_id_reduced = {dest_id_reduced_msb,dest_id[ID_WIDTH-3:0]};
end else begin
  assign src_id_reduced = src_id_reduced_msb;
  assign dest_id_reduced_next = dest_id_reduced_msb_next;
  assign dest_id_reduced = dest_id_reduced_msb;
end endgenerate

assign src_beat = src_mem_data_valid;
assign src_last_beat = src_beat & src_mem_data_last;
assign src_waddr = {src_id_reduced,src_beat_counter};

assign src_data_request_id = src_dest_id;

always @(*) begin
  if (src_last_beat == 1'b1) begin
    src_id_next <= inc_id(src_id);
  end else begin
    src_id_next <= src_id;
  end
end

always @(posedge src_clk) begin
  if (src_reset == 1'b1) begin
    src_id <= 'h00;
    src_id_reduced_msb <= 1'b0;
  end else begin
    src_id <= src_id_next;
    src_id_reduced_msb <= ^src_id_next[ID_WIDTH-1-:2];
  end
end

always @(posedge src_clk) begin
  if (src_reset == 1'b1 || src_last_beat == 1'b1) begin
    src_beat_counter <= 'h00;
  end else if (src_beat == 1'b1) begin
    src_beat_counter <= src_beat_counter + 1'b1;
  end
end

always @(posedge src_clk) begin
  if (src_last_beat == 1'b1) begin
    burst_len_mem[src_id_reduced] <= src_burst_len_data[BYTES_PER_BURST_WIDTH:DMA_LENGTH_ALIGN];
  end
end

assign dest_ready = ~dest_mem_data_valid | dest_mem_data_ready;
assign dest_last = dest_beat_counter == dest_burst_len;

assign dest_beat = dest_valid & dest_ready;
assign dest_last_beat = dest_last & dest_beat;
assign dest_raddr = {dest_id_reduced,dest_beat_counter};

assign dest_burst_valid = dest_data_request_id != dest_id_next;
assign dest_burst_ready = ~dest_valid | dest_last_beat;

/*
 * The data valid signal for the destination side is asserted if there are one
 * or more pending bursts. It is de-asserted if there are no more pending burst
 * and it is the last beat of the current burst
 */
always @(posedge dest_clk) begin
  if (dest_reset == 1'b1) begin
    dest_valid <= 1'b0;
  end else if (dest_burst_valid == 1'b1) begin
    dest_valid <= 1'b1;
  end else if (dest_last_beat == 1'b1) begin
    dest_valid <= 1'b0;
  end
end

/*
 * The output register of the memory creates a extra clock cycle of latency on
 * the data path. We need to handle this more the handshaking signals. If data
 * is available in the memory it will be available one clock cycle later in the
 * output register.
 */
always @(posedge dest_clk) begin
  if (dest_reset == 1'b1) begin
    dest_mem_data_valid <= 1'b0;
  end else if (dest_valid == 1'b1) begin
    dest_mem_data_valid <= 1'b1;
  end else if (dest_mem_data_ready == 1'b1) begin
    dest_mem_data_valid <= 1'b0;
  end
end

/*
 * This clears dest_data_last after the last beat. Strictly speaking this is not
 * necessary if this followed AXI handshaking rules since dest_data_last would
 * be qualified by dest_data_valid and it is OK to retain the previous value of
 * dest_data_last when dest_data_valid is not asserted. But clearing the signal
 * here doesn't cost much and can simplify some of the more congested
 * combinatorical logic further up the pipeline since we can assume that
 * fifo_last == 1'b1 implies fifo_valid == 1'b1.
 */
always @(posedge dest_clk) begin
  if (dest_reset == 1'b1) begin
    dest_mem_data_last <= 1'b0;
  end else if (dest_beat == 1'b1) begin
    dest_mem_data_last <= dest_last;
  end else if (dest_mem_data_ready == 1'b1) begin
    dest_mem_data_last <= 1'b0;
  end
end

always @(posedge dest_clk) begin
  if (dest_beat == 1'b1) begin
    if (dest_last == 1'b1) begin
      dest_mem_data_strb <= {DATA_WIDTH_MEM_DEST/8{1'b1}} >> ~dest_burst_len_data[BYTES_PER_BEAT_WIDTH_DEST-1:0];
    end else begin
      dest_mem_data_strb <= {DATA_WIDTH_MEM_DEST/8{1'b1}};
    end
  end
end

assign dest_id_next_inc = inc_id(dest_id_next);

always @(posedge dest_clk) begin
  if (dest_reset == 1'b1) begin
    dest_id_next <= 'h00;
    dest_id_reduced_msb_next <= 1'b0;
  end else if (dest_burst_valid == 1'b1 && dest_burst_ready == 1'b1) begin
    dest_id_next <= dest_id_next_inc;
    dest_id_reduced_msb_next <= ^dest_id_next_inc[ID_WIDTH-1-:2];
  end
end

always @(posedge dest_clk) begin
  if (dest_burst_valid == 1'b1 && dest_burst_ready == 1'b1) begin
    dest_burst_len_data[BYTES_PER_BURST_WIDTH:DMA_LENGTH_ALIGN] <= burst_len_mem[dest_id_reduced_next];
  end
end

always @(posedge dest_clk) begin
  if (dest_burst_ready == 1'b1) begin
    dest_id <= dest_id_next;
    dest_id_reduced_msb <= dest_id_reduced_msb_next;
  end
end

always @(posedge dest_clk) begin
  if (dest_reset == 1'b1 || dest_last_beat == 1'b1) begin
    dest_beat_counter <= 'h00;
  end else if (dest_beat == 1'b1) begin
    dest_beat_counter <= dest_beat_counter + 1'b1;
  end
end

assign dest_burst_info_length = dest_burst_len_data[BYTES_PER_BURST_WIDTH-1:0];
assign dest_burst_info_partial = dest_burst_len_data[BYTES_PER_BURST_WIDTH];
assign dest_burst_info_id = dest_id;

always @(posedge dest_clk) begin
  dest_burst_info_write <= (dest_burst_valid == 1'b1 && dest_burst_ready == 1'b1);
end

assign dest_burst_len = dest_burst_len_data[BYTES_PER_BURST_WIDTH-1 -: BURST_LEN_WIDTH_DEST];

axi_dmac_resize_src #(
  .DATA_WIDTH_SRC (DATA_WIDTH_SRC),
  .BYTES_PER_BEAT_WIDTH_SRC (BYTES_PER_BEAT_WIDTH_SRC),
  .DATA_WIDTH_MEM (DATA_WIDTH_MEM_SRC),
  .BYTES_PER_BEAT_WIDTH_MEM (BYTES_PER_BEAT_WIDTH_MEM_SRC)
) i_resize_src (
  .clk (src_clk),
  .reset (src_reset),

  .src_data_valid (src_data_valid),
  .src_data (src_data),
  .src_data_last (src_data_last),
  .src_data_valid_bytes (src_data_valid_bytes),
  .src_data_partial_burst (src_data_partial_burst),

  .mem_data_valid (src_mem_data_valid),
  .mem_data (src_mem_data),
  .mem_data_last (src_mem_data_last),
  .mem_data_valid_bytes (src_mem_data_valid_bytes),
  .mem_data_partial_burst (src_mem_data_partial_burst)
);

assign src_burst_len_data = {src_mem_data_partial_burst,
                             src_beat_counter,
                             src_mem_data_valid_bytes};

ad_mem_asym #(
  .A_ADDRESS_WIDTH (ADDRESS_WIDTH_SRC),
  .A_DATA_WIDTH (DATA_WIDTH_MEM_SRC),
  .B_ADDRESS_WIDTH (ADDRESS_WIDTH_DEST),
  .B_DATA_WIDTH (DATA_WIDTH_MEM_DEST)
) i_mem (
  .clka (src_clk),
  .wea (src_beat),
  .addra (src_waddr),
  .dina (src_mem_data),

  .clkb (dest_clk),
  .reb (dest_beat),
  .addrb (dest_raddr),
  .doutb (dest_mem_data)
);

axi_dmac_resize_dest #(
  .DATA_WIDTH_DEST (DATA_WIDTH_DEST),
  .DATA_WIDTH_MEM (DATA_WIDTH_MEM_DEST)
) i_resize_dest (
  .clk (dest_clk),
  .reset (dest_reset),

  .mem_data_valid (dest_mem_data_valid),
  .mem_data_ready (dest_mem_data_ready),
  .mem_data (dest_mem_data),
  .mem_data_last (dest_mem_data_last),
  .mem_data_strb (dest_mem_data_strb),

  .dest_data_valid (dest_data_valid),
  .dest_data_ready (dest_data_ready),
  .dest_data (dest_data),
  .dest_data_last (dest_data_last),
  .dest_data_strb (dest_data_strb)
);

sync_bits #(
  .NUM_OF_BITS (ID_WIDTH),
  .ASYNC_CLK (ASYNC_CLK)
) i_dest_sync_id (
  .in_bits (src_id),
  .out_clk (dest_clk),
  .out_resetn (1'b1),
  .out_bits (dest_src_id)
);

sync_bits #(
  .NUM_OF_BITS (ID_WIDTH),
  .ASYNC_CLK (ASYNC_CLK)
) i_src_sync_id (
  .in_bits (dest_id),
  .out_clk (src_clk),
  .out_resetn (1'b1),
  .out_bits (src_dest_id)
);

assign dest_request_id = dest_src_id;
assign dest_data_response_id = dest_id;

generate if (ENABLE_DIAGNOSTICS_IF == 1) begin

  reg [ID_WIDTH-1:0] _dest_diag_level_bursts = 'h0;

  // calculate buffer fullness in bursts
  always @(posedge dest_clk) begin
    if (dest_reset == 1'b1) begin
      _dest_diag_level_bursts <= 'h0;
    end else begin
      _dest_diag_level_bursts <= g2b(dest_src_id) - g2b(dest_id);
    end
  end
  assign dest_diag_level_bursts = {{{8-ID_WIDTH}{1'b0}},_dest_diag_level_bursts};

end else begin
  assign dest_diag_level_bursts = 'h0;
end
endgenerate

endmodule
