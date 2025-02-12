// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad35xxr_if_tb;
  parameter VCD_FILE = "axi_ad35xxr_if_tb.vcd";

  `define TIMEOUT 9000
  `include "../common/tb/tb_base.v"

  wire [ 23:0] data_read;
  wire         dac_sclk;
  wire         dac_csn;
  wire         dac_data_ready;
  wire [ 3:0]  sdio_i;
  wire [ 3:0]  sdio_o;
  wire [ 3:0]  sdio_t;
  wire [31:0]  dac_data_final;
  wire [ 3:0]  readback_data_shift;
  wire [ 5:0]  data_increment_valid;
  wire         if_busy;

  reg [ 7:0] address_write  = 8'b0;
  reg        dac_clk        = 1'b0;
  reg        reset_in       = 1'b1;
  reg        transfer_data  = 1'b0;
  reg [ 1:0] multi_io_mode  = 2'h1;
  reg        sdr_ddr_n      = 1'b1;
  reg        reg_8b_16bn    = 1'b0;
  reg        stream         = 1'b0;
  reg [23:0] data_write     = 24'h0;
  reg        dac_data_valid = 1'b0;
  reg [ 3:0] shift_count    = 4'b0;
  reg [31:0] transfer_reg   = 32'h89abcdef;
  reg [ 5:0] valid_counter  = 6'b0;
  reg [31:0] dac_data       = 32'b0;

  always #3.8 dac_clk <= ~dac_clk;

  initial begin

    #100 reset_in = 1'b0;

    // Write 8 bit SDR
    // Classic SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    data_write = 24'hab0000;
    multi_io_mode = 2'h0;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Read 8 bit SDR
    // Dual SPI

    wait (if_busy == 1'b0);
    address_write = 8'hac;
    data_write = 24'h000000;
    multi_io_mode = 2'h1;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Write 8 bit SDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    data_write = 24'hab0000;
    multi_io_mode = 2'h2;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Read 8 bit SDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'hac;
    data_write = 24'h000000;
    multi_io_mode = 2'h2;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Write 16 bit SDR
    // Dual SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    data_write = 24'h123400;
    multi_io_mode = 2'h1;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Read 16 bit SDR
    // Classic SPI

    wait (if_busy == 1'b0);
    address_write = 8'hac;
    data_write = 24'h000000;
    multi_io_mode = 2'h0;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Write 16 bit SDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    data_write = 24'h123400;
    multi_io_mode = 2'h2;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Read 16 bit SDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'hac;
    data_write = 24'h000000;
    multi_io_mode = 2'h2;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    #500;

    // Write 8 bit  DDR
    // Classic SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    multi_io_mode = 2'h0;
    data_write = 24'h120000;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Read 8 bit DDR
    // it must ignore the sdr_ddr_n bit
    // and work as SDR
    // Dual SPI

    wait (if_busy == 1'b0);
    address_write = 8'hac;
    data_write = 24'h000000;
    multi_io_mode = 2'h1;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Write 8 bit DDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    multi_io_mode = 2'h2;
    data_write = 24'h120000;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Read 8 bit DDR
    // it must ignore the sdr_ddr_n bit
    // and work as SDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'hac;
    data_write = 24'h000000;
    multi_io_mode = 2'h2;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Write 16 bit DDR
    // Classic SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    data_write = 24'h123400;
    multi_io_mode = 2'h0;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Read 16 bit DDR
    // it must ignore the sdr_ddr_n bit
    // and work as SDR
    // Dual SPI

    wait (if_busy == 1'b0);
    address_write = 8'hac;
    data_write = 24'h000000;
    multi_io_mode = 2'h1;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Write 16 bit DDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    data_write = 24'h123400;
    multi_io_mode = 2'h2;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    // Read 16 bit DDR
    // it must ignore the sdr_ddr_n bit
    // and work as SDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'hac;
    data_write = 24'h000000;
    multi_io_mode = 2'h2;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #40 transfer_data = 1'b0;

    #500;

    // Stream SDR
    // Dual SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    multi_io_mode = 2'h1;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b1;
    transfer_data = 1'b1;
    #40 transfer_data = 1'b0;
    #1000 stream = 1'b0;

    #500;

    // Stream SDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    multi_io_mode = 2'h2;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b1;
    transfer_data = 1'b1;
    #40 transfer_data = 1'b0;
    #1000 stream = 1'b0;

    #500;

    // Stream DDR
    // Dual SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    multi_io_mode = 2'h1;
    reg_8b_16bn = 1'b1;
    sdr_ddr_n = 1'b0;
    stream = 1'b1;
    transfer_data = 1'b1;
    #40 transfer_data = 1'b0;
    #1000 stream = 1'b0;

    #500;

    // Stream DDR
    // Quad SPI

    wait (if_busy == 1'b0);
    address_write = 8'h2c;
    multi_io_mode = 2'h2;
    reg_8b_16bn = 1'b1;
    sdr_ddr_n = 1'b0;
    stream = 1'b1;
    transfer_data = 1'b1;
    #40 transfer_data = 1'b0;
    #1000 stream = 1'b0;

  end

  // data is incremented at each complete cycle

  assign dac_data_final       = (stream == 1'b1) ? dac_data : data_write;
  assign data_increment_valid = (sdr_ddr_n ) ? 6'd32: 6'd16;

  always @(posedge dac_clk) begin
    if (valid_counter == data_increment_valid) begin
      dac_data <= dac_data + 32'h00010002;
      valid_counter <= 6'b0;
      dac_data_valid <= 1'b1;
    end else begin
      dac_data <= dac_data;
      valid_counter <= valid_counter + 6'b1;
      dac_data_valid <= 1'b0;
    end
  end

  // data is circullary shifted at every sampling edge

  assign readback_data_shift = (sdr_ddr_n | address_write[7]) ? 4'h1 : 4'h0;
  assign sdio_i = (sdio_t[1] === 1'b1) ? transfer_reg[31:28] : 4'h0;

  always @(posedge dac_clk) begin
    if (shift_count == readback_data_shift) begin
      transfer_reg = (multi_io_mode == 2'h2) ? {transfer_reg[27:0],transfer_reg[31:28]} :
                     ((multi_io_mode == 2'h0 || multi_io_mode == 2'h3) ? {transfer_reg[30:0],transfer_reg[31]} :
                                                                      ((transfer_state == WRITE_ADDRESS) ? {transfer_reg[30:0],transfer_reg[31]} :
                                                                      {transfer_reg[29:0],transfer_reg[31:30]}));
    end else if (sdio_t[1] === 1'b1) begin
      transfer_reg <= transfer_reg;
    end
    if (shift_count == readback_data_shift || dac_csn == 1'b1) begin
      shift_count <= 3'b0;
    end else if (sdio_t[1] === 1'b1) begin
      shift_count <= shift_count + 3'b1;
    end
  end

  axi_ad35xxr_if axi_ad35xxr_interface (
    .clk_in(dac_clk),
    .reset_in(reset_in),
    .dac_data(dac_data_final),
    .dac_data_valid(dac_data_valid),
    .address(address_write),
    .data_read(data_read),
    .data_write(data_write),
    .multi_io_mode(multi_io_mode),
    .sdr_ddr_n(sdr_ddr_n),
    .symb_8_16b(reg_8b_16bn),
    .transfer_data(transfer_data),
    .stream(stream),
    .dac_data_ready(dac_data_ready),
    .if_busy(if_busy),
    .sclk(dac_sclk),
    .csn(dac_csn),
    .sdio_i(sdio_i),
    .sdio_o(sdio_o),
    .sdio_t(sdio_t));

endmodule
