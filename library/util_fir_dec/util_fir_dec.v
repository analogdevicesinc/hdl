// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
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

module util_fir_dec (
  input               aclk,
  input               s_axis_data_tvalid,
  output              s_axis_data_tready,
  input       [15:0]  channel_0,
  input       [15:0]  channel_1,
  input               decimate,
  output              m_axis_data_tvalid,
  output      [31:0]  m_axis_data_tdata
);

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
    .m_axis_data_tdata(m_axis_data_tdata_s));

endmodule
