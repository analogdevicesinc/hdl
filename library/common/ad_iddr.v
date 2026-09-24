// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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

module ad_iddr #(
  parameter FPGA_TECHNOLOGY = 0
) (

  input   clk,
  input   data_in,
  output  data_p,
  output  data_n
);

  localparam SEVEN_SERIES    = 1;
  localparam ULTRASCALE      = 2;
  localparam ULTRASCALE_PLUS = 3;
  localparam CYCLONE_V       = 101;
  localparam NEXUS           = 201;

  generate
  if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin : g_7series

    IDDR #(
      .DDR_CLK_EDGE ("OPPOSITE_EDGE")
    ) i_iddr (
      .CE (1'b1),
      .R  (1'b0),
      .S  (1'b0),
      .C  (clk),
      .D  (data_in),
      .Q1 (data_p),
      .Q2 (data_n));

  end else if ((FPGA_TECHNOLOGY == ULTRASCALE) ||
               (FPGA_TECHNOLOGY == ULTRASCALE_PLUS)) begin : g_ultrascale

    IDDRE1 #(
      .DDR_CLK_EDGE ("OPPOSITE_EDGE")
    ) i_iddr (
      .R  (1'b0),
      .C  (clk),
      .CB (~clk),
      .D  (data_in),
      .Q1 (data_p),
      .Q2 (data_n));

  end else if (FPGA_TECHNOLOGY == CYCLONE_V) begin : g_cyclone_v

    // ALTDDIO_IN is the legacy DDR input megafunction for older Intel
    // device families (Cyclone IV/V, Arria II/V, Stratix IV/V).
    // For newer Intel families (Arria 10+), the GPIO Intel FPGA IP
    // (altera_gpio) is used instead — instantiated via _hw.tcl, not here.

    altddio_in #(
      .width              (1),
      .intended_device_family ("Cyclone V"),
      .power_up_high      ("OFF")
    ) i_iddr (
      .datain     (data_in),
      .inclock    (clk),
      .dataout_h  (data_p),
      .dataout_l  (data_n),
      .aclr       (1'b0),
      .inclocken  (1'b1),
      .aset       (1'b0),
      .sclr       (1'b0),
      .sset       (1'b0));

  end else if (FPGA_TECHNOLOGY == NEXUS) begin : g_nexus

    // Lattice Nexus platform (Certus Pro NX, Certus NX, CrossLink-NX).
    // IDDRX1F provides DDR-to-SDR conversion with both outputs aligned
    // to the rising edge of SCLK.

    IDDRX1F i_iddr (
      .SCLK (clk),
      .D    (data_in),
      .RST  (1'b0),
      .Q0   (data_p),
      .Q1   (data_n));

  end else begin : g_behavioral

    // Behavioral fallback for simulation (FPGA_TECHNOLOGY == 0) and for
    // Intel Arria 10+ families (102-105) where the actual DDIO is handled
    // by the altera_gpio IP instantiated in spi_engine_execution_hw.tcl.
    // OPPOSITE_EDGE: Q1 on posedge, Q2 on negedge — no pipeline latency.

    reg data_p_r;
    reg data_n_r;

    always @(posedge clk) begin
      data_p_r <= data_in;
    end

    always @(negedge clk) begin
      data_n_r <= data_in;
    end

    assign data_p = data_p_r;
    assign data_n = data_n_r;

  end
  endgenerate

endmodule
