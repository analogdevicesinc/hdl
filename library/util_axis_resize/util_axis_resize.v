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

`timescale 1ns/100ps

module util_axis_resize # (

  parameter MASTER_DATA_WIDTH = 64,
  parameter SLAVE_DATA_WIDTH = 64,
  parameter BIG_ENDIAN = 0)(

  input                       clk,
  input                       resetn,

  input                       s_valid,
  output                      s_ready,
  input [SLAVE_DATA_WIDTH-1:0]  s_data,

  output                      m_valid,
  input                       m_ready,
  output [MASTER_DATA_WIDTH-1:0] m_data
);

localparam RATIO = (SLAVE_DATA_WIDTH < MASTER_DATA_WIDTH) ?
                            MASTER_DATA_WIDTH / SLAVE_DATA_WIDTH :
                            SLAVE_DATA_WIDTH / MASTER_DATA_WIDTH;

function integer clog2;
  input integer value;
  begin
    value = value-1;
  for (clog2=0; value>0; clog2=clog2+1)
    value = value>>1;
  end
endfunction

generate if (SLAVE_DATA_WIDTH == MASTER_DATA_WIDTH) begin

assign m_valid = s_valid;
assign s_ready = m_ready;
assign m_data = s_data;

end else if (SLAVE_DATA_WIDTH < MASTER_DATA_WIDTH) begin

reg [MASTER_DATA_WIDTH-1:0] data;
reg [clog2(RATIO)-1:0] count;
reg valid;

always @(posedge clk)
begin
  if (resetn == 1'b0) begin
    count <= RATIO - 1;
    valid <= 1'b0;
  end else begin
    if (count == 'h00 && s_ready == 1'b1 && s_valid == 1'b1)
      valid <= 1'b1;
    else if (m_ready == 1'b1)
      valid <= 1'b0;

    if (s_ready == 1'b1 && s_valid == 1'b1) begin
      if (count == 'h00)
        count <= RATIO - 1;
      else
        count <= count - 1'b1;
    end
  end
end

always @(posedge clk)
begin
  if (s_ready == 1'b1 && s_valid == 1'b1)
    if (BIG_ENDIAN == 1) begin
      data <= {data[MASTER_DATA_WIDTH-SLAVE_DATA_WIDTH-1:0], s_data};
    end else begin
      data <= {s_data, data[MASTER_DATA_WIDTH-1:SLAVE_DATA_WIDTH]};
    end
end

assign s_ready = ~valid || m_ready;
assign m_valid = valid;
assign m_data = data;

end else begin

reg [SLAVE_DATA_WIDTH-1:0] data;
reg [clog2(RATIO)-1:0] count;
reg valid;

always @(posedge clk)
begin
  if (resetn == 1'b0) begin
    count <= RATIO - 1;
    valid <= 1'b0;
  end else begin
    if (s_valid == 1'b1 && s_ready == 1'b1)
      valid <= 1'b1;
    else if (count == 'h0 && m_ready == 1'b1 && m_valid == 1'b1)
      valid <= 1'b0;

    if (m_ready == 1'b1 && m_valid == 1'b1) begin
      if (count == 'h00)
        count <= RATIO - 1;
      else
        count <= count - 1'b1;
    end
  end
end

always @(posedge clk)
begin
  if (s_ready == 1'b1 && s_valid == 1'b1) begin
    data <= s_data;
  end else if (m_ready == 1'b1 && m_valid == 1'b1) begin
    if (BIG_ENDIAN == 1) begin
      data[SLAVE_DATA_WIDTH-1:MASTER_DATA_WIDTH] <= data[SLAVE_DATA_WIDTH-MASTER_DATA_WIDTH-1:0];
    end else begin
      data[SLAVE_DATA_WIDTH-MASTER_DATA_WIDTH-1:0] <= data[SLAVE_DATA_WIDTH-1:MASTER_DATA_WIDTH];
    end
  end
end

assign s_ready = ~valid || (m_ready && count == 'h0);
assign m_valid = valid;
assign m_data = BIG_ENDIAN == 1 ?
  data[SLAVE_DATA_WIDTH-1:SLAVE_DATA_WIDTH-MASTER_DATA_WIDTH] :
  data[MASTER_DATA_WIDTH-1:0];

end
endgenerate

endmodule
