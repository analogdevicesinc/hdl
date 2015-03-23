// ***************************************************************************
// ***************************************************************************
// Copyright 2011-2013(c) Analog Devices, Inc.
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
// Receive HDMI, hdmi embedded syncs data in, video dma data out.

module axi_hdmi_rx_core (

  // hdmi interface

  hdmi_clk,
  hdmi_rst,
  hdmi_data,
  hdmi_hs_count_mismatch,   // indicates receive hs mismatch against programmed
  hdmi_hs_count_update,     // high for one hdmi_clk cycle when count and count_mismatch are update
  hdmi_hs_count,            // received hs count
  hdmi_vs_count_mismatch,   // indicates receive vs mismatch against programmed
  hdmi_vs_count_update,     // high for one hdmi_clk cycle when count and count_mismatch are update
  hdmi_vs_count,            // received vs count
  hdmi_tpm_oos,             // test pattern monitor out of sync
  hdmi_oos_hs,              // horizontal HDMI receive resolution mismatch against programmed
  hdmi_oos_vs,              // vertical HDMI receive resolution mismatch against programmed
  hdmi_wr,                  // write interface
  hdmi_wdata,

  // processor interface
  hdmi_up_edge_sel,
  hdmi_up_hs_count,
  hdmi_up_vs_count,
  hdmi_up_csc_bypass,
  hdmi_up_tpg_enable,
  hdmi_up_packed,
  hdmi_up_bgr,

  // debug interface

  debug_data);

  // hdmi interface

  input           hdmi_clk;
  input           hdmi_rst;
  input   [15:0]  hdmi_data;
  output          hdmi_hs_count_mismatch;
  output          hdmi_hs_count_update;
  output  [15:0]  hdmi_hs_count;
  output          hdmi_vs_count_mismatch;
  output          hdmi_vs_count_update;
  output  [15:0]  hdmi_vs_count;
  output          hdmi_tpm_oos;
  output          hdmi_oos_hs;
  output          hdmi_oos_vs;
  output          hdmi_wr;
  output  [64:0]  hdmi_wdata;

  // control interface

  input           hdmi_up_edge_sel;
  input   [15:0]  hdmi_up_hs_count;
  input   [15:0]  hdmi_up_vs_count;
  input           hdmi_up_csc_bypass;
  input           hdmi_up_tpg_enable;
  input           hdmi_up_packed;
  input           hdmi_up_bgr;

  // debug interface (chipscope)

  output  [61:0]  debug_data;

  reg             hdmi_wr = 'd0;
  reg     [64:0]  hdmi_wdata = 'd0;
  reg     [23:0]  hdmi_tpm_data = 'd0;
  reg             hdmi_tpm_oos = 'd0;
  reg             hdmi_fs_422 = 'd0;
  reg             hdmi_de_422 = 'd0;
  reg     [15:0]  hdmi_data_422 = 'd0;
  reg             hdmi_fs_444 = 'd0;
  reg             hdmi_de_444 = 'd0;
  reg     [23:0]  hdmi_data_444 = 'd0;
  reg             hdmi_fs_444_d = 'd0;
  reg             hdmi_de_444_d = 'd0;
  reg     [23:0]  hdmi_data_444_d = 'd0;
  reg     [23:0]  hdmi_data_444_2d = 'd0;
  reg     [23:0]  hdmi_data_444_3d = 'd0;
  reg             hdmi_oos_hs = 'd0;
  reg             hdmi_oos_vs = 'd0;
  reg             hdmi_sof = 'd0;
  reg             hdmi_hs_de_d = 'd0;
  reg             hdmi_vs_de_d = 'd0;
  reg     [15:0]  hdmi_hs_run_count = 'd0;
  reg     [15:0]  hdmi_vs_run_count = 'd0;
  reg             hdmi_hs_count_mismatch = 'd0;
  reg             hdmi_hs_count_update = 'd0;
  reg     [15:0]  hdmi_hs_count = 'd0;
  reg             hdmi_vs_count_mismatch = 'd0;
  reg             hdmi_vs_count_update = 'd0;
  reg     [15:0]  hdmi_vs_count = 'd0;
  reg             hdmi_enable = 'd0;
  reg     [15:0]  hdmi_data_neg_p = 'd0;
  reg     [15:0]  hdmi_data_pos_p = 'd0;
  reg     [15:0]  hdmi_data_p = 'd0;
  reg     [15:0]  hdmi_data_neg = 'd0;
  reg     [ 2:0]  hdmi_wr_count = 'd0;

  reg     [15:0]  data_d = 'd0;
  reg     [15:0]  data_2d = 'd0;
  reg     [15:0]  data_3d = 'd0;
  reg     [15:0]  data_4d = 'd0;
  reg             hs_de_rcv_d = 'd0;
  reg             hs_de_rcv_2d = 'd0;
  reg             hs_de_rcv_3d = 'd0;
  reg             hs_de_rcv_4d = 'd0;
  reg             vs_de_rcv_d = 'd0;
  reg             vs_de_rcv_2d = 'd0;
  reg             vs_de_rcv_3d = 'd0;
  reg             vs_de_rcv_4d = 'd0;
  reg             hs_de_rcv = 'd0;
  reg             vs_de_rcv = 'd0;
  reg     [ 1:0]  preamble_cnt = 'd0;
  reg     [15:0]  hdmi_data_de;
  reg             hdmi_hs_de;
  reg             hdmi_vs_de;

  wire            hdmi_tpm_mismatch_s;
  wire    [15:0]  hdmi_tpm_data_s;
  wire            hdmi_sof_s;
  wire            hdmi_oos_hs_s;
  wire            hdmi_oos_vs_s;
  wire            hdmi_fs_444_s;
  wire            hdmi_de_444_s;
  wire    [23:0]  hdmi_data_444_s;
  wire            ss_fs_s;
  wire            ss_de_s;
  wire    [23:0]  ss_data_s;
  wire    [15:0]  hdmi_data_de_s;
  wire            hdmi_hs_de_s;
  wire            hdmi_vs_de_s;

  // debug signals

  assign debug_data[61:61] = hdmi_tpm_oos;
  assign debug_data[60:60] = hdmi_tpm_mismatch_s;
  assign debug_data[59:59] = hdmi_de_422;
  assign debug_data[58:43] = hdmi_data_422;
  assign debug_data[42:42] = hdmi_oos_hs | hdmi_oos_vs;
  assign debug_data[41:41] = hdmi_sof;
  assign debug_data[40:40] = hdmi_hs_count_mismatch;
  assign debug_data[39:39] = hdmi_vs_count_mismatch;
  assign debug_data[38:38] = hdmi_enable;
  assign debug_data[37:37] = hdmi_vs_de_s;
  assign debug_data[36:36] = hdmi_hs_de_s;
  assign debug_data[35:20] = hdmi_data_de_s;
  assign debug_data[15: 0] = hdmi_data_p;

  always @(posedge hdmi_clk) begin
    if (hdmi_de_444_d == 1'b1) begin
      hdmi_wr_count <= hdmi_wr_count + 1'b1;
    end else begin
      hdmi_wr_count <= 3'b0;
    end
    if (hdmi_up_packed == 1'b0) begin
      hdmi_wr <= hdmi_wr_count[0];
      hdmi_wdata[63:32] <= {8'hff,hdmi_data_444_d[23:0]};
      hdmi_wdata[31:0] <= hdmi_wdata[63:32];
    end else begin
      if (hdmi_up_csc_bypass) begin
        hdmi_wr <= hdmi_wr_count[1] & hdmi_wr_count[0];
        hdmi_wdata[63:48] <= hdmi_data_444_d[15:0];
        hdmi_wdata[47:0] <= hdmi_wdata[63:16];
      end else begin
        hdmi_wr <= 1'b0;
        case(hdmi_wr_count)
          3'h1: begin
            hdmi_wdata[23:0] <= hdmi_data_444_2d;
            hdmi_wdata[47:24] <= hdmi_data_444_d;
            hdmi_wdata[63:48] <= hdmi_data_444[15:0];
          end
          3'h2: begin
            hdmi_wr <= 1'b1;
          end
          3'h4: begin
            hdmi_wdata[7:0] <= hdmi_data_444_3d[23:16];
            hdmi_wdata[31:8] <= hdmi_data_444_2d;
            hdmi_wdata[55:32] <= hdmi_data_444_d;
            hdmi_wdata[63:56] <= hdmi_data_444[7:0];
          end
          3'h5: begin
            hdmi_wr <= 1'b1;
          end
          3'h6: begin
            hdmi_wdata[15:0] <= hdmi_data_444_2d[23:8];
            hdmi_wdata[39:16] <= hdmi_data_444_d;
            hdmi_wdata[63:40] <= hdmi_data_444;
          end
          3'h7: begin
            hdmi_wr <= 1'b1;
          end
        endcase
     end
  end

  if (hdmi_fs_444)
    hdmi_wdata[64:64] <= 1'b1;
  else if (hdmi_wr)
    hdmi_wdata[64:64] <= 1'b0;
  end

  // TPM on 422 data (the data must be passed through the cable as it is transmitted
  // by the v2h module. Any csc conversions must be disabled on info frame

  assign hdmi_tpm_mismatch_s = (hdmi_data_422 == hdmi_tpm_data_s) ? 1'b0 : hdmi_de_422;
  assign hdmi_tpm_data_s = {hdmi_tpm_data[3:2], 6'h20, hdmi_tpm_data[1:0], 6'h20};

  always @(posedge hdmi_clk) begin
    if (hdmi_fs_422 == 1'b1) begin
      hdmi_tpm_data <= 'd0;
    end else if (hdmi_de_422 == 1'b1) begin
      hdmi_tpm_data <= hdmi_tpm_data + 1'b1;
    end
    hdmi_tpm_oos <= hdmi_tpm_mismatch_s;
  end

  // fs, enable and data on 422 and 444 domains
  always @(posedge hdmi_clk) begin
    hdmi_fs_422   <= hdmi_sof & hdmi_enable;
    hdmi_de_422   <= hdmi_hs_de & hdmi_vs_de & hdmi_enable;
    hdmi_data_422 <= hdmi_data_de_s;
    hdmi_fs_444_d     <= hdmi_fs_444;
    hdmi_de_444_d     <= hdmi_de_444;
    hdmi_data_444_d   <= hdmi_data_444;
    hdmi_data_444_2d  <= hdmi_data_444_d;
    hdmi_data_444_3d  <= hdmi_data_444_2d;
  end

  // Select output data depending on the control setting
  always @(posedge hdmi_clk) begin
    if (hdmi_up_csc_bypass == 1'b1) begin
      hdmi_fs_444 <= hdmi_fs_422;
      hdmi_de_444 <= hdmi_de_422;
    end else begin
      hdmi_fs_444 <= hdmi_fs_444_s;
      hdmi_de_444 <= hdmi_de_444_s;
    end
    if (hdmi_up_tpg_enable == 1'b1) begin
      hdmi_data_444 <= hdmi_tpm_data;
    end else if (hdmi_up_csc_bypass == 1'b1) begin
      hdmi_data_444 <= {8'd0, hdmi_data_422};
    end else if (hdmi_up_bgr == 1'b1) begin
      hdmi_data_444 <= {hdmi_data_444_s[7:0], hdmi_data_444_s[15:8], hdmi_data_444_s[23:16]};
    end else begin
      hdmi_data_444 <= hdmi_data_444_s;
    end
  end

  // start of frame

  assign hdmi_sof_s = hdmi_vs_de & ~hdmi_vs_de_d;
  assign hdmi_oos_hs_s = hdmi_hs_count == hdmi_up_hs_count ? hdmi_hs_count_mismatch : 1'b1;
  assign hdmi_oos_vs_s = hdmi_vs_count == hdmi_up_vs_count ? hdmi_vs_count_mismatch : 1'b1;

  // hdmi side of the interface, horizontal and vertical sync counters.
  // capture active video size and report mismatch

  always @(posedge hdmi_clk) begin
    hdmi_oos_hs <= hdmi_oos_hs_s;
    hdmi_oos_vs <= hdmi_oos_vs_s;
    hdmi_sof <= hdmi_sof_s;
    hdmi_hs_de_d <= hdmi_hs_de;
    hdmi_vs_de_d <= hdmi_vs_de;
    if ((hdmi_hs_de == 1'b1) && (hdmi_hs_de_d == 1'b0)) begin
      hdmi_hs_run_count <= 'd1;
    end else if (hdmi_hs_de == 1'b1) begin
      hdmi_hs_run_count <= hdmi_hs_run_count + 1'b1;
    end
    if ((hdmi_vs_de == 1'b1) && (hdmi_vs_de_d == 1'b0)) begin
      hdmi_vs_run_count <= 'd0;
    end else if ((hdmi_vs_de == 1'b1) && (hdmi_hs_de == 1'b1) && (hdmi_hs_de_d == 1'b0)) begin
      hdmi_vs_run_count <= hdmi_vs_run_count + 1'b1;
    end
    if ((hdmi_hs_de == 1'b0) && (hdmi_hs_de_d == 1'b1)) begin
      hdmi_hs_count_mismatch <= (hdmi_hs_count == hdmi_hs_run_count) ? 1'b0 : 1'b1;
      hdmi_hs_count <= hdmi_hs_run_count;
      hdmi_hs_count_update <= 1'b1;
    end else begin
	  hdmi_hs_count_update <= 1'b0;
	end
    if ((hdmi_vs_de == 1'b0) && (hdmi_vs_de_d == 1'b1)) begin
      hdmi_vs_count_mismatch <= (hdmi_vs_count == hdmi_vs_run_count) ? 1'b0 : 1'b1;
      hdmi_vs_count <= hdmi_vs_run_count;
      hdmi_vs_count_update <= 1'b1;
    end else begin
      hdmi_vs_count_update <= 1'b0;
	end
    if (hdmi_sof_s == 1'b1) begin
      hdmi_enable <= ~hdmi_rst & ~hdmi_oos_hs_s & ~hdmi_oos_vs_s;
    end
  end

  // hdmi input data registers

  always @(posedge hdmi_clk) begin
    hdmi_data_neg_p <= hdmi_data_neg;
    hdmi_data_pos_p <= hdmi_data;
    if (hdmi_up_edge_sel == 1'b1) begin
      hdmi_data_p <= hdmi_data_neg_p;
    end else begin
      hdmi_data_p <= hdmi_data_pos_p;
    end
  end

  always @(negedge hdmi_clk) begin
    hdmi_data_neg <= hdmi_data;
  end

  // delay to get rid of eav's 4 bytes

  always @(posedge hdmi_clk) begin

    data_d        <= hdmi_data_p;
    data_2d       <= data_d;
    data_3d       <= data_2d;
    data_4d       <= data_3d;
    hdmi_data_de  <= data_4d;

    hs_de_rcv_d   <= hs_de_rcv;
    vs_de_rcv_d   <= vs_de_rcv;
    hs_de_rcv_2d  <= hs_de_rcv_d;
    vs_de_rcv_2d  <= vs_de_rcv_d;
    hs_de_rcv_3d  <= hs_de_rcv_2d;
    vs_de_rcv_3d  <= vs_de_rcv_2d;
    hs_de_rcv_4d  <= hs_de_rcv_3d;
    vs_de_rcv_4d  <= vs_de_rcv_3d;

    hdmi_hs_de    <= hs_de_rcv & hs_de_rcv_4d;
    hdmi_vs_de    <= vs_de_rcv & vs_de_rcv_4d;
  end

  assign hdmi_data_de_s = hdmi_data_de;
  assign hdmi_hs_de_s = hdmi_hs_de;
  assign hdmi_vs_de_s = hdmi_vs_de;

  // check for sav and eav and generate the corresponding enables

  always @(posedge hdmi_clk) begin
    if ((hdmi_data_p == 16'hffff) || (hdmi_data_p == 16'h0000)) begin
      preamble_cnt <= preamble_cnt + 1'b1;
    end else begin
      preamble_cnt <= 'd0;
    end

    if (preamble_cnt == 3'h3) begin
      if ((hdmi_data_p == 16'hb6b6) || (hdmi_data_p == 16'h9d9d)) begin
        hs_de_rcv <= 1'b0;
        vs_de_rcv <= ~hdmi_data_p[13];
      end else if ((hdmi_data_p == 16'habab) || (hdmi_data_p == 16'h8080)) begin
        hs_de_rcv <= 1'b1;
        vs_de_rcv <= ~hdmi_data_p[13];
      end
    end
  end

  // super sampling, 422 to 444

  ad_ss_422to444 #(
    .Cr_Cb_N(0),
    .DELAY_DATA_WIDTH(2)
  ) i_ss (
    .clk (hdmi_clk),
    .s422_de (hdmi_de_422),
    .s422_sync ({hdmi_fs_422,hdmi_de_422}),
    .s422_data (hdmi_data_422),
    .s444_sync ({ss_fs_s,ss_de_s}),
    .s444_data (ss_data_s)
  );

  // color space conversion, CrYCb to RGB

  ad_csc_CrYCb2RGB #(
    .DELAY_DATA_WIDTH(2)
  ) i_csc (
    .clk (hdmi_clk),
    .CrYCb_sync ({ss_fs_s, ss_de_s}),
    .CrYCb_data (ss_data_s),
    .RGB_sync ({hdmi_fs_444_s, hdmi_de_444_s}),
    .RGB_data (hdmi_data_444_s)
  );

endmodule

// ***************************************************************************
// ***************************************************************************
