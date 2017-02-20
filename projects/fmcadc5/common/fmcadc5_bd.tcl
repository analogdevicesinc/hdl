# adc peripherals

set util_fmcadc5_0_xcvr [create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_fmcadc5_0_xcvr]
set_property -dict [list CONFIG.QPLL_FBDIV {"0010000000"}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.CPLL_FBDIV {1}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.TX_OUT_DIV {2}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.TX_CLK25_DIV {10}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.RX_OUT_DIV {1}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.RX_CLK25_DIV {25}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.RX_DFE_LPM_CFG {0x0954}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.RX_CDR_CFG {0x03000023ff20400020}] $util_fmcadc5_0_xcvr
set_property -dict [list CONFIG.RX_PMA_CFG {0x00018480}] $util_fmcadc5_0_xcvr
set util_fmcadc5_1_xcvr [create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_fmcadc5_1_xcvr]
set_property -dict [list CONFIG.QPLL_FBDIV {"0010000000"}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.CPLL_FBDIV {1}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.TX_OUT_DIV {2}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.TX_CLK25_DIV {10}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.RX_OUT_DIV {1}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.RX_CLK25_DIV {25}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.RX_DFE_LPM_CFG {0x0954}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.RX_CDR_CFG {0x03000023ff20400020}] $util_fmcadc5_1_xcvr
set_property -dict [list CONFIG.RX_PMA_CFG {0x00018480}] $util_fmcadc5_1_xcvr

set axi_ad9625_0_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9625_0_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_ad9625_0_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {0}] $axi_ad9625_0_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {0}] $axi_ad9625_0_xcvr
set_property -dict [list CONFIG.LPM_OR_DFE_N {0}] $axi_ad9625_0_xcvr
set_property -dict [list CONFIG.SYS_CLK_SEL {"00"}] $axi_ad9625_0_xcvr
set_property -dict [list CONFIG.OUT_CLK_SEL {"010"}] $axi_ad9625_0_xcvr

set axi_ad9625_1_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9625_1_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_ad9625_1_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {0}] $axi_ad9625_1_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {0}] $axi_ad9625_1_xcvr
set_property -dict [list CONFIG.LPM_OR_DFE_N {0}] $axi_ad9625_1_xcvr
set_property -dict [list CONFIG.SYS_CLK_SEL {"00"}] $axi_ad9625_1_xcvr
set_property -dict [list CONFIG.OUT_CLK_SEL {"010"}] $axi_ad9625_1_xcvr

set axi_ad9625_0_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_ad9625_0_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_0_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_0_jesd
set axi_ad9625_1_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_ad9625_1_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_1_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_1_jesd

set axi_ad9625_0_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_0_core]
set_property -dict [list CONFIG.ID {0}] $axi_ad9625_0_core
set axi_ad9625_1_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_1_core]
set_property -dict [list CONFIG.ID {1}] $axi_ad9625_1_core

set util_ad9625_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_ad9625_cpack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {256}] $util_ad9625_cpack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_ad9625_cpack

set axi_ad9625_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9625_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {1}] $axi_ad9625_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.ID {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_ad9625_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_ad9625_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad9625_dma

p_sys_adcfifo [current_bd_instance .] axi_ad9625_fifo 512 18

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I rx_ref_clk_1

ad_xcvrpll  rx_ref_clk_0 util_fmcadc5_0_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcadc5_0_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9625_0_xcvr/up_pll_rst util_fmcadc5_0_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_0_xcvr/up_pll_rst util_fmcadc5_0_xcvr/up_cpll_rst_*
ad_xcvrpll  rx_ref_clk_1 util_fmcadc5_1_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_1 util_fmcadc5_1_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9625_1_xcvr/up_pll_rst util_fmcadc5_1_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_1_xcvr/up_pll_rst util_fmcadc5_1_xcvr/up_cpll_rst_*
ad_connect  sys_cpu_resetn util_fmcadc5_0_xcvr/up_rstn
ad_connect  sys_cpu_resetn util_fmcadc5_1_xcvr/up_rstn
ad_connect  sys_cpu_clk util_fmcadc5_0_xcvr/up_clk
ad_connect  sys_cpu_clk util_fmcadc5_1_xcvr/up_clk

# connections (adc)

ad_xcvrcon  util_fmcadc5_0_xcvr axi_ad9625_0_xcvr axi_ad9625_0_jesd
ad_xcvrcon  util_fmcadc5_1_xcvr axi_ad9625_1_xcvr axi_ad9625_1_jesd

delete_bd_objs [get_bd_nets -of_objects [get_bd_pins util_fmcadc5_1_xcvr/rx_out_clk_0]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9625_1_jesd_rstgen/peripheral_reset]]
delete_bd_objs [get_bd_cells axi_ad9625_1_jesd_rstgen]

ad_xcvrpll  util_fmcadc5_0_xcvr/rx_out_clk_0 util_fmcadc5_1_xcvr/rx_clk_*
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_ad9625_1_jesd/rx_core_clk
ad_connect  axi_ad9625_0_jesd_rstgen/peripheral_reset axi_ad9625_1_jesd/rx_reset
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_ad9625_0_core/rx_clk
ad_connect  axi_ad9625_0_jesd/rx_start_of_frame axi_ad9625_0_core/rx_sof
ad_connect  axi_ad9625_0_jesd/rx_tdata axi_ad9625_0_core/rx_data
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_ad9625_1_core/rx_clk
ad_connect  axi_ad9625_0_jesd/rx_start_of_frame axi_ad9625_1_core/rx_sof
ad_connect  axi_ad9625_1_jesd/rx_tdata axi_ad9625_1_core/rx_data
ad_connect  axi_ad9625_0_core/adc_raddr_out axi_ad9625_0_core/adc_raddr_in
ad_connect  axi_ad9625_0_core/adc_raddr_out axi_ad9625_1_core/adc_raddr_in
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 util_ad9625_cpack/adc_clk
ad_connect  axi_ad9625_0_jesd_rstgen/peripheral_reset util_ad9625_cpack/adc_rst
ad_connect  axi_ad9625_0_core/adc_enable util_ad9625_cpack/adc_enable_0
ad_connect  axi_ad9625_0_core/adc_valid util_ad9625_cpack/adc_valid_0
ad_connect  axi_ad9625_0_core/adc_data util_ad9625_cpack/adc_data_0
ad_connect  axi_ad9625_1_core/adc_enable util_ad9625_cpack/adc_enable_1
ad_connect  axi_ad9625_1_core/adc_valid util_ad9625_cpack/adc_valid_1
ad_connect  axi_ad9625_1_core/adc_data util_ad9625_cpack/adc_data_1
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_ad9625_fifo/adc_clk
ad_connect  axi_ad9625_0_jesd_rstgen/peripheral_reset axi_ad9625_fifo/adc_rst
ad_connect  util_ad9625_cpack/adc_valid axi_ad9625_fifo/adc_wr
ad_connect  util_ad9625_cpack/adc_data axi_ad9625_fifo/adc_wdata
ad_connect  axi_ad9625_fifo/adc_wovf axi_ad9625_0_core/adc_dovf
ad_connect  axi_ad9625_fifo/adc_wovf axi_ad9625_1_core/adc_dovf
ad_connect  sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn
ad_connect  axi_ad9625_fifo/dma_wr axi_ad9625_dma/s_axis_valid
ad_connect  axi_ad9625_fifo/dma_wdata axi_ad9625_dma/s_axis_data
ad_connect  axi_ad9625_fifo/dma_wready axi_ad9625_dma/s_axis_ready
ad_connect  axi_ad9625_fifo/dma_xfer_req axi_ad9625_dma/s_axis_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44a60000 axi_ad9625_0_xcvr
ad_cpu_interconnect 0x44b60000 axi_ad9625_1_xcvr
ad_cpu_interconnect 0x44a10000 axi_ad9625_0_core
ad_cpu_interconnect 0x44b10000 axi_ad9625_1_core
ad_cpu_interconnect 0x44a91000 axi_ad9625_0_jesd
ad_cpu_interconnect 0x44b91000 axi_ad9625_1_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9625_dma

# interconnect (gt/adc)

ad_mem_hp0_interconnect sys_cpu_clk axi_ad9625_0_xcvr/m_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_ad9625_1_xcvr/m_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad9625_dma/irq

# sync

create_bd_port -dir O rx_clk
create_bd_port -dir O up_clk
create_bd_port -dir O up_rstn
create_bd_port -dir O delay_clk
create_bd_port -dir O delay_rst

ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 rx_clk
ad_connect  sys_cpu_clk up_clk
ad_connect  sys_cpu_resetn up_rstn
ad_connect  sys_200m_clk delay_clk
ad_connect  sys_cpu_reset delay_rst


