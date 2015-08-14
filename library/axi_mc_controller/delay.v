// -----------------------------------------------------------------------------
//
// Copyright 2014(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//  - Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//  - Neither the name of Analog Devices, Inc. nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//  - The use of this software may or may not infringe the patent rights
//    of one or more patent holders.  This license does not release you
//    from the requirement that you obtain separate licenses from these
//    patent holders to use this software.
//  - Use of the software either in source or binary form, must be run
//    on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// -----------------------------------------------------------------------------
// FILE NAME : delay.v
// MODULE NAME : debouncer
// AUTHOR : ACozma
// AUTHOR’S EMAIL : andrei.cozma@analog.com
//
// -----------------------------------------------------------------------------

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
