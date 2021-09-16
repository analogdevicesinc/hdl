//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have
// by using this source code/core.
//
// The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask
// questions about and improve this core. Distribution of source, or resulting
// binaries (including those inside an FPGA or ASIC) require you to release the
// source of the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary.  If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License. (e.g. they
// do not require you to accompany any image (FPGA or ASIC) using the JESD204
// core with any corresponding source code.) For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a
// license to use this core in a commercial setting without releasing their
// source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required
// to do so; it is up to your common sense to decide whether you want to comply
// with this request or not.) For general publications, we suggest referencing :
// “The design and implementation of the JESD204 HDL Core used in this project
// is copyright © 2016-2017, Analog Devices, Inc.”
//

`timescale 1ns/100ps

module  jesd204_versal_gt_adapter_rx (
  input  [127 : 0] rxdata,
  //input  [1 : 0] rxdatavalid,
  input    [5 : 0] rxheader,
  output           rxgearboxslip,
  //output         rxlatclk,
  //output           gtrxreset,
  //output           rxprogdivreset,
  //output           rxuserrdy,
  //input          rxprogdivresetdone,
  //input          rxpmaresetdone,
  //input            rxresetdone,
  //input  [7 : 0] rx10gstat,
  //input  [2 : 0] rxbufstatus,
  //input          rxbyteisaligned,
  //input          rxbyterealign,
  //output         rxcdrhold,
  //input          rxcdrlock,
  //output         rxcdrovrden,
  //input          rxcdrphdone,
  //output         rxcdrreset,
  //input          rxchanbondseq,
  //input          rxchanisaligned,
  //input          rxchanrealign,
  //output [4 : 0] rxchbondi,
  //input  [4 : 0] rxchbondo,
  //input  [1 : 0] rxclkcorcnt,
  //input          rxcominitdet,
  //input          rxcommadet,
  //input          rxcomsoutputet,
  //input          rxcomwakedet,
  //input [15 : 0] rxctrl0,
  //input [15 : 0] rxctrl1,
  //input  [7 : 0] rxctrl2,
  //input  [7 : 0] rxctrl3,
  //output         rxdapicodeovrden,
  //output         rxdapicodereset,
  //input          rxdlyalignerr,
  //input          rxdlyalignprog,
  //output         rxdlyalignreq,
  //input          rxelecidle,
  //output         rxeqtraining,
  //input          rxfinealigndone,
  input    [1 : 0] rxheadervalid,
  //output         rxlpmen,
  //output         rxmldchaindone,
  //output         rxmldchainreq,
  //output         rxmlfinealignreq,
  //output         rxoobreset,
  //input          rxosintdone,
  //output [4 : 0] rxpcsresetmask,
  //output   [1 : 0] rxpd,
  //input          rxphaligndone,
  //input          rxphalignerr,
  //output         rxphalignreq,
  //output [1 : 0] rxphalignresetmask,
  //output         rxphdlypd,
  //output         rxphdlyreset,
  //input          rxphdlyresetdone,
  //input          rxphsetinitdone,
  //output         rxphsetinitreq,
  //output         rxphshift180,
  //input          rxphshift180done,
  //output [6 : 0] rxpmaresetmask,
  //output           rxpolarity,
  //output         rxprbscntreset,
  //input          rxprbserr,
  //input          rxprbslocked,
  //output [3 : 0] rxprbssel,
  //output [7 : 0] rxrate,
  //output [1 : 0] rxresetmode,
  //output           rxmstreset,
  //output         rxmstdatapathreset,
  //input          rxmstresetdone,
  //output         rxslide,
  //input          rxsliderdy,
  //input  [1 : 0] rxstartofseq,
  //input  [2 : 0] rxstatus,
  //output         rxsyncallin,
  //input          rxsyncdone,
  //output         rxtermination,
  //input          rxvalid,
  //output         cdrbmcdrreq,
  //output         cdrfreqos,
  //output         cdrincpctrl,
  //output         cdrstepdir,
  //output         cdrstepsq,
  //output         cdrstepsx,
  //output         eyescanreset,
  //output         eyescantrigger,
  //input          eyescandataerror,
  //input          cfokovrdrdy0,
  //input          cfokovrdrdy1,
  //input  [7 : 0] rxdataextendrsvd,
  //input          rxdccdone,
  //input          rxosintstarted,
  //input          rxosintstrobedone,
  //input          rxosintstrobestarted,
  //output         cfokovrdfinish,
  //output         cfokovrdpulse,

  // Interface to Link layer core
  output  [63:0]  rx_data,
  output   [1:0]  rx_header,
  output          rx_block_sync,

  // Other GTY signals
  //input           hsclk_lcplllocked,
  //input           hsclk_rplllocked,
  input           usr_clk//,
  //output          ilo_reset,

  // Control interface
  //output          up_pll_locked,
  //input           up_rst,
  //input           up_user_ready,
  //output          up_rst_done,
  //input           up_prbsforceerr,
  //input   [ 3:0]  up_prbssel,
  //input           up_lpm_dfe_n,
  //input   [ 2:0]  up_rate,
  //input   [ 1:0]  up_sys_clk_sel,
  //input   [ 2:0]  up_out_clk_sel,
  //input   [ 4:0]  up_diffctrl,
  //input   [ 4:0]  up_postcursor,
  //input   [ 4:0]  up_precursor,
  //input           up_enb,
  //input   [11:0]  up_addr,
  //input           up_wr,
  //input   [15:0]  up_wdata,
  //output  [15:0]  up_rdata,
  //output          up_ready

);

  //// Master reset not used
  //assign rxmstreset = 1'b0;

  //assign rxpd = 2'b0;
  //assign rxpolarity = 1'b0;

  //assign gtrxreset = up_rst;
  //assign rxprogdivreset = up_rst;
  //assign ilo_reset = up_rst;

  //// Assert rxuserrdy only when usr_clk is active
  //reg [2:0] usr_rdy = 3'b0;
  //always @(posedge usr_clk or negedge up_user_ready) begin
  //  if (~up_user_ready)
  //    usr_rdy <= 3'b0;
  //  else
  //    usr_rdy <= {1'b1,usr_rdy[2:1]};
  //end
  //assign rxuserrdy = usr_rdy[0];

  //assign up_rst_done = rxresetdone;
  //// TODO : Select locked status correctly
  //assign up_pll_locked = hsclk_lcplllocked | hsclk_rplllocked;

  // Sync header alignment
  wire rx_bitslip_req_s;
  reg [4:0] rx_bitslip_done_cnt = 'h0;
  always @(posedge usr_clk) begin
    if (rx_bitslip_done_cnt[4]) begin
      rx_bitslip_done_cnt <= 'b0;
    end else if (rx_bitslip_req_s & ~rx_bitslip_done_cnt[4]) begin
      rx_bitslip_done_cnt <= rx_bitslip_done_cnt + 1;
    end
  end

  reg rx_bitslip_req_s_d = 1'b0;
  always @(posedge usr_clk) begin
     rx_bitslip_req_s_d <= rx_bitslip_req_s;
  end
  assign rxgearboxslip = rx_bitslip_req_s & ~rx_bitslip_req_s_d;

  wire [63:0] rxdata_flip;
  genvar i;
  for (i = 0; i < 64; i=i+1) begin
    assign rxdata_flip[63-i] = rxdata[i];
  end

  // Sync header alignment
  sync_header_align i_sync_header_align (
    .clk(usr_clk),
    .reset(~rxheadervalid[0]),
    // Flip header bits and data
    .i_data({rxheader[0],rxheader[1],rxdata_flip[63:0]}),
    .i_slip(rx_bitslip_req_s),
    .i_slip_done(rx_bitslip_done_cnt[4]),
    .o_data(rx_data),
    .o_header(rx_header),
    .o_block_sync(rx_block_sync)
  );

  //// No DRP yet
  //assign up_rdata = 16'h0;
  //assign up_ready = 1'b1;

endmodule
