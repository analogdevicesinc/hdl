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
// Receive HDMI, hdmi embedded syncs data in, video dma data out.

module axi_hdmi_rx_core (

  // hdmi interface

  hdmi_clk,
  hdmi_rst,
  hdmi_data,
  hdmi_edge_sel,
  hdmi_bgr,
  hdmi_packed,
  hdmi_csc_bypass,
  hdmi_vs_count,
  hdmi_hs_count,
  hdmi_tpm_oos,
  hdmi_vs_oos,
  hdmi_hs_oos,
  hdmi_vs_mismatch,
  hdmi_hs_mismatch,
  hdmi_vs,
  hdmi_hs,

  // dma interface

  hdmi_dma_sof,
  hdmi_dma_de,
  hdmi_dma_data);

  // hdmi interface

  input           hdmi_clk;
  input           hdmi_rst;
  input   [15:0]  hdmi_data;
  input           hdmi_edge_sel;
  input           hdmi_bgr;
  input           hdmi_packed;
  input           hdmi_csc_bypass;
  input   [15:0]  hdmi_vs_count;
  input   [15:0]  hdmi_hs_count;
  output          hdmi_tpm_oos;
  output          hdmi_vs_oos;
  output          hdmi_hs_oos;
  output          hdmi_vs_mismatch;
  output          hdmi_hs_mismatch;
  output  [15:0]  hdmi_vs;
  output  [15:0]  hdmi_hs;

  // dma interface

  output          hdmi_dma_sof;
  output          hdmi_dma_de;
  output  [63:0]  hdmi_dma_data;

  // internal registers

  reg             hdmi_dma_sof = 'd0;
  reg             hdmi_dma_de = 'd0;
  reg             hdmi_dma_de_cnt = 'd0;
  reg     [63:0]  hdmi_dma_data = 'd0;
  reg             hdmi_dma_sof_int = 'd0;
  reg             hdmi_dma_de_int = 'd0;
  reg     [31:0]  hdmi_dma_data_int = 'd0;
  reg             hdmi_sof_422 = 'd0;
  reg             hdmi_de_422 = 'd0;
  reg             hdmi_de_422_cnt = 'd0;
  reg     [15:0]  hdmi_data_422 = 'd0;
  reg             hdmi_sof_444 = 'd0;
  reg             hdmi_de_444 = 'd0;
  reg     [23:0]  hdmi_data_444 = 'd0;
  reg     [ 1:0]  hdmi_de_444_cnt = 'd0;
  reg     [15:0]  hdmi_data_444_hold = 'd0;
  reg             hdmi_sof_444_p = 'd0;
  reg             hdmi_de_444_p = 'd0;
  reg     [31:0]  hdmi_data_444_p = 'd0;
  reg             hdmi_dma_enable = 'd0;
  reg     [15:0]  hdmi_vs = 'd0;
  reg     [15:0]  hdmi_hs = 'd0;
  reg             hdmi_vs_oos = 'd0;
  reg             hdmi_hs_oos = 'd0;
  reg             hdmi_vs_mismatch = 'd0;
  reg             hdmi_hs_mismatch = 'd0;
  reg             hdmi_hs_de_d = 'd0;
  reg             hdmi_vs_de_d = 'd0;
  reg             hdmi_sof = 'd0;
  reg     [15:0]  hdmi_hs_rcv = 'd0;
  reg     [15:0]  hdmi_hs_cur = 'd0;
  reg             hdmi_hs_oos_int = 'd0;
  reg     [15:0]  hdmi_vs_rcv = 'd0;
  reg     [15:0]  hdmi_vs_cur = 'd0;
  reg             hdmi_vs_oos_int = 'd0;
  reg     [15:0]  hdmi_data_neg_p = 'd0;
  reg     [15:0]  hdmi_data_pos_p = 'd0;
  reg     [15:0]  hdmi_data_p = 'd0;
  reg     [15:0]  hdmi_data_neg = 'd0;

  // internal signals

  wire            hdmi_sof_s;
  wire            hdmi_sof_ss_s;
  wire            hdmi_de_ss_s;
  wire    [23:0]  hdmi_data_ss_s;
  wire            hdmi_sof_444_s;
  wire            hdmi_de_444_s;
  wire    [23:0]  hdmi_data_444_s;
  wire    [15:0]  hdmi_data_de_s;
  wire            hdmi_hs_de_s;
  wire            hdmi_vs_de_s;

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

  always @(posedge hdmi_clk) begin
    hdmi_data_neg_p <= hdmi_data_neg;
    hdmi_data_pos_p <= hdmi_data;
    if (hdmi_edge_sel == 1'b1) begin
      hdmi_data_p <= hdmi_data_neg_p;
    end else begin
      hdmi_data_p <= hdmi_data_pos_p;
    end
  end

  always @(negedge hdmi_clk) begin
    hdmi_data_neg <= hdmi_data;
  end

  // super sampling, 422 to 444

  ad_ss_422to444 #(.Cr_Cb_N(0), .DELAY_DATA_WIDTH(2)) i_ss (
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

  // test patttern matcher

  axi_hdmi_rx_tpm i_tpm (
    .hdmi_clk (hdmi_clk),
    .hdmi_sof (hdmi_sof_422),
    .hdmi_de (hdmi_de_422),
    .hdmi_data (hdmi_data_422),
    .hdmi_tpm_oos(hdmi_tpm_oos));

endmodule

// ***************************************************************************
// ***************************************************************************
