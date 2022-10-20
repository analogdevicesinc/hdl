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

module spi_engine_execution_tb;
  parameter VCD_FILE = "spi_engine_execution_tb.vcd";
//  parameter VCD_FILE = {spi_engine_execution_tb.vcd,"cd"};
  parameter NUM_OF_CS = 1;
  parameter DEFAULT_SPI_CFG = 0;
  parameter DEFAULT_CLK_DIV = 0;
  parameter DATA_WIDTH = 32;                   // Valid data widths values are 8/16/24/32
  parameter NUM_OF_SDI = 4;
  parameter NUM_OF_SDO = 4;
  parameter [0:0] SDO_DEFAULT = 1'b0;
  parameter ECHO_SCLK = 0;
  parameter [1:0] SDI_DELAY = 2'b00;


  localparam THREE_WIRE = 0;
  localparam CPOL = 0;
  localparam CPHA = 1;
  localparam CLOCK_DIVIDER = 1;
  localparam DATA_DLENGTH = 32;

  localparam NUM_OF_WORDS = 256;


  `define TIMEOUT 1000000
  localparam INST_CS_OFF = 16'h10FF;
  localparam INST_CS_ON  = 16'h10FE;

  localparam INST_WR = 16'h0100 | (NUM_OF_WORDS-1);
  localparam INST_RD = 16'h0200 | (NUM_OF_WORDS-1);
  localparam INST_WRD = 16'h0300 | (NUM_OF_WORDS-1);

  // Configuration register instructions
  localparam INST_CFG = 16'h2100 | (THREE_WIRE << 2) | (CPOL << 1) | CPHA;
  localparam INST_PRESCALE = 16'h2000 | CLOCK_DIVIDER;
  localparam INST_DLENGTH = 16'h2200 | DATA_DLENGTH;

  // Synchronization
  localparam INST_SYNC = 16'h3000 | 1'b1;

  // Sleep instruction
  localparam INST_SLEEP = 16'h3100;
  `define sleep(a) INST_SLEEP | (a & 8'hFF)

  `include "tb_base.v"

  wire cmd_ready;
  reg cmd_valid;
  reg [15:0] cmd;

  wire sdo_data_ready;
  reg sdo_data_valid =1'b1;
  reg [(DATA_WIDTH-1):0] sdo_data = 32'h0;

  wire sdi_data_valid;
  wire [(NUM_OF_SDI * DATA_WIDTH)-1:0] sdi_data;
  reg sdi_data_ready;

  wire sync_valid;
  wire [7:0] sync;
  reg sync_ready =1'b1;

  wire sclk;
  wire [NUM_OF_SDO-1:0] sdo;
  wire sdo_t;
  wire [NUM_OF_CS-1:0] cs;
  wire three_wire;
  reg [NUM_OF_SDI-1:0] sdi;
  reg echo_sclk;

  integer timedout = 0;


  task write_cmd;
    input [15:0] data;
    begin

      // wait for cmd_ready
      @(posedge clk)
      while (cmd_ready == 1'b0) begin
        @(posedge clk);
        timedout<= timedout + 1;
        if (timedout == 100000) begin
          $display("write_cmd timed out using 0x%x!", data);
          $finish;
        end
      end
      timedout = 0; // data bus is driven synchronously
      @(posedge clk)
        cmd = data;
        cmd_valid = 1'b1;
      @(posedge clk);
        cmd_valid = 1'b0;
    end
  endtask

  task generate_transfer;
    begin
      // assert CSN
      write_cmd (INST_CS_ON);
      // transfer data
      write_cmd (INST_WR);
      // de-assert CSN
      write_cmd(INST_CS_OFF);
    end
  endtask

  reg sclk_dac = 0;
  always @* begin
    #2  sclk_dac <= sclk;
  end

  initial begin
      #100
      // configure the PHY
      #30 write_cmd (INST_CFG);
      #30 write_cmd (INST_PRESCALE);
//      #30 write_cmd (INST_DLENGTH);

    repeat (16) begin
      #100
      generate_transfer();
    end
  end


  always@(posedge clk)
  begin
    if(sdo_data_ready == 1'b1) begin
      sdo_data <= sdo_data + 32'h00020001;
    end
  end



  //AD3552R stub QSPI SDR
  reg [15:0] counter =0 ;
  reg [15:0] dac_a = 0;
  reg [15:0] dac_b = 0;
  reg [7:0]  address =7'b0;
  reg [39:0] shift_register = 40'h0;

  always@(posedge sclk_dac) begin
    if(cs[0] == 1'b1) begin
      counter <= 0;
      shift_register <= 0;
    end else begin
      counter <= counter + 1;
      shift_register <= {shift_register[27:0],sdo[3],sdo[2],sdo[1],sdo[0]};
    end
    if (counter == 7) begin
//      address<= shift_register[39:32];
      dac_a <= shift_register[31:16];
      dac_b <= shift_register[15:0];
      counter <= 0;
    end
  end

  spi_engine_execution #(
  .NUM_OF_CS(NUM_OF_CS),
  .DEFAULT_SPI_CFG(DEFAULT_SPI_CFG),
  .DEFAULT_CLK_DIV(DEFAULT_CLK_DIV),
  .DATA_WIDTH(DATA_WIDTH),                   // Valid data widths values are 8/16/24/32
  .NUM_OF_SDI(NUM_OF_SDI),
  .NUM_OF_SDO(NUM_OF_SDO),
  .SDO_DEFAULT(SDO_DEFAULT),
  .ECHO_SCLK(ECHO_SCLK),
  .SDI_DELAY(SDI_DELAY)
) i_spie_engine_execution (
  .clk(clk),
  .resetn(resetn),

  .cmd_ready(cmd_ready),
  .cmd_valid(cmd_valid),
  .cmd(cmd),

  .sdo_data_valid(sdo_data_valid),
  .sdo_data_ready(sdo_data_ready),
  .sdo_data(sdo_data),

  .sdi_data_ready(sdi_data_ready),
  .sdi_data_valid(sdi_data_valid),
  .sdi_data(sdi_data),

  .sync_ready(sync_ready),
  .sync_valid(sync_valid),
  .sync(sync),

  .echo_sclk(echo_sclk),
  .sclk(sclk),
  .sdo(sdo),
  .sdo_t(sdo_t),
  .sdi(sdi),
  .cs(cs),
  .three_wire(three_wire));

endmodule
