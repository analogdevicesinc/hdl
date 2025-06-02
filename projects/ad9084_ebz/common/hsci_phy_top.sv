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

`timescale 1ps/1ps

module hsci_phy_top (

  input wire          pll_inclk,
  input wire          hsci_pll_reset,

  output logic        hsci_pclk,
  output logic        hsci_mosi_d_p,
  output logic        hsci_mosi_d_n,

  input wire          hsci_miso_d_p,
  input wire          hsci_miso_d_n,

  output logic        hsci_pll_locked,

  output logic        hsci_mosi_clk_p,
  output logic        hsci_mosi_clk_n,

  input wire          hsci_miso_clk_p,
  input wire          hsci_miso_clk_n,

  input  wire  [7:0]  hsci_menc_clk,
  input  wire  [7:0]  hsci_mosi_data,
  output logic [7:0]  hsci_miso_data,

  // Status Signals
  output logic        vtc_rdy_bsc_tx,
  output logic        dly_rdy_bsc_tx,
  output logic        vtc_rdy_bsc_rx,
  output logic        dly_rdy_bsc_rx,
  output logic        rst_seq_done

);
   //TX
   logic [7:0]       hsci_mosi_data_br;
   logic             rst_seq_done_tx;
   logic             dly_rdy_bsc0;
   logic             vtc_rdy_bsc0;
   logic             dly_rdy_bsc1;
   logic             vtc_rdy_bsc1;

   // RX
   logic [7:0]       hsci_miso_data_br;
   logic [7:0]       hsci_miso_clk_d;
   logic             fifo_empty_rx;
   logic             fifo_empty_rx_strobe;

   // PLL
   logic             shared_pll0_clkoutphy_out;
   logic             pll0_clkout1;

   assign hsci_mosi_data_br = {hsci_mosi_data[0],hsci_mosi_data[1],hsci_mosi_data[2],hsci_mosi_data[3],hsci_mosi_data[4],hsci_mosi_data[5],hsci_mosi_data[6],hsci_mosi_data[7]};

   assign hsci_miso_data = rst_seq_done ? {hsci_miso_data_br[0],hsci_miso_data_br[1],hsci_miso_data_br[2],hsci_miso_data_br[3],hsci_miso_data_br[4],hsci_miso_data_br[5],hsci_miso_data_br[6],hsci_miso_data_br[7]}
                                        : 8'h0;

   assign dly_rdy_bsc_tx = dly_rdy_bsc0 & dly_rdy_bsc1;
   assign vtc_rdy_bsc_tx = vtc_rdy_bsc0 & vtc_rdy_bsc1;

   high_speed_selectio_wiz_0 hssio_wiz_tx_rx (
  .fifo_rd_clk_32                   (hsci_pclk),
  .fifo_rd_clk_34                   (hsci_pclk),
  .fifo_rd_en_32                    (1'b0),
  .fifo_rd_en_34                    (1'b1 & !fifo_empty_rx & rst_seq_done),
  .fifo_empty_32                    (fifo_empty_rx_strobe),
  .fifo_empty_34                    (fifo_empty_rx),
  .dly_rdy_bsc0                     (dly_rdy_bsc0),
  .vtc_rdy_bsc0                     (vtc_rdy_bsc0),
  .en_vtc_bsc0                      (1'b1),
  .dly_rdy_bsc1                     (dly_rdy_bsc1),
  .vtc_rdy_bsc1                     (vtc_rdy_bsc1),
  .en_vtc_bsc1                      (1'b1),
  .dly_rdy_bsc5                     (dly_rdy_bsc_rx),
  .vtc_rdy_bsc5                     (vtc_rdy_bsc_rx),
  .en_vtc_bsc5                      (1'b1),
  .rst_seq_done                     (rst_seq_done),
  .shared_pll0_clkoutphy_out        (shared_pll0_clkoutphy_out),
  .pll0_clkout0                     (hsci_pclk),
  .rst                              (hsci_pll_reset),
  .clk                              (pll_inclk),
  .pll0_locked                      (hsci_pll_locked),
  .clk_out_p                        (hsci_mosi_clk_p),
  .data_from_fabric_clk_out_p       (hsci_menc_clk),
  .clk_out_n                        (hsci_mosi_clk_n),
  .data_out_p                       (hsci_mosi_d_p),
  .data_from_fabric_data_out_p      (hsci_mosi_data_br),
  .data_out_n                       (hsci_mosi_d_n),
  .clk_in_p                         (hsci_miso_clk_p),
  .data_to_fabric_clk_in_p          (hsci_miso_clk_d),
  .clk_in_n                         (hsci_miso_clk_n),
  .data_in_p                        (hsci_miso_d_p),
  .data_to_fabric_data_in_p         (hsci_miso_data_br),
  .data_in_n                        (hsci_miso_d_n));

endmodule
