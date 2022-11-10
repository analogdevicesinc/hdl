// ***************************************************************************
// ***************************************************************************
// Copyright 2022 (c) Analog Devices, Inc. All rights reserved.
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

module axi_ad3552r_if (

  input                   clk_in,  // 120MHz
  input                   reset_in,
  input       [31:0]      dac_data,
  input                   dac_data_valid,
  output reg              dac_data_ready,

  input       [ 7:0]      address,
  output reg  [23:0]      data_read,
  input       [23:0]      data_write,
  input                   ddr_sdr_n,
  input                   reg_16b_8bn,
  input                   transfer_data,
  input                   stream,

  // DAC control signals
  output                  sclk,
  output reg              csn,
  inout                   sdio_0,
  inout                   sdio_1,
  inout                   sdio_2,
  inout                   sdio_3
);

  wire transfer_data_s;

  reg [55:0]  transfer_reg = 56'h0;

  reg [31:0] dac_data_int = 32'h0;
  reg [15:0] counter = 16'h0;
  reg [2:0] transfer_state = 0;
  reg [2:0] transfer_state_next = 0;

  reg cycle_done = 1'b0;
  reg transfer_step = 1'b0;
  reg sclk_ddr = 1'b0;
  reg full_speed = 1'b0;
  reg transfer_data_d = 1'b0;
  reg transfer_data_dd = 1'b0;
  reg data_r_wn = 1'b0;

  localparam  [ 2:0]    IDLE = 3'h0,
                        CS_LOW = 3'h1,
                        WRITE_ADDRESS = 3'h2,
                        TRANSFER_REGISTER = 3'h3,
                        READ_REGISTER = 3'h4,
                        STREAM = 3'h5,
                        CS_HIGH = 3'h6;

 localparam ADDRESS_COUNTS = 16;
 localparam ADDRESS_COUNTS_FAST = ADDRESS_COUNTS >> 2;
 localparam TRANSFER_8B_SDR = 16;
 localparam TRANSFER_8B_DDR = 16;
 localparam TRANSFER_16B_SDR = 16;
 localparam TRANSFER_16B_DDR = 16;
 localparam TRANSFER_24B_SDR = 16;
 localparam TRANSFER_24B_DDR = 16;

// transform the transfer data rising edge into a pulse

 assign transfer_data_s = transfer_data_d & ~transfer_data_dd;

 always @(posedge clk_in) begin
  if(reset_in == 1'b1) begin
    transfer_data_d  <= 'd0;
    transfer_data_dd <= 'd0;
  end else begin
    transfer_data_d  <= transfer_data;
    transfer_data_dd <= transfer_data_d;
  end
 end


// dac_data_int is a register allows capturing asinchronously with the
// transmission
  always @(posedge clk_in) begin
    if (dac_data_valid) begin
      dac_data_int <= dac_data;
    end end
  always @(posedge clk_in) begin
    if (reset_in == 1'b1) begin
      transfer_state <= IDLE;
    end else begin
      transfer_state <= transfer_state_next;
    end
  end

  // FSM next state logic
  always @(*) begin
    case (transfer_state)
      IDLE : begin
        transfer_state_next = transfer_data_s ? CS_LOW : IDLE;
        csn = 1'b1;
        transfer_step = 0;
        cycle_done = 0;
      end
      CS_LOW : begin
        // brings CS down
        // loads all configuration
        // puts data on the SDIO pins
        // needs 5 ns before risedge of the clock
        transfer_state_next = WRITE_ADDRESS;
        csn = 1'b0;
        transfer_step = 0;
        cycle_done = 0;
      end
      WRITE_ADDRESS : begin
        // writes the address
        // it works either at full speed (60 MHz) when streaming or normal
        // speed (15 MHz)
        // full speed - 2 clock cycles
        // half speed 8 clock cycles
        cycle_done = full_speed ? (counter == 16'h3) : (counter == 16'hf);
        transfer_state_next = cycle_done ? (stream ? STREAM : TRANSFER_REGISTER) : WRITE_ADDRESS ;
        csn = 1'b0;
        transfer_step = full_speed ? (counter[0]== 1'h1) : ((counter[4:0] == 5'h5)); // in streaming, change data on falledge. On regular transfer, change data on negedgE. A single step should be done for 8 bit addressing
      end
      TRANSFER_REGISTER : begin
        // always works at 15 MHz
        // can be DDR or SDR
        //
        cycle_done = ddr_sdr_n ? (reg_16b_8bn ? (counter == 16'h11) : (counter == 16'h09)): (reg_16b_8bn ? (counter == 16'h20) : (counter == 16'h10));
        transfer_state_next = cycle_done ? CS_HIGH : TRANSFER_REGISTER;
        csn = 1'b0;
        transfer_step = ddr_sdr_n ? (counter[1:0] == 2'h0) : (counter[2:0] == 3'h0); // in DDR mode, change data on falledge
      end
      STREAM : begin
        // can be DDR or SDR
        // in DDR mode needs to be make sure the clock and data is shifted by
        // 2 ns
        cycle_done = stream ? (ddr_sdr_n ? (counter == 16'h7) : (counter == 16'h0f )): (ddr_sdr_n ? (counter == 16'h7) : (counter == 16'h10 ));
        transfer_state_next = stream ? STREAM: (cycle_done ?  CS_HIGH :STREAM);
        csn = 1'b0;
        transfer_step = ddr_sdr_n ? 1'b1 : counter[0] ;
      end
      CS_HIGH : begin
        cycle_done = 1'b1;
        transfer_state_next = cycle_done ? IDLE : CS_HIGH;
        csn = 1'b1;
        transfer_step = 0;
      end
      default : begin
        cycle_done = 0;
        transfer_state_next = IDLE;
        csn = 1'b1;
        transfer_step = 0;
      end
    endcase
  end

  // counter is used to time all states
  // depends on number of clock cycles per phase
  //
  always@(posedge clk_in) begin
    if (transfer_state == IDLE) begin
      counter <= 1'b0;
    end else if (transfer_state == WRITE_ADDRESS | transfer_state == TRANSFER_REGISTER | transfer_state == STREAM) begin
      if (cycle_done) begin
        counter <= 0;
      end else  begin
        counter <= counter + 1;
      end
    end
  end
  // always@(posedge clk_in) begin
  //   if (transfer_state == IDLE) begin
  //     counter <= 0;
  //   end else if (transfer_state == CS_LOW | transfer_state == WRITE_ADDRESS | transfer_state == TRANSFER_REGISTER) begin
  //     if (transfer_state_next == STREAM) begin
  //       counter <= 0;
  //     end else begin
  //       counter <= counter + 1;
  //     end
  //   end else if (transfer_state == STREAM) begin
  //     if (cycle_done == 1'b1) begin
  //       counter <= 0;
  //     end else begin
  //       counter <= counter + 1;
  //     end
  //   end
  // end

// selection between 60 MHz and 15 MHz

  always @(negedge clk_in) begin
    if (transfer_state == STREAM | transfer_state == WRITE_ADDRESS ) begin
      sclk_ddr <= !sclk_ddr;
    end else begin
     sclk_ddr <= 0;
   end
 end

  assign sclk = full_speed ? (ddr_sdr_n ? sclk_ddr : counter[0]) : counter[2];

  always@(posedge clk_in) begin
    if (transfer_state == CS_LOW) begin
        data_r_wn <= address[7];
      end else if (transfer_state == CS_HIGH) begin
        data_r_wn <=1'b0;
      end
    if (transfer_state == CS_LOW & stream) begin
        dac_data_ready <= 1'b1;
    end else if (transfer_state == STREAM) begin
      if (cycle_done == 1'b1) begin
        dac_data_ready <= stream;
      end else begin
        dac_data_ready <= 1'b0;
      end
    end else begin
        dac_data_ready <= 1'b0;
    end
    if (transfer_state == CS_LOW) begin
        full_speed = stream;
      if(stream) begin
        transfer_reg <= {address,dac_data_int, 16'h0};
      end else begin
        transfer_reg <= {address,data_write, 24'h0};
      end
    end else if (transfer_state == STREAM & cycle_done) begin
        transfer_reg <= {dac_data_int, 24'h0};
    end else if (transfer_step) begin
      transfer_reg <= {transfer_reg[51:0], sdio_3,sdio_2,sdio_1,sdio_0};
    end

    if (transfer_state == CS_HIGH) begin
      data_read <= transfer_reg[23:0];
    end
  end

  // address[7] is r_wn : depends also on the state machine, input only when
  // in TRANSFER register mode
  assign sdio_0 = (data_r_wn & transfer_state == TRANSFER_REGISTER) ? 1'bz : transfer_reg[52];
  assign sdio_1 = (data_r_wn & transfer_state == TRANSFER_REGISTER) ? 1'bz : transfer_reg[53];
  assign sdio_2 = (data_r_wn & transfer_state == TRANSFER_REGISTER) ? 1'bz : transfer_reg[54];
  assign sdio_3 = (data_r_wn & transfer_state == TRANSFER_REGISTER) ? 1'bz : transfer_reg[55];

endmodule
