create_bd_port -dir O dac_sclk
create_bd_port -dir O dac_csn
create_bd_port -dir O dac_sdo0
create_bd_port -dir O dac_sdo1
create_bd_port -dir O dac_sdo2
create_bd_port -dir O dac_sdo3

create_bd_port -dir O -from 3 -to 0 rx_or_tx_n

create_bd_port -dir I dac_sdi0
create_bd_port -dir I dac_sdi1
create_bd_port -dir I dac_sdi2
create_bd_port -dir I dac_sdi3

ad_ip_instance axi_dmac axi_dac_dma
ad_ip_parameter axi_dac_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_dac_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_dac_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_dac_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_dac_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_DATA_WIDTH_SRC 32 
ad_ip_parameter axi_dac_dma CONFIG.DMA_DATA_WIDTH_DEST 32

ad_ip_instance axi_ad3552r axi_ad3552r_dac
 
ad_connect axi_ad3552r_dac/dac_sclk       dac_sclk
ad_connect axi_ad3552r_dac/dac_csn        dac_csn
ad_connect axi_ad3552r_dac/dac_sdo_0      dac_sdo0
ad_connect axi_ad3552r_dac/dac_sdo_1      dac_sdo1
ad_connect axi_ad3552r_dac/dac_sdo_2      dac_sdo2
ad_connect axi_ad3552r_dac/dac_sdo_3      dac_sdo3 
ad_connect axi_ad3552r_dac/dac_sdi_0      dac_sdi0
ad_connect axi_ad3552r_dac/dac_sdi_1      dac_sdi1
ad_connect axi_ad3552r_dac/dac_sdi_2      dac_sdi2
ad_connect axi_ad3552r_dac/dac_sdi_3      dac_sdi3 
ad_connect axi_ad3552r_dac/rx_or_tx_n     rx_or_tx_n
ad_connect axi_ad3552r_dac/dac_clk        sys_ps7/FCLK_CLK2
ad_connect axi_ad3552r_dac/dma_data       axi_dac_dma/m_axis_data
ad_connect axi_ad3552r_dac/valid_in_dma   axi_dac_dma/m_axis_valid
ad_connect axi_ad3552r_dac/dac_data_ready axi_dac_dma/m_axis_ready

ad_cpu_interconnect 0x44a30000 axi_dac_dma
ad_cpu_interconnect 0x44a70000 axi_ad3552r_dac

ad_cpu_interrupt "ps-13" "mb-13" axi_dac_dma/irq

ad_mem_hp0_interconnect sys_cpu_clk axi_dac_dma/m_src_axi
ad_connect sys_ps7/FCLK_CLK2 axi_dac_dma/m_axis_aclk