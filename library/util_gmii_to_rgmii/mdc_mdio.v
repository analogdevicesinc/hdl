`timescale 1ns/100ps

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

module mdc_mdio #(

  parameter PHY_AD = 5'b10000) (

  input                   mdio_mdc,
  input                   mdio_in_w,
  input                   mdio_in_r,

  output  reg [ 1:0]      speed_select,
  output  reg             duplex_mode);


  localparam IDLE     = 2'b01;
  localparam ACQUIRE  = 2'b10;

  wire        preamble;

  reg [ 1:0]  current_state = IDLE;
  reg [ 1:0]  next_state    = IDLE;
  reg [31:0]  data_in       = 32'h0;
  reg [31:0]  data_in_r     = 32'h0;
  reg [ 5:0]  data_counter  = 6'h0;

  assign preamble = &data_in;

  always @(posedge mdio_mdc) begin
    current_state <= next_state;
    data_in <= {data_in[30:0], mdio_in_w};
    if (current_state == ACQUIRE) begin
      data_counter <= data_counter + 1;
    end else begin
      data_counter <= 0;
    end
    if (data_counter == 6'h1f) begin
      if (data_in[31] == 1'b0 && data_in[29:28]==2'b10 && data_in[27:23] == PHY_AD && data_in[22:18] == 5'h11) begin
        speed_select <= data_in_r[16:15] ;
        duplex_mode  <= data_in_r[14];
      end
    end
  end

  always @(negedge mdio_mdc) begin
    data_in_r <= {data_in_r[30:0], mdio_in_r};
  end

  always @(*) begin
    case (current_state)
      IDLE: begin
        if (preamble == 1 && mdio_in_w == 0) begin
          next_state <= ACQUIRE;
        end else begin
          next_state <= IDLE;
        end
      end
      ACQUIRE: begin
        if (data_counter == 6'h1f) begin
          next_state <= IDLE;
        end else begin
          next_state <= ACQUIRE;
        end
      end
      default: begin
        next_state <= IDLE;
      end
    endcase
  end

endmodule
