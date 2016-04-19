
# usdrx1

create_bd_port -dir I -from 4 -to 0 spi_csn_i
create_bd_port -dir O -from 4 -to 0 spi_csn_o
create_bd_port -dir I spi_clk_i
create_bd_port -dir O spi_clk_o
create_bd_port -dir I spi_sdo_i
create_bd_port -dir O spi_sdo_o
create_bd_port -dir I spi_sdi_i

create_bd_port -dir I rx_ref_clk
create_bd_port -dir O rx_sync
create_bd_port -dir O rx_sysref
create_bd_port -dir I -from 7 -to 0 rx_data_p
create_bd_port -dir I -from 7 -to 0 rx_data_n

create_bd_port -dir O -from 255 -to 0 gt_rx_data
create_bd_port -dir I -from 63 -to 0 gt_rx_data_0
create_bd_port -dir I -from 63 -to 0 gt_rx_data_1
create_bd_port -dir I -from 63 -to 0 gt_rx_data_2
create_bd_port -dir I -from 63 -to 0 gt_rx_data_3
create_bd_port -dir O -from 127 -to 0 adc_data_0
create_bd_port -dir O -from 127 -to 0 adc_data_1
create_bd_port -dir O -from 127 -to 0 adc_data_2
create_bd_port -dir O -from 127 -to 0 adc_data_3
create_bd_port -dir O -from 7 -to 0 adc_valid_0
create_bd_port -dir O -from 7 -to 0 adc_valid_1
create_bd_port -dir O -from 7 -to 0 adc_valid_2
create_bd_port -dir O -from 7 -to 0 adc_valid_3
create_bd_port -dir O -from 7 -to 0 adc_enable_0
create_bd_port -dir O -from 7 -to 0 adc_enable_1
create_bd_port -dir O -from 7 -to 0 adc_enable_2
create_bd_port -dir O -from 7 -to 0 adc_enable_3
create_bd_port -dir I adc_dovf_0
create_bd_port -dir I adc_dovf_1
create_bd_port -dir I adc_dovf_2
create_bd_port -dir I adc_dovf_3
create_bd_port -dir I -from 511 -to 0 adc_data
create_bd_port -dir I adc_wr_en
create_bd_port -dir O adc_dovf

# adc peripherals

set axi_ad9671_core_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_0]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {0}] $axi_ad9671_core_0
set_property -dict [list CONFIG.ID {0}] $axi_ad9671_core_0

set axi_ad9671_core_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_1]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {0}] $axi_ad9671_core_1
set_property -dict [list CONFIG.ID {1}] $axi_ad9671_core_1

set axi_ad9671_core_2 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_2]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {0}] $axi_ad9671_core_2
set_property -dict [list CONFIG.ID {2}] $axi_ad9671_core_2

set axi_ad9671_core_3 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_3]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {0}] $axi_ad9671_core_3
set_property -dict [list CONFIG.ID {3}] $axi_ad9671_core_3

set axi_usdrx1_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_usdrx1_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_usdrx1_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_usdrx1_jesd
set_property -dict [list CONFIG.GT_Line_Rate {3.2}  ] $axi_usdrx1_jesd
set_property -dict [list CONFIG.GT_REFCLK_FREQ {80.000} ]  $axi_usdrx1_jesd

set axi_usdrx1_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_usdrx1_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_usdrx1_gt
set_property -dict [list CONFIG.QPLL0_ENABLE {0}] $axi_usdrx1_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $axi_usdrx1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_0 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_OUT_DIV_0 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_OUT_DIV_0 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_0 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff20400020}] $axi_usdrx1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_1 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_OUT_DIV_1 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_OUT_DIV_1 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_1 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_1 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PMA_RSV_1 {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_1 {0x03000023ff20400020}] $axi_usdrx1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_2 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_OUT_DIV_2 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_OUT_DIV_2 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_2 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_2 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PMA_RSV_2 {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_2 {0x03000023ff20400020}] $axi_usdrx1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_3 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_OUT_DIV_3 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_OUT_DIV_3 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_3 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_3 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PMA_RSV_3 {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_3 {0x03000023ff20400020}] $axi_usdrx1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_4 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_OUT_DIV_4 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_OUT_DIV_4 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_4 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_4 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PMA_RSV_4 {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_4 {0x03000023ff20400020}] $axi_usdrx1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_5 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_OUT_DIV_5 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_OUT_DIV_5 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_5 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_5 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PMA_RSV_5 {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_5 {0x03000023ff20400020}] $axi_usdrx1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_6 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_OUT_DIV_6 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_OUT_DIV_6 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_6 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_6 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PMA_RSV_6 {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_6 {0x03000023ff20400020}] $axi_usdrx1_gt
set_property -dict [list CONFIG.CPLL_FBDIV_7 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_OUT_DIV_7 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_OUT_DIV_7 {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_7 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_7 {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PMA_RSV_7 {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.RX_CDR_CFG_7 {0x03000023ff20400020}] $axi_usdrx1_gt

set util_usdrx1_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_usdrx1_gt]
set_property -dict [list CONFIG.QPLL0_ENABLE {0}] $util_usdrx1_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $util_usdrx1_gt
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $util_usdrx1_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_usdrx1_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_usdrx1_gt
set_property -dict [list CONFIG.TX_ENABLE {0}] $util_usdrx1_gt

set axi_usdrx1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_usdrx1_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {1}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.ID {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_usdrx1_dma
set_property -dict [list CONFIG.FIFO_SIZE {8}] $axi_usdrx1_dma

set axi_usdrx1_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_usdrx1_spi]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_usdrx1_spi
set_property -dict [list CONFIG.C_NUM_SS_BITS {5}] $axi_usdrx1_spi
set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_usdrx1_spi

# connections (spi)

ad_connect  spi_csn_i   axi_usdrx1_spi/ss_i
ad_connect  spi_csn_o   axi_usdrx1_spi/ss_o
ad_connect  spi_clk_i   axi_usdrx1_spi/sck_i
ad_connect  spi_clk_o   axi_usdrx1_spi/sck_o
ad_connect  spi_sdo_i   axi_usdrx1_spi/io0_i
ad_connect  spi_sdo_o   axi_usdrx1_spi/io0_o
ad_connect  spi_sdi_i   axi_usdrx1_spi/io1_i
ad_connect  sys_cpu_clk axi_usdrx1_spi/ext_spi_clk

# connections (gt)

ad_connect util_usdrx1_gt/qpll_ref_clk rx_ref_clk
ad_connect util_usdrx1_gt/cpll_ref_clk rx_ref_clk

ad_connect  axi_usdrx1_gt/gt_pll_0 util_usdrx1_gt/gt_pll_0
ad_connect  axi_usdrx1_gt/gt_pll_1 util_usdrx1_gt/gt_pll_1
ad_connect  axi_usdrx1_gt/gt_pll_2 util_usdrx1_gt/gt_pll_2
ad_connect  axi_usdrx1_gt/gt_pll_3 util_usdrx1_gt/gt_pll_3
ad_connect  axi_usdrx1_gt/gt_pll_4 util_usdrx1_gt/gt_pll_4
ad_connect  axi_usdrx1_gt/gt_pll_5 util_usdrx1_gt/gt_pll_5
ad_connect  axi_usdrx1_gt/gt_pll_6 util_usdrx1_gt/gt_pll_6
ad_connect  axi_usdrx1_gt/gt_pll_7 util_usdrx1_gt/gt_pll_7

ad_connect  axi_usdrx1_gt/gt_rx_0 util_usdrx1_gt/gt_rx_0
ad_connect  axi_usdrx1_gt/gt_rx_1 util_usdrx1_gt/gt_rx_1
ad_connect  axi_usdrx1_gt/gt_rx_2 util_usdrx1_gt/gt_rx_2
ad_connect  axi_usdrx1_gt/gt_rx_3 util_usdrx1_gt/gt_rx_3
ad_connect  axi_usdrx1_gt/gt_rx_4 util_usdrx1_gt/gt_rx_4
ad_connect  axi_usdrx1_gt/gt_rx_5 util_usdrx1_gt/gt_rx_5
ad_connect  axi_usdrx1_gt/gt_rx_6 util_usdrx1_gt/gt_rx_6
ad_connect  axi_usdrx1_gt/gt_rx_7 util_usdrx1_gt/gt_rx_7

ad_connect  axi_usdrx1_gt/gt_rx_ip_0 axi_usdrx1_jesd/gt0_rx
ad_connect  axi_usdrx1_gt/gt_rx_ip_1 axi_usdrx1_jesd/gt1_rx
ad_connect  axi_usdrx1_gt/gt_rx_ip_2 axi_usdrx1_jesd/gt2_rx
ad_connect  axi_usdrx1_gt/gt_rx_ip_3 axi_usdrx1_jesd/gt3_rx
ad_connect  axi_usdrx1_gt/gt_rx_ip_4 axi_usdrx1_jesd/gt4_rx
ad_connect  axi_usdrx1_gt/gt_rx_ip_5 axi_usdrx1_jesd/gt5_rx
ad_connect  axi_usdrx1_gt/gt_rx_ip_6 axi_usdrx1_jesd/gt6_rx
ad_connect  axi_usdrx1_gt/gt_rx_ip_7 axi_usdrx1_jesd/gt7_rx

ad_connect  axi_usdrx1_gt/rx_gt_comma_align_enb_0 axi_usdrx1_jesd/rxencommaalign_out
ad_connect  axi_usdrx1_gt/rx_gt_comma_align_enb_1 axi_usdrx1_jesd/rxencommaalign_out
ad_connect  axi_usdrx1_gt/rx_gt_comma_align_enb_2 axi_usdrx1_jesd/rxencommaalign_out
ad_connect  axi_usdrx1_gt/rx_gt_comma_align_enb_3 axi_usdrx1_jesd/rxencommaalign_out
ad_connect  axi_usdrx1_gt/rx_gt_comma_align_enb_4 axi_usdrx1_jesd/rxencommaalign_out
ad_connect  axi_usdrx1_gt/rx_gt_comma_align_enb_5 axi_usdrx1_jesd/rxencommaalign_out
ad_connect  axi_usdrx1_gt/rx_gt_comma_align_enb_6 axi_usdrx1_jesd/rxencommaalign_out
ad_connect  axi_usdrx1_gt/rx_gt_comma_align_enb_7 axi_usdrx1_jesd/rxencommaalign_out

# connections (adc)

ad_connect  rx_data_p   util_usdrx1_gt/rx_p
ad_connect  rx_data_n   util_usdrx1_gt/rx_n
ad_connect  rx_sync     util_usdrx1_gt/rx_sync
ad_connect  rx_sysref   util_usdrx1_gt/rx_ip_sysref

ad_connect  util_usdrx1_gt/rx_out_clk     util_usdrx1_gt/rx_clk
ad_connect  util_usdrx1_gt/rx_out_clk     axi_usdrx1_jesd/rx_core_clk

ad_connect  util_usdrx1_gt/rx_ip_rst      axi_usdrx1_jesd/rx_reset
ad_connect  util_usdrx1_gt/rx_ip_rst_done axi_usdrx1_jesd/rx_reset_done
ad_connect  util_usdrx1_gt/rx_ip_sysref   axi_usdrx1_jesd/rx_sysref
ad_connect  util_usdrx1_gt/rx_ip_sync     axi_usdrx1_jesd/rx_sync
ad_connect  util_usdrx1_gt/rx_ip_sof      axi_usdrx1_jesd/rx_start_of_frame
ad_connect  util_usdrx1_gt/rx_ip_data     axi_usdrx1_jesd/rx_tdata

ad_connect gt_rx_data                       util_usdrx1_gt/rx_data
ad_connect util_usdrx1_gt/rx_out_clk        axi_ad9671_core_0/rx_clk
ad_connect gt_rx_data_0                     axi_ad9671_core_0/rx_data
ad_connect util_usdrx1_gt/rx_sof            axi_ad9671_core_0/rx_sof
ad_connect util_usdrx1_gt/rx_out_clk        axi_ad9671_core_1/rx_clk
ad_connect gt_rx_data_1                     axi_ad9671_core_1/rx_data
ad_connect util_usdrx1_gt/rx_sof            axi_ad9671_core_1/rx_sof
ad_connect util_usdrx1_gt/rx_out_clk        axi_ad9671_core_2/rx_clk
ad_connect gt_rx_data_2                     axi_ad9671_core_2/rx_data
ad_connect util_usdrx1_gt/rx_sof            axi_ad9671_core_2/rx_sof
ad_connect util_usdrx1_gt/rx_out_clk        axi_ad9671_core_3/rx_clk
ad_connect gt_rx_data_3                     axi_ad9671_core_3/rx_data
ad_connect util_usdrx1_gt/rx_sof            axi_ad9671_core_3/rx_sof
ad_connect axi_ad9671_core_0/adc_clk        usdrx1_fifo/adc_clk
ad_connect adc_data_0                       axi_ad9671_core_0/adc_data
ad_connect adc_data_1                       axi_ad9671_core_1/adc_data
ad_connect adc_data_2                       axi_ad9671_core_2/adc_data
ad_connect adc_data_3                       axi_ad9671_core_3/adc_data
ad_connect adc_valid_0                      axi_ad9671_core_0/adc_valid
ad_connect adc_valid_1                      axi_ad9671_core_1/adc_valid
ad_connect adc_valid_2                      axi_ad9671_core_2/adc_valid
ad_connect adc_valid_3                      axi_ad9671_core_3/adc_valid
ad_connect adc_enable_0                     axi_ad9671_core_0/adc_enable
ad_connect adc_enable_1                     axi_ad9671_core_1/adc_enable
ad_connect adc_enable_2                     axi_ad9671_core_2/adc_enable
ad_connect adc_enable_3                     axi_ad9671_core_3/adc_enable
ad_connect adc_dovf_0                       axi_ad9671_core_0/adc_dovf
ad_connect adc_dovf_1                       axi_ad9671_core_1/adc_dovf
ad_connect adc_dovf_2                       axi_ad9671_core_2/adc_dovf
ad_connect adc_dovf_3                       axi_ad9671_core_3/adc_dovf
ad_connect adc_wr_en                        usdrx1_fifo/adc_wr
ad_connect adc_data                         usdrx1_fifo/adc_wdata
ad_connect axi_ad9671_adc_raddr             axi_ad9671_core_0/adc_raddr_out
ad_connect axi_ad9671_adc_raddr             axi_ad9671_core_1/adc_raddr_in
ad_connect axi_ad9671_adc_raddr             axi_ad9671_core_2/adc_raddr_in
ad_connect axi_ad9671_adc_raddr             axi_ad9671_core_3/adc_raddr_in
ad_connect axi_ad9671_adc_sync              axi_ad9671_core_0/adc_sync_out
ad_connect axi_ad9671_adc_sync              axi_ad9671_core_1/adc_sync_in
ad_connect axi_ad9671_adc_sync              axi_ad9671_core_2/adc_sync_in
ad_connect axi_ad9671_adc_sync              axi_ad9671_core_3/adc_sync_in

ad_connect util_usdrx1_gt/rx_rst            usdrx1_fifo/adc_rst
ad_connect adc_dovf                         usdrx1_fifo/adc_wovf

ad_connect usdrx1_fifo/dma_wdata            axi_usdrx1_dma/s_axis_data
ad_connect usdrx1_fifo/dma_wr               axi_usdrx1_dma/s_axis_valid
ad_connect usdrx1_fifo/dma_wready           axi_usdrx1_dma/s_axis_ready
ad_connect usdrx1_fifo/dma_xfer_req         axi_usdrx1_dma/s_axis_xfer_req
ad_connect sys_200m_clk                     axi_usdrx1_dma/s_axis_aclk
ad_connect sys_200m_clk                     usdrx1_fifo/dma_clk

# address map

ad_cpu_interconnect  0x44A00000 axi_ad9671_core_0
ad_cpu_interconnect  0x44A10000 axi_ad9671_core_1
ad_cpu_interconnect  0x44A20000 axi_ad9671_core_2
ad_cpu_interconnect  0x44A30000 axi_ad9671_core_3

ad_cpu_interconnect  0x44A60000 axi_usdrx1_gt
ad_cpu_interconnect  0x44A91000 axi_usdrx1_jesd
ad_cpu_interconnect  0x7c400000 axi_usdrx1_dma
ad_cpu_interconnect  0x7c420000 axi_usdrx1_spi

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_usdrx1_dma/m_dest_axi
ad_connect sys_cpu_resetn axi_usdrx1_dma/m_dest_axi_aresetn

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_usdrx1_gt/m_axi

#interrupts

ad_cpu_interrupt ps-12 mb-12 axi_usdrx1_spi/ip2intc_irpt
ad_cpu_interrupt ps-13 mb-13 axi_usdrx1_dma/irq

# ila

set ila_ad9671 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.0 ila_ad9671]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_ad9671
set_property -dict [list CONFIG.C_NUM_OF_PROBES {9}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE0_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE1_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE2_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE3_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE4_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE5_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE6_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE7_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE8_WIDTH {1}] $ila_ad9671
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_ad9671

ad_connect axi_ad9671_core_0/adc_clk  ila_ad9671/CLK
ad_connect adc_data_0                 ila_ad9671/PROBE0
ad_connect adc_valid_0                ila_ad9671/PROBE1
ad_connect adc_data_1                 ila_ad9671/PROBE2
ad_connect adc_valid_1                ila_ad9671/PROBE3
ad_connect adc_data_2                 ila_ad9671/PROBE4
ad_connect adc_valid_2                ila_ad9671/PROBE5
ad_connect adc_data_3                 ila_ad9671/PROBE6
ad_connect adc_valid_3                ila_ad9671/PROBE7
ad_connect adc_dovf_0                 ila_ad9671/PROBE8
