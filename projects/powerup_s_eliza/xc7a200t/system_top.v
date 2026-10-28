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

module system_top (

  // Input reference clock
  input  clk_122_p,
  input  clk_122_n,

  // Other GPIO
  input  FPGA_TRIG,

  // Aurora
  input        aurora_refclk_p,
  input        aurora_refclk_n,
  output [1:0] aurora_txp,
  output [1:0] aurora_txn,
  input  [1:0] aurora_rxp,
  input  [1:0] aurora_rxn
);

  system_wrapper i_system_wrapper (
    .clk_in_clk_p (clk_122_p),
    .clk_in_clk_n (clk_122_n),
    .clk_out (),
    .ext_rst (FPGA_TRIG),
    .gt_diff_refclk_clk_p(aurora_refclk_p),
    .gt_diff_refclk_clk_n(aurora_refclk_n),
    .gt_serial_tx_txp(aurora_txp),
    .gt_serial_tx_txn(aurora_txn),
    .gt_serial_rx_rxp(aurora_rxp),
    .gt_serial_rx_rxn(aurora_rxn));

endmodule
