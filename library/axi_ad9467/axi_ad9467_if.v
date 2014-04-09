// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
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
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module axi_ad9467_if (

  // adc interface (clk, data, over-range)
  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_data_or_p,
  adc_data_or_n,

  // interface outputs
  adc_clk,
  adc_data,
  adc_or,

  adc_ddr_edgesel,

  // delay control signals
  delay_sel,
  delay_rwn,
  delay_addr,
  delay_wdata,
  delay_clk,
  delay_ack,
  delay_rst,
  delay_rdata,
  delay_locked);

  // This parameter controls the buffer type based on the target device.
  parameter PCORE_BUFTYPE = 0;
  parameter C_DEVICE_7SERIES = 0;
  parameter C_DEVICE_VIRTEX6 = 1;


  parameter PCORE_IODELAY_GROUP = "dev_if_delay_group";

  // adc interface (clk, data, over-range)
  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [ 7:0]  adc_data_in_p;
  input   [ 7:0]  adc_data_in_n;
  input           adc_data_or_p;
  input           adc_data_or_n;

  // interface outputs
  output          adc_clk;
  output  [15:0]  adc_data;
  output          adc_or;

  input           adc_ddr_edgesel;

  // delay control signals
  input           delay_sel;
  input           delay_rwn;
  input   [ 7:0]  delay_addr;
  input   [ 4:0]  delay_wdata;
  input           delay_clk;
  input           delay_rst;
  output          delay_ack;
  output  [ 4:0]  delay_rdata;
  output          delay_locked;

  reg     [ 7:0]  adc_data_p = 'd0;
  reg     [ 7:0]  adc_data_n = 'd0;
  reg     [ 7:0]  adc_data_n_d = 'd0;
  reg     [ 7:0]  adc_dmux_a = 'd0;
  reg     [ 7:0]  adc_dmux_b = 'd0;
  reg     [15:0]  adc_data = 'd0;
  reg             adc_or_p = 'd0;
  reg             adc_or_n = 'd0;
  reg             adc_or = 'd0;
  reg     [ 8:0]  delay_ld = 'd0;
  reg             delay_ack = 'd0;
  reg     [ 4:0]  delay_rdata = 'd0;

  wire    [ 4:0]  delay_rdata_s[8:0];
  wire    [ 7:0]  adc_data_ibuf_s;
  wire    [ 7:0]  adc_data_idelay_s;
  wire    [ 7:0]  adc_data_p_s;
  wire    [ 7:0]  adc_data_n_s;
  wire            adc_or_ibuf_s;
  wire            adc_or_idelay_s;
  wire            adc_or_p_s;
  wire            adc_or_n_s;
  wire            adc_clk_ibuf_s;

  genvar          l_inst;

  // The adc data is 8bits ddr, and here it is demuxed to 16bits.
  // The samples may be selected to be either positive first,
  // or negative first.

  always @(posedge adc_clk) begin
    adc_data_p <= adc_data_p_s;
    adc_data_n <= adc_data_n_s;
    adc_data_n_d <= adc_data_n;
    adc_dmux_a <= (adc_ddr_edgesel == 1'b1) ? adc_data_n : adc_data_p;
    adc_dmux_b <= (adc_ddr_edgesel == 1'b1) ? adc_data_p : adc_data_n_d;
    adc_data[15] <= adc_dmux_b[7];
    adc_data[14] <= adc_dmux_a[7];
    adc_data[13] <= adc_dmux_b[6];
    adc_data[12] <= adc_dmux_a[6];
    adc_data[11] <= adc_dmux_b[5];
    adc_data[10] <= adc_dmux_a[5];
    adc_data[ 9] <= adc_dmux_b[4];
    adc_data[ 8] <= adc_dmux_a[4];
    adc_data[ 7] <= adc_dmux_b[3];
    adc_data[ 6] <= adc_dmux_a[3];
    adc_data[ 5] <= adc_dmux_b[2];
    adc_data[ 4] <= adc_dmux_a[2];
    adc_data[ 3] <= adc_dmux_b[1];
    adc_data[ 2] <= adc_dmux_a[1];
    adc_data[ 1] <= adc_dmux_b[0];
    adc_data[ 0] <= adc_dmux_a[0];
    adc_or_p <= adc_or_p_s;
    adc_or_n <= adc_or_n_s;
    if ((adc_or_p == 1'b1) || (adc_or_n == 1'b1)) begin
      adc_or <= 1'b1;
    end else begin
      adc_or <= 1'b0;
    end
  end

  // The delay write interface, each delay element can be individually
  // addressed, and a delay value can be directly loaded (no INC/DEC stuff)

  always @(posedge delay_clk) begin
    if ((delay_sel == 1'b1) && (delay_rwn == 1'b0)) begin
      case (delay_addr)
        8'd8 : delay_ld <= 9'h100;
        8'd7 : delay_ld <= 9'h080;
        8'd6 : delay_ld <= 9'h040;
        8'd5 : delay_ld <= 9'h020;
        8'd4 : delay_ld <= 9'h010;
        8'd3 : delay_ld <= 9'h008;
        8'd2 : delay_ld <= 9'h004;
        8'd1 : delay_ld <= 9'h002;
        8'd0 : delay_ld <= 9'h001;
        default: delay_ld <= 9'h000;
      endcase
    end else begin
      delay_ld <= 9'h000;
    end
  end


 // delay read interface, a delay ack toggle is used to transfer data to the
 // processor side- delay locked is independently transferred

 always @(posedge delay_clk) begin
    case (delay_addr)
      8'd8 : delay_rdata <= delay_rdata_s[8];
      8'd7 : delay_rdata <= delay_rdata_s[7];
      8'd6 : delay_rdata <= delay_rdata_s[6];
      8'd5 : delay_rdata <= delay_rdata_s[5];
      8'd4 : delay_rdata <= delay_rdata_s[4];
      8'd3 : delay_rdata <= delay_rdata_s[3];
      8'd2 : delay_rdata <= delay_rdata_s[2];
      8'd1 : delay_rdata <= delay_rdata_s[1];
      8'd0 : delay_rdata <= delay_rdata_s[0];
      default: delay_rdata <= 5'd0;
    endcase
    if (delay_sel == 1'b1) begin
      delay_ack <= ~delay_ack;
    end
  end

  // The data interface, data signals goes through a LVDS input buffer, then
  // a delay element (1/32th of a 200MHz clock) and finally an input DDR demux.

  generate
  for (l_inst = 0; l_inst <= 7; l_inst = l_inst + 1) begin : g_adc_if

  IBUFDS i_data_ibuf (
    .I (adc_data_in_p[l_inst]),
    .IB (adc_data_in_n[l_inst]),
    .O (adc_data_ibuf_s[l_inst]));

  if (PCORE_BUFTYPE == C_DEVICE_VIRTEX6) begin
  (* IODELAY_GROUP = PCORE_IODELAY_GROUP *)
  IODELAYE1 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("I"),
    .HIGH_PERFORMANCE_MODE ("TRUE"),
    .IDELAY_TYPE ("VAR_LOADABLE"),
    .IDELAY_VALUE (0),
    .ODELAY_TYPE ("FIXED"),
    .ODELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .SIGNAL_PATTERN ("DATA"))
  i_data_idelay (
    .T (1'b1),
    .CE (1'b0),
    .INC (1'b0),
    .CLKIN (1'b0),
    .DATAIN (1'b0),
    .ODATAIN (1'b0),
    .CINVCTRL (1'b0),
    .C (delay_clk),
    .IDATAIN (adc_data_ibuf_s[l_inst]),
    .DATAOUT (adc_data_idelay_s[l_inst]),
    .RST (delay_ld[l_inst]),
    .CNTVALUEIN (delay_wdata),
    .CNTVALUEOUT (delay_rdata_s[l_inst]));
  end else begin
  (* IODELAY_GROUP = PCORE_IODELAY_GROUP *)
  IDELAYE2 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("IDATAIN"),
    .HIGH_PERFORMANCE_MODE ("FALSE"),
    .IDELAY_TYPE ("VAR_LOAD"),
    .IDELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .PIPE_SEL ("FALSE"),
    .SIGNAL_PATTERN ("DATA"))
  i_data_idelay (
    .CE (1'b0),
    .INC (1'b0),
    .DATAIN (1'b0),
    .LDPIPEEN (1'b0),
    .CINVCTRL (1'b0),
    .REGRST (1'b0),
    .C (delay_clk),
    .IDATAIN (adc_data_ibuf_s[l_inst]),
    .DATAOUT (adc_data_idelay_s[l_inst]),
    .LD (delay_ld[l_inst]),
    .CNTVALUEIN (delay_wdata),
    .CNTVALUEOUT (delay_rdata_s[l_inst]));
  end

  IDDR #(
    .INIT_Q1 (1'b0),
    .INIT_Q2 (1'b0),
    .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
    .SRTYPE ("ASYNC"))
  i_data_ddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (adc_clk),
    .D (adc_data_idelay_s[l_inst]),
    .Q1 (adc_data_p_s[l_inst]),
    .Q2 (adc_data_n_s[l_inst]));

  end
  endgenerate

  // The over-range interface, it follows a similar path as the data signals.

  IBUFDS i_or_ibuf (
    .I (adc_data_or_p),
    .IB (adc_data_or_n),
    .O (adc_or_ibuf_s));

  generate
  if (PCORE_BUFTYPE == C_DEVICE_VIRTEX6) begin
  (* IODELAY_GROUP = PCORE_IODELAY_GROUP *)
  IODELAYE1 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("I"),
    .HIGH_PERFORMANCE_MODE ("TRUE"),
    .IDELAY_TYPE ("VAR_LOADABLE"),
    .IDELAY_VALUE (0),
    .ODELAY_TYPE ("FIXED"),
    .ODELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .SIGNAL_PATTERN ("DATA"))
  i_or_idelay (
    .T (1'b1),
    .CE (1'b0),
    .INC (1'b0),
    .CLKIN (1'b0),
    .DATAIN (1'b0),
    .ODATAIN (1'b0),
    .CINVCTRL (1'b0),
    .C (delay_clk),
    .IDATAIN (adc_or_ibuf_s),
    .DATAOUT (adc_or_idelay_s),
    .RST (delay_ld[8]),
    .CNTVALUEIN (delay_wdata),
    .CNTVALUEOUT (delay_rdata_s[8]));
  end else begin
  (* IODELAY_GROUP = PCORE_IODELAY_GROUP *)
  IDELAYE2 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("IDATAIN"),
    .HIGH_PERFORMANCE_MODE ("FALSE"),
    .IDELAY_TYPE ("VAR_LOAD"),
    .IDELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .PIPE_SEL ("FALSE"),
    .SIGNAL_PATTERN ("DATA"))
  i_or_idelay (
    .CE (1'b0),
    .INC (1'b0),
    .DATAIN (1'b0),
    .LDPIPEEN (1'b0),
    .CINVCTRL (1'b0),
    .REGRST (1'b0),
    .C (delay_clk),
    .IDATAIN (adc_or_ibuf_s),
    .DATAOUT (adc_or_idelay_s),
    .LD (delay_ld[8]),
    .CNTVALUEIN (delay_wdata),
    .CNTVALUEOUT (delay_rdata_s[8]));
  end
  endgenerate

  IDDR #(
    .INIT_Q1 (1'b0),
    .INIT_Q2 (1'b0),
    .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
    .SRTYPE ("ASYNC"))
  i_or_ddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (adc_clk),
    .D (adc_or_idelay_s),
    .Q1 (adc_or_p_s),
    .Q2 (adc_or_n_s));

  // The clock path is a simple clock buffer after a LVDS input buffer.
  // It is possible for this logic to be replaced with a OSERDES based data capture.
  // The reason for such a simple interface here is because this reference design
  // is used for various boards (native fmc and/or evaluation boards). The pinouts
  // of the FPGA - ADC interface is probably do not allow a OSERDES placement.

  IBUFGDS i_clk_ibuf (
    .I (adc_clk_in_p),
    .IB (adc_clk_in_n),
    .O (adc_clk_ibuf_s));

  generate
  if (PCORE_BUFTYPE == C_DEVICE_VIRTEX6) begin
  BUFR #(.BUFR_DIVIDE ("BYPASS")) i_clk_gbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (adc_clk_ibuf_s),
    .O (adc_clk));
  end else begin
  BUFG i_clk_gbuf (
    .I (adc_clk_ibuf_s),
    .O (adc_clk));
  end
  endgenerate

  // The delay controller. Refer to Xilinx doc. for details.
  // The GROUP directive controls which delay elements this is associated with.

  (* IODELAY_GROUP = PCORE_IODELAY_GROUP *)
  IDELAYCTRL i_delay_ctrl (
    .RST (delay_rst),
    .REFCLK (delay_clk),
    .RDY (delay_locked));

endmodule

// ***************************************************************************
// ***************************************************************************
