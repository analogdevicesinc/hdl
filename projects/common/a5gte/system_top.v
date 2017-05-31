// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module system_top (

  // fpga-fpga interface

  output                  eth_rx_clk,
  output                  eth_rx_cntrl,
  output      [ 3:0]      eth_rx_data,
  input                   eth_tx_clk,
  input                   eth_tx_cntrl,
  input       [ 3:0]      eth_tx_data,
  input                   eth_mdc,
  output                  eth_mdio_i,
  input                   eth_mdio_o,
  input                   eth_mdio_t,
  input                   eth_phy_resetn,

  // phy interface

  output                  phy_resetn,
  input                   phy_rx_clk,
  input                   phy_rx_cntrl,
  input       [ 3:0]      phy_rx_data,
  output                  phy_tx_clk_out,
  output                  phy_tx_cntrl,
  output      [ 3:0]      phy_tx_data,
  output                  phy_mdc,
  inout                   phy_mdio);

  wire            eth_rx_clk_90;
  wire            eth_tx_clk_90;
  wire    [ 4:0]  eth_tx_data_h;
  wire    [ 4:0]  eth_tx_data_l;
  wire    [ 4:0]  phy_rx_data_h;
  wire    [ 4:0]  phy_rx_data_l;

  reg     [ 4:0]  eth_tx_data_h_d;
  reg     [ 4:0]  phy_rx_data_h_d;
  reg     [ 4:0]  phy_rx_data_h_d1;
  reg     [ 4:0]  phy_rx_data_l_d;
  // RX path

  altera_pll #(
    .fractional_vco_multiplier("false"),
    .reference_clock_frequency("125.0 MHz"),
    .operation_mode("normal"),
    .number_of_clocks(1),
    .output_clock_frequency0("125.000000 MHz"),
    .phase_shift0("2000 ps"),
    .duty_cycle0(50),
    .output_clock_frequency1("0 MHz"),
    .phase_shift1("0 ps"),
    .duty_cycle1(50),
    .output_clock_frequency2("0 MHz"),
    .phase_shift2("0 ps"),
    .duty_cycle2(50),
    .output_clock_frequency3("0 MHz"),
    .phase_shift3("0 ps"),
    .duty_cycle3(50),
    .output_clock_frequency4("0 MHz"),
    .phase_shift4("0 ps"),
    .duty_cycle4(50),
    .output_clock_frequency5("0 MHz"),
    .phase_shift5("0 ps"),
    .duty_cycle5(50),
    .output_clock_frequency6("0 MHz"),
    .phase_shift6("0 ps"),
    .duty_cycle6(50),
    .output_clock_frequency7("0 MHz"),
    .phase_shift7("0 ps"),
    .duty_cycle7(50),
    .output_clock_frequency8("0 MHz"),
    .phase_shift8("0 ps"),
    .duty_cycle8(50),
    .output_clock_frequency9("0 MHz"),
    .phase_shift9("0 ps"),
    .duty_cycle9(50),
    .output_clock_frequency10("0 MHz"),
    .phase_shift10("0 ps"),
    .duty_cycle10(50),
    .output_clock_frequency11("0 MHz"),
    .phase_shift11("0 ps"),
    .duty_cycle11(50),
    .output_clock_frequency12("0 MHz"),
    .phase_shift12("0 ps"),
    .duty_cycle12(50),
    .output_clock_frequency13("0 MHz"),
    .phase_shift13("0 ps"),
    .duty_cycle13(50),
    .output_clock_frequency14("0 MHz"),
    .phase_shift14("0 ps"),
    .duty_cycle14(50),
    .output_clock_frequency15("0 MHz"),
    .phase_shift15("0 ps"),
    .duty_cycle15(50),
    .output_clock_frequency16("0 MHz"),
    .phase_shift16("0 ps"),
    .duty_cycle16(50),
    .output_clock_frequency17("0 MHz"),
    .phase_shift17("0 ps"),
    .duty_cycle17(50),
    .pll_type("General"),
    .pll_subtype("General")
  ) eth_rx_pll_i (
    .rst  (~eth_phy_resetn),
    .outclk (eth_rx_clk_90),
    .locked (),
    .fboutclk ( ),
    .fbclk  (1'b0),
    .refclk (phy_rx_clk)
  );

  altddio_in #(
    .intended_device_family("Arria V"),
    .invert_input_clocks("OFF"),
    .lpm_hint("UNUSED"),
    .lpm_type("altddio_in"),
    .power_up_high("OFF"),
    .width(5)
  ) eth_rx_path_in (
    .datain ({phy_rx_cntrl,phy_rx_data}),
    .inclock (phy_rx_clk),
    .dataout_h (phy_rx_data_h),
    .dataout_l (phy_rx_data_l),
    .aclr (~eth_phy_resetn),
    .aset (1'b0),
    .inclocken (1'b1),
    .sclr (1'b0),
    .sset (1'b0));

  always @(posedge phy_rx_clk)
  begin
    phy_rx_data_h_d <= phy_rx_data_h;
    phy_rx_data_h_d1 <= phy_rx_data_h_d;
    phy_rx_data_l_d <= phy_rx_data_l;
  end

  altddio_out #(
    .extend_oe_disable("OFF"),
    .intended_device_family("Arria V"),
    .invert_output("OFF"),
    .lpm_hint("UNUSED"),
    .lpm_type("altddio_out"),
    .oe_reg("UNREGISTERED"),
    .power_up_high("OFF"),
    .width(5)
  ) eth_rx_path_out (
    .datain_h (phy_rx_data_h_d1),
    .datain_l (phy_rx_data_l_d),
    .outclock (phy_rx_clk),
    .dataout ({eth_rx_cntrl,eth_rx_data}),
    .aclr (~eth_phy_resetn),
    .aset (1'b0),
    .oe (1'b1),
    .oe_out (),
    .outclocken (1'b1),
    .sclr (1'b0),
    .sset (1'b0));

  altddio_out #(.width(1)) i_eth_rx_clk (
    .aset (1'b0),
    .sset (1'b0),
    .sclr (1'b0),
    .oe (1'b1),
    .oe_out (),
    .datain_h (1'b1),
    .datain_l (1'b0),
    .outclocken (1'b1),
    .aclr (1'b0),
    .outclock (eth_rx_clk_90),
    .dataout (eth_rx_clk));

 // assign eth_rx_clk = eth_rx_clk_90;

  // TX path

  altera_pll #(
    .fractional_vco_multiplier("false"),
    .reference_clock_frequency("125.0 MHz"),
    .operation_mode("normal"),
    .number_of_clocks(1),
    .output_clock_frequency0("125.000000 MHz"),
    .phase_shift0("2000 ps"),
    .duty_cycle0(50),
    .output_clock_frequency1("0 MHz"),
    .phase_shift1("0 ps"),
    .duty_cycle1(50),
    .output_clock_frequency2("0 MHz"),
    .phase_shift2("0 ps"),
    .duty_cycle2(50),
    .output_clock_frequency3("0 MHz"),
    .phase_shift3("0 ps"),
    .duty_cycle3(50),
    .output_clock_frequency4("0 MHz"),
    .phase_shift4("0 ps"),
    .duty_cycle4(50),
    .output_clock_frequency5("0 MHz"),
    .phase_shift5("0 ps"),
    .duty_cycle5(50),
    .output_clock_frequency6("0 MHz"),
    .phase_shift6("0 ps"),
    .duty_cycle6(50),
    .output_clock_frequency7("0 MHz"),
    .phase_shift7("0 ps"),
    .duty_cycle7(50),
    .output_clock_frequency8("0 MHz"),
    .phase_shift8("0 ps"),
    .duty_cycle8(50),
    .output_clock_frequency9("0 MHz"),
    .phase_shift9("0 ps"),
    .duty_cycle9(50),
    .output_clock_frequency10("0 MHz"),
    .phase_shift10("0 ps"),
    .duty_cycle10(50),
    .output_clock_frequency11("0 MHz"),
    .phase_shift11("0 ps"),
    .duty_cycle11(50),
    .output_clock_frequency12("0 MHz"),
    .phase_shift12("0 ps"),
    .duty_cycle12(50),
    .output_clock_frequency13("0 MHz"),
    .phase_shift13("0 ps"),
    .duty_cycle13(50),
    .output_clock_frequency14("0 MHz"),
    .phase_shift14("0 ps"),
    .duty_cycle14(50),
    .output_clock_frequency15("0 MHz"),
    .phase_shift15("0 ps"),
    .duty_cycle15(50),
    .output_clock_frequency16("0 MHz"),
    .phase_shift16("0 ps"),
    .duty_cycle16(50),
    .output_clock_frequency17("0 MHz"),
    .phase_shift17("0 ps"),
    .duty_cycle17(50),
    .pll_type("General"),
    .pll_subtype("General")
  ) eth_tx_pll_i (
    .rst  (~eth_phy_resetn),
    .outclk (eth_tx_clk_90),
    .locked (),
    .fboutclk ( ),
    .fbclk  (1'b0),
    .refclk (eth_tx_clk)
  );

  altddio_in #(
    .intended_device_family("Arria V"),
    .invert_input_clocks("OFF"),
    .lpm_hint("UNUSED"),
    .lpm_type("altddio_in"),
    .power_up_high("OFF"),
    .width(5))
    eth_tx_path_in (
      .datain({eth_tx_cntrl,eth_tx_data}),
      .inclock(eth_tx_clk_90),
      .dataout_h(eth_tx_data_h),
      .dataout_l(eth_tx_data_l));

  always @(posedge eth_tx_clk_90)
  begin
    eth_tx_data_h_d <= eth_tx_data_h;
  end

 altddio_out #(
    .extend_oe_disable("OFF"),
    .intended_device_family("Arria V"),
    .invert_output("OFF"),
    .lpm_hint("UNUSED"),
    .lpm_type("altddio_out"),
    .oe_reg("UNREGISTERED"),
    .power_up_high("OFF"),
    .width(5)
  ) eth_tx_path_out (
    .datain_h (eth_tx_data_h_d),
    .datain_l (eth_tx_data_l),
    .outclock (eth_tx_clk_90),
    .dataout ({phy_tx_cntrl,phy_tx_data}),
    .aclr (~eth_phy_resetn),
    .aset (1'b0),
    .oe (1'b1),
    .oe_out (),
    .outclocken (1'b1),
    .sclr (1'b0),
    .sset (1'b0));

   altddio_out #(.width(1)) i_phy_tx_clk_out (
    .aset (1'b0),
    .sset (1'b0),
    .sclr (1'b0),
    .oe (1'b1),
    .oe_out (),
    .datain_h (1'b1),
    .datain_l (1'b0),
    .outclocken (1'b1),
    .aclr (1'b0),
    .outclock (eth_tx_clk_90),
    .dataout (phy_tx_clk_out));

 // assign phy_tx_clk_out = eth_tx_clk_90;

  // MDIO

  assign phy_mdc = eth_mdc;
  assign phy_mdio = (eth_mdio_t == 1'b0) ? eth_mdio_o : 1'bz;
  assign eth_mdio_i = phy_mdio;

  // Reset

  assign phy_resetn = eth_phy_resetn ;

endmodule

// ***************************************************************************
// ***************************************************************************
