# ad9434 interface

create_bd_port -dir I adc_clk_p
create_bd_port -dir I adc_clk_n
create_bd_port -dir I -from 11 -to 0 adc_data_p
create_bd_port -dir I -from 11 -to 0 adc_data_n
create_bd_port -dir I adc_or_p
create_bd_port -dir I adc_or_n

# ad9434

set axi_ad9434  [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9434:1.0 axi_ad9434]

# dma for ad9434

set axi_ad9434_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9434_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}]  $axi_ad9434_dma

# additions to default configuration

set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7

# ad9434 connections

ad_connect  sys_200m_clk axi_ad9434/delay_clk
ad_connect  axi_ad9434/adc_clk axi_ad9434_dma/fifo_wr_clk

ad_connect  adc_clk_p  axi_ad9434/adc_clk_in_p
ad_connect  adc_clk_n  axi_ad9434/adc_clk_in_n
ad_connect  adc_data_p axi_ad9434/adc_data_in_p
ad_connect  adc_data_n axi_ad9434/adc_data_in_n
ad_connect  adc_or_p   axi_ad9434/adc_or_in_p
ad_connect  adc_or_n   axi_ad9434/adc_or_in_n

ad_connect  axi_ad9434/adc_valid axi_ad9434_dma/fifo_wr_en
ad_connect  axi_ad9434/adc_data  axi_ad9434_dma/fifo_wr_din
ad_connect  axi_ad9434/adc_dovf  axi_ad9434_dma/fifo_wr_overflow

# interconnect

ad_cpu_interconnect 0x44A00000  axi_ad9434
ad_cpu_interconnect 0x44A30000  axi_ad9434_dma

# memory inteconnect

ad_mem_hp1_interconnect sys_200m_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_200m_clk axi_ad9434_dma/m_dest_axi
ad_connect sys_cpu_resetn axi_ad9434_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9434_dma/irq

