// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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
  input   [12:0]  gpio_bd_i, 
  output  [7:0]  gpio_bd_o,
 


  // LVDS data interace

  input           dco_p, // in project constr file
  input           dco_n, // in project constr file
  input           da_p, // in project constr file
  input           da_n, // in project constr file
  input           db_p, // in project constr file
  input           db_n, // in project constr file
  //input           cnv_in_p, // in project constr file
  //input           cnv_in_n, // in project constr file

  input           fpgaclk_p, // in project constr file
  input           fpgaclk_n,

  input           clk_p, // in project constr file
  input           clk_n,

  // GPIOs

  input           doa_fmc, // in project constr file
  input           dob_fmc, // as above
  input           doc_fmc, // as above
  input           dod_fmc, // as above

  output          gp0_dir, // as above
  output          gp1_dir, // as above
  output          gp2_dir, // as above
  output          gp3_dir, // as above
  input           gpio1_fmc, // as above
  output          gpio2_fmc, // as above
  input           gpio3_fmc, // as above

  input           pwrgd, // in project system constr file
  input           adf435x_lock, // as above
  output          en_psu, // as above
  output          pd_v33b, // as above
  output          osc_en, // as above
  output          ad9508_sync, // in project constr file

  // ADC SPI

  input           ad4080_miso, // in project constr file
  output          ad4080_sclk, // as above
  output          ad4080_csn, // as above
  output          ad4080_mosi, // as above

  // Clock SPI

  input           ad9508_adf4350_miso, // as above
  output          ad9508_adf4350_sclk, // as above
  output          ad9508_adf4350_mosi, // as above
  output          ad9508_csn, // as above
  output          adf4350_csn, // as above
  //wire  [2:0]   ad9508_adf4350_csn, // new signal to merge both csn 
  wire   [2:0] spi1_csn
  //output          spi1_csn0,
  //output          spi1_csn1
);
  // internal signals
  wire    [94:0]  gpio_i; // ZCU 102 default template is 94:0, modified this to reflect Zed
  wire    [94:0]  gpio_o; // ZCU 102 default template is 94:0, modified this to reflect Zed
  wire    [94:0]  gpio_t; // added to default
  
//  assign gpio_bd_o = gpio_o[7:0]; // ZCU 102 default template

//  assign gpio_i[94:21] = gpio_o[94:21]; // ZCU 102 default template
    assign gpio_i[20: 8] = gpio_bd_i; // ZCU 102 default template
    assign gpio_bd_o= gpio_o[ 7: 0];// ZCU 102 default template

  wire            filter_data_ready_n; // in ad408x_fmc_evb_bd.tcl
  wire            fpga_100_clk; // as above & output of clock buffer - IBUFDS i_fpga_100_clk
  wire            fpga_ref_clk;// as above & output of clock buffer - IBUFDS i_fpga_clk

  assign gp0_dir        = 1'b0; // in project constr file
  assign gp1_dir        = 1'b0; // as above
  assign gp2_dir        = 1'b1; // as above
  assign gp3_dir        = 1'b0; // as above

  assign filter_data_ready_n  = gpio1_fmc; // in project constr file
  assign gpio_i[34]           = gpio3_fmc; // in project constr file
  assign gpio2_fmc            = gpio_o[33]; // in project constr file

  assign en_psu         = 1'b1; // in project constr file
  assign osc_en         = pwrgd; // in project constr file
  assign pd_v33b        = 1'b1; // in project constr file
  assign ad9508_sync    = ~gpio_o[37]; // in project constr file
  assign gpio_i[35]     = adf435x_lock; // in project constr file
  assign gpio_i[36]     = pwrgd; // in project constr file
  assign gpio_i[94:38]  = gpio_o[94:38]; 
  //assign  ad9508_csn = ad9508_adf4350_csn [0]    ; // new
  //assign adf4350_csn = ad9508_adf4350_csn [1]    ; // new
  assign spi1_csn[0]   = ad9508_csn ; // new
  assign spi1_csn[1]   = adf4350_csn ; // new
  
  
  //spi1_csn[0] (ad9508_csn),
    //.spi1_csn[1] (adf4350_csn),
//  ad_iobuf #(
//    .DATA_WIDTH(32)
//  ) i_gpio_bd ( // in Common zed constr file
//    .dio_t({gpio_t[31:0]}),
//    .dio_i({gpio_o[31:0]}),
//    .dio_o({gpio_i[31:0]}),
//    .dio_p({gpio_bd_o[31:0]})); // in Common zed constr file - not sure if it should be input or out


  IBUFDS i_fpga_clk (
    .I (clk_p), // in project constr file
    .IB (clk_n), // not in proj contraints file - auto zero if not connected?
    .O (fpga_ref_clk)); // output goes to system wrapper section

  IBUFDS i_fpga_100_clk (
    .I (fpgaclk_p), // in project constr file
    .IB (fpgaclk_n), // not in proj contraints file - auto zero if not connected?
    .O (fpga_100_clk)); // output goes to system wrapper section
	
/*The ad_iobuf module is used in FPGA designs to interface general-purpose input/output (GPIO) signals with external pins. 
This module is particularly useful for handling bidirectional signals, allowing the same pin to function as either an input or an output depending on the control signals.
Here’s a brief overview of how it works:
dio_t: Tri-state control signal. When high, the pin behaves as an input; when low, it behaves as an output.
dio_i: Input data signal to the pin.
dio_o: Output data signal from the pin.
dio_p: The actual bidirectional pin.
The ad_iobuf module essentially converts these signals to and from the external pin, enabling flexible I/O operations.
*/




  // instantiations
  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),// in ZCU102 system bd
    .gpio_o (gpio_o),// in ZCU102 system bd
    .gpio_t (gpio_t), // in ZCU102 system bd

    .spi0_csn (ad4080_csn), // in ZCU102 system bd (in sys constr)
    .spi0_miso (ad4080_miso),//in ZCU102 system bd (in sys constr)
    .spi0_mosi (ad4080_mosi),//in ZCU102 system bd (in sys constr)
    .spi0_sclk (ad4080_sclk), //in ZCU102 system bd (in sys constr)
	.spi1_csn (ad9508_csn), //in ZCU102 system bd (new merged signal)
	//.spi1_csn0 (adf4350_csn),
	//.spi1_csn1 (adf4350_csn),
    .spi1_miso (ad9508_adf4350_miso), //in ZCU102 system bd (in sys constr)
    .spi1_mosi (ad9508_adf4350_mosi), //in ZCU102 system bd (in sys constr)
    .spi1_sclk (ad9508_adf4350_sclk), //in ZCU102 system bd (in sys constr)
	.dco_p (dco_p), // (in sys constr)
    .dco_n (dco_n), //(in sys constr)
    .da_p (da_p), // (in sys constr)
    .da_n (da_n), // (in sys constr)
    .db_p (db_p), // (in sys constr)
    .db_n (db_n), // (in sys constr)
    .cnv_in_p(cnv_in_p),// (in sys constr)
    .cnv_in_n(cnv_in_n),// (in sys constr)
    .filter_data_ready_n(filter_data_ready_n),
    .sync_n (ad9508_sync), // (in sys constr)
    .fpga_ref_clk(fpga_ref_clk), // created in this file via "IBUFDS i_fpga_clk" block using clk_p as an input from constraints file
    .fpga_100_clk(fpga_100_clk)); // created in this file via "IBUFDS i_fpga_100_clk" block using fpgaclk_p as an input from constraints file
endmodule
