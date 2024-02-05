// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
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

  output reg active,

  output cmd_ready,
  input cmd_valid,
  input [15:0] cmd,

  input sdo_data_valid,
  output reg sdo_data_ready,
  input [(DATA_WIDTH-1):0] sdo_data,

  input sdi_data_ready,
  output reg sdi_data_valid,
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

  localparam CMD_TRANSFER = 2'b00;
  localparam CMD_CHIPSELECT = 2'b01;
  localparam CMD_WRITE = 2'b10;
  localparam CMD_MISC = 2'b11;

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
  wire sdo_int_s;
  reg sdo_t_int = 1'b0;

  reg idle;

  reg [7:0] clk_div_counter = 'h00;
  reg [7:0] clk_div_counter_next = 'h00;
  reg clk_div_last;

  reg [(BIT_COUNTER_WIDTH+8):0] counter = 'h00;

  wire [7:0] sleep_counter = counter[(BIT_COUNTER_WIDTH+8):(BIT_COUNTER_WIDTH+1)];
  wire [1:0] cs_sleep_counter = counter[(BIT_COUNTER_WIDTH+2):(BIT_COUNTER_WIDTH+1)];
  wire [(BIT_COUNTER_WIDTH-1):0] bit_counter = counter[BIT_COUNTER_WIDTH:1];
  wire [7:0] transfer_counter = counter[(BIT_COUNTER_WIDTH+8):(BIT_COUNTER_WIDTH+1)];
  wire ntx_rx = counter[0];

  reg trigger = 1'b0;
  reg trigger_next = 1'b0;
  reg wait_for_io = 1'b0;
  reg transfer_active = 1'b0;

  wire last_bit;
  wire first_bit;
  reg last_transfer;
  reg [7:0] word_length = DATA_WIDTH;
  reg [7:0] left_aligned = 8'b0;
  wire end_of_word;

  reg [7:0] sdi_counter = 8'b0;

  assign first_bit = ((bit_counter == 'h0) ||  (bit_counter == word_length));

  reg [15:0] cmd_d1;

  reg cpha = DEFAULT_SPI_CFG[0];
  reg cpol = DEFAULT_SPI_CFG[1];
  reg [7:0] clk_div = DEFAULT_CLK_DIV;

  reg sdo_enabled = 1'b0;
  reg sdi_enabled = 1'b0;

  reg [(DATA_WIDTH-1):0] data_sdo_shift = 'h0;

  reg [SDI_DELAY+1:0] trigger_rx_d = {(SDI_DELAY+2){1'b0}};

  wire [1:0] inst = cmd[13:12];
  wire [1:0] inst_d1 = cmd_d1[13:12];

  wire exec_cmd = cmd_ready && cmd_valid;
  wire exec_transfer_cmd = exec_cmd && inst == CMD_TRANSFER;

  wire exec_write_cmd = exec_cmd && inst == CMD_WRITE;
  wire exec_chipselect_cmd = exec_cmd && inst == CMD_CHIPSELECT;
  wire exec_misc_cmd = exec_cmd && inst == CMD_MISC;
  wire exec_sync_cmd = exec_misc_cmd && cmd[8] == MISC_SYNC;

  wire trigger_tx;
  wire trigger_rx;

  wire sleep_counter_compare;
  wire cs_sleep_counter_compare;
  wire cs_sleep_early_exit;
  reg cs_sleep_repeat;
  reg cs_active;

  wire io_ready1;
  wire io_ready2;
  wire trigger_rx_s;

  wire last_sdi_bit;
  wire end_of_sdi_latch;

  (* direct_enable = "yes" *) wire cs_gen;

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

  always @(posedge clk) begin
    if (cmd_ready & cmd_valid)
     cmd_d1 <= cmd;
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      active <= 1'b0;
    end else begin
      if (exec_cmd == 1'b1)
        active <= 1'b1;
      else if (sync_ready == 1'b1 && sync_valid == 1'b1)
        active <= 1'b0;
    end
  end

  // Load the interface configurations from the 'Configuration Write'
  // instruction
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      cpha <= DEFAULT_SPI_CFG[0];
      cpol <= DEFAULT_SPI_CFG[1];
      three_wire <= DEFAULT_SPI_CFG[2];
      clk_div <= DEFAULT_CLK_DIV;
      word_length <= DATA_WIDTH;
      left_aligned <= 8'b0;
    end else if (exec_write_cmd == 1'b1) begin
      if (cmd[9:8] == REG_CONFIG) begin
        cpha <= cmd[0];
        cpol <= cmd[1];
        three_wire <= cmd[2];
      end else if (cmd[9:8] == REG_CLK_DIV) begin
        clk_div <= cmd[7:0];
      end else if (cmd[9:8] == REG_WORD_LENGTH) begin
        // the max value of this reg must be DATA_WIDTH
        word_length <= cmd[7:0];
        left_aligned <= DATA_WIDTH - cmd[7:0];
      end
    end
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

  assign sleep_counter_compare = sleep_counter == cmd_d1[7:0];
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
    if (idle == 1'b1 || (cs_sleep_counter_compare && !cs_sleep_repeat && inst_d1 == CMD_CHIPSELECT)) begin
      counter <= 'h00;
    end else if (clk_div_last == 1'b1 && wait_for_io == 1'b0) begin
      if (bit_counter == word_length) begin
        counter <= (counter & BIT_COUNTER_CLEAR) + (transfer_active ? 'h1 : (2**BIT_COUNTER_WIDTH)) + BIT_COUNTER_CARRY;
      end else begin
        counter <= counter + (transfer_active ? 'h1 : (2**BIT_COUNTER_WIDTH));
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
          if (transfer_active == 1'b0 && wait_for_io == 1'b0 && end_of_sdi_latch == 1'b1)
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

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      cs <= 'hff;
    end else if (cs_gen) begin
      cs <= cmd_d1[NUM_OF_CS-1:0];
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

  always @(posedge clk) begin
    if (resetn == 1'b0)
      sdo_data_ready <= 1'b0;
    else if (sdo_enabled == 1'b1 && first_bit == 1'b1 && trigger_tx == 1'b1 && transfer_active == 1'b1)
      sdo_data_ready <= 1'b1;
    else if (sdo_data_valid == 1'b1)
      sdo_data_ready <= 1'b0;
  end

  assign io_ready1 = (sdi_data_valid == 1'b0 || sdi_data_ready == 1'b1) &&
          (sdo_enabled == 1'b0 || last_transfer == 1'b1 || sdo_data_valid == 1'b1);
  assign io_ready2 = (sdi_enabled == 1'b0 || sdi_data_ready == 1'b1) &&
          (sdo_enabled == 1'b0 || last_transfer == 1'b1 || sdo_data_valid == 1'b1);

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
    if (resetn == 1'b0) begin
      transfer_active <= 1'b0;
      wait_for_io <= 1'b0;
    end else begin
      if (exec_transfer_cmd == 1'b1) begin
        wait_for_io <= 1'b1;
        transfer_active <= 1'b0;
      end else if (wait_for_io == 1'b1 && io_ready1 == 1'b1) begin
        wait_for_io <= 1'b0;
        if (last_transfer == 1'b0)
          transfer_active <= 1'b1;
        else
          transfer_active <= 1'b0;
      end else if (transfer_active == 1'b1 && end_of_word == 1'b1) begin
        if (last_transfer == 1'b1 || io_ready2 == 1'b0)
          transfer_active <= 1'b0;
        if (io_ready2 == 1'b0)
          wait_for_io <= 1'b1;
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

  // Load the SDO parallel data into the SDO shift register. In case of a custom
  // data width, additional bit shifting must done at load.
  always @(posedge clk) begin
    if ((inst_d1 == CMD_TRANSFER) && (!sdo_enabled)) begin
      data_sdo_shift <= {DATA_WIDTH{SDO_DEFAULT}};
    end else if (transfer_active == 1'b1 && trigger_tx == 1'b1) begin
      if (first_bit == 1'b1)
        data_sdo_shift <= sdo_data << left_aligned;
      else
        data_sdo_shift <= {data_sdo_shift[(DATA_WIDTH-2):0], 1'b0};
    end
  end

  assign sdo_int_s = data_sdo_shift[DATA_WIDTH-1];

  // In case of an interface with high clock rate (SCLK > 50MHz), the latch of
  // the SDI line can be delayed with 1, 2 or 3 SPI core clock cycle.
  // Taking the fact that in high SCLK frequencies the pre-scaler most likely will
  // be set to 0, to reduce the core clock's speed, this delay will mean that SDI will
  // be latched at one of the next consecutive SCLK edge.

  always @(posedge clk) begin
    trigger_rx_d <= {trigger_rx_d, trigger_rx};
  end

  assign trigger_rx_s = trigger_rx_d[SDI_DELAY+1];

  // Load the serial data into SDI shift register(s), then link it to the output
  // register of the module
  // NOTE: ECHO_SCLK mode can be used when the SCLK line is looped back to the FPGA
  // through an other level shifter, in order to remove the round-trip timing delays
  // introduced by the level shifters. This can improve the timing significantly
  // on higher SCLK rates. Devices like ad4630 have an echod SCLK, which can be
  // used to latch the MISO lines, improving the overall timing margin of the
  // interface.

  always @(posedge clk) begin
    if (!resetn) begin // set cs_active during reset for a cycle to clear shift reg
      cs_active <= 1;
    end else begin
      cs_active <= ~(&cmd_d1[NUM_OF_CS-1:0]) & cs_gen;
    end
  end

  genvar i;

  // NOTE: SPI configuration (CPOL/PHA) is only hardware configurable at this point
  generate
  if (ECHO_SCLK == 1) begin : g_echo_sclk_miso_latch

    reg [7:0] sdi_counter_d = 8'b0;
    reg [7:0] sdi_transfer_counter = 8'b0;
    reg [7:0] num_of_transfers = 8'b0;
    reg [(NUM_OF_SDI * DATA_WIDTH)-1:0] sdi_data_latch = {(NUM_OF_SDI * DATA_WIDTH){1'b0}};

    if ((DEFAULT_SPI_CFG[1:0] == 2'b01) || (DEFAULT_SPI_CFG[1:0] == 2'b10)) begin : g_echo_miso_nshift_reg

      // MISO shift register runs on negative echo_sclk
      for (i=0; i<NUM_OF_SDI; i=i+1) begin: g_sdi_shift_reg
        reg [DATA_WIDTH-1:0] data_sdi_shift;

        always @(negedge echo_sclk or posedge cs_active) begin
          if (cs_active) begin
            data_sdi_shift <= 0;
          end else begin
            data_sdi_shift <= {data_sdi_shift, sdi[i]};
          end
        end

        // intended LATCH
        always @(negedge echo_sclk) begin
          if (last_sdi_bit)
            sdi_data_latch[i*DATA_WIDTH+:DATA_WIDTH] <= {data_sdi_shift, sdi[i]};
        end

      end

      always @(posedge echo_sclk or posedge cs_active) begin
        if (cs_active) begin
          sdi_counter <= 8'b0;
          sdi_counter_d <= 8'b0;
        end else begin
          sdi_counter <= (sdi_counter == word_length-1) ? 8'b0 : sdi_counter + 1'b1;
          sdi_counter_d <= sdi_counter;
        end
      end

    end else begin : g_echo_miso_pshift_reg

      // MISO shift register runs on positive echo_sclk
      for (i=0; i<NUM_OF_SDI; i=i+1) begin: g_sdi_shift_reg
        reg [DATA_WIDTH-1:0] data_sdi_shift;
        always @(posedge echo_sclk or posedge cs_active) begin
          if (cs_active) begin
            data_sdi_shift <= 0;
          end else begin
            data_sdi_shift <= {data_sdi_shift, sdi[i]};
          end
        end
        // intended LATCH
        always @(posedge echo_sclk) begin
          if (last_sdi_bit)
            sdi_data_latch[i*DATA_WIDTH+:DATA_WIDTH] <= data_sdi_shift;
        end
      end

      always @(posedge echo_sclk or posedge cs_active) begin
        if (cs_active) begin
          sdi_counter <= 8'b0;
          sdi_counter_d <= 8'b0;
        end else begin
          sdi_counter <= (sdi_counter == word_length-1) ? 8'b0 : sdi_counter + 1'b1;
          sdi_counter_d <= sdi_counter;
        end
      end

    end

    assign sdi_data = sdi_data_latch;
    assign last_sdi_bit = (sdi_counter == 0) && (sdi_counter_d == word_length-1);

    // sdi_data_valid is synchronous to SPI clock, so synchronize the
    // last_sdi_bit to SPI clock

    reg [3:0] last_sdi_bit_m = 4'b0;
    always @(posedge clk) begin
      if (cs_active) begin
        last_sdi_bit_m <= 4'b0;
      end else begin
        last_sdi_bit_m <= {last_sdi_bit_m, last_sdi_bit};
      end
    end

    always @(posedge clk) begin
      if (cs_active) begin
        sdi_data_valid <= 1'b0;
      end else if (sdi_enabled == 1'b1 &&
                   last_sdi_bit_m[3] == 1'b0 &&
                   last_sdi_bit_m[2] == 1'b1) begin
        sdi_data_valid <= 1'b1;
      end else if (sdi_data_ready == 1'b1) begin
        sdi_data_valid <= 1'b0;
      end
    end

    always @(posedge clk) begin
      if (cs_active) begin
        num_of_transfers <= 8'b0;
      end else begin
        if (cmd_d1[15:12] == 4'b0) begin
          num_of_transfers <= cmd_d1[7:0] + 1'b1; // cmd_d1 contains the NUM_OF_TRANSFERS - 1
        end
      end
    end

    always @(posedge clk) begin
      if (cs_active) begin
        sdi_transfer_counter <= 0;
      end else if (last_sdi_bit_m[2] == 1'b0 &&
                   last_sdi_bit_m[1] == 1'b1) begin
        sdi_transfer_counter <= sdi_transfer_counter + 1'b1;
      end
    end

    assign end_of_sdi_latch = last_sdi_bit_m[2] & (sdi_transfer_counter == num_of_transfers);

  end /* g_echo_sclk_miso_latch */
  else
  begin : g_sclk_miso_latch

    assign end_of_sdi_latch = 1'b1;

    for (i=0; i<NUM_OF_SDI; i=i+1) begin: g_sdi_shift_reg

      reg [DATA_WIDTH-1:0] data_sdi_shift;

      always @(posedge clk) begin
        if (cs_active) begin
          data_sdi_shift <= 0;
        end else begin
          if (trigger_rx_s == 1'b1) begin
            data_sdi_shift <= {data_sdi_shift, sdi[i]};
          end
        end
      end

      assign sdi_data[i*DATA_WIDTH+:DATA_WIDTH] = data_sdi_shift;

    end

    assign last_sdi_bit = (sdi_counter == word_length-1);
    always @(posedge clk) begin
      if (resetn == 1'b0) begin
        sdi_counter <= 8'b0;
      end else begin
        if (trigger_rx_s == 1'b1) begin
          sdi_counter <= last_sdi_bit ? 8'b0 : sdi_counter + 1'b1;
        end
      end
    end

    always @(posedge clk) begin
      if (resetn == 1'b0)
        sdi_data_valid <= 1'b0;
      else if (sdi_enabled == 1'b1 && last_sdi_bit == 1'b1 && trigger_rx_s == 1'b1)
        sdi_data_valid <= 1'b1;
      else if (sdi_data_ready == 1'b1)
        sdi_data_valid <= 1'b0;
    end

  end /* g_sclk_miso_latch */
  endgenerate

  // end_of_word will signal the end of a transaction, pushing the command
  // stream execution to the next command. end_of_word in normal mode can be
  // generated using the global bit_counter
  assign last_bit = bit_counter == word_length - 1;
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
