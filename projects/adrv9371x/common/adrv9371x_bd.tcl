
# ad9371

create_bd_port -dir I rx_ref_clk
create_bd_port -dir I rx_sysref
create_bd_port -dir I -from 1 -to 0 rx_p
create_bd_port -dir I -from 1 -to 0 rx_n
create_bd_port -dir O rx_sync
create_bd_port -dir I -from 1 -to 0 rx_os_p
create_bd_port -dir I -from 1 -to 0 rx_os_n
create_bd_port -dir O rx_os_sync

create_bd_port -dir I tx_ref_clk
create_bd_port -dir I tx_sysref
create_bd_port -dir O -from 3 -to 0 tx_p
create_bd_port -dir O -from 3 -to 0 tx_n
create_bd_port -dir I tx_sync

create_bd_port -dir I dac_fifo_bypass

# dma clock

set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {150}] $sys_ps7

set sys_dma_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_dma_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_dma_rstgen

ad_connect  sys_dma_clk sys_ps7/FCLK_CLK2
ad_connect  sys_dma_reset sys_dma_rstgen/peripheral_reset
ad_connect  sys_dma_resetn sys_dma_rstgen/peripheral_aresetn
ad_connect  sys_dma_clk sys_dma_rstgen/slowest_sync_clk
ad_connect  sys_dma_rstgen/ext_reset_in sys_ps7/FCLK_RESET2_N

# dac peripherals

set axi_ad9371_tx_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9371_tx_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.ASYNC_CLK_DEST_REQ {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.ASYNC_CLK_SRC_DEST {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.ASYNC_CLK_REQ_SRC {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {128}] $axi_ad9371_tx_dma

p_sys_dacfifo [current_bd_instance .] axi_ad9371_tx_fifo 128 17

set util_ad9371_tx_upack [create_bd_cell -type ip -vlnv analog.com:user:util_upack:1.0 util_ad9371_tx_upack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {32}] $util_ad9371_tx_upack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9371_tx_upack

set axi_ad9371_tx_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9371_tx_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {1}] $axi_ad9371_tx_jesd
set_property -dict [list CONFIG.C_LANES {4}] $axi_ad9371_tx_jesd

# adc peripherals

set axi_ad9371_rx_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9371_rx_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9371_rx_jesd
set_property -dict [list CONFIG.C_LANES {2}] $axi_ad9371_rx_jesd

set axi_ad9371_rx_os_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9371_rx_os_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9371_rx_os_jesd
set_property -dict [list CONFIG.C_LANES {2}] $axi_ad9371_rx_os_jesd

set axi_ad9371_rx_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9371_rx_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.ASYNC_CLK_DEST_REQ {1}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.ASYNC_CLK_SRC_DEST {1}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.ASYNC_CLK_REQ_SRC {1}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9371_rx_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_ad9371_rx_dma

set axi_ad9371_rx_os_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9371_rx_os_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.ASYNC_CLK_DEST_REQ {1}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.ASYNC_CLK_SRC_DEST {1}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.ASYNC_CLK_REQ_SRC {1}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9371_rx_os_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_ad9371_rx_os_dma

set util_ad9371_rx_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_ad9371_rx_cpack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_ad9371_rx_cpack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9371_rx_cpack

set util_ad9371_rx_os_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_ad9371_rx_os_cpack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {32}] $util_ad9371_rx_os_cpack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_ad9371_rx_os_cpack

# ad9371 gt & core

set axi_ad9371_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9371:1.0 axi_ad9371_core]

set axi_ad9371_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_ad9371_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {4}] $axi_ad9371_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {4}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {4}] $axi_ad9371_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_ad9371_gt
set_property -dict [list CONFIG.CPLL_FBDIV_0 {4}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_OUT_DIV_0 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {5}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_0 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff20400020}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_OUT_DIV_0 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_0 {5}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_0 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_DATA_SEL_0 {3}] $axi_ad9371_gt
set_property -dict [list CONFIG.PMA_RSV_1 {0x00018480}] $axi_ad9371_gt
set_property -dict [list CONFIG.CPLL_FBDIV_1 {4}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_OUT_DIV_1 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_1 {5}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_1 {0}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CDR_CFG_1 {0x03000023ff20400020}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_OUT_DIV_1 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_1 {5}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_1 {0}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_DATA_SEL_1 {0}] $axi_ad9371_gt
set_property -dict [list CONFIG.PMA_RSV_2 {0x00018480}] $axi_ad9371_gt
set_property -dict [list CONFIG.CPLL_FBDIV_2 {4}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_OUT_DIV_2 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_2 {5}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_2 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CDR_CFG_2 {0x03000023ff20400020}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_OUT_DIV_2 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_2 {5}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_2 {0}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_DATA_SEL_2 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.PMA_RSV_3 {0x00018480}] $axi_ad9371_gt
set_property -dict [list CONFIG.CPLL_FBDIV_3 {4}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_OUT_DIV_3 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_3 {5}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_3 {0}] $axi_ad9371_gt
set_property -dict [list CONFIG.RX_CDR_CFG_3 {0x03000023ff20400020}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_OUT_DIV_3 {1}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_3 {5}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_3 {0}] $axi_ad9371_gt
set_property -dict [list CONFIG.TX_DATA_SEL_3 {2}] $axi_ad9371_gt

set util_ad9371_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_ad9371_gt]
set_property -dict [list CONFIG.QPLL0_ENABLE {1}] $util_ad9371_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $util_ad9371_gt
set_property -dict [list CONFIG.NUM_OF_LANES {4}] $util_ad9371_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_ad9371_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {2}] $util_ad9371_gt
set_property -dict [list CONFIG.TX_ENABLE {1}] $util_ad9371_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {4}] $util_ad9371_gt

set util_ad9371_os_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_ad9371_os_gt]
set_property -dict [list CONFIG.QPLL0_ENABLE {0}] $util_ad9371_os_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $util_ad9371_os_gt
set_property -dict [list CONFIG.NUM_OF_LANES {2}] $util_ad9371_os_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_ad9371_os_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {2}] $util_ad9371_os_gt
set_property -dict [list CONFIG.TX_ENABLE {0}] $util_ad9371_os_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {2}] $util_ad9371_os_gt

# ad9371 data path clocks

set axi_tx_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_tx_clkgen]
set_property -dict [list CONFIG.ID {2}] $axi_tx_clkgen
set_property -dict [list CONFIG.CLKIN_PERIOD {8.0}] $axi_tx_clkgen
set_property -dict [list CONFIG.VCO_DIV {1}] $axi_tx_clkgen
set_property -dict [list CONFIG.VCO_MUL {8}] $axi_tx_clkgen
set_property -dict [list CONFIG.CLK0_DIV {8}] $axi_tx_clkgen

set axi_rx_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_rx_clkgen]
set_property -dict [list CONFIG.ID {2}] $axi_rx_clkgen
set_property -dict [list CONFIG.CLKIN_PERIOD {8.0}] $axi_rx_clkgen
set_property -dict [list CONFIG.VCO_DIV {1}] $axi_rx_clkgen
set_property -dict [list CONFIG.VCO_MUL {8}] $axi_rx_clkgen
set_property -dict [list CONFIG.CLK0_DIV {8}] $axi_rx_clkgen

set axi_rx_os_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_rx_os_clkgen]
set_property -dict [list CONFIG.ID {2}] $axi_rx_os_clkgen
set_property -dict [list CONFIG.CLKIN_PERIOD {8.0}] $axi_rx_os_clkgen
set_property -dict [list CONFIG.VCO_DIV {1}] $axi_rx_os_clkgen
set_property -dict [list CONFIG.VCO_MUL {8}] $axi_rx_os_clkgen
set_property -dict [list CONFIG.CLK0_DIV {8}] $axi_rx_os_clkgen

# connections (gt)

ad_connect  util_ad9371_gt/qpll_ref_clk rx_ref_clk
ad_connect  util_ad9371_gt/cpll_ref_clk tx_ref_clk
ad_connect  util_ad9371_os_gt/qpll_ref_clk rx_ref_clk
ad_connect  util_ad9371_os_gt/cpll_ref_clk tx_ref_clk

ad_connect  axi_ad9371_gt/gt_qpll_0 util_ad9371_gt/gt_qpll_0
ad_connect  axi_ad9371_gt/gt_pll_0 util_ad9371_gt/gt_pll_0
ad_connect  axi_ad9371_gt/gt_pll_1 util_ad9371_gt/gt_pll_1
ad_connect  axi_ad9371_gt/gt_pll_2 util_ad9371_gt/gt_pll_2
ad_connect  axi_ad9371_gt/gt_pll_3 util_ad9371_gt/gt_pll_3
ad_connect  axi_ad9371_gt/gt_rx_0 util_ad9371_gt/gt_rx_0
ad_connect  axi_ad9371_gt/gt_rx_1 util_ad9371_gt/gt_rx_1
ad_connect  axi_ad9371_gt/gt_rx_ip_0 axi_ad9371_rx_jesd/gt0_rx
ad_connect  axi_ad9371_gt/gt_rx_ip_1 axi_ad9371_rx_jesd/gt1_rx
ad_connect  axi_ad9371_gt/rx_gt_comma_align_enb_0 axi_ad9371_rx_jesd/rxencommaalign_out
ad_connect  axi_ad9371_gt/rx_gt_comma_align_enb_1 axi_ad9371_rx_jesd/rxencommaalign_out
ad_connect  axi_ad9371_gt/gt_rx_2 util_ad9371_os_gt/gt_rx_0
ad_connect  axi_ad9371_gt/gt_rx_3 util_ad9371_os_gt/gt_rx_1
ad_connect  axi_ad9371_gt/gt_rx_ip_2 axi_ad9371_rx_os_jesd/gt0_rx
ad_connect  axi_ad9371_gt/gt_rx_ip_3 axi_ad9371_rx_os_jesd/gt1_rx
ad_connect  axi_ad9371_gt/rx_gt_comma_align_enb_2 axi_ad9371_rx_os_jesd/rxencommaalign_out
ad_connect  axi_ad9371_gt/rx_gt_comma_align_enb_3 axi_ad9371_rx_os_jesd/rxencommaalign_out
ad_connect  axi_ad9371_gt/gt_tx_0 util_ad9371_gt/gt_tx_0
ad_connect  axi_ad9371_gt/gt_tx_1 util_ad9371_gt/gt_tx_1
ad_connect  axi_ad9371_gt/gt_tx_2 util_ad9371_gt/gt_tx_2
ad_connect  axi_ad9371_gt/gt_tx_3 util_ad9371_gt/gt_tx_3
ad_connect  axi_ad9371_gt/gt_tx_ip_0 axi_ad9371_tx_jesd/gt0_tx
ad_connect  axi_ad9371_gt/gt_tx_ip_1 axi_ad9371_tx_jesd/gt1_tx
ad_connect  axi_ad9371_gt/gt_tx_ip_2 axi_ad9371_tx_jesd/gt2_tx
ad_connect  axi_ad9371_gt/gt_tx_ip_3 axi_ad9371_tx_jesd/gt3_tx

# connections (dac)

ad_connect  util_ad9371_gt/tx_sysref tx_sysref
ad_connect  util_ad9371_gt/tx_p tx_p
ad_connect  util_ad9371_gt/tx_n tx_n
ad_connect  util_ad9371_gt/tx_sync tx_sync
ad_connect  util_ad9371_gt/tx_out_clk axi_tx_clkgen/clk
ad_connect  axi_tx_clkgen/clk_0 util_ad9371_gt/tx_clk
ad_connect  axi_tx_clkgen/clk_0 axi_ad9371_tx_jesd/tx_core_clk
ad_connect  util_ad9371_gt/tx_ip_rst axi_ad9371_tx_jesd/tx_reset
ad_connect  util_ad9371_gt/tx_ip_rst_done axi_ad9371_tx_jesd/tx_reset_done
ad_connect  util_ad9371_gt/tx_ip_sysref axi_ad9371_tx_jesd/tx_sysref
ad_connect  util_ad9371_gt/tx_ip_sync axi_ad9371_tx_jesd/tx_sync
ad_connect  util_ad9371_gt/tx_ip_data axi_ad9371_tx_jesd/tx_tdata
ad_connect  axi_tx_clkgen/clk_0 axi_ad9371_core/dac_clk
ad_connect  util_ad9371_gt/tx_data axi_ad9371_core/dac_tx_data
ad_connect  axi_tx_clkgen/clk_0 util_ad9371_tx_upack/dac_clk
ad_connect  axi_ad9371_core/dac_valid_i0 util_ad9371_tx_upack/dac_valid_0
ad_connect  axi_ad9371_core/dac_enable_i0 util_ad9371_tx_upack/dac_enable_0
ad_connect  axi_ad9371_core/dac_data_i0 util_ad9371_tx_upack/dac_data_0
ad_connect  axi_ad9371_core/dac_valid_q0 util_ad9371_tx_upack/dac_valid_1
ad_connect  axi_ad9371_core/dac_enable_q0 util_ad9371_tx_upack/dac_enable_1
ad_connect  axi_ad9371_core/dac_data_q0 util_ad9371_tx_upack/dac_data_1
ad_connect  axi_ad9371_core/dac_valid_i1 util_ad9371_tx_upack/dac_valid_2
ad_connect  axi_ad9371_core/dac_enable_i1 util_ad9371_tx_upack/dac_enable_2
ad_connect  axi_ad9371_core/dac_data_i1 util_ad9371_tx_upack/dac_data_2
ad_connect  axi_ad9371_core/dac_valid_q1 util_ad9371_tx_upack/dac_valid_3
ad_connect  axi_ad9371_core/dac_enable_q1 util_ad9371_tx_upack/dac_enable_3
ad_connect  axi_ad9371_core/dac_data_q1 util_ad9371_tx_upack/dac_data_3
ad_connect  util_ad9371_tx_upack/dma_xfer_in axi_ad9371_tx_fifo/dac_xfer_out
ad_connect  axi_tx_clkgen/clk_0 axi_ad9371_tx_fifo/dac_clk
ad_connect  util_ad9371_tx_upack/dac_valid axi_ad9371_tx_fifo/dac_valid
ad_connect  util_ad9371_tx_upack/dac_data axi_ad9371_tx_fifo/dac_data
ad_connect  axi_tx_clkgen/clk_0 axi_ad9371_tx_fifo/dma_clk
ad_connect  util_ad9371_gt/tx_rst axi_ad9371_tx_fifo/dma_rst
ad_connect  axi_tx_clkgen/clk_0 axi_ad9371_tx_dma/m_axis_aclk
ad_connect  sys_dma_resetn axi_ad9371_tx_dma/m_src_axi_aresetn
ad_connect  axi_ad9371_tx_fifo/dma_xfer_req axi_ad9371_tx_dma/m_axis_xfer_req
ad_connect  axi_ad9371_tx_fifo/dma_ready axi_ad9371_tx_dma/m_axis_ready
ad_connect  axi_ad9371_tx_fifo/dma_data axi_ad9371_tx_dma/m_axis_data
ad_connect  axi_ad9371_tx_fifo/dma_valid axi_ad9371_tx_dma/m_axis_valid
ad_connect  axi_ad9371_tx_fifo/dma_xfer_last axi_ad9371_tx_dma/m_axis_last

# connections (adc)

ad_connect  util_ad9371_gt/rx_sysref rx_sysref
ad_connect  util_ad9371_gt/rx_p rx_p
ad_connect  util_ad9371_gt/rx_n rx_n
ad_connect  util_ad9371_gt/rx_sync rx_sync
ad_connect  util_ad9371_os_gt/rx_p rx_os_p
ad_connect  util_ad9371_os_gt/rx_n rx_os_n
ad_connect  util_ad9371_os_gt/rx_sysref rx_sysref
ad_connect  util_ad9371_os_gt/rx_sync rx_os_sync
ad_connect  util_ad9371_gt/rx_out_clk axi_rx_clkgen/clk
ad_connect  axi_rx_clkgen/clk_0 util_ad9371_gt/rx_clk
ad_connect  axi_rx_clkgen/clk_0 axi_ad9371_rx_jesd/rx_core_clk
ad_connect  util_ad9371_gt/rx_ip_rst axi_ad9371_rx_jesd/rx_reset
ad_connect  util_ad9371_gt/rx_ip_rst_done axi_ad9371_rx_jesd/rx_reset_done
ad_connect  util_ad9371_gt/rx_ip_sysref axi_ad9371_rx_jesd/rx_sysref
ad_connect  util_ad9371_gt/rx_ip_sync axi_ad9371_rx_jesd/rx_sync
ad_connect  util_ad9371_gt/rx_ip_sof axi_ad9371_rx_jesd/rx_start_of_frame
ad_connect  util_ad9371_gt/rx_ip_data axi_ad9371_rx_jesd/rx_tdata
ad_connect  util_ad9371_os_gt/rx_out_clk axi_rx_os_clkgen/clk
ad_connect  axi_rx_os_clkgen/clk_0 util_ad9371_os_gt/rx_clk
ad_connect  axi_rx_os_clkgen/clk_0 axi_ad9371_rx_os_jesd/rx_core_clk
ad_connect  util_ad9371_os_gt/rx_ip_rst axi_ad9371_rx_os_jesd/rx_reset
ad_connect  util_ad9371_os_gt/rx_ip_rst_done axi_ad9371_rx_os_jesd/rx_reset_done
ad_connect  util_ad9371_os_gt/rx_ip_sysref axi_ad9371_rx_os_jesd/rx_sysref
ad_connect  util_ad9371_os_gt/rx_ip_sync axi_ad9371_rx_os_jesd/rx_sync
ad_connect  util_ad9371_os_gt/rx_ip_sof axi_ad9371_rx_jesd/rx_start_of_frame
ad_connect  util_ad9371_os_gt/rx_ip_data axi_ad9371_rx_os_jesd/rx_tdata
ad_connect  axi_rx_clkgen/clk_0 axi_ad9371_core/adc_clk
ad_connect  util_ad9371_gt/rx_data axi_ad9371_core/adc_rx_data
ad_connect  axi_rx_os_clkgen/clk_0 axi_ad9371_core/adc_os_clk
ad_connect  util_ad9371_os_gt/rx_data axi_ad9371_core/adc_rx_os_data
ad_connect  axi_rx_clkgen/clk_0 util_ad9371_rx_cpack/adc_clk
ad_connect  util_ad9371_gt/rx_rst util_ad9371_rx_cpack/adc_rst
ad_connect  axi_ad9371_core/adc_enable_i0 util_ad9371_rx_cpack/adc_enable_0
ad_connect  axi_ad9371_core/adc_valid_i0 util_ad9371_rx_cpack/adc_valid_0
ad_connect  axi_ad9371_core/adc_data_i0 util_ad9371_rx_cpack/adc_data_0
ad_connect  axi_ad9371_core/adc_enable_q0 util_ad9371_rx_cpack/adc_enable_1
ad_connect  axi_ad9371_core/adc_valid_q0 util_ad9371_rx_cpack/adc_valid_1
ad_connect  axi_ad9371_core/adc_data_q0 util_ad9371_rx_cpack/adc_data_1
ad_connect  axi_ad9371_core/adc_enable_i1 util_ad9371_rx_cpack/adc_enable_2
ad_connect  axi_ad9371_core/adc_valid_i1 util_ad9371_rx_cpack/adc_valid_2
ad_connect  axi_ad9371_core/adc_data_i1 util_ad9371_rx_cpack/adc_data_2
ad_connect  axi_ad9371_core/adc_enable_q1 util_ad9371_rx_cpack/adc_enable_3
ad_connect  axi_ad9371_core/adc_valid_q1 util_ad9371_rx_cpack/adc_valid_3
ad_connect  axi_ad9371_core/adc_data_q1 util_ad9371_rx_cpack/adc_data_3
ad_connect  axi_rx_clkgen/clk_0 axi_ad9371_rx_dma/fifo_wr_clk
ad_connect  sys_dma_resetn axi_ad9371_rx_dma/m_dest_axi_aresetn
ad_connect  util_ad9371_rx_cpack/adc_valid axi_ad9371_rx_dma/fifo_wr_en
ad_connect  util_ad9371_rx_cpack/adc_sync axi_ad9371_rx_dma/fifo_wr_sync
ad_connect  util_ad9371_rx_cpack/adc_data axi_ad9371_rx_dma/fifo_wr_din
ad_connect  axi_ad9371_rx_dma/fifo_wr_overflow axi_ad9371_core/adc_dovf
ad_connect  axi_rx_os_clkgen/clk_0 util_ad9371_rx_os_cpack/adc_clk
ad_connect  util_ad9371_os_gt/rx_rst util_ad9371_rx_os_cpack/adc_rst
ad_connect  axi_ad9371_core/adc_os_enable_i0 util_ad9371_rx_os_cpack/adc_enable_0
ad_connect  axi_ad9371_core/adc_os_valid_i0 util_ad9371_rx_os_cpack/adc_valid_0
ad_connect  axi_ad9371_core/adc_os_data_i0 util_ad9371_rx_os_cpack/adc_data_0
ad_connect  axi_ad9371_core/adc_os_enable_q0 util_ad9371_rx_os_cpack/adc_enable_1
ad_connect  axi_ad9371_core/adc_os_valid_q0 util_ad9371_rx_os_cpack/adc_valid_1
ad_connect  axi_ad9371_core/adc_os_data_q0 util_ad9371_rx_os_cpack/adc_data_1
ad_connect  axi_rx_os_clkgen/clk_0 axi_ad9371_rx_os_dma/fifo_wr_clk
ad_connect  sys_dma_resetn axi_ad9371_rx_os_dma/m_dest_axi_aresetn
ad_connect  util_ad9371_rx_os_cpack/adc_valid axi_ad9371_rx_os_dma/fifo_wr_en
ad_connect  util_ad9371_rx_os_cpack/adc_sync axi_ad9371_rx_os_dma/fifo_wr_sync
ad_connect  util_ad9371_rx_os_cpack/adc_data axi_ad9371_rx_os_dma/fifo_wr_din
ad_connect  axi_ad9371_rx_os_dma/fifo_wr_overflow axi_ad9371_core/adc_os_dovf
ad_connect  axi_ad9371_tx_fifo/dac_fifo_bypass dac_fifo_bypass

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9371_gt
ad_cpu_interconnect 0x44A00000 axi_ad9371_core
ad_cpu_interconnect 0x43C00000 axi_tx_clkgen
ad_cpu_interconnect 0x44A90000 axi_ad9371_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9371_tx_dma
ad_cpu_interconnect 0x43C10000 axi_rx_clkgen
ad_cpu_interconnect 0x43C20000 axi_rx_os_clkgen
ad_cpu_interconnect 0x44A91000 axi_ad9371_rx_jesd
ad_cpu_interconnect 0x44A92000 axi_ad9371_rx_os_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9371_rx_dma
ad_cpu_interconnect 0x7c440000 axi_ad9371_rx_os_dma

# gt uses hp0, and 100MHz clock for both DRP and AXI4

ad_mem_hp0_interconnect sys_cpu_clk axi_ad9371_gt/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_dma_clk axi_ad9371_tx_dma/m_src_axi
ad_mem_hp2_interconnect sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_dma_clk axi_ad9371_rx_dma/m_dest_axi
ad_mem_hp2_interconnect sys_dma_clk axi_ad9371_rx_os_dma/m_dest_axi

ad_disconnect sys_cpu_resetn axi_hp1_interconnect/ARESETN
ad_disconnect sys_cpu_resetn axi_hp1_interconnect/M00_ARESETN
ad_disconnect sys_cpu_resetn axi_hp1_interconnect/S00_ARESETN
ad_disconnect sys_cpu_resetn axi_hp2_interconnect/ARESETN
ad_disconnect sys_cpu_resetn axi_hp2_interconnect/M00_ARESETN
ad_disconnect sys_cpu_resetn axi_hp2_interconnect/S00_ARESETN
ad_disconnect sys_cpu_resetn axi_hp2_interconnect/S01_ARESETN

ad_connect  sys_dma_resetn axi_hp1_interconnect/ARESETN
ad_connect  sys_dma_resetn axi_hp1_interconnect/M00_ARESETN
ad_connect  sys_dma_resetn axi_hp1_interconnect/S00_ARESETN
ad_connect  sys_dma_resetn axi_hp2_interconnect/ARESETN
ad_connect  sys_dma_resetn axi_hp2_interconnect/M00_ARESETN
ad_connect  sys_dma_resetn axi_hp2_interconnect/S00_ARESETN
ad_connect  sys_dma_resetn axi_hp2_interconnect/S01_ARESETN

# interrupts

ad_cpu_interrupt ps-11 mb-11 axi_ad9371_rx_os_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9371_tx_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9371_rx_dma/irq

# ila

set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.0 ila_adc]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc
set_property -dict [list CONFIG.C_NUM_OF_PROBES {4}] $ila_adc
set_property -dict [list CONFIG.C_PROBE0_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE2_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE3_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]  $ila_adc
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc

ad_connect  axi_rx_clkgen/clk_0                   ila_adc/clk
ad_connect  axi_ad9371_core/adc_data_i0           ila_adc/probe0
ad_connect  axi_ad9371_core/adc_data_q0           ila_adc/probe1
ad_connect  axi_ad9371_core/adc_data_i1           ila_adc/probe2
ad_connect  axi_ad9371_core/adc_data_q1           ila_adc/probe3

set bsplit_os_adc_0 [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 bsplit_os_adc_0]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $bsplit_os_adc_0
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $bsplit_os_adc_0

set bsplit_os_adc_1 [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 bsplit_os_adc_1]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $bsplit_os_adc_1
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $bsplit_os_adc_1

set ila_os_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.0 ila_os_adc]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_os_adc
set_property -dict [list CONFIG.C_NUM_OF_PROBES {6}] $ila_os_adc
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_os_adc
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_os_adc
set_property -dict [list CONFIG.C_PROBE2_WIDTH {16}] $ila_os_adc
set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] $ila_os_adc
set_property -dict [list CONFIG.C_PROBE4_WIDTH {16}] $ila_os_adc
set_property -dict [list CONFIG.C_PROBE5_WIDTH {16}] $ila_os_adc
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]  $ila_os_adc
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_os_adc

ad_connect  axi_ad9371_core/adc_os_data_i0        bsplit_os_adc_0/data
ad_connect  axi_ad9371_core/adc_os_data_q0        bsplit_os_adc_1/data
ad_connect  axi_rx_os_clkgen/clk_0                ila_os_adc/clk
ad_connect  axi_ad9371_core/adc_os_valid_i0       ila_os_adc/probe0
ad_connect  bsplit_os_adc_0/split_data_0          ila_os_adc/probe1
ad_connect  bsplit_os_adc_0/split_data_1          ila_os_adc/probe2
ad_connect  axi_ad9371_core/adc_os_valid_q0       ila_os_adc/probe3
ad_connect  bsplit_os_adc_1/split_data_0          ila_os_adc/probe4
ad_connect  bsplit_os_adc_1/split_data_1          ila_os_adc/probe5

