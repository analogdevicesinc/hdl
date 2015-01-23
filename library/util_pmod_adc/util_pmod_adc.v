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

// This core supports pmods with AD7091R, it controls a simple three wire
// SPI interface with an additional control line for conversion start
// NOTE: The maximum clock rate is 100 Mhz, the SPI interface clock is always
// half of the core's clock.

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
  parameter real    FPGA_CLOCK_FREQ   = 100;    // FPGA clock frequency [MHz] NOTE: this is the maximum supported frequency
  parameter real    ADC_CYCLE_TIME    = 1.000;  // minimum time between two ADC conversions [us]
  parameter real    ADC_CONVST_TIME   = 0.010;  // minimum time to keep /CONVST low [us]
  parameter real    ADC_CONVERT_TIME  = 0.650;  // conversion time [us]
  parameter         ADC_SCLK_PERIODS       = 5'd12;
  parameter         ADC_RESET_SCLK_PERIODS = 4'd3;

  // ADC states

  localparam        ADC_SW_RESET_STATE        = 8'b00000001;
  localparam        ADC_IDLE_STATE            = 8'b00000010;
  localparam        ADC_START_CNV_STATE       = 8'b00000100;
  localparam        ADC_WAIT_CNV_DONE_STATE   = 8'b00001000;
  localparam        ADC_WAIT_DATA_VALID_STATE = 8'b00010000;
  localparam        ADC_READ_CNV_RESULT       = 8'b00100000;
  localparam        ADC_END_CNV_STATE         = 8'b01000000;
  localparam        ADC_DATAREADY_STATE       = 8'b10000000;

  // ADC timing

  localparam [6:0]  ADC_CYCLE_CNT     = FPGA_CLOCK_FREQ * ADC_CYCLE_TIME - 1;
  localparam [6:0]  ADC_CONVST_CNT    = FPGA_CLOCK_FREQ * ADC_CONVST_TIME - 1;
  localparam [6:0]  ADC_CONVERT_CNT   = FPGA_CLOCK_FREQ * ADC_CONVERT_TIME - 1;

  // clock and reset signals

  input           clk;                          // system clock (100 MHz)
  input           reset;                        // active high reset signal

  // dma interface

  output  [15:0]  adc_data;
  output          adc_valid;
  output          adc_enable;
  output  [ 7:0]  adc_dbg;                      // signals that the first data acquisition has been performed

  // adc interface

  input           adc_sdo;
  output          adc_sclk;
  output          adc_cs_n;
  output          adc_convst_n;

  reg [15:0]      adc_data = 'd0;
  reg             adc_valid = 'b0;
  reg             adc_enable = 'b0;
  reg [ 7:0]      adc_dbg = 'b0;
  reg             adc_clk = 'd0;

  reg [ 7:0]      adc_state = 'b0;              // current state for the ADC control state machine
  reg [ 7:0]      adc_next_state = 'b0;         // next state for the ADC control state machine
  reg [ 7:0]      adc_state_nc_m1 = 'b0;        // current state for the ADC state machine in the ADC clock domain sampled on the falling edge
  reg [ 7:0]      adc_state_pc_m1 = 'b0;        // current state for the ADC state machine in the ADC clock domain sampled on the rising edge

  reg [ 6:0]      adc_tcycle_cnt = 'b0;
  reg [ 6:0]      adc_tconvst_cnt = 'b0;
  reg [ 6:0]      adc_tconvert_cnt = 'b0;
  reg [ 4:0]      sclk_clk_cnt = 'b0;

  reg             adc_cnv_s = 'b0;
  reg             adc_clk_en = 1'b0;
  reg             adc_cs_n_s = 'b0;
  reg [15:0]      adc_data_s = 'b0;
  reg             adc_sw_reset = 'b0;
  reg             data_rd_ready_s = 'b0;

  // Assign/Always Blocks

  assign adc_sclk     = adc_clk & adc_clk_en;
  assign adc_cs_n     = adc_cs_n_s;
  assign adc_convst_n = adc_cnv_s;

  always @(negedge clk) begin
    if(reset == 1'b1) begin
      adc_valid <= 1'b0;
      adc_enable <= 1'b0;
    end else begin
      adc_valid <= data_rd_ready_s;
      adc_enable <= 1'b1;
      if(adc_valid == 1'b1) begin
        adc_data <= adc_data_s;
      end
    end
  end

  // generate ADC clock, max rate is 50 Mhz

  always @(posedge clk) begin
    adc_clk<= ~adc_clk;
  end

  // update the ADC timing counters

  always @(posedge clk)
  begin
    if(reset == 1'b1) begin
      adc_tcycle_cnt   <= 0;
      adc_tconvst_cnt  <= ADC_CONVST_CNT;
      adc_tconvert_cnt <= ADC_CONVERT_CNT;
    end else begin
      if(adc_tcycle_cnt != 1'b0) begin
        adc_tcycle_cnt <= adc_tcycle_cnt - 7'h1;
      end
      else if(adc_state == ADC_IDLE_STATE || adc_state == ADC_SW_RESET_STATE) begin
        adc_tcycle_cnt <= ADC_CYCLE_CNT;
      end

      if(adc_state == ADC_START_CNV_STATE) begin
        adc_tconvst_cnt <= adc_tconvst_cnt - 7'h1;
      end
      else begin
        adc_tconvst_cnt <= ADC_CONVST_CNT;
      end
      if(adc_state == ADC_WAIT_CNV_DONE_STATE) begin
        adc_tconvert_cnt <= adc_tconvert_cnt - 7'h1;
      end
      else begin
        adc_tconvert_cnt <= ADC_CONVERT_CNT;
      end
    end
  end

  // determine when the ADC clock is valid to be sent to the ADC

  always @(negedge adc_clk) begin
    adc_state_nc_m1 <= adc_state;
    adc_clk_en      <= ((adc_state_nc_m1 == ADC_WAIT_DATA_VALID_STATE) ||
                        (adc_state_nc_m1 == ADC_READ_CNV_RESULT) &&
                        ((sclk_clk_cnt != 0) ||
                        ((adc_sw_reset == 1'b1) &&
                        (sclk_clk_cnt == ADC_SCLK_PERIODS - ADC_RESET_SCLK_PERIODS)))) ? 1'b1 : 1'b0;
  end

  // read data from the ADC

  always @(negedge adc_clk) begin
      adc_state_pc_m1 <= adc_state;
      if(adc_clk_en == 1'b1) begin
          adc_data_s   <= {3'b0, adc_data_s[11:0], adc_sdo};
          sclk_clk_cnt <= sclk_clk_cnt - 5'h1;
      end
      else if(adc_state_pc_m1 != ADC_READ_CNV_RESULT && adc_state_pc_m1 != ADC_END_CNV_STATE) begin
          adc_data_s   <= 16'h0;
          sclk_clk_cnt <= ADC_SCLK_PERIODS - 1;
      end
  end

  // update the ADC current state and the control signals

  always @(posedge clk) begin
    if(reset == 1'b1) begin
      adc_state <= ADC_SW_RESET_STATE;
      adc_dbg <= 1'b0;
    end
    else begin
      adc_state <= adc_next_state;
      adc_dbg <= adc_state;
      case (adc_state)
        ADC_SW_RESET_STATE: begin
          adc_cnv_s       <= 1'b1;
          adc_cs_n_s      <= 1'b1;
          data_rd_ready_s <= 1'b0;
          adc_sw_reset    <= 1'b1;
        end
        ADC_IDLE_STATE: begin
          adc_cnv_s       <= 1'b1;
          adc_cs_n_s      <= 1'b1;
          data_rd_ready_s <= 1'b0;
          adc_sw_reset    <= 1'b0;
        end
        ADC_START_CNV_STATE: begin
          adc_cnv_s       <= 1'b0;
          adc_cs_n_s      <= 1'b1;
          data_rd_ready_s <= 1'b0;
        end
        ADC_WAIT_CNV_DONE_STATE: begin
          adc_cnv_s       <= 1'b1;
          adc_cs_n_s      <= 1'b1;
          data_rd_ready_s <= 1'b0;
        end
        ADC_WAIT_DATA_VALID_STATE: begin
          adc_cnv_s       <= 1'b1;
          adc_cs_n_s      <= 1'b1;
          data_rd_ready_s <= 1'b0;
        end
        ADC_READ_CNV_RESULT: begin
          adc_cnv_s       <= 1'b1;
          adc_cs_n_s      <= 1'b0;
          data_rd_ready_s <= 1'b0;
        end
        ADC_END_CNV_STATE: begin
          adc_cnv_s       <= 1'b1;
          adc_cs_n_s      <= 1'b0;
          data_rd_ready_s <= 1'b0;
        end
        ADC_DATAREADY_STATE: begin
          adc_cnv_s       <= 1'b1;
          adc_cs_n_s      <= 1'b0;
          data_rd_ready_s <= 1'b1;
        end
      endcase
    end
  end

  // update the ADC next state

  always @(adc_state, adc_tcycle_cnt, adc_tconvst_cnt, adc_tconvert_cnt, sclk_clk_cnt, adc_sw_reset) begin
    adc_next_state <= adc_state;
    case (adc_state)
      ADC_SW_RESET_STATE: begin
        adc_next_state <= ADC_START_CNV_STATE;
      end
      ADC_IDLE_STATE: begin
        if(adc_tcycle_cnt == 0) begin
          adc_next_state <= ADC_START_CNV_STATE;
        end
      end
      ADC_START_CNV_STATE: begin
        if(adc_tconvst_cnt == 0) begin
          adc_next_state <= ADC_WAIT_CNV_DONE_STATE;
        end
      end
      ADC_WAIT_CNV_DONE_STATE: begin
        if(adc_tconvert_cnt == 0) begin
          adc_next_state <= ADC_WAIT_DATA_VALID_STATE;
        end
      end
      ADC_WAIT_DATA_VALID_STATE: begin
        adc_next_state <= ADC_READ_CNV_RESULT;
      end
      ADC_READ_CNV_RESULT: begin
        if((sclk_clk_cnt == 0) || ((adc_sw_reset == 1'b1) && (sclk_clk_cnt == ADC_SCLK_PERIODS - ADC_RESET_SCLK_PERIODS))) begin
          adc_next_state <= ADC_END_CNV_STATE;
        end
      end
      ADC_END_CNV_STATE: begin
        adc_next_state <= ADC_DATAREADY_STATE;
      end
      ADC_DATAREADY_STATE: begin
        adc_next_state <= ADC_IDLE_STATE;
      end
      default: begin
        adc_next_state <= ADC_IDLE_STATE;
      end
    endcase
  end

endmodule

