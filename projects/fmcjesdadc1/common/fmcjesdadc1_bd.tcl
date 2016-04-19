
# ad9250

create_bd_port -dir I rx_ref_clk
create_bd_port -dir O rx_sync
create_bd_port -dir O rx_sysref
create_bd_port -dir I -from 3 -to 0 rx_data_p
create_bd_port -dir I -from 3 -to 0 rx_data_n

# adc peripherals

set axi_ad9250_0_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9250:1.0 axi_ad9250_0_core]
set axi_ad9250_1_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9250:1.0 axi_ad9250_1_core]

set axi_ad9250_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9250_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9250_jesd
set_property -dict [list CONFIG.C_LANES {4}] $axi_ad9250_jesd

set axi_ad9250_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_ad9250_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {4}] $axi_ad9250_gt
set_property -dict [list CONFIG.QPLL0_ENABLE {0}] $axi_ad9250_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {4}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $axi_ad9250_gt
set_property -dict [list CONFIG.CPLL_FBDIV_0 {2}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_OUT_DIV_0 {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_OUT_DIV_0 {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_0 {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff20400020}] $axi_ad9250_gt
set_property -dict [list CONFIG.CPLL_FBDIV_1 {2}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_OUT_DIV_1 {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_OUT_DIV_1 {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_1 {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_1 {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.PMA_RSV_1 {0x00018480}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_CDR_CFG_1 {0x03000023ff20400020}] $axi_ad9250_gt
set_property -dict [list CONFIG.CPLL_FBDIV_2 {2}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_OUT_DIV_2 {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_OUT_DIV_2 {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_2 {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_2 {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.PMA_RSV_2 {0x00018480}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_CDR_CFG_2 {0x03000023ff20400020}] $axi_ad9250_gt
set_property -dict [list CONFIG.CPLL_FBDIV_3 {2}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_OUT_DIV_3 {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_OUT_DIV_3 {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_3 {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_3 {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.PMA_RSV_3 {0x00018480}] $axi_ad9250_gt
set_property -dict [list CONFIG.RX_CDR_CFG_3 {0x03000023ff20400020}] $axi_ad9250_gt

set util_fmcjesdadc1_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_fmcjesdadc1_gt]
set_property -dict [list CONFIG.QPLL0_ENABLE {0}] $util_fmcjesdadc1_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $util_fmcjesdadc1_gt
set_property -dict [list CONFIG.NUM_OF_LANES {4}] $util_fmcjesdadc1_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_fmcjesdadc1_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {4}] $util_fmcjesdadc1_gt
set_property -dict [list CONFIG.TX_ENABLE {0}] $util_fmcjesdadc1_gt

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

set data_bsplit [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 data_bsplit]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {64} ] $data_bsplit
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $data_bsplit

set data_pack_0 [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 data_pack_0]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $data_pack_0

set data_pack_1 [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 data_pack_1]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $data_pack_1

# connections (gt)

ad_connect util_fmcjesdadc1_gt/qpll_ref_clk rx_ref_clk
ad_connect util_fmcjesdadc1_gt/cpll_ref_clk rx_ref_clk

ad_connect  axi_ad9250_gt/gt_pll_0 util_fmcjesdadc1_gt/gt_pll_0
ad_connect  axi_ad9250_gt/gt_pll_1 util_fmcjesdadc1_gt/gt_pll_1
ad_connect  axi_ad9250_gt/gt_pll_2 util_fmcjesdadc1_gt/gt_pll_2
ad_connect  axi_ad9250_gt/gt_pll_3 util_fmcjesdadc1_gt/gt_pll_3

ad_connect  axi_ad9250_gt/gt_rx_0 util_fmcjesdadc1_gt/gt_rx_0
ad_connect  axi_ad9250_gt/gt_rx_1 util_fmcjesdadc1_gt/gt_rx_1
ad_connect  axi_ad9250_gt/gt_rx_2 util_fmcjesdadc1_gt/gt_rx_2
ad_connect  axi_ad9250_gt/gt_rx_3 util_fmcjesdadc1_gt/gt_rx_3

ad_connect  axi_ad9250_gt/gt_rx_ip_0 axi_ad9250_jesd/gt0_rx
ad_connect  axi_ad9250_gt/gt_rx_ip_1 axi_ad9250_jesd/gt1_rx
ad_connect  axi_ad9250_gt/gt_rx_ip_2 axi_ad9250_jesd/gt2_rx
ad_connect  axi_ad9250_gt/gt_rx_ip_3 axi_ad9250_jesd/gt3_rx

ad_connect  axi_ad9250_gt/rx_gt_comma_align_enb_0 axi_ad9250_jesd/rxencommaalign_out
ad_connect  axi_ad9250_gt/rx_gt_comma_align_enb_1 axi_ad9250_jesd/rxencommaalign_out
ad_connect  axi_ad9250_gt/rx_gt_comma_align_enb_2 axi_ad9250_jesd/rxencommaalign_out
ad_connect  axi_ad9250_gt/rx_gt_comma_align_enb_3 axi_ad9250_jesd/rxencommaalign_out

# connections (adc)

ad_connect  util_fmcjesdadc1_gt/rx_ip_sysref rx_sysref
ad_connect  util_fmcjesdadc1_gt/rx_p rx_data_p
ad_connect  util_fmcjesdadc1_gt/rx_n rx_data_n
ad_connect  util_fmcjesdadc1_gt/rx_sync rx_sync

ad_connect  util_fmcjesdadc1_gt/rx_out_clk      util_fmcjesdadc1_gt/rx_clk
ad_connect  util_fmcjesdadc1_gt/rx_out_clk      axi_ad9250_jesd/rx_core_clk
ad_connect  util_fmcjesdadc1_gt/rx_ip_rst       axi_ad9250_jesd/rx_reset
ad_connect  util_fmcjesdadc1_gt/rx_ip_rst_done  axi_ad9250_jesd/rx_reset_done
ad_connect  util_fmcjesdadc1_gt/rx_ip_sysref    axi_ad9250_jesd/rx_sysref
ad_connect  util_fmcjesdadc1_gt/rx_ip_sync      axi_ad9250_jesd/rx_sync
ad_connect  util_fmcjesdadc1_gt/rx_ip_sof       axi_ad9250_jesd/rx_start_of_frame
ad_connect  util_fmcjesdadc1_gt/rx_ip_data      axi_ad9250_jesd/rx_tdata

ad_connect  data_bsplit/data util_fmcjesdadc1_gt/rx_data

ad_connect  axi_ad9250_0_core/adc_clk       data_pack_0/adc_clk
ad_connect  axi_ad9250_0_core/adc_rst       data_pack_0/adc_rst
ad_connect  util_fmcjesdadc1_gt/rx_out_clk  axi_ad9250_0_core/rx_clk
ad_connect  data_bsplit/split_data_0        axi_ad9250_0_core/rx_data
ad_connect  axi_ad9250_0_core/adc_enable_a  data_pack_0/adc_enable_0
ad_connect  axi_ad9250_0_core/adc_valid_a   data_pack_0/adc_valid_0
ad_connect  axi_ad9250_0_core/adc_data_a    data_pack_0/adc_data_0
ad_connect  axi_ad9250_0_core/adc_enable_b  data_pack_0/adc_enable_1
ad_connect  axi_ad9250_0_core/adc_valid_b   data_pack_0/adc_valid_1
ad_connect  axi_ad9250_0_core/adc_data_b    data_pack_0/adc_data_1
ad_connect  axi_ad9250_0_core/adc_clk       axi_ad9250_0_dma/fifo_wr_clk
ad_connect  axi_ad9250_0_dma/fifo_wr_en     data_pack_0/adc_valid
ad_connect  axi_ad9250_0_dma/fifo_wr_sync   data_pack_0/adc_sync
ad_connect  axi_ad9250_0_dma/fifo_wr_din    data_pack_0/adc_data
ad_connect  axi_ad9250_0_core/adc_dovf      axi_ad9250_0_dma/fifo_wr_overflow

ad_connect  axi_ad9250_1_core/adc_clk       data_pack_1/adc_clk
ad_connect  axi_ad9250_1_core/adc_rst       data_pack_1/adc_rst
ad_connect  util_fmcjesdadc1_gt/rx_out_clk  axi_ad9250_1_core/rx_clk
ad_connect  data_bsplit/split_data_1        axi_ad9250_1_core/rx_data
ad_connect  axi_ad9250_1_core/adc_enable_a  data_pack_1/adc_enable_0
ad_connect  axi_ad9250_1_core/adc_valid_a   data_pack_1/adc_valid_0
ad_connect  axi_ad9250_1_core/adc_data_a    data_pack_1/adc_data_0
ad_connect  axi_ad9250_1_core/adc_enable_b  data_pack_1/adc_enable_1
ad_connect  axi_ad9250_1_core/adc_valid_b   data_pack_1/adc_valid_1
ad_connect  axi_ad9250_1_core/adc_data_b    data_pack_1/adc_data_1

ad_connect  axi_ad9250_1_core/adc_clk       axi_ad9250_1_dma/fifo_wr_clk

ad_connect  axi_ad9250_1_dma/fifo_wr_en     data_pack_1/adc_valid
ad_connect  axi_ad9250_1_dma/fifo_wr_sync   data_pack_1/adc_sync
ad_connect  axi_ad9250_1_dma/fifo_wr_din    data_pack_1/adc_data
ad_connect  axi_ad9250_1_core/adc_dovf      axi_ad9250_1_dma/fifo_wr_overflow

# interconnects

ad_cpu_interconnect 0x44A10000  axi_ad9250_0_core
ad_cpu_interconnect 0x44A20000  axi_ad9250_1_core
ad_cpu_interconnect 0x44A60000  axi_ad9250_gt
ad_cpu_interconnect 0x44A91000  axi_ad9250_jesd
ad_cpu_interconnect 0x7c420000  axi_ad9250_0_dma
ad_cpu_interconnect 0x7c430000  axi_ad9250_1_dma

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_0_dma/m_dest_axi
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_1_dma/m_dest_axi
ad_connect  sys_cpu_resetn axi_ad9250_0_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9250_1_dma/m_dest_axi_aresetn

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9250_gt/m_axi

#interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9250_0_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9250_1_dma/irq

