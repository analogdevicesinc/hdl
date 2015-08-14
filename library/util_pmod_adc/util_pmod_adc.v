// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
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

module util_pmod_adc (

  // clock and reset signals

  clk,
  reset,

  // dma interface
  adc_data,
  adc_valid,
  adc_enable,
  adc_dbg,

  // adc interface (clk, data, cs and conversion start)

  adc_sdo,
  adc_sclk,
  adc_cs_n,
  adc_convst_n
);

  // parameters and local parameters
  parameter         FPGA_CLOCK_MHZ      = 100;  // FPGA clock frequency [MHz]
  parameter         ADC_CONVST_NS       = 100;  // minimum time to keep /CONVST low is 10ns, default is 100ns
  parameter         ADC_CONVERT_NS      = 650;  // conversion time [ns]
  parameter         ADC_TQUIET_NS       = 60;   // quite time between the last SPI read and next conversion start
  parameter         SPI_WORD_LENGTH     = 12;
  parameter         ADC_RESET_LENGTH    = 3;
  parameter         ADC_CLK_DIVIDE      = 16;

  // ADC states
  localparam        ADC_POWERUP         = 0;
  localparam        ADC_SW_RESET        = 1;
  localparam        ADC_IDLE            = 2;
  localparam        ADC_START_CNV       = 3;
  localparam        ADC_WAIT_CNV_DONE   = 4;
  localparam        ADC_READ_CNV_RESULT = 5;
  localparam        ADC_DATA_VALID      = 6;
  localparam        ADC_TQUIET          = 7;

  // ADC timing

  localparam  [15:0]  FPGA_CLOCK_PERIOD_NS  = 1000 / FPGA_CLOCK_MHZ;
  localparam  [15:0]  ADC_CONVST_CNT        = ADC_CONVST_NS / FPGA_CLOCK_PERIOD_NS;
  localparam  [15:0]  ADC_CONVERT_CNT       = ADC_CONVERT_NS / FPGA_CLOCK_PERIOD_NS;
  localparam  [15:0]  ADC_TQUITE_CNT        = ADC_TQUIET_NS / FPGA_CLOCK_PERIOD_NS;

  // clock and reset signals

  input           clk;                          // system clock (100 MHz)
  input           reset;                        // active high reset signal

  // dma interface

  output  [15:0]  adc_data;
  output          adc_valid;
  output          adc_enable;
  output  [24:0]  adc_dbg;

  // adc interface

  input           adc_sdo;
  output          adc_sclk;
  output          adc_cs_n;
  output          adc_convst_n;

  // Internal registers

  reg [15:0]      adc_data          = 16'b0;
  reg             adc_valid         = 1'b0;
  reg [24:0]      adc_dbg           = 25'b0;

  reg [ 2:0]      adc_state         = 3'b0;     // current state for the ADC control state machine
  reg [ 2:0]      adc_next_state    = 3'b0;     // next state for the ADC control state machine

  reg [15:0]      adc_tconvst_cnt   = 16'b0;
  reg [15:0]      adc_tconvert_cnt  = 16'b0;
  reg [15:0]      adc_tquiet_cnt    = 16'b0;
  reg [15:0]      sclk_clk_cnt      = 16'b0;
  reg [15:0]      sclk_clk_cnt_m1   = 16'b0;
  reg [7:0]       adc_clk_cnt       = 8'h0;

  reg             adc_convst_n      = 1'b1;
  reg             adc_clk_en        = 1'b0;
  reg             adc_cs_n          = 1'b1;
  reg             adc_sw_reset      = 1'b0;
  reg             data_rd_ready     = 1'b0;
  reg             adc_spi_clk       = 1'b0;

  // Assign/Always Blocks

  assign adc_sclk   = adc_spi_clk & adc_clk_en;
  assign adc_enable = 1'b1;

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
    if(reset == 1'b1) begin
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
    if(reset == 1'b1) begin
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

