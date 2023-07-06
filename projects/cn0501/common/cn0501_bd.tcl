###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad7768 interface
create_bd_port -dir I clk_in
create_bd_port -dir I ready_in
create_bd_port -dir I -from 7 -to 0 data_in

# adc(cn0501-dma)

ad_ip_instance axi_dmac cn0501_dma
ad_ip_parameter cn0501_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter cn0501_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter cn0501_dma CONFIG.CYCLIC 0
ad_ip_parameter cn0501_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter cn0501_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter cn0501_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter cn0501_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter cn0501_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter cn0501_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# axi_ad77684

ad_ip_instance axi_ad7768 axi_ad7768_adc
ad_ip_parameter axi_ad7768_adc CONFIG.NUM_CHANNELS 8

# adc-path channel pack

ad_ip_instance util_cpack2 cn0501_adc_pack
ad_ip_parameter cn0501_adc_pack CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter cn0501_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

# connections

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad7768_adc/adc_enable_$i  cn0501_adc_pack/enable_$i
  ad_connect axi_ad7768_adc/adc_data_$i    cn0501_adc_pack/fifo_wr_data_$i
}

ad_connect axi_ad7768_adc/s_axi_aclk          sys_ps7/FCLK_CLK0 
ad_connect axi_ad7768_adc/clk_in              clk_in
ad_connect axi_ad7768_adc/ready_in            ready_in
ad_connect axi_ad7768_adc/data_in             data_in
ad_connect axi_ad7768_adc/adc_valid           cn0501_adc_pack/fifo_wr_en
ad_connect axi_ad7768_adc/adc_clk             cn0501_adc_pack/clk
ad_connect axi_ad7768_adc/adc_reset           cn0501_adc_pack/reset
ad_connect axi_ad7768_adc/adc_dovf            cn0501_adc_pack/fifo_wr_overflow 

ad_connect  cn0501_dma/s_axi_aclk               $sys_cpu_clk
ad_connect  cn0501_dma/m_dest_axi_aresetn       $sys_cpu_resetn   
ad_connect  cn0501_dma/m_dest_axi_aclk          $sys_cpu_clk                 
ad_connect  cn0501_dma/fifo_wr_clk              axi_ad7768_adc/adc_clk                
ad_connect  cn0501_dma/fifo_wr                  cn0501_adc_pack/packed_fifo_wr   

# cpu / memory interconnects

ad_cpu_interconnect 0x44a00000 axi_ad7768_adc 
ad_cpu_interconnect 0x44a30000 cn0501_dma

ad_mem_hp1_interconnect $sys_cpu_clk    sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk    cn0501_dma/m_dest_axi

# interrupts

ad_cpu_interrupt "ps-13" "mb-13"  cn0501_dma/irq
