// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

module axi_ad3552r_if_tb;
  parameter VCD_FILE = {`__FILE__,"cd"};

  `define TIMEOUT 1000000
  `include "tb_base.v"

  reg    [  7:0]   address;
  reg    [  7:0]   address_write;
  wire    [23:0]   data_read;
  wire             dac_valid;
  wire             dac_sclk;
  wire             dac_csn;
  wire             dac_data_ready;

  reg clk_a = 1'b0;
  reg clk_data = 1'b0;
  reg clk_b = 1'b0;
  reg clk_c = 1'b0;
  reg reset_in = 1'b1;
  reg transfer_data = 1'b0;

  reg [5:0] resetn_shift = 'h0;

  reg [10:0] counter = 'h00;
  reg [10:0] counter_n = 'h00;

  reg [15:0] ad3552r_8bit_reg = 'h00;
  reg [15:0] ad3552r_16bit_reg = 'h00;
  reg [15:0] dac_a = 'h00;
  reg [15:0] dac_b = 'h00;
  reg [31:0] shift_register = 'h00;
  reg [31:0] shift_register_n = 'h00;
  wire [31:0] dac_data ;
  reg [31:0] dac_data_old = 32'ha5a5f0f0;
  reg [15:0] ad3552r_16bit_in_reg = 'h00;

  reg ctrl_enable = 1'b0;
  reg ctrl_pause = 1'b0;
  reg address_read = 1'b0;
  reg ddr_sdr_n = 1'b1;
  reg reg_16b_8bn = 1'b0;
  reg stream = 1'b0;
  reg stream_reg = 1'b0;
  reg [23:0]    data_write = 24'h0;

  reg  dac_data_valid = 1'b0;
  wire dac_sdio_in_0;
  wire dac_sdio_in_1;
  wire dac_sdio_in_2;
  wire dac_sdio_in_3;

  always #4 clk_a <= ~clk_a;
  always #32 clk_data <= ~clk_data;
  initial begin
   #100 reset_in = 1'b0;
   // Write 8 bit SDR
   address_write = 8'h2c;
   data_write = 24'hf1a500;
   ddr_sdr_n = 1'b1;
   reg_16b_8bn = 1'b1;
   stream = 1'b0;
   #500 transfer_data = 1'b1;
   #100 transfer_data = 1'b0;
   #500 data_write = 24'ha5f000;
   // Read 8 bit SDR
   ad3552r_16bit_in_reg = 16'habcd;
   address_write = 8'hac;
   data_write = 24'hf1a500;
   ddr_sdr_n = 1'b1;
   reg_16b_8bn = 1'b1;
   stream = 1'b0;
   #500 transfer_data = 1'b1;
   #100 transfer_data = 1'b0;
   #500 data_write = 24'ha5f000;
   // Write 16 bit SDR
   address_write = 8'h2c;
   ddr_sdr_n = 1'b1;
   reg_16b_8bn = 1'b0;
   stream = 1'b0;
   #500 transfer_data = 1'b1;
   #100 transfer_data = 1'b0;
   #500 data_write = 24'h123400;
   // Read 16 bit SDR
   address_write = 8'hac;
   ad3552r_16bit_in_reg = 16'hfedc;
   ddr_sdr_n = 1'b1;
   reg_16b_8bn = 1'b0;
   stream = 1'b0;
   #500 transfer_data = 1'b1;
   #100 transfer_data = 1'b0;
   #500 data_write = 24'h123400;
   // Write 8 bit DDR
   address_write = 8'h2c;
   ddr_sdr_n = 1'b0;
   reg_16b_8bn = 1'b1;
   stream = 1'b0;
   #500 transfer_data = 1'b1;
   #100 transfer_data = 1'b0;
   #500 data_write = 24'hf5a500;
   // Write 16 bit DDR
   address_write = 8'h2c;
   ddr_sdr_n = 1'b0;
   reg_16b_8bn = 1'b0;
   stream = 1'b0;
   transfer_data = 1'b1;
   #100 transfer_data = 1'b0;
   #500 data_write = 24'h000000;
   // Stream SDR
   address_write = 8'h2c;
   ddr_sdr_n = 1'b1;
   reg_16b_8bn = 1'b0;
   stream = 1'b1;
   transfer_data = 1'b1;
   #100 transfer_data = 1'b0;
   #1725 stream = 1'b0;
   #2000 ddr_sdr_n = 1'b0;
   // Stream DDR
   address_write = 8'h2c;
   reg_16b_8bn = 1'b1;
   stream = 1'b1;
   transfer_data = 1'b1;
   #100 transfer_data = 1'b0;
   #5000 stream = 1'b0;
 
 end
 reg [3:0] counter_data = 4'b0;
 always@(posedge clk_a) begin
  if(counter_data == 4'h3) begin 
    dac_data_valid <= 1'b1;
  end else begin
  dac_data_valid <= 1'b0;
  end
  counter_data <= counter_data +4'b1;
  if(counter_data == 4'h7) begin 
  counter_data <= 4'h0;
  end
 end

  always@(posedge dac_sclk or posedge dac_csn) begin
    if(dac_csn == 1'b1) begin
      counter <= 0;
      shift_register <= 0;
      address_read <= 1'b0;
    end else begin
      if (counter == 2 && address_read == 1'b0) begin
        counter <= 0;
        address_read <= 1'b1;
        stream_reg <= stream;
      end else begin
        if (stream_reg) begin
          if (ddr_sdr_n == 1'b0 & counter == 3) begin
            counter <= 0;
          end else if (ddr_sdr_n == 1'b0 & counter == 7) begin
            counter <= 0;
          end else begin
            counter<= counter + 1;
          end
        end else begin
          if (counter <= 7) begin
            counter<= counter + 1;
          end else begin
            counter <= 1;
          end
        end
      end
    end
  end

  assign #15 dac_sdio_in_0 = shift_register_n[28];
  assign #15 dac_sdio_in_1 = shift_register_n[29];
  assign #15 dac_sdio_in_2 = shift_register_n[30];
  assign #15 dac_sdio_in_3 = shift_register_n[31];

  always@(negedge dac_sclk or posedge dac_csn) begin
    if(dac_csn == 1'b1 ) begin
      counter_n <= 0;
      shift_register_n <= 0;
    end else begin
        if ((counter == 2 && address_read == 1'b0)) begin
          counter_n <= 1;
          shift_register_n <= {ad3552r_16bit_in_reg, 16'h0};
        end else begin
          if (ddr_sdr_n == 1'b0 & counter_n == 5) begin
            counter_n <= 2;
          end else if (ddr_sdr_n == 1'b1 & counter_n  == 7) begin
            counter_n <= 1;
          end else begin
            counter_n <= counter_n + 1;
          end
        end
    end
  end

  always @(*) begin
    if (counter == 2) begin
      address <= shift_register[7:0];
    end

    if (stream_reg) begin
      if(ddr_sdr_n == 1'b1) begin
        if (counter == 3) begin
          dac_a = shift_register[15:0];
        end
        if (counter == 7) begin
          dac_b = shift_register[15:0];
        end
      end else begin
        if (counter_n == 3 && counter == 1) begin
          dac_a = {shift_register[7:4],shift_register_n[7:4],shift_register[3:0],shift_register_n[3:0]};
        end
        if (counter_n == 5 && counter == 3) begin
          dac_b = {shift_register[7:4],shift_register_n[7:4],shift_register[3:0],shift_register_n[3:0]};
        end
      end

    end else begin
      if(ddr_sdr_n == 1'b1) begin
        if (counter_n == 2) begin
          ad3552r_8bit_reg = shift_register[7:0];
        end
        if (counter_n == 4) begin
          ad3552r_16bit_reg = shift_register[15:0];
          dac_a = shift_register[15:0];
        end
        if (counter_n == 10) begin
          dac_b = shift_register[15:0];
        end
      end else begin
        if (counter_n == 2 && address_read) begin
          ad3552r_8bit_reg = {shift_register[3:0],shift_register_n[3:0]};
        end
        if (counter_n== 3) begin
          ad3552r_16bit_reg ={shift_register[7:4],shift_register_n[7:4],shift_register[3:0],shift_register_n[3:0]};
          dac_a = {shift_register[7:4],shift_register_n[7:4],shift_register[3:0],shift_register_n[3:0]};
        end
        if (counter_n == 6) begin
          dac_b = {shift_register[7:4],shift_register_n[7:4],shift_register[3:0],shift_register_n[3:0]};
        end
      end
    end
  end


  assign dac_data = (dac_data_valid) ? dac_data_old  + 32'h00010002 : dac_data_old;

always @(posedge clk_a) begin  
  dac_data_old <= dac_data;
end

wire [31:0] dac_data_final;
assign dac_data_final = dac_data;

  axi_ad3552r_if axi_ad3552r_interface (
    .clk_in(clk_a),
    .reset_in(reset_in),
    .dac_data(dac_data_final),
    .dac_data_valid(dac_data_valid),
    .address(address_write),
    .data_read(data_read),
    .data_write(data_write),
    .sdr_ddr_n(ddr_sdr_n),
    .symb_8_16b(reg_16b_8bn),
    .transfer_data(transfer_data),
    .stream(stream),
    .dac_data_ready(),
    .sclk(dac_sclk),
    .csn(dac_csn),
    .sdio_i(sdio_i),
    .sdio_o(sdio_o),
    .sdio_t(sdio_t));

endmodule
