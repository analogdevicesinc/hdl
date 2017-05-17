// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_iobuf #(

  parameter     DATA_WIDTH = 1) (

  input       [(DATA_WIDTH-1):0]  dio_t,
  input       [(DATA_WIDTH-1):0]  dio_i,
  output      [(DATA_WIDTH-1):0]  dio_o,
  inout       [(DATA_WIDTH-1):0]  dio_p);


  genvar n;
  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_iobuf
  assign dio_o[n] = dio_p[n];
  assign dio_p[n] = (dio_t[n] == 1'b1) ? 1'bz : dio_i[n];
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
