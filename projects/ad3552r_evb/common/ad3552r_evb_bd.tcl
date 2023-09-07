###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_port -dir O               dac_sclk
create_bd_port -dir O               dac_csn
create_bd_port -dir I -from 3 -to 0 dac_spi_sdi
create_bd_port -dir O -from 3 -to 0 dac_spi_sdo
create_bd_port -dir O               dac_spi_sdo_t

ad_ip_instance axi_dmac axi_dac_dma
ad_ip_parameter axi_dac_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_dac_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_dac_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_dac_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_dac_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_DATA_WIDTH_SRC 32 
ad_ip_parameter axi_dac_dma CONFIG.DMA_DATA_WIDTH_DEST 32

ad_ip_instance axi_ad3552r axi_ad3552r_dac
 
ad_connect axi_ad3552r_dac/dac_sclk       dac_sclk
ad_connect axi_ad3552r_dac/dac_csn        dac_csn
ad_connect axi_ad3552r_dac/sdio_i         dac_spi_sdi
ad_connect axi_ad3552r_dac/sdio_o         dac_spi_sdo
ad_connect axi_ad3552r_dac/sdio_t         dac_spi_sdo_t
ad_connect axi_ad3552r_dac/dma_data       axi_dac_dma/m_axis_data
ad_connect axi_ad3552r_dac/valid_in_dma   axi_dac_dma/m_axis_valid
ad_connect axi_ad3552r_dac/dac_data_ready axi_dac_dma/m_axis_ready
ad_connect sys_rstgen/peripheral_aresetn  axi_dac_dma/m_src_axi_aresetn 

ad_ip_instance  axi_clkgen axi_clkgen
ad_ip_parameter axi_clkgen CONFIG.ID 1
ad_ip_parameter axi_clkgen CONFIG.CLKIN_PERIOD 10
ad_ip_parameter axi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_clkgen CONFIG.VCO_MUL 8
ad_ip_parameter axi_clkgen CONFIG.CLK0_DIV 6


ad_connect axi_clkgen/clk         sys_ps7/FCLK_CLK0 
ad_connect axi_clkgen/clk_0       axi_ad3552r_dac/dac_clk   
ad_connect axi_clkgen/clk_0       axi_dac_dma/m_axis_aclk   

ad_cpu_interconnect 0x44a30000 axi_dac_dma
ad_cpu_interconnect 0x44a70000 axi_ad3552r_dac
ad_cpu_interconnect 0x44B00000 axi_clkgen

ad_cpu_interrupt "ps-13" "mb-13" axi_dac_dma/irq

ad_mem_hp0_interconnect sys_cpu_clk axi_dac_dma/m_src_axi
