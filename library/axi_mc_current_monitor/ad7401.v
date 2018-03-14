// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1 ns / 100 ps //Use a timescale that is best for simulation.

//------------------------------------------------------------------------------
//----------- Module Declaration -----------------------------------------------
//------------------------------------------------------------------------------

module ad7401
//----------- Ports Declarations -----------------------------------------------
(
    //clock and reset signals
    input               fpga_clk_i,     // system clock
    input               adc_clk_i,      // up to 20 MHZ clock
    input               reset_i,        // active high reset signal

    //IP control and data interface
    output reg  [15:0]  data_o,          // data read from the ADC
    output reg          data_rd_ready_o, // when set to high the data read from the ADC is available on the data_o bus
    output reg          adc_status_o,

    //AD7401 control and data interface
    input               adc_mdata_i    // AD7401 MDAT pin
);

//------------------------------------------------------------------------------
//----------- Wire Declarations ------------------------------------------------
//------------------------------------------------------------------------------

wire        data_rdy_s;
wire [15:0] data_s ;

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
//State machine
reg [3:0]   present_state;
reg [3:0]   next_state;

reg         data_rdy_s_d1;
reg         data_rdy_s_d2;

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------

//States
localparam WAIT_DATA_RDY_HIGH_STATE = 4'b0001;
localparam ACQUIRE_DATA_STATE       = 4'b0010;
localparam TRANSFER_DATA_STATE      = 4'b0100;
localparam WAIT_DATA_RDY_LOW_STATE  = 4'b1000;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// synchronize data on fpga_clki
always @(posedge fpga_clk_i)
begin
    data_rdy_s_d1 <= data_rdy_s;
    data_rdy_s_d2 <= data_rdy_s_d1;
end

always @(posedge fpga_clk_i)
begin
    if(reset_i == 1'b1)
    begin
        present_state      <= WAIT_DATA_RDY_HIGH_STATE;
        adc_status_o       <= 1'b0;
    end
    else
    begin
        present_state <= next_state;
        case (present_state)
            WAIT_DATA_RDY_HIGH_STATE:
            begin
                data_rd_ready_o  <= 1'b0;
            end
            ACQUIRE_DATA_STATE:             // Acquire data from the filter
            begin
                data_o          <= data_s;
                data_rd_ready_o <= 1'b0;
                adc_status_o    <= 1'b1;
            end
            TRANSFER_DATA_STATE:            // Transfer data to the upper module to write in memory
            begin
                data_rd_ready_o <= 1'b1;
            end
            WAIT_DATA_RDY_LOW_STATE:
            begin
                data_rd_ready_o <= 1'b0;
            end
        endcase
    end
end

always @(present_state, data_rdy_s_d2)
begin
    next_state <= present_state;
    case (present_state)
        WAIT_DATA_RDY_HIGH_STATE:
        begin
            if(data_rdy_s_d2 == 1'b1)
            begin
                next_state  <= ACQUIRE_DATA_STATE;
            end
        end
        ACQUIRE_DATA_STATE:
        begin
            next_state      <= TRANSFER_DATA_STATE;
        end
        TRANSFER_DATA_STATE:
        begin
            next_state      <= WAIT_DATA_RDY_LOW_STATE;
        end
        WAIT_DATA_RDY_LOW_STATE:
        begin
            if(data_rdy_s_d2 == 1'b0)
            begin
                next_state  <= WAIT_DATA_RDY_HIGH_STATE;
            end
        end
        default:
        begin
            next_state      <= WAIT_DATA_RDY_HIGH_STATE;
        end
    endcase
end

dec256sinc24b filter(
    .mclkout_i(adc_clk_i),
    .reset_i(reset_i),
    .mdata_i(adc_mdata_i),
    .data_rdy_o(data_rdy_s),
    .data_o(data_s));

endmodule
