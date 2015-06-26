
# adc interface

create_bd_port -dir I adc_clk_in_p
create_bd_port -dir I adc_clk_in_n
create_bd_port -dir I adc_or_in_p
create_bd_port -dir I adc_or_in_n
create_bd_port -dir I -from 15 -to 0 adc_data_in_p
create_bd_port -dir I -from 15 -to 0 adc_data_in_n

# dma interface

create_bd_port -dir O adc_clk
create_bd_port -dir O adc_valid_0
create_bd_port -dir O adc_enable_0
create_bd_port -dir O -from 15 -to 0 adc_data_0
create_bd_port -dir O adc_valid_1
create_bd_port -dir O adc_enable_1
create_bd_port -dir O -from 15 -to 0 adc_data_1
create_bd_port -dir I adc_dwr
create_bd_port -dir I -from 31 -to 0 adc_ddata

# adc peripherals

set axi_ad9652 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9652:1.0 axi_ad9652]

set axi_ad9652_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9652_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_FIFO_SIZE {8}] $axi_ad9652_dma

# connections (adc)

p_sys_wfifo [current_bd_instance .] sys_wfifo 32 64

ad_connect  adc_clk_in_p axi_ad9652/adc_clk_in_p
ad_connect  adc_clk_in_n axi_ad9652/adc_clk_in_n
ad_connect  adc_or_in_p axi_ad9652/adc_or_in_p
ad_connect  adc_or_in_n axi_ad9652/adc_or_in_n
ad_connect  adc_data_in_p axi_ad9652/adc_data_in_p
ad_connect  adc_data_in_n axi_ad9652/adc_data_in_n
ad_connect  axi_ad9652/adc_clk adc_clk 
ad_connect  axi_ad9652/adc_clk sys_wfifo/adc_clk
ad_connect  axi_ad9652/adc_dovf sys_wfifo/adc_wovf
ad_connect  sys_200m_clk sys_wfifo/dma_clk
ad_connect  sys_200m_clk axi_ad9652/delay_clk
ad_connect  sys_200m_clk axi_ad9652_dma/fifo_wr_clk
ad_connect  adc_valid_0 axi_ad9652/adc_valid_0
ad_connect  adc_enable_0 axi_ad9652/adc_enable_0
ad_connect  adc_data_0 axi_ad9652/adc_data_0
ad_connect  adc_valid_1 axi_ad9652/adc_valid_1
ad_connect  adc_enable_1 axi_ad9652/adc_enable_1
ad_connect  adc_data_1 axi_ad9652/adc_data_1
ad_connect  adc_dwr sys_wfifo/adc_wr
ad_connect  adc_ddata sys_wfifo/adc_wdata
ad_connect  sys_wfifo/dma_wr axi_ad9652_dma/fifo_wr_en
ad_connect  sys_wfifo/dma_wdata axi_ad9652_dma/fifo_wr_din
ad_connect  sys_wfifo/dma_wovf axi_ad9652_dma/fifo_wr_overflow

# interconnect (cpu)

ad_cpu_interconnect 0x79020000 axi_ad9652
ad_cpu_interconnect 0x7c420000 axi_ad9652_dma

# interconnect (mem/adc)

ad_mem_hp1_interconnect sys_200m_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_200m_clk axi_ad9652_dma/m_dest_axi
ad_connect  sys_cpu_resetn axi_ad9652_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9652_dma/irq

