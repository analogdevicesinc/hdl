###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG TRUE \
  [get_cells -hier *dma_mem_*_m*] \
  [get_cells -hier *axi_xfer_*_m*] \
  [get_cells -hier *axi_mem_*_m*] \
  [get_cells -hier *axi_dma_*_m*] \
  [get_cells -hier *dac_mem_*_m*] \
  [get_cells -hier *dac_xfer_*_m*] \
  [get_cells -hier *dac_last_*_m*] \
  [get_cells -hier *dac_bypass_m*]

# AXI clk to DMA clk
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_raddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dma_mem_raddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_last_read_toggle* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dma_mem_last_read_toggle_m_* && IS_SEQUENTIAL}]

# DAC clk to DMA clk
set_false_path -from [get_cells  -hier -filter {name =~ */dac_mem_raddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dma_mem_raddr_m1_* && IS_SEQUENTIAL}]
set_false_path -to   [get_cells  -hier -filter {name =~ */dma_rst_m1_reg && IS_SEQUENTIAL}]


# DMA clk to AXI clk
set_false_path -from [get_cells  -hier -filter {name =~ */dma_last_beats* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */axi_dma_last_beats_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */dma_mem_waddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */axi_mem_waddr_m1* && IS_SEQUENTIAL}]
#ignore timing only on the data, the synchronous reset of the FF is connected to the same clock domain
set_false_path -through [get_pins  -hier -filter {name =~ */axi_xfer_req_m_reg[0]/D}]

# DAC clk to AXI clk
set_false_path -from [get_cells  -hier -filter {name =~ */dac_mem_raddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */axi_mem_raddr_m1* && IS_SEQUENTIAL}]

# DMA clk to DAC clk
set_false_path -from [get_cells  -hier -filter {name =~ */dma_mem_waddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_mem_waddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */dma_last_beats* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_last_beats_m* && IS_SEQUENTIAL}]
#ignore timing only on the data, the synchronous reset of the FF is connected to the same clock domain
set_false_path -through [get_pins  -hier -filter {name =~ */dac_xfer_out_m1_reg*/D}]

# AXI clk to DAC clk
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_laddr* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_mem_laddr* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_laddr_toggle* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_mem_laddr_toggle_m* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_waddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_mem_waddr_m1* && IS_SEQUENTIAL}]
#ignore timing only on the data, the synchronous reset of the FF is connected to the same clock domain
set_false_path -through [get_pins  -hier -filter {name =~ */dac_xfer_req_m_reg[0]/D}]

