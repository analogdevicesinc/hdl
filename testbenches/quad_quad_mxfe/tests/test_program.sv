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

`define DAC_TPL 32'h44A5_0000
`define ADC_TPL 32'h44A4_0000
`define AXI_JESD_RX 32'h44A0_0000
`define AXI_JESD_TX 32'h44A2_0000
`define ADC_XCVR 32'h44A1_0000
`define DAC_XCVR 32'h44A3_0000

program test_program;

  environment env;

  initial begin
    //creating environment
    env = new(`TH.`MNG_AXI.inst.IF);

    #2ps;

    setLoggerVerbosity(6);
    env.start();


    // Configure Transport Layer for DMA data CH0-CH31
    for (int i = 0; i < 32; i++) begin
      env.mng.RegWrite32(`DAC_TPL+((30'h0106<<2)+(i*'h40)), 32'h00000002);
    end

    // Pull out TPL cores from reset
    env.mng.RegWrite32(`DAC_TPL+32'h0040, 32'h00000003);
    env.mng.RegWrite32(`ADC_TPL+32'h0040, 32'h00000003);


    //
    // Configure Link Layer
    //

    //LINK DISABLE
    env.mng.RegWrite32(`AXI_JESD_RX+32'h00c0, 32'h00000001);
    env.mng.RegWrite32(`AXI_JESD_TX+32'h00c0, 32'h00000001);

    //SYSREFCONF
    env.mng.RegWrite32(`AXI_JESD_RX+32'h0100, 32'h00000000); // Enable SYSREF handling
    env.mng.RegWrite32(`AXI_JESD_TX+32'h0100, 32'h00000000); // Enable SYSREF handling

    //CONF0
    env.mng.RegWrite32(`AXI_JESD_RX+32'h0210, 32'h0003007f); // F = 4 ; K=32
    env.mng.RegWrite32(`AXI_JESD_TX+32'h0210, 32'h0003007f); // F = 4 ; K=32
    //CONF1
    env.mng.RegWrite32(`AXI_JESD_RX+32'h0214, 32'h00000000);  // Scrambler enable
    env.mng.RegWrite32(`AXI_JESD_TX+32'h0214, 32'h00000000);  // Scrambler enable

    //ILAS  TODO
    env.mng.RegWrite32(`AXI_JESD_RX+32'h0314,32'h1f010000);
    env.mng.RegWrite32(`AXI_JESD_TX+32'h0314,32'h1f010000);
    env.mng.RegWrite32(`AXI_JESD_RX+32'h0318,32'h2f2f0f00);
    env.mng.RegWrite32(`AXI_JESD_TX+32'h0318,32'h2f2f0f00);

    //LINK ENABLE
    env.mng.RegWrite32(`AXI_JESD_RX+32'h00c0, 32'h00000000);
    env.mng.RegWrite32(`AXI_JESD_TX+32'h00c0, 32'h00000000);


    //PHY INIT
    //REG CTRL
    env.mng.RegWrite32(`ADC_XCVR+32'h0020,32'h00001004);   // RXOUTCLK uses DIV2
    env.mng.RegWrite32(`DAC_XCVR+32'h0020,32'h00001004);

    env.mng.RegWrite32(`ADC_XCVR+32'h0010,32'h00000001);
    env.mng.RegWrite32(`DAC_XCVR+32'h0010,32'h00000001);

    #5us;

    //Read status back
    // Check SYSREF_STATUS
    env.mng.RegReadVerify32(`AXI_JESD_RX+32'h108,1);
    env.mng.RegReadVerify32(`AXI_JESD_TX+32'h108,1);

    // Check if in DATA state and SYNC is 1
    env.mng.RegReadVerify32(`AXI_JESD_RX+32'h280,'h3);
    env.mng.RegReadVerify32(`AXI_JESD_TX+32'h280,'hF3);

    //LINK DISABLE
    env.mng.RegWrite32(`AXI_JESD_RX+32'h00c0, 32'h00000001);
    env.mng.RegWrite32(`AXI_JESD_TX+32'h00c0, 32'h00000001);


    #1us;

  end

endprogram
