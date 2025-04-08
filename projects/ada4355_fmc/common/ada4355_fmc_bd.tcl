###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ada4355 interface

create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir I d0a_p
create_bd_port -dir I d0a_n
create_bd_port -dir I d1a_p
create_bd_port -dir I d1a_n
create_bd_port -dir I sync_n
create_bd_port -dir I frame_p
create_bd_port -dir I frame_n

# axi_ada4355

ad_ip_instance axi_ada4355 axi_ada4355_adc

# dma for rx data

ad_ip_instance axi_dmac axi_ada4355_dma
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ada4355_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ada4355_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ada4355_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ada4355_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# connect interface to axi_ad4355_adc

ad_connect dco_p                axi_ada4355_adc/dco_p
ad_connect dco_n                axi_ada4355_adc/dco_n
ad_connect d0a_p                axi_ada4355_adc/d0a_p
ad_connect d0a_n                axi_ada4355_adc/d0a_n
ad_connect d1a_p                axi_ada4355_adc/d1a_p
ad_connect d1a_n                axi_ada4355_adc/d1a_n
ad_connect sync_n               axi_ada4355_adc/sync_n
ad_connect frame_p              axi_ada4355_adc/fco_p
ad_connect frame_n              axi_ada4355_adc/fco_n
ad_connect $sys_iodelay_clk     axi_ada4355_adc/delay_clk

# connect datapath

ad_connect axi_ada4355_adc/adc_data  axi_ada4355_dma/fifo_wr_din
ad_connect axi_ada4355_adc/adc_valid axi_ada4355_dma/fifo_wr_en
ad_connect axi_ada4355_adc/adc_dovf  axi_ada4355_dma/fifo_wr_overflow

# system runs on if.v's received clock

ad_connect axi_ada4355_adc/adc_clk axi_ada4355_dma/fifo_wr_clk

ad_connect $sys_cpu_resetn axi_ada4355_dma/m_dest_axi_aresetn

ad_cpu_interconnect 0x44A00000 axi_ada4355_adc
ad_cpu_interconnect 0x44A30000 axi_ada4355_dma

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ada4355_dma/m_dest_axi

ad_cpu_interrupt ps-13 mb-12 axi_ada4355_dma/irq
