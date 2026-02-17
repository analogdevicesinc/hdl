// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

// Generates a per-lane sine LUT stream that mimics SDO outputs.
// Intended to be instantiated next to the SPI engine; the system supplies CS and SCLK.
module spi_sdo_sin_tb #(
  parameter WORD_LENGTH = 18,
  parameter SAMPLE_COUNT = 1024,
  parameter TRI_STATE_BETWEEN_FRAMES = 1,
  parameter SIGNED = 1,
  // 0..3 (Mode 0 default)
  parameter SPI_MODE = 0,
  parameter SDO_LANES = 1
) (
  input  logic                    rstn,
  input  logic                    cs_n,
  input  logic                    sclk,
  output wire                     sdo0,
  output wire [SDO_LANES-1:0]     sdo
);

  localparam longint unsigned FULL_SCALE = (64'd1 << WORD_LENGTH) - 1;
  localparam longint signed   SIGNED_MAX = (WORD_LENGTH > 0) ? ((64'sd1 << (WORD_LENGTH - 1)) - 1) : 0;
  localparam longint signed   SIGNED_MIN = (WORD_LENGTH > 0) ? -(64'sd1 << (WORD_LENGTH - 1)) : 0;
  localparam bit SIGNED_MODE = (SIGNED != 1'b0);
  localparam bit CPHA = (SPI_MODE & 1) ? 1'b1 : 1'b0;
  localparam bit CPOL = (SPI_MODE[1]) ? 1'b1 : 1'b0;
  localparam bit SHIFT_ON_POSEDGE = (SPI_MODE == 1) || (SPI_MODE == 2);
  localparam bit SHIFT_ON_NEGEDGE = !SHIFT_ON_POSEDGE;
  localparam real TWO_PI = 6.2831853071795864769;

  logic [WORD_LENGTH-1:0] shadow_word;
  logic [WORD_LENGTH-1:0] active_word;
  logic [SDO_LANES-1:0]   sdo_drive;
  int                     sample_index;
  int                     bit_ptr;

  assign sdo = (TRI_STATE_BETWEEN_FRAMES && cs_n) ? {SDO_LANES{1'bz}} : sdo_drive;
  assign sdo0 = sdo_drive[0];

  function automatic [WORD_LENGTH-1:0] compute_sample (input int idx);
    real angle;
    real normalized;
    longint signed signed_scaled;
    longint signed signed_clamped;
    longint unsigned scaled;
    longint unsigned unsigned_clamped;
    begin
      idx = idx % SAMPLE_COUNT;
      angle = TWO_PI * real'(idx) / real'(SAMPLE_COUNT);
      if (SIGNED_MODE) begin
        normalized = $sin(angle);
        signed_scaled = longint'(normalized * real'(SIGNED_MAX));
        if (signed_scaled > SIGNED_MAX) begin
          signed_clamped = SIGNED_MAX;
        end else if (signed_scaled < SIGNED_MIN) begin
          signed_clamped = SIGNED_MIN;
        end else begin
          signed_clamped = signed_scaled;
        end
        compute_sample = signed_clamped[WORD_LENGTH-1:0];
      end else begin
        normalized = ($sin(angle) + 1.0) * 0.5;
        scaled = longint'(normalized * FULL_SCALE + 0.5);
        if (scaled > FULL_SCALE) begin
          unsigned_clamped = FULL_SCALE;
        end else begin
          unsigned_clamped = scaled;
        end
        compute_sample = unsigned_clamped[WORD_LENGTH-1:0];
      end
    end
  endfunction

  task automatic stage_sample(input int idx);
    begin
      shadow_word <= compute_sample(idx);
    end
  endtask

  always @(negedge rstn) begin
    if (!rstn) begin
      sample_index <= 0;
      bit_ptr <= WORD_LENGTH - 1;
      sdo_drive <= '0;
      stage_sample(0);
      active_word <= '0;
    end
  end

  always @(posedge cs_n) begin
    if (rstn) begin
      int base_index;
      base_index = (sample_index + 1) % SAMPLE_COUNT;
      sample_index <= base_index;
      stage_sample(base_index);
    end
  end

  always @(negedge cs_n or negedge rstn) begin
    if (!rstn) begin
      active_word <= '0;
      bit_ptr <= WORD_LENGTH - 1;
      sdo_drive <= '0;
    end else begin
      active_word <= shadow_word;
      if (CPHA == 1'b0) begin
        bit_ptr <= (WORD_LENGTH > 1) ? WORD_LENGTH - 2 : 0;
        sdo_drive <= {SDO_LANES{shadow_word[WORD_LENGTH-1]}};
      end else begin
        bit_ptr <= WORD_LENGTH - 1;
      end
    end
  end

  generate
  if (SHIFT_ON_POSEDGE) begin : g_shift_pos
    always @(posedge sclk or posedge cs_n or negedge rstn) begin
      if (!rstn) begin
        bit_ptr <= WORD_LENGTH - 1;
        sdo_drive <= '0;
      end else if (cs_n) begin
        bit_ptr <= (CPHA == 1'b0) ? ((WORD_LENGTH > 1) ? WORD_LENGTH - 2 : 0) : (WORD_LENGTH - 1);
        if (CPHA == 1'b0) begin
          sdo_drive <= {SDO_LANES{active_word[WORD_LENGTH-1]}};
        end
      end else begin
        sdo_drive <= {SDO_LANES{active_word[bit_ptr]}};
        if (bit_ptr != 0) begin
          bit_ptr <= bit_ptr - 1;
        end
      end
    end
  end else begin : g_shift_neg
    always @(negedge sclk or posedge cs_n or negedge rstn) begin
      if (!rstn) begin
        bit_ptr <= WORD_LENGTH - 1;
        sdo_drive <= '0;
      end else if (cs_n) begin
        bit_ptr <= (CPHA == 1'b0) ? ((WORD_LENGTH > 1) ? WORD_LENGTH - 2 : 0) : (WORD_LENGTH - 1);
        if (CPHA == 1'b0) begin
          sdo_drive <= {SDO_LANES{active_word[WORD_LENGTH-1]}};
        end
      end else begin
        sdo_drive <= {SDO_LANES{active_word[bit_ptr]}};
        if (bit_ptr != 0) begin
          bit_ptr <= bit_ptr - 1;
        end
      end
    end
  end
  endgenerate

endmodule
