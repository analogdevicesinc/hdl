// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2016-2019, 2021-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_up_ilas_mem #(
  parameter DATA_PATH_WIDTH = 4
) (
  input up_clk,

  input up_rreq,
  input [1:0] up_raddr,
  output [31:0] up_rdata,

  input core_clk,
  input core_reset,

  input core_ilas_config_valid,
  input [1:0] core_ilas_config_addr,
  input [DATA_PATH_WIDTH*8-1:0] core_ilas_config_data,

  output up_ilas_ready
);

  localparam ILAS_DATA_LENGTH = (DATA_PATH_WIDTH == 4) ? 4 : 2;

  reg core_ilas_captured = 1'b0;

  wire [1:0] up_raddr_i;
  wire [31:0] up_rdata_i;

  ad_mem #(
    .DATA_WIDTH(DATA_PATH_WIDTH*8),
    .ADDRESS_WIDTH($clog2(ILAS_DATA_LENGTH))
  ) mem (
    .clka(core_clk),
    .wea(core_ilas_config_valid),
    .addra(core_ilas_config_addr),
    .dina(core_ilas_config_data),

    .clkb(up_clk),
    .reb(up_rreq),
    .addrb(up_raddr_i),
    .doutb(up_rdata_i)
  );

  generate
    if(DATA_PATH_WIDTH == 4)  begin : dp_4_gen
      assign up_raddr_i = up_raddr;
      assign up_rdata = up_rdata_i;
    end else if(DATA_PATH_WIDTH == 8) begin : dp_8_gen
      assign up_raddr_i = up_raddr[1];
      assign up_rdata = up_rdata_i >> (up_raddr[0]*32);
    end
  endgenerate

  sync_bits i_cdc_ilas_ready (
    .in_bits(core_ilas_captured),
    .out_resetn(1'b1),
    .out_clk(up_clk),
    .out_bits(up_ilas_ready));

  always @(posedge core_clk) begin
    if (core_reset == 1'b1) begin
      core_ilas_captured <= 1'b0;
    end else begin
      if (core_ilas_config_valid == 1'b1 && core_ilas_config_addr == ILAS_DATA_LENGTH-1) begin
        core_ilas_captured <= 1'b1;
      end
    end
  end

  /*
   * Shift register with variable tap for accessing the stored data.
   *
   * This has slightly better utilization on Xilinx based platforms than the dual
   * port RAM approach, but there is no equivalent primitive on Intel resulting
   * in increased utilization since it needs to be implemented used registers and
   * muxes.
   *
   * We might make this a device dependent configuration option at some point.

  reg [3:0] mem[0:31];

  generate
  genvar i;
  for (i = 0; i < 32; i = i + 1) begin: gen_ilas_mem
    assign up_rdata[i] = mem[i][~up_raddr];

    always @(posedge core_clk) begin
      if (core_ilas_config_valid == 1'b1) begin
        mem[i] <= {mem[i][2:0],core_ilas_config_data[i]};
      end
    end
  end
  endgenerate
  */

endmodule
