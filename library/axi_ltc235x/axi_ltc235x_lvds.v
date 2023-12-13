// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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

module axi_ltc235x_lvds #(
  parameter XILINX_INTEL_N = 0,
  parameter LTC235X_FAMILY = 0,
  parameter NUM_CHANNELS = 8,	// 8 for 2358, 4 for 2357, 2 for 2353
  parameter DATA_WIDTH = 18	// 18 or 16 based on -18/-16
) (

  input                   rst,
  input                   clk,
  input       [ 7:0]      adc_enable,
  input       [23:0]      softspan_next,

  // physical interface

  output                  scki_p,
  output                  scki_n,
  output                  sdi_p,
  output                  sdi_n,
  input                   scko_p,
  input                   scko_n,
  input                   sdo_p,
  input                   sdo_n,
  input                   busy,

  // FIFO interface

  output      [ 2:0]      adc_ch0_id,
  output      [ 2:0]      adc_ch1_id,
  output      [ 2:0]      adc_ch2_id,
  output      [ 2:0]      adc_ch3_id,
  output      [ 2:0]      adc_ch4_id,
  output      [ 2:0]      adc_ch5_id,
  output      [ 2:0]      adc_ch6_id,
  output      [ 2:0]      adc_ch7_id,

  output      [31:0]      adc_data_0,
  output      [31:0]      adc_data_1,
  output      [31:0]      adc_data_2,
  output      [31:0]      adc_data_3,
  output      [31:0]      adc_data_4,
  output      [31:0]      adc_data_5,
  output      [31:0]      adc_data_6,
  output      [31:0]      adc_data_7,

  output      [ 2:0]      adc_softspan_0,
  output      [ 2:0]      adc_softspan_1,
  output      [ 2:0]      adc_softspan_2,
  output      [ 2:0]      adc_softspan_3,
  output      [ 2:0]      adc_softspan_4,
  output      [ 2:0]      adc_softspan_5,
  output      [ 2:0]      adc_softspan_6,
  output      [ 2:0]      adc_softspan_7,

  output reg              adc_valid
);

  // local parameters

  localparam DW = 24;     // packet size per channel
  localparam DW_8 = 24 * 8; // packet size for all 8 channels
  localparam BW = DW - 1;
  localparam BW_8 = DW_8 - 1;

  // internal registers

  reg        busy_m1;
  reg        busy_m2;
  reg        busy_m3;

  reg [ 8:0] scki_counter = 9'h0;
  reg [ 8:0] data_counter = 9'h0;

  reg        scki_i;
  reg        scki_d;

  reg [BW_8:0] adc_lane;
  reg [BW_8:0] adc_data_init;
  reg [  BW:0] adc_data_store[7:0];

  reg        adc_valid_init;
  reg        adc_valid_init_d;

  reg        ch_data_lock = 1;
  reg        ch_capture;
  reg        ch_captured;

  reg        scko_d;
  reg        sdo_d;

  reg [ 4:0] sdi_index = 5'd23;

  reg [23:0] softspan_next_int;

  // internal wires

  wire        start_transfer_s;

  wire        scki_cnt_rst;

  wire        acquire_data;

  wire [DATA_WIDTH-1:0] adc_data_raw_s [7:0];
  wire [31:0] adc_data_sign_s [7:0];
  wire [31:0] adc_data_zero_s [7:0];
  wire [31:0] adc_data_s [7:0];
  wire [ 2:0] adc_ch_id_s [7:0];
  wire [ 2:0] adc_softspan_s [7:0];

  wire        scki_s;
  wire        sdi_s;
  wire        scko_s;
  wire        sdo_s;

  generate
    if (XILINX_INTEL_N == 0) begin
      assign scki_p = scki_s;
      assign scki_n = 1'b0;
      assign sdi_p = sdi_s;
      assign sdi_n = 1'b0;
      assign scko_s = scko_p;
      assign sdo_s = sdo_p;
    end else begin
      OBUFDS obufds_scki (
        .O(scki_n),
        .OB(scki_p),
        .I(scki_s));

      OBUFDS obufds_sdi (
        .O(sdi_n),
        .OB(sdi_p),
        .I(sdi_s));

      IBUFDS #(
        .CCIO_EN_M("TRUE"),
        .CCIO_EN_S("TRUE")
      ) ibufds_scko (
        .O(scko_s),
        .I(scko_p),
        .IB(scko_n));

      IBUFDS #(
        .CCIO_EN_M("TRUE"),
        .CCIO_EN_S("TRUE")
      ) ibufds_sdo (
        .O(sdo_s),
        .I(sdo_p),
        .IB(sdo_n));
    end
  endgenerate

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      busy_m1 <= 1'b0;
      busy_m2 <= 1'b0;
    end else begin
      busy_m1 <= busy;
      busy_m2 <= busy_m1;
      busy_m3 <= busy_m2;
    end
  end

  assign start_transfer_s = busy_m3 & ~busy_m2;

  // reading clock logic
  always @(posedge clk) begin
    if (rst) begin
      scki_counter <= 9'h0;
      scki_i <= 1'b0;
      scki_d <=  1'b0;
    end else begin
      scki_d <= scki_i;
      if (acquire_data == 1'b0) begin
        scki_counter <= 9'h0;
        scki_i <= 1'b0;
      end else if (scki_cnt_rst & (scki_d != scki_i)) begin // end of a capture
        scki_counter <= 9'h1;
        scki_i <= 1'b0;
      end else begin
        scki_counter <= scki_counter + 9'd1;
        scki_i <= ~scki_i;
      end
    end
  end

  assign scki_cnt_rst = (scki_counter == DW_8);
  assign scki_s = scki_i & acquire_data;

  // capture data per lane in rx buffer on every edge of scko_s
  // ignore when busy forced scko_s to 0
  always @(posedge clk) begin
    scko_d <= scko_s;
    sdo_d <= sdo_s;
    if (scko_s != scko_d && scki_s != scki_d) begin
      adc_lane <= {adc_lane[BW_8-1:0], sdo_d};
    end
  end

  // store the data from the rx buffers when all bits are received
  // when data transaction window is done
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_data_init <= 'h0;
      data_counter <= 9'h0;
    end else begin
      data_counter <= scki_counter;
      if (data_counter == DW_8) begin
        adc_data_init <= adc_lane;
      end
    end
  end

  // ch_data_lock - locks all the channel, means dont acquire data if all ch's are lock while acquire_data = 0
  always @(posedge clk) begin
    if (start_transfer_s) begin
      ch_data_lock <= 1'd0;
    end else if (acquire_data == 1'b1 && (scki_cnt_rst & (scki_d != scki_i))) begin
      ch_data_lock <= 1'd1;
    end
  end

  assign acquire_data = ~((ch_data_lock | ~adc_enable[0]) &
                          (ch_data_lock | ~adc_enable[1]) &
                          (ch_data_lock | ~adc_enable[2]) &
                          (ch_data_lock | ~adc_enable[3]) &
                          (ch_data_lock | ~adc_enable[4]) &
                          (ch_data_lock | ~adc_enable[5]) &
                          (ch_data_lock | ~adc_enable[6]) &
                          (ch_data_lock | ~adc_enable[7]));

  // stores the data from the rx buffer, but now based on ch
  // from the whole buffer into the per channel buffer
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_data_store[0] <= 'd0;
      adc_data_store[1] <= 'd0;
      adc_data_store[2] <= 'd0;
      adc_data_store[3] <= 'd0;
      adc_data_store[4] <= 'd0;
      adc_data_store[5] <= 'd0;
      adc_data_store[6] <= 'd0;
      adc_data_store[7] <= 'd0;
    end else begin
      if (!adc_valid_init_d & adc_valid_init) begin
        adc_data_store[0] <= adc_data_init[BW + DW * 7: DW * 7];
        adc_data_store[1] <= adc_data_init[BW + DW * 6: DW * 6];
        adc_data_store[2] <= adc_data_init[BW + DW * 5: DW * 5];
        adc_data_store[3] <= adc_data_init[BW + DW * 4: DW * 4];
        adc_data_store[4] <= adc_data_init[BW + DW * 3: DW * 3];
        adc_data_store[5] <= adc_data_init[BW + DW * 2: DW * 2];
        adc_data_store[6] <= adc_data_init[BW + DW * 1: DW * 1];
        adc_data_store[7] <= adc_data_init[BW + DW * 0: DW * 0];
      end
    end
  end

  // extract info from the data bits
  genvar i;
  generate
    for (i=0; i < 8; i=i+1) begin: format
      assign adc_data_raw_s[i] = adc_data_store[i][BW:DW-DATA_WIDTH];
      assign adc_data_sign_s[i] = {{(32-DATA_WIDTH){adc_data_raw_s[i][DATA_WIDTH-1]}}, adc_data_raw_s[i]};
      assign adc_data_zero_s[i] = {{(32-DATA_WIDTH){1'b0}}, adc_data_raw_s[i]};
      assign adc_data_s[i] =  (adc_softspan_s[i] == 3'b0)?  32'h0               :
                              (adc_softspan_s[i][1])?       adc_data_sign_s[i]  :
                                                            adc_data_zero_s[i]  ;
      if (NUM_CHANNELS == 8) begin
        assign adc_ch_id_s[i] = adc_data_store[i][5:3];
      end else if (NUM_CHANNELS == 4) begin
        assign adc_ch_id_s[i] = {1'b0, adc_data_store[i][4:3]};
      end else begin
        assign adc_ch_id_s[i] = {2'b0, adc_data_store[i][3]};
      end
      assign adc_softspan_s[i] = adc_data_store[i][2:0];
    end
  endgenerate

  // assign extracted adc data to corresponding outputs
  assign adc_data_0 = adc_data_s[0];
  assign adc_data_1 = adc_data_s[1];
  assign adc_data_2 = adc_data_s[2];
  assign adc_data_3 = adc_data_s[3];
  assign adc_data_4 = adc_data_s[4];
  assign adc_data_5 = adc_data_s[5];
  assign adc_data_6 = adc_data_s[6];
  assign adc_data_7 = adc_data_s[7];

  // assign extracted adc channel id to corresponding outputs
  assign adc_ch0_id = adc_ch_id_s[0];
  assign adc_ch1_id = adc_ch_id_s[1];
  assign adc_ch2_id = adc_ch_id_s[2];
  assign adc_ch3_id = adc_ch_id_s[3];
  assign adc_ch4_id = adc_ch_id_s[4];
  assign adc_ch5_id = adc_ch_id_s[5];
  assign adc_ch6_id = adc_ch_id_s[6];
  assign adc_ch7_id = adc_ch_id_s[7];

  // assign extracted adc channel id to corresponding outputs
  assign adc_softspan_0 = adc_softspan_s[0];
  assign adc_softspan_1 = adc_softspan_s[1];
  assign adc_softspan_2 = adc_softspan_s[2];
  assign adc_softspan_3 = adc_softspan_s[3];
  assign adc_softspan_4 = adc_softspan_s[4];
  assign adc_softspan_5 = adc_softspan_s[5];
  assign adc_softspan_6 = adc_softspan_s[6];
  assign adc_softspan_7 = adc_softspan_s[7];

  // initial valid signal
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_valid_init <= 1'b0;
    end else begin
      if (data_counter == DW_8 && adc_valid_init == 1'b0) begin
        adc_valid_init <= 1'b1;
      end else begin
        adc_valid_init <= 1'b0;
      end
    end
  end

  // delayed both valid signal and data_lock signal
  // for datasyncing with valid signal
  always @(posedge clk) begin
    if (rst == 1'b1 || adc_valid == 1'b1) begin
      adc_valid <= 1'b0;
      adc_valid_init_d <= 1'b0;
      ch_capture <= 1'd0;
      ch_captured <= 1'd0;
    end else begin
      ch_capture <= ch_data_lock;
      ch_captured <= ch_capture;
      adc_valid_init_d <= adc_valid_init;
      adc_valid <= adc_valid_init_d &
                     (ch_captured | ~adc_enable[0]) &
                     (ch_captured | ~adc_enable[1]) &
                     (ch_captured | ~adc_enable[2]) &
                     (ch_captured | ~adc_enable[3]) &
                     (ch_captured | ~adc_enable[4]) &
                     (ch_captured | ~adc_enable[5]) &
                     (ch_captured | ~adc_enable[6]) &
                     (ch_captured | ~adc_enable[7]);
    end
  end

  // every negedge of clk, update index of sdi_s
  always @(negedge clk) begin
    if (start_transfer_s || rst) begin
      sdi_index <= 5'd23;
    end else begin
      if (scki_s != scki_d && sdi_index != 5'b11111) begin
        sdi_index <= sdi_index - 5'b1;
      end
    end
  end

  // update next softspan configuration every after busy
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      softspan_next_int <= 24'hff_ffff;
    end else begin
      if (busy_m3 & ~busy_m2) begin
        softspan_next_int <= softspan_next;
      end else begin
        softspan_next_int <= softspan_next_int;
      end
    end
  end

  assign sdi_s = (sdi_index != 5'b11111)? softspan_next_int[sdi_index] : 1'b0;

endmodule
