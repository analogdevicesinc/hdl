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

module debouncer
//----------- Paramters Declarations -------------------------------------------
#(
    parameter DEBOUNCER_LENGTH = 4
)
//----------- Ports Declarations -----------------------------------------------
(
    input       clk_i,
    input       rst_i,
    input       sig_i,
    output reg  sig_o
);
//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg [DEBOUNCER_LENGTH-1:0] shift_reg;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

always @(posedge clk_i)
begin
    if(rst_i == 1)
    begin
        shift_reg   <= 0;
        sig_o       <= 0;
    end
    else
    begin
        shift_reg <= {shift_reg[DEBOUNCER_LENGTH-2:0], sig_i};
        if(shift_reg == {DEBOUNCER_LENGTH{1'b1}})
        begin
            sig_o <= 1'b1;
        end
        else if(shift_reg == {DEBOUNCER_LENGTH{1'b0}})
        begin
            sig_o <= 1'b0;
        end
    end
end

endmodule
