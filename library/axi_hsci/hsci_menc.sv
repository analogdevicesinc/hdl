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
//  1. The GNU General Public License version 2 as published by the
//    Free Software Foundation, which can be found in the top level directory
//    of this repository (LICENSE_GPL2), and also online at:
//    <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//  2. An ADI specific BSD license, which can be found in the top level directory
//    of this repository (LICENSE_ADIBSD), and also on-line at:
//    https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//    This will allow to generate bit files and not release the source code,
//    as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ps

module hsci_menc (
  // globals
  input hsci_pclk,
  input rstn,
  // Reg inputs
  input hsci_master_run,
  input [1:0] hsci_cmd_sel,
  input [15:0] hsci_master_xfer_num,
  input [16:0] hsci_master_byte_num,
  input [2:0] hsci_master_addr_size,
  input [15:0] hsci_master_bram_addr,
  input [1:0] tsize,
  input mosi_test_mode,
  input mosi_clk_inv,
  // status sigs for regmap
  output master_done,
  output master_running,
  output reg master_wr_in_prog,
  output reg master_rd_in_prog,
  output [3:0] enc_fsm,
  // link control sigs
  input man_linkup,
  input auto_linkup,
  input [9:0] linkup_word,
  output menc_pause,
  input [7:0] lfsr_word,
  // mem interfac
  output reg [14:0] enc_addr,
  input [31:0] enc_data,  // Note: this is data read from the memory and actually write data to the slave
  output reg enc_en,
  // oserdes interfac
  output reg [7:0] menc_clk,
  output reg [7:0] menc_data,
  // i/f with  mdec
  output [3:0] menc_state,
  output xfer_mode,
  output reg read_op,
  output reg [16:0] read_byte_num,
  input read_done
);

  typedef enum reg [3:0] { S_IDLE    = 4'b0000,
                           S_START1   = 4'b0001,
                           S_START2   = 4'b0010,
                           S_START3   = 4'b0011,
                           SEND_INSTR  = 4'b0100,
                           SEND_ADDR  = 4'b0101,
                           SEND_MASK  = 4'b0110,
                           SEND_DATA  = 4'b0111,
                           SEND_NUM   = 4'b1000,
                           S_READOP   = 4'b1001,
                           SEND_LINKUP = 4'b1010
                         } state;

  state mstate;
  state prev_state;

  localparam MWRITE_OP  = 4'b0110;
  localparam MREAD_OP   = 4'b1000;
  localparam MRMW_OP    = 4'b1001;
  localparam LINKUP_OP  = 4'b1001;

  localparam LINKUP_SFRM = 5'b1_0101;

  reg [1:0]  m_xfer_type;  //  hsci_cmd_sel:  0=write, 1=read, 2=rmw
  reg [15:0] m_xfer_num;  //  hsci_master_xfer_num
  reg [15:0] m_xfer_cnt;
  reg [16:0] m_byte_num;  //  hsci_master_byte_num
  reg [16:0] m_byte_cnt;
  reg [2:0]  m_addr_size;

  reg m_xfer_mode;      //  0=continuous, 1=dis-contigous
  reg [3:0]  m_instr;
  reg [1:0]  m_tsize;
  reg [1:0]  maddr_cnt;
  reg [1:0]  mdata_cnt;
  reg [1:0]  mask_cnt;
  reg [1:0]  byte_num_size;
  reg active_wr;

  reg [31:0] wr_addr;
  reg [31:0] wr_mask;
  reg [31:0] wr_data;
  reg [9:0] menc_word;
  reg [2:0] menc_word_cntr;
  wire pbit;
  reg [7:0] cur_buf, next_buf;
  //  wire menc_pause;

  // linkup variables
  reg [2:0] linkup_cntr;
  reg [7:0] lfsr_out;
  reg lfsr_en;
  reg [2:0] txclk_ctrl;

  // FIFO variables
  reg [31:0] fmem [0:7];
  reg [2:0]  wr_ptr, rd_ptr;
  reg mem_fetch, mem_fetch_d1, mem_fetch_d2;
  wire full;
  wire empty;

  // status sigs for regmap
  assign menc_state = mstate;
  assign xfer_mode = m_xfer_mode; // 0=continuous, 1=dis-contiguous


  // build 8 element FIFO to accomodate dpram interface
  // this is a synchronize FIFO
  // write side should ALWAYS write faster than read
  // Once started write side will write until full
  // NOTE:  the write side will end up loadibg invalid values, but the FSM should retreat back to S_IDLE before those values are read
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      fmem[0] <= 32'h0;
      fmem[1] <= 32'h0;
      fmem[2] <= 32'h0;
      fmem[3] <= 32'h0;
      fmem[4] <= 32'h0;
      fmem[5] <= 32'h0;
      fmem[6] <= 32'h0;
      fmem[7] <= 32'h0;
      wr_ptr <= 3'b000;
      enc_addr <= 15'h0000;
      mem_fetch <= 1'b0;
      mem_fetch_d1 <= 1'b0;
      mem_fetch_d2 <= 1'b0;
    end else begin
      mem_fetch_d2 <= mem_fetch_d1;
      mem_fetch_d1 <= mem_fetch;

      if (hsci_master_run == 1'b1) begin
        enc_addr <= hsci_master_bram_addr;
        mem_fetch <= 1'b1;
      end else if (master_running == 1'b1) begin
        if (empty == 1'b1) begin
          enc_addr <= enc_addr + 15'h0001;
          mem_fetch <= 1'b1;
        end else begin
          enc_addr <= enc_addr;
          mem_fetch <= 1'b0;
        end

        if (mem_fetch_d2 == 1'b1) begin
          fmem[wr_ptr] <= enc_data;
          wr_ptr <= wr_ptr + 3'b001;
        end
      end else begin// if (master_rinning == 1'b1)
        wr_ptr <= 3'b000;
        enc_addr <= 15'h0000;
        mem_fetch <= 1'b0;
        mem_fetch_d1 <= 1'b0;
        mem_fetch_d2 <= 1'b0;
      end // else: !if(master_rinning == 1'b1)
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  assign full  = ((( wr_ptr + 3'b001) == rd_ptr) | (( wr_ptr + 3'b010) == rd_ptr) | (( wr_ptr + 3'b011) == rd_ptr));
  assign empty = ((wr_ptr == rd_ptr) | (wr_ptr == (rd_ptr + 3'b001)) | (wr_ptr == (rd_ptr +3'b010)) | (wr_ptr == (rd_ptr +3'b011)));

  // FSM for access
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      mstate <= S_IDLE;
      prev_state <= S_IDLE;
    end else begin
      unique case (mstate)
       // remain in S_IDLE until hsci_master_run detected
        S_IDLE: begin
          if ((man_linkup == 1'b1) | (auto_linkup == 1'b1))
            mstate <= SEND_LINKUP;
          else if (hsci_master_run == 1'b1)
            mstate <= S_START1;
          else
            mstate <= S_IDLE;
        end

        // wait for FIFO to catch up
        S_START1: begin
          mstate <= S_START2;
        end

        // wait for FIFO to catch up
        S_START2: begin
          mstate <= S_START3;
        end

        // wait for FIFO to catch up
        S_START3: begin
          mstate <= SEND_INSTR;
        end

        // Access always begins with instruction word
        // Gated by parser rdy
        SEND_INSTR: begin
          if (menc_pause != 1'b1)
            mstate <= SEND_ADDR;
          else
            mstate <= SEND_INSTR;
        end

        // For write, read or rmw operation, SEND_ADDR after SEND_INSTR
        // Gated by menc_pause
        // For Write_op proceed to SEND_DATA
        // For RMW_op proceed to SEND_MASK
        // For Read_req_op proced to SNED_NUM
        SEND_ADDR: begin
          if (menc_pause != 1'b1) begin
            if (maddr_cnt == 2'b00) begin
              if (m_instr == MWRITE_OP)
                mstate <= SEND_DATA;
              else if (m_instr == MRMW_OP)
                mstate <= SEND_DATA;  // write and rmw ops are treated the same
              else
                mstate <= SEND_NUM;
            end else
              mstate <= SEND_ADDR;
          end else
            mstate <= SEND_ADDR;
        end // case: SEND_ADDR

        // RMW operation
        // During Read-Modify-Write, the FSM will toggle between SEND_MASK and SEND_DATA
        SEND_MASK: begin
          if (menc_pause != 1'b1) begin
            if (mask_cnt == 2'b00)
              mstate <= SEND_DATA;
            else
              mstate <= SEND_MASK;
          end else
            mstate <= SEND_MASK;
        end // case: SEND_MASK

        // Write or RMW Operation
        // Gated by menc_pause
        // Once all data sent, return to S_IDLE
        SEND_DATA: begin
          if (menc_pause != 1'b1) begin
            if ((m_xfer_cnt == m_xfer_num) && (m_byte_cnt == m_byte_num))
              mstate <= S_IDLE;
            else begin
              if (m_byte_cnt == m_byte_num)
                mstate <= SEND_INSTR;
              else
                mstate <= SEND_DATA;
            end
          end // if (menc_pause != 1'b1)
        end // case: SEND_DATA

        // For Read_req_op, SEND_ADDR -> SEND_NUM
        // Gated by menc_pause
        // once complete, return to S_IDLE
        SEND_NUM: begin
          if (menc_pause != 1'b1) begin
            if (byte_num_size == 2'b00)
              mstate <= S_READOP;
            else
              mstate <= SEND_NUM;
          end
        end

        S_READOP: begin
          if (menc_pause != 1'b1) begin
            if (read_done == 1'b1) begin
              if (m_xfer_mode == 1'b0) // continuous read
                mstate <= S_IDLE;
              else begin           // discontiguous read, need to check xfer_cnt
                if (m_xfer_cnt == m_xfer_num)
                  mstate <= S_IDLE;
                else
                  mstate <= SEND_INSTR;
              end
            end // if (read_done == 1'b1)
          else
            mstate <= S_READOP;
          end // if (menc_pause != 1'b1)
        end // case: S_READOP

        SEND_LINKUP: begin
          if ((man_linkup == 1'b1) | (auto_linkup == 1'b1))
            mstate <= SEND_LINKUP;
          else
            mstate <= S_IDLE;
        end

        default: begin
          mstate <= S_IDLE;
        end
      endcase // unique case (mstate)
      prev_state <= mstate;
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)


  // Use FSM to determine action
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      // output to mparser
      menc_word <= 10'h000;

      // internals
      m_xfer_type    <= 2'b00;
      m_xfer_mode    <= 1'b0;
      m_xfer_num    <= 16'h0000;
      m_xfer_cnt    <= 16'h0000;
      m_byte_num    <= 17'h0000;
      m_byte_cnt    <= 17'h0000;
      m_addr_size    <= 3'b000;
      m_instr      <= 4'h0;
      m_tsize      <= 3'b000;
      maddr_cnt     <= 2'b00;  // needed for 16 bit & 32 bit addresses
      mdata_cnt     <= 2'b00;  // needed for 16 bit and 32 bit data
      mask_cnt      <= 2'b00;
      byte_num_size <= 2'b00;

      active_wr <= 1'b0;
      wr_addr <= 32'h0;
      wr_data <= 32'h0;
      wr_mask <= 32'h0;

      read_op <= 1'b0;
      read_byte_num <= 17'h0000;

      // memory access always on
      enc_en <= 1'b1;
      rd_ptr <= 3'b000;
    end else begin
      case (mstate)
        S_IDLE: begin
          menc_word <= 10'h000;

          if (hsci_master_run) begin  // At beginning of operation, load info
            m_xfer_type <= hsci_cmd_sel;
            m_xfer_mode <= (hsci_master_xfer_num == 16'h0001) ? 1'b0: 1'b1;
            m_xfer_num  <= hsci_master_xfer_num - 1;
            m_xfer_cnt  <= 16'h0;
            m_addr_size <= hsci_master_addr_size;
            m_instr    <= (hsci_cmd_sel[1:0] == 2'b00) ? MWRITE_OP:
                      (hsci_cmd_sel[1:0] == 2'b01) ? MREAD_OP:
                      (hsci_cmd_sel[1:0] == 2'b10) ? MRMW_OP:
                                            LINKUP_OP;
            m_byte_num  <= hsci_master_byte_num - 1;
            m_byte_cnt <= 17'h0000;
            read_byte_num <= hsci_master_byte_num - 1;
            maddr_cnt <= hsci_master_addr_size[1:0];
            byte_num_size <= (hsci_master_byte_num[16:8] == 8'h00) ? 2'b00:
                        (hsci_master_byte_num[16]  == 1'b0)  ? 2'b01:
                                                  2'b10;

            m_tsize    <= tsize;

            // start memory access
            enc_en <= 1'b1;
          end else begin// if (hsci_master_run)
            m_xfer_type    <= 2'b00;
            m_xfer_mode    <= 1'b0;
            m_xfer_num    <= 16'h0000;
            m_xfer_cnt    <= 16'h0000;
            m_instr      <= 3'b000;
            m_addr_size    <= 3'b000;
            m_tsize      <= 2'b00;
            maddr_cnt     <= 2'b00;
            mdata_cnt     <= 2'b00;
            mask_cnt      <= 2'b00;
            byte_num_size  <= 2'b00;

            active_wr  <= 1'b0;
            wr_addr <= 32'h0;
            wr_data <= 32'h0;
            wr_mask <= 32'h0;

            read_op <= 1'b0;
            read_byte_num <= 17'h0000;

            // dpram i/f
            enc_en <= 1'b1;
            rd_ptr <= 3'b000;
          end // else: !if(hsci_master_run)
        end // case: S_IDLE

        SEND_INSTR: begin
          m_byte_cnt <= 17'h0;
          mdata_cnt <= 2'b00;
          maddr_cnt <= m_addr_size;

          if (menc_pause != 1'b1) begin
            // drive out instr
            menc_word[9]  <= 1'b1;    // Start bit
            menc_word[8:5] <= m_instr;  // Instruction
            menc_word[4:2] <= {1'b0, m_tsize};  // Tsize
            menc_word[1]  <= 1'b0;    // Parity generation takes place in mparse
            menc_word[0]  <= 1'b0;

            // fifo i/f
            // addr needs to be reformatted according to addr_size
            case(hsci_master_addr_size)
              2'b00: wr_addr <= {24'h0, fmem[rd_ptr][7:0]};
              2'b01: wr_addr <= {16'h0, fmem[rd_ptr][7:0], fmem[rd_ptr][15:8]};
              2'b10: wr_addr <= {8'h0,  fmem[rd_ptr][7:0], fmem[rd_ptr][15:8], fmem[rd_ptr][23:16]};
              2'b11: wr_addr <= {fmem[rd_ptr][7:0], fmem[rd_ptr][15:8], fmem[rd_ptr][23:16], fmem[rd_ptr][31:24]};
            endcase // case (addr_size)
            rd_ptr <= rd_ptr + 3'b001;
          end else begin
            menc_word <= menc_word;  // hold menc_word
          end // else: !if(menc_pause == 1'b1)
        end // case: SEND_INSTR

        // Drive out a byte, 2 bytes or 4 bytes of address depending on addr_size
        // need to wait for menc_pause
        SEND_ADDR: begin
          if (menc_pause != 1'b1) begin
            // drive out addr
            case (maddr_cnt)
              2'b11:  begin  menc_word <= {wr_addr[31:24], 1'b0, 1'b1}; end
              2'b10:  begin  menc_word <= {wr_addr[23:16], 1'b0, 1'b1}; end
              2'b01:  begin  menc_word <= {wr_addr[15:8],  1'b0, 1'b1}; end
              2'b00:  begin  menc_word <= {wr_addr[7:0],  1'b0, 1'b0}; end
            endcase // case (maddr_cnt)
            maddr_cnt <= (maddr_cnt == 2'b00) ? maddr_cnt: maddr_cnt - 1;

            // read next fifo location if maddr_cnt = 0
            if (maddr_cnt == 2'b00) begin
              if ((m_instr == MWRITE_OP) | (m_instr == MRMW_OP)) begin
                wr_data <= fmem[rd_ptr];
                rd_ptr <= rd_ptr + 3'b001;
              end
            end
          end else begin // if ((menc_pause == 1'b1) && (menc_val == 1'b0))
            menc_word <= menc_word;
          end // else: !if((menc_pause == 1'b1) && (menc_val == 1'b0))
        end // case: SEND_ADDR

        // send out data
        // depending on tsize, send out byte, halfword or words with mdata_cnt keeping track
        // m_daddr is incremented and compared to m_dmax, when m_daddr == m_dmax, dara xfer conplete
        SEND_DATA: begin
          if (menc_pause != 1'b1) begin
            case (mdata_cnt)
              2'b00: menc_word[9:2] <= wr_data[7:0];
              2'b01: menc_word[9:2] <= wr_data[15:8];
              2'b10: menc_word[9:2] <= wr_data[23:16];
              2'b11: menc_word[9:2] <= wr_data[31:24];
            endcase // case (mdata_cnt)
            menc_word[1] <= 1'b0;
            menc_word[0] <= (m_byte_num == m_byte_cnt) ? 1'b0: 1'b1;
            m_byte_cnt <= m_byte_cnt + 16'h0001;
            mdata_cnt <= mdata_cnt + 2'b01;

            //  incr xfer_cnt if byte_num = byte_cnt
            if (m_byte_cnt == m_byte_num)
              m_xfer_cnt <= m_xfer_cnt + 1;

            // Dont fetch data if in dis-contiguous mode
            if ((mdata_cnt == 2'b11) & (m_byte_cnt != m_byte_num)) begin
              wr_data <= fmem[rd_ptr];
              rd_ptr <= rd_ptr + 3'b001;
            end
          end else begin // if (menc_pause == 1'b1)
            menc_word <= menc_word;
          end
        end // case: SEND_DATA

        // For read op, send out number of bytes to read
        SEND_NUM: begin
          if (menc_pause != 1'b1) begin
            case(byte_num_size)
              2'b10: begin
                menc_word <= {m_byte_num[7:0],  1'b0, 1'b1};
                m_byte_num <= {8'h00, m_byte_num[16:8]};
              end

              2'b01: begin
                menc_word <= {m_byte_num[7:0],  1'b0, 1'b1};
                m_byte_num <= {8'h00, m_byte_num[16:8]};
              end

              2'b00: begin
                menc_word <= {m_byte_num[7:0],  1'b0, 1'b0};
                read_op <= 1'b1;
              end
            endcase // case (m_num_bytes_cnt)
            byte_num_size <= (byte_num_size == 2'b00) ? 2'b00: byte_num_size - 2'b01;
          end else begin // if (menc_pause == 1'b1)
            menc_word <= menc_word;
          end
        end // case: SEND_NUM

        S_READOP: begin
          read_op <= 1'b0;
          menc_word <= 10'h0;

          if (menc_pause != 1'b1) begin
            if ((m_xfer_mode == 1'b1) & (read_done == 1'b1))
              m_xfer_cnt <= m_xfer_cnt + 16'h0001;
          end
        end

        SEND_LINKUP: begin
          if (menc_pause != 1'b1)
            menc_word <= linkup_word;
        end // case: SEND_LINKUP
      endcase // case (mstate)
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  // set-up menc_word_cntr
  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn)
      menc_word_cntr <= 3'b000;
    else begin
      if (prev_state != S_IDLE)
        menc_word_cntr <= (menc_word_cntr == 3'b100) ? 3'b000: menc_word_cntr + 3'b001;
      else
        menc_word_cntr <= 3'b000;
    end
  end

  // parser
  assign pbit = (mstate != SEND_LINKUP) ? menc_word[9] + menc_word[8] + menc_word[7] + menc_word[6] + menc_word[5] + menc_word[4] + menc_word[3] + menc_word[2] + menc_word[0]
                                        : menc_word[1];

  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      cur_buf <= 8'h00;
      next_buf <= 8'h00;
    end else begin
      case(menc_word_cntr)
        3'b000: begin cur_buf <=            menc_word[9:2];  next_buf <= {6'h0,            pbit, menc_word[0]}; end
        3'b001: begin cur_buf <= {next_buf[1:0], menc_word[9:4]}; next_buf <= {4'h0, menc_word[3:2], pbit, menc_word[0]}; end
        3'b010: begin cur_buf <= {next_buf[3:0], menc_word[9:6]}; next_buf <= {2'h0, menc_word[5:2], pbit, menc_word[0]}; end
        3'b011: begin cur_buf <= {next_buf[5:0], menc_word[9:8]}; next_buf <= {    menc_word[7:2], pbit, menc_word[0]}; end
        3'b100: begin cur_buf <=  next_buf[7:0];            next_buf <= 8'h00;                          end
      endcase // case (menc_word_cntr)
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

  assign menc_pause = (menc_word_cntr == 3'b011);
  assign menc_clk = (mosi_clk_inv == 1'b0) ? 8'h55: 8'hAA;
  assign menc_data = (mosi_test_mode == 1'b1) ? lfsr_word: cur_buf;

  // set-up status sigs
  assign master_done = (mstate == S_IDLE);
  assign master_running = !(mstate == S_IDLE);
  assign enc_fsm = mstate;

  always @ (posedge hsci_pclk or negedge rstn) begin
    if (~rstn) begin
      master_wr_in_prog <= 1'b0;
      master_wr_in_prog <= 1'b0;
    end else begin
      if ((mstate == S_START1) & ((m_instr == MWRITE_OP) | (m_instr == MRMW_OP)))
        master_wr_in_prog <= 1'b1;
      else if (mstate == S_IDLE)
        master_wr_in_prog <= 1'b0;
      else
        master_wr_in_prog <= master_wr_in_prog;

      if ((mstate == S_START1) & (m_instr == MREAD_OP))
        master_rd_in_prog <= 1'b1;
      else if (mstate == S_IDLE)
        master_rd_in_prog <= 1'b0;
      else
        master_rd_in_prog <= master_wr_in_prog;
    end // else: !if(~rstn)
  end // always @ (posedge hsci_pclk or negedge rstn)

endmodule
