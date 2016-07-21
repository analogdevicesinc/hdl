
# fmcomms11

create_bd_port -dir I sysref

create_bd_port -dir I rx_ref_clk
create_bd_port -dir O rx_sync
create_bd_port -dir I -from 7 -to 0 rx_data_p
create_bd_port -dir I -from 7 -to 0 rx_data_n

create_bd_port -dir I tx_ref_clk
create_bd_port -dir I tx_sync
create_bd_port -dir O -from 7 -to 0 tx_data_p
create_bd_port -dir O -from 7 -to 0 tx_data_n

# dac peripherals

set axi_ad9162_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9162:1.0 axi_ad9162_core]

set axi_ad9162_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9162_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {1}] $axi_ad9162_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9162_jesd

set axi_ad9162_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9162_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9162_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {1}] $axi_ad9162_dma
set_property -dict [list CONFIG.ID {1}] $axi_ad9162_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9162_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9162_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_ad9162_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9162_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9162_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {256}] $axi_ad9162_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {256}] $axi_ad9162_dma

# adc peripherals

set axi_ad9625_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_core]

set axi_ad9625_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9625_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_jesd

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

# dac/adc common gt

set axi_fmcomms11_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_fmcomms11_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL0_ENABLE {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL0_REFCLK_DIV {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL1_REFCLK_DIV {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL0_CFG {0x0680181}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL1_CFG {0x0680181}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL0_FBDIV_RATIO {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL1_FBDIV_RATIO {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {8}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_0 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_0 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL0_FBDIV {"0100100000"}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.QPLL1_FBDIV {"0100100000"}] $axi_fmcomms11_gt   
set_property -dict [list CONFIG.CPLL_FBDIV_0 {4}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_OUT_DIV_0 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_OUT_DIV_0 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_0 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff10400020}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.CPLL_FBDIV_1 {4}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_OUT_DIV_1 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_OUT_DIV_1 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_1 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_1 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.PMA_RSV_1 {0x00018480}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CDR_CFG_1 {0x03000023ff10400020}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.CPLL_FBDIV_2 {4}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_OUT_DIV_2 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_OUT_DIV_2 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_2 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_2 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.PMA_RSV_2 {0x00018480}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CDR_CFG_2 {0x03000023ff10400020}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.CPLL_FBDIV_3 {4}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_OUT_DIV_3 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_OUT_DIV_3 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_3 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_3 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.PMA_RSV_3 {0x00018480}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CDR_CFG_3 {0x03000023ff10400020}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.CPLL_FBDIV_4 {4}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_OUT_DIV_4 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_OUT_DIV_4 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_4 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_4 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.PMA_RSV_4 {0x00018480}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CDR_CFG_4 {0x03000023ff10400020}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.CPLL_FBDIV_5 {4}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_OUT_DIV_5 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_OUT_DIV_5 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_5 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_5 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.PMA_RSV_5 {0x00018480}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CDR_CFG_5 {0x03000023ff10400020}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.CPLL_FBDIV_6 {4}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_OUT_DIV_6 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_OUT_DIV_6 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_6 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_6 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.PMA_RSV_6 {0x00018480}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CDR_CFG_6 {0x03000023ff10400020}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.CPLL_FBDIV_7 {4}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_OUT_DIV_7 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_OUT_DIV_7 {1}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_7 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_7 {7}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.PMA_RSV_7 {0x00018480}] $axi_fmcomms11_gt
set_property -dict [list CONFIG.RX_CDR_CFG_7 {0x03000023ff10400020}] $axi_fmcomms11_gt

set util_fmcomms11_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_fmcomms11_gt]
set_property -dict [list CONFIG.QPLL0_ENABLE {1}] $util_fmcomms11_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {1}] $util_fmcomms11_gt
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $util_fmcomms11_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_fmcomms11_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_fmcomms11_gt
set_property -dict [list CONFIG.TX_ENABLE {1}] $util_fmcomms11_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {8}] $util_fmcomms11_gt

# connections (gt)

ad_connect  util_fmcomms11_gt/qpll_ref_clk tx_ref_clk
ad_connect  util_fmcomms11_gt/cpll_ref_clk tx_ref_clk

ad_connect  axi_fmcomms11_gt/gt_qpll_0 util_fmcomms11_gt/gt_qpll_0
ad_connect  axi_fmcomms11_gt/gt_qpll_1 util_fmcomms11_gt/gt_qpll_1
ad_connect  axi_fmcomms11_gt/gt_pll_0 util_fmcomms11_gt/gt_pll_0
ad_connect  axi_fmcomms11_gt/gt_pll_1 util_fmcomms11_gt/gt_pll_1
ad_connect  axi_fmcomms11_gt/gt_pll_2 util_fmcomms11_gt/gt_pll_2
ad_connect  axi_fmcomms11_gt/gt_pll_3 util_fmcomms11_gt/gt_pll_3
ad_connect  axi_fmcomms11_gt/gt_pll_4 util_fmcomms11_gt/gt_pll_4
ad_connect  axi_fmcomms11_gt/gt_pll_5 util_fmcomms11_gt/gt_pll_5
ad_connect  axi_fmcomms11_gt/gt_pll_6 util_fmcomms11_gt/gt_pll_6
ad_connect  axi_fmcomms11_gt/gt_pll_7 util_fmcomms11_gt/gt_pll_7
ad_connect  axi_fmcomms11_gt/gt_rx_0 util_fmcomms11_gt/gt_rx_0
ad_connect  axi_fmcomms11_gt/gt_rx_1 util_fmcomms11_gt/gt_rx_1
ad_connect  axi_fmcomms11_gt/gt_rx_2 util_fmcomms11_gt/gt_rx_2
ad_connect  axi_fmcomms11_gt/gt_rx_3 util_fmcomms11_gt/gt_rx_3
ad_connect  axi_fmcomms11_gt/gt_rx_4 util_fmcomms11_gt/gt_rx_4
ad_connect  axi_fmcomms11_gt/gt_rx_5 util_fmcomms11_gt/gt_rx_5
ad_connect  axi_fmcomms11_gt/gt_rx_6 util_fmcomms11_gt/gt_rx_6
ad_connect  axi_fmcomms11_gt/gt_rx_7 util_fmcomms11_gt/gt_rx_7
ad_connect  axi_fmcomms11_gt/gt_rx_ip_0 axi_ad9625_jesd/gt0_rx
ad_connect  axi_fmcomms11_gt/gt_rx_ip_1 axi_ad9625_jesd/gt1_rx
ad_connect  axi_fmcomms11_gt/gt_rx_ip_2 axi_ad9625_jesd/gt2_rx
ad_connect  axi_fmcomms11_gt/gt_rx_ip_3 axi_ad9625_jesd/gt3_rx
ad_connect  axi_fmcomms11_gt/gt_rx_ip_4 axi_ad9625_jesd/gt4_rx
ad_connect  axi_fmcomms11_gt/gt_rx_ip_5 axi_ad9625_jesd/gt5_rx
ad_connect  axi_fmcomms11_gt/gt_rx_ip_6 axi_ad9625_jesd/gt6_rx
ad_connect  axi_fmcomms11_gt/gt_rx_ip_7 axi_ad9625_jesd/gt7_rx
ad_connect  axi_fmcomms11_gt/rx_gt_comma_align_enb_0 axi_ad9625_jesd/rxencommaalign_out
ad_connect  axi_fmcomms11_gt/rx_gt_comma_align_enb_1 axi_ad9625_jesd/rxencommaalign_out
ad_connect  axi_fmcomms11_gt/rx_gt_comma_align_enb_2 axi_ad9625_jesd/rxencommaalign_out
ad_connect  axi_fmcomms11_gt/rx_gt_comma_align_enb_3 axi_ad9625_jesd/rxencommaalign_out
ad_connect  axi_fmcomms11_gt/rx_gt_comma_align_enb_4 axi_ad9625_jesd/rxencommaalign_out
ad_connect  axi_fmcomms11_gt/rx_gt_comma_align_enb_5 axi_ad9625_jesd/rxencommaalign_out
ad_connect  axi_fmcomms11_gt/rx_gt_comma_align_enb_6 axi_ad9625_jesd/rxencommaalign_out
ad_connect  axi_fmcomms11_gt/rx_gt_comma_align_enb_7 axi_ad9625_jesd/rxencommaalign_out
ad_connect  axi_fmcomms11_gt/gt_tx_0 util_fmcomms11_gt/gt_tx_0
ad_connect  axi_fmcomms11_gt/gt_tx_1 util_fmcomms11_gt/gt_tx_1
ad_connect  axi_fmcomms11_gt/gt_tx_2 util_fmcomms11_gt/gt_tx_2
ad_connect  axi_fmcomms11_gt/gt_tx_3 util_fmcomms11_gt/gt_tx_3
ad_connect  axi_fmcomms11_gt/gt_tx_4 util_fmcomms11_gt/gt_tx_4
ad_connect  axi_fmcomms11_gt/gt_tx_5 util_fmcomms11_gt/gt_tx_5
ad_connect  axi_fmcomms11_gt/gt_tx_6 util_fmcomms11_gt/gt_tx_6
ad_connect  axi_fmcomms11_gt/gt_tx_7 util_fmcomms11_gt/gt_tx_7
ad_connect  axi_fmcomms11_gt/gt_tx_ip_0 axi_ad9162_jesd/gt0_tx
ad_connect  axi_fmcomms11_gt/gt_tx_ip_1 axi_ad9162_jesd/gt1_tx
ad_connect  axi_fmcomms11_gt/gt_tx_ip_2 axi_ad9162_jesd/gt2_tx
ad_connect  axi_fmcomms11_gt/gt_tx_ip_3 axi_ad9162_jesd/gt3_tx
ad_connect  axi_fmcomms11_gt/gt_tx_ip_4 axi_ad9162_jesd/gt4_tx
ad_connect  axi_fmcomms11_gt/gt_tx_ip_5 axi_ad9162_jesd/gt5_tx
ad_connect  axi_fmcomms11_gt/gt_tx_ip_6 axi_ad9162_jesd/gt6_tx
ad_connect  axi_fmcomms11_gt/gt_tx_ip_7 axi_ad9162_jesd/gt7_tx

# connections (dac)

ad_connect  util_fmcomms11_gt/tx_sysref sysref
ad_connect  util_fmcomms11_gt/tx_p tx_data_p
ad_connect  util_fmcomms11_gt/tx_n tx_data_n
ad_connect  util_fmcomms11_gt/tx_sync tx_sync
ad_connect  util_fmcomms11_gt/tx_out_clk util_fmcomms11_gt/tx_clk
ad_connect  util_fmcomms11_gt/tx_out_clk axi_ad9162_jesd/tx_core_clk
ad_connect  util_fmcomms11_gt/tx_ip_rst axi_ad9162_jesd/tx_reset
ad_connect  util_fmcomms11_gt/tx_ip_rst_done axi_ad9162_jesd/tx_reset_done
ad_connect  util_fmcomms11_gt/tx_ip_sysref axi_ad9162_jesd/tx_sysref
ad_connect  util_fmcomms11_gt/tx_ip_sync axi_ad9162_jesd/tx_sync
ad_connect  util_fmcomms11_gt/tx_ip_data axi_ad9162_jesd/tx_tdata
ad_connect  util_fmcomms11_gt/tx_out_clk axi_ad9162_core/tx_clk
ad_connect  util_fmcomms11_gt/tx_data axi_ad9162_core/tx_data
ad_connect  util_fmcomms11_gt/tx_out_clk axi_ad9162_fifo/dac_clk
ad_connect  axi_ad9162_core/dac_valid axi_ad9162_fifo/dac_valid
ad_connect  axi_ad9162_core/dac_ddata axi_ad9162_fifo/dac_data
ad_connect  sys_cpu_clk axi_ad9162_fifo/dma_clk
ad_connect  sys_cpu_reset axi_ad9162_fifo/dma_rst
ad_connect  sys_cpu_clk axi_ad9162_dma/m_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9162_dma/m_src_axi_aresetn
ad_connect  axi_ad9162_fifo/dma_xfer_req axi_ad9162_dma/m_axis_xfer_req
ad_connect  axi_ad9162_fifo/dma_ready axi_ad9162_dma/m_axis_ready
ad_connect  axi_ad9162_fifo/dma_data axi_ad9162_dma/m_axis_data
ad_connect  axi_ad9162_fifo/dma_valid axi_ad9162_dma/m_axis_valid
ad_connect  axi_ad9162_fifo/dma_xfer_last axi_ad9162_dma/m_axis_last

# connections (adc)

ad_connect  util_fmcomms11_gt/rx_sysref sysref
ad_connect  util_fmcomms11_gt/rx_p rx_data_p
ad_connect  util_fmcomms11_gt/rx_n rx_data_n
ad_connect  util_fmcomms11_gt/rx_sync rx_sync
ad_connect  util_fmcomms11_gt/rx_out_clk util_fmcomms11_gt/rx_clk
ad_connect  util_fmcomms11_gt/rx_out_clk axi_ad9625_jesd/rx_core_clk
ad_connect  util_fmcomms11_gt/rx_ip_rst axi_ad9625_jesd/rx_reset
ad_connect  util_fmcomms11_gt/rx_ip_rst_done axi_ad9625_jesd/rx_reset_done
ad_connect  util_fmcomms11_gt/rx_ip_sysref axi_ad9625_jesd/rx_sysref
ad_connect  util_fmcomms11_gt/rx_ip_sync axi_ad9625_jesd/rx_sync
ad_connect  util_fmcomms11_gt/rx_ip_sof axi_ad9625_jesd/rx_start_of_frame
ad_connect  util_fmcomms11_gt/rx_ip_data axi_ad9625_jesd/rx_tdata
ad_connect  util_fmcomms11_gt/rx_out_clk axi_ad9625_core/rx_clk
ad_connect  util_fmcomms11_gt/rx_data axi_ad9625_core/rx_data
ad_connect  axi_ad9625_core/adc_raddr_in GND
ad_connect  axi_ad9625_core/adc_dunf GND
ad_connect  util_fmcomms11_gt/rx_out_clk axi_ad9625_fifo/adc_clk
ad_connect  util_fmcomms11_gt/rx_rst axi_ad9625_fifo/adc_rst
ad_connect  axi_ad9625_core/adc_valid axi_ad9625_fifo/adc_wr
ad_connect  axi_ad9625_core/adc_data axi_ad9625_fifo/adc_wdata
ad_connect  sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn
ad_connect  axi_ad9625_fifo/dma_wr axi_ad9625_dma/s_axis_valid
ad_connect  axi_ad9625_fifo/dma_wdata axi_ad9625_dma/s_axis_data
ad_connect  axi_ad9625_fifo/dma_wready axi_ad9625_dma/s_axis_ready
ad_connect  axi_ad9625_fifo/dma_xfer_req axi_ad9625_dma/s_axis_xfer_req
ad_connect  axi_ad9625_core/adc_dovf axi_ad9625_fifo/adc_wovf

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_fmcomms11_gt
ad_cpu_interconnect 0x44A00000 axi_ad9162_core
ad_cpu_interconnect 0x44A90000 axi_ad9162_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9162_dma
ad_cpu_interconnect 0x44A10000 axi_ad9625_core
ad_cpu_interconnect 0x44A91000 axi_ad9625_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9625_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_fmcomms11_gt/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9162_dma/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad9162_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9625_dma/irq

# unused

ad_connect  axi_ad9162_fifo/dac_fifo_bypass GND

# ila

create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.0 ad9625_ila
set_property CONFIG.C_MONITOR_TYPE {Native} [get_bd_cells ad9625_ila]
set_property CONFIG.C_NUM_OF_PROBES {33} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE0_WIDTH  {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE1_WIDTH  {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE2_WIDTH  {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE3_WIDTH  {32} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE4_WIDTH  {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE5_WIDTH  {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE6_WIDTH  {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE7_WIDTH  {32} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE8_WIDTH  {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE9_WIDTH  {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE10_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE11_WIDTH {32} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE12_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE13_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE14_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE15_WIDTH {32} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE16_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE17_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE18_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE19_WIDTH {32} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE20_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE21_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE22_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE23_WIDTH {32} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE24_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE25_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE26_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE27_WIDTH {32} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE28_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE29_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE30_WIDTH {4}  [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE31_WIDTH {32} [get_bd_cells ad9625_ila]
set_property CONFIG.C_PROBE32_WIDTH {1}  [get_bd_cells ad9625_ila]

ad_connect  axi_ad9625_jesd/gt0_rxcharisk    axi_fmcomms11_gt/rx_gt_charisk_0   
ad_connect  axi_ad9625_jesd/gt0_rxdisperr    axi_fmcomms11_gt/rx_gt_disperr_0   
ad_connect  axi_ad9625_jesd/gt0_rxnotintable axi_fmcomms11_gt/rx_gt_notintable_0
ad_connect  axi_ad9625_jesd/gt0_rxdata       axi_fmcomms11_gt/rx_gt_data_0      
ad_connect  axi_ad9625_jesd/gt1_rxcharisk    axi_fmcomms11_gt/rx_gt_charisk_1   
ad_connect  axi_ad9625_jesd/gt1_rxdisperr    axi_fmcomms11_gt/rx_gt_disperr_1   
ad_connect  axi_ad9625_jesd/gt1_rxnotintable axi_fmcomms11_gt/rx_gt_notintable_1
ad_connect  axi_ad9625_jesd/gt1_rxdata       axi_fmcomms11_gt/rx_gt_data_1      
ad_connect  axi_ad9625_jesd/gt2_rxcharisk    axi_fmcomms11_gt/rx_gt_charisk_2   
ad_connect  axi_ad9625_jesd/gt2_rxdisperr    axi_fmcomms11_gt/rx_gt_disperr_2   
ad_connect  axi_ad9625_jesd/gt2_rxnotintable axi_fmcomms11_gt/rx_gt_notintable_2
ad_connect  axi_ad9625_jesd/gt2_rxdata       axi_fmcomms11_gt/rx_gt_data_2      
ad_connect  axi_ad9625_jesd/gt3_rxcharisk    axi_fmcomms11_gt/rx_gt_charisk_3   
ad_connect  axi_ad9625_jesd/gt3_rxdisperr    axi_fmcomms11_gt/rx_gt_disperr_3   
ad_connect  axi_ad9625_jesd/gt3_rxnotintable axi_fmcomms11_gt/rx_gt_notintable_3
ad_connect  axi_ad9625_jesd/gt3_rxdata       axi_fmcomms11_gt/rx_gt_data_3      
ad_connect  axi_ad9625_jesd/gt4_rxcharisk    axi_fmcomms11_gt/rx_gt_charisk_4   
ad_connect  axi_ad9625_jesd/gt4_rxdisperr    axi_fmcomms11_gt/rx_gt_disperr_4   
ad_connect  axi_ad9625_jesd/gt4_rxnotintable axi_fmcomms11_gt/rx_gt_notintable_4
ad_connect  axi_ad9625_jesd/gt4_rxdata       axi_fmcomms11_gt/rx_gt_data_4      
ad_connect  axi_ad9625_jesd/gt5_rxcharisk    axi_fmcomms11_gt/rx_gt_charisk_5   
ad_connect  axi_ad9625_jesd/gt5_rxdisperr    axi_fmcomms11_gt/rx_gt_disperr_5   
ad_connect  axi_ad9625_jesd/gt5_rxnotintable axi_fmcomms11_gt/rx_gt_notintable_5
ad_connect  axi_ad9625_jesd/gt5_rxdata       axi_fmcomms11_gt/rx_gt_data_5      
ad_connect  axi_ad9625_jesd/gt6_rxcharisk    axi_fmcomms11_gt/rx_gt_charisk_6   
ad_connect  axi_ad9625_jesd/gt6_rxdisperr    axi_fmcomms11_gt/rx_gt_disperr_6   
ad_connect  axi_ad9625_jesd/gt6_rxnotintable axi_fmcomms11_gt/rx_gt_notintable_6
ad_connect  axi_ad9625_jesd/gt6_rxdata       axi_fmcomms11_gt/rx_gt_data_6      
ad_connect  axi_ad9625_jesd/gt7_rxcharisk    axi_fmcomms11_gt/rx_gt_charisk_7   
ad_connect  axi_ad9625_jesd/gt7_rxdisperr    axi_fmcomms11_gt/rx_gt_disperr_7   
ad_connect  axi_ad9625_jesd/gt7_rxnotintable axi_fmcomms11_gt/rx_gt_notintable_7
ad_connect  axi_ad9625_jesd/gt7_rxdata       axi_fmcomms11_gt/rx_gt_data_7      

ad_connect  axi_fmcomms11_gt/rx_gt_charisk_0    ad9625_ila/probe0
ad_connect  axi_fmcomms11_gt/rx_gt_disperr_0    ad9625_ila/probe1
ad_connect  axi_fmcomms11_gt/rx_gt_notintable_0 ad9625_ila/probe2
ad_connect  axi_fmcomms11_gt/rx_gt_data_0       ad9625_ila/probe3
ad_connect  axi_fmcomms11_gt/rx_gt_charisk_1    ad9625_ila/probe4
ad_connect  axi_fmcomms11_gt/rx_gt_disperr_1    ad9625_ila/probe5
ad_connect  axi_fmcomms11_gt/rx_gt_notintable_1 ad9625_ila/probe6
ad_connect  axi_fmcomms11_gt/rx_gt_data_1       ad9625_ila/probe7
ad_connect  axi_fmcomms11_gt/rx_gt_charisk_2    ad9625_ila/probe8
ad_connect  axi_fmcomms11_gt/rx_gt_disperr_2    ad9625_ila/probe9
ad_connect  axi_fmcomms11_gt/rx_gt_notintable_2 ad9625_ila/probe10
ad_connect  axi_fmcomms11_gt/rx_gt_data_2       ad9625_ila/probe11
ad_connect  axi_fmcomms11_gt/rx_gt_charisk_3    ad9625_ila/probe12
ad_connect  axi_fmcomms11_gt/rx_gt_disperr_3    ad9625_ila/probe13
ad_connect  axi_fmcomms11_gt/rx_gt_notintable_3 ad9625_ila/probe14
ad_connect  axi_fmcomms11_gt/rx_gt_data_3       ad9625_ila/probe15
ad_connect  axi_fmcomms11_gt/rx_gt_charisk_4    ad9625_ila/probe16
ad_connect  axi_fmcomms11_gt/rx_gt_disperr_4    ad9625_ila/probe17
ad_connect  axi_fmcomms11_gt/rx_gt_notintable_4 ad9625_ila/probe18
ad_connect  axi_fmcomms11_gt/rx_gt_data_4       ad9625_ila/probe19
ad_connect  axi_fmcomms11_gt/rx_gt_charisk_5    ad9625_ila/probe20
ad_connect  axi_fmcomms11_gt/rx_gt_disperr_5    ad9625_ila/probe21
ad_connect  axi_fmcomms11_gt/rx_gt_notintable_5 ad9625_ila/probe22
ad_connect  axi_fmcomms11_gt/rx_gt_data_5       ad9625_ila/probe23
ad_connect  axi_fmcomms11_gt/rx_gt_charisk_6    ad9625_ila/probe24
ad_connect  axi_fmcomms11_gt/rx_gt_disperr_6    ad9625_ila/probe25
ad_connect  axi_fmcomms11_gt/rx_gt_notintable_6 ad9625_ila/probe26
ad_connect  axi_fmcomms11_gt/rx_gt_data_6       ad9625_ila/probe27
ad_connect  axi_fmcomms11_gt/rx_gt_charisk_7    ad9625_ila/probe28
ad_connect  axi_fmcomms11_gt/rx_gt_disperr_7    ad9625_ila/probe29
ad_connect  axi_fmcomms11_gt/rx_gt_notintable_7 ad9625_ila/probe30
ad_connect  axi_fmcomms11_gt/rx_gt_data_7       ad9625_ila/probe31
ad_connect  axi_ad9625_jesd/rx_sync             ad9625_ila/probe32
ad_connect  util_fmcomms11_gt/rx_out_clk        ad9625_ila/clk
