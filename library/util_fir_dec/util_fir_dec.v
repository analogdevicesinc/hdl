// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
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
// This IP allows the decimation by 8 of the data from the input channels
// 0 and 1. The decimation filter is implemented using a fir_compiler IP from
// Xilinx.
// ***************************************************************************

`timescale 1ns/100ps

module util_fir_dec (
  input               aclk,
  input               s_axis_data_tvalid,
  output              s_axis_data_tready,
  input       [15:0]  channel_0,
  input       [15:0]  channel_1,
  input               decimate,
  output              m_axis_data_tvalid,
  output      [31:0]  m_axis_data_tdata);

  wire [31:0] s_axis_data_tdata;

  wire        m_axis_data_tvalid_s;
  wire [31:0] m_axis_data_tdata_s;

  assign s_axis_data_tdata = {channel_1, channel_0};

  assign m_axis_data_tvalid = (decimate == 1'b1) ? m_axis_data_tvalid_s : s_axis_data_tvalid;
  assign m_axis_data_tdata = (decimate == 1'b1) ? {m_axis_data_tdata_s[30:16], 1'b0, m_axis_data_tdata_s[14:0], 1'b0} : {channel_1, channel_0};

  fir_decim decimator (
    .aclk(aclk),
    .s_axis_data_tvalid(s_axis_data_tvalid),
    .s_axis_data_tready(s_axis_data_tready),
    .s_axis_data_tdata(s_axis_data_tdata),
    .m_axis_data_tvalid(m_axis_data_tvalid_s),
    .m_axis_data_tdata(m_axis_data_tdata_s)
  );

endmodule  // util_fir_dec

