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

module axi_ad9371_if (

  // receive

  adc_clk,
  adc_rx_sof,
  adc_rx_data,
  adc_os_clk,
  adc_rx_os_sof,
  adc_rx_os_data,

  adc_data,
  adc_os_valid,
  adc_os_data,

  // transmit

  dac_clk,
  dac_tx_data,

  dac_data);

  // parameters

  parameter   DEVICE_TYPE = 0;

  // receive

  input             adc_clk;
  input   [  3:0]   adc_rx_sof;
  input   [ 63:0]   adc_rx_data;
  input             adc_os_clk;
  input   [  3:0]   adc_rx_os_sof;
  input   [ 63:0]   adc_rx_os_data;
  output  [ 63:0]   adc_data;
  output            adc_os_valid;
  output  [ 63:0]   adc_os_data;

  // transmit

  input             dac_clk;
  output  [127:0]   dac_tx_data;
  input   [127:0]   dac_data;

  // internal signals

  wire    [ 63:0]   adc_rx_data_s;
  wire    [ 63:0]   adc_rx_os_data_s;

  // delineating

  assign adc_data[((8* 7)+7):(8* 7)] = adc_rx_data_s[((8* 6)+7):(8* 6)];
  assign adc_data[((8* 6)+7):(8* 6)] = adc_rx_data_s[((8* 7)+7):(8* 7)];
  assign adc_data[((8* 5)+7):(8* 5)] = adc_rx_data_s[((8* 4)+7):(8* 4)];
  assign adc_data[((8* 4)+7):(8* 4)] = adc_rx_data_s[((8* 5)+7):(8* 5)];
  assign adc_data[((8* 3)+7):(8* 3)] = adc_rx_data_s[((8* 2)+7):(8* 2)];
  assign adc_data[((8* 2)+7):(8* 2)] = adc_rx_data_s[((8* 3)+7):(8* 3)];
  assign adc_data[((8* 1)+7):(8* 1)] = adc_rx_data_s[((8* 0)+7):(8* 0)];
  assign adc_data[((8* 0)+7):(8* 0)] = adc_rx_data_s[((8* 1)+7):(8* 1)];

  assign adc_os_valid = 'd1;
  assign adc_os_data[((8* 7)+7):(8* 7)] = adc_rx_os_data_s[((8* 6)+7):(8* 6)];
  assign adc_os_data[((8* 6)+7):(8* 6)] = adc_rx_os_data_s[((8* 7)+7):(8* 7)];
  assign adc_os_data[((8* 5)+7):(8* 5)] = adc_rx_os_data_s[((8* 4)+7):(8* 4)];
  assign adc_os_data[((8* 4)+7):(8* 4)] = adc_rx_os_data_s[((8* 5)+7):(8* 5)];
  assign adc_os_data[((8* 3)+7):(8* 3)] = adc_rx_os_data_s[((8* 2)+7):(8* 2)];
  assign adc_os_data[((8* 2)+7):(8* 2)] = adc_rx_os_data_s[((8* 3)+7):(8* 3)];
  assign adc_os_data[((8* 1)+7):(8* 1)] = adc_rx_os_data_s[((8* 0)+7):(8* 0)];
  assign adc_os_data[((8* 0)+7):(8* 0)] = adc_rx_os_data_s[((8* 1)+7):(8* 1)];

  assign dac_tx_data[((8*15)+7):(8*15)] = (DEVICE_TYPE == 1) ? dac_data[((8*13)+7):(8*13)] : dac_data[((8*14)+7):(8*14)];
  assign dac_tx_data[((8*14)+7):(8*14)] = (DEVICE_TYPE == 1) ? dac_data[((8*12)+7):(8*12)] : dac_data[((8*15)+7):(8*15)];
  assign dac_tx_data[((8*13)+7):(8*13)] = (DEVICE_TYPE == 1) ? dac_data[((8*15)+7):(8*15)] : dac_data[((8*12)+7):(8*12)];
  assign dac_tx_data[((8*12)+7):(8*12)] = (DEVICE_TYPE == 1) ? dac_data[((8*14)+7):(8*14)] : dac_data[((8*13)+7):(8*13)];
  assign dac_tx_data[((8*11)+7):(8*11)] = (DEVICE_TYPE == 1) ? dac_data[((8* 9)+7):(8* 9)] : dac_data[((8*10)+7):(8*10)];
  assign dac_tx_data[((8*10)+7):(8*10)] = (DEVICE_TYPE == 1) ? dac_data[((8* 8)+7):(8* 8)] : dac_data[((8*11)+7):(8*11)];
  assign dac_tx_data[((8* 9)+7):(8* 9)] = (DEVICE_TYPE == 1) ? dac_data[((8*11)+7):(8*11)] : dac_data[((8* 8)+7):(8* 8)];
  assign dac_tx_data[((8* 8)+7):(8* 8)] = (DEVICE_TYPE == 1) ? dac_data[((8*10)+7):(8*10)] : dac_data[((8* 9)+7):(8* 9)];
  assign dac_tx_data[((8* 7)+7):(8* 7)] = (DEVICE_TYPE == 1) ? dac_data[((8* 5)+7):(8* 5)] : dac_data[((8* 6)+7):(8* 6)];
  assign dac_tx_data[((8* 6)+7):(8* 6)] = (DEVICE_TYPE == 1) ? dac_data[((8* 4)+7):(8* 4)] : dac_data[((8* 7)+7):(8* 7)];
  assign dac_tx_data[((8* 5)+7):(8* 5)] = (DEVICE_TYPE == 1) ? dac_data[((8* 7)+7):(8* 7)] : dac_data[((8* 4)+7):(8* 4)];
  assign dac_tx_data[((8* 4)+7):(8* 4)] = (DEVICE_TYPE == 1) ? dac_data[((8* 6)+7):(8* 6)] : dac_data[((8* 5)+7):(8* 5)];
  assign dac_tx_data[((8* 3)+7):(8* 3)] = (DEVICE_TYPE == 1) ? dac_data[((8* 1)+7):(8* 1)] : dac_data[((8* 2)+7):(8* 2)];
  assign dac_tx_data[((8* 2)+7):(8* 2)] = (DEVICE_TYPE == 1) ? dac_data[((8* 0)+7):(8* 0)] : dac_data[((8* 3)+7):(8* 3)];
  assign dac_tx_data[((8* 1)+7):(8* 1)] = (DEVICE_TYPE == 1) ? dac_data[((8* 3)+7):(8* 3)] : dac_data[((8* 0)+7):(8* 0)];
  assign dac_tx_data[((8* 0)+7):(8* 0)] = (DEVICE_TYPE == 1) ? dac_data[((8* 2)+7):(8* 2)] : dac_data[((8* 1)+7):(8* 1)];

  // instantiations

  genvar n;

  generate
  for (n = 0; n < 2; n = n + 1) begin: g_xcvr_if

  ad_xcvr_rx_if #(.DEVICE_TYPE (DEVICE_TYPE)) i_xcvr_rx_if (
    .rx_clk (adc_clk),
    .rx_ip_sof (adc_rx_sof),
    .rx_ip_data (adc_rx_data[((n*32)+31):(n*32)]),
    .rx_sof (),
    .rx_data (adc_rx_data_s[((n*32)+31):(n*32)]));

  ad_xcvr_rx_if #(.DEVICE_TYPE (DEVICE_TYPE)) i_xcvr_rx_os_if (
    .rx_clk (adc_os_clk),
    .rx_ip_sof (adc_rx_os_sof),
    .rx_ip_data (adc_rx_os_data[((n*32)+31):(n*32)]),
    .rx_sof (),
    .rx_data (adc_rx_os_data_s[((n*32)+31):(n*32)]));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
