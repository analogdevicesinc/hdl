// ***************************************************************************
// ***************************************************************************
// Copyright 2017 (c) Analog Device_ctrls, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique lice_ctrlnse
// terms.
//
// The user should read each of these lice_ctrlnse terms, and understand the
// freedoms and responsabilities that he or she has by using this source_ctrl/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source_ctrl or resulting binaries, with or without modification
// of this file, are permitted under one of the following two lice_ctrlnse terms:
//
//   1. The GNU General Public Lice_ctrlnse version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LIce_ctrlNSE_GPL2), and also online at:
//      <https://www.gnu.org/lice_ctrlnses/old-lice_ctrlnses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD lice_ctrlnse, which can be found in the top level directory
//      of this repository (LIce_ctrlNSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevice_ctrlsinc/hdl/blob/master/LIce_ctrlNSE_ADIBSD
//      This will allow to generate bit files and not release the source_ctrl code,
//      as long as it attaches to an ADI device_ctrl.
//
// ***************************************************************************
// ***************************************************************************

module util_upack2_impl #(
  parameter NUM_OF_CHANNELS = 4,
  parameter SAMPLE_DATA_WIDTH = 16,
  parameter SAMPLES_PER_CHANNEL = 1
) (
  input clk,
  input reset,

  input [NUM_OF_CHANNELS-1:0] enable,

  input fifo_rd_en,
  output reg fifo_rd_valid,
  output reg fifo_rd_underflow,
  output reg [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data,

  input s_axis_valid,
  output s_axis_ready,
  input [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] s_axis_data
);

localparam TOTAL_DATA_WIDTH = NUM_OF_CHANNELS * SAMPLE_DATA_WIDTH * SAMPLES_PER_CHANNEL;
localparam NUM_OF_PORTS = NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL;

localparam PORT_ADDRESS_WIDTH =
  NUM_OF_PORTS > 64 ? 7:
  NUM_OF_PORTS > 32 ? 6:
  NUM_OF_PORTS > 16 ? 5:
  NUM_OF_PORTS > 8 ? 4:
  NUM_OF_PORTS > 4 ? 3:
  NUM_OF_PORTS > 2 ? 2 : 1;

localparam CTRL_WIDTH = NUM_OF_PORTS * PORT_ADDRESS_WIDTH / 2;

reg reset_data = 1'b1;
reg reset_ctrl = 1'b1;
reg startup_ctrl = 1'b0;
reg [PORT_ADDRESS_WIDTH:0] sum;
reg [NUM_OF_CHANNELS-1:0] enable_int = 'h00;

wire [NUM_OF_PORTS-1:0] ports_enable;
wire [CTRL_WIDTH-1:0] unpack_ctrl;
wire [PORT_ADDRESS_WIDTH:0] enable_count[0:1];
wire [TOTAL_DATA_WIDTH-1:0] unpacked_data[0:2];
wire [TOTAL_DATA_WIDTH-1:0] deinterleaved_data;
wire [PORT_ADDRESS_WIDTH-1:0] rotate;
wire ce_ctrl;

assign s_axis_ready = sum[PORT_ADDRESS_WIDTH] & fifo_rd_en & ~reset_data;
assign ce_ctrl = (fifo_rd_en & s_axis_valid) | startup_ctrl;

assign ports_enable = {SAMPLES_PER_CHANNEL{enable_int}};
assign rotate = sum[PORT_ADDRESS_WIDTH-1:0];

/*
 * The internal state is reset whenever the selected channels change.
 * The control path is pipelined and computed one clock cycle in advance. This
 * means the control path needs to be taken out of reset one clock cycle before
 * the data path and a special startup cycle is required to compute the first
 * set of control signals.
 */
always @(posedge clk) begin
  if (reset == 1'b1) begin
    reset_data <= 1'b1;
    reset_ctrl <= 1'b1;
    startup_ctrl <= 1'b0;
  end else if (enable != enable_int || enable == {NUM_OF_PORTS{1'b0}}) begin
    reset_data <= 1'b1;
    reset_ctrl <= 1'b1;
    startup_ctrl <= 1'b1;
  end else begin
    reset_data <= reset_ctrl;
    reset_ctrl <= 1'b0;
    startup_ctrl <= reset_ctrl;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    enable_int <= {NUM_OF_PORTS{1'b0}};
  end else begin
    enable_int <= enable;
  end
end

always @(posedge clk) begin
  if (reset_ctrl == 1'b1) begin
    sum <= 'h00;
  end else if (ce_ctrl == 1'b1) begin
    sum <= sum[PORT_ADDRESS_WIDTH-1:0] + enable_count[0];
  end
end

assign unpacked_data[0] = s_axis_data;

/*
 * The routing network can be built from any type of MUX. When it comes to
 * resource usage 2:1 MUXes and 4:1 MUXes are the most efficient, both will
 * require the same amount of LUTs. But a network built from 4:1 MUXes only uses
 * half the number of stages of a network built from 2:1 MUXes, so it has a
 * shorter routing delay and is the preferred architecture.
 *
 * For a pure 4:1 MUX network the number of ports is a power of 4. For a 2:1 MUX
 * network the number of ports is a power of 2. To get the best from both worlds
 * build the first stage from 2:1 MUXes when the number of ports is a power of
 * 2 and use 4:1 MUXes for the remaining stages.
 */

generate

genvar i;

for (i = 0; i < 2; i = i + 1) begin
  localparam MUX_ORDER = i == 0 ? 1 : 2;
  localparam MIN_STAGE = i == 0 ? 0 : PORT_ADDRESS_WIDTH % 2;
  localparam NUM_STAGES = i == 0 ? PORT_ADDRESS_WIDTH % 2 : PORT_ADDRESS_WIDTH / 2;

  if (NUM_STAGES != 0) begin
    wire [NUM_OF_PORTS*MUX_ORDER*NUM_STAGES-1:0] unpack_ctrl_s;
    reg [NUM_OF_PORTS*MUX_ORDER*NUM_STAGES-1:0] unpack_ctrl = 'h00;

    pack_ctrl #(
      .PORT_ADDRESS_WIDTH(PORT_ADDRESS_WIDTH),
      .MUX_ORDER(MUX_ORDER),
      .MIN_STAGE(MIN_STAGE),
      .NUM_STAGES(NUM_STAGES)
    ) i_unpack_ctrl (
      .rotate(rotate),
      .enable(ports_enable),
      .ctrl(unpack_ctrl_s),
      .enable_count(enable_count[i])
    );

    always @(posedge clk) begin
      if (ce_ctrl == 1'b1) begin
        unpack_ctrl <= unpack_ctrl_s;
      end
    end

    pack_interconnect #(
      .PORT_DATA_WIDTH(SAMPLE_DATA_WIDTH),
      .PORT_ADDRESS_WIDTH(PORT_ADDRESS_WIDTH),
      .MUX_ORDER(MUX_ORDER),
      .NUM_STAGES(NUM_STAGES),
      .PACK(0)
    ) i_unpack_interconnect (
      .ctrl(unpack_ctrl),

      .data_in(unpacked_data[i]),
      .data_out(unpacked_data[i+1])
    );
  end else begin
    assign unpacked_data[i+1] = unpacked_data[i];
    assign enable_count[i] = enable_count[1-i]; // Use the other one
  end
end

genvar j;
for (i = 0; i < NUM_OF_CHANNELS; i = i + 1) begin
  localparam base_dst = i * SAMPLES_PER_CHANNEL*SAMPLE_DATA_WIDTH;
  localparam base_src = i * SAMPLE_DATA_WIDTH;

  for (j = 0; j < SAMPLES_PER_CHANNEL; j = j + 1) begin
    localparam dst = base_dst + j * SAMPLE_DATA_WIDTH;
    localparam src = base_src + j * SAMPLE_DATA_WIDTH*NUM_OF_CHANNELS;
    assign deinterleaved_data[dst+:SAMPLE_DATA_WIDTH] = unpacked_data[2][src+:SAMPLE_DATA_WIDTH];
  end
end

endgenerate

always @(posedge clk) begin
  if (fifo_rd_en == 1'b1 && reset_data == 1'b0) begin
    fifo_rd_data <= deinterleaved_data;
    fifo_rd_valid <= s_axis_valid;;
    fifo_rd_underflow <= ~s_axis_valid;
  end else begin
    fifo_rd_valid <= 1'b0;
    fifo_rd_underflow <= 1'b0;
  end
end

endmodule
