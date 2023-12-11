// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2023(c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL(Verilog or VHDL) components. The individual modules are
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
//      of this repository(LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository(LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad408x_phy #(
  parameter FPGA_TECHNOLOGY = 0,
  parameter DRP_WIDTH = 5,
  parameter NUM_LANES = 2,  // Max number of lanes is 2 
  parameter DDR_SUPPORT = 1,
  parameter IODELAY_CTRL = 1,
  parameter IO_DELAY_GROUP = "dev_if_delay_group"
) (

  // device interface
  input                             dclk_in_n,
  input                             dclk_in_p,
  input                             data_a_in_n,
  input                             data_a_in_p,
  input                             data_b_in_n,
  input                             data_b_in_p,

  // control interface

  input                              sync_n,

    // Assumption:
    //  control bits are static after sync_n de-assertion

  input                             sdr_ddr_n,
  input        [4:0]                num_lanes,
  input                             ddr_edge_sel,

  // In uncorrected mode for each sample 80 bits are transferred
  // the 20 LSBs are the corrected sample, the other bits are debug info

  input                             uncorrected_mode,

  // delay interface(for IDELAY macros)

  input                             up_clk,
  input   [NUM_LANES-1:0]           up_adc_dld,
  input   [DRP_WIDTH*NUM_LANES-1:0] up_adc_dwdata,
  output  [DRP_WIDTH*NUM_LANES-1:0] up_adc_drdata,
  input                             delay_clk,
  input                             delay_rst,
  output                            delay_locked,

  // internal reset and clocks

  input                             adc_rst,
  output                            adc_clk,
  output                            adc_clk_div,

  output      [31:0]                adc_data,
  output                            adc_valid,
  
  output      [127:0]               adc_uncor_data,
  output                            adc_uncor_valid,

  // Debug interface

  output                            clk_in_s,
  input                             bitslip_enable,
  output                            sync_status
);

  // Use always DDR mode for SERDES, useful for SDR mode to adjust capture

  localparam DDR_OR_SDR_N    = 1;
  localparam CMOS_LVDS_N     = 0; // Use always LVDS mode
  localparam SEVEN_SERIES    = 1;
  localparam ULTRASCALE      = 2;
  localparam ULTRASCALE_PLUS = 3;

// Assumptions:
//  A replica of sync_n on the external board serves as a reset signal
//  for the clock received on the dclk_in_n/p pairs
//  Clock will stay low if sync_n is low, once sync_n deasserts after an
//  undefined amount of time the clock will start to toggle, glitch-less
//  having a smooth start.
//  Framing information will be reconstructed based on this assumption.
//
// Serdes reset
//
//  When deasserted synchronously with CLKDIV, internal logic re-times this
//  deassertion to the first rising edge of CLK
//  The reset signal should only be deasserted when it is known that CLK
//  and CLKDIV are stable and present, and should be a minimum of two CLKDIV pulses
//  wide. After deassertion of reset, the output is not valid until after two CLKDIV cycles.
// Serdes factor
//  A sample has 20 bits, this can be transferred either on one lane or two
//  lanes, SDR or DDR.
//
//                                             clk_div per sample
//   single_lane sdr_ddr_n  | dclk per sample | /5    | /4
//   0           0          | 5               | 1     | 1.25
//   0           1          | 10              | 2     | 2.5
//   1           0          | 10              | 2     | 2.5
//   1           1          | 20              | 4     | 5
//
//   To accommodate all cases a serdes factor of 10 could be used in DDR mode
//   with a clock division of 5. This requires a cascaded serdes
//   configuration. However this will work only in 7 series devices.
//   Instead a serdes factor of 8 is used to support ultrascale devices too
//  (which do not have the cascaded mode with a factor of 10). This requires
//   additional packer circuitry from 4/8/16 bits to 20 bits depending on
//   mode.
//
// Serdes output valid
//   The latency of serdes in 7 series is two div_clk cycles. Output valid of
//   the serdes will assert two cock cycles later its reset de-asserts.


  // internal wire

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

  assign single_lane = num_lanes[0];
  assign sdr_ddr_loc_n = DDR_SUPPORT ? sdr_ddr_n : 1'b1;
  assign sync_status = sync_status_int;

  //
  // data interface
  //
  
  IBUFGDS i_clk_in_ibuf(
    .I(dclk_in_p),
    .IB(dclk_in_n),
    .O(clk_in_s));

  generate
  if(FPGA_TECHNOLOGY == SEVEN_SERIES) begin

    BUFIO i_clk_buf(
      .I(clk_in_s),
      .O(adc_clk_in_fast));

    BUFR #(.BUFR_DIVIDE("4")) i_div_clk_buf(
      .CLR(~sync_n),
      .CE(1'b1),
      .I(clk_in_s),
      .O(adc_clk_div));

  end else begin

    BUFGCE #(
       .CE_TYPE("SYNC"),
       .IS_CE_INVERTED(1'b0),
       .IS_I_INVERTED(1'b0)
    ) i_clk_buf_fast(
       .O(adc_clk_in_fast),
       .CE(1'b1),
       .I(clk_in_s)
    );

    BUFGCE_DIV #(
       .BUFGCE_DIVIDE(4),
       .IS_CE_INVERTED(1'b0),
       .IS_CLR_INVERTED(1'b0),
       .IS_I_INVERTED(1'b0)
    ) i_div_clk_buf(
       .O(adc_clk_div),
       .CE(1'b1),
       .CLR(~sync_n),
       .I(clk_in_s)
    );

  end
  endgenerate

  assign serdes_in_p = {data_b_in_p, data_a_in_p};
  assign serdes_in_n = {data_b_in_n, data_a_in_n};

  // Min 2 div_clk cycles once div_clk is running after deassertion of sync
  // Control externally the reset of serdes for precise timing

  reg [5:0] serdes_reset = 6'b000110;

  always @(posedge adc_clk_div or negedge sync_n) begin
    if(~sync_n) begin
      serdes_reset <= 6'b000110;
    end else begin
      serdes_reset <= {serdes_reset[4:0],1'b0};
    end
  end
  assign serdes_reset_s = serdes_reset[5];

  ad_serdes_in #(
    .CMOS_LVDS_N(CMOS_LVDS_N),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_CTRL(IODELAY_CTRL),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(DDR_OR_SDR_N),
    .DATA_WIDTH(NUM_LANES),
    .DRP_WIDTH(DRP_WIDTH),
    .SERDES_FACTOR(8),
    .EXT_SERDES_RESET(1)
  ) i_serdes(
    .rst(serdes_reset_s),
    .ext_serdes_rst(serdes_reset_s),
    .clk(adc_clk_in_fast),
    .div_clk(adc_clk_div),
    .data_s0(data_s0),
    .data_s1(data_s1),
    .data_s2(data_s2),
    .data_s3(data_s3),
    .data_s4(data_s4),
    .data_s5(data_s5),
    .data_s6(data_s6),
    .data_s7(data_s7),
    .data_in_p(serdes_in_p),
    .data_in_n(serdes_in_n),
    .up_clk(up_clk),
    .up_dld(up_adc_dld),
    .up_dwdata(up_adc_dwdata),
    .up_drdata(up_adc_drdata),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked));

  wire      [7:0]       serdes_data_0;
  wire      [7:0]       serdes_data_1;

  assign {serdes_data_1[0],serdes_data_0[0]} = data_s0;  // f-e latest bit received
  assign {serdes_data_1[1],serdes_data_0[1]} = data_s1;  // r-e
  assign {serdes_data_1[2],serdes_data_0[2]} = data_s2;  // f-e
  assign {serdes_data_1[3],serdes_data_0[3]} = data_s3;  // r-e
  assign {serdes_data_1[4],serdes_data_0[4]} = data_s4;  // f-e
  assign {serdes_data_1[5],serdes_data_0[5]} = data_s5;  // r-e
  assign {serdes_data_1[6],serdes_data_0[6]} = data_s6;  // f-e
  assign {serdes_data_1[7],serdes_data_0[7]} = data_s7;  // r-e oldest bit received

  // Assert serdes valid after 2 clock cycles is pulled out of reset

  reg [1:0] serdes_valid = 2'b00;

  always @(posedge adc_clk_div) begin
    if(serdes_reset_s) begin
      serdes_valid <= 2'b00;
    end else begin
      serdes_valid <= {serdes_valid[0],1'b1};
    end
  end

  wire [ 3:0] serdes_data_4_lane0;
  wire [ 3:0] serdes_data_4_lane1;
  wire [ 7:0] serdes_data_8;
  wire [15:0] serdes_data_16;

  // The serdes produces 8 bits at a div_clk cycle
  // In SDR only half of those bits are valid,
  //
  //  mode           | number of valid bits per div_clk beat
  //  sdr singe lane    4 bits
  //  sdr dual lane     8 bits
  //  ddr single lane   8 bits
  //  ddr dual lane     16 bits
  //
  //  ddr_edge_sel - 0 posedge
  //                 1 negedge
  
  assign serdes_data_4_lane0 = ddr_edge_sel ? {serdes_data_0[6],
                                               serdes_data_0[4],
                                               serdes_data_0[2],
                                               serdes_data_0[0]}
                                            : {serdes_data_0[7],
                                               serdes_data_0[5],
                                               serdes_data_0[3],
                                               serdes_data_0[1]};

  assign serdes_data_4_lane1 = ddr_edge_sel ? {serdes_data_1[6],
                                               serdes_data_1[4],
                                               serdes_data_1[2],
                                               serdes_data_1[0]}
                                            : {serdes_data_1[7],
                                               serdes_data_1[5],
                                               serdes_data_1[3],
                                               serdes_data_1[1]};

  // For SDR(dual lane) take data from two lanes interleaved
  // for DDR(single lane) take data from a single lane

  assign serdes_data_8 = sdr_ddr_loc_n ? {serdes_data_4_lane0[3],
                                      serdes_data_4_lane1[3],
                                      serdes_data_4_lane0[2],
                                      serdes_data_4_lane1[2],
                                      serdes_data_4_lane0[1],
                                      serdes_data_4_lane1[1],
                                      serdes_data_4_lane0[0],
                                      serdes_data_4_lane1[0]}
                                   : serdes_data_0;

  // For DDR dual lane interleave the two sedres outputs;

  assign serdes_data_16 = {serdes_data_0[7],
                           serdes_data_1[7],
                           serdes_data_0[6],
                           serdes_data_1[6],
                           serdes_data_0[5],
                           serdes_data_1[5],
                           serdes_data_0[4],
                           serdes_data_1[4],
                           serdes_data_0[3],
                           serdes_data_1[3],
                           serdes_data_0[2],
                           serdes_data_1[2],
                           serdes_data_0[1],
                           serdes_data_1[1],
                           serdes_data_0[0],
                           serdes_data_1[0]};

  wire [19:0] packed_4_20;
  wire [19:0] packed_8_20;
  wire [19:0] packed_16_20;
  wire [79:0] packed_20_80;
  wire        pack80_valid;

  ad_pack #(
    .I_W(4),
    .O_W(20),
    .UNIT_W(1),
    .ALIGN_TO_MSB(1)
  ) i_ad_pack_4(
    .clk(adc_clk_div),
    .reset(~serdes_valid[0]),
    .idata(serdes_data_4_lane0),
    .ivalid(serdes_valid[1]),
    .odata(packed_4_20),
    .ovalid(pack4_valid)
  );

  ad_pack #(
    .I_W(8),
    .O_W(20),
    .UNIT_W(1),
    .ALIGN_TO_MSB(1)
  ) i_ad_pack_8(
    .clk(adc_clk_div),
    .reset(~serdes_valid[0]),
    .idata(serdes_data_8),
    .ivalid(serdes_valid[1]),
    .odata(packed_8_20),
    .ovalid(pack8_valid)
  );

  ad_pack #(
    .I_W(16),
    .O_W(20),
    .UNIT_W(1),
    .ALIGN_TO_MSB(1)
  ) i_ad_pack_16(
    .clk(adc_clk_div),
    .reset(~serdes_valid[0]),
    .idata(serdes_data_16),
    .ivalid(serdes_valid[1]),
    .odata(packed_16_20),
    .ovalid(pack16_valid)
  );

  reg [19:0] packed_data;
  reg        packed_data_valid;

  always @(*) begin
    case({single_lane,sdr_ddr_loc_n})
      2'b00 : packed_data = packed_16_20;
      2'b01 : packed_data = packed_8_20;
      2'b10 : packed_data = packed_8_20;
      2'b11 : packed_data = packed_4_20;
    endcase
  end

  always @(*) begin
    case({single_lane,sdr_ddr_loc_n})
      2'b00 : packed_data_valid = pack16_valid;
      2'b01 : packed_data_valid = pack8_valid;
      2'b10 : packed_data_valid = pack8_valid;
      2'b11 : packed_data_valid = pack4_valid;
    endcase
  end

  // Align data
  // Use different rotations based on selected mode
  // Latency from first clock edge post sync_n deasertion to the first valid
  // output of the packer should be constant allowing for a constant rotation every time.

  reg [19:0] packed_data_d;

  always @(posedge adc_clk_div) begin
    if(packed_data_valid) begin
      packed_data_d <= packed_data;
    end
  end
  
  reg  [ 4:0]  shift_cnt = 5'd0;
  reg          shift_cnt_en = 1'b0;
  reg          sync_status_int = 1'b0;
  reg          slip_d;
  reg          slip_dd;

  wire         shift_cnt_en_s;
  wire [ 4:0]  shift_cnt_value;
  wire [19:0]  pattern_value;

  always @(posedge adc_clk_div) begin
    slip_d <= bitslip_enable;
    slip_dd <= slip_d;
    if(serdes_reset_s || adc_data_shifted == pattern_value)
      shift_cnt_en <= 1'b0;
    else if(slip_d & ~slip_dd)
      shift_cnt_en <= 1'b1;
  end

  assign shift_cnt_value = 'd19;
  assign  pattern_value = 20'hac5d6;

  always @(posedge adc_clk_div) begin
    if(shift_cnt_en) begin
      if(shift_cnt == shift_cnt_value || serdes_reset_s) begin
        shift_cnt <= 0;
        sync_status_int <= 1'b0;
      end else if( adc_data_shifted != pattern_value &&(packed_data_valid_d & ~packed_data_valid) ) begin
        shift_cnt <= shift_cnt + 1;
      end
      if(adc_data_shifted == pattern_value) begin 
        sync_status_int <= 1'b1;
      end
    end
  end

  reg [19:0]  adc_data_shifted;
  reg packed_data_valid_d;

  always @(posedge adc_clk_div) begin
    // >> 1 for sdr,single lane
    // >> 14 for sdr,dual lane
    adc_data_shifted <= {packed_data_d,packed_data} >> shift_cnt;
    packed_data_valid_d <= packed_data_valid;
  end

  // Sign extend to 32 bits

  assign adc_data =  ~uncorrected_mode ? {{12{adc_data_shifted[19]}},adc_data_shifted} :
                                         {{12{packed_20_80[19]}},packed_20_80[19:0]};
  assign adc_valid = ~uncorrected_mode ? packed_data_valid_d : pack80_valid;

  // Pack to 80 bit for the uncorrected mode
  // Start packing after first three samples since first sample is not
  // received fully

  reg [2:0] pack_rst = 3'b111;

  always @(posedge adc_clk_div) begin
    packed_data_valid_d <= packed_data_valid;
    if(packed_data_valid_d)
      pack_rst <= {pack_rst,1'b0};
  end
  
  ad_pack #(
    .I_W(20),
    .O_W(80),
    .UNIT_W(1),
    .ALIGN_TO_MSB(1)
  ) i_ad_pack_80(
    .clk(adc_clk_div),
    .reset(pack_rst[2]),
    .idata(adc_data_shifted),
    .ivalid(packed_data_valid_d),
    .odata(packed_20_80),
    .ovalid(pack80_valid)
  );

  assign adc_uncor_valid = uncorrected_mode ? pack80_valid : 1'b0;
  assign adc_uncor_data = {48'b0,packed_20_80};

endmodule
