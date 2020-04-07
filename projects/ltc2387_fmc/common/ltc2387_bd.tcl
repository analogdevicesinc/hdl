
# ltc2387

create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir I cnv_p
create_bd_port -dir I cnv_n
create_bd_port -dir I adc_da_in_p
create_bd_port -dir I adc_da_in_n
create_bd_port -dir I adc_db_in_p
create_bd_port -dir I adc_db_in_n
#create_bd_port -dir I osc_clk
#create_bd_port -dir O out_clk


# adc peripheral

ad_ip_instance axi_ltc2387 axi_ltc2387

# dma

ad_ip_instance axi_dmac axi_ltc2387_dma
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_DEST 128

# connections (ltc2387)

ad_connect    dco_p            axi_ltc2387/dco_p
ad_connect    dco_n            axi_ltc2387/dco_n
ad_connect    cnv_p            axi_ltc2387/cnv_p
ad_connect    cnv_n            axi_ltc2387/cnv_n
ad_connect    adc_da_in_n      axi_ltc2387/adc_da_in_n
ad_connect    adc_da_in_p      axi_ltc2387/adc_da_in_p
ad_connect    adc_db_in_n      axi_ltc2387/adc_db_in_n
ad_connect    adc_db_in_p      axi_ltc2387/adc_db_in_p
#ad_connect    osc_clk          axi_ltc2387/osc_clk
#ad_connect    out_clk          axi_ltc2387/out_clk

ad_connect ltc2387_clk axi_ltc2387/adc_clk

ad_connect ltc2387_clk         axi_ltc2387_dma/fifo_wr_clk
ad_connect $sys_iodelay_clk    axi_ltc2387/delay_clk

ad_connect axi_ltc2387/adc_valid  axi_ltc2387_dma/fifo_wr_en
ad_connect axi_ltc2387/adc_data   axi_ltc2387_dma/fifo_wr_din
ad_connect axi_ltc2387/adc_dovf   axi_ltc2387_dma/fifo_wr_overflow

# address mapping

ad_cpu_interconnect 0x44A00000 axi_ltc2387
ad_cpu_interconnect 0x44A30000 axi_ltc2387_dma

# interconnect (adc)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_ltc2387_dma/m_dest_axi
ad_connect  $sys_dma_resetn axi_ltc2387_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ltc2387_dma/irq
