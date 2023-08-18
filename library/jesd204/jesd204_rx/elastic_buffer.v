// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module elastic_buffer #(
  parameter IWIDTH = 32,
  parameter OWIDTH = 48,
  parameter SIZE = 256,
  parameter ASYNC_CLK = 0
) (
  input clk,
  input reset,

  input device_clk,
  input device_reset,

  input [IWIDTH-1:0] wr_data,

  output [OWIDTH-1:0] rd_data,

  input ready_n,
  input do_release_n
);

  localparam ADDR_WIDTH = SIZE > 128 ? 7 :
    SIZE > 64 ? 6 :
    SIZE > 32 ? 5 :
    SIZE > 16 ? 4 :
    SIZE > 8 ? 3 :
    SIZE > 4 ? 2 :
    SIZE > 2 ? 1 : 0;

  localparam WIDTH = OWIDTH >= IWIDTH ? OWIDTH : IWIDTH;

  reg [ADDR_WIDTH:0] wr_addr = 'h00;
  reg [ADDR_WIDTH:0] rd_addr = 'h00;
  (* ram_style = "distributed" *) reg [WIDTH-1:0] mem[0:SIZE - 1];
  reg             mem_rd_valid = 'b0;
  reg [WIDTH-1:0] mem_rd_data;

  wire mem_wr;
  wire [WIDTH-1:0] mem_wr_data;
  wire unpacker_ready;

  generate if ((OWIDTH < IWIDTH) && ASYNC_CLK) begin

    assign mem_wr = 1'b1;

    always @(posedge clk) begin
      if (ready_n) begin
        wr_addr <= 'h00;
      end else if (mem_wr) begin
        wr_addr <= wr_addr + 1;
      end
    end

    always @(posedge clk) begin
      if (mem_wr) begin
        mem[wr_addr] <= wr_data;
      end
    end

    assign mem_rd_en = ~do_release_n & unpacker_ready;

    always @(posedge device_clk) begin
      if (mem_rd_en) begin
        mem_rd_data <= mem[rd_addr];
      end
      mem_rd_valid <= mem_rd_en;
    end

    always @(posedge device_clk) begin
      if (do_release_n) begin
        rd_addr <= 'b0;
      end else if (mem_rd_en) begin
        rd_addr <= rd_addr + 1;
      end
    end

    ad_upack #(
      .I_W(IWIDTH/8),
      .O_W(OWIDTH/8),
      .UNIT_W(8),
      .O_REG(0)
    ) i_ad_upack (
      .clk(device_clk),
      .reset(do_release_n),
      .idata(mem_rd_data),
      .ivalid(mem_rd_valid),
      .iready(unpacker_ready),

      .odata(rd_data),
      .ovalid());

    end else begin
      if ((OWIDTH > IWIDTH) && ASYNC_CLK) begin
        ad_pack #(
          .I_W(IWIDTH/8),
          .O_W(OWIDTH/8),
          .UNIT_W(8)
        ) i_ad_pack (
          .clk(clk),
          .reset(ready_n),
          .idata(wr_data),
          .ivalid(1'b1),

          .odata(mem_wr_data),
          .ovalid(mem_wr));
      end else begin
        assign mem_wr = 1'b1;
        assign mem_wr_data = wr_data;
      end

      always @(posedge clk) begin
        if (ready_n == 1'b1) begin
          wr_addr <= 'h00;
        end else if (mem_wr) begin
          mem[wr_addr] <= mem_wr_data;
          wr_addr <= wr_addr + 1'b1;
        end
      end

      always @(posedge device_clk) begin
        if (do_release_n == 1'b1) begin
          rd_addr <= 'h00;
        end else begin
          rd_addr <= rd_addr + 1'b1;
          mem_rd_data <= mem[rd_addr];
        end
      end

      assign rd_data = mem_rd_data;

    end
  endgenerate

endmodule
