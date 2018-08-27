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

module cn0363_dma_sequencer (
  input clk,
  input resetn,

  input [31:0] phase,
  input phase_valid,
  output reg phase_ready,

  input [23:0] data,
  input data_valid,
  output reg data_ready,

  input [31:0] data_filtered,
  input data_filtered_valid,
  output reg data_filtered_ready,

  input [31:0] i_q,
  input i_q_valid,
  output reg i_q_ready,

  input [31:0] i_q_filtered,
  input i_q_filtered_valid,
  output reg i_q_filtered_ready,

  output overflow,

  output reg [31:0] dma_wr_data,
  output reg dma_wr_en,
  output reg dma_wr_sync,
  input dma_wr_overflow,
  input dma_wr_xfer_req,

  input [13:0] channel_enable,

  output processing_resetn
);

reg [3:0] count = 'h00;

assign overflow = dma_wr_overflow;
assign processing_resetn = dma_wr_xfer_req;

always @(posedge clk) begin
  if (processing_resetn == 1'b0) begin
    count <= 'h0;
  end else begin
    case (count)
    'h0: if (phase_valid) count <= count + 1;
    'h1: if (data_valid) count <= count + 1;
    'h2: if (data_filtered_valid) count <= count + 1;
    'h3: if (i_q_valid) count <= count + 1;
    'h4: if (i_q_valid) count <= count + 1;
    'h5: if (i_q_filtered_valid) count <= count + 1;
    'h6: if (i_q_filtered_valid) count <= count + 1;
    'h7: if (phase_valid) count <= count + 1;
    'h8: if (data_valid) count <= count + 1;
    'h9: if (data_filtered_valid) count <= count + 1;
    'ha: if (i_q_valid) count <= count + 1;
    'hb: if (i_q_valid) count <= count + 1;
    'hc: if (i_q_filtered_valid) count <= count + 1;
    'hd: if (i_q_filtered_valid) count <= 'h00;
    endcase
  end
end

always @(posedge clk) begin
  case (count)
  'h0: dma_wr_data <= phase;
  'h1: dma_wr_data <= {8'h00,data[23:0]};
  'h2: dma_wr_data <= data_filtered;
  'h3: dma_wr_data <= i_q;
  'h4: dma_wr_data <= i_q;
  'h5: dma_wr_data <= i_q_filtered;
  'h6: dma_wr_data <= i_q_filtered;
  'h7: dma_wr_data <= phase;
  'h8: dma_wr_data <= {8'h00,data[23:0]};
  'h9: dma_wr_data <= data_filtered;
  'ha: dma_wr_data <= i_q;
  'hb: dma_wr_data <= i_q;
  'hc: dma_wr_data <= i_q_filtered;
  'hd: dma_wr_data <= i_q_filtered;
  endcase
end

always @(posedge clk) begin
  if (processing_resetn == 1'b0 || channel_enable[count] == 1'b0) begin
    dma_wr_en <= 1'b0;
  end else begin
    case (count)
    'h0: dma_wr_en <= phase_valid;
    'h1: dma_wr_en <= data_valid;
    'h2: dma_wr_en <= data_filtered_valid;
    'h3: dma_wr_en <= i_q_valid;
    'h4: dma_wr_en <= i_q_valid;
    'h5: dma_wr_en <= i_q_filtered_valid;
    'h6: dma_wr_en <= i_q_filtered_valid;
    'h7: dma_wr_en <= phase_valid;
    'h8: dma_wr_en <= data_valid;
    'h9: dma_wr_en <= data_filtered_valid;
    'ha: dma_wr_en <= i_q_valid;
    'hb: dma_wr_en <= i_q_valid;
    'hc: dma_wr_en <= i_q_filtered_valid;
    'hd: dma_wr_en <= i_q_filtered_valid;
    endcase
  end
end

always @(posedge clk) begin
  if (count == 'h00) begin
    dma_wr_sync <= 1'b1;
  end else if (dma_wr_en == 1'b1) begin
    dma_wr_sync = 1'b0;
  end
end

always @(*) begin
  case (count)
  'h0: phase_ready <= 1'b1;
  'h7: phase_ready <= 1'b1;
  default: phase_ready <= 1'b0;
  endcase
end

always @(*) begin
  case (count)
  'h1: data_ready <= 1'b1;
  'h8: data_ready <= 1'b1;
  default: data_ready <= 1'b0;
  endcase
end

always @(*) begin
  case (count)
  'h2: data_filtered_ready <= 1'b1;
  'h9: data_filtered_ready <= 1'b1;
  default: data_filtered_ready <= 1'b0;
  endcase
end

always @(*) begin
  case (count)
  'h3: i_q_ready <= 1'b1;
  'h4: i_q_ready <= 1'b1;
  'ha: i_q_ready <= 1'b1;
  'hb: i_q_ready <= 1'b1;
  default: i_q_ready <= 1'b0;
  endcase
end

always @(*) begin
  case (count)
  'h5: i_q_filtered_ready <= 1'b1;
  'h6: i_q_filtered_ready <= 1'b1;
  'hc: i_q_filtered_ready <= 1'b1;
  'hd: i_q_filtered_ready <= 1'b1;
  default: i_q_filtered_ready <= 1'b0;
  endcase
end

endmodule
