###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path -to [get_registers *dac_bypass_m1*]
set_false_path -to [get_registers *dma_bypass_m1*]

set_false_path -from [get_registers *dac_raddr_g*] -to [get_registers *dma_raddr_m1*]
set_false_path -from [get_registers *dma_waddr_g*] -to [get_registers *dac_waddr_m1*]
set_false_path -from [get_registers *dma_lastaddr_g*] -to [get_registers *dac_lastaddr_m1*]
set_false_path -from [get_registers *dma_xfer_out_fifo*] -to [get_registers *dac_xfer_out_fifo_m1*]

set_false_path -from [get_registers *dma_mem_waddr_g*] -to [get_registers *dac_mem_waddr_m1*]
set_false_path -from [get_registers *dac_mem_raddr_g*] -to [get_registers *dma_mem_raddr_m1*]
set_false_path -to [get_registers *dma_rst_m1*]
set_false_path -to [get_registers *dac_xfer_req_m1*]


