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

`timescale 1ps/1ps

module hsci_mcore (
  // globals
  input hsci_pclk,
  input hsci_rstn,
  // register inputs
  input hsci_master_run,
  input [1:0] hsci_cmd_sel,  // 00=write, 01=read, 10=write
  input [15:0] hsci_master_xfer_num,
  input [16:0] hsci_master_byte_num,
  input [2:0]  hsci_master_addr_size,  // 00=1 byte, 01=2 bytes, 10=3 bytes, 11=4 bytes
  input [15:0] hsci_master_bram_addr,
  input [1:0] tsize,      // 00=byte, 01=halfword, 10=word
  input man_linkup,
  input [9:0] man_linkup_word,
  input auto_linkup,
  input capture_mode,
  output [9:0] capture_word,
  input mosi_test_mode,
  input miso_test_mode,
  input alink_fsm_stall,
  input alink_fsm_step,
  input clear_errors,
  input ver_b_na,
  input mosi_clk_inv,
  input miso_clk_inv,
  // status sigs
  output master_done,
  output master_running,
  output master_wr_in_prog,
  output master_rd_in_prog,
  output [3:0] enc_fsm,
  output [2:0] dec_fsm,
  output link_active,
  output [3:0] alink_fsm,
  output [15:0] alink_table,
  output [3:0] alink_txclk_adj,
  output alink_txclk_inv,
  output [31:0] miso_ber_cnt,
  output miso_test_lfsr_acq,
  output [7:0] error_code,
  output parity_err,
  output unk_instr_err,
  output [31:0] link_err_info,
  output alink_fsm_stalled,
  output txclk_adj_mismatch,
  output txclk_inv_mismatch,
  // dpram i/f
  output [14:0] mem_addr,
  output mem_en,
  output [31:0] mem_din,
  output [3:0] mem_we,
  input [31:0] mem_dout,
  // iserdes/oserdes i/f
  output [7:0] menc_clk,
  output [7:0] menc_data,
  input [7:0] mdec_data
);

  // hsci_mlink_ctrl internal outputs
  wire [9:0] linkup_word;
  wire [7:0] lfsr_word;
  wire frm_acq;
  // wire [31:0] link_err_info;

  // hsci_enc internal outputs
  wire menc_pause;
  wire [14:0] enc_addr;
  wire enc_en;
  wire [31:0] enc_data;
  wire [3:0] menc_state;
  wire xfer_mode;
  wire read_op;
  wire [16:0] read_byte_num;

  wire xfer_active;
  wire menc_val;
  wire [9:0] menc_word;

  // hsci_mfrm_det internal outputs
  wire frm_det;
  wire next_frm_start;
  wire [9:0] mdec_sfrm;
  // wire [31:0] mdec_ber_cnt;

  // hsci_mdec internal outputs
  wire [14:0] dec_addr;
  wire dec_en;
  wire [31:0] dec_data;
  wire [3:0] dec_we;
  wire alink_dval;
  wire [1:0] rd_tsize;
  wire [7:0] alink_data;
  wire signal_det;
  wire signal_acquire;
  wire idle_state;
  wire [3:0] tx_clk_adj_rcvd;
  wire tx_clk_inv_rcvd;
  wire read_done;
  wire [31:0] mdec_ber_cnt;

  // linkup control
  hsci_mlink_ctrl ctrl0 (
    // global
    .hsci_pclk(hsci_pclk),
    .rstn(hsci_rstn),
    // register sigs
    .man_linkup(man_linkup),
    .man_linkup_word(man_linkup_word),
    .auto_linkup(auto_linkup),
    .mosi_test_mode(mosi_test_mode),
    .alink_fsm_stall(alink_fsm_stall),
    .alink_fsm_step(alink_fsm_step),
    .ver_b_na(ver_b_na),
    // status sigs
    .alink_fsm(alink_fsm),
    .alink_table(alink_table),
    .alink_txclk_adj(alink_txclk_adj),
    .alink_txclk_inv(alink_txclk_inv),
    .alink_fsm_stalled(alink_fsm_stalled),
    .txclk_adj_mismatch(txclk_adj_mismatch),
    .txclk_inv_mismatch(txclk_inv_mismatch),
    // menc sigs
    .menc_pause(menc_pause),
    .lfsr_word(lfsr_word),
    // mdec sigs
    .signal_det(signal_det),
    .signal_acquired(signal_acquired),
    .alink_dval(alink_dval),
    .alink_data(alink_data),
    .idle_state(idle_state),
    .frm_acq(frm_acq),
    .tx_clk_adj_rcvd(tx_clk_adj_rcvd),
    .tx_clk_inv_rcvd(tx_clk_inv_rcvd),
    // output
    .linkup_word(linkup_word),
    .link_active(link_active),
    .link_err_info(link_err_info));

  // drive link_err_info out ber_cnt if auto link fsm = link_err
  // assign miso_ber_cnt[31:0] = (alink_fsm == 4'hB) ? link_err_info[31:0]: mdec_ber_cnt[31:0];

   // hsci_menc
  hsci_menc enc0 (
    // globals
    .hsci_pclk(hsci_pclk),
    .rstn(hsci_rstn),
    // register inputs
    .hsci_master_run(hsci_master_run),
    .hsci_cmd_sel(hsci_cmd_sel),
    .hsci_master_xfer_num(hsci_master_xfer_num),
    .hsci_master_byte_num(hsci_master_byte_num),
    .hsci_master_addr_size(hsci_master_addr_size),
    .hsci_master_bram_addr(hsci_master_bram_addr),
    .tsize(tsize),
    .mosi_test_mode(mosi_test_mode),
    .mosi_clk_inv(mosi_clk_inv),
    // status sigs
    .master_done(master_done),
    .master_running(master_running),
    .master_wr_in_prog(master_wr_in_prog),
    .master_rd_in_prog(master_rd_in_prog),
    .enc_fsm(enc_fsm),
    // link control sigs
    .man_linkup(man_linkup),
    .auto_linkup(auto_linkup),
    .linkup_word(linkup_word),
    .menc_pause(menc_pause),
    .lfsr_word(lfsr_word),
    // mem i/f
    .enc_addr(enc_addr),
    .enc_data(enc_data),
    .enc_en(enc_en),
    // oserdes i/f
    .menc_clk(menc_clk),
    .menc_data(menc_data),
    // i/f to mdec
    .menc_state(menc_state),
    .xfer_mode(xfer_mode),
    .read_op(read_op),
    .read_byte_num(read_byte_num),
    .read_done(read_done));
    // auto link i/f
    // TBD

  // hsci_mfrm_det
  hsci_mfrm_det frm_det0 (
    // globals
    .hsci_pclk(hsci_pclk),
    .rstn(hsci_rstn),
    // iserdes i/f
    .mdec_data(mdec_data),
    // inputs from mdec
    .dec_fsm(dec_fsm),
    .rd_tsize(rd_tsize),
    // register i/f
    .capture_mode(capture_mode),
    .capture_word(capture_word),
    .miso_test_mode(miso_test_mode),
    .miso_ber_cnt(miso_ber_cnt),
    .miso_test_lfsr_acq(miso_test_lfsr_acq),
    .miso_clk_inv(miso_clk_inv),
     // link control sigs
    .man_linkup(man_linkup),
    .auto_linkup(auto_linkup),
    .alink_fsm(alink_fsm),
    .frm_acq(frm_acq),
    // i/f to mdec
    .frm_det(frm_det),
    .next_frm_start(next_frm_start),
    .mdec_sfrm(mdec_sfrm),
    .mdec_val(mdec_val));

  // hsci_mdec
  hsci_mdec dec0 (
    // globals
    .hsci_pclk(hsci_pclk),
    .rstn(hsci_rstn),
    // inputs from mfrm_det
    .frm_det(frm_det),
    .next_frm_start(next_frm_start),
    .mdec_sfrm(mdec_sfrm),
    .mdec_val(mdec_val),
    .rd_tsize(rd_tsize),
    //  mem i/f
    .dec_addr(dec_addr),
    .dec_data(dec_data),
    .dec_en(dec_en),
    .dec_we(dec_we),
    // register i/f
    .miso_test_mode(miso_test_mode),
    .dec_fsm(dec_fsm),
    .error_code(error_code),
    .clear_errors(clear_errors),
    .parity_err(parity_err),
    .unk_instr_err(unk_instr_err),
    // link control sigs
    .ver_b_na(ver_b_na),
    .man_linkup(man_linkup),
    .auto_linkup(auto_linkup),
    .alink_fsm(alink_fsm),
    .alink_dval(alink_dval),
    .alink_data(alink_data),
    .signal_det(signal_det),
    .signal_acquired(signal_acquired),
    .idle_state(idle_state),
    .tx_clk_adj_rcvd(tx_clk_adj_rcvd),
    .tx_clk_inv_rcvd(tx_clk_inv_rcvd),
    // i/f to menc
    .menc_state(menc_state),
    .xfer_mode(xfer_mode),
    .read_op(read_op),
    .read_byte_num(read_byte_num),
    .read_done(read_done));

  // dpram mux,  default reads to hsci_enc
  assign mem_addr = (dec_en == 1'b1) ? dec_addr: enc_addr;
  assign mem_en = enc_en | dec_en;
  assign enc_data = mem_dout;
  assign mem_din  = dec_data;
  assign mem_we = dec_we;

endmodule
