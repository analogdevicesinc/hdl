###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# bd ports

create_bd_port -dir I ad974x_clk
create_bd_port -dir O -from 13 -to 0 ad974x_data

# dma

ad_ip_instance axi_dmac ad974x_dma
ad_ip_parameter ad974x_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad974x_dma CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter ad974x_dma CONFIG.CYCLIC 1
ad_ip_parameter ad974x_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter ad974x_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad974x_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter ad974x_dma CONFIG.DMA_DATA_WIDTH_DEST 16

# ad974x

ad_ip_instance axi_ad974x ad974x_dac

# clocks

ad_connect ad974x_clk ad974x_dac/dac_clk

# resets

ad_connect sys_rstgen/peripheral_aresetn ad974x_dma/m_src_axi_aresetn

# data path

connect_bd_net [get_bd_pins ad974x_dma/fifo_rd_dout] [get_bd_pins ad974x_dac/dma_data]
connect_bd_net [get_bd_pins ad974x_dma/fifo_rd_valid] [get_bd_pins ad974x_dac/dma_valid]

connect_bd_net [get_bd_ports ad974x_clk] [get_bd_pins ad974x_dma/fifo_rd_clk]

connect_bd_net [get_bd_pins ad974x_dma/fifo_rd_en] [get_bd_pins ad974x_dac/dma_ready]

ad_connect ad974x_dac/dac_data ad974x_data

# AXI address definitions

ad_cpu_interconnect 0x44a40000 ad974x_dma
ad_cpu_interconnect 0x44a70000 ad974x_dac

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" ad974x_dma/irq

# memory interconnects

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk ad974x_dma/m_src_axi
