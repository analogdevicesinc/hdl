// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad3552r_if_tb;
  parameter VCD_FILE = "axi_ad3552r_if_tb.vcd";

  `define TIMEOUT 9000
  `include "../common/tb/tb_base.v"

  wire   [ 23:0]   data_read;
  wire             dac_sclk;
  wire             dac_csn;
  wire             dac_data_ready;
  wire   [ 3:0]    sdio_i;
  wire   [ 3:0]    sdio_o;
  wire             sdio_t;
  wire   [31:0]    dac_data_final;
  wire   [ 3:0]    readback_data_shift;
  wire   [ 4:0]    data_increment_valid;
  wire             if_busy;

  reg    [ 7:0]    address_write  = 8'b0;
  reg              dac_clk        = 1'b0;
  reg              reset_in       = 1'b1;
  reg              transfer_data  = 1'b0;
  reg              sdr_ddr_n      = 1'b1;
  reg              reg_8b_16bn    = 1'b0;
  reg              stream         = 1'b0;
  reg    [23:0]    data_write     = 24'h0;
  reg              dac_data_valid = 1'b0;
  reg    [ 3:0]    shift_count    = 4'b0;
  reg    [31:0]    transfer_reg   = 32'h89abcdef;
  reg    [ 4:0]    valid_counter  = 5'b0;
  reg    [31:0]    dac_data       = 32'b0;

  always #4 dac_clk <= ~dac_clk;

  initial begin

    #100 reset_in = 1'b0;

    // Write 8 bit SDR

    address_write = 8'h2c;
    data_write = 24'hab0000;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #100 transfer_data = 1'b0;

    // Read 8 bit SDR

    address_write = 8'hac;
    data_write = 24'h000000;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #100 transfer_data = 1'b0;

    // Write 16 bit SDR

    address_write = 8'h2c;
    data_write = 24'h123400;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #100 transfer_data = 1'b0;

    // Read 16 bit SDR

    address_write = 8'hac;
    data_write = 24'h000000;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #100 transfer_data = 1'b0;
    
    #500;

    // Write 8 bit DDR

    address_write = 8'h2c;
    data_write = 24'h120000;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #100 transfer_data = 1'b0;

    // Read 8 bit DDR

    address_write = 8'hac;
    data_write = 24'h000000;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b1;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #100 transfer_data = 1'b0;

    // Write 16 bit DDR

    address_write = 8'h2c;
    data_write = 24'h123400;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    transfer_data = 1'b1;
    #100 transfer_data = 1'b0;

    // Read 16 bit DDR

    address_write = 8'hac;
    data_write = 24'h000000;
    sdr_ddr_n = 1'b0;
    reg_8b_16bn = 1'b0;
    stream = 1'b0;
    #500 transfer_data = 1'b1;
    #100 transfer_data = 1'b0;

    #500;

    // Stream SDR

    address_write = 8'h2c;
    sdr_ddr_n = 1'b1;
    reg_8b_16bn = 1'b0;
    stream = 1'b1;
    transfer_data = 1'b1;
    #100 transfer_data = 1'b0;
    #1000 stream = 1'b0;

    #500;

    // Stream DDR

    address_write = 8'h2c;
    reg_8b_16bn = 1'b1;
    sdr_ddr_n = 1'b0;
    stream = 1'b1;
    transfer_data = 1'b1;
    #100 transfer_data = 1'b0;
    #1000 stream = 1'b0;

  end

  // data is incremented at each complete cycle 

  assign dac_data_final       = (stream == 1'b1) ? dac_data : data_write;
  assign data_increment_valid = (sdr_ddr_n ) ? 5'd16: 5'h8;
  
  always @(posedge dac_clk) begin 
    if (valid_counter == data_increment_valid) begin
      dac_data <= dac_data + 32'h00010002;
      valid_counter <= 3'b0;
      dac_data_valid <= 1'b1;
    end else begin 
      dac_data <= dac_data;
      valid_counter <= valid_counter + 3'b1;
      dac_data_valid <= 1'b0;
    end 
  end

  // data is circullary shifted at every sampling edge 

  assign readback_data_shift = (sdr_ddr_n ) ? 4'h8 : 4'h4;
  assign sdio_i = (sdio_t === 1'b1) ? transfer_reg[31:28] : 4'b0;

  always @(posedge dac_clk) begin 
    if (shift_count == readback_data_shift) begin 
      transfer_reg <= {transfer_reg[27:0],transfer_reg[31:28]};
    end else if (sdio_t === 1'b1) begin 
      transfer_reg <= transfer_reg;
    end
    if (shift_count == readback_data_shift || dac_csn == 1'b1) begin 
      shift_count <= 3'b0;
    end else if (sdio_t === 1'b1) begin
      shift_count <= shift_count + 3'b1;
    end
  end

  axi_ad3552r_if axi_ad3552r_interface (
    .clk_in(dac_clk),
    .reset_in(reset_in),
    .dac_data(dac_data_final),
    .dac_data_valid(dac_data_valid),
    .address(address_write),
    .data_read(data_read),
    .data_write(data_write),
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
