###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad4080 interface

create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir I da_p
create_bd_port -dir I da_n
create_bd_port -dir I db_p
create_bd_port -dir I db_n
create_bd_port -dir I sync_n
create_bd_port -dir I cnv_in_p
create_bd_port -dir I cnv_in_n
create_bd_port -dir I filter_data_ready_n
create_bd_port -dir O sys_cpu_out_clk

# axi_ad408x

ad_ip_instance axi_ad408x axi_ad4080_adc
ad_ip_parameter axi_ad4080_adc CONFIG.NUM_OF_CHANNELS 1
ad_ip_parameter axi_ad4080_adc CONFIG.HAS_DELAY_CTRL 1
ad_ip_parameter axi_ad4080_adc CONFIG.DELAY_CTRL_NUM_LANES 2

# dma for rx1

ad_ip_instance axi_dmac axi_ad4080_dma
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad4080_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad4080_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad4080_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad4080_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# connect interface to axi_ad4080_adc

ad_connect dco_p                axi_ad4080_adc/dclk_in_p
ad_connect dco_n                axi_ad4080_adc/dclk_in_n
ad_connect da_p                 axi_ad4080_adc/data_a_in_p
ad_connect da_n                 axi_ad4080_adc/data_a_in_n
ad_connect db_p                 axi_ad4080_adc/data_b_in_p
ad_connect db_n                 axi_ad4080_adc/data_b_in_n
ad_connect sync_n               axi_ad4080_adc/sync_n
ad_connect cnv_in_p             axi_ad4080_adc/cnv_in_p
ad_connect cnv_in_n             axi_ad4080_adc/cnv_in_n
ad_connect filter_data_ready_n  axi_ad4080_adc/filter_data_ready_n
ad_connect $sys_iodelay_clk     axi_ad4080_adc/delay_clk

# connect datapath

ad_connect axi_ad4080_adc/adc_data  axi_ad4080_dma/fifo_wr_din
ad_connect axi_ad4080_adc/adc_valid axi_ad4080_dma/fifo_wr_en
ad_connect axi_ad4080_adc/adc_dovf  axi_ad4080_dma/fifo_wr_overflow
# system runs on phy's received clock

ad_connect axi_ad4080_adc/adc_clk axi_ad4080_dma/fifo_wr_clk
ad_connect $sys_cpu_clk sys_cpu_out_clk

ad_connect $sys_cpu_resetn axi_ad4080_dma/m_dest_axi_aresetn

ad_cpu_interconnect 0x44A00000 axi_ad4080_adc
ad_cpu_interconnect 0x44A30000 axi_ad4080_dma

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad4080_dma/m_dest_axi

ad_cpu_interrupt ps-13 mb-12 axi_ad4080_dma/irq
