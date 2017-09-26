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

module avl_dacfifo_rd #(

  parameter     AVL_DATA_WIDTH = 512,
  parameter     DAC_DATA_WIDTH = 64,
  parameter     AVL_DDR_BASE_ADDRESS = 0,
  parameter     AVL_DDR_ADDRESS_LIMIT = 1048576,
  parameter     DAC_MEM_ADDRESS_WIDTH = 8)(

  input                                     dac_clk,
  input                                     dac_reset,
  input                                     dac_valid,
  output  reg [(DAC_DATA_WIDTH-1):0]        dac_data,
  output  reg                               dac_xfer_req,
  output  reg                               dac_dunf,

  input                                     avl_clk,
  input                                     avl_reset,
  output  reg [24:0]                        avl_address,
  output  reg [ 5:0]                        avl_burstcount,
  output  reg [63:0]                        avl_byteenable,
  input                                     avl_ready,
  input                                     avl_readdatavalid,
  output  reg                               avl_read,
  input       [AVL_DATA_WIDTH-1:0]          avl_data,

  input       [24:0]                        avl_last_address,
  input       [63:0]                        avl_last_byteenable,
  input                                     avl_xfer_req);

  // Max supported MEM_RATIO is 16
  localparam  MEM_RATIO = AVL_DATA_WIDTH/DAC_DATA_WIDTH;
  localparam  AVL_MEM_ADDRESS_WIDTH = (MEM_RATIO ==  1) ?  DAC_MEM_ADDRESS_WIDTH :
                                      (MEM_RATIO ==  2) ? (DAC_MEM_ADDRESS_WIDTH - 1) :
                                      (MEM_RATIO ==  4) ? (DAC_MEM_ADDRESS_WIDTH - 2) :
                                      (MEM_RATIO ==  8) ? (DAC_MEM_ADDRESS_WIDTH - 3) :
                                      (MEM_RATIO == 16) ? (DAC_MEM_ADDRESS_WIDTH - 4) :
                                                          (DAC_MEM_ADDRESS_WIDTH - 5);
  localparam  AVL_MEM_THRESHOLD_LO = 8;
  localparam  AVL_MEM_THRESHOLD_HI = {(AVL_MEM_ADDRESS_WIDTH){1'b1}} - 7;

  localparam  MEM_WIDTH_DIFF = (MEM_RATIO > 16) ? 5 :
                               (MEM_RATIO >  8) ? 4 :
                               (MEM_RATIO >  4) ? 3 :
                               (MEM_RATIO >  2) ? 2 :
                               (MEM_RATIO >  1) ? 1 : 1;
  // internal register

  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_wr_address;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_wr_address_g;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address_m1;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address_m2;
  reg                                       avl_mem_wr_enable;
  reg                                       avl_mem_request_data;
  reg         [AVL_DATA_WIDTH-1:0]          avl_mem_data;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_address_diff;
  reg                                       avl_read_inprogress;
  reg                                       avl_last_transfer;

  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_wr_address;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_wr_address_m1;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_wr_address_m2;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_wr_last_address;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_rd_address;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_rd_address_g;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_address_diff;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_rd_last_address;
  reg                                       dac_mem_last_transfer_active;

  reg                                       dac_avl_xfer_req;
  reg                                       dac_avl_xfer_req_m1;
  reg                                       dac_avl_xfer_req_m2;

  reg                                       dac_avl_last_transfer_m1;
  reg                                       dac_avl_last_transfer_m2;
  reg                                       dac_avl_last_transfer;
  reg         [MEM_WIDTH_DIFF-1:0]          dac_avl_last_beats_m1;
  reg         [MEM_WIDTH_DIFF-1:0]          dac_avl_last_beats_m2;
  reg         [MEM_WIDTH_DIFF-1:0]          dac_avl_last_beats;

  // internal signals

  wire        [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address_s;
  wire        [AVL_MEM_ADDRESS_WIDTH:0]     avl_mem_address_diff_s;
  wire        [DAC_MEM_ADDRESS_WIDTH:0]     dac_mem_address_diff_s;

  wire        [DAC_MEM_ADDRESS_WIDTH:0]     dac_mem_wr_address_s;
  wire        [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_wr_address_g2b_s;
  wire        [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_wr_address_b2g_s;
  wire        [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address_g2b_s;
  wire        [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_rd_address_b2g_s;
  wire                                      dac_mem_rd_enable_s;
  wire        [DAC_DATA_WIDTH-1:0]          dac_mem_data_s;

  wire        [MEM_WIDTH_DIFF-1:0]          avl_last_beats_s;
  wire                                      avl_last_transfer_s;
  wire                                      avl_read_en_s;
  wire                                      avl_mem_wr_enable_s;
  wire                                      avl_last_readdatavalid_s;

  // ==========================================================================
  // An asymmetric memory to transfer data from Avalon interface to DAC
  // interface
  // ==========================================================================

  alt_mem_asym_rd i_mem_asym (
    .mem_i_wrclock (avl_clk),
    .mem_i_wren (avl_mem_wr_enable),
    .mem_i_wraddress (avl_mem_wr_address),
    .mem_i_datain (avl_mem_data),
    .mem_i_rdclock (dac_clk),
    .mem_i_rdaddress (dac_mem_rd_address),
    .mem_o_dataout (dac_mem_data_s));

  // ==========================================================================
  // Avalon Memory Mapped interface access
  // ==========================================================================

  // Avalon address generation and read control signaling

  always @(posedge avl_clk) begin
    if ((avl_reset == 1'b1) || (avl_xfer_req == 1'b0)) begin
      avl_address <= AVL_DDR_BASE_ADDRESS;
    end else begin
      if (avl_readdatavalid == 1'b1) begin
        avl_address <= (avl_address < avl_last_address) ? avl_address + 1 : 0;
      end
    end
  end

  assign avl_read_en_s = avl_xfer_req & avl_mem_request_data;

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_read <= 1'b0;
      avl_read_inprogress <= 1'b0;
    end else begin
      if ((avl_read_inprogress == 1'b0) && (avl_read_en_s == 1'b1)) begin
        avl_read <= 1'b1;
        avl_read_inprogress <= 1'b1;
      end else if (avl_read_inprogress == 1'b1) begin
        avl_read <= 1'b0;
        if (avl_readdatavalid == 1'b1) begin
          avl_read_inprogress <= 1'b0;
        end
      end
    end
  end

  assign avl_last_transfer_s = (avl_address == avl_last_address) ? 1'b1 : 1'b0;
  always @(posedge avl_clk) begin
    avl_burstcount <= 1'b1;
    avl_byteenable <= (avl_last_transfer_s) ? avl_last_byteenable : {64{1'b1}};
    avl_last_transfer <= avl_last_transfer_s;
  end

  // write data from Avalon interface into the async FIFO

  assign avl_mem_wr_enable_s = avl_readdatavalid & avl_ready;
  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_mem_data <= 0;
      avl_mem_wr_enable <= 0;
    end else begin
      avl_mem_wr_enable <= avl_mem_wr_enable_s;
      if (avl_mem_wr_enable_s == 1'b1) begin
        avl_mem_data <= avl_data;
      end
    end
  end

  always @(posedge avl_clk) begin
    if ((avl_reset == 1'b1) || (avl_xfer_req == 1'b0)) begin
      avl_mem_wr_address <= 0;
      avl_mem_wr_address_g <= 0;
    end else begin
      if (avl_mem_wr_enable == 1'b1) begin
        avl_mem_wr_address <= avl_mem_wr_address + 1;
      end
      avl_mem_wr_address_g <= avl_mem_wr_address_b2g_s;
    end
  end

  ad_b2g #(
    .DATA_WIDTH(AVL_MEM_ADDRESS_WIDTH)
  ) i_avl_mem_wr_address_b2g (
    .din (avl_mem_wr_address),
    .dout (avl_mem_wr_address_b2g_s));

  // ==========================================================================
  // control the FIFO to prevent overflow, underflow is monitored
  // ==========================================================================

  assign avl_mem_rd_address_s = (MEM_RATIO ==  1) ? avl_mem_rd_address :
                                (MEM_RATIO ==  2) ? avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):1] :
                                (MEM_RATIO ==  4) ? avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):2] :
                                (MEM_RATIO ==  8) ? avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):3] :
                                (MEM_RATIO == 16) ? avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):4] :
                                                    avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):5];

  assign avl_mem_address_diff_s = {1'b1, avl_mem_wr_address} - avl_mem_rd_address_s;

  always @(posedge avl_clk) begin
    if (avl_xfer_req == 1'b0) begin
      avl_mem_address_diff <= 'd0;
      avl_mem_rd_address <= 'd0;
      avl_mem_rd_address_m1 <= 'd0;
      avl_mem_rd_address_m2 <= 'd0;
      avl_mem_request_data <= 'd0;
    end else begin
      avl_mem_rd_address_m1 <= dac_mem_rd_address_g;
      avl_mem_rd_address_m2 <= avl_mem_rd_address_m1;
      avl_mem_rd_address <= avl_mem_rd_address_g2b_s;
      avl_mem_address_diff <= avl_mem_address_diff_s[AVL_MEM_ADDRESS_WIDTH-1:0];
      if (avl_mem_address_diff >= AVL_MEM_THRESHOLD_HI) begin
        avl_mem_request_data <= 1'b0;
      end else if (avl_mem_address_diff <= AVL_MEM_THRESHOLD_LO) begin
        avl_mem_request_data <= 1'b1;
      end
    end
  end

  ad_g2b #(
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_avl_mem_rd_address_g2b (
    .din (avl_mem_rd_address_m2),
    .dout (avl_mem_rd_address_g2b_s));

  avl_dacfifo_byteenable_decoder #(
    .MEM_RATIO (MEM_RATIO),
    .LAST_BEATS_WIDTH (MEM_WIDTH_DIFF)
  ) i_byteenable_decoder (
    .avl_clk (avl_clk),
    .avl_byteenable (avl_last_byteenable),
    .avl_enable (1'b1),
    .avl_last_beats (avl_last_beats_s)
  );

  // ==========================================================================
  // Push data from the async FIFO to the DAC
  // Data flow is controlled by the DAC, no back-pressure. If FIFO is not
  // ready, data will be dropped
  // ==========================================================================

  assign dac_mem_wr_address_s = (MEM_RATIO ==  1) ?  dac_mem_wr_address :
                                (MEM_RATIO ==  2) ? {dac_mem_wr_address, 1'b0} :
                                (MEM_RATIO ==  4) ? {dac_mem_wr_address, 2'b0} :
                                (MEM_RATIO ==  8) ? {dac_mem_wr_address, 3'b0} :
                                (MEM_RATIO == 16) ? {dac_mem_wr_address, 4'b0} :
                                                    {dac_mem_wr_address, 5'b0};

  assign dac_mem_address_diff_s = {1'b1, dac_mem_wr_address_s} - dac_mem_rd_address;

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_mem_wr_address_m2 <= 0;
      dac_mem_wr_address_m1 <= 0;
      dac_mem_wr_address <= 0;
      dac_mem_wr_last_address <= 0;
    end else begin
      dac_mem_wr_address_m1 <= avl_mem_wr_address_g;
      dac_mem_wr_address_m2 <= dac_mem_wr_address_m1;
      dac_mem_wr_address <= dac_mem_wr_address_g2b_s;
      dac_mem_wr_last_address <= (dac_avl_last_transfer == 1'b1) ? dac_mem_wr_address_s : dac_mem_wr_last_address;
    end
  end

  ad_g2b #(
    .DATA_WIDTH(AVL_MEM_ADDRESS_WIDTH)
  ) i_dac_mem_wr_address_g2b (
    .din (dac_mem_wr_address_m2),
    .dout (dac_mem_wr_address_g2b_s));

  assign avl_last_readdatavalid_s = (avl_last_transfer & avl_readdatavalid);
  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_avl_last_transfer_m1 <= 0;
      dac_avl_last_transfer_m2 <= 0;
      dac_avl_last_transfer <= 0;
    end else begin
      dac_avl_last_transfer_m1 <= avl_last_readdatavalid_s;
      dac_avl_last_transfer_m2 <= dac_avl_last_transfer_m1;
      dac_avl_last_transfer <= dac_avl_last_transfer_m2;
    end
  end

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_avl_xfer_req_m2 <= 0;
      dac_avl_xfer_req_m1 <= 0;
      dac_avl_xfer_req <= 0;
    end else begin
      dac_avl_xfer_req_m1 <= avl_xfer_req;
      dac_avl_xfer_req_m2 <= dac_avl_xfer_req_m1;
      dac_avl_xfer_req <= dac_avl_xfer_req_m2;
    end
  end

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_mem_last_transfer_active <= 1'b0;
    end else begin
      if (dac_avl_last_transfer == 1'b1) begin
        dac_mem_last_transfer_active <= 1'b1;
      end else if (dac_mem_rd_address == dac_mem_rd_last_address) begin
        dac_mem_last_transfer_active <= 1'b0;
      end
    end
  end

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_avl_last_beats_m2 <= 0;
      dac_avl_last_beats_m1 <= 0;
      dac_avl_last_beats <= 0;
    end else begin
      dac_avl_last_beats_m1 <= avl_last_beats_s;
      dac_avl_last_beats_m2 <= dac_avl_last_beats_m1;
      dac_avl_last_beats <= dac_avl_last_beats_m2;
    end
  end

  assign dac_mem_rd_enable_s = (dac_mem_address_diff[DAC_MEM_ADDRESS_WIDTH-1:0] == 1'b0) ? 0 : (dac_xfer_req & dac_valid);
  always @(posedge dac_clk) begin
    if ((dac_reset == 1'b1) || ((dac_avl_xfer_req == 1'b0) && (dac_xfer_req == 1'b0))) begin
      dac_mem_rd_address <= 0;
      dac_mem_rd_address_g <= 0;
      dac_mem_address_diff <= 0;
      dac_mem_rd_last_address <= 0;
    end else begin
      dac_mem_address_diff <= dac_mem_address_diff_s[DAC_MEM_ADDRESS_WIDTH-1:0];
      dac_mem_rd_last_address <= dac_mem_wr_last_address + dac_avl_last_beats;
      if (dac_mem_rd_enable_s == 1'b1) begin
        dac_mem_rd_address <= ((dac_mem_rd_address == dac_mem_rd_last_address) && (dac_mem_last_transfer_active == 1'b1)) ?
                                                            (dac_mem_wr_last_address + {MEM_WIDTH_DIFF{1'b1}} + 1) :
                                                            (dac_mem_rd_address + 1);
      end
      dac_mem_rd_address_g <= dac_mem_rd_address_b2g_s;
    end
  end

  ad_b2g #(
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_dac_mem_rd_address_b2g (
    .din (dac_mem_rd_address),
    .dout (dac_mem_rd_address_b2g_s));

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_xfer_req <= 0;
    end else begin
      if ((dac_avl_xfer_req == 1'b1) && (dac_mem_address_diff > 0)) begin
        dac_xfer_req <= 1'b1;
      end else if ((dac_avl_xfer_req == 1'b0) && (dac_mem_address_diff_s[DAC_MEM_ADDRESS_WIDTH-1:0] == 0)) begin
        dac_xfer_req <= 1'b0;
      end
    end
  end

  always @(posedge dac_clk) begin
    if ((dac_reset == 1'b1) || (dac_xfer_req == 1'b0)) begin
      dac_data <= 0;
    end else begin
      dac_data <= dac_mem_data_s;
    end
  end

  always @(posedge dac_clk) begin
    if ((dac_reset == 1'b1) || (dac_xfer_req == 1'b0)) begin
      dac_dunf <= 1'b0;
    end else begin
      dac_dunf <= (dac_mem_address_diff == 0) ? 1'b1 : 1'b0;
    end
  end

endmodule

