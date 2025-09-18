// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2015-2025 Analog Devices, Inc. All rights reserved.
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

module spi_engine_execution #(

  parameter NUM_OF_CS = 1,
  parameter DEFAULT_SPI_CFG = 0,
  parameter DEFAULT_CLK_DIV = 0,
  parameter DATA_WIDTH = 8,                   // Valid data widths values are 8/16/24/32
  parameter NUM_OF_SDI = 1,
  parameter [0:0] SDO_DEFAULT = 1'b0,
  parameter ECHO_SCLK = 0,
  parameter [1:0] SDI_DELAY = 2'b00
) (
  input clk,
  input resetn,

  output cmd_ready,
  input cmd_valid,
  input [15:0] cmd,

  input sdo_data_valid,
  output sdo_data_ready,
  input [(DATA_WIDTH-1):0] sdo_data,

  input sdi_data_ready,
  output sdi_data_valid,
  output [(NUM_OF_SDI * DATA_WIDTH)-1:0] sdi_data,

  input sync_ready,
  output reg sync_valid,
  output [7:0] sync,

  input echo_sclk,
  output reg sclk,
  output reg sdo,
  output reg sdo_t,
  input [NUM_OF_SDI-1:0] sdi,
  output reg [NUM_OF_CS-1:0] cs,
  output reg three_wire
);

  localparam CMD_TRANSFER = 3'b000;
  localparam CMD_CHIPSELECT = 3'b001;
  localparam CMD_WRITE = 3'b010;
  localparam CMD_MISC = 3'b011;
  localparam CMD_CS_INV = 3'b100;

  localparam MISC_SYNC = 1'b0;
  localparam MISC_SLEEP = 1'b1;

  localparam REG_CLK_DIV = 2'b00;
  localparam REG_CONFIG = 2'b01;
  localparam REG_WORD_LENGTH = 2'b10;

  localparam BIT_COUNTER_WIDTH = DATA_WIDTH > 16 ? 5 :
                                 DATA_WIDTH > 8  ? 4 : 3;

  localparam BIT_COUNTER_CARRY = 2** (BIT_COUNTER_WIDTH + 1);
  localparam BIT_COUNTER_CLEAR = {{8{1'b1}}, {BIT_COUNTER_WIDTH{1'b0}}, 1'b1};

  reg sclk_int = 1'b0;
  reg sdo_t_int = 1'b0;

  reg idle;

  reg [7:0] clk_div_counter = 'h00;
  reg [7:0] clk_div_counter_next = 'h00;
  reg clk_div_last;

  reg [7:0] sleep_counter;
  reg [(BIT_COUNTER_WIDTH-1):0] bit_counter;
  reg [7:0] transfer_counter;
  reg [7:0] echo_transfer_counter;
  reg ntx_rx;
  reg sleep_counter_increment;

  reg trigger = 1'b0;
  reg trigger_next = 1'b0;
  reg wait_for_io = 1'b0;
  reg transfer_active = 1'b0;
  reg transfer_done = 1'b0;

  reg last_transfer;
  reg echo_last_transfer;
  reg [7:0] word_length = DATA_WIDTH;
  reg [7:0] last_bit_count = DATA_WIDTH-1;
  reg [7:0] left_aligned = 8'b0;

  assign first_bit = ((bit_counter == 'h0) ||  (bit_counter == word_length));

  reg [15:0] cmd_d1;

  reg cpha = DEFAULT_SPI_CFG[0];
  reg cpol = DEFAULT_SPI_CFG[1];
  reg [7:0] clk_div = DEFAULT_CLK_DIV;
  reg sdo_idle_state = SDO_DEFAULT;

  reg [NUM_OF_CS-1:0] cs_inv_mask_reg = 'h0;

  reg sdo_enabled = 1'b0;
  reg sdi_enabled = 1'b0;
  wire sdo_enabled_io;
  wire sdi_enabled_io;

  wire sdo_int_s;

  wire last_bit;
  wire echo_last_bit;
  wire first_bit;
  wire end_of_word;

  wire [2:0] inst = cmd[14:12];
  wire [2:0] inst_d1 = cmd_d1[14:12];

  wire exec_cmd = cmd_ready && cmd_valid;
  wire exec_transfer_cmd = exec_cmd && inst == CMD_TRANSFER;
  wire exec_cs_inv_cmd = exec_cmd && inst == CMD_CS_INV;
  wire exec_write_cmd = exec_cmd && inst == CMD_WRITE;
  wire exec_chipselect_cmd = exec_cmd && inst == CMD_CHIPSELECT;
  wire exec_misc_cmd = exec_cmd && inst == CMD_MISC;
  wire exec_sync_cmd = exec_misc_cmd && cmd[8] == MISC_SYNC;

  wire trigger_tx;
  wire trigger_rx;

  wire [1:0] cs_sleep_counter = sleep_counter[1:0];
  wire sleep_counter_compare;
  wire cs_sleep_counter_compare;
  wire cs_sleep_early_exit;
  reg cs_sleep_repeat;
  reg cs_activate;

  wire io_ready1;
  wire io_ready2;

  wire sdo_io_ready;

  (* direct_enable = "yes" *) wire cs_gen;

  spi_engine_execution_shiftreg #(
    .DEFAULT_SPI_CFG(DEFAULT_SPI_CFG),
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_OF_SDI(NUM_OF_SDI),
    .SDI_DELAY(SDI_DELAY),
    .ECHO_SCLK(ECHO_SCLK),
    .CMD_TRANSFER(CMD_TRANSFER)
  ) shiftreg (
    .clk(clk),
    .resetn(resetn),
    .sdi(sdi),
    .sdo_int(sdo_int_s),
    .echo_sclk(echo_sclk),
    .sdo_data(sdo_data),
    .sdo_data_valid(sdo_data_valid),
    .sdo_data_ready(sdo_data_ready),
    .sdi_data(sdi_data),
    .sdi_data_valid(sdi_data_valid),
    .sdi_data_ready(sdi_data_ready),
    .sdo_enabled(sdo_enabled),
    .sdi_enabled(sdi_enabled),
    .current_cmd(cmd_d1),
    .sdo_idle_state(sdo_idle_state),
    .left_aligned(left_aligned),
    .word_length(word_length),
    .sdo_io_ready(sdo_io_ready),
    .echo_last_bit(echo_last_bit),
    .transfer_active(transfer_active),
    .trigger_tx(trigger_tx),
    .trigger_rx(trigger_rx),
    .first_bit(first_bit),
    .cs_activate(cs_activate));

  assign cs_gen = inst_d1 == CMD_CHIPSELECT
                  && ((cs_sleep_counter_compare == 1'b1) || cs_sleep_early_exit)
                  && (cs_sleep_repeat == 1'b0)
                  && (idle == 1'b0);
  assign cmd_ready = idle;

  always @(posedge clk) begin
    if (exec_transfer_cmd) begin
      sdo_enabled <= cmd[8];
      sdi_enabled <= cmd[9];
    end
  end
  assign sdo_enabled_io = (exec_transfer_cmd) ? cmd[8] : sdo_enabled;
  assign sdi_enabled_io = (exec_transfer_cmd) ? cmd[9] : sdi_enabled;

  always @(posedge clk) begin
    if (cmd_ready & cmd_valid)
     cmd_d1 <= cmd;
  end

  // Load the interface configurations from the 'Configuration Write'
  // instruction
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      cpha <= DEFAULT_SPI_CFG[0];
      cpol <= DEFAULT_SPI_CFG[1];
      three_wire <= DEFAULT_SPI_CFG[2];
      sdo_idle_state <= SDO_DEFAULT;
      clk_div <= DEFAULT_CLK_DIV;
      word_length <= DATA_WIDTH;
      left_aligned <= 8'b0;
    end else if (exec_write_cmd == 1'b1) begin
      if (cmd[9:8] == REG_CONFIG) begin
        cpha <= cmd[0];
        cpol <= cmd[1];
        three_wire <= cmd[2];
        sdo_idle_state <= cmd[3];
      end else if (cmd[9:8] == REG_CLK_DIV) begin
        clk_div <= cmd[7:0];
      end else if (cmd[9:8] == REG_WORD_LENGTH) begin
        // the max value of this reg must be DATA_WIDTH
        word_length <= cmd[7:0];
        left_aligned <= DATA_WIDTH - cmd[7:0]; // needed 1 cycle before transfer_active goes high
      end
    end
  end

  always @(posedge clk) begin
    // we can calculate this from word_length (instead of cmd), with an extra cycle delay
    // because even in the worst case (transfer after config), we still have another cycle before using it
    last_bit_count <= word_length - 1; // needed when transfer_active goes high
  end

  always @(posedge clk) begin
    if ((clk_div_last == 1'b0 && idle == 1'b0 && wait_for_io == 1'b0 &&
      clk_div_counter == 'h01) || clk_div == 'h00)
      clk_div_last <= 1'b1;
    else
      clk_div_last <= 1'b0;
  end

  always @(posedge clk) begin
    if (clk_div_last == 1'b1 || idle == 1'b1 || wait_for_io == 1'b1) begin
      clk_div_counter <= clk_div;
      trigger <= 1'b1;
    end else begin
      clk_div_counter <= clk_div_counter - 1'b1;
      trigger <= 1'b0;
    end
  end

  assign trigger_tx = trigger == 1'b1 && ntx_rx == 1'b0;
  assign trigger_rx = trigger == 1'b1 && ntx_rx == 1'b1;

  assign sleep_counter_compare = sleep_counter == cmd_d1[7:0]+1;
  assign cs_sleep_counter_compare = cs_sleep_counter == cmd_d1[9:8];
  assign cs_sleep_early_exit = (cmd_d1[9:8] == 2'b00);

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      cs_sleep_repeat <= 1'b0;
    end else begin
      if (idle) begin
        cs_sleep_repeat <= 1'b0;
      end else if (cs_sleep_counter_compare && (inst_d1 == CMD_CHIPSELECT)) begin
        cs_sleep_repeat <= !cs_sleep_repeat;
      end
    end
  end

  always @(posedge clk) begin
    if (idle == 1'b1) begin
      bit_counter <= 'h0;
      transfer_counter <= 'h0;
      ntx_rx  <= 1'b0;
      sleep_counter_increment <= 1'b0;
      sleep_counter <= 'h0;
    end else begin
      if (clk_div_last == 1'b1 && wait_for_io == 1'b0) begin
        if (last_bit && transfer_active && ntx_rx) begin
          bit_counter <= 'h0;
          transfer_counter <= transfer_counter + 1;
          ntx_rx <= ~ntx_rx;
        end else begin
          if (transfer_active) begin
            bit_counter <= bit_counter + ntx_rx;
            ntx_rx <= ~ntx_rx;
          end else begin
            sleep_counter_increment <= ~sleep_counter_increment;
            sleep_counter <= sleep_counter + sleep_counter_increment;
          end
        end
      end
      if (cs_sleep_counter_compare && !cs_sleep_repeat && inst_d1 == CMD_CHIPSELECT) begin
        sleep_counter <= 'h0;
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      idle <= 1'b1;
    end else begin
      if (exec_transfer_cmd || exec_chipselect_cmd || exec_misc_cmd) begin
        idle <= 1'b0;
      end else begin
        case (inst_d1)
        CMD_TRANSFER: begin
          if (transfer_done)
            idle <= 1'b1;
        end
        CMD_CHIPSELECT: begin
          if ((cs_sleep_counter_compare && cs_sleep_repeat) || cs_sleep_early_exit)
            idle <= 1'b1;
        end
        CMD_MISC: begin
          case (cmd_d1[8])
          MISC_SLEEP: begin
            if (sleep_counter_compare)
              idle <= 1'b1;
          end
          MISC_SYNC: begin
            if (sync_ready)
              idle <= 1'b1;
          end
          endcase
        end
        endcase
      end
    end
  end

  always @(posedge clk ) begin
    if (resetn == 1'b0) begin
      cs_inv_mask_reg <= 'h0;
    end else begin
      if (exec_cs_inv_cmd == 1'b1) begin
        cs_inv_mask_reg <= cmd[NUM_OF_CS-1:0];
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      cs <= 'hff;
    end else if (cs_gen) begin
      cs <= cmd_d1[NUM_OF_CS-1:0]^cs_inv_mask_reg[NUM_OF_CS-1:0];
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      sync_valid <= 1'b0;
    end else begin
      if (exec_sync_cmd == 1'b1) begin
        sync_valid <= 1'b1;
      end else if (sync_ready == 1'b1) begin
        sync_valid <= 1'b0;
      end
    end
  end

  assign sync = cmd_d1[7:0];

  assign io_ready1 = (sdi_data_valid == 1'b0 || sdi_data_ready == 1'b1) &&
          (sdo_enabled_io == 1'b0 || sdo_io_ready == 1'b1);
  assign io_ready2 = (sdi_enabled == 1'b0 || sdi_data_ready == 1'b1) &&
          (sdo_enabled_io == 1'b0 || last_transfer == 1'b1 || sdo_io_ready == 1'b1);

  always @(posedge clk) begin
    if (idle == 1'b1) begin
      last_transfer <= 1'b0;
    end else if (trigger_tx == 1'b1 && transfer_active == 1'b1) begin
      if (transfer_counter == cmd_d1[7:0])
        last_transfer <= 1'b1;
      else
        last_transfer <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0 || idle == 1'b1) begin
      echo_last_transfer    <= 1'b0;
    end else begin
      if (inst_d1 == CMD_TRANSFER && cmd_d1[7:0] == 0) begin
        echo_last_transfer    <= 1'b1;
      end else if (echo_last_bit == 1'b1) begin
        if (echo_transfer_counter +1 == cmd_d1[7:0]) begin
          echo_last_transfer    <= 1'b1;
        end else begin
          echo_last_transfer    <= 1'b0;
        end
      end
    end
  end

  always @(posedge clk ) begin
    if (resetn == 1'b0 || idle == 1'b1) begin
      echo_transfer_counter <= 0;
    end else begin
      if (echo_last_bit == 1'b1) begin
        echo_transfer_counter <= echo_transfer_counter + 1;
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      transfer_active <= 1'b0;
      wait_for_io <= 1'b0;
    end else begin
      if (exec_transfer_cmd == 1'b1) begin
        wait_for_io <= !io_ready1;
        transfer_active <= io_ready1;
      end else if (wait_for_io == 1'b1 && io_ready1 == 1'b1) begin
        wait_for_io <= 1'b0;
        transfer_active <= !last_transfer;
      end else if (transfer_active == 1'b1 && end_of_word == 1'b1) begin
        if (last_transfer == 1'b1 || io_ready2 == 1'b0)
          transfer_active <= 1'b0;
        if (io_ready2 == 1'b0)
          wait_for_io <= 1'b1;
      end
    end
  end

  always @(posedge clk ) begin
    if (resetn == 1'b0) begin
      transfer_done <= 1'b0;
    end else begin
       if (ECHO_SCLK) begin
        transfer_done <= echo_last_bit && echo_last_transfer;
       end else begin
        transfer_done <= (wait_for_io && io_ready1 && last_transfer) || (!wait_for_io && transfer_active && end_of_word && last_transfer );
       end
    end
  end

  always @(posedge clk) begin
    if (transfer_active == 1'b1 || wait_for_io == 1'b1)
    begin
      sdo_t_int <= ~sdo_enabled;
    end else begin
      sdo_t_int <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (!resetn) begin // set cs_activate during reset for a cycle to clear shift reg
      cs_activate <= 1;
    end else begin
      cs_activate <= ~(&cmd_d1[NUM_OF_CS-1:0]) & cs_gen;
    end
  end

  // end_of_word will signal the end of a transaction, pushing the command
  // stream execution to the next command. end_of_word in normal mode can be
  // generated using the global bit_counter
  assign last_bit = (bit_counter == last_bit_count);
  assign end_of_word = last_bit == 1'b1 && ntx_rx == 1'b1 && clk_div_last == 1'b1;

  always @(posedge clk) begin
    if (transfer_active == 1'b1) begin
      sclk_int <= cpol ^ cpha ^ ntx_rx;
    end else begin
      sclk_int <= cpol;
    end
  end

  // Additional register stage to improve timing
  always @(posedge clk) begin
    sclk <= sclk_int;
    sdo <= sdo_int_s;
    sdo_t <= sdo_t_int;
  end

endmodule
