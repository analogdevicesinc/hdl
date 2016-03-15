
# fmcadc4

create_bd_port -dir I rx_ref_clk
create_bd_port -dir O rx_sync
create_bd_port -dir I rx_sysref
create_bd_port -dir I -from 7 -to 0 rx_data_p
create_bd_port -dir I -from 7 -to 0 rx_data_n

# adc peripherals

set axi_ad9680_core_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9680:1.0 axi_ad9680_core_0]
set_property -dict [list CONFIG.ID {0}] $axi_ad9680_core_0
set axi_ad9680_core_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9680:1.0 axi_ad9680_core_1]
set_property -dict [list CONFIG.ID {1}] $axi_ad9680_core_1

set axi_ad9680_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.2 axi_ad9680_jesd]
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

set axi_fmcadc4_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_fmcadc4_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_fmcadc4_gt
set_property -dict [list CONFIG.QPLL0_ENABLE {1}] $axi_fmcadc4_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {1}] $axi_fmcadc4_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $axi_fmcadc4_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $axi_fmcadc4_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_0 {1}] $axi_fmcadc4_gt

set util_fmcadc4_gt [create_bd_cell -type ip -vlnv analog.com:user:util_jesd_gt:1.0 util_fmcadc4_gt]
set_property -dict [list CONFIG.QPLL0_ENABLE {1}] $util_fmcadc4_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {1}] $util_fmcadc4_gt
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $util_fmcadc4_gt
set_property -dict [list CONFIG.RX_ENABLE {1}] $util_fmcadc4_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_fmcadc4_gt
set_property -dict [list CONFIG.TX_ENABLE {0}] $util_fmcadc4_gt

create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_data
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {128}] [get_bd_cells util_bsplit_rx_data]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] [get_bd_cells util_bsplit_rx_data]

# connections (gt)

ad_connect  util_fmcadc4_gt/qpll_ref_clk rx_ref_clk

ad_connect  axi_fmcadc4_gt/gt_qpll_0 util_fmcadc4_gt/gt_qpll_0
ad_connect  axi_fmcadc4_gt/gt_qpll_1 util_fmcadc4_gt/gt_qpll_1
ad_connect  axi_fmcadc4_gt/gt_pll_0 util_fmcadc4_gt/gt_pll_0
ad_connect  axi_fmcadc4_gt/gt_pll_1 util_fmcadc4_gt/gt_pll_1
ad_connect  axi_fmcadc4_gt/gt_pll_2 util_fmcadc4_gt/gt_pll_2
ad_connect  axi_fmcadc4_gt/gt_pll_3 util_fmcadc4_gt/gt_pll_3
ad_connect  axi_fmcadc4_gt/gt_pll_4 util_fmcadc4_gt/gt_pll_4
ad_connect  axi_fmcadc4_gt/gt_pll_5 util_fmcadc4_gt/gt_pll_5
ad_connect  axi_fmcadc4_gt/gt_pll_6 util_fmcadc4_gt/gt_pll_6
ad_connect  axi_fmcadc4_gt/gt_pll_7 util_fmcadc4_gt/gt_pll_7
ad_connect  axi_fmcadc4_gt/gt_rx_0 util_fmcadc4_gt/gt_rx_0
ad_connect  axi_fmcadc4_gt/gt_rx_1 util_fmcadc4_gt/gt_rx_1
ad_connect  axi_fmcadc4_gt/gt_rx_2 util_fmcadc4_gt/gt_rx_2
ad_connect  axi_fmcadc4_gt/gt_rx_3 util_fmcadc4_gt/gt_rx_3
ad_connect  axi_fmcadc4_gt/gt_rx_4 util_fmcadc4_gt/gt_rx_4
ad_connect  axi_fmcadc4_gt/gt_rx_5 util_fmcadc4_gt/gt_rx_5
ad_connect  axi_fmcadc4_gt/gt_rx_6 util_fmcadc4_gt/gt_rx_6
ad_connect  axi_fmcadc4_gt/gt_rx_7 util_fmcadc4_gt/gt_rx_7
ad_connect  axi_fmcadc4_gt/gt_rx_ip_0 axi_ad9680_jesd/gt0_rx
ad_connect  axi_fmcadc4_gt/gt_rx_ip_1 axi_ad9680_jesd/gt1_rx
ad_connect  axi_fmcadc4_gt/gt_rx_ip_2 axi_ad9680_jesd/gt2_rx
ad_connect  axi_fmcadc4_gt/gt_rx_ip_3 axi_ad9680_jesd/gt3_rx
ad_connect  axi_fmcadc4_gt/gt_rx_ip_4 axi_ad9680_jesd/gt4_rx
ad_connect  axi_fmcadc4_gt/gt_rx_ip_5 axi_ad9680_jesd/gt5_rx
ad_connect  axi_fmcadc4_gt/gt_rx_ip_6 axi_ad9680_jesd/gt6_rx
ad_connect  axi_fmcadc4_gt/gt_rx_ip_7 axi_ad9680_jesd/gt7_rx
ad_connect  axi_fmcadc4_gt/rx_gt_comma_align_enb_0 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcadc4_gt/rx_gt_comma_align_enb_1 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcadc4_gt/rx_gt_comma_align_enb_2 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcadc4_gt/rx_gt_comma_align_enb_3 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcadc4_gt/rx_gt_comma_align_enb_4 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcadc4_gt/rx_gt_comma_align_enb_5 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcadc4_gt/rx_gt_comma_align_enb_6 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_fmcadc4_gt/rx_gt_comma_align_enb_7 axi_ad9680_jesd/rxencommaalign_out

# connections (adc)

ad_connect  util_fmcadc4_gt/rx_p rx_data_p
ad_connect  util_fmcadc4_gt/rx_n rx_data_n
ad_connect  util_fmcadc4_gt/rx_sysref rx_sysref
ad_connect  util_fmcadc4_gt/rx_sync rx_sync
ad_connect  util_fmcadc4_gt/rx_out_clk util_fmcadc4_gt/rx_clk
ad_connect  util_fmcadc4_gt/rx_out_clk axi_ad9680_jesd/rx_core_clk
ad_connect  util_fmcadc4_gt/rx_ip_rst axi_ad9680_jesd/rx_reset
ad_connect  util_fmcadc4_gt/rx_ip_rst_done axi_ad9680_jesd/rx_reset_done
ad_connect  util_fmcadc4_gt/rx_ip_sysref axi_ad9680_jesd/rx_sysref
ad_connect  util_fmcadc4_gt/rx_ip_sync axi_ad9680_jesd/rx_sync
ad_connect  util_fmcadc4_gt/rx_ip_sof axi_ad9680_jesd/rx_start_of_frame
ad_connect  util_fmcadc4_gt/rx_ip_data axi_ad9680_jesd/rx_tdata
ad_connect  util_fmcadc4_gt/rx_data util_bsplit_rx_data/data
ad_connect  util_fmcadc4_gt/rx_out_clk axi_ad9680_core_0/rx_clk
ad_connect  util_fmcadc4_gt/rx_out_clk axi_ad9680_core_1/rx_clk
ad_connect  util_bsplit_rx_data/split_data_0 axi_ad9680_core_0/rx_data
ad_connect  util_bsplit_rx_data/split_data_1 axi_ad9680_core_1/rx_data
ad_connect  util_fmcadc4_gt/rx_out_clk axi_ad9680_cpack/adc_clk
ad_connect  util_fmcadc4_gt/rx_rst axi_ad9680_cpack/adc_rst
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
ad_connect  util_fmcadc4_gt/rx_out_clk axi_ad9680_fifo/adc_clk
ad_connect  util_fmcadc4_gt/rx_rst axi_ad9680_fifo/adc_rst
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

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_fmcadc4_gt
ad_cpu_interconnect 0x44A00000 axi_ad9680_core_0
ad_cpu_interconnect 0x44A10000 axi_ad9680_core_1
ad_cpu_interconnect 0x44A91000 axi_ad9680_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9680_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_fmcadc4_gt/m_axi

# interconnect (mem/adc)

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9680_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9680_dma/irq

