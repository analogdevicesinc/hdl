// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
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

module axi_ad485x_lvds #(

  parameter FPGA_TECHNOLOGY = 0,
  parameter RESOLUTION = 20,
  parameter DELAY_REFCLK_FREQ = 200,
  parameter IODELAY_ENABLE = 1,
  parameter N_CHANNELS = 8
) (

  input                   rst,
  input                   clk,
  input                   fast_clk,
  input        [ 7:0]     adc_enable,
  input                   adc_crc_enable,

  // physical interface

  output                  scki_p,
  output                  scki_n,
  input                   scko_p,
  input                   scko_n,
  input                   sdo_p,
  input                   sdo_n,
  input                   busy,
  input                   cnvs,

  // format

  input       [ 1:0]      packet_format_in,
  input                   oversampling_en,

  // channel interface

  output reg [255:0]      adc_data,
  output reg              adc_valid,
  output reg              crc_error,
  output reg  [ 7:0]      dev_status,

  // delay interface (for IDELAY macros)

  input                   up_clk,
  input                   up_adc_dld,
  input       [ 4:0]      up_adc_dwdata,
  output      [ 4:0]      up_adc_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked
);

  localparam DW  = (32 * N_CHANNELS);
  localparam HDW = (DW / 2)-1;
  localparam BW  = DW - 1;
  localparam FBW = DW + 31;
  localparam HBW = ((DW + 32) / 2)-1;

  localparam [5:0] PACKET_1 = RESOLUTION == 16 ? 16 : 20;
  localparam [5:0] PACKET_2 = RESOLUTION == 16 ? 24 : 24;
  localparam [5:0] PACKET_3 = RESOLUTION == 16 ? 24 : 32;

  // internal registers

  reg        [  1:0]  packet_format;
  reg        [  5:0]  packet_cnt_length;
  reg        [ 15:0]  crc_data_length;

  reg        [HBW:0]  rx_data_pos;
  reg        [HBW:0]  rx_data_neg;

  reg        [  5:0]  data_counter = 'h0;
  reg        [  3:0]  ch_counter = 'h0;

  reg                 busy_m1;
  reg                 busy_m2;
  reg                 cnvs_d;
  reg        [ 31:0]  period_cnt;

  reg                 conversion_quiet_time;
  reg                 run_busy_period_cnt;
  reg        [ 31:0]  busy_conversion_cnt;
  reg        [ 31:0]  busy_measure_value;
  reg        [ 31:0]  busy_measure_value_plus;

  reg        [FBW:0]  adc_data_store;
  reg        [FBW:0]  adc_data_init;
  reg                 aquire_data;
  reg                 capture_complete_init;
  reg                 capture_complete_d;
  reg                 start_transfer;
  reg                 start_transfer_d;

  reg        [ 15:0]  dynamic_delay;
  reg                 adc_valid_init;
  reg                 adc_valid_init_d;
  reg                 adc_valid_init_d2;

  reg        [ BW:0]  adc_data_0;
  reg        [ BW:0]  adc_data_1;
  reg        [ BW:0]  adc_data_2;
  reg                 crc_enable_window;
  reg                 run_crc;
  reg                 run_crc_d;
  reg        [FBW:0]  crc_data_in;
  reg        [FBW:0]  crc_data_in_sh;
  reg        [ 15:0]  crc_cnt;
  reg        [  7:0]  data_in_byte;

  reg        [  3:0]  ch_7_index;
  reg        [  3:0]  ch_6_index;
  reg        [  3:0]  ch_5_index;
  reg        [  3:0]  ch_4_index;
  reg        [  3:0]  ch_3_index;
  reg        [  3:0]  ch_2_index;
  reg        [  3:0]  ch_1_index;
  reg        [  3:0]  ch_0_index;
  reg        [  8:0]  ch_7_base;
  reg        [  8:0]  ch_6_base;
  reg        [  8:0]  ch_5_base;
  reg        [  8:0]  ch_4_base;
  reg        [  8:0]  ch_3_base;
  reg        [  8:0]  ch_2_base;
  reg        [  8:0]  ch_1_base;
  reg        [  8:0]  ch_0_base;
  reg        [  3:0]  max_channel_transfer;
  reg        [ 31:0]  device_status_store;

  // internal wires

  wire                scko;
  wire                scko_s;
  wire                sdo;
  wire                conversion_completed;
  wire                conversion_quiet_time_s;

  wire                capture_complete_s;
  wire                capture_complete;

  wire                crc_reset;
  wire                crc_enable;
  wire                crc_valid;
  wire       [ 15:0]  crc_res;
  wire                sdo_p_s;
  wire                sdo_n_s;
  wire       [  8:0]  ch_index_20_pack [8:0];
  wire       [  8:0]  ch_index_24_pack [8:0];
  wire       [  8:0]  ch_index_32_pack [8:0];

  wire       [HBW:0]  rx_data_pos_s;
  wire       [HBW:0]  rx_data_neg_s;

  // assgments

  genvar j;
  generate
    for (j = 0; j <= N_CHANNELS; j = j + 1) begin
      assign ch_index_20_pack [j] = j * PACKET_1;
      assign ch_index_24_pack [j] = j * PACKET_2;
      assign ch_index_32_pack [j] = j * PACKET_3;
    end
  endgenerate

  always @(posedge clk) begin
    busy_m1 <= busy;
    busy_m2 <= busy_m1;
    start_transfer <= busy_m2 & !busy_m1;
    start_transfer_d <= start_transfer;
  end

  always @(posedge clk) begin
    packet_format <= packet_format_in;
    if (start_transfer) begin
      packet_cnt_length <= packet_format == 2'd0 ? PACKET_1 - 6'd4 :
                           packet_format == 2'd1 ? PACKET_2 - 6'd4 : PACKET_3 - 6'd4;
      max_channel_transfer <= adc_crc_enable ? N_CHANNELS : N_CHANNELS - 1;
      crc_enable_window <= adc_crc_enable;
    end
  end

  // busy period counter
  always @(posedge clk) begin
    if (cnvs == 1'b1 && busy_m2 == 1'b1) begin
      run_busy_period_cnt <= 1'b1;
    end else if (start_transfer == 1'b1) begin
      run_busy_period_cnt <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (adc_cnvs_redge == 1'b1) begin
      busy_conversion_cnt <= - 'd1; //adj for + 1 clk cycle measurement error
    end else if (run_busy_period_cnt == 1'b1) begin
      busy_conversion_cnt <= busy_conversion_cnt + 'd1;
    end
  end

  always @(posedge clk) begin
    if (start_transfer == 1'b1) begin
      busy_measure_value <= busy_conversion_cnt;
    end
  end

  always @(posedge clk) begin
    cnvs_d <= cnvs;
    if (oversampling_en == 1 && adc_cnvs_redge == 1'b1) begin
      conversion_quiet_time <= 1'b1;
    end else begin
      conversion_quiet_time <= conversion_quiet_time & ~conversion_completed;
    end
    if (adc_cnvs_redge == 1'b1) begin
      period_cnt <= 'd0;
    end else begin
      period_cnt <= period_cnt + 1;
    end
  end

  assign conversion_quiet_time_s = (oversampling_en == 1) ? conversion_quiet_time & !conversion_completed | cnvs : 1'b0;
  assign conversion_completed = (period_cnt == busy_measure_value) ? 1'b1 : 1'b0;
  assign adc_cnvs_redge = ~cnvs_d & cnvs;

  always @(posedge clk) begin
    if (aquire_data == 1'b0 || data_counter == packet_cnt_length) begin
      data_counter <= 2'h0;
    end else begin
      data_counter <= data_counter + 4;
    end

    if (start_transfer == 1'b1) begin
      ch_counter <= 4'h0;
    end else begin
      if (data_counter == packet_cnt_length) begin
        if (ch_counter == max_channel_transfer) begin
          ch_counter <= 4'h0;
        end else begin
          ch_counter <= ch_counter + 1;
        end
      end else begin
        ch_counter <= ch_counter;
      end
    end

    if (data_counter == packet_cnt_length && ch_counter == max_channel_transfer) begin
      aquire_data <= 1'b0;
      capture_complete_init <= 1'b1;
    end else if (aquire_data | start_transfer) begin
      aquire_data <= ~conversion_quiet_time_s;
      capture_complete_init <= 1'b0;
    end
    capture_complete_d <= capture_complete_init;
  end

  assign capture_complete_s = ~capture_complete_d & capture_complete_init;

  // valid delay (0 to 15)
  always @(posedge clk) begin
    dynamic_delay <= {dynamic_delay[14:0], capture_complete_s};
  end

  assign capture_complete = dynamic_delay[4'd10];

  IBUFDS i_scko_bufds (
    .O(scko_s),
    .I(scko_p),
    .IB(scko_n));

   // It is added to constraint the tool to keep the logic in the same region
   // as the input pins, otherwise the tool will automatically add a bufg and
   // meeting the timing margins is harder.
   BUFH BUFH_inst (
      .O(scko),
      .I(scko_s)
   );

  // receive

  ad_data_in #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQ),
    .IODELAY_CTRL (1),
    .IODELAY_ENABLE (IODELAY_ENABLE),
    .IDDR_CLK_EDGE ("OPPOSITE_EDGE")
  ) i_rx (
    .rx_clk (scko),
    .rx_data_in_p (sdo_p),
    .rx_data_in_n (sdo_n),
    .rx_data_p (sdo_p_s),
    .rx_data_n (sdo_n_s),
    .up_clk (up_clk),
    .up_dld (up_adc_dld),
    .up_dwdata (up_adc_dwdata[4:0]),
    .up_drdata (up_adc_drdata[4:0]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  always @(posedge scko) begin
    rx_data_pos <= {rx_data_pos[HBW-1:0], sdo_p_s};
  end
  always @(negedge scko) begin
    rx_data_neg <= {rx_data_neg[HBW-1:0], sdo_n_s};
  end

  assign rx_data_pos_s = {rx_data_pos[HBW-1:0], sdo_p_s};
  assign rx_data_neg_s = {rx_data_neg[HBW-1:0], sdo_n_s};

  genvar i;
  generate
    for (i = 0; i <= FBW - 1; i = i + 2) begin
      always @(posedge clk) begin
        if (capture_complete) begin
          adc_data_init[i+:2] <= {rx_data_pos_s[i>>1], rx_data_neg_s[i>>1]};
        end
      end
    end
  endgenerate

  always @(posedge clk) begin
    adc_valid_init <= capture_complete;
    adc_valid_init_d <= adc_valid_init;
    adc_valid_init_d2 <= adc_valid_init_d;
    adc_valid <= adc_valid_init_d2;
    adc_data_store <= adc_data_init; // relax timing
  end

  generate
    if (N_CHANNELS == 8) begin

      always @(posedge clk) begin
        if (start_transfer_d) begin
          ch_7_index <= crc_enable_window ? 1 : 0;
          ch_6_index <= crc_enable_window ? 2 : 1;
          ch_5_index <= crc_enable_window ? 3 : 2;
          ch_4_index <= crc_enable_window ? 4 : 3;
          ch_3_index <= crc_enable_window ? 5 : 4;
          ch_2_index <= crc_enable_window ? 6 : 5;
          ch_1_index <= crc_enable_window ? 7 : 6;
          ch_0_index <= crc_enable_window ? 8 : 7;
        end
      end

      always @(posedge clk) begin
        ch_7_base <= packet_format == 0 ? ch_index_20_pack[ch_7_index] :
                     packet_format == 1 ? ch_index_24_pack[ch_7_index] : ch_index_32_pack[ch_7_index];
        ch_6_base <= packet_format == 0 ? ch_index_20_pack[ch_6_index] :
                     packet_format == 1 ? ch_index_24_pack[ch_6_index] : ch_index_32_pack[ch_6_index];
        ch_5_base <= packet_format == 0 ? ch_index_20_pack[ch_5_index] :
                     packet_format == 1 ? ch_index_24_pack[ch_5_index] : ch_index_32_pack[ch_5_index];
        ch_4_base <= packet_format == 0 ? ch_index_20_pack[ch_4_index] :
                     packet_format == 1 ? ch_index_24_pack[ch_4_index] : ch_index_32_pack[ch_4_index];

        if (RESOLUTION == 16) begin
          adc_data_0[255:128] <= {16'b0,adc_data_store[ch_7_base+:16],
                                  16'b0,adc_data_store[ch_6_base+:16],
                                  16'b0,adc_data_store[ch_5_base+:16],
                                  16'b0,adc_data_store[ch_4_base+:16]};
        end else begin
          adc_data_0[255:128] <= {12'b0,adc_data_store[ch_7_base+:20],
                                  12'b0,adc_data_store[ch_6_base+:20],
                                  12'b0,adc_data_store[ch_5_base+:20],
                                  12'b0,adc_data_store[ch_4_base+:20]};
        end
        adc_data_1[255:128] <= {8'b0,adc_data_store[ch_7_base+:24],
                                8'b0,adc_data_store[ch_6_base+:24],
                                8'b0,adc_data_store[ch_5_base+:24],
                                8'b0,adc_data_store[ch_4_base+:24]};
        adc_data_2[255:128] <= {adc_data_store[ch_7_base+:32],
                                adc_data_store[ch_6_base+:32],
                                adc_data_store[ch_5_base+:32],
                                adc_data_store[ch_4_base+:32]};
      end
    end else begin
      always @(posedge clk) begin
        if (start_transfer_d) begin
          ch_3_index <= crc_enable_window ? 1 : 0;
          ch_2_index <= crc_enable_window ? 2 : 1;
          ch_1_index <= crc_enable_window ? 3 : 2;
          ch_0_index <= crc_enable_window ? 4 : 3;
        end
      end
    end

    always @(posedge clk) begin
      ch_3_base <= packet_format == 0 ? ch_index_20_pack[ch_3_index] :
                   packet_format == 1 ? ch_index_24_pack[ch_3_index] : ch_index_32_pack[ch_3_index];
      ch_2_base <= packet_format == 0 ? ch_index_20_pack[ch_2_index] :
                   packet_format == 1 ? ch_index_24_pack[ch_2_index] : ch_index_32_pack[ch_2_index];
      ch_1_base <= packet_format == 0 ? ch_index_20_pack[ch_1_index] :
                   packet_format == 1 ? ch_index_24_pack[ch_1_index] : ch_index_32_pack[ch_1_index];
      ch_0_base <= packet_format == 0 ? ch_index_20_pack[ch_0_index] :
                   packet_format == 1 ? ch_index_24_pack[ch_0_index] : ch_index_32_pack[ch_0_index];

      if (RESOLUTION == 16) begin
        adc_data_0[127:0] <= {16'b0,adc_data_store[ch_3_base+:16],
                              16'b0,adc_data_store[ch_2_base+:16],
                              16'b0,adc_data_store[ch_1_base+:16],
                              16'b0,adc_data_store[ch_0_base+:16]};
      end else if (RESOLUTION == 20) begin
        adc_data_0[127:0] <= {12'b0,adc_data_store[ch_3_base+:20],
                              12'b0,adc_data_store[ch_2_base+:20],
                              12'b0,adc_data_store[ch_1_base+:20],
                              12'b0,adc_data_store[ch_0_base+:20]};
      end
      adc_data_1[127:0] <= {8'b0,adc_data_store[ch_3_base+:24],
                            8'b0,adc_data_store[ch_2_base+:24],
                            8'b0,adc_data_store[ch_1_base+:24],
                            8'b0,adc_data_store[ch_0_base+:24]};
      adc_data_2[127:0] <= {adc_data_store[ch_3_base+:32],
                            adc_data_store[ch_2_base+:32],
                            adc_data_store[ch_1_base+:32],
                            adc_data_store[ch_0_base+:32]};
    end
  endgenerate

  always @(posedge clk) begin
    if (crc_enable_window == 1'b1) begin
      device_status_store <= adc_data_store[31:0];
    end else begin
      device_status_store <= 0;
    end
  end

  always @(posedge clk) begin
    case (packet_format)
      2'h0: begin
        adc_data <= adc_data_0;
        dev_status <= device_status_store[19:0];
      end
      2'h1: begin
        adc_data <= adc_data_1;
        dev_status <= device_status_store[23:0];
      end
      2'h2: begin
        adc_data <= adc_data_2;
        dev_status <= device_status_store[31:0];
      end
      2'h3: begin
        adc_data <= adc_data_2;
        dev_status <= device_status_store[31:0];
      end
    endcase
  end

  // CRC checker logic

  always @(posedge clk) begin
    if (adc_valid_init_d == 1) begin
      if (N_CHANNELS == 8) begin
        if (packet_format == 0) begin
          if (RESOLUTION == 16) begin
            crc_data_in <= {adc_data_store[143:0], 144'd0};
          end else if (RESOLUTION == 20) begin
            crc_data_in <= {adc_data_store[179:0], 108'd0};
          end
        end else if (packet_format == 1) begin
          crc_data_in <= {adc_data_store[215:0], 72'd0};
        end else  begin
          crc_data_in <= {adc_data_store};
        end
      end else begin // quad channel
        if (packet_format == 0) begin
          if (RESOLUTION == 16) begin
            crc_data_in <= {adc_data_store[79:0], 80'd0};
          end else if (RESOLUTION == 20) begin
            crc_data_in <= {4'd0, adc_data_store[99:0], 56'd0};
          end
        end else if (packet_format == 1) begin
          crc_data_in <= {adc_data_store[119:0], 40'd0};
        end else  begin
          crc_data_in <= {adc_data_store};
        end
      end
    end
  end

  // As an optimization, a crc checker with 8 parallel operations per clk cycle
  // will be used for all packet formats.
  // The channel plus status and crc data will be feed in byte packets to the
  // crc checker.
  // When packet_format is 20 bits, 20x8+20(st and crc) = 180 which is not a
  // multiple of 8. So, we will feed 184 bits, which is a multiple of 8.
  // Last extra 4 bits entering the checker being 0, will not affect the result
  always @(posedge clk) begin
    if (N_CHANNELS == 8) begin
      if (RESOLUTION == 16) begin
        crc_data_length <= packet_format == 2'd0 ? 16'd144 : 16'd208;
      end else if (RESOLUTION == 20) begin
        crc_data_length <= packet_format == 2'd0 ? 16'd176 : // 184-8
                           packet_format == 2'd1 ? 16'd208 : 16'd280;
      end
    end else begin // quad channel
      if (RESOLUTION == 16) begin
        crc_data_length <= packet_format == 2'd0 ? 16'd80 : 16'd120;
      end else if (RESOLUTION == 20) begin
        crc_data_length <= packet_format == 2'd0 ? 16'd104 :
                           packet_format == 2'd1 ? 16'd120 : 16'd160;
      end
    end
  end

  always @(posedge clk) begin
    if (adc_valid_init_d2 == 1'b1) begin
      crc_cnt <= crc_data_length;
      run_crc <= (crc_enable_window == 1) ? 1'b1 : 1'b0;
    end else begin
      if (run_crc == 1'b1) begin
        if (crc_cnt == 0) begin
          run_crc <= 1'b0;
        end else begin
          crc_cnt <= crc_cnt - 8;
        end
      end
    end
    // the counter is initialized with n-1 to accommodate the byte shifter
    run_crc_d <= run_crc;
  end

  always @(posedge clk) begin
    if (adc_valid_init_d2 == 1'b1) begin
      crc_data_in_sh <= crc_data_in;
    end else if (run_crc == 1'b1) begin
      crc_data_in_sh <= crc_data_in_sh << 8;
    end
  end

  always @(posedge clk) begin
    if (run_crc == 1'b1) begin
      data_in_byte <= crc_data_in_sh[FBW:FBW-7];
    end else begin
      data_in_byte <= 8'd0;
    end
  end

  assign crc_reset = adc_valid_init_d2;
  assign crc_enable = run_crc_d | run_crc;

  always @(posedge clk) begin
    if (crc_valid == 1) begin
      if (crc_res == 16'd0) begin
        crc_error <= 1'd0;
      end else begin
        crc_error <= 1'd1;
      end
    end
  end

  axi_ad485x_crc i_ad485x_crc_8 (
    .rst (crc_reset),
    .clk (clk),
    .crc_en (crc_enable),
    .d_in (data_in_byte),
    .crc_valid (crc_valid),
    .crc_res (crc_res));

  ad_serdes_out #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .DDR_OR_SDR_N(1'b1),
    .DATA_WIDTH(1),
    .SERDES_FACTOR(4)
  ) i_scki_out (
    .rst(rst),
    .clk(fast_clk),
    .div_clk(clk),
    .data_oe(1'b1),
    .data_s0(1'b0),
    .data_s1(aquire_data),
    .data_s2(1'b0),
    .data_s3(aquire_data),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_out_se (),
    .data_out_p(scki_p),
    .data_out_n(scki_n));

endmodule
