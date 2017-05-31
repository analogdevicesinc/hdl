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

// This core supports the following CFTL pmods:
//        - EVAL-CN0350-PMDZ
//        - EVAL-CN0335-PMDZ
//        - EVAL-CN0336-PMDZ
//        - EVAL-CN0337-PMDZ
//
// It controls a simple three wire SPI interface with an additional control
// line for conversion start, and a counter which trigger the SPI read after
// the end of ADC conversion.
// NOTE:  - The maximum frequency of serial read clock (adc_spi_clk) is 50Mhz.
//        - The maximum conversion rate is 1MSPS (AD7091r)
//        - The frequency of the serial read clock need to be adjusted to the desired
//          conversion rate, exp. for AD7091r :
//
//            ADC Rate >= ADC Conversion Time + SPI Word Length * ADC Serial Clock Period + Tquiet
//        where ADC Conversion Time >= 650ns
//              SPI Word Length = 12
//              Tquiet >= 58ns

`timescale 1ns/1ns

module util_pmod_adc #(

  parameter         FPGA_CLOCK_MHZ      = 100,
  parameter         ADC_CONVST_NS       = 100,
  parameter         ADC_CONVERT_NS      = 650,
  parameter         ADC_TQUIET_NS       = 60,
  parameter         SPI_WORD_LENGTH     = 12,
  parameter         ADC_RESET_LENGTH    = 3,
  parameter         ADC_CLK_DIVIDE      = 16) (

  // clock and reset signals

  input                   clk,
  input                   resetn,

  // dma interface
  output  reg [15:0]      adc_data,
  output  reg             adc_valid,
  output  reg [24:0]      adc_dbg,

  // adc interface (clk, data, cs and conversion start)

  input                   adc_sdo,
  output                  adc_sclk,
  output  reg             adc_cs_n,
  output  reg             adc_convst_n);


  localparam        ADC_POWERUP         = 0;
  localparam        ADC_SW_RESET        = 1;
  localparam        ADC_IDLE            = 2;
  localparam        ADC_START_CNV       = 3;
  localparam        ADC_WAIT_CNV_DONE   = 4;
  localparam        ADC_READ_CNV_RESULT = 5;
  localparam        ADC_DATA_VALID      = 6;
  localparam        ADC_TQUIET          = 7;

  localparam  [15:0]  FPGA_CLOCK_PERIOD_NS  = 1000 / FPGA_CLOCK_MHZ;
  localparam  [15:0]  ADC_CONVST_CNT        = ADC_CONVST_NS / FPGA_CLOCK_PERIOD_NS;
  localparam  [15:0]  ADC_CONVERT_CNT       = ADC_CONVERT_NS / FPGA_CLOCK_PERIOD_NS;
  localparam  [15:0]  ADC_TQUITE_CNT        = ADC_TQUIET_NS / FPGA_CLOCK_PERIOD_NS;

  // Internal registers

  reg [ 2:0]      adc_state         = 3'b0;     // current state for the ADC control state machine
  reg [ 2:0]      adc_next_state    = 3'b0;     // next state for the ADC control state machine

  reg [15:0]      adc_tconvst_cnt   = 16'b0;
  reg [15:0]      adc_tconvert_cnt  = 16'b0;
  reg [15:0]      adc_tquiet_cnt    = 16'b0;
  reg [15:0]      sclk_clk_cnt      = 16'b0;
  reg [15:0]      sclk_clk_cnt_m1   = 16'b0;
  reg [7:0]       adc_clk_cnt       = 8'h0;

  reg             adc_clk_en        = 1'b0;
  reg             adc_sw_reset      = 1'b0;
  reg             data_rd_ready     = 1'b0;
  reg             adc_spi_clk       = 1'b0;

  // Assign/Always Blocks

  assign adc_sclk   = adc_spi_clk & adc_clk_en;

  // spi clock generation
  always @(posedge clk) begin
    adc_clk_cnt <= adc_clk_cnt + 1;
    if (adc_clk_cnt == ((ADC_CLK_DIVIDE/2)-1)) begin
      adc_clk_cnt <= 0;
      adc_spi_clk <= ~adc_spi_clk;
    end
  end

  // update the ADC timing counters

  always @(posedge clk)
  begin
    if(resetn == 1'b0) begin
      adc_tconvst_cnt  <= ADC_CONVST_CNT;
      adc_tconvert_cnt <= ADC_CONVERT_CNT;
      adc_tquiet_cnt   <= ADC_TQUITE_CNT;
    end else begin
      if(adc_state == ADC_START_CNV) begin
        adc_tconvst_cnt <= adc_tconvst_cnt - 1;
      end else begin
        adc_tconvst_cnt <= ADC_CONVST_CNT;
      end
      if((adc_state == ADC_START_CNV) || (adc_state == ADC_WAIT_CNV_DONE)) begin
        adc_tconvert_cnt <= adc_tconvert_cnt - 1;
      end else begin
        adc_tconvert_cnt <= ADC_CONVERT_CNT;
      end
      if(adc_state == ADC_TQUIET) begin
        adc_tquiet_cnt <= adc_tquiet_cnt - 1;
      end else begin
        adc_tquiet_cnt <= ADC_TQUITE_CNT;
      end
    end
  end

  // determine when the ADC clock is valid

  always @(negedge adc_spi_clk) begin
    adc_clk_en <= ((adc_state == ADC_READ_CNV_RESULT) && (sclk_clk_cnt != 0)) ? 1'b1 : 1'b0;
  end

  // read data from the ADC

  always @(negedge adc_spi_clk) begin
      sclk_clk_cnt_m1 <= sclk_clk_cnt;
      if((adc_clk_en == 1'b1) && (sclk_clk_cnt != 0)) begin
          adc_data   <= {3'b0, adc_data[11:0], adc_sdo};
          if ((adc_sw_reset == 1'b1) && (sclk_clk_cnt == SPI_WORD_LENGTH - ADC_RESET_LENGTH + 1)) begin
            sclk_clk_cnt <= 16'b0;
          end else begin
            sclk_clk_cnt <= sclk_clk_cnt - 1;
          end
      end
      else if(adc_state != ADC_READ_CNV_RESULT) begin
          adc_data   <= 16'h0;
          sclk_clk_cnt <= SPI_WORD_LENGTH - 1;
      end
  end

  // update the ADC current state and the control signals

  always @(posedge clk) begin
    if(resetn == 1'b0) begin
      adc_state <= ADC_SW_RESET;
      adc_dbg <= 1'b0;
    end
    else begin
      adc_state <= adc_next_state;
      adc_dbg <= {adc_state, adc_clk_en, sclk_clk_cnt};
      case (adc_state)
        ADC_POWERUP: begin
          adc_convst_n    <= 1'b1;
          adc_cs_n        <= 1'b1;
          adc_valid       <= 1'b0;
          adc_sw_reset    <= 1'b0;
        end
        ADC_SW_RESET: begin
          adc_convst_n    <= 1'b1;
          adc_cs_n        <= 1'b1;
          adc_valid       <= 1'b0;
          adc_sw_reset    <= 1'b1;
        end
        ADC_IDLE: begin
          adc_convst_n    <= 1'b1;
          adc_cs_n        <= 1'b1;
          adc_valid       <= 1'b0;
          adc_sw_reset    <= 1'b0;
        end
        ADC_START_CNV: begin
          adc_convst_n    <= 1'b0;
          adc_cs_n        <= 1'b1;
          adc_valid       <= 1'b0;
        end
        ADC_WAIT_CNV_DONE: begin
          adc_convst_n    <= 1'b1;
          adc_cs_n        <= 1'b1;
          adc_valid       <= 1'b0;
        end
        ADC_READ_CNV_RESULT: begin
          adc_convst_n    <= 1'b1;
          adc_cs_n        <= 1'b0;
          adc_valid       <= 1'b0;
        end
        ADC_DATA_VALID: begin
          adc_convst_n    <= 1'b1;
          adc_cs_n        <= 1'b0;
          adc_valid       <= 1'b1;
        end
        ADC_TQUIET: begin
          adc_convst_n    <= 1'b1;
          adc_cs_n        <= 1'b1;
          adc_valid       <= 1'b0;
        end
      endcase
    end
  end

  // update the ADC next state

  always @(adc_state, adc_tconvst_cnt, adc_tconvert_cnt, sclk_clk_cnt_m1, adc_tquiet_cnt, adc_sw_reset) begin
    adc_next_state <= adc_state;
    case (adc_state)
      ADC_POWERUP: begin
        if(adc_sw_reset == 1'b1) begin
          adc_next_state <= ADC_SW_RESET;
        end
      end
      ADC_SW_RESET: begin
        adc_next_state <= ADC_START_CNV;
      end
      ADC_IDLE: begin
          adc_next_state <= ADC_START_CNV;
      end
      ADC_START_CNV: begin
        if(adc_tconvst_cnt == 0) begin
          adc_next_state <= ADC_WAIT_CNV_DONE;
        end
      end
      ADC_WAIT_CNV_DONE: begin
        if(adc_tconvert_cnt == 0) begin
          adc_next_state <= ADC_READ_CNV_RESULT;
        end
      end
      ADC_READ_CNV_RESULT: begin
        if(sclk_clk_cnt_m1 == 0) begin
          adc_next_state <= ADC_DATA_VALID;
        end
      end
      ADC_DATA_VALID: begin
        adc_next_state <= ADC_TQUIET;
      end
      ADC_TQUIET: begin
        if(adc_tquiet_cnt == 0) begin
          adc_next_state <= ADC_IDLE;
        end
      end
      default: begin
        adc_next_state <= ADC_IDLE;
      end
    endcase
  end

endmodule

