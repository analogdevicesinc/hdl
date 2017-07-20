
# adc peripherals

set axi_ad9250_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9250_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {4}] $axi_ad9250_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {0}] $axi_ad9250_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {0}] $axi_ad9250_xcvr
set_property -dict [list CONFIG.LPM_OR_DFE_N {0}] $axi_ad9250_xcvr
set_property -dict [list CONFIG.OUT_CLK_SEL {"010"}] $axi_ad9250_xcvr
set_property -dict [list CONFIG.SYS_CLK_SEL {"00"}] $axi_ad9250_xcvr

set axi_ad9250_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_ad9250_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9250_jesd
set_property -dict [list CONFIG.C_LANES {4}] $axi_ad9250_jesd

set data_bsplit [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 data_bsplit]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {64} ] $data_bsplit
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $data_bsplit

set axi_ad9250_0_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9250:1.0 axi_ad9250_0_core]
set axi_ad9250_1_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9250:1.0 axi_ad9250_1_core]

set axi_ad9250_0_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 axi_ad9250_0_cpack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $axi_ad9250_0_cpack
set axi_ad9250_1_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 axi_ad9250_1_cpack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $axi_ad9250_1_cpack

set axi_ad9250_0_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9250_0_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.ID {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad9250_0_dma

set axi_ad9250_1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9250_1_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.ID {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad9250_1_dma

# transceiver core

set util_fmcjesdadc1_xcvr [create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_fmcjesdadc1_xcvr]
set_property -dict [list CONFIG.QPLL_FBDIV {"0010000000"}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.CPLL_FBDIV {2}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.TX_OUT_DIV {1}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.TX_CLK25_DIV {10}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.RX_NUM_OF_LANES {4}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.RX_OUT_DIV {1}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.RX_CLK25_DIV {10}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.RX_DFE_LPM_CFG {0x0904}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.RX_PMA_CFG {0x00018480}] $util_fmcjesdadc1_xcvr
set_property -dict [list CONFIG.RX_CDR_CFG {0x03000023ff10200020}] $util_fmcjesdadc1_xcvr

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  rx_ref_clk_0 util_fmcjesdadc1_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcjesdadc1_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9250_xcvr/up_pll_rst util_fmcjesdadc1_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9250_xcvr/up_pll_rst util_fmcjesdadc1_xcvr/up_cpll_rst_*
ad_connect  sys_cpu_resetn util_fmcjesdadc1_xcvr/up_rstn
ad_connect  sys_cpu_clk util_fmcjesdadc1_xcvr/up_clk

create_bd_port -dir O rx_core_clk

# connections (adc)

ad_xcvrcon  util_fmcjesdadc1_xcvr axi_ad9250_xcvr axi_ad9250_jesd
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_0_core/rx_clk
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 rx_core_clk
ad_connect  axi_ad9250_jesd/rx_start_of_frame axi_ad9250_0_core/rx_sof
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_1_core/rx_clk
ad_connect  axi_ad9250_jesd/rx_start_of_frame axi_ad9250_1_core/rx_sof

ad_connect  axi_ad9250_jesd/rx_tdata data_bsplit/data
ad_connect  axi_ad9250_0_core/rx_data data_bsplit/split_data_0
ad_connect  axi_ad9250_1_core/rx_data data_bsplit/split_data_1

ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_0_cpack/adc_clk
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_1_cpack/adc_clk
ad_connect  axi_ad9250_jesd_rstgen/peripheral_reset axi_ad9250_0_cpack/adc_rst
ad_connect  axi_ad9250_jesd_rstgen/peripheral_reset axi_ad9250_1_cpack/adc_rst

ad_connect  axi_ad9250_0_core/adc_enable_a axi_ad9250_0_cpack/adc_enable_0
ad_connect  axi_ad9250_0_core/adc_valid_a axi_ad9250_0_cpack/adc_valid_0
ad_connect  axi_ad9250_0_core/adc_data_a axi_ad9250_0_cpack/adc_data_0
ad_connect  axi_ad9250_0_core/adc_enable_b axi_ad9250_0_cpack/adc_enable_1
ad_connect  axi_ad9250_0_core/adc_valid_b axi_ad9250_0_cpack/adc_valid_1
ad_connect  axi_ad9250_0_core/adc_data_b axi_ad9250_0_cpack/adc_data_1
ad_connect  axi_ad9250_1_core/adc_enable_a axi_ad9250_1_cpack/adc_enable_0
ad_connect  axi_ad9250_1_core/adc_valid_a axi_ad9250_1_cpack/adc_valid_0
ad_connect  axi_ad9250_1_core/adc_data_a axi_ad9250_1_cpack/adc_data_0
ad_connect  axi_ad9250_1_core/adc_enable_b axi_ad9250_1_cpack/adc_enable_1
ad_connect  axi_ad9250_1_core/adc_valid_b axi_ad9250_1_cpack/adc_valid_1
ad_connect  axi_ad9250_1_core/adc_data_b axi_ad9250_1_cpack/adc_data_1

ad_connect  axi_ad9250_0_core/adc_clk axi_ad9250_0_dma/fifo_wr_clk
ad_connect  axi_ad9250_0_dma/fifo_wr_en axi_ad9250_0_cpack/adc_valid
ad_connect  axi_ad9250_0_dma/fifo_wr_sync axi_ad9250_0_cpack/adc_sync
ad_connect  axi_ad9250_0_dma/fifo_wr_din axi_ad9250_0_cpack/adc_data
ad_connect  axi_ad9250_0_core/adc_dovf axi_ad9250_0_dma/fifo_wr_overflow
ad_connect  axi_ad9250_1_core/adc_clk axi_ad9250_1_dma/fifo_wr_clk
ad_connect  axi_ad9250_1_dma/fifo_wr_en axi_ad9250_1_cpack/adc_valid
ad_connect  axi_ad9250_1_dma/fifo_wr_sync axi_ad9250_1_cpack/adc_sync
ad_connect  axi_ad9250_1_dma/fifo_wr_din axi_ad9250_1_cpack/adc_data
ad_connect  axi_ad9250_1_core/adc_dovf axi_ad9250_1_dma/fifo_wr_overflow

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9250_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9250_0_core
ad_cpu_interconnect 0x44A20000 axi_ad9250_1_core
ad_cpu_interconnect 0x44A91000 axi_ad9250_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9250_0_dma
ad_cpu_interconnect 0x7c430000 axi_ad9250_1_dma

# xcvr uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9250_xcvr/m_axi

# interconnect (adc)

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_0_dma/m_dest_axi
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_1_dma/m_dest_axi

ad_connect  sys_cpu_resetn axi_ad9250_0_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9250_1_dma/m_dest_axi_aresetn

#interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9250_0_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9250_1_dma/irq

