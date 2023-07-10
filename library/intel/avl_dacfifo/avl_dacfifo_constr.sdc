###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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

