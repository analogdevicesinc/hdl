// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2019 (c) Analog Devices, Inc. All rights reserved.
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

module axi_hil #(
  parameter     ID = 0
) (  
  output      [31:0]                  dac_1_0_data,
  output      [31:0]                  dac_3_2_data,
  input                               sampling_clk,
  input       [15:0]                  adc_0_data,
  input                               adc_0_valid,
  input       [15:0]                  adc_1_data,
  input                               adc_1_valid,
  input       [15:0]                  adc_2_data,
  input                               adc_2_valid,
  input       [15:0]                  adc_3_data,
  input                               adc_3_valid,

  // ila probes
  // output      [15:0]                  dbg_adc_0_threshold,
  // output      [15:0]                  dbg_dac_0_min_value,
  // output      [15:0]                  dbg_dac_0_max_value,
  // output      [31:0]                  dbg_adc_0_delay_prescaler,
  // output      [31:0]                  dbg_adc_0_delay_cnt,
  // output      [ 0:0]                  dbg_dac_0_bypass_mux,
  // output      [ 0:0]                  dbg_resetn,
  // output      [ 0:0]                  dbg_adc_0_threshold_passed,
  // output      [ 0:0]                  dbg_adc_0_delay_cnt_en,
  // output      [ 0:0]                  dbg_adc_0_valid,
  // output      [ 0:0]                  dbg_adc_1_valid,
  // output      [ 0:0]                  dbg_adc_2_valid,
  // output      [ 0:0]                  dbg_adc_3_valid,

  //axi interface
  input                               s_axi_aclk,
  input                               s_axi_aresetn,
  input                               s_axi_awvalid,
  input       [ 9:0]                  s_axi_awaddr,
  input       [ 2:0]                  s_axi_awprot,
  output                              s_axi_awready,
  input                               s_axi_wvalid,
  input       [31:0]                  s_axi_wdata,
  input       [ 3:0]                  s_axi_wstrb,
  output                              s_axi_wready,
  output                              s_axi_bvalid,
  output      [ 1:0]                  s_axi_bresp,
  input                               s_axi_bready,
  input                               s_axi_arvalid,
  input       [ 9:0]                  s_axi_araddr,
  input       [ 2:0]                  s_axi_arprot,
  output                              s_axi_arready,
  output                              s_axi_rvalid,
  output      [ 1:0]                  s_axi_rresp,
  output      [31:0]                  s_axi_rdata,
  input                               s_axi_rready
);

  //local parameters
  localparam [31:0] CORE_VERSION            = {16'h0001,     /* MAJOR */
                                                8'h00,       /* MINOR */
                                                8'h00};      /* PATCH */ // 0.0.0
  localparam [31:0] CORE_MAGIC              = 32'h48494C43;    // HILC

  localparam ADC_ABOVE_THRESHOLD = 1'b1;
  localparam ADC_BELOW_THRESHOLD = 1'b0;

  localparam [1:0] MUX_HIL_BYPASS =     2'b00;
  localparam [1:0] MUX_HIL_COMPARATOR = 2'b01;
  localparam [1:0] MUX_HIL_OPERATION =  2'b10;

  wire          up_wack;
  wire   [31:0] up_rdata;
  wire          up_rack;
  wire          up_rreq_s;
  wire  [7:0]   up_raddr_s;
  wire          up_wreq_s;
  wire  [7:0]   up_waddr_s;
  wire  [31:0]  up_wdata_s;

  wire          up_clk = s_axi_aclk;
  wire          up_rstn = s_axi_aresetn;

  wire  [15:0]  adc_data    [3:0];
  wire          adc_valid   [3:0];
  
  assign adc_data[0] = adc_0_data;
  assign adc_data[1] = adc_1_data;
  assign adc_data[2] = adc_2_data;
  assign adc_data[3] = adc_3_data;
  assign adc_valid[0] = adc_0_valid;
  assign adc_valid[1] = adc_1_valid;
  assign adc_valid[2] = adc_2_valid;
  assign adc_valid[3] = adc_3_valid;  

  wire            resetn;
  wire            adc_threshold_passed  [3:0];
  reg    [15:0]   dac_data              [3:0];
  wire   [ 1:0]   dac_bypass_mux        [3:0];
  wire   [15:0]   adc_threshold         [3:0];
  wire   [31:0]   adc_delay_prescaler   [3:0];
  wire   [15:0]   dac_min_value         [3:0];
  wire   [15:0]   dac_max_value         [3:0];
  wire   [31:0]   dac_pulse_prescaler   [3:0];
  reg    [31:0]   adc_delay_cnt         [3:0];
  reg             adc_delay_cnt_en      [3:0];
  reg    [31:0]   dac_pulse_cnt         [3:0];
  reg             dac_pulse_cnt_en      [3:0];
  reg    [15:0]   delay_dac_data        [3:0];
  reg             adc_input_change      [3:0];
  reg             adc_input_change_d1   [3:0];
  wire   [ 7:0]   dac_c0                [3:0];
  wire   [ 7:0]   dac_c1                [3:0];
  wire   [ 7:0]   dac_c2                [3:0];
  wire   [ 7:0]   dac_c3                [3:0];

  reg    [ 7:0]   dac_c0_d0             [ 3:0];
  reg    [ 7:0]   dac_c1_d0             [ 3:0];
  reg    [ 7:0]   dac_c2_d0             [ 3:0];
  reg    [ 7:0]   dac_c3_d0             [ 3:0];
  reg    [23:0]   dac_data_gain_d1      [15:0];
  reg    [23:0]   dac_data_gain_d0      [15:0];
  reg    [15:0]   adc_data_d0           [ 3:0];
  reg    [15:0]   dac_data_operation_d1 [ 3:0];
  reg    [15:0]   dac_data_operation_d0 [ 3:0];

  up_axi #(
    .AXI_ADDRESS_WIDTH (10)
  ) i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  axi_hil_regmap #(
    .ID (ID),
    .CORE_MAGIC (CORE_MAGIC),
    .CORE_VERSION (CORE_VERSION),
    .ADC_0_THRESHOLD (16'h2000),
    .ADC_1_THRESHOLD (0),
    .ADC_2_THRESHOLD (16'h2000),
    .ADC_3_THRESHOLD (0),
    .ADC_0_DELAY_PRESCALER (32'h1),
    .ADC_1_DELAY_PRESCALER (0),
    .ADC_2_DELAY_PRESCALER (32'h00B71B00),
    .ADC_3_DELAY_PRESCALER (0),
    .DAC_0_MIN_VALUE (16'h4639),
    .DAC_1_MIN_VALUE (0),
    .DAC_2_MIN_VALUE (16'h4639),
    .DAC_3_MIN_VALUE (0),
    .DAC_0_MAX_VALUE (16'h0000),
    .DAC_1_MAX_VALUE (0),
    .DAC_2_MAX_VALUE (16'h0000),
    .DAC_3_MAX_VALUE (0),
    .DAC_0_PULSE_PRESCALER (32'h000927C0),
    .DAC_1_PULSE_PRESCALER (0),
    .DAC_2_PULSE_PRESCALER (32'h000927C0),
    .DAC_3_PULSE_PRESCALER (0),
    .DAC_0_C00 (1),
    .DAC_0_C01 (0),
    .DAC_0_C02 (0),
    .DAC_0_C03 (0),
    .DAC_1_C10 (0),
    .DAC_1_C11 (1),
    .DAC_1_C12 (0),
    .DAC_1_C13 (0),
    .DAC_2_C20 (0),
    .DAC_2_C21 (0),
    .DAC_2_C22 (1),
    .DAC_2_C23 (0),
    .DAC_3_C30 (0),
    .DAC_3_C31 (0),
    .DAC_3_C32 (0),
    .DAC_3_C33 (1),
    .DAC_0_BYPASS_MUX (MUX_HIL_COMPARATOR),
    .DAC_1_BYPASS_MUX (MUX_HIL_BYPASS),
    .DAC_2_BYPASS_MUX (MUX_HIL_COMPARATOR),
    .DAC_3_BYPASS_MUX (MUX_HIL_BYPASS)
  ) i_regmap (
    .ext_clk (sampling_clk),
    .resetn (resetn),
    .dac_0_bypass_mux (dac_bypass_mux[0]),
    .dac_1_bypass_mux (dac_bypass_mux[1]),
    .dac_2_bypass_mux (dac_bypass_mux[2]),
    .dac_3_bypass_mux (dac_bypass_mux[3]),
    .adc_0_threshold (adc_threshold[0]),
    .adc_1_threshold (adc_threshold[1]),
    .adc_2_threshold (adc_threshold[2]),
    .adc_3_threshold (adc_threshold[3]),
    .adc_0_delay_prescaler (adc_delay_prescaler[0]),
    .adc_1_delay_prescaler (adc_delay_prescaler[1]),
    .adc_2_delay_prescaler (adc_delay_prescaler[2]),
    .adc_3_delay_prescaler (adc_delay_prescaler[3]),
    .dac_0_min_value (dac_min_value[0]),
    .dac_1_min_value (dac_min_value[1]),
    .dac_2_min_value (dac_min_value[2]),
    .dac_3_min_value (dac_min_value[3]),
    .dac_0_max_value (dac_max_value[0]),
    .dac_1_max_value (dac_max_value[1]),
    .dac_2_max_value (dac_max_value[2]),
    .dac_3_max_value (dac_max_value[3]),
    .dac_0_pulse_prescaler (dac_pulse_prescaler[0]),
    .dac_1_pulse_prescaler (dac_pulse_prescaler[1]),
    .dac_2_pulse_prescaler (dac_pulse_prescaler[2]),
    .dac_3_pulse_prescaler (dac_pulse_prescaler[3]),
    .dac_0_c00 (dac_c0[0]),
    .dac_0_c01 (dac_c1[0]),
    .dac_0_c02 (dac_c2[0]),
    .dac_0_c03 (dac_c3[0]),
    .dac_1_c10 (dac_c0[1]),
    .dac_1_c11 (dac_c1[1]),
    .dac_1_c12 (dac_c2[1]),
    .dac_1_c13 (dac_c3[1]),
    .dac_2_c20 (dac_c0[2]),
    .dac_2_c21 (dac_c1[2]),
    .dac_2_c22 (dac_c2[2]),
    .dac_2_c23 (dac_c3[2]),
    .dac_3_c30 (dac_c0[3]),
    .dac_3_c31 (dac_c1[3]),
    .dac_3_c32 (dac_c2[3]),
    .dac_3_c33 (dac_c3[3]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin
      // comparator logic and latch ADC output values
      always @(posedge sampling_clk) begin
        if (resetn == 1'b0) begin
          adc_input_change[i] <= ADC_BELOW_THRESHOLD;
          adc_data_d0[i] <= 'd0;
        end else begin
          if (adc_valid[i]) begin
            adc_data_d0[i] <= adc_data[i];
            if (!adc_data[i] && adc_data[i] >= adc_threshold[i]) begin
              adc_input_change[i] <= ADC_ABOVE_THRESHOLD;
            end else begin
              adc_input_change[i] <= ADC_BELOW_THRESHOLD;
            end
          end
        end
      end
      // delay and pulse logic
      assign adc_threshold_passed[i] = (adc_input_change_d1[i] == ADC_BELOW_THRESHOLD) && (adc_input_change[i] == ADC_ABOVE_THRESHOLD);
      always @(posedge sampling_clk) begin
        if (resetn == 1'b0) begin
          adc_input_change_d1[i] <= 1'b0;
          adc_delay_cnt_en[i] <= 1'b0;
          dac_pulse_cnt_en[i] <= 1'b0;
        end else begin
          adc_input_change_d1[i] <= adc_input_change[i];
          if (!adc_delay_cnt_en[i] && adc_threshold_passed[i]) begin
            adc_delay_cnt_en[i] <= 1'b1;
          end
          if (adc_delay_cnt[i] == adc_delay_prescaler[i]) begin
            adc_delay_cnt_en[i] <= 1'b0;
            dac_pulse_cnt_en[i] <= 1'b1;
          end
          if (dac_pulse_cnt[i] == dac_pulse_prescaler[i]) begin
            dac_pulse_cnt_en[i] <= 1'b0;
          end
        end
      end
      // delay and pulse counters
      always @(posedge sampling_clk) begin
        if (resetn == 1'b0) begin
          adc_delay_cnt[i] <= 32'd0;
          dac_pulse_cnt[i] <= 32'd0;
        end else begin
          if (adc_delay_cnt_en[i]) begin
            adc_delay_cnt[i] <= adc_delay_cnt[i] + 1'b1;
            if (adc_delay_cnt[i] == adc_delay_prescaler[i]) begin
              adc_delay_cnt[i] <= 32'd0;
              delay_dac_data[i] <= dac_max_value[i];
            end
          end
          if (dac_pulse_cnt_en[i]) begin
            dac_pulse_cnt[i] <= dac_pulse_cnt[i] + 1'b1;
            if (dac_pulse_cnt[i] == dac_pulse_prescaler[i]) begin
              dac_pulse_cnt[i] <= 32'd0;
              delay_dac_data[i] <= dac_min_value[i];
            end
          end
        end
      end
      // multiply and sum
      always @(posedge sampling_clk) begin
        if (resetn == 1'b0) begin
          dac_c0_d0[i] <= 'd0;
          dac_c1_d0[i] <= 'd0;
          dac_c2_d0[i] <= 'd0;
          dac_c3_d0[i] <= 'd0;
          dac_data_gain_d1[4*i+0] <= 'd0;
          dac_data_gain_d1[4*i+1] <= 'd0;
          dac_data_gain_d1[4*i+2] <= 'd0;
          dac_data_gain_d1[4*i+3] <= 'd0;
          dac_data_gain_d0[4*i+0] <= 'd0;
          dac_data_gain_d0[4*i+1] <= 'd0;
          dac_data_gain_d0[4*i+2] <= 'd0;
          dac_data_gain_d0[4*i+3] <= 'd0;
          dac_data_operation_d1[i] <= 'd0;
          dac_data_operation_d0[i] <= 'd0;
        end else begin
          dac_c0_d0[i] <= dac_c0[i];
          dac_c1_d0[i] <= dac_c1[i];
          dac_c2_d0[i] <= dac_c2[i];
          dac_c3_d0[i] <= dac_c3[i];
          dac_data_gain_d1[4*i+0] <= dac_c0_d0[i] * adc_data_d0[0];
          dac_data_gain_d1[4*i+1] <= dac_c1_d0[i] * adc_data_d0[1];
          dac_data_gain_d1[4*i+2] <= dac_c2_d0[i] * adc_data_d0[2];
          dac_data_gain_d1[4*i+3] <= dac_c3_d0[i] * adc_data_d0[3];
          dac_data_gain_d0[4*i+0] <= dac_data_gain_d1[4*i+0];
          dac_data_gain_d0[4*i+1] <= dac_data_gain_d1[4*i+1];
          dac_data_gain_d0[4*i+2] <= dac_data_gain_d1[4*i+2];
          dac_data_gain_d0[4*i+3] <= dac_data_gain_d1[4*i+3];
          dac_data_operation_d1[i] <= dac_data_gain_d0[4*i+0] + dac_data_gain_d0[4*i+1] + dac_data_gain_d0[4*i+2] + dac_data_gain_d0[4*i+3];
          dac_data_operation_d0[i] <= dac_data_operation_d1[i];
        end
      end
      // output mux logic
      always @(*) begin
        case (dac_bypass_mux[i])
          MUX_HIL_BYPASS:     dac_data[i] <= {~adc_data[i][15], adc_data[i][14:0]};
          MUX_HIL_COMPARATOR: dac_data[i] <= {~delay_dac_data[i][15], delay_dac_data[i][14:0]};
          MUX_HIL_OPERATION:  dac_data[i] <= {~dac_data_operation_d0[i][15], dac_data_operation_d0[i][14:0]}; 
          default:            dac_data[i] <= 'd0;
        endcase
      end
    end
  endgenerate

  // assign dac_1_0_data = {dac_data[2], dac_data[0]}; // ADC CHC -> CHB DAC by Miguel's request
  assign dac_1_0_data = {dac_data[1], dac_data[0]};
  assign dac_3_2_data = {dac_data[3], dac_data[2]};

  // ila probes
  // assign dbg_adc_0_threshold = adc_threshold[0];
  // assign dbg_dac_0_min_value = dac_min_value[0];
  // assign dbg_dac_0_max_value = dac_max_value[0];
  // assign dbg_adc_0_delay_prescaler = adc_delay_prescaler[0];
  // assign dbg_adc_0_delay_cnt = adc_delay_cnt[0];
  // assign dbg_dac_0_bypass_mux = dac_bypass_mux[0];
  // assign dbg_resetn = resetn;
  // assign dbg_adc_0_threshold_passed = adc_threshold_passed[0];
  // assign dbg_adc_0_delay_cnt_en = adc_delay_cnt_en[0];
  // assign dbg_adc_0_valid = adc_0_valid;
  // assign dbg_adc_1_valid = adc_1_valid;
  // assign dbg_adc_2_valid = adc_2_valid;
  // assign dbg_adc_3_valid = adc_3_valid;

endmodule
