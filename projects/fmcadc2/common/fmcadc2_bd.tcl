# adc peripherals

set axi_ad9625_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_core]

set axi_ad9625_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_ad9625_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_jesd

set axi_ad9625_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9625_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_ad9625_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {0}] $axi_ad9625_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {0}] $axi_ad9625_xcvr
set_property -dict [list CONFIG.LPM_OR_DFE_N {1}] $axi_ad9625_xcvr
set_property -dict [list CONFIG.SYS_CLK_SEL {0}] $axi_ad9625_xcvr
set_property -dict [list CONFIG.OUT_CLK_SEL {2}] $axi_ad9625_xcvr

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

set util_fmcadc2_xcvr [create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_fmcadc2_xcvr]
set_property -dict [list CONFIG.QPLL_FBDIV {"0010000000"}] $util_fmcadc2_xcvr ;# N = 40
set_property -dict [list CONFIG.CPLL_FBDIV {1}] $util_fmcadc2_xcvr
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $util_fmcadc2_xcvr
set_property -dict [list CONFIG.TX_OUT_DIV {1}] $util_fmcadc2_xcvr
set_property -dict [list CONFIG.TX_CLK25_DIV {25}] $util_fmcadc2_xcvr
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_fmcadc2_xcvr
set_property -dict [list CONFIG.RX_OUT_DIV {1}] $util_fmcadc2_xcvr
set_property -dict [list CONFIG.RX_CLK25_DIV {25}] $util_fmcadc2_xcvr
set_property -dict [list CONFIG.RX_DFE_LPM_CFG {0x0904}] $util_fmcadc2_xcvr
set_property -dict [list CONFIG.RX_CDR_CFG {0x03000023ff20400020}] $util_fmcadc2_xcvr ;# DFE mode refclk +-200

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir O rx_core_clk

ad_xcvrpll  rx_ref_clk_0 util_fmcadc2_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcadc2_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9625_xcvr/up_pll_rst util_fmcadc2_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_xcvr/up_pll_rst util_fmcadc2_xcvr/up_cpll_rst_*
ad_connect  sys_cpu_resetn util_fmcadc2_xcvr/up_rstn
ad_connect  sys_cpu_clk util_fmcadc2_xcvr/up_clk

# connections (adc)

ad_xcvrcon  util_fmcadc2_xcvr axi_ad9625_xcvr axi_ad9625_jesd
ad_connect  util_fmcadc2_xcvr/rx_out_clk_0 axi_ad9625_core/rx_clk
ad_connect  util_fmcadc2_xcvr/rx_out_clk_0 rx_core_clk
ad_connect  axi_ad9625_jesd/rx_tdata axi_ad9625_core/rx_data
ad_connect  axi_ad9625_jesd/rx_start_of_frame axi_ad9625_core/rx_sof
ad_connect  sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn
ad_connect  axi_ad9625_core/adc_clk axi_ad9625_fifo/adc_clk
ad_connect  axi_ad9625_jesd_rstgen/peripheral_reset axi_ad9625_fifo/adc_rst
ad_connect  axi_ad9625_core/adc_enable axi_ad9625_fifo/adc_wr
ad_connect  axi_ad9625_core/adc_data axi_ad9625_fifo/adc_wdata
ad_connect  axi_ad9625_core/adc_dovf axi_ad9625_fifo/adc_wovf
ad_connect  axi_ad9625_fifo/dma_wr axi_ad9625_dma/s_axis_valid
ad_connect  axi_ad9625_fifo/dma_wdata axi_ad9625_dma/s_axis_data
ad_connect  axi_ad9625_fifo/dma_wready axi_ad9625_dma/s_axis_ready
ad_connect  axi_ad9625_fifo/dma_xfer_req axi_ad9625_dma/s_axis_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9625_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9625_core
ad_cpu_interconnect 0x44A91000 axi_ad9625_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9625_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9625_xcvr/m_axi

# interconnect (mem/adc)

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9625_dma/irq

