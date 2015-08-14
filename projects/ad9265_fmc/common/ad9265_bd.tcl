
# ad9265

create_bd_port -dir I adc_clk_in_p
create_bd_port -dir I adc_clk_in_n
create_bd_port -dir I adc_data_or_p
create_bd_port -dir I adc_data_or_n
create_bd_port -dir I -from 7 -to 0 adc_data_in_n
create_bd_port -dir I -from 7 -to 0 adc_data_in_p

# adc peripheral

set axi_ad9265  [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9265:1.0 axi_ad9265]

set axi_ad9265_dma  [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9265_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {16}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9265_dma

# clock for ila

set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {125.0}] $sys_ps7

# connections (ad9265)

ad_connect    adc_clk_in_p     axi_ad9265/adc_clk_in_p
ad_connect    adc_clk_in_n     axi_ad9265/adc_clk_in_n
ad_connect    adc_data_in_n    axi_ad9265/adc_data_in_n
ad_connect    adc_data_in_p    axi_ad9265/adc_data_in_p
ad_connect    adc_data_or_p    axi_ad9265/adc_or_in_p
ad_connect    adc_data_or_n    axi_ad9265/adc_or_in_n

ad_connect ad9265_clk axi_ad9265/adc_clk

ad_connect ad9265_clk     axi_ad9265_dma/fifo_wr_clk
ad_connect sys_200m_clk   axi_ad9265/delay_clk

ad_connect axi_ad9265/adc_valid  axi_ad9265_dma/fifo_wr_en
ad_connect axi_ad9265/adc_data   axi_ad9265_dma/fifo_wr_din
ad_connect axi_ad9265/adc_dovf   axi_ad9265_dma/fifo_wr_overflow

# ila (with fifo to prevent timing failure)

p_sys_wfifo [current_bd_instance .] ila_wfifo 16 32

ad_connect ad9265_clk         ila_wfifo/adc_clk
ad_connect sys_200m_clk       ila_wfifo/dma_clk
ad_connect axi_ad9265/adc_rst ila_wfifo/adc_rst

set ila_ad9265_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_ad9265_mon]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_ad9265_mon
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_ad9265_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_ad9265_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {32}] $ila_ad9265_mon
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_ad9265_mon

ad_connect ila_wfifo/adc_wr axi_ad9265/adc_valid
ad_connect ila_wfifo/adc_wdata axi_ad9265/adc_data
ad_connect ila_wfifo/dma_wr ila_ad9265_mon/PROBE0
ad_connect ila_wfifo/dma_wdata ila_ad9265_mon/PROBE1
ad_connect sys_200m_clk ila_ad9265_mon/clk

# address mapping

ad_cpu_interconnect 0x44A00000 axi_ad9265
ad_cpu_interconnect 0x44A30000 axi_ad9265_dma

# interconnect (adc)

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad9265_dma/m_dest_axi
ad_connect  sys_cpu_resetn axi_ad9265_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9265_dma/irq
