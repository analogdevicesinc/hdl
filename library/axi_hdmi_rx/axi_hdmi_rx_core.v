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
// Receive HDMI, hdmi embedded syncs data in, video dma data out.

`timescale 1ns/100ps

module axi_hdmi_rx_core #(

  parameter   IO_INTERFACE = 1) (

  // hdmi interface

  input                   hdmi_clk,
  input                   hdmi_rst,
  input       [15:0]      hdmi_data,
  input                   hdmi_edge_sel,
  input                   hdmi_bgr,
  input                   hdmi_packed,
  input                   hdmi_csc_bypass,
  input       [15:0]      hdmi_vs_count,
  input       [15:0]      hdmi_hs_count,
  output                  hdmi_tpm_oos,
  output  reg             hdmi_vs_oos,
  output  reg             hdmi_hs_oos,
  output  reg             hdmi_vs_mismatch,
  output  reg             hdmi_hs_mismatch,
  output  reg [15:0]      hdmi_vs,
  output  reg [15:0]      hdmi_hs,

  // dma interface

  output  reg             hdmi_dma_sof,
  output  reg             hdmi_dma_de,
  output  reg [63:0]      hdmi_dma_data);

  // internal registers

  reg                     hdmi_dma_de_cnt = 'd0;
  reg                     hdmi_dma_sof_int = 'd0;
  reg                     hdmi_dma_de_int = 'd0;
  reg         [31:0]      hdmi_dma_data_int = 'd0;
  reg                     hdmi_sof_422 = 'd0;
  reg                     hdmi_de_422 = 'd0;
  reg                     hdmi_de_422_cnt = 'd0;
  reg         [15:0]      hdmi_data_422 = 'd0;
  reg                     hdmi_sof_444 = 'd0;
  reg                     hdmi_de_444 = 'd0;
  reg         [23:0]      hdmi_data_444 = 'd0;
  reg         [ 1:0]      hdmi_de_444_cnt = 'd0;
  reg         [15:0]      hdmi_data_444_hold = 'd0;
  reg                     hdmi_sof_444_p = 'd0;
  reg                     hdmi_de_444_p = 'd0;
  reg         [31:0]      hdmi_data_444_p = 'd0;
  reg                     hdmi_dma_enable = 'd0;
  reg                     hdmi_hs_de_d = 'd0;
  reg                     hdmi_vs_de_d = 'd0;
  reg                     hdmi_sof = 'd0;
  reg         [15:0]      hdmi_hs_rcv = 'd0;
  reg         [15:0]      hdmi_hs_cur = 'd0;
  reg                     hdmi_hs_oos_int = 'd0;
  reg         [15:0]      hdmi_vs_rcv = 'd0;
  reg         [15:0]      hdmi_vs_cur = 'd0;
  reg                     hdmi_vs_oos_int = 'd0;
  reg         [15:0]      hdmi_data_p = 'd0;

  // internal signals

  wire        [15:0]      hdmi_data_p_s;
  wire        [15:0]      hdmi_data_n_s;
  wire                    hdmi_sof_s;
  wire                    hdmi_sof_ss_s;
  wire                    hdmi_de_ss_s;
  wire        [23:0]      hdmi_data_ss_s;
  wire                    hdmi_sof_444_s;
  wire                    hdmi_de_444_s;
  wire        [23:0]      hdmi_data_444_s;
  wire        [15:0]      hdmi_data_de_s;
  wire                    hdmi_hs_de_s;
  wire                    hdmi_vs_de_s;

  // dma interface

  always @(posedge hdmi_clk) begin
    if(hdmi_dma_sof_int == 1'b1) begin
      hdmi_dma_sof <= 1'b1;
    end else if (hdmi_dma_de == 1'b1) begin
      hdmi_dma_sof <= 1'b0;
    end

    if(hdmi_dma_sof_int == 1'b1) begin
      hdmi_dma_de_cnt <= 1'b0;
    end else if (hdmi_dma_de_int == 1'b1) begin
      hdmi_dma_de_cnt <= ~hdmi_dma_de_cnt;
    end

    hdmi_dma_de <= hdmi_dma_de_cnt & hdmi_dma_de_int;
    if (hdmi_dma_de_int == 1'b1) begin
      hdmi_dma_data[63:32] <= hdmi_dma_data_int;
      hdmi_dma_data[31: 0] <= hdmi_dma_data[63:32];
    end
  end

  // 32 bit interface

  always @(posedge hdmi_clk) begin
    if (hdmi_dma_enable == 1'b0) begin
      hdmi_dma_sof_int <= 1'd0;
      hdmi_dma_de_int <= 1'd0;
      hdmi_dma_data_int <= 32'd0;
      hdmi_de_422_cnt <= 1'b0;
    end else if (hdmi_csc_bypass == 1'b1) begin
      if (hdmi_packed == 1'b0) begin
        hdmi_dma_sof_int <= hdmi_sof_422;
        hdmi_dma_de_int <= hdmi_de_422;
        hdmi_dma_data_int <= {16'd0, hdmi_data_422};
      end else begin
        hdmi_dma_sof_int <= hdmi_sof_422;
        hdmi_dma_de_int <= hdmi_de_422_cnt && hdmi_de_422;
        if (hdmi_de_422) begin
          hdmi_de_422_cnt <= hdmi_de_422_cnt + 1'b1;
          hdmi_dma_data_int <= {hdmi_data_422, hdmi_dma_data_int[31:16]};
        end
      end
    end else begin
      if (hdmi_packed == 1'b0) begin
        hdmi_dma_sof_int <= hdmi_sof_444;
        hdmi_dma_de_int <= hdmi_de_444;
        hdmi_dma_data_int <= {8'd0, hdmi_data_444};
      end else begin
        hdmi_dma_sof_int <= hdmi_sof_444_p;
        hdmi_dma_de_int <= hdmi_de_444_p;
        hdmi_dma_data_int <= hdmi_data_444_p;
      end
    end
  end

  // sof, enable and data on 422 and 444 domains

  always @(posedge hdmi_clk) begin
    hdmi_sof_422 <= hdmi_sof;
    hdmi_de_422 <= hdmi_hs_de_s & hdmi_vs_de_s;
    hdmi_data_422 <= hdmi_data_de_s;
    hdmi_sof_444 <= hdmi_sof_444_s;
    hdmi_de_444 <= hdmi_de_444_s;
    if (hdmi_bgr == 1'b1) begin
      hdmi_data_444[23:16] <= hdmi_data_444_s[ 7: 0];
      hdmi_data_444[15: 8] <= hdmi_data_444_s[15: 8];
      hdmi_data_444[ 7: 0] <= hdmi_data_444_s[23:16];
    end else begin
      hdmi_data_444[23:16] <= hdmi_data_444_s[23:16];
      hdmi_data_444[15: 8] <= hdmi_data_444_s[15: 8];
      hdmi_data_444[ 7: 0] <= hdmi_data_444_s[ 7: 0];
    end
    if (hdmi_sof_444 == 1'b1) begin
      hdmi_de_444_cnt <= (hdmi_de_444 == 1'b1) ? 2'b1 : 2'b0;
    end else if (hdmi_de_444 == 1'b1) begin
      hdmi_de_444_cnt <= hdmi_de_444_cnt + 1'b1;
    end
    hdmi_data_444_hold <= hdmi_data_444[23:8];
    hdmi_sof_444_p <= hdmi_sof_444;
    hdmi_de_444_p <= hdmi_de_444_cnt[0] | hdmi_de_444_cnt[1];
    case (hdmi_de_444_cnt)
      2'b11: hdmi_data_444_p <= {hdmi_data_444[23:0], hdmi_data_444_hold[15: 8]};
      2'b10: hdmi_data_444_p <= {hdmi_data_444[15:0], hdmi_data_444_hold[15: 0]};
      2'b01: hdmi_data_444_p <= {hdmi_data_444[ 7:0], hdmi_data_444_p[23: 0]};
      default: hdmi_data_444_p <= {8'd0, hdmi_data_444};
    endcase
  end

  always @(posedge hdmi_clk) begin
    if (hdmi_rst == 1'b1) begin
      hdmi_dma_enable <= 1'b0;
    end else if (hdmi_sof_s == 1'b1) begin
      hdmi_dma_enable <= ~(hdmi_vs_oos | hdmi_hs_oos);
    end
  end

  // horizontal and vertical sync counters, active video size & mismatch

  always @(posedge hdmi_clk) begin
    if (hdmi_rst == 1'b1) begin
      hdmi_vs <= 'd0;
      hdmi_hs <= 'd0;
      hdmi_vs_oos <= 1'd1;
      hdmi_hs_oos <= 1'd1;
      hdmi_vs_mismatch <= 1'd1;
      hdmi_hs_mismatch <= 1'd1;
    end else if (hdmi_sof == 1'b1) begin
      hdmi_vs <= hdmi_vs_cur;
      hdmi_hs <= hdmi_hs_cur;
      hdmi_vs_oos <= hdmi_vs_oos_int;
      hdmi_hs_oos <= hdmi_hs_oos_int;
      if (hdmi_vs_count == hdmi_vs_cur) begin
        hdmi_vs_mismatch <= hdmi_vs_oos_int;
      end else begin
        hdmi_vs_mismatch <= 1'b1;
      end
      if (hdmi_hs_count == hdmi_hs_cur) begin
        hdmi_hs_mismatch <= hdmi_hs_oos_int;
      end else begin
        hdmi_hs_mismatch <= 1'b1;
      end
    end
  end

  assign hdmi_sof_s = hdmi_vs_de_s & ~hdmi_vs_de_d;

  always @(posedge hdmi_clk) begin
    hdmi_hs_de_d <= hdmi_hs_de_s;
    hdmi_vs_de_d <= hdmi_vs_de_s;
    hdmi_sof <= hdmi_sof_s;
    if ((hdmi_hs_de_s == 1'b1) && (hdmi_hs_de_d == 1'b0)) begin
      hdmi_hs_rcv <= 'd1;
      hdmi_hs_cur <= hdmi_hs_rcv;
      if (hdmi_hs_cur == hdmi_hs_rcv) begin
        hdmi_hs_oos_int <= 1'b0;
      end else begin
        hdmi_hs_oos_int <= 1'b1;
      end
    end else if (hdmi_hs_de_s == 1'b1) begin
      hdmi_hs_rcv <= hdmi_hs_rcv + 1'b1;
      hdmi_hs_cur <= hdmi_hs_cur;
      hdmi_hs_oos_int <= hdmi_hs_oos_int;
    end
    if ((hdmi_vs_de_s == 1'b1) && (hdmi_vs_de_d == 1'b0)) begin
      hdmi_vs_rcv <= 'd0;
      hdmi_vs_cur <= hdmi_vs_rcv;
      if (hdmi_vs_cur == hdmi_vs_rcv) begin
        hdmi_vs_oos_int <= 1'b0;
      end else begin
        hdmi_vs_oos_int <= 1'b1;
      end
    end else if ((hdmi_vs_de_s == 1'b1) && (hdmi_hs_de_s == 1'b1) &&
      (hdmi_hs_de_d == 1'b0)) begin
      hdmi_vs_rcv <= hdmi_vs_rcv + 1'b1;
      hdmi_vs_cur <= hdmi_vs_cur;
      hdmi_vs_oos_int <= hdmi_vs_oos_int;
    end
  end

  // hdmi input data registers
  // use iddr if interfacing off-chip (keeps iob)
  // use same edge (or register falling edge again)

  genvar n;
  generate
  if (IO_INTERFACE == 0) begin
  for (n = 0; n < 16; n = n + 1) begin: g_hdmi_data
  IDDR #(
    .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
    .INIT_Q1 (1'b0),
    .INIT_Q2 (1'b0),
    .SRTYPE ("ASYNC"))
  i_rx_data_iddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (hdmi_clk),
    .D (hdmi_data[n]),
    .Q1 (hdmi_data_p_s[n]),
    .Q2 (hdmi_data_n_s[n]));
  end
  end else begin
  assign hdmi_data_p_s = hdmi_data;
  assign hdmi_data_n_s = hdmi_data;
  end
  endgenerate

  always @(posedge hdmi_clk) begin
    if (hdmi_edge_sel == 1'b1) begin
      hdmi_data_p <= hdmi_data_n_s;
    end else begin
      hdmi_data_p <= hdmi_data_p_s;
    end
  end

  // super sampling, 422 to 444

  ad_ss_422to444 #(.CR_CB_N(0), .DELAY_DATA_WIDTH(2)) i_ss (
    .clk (hdmi_clk),
    .s422_de (hdmi_de_422),
    .s422_sync ({hdmi_sof_422, hdmi_de_422}),
    .s422_data (hdmi_data_422),
    .s444_sync ({hdmi_sof_ss_s, hdmi_de_ss_s}),
    .s444_data (hdmi_data_ss_s));

  // color space conversion, CrYCb to RGB

  ad_csc_CrYCb2RGB #(.DELAY_DATA_WIDTH(2)) i_csc (
    .clk (hdmi_clk),
    .CrYCb_sync ({hdmi_sof_ss_s, hdmi_de_ss_s}),
    .CrYCb_data (hdmi_data_ss_s),
    .RGB_sync ({hdmi_sof_444_s, hdmi_de_444_s}),
    .RGB_data (hdmi_data_444_s));

  // embedded sync

  axi_hdmi_rx_es #(.DATA_WIDTH(16)) i_es (
    .hdmi_clk (hdmi_clk),
    .hdmi_data (hdmi_data_p),
    .hdmi_vs_de (hdmi_vs_de_s),
    .hdmi_hs_de (hdmi_hs_de_s),
    .hdmi_data_de (hdmi_data_de_s));

  // test pattern matcher

  axi_hdmi_rx_tpm i_tpm (
    .hdmi_clk (hdmi_clk),
    .hdmi_sof (hdmi_sof_422),
    .hdmi_de (hdmi_de_422),
    .hdmi_data (hdmi_data_422),
    .hdmi_tpm_oos(hdmi_tpm_oos));

endmodule

// ***************************************************************************
// ***************************************************************************
