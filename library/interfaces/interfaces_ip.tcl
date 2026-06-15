###############################################################################
## Copyright (C) 2015-2023, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_if_define if_xcvr_cm
adi_if_ports output    1  enb
adi_if_ports output   12  addr
adi_if_ports output    1  wr
adi_if_ports output   16  wdata
adi_if_ports input    16  rdata
adi_if_ports input     1  ready

adi_if_define if_xcvr_ch
adi_if_ports input     1  pll_locked
adi_if_ports output    1  rst
adi_if_ports output    1  user_ready
adi_if_ports input     1  rst_done
adi_if_ports output    4  prbssel
adi_if_ports output    1  prbsforceerr
adi_if_ports output    1  prbscntreset
adi_if_ports input     1  prbserr
adi_if_ports input     1  prbslocked
adi_if_ports output    1  lpm_dfe_n
adi_if_ports output    3  rate
adi_if_ports output    2  sys_clk_sel
adi_if_ports output    3  out_clk_sel
adi_if_ports output    4  tx_diffctrl
adi_if_ports output    5  tx_postcursor
adi_if_ports output    5  tx_precursor
adi_if_ports output    1  enb
adi_if_ports output   12  addr
adi_if_ports output    1  wr
adi_if_ports output   16  wdata
adi_if_ports input    16  rdata
adi_if_ports input     1  ready
adi_if_ports output    2  bufstatus
adi_if_ports output    1  bufstatus_rst

adi_if_define if_gt_qpll
adi_if_ports output    1  qpll_rst            reset
adi_if_ports output    1  qpll_ref_clk        clock

adi_if_define if_gt_pll
adi_if_ports output    1  cpll_rst_m          reset
adi_if_ports output    1  cpll_ref_clk_in     clock

adi_if_define if_gt_rx
adi_if_ports  output   1  rx_p
adi_if_ports  output   1  rx_n
adi_if_ports  input    1  rx_rst              reset
adi_if_ports  output   1  rx_rst_m            reset
adi_if_ports  input    1  rx_pll_rst          reset
adi_if_ports  input    1  rx_gt_rst           reset
adi_if_ports  output   1  rx_gt_rst_m         reset
adi_if_ports  input    1  rx_pll_locked
adi_if_ports  output   1  rx_pll_locked_m
adi_if_ports  input    1  rx_user_ready
adi_if_ports  output   1  rx_user_ready_m
adi_if_ports  input    1  rx_rst_done
adi_if_ports  output   1  rx_rst_done_m
adi_if_ports  input    1  rx_out_clk          clock
adi_if_ports  output   1  rx_clk              clock
adi_if_ports  output   1  rx_sysref
adi_if_ports  input    1  rx_sync
adi_if_ports  input    1  rx_sof
adi_if_ports  input   32  rx_data
adi_if_ports  input    1  rx_ip_rst           reset
adi_if_ports  output   4  rx_ip_sof
adi_if_ports  output  32  rx_ip_data
adi_if_ports  input    1  rx_ip_sysref
adi_if_ports  output   1  rx_ip_sync
adi_if_ports  input    1  rx_ip_rst_done

adi_if_define if_gt_tx
adi_if_ports  input    1  tx_p
adi_if_ports  input    1  tx_n
adi_if_ports  input    1  tx_rst              reset
adi_if_ports  output   1  tx_rst_m            reset
adi_if_ports  input    1  tx_pll_rst          reset
adi_if_ports  input    1  tx_gt_rst           reset
adi_if_ports  output   1  tx_gt_rst_m         reset
adi_if_ports  input    1  tx_pll_locked
adi_if_ports  output   1  tx_pll_locked_m
adi_if_ports  input    1  tx_user_ready
adi_if_ports  output   1  tx_user_ready_m
adi_if_ports  input    1  tx_rst_done
adi_if_ports  output   1  tx_rst_done_m
adi_if_ports  input    1  tx_out_clk          clock
adi_if_ports  output   1  tx_clk              clock
adi_if_ports  output   1  tx_sysref
adi_if_ports  output   1  tx_sync
adi_if_ports  output  32  tx_data
adi_if_ports  input    1  tx_ip_rst           reset
adi_if_ports  input   32  tx_ip_data
adi_if_ports  input    1  tx_ip_sysref
adi_if_ports  input    1  tx_ip_sync
adi_if_ports  input    1  tx_ip_rst_done

adi_if_define if_gt_rx_ksig
adi_if_ports  output   4  rx_gt_ilas_f
adi_if_ports  output   4  rx_gt_ilas_q
adi_if_ports  output   4  rx_gt_ilas_a
adi_if_ports  output   4  rx_gt_ilas_r
adi_if_ports  output   4  rx_gt_cgs_k

adi_if_define if_do_ctrl
adi_if_ports  output   1  request_enable
adi_if_ports  output   1  request_valid
adi_if_ports  input    1  request_ready
adi_if_ports  output  -1  request_length
adi_if_ports  output  -1  response_measured_length
adi_if_ports  input    1  response_eot
adi_if_ports  input    1  status_underflow
adi_if_ports  input    1  status_overflow
