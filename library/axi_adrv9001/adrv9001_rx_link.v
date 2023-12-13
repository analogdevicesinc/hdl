// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
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

module adrv9001_rx_link #(
  parameter CMOS_LVDS_N = 0
) (
  input         adc_rst,
  input         adc_clk_div,
  input   [7:0] adc_data_0,
  input   [7:0] adc_data_1,
  input   [7:0] adc_data_2,
  input   [7:0] adc_data_3,
  input   [7:0] adc_data_strobe,
  input         adc_valid,

  // upper layer data interface
  output        rx_clk,
  output        rx_data_valid,
  output [15:0] rx_data_i,
  output [15:0] rx_data_q,

  // Config interface
  input         rx_sdr_ddr_n,
  input         rx_single_lane,
  input         rx_symb_op,
  input         rx_symb_8_16b
);

  wire [7:0] data_0;
  wire [7:0] data_1;
  wire [7:0] data_2;
  wire [7:0] data_3;
  wire [7:0] data_strobe;
  wire       data_valid;

  assign rx_clk = adc_clk_div;

  // CMOS can operate in SDR or DDR mode
  generate if (CMOS_LVDS_N) begin : cmos_4_to_8
    wire [3:0] sdr_data_0;
    wire [3:0] sdr_data_1;
    wire [3:0] sdr_data_2;
    wire [3:0] sdr_data_3;
    wire [3:0] sdr_data_strobe;
    wire       sdr_data_valid;

    wire [3:0] sdr_data_0_aligned;
    wire [3:0] sdr_data_1_aligned;
    wire [3:0] sdr_data_2_aligned;
    wire [3:0] sdr_data_3_aligned;
    wire [3:0] sdr_data_strobe_aligned;

    wire [7:0] sdr_data_0_packed;
    wire [7:0] sdr_data_1_packed;
    wire [7:0] sdr_data_2_packed;
    wire [7:0] sdr_data_3_packed;
    wire [7:0] sdr_data_strobe_packed;

    wire       aligner4_ovalid;

    // For SDR drop every second DDR bit

    assign sdr_data_0 = {adc_data_0[7],adc_data_0[5],adc_data_0[3],adc_data_0[1]};
    assign sdr_data_1 = {adc_data_1[7],adc_data_1[5],adc_data_1[3],adc_data_1[1]};
    assign sdr_data_2 = {adc_data_2[7],adc_data_2[5],adc_data_2[3],adc_data_2[1]};
    assign sdr_data_3 = {adc_data_3[7],adc_data_3[5],adc_data_3[3],adc_data_3[1]};
    assign sdr_data_strobe = {adc_data_strobe[7],adc_data_strobe[5],adc_data_strobe[3],adc_data_strobe[1]};

    adrv9001_aligner4 i_rx_aligner4_0 (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_0),
      .ivalid (adc_valid),
      .strobe (sdr_data_strobe),
      .odata (sdr_data_0_aligned));

    adrv9001_aligner4 i_rx_aligner4_1 (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_1),
      .ivalid (adc_valid),
      .strobe (sdr_data_strobe),
      .odata (sdr_data_1_aligned));

    adrv9001_aligner4 i_rx_aligner4_2 (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_2),
      .ivalid (adc_valid),
      .strobe (sdr_data_strobe),
      .odata (sdr_data_2_aligned));

    adrv9001_aligner4 i_rx_aligner4_3 (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_3),
      .ivalid (adc_valid),
      .strobe (sdr_data_strobe),
      .odata (sdr_data_3_aligned));

    adrv9001_aligner4 i_rx_aligner4_strobe (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_strobe),
      .ivalid (adc_valid),
      .strobe (sdr_data_strobe),
      .ovalid (aligner4_ovalid),
      .odata (sdr_data_strobe_aligned));

    adrv9001_pack #(
      .WIDTH(4)
    ) i_rx_pack_4_to_8_0 (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_0_aligned),
      .ivalid (aligner4_ovalid),
      .sof (sdr_data_strobe_aligned[3]),
      .odata (sdr_data_0_packed),
      .ovalid (sdr_data_valid));

    adrv9001_pack #(
      .WIDTH(4)
    ) i_rx_pack_4_to_8_1 (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_1_aligned),
      .ivalid (aligner4_ovalid),
      .sof (sdr_data_strobe_aligned[3]),
      .odata (sdr_data_1_packed),
      .ovalid ());

    adrv9001_pack #(
      .WIDTH(4)
    ) i_rx_pack_4_to_8_2 (
      .clk (adc_clk_div),
      .idata (sdr_data_2_aligned),
      .ivalid (aligner4_ovalid),
      .sof (sdr_data_strobe_aligned[3]),
      .odata (sdr_data_2_packed),
      .ovalid ());

    adrv9001_pack #(
      .WIDTH(4)
    ) i_rx_pack_4_to_8_3 (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_3_aligned),
      .ivalid (aligner4_ovalid),
      .sof (sdr_data_strobe_aligned[3]),
      .odata (sdr_data_3_packed),
      .ovalid ());

    adrv9001_pack #(
      .WIDTH(4)
    ) i_rx_pack_4_to_8_strobe (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (sdr_data_strobe_aligned),
      .ivalid (aligner4_ovalid),
      .sof (sdr_data_strobe_aligned[3]),
      .odata (sdr_data_strobe_packed),
      .ovalid ());

    assign data_0 = rx_sdr_ddr_n ? sdr_data_0_packed : adc_data_0;
    assign data_1 = rx_sdr_ddr_n ? sdr_data_1_packed : adc_data_1;
    assign data_2 = rx_sdr_ddr_n ? sdr_data_2_packed : adc_data_2;
    assign data_3 = rx_sdr_ddr_n ? sdr_data_3_packed : adc_data_3;
    assign data_strobe = rx_sdr_ddr_n ? sdr_data_strobe_packed : adc_data_strobe;
    assign data_valid = rx_sdr_ddr_n ? sdr_data_valid : adc_valid;
  end else begin
    assign data_0 = adc_data_0;
    assign data_1 = adc_data_1;
    assign data_2 = adc_data_2;
    assign data_3 = adc_data_3;
    assign data_strobe = adc_data_strobe;
    assign data_valid = adc_valid;
  end
  endgenerate

  // ADC

  wire [7:0] rx_data8_0_aligned;
  wire [7:0] rx_data8_1_aligned;
  wire [7:0] rx_data8_2_aligned;
  wire [7:0] rx_data8_3_aligned;
  wire [7:0] rx_data8_strobe_aligned;
  wire       rx_data8_0_aligned_valid;
  wire       rx_data8_1_aligned_valid;

  wire [15:0] rx_data16_0_packed;
  wire [15:0] rx_data16_1_packed;
  wire        rx_data16_0_packed_valid;
  wire        rx_data16_1_packed_valid;
  wire        rx_data16_0_packed_osof;
  wire        rx_data16_1_packed_osof;

  wire [31:0] rx_data32_0_packed;
  wire        rx_data32_0_packed_valid;

  adrv9001_aligner8 i_rx_aligner8_0 (
    .clk (adc_clk_div),
    .rst (adc_rst),
    .idata (data_0),
    .ivalid (data_valid),
    .strobe (data_strobe),
    .odata (rx_data8_0_aligned),
    .ovalid (rx_data8_0_aligned_valid));

  adrv9001_aligner8 i_rx_aligner8_1 (
    .clk (adc_clk_div),
    .rst (adc_rst),
    .ivalid (data_valid),
    .idata (data_1),
    .strobe (data_strobe),
    .odata (rx_data8_1_aligned),
    .ovalid (rx_data8_1_aligned_valid));

  generate if (CMOS_LVDS_N) begin : cmos_aligner8
    adrv9001_aligner8 i_rx_aligner8_2 (
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (data_2),
      .ivalid (data_valid),
      .strobe (data_strobe),
      .odata (rx_data8_2_aligned));

    adrv9001_aligner8 i_rx_aligner8_3(
      .clk (adc_clk_div),
      .rst (adc_rst),
      .idata (data_3),
      .ivalid (data_valid),
      .strobe (data_strobe),
      .odata (rx_data8_3_aligned));
  end
  endgenerate

  adrv9001_aligner8 i_rx_strobe_aligner (
    .clk (adc_clk_div),
    .rst (adc_rst),
    .idata (data_strobe),
    .ivalid (data_valid),
    .strobe (data_strobe),
    .odata (rx_data8_strobe_aligned));

  adrv9001_pack #(
    .WIDTH (8)
  ) i_rx_pack_8_to_16_0 (
    .clk (adc_clk_div),
    .rst (adc_rst),
    .ivalid (rx_data8_0_aligned_valid),
    .idata (rx_data8_0_aligned),
    .sof (rx_data8_strobe_aligned[7]),
    .odata (rx_data16_0_packed),
    .ovalid (rx_data16_0_packed_valid),
    .osof (rx_data16_0_packed_osof));

  adrv9001_pack #(
    .WIDTH (8)
  ) i_rx_pack_8_to_16_1 (
    .clk (adc_clk_div),
    .rst (adc_rst),
    .ivalid (rx_data8_1_aligned_valid),
    .idata (rx_data8_1_aligned),
    .sof (rx_data8_strobe_aligned[7]),
    .odata (rx_data16_1_packed),
    .ovalid (rx_data16_1_paked_valid),
    .osof (rx_data16_1_packed_osof));

  adrv9001_pack #(
    .WIDTH (16)
  ) i_rx_pack_16_to_32_0 (
    .clk (adc_clk_div),
    .rst (adc_rst),
    .ivalid (rx_data16_0_packed_valid),
    .idata (rx_data16_0_packed),
    .sof (rx_data16_0_packed_osof),
    .odata (rx_data32_0_packed),
    .ovalid (rx_data32_0_packed_valid),
    .osof (rx_data32_0_packed_osof));

  generate if (CMOS_LVDS_N) begin
    assign rx_data_i = ~rx_single_lane ? {rx_data8_1_aligned,rx_data8_0_aligned} :
                                         (rx_symb_op ? rx_data16_0_packed : rx_data32_0_packed[31:16]);
    assign rx_data_q = ~rx_single_lane ? {rx_data8_3_aligned,rx_data8_2_aligned} :
                                         (rx_symb_op ? 'b0 : rx_data32_0_packed[15:0]);
    assign rx_data_valid = ~rx_single_lane ? rx_data8_0_aligned_valid :
                                             (rx_symb_op ? (rx_symb_8_16b ? rx_data8_0_aligned_valid : rx_data16_0_packed_valid) : rx_data32_0_packed_valid);
  end else begin
    assign rx_data_i = ~rx_single_lane ? rx_data16_0_packed :
                                         rx_data32_0_packed[31:16];
    assign rx_data_q = ~rx_single_lane ? rx_data16_1_packed :
                                         rx_data32_0_packed[15:0];
    assign rx_data_valid = ~rx_single_lane ? rx_data16_0_packed_valid :
                                             rx_data32_0_packed_valid;
  end
  endgenerate

endmodule
