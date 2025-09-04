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

module hsci_mdec (
  // globals
  input hsci_pclk,
  input rstn,
  //  mfrm_det i/o
  input frm_det,
  input next_frm_start,
  input [9:0] mdec_sfrm,
  input mdec_val,
  output reg [1:0] rd_tsize,
  // mem i/f
  output reg [14:0] dec_addr,
  output reg [31:0] dec_data,
  output reg dec_en,
  output reg [3:0] dec_we,
  // reg sigs
  input miso_test_mode,
  output [2:0] dec_fsm,
  output reg [7:0] error_code,
  input clear_errors,
  output reg parity_err,
  output reg unk_instr_err,
  // link control sigs
  input ver_b_na,
  input man_linkup,
  input auto_linkup,
  input [3:0] alink_fsm,
  output reg alink_dval,
  output reg [7:0] alink_data,
  output reg signal_det,
  output reg signal_acquired,
  output idle_state,
  output reg [3:0] tx_clk_adj_rcvd,
  output reg tx_clk_inv_rcvd,
  // i/f to menc
  input [3:0] menc_state,
  input xfer_mode,
  input read_op,
  input [16:0] read_byte_num,
  output reg read_done
);

  typedef enum reg [2:0] { D_IDLE      = 3'b000,
                           D_INSTR     = 3'b001,
                           D_RINDEX    = 3'b010,
                           D_RDATA     = 3'b011,
                           D_ERROR     = 3'b100,
                           D_LINKUP    = 3'b101,
                           D_TMODE     = 3'b110,
                           D_MERR      = 3'b111
                          } state;


  localparam READ_ACK = 4'b1010;
  localparam ERR_MSG  = 4'b1100;
  localparam ALINK    = 4'b0101;

   // internal variables
  state dec_state;

  wire [7:0]  mdec_word;
  wire mdec_par;
  wire mdec_cont;

  reg p_calc;

  reg [16:0] read_byte_cnt;
  reg read_pending;
  reg read_done_d;
  reg [31:0] rd_index;
  reg [1:0] rd_index_cnt;
  reg [31:0] rd_data;
  reg [1:0] rd_data_cnt;
  reg store_data;
  reg [3:0] store_we;
  reg new_dec_addr;

  reg [4:0] idle_cnt;

  assign mdec_word = mdec_sfrm[9:2];
  assign mdec_par = mdec_sfrm[1];
  assign mdec_cont = mdec_sfrm[0];

  assign p_calc = mdec_word[7] + mdec_word[6] + mdec_word[5] + mdec_word[4] + mdec_word[3] + mdec_word[2] + mdec_word[1] + mdec_word[0] + mdec_cont;
  // during active xfer, check parity
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      parity_err <= 1'b0;
    else begin
      if (mdec_par ^ p_calc)
        parity_err <= 1'b1;
      else if (clear_errors == 1'b1)
        parity_err <= 1'b0;
      else
        parity_err <= parity_err;
    end
  end


  // set signal_det if auto_linkup '1' and frm_det '1'
  // once signal_det set, leave on until auto_linkup goes low
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      signal_det <= 1'b0;
    else begin
      if (auto_linkup == 1'b1) begin
        if (frm_det == 1'b1)
          signal_det <= 1'b1;
        end
      else
        signal_det <= 1'b0;
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  assign idle_state = ( (dec_state == D_IDLE) & (auto_linkup == 1'b1) );

  // decode FSM
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
       dec_state <= D_IDLE;
    else begin
      case(dec_state)
        //
        D_IDLE: begin
          if (mdec_val == 1'b1) begin
            // Don't try and decode INSTR if in man linkup mode, only ALINK
            if (miso_test_mode == 1'b1)
              dec_state <= D_TMODE;
            else if (man_linkup == 1'b1)
              dec_state <= D_IDLE;
            else if  (auto_linkup == 1'b1) begin
              if ((mdec_word[7] == 1'b1) & (mdec_word[6:3] == ALINK)) // start bit and instr=ALINK
                dec_state <= D_LINKUP;
              else
                dec_state <= D_IDLE;
            end else begin
              if (mdec_word[7] == 1'b1) begin // start bit
                if (mdec_word[6:3] == READ_ACK)
                  dec_state <= D_RINDEX;
                else if (mdec_word[6:3] == ERR_MSG)
                  dec_state <= D_ERROR;
                else
                  dec_state <= D_MERR;
              end
            else
              dec_state <= D_IDLE;
            end // else: !if( (auto_linkup == 1'b1) | (man_linkup == 1'b1) )
          end else // if (mdec_val == 1'b1)
            dec_state <= D_IDLE;
        end // case: D_IDLE

        D_INSTR: begin
          if (mdec_val == 1'b1) begin
            // Don't try and decode INSTR if in linkup mode, only ALINK
            if (mdec_word[7] == 1'b1) begin // start bit
              if (mdec_word[6:3] == READ_ACK)
                dec_state <= D_RINDEX;
              else if (mdec_word[6:3] == ERR_MSG)
                dec_state <= D_ERROR;
              else
                dec_state <= D_MERR;
            end
          end // if (mdec_val == 1'b1)
        end // case: D_INSTR

        D_RINDEX: begin
          if (mdec_val == 1'b1) begin
            if (mdec_cont == 1'b0)
              dec_state <= D_RDATA;
            else
              dec_state <= D_RINDEX;
          end
        end

        D_RDATA: begin
          if (mdec_val == 1'b1) begin
            if (mdec_cont == 1'b0) begin
              if ((next_frm_start == 1'b0)) // no start bit on next incoming frame
                  dec_state <= D_IDLE;
              else
                dec_state <= D_IDLE; // handles back-to-back incoming frames
              end // if (mdec_cont == 1'b0)
            else
              dec_state <= dec_state;
          end
        end

        D_LINKUP: begin
          if (mdec_val == 1'b1) begin
            if (mdec_cont == 1'b0)
              dec_state <= D_IDLE;
            else
              dec_state <= D_LINKUP;
          end
        end

        D_ERROR: begin// go back to IDLE
          if (mdec_val == 1'b1)
            dec_state <= D_IDLE;
          else
            dec_state <= D_ERROR;
        end

        D_TMODE: begin
          if (miso_test_mode == 1'b1)
            dec_state <= D_TMODE;
          else
            dec_state <= D_IDLE;
        end

        D_MERR: begin // go back to IDLE
          if (mdec_val == 1'b1)
            dec_state <= D_IDLE;
          else
            dec_state <= D_MERR;
        end

        default: begin
          dec_state <= D_IDLE;
        end
      endcase // unique case (dec_state)
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)


  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      rd_index <= 32'h0;
      rd_data <= 32'h0;

      rd_index_cnt <= 2'b00;
      rd_data_cnt <= 2'b00;
      store_data <= 1'b0;
      store_we <= 4'h0;

      alink_dval <= 1'b0;
      alink_data <= 8'h00;
      signal_acquired <= 1'b0;

      tx_clk_adj_rcvd <= 4'h0;
      tx_clk_inv_rcvd <= 1'b0;
    end else begin
      case(dec_state)
        D_IDLE: begin
          rd_index <= 32'h0;
          rd_data <= 32'h0;

          rd_index_cnt <= 2'b00;
          rd_data_cnt <= (read_done == 1'b1) ? 2'b00: rd_data_cnt;
          store_data <= 1'b0;
          store_we <= 4'h0;

          if (auto_linkup == 1'b1) begin
            if (ver_b_na == 1'b1) begin
              if ((mdec_word[7] == 1'b1) & (mdec_word[6:3] == ALINK)) begin
                tx_clk_adj_rcvd <= {mdec_word[1:0], mdec_par, mdec_cont};
                tx_clk_inv_rcvd <=  mdec_word[2];
              end
            end else begin
              tx_clk_adj_rcvd <= 4'h0;
              tx_clk_inv_rcvd <= 1'b0;
            end // else: !if(ver_b_na == 1'b1)
          end else begin // if (auto_linkup == 1'b1)
            if (frm_det == 1'b1)
              rd_tsize <= mdec_word[1:0];
          end // else: !if(auto_linkup == 1'b1)

          alink_dval <= 1'b0;
          alink_data <= 8'h00;
        end // case: D_IDLE

        D_INSTR: begin
          rd_index_cnt <= 2'b00;
          // rd_data_cnt <= 2'b00;
          store_data <= 1'b0;
          store_we <= 4'h0;
        end

        D_RINDEX: begin
          if (mdec_val == 1'b1) begin
            case (rd_index_cnt)
              2'b00: rd_index <= {rd_index[31:8], mdec_word[7:0]};
              2'b01: rd_index <= {rd_index[31:16], mdec_word[7:0], rd_index[7:0]};
              2'b10: rd_index <= {rd_index[31:24], mdec_word[7:0], rd_index[15:0]};
              2'b11: rd_index <= {mdec_word[7:0], rd_index[23:0]};
            endcase // case (rd_index_cnt)
            rd_index_cnt <= (rd_index_cnt == 2'b11) ? rd_index_cnt: rd_index_cnt + 2'b01;
          end
        end // case: D_RINDEX

        D_RDATA: begin
          if (mdec_val == 1'b1) begin
            rd_index_cnt <= 2'b00;

            case(rd_data_cnt)
              2'b00: begin
                rd_data <= {24'h0, mdec_word[7:0]};
                store_data <= 1'b1;
                store_we <= 4'h1;
              end

              2'b01: begin
                rd_data <= {16'h0, mdec_word[7:0], 8'h0};
                store_data <= 1'b1;
                store_we <= 4'h2;
              end

              2'b10: begin
                rd_data <= {8'h0, mdec_word[7:0], 16'h0};
                store_data <= 1'b1;
                store_we <= 4'h4;
              end

              2'b11: begin
                rd_data <= {mdec_word[7:0], 24'h0};
                store_data <= 1'b1;
                store_we <= 4'h8;
              end
            endcase // case (rd_data_cnt)
            rd_data_cnt <= rd_data_cnt + 2'b01;
          end else begin // if (mdec_val == 1'b1)
            store_data <= 1'b0;
            rd_data_cnt <= rd_data_cnt;
            rd_data <= rd_data;
          end // else: !if(mdec_val == 1'b1)
        end // case: D_RDATA

        D_LINKUP: begin
          signal_acquired <= 1'b1;
          if (mdec_val == 1'b1) begin
            alink_dval <= 1'b1;
            alink_data <= mdec_word[7:0];
          end else
            alink_dval <= 1'b0;
        end

        D_ERROR: begin
        end

        D_MERR: begin
        end

        default: begin
        end
      endcase // unique case (dec_state)
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  // tally read bytes
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      read_pending <= 1'b0;
      read_byte_cnt <= 17'h00000;
      read_done_d <= 1'b0;
      read_done <= 1'b0;
    end else begin
      read_done_d <= read_done;

      if (read_op == 1'b1) begin
        read_pending <= 1'b1;
        read_byte_cnt <= 17'h00000;
        read_done <= 1'b0;
      end else if (store_data == 1'b1) begin
        read_byte_cnt <= read_byte_cnt + 17'h00001;
      end else if (read_byte_cnt > read_byte_num) begin
        read_pending <= 1'b0;
        read_byte_cnt <= 17'h00000;
        read_done <= 1'b1;
      end else if (read_done_d == 1'b1) begin // keep read_done high fr 2 cycles
        read_done <= 1'b0;
      end else begin
        read_pending <= read_pending;
        read_byte_cnt <= read_byte_cnt;
        read_done <= read_done;
      end // else: !if(store_data == 1'b1)
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  // set-up unkn_instr
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      unk_instr_err <= 1'b0;
    else begin
      if ((dec_state == D_MERR) & (mdec_val == 1'b1))
        unk_instr_err <= 1'b1;
      else if (clear_errors == 1'b1)
        unk_instr_err <= 1'b0;
      else
        unk_instr_err <= unk_instr_err;
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)


  // set-up error_code
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      error_code <= 1'b0;
    else begin
      if ((dec_state == D_ERROR) & (mdec_val == 1'b1))
        error_code <= mdec_word[7:0];
      else if (clear_errors == 1'b1)
        error_code <= 8'h00;
      else
        error_code <= error_code;
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)


  // dpram i/f
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      dec_en <= 1'b0;
      dec_we <= 4'h0;
      dec_addr <= 15'h0000;
      dec_data <= 32'h0;
      new_dec_addr <= 1'b0;
    end else begin
      if (store_data == 1'b1) begin
        dec_en <= 1'b1;
        dec_we <= store_we;
        dec_addr <= dec_addr;
        dec_data <= rd_data;
        if (dec_we[0] == 1'b1)
          new_dec_addr <= 1'b0;
      end else begin
        if (menc_state == 4'b0000) begin // menc_state = IDLE
          dec_en <= 1'b0;
          dec_we <= 4'h0;
          dec_addr <= 15'h0000;
          dec_data <= 32'h0;
        end else begin
          dec_en <= 1'b0;
          dec_we <= 4'h0;
          dec_addr <= dec_addr;
          dec_data <= 32'h0;
        end // else: !if(dec_state == D_IDLE)
      end // else: !if(store_data == 1'b1)

      if (dec_we[3] == 1'b1) begin
        dec_addr <= dec_addr + 15'h0001;
        new_dec_addr <= 1'b1;
      end else if (xfer_mode == 1'b1) begin // dis-contiguous mode
        if ((read_done == 1'b1) & (read_done_d == 1'b1)) begin
          if (new_dec_addr == 1'b1)
            new_dec_addr <= 1'b0;
          else
            dec_addr <= dec_addr + 15'h0001;
        end
      end else begin
        if ((read_done == 1'b1) & (read_done_d == 1'b1)) begin
          dec_addr <= 15'h0000;
          new_dec_addr <= 1'b0;
        end
      end
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  // set-up status sigs
  assign dec_fsm = dec_state;

endmodule
