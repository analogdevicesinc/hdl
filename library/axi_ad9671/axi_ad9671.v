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

`timescale 1ns/100ps

module axi_ad9671 (

  // jesd interface 
  // rx_clk is (line-rate/40)

  rx_clk,
  rx_data,

  // dma interface

  adc_clk,
  adc_dwr,
  adc_ddata,
  adc_dsync,
  adc_dovf,
  adc_dunf,

  // axi interface

  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rresp,
  s_axi_rdata,
  s_axi_rready,

  // debug signals

  adc_mon_valid,
  adc_mon_data);

  parameter PCORE_ID = 0;
  parameter PCORE_DEVICE_TYPE = 0;
  parameter PCORE_4L_2L_N = 1;
  parameter PCORE_IODELAY_GROUP = "adc_if_delay_group";
  parameter C_S_AXI_MIN_SIZE = 32'hffff;
  parameter C_BASEADDR = 32'hffffffff;
  parameter C_HIGHADDR = 32'h00000000;

  // jesd interface 
  // rx_clk is the jesd clock (ref_clk/2)

  input                                 rx_clk;
  input   [(64*PCORE_4L_2L_N)+63:0]     rx_data;

  // dma interface

  output                                adc_clk;
  output                                adc_dwr;
  output  [127:0]                       adc_ddata;
  output                                adc_dsync;
  input                                 adc_dovf;
  input                                 adc_dunf;

  // axi interface

  input                                 s_axi_aclk;
  input                                 s_axi_aresetn;
  input                                 s_axi_awvalid;
  input   [ 31:0]                       s_axi_awaddr;
  output                                s_axi_awready;
  input                                 s_axi_wvalid;
  input   [ 31:0]                       s_axi_wdata;
  input   [  3:0]                       s_axi_wstrb;
  output                                s_axi_wready;
  output                                s_axi_bvalid;
  output  [  1:0]                       s_axi_bresp;
  input                                 s_axi_bready;
  input                                 s_axi_arvalid;
  input   [ 31:0]                       s_axi_araddr;
  output                                s_axi_arready;
  output                                s_axi_rvalid;
  output  [  1:0]                       s_axi_rresp;
  output  [ 31:0]                       s_axi_rdata;
  input                                 s_axi_rready;

  // debug signals

  output                                adc_mon_valid;
  output  [127:0]                       adc_mon_data;

  // internal registers

  reg     [  2:0]                       adc_data_cnt = 'd0;
  reg                                   adc_dwr = 'd0;
  reg                                   adc_dsync = 'd0;
  reg     [127:0]                       adc_ddata = 'd0;
  reg                                   up_adc_status_pn_err = 'd0;
  reg                                   up_adc_status_pn_oos = 'd0;
  reg                                   up_adc_status_or = 'd0;
  reg                                   up_ack = 'd0;
  reg     [ 31:0]                       up_rdata = 'd0;

  // internal clocks & resets

  wire                                  adc_rst;
  wire                                  up_rstn;
  wire                                  up_clk;

  // internal signals

  wire                                  adc_status_s;
  wire                                  adc_valid_s;
  wire    [ 15:0]                       adc_data_s[7:0];
  wire    [  7:0]                       adc_or_s;
  wire    [  7:0]                       adc_dfmt_valid_s;
  wire    [ 15:0]                       adc_dfmt_data_s[7:0];
  wire    [  7:0]                       adc_enable_s;
  wire    [  7:0]                       up_adc_pn_err_s;
  wire    [  7:0]                       up_adc_pn_oos_s;
  wire    [  7:0]                       up_adc_or_s;
  wire    [ 31:0]                       up_adc_channel_rdata_s[7:0];
  wire    [  7:0]                       up_adc_channel_ack_s;
  wire                                  up_sel_s;
  wire                                  up_wr_s;
  wire    [ 13:0]                       up_addr_s;
  wire    [ 31:0]                       up_wdata_s;
  wire    [ 31:0]                       up_adc_common_rdata_s;
  wire                                  up_adc_common_ack_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // monitor signals

  assign adc_mon_valid = 1'b1;
  assign adc_mon_data[ 15:  0] = adc_dfmt_data_s[0];
  assign adc_mon_data[ 31: 16] = adc_dfmt_data_s[1];
  assign adc_mon_data[ 47: 32] = adc_dfmt_data_s[2];
  assign adc_mon_data[ 63: 48] = adc_dfmt_data_s[3];
  assign adc_mon_data[ 79: 64] = adc_dfmt_data_s[4];
  assign adc_mon_data[ 95: 80] = adc_dfmt_data_s[5];
  assign adc_mon_data[111: 96] = adc_dfmt_data_s[6];
  assign adc_mon_data[127:112] = adc_dfmt_data_s[7];

  // adc channels - dma interface

  always @(posedge adc_clk) begin
    if (adc_dfmt_valid_s == 8'hff) begin
      adc_data_cnt <= adc_data_cnt + 1'b1;
      case (adc_enable_s)
        8'b11111111: begin 
          adc_dwr <= 1'b1;
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[7],
            adc_dfmt_data_s[6],
            adc_dfmt_data_s[5],
            adc_dfmt_data_s[4],
            adc_dfmt_data_s[3],
            adc_dfmt_data_s[2],
            adc_dfmt_data_s[1],
            adc_dfmt_data_s[0]};
        end
        8'b10000000: begin 
          adc_dwr <= (& adc_data_cnt);
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[0], adc_ddata[127:16]};
        end
        8'b01000000: begin 
          adc_dwr <= (& adc_data_cnt);
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[1], adc_ddata[127:16]};
        end
        8'b00100000: begin 
          adc_dwr <= (& adc_data_cnt);
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[2], adc_ddata[127:16]};
        end
        8'b00010000: begin 
          adc_dwr <= (& adc_data_cnt);
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[3], adc_ddata[127:16]};
        end
        8'b00001000: begin 
          adc_dwr <= (& adc_data_cnt);
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[4], adc_ddata[127:16]};
        end
        8'b00000100: begin 
          adc_dwr <= (& adc_data_cnt);
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[5], adc_ddata[127:16]};
        end
        8'b00000010: begin 
          adc_dwr <= (& adc_data_cnt);
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[6], adc_ddata[127:16]};
        end
        8'b00000001: begin 
          adc_dwr <= (& adc_data_cnt);
          adc_dsync <= 1'b1;
          adc_ddata <= {adc_dfmt_data_s[7], adc_ddata[127:16]};
        end
        default: begin
          adc_dwr <= 1'b1;
          adc_dsync <= 1'b1;
          adc_ddata <= {8{16'hdead}};
        end
      endcase
    end else begin
      adc_data_cnt <= adc_data_cnt;
      adc_dwr <= 1'b0;
      adc_dsync <= 1'b0;
      adc_ddata <= 128'd0;
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_status_pn_err <= 'd0;
      up_adc_status_pn_oos <= 'd0;
      up_adc_status_or <= 'd0;
      up_ack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_adc_status_pn_err <= | up_adc_pn_err_s;
      up_adc_status_pn_oos <= | up_adc_pn_oos_s;
      up_adc_status_or <= | up_adc_or_s;
      up_ack <=  up_adc_common_ack_s | (| up_adc_channel_ack_s);
      up_rdata <= up_adc_common_rdata_s |
        up_adc_channel_rdata_s[0] |
        up_adc_channel_rdata_s[1] |
        up_adc_channel_rdata_s[2] |
        up_adc_channel_rdata_s[3] |
        up_adc_channel_rdata_s[4] |
        up_adc_channel_rdata_s[5] |
        up_adc_channel_rdata_s[6] |
        up_adc_channel_rdata_s[7];
    end
  end

  // main (device interface)

  axi_ad9671_if #(.PCORE_4L_2L_N(PCORE_4L_2L_N)) i_if (
    .rx_clk (rx_clk),
    .rx_data (rx_data),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid_s),
    .adc_data_a (adc_data_s[0]),
    .adc_or_a (adc_or_s[0]),
    .adc_data_b (adc_data_s[1]),
    .adc_or_b (adc_or_s[1]),
    .adc_data_c (adc_data_s[2]),
    .adc_or_c (adc_or_s[2]),
    .adc_data_d (adc_data_s[3]),
    .adc_or_d (adc_or_s[3]),
    .adc_data_e (adc_data_s[4]),
    .adc_or_e (adc_or_s[4]),
    .adc_data_f (adc_data_s[5]),
    .adc_or_f (adc_or_s[5]),
    .adc_data_g (adc_data_s[6]),
    .adc_or_g (adc_or_s[6]),
    .adc_data_h (adc_data_s[7]),
    .adc_or_h (adc_or_s[7]),
    .adc_status (adc_status_s));

  // channels

  genvar n;
  generate
  for (n = 0; n < 8; n = n + 1) begin: g_channel
  axi_ad9671_channel #(.CHID(n)) i_channel (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s[n]),
    .adc_or (adc_or_s[n]),
    .adc_dfmt_valid (adc_dfmt_valid_s[n]),
    .adc_dfmt_data (adc_dfmt_data_s[n]),
    .adc_enable (adc_enable_s[n]),
    .up_adc_pn_err (up_adc_pn_err_s[n]),
    .up_adc_pn_oos (up_adc_pn_oos_s[n]),
    .up_adc_or (up_adc_or_s[n]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_adc_channel_rdata_s[n]),
    .up_ack (up_adc_channel_ack_s[n]));
  end
  endgenerate

  // common processor control

  up_adc_common #(.PCORE_ID(PCORE_ID)) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status_s),
    .adc_status_pn_err (up_adc_status_pn_err),
    .adc_status_pn_oos (up_adc_status_pn_oos),
    .adc_status_or (up_adc_status_or),
    .adc_status_ovf (adc_dovf),
    .adc_status_unf (adc_dunf),
    .adc_clk_ratio (32'd1),
    .delay_clk (1'b0),
    .delay_rst (),
    .delay_sel (),
    .delay_rwn (),
    .delay_addr (),
    .delay_wdata (),
    .delay_rdata (5'd0),
    .delay_ack_t (1'b0),
    .delay_locked (1'b0),
    .drp_clk (1'd0),
    .drp_rst (),
    .drp_sel (),
    .drp_wr (),
    .drp_addr (),
    .drp_wdata (),
    .drp_rdata (16'd0),
    .drp_ready (1'd0),
    .drp_locked (1'd0),
    .up_usr_chanmax (),
    .adc_usr_chanmax (8'd7),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_adc_common_rdata_s),
    .up_ack (up_adc_common_ack_s));

  // up bus interface

  up_axi #(
    .PCORE_BASEADDR (C_BASEADDR),
    .PCORE_HIGHADDR (C_HIGHADDR))
  i_up_axi (
    .up_rstn (up_rstn),
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
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata),
    .up_ack (up_ack));

endmodule

// ***************************************************************************
// ***************************************************************************
