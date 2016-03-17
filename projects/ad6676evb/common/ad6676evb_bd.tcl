
# ad6676

create_bd_port -dir I rx_ref_clk
create_bd_port -dir O rx_sync
create_bd_port -dir O rx_sysref
create_bd_port -dir I -from 1 -to 0 rx_data_p
create_bd_port -dir I -from 1 -to 0 rx_data_n

# adc peripherals

set axi_ad6676_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad6676:1.0 axi_ad6676_core]

set axi_ad6676_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad6676_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad6676_jesd
set_property -dict [list CONFIG.C_LANES {2}] $axi_ad6676_jesd

set axi_ad6676_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_ad6676_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {2}] $axi_ad6676_gt
set_property -dict [list CONFIG.QPLL0_ENABLE {0}] $axi_ad6676_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_ad6676_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {2}] $axi_ad6676_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $axi_ad6676_gt
set_property -dict [list CONFIG.CPLL_FBDIV_0 {2}] $axi_ad6676_gt
set_property -dict [list CONFIG.RX_OUT_DIV_0 {1}] $axi_ad6676_gt
set_property -dict [list CONFIG.TX_OUT_DIV_0 {1}] $axi_ad6676_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {13}] $axi_ad6676_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_0 {13}] $axi_ad6676_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_ad6676_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff20400020}] $axi_ad6676_gt
set_property -dict [list CONFIG.CPLL_FBDIV_1 {2}] $axi_ad6676_gt
set_property -dict [list CONFIG.RX_OUT_DIV_1 {1}] $axi_ad6676_gt
set_property -dict [list CONFIG.TX_OUT_DIV_1 {1}] $axi_ad6676_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_1 {13}] $axi_ad6676_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_1 {13}] $axi_ad6676_gt
set_property -dict [list CONFIG.PMA_RSV_1 {0x00018480}] $axi_ad6676_gt
set_property -dict [list CONFIG.RX_CDR_CFG_1 {0x03000023ff20400020}] $axi_ad6676_gt

set util_ad6676_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_ad6676_gt]
set_property -dict [list CONFIG.QPLL0_ENABLE {0}] $util_ad6676_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $util_ad6676_gt
set_property -dict [list CONFIG.NUM_OF_LANES {2}] $util_ad6676_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_ad6676_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {2}] $util_ad6676_gt
set_property -dict [list CONFIG.TX_ENABLE {0}] $util_ad6676_gt

set axi_ad6676_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad6676_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad6676_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad6676_dma
set_property -dict [list CONFIG.ID {0}] $axi_ad6676_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad6676_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad6676_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad6676_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_ad6676_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad6676_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad6676_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_ad6676_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad6676_dma

set adc_pack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 adc_pack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $adc_pack

# connections (gt)

ad_connect util_ad6676_gt/qpll_ref_clk rx_ref_clk
ad_connect util_ad6676_gt/cpll_ref_clk rx_ref_clk

ad_connect  axi_ad6676_gt/gt_pll_0 util_ad6676_gt/gt_pll_0
ad_connect  axi_ad6676_gt/gt_pll_1 util_ad6676_gt/gt_pll_1

ad_connect  axi_ad6676_gt/gt_rx_0 util_ad6676_gt/gt_rx_0
ad_connect  axi_ad6676_gt/gt_rx_1 util_ad6676_gt/gt_rx_1

ad_connect  axi_ad6676_gt/gt_rx_ip_0 axi_ad6676_jesd/gt0_rx
ad_connect  axi_ad6676_gt/gt_rx_ip_1 axi_ad6676_jesd/gt1_rx

ad_connect  axi_ad6676_gt/rx_gt_comma_align_enb_0 axi_ad6676_jesd/rxencommaalign_out
ad_connect  axi_ad6676_gt/rx_gt_comma_align_enb_1 axi_ad6676_jesd/rxencommaalign_out

# connections (adc)

ad_connect  util_ad6676_gt/rx_p         rx_data_p
ad_connect  util_ad6676_gt/rx_n         rx_data_n
ad_connect  util_ad6676_gt/rx_sync      rx_sync
ad_connect  util_ad6676_gt/rx_ip_sysref rx_sysref

ad_connect  util_ad6676_gt/rx_out_clk     util_ad6676_gt/rx_clk
ad_connect  util_ad6676_gt/rx_out_clk     axi_ad6676_jesd/rx_core_clk
ad_connect  util_ad6676_gt/rx_ip_rst      axi_ad6676_jesd/rx_reset
ad_connect  util_ad6676_gt/rx_ip_rst_done axi_ad6676_jesd/rx_reset_done
ad_connect  util_ad6676_gt/rx_ip_sysref   axi_ad6676_jesd/rx_sysref
ad_connect  util_ad6676_gt/rx_ip_sync     axi_ad6676_jesd/rx_sync
ad_connect  util_ad6676_gt/rx_ip_sof      axi_ad6676_jesd/rx_start_of_frame
ad_connect  util_ad6676_gt/rx_ip_data     axi_ad6676_jesd/rx_tdata

ad_connect  axi_ad6676_core/adc_clk   adc_pack/adc_clk
ad_connect  axi_ad6676_core/adc_rst   adc_pack/adc_rst
ad_connect  util_ad6676_gt/rx_out_clk axi_ad6676_core/rx_clk
ad_connect  util_ad6676_gt/rx_data    axi_ad6676_core/rx_data

ad_connect  axi_ad6676_core/adc_enable_a  adc_pack/adc_enable_0
ad_connect  axi_ad6676_core/adc_valid_a   adc_pack/adc_valid_0
ad_connect  axi_ad6676_core/adc_data_a    adc_pack/adc_data_0
ad_connect  axi_ad6676_core/adc_enable_b  adc_pack/adc_enable_1
ad_connect  axi_ad6676_core/adc_valid_b   adc_pack/adc_valid_1
ad_connect  axi_ad6676_core/adc_data_b    adc_pack/adc_data_1

ad_connect  axi_ad6676_core/adc_clk       axi_ad6676_dma/fifo_wr_clk
ad_connect  axi_ad6676_dma/fifo_wr_en     adc_pack/adc_valid
ad_connect  axi_ad6676_dma/fifo_wr_sync   adc_pack/adc_sync
ad_connect  axi_ad6676_dma/fifo_wr_din    adc_pack/adc_data
ad_connect  axi_ad6676_core/adc_dovf      axi_ad6676_dma/fifo_wr_overflow

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad6676_gt
ad_cpu_interconnect 0x44A10000 axi_ad6676_core
ad_cpu_interconnect 0x44A91000 axi_ad6676_jesd
ad_cpu_interconnect 0x7c420000 axi_ad6676_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad6676_gt/m_axi

# interconnect (adc)

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad6676_dma/m_dest_axi
ad_connect  sys_cpu_resetn axi_ad6676_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad6676_dma/irq

