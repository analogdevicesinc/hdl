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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

//------------------------------------------------------------------------------   
//----------- Module Declaration -----------------------------------------------
//------------------------------------------------------------------------------ 
module clk_div
    (
        // Clock and Reset signals
        input 			clk_i,
        input 			reset_n_i,
		
		// Clock divider
		input 			new_div_i,
		input   [31:0] 	div_i,
		input			new_phase_inc_i,
		input   [31:0] 	phase_inc_i,
        
		// Divided clock output
		output	reg		reg_update_rdy_o,
		output 			clk_o,
		output 	[31:0]	phase_o
    );

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg [31:0] div;
reg [31:0] div_cnt;
reg [31:0] phase;
reg [31:0] phase_inc;
reg        clk_div;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------
assign clk_o 	= clk_div;
assign phase_o 	= phase;

// Register update logic
always @(posedge clk_i)
begin
    if(reset_n_i == 1'b0)
    begin
        div   		<= 'd0;
		phase_inc	<= 'd0;
		reg_update_rdy_o <= 1'b0;
    end
    else
    begin
		if(new_div_i == 1'b1)
		begin
			div <= div_i;			
		end
		if(new_phase_inc_i == 1'b1)
		begin
			phase_inc <= phase_inc_i;			
		end
		reg_update_rdy_o <= new_div_i | new_phase_inc_i;		
    end
end

// Clock division logic
always @(posedge clk_i)
begin
    if(reset_n_i == 1'b0)
    begin
		clk_div	<= 'd1;
		phase   <= 'd0;
    end
    else
    begin
        if(div_cnt < div)
		begin
			div_cnt <= div_cnt + 'd1;
		end
		else
		begin
			div_cnt <= 'd1;
			//clk_div <= ~clk_div;
		end
		phase <= phase + phase_inc;
		clk_div <= phase[31];
    end
end

endmodule
