// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

module header_inserter #(

  parameter AXIS_DATA_WIDTH = 16,
  parameter HEADER_WIDTH = 8
) (

  input  wire                         clk,
  input  wire                         rstn,

  // Header
  input  wire [HEADER_WIDTH-1:0]      header,

  // Input
  output reg                          input_axis_tready,
  input  wire                         input_axis_tvalid,
  input  wire [AXIS_DATA_WIDTH-1:0]   input_axis_tdata,
  input  wire [AXIS_DATA_WIDTH/8-1:0] input_axis_tkeep,
  input  wire                         input_axis_tlast,

  // Output
  input  wire                         output_axis_tready,
  output wire                         output_axis_tvalid,
  output wire [AXIS_DATA_WIDTH-1:0]   output_axis_tdata,
  output wire [AXIS_DATA_WIDTH/8-1:0] output_axis_tkeep,
  output wire                         output_axis_tlast
);

  localparam HEADER_PARTS = (HEADER_WIDTH > AXIS_DATA_WIDTH) ? (HEADER_WIDTH-1)/AXIS_DATA_WIDTH : 0;

  localparam SPLIT_PAYLOAD = (HEADER_WIDTH % AXIS_DATA_WIDTH) ? 1 : 0;

  localparam TEMP_WIDTH = (HEADER_WIDTH < AXIS_DATA_WIDTH) ? HEADER_WIDTH :
    ((SPLIT_PAYLOAD) ? HEADER_WIDTH % AXIS_DATA_WIDTH : AXIS_DATA_WIDTH);

  localparam BYPASS_WIDTH = AXIS_DATA_WIDTH-TEMP_WIDTH;

  reg [$clog2(HEADER_PARTS):0] header_part_counter;

  reg new_packet;

  reg                          buffer_axis_tvalid;
  wire                         buffer_axis_tready;
  reg  [AXIS_DATA_WIDTH-1:0]   buffer_axis_tdata;
  reg  [AXIS_DATA_WIDTH/8-1:0] buffer_axis_tkeep;
  reg                          buffer_axis_tlast;

  reg [TEMP_WIDTH-1:0]   temp_axis_tdata;
  reg [TEMP_WIDTH/8-1:0] temp_axis_tkeep;
  reg                    temp_axis_tlast;

  // temporary storage
  always @(posedge clk)
  begin
    if (!rstn) begin
      temp_axis_tdata <= {TEMP_WIDTH{1'b0}};
      temp_axis_tkeep <= {TEMP_WIDTH/8{1'b0}};
      temp_axis_tlast <= 1'b0;
    end else begin
      if (input_axis_tvalid && input_axis_tready) begin
        temp_axis_tdata <= input_axis_tdata[AXIS_DATA_WIDTH-1:BYPASS_WIDTH];
        temp_axis_tkeep <= input_axis_tkeep[AXIS_DATA_WIDTH/8-1:BYPASS_WIDTH/8];
        temp_axis_tlast <= input_axis_tlast;
      end else if (buffer_axis_tvalid) begin
        temp_axis_tlast <= 1'b0;
      end
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      header_part_counter <= 'd0;
    end else begin
      if (buffer_axis_tready) begin
        if (((SPLIT_PAYLOAD) ? new_packet && (header_part_counter != HEADER_PARTS && (header_part_counter < HEADER_PARTS || (input_axis_tvalid && input_axis_tready))) : new_packet && header_part_counter != HEADER_PARTS)) begin
          header_part_counter <= header_part_counter + 1;
        end else if (input_axis_tready && input_axis_tvalid && !new_packet) begin
          header_part_counter <= 'd0;
        end
      end
    end
  end

  generate

    if (SPLIT_PAYLOAD) begin

      reg [BYPASS_WIDTH-1:0]   bypass_axis_tdata;
      reg [BYPASS_WIDTH/8-1:0] bypass_axis_tkeep;
      reg                      bypass_axis_tlast;

      reg no_remainder;

      always @(*)
      begin
        bypass_axis_tdata = input_axis_tdata[BYPASS_WIDTH-1:0];
        bypass_axis_tkeep = input_axis_tkeep[BYPASS_WIDTH/8-1:0];
        bypass_axis_tlast = input_axis_tlast;
      end

      // ready signal generation
      always @(*)
      begin
        input_axis_tready = buffer_axis_tready && (!new_packet || header_part_counter == HEADER_PARTS) && (!temp_axis_tlast || new_packet);
      end

      always @(posedge clk)
      begin
        if (!rstn) begin
          no_remainder <= 1'b0;
        end else begin
          if (input_axis_tkeep[AXIS_DATA_WIDTH/8-1:BYPASS_WIDTH/8] && input_axis_tlast) begin
            no_remainder <= 1'b0;
          end else begin
            no_remainder <= 1'b1;
          end
        end
      end

      // new packet marking
      always @(posedge clk)
      begin
        if (!rstn) begin
          new_packet <= 1'b1;
        end else begin
          if (buffer_axis_tready) begin
            if (header_part_counter == HEADER_PARTS && input_axis_tvalid && new_packet) begin
              new_packet <= 1'b0;
            end else if (((input_axis_tkeep[AXIS_DATA_WIDTH/8-1:BYPASS_WIDTH/8]) ? temp_axis_tlast : bypass_axis_tlast) || (temp_axis_tlast && !no_remainder)) begin
              new_packet <= 1'b1;
            end
          end
        end
      end

      // header insertion
      always @(posedge clk)
      begin
        if (!rstn) begin
          buffer_axis_tvalid <= 1'b0;
          buffer_axis_tdata <= {AXIS_DATA_WIDTH-1{1'b0}};
          buffer_axis_tkeep <= {AXIS_DATA_WIDTH/8-1{1'b0}};
          buffer_axis_tlast <= 1'b0;
        end else begin
          if (buffer_axis_tready) begin
            buffer_axis_tvalid <= (new_packet && header_part_counter != HEADER_PARTS) || (input_axis_tvalid && input_axis_tready) || (temp_axis_tlast && !no_remainder);

            if (HEADER_PARTS) begin

              if (new_packet && header_part_counter < HEADER_PARTS) begin
                buffer_axis_tdata <= header[header_part_counter*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH];
                buffer_axis_tkeep <= {AXIS_DATA_WIDTH/8{1'b1}};
                buffer_axis_tlast <= 1'b0;
              end else if (new_packet && header_part_counter == HEADER_PARTS) begin
                buffer_axis_tdata <= {bypass_axis_tdata, header[header_part_counter*AXIS_DATA_WIDTH +: TEMP_WIDTH]};
                buffer_axis_tkeep <= {bypass_axis_tkeep, {HEADER_WIDTH/8{1'b1}}};
                buffer_axis_tlast <= 1'b0;
              end else if (!temp_axis_tlast) begin
                buffer_axis_tdata <= {bypass_axis_tdata, temp_axis_tdata};
                buffer_axis_tkeep <= {bypass_axis_tkeep, temp_axis_tkeep};
                buffer_axis_tlast <= (input_axis_tkeep[AXIS_DATA_WIDTH/8-1:BYPASS_WIDTH/8]) ? 1'b0 : bypass_axis_tlast;
              end else begin
                buffer_axis_tdata <= {{BYPASS_WIDTH{1'b0}}, temp_axis_tdata};
                buffer_axis_tkeep <= {{BYPASS_WIDTH/8{1'b0}}, temp_axis_tkeep};
                buffer_axis_tlast <= temp_axis_tlast;
              end

            end else begin

              if (new_packet) begin
                buffer_axis_tdata <= {bypass_axis_tdata, header};
                buffer_axis_tkeep <= {bypass_axis_tkeep, {HEADER_WIDTH/8{1'b1}}};
                buffer_axis_tlast <= 1'b0;
              end else if (!temp_axis_tlast) begin
                buffer_axis_tdata <= {bypass_axis_tdata, temp_axis_tdata};
                buffer_axis_tkeep <= {bypass_axis_tkeep, temp_axis_tkeep};
                buffer_axis_tlast <= (input_axis_tkeep[AXIS_DATA_WIDTH/8-1:BYPASS_WIDTH/8]) ? 1'b0 : bypass_axis_tlast;
              end else begin
                buffer_axis_tdata <= {{BYPASS_WIDTH{1'b0}}, temp_axis_tdata};
                buffer_axis_tkeep <= {{BYPASS_WIDTH/8{1'b0}}, temp_axis_tkeep};
                buffer_axis_tlast <= temp_axis_tlast;
              end

            end

          end
        end
      end

    end else begin

      // ready signal generation
      always @(*)
      begin
        input_axis_tready = buffer_axis_tready && !new_packet;
      end

      // new packet marking
      always @(posedge clk)
      begin
        if (!rstn) begin
          new_packet <= 1'b1;
        end else begin
          if (buffer_axis_tready) begin
            if (input_axis_tlast && input_axis_tvalid) begin
              new_packet <= 1'b1;
            end else if (header_part_counter == HEADER_PARTS) begin
              new_packet <= 1'b0;
            end
          end
        end
      end

      // header insertion
      always @(posedge clk)
      begin
        if (!rstn) begin
          buffer_axis_tvalid <= 1'b0;
          buffer_axis_tdata <= {AXIS_DATA_WIDTH-1{1'b0}};
          buffer_axis_tkeep <= {AXIS_DATA_WIDTH/8-1{1'b0}};
          buffer_axis_tlast <= 1'b0;
        end else begin
          if (buffer_axis_tready) begin
            buffer_axis_tvalid <= new_packet || (input_axis_tvalid && input_axis_tready);

            if (HEADER_PARTS) begin

              if (new_packet) begin
                buffer_axis_tdata <= header[header_part_counter*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH];
                buffer_axis_tkeep <= {AXIS_DATA_WIDTH/8{1'b1}};
                buffer_axis_tlast <= 1'b0;
              end else begin
                buffer_axis_tdata <= input_axis_tdata;
                buffer_axis_tkeep <= input_axis_tkeep;
                buffer_axis_tlast <= input_axis_tlast;
              end

            end else begin

              if (new_packet) begin
                buffer_axis_tdata <= header;
                buffer_axis_tkeep <= {AXIS_DATA_WIDTH/8{1'b1}};
                buffer_axis_tlast <= 1'b0;
              end else begin
                buffer_axis_tdata <= input_axis_tdata;
                buffer_axis_tkeep <= input_axis_tkeep;
                buffer_axis_tlast <= input_axis_tlast;
              end

            end

          end
        end
      end

    end

  endgenerate

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH(2),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(),
    .ALMOST_FULL_THRESHOLD(),
    .TLAST_EN(1),
    .TKEEP_EN(1),
    .REMOVE_NULL_BEAT_EN(0)
  ) packet_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(output_axis_tready),
    .m_axis_valid(output_axis_tvalid),
    .m_axis_data(output_axis_tdata),
    .m_axis_tkeep(output_axis_tkeep),
    .m_axis_tlast(output_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_full(),
    .m_axis_almost_full(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(buffer_axis_tready),
    .s_axis_valid(buffer_axis_tvalid),
    .s_axis_data(buffer_axis_tdata),
    .s_axis_tkeep(buffer_axis_tkeep),
    .s_axis_tlast(buffer_axis_tlast),
    .s_axis_room(),
    .s_axis_empty(),
    .s_axis_almost_empty(),
    .s_axis_full(),
    .s_axis_almost_full());

endmodule
