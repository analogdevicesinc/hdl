// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2023, 2026 Analog Devices, Inc. All rights reserved.
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

module adrv9001_rx #(
  parameter CMOS_LVDS_N = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter EN_RX_MCS_TO_STRB_M = 0,
  parameter NUM_LANES = 3,
  parameter DRP_WIDTH = 5,
  parameter IODELAY_ENABLE = 0,
  parameter IODELAY_CTRL = 0,
  parameter USE_BUFG = 0,
  parameter IO_DELAY_GROUP = "dev_if_delay_group"
) (

  // device interface
  input                   rx_dclk_in_n_NC,
  input                   rx_dclk_in_p_dclk_in,
  input                   rx_idata_in_n_idata0,
  input                   rx_idata_in_p_idata1,
  input                   rx_qdata_in_n_qdata2,
  input                   rx_qdata_in_p_qdata3,
  input                   rx_strobe_in_n_NC,
  input                   rx_strobe_in_p_strobe_in,

  input                   mcs_6th_pulse,

  // internal reset and clocks
  input                   adc_rst,
  output                  adc_clk,
  output                  adc_if_rst,
  output                  adc_clk_div,
  output      [7:0]       adc_data_0,
  output      [7:0]       adc_data_1,
  output      [7:0]       adc_data_2,
  output      [7:0]       adc_data_3,
  output      [7:0]       adc_data_strobe,
  output                  adc_valid,

  output     [31:0]       adc_clk_ratio,
  output     [ 9:0]       mcs_to_strobe_delay,

  // delay interface (for IDELAY macros)
  input                             up_clk,
  input   [NUM_LANES-1:0]           up_adc_dld,
  input   [DRP_WIDTH*NUM_LANES-1:0] up_adc_dwdata,
  output  [DRP_WIDTH*NUM_LANES-1:0] up_adc_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked,

  input                   mssi_sync
);

  reg [3:0] valid_gen = 4'b0001;
  reg [2:0] sync_rst = 3'b0;

  wire [4:0] gpio_in;
  wire [39:0] deser_out;
  wire mssi_sync_s;

  periphery_clk_buf rx_clk_buf(
    .inclk (rx_dclk_in_p_dclk_in),
    .outclk (rx_clk)
  );

  assign gpio_in = {rx_strobe_in_p_strobe_in,
                    rx_qdata_in_p_qdata3,
                    rx_qdata_in_n_qdata2,
                    rx_idata_in_p_idata1,
                    rx_idata_in_n_idata0};

  assign {adc_data_strobe,
          adc_data_3,
          adc_data_2,
          adc_data_1,
          adc_data_0} = deser_out;

  genvar i;
  generate
    for (i = 0; i <= 4; i = i + 1) begin: g_ddr_i

      reg [7:0] shift_reg = 8'b0;
      wire [1:0] gpio_out;

      // DDR input
      adrv9001_gpio_in gpio_rx_in (
        .ck (rx_clk),
        .dout (gpio_out),
        .pad_in (gpio_in[i])
      );

      // Temporal ordering:
      //   MSB - oldest received bit;
      //   LSB - newest received bit;
      always @(posedge rx_clk) begin
        shift_reg <= {shift_reg[5:0],gpio_out[0],gpio_out[1]};
      end

      assign deser_out[i*8+:8] = shift_reg;

    end
  endgenerate

  // There is no clock divider to clear on MSSI sync, as the Xilinx PHY
  // does; restart the qualifier instead, so all PHYs start their 8-bit
  // words on the same rx_clk edge after the sync is released.
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_mssi_sync (
    .in_bits (mssi_sync),
    .out_resetn (1'b1),
    .out_clk (rx_clk),
    .out_bits (mssi_sync_s));

  always @(posedge rx_clk) begin
    sync_rst <= {sync_rst[1:0],mssi_sync_s};
  end

  always @(posedge rx_clk) begin
    if (adc_rst | mssi_sync_s) begin
      valid_gen <= 4'b0001;
    end else begin
      valid_gen <= {valid_gen[2:0],valid_gen[3]};
    end
  end

  assign adc_valid = valid_gen[3];
  // No clock divider, qualifier used instead
  assign adc_clk_div = rx_clk;
  assign adc_clk = rx_clk;
  assign adc_clk_ratio = 1;
  assign adc_if_rst = adc_rst | mssi_sync_s | (|sync_rst);

  // Drive unused signals
  assign delay_locked = 'b0;
  assign up_adc_drdata = 'b0;

  generate
  if (EN_RX_MCS_TO_STRB_M == 1'b1) begin

    reg [9:0] mcs_to_strobe_cnt;
    reg       mcs_6th_pulse_d;
    reg [9:0] mcs_to_strobe_fine_delay;
    reg [9:0] mcs_to_strobe_8_delays;
    reg [9:0] mcs_to_strobe_delay_res;
    reg       fine_count_run;
    reg [9:0] fine_count;
    reg [9:0] coarse_count;

    wire      mcs_6th_pulse_s;
    wire      mcs_rise_s;

    sync_bits #(
      .NUM_OF_BITS (1),
      .ASYNC_CLK (1)
    ) i_mcs_sync_in (
      .in_bits (mcs_6th_pulse),
      .out_resetn (1'b1),
      .out_clk (rx_clk),
      .out_bits (mcs_6th_pulse_s));

    // Same measurement as the Xilinx PHY, in 8-bit words: count only the
    // qualified rx_clk cycles, where adc_data_strobe holds a whole word.
    always @(posedge rx_clk) begin
      if (adc_valid) begin
        mcs_6th_pulse_d <= mcs_6th_pulse_s;
      end
    end

    assign mcs_rise_s = adc_valid & !mcs_6th_pulse_d & mcs_6th_pulse_s;

    always @(posedge rx_clk) begin
      if (mcs_rise_s) begin
        mcs_to_strobe_cnt <= 0;
      end else if (adc_valid) begin
        if (mcs_6th_pulse_s & !(|adc_data_strobe) & !fine_count_run) begin
          mcs_to_strobe_cnt <= mcs_to_strobe_cnt + 1;
        end
      end
    end

    always @(posedge rx_clk) begin
      if (mcs_rise_s) begin
        mcs_to_strobe_fine_delay <= 'd0;
        fine_count_run <= 1'b0;
        fine_count <= 'd0;
        coarse_count <= 'd0;
        mcs_to_strobe_8_delays <= 'd0;
      end else if (adc_valid) begin
        if (|adc_data_strobe & !fine_count_run) begin
          mcs_to_strobe_8_delays <= mcs_to_strobe_cnt;
          mcs_to_strobe_fine_delay <= {2'b00, adc_data_strobe};
          fine_count_run <= 1'b1;
        end else if (fine_count_run) begin
          if (|mcs_to_strobe_fine_delay) begin
            fine_count <= fine_count + 1'b1;
            coarse_count <= mcs_to_strobe_8_delays << 3;
            mcs_to_strobe_fine_delay <= mcs_to_strobe_fine_delay >> 1;
          end else begin
            mcs_to_strobe_delay_res <= fine_count + coarse_count;
          end
        end
      end
    end

    assign mcs_to_strobe_delay = mcs_to_strobe_delay_res;

  end else begin
    assign mcs_to_strobe_delay = 10'd0;
  end
  endgenerate

endmodule
