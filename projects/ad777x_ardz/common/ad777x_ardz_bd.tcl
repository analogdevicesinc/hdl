###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad777x interface

create_bd_port -dir I adc_clk_in
create_bd_port -dir O sync_adc_mosi
create_bd_port -dir I sync_adc_miso
create_bd_port -dir I adc_ready
create_bd_port -dir I -from 3 -to 0 adc_data_in

# adc(ad777x-dma)

ad_ip_instance axi_dmac ad777x_dma
ad_ip_parameter ad777x_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad777x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad777x_dma CONFIG.CYCLIC 0
ad_ip_parameter ad777x_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad777x_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad777x_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad777x_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad777x_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter ad777x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_resetn ad777x_dma/m_dest_axi_aresetn

# ps7-hp1

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 1

# axi_ad777x

ad_ip_instance axi_ad777x axi_ad777x_adc

ad_connect adc_data_in axi_ad777x_adc/data_in
ad_connect  adc_clk_in axi_ad777x_adc/clk_in
ad_connect adc_ready   axi_ad777x_adc/ready_in
ad_connect sync_adc_mosi   axi_ad777x_adc/sync_adc_mosi
ad_connect sync_adc_miso  axi_ad777x_adc/sync_adc_miso
ad_connect  axi_ad777x_adc/adc_clk ad777x_dma/fifo_wr_clk

# adc-path channel pack

ad_ip_instance util_cpack2 ad777x_adc_pack
ad_ip_parameter ad777x_adc_pack CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter ad777x_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

ad_connect axi_ad777x_adc/adc_clk ad777x_adc_pack/clk
ad_connect axi_ad777x_adc/adc_reset ad777x_adc_pack/reset
ad_connect axi_ad777x_adc/adc_valid ad777x_adc_pack/fifo_wr_en
ad_connect  ad777x_adc_pack/packed_fifo_wr ad777x_dma/fifo_wr
ad_connect  ad777x_adc_pack/fifo_wr_overflow axi_ad777x_adc/adc_dovf

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad777x_adc/adc_data_$i ad777x_adc_pack/fifo_wr_data_$i
  ad_connect axi_ad777x_adc/adc_enable_$i ad777x_adc_pack/enable_$i
}

# interrupts

ad_cpu_interrupt ps-10 mb-10  ad777x_dma/irq

# cpu / memory interconnects

ad_cpu_interconnect 0x43c00000 axi_ad777x_adc 
ad_cpu_interconnect 0x7c480000 ad777x_dma

ad_mem_hp1_interconnect sys_cpu_clk    sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk    ad777x_dma/m_dest_axi
