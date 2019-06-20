
# ad9265

create_bd_port -dir I adc_clk_in_p
create_bd_port -dir I adc_clk_in_n
create_bd_port -dir I adc_data_or_p
create_bd_port -dir I adc_data_or_n
create_bd_port -dir I -from 7 -to 0 adc_data_in_n
create_bd_port -dir I -from 7 -to 0 adc_data_in_p

# adc peripheral

ad_ip_instance axi_ad9265 axi_ad9265

ad_ip_instance axi_dmac axi_ad9265_dma
ad_ip_parameter axi_ad9265_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9265_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9265_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9265_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9265_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9265_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9265_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9265_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ad9265_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# connections (ad9265)

ad_connect    adc_clk_in_p     axi_ad9265/adc_clk_in_p
ad_connect    adc_clk_in_n     axi_ad9265/adc_clk_in_n
ad_connect    adc_data_in_n    axi_ad9265/adc_data_in_n
ad_connect    adc_data_in_p    axi_ad9265/adc_data_in_p
ad_connect    adc_data_or_p    axi_ad9265/adc_or_in_p
ad_connect    adc_data_or_n    axi_ad9265/adc_or_in_n

ad_connect ad9265_clk axi_ad9265/adc_clk

ad_connect ad9265_clk         axi_ad9265_dma/fifo_wr_clk
ad_connect $sys_iodelay_clk   axi_ad9265/delay_clk

ad_connect axi_ad9265/adc_valid  axi_ad9265_dma/fifo_wr_en
ad_connect axi_ad9265/adc_data   axi_ad9265_dma/fifo_wr_din
ad_connect axi_ad9265/adc_dovf   axi_ad9265_dma/fifo_wr_overflow

# address mapping

ad_cpu_interconnect 0x44A00000 axi_ad9265
ad_cpu_interconnect 0x44A30000 axi_ad9265_dma

# interconnect (adc)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_ad9265_dma/m_dest_axi
ad_connect  $sys_dma_resetn axi_ad9265_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9265_dma/irq
