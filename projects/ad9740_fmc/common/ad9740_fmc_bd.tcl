###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set DAC_RESOLUTION $ad_project_params(DAC_RESOLUTION)

# bd ports

create_bd_port -dir I ad9740_clk
create_bd_port -dir O -from 27 -to 0 ad9740_data

# dma

ad_ip_instance axi_dmac ad9740_dma
ad_ip_parameter ad9740_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad9740_dma CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter ad9740_dma CONFIG.CYCLIC 1
ad_ip_parameter ad9740_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter ad9740_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad9740_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter ad9740_dma CONFIG.DMA_DATA_WIDTH_DEST 32

# ad9740

ad_ip_instance axi_ad9740 ad9740_dac
ad_ip_parameter ad9740_dac CONFIG.DAC_RESOLUTION $DAC_RESOLUTION
ad_ip_parameter ad9740_dac CONFIG.CLK_RATIO 2
ad_ip_parameter ad9740_dac CONFIG.DDS_CORDIC_DW 18
ad_ip_parameter ad9740_dac CONFIG.DDS_CORDIC_PHASE_DW 18

# clocks

ad_connect ad9740_clk ad9740_dac/dac_clk

# resets

ad_connect sys_rstgen/peripheral_aresetn ad9740_dma/m_src_axi_aresetn

# data path

ad_connect ad9740_dma/fifo_rd_dout ad9740_dac/dma_data
ad_connect ad9740_dma/fifo_rd_valid ad9740_dac/dma_valid
ad_connect ad9740_clk ad9740_dma/fifo_rd_clk
ad_connect ad9740_dac/dma_ready ad9740_dma/fifo_rd_en

ad_connect ad9740_dac/dac_data ad9740_data

# AXI address definitions

ad_cpu_interconnect 0x44a40000 ad9740_dma
ad_cpu_interconnect 0x44a70000 ad9740_dac

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" ad9740_dma/irq

# memory interconnects

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk ad9740_dma/m_src_axi
