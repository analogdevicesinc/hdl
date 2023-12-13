// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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

module up_ad5766_sequencer #(

  parameter   SEQ_ID = 0
) (
  input                 sequence_clk,
  input                 sequence_rst,
  input                 sequence_req,
  output  reg           sequence_valid,
  output  reg   [ 7:0]  sequence_data,

  input                 up_rstn,
  input                 up_clk,
  input                 up_wreq,
  input         [13:0]  up_waddr,
  input         [31:0]  up_wdata,
  output  reg           up_wack,
  input                 up_rreq,
  input         [13:0]  up_raddr,
  output  reg   [31:0]  up_rdata,
  output  reg           up_rack
);

  // registers

  reg           [ 7:0]  up_sequencer[15:0];
  reg           [ 3:0]  up_endof_seq = 4'b0;
  reg                   up_xfer_req = 1'b0;
  reg           [ 3:0]  sequence_counter = 0;

  // internal signals

  wire                  up_wreq_s;
  wire                  up_rreq_s;
  wire          [ 7:0]  sequencer[15:0];
  wire          [ 3:0]  end_of_sequence;

  integer               i;

  // sequence counter

  always @(posedge sequence_clk) begin
    if (sequence_rst) begin
      sequence_counter <= 4'b0;
    end else if (sequence_req) begin
      sequence_counter <= (sequence_counter == end_of_sequence) ? 0 : sequence_counter + 1;
    end
  end

  // sequence output mux

  always @(posedge sequence_clk) begin
    if (sequence_rst) begin
      sequence_data <= 16'b0;
    end
    else if (sequence_req) begin
      sequence_data <= sequencer[sequence_counter];
    end
    sequence_valid <= sequence_req;
  end

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == SEQ_ID) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == SEQ_ID) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      for (i=0; i<16; i=i+1) begin
        up_sequencer[i] <= 8'b0;
      end
      up_endof_seq <= 4'b0;
      up_wack <= 1'b0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h40)) begin
        up_sequencer[0] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h41)) begin
        up_sequencer[1] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h42)) begin
        up_sequencer[2] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h43)) begin
        up_sequencer[3] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h44)) begin
        up_sequencer[4] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h45)) begin
        up_sequencer[5] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h46)) begin
        up_sequencer[6] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h47)) begin
        up_sequencer[7] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h48)) begin
        up_sequencer[8] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h49)) begin
        up_sequencer[9] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h4a)) begin
        up_sequencer[10] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h4b)) begin
        up_sequencer[11] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h4c)) begin
        up_sequencer[12] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h4d)) begin
        up_sequencer[13] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h4e)) begin
        up_sequencer[14] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h4f)) begin
        up_sequencer[15] <= up_wdata[7:0];
        up_endof_seq <= (up_wdata[16]) ? up_waddr[3:0] : 4'b0;
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[7:0])
          8'h40 : up_rdata <= {24'b0, up_sequencer[0]};
          8'h41 : up_rdata <= {24'b0, up_sequencer[1]};
          8'h42 : up_rdata <= {24'b0, up_sequencer[2]};
          8'h43 : up_rdata <= {24'b0, up_sequencer[3]};
          8'h44 : up_rdata <= {24'b0, up_sequencer[4]};
          8'h45 : up_rdata <= {24'b0, up_sequencer[5]};
          8'h46 : up_rdata <= {24'b0, up_sequencer[6]};
          8'h47 : up_rdata <= {24'b0, up_sequencer[7]};
          8'h48 : up_rdata <= {24'b0, up_sequencer[8]};
          8'h49 : up_rdata <= {24'b0, up_sequencer[9]};
          8'h4a : up_rdata <= {24'b0, up_sequencer[10]};
          8'h4b : up_rdata <= {24'b0, up_sequencer[11]};
          8'h4c : up_rdata <= {24'b0, up_sequencer[12]};
          8'h4d : up_rdata <= {24'b0, up_sequencer[13]};
          8'h4e : up_rdata <= {24'b0, up_sequencer[14]};
          8'h4f : up_rdata <= {24'b0, up_sequencer[15]};
          8'h60 : up_rdata <= {27'b0, up_xfer_req, up_endof_seq};
        endcase
      end else begin
        up_rdata <= 32'b0;
      end
    end
  end

  // CDC

  up_xfer_cntrl #(
    .DATA_WIDTH(132)
  ) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({up_endof_seq,
                     up_sequencer[0],
                     up_sequencer[1],
                     up_sequencer[2],
                     up_sequencer[3],
                     up_sequencer[4],
                     up_sequencer[5],
                     up_sequencer[6],
                     up_sequencer[7],
                     up_sequencer[8],
                     up_sequencer[9],
                     up_sequencer[10],
                     up_sequencer[11],
                     up_sequencer[12],
                     up_sequencer[13],
                     up_sequencer[14],
                     up_sequencer[15]}),
    .up_xfer_done (up_cntrl_xfer_done),
    .d_rst (sequence_rst),
    .d_clk (sequence_clk),
    .d_data_cntrl ({end_of_sequence,
                    sequencer[0],
                    sequencer[1],
                    sequencer[2],
                    sequencer[3],
                    sequencer[4],
                    sequencer[5],
                    sequencer[6],
                    sequencer[7],
                    sequencer[8],
                    sequencer[9],
                    sequencer[10],
                    sequencer[11],
                    sequencer[12],
                    sequencer[13],
                    sequencer[14],
                    sequencer[15]}));

endmodule
