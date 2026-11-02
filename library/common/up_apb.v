// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

module up_apb #(

  parameter   APB_ADDRESS_WIDTH = 16
) (

  // apb interface

  input                             up_apb_presetn,
  input                             up_apb_clk,

  input   [(APB_ADDRESS_WIDTH-1):0] up_apb_paddr,
  input                             up_apb_penable,
  output  [31:0]                    up_apb_prdata,
  output                            up_apb_pready,
  input                             up_apb_pselx,
  output                            up_apb_pslverr,
  input   [31:0]                    up_apb_pwdata,
  input                             up_apb_pwrite,

  // pcore interface

  output                            up_wreq,
  output  [(APB_ADDRESS_WIDTH-3):0] up_waddr,
  output  [31:0]                    up_wdata,
  input                             up_wack,

  output                            up_rreq,
  output  [(APB_ADDRESS_WIDTH-3):0] up_raddr,
  input   [31:0]                    up_rdata,
  input                             up_rack
);

  // no error
  assign up_apb_pslverr = 0;

  // addr
  assign up_waddr = up_apb_paddr[(APB_ADDRESS_WIDTH-1):2];
  assign up_raddr = up_apb_paddr[(APB_ADDRESS_WIDTH-1):2];

  // data
  assign up_wdata = up_apb_pwdata;
  assign up_apb_prdata = up_rdata;

  // requests
  // one cycle request per transfer, as up_axi: the access phase lasts until
  // pready (the registered ack of the pcore), so the request is given only in
  // its first cycle; otherwise the pcore would see one write or read per
  // cycle of the access phase (a second transfer submit, a second FIFO read)

  reg                               up_apb_access = 1'b0;

  wire                              up_apb_req_s;

  assign up_apb_req_s = up_apb_pselx & up_apb_penable & ~up_apb_access;

  always @(posedge up_apb_clk) begin
    if (up_apb_presetn == 1'b0) begin
      up_apb_access <= 1'b0;
    end else if (up_apb_pready == 1'b1) begin
      up_apb_access <= 1'b0;
    end else if ((up_apb_pselx == 1'b1) && (up_apb_penable == 1'b1)) begin
      up_apb_access <= 1'b1;
    end
  end

  assign up_wreq = up_apb_req_s & up_apb_pwrite;
  assign up_rreq = up_apb_req_s & ~up_apb_pwrite;

  // regmap is ready if it is not in reset
  // assign up_apb_pready = up_apb_presetn;

  // option with response

  assign up_apb_pready = (up_apb_pwrite ? up_wack : up_rack) & up_apb_presetn;

endmodule
