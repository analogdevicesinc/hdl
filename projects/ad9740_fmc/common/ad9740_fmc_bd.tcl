###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# bd ports

# clkgen

ad_ip_instance axi_clkgen ad9740_clkgen;
ad_ip_parameter ad9740_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter ad9740_clkgen CONFIG.VCO_MUL 7
ad_ip_parameter ad9740_clkgen CONFIG.CLK0_DIV 5

# dma to send sample data

ad_ip_instance axi_dmac ad9740_dma
ad_ip_parameter ad9740_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad9740_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter ad9740_dma CONFIG.CYCLIC 0
ad_ip_parameter ad9740_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter ad9740_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad9740_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter ad9740_dma CONFIG.DMA_DATA_WIDTH_DEST 32

# clocks

ad_connect  $sys_cpu_clk ad9740_clkgen/clk
ad_connect  ad9740_clkgen/clk_0 ad9740_dma/m_axis_aclk

# resets

ad_connect  sys_cpu_resetn ad9740_dma/m_src_axi_aresetn

# data path

# AXI address definitions

ad_cpu_interconnect 0x44a40000 ad9740_dma
ad_cpu_interconnect 0x44b10000 ad9740_clkgen

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" ad9740_dma/irq

# memory interconnects

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk ad9740_dma/m_src_axi
