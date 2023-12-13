// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns / 1ps

module axi_fan_control #(
  parameter     ID = 0,
  parameter     PWM_FREQUENCY_HZ  = 5000,
  parameter     INTERNAL_SYSMONE  = 0,
  parameter     AVG_POW = 7, //do not exceede 7

  //temperature thresholds defined to match sysmon reg values
  parameter     TACHO_TOL_PERCENT = 25,
  parameter     TACHO_T25         = 1470000, // 14.7 ms
  parameter     TACHO_T50         = 820000, // 8.2 ms
  parameter     TACHO_T75         = 480000, // 4.8 ms
  parameter     TACHO_T100        = 340000, // 3.4 ms
  parameter     TEMP_00_H         = 05,
  parameter     TEMP_25_L         = 20,
  parameter     TEMP_25_H         = 40,
  parameter     TEMP_50_L         = 60,
  parameter     TEMP_50_H         = 70,
  parameter     TEMP_75_L         = 80,
  parameter     TEMP_75_H         = 90,
  parameter     TEMP_00_L         = 95
) (
  input       [ 9:0]      temp_in,
  input                   tacho,
  output    reg           irq,
  output                  pwm,

  //axi interface
  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready
);

  //local parameters
  localparam [31:0] CORE_VERSION            = {16'h0001,     /* MAJOR */
                                                8'h00,       /* MINOR */
                                                8'h61};      /* PATCH */ // 0.0.0
  localparam [31:0] CORE_MAGIC              = 32'h46414E43;    // FANC

  localparam        CLK_FREQUENCY           = 100000000;
  localparam        PWM_PERIOD              = CLK_FREQUENCY / PWM_FREQUENCY_HZ;
  localparam        OVERFLOW_LIM            = CLK_FREQUENCY * 5;
  localparam        AVERAGE_DIV             = 2**AVG_POW;

  localparam        THRESH_PWM_000          = (INTERNAL_SYSMONE == 1) ? (((TEMP_00_H + 280.2308787) * 65535) / 509.3140064) : ((TEMP_00_H * 41 + 11195) / 20);
  localparam        THRESH_PWM_025_L        = (INTERNAL_SYSMONE == 1) ? (((TEMP_25_L + 280.2308787) * 65535) / 509.3140064) : ((TEMP_25_L * 41 + 11195) / 20);
  localparam        THRESH_PWM_025_H        = (INTERNAL_SYSMONE == 1) ? (((TEMP_25_H + 280.2308787) * 65535) / 509.3140064) : ((TEMP_25_H * 41 + 11195) / 20);
  localparam        THRESH_PWM_050_L        = (INTERNAL_SYSMONE == 1) ? (((TEMP_50_L + 280.2308787) * 65535) / 509.3140064) : ((TEMP_50_L * 41 + 11195) / 20);
  localparam        THRESH_PWM_050_H        = (INTERNAL_SYSMONE == 1) ? (((TEMP_50_H + 280.2308787) * 65535) / 509.3140064) : ((TEMP_50_H * 41 + 11195) / 20);
  localparam        THRESH_PWM_075_L        = (INTERNAL_SYSMONE == 1) ? (((TEMP_75_L + 280.2308787) * 65535) / 509.3140064) : ((TEMP_75_L * 41 + 11195) / 20);
  localparam        THRESH_PWM_075_H        = (INTERNAL_SYSMONE == 1) ? (((TEMP_75_H + 280.2308787) * 65535) / 509.3140064) : ((TEMP_75_H * 41 + 11195) / 20);
  localparam        THRESH_PWM_100          = (INTERNAL_SYSMONE == 1) ? (((TEMP_00_L + 280.2308787) * 65535) / 509.3140064) : ((TEMP_00_L * 41 + 11195) / 20);

  //pwm params
  localparam        PWM_ONTIME_25           = PWM_PERIOD / 4;
  localparam        PWM_ONTIME_50           = PWM_PERIOD / 2;
  localparam        PWM_ONTIME_75           = PWM_PERIOD * 3 / 4;

  //tacho params
  localparam        TACHO_T25_TOL           = TACHO_T25 * TACHO_TOL_PERCENT / 100;
  localparam        TACHO_T50_TOL           = TACHO_T50 * TACHO_TOL_PERCENT / 100;
  localparam        TACHO_T75_TOL           = TACHO_T75 * TACHO_TOL_PERCENT / 100;
  localparam        TACHO_T100_TOL          = TACHO_T100 * TACHO_TOL_PERCENT / 100;

  //state machine states
  localparam        INIT                    = 8'h00;
  localparam        DRP_WAIT_EOC            = 8'h01;
  localparam        DRP_WAIT_DRDY           = 8'h02;
  localparam        DRP_WAIT_FSM_EN         = 8'h03;
  localparam        DRP_READ_TEMP           = 8'h04;
  localparam        DRP_READ_TEMP_WAIT_DRDY = 8'h05;
  localparam        GET_TACHO               = 8'h06;
  localparam        EVAL_TEMP               = 8'h07;
  localparam        SET_PWM                 = 8'h08;
  localparam        EVAL_TACHO              = 8'h09;

  reg   [31:0]  up_scratch = 'd0;
  reg   [7:0]   state = INIT;
  reg   [7:0]   drp_daddr = 'h0;
  reg   [15:0]  drp_di = 'h0;
  reg   [1:0]   drp_den_reg = 'h0;
  reg   [1:0]   drp_dwe_reg = 'h0;
  reg   [15:0]  sysmone_temp = 'h0;
  reg           temp_increase_alarm = 'h0;
  reg           tacho_alarm = 'h0;

  reg   [31:0]  up_tacho_val = 'h0;
  reg   [31:0]  up_tacho_tol = 'h0;
  reg           up_tacho_en = 'h0;
  reg   [7:0]   tacho_avg_cnt = 'h0;
  reg   [31:0]  tacho_avg_sum = 'h0;
  reg   [31:0]  tacho_meas = 'h0;
  reg           tacho_delayed = 'h0;
  reg           tacho_meas_new = 'h0;
  reg           tacho_meas_ack = 'h0;
  reg           tacho_edge_det = 'h0;
  reg   [31:0]  up_tacho_avg_sum = 'h0;

  reg   [31:0]  counter_reg = 'h0;
  reg   [31:0]  pwm_width = 'h0;
  reg   [31:0]  pwm_width_req = 'h0;
  reg           counter_overflow = 'h0;
  reg           pwm_change_done = 1'b1;
  reg           pulse_gen_load_config = 'h0;
  reg           tacho_meas_int = 'h0;

  reg   [15:0]  presc_reg = 'h0;
  reg   [31:0]  up_pwm_width = 'd0;

  reg   [31:0]  up_temp_00_h  = THRESH_PWM_000  ;
  reg   [31:0]  up_temp_25_l  = THRESH_PWM_025_L;
  reg   [31:0]  up_temp_25_h  = THRESH_PWM_025_H;
  reg   [31:0]  up_temp_50_l  = THRESH_PWM_050_L;
  reg   [31:0]  up_temp_50_h  = THRESH_PWM_050_H;
  reg   [31:0]  up_temp_75_l  = THRESH_PWM_075_L;
  reg   [31:0]  up_temp_75_h  = THRESH_PWM_075_H;
  reg   [31:0]  up_temp_100_l = THRESH_PWM_100  ;

  reg   [31:0]  up_tacho_25 = TACHO_T25;
  reg   [31:0]  up_tacho_50 = TACHO_T50;
  reg   [31:0]  up_tacho_75 = TACHO_T75;
  reg   [31:0]  up_tacho_100 = TACHO_T100;
  reg   [31:0]  up_tacho_25_tol = TACHO_T25 * TACHO_TOL_PERCENT / 100;
  reg   [31:0]  up_tacho_50_tol = TACHO_T50 * TACHO_TOL_PERCENT / 100;
  reg   [31:0]  up_tacho_75_tol = TACHO_T75 * TACHO_TOL_PERCENT / 100;
  reg   [31:0]  up_tacho_100_tol = TACHO_T100 * TACHO_TOL_PERCENT / 100;

  reg           up_wack = 'd0;
  reg   [31:0]  up_rdata = 'd0;
  reg           up_rack = 'd0;
  reg           up_resetn = 1'b0;
  reg   [3:0]   up_irq_mask = 4'b1111;
  reg   [3:0]   up_irq_source = 4'h0;

  wire          counter_resetn;
  wire  [15:0]  drp_do;
  wire          drp_drdy;
  wire          drp_eoc;
  wire          drp_eos;

  wire          pwm_change_done_int;
  wire          pulse_gen_out;
  wire          up_clk;
  wire          up_rreq_s;
  wire  [7:0]   up_raddr_s;
  wire          up_wreq_s;
  wire  [7:0]   up_waddr_s;
  wire  [31:0]  up_wdata_s;
  wire  [3:0]   up_irq_pending;
  wire  [3:0]   up_irq_trigger;
  wire  [3:0]   up_irq_source_clear;

  assign up_clk = s_axi_aclk;
  assign pwm = ~pulse_gen_out & up_resetn; //reverse polarity because the board is also reversing it
  assign pwm_change_done_int = counter_overflow & !pwm_change_done;

  //IRQ handling
  assign up_irq_pending = ~up_irq_mask & up_irq_source;
  assign up_irq_trigger  = {tacho_meas_int, temp_increase_alarm, tacho_alarm, pwm_change_done_int};
  assign up_irq_source_clear = (up_wreq_s == 1'b1 && up_waddr_s == 8'h11) ? up_wdata_s[3:0] : 4'b0000;

  //switching the reset signal for the counter
  //counter is used to measure tacho and to provide delay between pwm_ontime changes
  assign counter_resetn = (pwm_change_done ) ? (!tacho_edge_det) : ((!pwm_change_done) & (!counter_overflow));

  up_axi #(
    .AXI_ADDRESS_WIDTH(10)
  ) i_up_axi (
    .up_rstn (s_axi_aresetn),
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

  generate
  if (INTERNAL_SYSMONE == 1) begin
    SYSMONE4 #(
      .COMMON_N_SOURCE(16'hFFFF),
      .INIT_40(16'h1000), // config reg 0
      .INIT_41(16'h2F9F), // config reg 1
      .INIT_42(16'h1400), // config reg 2
      .INIT_43(16'h200F), // config reg 3
      .INIT_44(16'h0000), // config reg 4
      .INIT_45(16'hE200), // Analog Bus Register
      .INIT_46(16'h0000), // Sequencer Channel selection (Vuser0-3)
      .INIT_47(16'h0000), // Sequencer Average selection (Vuser0-3)
      .INIT_48(16'h0101), // Sequencer channel selection
      .INIT_49(16'h0000), // Sequencer channel selection
      .INIT_4A(16'h0000), // Sequencer Average selection
      .INIT_4B(16'h0000), // Sequencer Average selection
      .INIT_4C(16'h0000), // Sequencer Bipolar selection
      .INIT_4D(16'h0000), // Sequencer Bipolar selection
      .INIT_4E(16'h0000), // Sequencer Acq time selection
      .INIT_4F(16'h0000), // Sequencer Acq time selection
      .INIT_50(16'hB794), // Temp alarm trigger
      .INIT_51(16'h4E81), // Vccint upper alarm limit
      .INIT_52(16'hA147), // Vccaux upper alarm limit
      .INIT_53(16'hBF13), // Temp alarm OT upper
      .INIT_54(16'hAB02), // Temp alarm reset
      .INIT_55(16'h4963), // Vccint lower alarm limit
      .INIT_56(16'h9555), // Vccaux lower alarm limit
      .INIT_57(16'hB00A), // Temp alarm OT reset
      .INIT_58(16'h4E81), // VCCBRAM upper alarm limit
      .INIT_5C(16'h4963), // VCCBRAM lower alarm limit
      .INIT_59(16'h4963), // vccpsintlp upper alarm limit
      .INIT_5D(16'h451E), // vccpsintlp lower alarm limit
      .INIT_5A(16'h4963), // vccpsintfp upper alarm limit
      .INIT_5E(16'h451E), // vccpsintfp lower alarm limit
      .INIT_5B(16'h9A74), // vccpsaux upper alarm limit
      .INIT_5F(16'h91EB), // vccpsaux lower alarm limit
      .INIT_60(16'h4D39), // Vuser0 upper alarm limit
      .INIT_61(16'h4DA7), // Vuser1 upper alarm limit
      .INIT_62(16'h9A74), // Vuser2 upper alarm limit
      .INIT_63(16'h9A74), // Vuser3 upper alarm limit
      .INIT_68(16'h4C5E), // Vuser0 lower alarm limit
      .INIT_69(16'h4BF2), // Vuser1 lower alarm limit
      .INIT_6A(16'h98BF), // Vuser2 lower alarm limit
      .INIT_6B(16'h98BF), // Vuser3 lower alarm limit
      .INIT_7A(16'h0000), // DUAL0 Register
      .INIT_7B(16'h0000), // DUAL1 Register
      .INIT_7C(16'h0000), // DUAL2 Register
      .INIT_7D(16'h0000), // DUAL3 Register
      .SIM_DEVICE("ZYNQ_ULTRASCALE"),
      .SIM_MONITOR_FILE("design.txt")
    ) inst_sysmon (
      .DADDR(drp_daddr),
      .DCLK(up_clk),
      .DEN(drp_den_reg[0]),
      .DI(drp_di),
      .DWE(drp_dwe_reg[0]),
      .RESET(!up_resetn),
      .DO(drp_do),
      .DRDY(drp_drdy),
      .EOC(drp_eoc),
      .EOS(drp_eos));
  end
  endgenerate

  //pulse generator instance
  util_pulse_gen #(
    .PULSE_WIDTH(0),
    .PULSE_PERIOD(0)
  ) util_pulse_gen_i(
    .clk (up_clk),
    .rstn (up_resetn),
    .pulse_width (pwm_width),
    .pulse_period (PWM_PERIOD),
    .load_config (pulse_gen_load_config),
    .pulse (pulse_gen_out));

  //state machine
  always @(posedge up_clk)
    if (up_resetn == 1'b0) begin
      tacho_alarm <= 'h0;
      drp_den_reg <= 'h0;
      drp_dwe_reg <= 'h0;
      drp_di <= 'h0;
      tacho_avg_cnt <= 'h0;
      tacho_avg_sum <= 'h0;
      tacho_meas_ack <= 'h0;
      pulse_gen_load_config <= 'h0;
      sysmone_temp <= 'h0;
      pwm_width_req <= 'h0;
      pwm_width <= 'h0;
      up_tacho_avg_sum <= 'h0;
      temp_increase_alarm <= 'h0;
      tacho_meas_int <= 1'b0;
      state <= INIT;
    end else begin

      case (state)

        INIT : begin
          if (INTERNAL_SYSMONE == 1) begin
            drp_daddr <= 8'h40;
            // performing read
            drp_den_reg <= 2'h2;
            if (drp_eoc == 1'b1) begin
              state <= DRP_WAIT_EOC;
            end
          end else begin
            state <= DRP_READ_TEMP;
          end
        end

        DRP_WAIT_EOC : begin
          if (drp_eoc == 1'b1) begin
            //Clearing AVG bits for Configreg0
            drp_di <= drp_do & 16'h03FF;
            drp_daddr <= 8'h40;
            drp_den_reg <= 2'h2;
            // performing write
            drp_dwe_reg <= 2'h2;
            state <= DRP_WAIT_DRDY;
          end else begin
            drp_den_reg <= {1'b0, drp_den_reg[1]};
            drp_dwe_reg <= {1'b0, drp_dwe_reg[1]};
          end
        end

        DRP_WAIT_DRDY : begin
          if (drp_drdy == 1'b1) begin
            state <= DRP_READ_TEMP;
          end else begin
            drp_den_reg <= {1'b0, drp_den_reg[1]};
            drp_dwe_reg <= {1'b0, drp_dwe_reg[1]};
          end
        end

        DRP_WAIT_FSM_EN : begin
          tacho_meas_int <= 1'b0;
          tacho_alarm <= 1'b0;
          pulse_gen_load_config <= 1'b0;
          if (presc_reg[15] == 1'b1) begin
            state <= DRP_READ_TEMP;
          end
        end

        DRP_READ_TEMP : begin
          if (INTERNAL_SYSMONE == 1) begin
            drp_daddr <= 8'h00;
            // performing read
            drp_den_reg <= 2'h2;
            if (drp_eos == 1'b1) begin
              state <= DRP_READ_TEMP_WAIT_DRDY;
            end
          end else begin
            state <= DRP_READ_TEMP_WAIT_DRDY;
          end
        end

        DRP_READ_TEMP_WAIT_DRDY : begin
          if (INTERNAL_SYSMONE == 1) begin
            if (drp_drdy == 1'b1) begin
              sysmone_temp <= drp_do;
              state <= GET_TACHO;
            end else begin
              drp_den_reg <= {1'b0, drp_den_reg[1]};
              drp_dwe_reg <= {1'b0, drp_dwe_reg[1]};
            end
          end else begin
            sysmone_temp <= temp_in;
            state <= GET_TACHO;
          end
        end

        GET_TACHO : begin
          //adding up tacho measurements in order to obtain a mean value from 32 samples
          if ((tacho_avg_cnt == AVERAGE_DIV) || (counter_overflow) || (!pwm_change_done)) begin
            //once a set measurements has been obtained, reset the values
            tacho_avg_sum <= 1'b0;
            tacho_avg_cnt <= 1'b0;
            tacho_meas_ack <= 1'b0;
          end else if ((tacho_meas_new) && (pwm_change_done)) begin
            //tacho_meas_new and tacho_meas_ack ensure the value is read at the right time and only once
            tacho_avg_sum <= tacho_avg_sum + tacho_meas;
            tacho_avg_cnt <= tacho_avg_cnt + 1'b1;
            //acknowledge tha the current values has been added
            tacho_meas_ack <= 1'b1;
          end else begin
            tacho_meas_ack <= 1'b0;
          end
          state <= EVAL_TEMP;
        end

        EVAL_TEMP : begin
          //pwm section
          //the pwm only has to be changed when passing through these temperature intervals
          if (sysmone_temp < up_temp_00_h) begin
            //PWM DUTY should be 0%
            pwm_width_req <= 1'b0;
          end else if ((sysmone_temp > up_temp_25_l) && (sysmone_temp < up_temp_25_h)) begin
            //PWM DUTY should be 25%
            pwm_width_req <= PWM_ONTIME_25;
          end else if ((sysmone_temp > up_temp_50_l) && (sysmone_temp < up_temp_50_h)) begin
            //PWM DUTY should be 50%
            pwm_width_req <= PWM_ONTIME_50;
          end else if ((sysmone_temp > up_temp_75_l) && (sysmone_temp < up_temp_75_h)) begin
            //PWM DUTY should be 75%
            pwm_width_req <= PWM_ONTIME_75;
          end else if (sysmone_temp > up_temp_100_l) begin
            //PWM DUTY should be 100%
            pwm_width_req <= PWM_PERIOD;
            //default to 100% duty cycle after reset if not within temperature intervals described above
          end else if ((sysmone_temp != 'h0) && (pwm_width == 'h0)) begin
            pwm_width_req <= PWM_PERIOD;
          end else begin
            //if no changes are needed make sure to mantain current pwm
            pwm_width_req <= pwm_width;
          end
          state <= SET_PWM;
        end

        SET_PWM : begin
          if ((up_pwm_width != pwm_width) && (up_pwm_width >= pwm_width_req) && (up_pwm_width <= PWM_PERIOD) && (pwm_change_done)) begin
            pwm_width <= up_pwm_width;
            pulse_gen_load_config <= 1'b1;
            //clear alarm when pwm duty changes
          end else if ((pwm_width != pwm_width_req) && (pwm_width_req > up_pwm_width) && (pwm_change_done)) begin
            pwm_width <= pwm_width_req;
            pulse_gen_load_config <= 1'b1;
            temp_increase_alarm <= 1'b1;
            //clear alarm when pwm duty changes
          end
          state <= EVAL_TACHO;
        end

        EVAL_TACHO : begin
          temp_increase_alarm <= 1'b0;
          //tacho section
          //check if the fan is turning then see if it is turning correctly
          if(counter_overflow & pwm_change_done) begin
            //if overflow is 1 then the fan is not turning so do something
            tacho_alarm <= 1'b1;
          end else if (tacho_avg_cnt == AVERAGE_DIV) begin
            //check rpm according to the current pwm duty cycle
            //tacho_alarm is only asserted for certain known pwm duty cycles and
            //for timeout
            up_tacho_avg_sum <= tacho_avg_sum [AVG_POW + 24 : AVG_POW];
            tacho_meas_int <= 1'b1;
            if ((pwm_width == PWM_ONTIME_25) && (up_tacho_en == 0)) begin
              if ((tacho_avg_sum [AVG_POW + 24 : AVG_POW] > up_tacho_25 + up_tacho_25_tol) || (tacho_avg_sum [AVG_POW + 24 : AVG_POW] < up_tacho_25 - up_tacho_25_tol)) begin
                //the fan is turning but not as expected
                tacho_alarm <= 1'b1;
              end
            end else if ((pwm_width == PWM_ONTIME_50) && (up_tacho_en == 0)) begin
              if ((tacho_avg_sum [AVG_POW + 24 : AVG_POW] > up_tacho_50 + up_tacho_50_tol) || (tacho_avg_sum [AVG_POW + 24 : AVG_POW] < up_tacho_50 - up_tacho_50_tol)) begin
                //the fan is turning but not as expected
                tacho_alarm <= 1'b1;
              end
            end else if ((pwm_width == PWM_ONTIME_75) && (up_tacho_en == 0)) begin
              if ((tacho_avg_sum [AVG_POW + 24 : AVG_POW] > up_tacho_75 + up_tacho_75_tol) || (tacho_avg_sum [AVG_POW + 24 : AVG_POW] < up_tacho_75 - up_tacho_75_tol)) begin
                //the fan is turning but not as expected
                tacho_alarm <= 1'b1;
              end
            end else if ((pwm_width == PWM_PERIOD) && (up_tacho_en == 0)) begin
              if ((tacho_avg_sum [AVG_POW + 24 : AVG_POW] > up_tacho_100 + up_tacho_100_tol) || (tacho_avg_sum [AVG_POW + 24 : AVG_POW] < up_tacho_100 - up_tacho_100_tol)) begin
                //the fan is turning but not as expected
                tacho_alarm <= 1'b1;
              end
            end else if ((pwm_width == up_pwm_width) && up_tacho_en) begin
              if ((tacho_avg_sum [AVG_POW + 24 : AVG_POW] > up_tacho_val + up_tacho_tol) || (tacho_avg_sum [AVG_POW + 24 : AVG_POW] < up_tacho_val - up_tacho_tol)) begin
                //the fan is turning but not as expected
                tacho_alarm <= 1'b1;
              end
            end
          end
          state <= DRP_WAIT_FSM_EN;
        end
        default :
          state <= DRP_WAIT_FSM_EN;
      endcase
    end

  //axi registers write
  always @(posedge up_clk) begin
    if (up_resetn == 1'b0) begin
      up_pwm_width <= 'd0;
      up_tacho_val <= 'd0;
      up_tacho_tol <= 'd0;
      up_tacho_en <= 'd0;
      up_scratch <= 'd0;
      up_temp_00_h <= THRESH_PWM_000;
      up_temp_25_l <= THRESH_PWM_025_L;
      up_temp_25_h <= THRESH_PWM_025_H;
      up_temp_50_l <= THRESH_PWM_050_L;
      up_temp_50_h <= THRESH_PWM_050_H;
      up_temp_75_l <= THRESH_PWM_075_L;
      up_temp_75_h <= THRESH_PWM_075_H;
      up_temp_100_l <= THRESH_PWM_100;
      up_tacho_25 <= TACHO_T25;
      up_tacho_50 <= TACHO_T50;
      up_tacho_75 <= TACHO_T75;
      up_tacho_100 <= TACHO_T100;
      up_tacho_25_tol <= TACHO_T25 * TACHO_TOL_PERCENT / 100;
      up_tacho_50_tol <= TACHO_T50 * TACHO_TOL_PERCENT / 100;
      up_tacho_75_tol <= TACHO_T75 * TACHO_TOL_PERCENT / 100;
      up_tacho_100_tol <= TACHO_T100 * TACHO_TOL_PERCENT / 100;
      up_irq_mask <= 4'b1111;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h02)) begin
        up_scratch <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h21)) begin
        up_pwm_width <= up_wdata_s;
        up_tacho_en <= 1'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h22)) begin
        up_tacho_val <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h23)) begin
        up_tacho_tol <= up_wdata_s;
        up_tacho_en <= 1'b1;
      end else if (temp_increase_alarm) begin
        up_tacho_en <= 1'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h40)) begin
        up_temp_00_h <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h41)) begin
        up_temp_25_l <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h42)) begin
        up_temp_25_h <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h43)) begin
        up_temp_50_l <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h44)) begin
        up_temp_50_h <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h45)) begin
        up_temp_75_l <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h46)) begin
        up_temp_75_h <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h47)) begin
        up_temp_100_l <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h50)) begin
        up_tacho_25 <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h51)) begin
        up_tacho_50 <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h52)) begin
        up_tacho_75 <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h53)) begin
        up_tacho_100 <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h54)) begin
        up_tacho_25_tol <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h55)) begin
        up_tacho_50_tol <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h56)) begin
        up_tacho_75_tol <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h57)) begin
        up_tacho_100_tol <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h10)) begin
        up_irq_mask <= up_wdata_s[3:0];
      end
    end
  end

  //writing reset
  always @(posedge up_clk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_wack <= 'd0;
      up_resetn <= 1'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h20)) begin
        up_resetn <= up_wdata_s[0];
      end else begin
        up_resetn <= 1'd1;
      end
    end
  end

  //axi registers read
  always @(posedge up_clk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr_s)
          8'h00: up_rdata <= CORE_VERSION;
          8'h01: up_rdata <= ID;
          8'h02: up_rdata <= up_scratch;
          8'h03: up_rdata <= CORE_MAGIC;
          8'h10: up_rdata <= up_irq_mask;
          8'h11: up_rdata <= up_irq_pending;
          8'h12: up_rdata <= up_irq_source;
          8'h20: up_rdata <= up_resetn;
          8'h21: up_rdata <= pwm_width;
          8'h22: up_rdata <= up_tacho_val;
          8'h23: up_rdata <= up_tacho_tol;
          8'h24: up_rdata <= INTERNAL_SYSMONE;
          8'h30: up_rdata <= PWM_PERIOD;
          8'h31: up_rdata <= up_tacho_avg_sum;
          8'h32: up_rdata <= sysmone_temp;
          8'h40: up_rdata <= up_temp_00_h;
          8'h41: up_rdata <= up_temp_25_l;
          8'h42: up_rdata <= up_temp_25_h;
          8'h43: up_rdata <= up_temp_50_l;
          8'h44: up_rdata <= up_temp_50_h;
          8'h45: up_rdata <= up_temp_75_l;
          8'h46: up_rdata <= up_temp_75_h;
          8'h47: up_rdata <= up_temp_100_l;
          8'h50: up_rdata <= up_tacho_25;
          8'h51: up_rdata <= up_tacho_50;
          8'h52: up_rdata <= up_tacho_75;
          8'h53: up_rdata <= up_tacho_100;
          8'h54: up_rdata <= up_tacho_25_tol;
          8'h55: up_rdata <= up_tacho_50_tol;
          8'h56: up_rdata <= up_tacho_75_tol;
          8'h57: up_rdata <= up_tacho_100_tol;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  //IRQ handling
  always @(posedge up_clk) begin
    if (up_resetn == 1'b0) begin
      irq <= 1'b0;
    end else begin
      irq <= |up_irq_pending;
    end
  end

  always @(posedge up_clk) begin
    if (up_resetn == 1'b0) begin
      up_irq_source <= 4'b0000;
    end else begin
      up_irq_source <= up_irq_trigger | (up_irq_source & ~up_irq_source_clear);
    end
  end

  //tacho measurement logic
  always @(posedge up_clk) begin
    if (up_resetn == 1'b0) begin
      tacho_edge_det <= 'h0;
      tacho_meas <= 'h0;
      tacho_meas_new <= 'h0;
      tacho_delayed <= 'h0;
    end else begin
      //edge detection of tacho signal
      tacho_delayed <= tacho;
      tacho_edge_det <= tacho & ~tacho_delayed;
      if ((tacho_edge_det == 1'b1) && (pwm_change_done)) begin
        //measurement is recorded
        tacho_meas <= counter_reg;
        //signal indicates new measurement completed
        tacho_meas_new <= 1'b1;
      end else if(tacho_meas_ack == 1'b1) begin
        //acknowledge received from state machine
        //resetting new measurement flag
        tacho_meas_new <= 'h0;
      end
    end
  end

  //pwm change proc
  always @(posedge up_clk) begin
    if (up_resetn == 1'b0) begin
      pwm_change_done <= 1'b1;
    end else if (counter_overflow) begin
      pwm_change_done <= 1'b1;
    end else if (pulse_gen_load_config) begin
      pwm_change_done <= 'h0;
    end
  end

  //tacho measurement and pwm change delay counter
  always @(posedge up_clk) begin
    if ((up_resetn & counter_resetn) == 1'b0) begin
      counter_reg <= 'h0;
      counter_overflow <= 1'b0;
    end else begin
      if (counter_reg == OVERFLOW_LIM) begin
        counter_reg <= 'h0;
        counter_overflow <= 1'b1;
      end else begin
        counter_reg <= counter_reg + 1'b1;
      end
    end
  end

  //prescaler; sets the rate at which the fsm is run
  always @(posedge up_clk) begin
    if (up_resetn  == 1'b0) begin
      presc_reg <= 'h0;
    end else begin
      if (presc_reg == 'h8000) begin
        presc_reg <= 'h0;
      end else begin
        presc_reg <= presc_reg + 1'b1;
      end
    end
  end
endmodule
