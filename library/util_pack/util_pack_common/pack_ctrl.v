// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

`timescale 1ns/100ps

module pack_ctrl #(
  parameter PORT_ADDRESS_WIDTH = 2,
  parameter MUX_ORDER = 1,
  parameter MIN_STAGE = 0,
  parameter NUM_STAGES = 2,
  parameter PACK = 0
) (
  input [PORT_ADDRESS_WIDTH-1:0] rotate,
  input [2**PORT_ADDRESS_WIDTH*PORT_ADDRESS_WIDTH-1:0] prefix_count,

  output [2**PORT_ADDRESS_WIDTH*MUX_ORDER*NUM_STAGES-1:0] ctrl
);

  /*
   * This module computes the control bits that are used to configure the MUXes
   * in the pack interconect network. The controls are configured according to
   * the specified global rotation and the prefix count of each of the outputs.
   */

  localparam NUM_OF_PORTS = 2**PORT_ADDRESS_WIDTH;

  wire [NUM_OF_PORTS*MUX_ORDER*NUM_STAGES-1:0] ctrl1;
  reg [NUM_OF_PORTS*MUX_ORDER*NUM_STAGES-1:0] ctrl2;

  generate
  genvar i, j, k;
  integer n;

  localparam z = 2**MUX_ORDER;

  /* This part is magic */
  for (i = 0; i < NUM_STAGES; i = i + 1) begin: ctrl_gen_outer
    localparam k0 = 2**(PORT_ADDRESS_WIDTH - MUX_ORDER*(i+1)-MIN_STAGE);
    localparam k1 = 2**(MUX_ORDER*(1+i)+MIN_STAGE);

    for (j = 0; j < NUM_OF_PORTS; j = j + 1) begin: ctrl_gen_inner
      /* Offset in the ctrl signal */
      localparam s = (i*NUM_OF_PORTS+j)*MUX_ORDER;
      localparam m = (j % k1) * k0;
      localparam n = j / k1;

      if (MUX_ORDER == 1 && j % 2 == 0) begin
        /* This is an optimization that only works for 2:1 MUXes */
        assign ctrl1[s] = ~ctrl1[s+1];
      end else begin
        assign ctrl1[s+:MUX_ORDER] = (j - (prefix_count[m*PORT_ADDRESS_WIDTH+:PORT_ADDRESS_WIDTH] + n - rotate) / k0) % z;
      end
    end
  end

  if (PACK == 0 || MUX_ORDER == 1) begin
    /* For 2:1 MUXes pack and unpack control is the same */
    assign ctrl = ctrl1;
  end else begin
    /*
     * Transform demux control into mux control. The implementation here uses a
     * priority encoder.
     */
    for (i = 0; i < NUM_STAGES*NUM_OF_PORTS; i = i + z) begin: demux_gen_outer
      localparam base = i*MUX_ORDER;
      for (k = 0; k < z; k = k + 1) begin: demux_gen_inner
        always @(ctrl1) begin
          ctrl2[base+k*MUX_ORDER+:MUX_ORDER] <= {MUX_ORDER{1'b1}};
          for (n = 0; n < z; n = n + 1) begin
            if (ctrl1[base+n*MUX_ORDER+:MUX_ORDER] == k) begin
              ctrl2[base+k*MUX_ORDER+:MUX_ORDER] <= n[MUX_ORDER-1:0];
            end
          end
        end
      end
    end
    assign ctrl = ctrl2;
  end
  endgenerate

endmodule
