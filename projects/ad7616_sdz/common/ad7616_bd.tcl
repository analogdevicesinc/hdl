
global ad7616_if

# data interfaces

create_bd_port -dir O rx_sclk
create_bd_port -dir O rx_sdo
create_bd_port -dir I rx_sdi_0
create_bd_port -dir I rx_sdi_1

create_bd_port -dir O -from 15 -to 0 rx_db_o
create_bd_port -dir I -from 15 -to 0 rx_db_i
create_bd_port -dir O rx_db_t
create_bd_port -dir O rx_rd_n
create_bd_port -dir O rx_wr_n

# control lines

create_bd_port -dir O rx_cnvst
create_bd_port -dir O rx_cs_n
create_bd_port -dir I rx_busy

# instantiation

ad_ip_instance axi_ad7616 axi_ad7616
ad_ip_parameter axi_ad7616 CONFIG.IF_TYPE $ad7616_if

ad_ip_instance axi_dmac axi_ad7616_dma
ad_ip_parameter axi_ad7616_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad7616_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7616_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7616_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7616_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ad7616_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# interface connections
if {$ad7616_if == 0} {

  ad_connect  rx_sclk axi_ad7616/rx_sclk
  ad_connect  rx_sdo axi_ad7616/rx_sdo
  ad_connect  rx_sdi_0 axi_ad7616/rx_sdi_0
  ad_connect  rx_sdi_1 axi_ad7616/rx_sdi_1
  ad_connect  rx_cs_n axi_ad7616/rx_cs_n

  ad_connect  rx_cnvst axi_ad7616/rx_cnvst
  ad_connect  rx_busy axi_ad7616/rx_busy

} else {

  ad_connect  rx_db_o axi_ad7616/rx_db_o
  ad_connect  rx_db_i axi_ad7616/rx_db_i
  ad_connect  rx_db_t axi_ad7616/rx_db_t
  ad_connect  rx_rd_n axi_ad7616/rx_rd_n
  ad_connect  rx_wr_n axi_ad7616/rx_wr_n

  ad_connect  rx_cs_n axi_ad7616/rx_cs_n
  ad_connect  rx_cnvst axi_ad7616/rx_cnvst
  ad_connect  rx_busy axi_ad7616/rx_busy

}

ad_connect  sys_cpu_clk axi_ad7616_dma/s_axi_aclk
ad_connect  sys_cpu_clk axi_ad7616_dma/fifo_wr_clk
ad_connect  axi_ad7616/adc_valid axi_ad7616_dma/fifo_wr_en
ad_connect  axi_ad7616/adc_data axi_ad7616_dma/fifo_wr_din
ad_connect  axi_ad7616/adc_sync axi_ad7616_dma/fifo_wr_sync

# interconnect

ad_cpu_interconnect  0x44A00000 axi_ad7616
ad_cpu_interconnect  0x44A30000 axi_ad7616_dma

# memory interconnect

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad7616_dma/m_dest_axi
ad_connect sys_cpu_resetn axi_ad7616_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad7616_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_ad7616/irq

