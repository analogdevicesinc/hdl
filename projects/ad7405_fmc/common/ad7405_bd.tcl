
create_bd_port -dir O adc_clk
create_bd_port -dir I adc_data

create_bd_port -dir I -from 15 -to 0 filter_decimation_ratio
create_bd_port -dir I filter_reset

ad_ip_instance util_dec256sinc24b sync3

# ADC's DMA

ad_ip_instance axi_dmac axi_ad7405_dma
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7405_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7405_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad7405_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad7405_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# MCLK generation

ad_ip_instance axi_clkgen axi_adc_clkgen
ad_ip_parameter axi_adc_clkgen CONFIG.VCO_DIV $clkgen_vco_div
ad_ip_parameter axi_adc_clkgen CONFIG.VCO_MUL $clkgen_vco_mul
ad_ip_parameter axi_adc_clkgen CONFIG.CLK0_DIV [expr ($sys_cpu_clk_freq * $clkgen_vco_mul) / ($clkgen_vco_div * $ext_clk_rate)]

ad_connect adc_clk axi_adc_clkgen/clk_0
ad_connect sys_cpu_clk axi_adc_clkgen/clk
ad_connect sync3/clk axi_adc_clkgen/clk_0
ad_connect axi_ad7405_dma/fifo_wr_clk axi_adc_clkgen/clk_0
ad_connect filter_reset sync3/reset

ad_connect adc_data sync3/data_in
ad_connect sync3/data_out axi_ad7405_dma/fifo_wr_din
ad_connect sync3/data_en axi_ad7405_dma/fifo_wr_en
ad_connect filter_decimation_ratio sync3/dec_rate

ad_cpu_interconnect 0x44a30000 axi_ad7405_dma
ad_cpu_interconnect 0x44a40000 axi_adc_clkgen

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad7405_dma/m_dest_axi

ad_cpu_interrupt "ps-13" "mb-13" axi_ad7405_dma/irq

