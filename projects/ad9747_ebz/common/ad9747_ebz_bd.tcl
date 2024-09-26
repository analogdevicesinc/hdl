###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Default dual-port mode (ONEPORT = 0), each DAC receives data from its dedicated input port
# In single-port mode (ONEPORT = 1), both DACs receive data from Port 1

set ONPEPORT $ad_project_params(ONPEPORT)
puts "build parameter: ONPEPORT: $ONPEPORT"

# dac interface

create_bd_port -dir I dco
create_bd_port -dir O -from 15 -to 0 data_p1
create_bd_port -dir O -from 15 -to 0 data_p2

# dac peripherals

ad_ip_instance axi_ad9747 axi_ad9747
ad_ip_parameter axi_ad9747_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9747_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9747_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9747_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9747_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9747_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9747_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9747_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9747_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9747_dma CONFIG.DMA_AXI_PROTOCOL_SRC 1

ad_ip_instance util_upack2 util_ad9747_dac_upack { \
  NUM_OF_CHANNELS 2 \
  SAMPLES_PER_CHANNEL 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# connections (dac)
ad_connect  dco          axi_ad9747/dac_clk_in
ad_connect  data_p1      axi_ad9747/data_p1
ad_connect  data_p2      axi_ad9747/data_p2

ad_connect  axi_ad9747/dac_valid                        util_ad9747_dac_upack/fifo_rd_en
ad_connect  axi_ad9747/dac_div_clk                      util_ad9747_dac_upack/clk
ad_connect  axi_ad9747/dac_div_clk                      axi_ad9747_dma/m_axis_aclk
ad_connect  axi_ad9747/dac_rst                          util_ad9747_dac_upack/reset
ad_connect  axi_ad9747/dac_enable_0                     util_ad9747_dac_upack/enable_0
ad_connect  axi_ad9747/dac_enable_1                     util_ad9747_dac_upack/enable_1
   
ad_connect  axi_ad9747_dma/m_axis                       util_ad9747_dac_upack/s_axis

ad_connect  util_ad9747_dac_upack/fifo_rd_data_0        axi_ad9747/dac_ddata_0
ad_connect  util_ad9747_dac_upack/fifo_rd_data_1        axi_ad9747/dac_ddata_1
ad_connect  util_ad9747_dac_upack/fifo_rd_underflow     axi_ad9747/dac_dunf

# interconnect (cpu)

ad_cpu_interconnect 0x74200000 axi_ad9747
ad_cpu_interconnect 0x7c420000 axi_ad9747_dma

# interconnect (mem/dac)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_ad9747_dma/m_src_axi
ad_connect  $sys_dma_resetn axi_ad9747_dma/m_src_axi_aresetn

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad9747_dma/irq