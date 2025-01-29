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
ad_ip_parameter hmcad15xx_dma CONFIG.DMA_DATA_WIDTH_SRC 32



# parallel path channel pack

ad_ip_instance util_cpack2 util_hmcad15xx_adc_pack
ad_ip_parameter util_hmcad15xx_adc_pack CONFIG.NUM_OF_CHANNELS 4
ad_ip_parameter util_hmcad15xx_adc_pack CONFIG.SAMPLE_DATA_WIDTH 8

# axi_hmcad15xx

ad_ip_instance axi_hmcad15xx axi_hmcad15xx_adc
ad_ip_parameter axi_hmcad15xx_adc CONFIG.NUM_CHANNELS 4

for {set i 0} {$i < 4} {incr i} {
  ad_connect axi_hmcad15xx_adc/adc_enable_$i  util_hmcad15xx_adc_pack/enable_$i
  ad_connect axi_hmcad15xx_adc/adc_data_$i    util_hmcad15xx_adc_pack/fifo_wr_data_$i
}

ad_connect axi_hmcad15xx_adc/s_axi_aclk    sys_ps7/FCLK_CLK0
ad_connect axi_hmcad15xx_adc/clk_in_p      clk_in_p
ad_connect axi_hmcad15xx_adc/clk_in_n      clk_in_n
ad_connect axi_hmcad15xx_adc/fclk_p        fclk_p
ad_connect axi_hmcad15xx_adc/fclk_n        fclk_n
ad_connect axi_hmcad15xx_adc/data_in_p     data_in_p
ad_connect axi_hmcad15xx_adc/data_in_n     data_in_n

ad_connect axi_hmcad15xx_adc/adc_valid     util_hmcad15xx_adc_pack/fifo_wr_en
ad_connect axi_hmcad15xx_adc/adc_clk       util_hmcad15xx_adc_pack/clk
ad_connect axi_hmcad15xx_adc/adc_reset     util_hmcad15xx_adc_pack/reset
ad_connect axi_hmcad15xx_adc/adc_dovf      util_hmcad15xx_adc_pack/fifo_wr_overflow

#serial DMA

ad_connect  hmcad15xx_dma/m_dest_axi_aresetn     sys_cpu_resetn
ad_connect  hmcad15xx_dma/fifo_wr_clk            axi_hmcad15xx_adc/adc_clk
ad_connect  hmcad15xx_dma/fifo_wr                util_hmcad15xx_adc_pack/packed_fifo_wr
ad_connect  hmcad15xx_dma/sync                    util_hmcad15xx_adc_pack/packed_sync

# interrupts

ad_cpu_interrupt ps-13 mb-13  hmcad15xx_dma/irq


# cpu / memory interconnects

ad_cpu_interconnect 0x7C400000 hmcad15xx_dma
ad_cpu_interconnect 0x43c00000 axi_hmcad15xx_adc

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk hmcad15xx_dma/m_dest_axi

