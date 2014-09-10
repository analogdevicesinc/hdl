// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  // fmc fpga interface

  eth_rx_clk,
  eth_rx_cntrl,
  eth_rx_data,
  eth_tx_clk_out,
  eth_tx_cntrl,
  eth_tx_data,
  eth_mdc,
  eth_mdio_i,
  eth_mdio_o,
  eth_mdio_t,

  // phy interface

  phy_resetn,
  phy_rx_clk,
  phy_rx_cntrl,
  phy_rx_data,
  phy_tx_clk_out,
  phy_tx_cntrl,
  phy_tx_data,
  phy_mdc,
  phy_mdio);

  // fmc fpga interface

  output            eth_rx_clk;
  output            eth_rx_cntrl;
  output  [  3:0]   eth_rx_data;
  input             eth_tx_clk_out;
  input             eth_tx_cntrl;
  input   [  3:0]   eth_tx_data;
  input             eth_mdc;
  output            eth_mdio_i;
  input             eth_mdio_o;
  input             eth_mdio_t;

  // phy interface

  output            phy_resetn;
  input             phy_rx_clk;
  input             phy_rx_cntrl;
  input   [  3:0]   phy_rx_data;
  output            phy_tx_clk_out;
  output            phy_tx_cntrl;
  output  [  3:0]   phy_tx_data;
  output            phy_mdc;
  inout             phy_mdio;

  // simple pass through

  assign eth_rx_clk = phy_rx_clk;
  assign eth_rx_cntrl = phy_rx_cntrl;
  assign eth_rx_data = phy_rx_data;

  assign phy_tx_clk_out = eth_tx_clk_out;
  assign phy_tx_cntrl = eth_tx_cntrl;
  assign phy_tx_data = eth_tx_data;

  assign phy_mdc = eth_mdc;
  assign phy_mdio = (eth_mdio_t == 1'b0) ? eth_mdio_o : 1'bz;
  assign eth_mdio_i = phy_mdio;

  assign phy_resetn = 1'b1;

endmodule

// ***************************************************************************
// ***************************************************************************
