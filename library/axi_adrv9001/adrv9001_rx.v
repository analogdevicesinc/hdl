// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
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
  parameter IODELAY_ENABLE = 1,
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
  output reg              adc_valid,

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

  // Use always DDR mode
  localparam DDR_OR_SDR_N = 1;

  localparam  SEVEN_SERIES  = 1;
  localparam  ULTRASCALE  = 2;
  localparam  ULTRASCALE_PLUS  = 3;

  // internal wire
  wire                 clk_in_s;
  wire [NUM_LANES-1:0] serdes_in_p;
  wire [NUM_LANES-1:0] serdes_in_n;
  wire [NUM_LANES-1:0] data_s0;
  wire [NUM_LANES-1:0] data_s1;
  wire [NUM_LANES-1:0] data_s2;
  wire [NUM_LANES-1:0] data_s3;
  wire [NUM_LANES-1:0] data_s4;
  wire [NUM_LANES-1:0] data_s5;
  wire [NUM_LANES-1:0] data_s6;
  wire [NUM_LANES-1:0] data_s7;
  wire                 adc_clk_in_fast;
  wire                 mcs_6th_pulse_s;
  wire                 adc_clk_div_s;

  // internal registers

  reg       mssi_sync_d1;
  reg       mssi_sync_d2;
  reg       reset_m2;
  reg       reset_m1;
  reg       reset;
  reg       bufdiv_clr = 1'b0;
  reg [2:0] state_cnt = 7;
  reg [2:0] bufdiv_clr_state = 3;
  reg       bufdiv_ce = 1'b1;
  reg       serdes_reset = 1'b0;
  reg       serdes_next_reset = 1'b0;
  reg [7:0] serdes_min_reset_cycle = 8'hff;

  // data interface
  ad_serdes_in #(
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IODELAY_CTRL (IODELAY_CTRL),
    .IODELAY_ENABLE (IODELAY_ENABLE),
    .IODELAY_GROUP (IO_DELAY_GROUP),
    .DDR_OR_SDR_N (DDR_OR_SDR_N),
    .DATA_WIDTH (NUM_LANES),
    .DRP_WIDTH (DRP_WIDTH),
    .SERDES_FACTOR (8)
  ) i_serdes (
    .rst (serdes_reset),
    .clk (adc_clk_in_fast),
    .div_clk (adc_clk_div),
    .data_s0 (data_s0),
    .data_s1 (data_s1),
    .data_s2 (data_s2),
    .data_s3 (data_s3),
    .data_s4 (data_s4),
    .data_s5 (data_s5),
    .data_s6 (data_s6),
    .data_s7 (data_s7),
    .data_in_p (serdes_in_p),
    .data_in_n (serdes_in_n),
    .up_clk (up_clk),
    .up_dld (up_adc_dld),
    .up_dwdata (up_adc_dwdata),
    .up_drdata (up_adc_drdata),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  generate
  if (CMOS_LVDS_N == 0) begin

    IBUFDS i_clk_in_ibuf (
      .I (rx_dclk_in_p_dclk_in),
      .IB (rx_dclk_in_n_NC),
      .O (clk_in_s));

    assign {adc_data_strobe[0],adc_data_1[0],adc_data_0[0]} = data_s0;
    assign {adc_data_strobe[1],adc_data_1[1],adc_data_0[1]} = data_s1;
    assign {adc_data_strobe[2],adc_data_1[2],adc_data_0[2]} = data_s2;
    assign {adc_data_strobe[3],adc_data_1[3],adc_data_0[3]} = data_s3;
    assign {adc_data_strobe[4],adc_data_1[4],adc_data_0[4]} = data_s4;
    assign {adc_data_strobe[5],adc_data_1[5],adc_data_0[5]} = data_s5;
    assign {adc_data_strobe[6],adc_data_1[6],adc_data_0[6]} = data_s6;
    assign {adc_data_strobe[7],adc_data_1[7],adc_data_0[7]} = data_s7;

    assign serdes_in_p = {rx_strobe_in_p_strobe_in,
                          rx_qdata_in_p_qdata3,
                          rx_idata_in_p_idata1};
    assign serdes_in_n = {rx_strobe_in_n_NC,
                          rx_qdata_in_n_qdata2,
                          rx_idata_in_n_idata0};

  end else begin

    IBUF i_clk_in_ibuf (
      .I (rx_dclk_in_p_dclk_in),
      .O (clk_in_s));

    assign {adc_data_strobe[0],adc_data_3[0],adc_data_2[0],adc_data_1[0],adc_data_0[0]} = data_s0;
    assign {adc_data_strobe[1],adc_data_3[1],adc_data_2[1],adc_data_1[1],adc_data_0[1]} = data_s1;
    assign {adc_data_strobe[2],adc_data_3[2],adc_data_2[2],adc_data_1[2],adc_data_0[2]} = data_s2;
    assign {adc_data_strobe[3],adc_data_3[3],adc_data_2[3],adc_data_1[3],adc_data_0[3]} = data_s3;
    assign {adc_data_strobe[4],adc_data_3[4],adc_data_2[4],adc_data_1[4],adc_data_0[4]} = data_s4;
    assign {adc_data_strobe[5],adc_data_3[5],adc_data_2[5],adc_data_1[5],adc_data_0[5]} = data_s5;
    assign {adc_data_strobe[6],adc_data_3[6],adc_data_2[6],adc_data_1[6],adc_data_0[6]} = data_s6;
    assign {adc_data_strobe[7],adc_data_3[7],adc_data_2[7],adc_data_1[7],adc_data_0[7]} = data_s7;

    assign serdes_in_p = {rx_strobe_in_p_strobe_in,
                          rx_qdata_in_p_qdata3,
                          rx_qdata_in_n_qdata2,
                          rx_idata_in_p_idata1,
                          rx_idata_in_n_idata0};
    assign serdes_in_n = 5'b0;

  end
  endgenerate

  // reset logic

  always @(posedge clk_in_s) begin
    mssi_sync_d1 <= mssi_sync;
    mssi_sync_d2 <= mssi_sync_d1;
  end

  always @(posedge clk_in_s, posedge mssi_sync_d2) begin
    if (mssi_sync_d2 == 1'b1) begin
      bufdiv_ce <= 1'b0;
      bufdiv_clr <= 1'b0;
      bufdiv_clr_state <= 3'd0;
      state_cnt <= 3'd7;
    end else begin
      if (bufdiv_ce == 1'b0) begin
        if (state_cnt == 3'd0) begin
          bufdiv_clr_state <= bufdiv_clr_state + 1;
        end else begin
          state_cnt <= state_cnt - 3'd1;
        end
      end

      case (bufdiv_clr_state)
        3'd0 : begin
          bufdiv_ce <= 1'b0;
          bufdiv_clr <= 1'b0;
        end
        3'd1 : begin
          bufdiv_ce <= 1'b0;
          bufdiv_clr <= 1'b1;
        end
        3'd2 : begin
          bufdiv_ce <= 1'b0;
          bufdiv_clr <= 1'b0;
        end
        default: begin
          bufdiv_ce <= 1'b1;
          bufdiv_clr <= 1'b0;
        end
      endcase
    end
  end

  always @(posedge adc_clk_div, posedge bufdiv_clr) begin
    if (bufdiv_clr == 1'b1) begin
      reset_m2 <= 1'b1;
      reset_m1 <= 1'b1;
      reset <= 1'b1;
    end else begin
      reset_m2 <= 1'b0;
      reset_m1 <= reset_m2;
      reset <= reset_m1;
    end
  end

  assign adc_if_rst = adc_rst | reset;

  always @(posedge adc_clk_div) begin
    if (adc_if_rst == 1'b1) begin
      serdes_reset <= 1'b0;
      serdes_next_reset <= 1'b1;
      serdes_min_reset_cycle <= 8'hff;
    end else begin
      if (serdes_next_reset == 1'b1) begin
        serdes_reset <= 1'b1;
        if (serdes_min_reset_cycle == 8'd0) begin
          serdes_next_reset <= 1'b0;
        end else begin
          serdes_min_reset_cycle <= serdes_min_reset_cycle >> 1;
        end
      end else begin
        serdes_reset <= 1'b0;
        serdes_next_reset <= 1'b0;
        serdes_min_reset_cycle <= 8'd0;
      end
    end
  end

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

    sync_bits i_mcs_sync_in (
      .in_bits(mcs_6th_pulse),
      .out_clk(adc_clk_div),
      .out_resetn(1'b1),
      .out_bits(mcs_6th_pulse_s));

    // mcs to strobe measure

    always @(posedge adc_clk_div) begin
      mcs_6th_pulse_d <= mcs_6th_pulse_s;
      if (!mcs_6th_pulse_d & mcs_6th_pulse_s) begin
        mcs_to_strobe_cnt <= 0;
      end else begin
        if (mcs_6th_pulse_s & !(|adc_data_strobe) & !fine_count_run) begin
          mcs_to_strobe_cnt <= mcs_to_strobe_cnt + 1;
        end
      end
    end

    always @(posedge adc_clk_div) begin
      if (!mcs_6th_pulse_d & mcs_6th_pulse_s) begin
        mcs_to_strobe_fine_delay <= 'd0;
        fine_count_run <= 1'b0;
        fine_count <= 'd0;
        coarse_count <= 'd0;
        mcs_to_strobe_8_delays <= 'd0;
      end else begin
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

  if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
    wire adc_clk_div_s;

    BUFG i_clk_buf (
      .I (clk_in_s),
      .O (adc_clk_in_fast));

    BUFR #(
      .BUFR_DIVIDE("4")
    ) i_div_clk_buf (
      .CE (bufdiv_ce),
      .CLR (bufdiv_clr),
      .I (clk_in_s),
      .O (adc_clk_div_s));

    if (USE_BUFG == 1) begin
      BUFG I_bufg (
        .I (adc_clk_div_s),
        .O (adc_clk_div));
    end else begin
      assign adc_clk_div = adc_clk_div_s;
    end

  end else begin

    BUFGCE #(
      .CE_TYPE ("SYNC"),
      .IS_CE_INVERTED (1'b0),
      .IS_I_INVERTED (1'b0)
    ) i_clk_buf_fast (
      .O (adc_clk_in_fast),
      .CE (1'b1),
      .I (clk_in_s));

    BUFGCE_DIV #(
      .BUFGCE_DIVIDE (4),
      .IS_CE_INVERTED (1'b0),
      .IS_CLR_INVERTED (1'b0),
      .IS_I_INVERTED (1'b0)
    ) i_div_clk_buf (
      .O (adc_clk_div),
      .CE (1'b1),
      .CLR (bufdiv_clr),
      .I (clk_in_s));

  end

  endgenerate

  assign adc_clk = adc_clk_in_fast;
  assign adc_clk_ratio = 4;

  always @(posedge adc_clk_div, posedge adc_if_rst) begin
    if (adc_if_rst == 1'b1) begin
      adc_valid <= 1'b0;
    end else begin
      adc_valid <= 1'b1;
    end
  end

endmodule
