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

`timescale 1ns/100ps

// Both instances use the AD9084 24-lane 64B66B widths: 1536 bits of pack/unpack
// bus against a 2048-bit DMA bus, a 3:4 ratio neither util_axis_resize nor
// util_axis_fifo_asym can express.

module gearbox_tb;
  parameter VCD_FILE = {"gearbox_tb.vcd"};

  `define TIMEOUT 200000
  `include "../../common/tb/tb_base.v"

  localparam UNIT = 512;
  localparam NARROW = 1536;
  localparam WIDE = 2048;

  wire resetn = ~reset;

  function [UNIT-1:0] unit_val;
    input integer idx;
    begin
      unit_val = {{(UNIT-64){1'b0}}, idx[31:0], ~idx[31:0]};
    end
  endfunction

  integer i;

  // narrow -> wide, master always ready: models the ADC path, where util_cpack2
  // cannot be back-pressured, so any slave-side stall would drop samples.
  reg  up_s_valid = 1'b0;
  wire up_s_ready;
  reg  [NARROW-1:0] up_s_data;
  wire up_m_valid;
  wire [WIDE-1:0] up_m_data;

  integer up_in = 0;
  integer up_out = 0;

  util_axis_gearbox #(
    .S_DATA_WIDTH (NARROW),
    .M_DATA_WIDTH (WIDE)
  ) i_up (
    .clk (clk),
    .resetn (resetn),
    .s_axis_valid (up_s_valid),
    .s_axis_ready (up_s_ready),
    .s_axis_data (up_s_data),
    .m_axis_valid (up_m_valid),
    .m_axis_ready (1'b1),
    .m_axis_data (up_m_data));

  task up_load;
    begin
      for (i = 0; i < NARROW/UNIT; i = i + 1)
        up_s_data[i*UNIT +: UNIT] = unit_val(up_in + i);
    end
  endtask

  initial up_load;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      up_s_valid <= 1'b0;
    end else begin
      up_s_valid <= 1'b1;
      if (up_s_valid == 1'b1 && up_s_ready == 1'b0) begin
        $display("ERROR: slave side stalled while the master side was ready");
        failed <= 1'b1;
      end
      if (up_s_valid == 1'b1 && up_s_ready == 1'b1) begin
        up_in = up_in + NARROW/UNIT;
        up_load;
      end
      if (up_m_valid == 1'b1) begin
        for (i = 0; i < WIDE/UNIT; i = i + 1) begin
          if (up_m_data[i*UNIT +: UNIT] !== unit_val(up_out + i)) begin
            $display("ERROR: narrow->wide unit %0d: got %h expected %h", up_out + i,
                     up_m_data[i*UNIT +: UNIT], unit_val(up_out + i));
            failed <= 1'b1;
          end
        end
        up_out = up_out + WIDE/UNIT;
      end
    end
  end

  // wide -> narrow with random stalls on both sides: models the DAC path.
  reg  dn_s_valid = 1'b0;
  wire dn_s_ready;
  reg  [WIDE-1:0] dn_s_data;
  wire dn_m_valid;
  reg  dn_m_ready = 1'b1;
  wire [NARROW-1:0] dn_m_data;

  integer dn_in = 0;
  integer dn_out = 0;

  util_axis_gearbox #(
    .S_DATA_WIDTH (WIDE),
    .M_DATA_WIDTH (NARROW)
  ) i_dn (
    .clk (clk),
    .resetn (resetn),
    .s_axis_valid (dn_s_valid),
    .s_axis_ready (dn_s_ready),
    .s_axis_data (dn_s_data),
    .m_axis_valid (dn_m_valid),
    .m_axis_ready (dn_m_ready),
    .m_axis_data (dn_m_data));

  task dn_load;
    begin
      for (i = 0; i < WIDE/UNIT; i = i + 1)
        dn_s_data[i*UNIT +: UNIT] = unit_val(dn_in + i);
    end
  endtask

  initial dn_load;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      dn_s_valid <= 1'b0;
    end else begin
      dn_s_valid <= ($random % 4) != 0;
      dn_m_ready <= ($random % 3) != 0;
      if (dn_s_valid == 1'b1 && dn_s_ready == 1'b1) begin
        dn_in = dn_in + WIDE/UNIT;
        dn_load;
      end
      if (dn_m_valid == 1'b1 && dn_m_ready == 1'b1) begin
        for (i = 0; i < NARROW/UNIT; i = i + 1) begin
          if (dn_m_data[i*UNIT +: UNIT] !== unit_val(dn_out + i)) begin
            $display("ERROR: wide->narrow unit %0d: got %h expected %h", dn_out + i,
                     dn_m_data[i*UNIT +: UNIT], unit_val(dn_out + i));
            failed <= 1'b1;
          end
        end
        dn_out = dn_out + NARROW/UNIT;
      end
    end
  end

  initial begin
    #(`TIMEOUT - 100);
    $display("INFO: narrow->wide moved %0d units, wide->narrow %0d units", up_out, dn_out);
    if (up_out == 0 || dn_out == 0) begin
      $display("ERROR: no data moved");
      failed <= 1'b1;
    end
  end

endmodule
