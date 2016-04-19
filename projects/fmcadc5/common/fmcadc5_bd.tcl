
# ad9625

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I -from 7 -to 0 rx_data_0_p
create_bd_port -dir I -from 7 -to 0 rx_data_0_n
create_bd_port -dir O rx_sync_0
create_bd_port -dir I rx_ref_clk_1
create_bd_port -dir I -from 7 -to 0 rx_data_1_p
create_bd_port -dir I -from 7 -to 0 rx_data_1_n
create_bd_port -dir O rx_sync_1
create_bd_port -dir O rx_sysref
create_bd_port -dir O rx_clk

# adc peripherals

set axi_ad9625_0_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_0_core]
set_property -dict [list CONFIG.ID {0}] $axi_ad9625_0_core
set axi_ad9625_1_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_1_core]
set_property -dict [list CONFIG.ID {1}] $axi_ad9625_1_core

set axi_ad9625_0_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9625_0_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_0_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_0_jesd
set axi_ad9625_1_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9625_1_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_1_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_1_jesd

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

p_sys_dmafifo [current_bd_instance .] axi_ad9625_fifo 512 18

# adc common gt

set axi_fmcadc5_0_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_fmcadc5_0_gt]
set_property -dict [list CONFIG.ID {0}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.CPLL_FBDIV_0 {1}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.PMA_RSV_1 {0x00018480}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.CPLL_FBDIV_1 {1}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.PMA_RSV_2 {0x00018480}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.CPLL_FBDIV_2 {1}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.PMA_RSV_3 {0x00018480}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.CPLL_FBDIV_3 {1}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.PMA_RSV_4 {0x00018480}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.CPLL_FBDIV_4 {1}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.PMA_RSV_5 {0x00018480}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.CPLL_FBDIV_5 {1}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.PMA_RSV_6 {0x00018480}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.CPLL_FBDIV_6 {1}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.PMA_RSV_7 {0x00018480}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.CPLL_FBDIV_7 {1}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {25}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff20400020}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_1 {25}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CDR_CFG_1 {0x03000023ff20400020}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_2 {25}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CDR_CFG_2 {0x03000023ff20400020}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_3 {25}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CDR_CFG_3 {0x03000023ff20400020}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_4 {25}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CDR_CFG_4 {0x03000023ff20400020}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_5 {25}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CDR_CFG_5 {0x03000023ff20400020}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_6 {25}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CDR_CFG_6 {0x03000023ff20400020}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_7 {25}] $axi_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_CDR_CFG_7 {0x03000023ff20400020}] $axi_fmcadc5_0_gt

set axi_fmcadc5_1_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_fmcadc5_1_gt]
set_property -dict [list CONFIG.ID {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_0 {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.PMA_RSV_1 {0x00018480}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_1 {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.PMA_RSV_2 {0x00018480}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_2 {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.PMA_RSV_3 {0x00018480}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_3 {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.PMA_RSV_4 {0x00018480}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_4 {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.PMA_RSV_5 {0x00018480}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_5 {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.PMA_RSV_6 {0x00018480}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_6 {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.PMA_RSV_7 {0x00018480}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_7 {1}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {25}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff20400020}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_1 {25}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_1 {0x03000023ff20400020}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_2 {25}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_2 {0x03000023ff20400020}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_3 {25}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_3 {0x03000023ff20400020}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_4 {25}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_4 {0x03000023ff20400020}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_5 {25}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_5 {0x03000023ff20400020}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_6 {25}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_6 {0x03000023ff20400020}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_7 {25}] $axi_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_7 {0x03000023ff20400020}] $axi_fmcadc5_1_gt

set util_fmcadc5_0_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_fmcadc5_0_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $util_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_fmcadc5_0_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_fmcadc5_0_gt
set_property -dict [list CONFIG.TX_ENABLE {0}] $util_fmcadc5_0_gt

set util_fmcadc5_1_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_fmcadc5_1_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $util_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_fmcadc5_1_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_fmcadc5_1_gt
set_property -dict [list CONFIG.TX_ENABLE {0}] $util_fmcadc5_1_gt

set axi_fmcadc5_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 axi_fmcadc5_cpack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {256}] $axi_fmcadc5_cpack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $axi_fmcadc5_cpack

# connections (gt)

ad_connect  util_fmcadc5_0_gt/cpll_ref_clk rx_ref_clk_0
ad_connect  util_fmcadc5_1_gt/cpll_ref_clk rx_ref_clk_1

ad_connect  axi_fmcadc5_0_gt/gt_qpll_0 util_fmcadc5_0_gt/gt_qpll_0
ad_connect  axi_fmcadc5_0_gt/gt_qpll_1 util_fmcadc5_0_gt/gt_qpll_1
ad_connect  axi_fmcadc5_0_gt/gt_pll_0 util_fmcadc5_0_gt/gt_pll_0
ad_connect  axi_fmcadc5_0_gt/gt_pll_1 util_fmcadc5_0_gt/gt_pll_1
ad_connect  axi_fmcadc5_0_gt/gt_pll_2 util_fmcadc5_0_gt/gt_pll_2
ad_connect  axi_fmcadc5_0_gt/gt_pll_3 util_fmcadc5_0_gt/gt_pll_3
ad_connect  axi_fmcadc5_0_gt/gt_pll_4 util_fmcadc5_0_gt/gt_pll_4
ad_connect  axi_fmcadc5_0_gt/gt_pll_5 util_fmcadc5_0_gt/gt_pll_5
ad_connect  axi_fmcadc5_0_gt/gt_pll_6 util_fmcadc5_0_gt/gt_pll_6
ad_connect  axi_fmcadc5_0_gt/gt_pll_7 util_fmcadc5_0_gt/gt_pll_7
ad_connect  axi_fmcadc5_1_gt/gt_qpll_0 util_fmcadc5_1_gt/gt_qpll_0
ad_connect  axi_fmcadc5_1_gt/gt_qpll_1 util_fmcadc5_1_gt/gt_qpll_1
ad_connect  axi_fmcadc5_1_gt/gt_pll_0 util_fmcadc5_1_gt/gt_pll_0
ad_connect  axi_fmcadc5_1_gt/gt_pll_1 util_fmcadc5_1_gt/gt_pll_1
ad_connect  axi_fmcadc5_1_gt/gt_pll_2 util_fmcadc5_1_gt/gt_pll_2
ad_connect  axi_fmcadc5_1_gt/gt_pll_3 util_fmcadc5_1_gt/gt_pll_3
ad_connect  axi_fmcadc5_1_gt/gt_pll_4 util_fmcadc5_1_gt/gt_pll_4
ad_connect  axi_fmcadc5_1_gt/gt_pll_5 util_fmcadc5_1_gt/gt_pll_5
ad_connect  axi_fmcadc5_1_gt/gt_pll_6 util_fmcadc5_1_gt/gt_pll_6
ad_connect  axi_fmcadc5_1_gt/gt_pll_7 util_fmcadc5_1_gt/gt_pll_7
ad_connect  axi_fmcadc5_0_gt/gt_rx_0 util_fmcadc5_0_gt/gt_rx_0
ad_connect  axi_fmcadc5_0_gt/gt_rx_1 util_fmcadc5_0_gt/gt_rx_1
ad_connect  axi_fmcadc5_0_gt/gt_rx_2 util_fmcadc5_0_gt/gt_rx_2
ad_connect  axi_fmcadc5_0_gt/gt_rx_3 util_fmcadc5_0_gt/gt_rx_3
ad_connect  axi_fmcadc5_0_gt/gt_rx_4 util_fmcadc5_0_gt/gt_rx_4
ad_connect  axi_fmcadc5_0_gt/gt_rx_5 util_fmcadc5_0_gt/gt_rx_5
ad_connect  axi_fmcadc5_0_gt/gt_rx_6 util_fmcadc5_0_gt/gt_rx_6
ad_connect  axi_fmcadc5_0_gt/gt_rx_7 util_fmcadc5_0_gt/gt_rx_7
ad_connect  axi_fmcadc5_1_gt/gt_rx_0 util_fmcadc5_1_gt/gt_rx_0
ad_connect  axi_fmcadc5_1_gt/gt_rx_1 util_fmcadc5_1_gt/gt_rx_1
ad_connect  axi_fmcadc5_1_gt/gt_rx_2 util_fmcadc5_1_gt/gt_rx_2
ad_connect  axi_fmcadc5_1_gt/gt_rx_3 util_fmcadc5_1_gt/gt_rx_3
ad_connect  axi_fmcadc5_1_gt/gt_rx_4 util_fmcadc5_1_gt/gt_rx_4
ad_connect  axi_fmcadc5_1_gt/gt_rx_5 util_fmcadc5_1_gt/gt_rx_5
ad_connect  axi_fmcadc5_1_gt/gt_rx_6 util_fmcadc5_1_gt/gt_rx_6
ad_connect  axi_fmcadc5_1_gt/gt_rx_7 util_fmcadc5_1_gt/gt_rx_7
ad_connect  axi_fmcadc5_0_gt/gt_rx_ip_0 axi_ad9625_0_jesd/gt0_rx
ad_connect  axi_fmcadc5_0_gt/gt_rx_ip_1 axi_ad9625_0_jesd/gt1_rx
ad_connect  axi_fmcadc5_0_gt/gt_rx_ip_2 axi_ad9625_0_jesd/gt2_rx
ad_connect  axi_fmcadc5_0_gt/gt_rx_ip_3 axi_ad9625_0_jesd/gt3_rx
ad_connect  axi_fmcadc5_0_gt/gt_rx_ip_4 axi_ad9625_0_jesd/gt4_rx
ad_connect  axi_fmcadc5_0_gt/gt_rx_ip_5 axi_ad9625_0_jesd/gt5_rx
ad_connect  axi_fmcadc5_0_gt/gt_rx_ip_6 axi_ad9625_0_jesd/gt6_rx
ad_connect  axi_fmcadc5_0_gt/gt_rx_ip_7 axi_ad9625_0_jesd/gt7_rx
ad_connect  axi_fmcadc5_1_gt/gt_rx_ip_0 axi_ad9625_1_jesd/gt0_rx
ad_connect  axi_fmcadc5_1_gt/gt_rx_ip_1 axi_ad9625_1_jesd/gt1_rx
ad_connect  axi_fmcadc5_1_gt/gt_rx_ip_2 axi_ad9625_1_jesd/gt2_rx
ad_connect  axi_fmcadc5_1_gt/gt_rx_ip_3 axi_ad9625_1_jesd/gt3_rx
ad_connect  axi_fmcadc5_1_gt/gt_rx_ip_4 axi_ad9625_1_jesd/gt4_rx
ad_connect  axi_fmcadc5_1_gt/gt_rx_ip_5 axi_ad9625_1_jesd/gt5_rx
ad_connect  axi_fmcadc5_1_gt/gt_rx_ip_6 axi_ad9625_1_jesd/gt6_rx
ad_connect  axi_fmcadc5_1_gt/gt_rx_ip_7 axi_ad9625_1_jesd/gt7_rx
ad_connect  axi_fmcadc5_0_gt/rx_gt_comma_align_enb_0 axi_ad9625_0_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_0_gt/rx_gt_comma_align_enb_1 axi_ad9625_0_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_0_gt/rx_gt_comma_align_enb_2 axi_ad9625_0_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_0_gt/rx_gt_comma_align_enb_3 axi_ad9625_0_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_0_gt/rx_gt_comma_align_enb_4 axi_ad9625_0_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_0_gt/rx_gt_comma_align_enb_5 axi_ad9625_0_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_0_gt/rx_gt_comma_align_enb_6 axi_ad9625_0_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_0_gt/rx_gt_comma_align_enb_7 axi_ad9625_0_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_1_gt/rx_gt_comma_align_enb_0 axi_ad9625_1_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_1_gt/rx_gt_comma_align_enb_1 axi_ad9625_1_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_1_gt/rx_gt_comma_align_enb_2 axi_ad9625_1_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_1_gt/rx_gt_comma_align_enb_3 axi_ad9625_1_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_1_gt/rx_gt_comma_align_enb_4 axi_ad9625_1_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_1_gt/rx_gt_comma_align_enb_5 axi_ad9625_1_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_1_gt/rx_gt_comma_align_enb_6 axi_ad9625_1_jesd/rxencommaalign_out
ad_connect  axi_fmcadc5_1_gt/rx_gt_comma_align_enb_7 axi_ad9625_1_jesd/rxencommaalign_out

# connections (adc)

ad_connect  util_fmcadc5_0_gt/rx_p rx_data_0_p
ad_connect  util_fmcadc5_0_gt/rx_n rx_data_0_n
ad_connect  util_fmcadc5_0_gt/rx_sysref GND
ad_connect  util_fmcadc5_0_gt/rx_sync rx_sync_0
ad_connect  util_fmcadc5_1_gt/rx_p rx_data_1_p
ad_connect  util_fmcadc5_1_gt/rx_n rx_data_1_n
ad_connect  util_fmcadc5_1_gt/rx_sysref GND
ad_connect  util_fmcadc5_1_gt/rx_sync rx_sync_1
ad_connect  util_fmcadc5_0_gt/rx_ip_sysref rx_sysref
ad_connect  util_fmcadc5_0_gt/rx_out_clk rx_clk
ad_connect  util_fmcadc5_0_gt/rx_out_clk util_fmcadc5_0_gt/rx_clk
ad_connect  util_fmcadc5_0_gt/rx_out_clk axi_ad9625_0_jesd/rx_core_clk
ad_connect  util_fmcadc5_0_gt/rx_ip_rst axi_ad9625_0_jesd/rx_reset
ad_connect  util_fmcadc5_0_gt/rx_ip_rst_done axi_ad9625_0_jesd/rx_reset_done
ad_connect  util_fmcadc5_0_gt/rx_ip_sysref axi_ad9625_0_jesd/rx_sysref
ad_connect  util_fmcadc5_0_gt/rx_ip_sync axi_ad9625_0_jesd/rx_sync
ad_connect  util_fmcadc5_0_gt/rx_ip_sof axi_ad9625_0_jesd/rx_start_of_frame
ad_connect  util_fmcadc5_0_gt/rx_ip_data axi_ad9625_0_jesd/rx_tdata
ad_connect  util_fmcadc5_0_gt/rx_out_clk axi_ad9625_0_core/rx_clk
ad_connect  util_fmcadc5_0_gt/rx_data axi_ad9625_0_core/rx_data
ad_connect  util_fmcadc5_0_gt/rx_out_clk util_fmcadc5_1_gt/rx_clk
ad_connect  util_fmcadc5_0_gt/rx_out_clk axi_ad9625_1_jesd/rx_core_clk
ad_connect  util_fmcadc5_1_gt/rx_ip_rst axi_ad9625_1_jesd/rx_reset
ad_connect  util_fmcadc5_1_gt/rx_ip_rst_done axi_ad9625_1_jesd/rx_reset_done
ad_connect  util_fmcadc5_0_gt/rx_ip_sysref axi_ad9625_1_jesd/rx_sysref
ad_connect  util_fmcadc5_1_gt/rx_ip_sync axi_ad9625_1_jesd/rx_sync
ad_connect  util_fmcadc5_1_gt/rx_ip_sof axi_ad9625_1_jesd/rx_start_of_frame
ad_connect  util_fmcadc5_1_gt/rx_ip_data axi_ad9625_1_jesd/rx_tdata
ad_connect  util_fmcadc5_0_gt/rx_out_clk axi_ad9625_1_core/rx_clk
ad_connect  util_fmcadc5_1_gt/rx_data axi_ad9625_1_core/rx_data
ad_connect  util_fmcadc5_0_gt/rx_out_clk axi_fmcadc5_cpack/adc_clk
ad_connect  util_fmcadc5_0_gt/rx_rst axi_fmcadc5_cpack/adc_rst
ad_connect  axi_ad9625_0_core/adc_raddr_out axi_ad9625_0_core/adc_raddr_in
ad_connect  axi_ad9625_0_core/adc_raddr_out axi_ad9625_1_core/adc_raddr_in
ad_connect  axi_ad9625_0_core/adc_enable axi_fmcadc5_cpack/adc_enable_0
ad_connect  axi_ad9625_0_core/adc_valid axi_fmcadc5_cpack/adc_valid_0
ad_connect  axi_ad9625_0_core/adc_data axi_fmcadc5_cpack/adc_data_0
ad_connect  axi_ad9625_1_core/adc_enable axi_fmcadc5_cpack/adc_enable_1
ad_connect  axi_ad9625_1_core/adc_valid axi_fmcadc5_cpack/adc_valid_1
ad_connect  axi_ad9625_1_core/adc_data axi_fmcadc5_cpack/adc_data_1
ad_connect  util_fmcadc5_0_gt/rx_out_clk axi_ad9625_fifo/adc_clk
ad_connect  util_fmcadc5_0_gt/rx_rst axi_ad9625_fifo/adc_rst
ad_connect  axi_fmcadc5_cpack/adc_valid axi_ad9625_fifo/adc_wr
ad_connect  axi_fmcadc5_cpack/adc_data axi_ad9625_fifo/adc_wdata
ad_connect  axi_ad9625_0_core/adc_dovf axi_ad9625_fifo/adc_wovf
ad_connect  sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn
ad_connect  axi_ad9625_fifo/dma_wr axi_ad9625_dma/s_axis_valid
ad_connect  axi_ad9625_fifo/dma_wdata axi_ad9625_dma/s_axis_data
ad_connect  axi_ad9625_fifo/dma_wready axi_ad9625_dma/s_axis_ready
ad_connect  axi_ad9625_fifo/dma_xfer_req axi_ad9625_dma/s_axis_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44a60000 axi_fmcadc5_0_gt
ad_cpu_interconnect 0x44b60000 axi_fmcadc5_1_gt
ad_cpu_interconnect 0x44a10000 axi_ad9625_0_core
ad_cpu_interconnect 0x44b10000 axi_ad9625_1_core
ad_cpu_interconnect 0x44a91000 axi_ad9625_0_jesd
ad_cpu_interconnect 0x44b91000 axi_ad9625_1_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9625_dma

# interconnect (gt/adc)

ad_mem_hp0_interconnect sys_cpu_clk axi_fmcadc5_0_gt/m_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_fmcadc5_1_gt/m_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9625_dma/irq

# sync

create_bd_port -dir O up_clk
create_bd_port -dir O up_rstn
create_bd_port -dir O delay_clk
create_bd_port -dir O delay_rst

ad_connect  sys_cpu_clk up_clk
ad_connect  sys_cpu_resetn up_rstn
ad_connect  sys_200m_clk delay_clk
ad_connect  sys_cpu_reset delay_rst


