// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
//
//
//
`include "utils.svh"
`include "environment.sv"

import axi_vip_pkg::*;
import axi4stream_vip_pkg::*;
import logger_pkg::*;

// Addresses should match values form address editor
`define AXI_JESD_RX_0 32'h44A0_0000
`define ADC_XCVR_0    32'h44A1_0000
`define AXI_JESD_TX_0 32'h44A2_0000
`define DAC_XCVR_0    32'h44A3_0000
`define ADC_TPL_0     32'h44A4_0000
`define DAC_TPL_0     32'h44A5_0000

`define AXI_JESD_RX_1 32'h44A6_0000
`define ADC_XCVR_1    32'h44A7_0000
`define AXI_JESD_TX_1 32'h44A8_0000
`define DAC_XCVR_1    32'h44A9_0000
`define ADC_TPL_1     32'h44AA_0000
`define DAC_TPL_1     32'h44AB_0000

program test_program;

  environment env;

  //
  // Configure Link Layer
  //
  task SetJesdLink(int BaseAddress);

    //LINK DISABLE
    env.mng.RegWrite32(BaseAddress + 32'h00c0, 32'h00000001);

    //SYSREFCONF
    env.mng.RegWrite32(BaseAddress + 32'h0100, 32'h00000000); // Enable SYSREF handling

    //CONF0
    env.mng.RegWrite32(BaseAddress + 32'h0210, 32'h0003007f); // F = 4 ; K=32
    //CONF1
    env.mng.RegWrite32(BaseAddress + 32'h0214, 32'h00000000);  // Scrambler enable

    //ILAS  TODO
    env.mng.RegWrite32(BaseAddress + 32'h0314, 32'h1f010000);
    env.mng.RegWrite32(BaseAddress + 32'h0318, 32'h2f2f0f00);

    //LINK ENABLE
    env.mng.RegWrite32(BaseAddress + 32'h00c0, 32'h00000000);
  endtask

  //
  // Tear down Link Layer
  //
  task UnSetJesdLink(int BaseAddress);
    env.mng.RegWrite32(BaseAddress + 32'h00c0, 32'h00000001);
  endtask

  //
  // Check Rx Link Layer Status
  //
  task CheckRxLink(int BaseAddress);
    //Read status back
    // Check SYSREF_STATUS
    env.mng.RegReadVerify32(BaseAddress + 32'h108,1);

    // Check if in DATA state and SYNC is 1
    env.mng.RegReadVerify32(BaseAddress + 32'h280,'h3);
  endtask

  //
  // Check Tx Link Layer Status
  //
  task CheckTxLink(int BaseAddress);
    //Read status back
    // Check SYSREF_STATUS
    env.mng.RegReadVerify32(BaseAddress + 32'h108,1);

    // Check if in DATA state and SYNC is 1
    env.mng.RegReadVerify32(BaseAddress + 32'h280,'hF3);
  endtask


  initial begin
    //creating environment
    env = new(`TH.`MNG_AXI.inst.IF);

    #2ps;

    setLoggerVerbosity(6);
    env.start();

    // ---------------
    // Set up TX first
    // ---------------
    //PHY INIT
    //REG CTRL
    env.mng.RegWrite32(`DAC_XCVR_0 + 32'h0020,32'h00001004);
    env.mng.RegWrite32(`DAC_XCVR_1 + 32'h0020,32'h00001004);

    env.mng.RegWrite32(`DAC_XCVR_0 + 32'h0010,32'h00000001);
    env.mng.RegWrite32(`DAC_XCVR_1 + 32'h0010,32'h00000001);

    // Configure Transport Layer for DMA data CH0-CH63
    for (int i = 0; i < 32; i++) begin
      env.mng.RegWrite32(`DAC_TPL_0 + ((30'h0106<<2)+(i*'h40)), 32'h00000002);
      env.mng.RegWrite32(`DAC_TPL_1 + ((30'h0106<<2)+(i*'h40)), 32'h00000002);
    end


    // Configure Tx Link Layer
    SetJesdLink(`AXI_JESD_TX_0);
    SetJesdLink(`AXI_JESD_TX_1);


    // Pull out TPL cores from reset
    env.mng.RegWrite32(`DAC_TPL_0 + 32'h0040, 32'h00000003);
    env.mng.RegWrite32(`DAC_TPL_1 + 32'h0040, 32'h00000003);


    // ---------------
    // Set up RX last
    // ---------------

    //PHY INIT
    //REG CTRL
    env.mng.RegWrite32(`ADC_XCVR_0 + 32'h0020,32'h00001004);   // RXOUTCLK uses DIV2
    env.mng.RegWrite32(`ADC_XCVR_1 + 32'h0020,32'h00001004);   // RXOUTCLK uses DIV2

    env.mng.RegWrite32(`ADC_XCVR_0 + 32'h0010,32'h00000001);
    env.mng.RegWrite32(`ADC_XCVR_1 + 32'h0010,32'h00000001);

    // Configure Rx Link Layer
    SetJesdLink(`AXI_JESD_RX_0);
    SetJesdLink(`AXI_JESD_RX_1);

    // Pull out TPL cores from reset
    env.mng.RegWrite32(`ADC_TPL_0 + 32'h0040, 32'h00000003);
    env.mng.RegWrite32(`ADC_TPL_1 + 32'h0040, 32'h00000003);

    // Wait until link is established
    #5us;

    //Read status back
    CheckRxLink(`AXI_JESD_RX_0);
    CheckRxLink(`AXI_JESD_RX_1);

    CheckTxLink(`AXI_JESD_TX_0);
    CheckTxLink(`AXI_JESD_TX_1);

    //LINK DISABLE
    UnSetJesdLink(`AXI_JESD_RX_0);
    UnSetJesdLink(`AXI_JESD_RX_1);
    UnSetJesdLink(`AXI_JESD_TX_0);
    UnSetJesdLink(`AXI_JESD_TX_1);

    `INFO(("Test PASSED !!!"));

  end

endprogram
