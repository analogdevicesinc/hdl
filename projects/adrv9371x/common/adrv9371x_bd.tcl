
# ad9371

create_bd_port -dir I dac_fifo_bypass

# dac peripherals

set axi_ad9371_tx_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_ad9371_tx_clkgen]
set_property -dict [list CONFIG.ID {2}] $axi_ad9371_tx_clkgen
set_property -dict [list CONFIG.CLKIN_PERIOD {8}] $axi_ad9371_tx_clkgen
set_property -dict [list CONFIG.VCO_DIV {1}] $axi_ad9371_tx_clkgen
set_property -dict [list CONFIG.VCO_MUL {8}] $axi_ad9371_tx_clkgen
set_property -dict [list CONFIG.CLK0_DIV {8}] $axi_ad9371_tx_clkgen

set axi_ad9371_tx_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9371_tx_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {4}] $axi_ad9371_tx_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {1}] $axi_ad9371_tx_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {1}] $axi_ad9371_tx_xcvr

set axi_ad9371_tx_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_ad9371_tx_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {1}] $axi_ad9371_tx_jesd
set_property -dict [list CONFIG.C_LANES {4}] $axi_ad9371_tx_jesd

set util_ad9371_tx_upack [create_bd_cell -type ip -vlnv analog.com:user:util_upack:1.0 util_ad9371_tx_upack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {32}] $util_ad9371_tx_upack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9371_tx_upack

set axi_ad9371_tx_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9371_tx_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.CYCLIC {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.ASYNC_CLK_DEST_REQ {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.ASYNC_CLK_SRC_DEST {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.ASYNC_CLK_REQ_SRC {1}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9371_tx_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {128}] $axi_ad9371_tx_dma

# adc peripherals

set axi_ad9371_rx_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_ad9371_rx_clkgen]
set_property -dict [list CONFIG.ID {2}] $axi_ad9371_rx_clkgen
set_property -dict [list CONFIG.CLKIN_PERIOD {8}] $axi_ad9371_rx_clkgen
set_property -dict [list CONFIG.VCO_DIV {1}] $axi_ad9371_rx_clkgen
set_property -dict [list CONFIG.VCO_MUL {8}] $axi_ad9371_rx_clkgen
set_property -dict [list CONFIG.CLK0_DIV {8}] $axi_ad9371_rx_clkgen

set axi_ad9371_rx_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9371_rx_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {2}] $axi_ad9371_rx_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {0}] $axi_ad9371_rx_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {0}] $axi_ad9371_rx_xcvr

set axi_ad9371_rx_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_ad9371_rx_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9371_rx_jesd
set_property -dict [list CONFIG.C_LANES {2}] $axi_ad9371_rx_jesd

set util_ad9371_rx_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_ad9371_rx_cpack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_ad9371_rx_cpack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9371_rx_cpack

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

# adc-os peripherals

set axi_ad9371_rx_os_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_ad9371_rx_os_clkgen]
set_property -dict [list CONFIG.ID {2}] $axi_ad9371_rx_os_clkgen
set_property -dict [list CONFIG.CLKIN_PERIOD {8}] $axi_ad9371_rx_os_clkgen
set_property -dict [list CONFIG.VCO_DIV {1}] $axi_ad9371_rx_os_clkgen
set_property -dict [list CONFIG.VCO_MUL {8}] $axi_ad9371_rx_os_clkgen
set_property -dict [list CONFIG.CLK0_DIV {8}] $axi_ad9371_rx_os_clkgen

set axi_ad9371_rx_os_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9371_rx_os_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {2}] $axi_ad9371_rx_os_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {0}] $axi_ad9371_rx_os_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {0}] $axi_ad9371_rx_os_xcvr

set axi_ad9371_rx_os_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_ad9371_rx_os_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9371_rx_os_jesd
set_property -dict [list CONFIG.C_LANES {2}] $axi_ad9371_rx_os_jesd

set util_ad9371_rx_os_cpack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_ad9371_rx_os_cpack]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {32}] $util_ad9371_rx_os_cpack
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_ad9371_rx_os_cpack

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

# common cores

set axi_ad9371_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9371:1.0 axi_ad9371_core]

set util_ad9371_xcvr [create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_ad9371_xcvr]
set_property -dict [list CONFIG.RX_NUM_OF_LANES {4}] $util_ad9371_xcvr
set_property -dict [list CONFIG.TX_NUM_OF_LANES {4}] $util_ad9371_xcvr
set_property -dict [list CONFIG.TX_OUT_DIV {2}] $util_ad9371_xcvr
set_property -dict [list CONFIG.CPLL_FBDIV {4}] $util_ad9371_xcvr
set_property -dict [list CONFIG.RX_CLK25_DIV {5}] $util_ad9371_xcvr
set_property -dict [list CONFIG.TX_CLK25_DIV {5}] $util_ad9371_xcvr
set_property -dict [list CONFIG.RX_PMA_CFG {0x00018480}] $util_ad9371_xcvr
set_property -dict [list CONFIG.RX_CDR_CFG {0x03000023ff20400020}] $util_ad9371_xcvr
set_property -dict [list CONFIG.QPLL_FBDIV {"0100100000"}] $util_ad9371_xcvr

# xcvr interfaces

create_bd_port -dir I tx_ref_clk_0
create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I rx_ref_clk_2

ad_xcvrpll  tx_ref_clk_0 util_ad9371_xcvr/qpll_ref_clk_0
ad_xcvrpll  rx_ref_clk_0 util_ad9371_xcvr/cpll_ref_clk_0
ad_xcvrpll  rx_ref_clk_0 util_ad9371_xcvr/cpll_ref_clk_1
ad_xcvrpll  rx_ref_clk_2 util_ad9371_xcvr/cpll_ref_clk_2
ad_xcvrpll  rx_ref_clk_2 util_ad9371_xcvr/cpll_ref_clk_3
ad_xcvrpll  axi_ad9371_tx_xcvr/up_pll_rst util_ad9371_xcvr/up_qpll_rst_0
ad_xcvrpll  axi_ad9371_rx_xcvr/up_pll_rst util_ad9371_xcvr/up_cpll_rst_0
ad_xcvrpll  axi_ad9371_rx_xcvr/up_pll_rst util_ad9371_xcvr/up_cpll_rst_1
ad_xcvrpll  axi_ad9371_rx_os_xcvr/up_pll_rst util_ad9371_xcvr/up_cpll_rst_2
ad_xcvrpll  axi_ad9371_rx_os_xcvr/up_pll_rst util_ad9371_xcvr/up_cpll_rst_3
ad_connect  sys_cpu_resetn util_ad9371_xcvr/up_rstn
ad_connect  sys_cpu_clk util_ad9371_xcvr/up_clk

ad_xcvrcon  util_ad9371_xcvr axi_ad9371_tx_xcvr axi_ad9371_tx_jesd
ad_reconct  util_ad9371_xcvr/tx_out_clk_0 axi_ad9371_tx_clkgen/clk
ad_connect  axi_ad9371_tx_clkgen/clk_0 util_ad9371_xcvr/tx_clk_0
ad_connect  axi_ad9371_tx_clkgen/clk_0 util_ad9371_xcvr/tx_clk_1
ad_connect  axi_ad9371_tx_clkgen/clk_0 util_ad9371_xcvr/tx_clk_2
ad_connect  axi_ad9371_tx_clkgen/clk_0 util_ad9371_xcvr/tx_clk_3
ad_connect  axi_ad9371_tx_clkgen/clk_0 axi_ad9371_tx_jesd/tx_core_clk
ad_connect  axi_ad9371_tx_clkgen/clk_0 axi_ad9371_tx_jesd_rstgen/slowest_sync_clk
ad_reconct  util_ad9371_xcvr/tx_0 axi_ad9371_tx_jesd/gt3_tx
ad_reconct  util_ad9371_xcvr/tx_1 axi_ad9371_tx_jesd/gt0_tx
ad_reconct  util_ad9371_xcvr/tx_2 axi_ad9371_tx_jesd/gt1_tx
ad_reconct  util_ad9371_xcvr/tx_3 axi_ad9371_tx_jesd/gt2_tx
ad_xcvrcon  util_ad9371_xcvr axi_ad9371_rx_xcvr axi_ad9371_rx_jesd
ad_reconct  util_ad9371_xcvr/rx_out_clk_0 axi_ad9371_rx_clkgen/clk
ad_connect  axi_ad9371_rx_clkgen/clk_0 util_ad9371_xcvr/rx_clk_0
ad_connect  axi_ad9371_rx_clkgen/clk_0 util_ad9371_xcvr/rx_clk_1
ad_connect  axi_ad9371_rx_clkgen/clk_0 axi_ad9371_rx_jesd/rx_core_clk
ad_connect  axi_ad9371_rx_clkgen/clk_0 axi_ad9371_rx_jesd_rstgen/slowest_sync_clk
ad_xcvrcon  util_ad9371_xcvr axi_ad9371_rx_os_xcvr axi_ad9371_rx_os_jesd
ad_reconct  util_ad9371_xcvr/rx_out_clk_2 axi_ad9371_rx_os_clkgen/clk
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 util_ad9371_xcvr/rx_clk_2
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 util_ad9371_xcvr/rx_clk_3
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 axi_ad9371_rx_os_jesd/rx_core_clk
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 axi_ad9371_rx_os_jesd_rstgen/slowest_sync_clk

# dma clock & reset

set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {150}] $sys_ps7

set sys_dma_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_dma_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_dma_rstgen

ad_connect  sys_dma_clk sys_ps7/FCLK_CLK2
ad_connect  sys_dma_clk sys_dma_rstgen/slowest_sync_clk
ad_connect  sys_ps7/FCLK_RESET2_N sys_dma_rstgen/ext_reset_in
ad_connect  sys_dma_resetn sys_dma_rstgen/peripheral_aresetn

# connections (dac)

ad_connect  axi_ad9371_tx_clkgen/clk_0 axi_ad9371_core/dac_clk
ad_connect  axi_ad9371_tx_jesd/tx_tdata axi_ad9371_core/dac_tx_data
ad_connect  axi_ad9371_tx_clkgen/clk_0 util_ad9371_tx_upack/dac_clk
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
ad_connect  axi_ad9371_tx_clkgen/clk_0 axi_ad9371_dacfifo/dac_clk
ad_connect  axi_ad9371_rx_jesd_rstgen/peripheral_reset axi_ad9371_dacfifo/dac_rst
ad_connect  util_ad9371_tx_upack/dac_valid axi_ad9371_dacfifo/dac_valid
ad_connect  util_ad9371_tx_upack/dac_data axi_ad9371_dacfifo/dac_data
ad_connect  util_ad9371_tx_upack/dma_xfer_in axi_ad9371_dacfifo/dac_xfer_out
ad_connect  axi_ad9371_dacfifo/ddr_clk axi_ad9371_dacfifo/dma_clk
ad_connect  axi_ad9371_dacfifo/ddr_clk axi_ad9371_tx_dma/m_axis_aclk
ad_connect  axi_ad9371_dacfifo/dma_rvalid axi_ad9371_tx_dma/m_axis_valid
ad_connect  axi_ad9371_dacfifo/dma_rdata axi_ad9371_tx_dma/m_axis_data
ad_connect  axi_ad9371_dacfifo/dma_rready axi_ad9371_tx_dma/m_axis_ready
ad_connect  axi_ad9371_dacfifo/dma_xfer_req axi_ad9371_tx_dma/m_axis_xfer_req
ad_connect  axi_ad9371_dacfifo/dma_xfer_last axi_ad9371_tx_dma/m_axis_last
ad_connect  axi_ad9371_dacfifo/dac_dunf axi_ad9371_core/dac_dunf
ad_connect  axi_ad9371_dacfifo/dac_fifo_bypass dac_fifo_bypass
ad_connect  sys_dma_resetn axi_ad9371_tx_dma/m_src_axi_aresetn

# connections (adc)

ad_connect  axi_ad9371_rx_clkgen/clk_0 axi_ad9371_core/adc_clk
ad_connect  axi_ad9371_rx_jesd/rx_start_of_frame axi_ad9371_core/adc_rx_sof
ad_connect  axi_ad9371_rx_jesd/rx_tdata axi_ad9371_core/adc_rx_data
ad_connect  axi_ad9371_rx_clkgen/clk_0 util_ad9371_rx_cpack/adc_clk
ad_connect  axi_ad9371_rx_jesd_rstgen/peripheral_reset util_ad9371_rx_cpack/adc_rst
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
ad_connect  axi_ad9371_rx_clkgen/clk_0 axi_ad9371_rx_dma/fifo_wr_clk
ad_connect  util_ad9371_rx_cpack/adc_valid axi_ad9371_rx_dma/fifo_wr_en
ad_connect  util_ad9371_rx_cpack/adc_sync axi_ad9371_rx_dma/fifo_wr_sync
ad_connect  util_ad9371_rx_cpack/adc_data axi_ad9371_rx_dma/fifo_wr_din
ad_connect  axi_ad9371_rx_dma/fifo_wr_overflow axi_ad9371_core/adc_dovf
ad_connect  sys_dma_resetn axi_ad9371_rx_dma/m_dest_axi_aresetn

# connections (adc-os)

ad_connect  axi_ad9371_rx_os_clkgen/clk_0 axi_ad9371_core/adc_os_clk
ad_connect  axi_ad9371_rx_os_jesd/rx_start_of_frame axi_ad9371_core/adc_rx_os_sof
ad_connect  axi_ad9371_rx_os_jesd/rx_tdata axi_ad9371_core/adc_rx_os_data
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 util_ad9371_rx_os_cpack/adc_clk
ad_connect  axi_ad9371_rx_os_jesd_rstgen/peripheral_reset util_ad9371_rx_os_cpack/adc_rst
ad_connect  axi_ad9371_core/adc_os_enable_i0 util_ad9371_rx_os_cpack/adc_enable_0
ad_connect  axi_ad9371_core/adc_os_valid_i0 util_ad9371_rx_os_cpack/adc_valid_0
ad_connect  axi_ad9371_core/adc_os_data_i0 util_ad9371_rx_os_cpack/adc_data_0
ad_connect  axi_ad9371_core/adc_os_enable_q0 util_ad9371_rx_os_cpack/adc_enable_1
ad_connect  axi_ad9371_core/adc_os_valid_q0 util_ad9371_rx_os_cpack/adc_valid_1
ad_connect  axi_ad9371_core/adc_os_data_q0 util_ad9371_rx_os_cpack/adc_data_1
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 axi_ad9371_rx_os_dma/fifo_wr_clk
ad_connect  util_ad9371_rx_os_cpack/adc_valid axi_ad9371_rx_os_dma/fifo_wr_en
ad_connect  util_ad9371_rx_os_cpack/adc_sync axi_ad9371_rx_os_dma/fifo_wr_sync
ad_connect  util_ad9371_rx_os_cpack/adc_data axi_ad9371_rx_os_dma/fifo_wr_din
ad_connect  axi_ad9371_rx_os_dma/fifo_wr_overflow axi_ad9371_core/adc_os_dovf
ad_connect  sys_dma_resetn axi_ad9371_rx_os_dma/m_dest_axi_aresetn

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 axi_ad9371_core
ad_cpu_interconnect 0x44A80000 axi_ad9371_tx_xcvr
ad_cpu_interconnect 0x43C00000 axi_ad9371_tx_clkgen
ad_cpu_interconnect 0x44A90000 axi_ad9371_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9371_tx_dma
ad_cpu_interconnect 0x44A60000 axi_ad9371_rx_xcvr
ad_cpu_interconnect 0x43C10000 axi_ad9371_rx_clkgen
ad_cpu_interconnect 0x44A91000 axi_ad9371_rx_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9371_rx_dma
ad_cpu_interconnect 0x44A70000 axi_ad9371_rx_os_xcvr
ad_cpu_interconnect 0x43C20000 axi_ad9371_rx_os_clkgen
ad_cpu_interconnect 0x44A92000 axi_ad9371_rx_os_jesd
ad_cpu_interconnect 0x7c440000 axi_ad9371_rx_os_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9371_rx_xcvr/m_axi
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9371_rx_os_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_dma_clk axi_ad9371_tx_dma/m_src_axi
ad_mem_hp2_interconnect sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_dma_clk axi_ad9371_rx_dma/m_dest_axi
ad_mem_hp2_interconnect sys_dma_clk axi_ad9371_rx_os_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-11 mb-11 axi_ad9371_rx_os_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9371_tx_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9371_rx_dma/irq

# ila

set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_adc]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc
set_property -dict [list CONFIG.C_NUM_OF_PROBES {4}] $ila_adc
set_property -dict [list CONFIG.C_PROBE0_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE2_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE3_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]  $ila_adc
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc

ad_connect  axi_ad9371_rx_clkgen/clk_0 ila_adc/clk
ad_connect  axi_ad9371_core/adc_data_i0 ila_adc/probe0
ad_connect  axi_ad9371_core/adc_data_q0 ila_adc/probe1
ad_connect  axi_ad9371_core/adc_data_i1 ila_adc/probe2
ad_connect  axi_ad9371_core/adc_data_q1 ila_adc/probe3

set bsplit_os_adc_0 [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 bsplit_os_adc_0]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $bsplit_os_adc_0
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $bsplit_os_adc_0

set bsplit_os_adc_1 [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 bsplit_os_adc_1]
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $bsplit_os_adc_1
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $bsplit_os_adc_1

set ila_os_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_os_adc]
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

ad_connect  axi_ad9371_core/adc_os_data_i0 bsplit_os_adc_0/data
ad_connect  axi_ad9371_core/adc_os_data_q0 bsplit_os_adc_1/data
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 ila_os_adc/clk
ad_connect  axi_ad9371_core/adc_os_valid_i0 ila_os_adc/probe0
ad_connect  bsplit_os_adc_0/split_data_0 ila_os_adc/probe1
ad_connect  bsplit_os_adc_0/split_data_1 ila_os_adc/probe2
ad_connect  axi_ad9371_core/adc_os_valid_q0 ila_os_adc/probe3
ad_connect  bsplit_os_adc_1/split_data_0 ila_os_adc/probe4
ad_connect  bsplit_os_adc_1/split_data_1 ila_os_adc/probe5

