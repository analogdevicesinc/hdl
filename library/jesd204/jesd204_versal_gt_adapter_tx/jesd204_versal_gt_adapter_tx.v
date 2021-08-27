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

module  jesd204_versal_gt_adapter_tx (
  output  [127 : 0] txdata,
  output    [5 : 0] txheader,
//  output  [6 : 0] txsequence,
  output            gttxreset,
  output            txprogdivreset,
  output            txuserrdy,
//  output  [1 : 0] txphalignresetmask,
//  output          txcominit,
//  output          txcomsas,
//  output          txcomwake,
//  output          txdapicodeovrden,
//  output          txdapicodereset,
//  output          txdetectrx,
//  output          txlatclk,
//  output          txphdlytstclk,
//  output          txdlyalignreq,
//  output          txelecidle,
//  output          txinhibit,
//  output          txmldchaindone,
//  output          txmldchainreq,
//  output          txoneszeros,
//  output          txpausedelayalign,
//  output          txpcsresetmask,
//  output          txphalignreq,
//  output          txphdlypd,
//  output          txphdlyreset,
//  output          txphsetinitreq,
//  output          txphshift180,
//  output          txpicodeovrden,
//  output          txpicodereset,
//  output          txpippmen,
//  output          txpisopd,
//  output          txpolarity,
//  output          txprbsforceerr,
//  output          txswing,
//  output          txsyncallin,
//  input           tx10gstat,
//  input           txcomfinish,
//  input           txdccdone,
//  input           txdlyalignerr,
//  input           txdlyalignprog,
//  input           txphaligndone,
//  input           txphalignerr,
//  input           txphalignoutrsvd,
//  input           txphdlyresetdone,
//  input           txphsetinitdone,
//  input           txphshift180done,
//  input           txsyncdone,
//  input   [1 : 0] txbufstatus,
//  output [15 : 0] txctrl0,
//  output [15 : 0] txctrl1,
//  output  [1 : 0] txdeemph,
//  output  [1 : 0] txpd,
//  output  [1 : 0] txresetmode,
  output            txmstreset,
//  output          txmstdatapathreset,
//  input           txmstresetdone,
//  output  [2 : 0] txmargin,
//  output  [2 : 0] txpmaresetmask,
//  output  [3 : 0] txprbssel,
//  output  [4 : 0] txdiffctrl,
//  output  [4 : 0] txpippmstepsize,
//  output  [4 : 0] txpostcursor,
//  output  [4 : 0] txprecursor,
//  output  [6 : 0] txmaincursor,
//  output  [7 : 0] txctrl2,
//  output  [7 : 0] txrate,
//  input           txprogdivresetdone,
//  input           txpmaresetdone,
  input             txresetdone,

  // Interface to Link layer core
  input      [63:0] tx_data,
  input       [1:0] tx_header,

  // Other GTY signals
  input             hsclk_lcplllocked,
  input             hsclk_rplllocked,
  input             usr_clk,

  // Control interface
  output          up_pll_locked,
  input           up_rst,
  input           up_user_ready,
  output          up_rst_done,
  input           up_prbsforceerr,
  input   [ 3:0]  up_prbssel,
  input           up_lpm_dfe_n,
  input   [ 2:0]  up_rate,
  input   [ 1:0]  up_sys_clk_sel,
  input   [ 2:0]  up_out_clk_sel,
  input   [ 4:0]  up_diffctrl,
  input   [ 4:0]  up_postcursor,
  input   [ 4:0]  up_precursor,
  input           up_enb,
  input   [11:0]  up_addr,
  input           up_wr,
  input   [15:0]  up_wdata,
  output  [15:0]  up_rdata,
  output          up_ready

);

  assign txdata = {64'b0,tx_data};
  assign txheader = {4'b0,tx_header};

  // Master reset not used
  assign txmstreset = 1'b0;
  assign gttxreset = up_rst;
  assign txprogdivreset = up_rst;

  // Assert txuserrdy only when usr_clk is active
  reg [2:0] usr_rdy = 3'b0;
  always @(posedge usr_clk or negedge up_user_ready) begin
    if (~up_user_ready)
      usr_rdy <= 3'b0;
    else
      usr_rdy <= {1'b1,usr_rdy[2:1]};
  end
  assign txuserrdy = usr_rdy[0];

  assign up_rst_done = txresetdone;
  // TODO : Select locked status correctly
  assign up_pll_locked = hsclk_lcplllocked | hsclk_rplllocked;


  // No DRP yet
  assign up_rdata = 16'h0;
  assign up_ready = 1'b1;

endmodule
