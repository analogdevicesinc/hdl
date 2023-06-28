// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017(c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL(Verilog or VHDL) components. The individual modules are
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
//      of this repository(LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository(LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

module yuv422torgb(

input              video_clk,

// Y-U-V inputs AXI-STREAM SLAVE INTERFACE

input              video_in_valid ,
input   [15:0]     video_in_data,
output             video_in_ready,

// R-G-B outputs AXI-STREAM MASTER INTERFACE

output                 video_out_valid,
output reg     [23:0]  video_out_data,
input                  video_out_ready
);

reg         video_in_ready_r;

wire  [23:0] s444_data; 
wire         s444_valid;
wire  [23:0] video_out_data_s;

assign video_in_ready = video_in_ready_r;


always @(posedge video_clk) begin
  video_in_ready_r <= video_out_valid;
  if(video_out_ready == 1'b1) begin 
    video_out_data <= video_out_data_s;
  end 
end

// YUV 4:2:2 to YUV 4:4:4 conversion

yuv422torgb_upscale ad_yuv_422to444 (
  .clk(video_clk),
  .s422_sync(video_in_valid),
  .s422_data(video_in_data),
  .s444_sync(s444_valid),
  .s444_data(s444_data));

// YUV 4:4:4 to RGB conversion

yuv422torgb_conversion yuv444_to_RGB (
  .clk(video_clk),
  .YUV_sync(s444_valid),
  .YUV_data(s444_data),
  .RGB_sync(video_out_valid),
  .RGB_data(video_out_data_s));

endmodule