###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# dac interface

create_bd_port -dir O dci_p
create_bd_port -dir O dci_n
create_bd_port -dir I dco1_p
create_bd_port -dir I dco1_n
create_bd_port -dir O -from 15 -to 0 data_p
create_bd_port -dir O -from 15 -to 0 data_n

# dac peripherals

ad_ip_instance axi_ad9783 axi_ad9783

ad_ip_instance axi_dmac axi_ad9783_dma
ad_ip_parameter axi_ad9783_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9783_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9783_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9783_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9783_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9783_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9783_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9783_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9783_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9783_dma CONFIG.DMA_AXI_PROTOCOL_SRC 1

# dac-path channel upack

ad_ip_instance util_upack2 util_ad9783_dac_upack { \
  NUM_OF_CHANNELS 2 \
  SAMPLES_PER_CHANNEL 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# connections (dac)

ad_connect  dci_p          axi_ad9783/dac_clk_out_p
ad_connect  dci_n          axi_ad9783/dac_clk_out_n
ad_connect  dco1_p         axi_ad9783/dac_clk_in_p
ad_connect  dco1_n         axi_ad9783/dac_clk_in_n
ad_connect  data_p         axi_ad9783/dac_data_out_p
ad_connect  data_n         axi_ad9783/dac_data_out_n
ad_connect  dac_div_clk    axi_ad9783/dac_div_clk

ad_connect  axi_ad9783/dac_valid                        util_ad9783_dac_upack/fifo_rd_en
ad_connect  axi_ad9783/dac_div_clk                      util_ad9783_dac_upack/clk
ad_connect  axi_ad9783/dac_div_clk                      axi_ad9783_dma/m_axis_aclk
ad_connect  axi_ad9783/dac_rst                          util_ad9783_dac_upack/reset
ad_connect  axi_ad9783/dac_enable_0                     util_ad9783_dac_upack/enable_0
ad_connect  axi_ad9783/dac_enable_1                     util_ad9783_dac_upack/enable_1
   
ad_connect  axi_ad9783_dma/m_axis                       util_ad9783_dac_upack/s_axis

ad_connect  util_ad9783_dac_upack/fifo_rd_data_0        axi_ad9783/dac_ddata_0
ad_connect  util_ad9783_dac_upack/fifo_rd_data_1        axi_ad9783/dac_ddata_1
ad_connect  util_ad9783_dac_upack/fifo_rd_underflow     axi_ad9783/dac_dunf

# interconnect (cpu)

ad_cpu_interconnect 0x74200000 axi_ad9783
ad_cpu_interconnect 0x7c420000 axi_ad9783_dma

# interconnect (mem/dac)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_ad9783_dma/m_src_axi
ad_connect  $sys_dma_resetn axi_ad9783_dma/m_src_axi_aresetn

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad9783_dma/irq
