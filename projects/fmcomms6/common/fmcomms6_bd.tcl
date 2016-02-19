
# adc interface

create_bd_port -dir I adc_clk_in_p
create_bd_port -dir I adc_clk_in_n
create_bd_port -dir I adc_or_in_p
create_bd_port -dir I adc_or_in_n
create_bd_port -dir I -from 15 -to 0 adc_data_in_p
create_bd_port -dir I -from 15 -to 0 adc_data_in_n

# adc peripherals

set axi_ad9652 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9652:1.0 axi_ad9652]

set axi_ad9652_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9652_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9652_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad9652_dma
set_property -dict [list CONFIG.FIFO_SIZE {8}] $axi_ad9652_dma

set axi_ad9652_adc_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 axi_ad9652_adc_fifo]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $axi_ad9652_adc_fifo
set_property -dict [list CONFIG.DIN_ADDRESS_WIDTH {4}] $axi_ad9652_adc_fifo
set_property -dict [list CONFIG.DIN_DATA_WIDTH {16}] $axi_ad9652_adc_fifo
set_property -dict [list CONFIG.DOUT_DATA_WIDTH {32}] $axi_ad9652_adc_fifo

set data_pack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 data_pack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $data_pack

# connections (adc)

ad_connect  adc_clk_in_p  axi_ad9652/adc_clk_in_p
ad_connect  adc_clk_in_n  axi_ad9652/adc_clk_in_n
ad_connect  adc_or_in_p   axi_ad9652/adc_or_in_p
ad_connect  adc_or_in_n   axi_ad9652/adc_or_in_n
ad_connect  adc_data_in_p axi_ad9652/adc_data_in_p
ad_connect  adc_data_in_n axi_ad9652/adc_data_in_n

ad_connect  axi_ad9652/adc_clk axi_ad9652_adc_fifo/din_clk
ad_connect  axi_ad9652/adc_rst axi_ad9652_adc_fifo/din_rst

ad_connect  sys_200m_clk axi_ad9652/delay_clk
ad_connect  sys_200m_clk axi_ad9652_dma/fifo_wr_clk

ad_connect  sys_200m_clk  data_pack/adc_clk
ad_connect  sys_cpu_reset data_pack/adc_rst

ad_connect  axi_ad9652/adc_enable_0 axi_ad9652_adc_fifo/din_enable_0
ad_connect  axi_ad9652/adc_valid_0  axi_ad9652_adc_fifo/din_valid_0
ad_connect  axi_ad9652/adc_data_0   axi_ad9652_adc_fifo/din_data_0
ad_connect  axi_ad9652/adc_enable_1 axi_ad9652_adc_fifo/din_enable_1
ad_connect  axi_ad9652/adc_valid_1  axi_ad9652_adc_fifo/din_valid_1
ad_connect  axi_ad9652/adc_data_1   axi_ad9652_adc_fifo/din_data_1

ad_connect  sys_200m_clk    axi_ad9652_adc_fifo/dout_clk
ad_connect  sys_cpu_resetn  axi_ad9652_adc_fifo/dout_rstn

ad_connect  axi_ad9652_adc_fifo/dout_valid_0   data_pack/adc_valid_0
ad_connect  axi_ad9652_adc_fifo/dout_enable_0  data_pack/adc_enable_0
ad_connect  axi_ad9652_adc_fifo/dout_data_0    data_pack/adc_data_0
ad_connect  axi_ad9652_adc_fifo/dout_valid_1   data_pack/adc_valid_1
ad_connect  axi_ad9652_adc_fifo/dout_enable_1  data_pack/adc_enable_1
ad_connect  axi_ad9652_adc_fifo/dout_data_1    data_pack/adc_data_1

ad_connect  axi_ad9652_adc_fifo/din_ovf    axi_ad9652/adc_dovf

ad_connect  data_pack/adc_valid               axi_ad9652_dma/fifo_wr_en
ad_connect  data_pack/adc_sync                axi_ad9652_dma/fifo_wr_sync
ad_connect  data_pack/adc_data                axi_ad9652_dma/fifo_wr_din
ad_connect  axi_ad9652_adc_fifo/dout_ovf      axi_ad9652_dma/fifo_wr_overflow

# interconnect (cpu)

ad_cpu_interconnect 0x79020000 axi_ad9652
ad_cpu_interconnect 0x7c420000 axi_ad9652_dma

# interconnect (mem/adc)

ad_mem_hp1_interconnect sys_200m_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_200m_clk axi_ad9652_dma/m_dest_axi
ad_connect  sys_cpu_resetn axi_ad9652_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9652_dma/irq

