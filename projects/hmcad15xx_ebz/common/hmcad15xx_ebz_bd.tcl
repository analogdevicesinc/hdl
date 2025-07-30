###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# hmcad15xx interface

create_bd_port -dir I clk_in_p
create_bd_port -dir I clk_in_n
create_bd_port -dir I fclk_p
create_bd_port -dir I fclk_n
create_bd_port -dir I -from 7 -to 0 data_in_p
create_bd_port -dir I -from 7 -to 0 data_in_n

# instances

ad_ip_instance axi_dmac hmcad15xx_dma
ad_ip_parameter hmcad15xx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter hmcad15xx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter hmcad15xx_dma CONFIG.CYCLIC 0
ad_ip_parameter hmcad15xx_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter hmcad15xx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter hmcad15xx_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter hmcad15xx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter hmcad15xx_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter hmcad15xx_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter hmcad15xx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter hmcad15xx_dma CONFIG.MAX_BYTES_PER_BURST 4096

# axi_hmcad15xx

ad_ip_instance axi_hmcad15xx axi_hmcad15xx_adc
ad_ip_parameter axi_hmcad15xx_adc CONFIG.NUM_CHANNELS 4

ad_connect axi_hmcad15xx_adc/s_axi_aclk    sys_cpu_clk
ad_connect axi_hmcad15xx_adc/clk_in_p      clk_in_p
ad_connect axi_hmcad15xx_adc/clk_in_n      clk_in_n
ad_connect axi_hmcad15xx_adc/fclk_p        fclk_p
ad_connect axi_hmcad15xx_adc/fclk_n        fclk_n
ad_connect axi_hmcad15xx_adc/data_in_p     data_in_p
ad_connect axi_hmcad15xx_adc/data_in_n     data_in_n
ad_connect axi_hmcad15xx_adc/delay_clk     $sys_iodelay_clk

ad_connect axi_hmcad15xx_adc/adc_clk   hmcad15xx_dma/fifo_wr_clk
ad_connect axi_hmcad15xx_adc/adc_data  hmcad15xx_dma/fifo_wr_din
ad_connect axi_hmcad15xx_adc/adc_valid hmcad15xx_dma/fifo_wr_en
ad_connect axi_hmcad15xx_adc/adc_dovf  hmcad15xx_dma/fifo_wr_overflow

ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 150.0
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST2_PORT 1

ad_ip_instance proc_sys_reset sys_150m_rstgen
ad_ip_parameter sys_150m_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_connect  sys_ps7/FCLK_CLK2 sys_150m_rstgen/slowest_sync_clk
ad_connect  sys_150m_rstgen/ext_reset_in sys_ps7/FCLK_RESET2_N

#DMA

ad_connect  hmcad15xx_dma/m_dest_axi_aresetn     sys_150m_rstgen/peripheral_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-12  hmcad15xx_dma/irq


# cpu / memory interconnects
ad_cpu_interconnect 0x44A00000 axi_hmcad15xx_adc
ad_cpu_interconnect 0x44A30000 hmcad15xx_dma


ad_mem_hp1_interconnect sys_ps7/FCLK_CLK2 sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_ps7/FCLK_CLK2 hmcad15xx_dma/m_dest_axi
