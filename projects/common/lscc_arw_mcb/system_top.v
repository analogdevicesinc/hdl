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
  input           clk_100,
  input           clk_125,
  input           rstn_i,

  output          config_active,

  input           rxd_i,
  output          txd_o,

  output  [5:0]   ddr_ca_o,
  output  [0:0]   ddr_ck_o,
  output  [0:0]   ddr_cke_o,
  output  [0:0]   ddr_cs_o,
  inout   [3:0]   ddr_dmi_io,
  inout   [31:0]  ddr_dq_io,
  inout   [3:0]   ddr_dqs_io,
  output          ddr_reset_n_o,
  output          init_done_o
);

  template_lscc_arw_mcb template_lscc_arw_mcb_inst (
    .clk_100        (clk_100),
    .clk_125        (clk_125),
    .rstn_i         (rstn_i),
    .config_active  (config_active),
    .rxd_i          (rxd_i),
    .txd_o          (txd_o),
    .ddr_ca_o       (ddr_ca_o),
    .ddr_ck_o       (ddr_ck_o),
    .ddr_cke_o      (ddr_cke_o),
    .ddr_cs_o       (ddr_cs_o),
    .ddr_dmi_io     (ddr_dmi_io),
    .ddr_dq_io      (ddr_dq_io),
    .ddr_dqs_io     (ddr_dqs_io),
    .ddr_reset_n_o  (ddr_reset_n_o),
    .init_done_o    (init_done_o),
    .irq_o          (),
    .pll_lock_o     (),
    .sclk_o         (),
    .trn_err_o      ());

endmodule
