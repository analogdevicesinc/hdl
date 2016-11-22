
# fmcadc4

# adc peripherals

set axi_ad9680_core_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9680:1.0 axi_ad9680_core_0]
set_property -dict [list CONFIG.ID {0}] $axi_ad9680_core_0
set axi_ad9680_core_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9680:1.0 axi_ad9680_core_1]
set_property -dict [list CONFIG.ID {1}] $axi_ad9680_core_1

set axi_ad9680_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9680_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_ad9680_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {1}] $axi_ad9680_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {0}] $axi_ad9680_xcvr

set axi_ad9680_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_ad9680_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9680_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9680_jesd

set axi_ad9680_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9680_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {1}] $axi_ad9680_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9680_dma
set_property -dict [list CONFIG.ID {0}] $axi_ad9680_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9680_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9680_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9680_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_ad9680_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9680_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9680_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_ad9680_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad9680_dma

set axi_ad9680_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 axi_ad9680_cpack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {64}] $axi_ad9680_cpack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $axi_ad9680_cpack

# adc common gt

set util_fmcadc4_xcvr [create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_fmcadc4_xcvr]
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_fmcadc4_xcvr
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $util_fmcadc4_xcvr

create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_data
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {128}] [get_bd_cells util_bsplit_rx_data]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] [get_bd_cells util_bsplit_rx_data]

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  rx_ref_clk_0 util_fmcadc4_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcadc4_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9680_xcvr/up_pll_rst util_fmcadc4_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9680_xcvr/up_pll_rst util_fmcadc4_xcvr/up_cpll_rst_*

# connections (gt)

ad_xcvrcon  util_fmcadc4_xcvr axi_ad9680_xcvr axi_ad9680_jesd
ad_connect  util_fmcadc4_xcvr/rx_out_clk_0 axi_ad9680_cpack/adc_clk
ad_connect  util_fmcadc4_xcvr/rx_out_clk_0 axi_ad9680_core_0/rx_clk
ad_connect  util_fmcadc4_xcvr/rx_out_clk_0 axi_ad9680_core_1/rx_clk
ad_connect  axi_ad9680_jesd/rx_start_of_frame axi_ad9680_core_0/rx_sof
ad_connect  axi_ad9680_jesd/rx_start_of_frame axi_ad9680_core_1/rx_sof
ad_connect  axi_ad9680_jesd/rx_tdata util_bsplit_rx_data/data
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_cpack/adc_rst

# connections (adc)

ad_connect  util_bsplit_rx_data/split_data_0 axi_ad9680_core_0/rx_data
ad_connect  util_bsplit_rx_data/split_data_1 axi_ad9680_core_1/rx_data
ad_connect  axi_ad9680_core_0/adc_enable_0 axi_ad9680_cpack/adc_enable_0
ad_connect  axi_ad9680_core_0/adc_valid_0 axi_ad9680_cpack/adc_valid_0
ad_connect  axi_ad9680_core_0/adc_data_0 axi_ad9680_cpack/adc_data_0
ad_connect  axi_ad9680_core_0/adc_enable_1 axi_ad9680_cpack/adc_enable_1
ad_connect  axi_ad9680_core_0/adc_valid_1 axi_ad9680_cpack/adc_valid_1
ad_connect  axi_ad9680_core_0/adc_data_1 axi_ad9680_cpack/adc_data_1
ad_connect  axi_ad9680_core_1/adc_enable_0 axi_ad9680_cpack/adc_enable_2
ad_connect  axi_ad9680_core_1/adc_valid_0 axi_ad9680_cpack/adc_valid_2
ad_connect  axi_ad9680_core_1/adc_data_0 axi_ad9680_cpack/adc_data_2
ad_connect  axi_ad9680_core_1/adc_enable_1 axi_ad9680_cpack/adc_enable_3
ad_connect  axi_ad9680_core_1/adc_valid_1 axi_ad9680_cpack/adc_valid_3
ad_connect  axi_ad9680_core_1/adc_data_1 axi_ad9680_cpack/adc_data_3
ad_connect  util_fmcadc4_xcvr/rx_out_clk_0 axi_ad9680_fifo/adc_clk
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_fifo/adc_rst
ad_connect  axi_ad9680_cpack/adc_valid axi_ad9680_fifo/adc_wr
ad_connect  axi_ad9680_cpack/adc_data axi_ad9680_fifo/adc_wdata
ad_connect  sys_cpu_clk axi_ad9680_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9680_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect  axi_ad9680_fifo/dma_wr axi_ad9680_dma/s_axis_valid
ad_connect  axi_ad9680_fifo/dma_wdata axi_ad9680_dma/s_axis_data
ad_connect  axi_ad9680_fifo/dma_wready axi_ad9680_dma/s_axis_ready
ad_connect  axi_ad9680_fifo/dma_xfer_req axi_ad9680_dma/s_axis_xfer_req
ad_connect  axi_ad9680_core_0/adc_dovf axi_ad9680_fifo/adc_wovf

ad_connect  sys_cpu_clk util_fmcadc4_xcvr/up_clk
ad_connect  sys_cpu_resetn util_fmcadc4_xcvr/up_rstn

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9680_xcvr
ad_cpu_interconnect 0x44A00000 axi_ad9680_core_0
ad_cpu_interconnect 0x44A10000 axi_ad9680_core_1
ad_cpu_interconnect 0x44A91000 axi_ad9680_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9680_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9680_xcvr/m_axi

# interconnect (mem/adc)

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9680_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9680_dma/irq

