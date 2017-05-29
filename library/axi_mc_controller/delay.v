// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory of
//      the repository (LICENSE_GPL2), and at: <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns / 1ps

module delay
//----------- Parameters Declarations -------------------------------------------
#(
    parameter DELAY = 128
)
//----------- Ports Declarations -----------------------------------------------
(
    input       clk_i,
    input       rst_n_i,
    input       sig_i,
    output reg  sig_o
);
//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg [DELAY-1:0] shift_reg;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------
always @(posedge clk_i)
begin
    if(rst_n_i == 0)
    begin
        shift_reg   <= 0;
        sig_o       <= 0;
    end
    else
    begin
        shift_reg   <= {shift_reg[DELAY-2:0], sig_i};
        sig_o       <= shift_reg[DELAY-1];
    end
end

endmodule
