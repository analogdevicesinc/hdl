// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module spi_engine_execution_shiftreg #(

  parameter DEFAULT_SPI_CFG = 0,
  parameter DATA_WIDTH = 8,
  parameter NUM_OF_SDI = 1,
  parameter [1:0] SDI_DELAY = 2'b00,
  parameter ECHO_SCLK = 0,
  parameter [2:0]CMD_TRANSFER = 3'b000
) (
  input   clk,
  input   resetn,

  // spi io
  input   [NUM_OF_SDI-1:0]  sdi,
  output                    sdo_int,
  input                     echo_sclk,

  // spi data
  input   [(DATA_WIDTH-1):0]  sdo_data,
  input                       sdo_data_valid,
  output                      sdo_data_ready,

  output  [(NUM_OF_SDI * DATA_WIDTH-1):0] sdi_data,
  output reg                              sdi_data_valid,
  input                                   sdi_data_ready,

  // cfg and status
  input           sdo_enabled,
  input           sdi_enabled,
  input   [15:0]  current_cmd,
  input           sdo_idle_state,
  input   [ 7:0]  left_aligned,
  input   [ 7:0]  word_length,

  // timing from main fsm
  output      sdo_io_ready,
  output      echo_last_bit,
  input       transfer_active,
  input       trigger_tx,
  input       trigger_rx,
  input       first_bit,
  input       cs_activate
);

  reg [             7:0] sdi_counter    = 8'b0;
  reg [(DATA_WIDTH-1):0] data_sdo_shift = 'h0;
  reg [   SDI_DELAY+1:0] trigger_rx_d   = {(SDI_DELAY+2){1'b0}};
  reg [(DATA_WIDTH-1):0] aligned_sdo_data, sdo_data_reg;
  reg data_sdo_v;
  wire sdo_toshiftreg;
  wire last_sdi_bit;
  wire trigger_rx_s;
  wire [2:0] current_instr = current_cmd[14:12];

  // sdo data handshake
  assign sdo_data_ready = (!data_sdo_v) || sdo_toshiftreg;
  assign sdo_io_ready = data_sdo_v;
  always @(posedge clk ) begin
    if (resetn == 1'b0) begin
      data_sdo_v <= 1'b0;
    end else begin
      if (sdo_data_ready && sdo_data_valid) begin
        data_sdo_v <= 1'b1;
        sdo_data_reg <= sdo_data;
      end else if (sdo_toshiftreg) begin
        data_sdo_v <= 1'b0;
      end
    end
  end

  // pipelined shifter for sdo_data
  always @(posedge clk ) begin
    if (resetn == 1'b0) begin
      aligned_sdo_data <= 0;
    end else begin
      aligned_sdo_data <= sdo_data_reg << left_aligned;
    end
  end

  // Load the SDO parallel data into the SDO shift register. In case of a custom
  // data width, additional bit shifting must done at load.
  always @(posedge clk) begin
    if (!sdo_enabled || (current_instr != CMD_TRANSFER)) begin
      data_sdo_shift <= {DATA_WIDTH{sdo_idle_state}};
    end else if (transfer_active == 1'b1 && trigger_tx == 1'b1) begin
      if (first_bit == 1'b1) begin
        data_sdo_shift <= aligned_sdo_data;
      end else begin
        data_sdo_shift <= {data_sdo_shift[(DATA_WIDTH-2):0], 1'b0};
      end
    end
  end
  assign sdo_int = data_sdo_shift[DATA_WIDTH-1];
  assign sdo_toshiftreg = (transfer_active && trigger_tx && first_bit && sdo_enabled);

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

  genvar i;
  // NOTE: SPI configuration (CPOL/PHA) is only hardware configurable at this point, unless ECHO_SCLK=0
  generate
  if (ECHO_SCLK == 1) begin : g_echo_sclk_miso_latch

    reg last_sdi_bit_r;
    reg latch_sdi;
    reg [(NUM_OF_SDI * DATA_WIDTH)-1:0] sdi_data_latch = {(NUM_OF_SDI * DATA_WIDTH){1'b0}};

    if ((DEFAULT_SPI_CFG[1:0] == 2'b01) || (DEFAULT_SPI_CFG[1:0] == 2'b10)) begin : g_echo_miso_nshift_reg

      // MISO shift register runs on negative echo_sclk
      for (i=0; i<NUM_OF_SDI; i=i+1) begin: g_sdi_shift_reg
        reg [DATA_WIDTH-1:0] data_sdi_shift;

        always @(negedge echo_sclk or posedge cs_activate) begin
          if (cs_activate) begin
            data_sdi_shift <= 0;
          end else begin
            data_sdi_shift <= {data_sdi_shift, sdi[i]};
          end
        end

        // intended LATCH
        always @(negedge echo_sclk) begin
          if (latch_sdi)
            sdi_data_latch[i*DATA_WIDTH+:DATA_WIDTH] <= {data_sdi_shift, sdi[i]};
        end
      end

      always @(negedge echo_sclk or posedge cs_activate) begin
        if (cs_activate) begin
          sdi_counter     <= 8'b0;
          last_sdi_bit_r  <= 1'b0;
          latch_sdi       <= 1'b0;
        end else begin
          // these paths would be unsafe it there wasn't a guarantee of some settling time between word_length changing and a transfer starting
          latch_sdi       <= (sdi_counter == word_length - 2);
          last_sdi_bit_r  <= (sdi_counter == word_length - 1);
          sdi_counter     <= (sdi_counter == word_length - 1) ? 8'b0 : sdi_counter + 1'b1;
        end
      end

    end else begin : g_echo_miso_pshift_reg

      // MISO shift register runs on positive echo_sclk
      for (i=0; i<NUM_OF_SDI; i=i+1) begin: g_sdi_shift_reg
        reg [DATA_WIDTH-1:0] data_sdi_shift;
        always @(posedge echo_sclk or posedge cs_activate) begin
          if (cs_activate) begin
            data_sdi_shift <= 0;
          end else begin
            data_sdi_shift <= {data_sdi_shift, sdi[i]};
          end
        end
        // intended LATCH
        always @(posedge echo_sclk) begin
          if (latch_sdi)
            sdi_data_latch[i*DATA_WIDTH+:DATA_WIDTH] <= {data_sdi_shift, sdi[i]};
        end
      end

      always @(posedge echo_sclk or posedge cs_activate) begin
        if (cs_activate) begin
          sdi_counter     <= 8'b0;
          last_sdi_bit_r  <= 1'b0;
          latch_sdi       <= 1'b0;
        end else begin
          // these paths would be unsafe it there wasn't a guarantee of some settling time between word_length changing and a transfer starting
          latch_sdi       <= (sdi_counter == word_length - 2);
          last_sdi_bit_r  <= (sdi_counter == word_length - 1);
          sdi_counter     <= (sdi_counter == word_length - 1) ? 8'b0 : sdi_counter + 1'b1;
        end
      end

    end

    assign sdi_data = sdi_data_latch;
    assign last_sdi_bit = last_sdi_bit_r;
    assign echo_last_bit =  !last_sdi_bit_m[3] && last_sdi_bit_m[2];

    // sdi_data_valid is synchronous to SPI clock, so synchronize the
    // last_sdi_bit to SPI clock

    reg [3:0] last_sdi_bit_m = 4'b0;
    always @(posedge clk) begin
      if (cs_activate) begin
        last_sdi_bit_m <= 4'b0;
      end else begin
        last_sdi_bit_m <= {last_sdi_bit_m, last_sdi_bit};
      end
    end

    always @(posedge clk) begin
      if (cs_activate) begin
        sdi_data_valid <= 1'b0;
      end else if (sdi_enabled == 1'b1 && echo_last_bit) begin
        sdi_data_valid <= 1'b1;
      end else if (sdi_data_ready == 1'b1) begin
        sdi_data_valid <= 1'b0;
      end
    end

  end /* g_echo_sclk_miso_latch */
  else
  begin : g_sclk_miso_latch

    for (i=0; i<NUM_OF_SDI; i=i+1) begin: g_sdi_shift_reg

      reg [DATA_WIDTH-1:0] data_sdi_shift;

      always @(posedge clk) begin
        if (cs_activate) begin
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

endmodule
