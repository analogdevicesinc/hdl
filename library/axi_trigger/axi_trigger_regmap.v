// ***************************************************************************
// ***************************************************************************
// Copyright 2021 (c) Analog Devices, Inc. All rights reserved.
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

module trigger_ip_regmap (

  input                 clk,

  output      [ 3:0]    in_data_en,

  // condition for internal trigger
  // bit 3: OR(0) / AND(1): the internal trigger condition,
  // bits [2:0] - relationship between internal and external trigger
  // 0 - internal trigger only
  // 1 - external trigger only
  // 2 - internal AND external trigger
  // 3 - internal OR external trigger
  // 4 - internal XOR external trigger
  output      [ 3:0]    triggers_rel,

  // condition for the internal analog triggering;
  // comparison between the probe and the limit
  // 0 - lower than the limit
  // 1 - higher than the limit
  // 2 - passing through high limit
  // 3 - passing through low limit
  output      [ 1:0]    trigger_adc_0,
  output      [ 1:0]    trigger_adc_1,
  output      [ 1:0]    trigger_adc_2,
  output      [ 1:0]    trigger_adc_3,

  // type of triggering to be applied on input
  // 0 - analog triggering
  // 1 - digital triggering
  // 3 - disable
  output      [ 1:0]    trigger_type,

  // limit for triggering on analog data
  output      [31:0]    limit_0,
  output      [31:0]    limit_1,
  output      [31:0]    limit_2,
  output      [31:0]    limit_3,

  // hysteresis value for triggering on analog data
  output      [31:0]    hysteresis_0,
  output      [31:0]    hysteresis_1,
  output      [31:0]    hysteresis_2,
  output      [31:0]    hysteresis_3,

  output      [31:0]    edge_detect_enable_0,
  output      [31:0]    rise_edge_enable_0,
  output      [31:0]    fall_edge_enable_0,
  output      [31:0]    low_level_enable_0,
  output      [31:0]    high_level_enable_0,

  output      [31:0]    edge_detect_enable_1,
  output      [31:0]    rise_edge_enable_1,
  output      [31:0]    fall_edge_enable_1,
  output      [31:0]    low_level_enable_1,
  output      [31:0]    high_level_enable_1,

  output      [31:0]    edge_detect_enable_2,
  output      [31:0]    rise_edge_enable_2,
  output      [31:0]    fall_edge_enable_2,
  output      [31:0]    low_level_enable_2,
  output      [31:0]    high_level_enable_2,

  output      [31:0]    edge_detect_enable_3,
  output      [31:0]    rise_edge_enable_3,
  output      [31:0]    fall_edge_enable_3,
  output      [31:0]    low_level_enable_3,
  output      [31:0]    high_level_enable_3,

  // bus interface
  input                 up_rstn,
  input                 up_clk,
  input                 up_wreq,
  input       [ 4:0]    up_waddr,
  input       [31:0]    up_wdata,
  output reg            up_wack,
  input                 up_rreq,
  input       [ 4:0]    up_raddr,
  output reg  [31:0]    up_rdata,
  output reg            up_rack
);

  // internal registers

  reg         [31:0]    up_version = 32'h00020100;
  reg         [31:0]    up_scratch = 'h0;

  reg         [ 3:0]    up_in_data_en = 'h0;

  reg         [ 3:0]    up_triggers_rel = 'h0;

  reg         [ 1:0]    up_trigger_adc_0 = 'h0;
  reg         [ 1:0]    up_trigger_adc_1 = 'h0;
  reg         [ 1:0]    up_trigger_adc_2 = 'h0;
  reg         [ 1:0]    up_trigger_adc_3 = 'h0;
  reg         [ 1:0]    up_trigger_type = 'h0;

  reg         [31:0]    up_limit_0 = 'h0;
  reg         [31:0]    up_limit_1 = 'h0;
  reg         [31:0]    up_limit_2 = 'h0;
  reg         [31:0]    up_limit_3 = 'h0;

  reg         [31:0]    up_hysteresis_0 = 'h0;
  reg         [31:0]    up_hysteresis_1 = 'h0;
  reg         [31:0]    up_hysteresis_2 = 'h0;
  reg         [31:0]    up_hysteresis_3 = 'h0;

  reg         [31:0]    up_edge_detect_enable_0 = 'h0;
  reg         [31:0]    up_rise_edge_enable_0   = 'h0;
  reg         [31:0]    up_fall_edge_enable_0   = 'h0;
  reg         [31:0]    up_low_level_enable_0   = 'h0;
  reg         [31:0]    up_high_level_enable_0  = 'h0;

  reg         [31:0]    up_edge_detect_enable_1 = 'h0;
  reg         [31:0]    up_rise_edge_enable_1   = 'h0;
  reg         [31:0]    up_fall_edge_enable_1   = 'h0;
  reg         [31:0]    up_low_level_enable_1   = 'h0;
  reg         [31:0]    up_high_level_enable_1  = 'h0;

  reg         [31:0]    up_edge_detect_enable_2 = 'h0;
  reg         [31:0]    up_rise_edge_enable_2   = 'h0;
  reg         [31:0]    up_fall_edge_enable_2   = 'h0;
  reg         [31:0]    up_low_level_enable_2   = 'h0;
  reg         [31:0]    up_high_level_enable_2  = 'h0;

  reg         [31:0]    up_edge_detect_enable_3 = 'h0;
  reg         [31:0]    up_rise_edge_enable_3   = 'h0;
  reg         [31:0]    up_fall_edge_enable_3   = 'h0;
  reg         [31:0]    up_low_level_enable_3   = 'h0;
  reg         [31:0]    up_high_level_enable_3  = 'h0;

  always @(negedge up_rstn or posedge up_clk) begin
      if (up_rstn == 0) begin
        up_wack <= 'h0;
        up_scratch <= 'h0;

        up_in_data_en <= 'h0;

        up_triggers_rel <= 'h0;
        up_trigger_adc_0 <= 'h0;
        up_trigger_adc_1 <= 'h0;
        up_trigger_adc_2 <= 'h0;
        up_trigger_adc_3 <= 'h0;
        up_trigger_type <= 'h0;

        up_edge_detect_enable_0 <= 'h0;
        up_rise_edge_enable_0   <= 'h0;
        up_fall_edge_enable_0   <= 'h0;
        up_low_level_enable_0   <= 'h0;
        up_high_level_enable_0  <= 'h0;
        up_limit_0 <= 'h0;
        up_hysteresis_0 <= 'h0;

        up_edge_detect_enable_1 <= 'h0;
        up_rise_edge_enable_1   <= 'h0;
        up_fall_edge_enable_1   <= 'h0;
        up_low_level_enable_1   <= 'h0;
        up_high_level_enable_1  <= 'h0;
        up_limit_1 <= 'h0;
        up_hysteresis_1 <= 'h0;

        up_edge_detect_enable_2 <= 'h0;
        up_rise_edge_enable_2   <= 'h0;
        up_fall_edge_enable_2   <= 'h0;
        up_low_level_enable_2   <= 'h0;
        up_high_level_enable_2  <= 'h0;
        up_limit_2 <= 'h0;
        up_hysteresis_2 <= 'h0;

        up_edge_detect_enable_3 <= 'h0;
        up_rise_edge_enable_3   <= 'h0;
        up_fall_edge_enable_3   <= 'h0;
        up_low_level_enable_3   <= 'h0;
        up_high_level_enable_3  <= 'h0;
        up_limit_3 <= 'h0;
        up_hysteresis_3 <= 'h0;
    end else begin

      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
          up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2)) begin
          up_in_data_en <= up_wdata[3:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h3)) begin
          up_triggers_rel <= up_wdata[3:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h4)) begin
          up_trigger_type <= up_wdata[1:0];
      end

      // for PROBE 0
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h10)) begin
          up_edge_detect_enable_0 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h11)) begin
          up_rise_edge_enable_0 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h12)) begin
          up_fall_edge_enable_0 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h13)) begin
          up_low_level_enable_0 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h14)) begin
          up_high_level_enable_0 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h15)) begin
          up_limit_0 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h16)) begin
          up_hysteresis_0 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h17)) begin
          up_trigger_adc_0 <= up_wdata[1:0];
      end

      // for PROBE 1
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h18)) begin
          up_edge_detect_enable_1 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h19)) begin
          up_rise_edge_enable_1 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1A)) begin
          up_fall_edge_enable_1 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1B)) begin
          up_low_level_enable_1 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1C)) begin
          up_high_level_enable_1 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1D)) begin
          up_limit_1 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1E)) begin
          up_hysteresis_1 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1F)) begin
          up_trigger_adc_1 <= up_wdata[1:0];
      end

      // for PROBE 2
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h20)) begin
          up_edge_detect_enable_2 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h21)) begin
          up_rise_edge_enable_2 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h22)) begin
          up_fall_edge_enable_2 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h23)) begin
          up_low_level_enable_2 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h24)) begin
          up_high_level_enable_2 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h25)) begin
          up_limit_2 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h26)) begin
          up_hysteresis_2 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h27)) begin
          up_trigger_adc_2 <= up_wdata[1:0];
      end

      // for PROBE 3
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h28)) begin
          up_edge_detect_enable_3 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h29)) begin
          up_rise_edge_enable_3 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2A)) begin
          up_fall_edge_enable_3 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2B)) begin
          up_low_level_enable_3 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2C)) begin
          up_high_level_enable_3 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2D)) begin
          up_limit_3 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2E)) begin
          up_hysteresis_3 <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2F)) begin
          up_trigger_adc_3 <= up_wdata[1:0];
      end
    end
  end

  // processor read interface
  always @(negedge up_rstn or posedge up_clk) begin
      if (up_rstn == 0) begin
          up_rack <= 'h0;
          up_rdata <= 'h0;
      end else begin
        up_rack <= up_rreq;
        if (up_rreq == 1'b1) begin
            case (up_raddr[4:0])
              5'h0:up_rdata <= up_version;
              5'h1:up_rdata <= up_scratch;
              5'h2:up_rdata <= {28'h0, up_in_data_en};
              5'h3:up_rdata <= {28'h0, up_triggers_rel};
              5'h4:up_rdata <= {30'h0, up_trigger_type};

              5'h10:up_rdata <= up_edge_detect_enable_0;
              5'h11:up_rdata <= up_rise_edge_enable_0;
              5'h12:up_rdata <= up_fall_edge_enable_0;
              5'h13:up_rdata <= up_low_level_enable_0;
              5'h14:up_rdata <= up_high_level_enable_0;
              5'h15:up_rdata <= up_limit_0;
              5'h16:up_rdata <= up_hysteresis_0;
              5'h17:up_rdata <= {30'h0, up_trigger_adc_0};

              5'h18:up_rdata <= up_edge_detect_enable_1;
              5'h19:up_rdata <= up_rise_edge_enable_1;
              5'h1A:up_rdata <= up_fall_edge_enable_1;
              5'h1B:up_rdata <= up_low_level_enable_1;
              5'h1C:up_rdata <= up_high_level_enable_1;
              5'h1D:up_rdata <= up_limit_1;
              5'h1E:up_rdata <= up_hysteresis_1;
              5'h1F:up_rdata <= {30'h0, up_trigger_adc_1};

              5'h20:up_rdata <= up_edge_detect_enable_2;
              5'h21:up_rdata <= up_rise_edge_enable_2;
              5'h22:up_rdata <= up_fall_edge_enable_2;
              5'h23:up_rdata <= up_low_level_enable_2;
              5'h24:up_rdata <= up_high_level_enable_2;
              5'h25:up_rdata <= up_limit_2;
              5'h26:up_rdata <= up_hysteresis_2;
              5'h27:up_rdata <= {30'h0, up_trigger_adc_2};

              5'h28:up_rdata <= up_edge_detect_enable_3;
              5'h29:up_rdata <= up_rise_edge_enable_3;
              5'h2A:up_rdata <= up_fall_edge_enable_3;
              5'h2B:up_rdata <= up_low_level_enable_3;
              5'h2C:up_rdata <= up_high_level_enable_3;
              5'h2D:up_rdata <= up_limit_3;
              5'h2E:up_rdata <= up_hysteresis_3;
              5'h2F:up_rdata <= {30'h0, up_trigger_adc_3};
          default:up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'h0;
      end
    end
  end

  // clock domain crossing
  up_xfer_cntrl #(.DATA_WIDTH(914)) i_xfer_cntrl (
      .up_rstn (up_rstn),
      .up_clk (up_clk),
      .up_data_cntrl ({ up_in_data_en,                //  4
                        up_triggers_rel,              //  4
                        up_trigger_type,              //  2

                        up_high_level_enable_0,       // 32
                        up_low_level_enable_0,        // 32
                        up_fall_edge_enable_0,        // 32
                        up_rise_edge_enable_0,        // 32
                        up_edge_detect_enable_0,      // 32
                        up_limit_0,                   // 32
                        up_hysteresis_0,              // 32
                        up_trigger_adc_0,             //  2

                        up_high_level_enable_1,       // 32
                        up_low_level_enable_1,        // 32
                        up_fall_edge_enable_1,        // 32
                        up_rise_edge_enable_1,        // 32
                        up_edge_detect_enable_1,      // 32
                        up_limit_1,                   // 32
                        up_hysteresis_1,              // 32
                        up_trigger_adc_1,             //  2

                        up_high_level_enable_2,       // 32
                        up_low_level_enable_2,        // 32
                        up_fall_edge_enable_2,        // 32
                        up_rise_edge_enable_2,        // 32
                        up_edge_detect_enable_2,      // 32
                        up_limit_2,                   // 32
                        up_hysteresis_2,              // 32
                        up_trigger_adc_2,             //  2

                        up_high_level_enable_3,       // 32
                        up_low_level_enable_3,        // 32
                        up_fall_edge_enable_3,        // 32
                        up_rise_edge_enable_3,        // 32
                        up_edge_detect_enable_3,      // 32
                        up_limit_3,                   // 32
                        up_hysteresis_3,              // 32
                        up_trigger_adc_3              //  2
    }),

        .up_xfer_done (),
        .d_rst (1'b0),
        .d_clk (clk),
        .d_data_cntrl ({  in_data_en,                //  4
                          triggers_rel,              //  4
                          trigger_type,              //  2

                          high_level_enable_0,       // 32
                          low_level_enable_0,        // 32
                          fall_edge_enable_0,        // 32
                          rise_edge_enable_0,        // 32
                          edge_detect_enable_0,      // 32
                          limit_0,                   // 32
                          hysteresis_0,              // 32
                          trigger_adc_0,             //  2

                          high_level_enable_1,       // 32
                          low_level_enable_1,        // 32
                          fall_edge_enable_1,        // 32
                          rise_edge_enable_1,        // 32
                          edge_detect_enable_1,      // 32
                          limit_1,                   // 32
                          hysteresis_1,              // 32
                          trigger_adc_1,             //  2

                          high_level_enable_2,       // 32
                          low_level_enable_2,        // 32
                          fall_edge_enable_2,        // 32
                          rise_edge_enable_2,        // 32
                          edge_detect_enable_2,      // 32
                          limit_2,                   // 32
                          hysteresis_2,              // 32
                          trigger_adc_2,             //  2

                          high_level_enable_3,       // 32
                          low_level_enable_3,        // 32
                          fall_edge_enable_3,        // 32
                          rise_edge_enable_3,        // 32
                          edge_detect_enable_3,      // 32
                          limit_3,                   // 32
                          hysteresis_3,              // 32
                          trigger_adc_3              //  2
    }));
endmodule

// ***************************************************************************
// ***************************************************************************
