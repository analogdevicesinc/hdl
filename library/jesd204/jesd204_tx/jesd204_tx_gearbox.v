// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

// Constraints:
//   - IN_DATA_PATH_WIDTH >= OUT_DATA_PATH_WIDTH
//

module jesd204_tx_gearbox #(
  parameter IN_DATA_PATH_WIDTH = 6,
  parameter OUT_DATA_PATH_WIDTH = 4,
  parameter NUM_LANES = 1,
  parameter DEPTH = 16
) (
  input link_clk,
  input reset,
  input device_clk,
  input device_reset,
  input [NUM_LANES*IN_DATA_PATH_WIDTH*8-1:0] device_data,
  input device_lmfc_edge,
  output [NUM_LANES*OUT_DATA_PATH_WIDTH*8-1:0] link_data,
  input output_ready
);

  localparam MEM_W = (OUT_DATA_PATH_WIDTH <= IN_DATA_PATH_WIDTH) ?
                      IN_DATA_PATH_WIDTH*8*NUM_LANES :
                      OUT_DATA_PATH_WIDTH*8*NUM_LANES;
  localparam D_LOG2 = $clog2(DEPTH);

  reg [MEM_W-1:0] mem [0:DEPTH-1];
  reg [D_LOG2-1:0]  in_addr ='h00;
  reg [D_LOG2-1:0]  out_addr = 'b0;
  reg               mem_rd_valid = 'b0;
  reg [MEM_W-1:0]  mem_rd_data = 'b0;

  wire                mem_rd_en;
  wire                mem_wr_en;
  wire [D_LOG2-1:0]  in_out_addr;
  wire [D_LOG2-1:0]  out_in_addr;
  wire [MEM_W-1:0]  mem_wr_data;
  wire [NUM_LANES-1:0] data_ready;
  wire output_ready_sync;
  wire addr_reset;
  wire packer_reset;

  sync_bits i_sync_ready (
    .in_bits(output_ready),
    .out_resetn(~device_reset),
    .out_clk(device_clk),
    .out_bits(output_ready_sync));

  assign addr_reset   = device_lmfc_edge & ~output_ready_sync;
  assign packer_reset = device_reset | addr_reset;

  genvar i;
  generate if (OUT_DATA_PATH_WIDTH < IN_DATA_PATH_WIDTH) begin

    assign mem_wr_en = 1'b1;

    always @(posedge device_clk) begin
      if (addr_reset) begin
        in_addr <= 'h00;
      end else if (mem_wr_en) begin
        in_addr <= in_addr + 1;
      end
    end

    always @(posedge device_clk) begin
      if (mem_wr_en) begin
        mem[in_addr] <= device_data;
      end
    end

    assign mem_rd_en = output_ready&data_ready[0];

    always @(posedge link_clk) begin
      if (mem_rd_en) begin
        mem_rd_data <= mem[out_addr];
      end
      mem_rd_valid <= mem_rd_en;
    end

    always @(posedge link_clk) begin
      if (reset) begin
        out_addr <= 'b0;
      end else if (mem_rd_en) begin
        out_addr <= out_addr + 1;
      end
    end

    for (i = 0; i < NUM_LANES; i=i+1) begin: unpacker
      ad_upack #(
        .I_W(IN_DATA_PATH_WIDTH),
        .O_W(OUT_DATA_PATH_WIDTH),
        .UNIT_W(8),
        .O_REG(0)
      ) i_ad_upack (
        .clk(link_clk),
        .reset(reset),
        .idata(mem_rd_data[i*IN_DATA_PATH_WIDTH*8+:IN_DATA_PATH_WIDTH*8]),
        .ivalid(mem_rd_valid),
        .iready(data_ready[i]),

        .odata(link_data[i*OUT_DATA_PATH_WIDTH*8+:OUT_DATA_PATH_WIDTH*8]),
        .ovalid());
    end

  end else begin
    if (OUT_DATA_PATH_WIDTH > IN_DATA_PATH_WIDTH) begin
      for (i = 0; i < NUM_LANES; i=i+1) begin: packer
        ad_pack #(
          .I_W(IN_DATA_PATH_WIDTH),
          .O_W(OUT_DATA_PATH_WIDTH),
          .UNIT_W(8),
          .O_REG(0)
        ) i_ad_pack (
          .clk(device_clk),
          .reset(packer_reset),
          .idata(device_data[i*IN_DATA_PATH_WIDTH*8+:IN_DATA_PATH_WIDTH*8]),
          .ivalid(1'b1),

          .odata(mem_wr_data[i*OUT_DATA_PATH_WIDTH*8+:OUT_DATA_PATH_WIDTH*8]),
          .ovalid(data_ready[i]));
      end
      assign mem_wr_en = data_ready[0];
    end else begin
      assign mem_wr_en = 1'b1;
      assign mem_wr_data = device_data;
    end

    always @(posedge device_clk) begin
      if (addr_reset) begin
        in_addr <= 'h00;
      end else if (mem_wr_en) begin
        mem[in_addr] <= mem_wr_data;
        in_addr <= in_addr + 1'b1;
      end
    end

    always @(posedge link_clk) begin
      if (output_ready == 1'b0) begin
        out_addr <= 'h00;
      end else begin
        out_addr <= out_addr + 1'b1;
        mem_rd_data <= mem[out_addr];
      end
    end

    assign link_data = mem_rd_data;

  end
  endgenerate

endmodule
