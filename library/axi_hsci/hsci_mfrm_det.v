// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

module hsci_mfrm_det (
  // globals
  input hsci_pclk,
  input rstn,
  // input from iserdes
  input [7:0] mdec_data,
  // inputs from mdec
  input [2:0] dec_fsm,
  input [1:0]  rd_tsize,
  // reg sigs
  input capture_mode,
  output reg [9:0] capture_word,
  input miso_test_mode,
  output miso_test_lfsr_acq,
  output reg [31:0] miso_ber_cnt,
  input miso_clk_inv,
  // link control sigs
  input man_linkup,
  input auto_linkup,
  input [3:0] alink_fsm,
  input frm_acq,
  // i/f to mdec
  output reg frm_det,
  output next_frm_start,
  output reg [9:0] mdec_sfrm,
  output mdec_val
);

  localparam READ_ACK = 4'b1010;
  localparam ALINK    = 4'b0101;

  localparam DEC_IDLE     = 3'b000;
  localparam DEC_RDATA = 3'b011;
  localparam DEC_ERROR = 3'b100;
  localparam DEC_MERR   = 3'b111;
  localparam DEC_LINKUP = 3'b111;

  reg [17:0] ibuf;
  reg [3:0] frm_align;
  wire [9:0] tmp_frm[0:7];

  reg [14:0] lfsr_sreg;
  reg [2:0] lfsr_cnt;
  wire [7:0] lfsr_next;
  reg [2:0] idle_cnt;
  reg [1:0] frm_acq_cnt;
  reg [6:0] mdec_data_d1;

  // count idle states
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      idle_cnt <= 3'b000;
    else begin
      if ((auto_linkup == 1'b1) & (dec_fsm == DEC_IDLE))
        idle_cnt <= (idle_cnt == 3'b100) ? 3'b000: idle_cnt + 3'b001;
      else
        idle_cnt <= 3'b000;
    end
  end // always @ (posedge hsci_pclk or negedge rstn)

  // when frm_acq pulse comes in hold frame detect for 4 clock cycles
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      frm_acq_cnt <= 2'b00;
    else begin
      if (frm_acq == 1'b1)
        frm_acq_cnt <= 2'b11;
      else
        frm_acq_cnt <= (frm_acq_cnt == 2'b00) ? 2'b00: frm_acq_cnt - 2'b01;
    end
  end // always @ (posedge hsci_pclk or negedge rstn)

  // JPB
  //capture and delay mdec_dats
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      mdec_data_d1 <= 7'h00;
    else
      mdec_data_d1 <= mdec_data[6:0];
  end

  // buffer input
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      ibuf <= 19'h00000;
    else begin
      if (miso_clk_inv == 1'b0)
        ibuf <= {ibuf[10:0], mdec_data[7:0]};
      else
        ibuf <= {ibuf[10:0], mdec_data_d1[6:0], mdec_data[7]};
    end
  end

  assign tmp_frm[7] = ibuf[16:7];
  assign tmp_frm[6] = ibuf[15:6];
  assign tmp_frm[5] = ibuf[14:5];
  assign tmp_frm[4] = ibuf[13:4];
  assign tmp_frm[3] = ibuf[12:3];
  assign tmp_frm[2] = ibuf[11:2];
  assign tmp_frm[1] = ibuf[10:1];
  assign tmp_frm[0] = ibuf[9:0];

  // search for frame aligment
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      frm_det <= 1'b0;
      frm_align <= 4'h9;
      mdec_sfrm <= 10'h000;
    end else begin
      if (frm_det == 1'b0) begin
        if (ibuf[16] == 1'b1) begin
          frm_det <= 1'b1;
          frm_align <= 4'h7;
          mdec_sfrm <= tmp_frm[7];
        end else if(ibuf[14] == 1'b1) begin
          frm_det <= 1'b1;
          frm_align <= 4'h5;
          mdec_sfrm <= tmp_frm[5];
        end else if(ibuf[12] == 1'b1) begin
          frm_det <= 1'b1;
          frm_align <= 4'h3;
          mdec_sfrm <= tmp_frm[3];
        end else if(ibuf[10] == 1'b1) begin
          frm_det <= 1'b1;
          frm_align <= 4'h1;
          mdec_sfrm <= tmp_frm[1];
        end
      end else begin// if (frm_det == 1'b0)
        if (((auto_linkup == 1'b1) & (frm_acq_cnt != 2'b00)) | (idle_cnt == 3'b100)) begin
          frm_det <= 1'b0;
          frm_align <= 4'h9;
          mdec_sfrm <= 10'h000;
        end else if (((dec_fsm == DEC_LINKUP) | (dec_fsm == DEC_RDATA) | (dec_fsm == DEC_ERROR) | (dec_fsm == DEC_MERR)) & (mdec_sfrm[0] == 1'b0) & (mdec_val == 1'b1)) begin
          // check for next frame coming in
          case(frm_align)
            4'h7: begin
              if (tmp_frm[5][9] == 1'b1) begin
                frm_det <= 1'b1;
                frm_align <= 4'h5;
                mdec_sfrm <= tmp_frm[5];
              end else if (tmp_frm[3][9] == 1'b1) begin
                frm_det <= 1'b1;
                frm_align <= 4'h3;
                mdec_sfrm <= tmp_frm[3];
              end else if (tmp_frm[1][9] == 1'b1) begin
                frm_det <= 1'b1;
                frm_align <= 4'h1;
                mdec_sfrm <= tmp_frm[1];
              end else begin // drop frm_det
                frm_det <= 1'b0;
                frm_align <= 4'h9;
                mdec_sfrm <= 10'h000;
              end // else: !if(tmp_frm[0][9] == 1'b1)
            end // case: 3'h6

            4'h5: begin
              if (tmp_frm[3][9] == 1'b1) begin
                frm_det <= 1'b1;
                frm_align <= 4'h3;
                mdec_sfrm <= tmp_frm[3];
              end else if (tmp_frm[1][9] == 1'b1) begin
                frm_det <= 1'b1;
                frm_align <= 4'h1;
                mdec_sfrm <= tmp_frm[1];
              end else begin // drop frm_det
                frm_det <= 1'b0;
                frm_align <= 4'h9;
                mdec_sfrm <= 10'h000;
              end // else: !if(tmp_frm[0][9] == 1'b1)
            end // case: 3'h5

            4'h3: begin
              if (tmp_frm[1][9] == 1'b1) begin
                frm_det <= 1'b1;
                frm_align <= 4'h1;
                mdec_sfrm <= tmp_frm[1];
              end else begin  // drop frm_det
                frm_det <= 1'b0;
                frm_align <= 4'h9;
                mdec_sfrm <= 10'h000;
              end // else: !if(tmp_frm[0][9] == 1'b1)
            end // case: 3'h3

            4'h1: begin
                frm_det <= 1'b0;
                frm_align <= 4'h9;
                mdec_sfrm <= 10'h000;
            end // else: !if(tmp_frm[0][9] == 1'b1)
              //  end // case: 3'h1

            default: begin  // drop frm_det
              frm_det <= 1'b0;
              frm_align <= 4'h9;
              mdec_sfrm <= 10'h000;
            end
          endcase // case (frm_align)
        end else begin // if ( (dec_fsm == DEC_RDATA) & (mdec_cont == 1'b0) & (mdec_val == 1'b1) )
          frm_align <= (frm_align <= 4'h1) ? 4'h9:frm_align - 4'h2;
          frm_det <= frm_det;
          mdec_sfrm <= (frm_align == 4'h0) ? mdec_sfrm:
                       (frm_align == 4'h1) ? mdec_sfrm: tmp_frm[frm_align - 4'h2]; // if (dec_fsm == DEC_IDLE)
        end // else: !if( ( (dec_fsm == DEC_LINKUP) | (dec_fsm == DEC_RDATA) | (dec_fsm == DEC_ERROR) | (dec_fsm == DEC_MERR) ) & (mdec_sfrm[0] == 1'b0) & (mdec_val == 1'b1) )
      end // else: !if(frm_det == 1'b0)
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  assign mdec_val  = ~( (frm_align == 4'h9) | (frm_align == 4'h8) );
  assign next_frm_start = (frm_align > 4'h1) ? tmp_frm[frm_align - 4'h2][9] : tmp_frm[7][9];

  // in capture_mode, always spit out tmp_frm[0]
  // for miso_test_mode, use capture_word
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      capture_word <= 10'h000;
    else begin
      if (capture_mode == 1'b1)
        capture_word <= ( (frm_align == 4'h9) | (frm_align == 4'h8) ) ? capture_word: tmp_frm[frm_align];
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

   // DFx miso test mode
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      lfsr_sreg <= 15'h7fff;
      lfsr_cnt <= 3'b000;
      miso_ber_cnt <= 32'h0;
    end else begin
      if (miso_test_mode == 1'b1) begin
        if (lfsr_cnt != 3'b111) begin
          lfsr_sreg <= (|lfsr_sreg == 1'b0) ? 15'h0001: {lfsr_sreg[6:0], mdec_data[7:0]};
          if (lfsr_next == mdec_data[7:0])
            lfsr_cnt <= lfsr_cnt + 3'b001;
          else
            lfsr_cnt <= 3'b000;
        end else begin
        lfsr_sreg <= (|lfsr_sreg == 1'b0) ? 15'h0001: {lfsr_sreg[6:0], lfsr_next[7:0]};
        if (lfsr_next != mdec_data[7:0])
          miso_ber_cnt <= (miso_ber_cnt != 32'hffffffff) ? miso_ber_cnt + 32'h00000001: 32'hffffffff;
        end // else: !if(lfsr_cnt != 3'b111)
      end // if (miso_test_mode == 1'b1)
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  assign miso_test_lfsr_acq = (lfsr_cnt == 3'b111);
  assign lfsr_next = {(lfsr_sreg[14] ^ lfsr_sreg[13]),
                      (lfsr_sreg[13] ^ lfsr_sreg[12]),
                      (lfsr_sreg[12] ^ lfsr_sreg[11]),
                      (lfsr_sreg[11] ^ lfsr_sreg[10]),
                      (lfsr_sreg[10] ^ lfsr_sreg[9]),
                      (lfsr_sreg[9]  ^ lfsr_sreg[8]),
                      (lfsr_sreg[8]  ^ lfsr_sreg[7]),
                      (lfsr_sreg[7]  ^ lfsr_sreg[6])};

endmodule
