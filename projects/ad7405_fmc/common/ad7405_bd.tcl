###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_port -dir O adc_clk
create_bd_port -dir I adc_data

# ADC's DMA

ad_ip_instance axi_dmac axi_ad7405_dma
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7405_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7405_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad7405_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad7405_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# MCLK generation 40 MHz

ad_ip_instance axi_clkgen axi_adc_clkgen
ad_ip_parameter axi_adc_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_adc_clkgen CONFIG.VCO_MUL 10
ad_ip_parameter axi_adc_clkgen CONFIG.CLK0_DIV 25

ad_ip_instance axi_ad7405 axi_ad7405

ad_connect adc_clk axi_adc_clkgen/clk_0
ad_connect sys_cpu_clk axi_adc_clkgen/clk
ad_connect axi_ad7405/clk_in axi_adc_clkgen/clk_0
ad_connect axi_ad7405_dma/fifo_wr_clk axi_adc_clkgen/clk_0

ad_connect adc_data axi_ad7405/adc_data_in
ad_connect axi_ad7405/adc_data_out axi_ad7405_dma/fifo_wr_din
ad_connect axi_ad7405/adc_data_en axi_ad7405_dma/fifo_wr_en

# interconnect

ad_cpu_interconnect 0x44a00000 axi_ad7405
ad_cpu_interconnect 0x44a30000 axi_ad7405_dma
ad_cpu_interconnect 0x44a40000 axi_adc_clkgen

# memory interconnect

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad7405_dma/m_dest_axi

# interrupt

ad_cpu_interrupt "ps-13" "mb-13" axi_ad7405_dma/irq
