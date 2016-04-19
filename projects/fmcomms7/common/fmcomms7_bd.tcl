
# fmcomms7

create_bd_port -dir I rx_ref_clk
create_bd_port -dir O rx_sync
create_bd_port -dir I rx_sysref
create_bd_port -dir I -from 3 -to 0 rx_data_p
create_bd_port -dir I -from 3 -to 0 rx_data_n

create_bd_port -dir I tx_ref_clk
create_bd_port -dir I tx_sync
create_bd_port -dir I tx_sysref
create_bd_port -dir O -from 7 -to 0 tx_data_p
create_bd_port -dir O -from 7 -to 0 tx_data_n

create_bd_port -dir O -from 11 -to 0 spi2_csn_o
create_bd_port -dir I -from 11 -to 0 spi2_csn_i
create_bd_port -dir I spi2_clk_i
create_bd_port -dir O spi2_clk_o
create_bd_port -dir I spi2_sdo_i
create_bd_port -dir O spi2_sdo_o
create_bd_port -dir I spi2_sdi_i

# dac peripherals

set axi_ad9144_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9144:1.0 axi_ad9144_core]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {1}] $axi_ad9144_core

set axi_ad9144_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9144_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {1}] $axi_ad9144_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9144_jesd

set axi_ad9144_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9144_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9144_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {1}] $axi_ad9144_dma
set_property -dict [list CONFIG.ID {1}] $axi_ad9144_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9144_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9144_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_ad9144_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9144_dma
set_property -dict [list CONFIG.CYCLIC {1}] $axi_ad9144_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {256}] $axi_ad9144_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {256}] $axi_ad9144_dma

set axi_ad9144_upack [create_bd_cell -type ip -vlnv analog.com:user:util_upack:1.0 axi_ad9144_upack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {64}] $axi_ad9144_upack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $axi_ad9144_upack

# adc peripherals

set axi_ad9680_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9680:1.0 axi_ad9680_core]

set axi_ad9680_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9680_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9680_jesd
set_property -dict [list CONFIG.C_LANES {4}] $axi_ad9680_jesd

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
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $axi_ad9680_cpack

# dac/adc common gt

set axi_fmcomms7_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_fmcomms7_gt]
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {8}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {4}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_DATA_SEL_0 {5}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_DATA_SEL_1 {3}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_DATA_SEL_2 {6}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_DATA_SEL_3 {7}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_DATA_SEL_4 {2}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_DATA_SEL_5 {0}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_DATA_SEL_6 {1}] $axi_fmcomms7_gt
set_property -dict [list CONFIG.TX_DATA_SEL_7 {4}] $axi_fmcomms7_gt

set util_fmcomms7_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_fmcomms7_gt]
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $util_fmcomms7_gt
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $util_fmcomms7_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_fmcomms7_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {4}] $util_fmcomms7_gt
set_property -dict [list CONFIG.TX_ENABLE {1}] $util_fmcomms7_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {8}] $util_fmcomms7_gt

set axi_fmcomms7_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_fmcomms7_spi]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_fmcomms7_spi
set_property -dict [list CONFIG.C_NUM_SS_BITS {12}] $axi_fmcomms7_spi
set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_fmcomms7_spi

# connections (spi2)

ad_connect  spi2_csn_i axi_fmcomms7_spi/ss_i
ad_connect  spi2_csn_o axi_fmcomms7_spi/ss_o
ad_connect  spi2_clk_i axi_fmcomms7_spi/sck_i
ad_connect  spi2_clk_o axi_fmcomms7_spi/sck_o
ad_connect  spi2_sdo_i axi_fmcomms7_spi/io0_i
ad_connect  spi2_sdo_o axi_fmcomms7_spi/io0_o
ad_connect  spi2_sdi_i axi_fmcomms7_spi/io1_i
ad_connect  sys_cpu_clk axi_fmcomms7_spi/ext_spi_clk

# connections (gt)

ad_connect  util_fmcomms7_gt/qpll_ref_clk rx_ref_clk
ad_connect  util_fmcomms7_gt/cpll_ref_clk tx_ref_clk

ad_connect  axi_fmcomms7_gt/gt_qpll_0 util_fmcomms7_gt/gt_qpll_0
ad_connect  axi_fmcomms7_gt/gt_pll_0 util_fmcomms7_gt/gt_pll_0
ad_connect  axi_fmcomms7_gt/gt_pll_1 util_fmcomms7_gt/gt_pll_1
ad_connect  axi_fmcomms7_gt/gt_pll_2 util_fmcomms7_gt/gt_pll_2
ad_connect  axi_fmcomms7_gt/gt_pll_3 util_fmcomms7_gt/gt_pll_3
ad_connect  axi_fmcomms7_gt/gt_pll_4 util_fmcomms7_gt/gt_pll_4
ad_connect  axi_fmcomms7_gt/gt_pll_5 util_fmcomms7_gt/gt_pll_5
ad_connect  axi_fmcomms7_gt/gt_pll_6 util_fmcomms7_gt/gt_pll_6
ad_connect  axi_fmcomms7_gt/gt_pll_7 util_fmcomms7_gt/gt_pll_7
ad_connect  axi_fmcomms7_gt/gt_rx_0 util_fmcomms7_gt/gt_rx_0
ad_connect  axi_fmcomms7_gt/gt_rx_1 util_fmcomms7_gt/gt_rx_1
ad_connect  axi_fmcomms7_gt/gt_rx_2 util_fmcomms7_gt/gt_rx_2
ad_connect  axi_fmcomms7_gt/gt_rx_3 util_fmcomms7_gt/gt_rx_3
ad_connect  axi_fmcomms7_gt/gt_rx_ip_0 axi_ad9680_jesd/gt0_rx
ad_connect  axi_fmcomms7_gt/gt_rx_ip_1 axi_ad9680_jesd/gt1_rx
ad_connect  axi_fmcomms7_gt/gt_rx_ip_2 axi_ad9680_jesd/gt2_rx
ad_connect  axi_fmcomms7_gt/gt_rx_ip_3 axi_ad9680_jesd/gt3_rx
ad_connect  axi_fmcomms7_gt/rx_gt_comma_align_enb_0 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcomms7_gt/rx_gt_comma_align_enb_1 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcomms7_gt/rx_gt_comma_align_enb_2 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcomms7_gt/rx_gt_comma_align_enb_3 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcomms7_gt/gt_tx_0 util_fmcomms7_gt/gt_tx_0
ad_connect  axi_fmcomms7_gt/gt_tx_1 util_fmcomms7_gt/gt_tx_1
ad_connect  axi_fmcomms7_gt/gt_tx_2 util_fmcomms7_gt/gt_tx_2
ad_connect  axi_fmcomms7_gt/gt_tx_3 util_fmcomms7_gt/gt_tx_3
ad_connect  axi_fmcomms7_gt/gt_tx_4 util_fmcomms7_gt/gt_tx_4
ad_connect  axi_fmcomms7_gt/gt_tx_5 util_fmcomms7_gt/gt_tx_5
ad_connect  axi_fmcomms7_gt/gt_tx_6 util_fmcomms7_gt/gt_tx_6
ad_connect  axi_fmcomms7_gt/gt_tx_7 util_fmcomms7_gt/gt_tx_7
ad_connect  axi_fmcomms7_gt/gt_tx_ip_0 axi_ad9144_jesd/gt0_tx
ad_connect  axi_fmcomms7_gt/gt_tx_ip_1 axi_ad9144_jesd/gt1_tx
ad_connect  axi_fmcomms7_gt/gt_tx_ip_2 axi_ad9144_jesd/gt2_tx
ad_connect  axi_fmcomms7_gt/gt_tx_ip_3 axi_ad9144_jesd/gt3_tx
ad_connect  axi_fmcomms7_gt/gt_tx_ip_4 axi_ad9144_jesd/gt4_tx
ad_connect  axi_fmcomms7_gt/gt_tx_ip_5 axi_ad9144_jesd/gt5_tx
ad_connect  axi_fmcomms7_gt/gt_tx_ip_6 axi_ad9144_jesd/gt6_tx
ad_connect  axi_fmcomms7_gt/gt_tx_ip_7 axi_ad9144_jesd/gt7_tx

# connections (dac)

ad_connect  util_fmcomms7_gt/tx_sysref tx_sysref
ad_connect  util_fmcomms7_gt/tx_p tx_data_p
ad_connect  util_fmcomms7_gt/tx_n tx_data_n
ad_connect  util_fmcomms7_gt/tx_sync tx_sync
ad_connect  util_fmcomms7_gt/tx_out_clk util_fmcomms7_gt/tx_clk
ad_connect  util_fmcomms7_gt/tx_out_clk axi_ad9144_jesd/tx_core_clk
ad_connect  util_fmcomms7_gt/tx_ip_rst axi_ad9144_jesd/tx_reset
ad_connect  util_fmcomms7_gt/tx_ip_rst_done axi_ad9144_jesd/tx_reset_done
ad_connect  util_fmcomms7_gt/tx_ip_sysref axi_ad9144_jesd/tx_sysref
ad_connect  util_fmcomms7_gt/tx_ip_sync axi_ad9144_jesd/tx_sync
ad_connect  util_fmcomms7_gt/tx_ip_data axi_ad9144_jesd/tx_tdata
ad_connect  util_fmcomms7_gt/tx_out_clk axi_ad9144_core/tx_clk
ad_connect  util_fmcomms7_gt/tx_data axi_ad9144_core/tx_data
ad_connect  util_fmcomms7_gt/tx_out_clk axi_ad9144_upack/dac_clk
ad_connect  axi_ad9144_core/dac_enable_0 axi_ad9144_upack/dac_enable_0
ad_connect  axi_ad9144_core/dac_ddata_0 axi_ad9144_upack/dac_data_0
ad_connect  axi_ad9144_core/dac_valid_0 axi_ad9144_upack/dac_valid_0
ad_connect  axi_ad9144_core/dac_enable_1 axi_ad9144_upack/dac_enable_1
ad_connect  axi_ad9144_core/dac_ddata_1 axi_ad9144_upack/dac_data_1
ad_connect  axi_ad9144_core/dac_valid_1 axi_ad9144_upack/dac_valid_1
ad_connect  axi_ad9144_core/dac_enable_2 axi_ad9144_upack/dac_enable_2
ad_connect  axi_ad9144_core/dac_ddata_2 axi_ad9144_upack/dac_data_2
ad_connect  axi_ad9144_core/dac_valid_2 axi_ad9144_upack/dac_valid_2
ad_connect  axi_ad9144_core/dac_enable_3 axi_ad9144_upack/dac_enable_3
ad_connect  axi_ad9144_core/dac_ddata_3 axi_ad9144_upack/dac_data_3
ad_connect  axi_ad9144_core/dac_valid_3 axi_ad9144_upack/dac_valid_3
ad_connect  util_fmcomms7_gt/tx_out_clk axi_ad9144_fifo/dac_clk
ad_connect  axi_ad9144_upack/dac_valid axi_ad9144_fifo/dac_valid
ad_connect  axi_ad9144_upack/dac_data axi_ad9144_fifo/dac_data
ad_connect  sys_cpu_clk axi_ad9144_fifo/dma_clk
ad_connect  sys_cpu_reset axi_ad9144_fifo/dma_rst
ad_connect  sys_cpu_clk axi_ad9144_dma/m_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9144_dma/m_src_axi_aresetn
ad_connect  axi_ad9144_fifo/dma_xfer_req axi_ad9144_dma/m_axis_xfer_req
ad_connect  axi_ad9144_fifo/dma_ready axi_ad9144_dma/m_axis_ready
ad_connect  axi_ad9144_fifo/dma_data axi_ad9144_dma/m_axis_data
ad_connect  axi_ad9144_fifo/dma_valid axi_ad9144_dma/m_axis_valid
ad_connect  axi_ad9144_fifo/dma_xfer_last axi_ad9144_dma/m_axis_last

# connections (adc)

ad_connect  util_fmcomms7_gt/rx_sysref rx_sysref
ad_connect  util_fmcomms7_gt/rx_p rx_data_p
ad_connect  util_fmcomms7_gt/rx_n rx_data_n
ad_connect  util_fmcomms7_gt/rx_sync rx_sync
ad_connect  util_fmcomms7_gt/rx_out_clk util_fmcomms7_gt/rx_clk
ad_connect  util_fmcomms7_gt/rx_out_clk axi_ad9680_jesd/rx_core_clk
ad_connect  util_fmcomms7_gt/rx_ip_rst axi_ad9680_jesd/rx_reset
ad_connect  util_fmcomms7_gt/rx_ip_rst_done axi_ad9680_jesd/rx_reset_done
ad_connect  util_fmcomms7_gt/rx_ip_sysref axi_ad9680_jesd/rx_sysref
ad_connect  util_fmcomms7_gt/rx_ip_sync axi_ad9680_jesd/rx_sync
ad_connect  util_fmcomms7_gt/rx_ip_sof axi_ad9680_jesd/rx_start_of_frame
ad_connect  util_fmcomms7_gt/rx_ip_data axi_ad9680_jesd/rx_tdata
ad_connect  util_fmcomms7_gt/rx_out_clk axi_ad9680_core/rx_clk
ad_connect  util_fmcomms7_gt/rx_data axi_ad9680_core/rx_data
ad_connect  util_fmcomms7_gt/rx_out_clk axi_ad9680_cpack/adc_clk
ad_connect  util_fmcomms7_gt/rx_rst axi_ad9680_cpack/adc_rst
ad_connect  axi_ad9680_core/adc_enable_0 axi_ad9680_cpack/adc_enable_0
ad_connect  axi_ad9680_core/adc_valid_0 axi_ad9680_cpack/adc_valid_0
ad_connect  axi_ad9680_core/adc_data_0 axi_ad9680_cpack/adc_data_0
ad_connect  axi_ad9680_core/adc_enable_1 axi_ad9680_cpack/adc_enable_1
ad_connect  axi_ad9680_core/adc_valid_1 axi_ad9680_cpack/adc_valid_1
ad_connect  axi_ad9680_core/adc_data_1 axi_ad9680_cpack/adc_data_1
ad_connect  util_fmcomms7_gt/rx_out_clk axi_ad9680_fifo/adc_clk
ad_connect  util_fmcomms7_gt/rx_rst axi_ad9680_fifo/adc_rst
ad_connect  axi_ad9680_cpack/adc_valid axi_ad9680_fifo/adc_wr
ad_connect  axi_ad9680_cpack/adc_data axi_ad9680_fifo/adc_wdata
ad_connect  sys_cpu_clk axi_ad9680_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9680_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect  axi_ad9680_fifo/dma_wr axi_ad9680_dma/s_axis_valid
ad_connect  axi_ad9680_fifo/dma_wdata axi_ad9680_dma/s_axis_data
ad_connect  axi_ad9680_fifo/dma_wready axi_ad9680_dma/s_axis_ready
ad_connect  axi_ad9680_fifo/dma_xfer_req axi_ad9680_dma/s_axis_xfer_req
ad_connect  axi_ad9680_core/adc_dovf axi_ad9680_fifo/adc_wovf

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_fmcomms7_gt
ad_cpu_interconnect 0x44A00000 axi_ad9144_core
ad_cpu_interconnect 0x44A90000 axi_ad9144_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9144_dma
ad_cpu_interconnect 0x44A10000 axi_ad9680_core
ad_cpu_interconnect 0x44A91000 axi_ad9680_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9680_dma
ad_cpu_interconnect 0x44A80000 axi_fmcomms7_spi

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_fmcomms7_gt/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9144_dma/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9680_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-9  mb-9  axi_ad9144_dma/irq
ad_cpu_interrupt ps-10 mb-10 axi_ad9680_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_fmcomms7_spi/ip2intc_irpt

