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

module hsci_mlink_ctrl (
  // globals
  input hsci_pclk,
  input rstn,
  // register sigs
  input man_linkup,
  input [9:0] man_linkup_word,
  input auto_linkup,
  input mosi_test_mode,
  input alink_fsm_stall,
  input alink_fsm_step,
  input ver_b_na,
  // status sigs for regmap
  output [3:0] alink_fsm,
  output [15:0] alink_table,
  output [3:0] alink_txclk_adj,
  output alink_txclk_inv,
  output alink_fsm_stalled,
  output txclk_adj_mismatch,
  output txclk_inv_mismatch,
  // menc_sigs
  input menc_pause,
  output [7:0] lfsr_word,
  // mdec sigs
  input signal_det,
  input signal_acquired,
  input alink_dval,
  input [7:0] alink_data,
  input idle_state,
  input [3:0] tx_clk_adj_rcvd,
  input tx_clk_inv_rcvd,
  output reg frm_acq,
  // outputs
  output reg [9:0] linkup_word,
  output reg link_active,
  output reg [31:0] link_err_info
);

  typedef enum reg [3:0] { M_IDLE       = 4'h0,
                           M_RX_LINK    = 4'h1,
                           M_TX_DETECT  = 4'h2,
                           M_TX_CLK_ADJ = 4'h3,
                           M_TX_ACQ     = 4'h5,
                           M_TX_ENDLP   = 4'h6,
                           M_TX_STALL   = 4'h7,
                           M_TX_DECIDE  = 4'h8,
                           M_TX_CLK_INV = 4'h9,
                           M_SET_TXCLK  = 4'hA,
                           M_TX_REACQ   = 4'hB,
                           M_TX_LINKUP  = 4'hC,
                           M_LINKUP     = 4'hD,
                           M_LINK_ERR   = 4'hE
                         } state;
  state mlink_state;
  state prev_state;

  localparam LINKUP_INSTR = 4'b0101;
  localparam RX_LINK_CNT_DEF = 20'hfffff;
  localparam ACQUIRE_CNT_DEF = 16'h0fff;

  reg [2:0] alink_cntr;
  wire [7:0] lfsr_out;
  wire lfsr_en;

  reg signal_lock;
  reg [19:0] rx_link_cntr;
  reg rx_link_to;

  reg [15:0] tx_acq_cntr;
  reg tx_acq_to;
  reg [3:0] tx_clk_adj, tx_clk_adj_d;
  reg [3:0] tx_clk_adj_val;
  reg tx_clk_inv;
  reg [2:0] tx_ctrl;
  reg tx_linkup_achieved;
  reg [4:0] tx_ctrl_b0;

  reg [15:0] auto_link_table;
  reg [7:0] lock_data_cntr;
  wire[7:0] next_lock_data;
  reg [2:0] lock_fail_cntr;

  reg [14:0] lock_sreg;

  reg [2:0] dec_cntr;
  reg dec_made;
  reg [5:0][2:0]  sum7;
  reg [7:0][2:0]  sum5;
  reg [9:0][1:0] sum3;
  reg idle_det;
  reg [5:0] idle_det_cntr;
  reg [3:0] tx_del_cntr;
  reg get_link_err_info;
  reg fsm_step_d1, fsm_step_d2;
  wire fsm_step;

  // Link-up FSM
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      mlink_state <= M_IDLE;
      prev_state <= M_IDLE;
    end else begin
      case(mlink_state)
        M_IDLE: begin
          if (auto_linkup == 1'b1)
            mlink_state <= M_RX_LINK;
          else
            mlink_state <= M_IDLE;
        end

        M_RX_LINK: begin
          if (rx_link_to == 1'b1)
            mlink_state <= M_LINK_ERR;
          else if (signal_det == 1'b1)
            mlink_state <= M_TX_DETECT;
          else
            mlink_state <= M_RX_LINK;
        end

        M_TX_DETECT: begin
          if (signal_det == 1'b1)
            mlink_state <= M_TX_CLK_ADJ;
          else
            mlink_state <= M_TX_DETECT;
        end

        M_TX_CLK_ADJ: begin
          mlink_state <= M_TX_ACQ;  // A0
        end

        M_TX_ACQ: begin
          if (tx_acq_to == 1'b1)
            mlink_state <= M_TX_ENDLP;
          else if (signal_lock == 1'b1)
            mlink_state <= M_TX_ENDLP;
          else
            mlink_state <= M_TX_ACQ;
        end

        M_TX_ENDLP: begin
          if (tx_clk_adj == 4'h0)
            mlink_state <= M_TX_DECIDE;
          else
            mlink_state <= M_TX_STALL;
        end

         M_TX_STALL: begin
          if (alink_fsm_stall == 1'b0)
            mlink_state <= M_TX_CLK_ADJ;
          else begin
            if (fsm_step == 1'b1)
              mlink_state <= M_TX_CLK_ADJ;
            else
              mlink_state <= M_TX_STALL;
          end
        end

        M_TX_DECIDE: begin
          if (dec_made == 1'b1) begin
            mlink_state <= M_SET_TXCLK;
          end else begin
            if (dec_cntr == 3'b000) begin
              if (tx_clk_inv == 1'b0)
                mlink_state <= M_TX_CLK_INV;
              else
                mlink_state <= M_LINK_ERR;
            end else
              mlink_state <= M_TX_DECIDE;
          end // else: !if(dec_made == 1'b1)
        end // case: M_TX_DECIDE

        M_TX_CLK_INV: begin
          mlink_state <= M_TX_CLK_ADJ;
        end

        M_SET_TXCLK: begin
          if (ver_b_na == 1'b0) begin // A0
            if ( (tx_clk_adj == tx_clk_adj_val) & (tx_del_cntr == 4'h0) )
              mlink_state <= M_TX_LINKUP;
            else
              mlink_state <= M_SET_TXCLK;
          end else begin // B0
            mlink_state <= M_TX_REACQ;
          end // else: !if(ver_b_na == 1'b0)
        end // case: M_SET_TXCLK

        M_TX_REACQ: begin
          if (tx_acq_to == 1'b1)
            mlink_state <= M_LINK_ERR;
          else if (signal_lock == 1'b1)
            mlink_state <= M_TX_LINKUP;
          else
            mlink_state <= M_TX_REACQ;
        end

        M_TX_LINKUP: begin
          if (idle_det == 1'b1)
            mlink_state <= M_LINKUP;
          else
            mlink_state <= M_TX_LINKUP;
        end

        M_LINKUP: begin
          mlink_state <= M_LINKUP;
        end

        M_LINK_ERR: begin
          mlink_state <= M_LINK_ERR;
        end

        default: begin
          mlink_state <= M_LINK_ERR;
        end
      endcase // case (mlink_state)

      prev_state <= mlink_state;
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  // tx delay cntr needed during set_txclk because there is a delay
  // between changing tx_ctrl and when the chang occurs in the slave.
  // So, tx delay cntr hold mlink_state in SET_TXCLK a little long before transitioning into TX_LINKUP
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      tx_del_cntr <= 4'hf;
    else begin
      if (tx_clk_adj != tx_clk_adj_val)
        tx_del_cntr <= 4'hf;
      else
        tx_del_cntr <= (tx_del_cntr == 4'h0) ? 4'h0: tx_del_cntr - 4'h1;
    end
  end // always @ (posedge hsci_pclk or negedge rstn)

  // MOSI portion of link control
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      linkup_word <= 10'h000;
      alink_cntr <= 3'b000;
      tx_clk_adj_d <= 4'hf;
      tx_ctrl <= 3'b000;
      tx_ctrl_b0 <= 5'h00;
    end else begin
      if ((auto_linkup== 1'b1) & (tx_linkup_achieved == 1'b0)) begin
        if (ver_b_na == 1'b0) begin  // A0
          if (mlink_state == M_TX_CLK_INV)
            tx_ctrl <= 3'b011;  // clock invert
          else if ((mlink_state == M_TX_ACQ) | (mlink_state == M_SET_TXCLK)) begin
            if ((mlink_state == M_TX_ACQ) & (alink_fsm_stall == 1'b1)) begin
              if ((tx_acq_cntr == (ACQUIRE_CNT_DEF - 16'h002F) ) & (tx_clk_adj != 4'hF))
                tx_ctrl <= 3'b010;  // decrement
              else if ((alink_cntr == 3'b000) & (menc_pause == 1'b0))
                tx_ctrl <= 3'b000;
              else
                tx_ctrl <= tx_ctrl;
              end else begin
                if (tx_clk_adj < tx_clk_adj_d)
                  tx_ctrl <= 3'b010;  // decrement
                else if (tx_clk_adj > tx_clk_adj_d)
                  tx_ctrl <= 3'b001;  // increment
                else if ((alink_cntr == 3'b000) & (menc_pause == 1'b0))
                  tx_ctrl <= 3'b000;
                else
                  tx_ctrl <= tx_ctrl;
               end // else: !if( (mlink_state == M_TX_ACQ) & (alink_fsm_stall == 1'b1) )
          end // if ( (mlink_state == M_TX_ACQ) | (mlink_state == M_SET_TXCLK) )
        end else begin // if (ver_b_na == 1'b0)
          // B0
          tx_ctrl_b0 <= {tx_clk_inv, tx_clk_adj};
        end // else: !if(ver_b_na == 1'b0)
      end else // if ((auto_linkup== 1'b1) & (tx_linkup_achieved == 1'b0))
        tx_ctrl <= 3'b000;
        if (man_linkup == 1'b1) begin
          linkup_word <= man_linkup_word;
        end else if (auto_linkup == 1'b1) begin
          if (mlink_state == M_TX_CLK_INV)
            tx_clk_adj_d <= 4'hf;  //  clock invert resets txclk_adj back to 4'hf
          else
            tx_clk_adj_d <= tx_clk_adj;

          if (menc_pause == 1'b0) begin
            if ((mlink_state == M_LINKUP) | (mlink_state == M_TX_LINKUP)) begin
              linkup_word[9:0] <= 10'h000;
              alink_cntr <= 3'b000;
            end else begin
              case (alink_cntr)
                3'b000: begin
                  linkup_word[9:2] <= (ver_b_na == 1'b0) ? {1'b1, LINKUP_INSTR, tx_ctrl}:  {1'b1, LINKUP_INSTR, tx_ctrl_b0[4:2]};
                  linkup_word[1]   <=  (ver_b_na == 1'b0) ? (linkup_word[9] + linkup_word[8] + linkup_word[7] + linkup_word[6] + linkup_word[5] + linkup_word[4] + linkup_word[3]): tx_ctrl_b0[1];
                  linkup_word[0]   <=  (ver_b_na == 1'b0) ? 1'b0: tx_ctrl_b0[0];
                end
                3'b001, 3'b010, 3'b011, 3'b100, 3'b101: begin
                  linkup_word[9:2] <= lfsr_out[7:0];
                  linkup_word[1]   <=  (linkup_word[9] + linkup_word[8] + linkup_word[7] + linkup_word[6] + linkup_word[5] + linkup_word[4] + linkup_word[3] + 1'b1);
                  linkup_word[0]   <=  1'b1;
                end
                3'b110: begin
                  linkup_word[9:2] <= lfsr_out[7:0];
                  linkup_word[1]   <=  (linkup_word[9] + linkup_word[8] + linkup_word[7] + linkup_word[6] + linkup_word[5] + linkup_word[4] + linkup_word[3]);
                  linkup_word[0]   <=  1'b0;
                end
                3'b111:
                  linkup_word <= 10'h000;  // IDLE
              endcase // case (alink_cntr)

              alink_cntr <= alink_cntr + 3'b001;
            end // else: !if( (mlink_state == M_LINKUP) | (mlink_state == M_TX_LINKUP) )
          end // if (menc_pause == 1'b0)
        end else // if (auto_linkup == 1'b1)
          linkup_word <= 10'h000;
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  assign lfsr_en = ((mosi_test_mode == 1'b1) |  ((alink_cntr != 3'b000) & (alink_cntr != 3'b111) & (menc_pause != 1'b1)));

  lfsr15_8 lfsr0 (
    .clk(hsci_pclk),
    .rstn(rstn),
    .en(lfsr_en),
    .pn_out(lfsr_out));

  assign lfsr_word = (mosi_test_mode == 1'b1) ? lfsr_out: 8'h00;

  // generate tx clock mismatch sigs
  assign txclk_adj_mismatch = (ver_b_na == 1'b1) ? ~(tx_clk_adj == tx_clk_adj_rcvd): 1'b0;
  assign txclk_inv_mismatch = (ver_b_na == 1'b1) ? ~(tx_clk_inv == tx_clk_inv_rcvd): 1'b0;

  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      signal_lock <= 1'b0;

      rx_link_cntr <= RX_LINK_CNT_DEF;
      rx_link_to <= 1'b0;

      tx_acq_cntr <= ACQUIRE_CNT_DEF;
      tx_acq_to <= 1'b0;
      tx_clk_adj <= 4'hf;
      tx_clk_adj_val <= 4'hf;
      tx_clk_inv <= 1'b0;
      tx_linkup_achieved <= 1'b0;

      auto_link_table <= 16'h0000;

      lock_data_cntr <= 8'h00;
      lock_sreg <= 15'h7fff;

      dec_cntr <= 3'b111;
      dec_made <= 1'b0;
      sum7 <= 'h0;
      sum5 <= 'h0;
      sum3 <= 'h0;

      idle_det <= 1'b0;
      idle_det_cntr <= 6'h3f;

      link_active <= 1'b0;
      get_link_err_info <= 1'b0;
      link_err_info <= 32'h0;
    end else begin // if (~rstn)
      case(mlink_state)
        M_IDLE: begin
          signal_lock <= 1'b0;

          rx_link_cntr <= RX_LINK_CNT_DEF;
          rx_link_to <= 1'b0;

          tx_acq_cntr <= ACQUIRE_CNT_DEF;
          tx_acq_to <= 1'b0;
          tx_clk_adj <= 4'hf;
          tx_clk_inv <= 1'b0;
          tx_linkup_achieved <= 1'b0;

          auto_link_table <= 16'h0000;

          dec_cntr <= 3'b111;
          dec_made <= 1'b0;
          sum7 <= 'h0;
          sum5 <= 'h0;
          sum3 <= 'h0;

          idle_det <= 1'b0;
          idle_det_cntr <= 6'h3f;

          link_active <= 1'b0;
          get_link_err_info <= 1'b0;
          link_err_info <= 32'h0;
        end // case: M_IDLE

        M_RX_LINK: begin
          rx_link_cntr <= (rx_link_cntr == 20'h0) ? rx_link_cntr: rx_link_cntr - 20'h1;
          rx_link_to <= (rx_link_cntr == 20'h0);
        end

        M_TX_DETECT: begin
        end

        M_TX_CLK_ADJ: begin
          if ((prev_state == M_TX_DETECT) | (prev_state == M_TX_CLK_INV)) begin
            tx_clk_adj <= 4'hf;
            auto_link_table <= 16'h0000;
          end else begin
            tx_clk_adj <= tx_clk_adj - 1;
          end
            dec_cntr <= 3'b111;
        end // case: M_TX_CLK_ADJ

        M_TX_ACQ: begin // find a link frame, linkup cmd, 6 data sub frames

          tx_acq_cntr <= (tx_acq_cntr == 16'h0000) ? 16'h0000: tx_acq_cntr - 1;
          tx_acq_to <= (tx_acq_cntr == 16'h0000);

          if ((txclk_adj_mismatch == 1'b0) & (txclk_inv_mismatch == 1'b0)) begin
            if (alink_dval == 1'b1) begin
              if (alink_data != next_lock_data) begin
                if (lock_sreg == 15'h0000)
                  lock_sreg <= 15'h7fff;
                else
                  lock_sreg <= {lock_sreg[6:0], alink_data};
                lock_data_cntr <= 8'h00;
              end else begin
                if (lock_sreg == 15'h0000) begin
                  lock_sreg <= 15'h7fff;
                end else begin
                  lock_sreg[14:8] <= lock_sreg[6:0];
                  lock_sreg[7]    <= lock_sreg[14] ^ lock_sreg[13];
                  lock_sreg[6]    <= lock_sreg[13] ^ lock_sreg[12];
                  lock_sreg[5]    <= lock_sreg[12] ^ lock_sreg[11];
                  lock_sreg[4]    <= lock_sreg[11] ^ lock_sreg[10];
                  lock_sreg[3]    <= lock_sreg[10] ^ lock_sreg[9];
                  lock_sreg[2]    <= lock_sreg[9]  ^ lock_sreg[8];
                  lock_sreg[1]    <= lock_sreg[8]  ^ lock_sreg[7];
                  lock_sreg[0]    <= lock_sreg[7]  ^ lock_sreg[6];
                  lock_data_cntr <= (lock_data_cntr == 8'h7f) ? lock_data_cntr: lock_data_cntr + 8'h01;
                  signal_lock <= (lock_data_cntr == 8'h7f);
                end // else: !if(lock_sreg == 15'h0000)
              end
            end // if (alink_dval == 1'b1)
          end // if ((txclk_adj_mismatch == 1'b0) & (txclk_inv_mismatch == 1'b0))
        end // case: H_ACQ

        M_TX_ENDLP: begin
          // tally aqc results
          lock_data_cntr <= 8'h00;
          signal_lock <= 1'b0;
          auto_link_table[tx_clk_adj] <= signal_lock;

          // reset acq counter, etc
          tx_acq_cntr <= ACQUIRE_CNT_DEF;
          tx_acq_to <= 1'b0;
        end

        M_TX_DECIDE: begin
          dec_cntr <= (dec_cntr == 3'b000) ? 3'b000: dec_cntr - 3'b001;

          case (dec_cntr)
            3'b111: begin
              sum7[0]  <= auto_link_table[0]  + auto_link_table[1]  + auto_link_table[2]  + auto_link_table[3]  + auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6];
              sum7[1]  <= auto_link_table[1]  + auto_link_table[2]  + auto_link_table[3]  + auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7];
              sum7[2]  <= auto_link_table[2]  + auto_link_table[3]  + auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7]  + auto_link_table[8];
              sum7[3]  <= auto_link_table[3]  + auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7]  + auto_link_table[8]  + auto_link_table[9];
              sum7[4]  <= auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7]  + auto_link_table[8]  + auto_link_table[9] + auto_link_table[10];
              sum7[5]  <= auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7]  + auto_link_table[8]  + auto_link_table[9]  + auto_link_table[10] + auto_link_table[11];

              sum5[0]  <= auto_link_table[0]  + auto_link_table[1]  + auto_link_table[2]  + auto_link_table[3]  + auto_link_table[4];
              sum5[1]  <= auto_link_table[1]  + auto_link_table[2]  + auto_link_table[3]  + auto_link_table[4]  + auto_link_table[5];
              sum5[2]  <= auto_link_table[2]  + auto_link_table[3]  + auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6];
              sum5[3]  <= auto_link_table[3]  + auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7];
              sum5[4]  <= auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7]  + auto_link_table[8];
              sum5[5]  <= auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7]  + auto_link_table[8]  + auto_link_table[9];
              sum5[6]  <= auto_link_table[6]  + auto_link_table[7]  + auto_link_table[8]  + auto_link_table[9]  + auto_link_table[10];
              sum5[7]  <= auto_link_table[7]  + auto_link_table[8]  + auto_link_table[9] + auto_link_table[10] + auto_link_table[11];

              sum3[0]  <= auto_link_table[0]  + auto_link_table[1]  + auto_link_table[2];
              sum3[1]  <= auto_link_table[1]  + auto_link_table[2]  + auto_link_table[3];
              sum3[2]  <= auto_link_table[2]  + auto_link_table[3]  + auto_link_table[4];
              sum3[3]  <= auto_link_table[3]  + auto_link_table[4]  + auto_link_table[5];
              sum3[4]  <= auto_link_table[4]  + auto_link_table[5]  + auto_link_table[6];
              sum3[5]  <= auto_link_table[5]  + auto_link_table[6]  + auto_link_table[7];
              sum3[6]  <= auto_link_table[6]  + auto_link_table[7]  + auto_link_table[8];
              sum3[7]  <= auto_link_table[7]  + auto_link_table[8]  + auto_link_table[9];
              sum3[8]  <= auto_link_table[8]  + auto_link_table[9]  + auto_link_table[10];
              sum3[9]  <= auto_link_table[9]  + auto_link_table[10] + auto_link_table[11];
            end // case: 3'b111

            3'b110: begin
              if (sum7[0] == 3'b111) begin
                tx_clk_adj_val <= 4'h3;
                dec_made <= 1'b1;
              end else if (sum7[1] == 3'b111) begin
                tx_clk_adj_val <= 4'h4;
                dec_made <= 1'b1;
              end else if (sum7[2] == 3'b111) begin
                tx_clk_adj_val <= 4'h5;
                dec_made <= 1'b1;
              end else if (sum7[3] == 3'b111) begin
                tx_clk_adj_val <= 4'h6;
                dec_made <= 1'b1;
              end else if (sum7[4] == 3'b111) begin
                tx_clk_adj_val <= 4'h7;
                dec_made <= 1'b1;
              end else if (sum7[5] == 3'b111) begin
                tx_clk_adj_val <= 4'h8;
                dec_made <= 1'b1;
              end
            end // case: 3'b110

            3'b101: begin
              if (dec_made == 1'b0) begin  // no decision yet
                if (sum5[0] == 3'b101) begin
                  tx_clk_adj_val <= 4'h2;
                  dec_made <= 1'b1;
                end else if (sum5[1] == 3'b101) begin
                  tx_clk_adj_val <= 4'h3;
                  dec_made <= 1'b1;
                end else if (sum5[2] == 3'b101) begin
                  tx_clk_adj_val <= 4'h4;
                  dec_made <= 1'b1;
                end else if (sum5[3] == 3'b101) begin
                  tx_clk_adj_val <= 4'h5;
                  dec_made <= 1'b1;
                end else if (sum5[4] == 3'b101) begin
                  tx_clk_adj_val <= 4'h6;
                  dec_made <= 1'b1;
                end else if (sum5[5] == 3'b101)begin
                  tx_clk_adj_val <= 4'h7;
                  dec_made <= 1'b1;
                end else if (sum5[6] == 3'b101) begin
                  tx_clk_adj_val <= 4'h8;
                  dec_made <= 1'b1;
                end else if (sum5[7] == 3'b101) begin
                  tx_clk_adj_val <= 4'h9;
                  dec_made <= 1'b1;
                end
              end // if (dec_made == 1'b0)
            end // case: 3'b101

            3'b100: begin
              if (dec_made == 1'b0) begin  // no decision yet
                if (sum3[0] == 2'b11) begin
                  tx_clk_adj_val <= 4'h1;
                  dec_made <= 1'b1;
                end else if (sum3[1] == 2'b11) begin
                  tx_clk_adj_val <= 4'h2;
                  dec_made <= 1'b1;
                end else if (sum3[2] == 2'b11) begin
                  tx_clk_adj_val <= 4'h3;
                  dec_made <= 1'b1;
                end else if (sum3[3] == 2'b11) begin
                  tx_clk_adj_val <= 4'h4;
                  dec_made <= 1'b1;
                end else if (sum3[4] == 2'b11) begin
                  tx_clk_adj_val <= 4'h5;
                  dec_made <= 1'b1;
                end else if (sum3[5] == 2'b11) begin
                  tx_clk_adj_val <= 4'h6;
                  dec_made <= 1'b1;
                end else if (sum3[6] == 2'b11) begin
                  tx_clk_adj_val <= 4'h7;
                  dec_made <= 1'b1;
                end else if (sum3[7] == 2'b11) begin
                  tx_clk_adj_val <= 4'h8;
                  dec_made <= 1'b1;
                end else if (sum3[8] == 2'b11) begin
                  tx_clk_adj_val <= 4'h9;
                  dec_made <= 1'b1;
                end else if (sum3[9] == 2'b11) begin
                  tx_clk_adj_val <= 4'hA;
                  dec_made <= 1'b1;
                end
              end // if (dec_made == 1'b0)
            end // case: 3'b100

            default: begin
            end
          endcase // case (dec_cntr)
        end // case: M_TX_DECIDE

        M_TX_CLK_INV: begin
          tx_clk_inv <= 1'b1;
          tx_clk_adj <= 4'hf;  // tx_clk_inv also resets tx_clk_adj
          auto_link_table <= 16'h0000;
        end

        M_SET_TXCLK: begin  // TX_ACK2 for B0
          if (ver_b_na == 1'b0) begin  // A0
            if ((alink_cntr == 3'b111) & ((tx_clk_adj != tx_clk_adj_val)))
              tx_clk_adj <= tx_clk_adj + 4'h1;
          end else
            tx_clk_adj <= tx_clk_adj_val;
        end

        M_TX_REACQ: begin // re-acquire with desired txclk_adj
          tx_acq_cntr <= (tx_acq_cntr == 16'h0000) ? 16'h0000: tx_acq_cntr - 1;
          tx_acq_to <= (tx_acq_cntr == 16'h0000);

          if ((txclk_adj_mismatch == 1'b0) & (txclk_inv_mismatch == 1'b0)) begin
            if (alink_dval == 1'b1) begin
              if (alink_data != next_lock_data) begin
                if (lock_sreg == 15'h0000)
                  lock_sreg <= 15'h7fff;
                else
                  lock_sreg <= {lock_sreg[6:0], alink_data};
                lock_data_cntr <= 8'h00;
              end else begin
                if (lock_sreg == 15'h0000) begin
                  lock_sreg <= 15'h7fff;
                end else begin
                  lock_sreg[14:8] <= lock_sreg[6:0];
                  lock_sreg[7]    <= lock_sreg[14] ^ lock_sreg[13];
                  lock_sreg[6]    <= lock_sreg[13] ^ lock_sreg[12];
                  lock_sreg[5]    <= lock_sreg[12] ^ lock_sreg[11];
                  lock_sreg[4]    <= lock_sreg[11] ^ lock_sreg[10];
                  lock_sreg[3]    <= lock_sreg[10] ^ lock_sreg[9];
                  lock_sreg[2]    <= lock_sreg[9]  ^ lock_sreg[8];
                  lock_sreg[1]    <= lock_sreg[8]  ^ lock_sreg[7];
                  lock_sreg[0]    <= lock_sreg[7]  ^ lock_sreg[6];
                  lock_data_cntr <= (lock_data_cntr == 8'h7f) ? lock_data_cntr: lock_data_cntr + 8'h01;
                  signal_lock <= (lock_data_cntr == 8'h7f);
                end // else: !if(lock_sreg == 15'h0000)
              end
            end // if (alink_dval == 1'b1)
          end // if ( (txclk_adj_mismatch == 1'b0) & (txclk_inv_mismatch == 1'b0) )
        end // case: H_ACQ

        M_TX_LINKUP: begin
          tx_linkup_achieved <= 1'b1;

          if (idle_state == 1'b1)
            idle_det_cntr <= (idle_det_cntr == 6'h00) ? 6'h00: idle_det_cntr - 6'h01;
          else
            idle_det_cntr <= 6'h3f;
          idle_det <= (idle_det_cntr == 6'h00);
        end

        M_LINKUP: begin
          link_active <= 1'b1;
        end

        M_LINK_ERR: begin
          // Capture link error info
          if (get_link_err_info == 1'b0) begin
            link_err_info <= {15'h0, tx_linkup_achieved, tx_clk_adj, tx_clk_adj_val, dec_made, tx_acq_to, rx_link_to, signal_lock, prev_state};
            get_link_err_info <= 1'b1;
          end
        end
      endcase // case (hsci_state)
    end // else: !if(~rstn)
  end // always @ (posedge rx_mclk or negedge rstn)

  // set-up fsm_step
  // sample alink_fsm_step and generate a fsm_step pulse if rising edge detected
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      fsm_step_d2 <= 1'b0;
      fsm_step_d1 <= 1'b0;
    end else begin
      fsm_step_d2 <= fsm_step_d1;
      fsm_step_d1 <= alink_fsm_step;
    end
  end // always @ (posedge hsci_pclk or negedge rstn)

  assign fsm_step = (fsm_step_d1 & !fsm_step_d2);

  assign next_lock_data = {(lock_sreg[14] ^ lock_sreg[13]),
                           (lock_sreg[13] ^ lock_sreg[12]),
                           (lock_sreg[12] ^ lock_sreg[11]),
                           (lock_sreg[11] ^ lock_sreg[10]),
                           (lock_sreg[10] ^ lock_sreg[9]),
                           (lock_sreg[9]  ^ lock_sreg[8]),
                           (lock_sreg[8]  ^ lock_sreg[7]),
                           (lock_sreg[7]  ^ lock_sreg[6])};

  // set-up status sigs
  assign alink_fsm = mlink_state;
  assign alink_table = auto_link_table;
  assign alink_txclk_adj = tx_clk_adj;
  assign alink_txclk_inv = tx_clk_inv;
  assign alink_fsm_stalled = ((mlink_state == M_TX_STALL) & (alink_fsm_stall == 1'b1));

  //   During auto link-up,  if lock data not match, reset frame detect logic
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      lock_fail_cntr <= 3'b000;
    end else begin  // fail counter increments when alink_data != next_lock_data
      if ((mlink_state == M_TX_ACQ) & (alink_dval == 1'b1) & (alink_data != next_lock_data)) begin
        if (lock_fail_cntr >= 3'b110)
          lock_fail_cntr <= 3'b110;
        else
          lock_fail_cntr <= lock_fail_cntr + 1;
      end else if (mlink_state != M_TX_ACQ)
        lock_fail_cntr <= 3'b000;
      else if (alink_data == next_lock_data)
        lock_fail_cntr <= 3'b000;
      else if (lock_fail_cntr >= 3'b110)
        lock_fail_cntr <= 3'b000;
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  assign frm_acq = (lock_fail_cntr >= 3'b110);

endmodule
