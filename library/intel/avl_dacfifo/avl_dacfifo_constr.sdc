###############################################################################
## Copyright (C) 2017-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# CDC paths

set_false_path  -from [get_registers *avl_dacfifo_rd:i_rd|dac_mem_raddr_g*] \
                -to   [get_registers *avl_dacfifo_rd:i_rd|avl_mem_raddr_m1*]
set_false_path  -from [get_registers *avl_dacfifo_rd:i_rd|avl_mem_waddr_g*] \
                -to   [get_registers *avl_dacfifo_rd:i_rd|dac_mem_waddr_m1*]
set_false_path  -from [get_registers *avl_dacfifo_rd:i_rd|avl_xfer_req_out*] \
                -to   [get_registers *avl_dacfifo_rd:i_rd|dac_avl_xfer_req_m1*]
set_false_path  -from [get_registers *avl_dacfifo_rd:i_rd|avl_mem_laddr_toggle*] \
                -to   [get_registers *avl_dacfifo_rd:i_rd|dac_mem_laddr_toggle_m[0]]
set_false_path  -to   [get_registers *avl_dacfifo_rd:i_rd|dac_mem_laddr*]
set_false_path  -to   [get_registers *avl_dacfifo_rd:i_rd|dac_dma_last_beats_m1*]

set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|avl_xfer_req_lp*] \
                -to   [get_registers *avl_dacfifo_wr:i_wr|dma_xfer_req_lp_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|avl_xfer_req_out*] \
                -to   [get_registers *avl_dacfifo_wr:i_wr|dma_avl_xfer_req_out_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|avl_mem_raddr_g*] \
                -to   [get_registers *avl_dacfifo_wr:i_wr|dma_mem_raddr_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|dma_xfer_req*] \
                -to   [get_registers *avl_dacfifo_wr:i_wr|avl_dma_xfer_req_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|dma_mem_waddr_g*] \
                -to   [get_registers *avl_dacfifo_wr:i_wr|avl_mem_waddr_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|dma_last_beats*] \
                -to   [get_registers *avl_dacfifo_wr:i_wr|avl_dma_last_beats_m1*]

set_false_path  -from [get_registers *util_dacfifo_bypass:i_dacfifo_bypass|dac_mem_raddr_g*] \
                -to   [get_registers *util_dacfifo_bypass:i_dacfifo_bypass|dma_mem_raddr_m1*]

set_false_path  -from [get_registers *util_dacfifo_bypass:i_dacfifo_bypass|dma_mem_waddr_g*] \
                -to   [get_registers *util_dacfifo_bypass:i_dacfifo_bypass|dac_mem_waddr_m1*]
set_false_path  -to   [get_registers *util_dacfifo_bypass:i_dacfifo_bypass|dac_xfer_out_m1*]

set_false_path  -to [get_registers *avl_dacfifo:*avl_dma_xfer_req_m1*]
set_false_path  -to [get_registers *avl_dacfifo:*dac_xfer_out_m1*]
set_false_path  -to [get_registers *avl_dacfifo:*bypass_m1*]

set_false_path  -to [get_registers *util_dacfifo_bypass:i_dacfifo_bypass|dma_rst_m1*]

