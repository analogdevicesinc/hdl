
# ad9467

create_bd_port -dir I adc_clk_in_p
create_bd_port -dir I adc_clk_in_n
create_bd_port -dir I adc_data_or_p
create_bd_port -dir I adc_data_or_n
create_bd_port -dir I -from 7 -to 0 adc_data_in_n
create_bd_port -dir I -from 7 -to 0 adc_data_in_p

# adc peripheral

set axi_ad9467  [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9467:1.0 axi_ad9467]

set axi_ad9467_dma  [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9467_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {16}] $axi_ad9467_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9467_dma

# connections (ad9467)

ad_connect  adc_clk_in_p axi_ad9467/adc_clk_in_p
ad_connect  adc_clk_in_n axi_ad9467/adc_clk_in_n
ad_connect  adc_data_in_n axi_ad9467/adc_data_in_n
ad_connect  adc_data_in_p axi_ad9467/adc_data_in_p
ad_connect  adc_data_or_p axi_ad9467/adc_or_in_p
ad_connect  adc_data_or_n axi_ad9467/adc_or_in_n

ad_connect  axi_ad9467/adc_clk axi_ad9467_dma/fifo_wr_clk

ad_connect  sys_200m_clk axi_ad9467/delay_clk

ad_connect  axi_ad9467/adc_valid axi_ad9467_dma/fifo_wr_en
ad_connect  axi_ad9467/adc_data axi_ad9467_dma/fifo_wr_din
ad_connect  axi_ad9467/adc_dovf axi_ad9467_dma/fifo_wr_overflow

# interconnect

ad_cpu_interconnect  0x44A00000 axi_ad9467
ad_cpu_interconnect  0x44A30000 axi_ad9467_dma

# memory inteconnect

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9467_dma/m_dest_axi
ad_connect sys_cpu_resetn axi_ad9467_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9467_dma/irq

# ila (with fifo to prevent timing failure)

set ila_fifo  [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 ila_fifo]
set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}] $ila_fifo
set_property -dict [list CONFIG.Input_Data_Width {16}] $ila_fifo
set_property -dict [list CONFIG.Input_Depth {128}] $ila_fifo
set_property -dict [list CONFIG.Output_Data_Width {32}] $ila_fifo
set_property -dict [list CONFIG.Overflow_Flag {true}] $ila_fifo
set_property -dict [list CONFIG.Reset_Pin {false}] $ila_fifo

set ila_ad9467_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_ad9467_mon]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_ad9467_mon
set_property -dict [list CONFIG.C_NUM_OF_PROBES {1}] $ila_ad9467_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {32}] $ila_ad9467_mon


ad_connect  sys_200m_clk ila_ad9467_mon/clk
ad_connect  axi_ad9467/adc_clk ila_fifo/wr_clk
ad_connect  sys_200m_clk ila_fifo/rd_clk

ad_connect  ila_fifo/din axi_ad9467/adc_data
ad_connect  ila_fifo/rd_en  "VCC"
ad_connect  ila_fifo/wr_en  "VCC"
ad_connect  ila_fifo/dout ila_ad9467_mon/probe0

