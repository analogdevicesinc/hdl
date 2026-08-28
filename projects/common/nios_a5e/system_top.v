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

  // clock and resets
  input            sys_clk,
  input            sys_resetn,

  // board gpio
  output  [3:0]    fpga_led,
  input   [3:0]    fpga_dipsw,
  input   [3:0]    fpga_btn,

  // emif
  input            emif_ref_clk,
  output           emif_mem_ck_t,
  output           emif_mem_ck_c,
  output [ 16:0]   emif_mem_a,
  output           emif_mem_act_n,
  output [  1:0]   emif_mem_ba,
  output [  1:0]   emif_mem_bg,
  output           emif_mem_cke,
  output           emif_mem_cs_n,
  output           emif_mem_odt,
  output           emif_mem_reset_n,
  output           emif_mem_par,
  input            emif_mem_alert_n,
  input            emif_oct_rzqin,
  inout  [  4:0]   emif_mem_dqs_t,
  inout  [  4:0]   emif_mem_dqs_c,
  inout  [ 39:0]   emif_mem_dq,
  inout  [  4:0]   emif_mem_dbi_n
);

  wire  [63:0]  gpio_i;
  wire  [63:0]  gpio_o;
  wire          ninit_done;
  wire          sys_reset_n;
  wire          pma_cu_clk;

  assign fpga_led      = gpio_o[3:0];
  assign gpio_i[ 3: 0] = gpio_o[3:0];
  assign gpio_i[ 7: 4] = fpga_dipsw;
  assign gpio_i[11: 8] = fpga_btn;

  assign gpio_i[31:12] = gpio_o[31:12];
  assign gpio_i[63:32] = gpio_o[63:32];

  assign sys_reset_n   = sys_resetn & ~ninit_done;

  system_bd i_system_bd (
    .sys_clk_clk                                             (sys_clk),

    .sys_rst_reset_n                                         (sys_reset_n),
    .rst_ninit_done                                          (ninit_done),

    .pr_rom_data_nc_rom_data                                 ('h0),
    .o_pma_cu_clk_clk                                        (pma_cu_clk),

    .emif_mem_0_mem_cke                                      (emif_mem_cke),
    .emif_mem_0_mem_odt                                      (emif_mem_odt),
    .emif_mem_0_mem_cs_n                                     (emif_mem_cs_n),
    .emif_mem_0_mem_a                                        (emif_mem_a),
    .emif_mem_0_mem_ba                                       (emif_mem_ba),
    .emif_mem_0_mem_bg                                       (emif_mem_bg),
    .emif_mem_0_mem_act_n                                    (emif_mem_act_n),
    .emif_mem_0_mem_par                                      (emif_mem_par),
    .emif_mem_0_mem_dq                                       (emif_mem_dq),
    .emif_mem_0_mem_dqs_t                                    (emif_mem_dqs_t),
    .emif_mem_0_mem_dqs_c                                    (emif_mem_dqs_c),
    .emif_mem_0_mem_alert_n                                  (emif_mem_alert_n),
    .emif_mem_ck_0_mem_ck_t                                  (emif_mem_ck_t),
    .emif_mem_ck_0_mem_ck_c                                  (emif_mem_ck_c),
    .emif_mem_reset_n_mem_reset_n                            (emif_mem_reset_n),
    .emif_oct_0_oct_rzqin                                    (emif_oct_rzqin),
    .emif_ref_clk_0_clk                                      (emif_ref_clk),
    .emif_mem_0_mem_dbi_n                                    (emif_mem_dbi_n),

    .sys_gpio_bd_in_port                                     (gpio_i[31:0]),
    .sys_gpio_bd_out_port                                    (gpio_o[31:0]),
    .sys_gpio_in_export                                      (gpio_i[63:32]),
    .sys_gpio_out_export                                     (gpio_o[63:32]));

endmodule
