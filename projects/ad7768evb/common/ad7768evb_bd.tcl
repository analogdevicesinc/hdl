###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad7768 interface

create_bd_port -dir I clk_in
create_bd_port -dir I ready_in
create_bd_port -dir I -from 7 -to 0 data_in

# instances

ad_ip_instance axi_dmac ad7768_dma
ad_ip_parameter ad7768_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad7768_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad7768_dma CONFIG.CYCLIC 0
ad_ip_parameter ad7768_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad7768_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad7768_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad7768_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad7768_dma CONFIG.DMA_DATA_WIDTH_SRC 32

ad_ip_instance axi_dmac ad7768_dma_2
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad7768_dma_2 CONFIG.CYCLIC 0
ad_ip_parameter ad7768_dma_2 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad7768_dma_2 CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad7768_dma_2 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_DATA_WIDTH_SRC 256

# ps7-hp1

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 1

# parallel path channel pack

ad_ip_instance util_cpack2 util_ad7768_adc_pack
ad_ip_parameter util_ad7768_adc_pack CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter util_ad7768_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

# axi_ad7768

ad_ip_instance axi_ad7768 axi_ad7768_adc
ad_ip_parameter axi_ad7768_adc CONFIG.NUM_CHANNELS 8

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad7768_adc/adc_enable_$i  util_ad7768_adc_pack/enable_$i
  ad_connect axi_ad7768_adc/adc_data_$i    util_ad7768_adc_pack/fifo_wr_data_$i
}

ad_connect axi_ad7768_adc/s_axi_aclk          sys_ps7/FCLK_CLK0 
ad_connect axi_ad7768_adc/clk_in              clk_in
ad_connect axi_ad7768_adc/ready_in            ready_in
ad_connect axi_ad7768_adc/data_in             data_in
ad_connect axi_ad7768_adc/adc_valid           util_ad7768_adc_pack/fifo_wr_en
ad_connect axi_ad7768_adc/adc_clk             util_ad7768_adc_pack/clk
ad_connect axi_ad7768_adc/adc_reset           util_ad7768_adc_pack/reset
ad_connect axi_ad7768_adc/adc_dovf            util_ad7768_adc_pack/fifo_wr_overflow 

#serial DMA

ad_connect  ad7768_dma/m_dest_axi_aresetn     sys_cpu_resetn                        
ad_connect  ad7768_dma/fifo_wr_clk            axi_ad7768_adc/adc_clk                
ad_connect  ad7768_dma/fifo_wr_en             axi_ad7768_adc/adc_valid              
ad_connect  ad7768_dma/fifo_wr_din            axi_ad7768_adc/adc_data  
ad_connect  ad7768_dma/fifo_wr_sync           axi_ad7768_adc/adc_sync             

#parallel DMA

ad_connect  ad7768_dma_2/m_dest_axi_aresetn   sys_cpu_resetn                        
ad_connect  ad7768_dma_2/fifo_wr_clk          axi_ad7768_adc/adc_clk                
ad_connect  ad7768_dma_2/fifo_wr              util_ad7768_adc_pack/packed_fifo_wr   

# interrupts

ad_cpu_interrupt ps-13 mb-13  ad7768_dma/irq
ad_cpu_interrupt ps-10 mb-10  ad7768_dma_2/irq

# cpu / memory interconnects

ad_cpu_interconnect 0x7C400000 ad7768_dma
ad_cpu_interconnect 0x7C480000 ad7768_dma_2
ad_cpu_interconnect 0x43c00000 axi_ad7768_adc

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk ad7768_dma/m_dest_axi
ad_mem_hp1_interconnect sys_cpu_clk ad7768_dma_2/m_dest_axi
