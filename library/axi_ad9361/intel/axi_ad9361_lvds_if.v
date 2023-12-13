// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad9361_lvds_if #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   DAC_IODELAY_ENABLE = 0,
  parameter   CLK_DESKEW = 0,

  // Dummy parameters, required keep the code consistency(used on Xilinx)
  parameter   USE_SSI_CLK = 1,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group",
  parameter   IODELAY_CTRL = 1,
  parameter   DELAY_REFCLK_FREQUENCY = 0,
  parameter   RX_NODPA = 0
) (

  // physical interface (receive)

  input               rx_clk_in_p,
  input               rx_clk_in_n,
  input               rx_frame_in_p,
  input               rx_frame_in_n,
  input   [ 5:0]      rx_data_in_p,
  input   [ 5:0]      rx_data_in_n,

  // physical interface (transmit)

  output              tx_clk_out_p,
  output              tx_clk_out_n,
  output              tx_frame_out_p,
  output              tx_frame_out_n,
  output  [ 5:0]      tx_data_out_p,
  output  [ 5:0]      tx_data_out_n,

  // ensm control

  output              enable,
  output              txnrx,

  // clock (common to both receive and transmit)

  input               rst,
  input               clk,
  output              l_clk,

  // receive data path interface

  output              adc_valid,
  output      [47:0]  adc_data,
  output              adc_status,
  input               adc_r1_mode,
  input               adc_ddr_edgesel,

  // transmit data path interface

  input               dac_valid,
  input   [47:0]      dac_data,
  input               dac_clksel,
  input               dac_r1_mode,

  // tdd interface

  input               tdd_enable,
  input               tdd_txnrx,
  input               tdd_mode,

  // delay interface

  input               mmcm_rst,
  input               up_clk,
  input               up_rstn,
  input               up_enable,
  input               up_txnrx,
  input   [ 6:0]      up_adc_dld,
  input   [34:0]      up_adc_dwdata,
  output  [34:0]      up_adc_drdata,
  input   [ 9:0]      up_dac_dld,
  input   [49:0]      up_dac_dwdata,
  output  [49:0]      up_dac_drdata,
  input               delay_clk,
  input               delay_rst,
  output              delay_locked,

  // drp interface

  input               up_drp_sel,
  input               up_drp_wr,
  input   [11:0]      up_drp_addr,
  input   [31:0]      up_drp_wdata,
  output  [31:0]      up_drp_rdata,
  output              up_drp_ready,
  output              up_drp_locked
);

  // internal registers

  reg                 up_drp_locked_m1 = 1'd0;
  reg                 up_drp_locked_int = 1'd0;
  reg                 rx_r1_mode = 'd0;
  reg     [ 3:0]      rx_frame_d = 'd0;
  reg     [ 5:0]      rx_data_3 = 'd0;
  reg     [ 5:0]      rx_data_2 = 'd0;
  reg     [ 5:0]      rx_data_1 = 'd0;
  reg                 adc_valid_p = 'd0;
  reg     [47:0]      adc_data_p = 'd0;
  reg                 adc_status_p = 'd0;
  reg                 adc_valid_int = 'd0;
  reg     [47:0]      adc_data_int = 'd0;
  reg                 adc_status_int = 'd0;
  reg                 tx_valid = 'd0;
  reg     [47:0]      tx_data = 'd0;
  reg     [ 3:0]      tx_frame_p = 'd0;
  reg     [ 5:0]      tx_data_0_p = 'd0;
  reg     [ 5:0]      tx_data_1_p = 'd0;
  reg     [ 5:0]      tx_data_2_p = 'd0;
  reg     [ 5:0]      tx_data_3_p = 'd0;
  reg     [ 3:0]      tx_frame = 'd0;
  reg     [ 5:0]      tx_data_0 = 'd0;
  reg     [ 5:0]      tx_data_1 = 'd0;
  reg     [ 5:0]      tx_data_2 = 'd0;
  reg     [ 5:0]      tx_data_3 = 'd0;
  reg                 up_enable_int = 'd0;
  reg                 up_txnrx_int = 'd0;
  reg                 enable_up_m1 = 'd0;
  reg                 txnrx_up_m1 = 'd0;
  reg                 enable_up = 'd0;
  reg                 txnrx_up = 'd0;
  reg                 enable_int = 'd0;
  reg                 txnrx_int = 'd0;
  reg                 enable_int_p = 'd0;
  reg                 txnrx_int_p = 'd0;

  // internal signals

  wire                locked_s;
  wire    [ 3:0]      rx_frame_s;
  wire    [ 5:0]      rx_data_3_s;
  wire    [ 5:0]      rx_data_2_s;
  wire    [ 5:0]      rx_data_1_s;
  wire    [ 5:0]      rx_data_0_s;

  // local parameters

  localparam CYCLONE5 = 101;
  localparam ARRIA10  = 103;

  // unused interface signals

  assign up_adc_drdata = 35'b0;
  assign up_dac_drdata = 50'b0;
  assign delay_locked = 1'b1;

  // drp locked must be on up-clock

  assign up_drp_locked = up_drp_locked_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_drp_locked_m1 <= 1'd0;
      up_drp_locked_int <= 1'd0;
    end else begin
      up_drp_locked_m1 <= locked_s;
      up_drp_locked_int <= up_drp_locked_m1;
    end
  end

  // r1mode

  generate if (CLK_DESKEW) begin

    reg adc_r1_mode_n = 'd0;

    always @(negedge clk) begin
      adc_r1_mode_n <= adc_r1_mode;
    end

    always @(posedge l_clk) begin
      rx_r1_mode <= adc_r1_mode_n;
    end

  end else begin /* CLK_DESKEW == 0 */

    always @(posedge l_clk) begin
      rx_r1_mode <= adc_r1_mode;
    end

  end
  endgenerate

  // frame check

  always @(posedge l_clk) begin
    if (rx_r1_mode == 1'd1) begin
      rx_frame_d <= rx_frame_s;
    end else begin
      rx_frame_d <= ~rx_frame_s;
    end
  end

  // data hold

  always @(posedge l_clk) begin
    rx_data_3 <= rx_data_3_s;
    rx_data_2 <= rx_data_2_s;
    rx_data_1 <= rx_data_1_s;
  end

  // delineation

  always @(posedge l_clk) begin
    case ({rx_r1_mode, rx_frame_s})
      5'b01111: begin
        adc_valid_p <= 1'b0;
        adc_data_p[47:24] <= 24'd0;
        adc_data_p[23:12] <= {rx_data_1_s, rx_data_3_s};
        adc_data_p[11: 0] <= {rx_data_0_s, rx_data_2_s};
      end
      5'b00000: begin
        adc_valid_p <= 1'b1;
        adc_data_p[47:36] <= {rx_data_1_s, rx_data_3_s};
        adc_data_p[35:24] <= {rx_data_0_s, rx_data_2_s};
        adc_data_p[23: 0] <= adc_data_p[23:0];
      end
      5'b00111: begin
        adc_valid_p <= 1'b0;
        adc_data_p[47:24] <= 24'd0;
        adc_data_p[23:12] <= {rx_data_0_s, rx_data_2_s};
        adc_data_p[11: 0] <= {rx_data_3, rx_data_1_s};
      end
      5'b01000: begin
        adc_valid_p <= 1'b1;
        adc_data_p[47:36] <= {rx_data_0_s, rx_data_2_s};
        adc_data_p[35:24] <= {rx_data_3, rx_data_1_s};
        adc_data_p[23: 0] <= adc_data_p[23:0];
      end
      5'b00011: begin
        adc_valid_p <= 1'b0;
        adc_data_p[47:24] <= 24'd0;
        adc_data_p[23:12] <= {rx_data_3, rx_data_1_s};
        adc_data_p[11: 0] <= {rx_data_2, rx_data_0_s};
      end
      5'b01100: begin
        adc_valid_p <= 1'b1;
        adc_data_p[47:36] <= {rx_data_3, rx_data_1_s};
        adc_data_p[35:24] <= {rx_data_2, rx_data_0_s};
        adc_data_p[23: 0] <= adc_data_p[23:0];
      end
      5'b00001: begin
        adc_valid_p <= 1'b0;
        adc_data_p[47:24] <= 24'd0;
        adc_data_p[23:12] <= {rx_data_2, rx_data_0_s};
        adc_data_p[11: 0] <= {rx_data_1, rx_data_3};
      end
      5'b01110: begin
        adc_valid_p <= 1'b1;
        adc_data_p[47:36] <= {rx_data_2, rx_data_0_s};
        adc_data_p[35:24] <= {rx_data_1, rx_data_3};
        adc_data_p[23: 0] <= adc_data_p[23:0];
      end
      5'b10011: begin
        adc_valid_p <= 1'b1;
        adc_data_p[47:24] <= 24'd0;
        adc_data_p[23:12] <= {rx_data_1_s, rx_data_3_s};
        adc_data_p[11: 0] <= {rx_data_0_s, rx_data_2_s};
      end
      5'b11001: begin
        adc_valid_p <= 1'b1;
        adc_data_p[47:24] <= 24'd0;
        adc_data_p[23:12] <= {rx_data_0_s, rx_data_2_s};
        adc_data_p[11: 0] <= {rx_data_3, rx_data_1_s};
      end
      5'b11100: begin
        adc_valid_p <= 1'b1;
        adc_data_p[47:24] <= 24'd0;
        adc_data_p[23:12] <= {rx_data_3, rx_data_1_s};
        adc_data_p[11: 0] <= {rx_data_2, rx_data_0_s};
      end
      5'b10110: begin
        adc_valid_p <= 1'b1;
        adc_data_p[47:24] <= 24'd0;
        adc_data_p[23:12] <= {rx_data_2, rx_data_0_s};
        adc_data_p[11: 0] <= {rx_data_1, rx_data_3};
      end
      default: begin
        adc_valid_p <= 1'b0;
        adc_data_p <= 48'd0;
      end
    endcase
  end

  // adc-status

  always @(posedge l_clk) begin
    if (rx_frame_d == rx_frame_s) begin
      adc_status_p <= locked_s;
    end else begin
      adc_status_p <= 1'b0;
    end
  end

  // transfer to common clock

  generate if (CLK_DESKEW) begin

    reg         adc_valid_n = 'd0;
    reg [47:0]  adc_data_n = 'd0;
    reg         adc_status_n = 'd0;

    always @(negedge l_clk) begin
      adc_valid_n <= adc_valid_p;
      adc_data_n <= adc_data_p;
      adc_status_n <= adc_status_p;
    end

    always @(posedge clk) begin
      adc_valid_int <= adc_valid_n;
      adc_data_int <= adc_data_n;
      adc_status_int <= adc_status_n;
    end

  end else begin /* CLK_DESKEW == 0 */

    always @(posedge l_clk) begin
      adc_valid_int <= adc_valid_p;
      adc_data_int <= adc_data_p;
      adc_status_int <= adc_status_p;
    end

  end
  endgenerate

  assign adc_valid = adc_valid_int;
  assign adc_data = adc_data_int;
  assign adc_status = adc_status_int;

  // dac-tx interface

  always @(posedge clk) begin
    tx_valid <= dac_valid;
    if (dac_valid == 1'b1) begin
      tx_data <= dac_data;
    end
  end

  always @(posedge clk) begin
    if (dac_r1_mode == 1'b1) begin
      tx_frame_p <= 4'b0011;
      tx_data_0_p <= tx_data[11: 6];
      tx_data_1_p <= tx_data[23:18];
      tx_data_2_p <= tx_data[ 5: 0];
      tx_data_3_p <= tx_data[17:12];
    end else if (tx_valid == 1'b1) begin
      tx_frame_p <= 4'b1111;
      tx_data_0_p <= tx_data[11: 6];
      tx_data_1_p <= tx_data[23:18];
      tx_data_2_p <= tx_data[ 5: 0];
      tx_data_3_p <= tx_data[17:12];
    end else begin
      tx_frame_p <= 4'b0000;
      tx_data_0_p <= tx_data[35:30];
      tx_data_1_p <= tx_data[47:42];
      tx_data_2_p <= tx_data[29:24];
      tx_data_3_p <= tx_data[41:36];
    end
  end

  // transfer to local clock

  generate if (CLK_DESKEW) begin

    reg         tx_frame_n = 'd0;
    reg [ 5:0]  tx_data_0_n = 'd0;
    reg [ 5:0]  tx_data_1_n = 'd0;
    reg [ 5:0]  tx_data_2_n = 'd0;
    reg [ 5:0]  tx_data_3_n = 'd0;

    always @(negedge clk) begin
      tx_frame_n <= tx_frame_p;
      tx_data_0_n <= tx_data_0_p;
      tx_data_1_n <= tx_data_1_p;
      tx_data_2_n <= tx_data_2_p;
      tx_data_3_n <= tx_data_3_p;
    end

    always @(posedge l_clk) begin
      tx_frame <= tx_frame_n;
      tx_data_0 <= tx_data_0_n;
      tx_data_1 <= tx_data_1_n;
      tx_data_2 <= tx_data_2_n;
      tx_data_3 <= tx_data_3_n;
    end

  end else begin /* CLK_DESKEW == 0 */

    always @(posedge l_clk) begin
      tx_frame <= tx_frame_p;
      tx_data_0 <= tx_data_0_p;
      tx_data_1 <= tx_data_1_p;
      tx_data_2 <= tx_data_2_p;
      tx_data_3 <= tx_data_3_p;
    end

  end
  endgenerate

  // tdd/ensm control

  always @(posedge up_clk) begin
    up_enable_int <= up_enable;
    up_txnrx_int <= up_txnrx;
  end

  always @(posedge clk or posedge rst) begin
    if (rst == 1'b1) begin
      enable_up_m1 <= 1'b0;
      txnrx_up_m1 <= 1'b0;
      enable_up <= 1'b0;
      txnrx_up <= 1'b0;
    end else begin
      enable_up_m1 <= up_enable_int;
      txnrx_up_m1 <= up_txnrx_int;
      enable_up <= enable_up_m1;
      txnrx_up <= txnrx_up_m1;
    end
  end

  always @(posedge clk) begin
    if (tdd_mode == 1'b1) begin
      enable_int <= tdd_enable;
      txnrx_int <= tdd_txnrx;
    end else begin
      enable_int <= enable_up;
      txnrx_int <= txnrx_up;
    end
  end

  generate if (CLK_DESKEW) begin

    reg enable_int_n = 'd0;
    reg txnrx_int_n = 'd0;

    always @(negedge clk) begin
      enable_int_n <= enable_int;
      txnrx_int_n <= txnrx_int;
    end

    always @(posedge l_clk) begin
      enable_int_p <= enable_int_n;
      txnrx_int_p <= txnrx_int_n;
    end

  end else begin /* CLK_DESKEW == 0 */

    always @(posedge l_clk) begin
      enable_int_p <= enable_int;
      txnrx_int_p <= txnrx_int;
    end

  end
  endgenerate

  generate
  if (FPGA_TECHNOLOGY == CYCLONE5) begin
  axi_ad9361_lvds_if_c5 i_axi_ad9361_lvds_if_c5 (
    .rx_clk_in_p (rx_clk_in_p),
    .rx_clk_in_n (rx_clk_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_data_out_n (tx_data_out_n),
    .enable (enable),
    .txnrx (txnrx),
    .clk (l_clk),
    .rx_frame (rx_frame_s),
    .rx_data_0 (rx_data_0_s),
    .rx_data_1 (rx_data_1_s),
    .rx_data_2 (rx_data_2_s),
    .rx_data_3 (rx_data_3_s),
    .tx_frame (tx_frame),
    .tx_data_0 (tx_data_0),
    .tx_data_1 (tx_data_1),
    .tx_data_2 (tx_data_2),
    .tx_data_3 (tx_data_3),
    .tx_enable (enable_int_p),
    .tx_txnrx (txnrx_int_p),
    .locked (locked_s),
    .up_clk (up_clk),
    .up_rstn (up_rstn));
  end
  endgenerate

  generate
  if (FPGA_TECHNOLOGY == ARRIA10) begin
  axi_ad9361_lvds_if_10 #(
    .RX_NODPA (RX_NODPA)
  ) i_axi_ad9361_lvds_if_10 (
    .rx_clk_in_p (rx_clk_in_p),
    .rx_clk_in_n (rx_clk_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_data_out_n (tx_data_out_n),
    .enable (enable),
    .txnrx (txnrx),
    .clk (l_clk),
    .rx_frame (rx_frame_s),
    .rx_data_0 (rx_data_0_s),
    .rx_data_1 (rx_data_1_s),
    .rx_data_2 (rx_data_2_s),
    .rx_data_3 (rx_data_3_s),
    .tx_frame (tx_frame),
    .tx_data_0 (tx_data_0),
    .tx_data_1 (tx_data_1),
    .tx_data_2 (tx_data_2),
    .tx_data_3 (tx_data_3),
    .tx_enable (enable_int_p),
    .tx_txnrx (txnrx_int_p),
    .locked (locked_s),
    .up_clk (up_clk),
    .up_rstn (up_rstn));
  end
  endgenerate

endmodule
