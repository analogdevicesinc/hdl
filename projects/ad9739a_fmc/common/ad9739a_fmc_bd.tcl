
# dac interface

create_bd_port -dir I dac_clk_in_p
create_bd_port -dir I dac_clk_in_n
create_bd_port -dir O dac_clk_out_p
create_bd_port -dir O dac_clk_out_n
create_bd_port -dir O -from 13 -to 0 dac_data_out_a_p
create_bd_port -dir O -from 13 -to 0 dac_data_out_a_n
create_bd_port -dir O -from 13 -to 0 dac_data_out_b_p
create_bd_port -dir O -from 13 -to 0 dac_data_out_b_n

# dac peripherals

ad_ip_instance axi_ad9739a axi_ad9739a

ad_ip_instance axi_dmac axi_ad9739a_dma
ad_ip_parameter axi_ad9739a_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9739a_dma CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter axi_ad9739a_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9739a_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9739a_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9739a_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9739a_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9739a_dma CONFIG.DMA_DATA_WIDTH_DEST 256
ad_ip_parameter axi_ad9739a_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter axi_ad9739a_dma CONFIG.DMA_AXI_PROTOCOL_SRC 1

# connections (dac)

ad_connect  dac_clk_in_p axi_ad9739a/dac_clk_in_p
ad_connect  dac_clk_in_n axi_ad9739a/dac_clk_in_n
ad_connect  dac_clk_out_p axi_ad9739a/dac_clk_out_p
ad_connect  dac_clk_out_n axi_ad9739a/dac_clk_out_n
ad_connect  dac_data_out_a_p axi_ad9739a/dac_data_out_a_p
ad_connect  dac_data_out_a_n axi_ad9739a/dac_data_out_a_n
ad_connect  dac_data_out_b_p axi_ad9739a/dac_data_out_b_p
ad_connect  dac_data_out_b_n axi_ad9739a/dac_data_out_b_n
ad_connect  dac_div_clk axi_ad9739a/dac_div_clk
ad_connect  dac_div_clk axi_ad9739a_dma/fifo_rd_clk
ad_connect  axi_ad9739a/dac_valid axi_ad9739a_dma/fifo_rd_en
ad_connect  axi_ad9739a/dac_ddata axi_ad9739a_dma/fifo_rd_dout
ad_connect  axi_ad9739a/dac_dunf axi_ad9739a_dma/fifo_rd_underflow

# interconnect (cpu)

ad_cpu_interconnect 0x74200000 axi_ad9739a
ad_cpu_interconnect 0x7c420000 axi_ad9739a_dma

# interconnect (mem/dac)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_ad9739a_dma/m_src_axi
ad_connect  $sys_dma_resetn axi_ad9739a_dma/m_src_axi_aresetn

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad9739a_dma/irq

