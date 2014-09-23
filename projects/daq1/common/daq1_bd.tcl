
# daq1

set spi_csn_i       [create_bd_port -dir I -from 2 -to 0 spi_csn_i]
set spi_csn_o       [create_bd_port -dir O -from 2 -to 0 spi_csn_o]
set spi_clk_i       [create_bd_port -dir I spi_clk_i]
set spi_clk_o       [create_bd_port -dir O spi_clk_o]
set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

set rx_ref_clk      [create_bd_port -dir I rx_ref_clk]
set rx_sync         [create_bd_port -dir O rx_sync]
set rx_sysref       [create_bd_port -dir I rx_sysref]
set rx_data_p       [create_bd_port -dir I -from 1 -to 0 rx_data_p]
set rx_data_n       [create_bd_port -dir I -from 1 -to 0 rx_data_n]

set dac_clk         [create_bd_port -dir O dac_clk]
set dac_valid_0     [create_bd_port -dir O dac_valid_0]
set dac_enable_0    [create_bd_port -dir O dac_enable_0]
set dac_ddata_0     [create_bd_port -dir I -from 63 -to 0 dac_ddata_0]
set dac_valid_1     [create_bd_port -dir O dac_valid_1]
set dac_enable_1    [create_bd_port -dir O dac_enable_1]
set dac_ddata_1     [create_bd_port -dir I -from 63 -to 0 dac_ddata_1]
set dac_drd         [create_bd_port -dir I dac_drd]
set dac_ddata       [create_bd_port -dir O -from 127 -to 0 dac_ddata]

set adc_clk         [create_bd_port -dir O adc_clk]
set adc_enable_a    [create_bd_port -dir O adc_enable_a]
set adc_valid_a     [create_bd_port -dir O adc_valid_a]
set adc_data_a      [create_bd_port -dir O -from 31 -to 0 adc_data_a]
set adc_enable_b    [create_bd_port -dir O adc_enable_b]
set adc_valid_b     [create_bd_port -dir O adc_valid_b]
set adc_data_b      [create_bd_port -dir O -from 31 -to 0 adc_data_b]
set adc_dwr         [create_bd_port -dir I adc_dwr]
set adc_dsync       [create_bd_port -dir I adc_dsync]
set adc_ddata       [create_bd_port -dir I -from 63 -to 0 adc_ddata]

set tx_ref_clk_p    [create_bd_port -dir I tx_ref_clk_p]
set tx_ref_clk_n    [create_bd_port -dir I tx_ref_clk_n]
set tx_clk_p        [create_bd_port -dir O tx_clk_p]
set tx_clk_n        [create_bd_port -dir O tx_clk_n]
set tx_frame_p      [create_bd_port -dir O tx_frame_p]
set tx_frame_n      [create_bd_port -dir O tx_frame_n]
set tx_data_p       [create_bd_port -dir O -from 15 -to 0 tx_data_p]
set tx_data_n       [create_bd_port -dir O -from 15 -to 0 tx_data_n]

# dac peripherals

set axi_ad9122_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9122:1.0 axi_ad9122_core]

set axi_ad9122_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9122_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9122_dma
set_property -dict [list CONFIG.PCORE_ID {1}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {0}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {128}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {128}] $axi_ad9122_dma

set axi_ad9122_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9122_dma_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9122_dma_interconnect

# adc peripherals

set axi_ad9250_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9250:1.0 axi_ad9250_core]

set axi_ad9250_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.1 axi_ad9250_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9250_jesd
set_property -dict [list CONFIG.C_LANES {2}] $axi_ad9250_jesd

set axi_ad9250_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9250_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9250_dma

set axi_ad9250_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9250_dma_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9250_dma_interconnect

# dac/adc common gt/gpio

set axi_daq1_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_daq1_gt]
set_property -dict [list CONFIG.PCORE_NUM_OF_LANES {2}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_CPLL_FBDIV {2}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_RX_OUT_DIV {1}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_TX_OUT_DIV {1}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_RX_CLK25_DIV {10}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_TX_CLK25_DIV {10}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_PMA_RSV {0x00018480}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_RX_CDR_CFG {0x03000023ff20400020}] $axi_daq1_gt

set axi_daq1_gt_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_daq1_gt_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_daq1_gt_interconnect

# additions to default configuration

set_property -dict [list CONFIG.NUM_MI {13}] $axi_cpu_interconnect
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {40}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7

set_property LEFT 39 [get_bd_ports GPIO_I]
set_property LEFT 39 [get_bd_ports GPIO_O]
set_property LEFT 39 [get_bd_ports GPIO_T]

# connections (spi)
set sys_spi_csn_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 sys_spi_csn_concat]
set_property -dict [list CONFIG.NUM_PORTS {3}] $sys_spi_csn_concat

connect_bd_net -net spi_csn0  [get_bd_pins sys_spi_csn_concat/In2] [get_bd_pins sys_ps7/SPI0_SS_O]
connect_bd_net -net spi_csn1  [get_bd_pins sys_spi_csn_concat/In1] [get_bd_pins sys_ps7/SPI0_SS1_O]
connect_bd_net -net spi_csn2  [get_bd_pins sys_spi_csn_concat/In0] [get_bd_pins sys_ps7/SPI0_SS2_O]
connect_bd_net -net spi_csn_i [get_bd_ports spi_csn_i]  [get_bd_pins sys_ps7/SPI0_SS_I]
connect_bd_net -net spi_csn_o [get_bd_ports spi_csn_o]  [get_bd_pins sys_spi_csn_concat/dout]
connect_bd_net -net spi_clk_i [get_bd_ports spi_clk_i]  [get_bd_pins sys_ps7/SPI0_SCLK_I]
connect_bd_net -net spi_clk_o [get_bd_ports spi_clk_o]  [get_bd_pins sys_ps7/SPI0_SCLK_O]
connect_bd_net -net spi_sdo_i [get_bd_ports spi_sdo_i]  [get_bd_pins sys_ps7/SPI0_MOSI_I]
connect_bd_net -net spi_sdo_o [get_bd_ports spi_sdo_o]  [get_bd_pins sys_ps7/SPI0_MOSI_O]
connect_bd_net -net spi_sdi_i [get_bd_ports spi_sdi_i]  [get_bd_pins sys_ps7/SPI0_MISO_I]

# connections (gt)

connect_bd_net -net axi_daq1_gt_ref_clk_c         [get_bd_pins axi_daq1_gt/ref_clk_c]           [get_bd_ports rx_ref_clk]
connect_bd_net -net axi_daq1_gt_rx_data_p         [get_bd_pins axi_daq1_gt/rx_data_p]           [get_bd_ports rx_data_p]
connect_bd_net -net axi_daq1_gt_rx_data_n         [get_bd_pins axi_daq1_gt/rx_data_n]           [get_bd_ports rx_data_n]
connect_bd_net -net axi_daq1_gt_rx_sync           [get_bd_pins axi_daq1_gt/rx_sync]             [get_bd_ports rx_sync]
connect_bd_net -net axi_daq1_gt_rx_ext_sysref     [get_bd_pins axi_daq1_gt/rx_ext_sysref]       [get_bd_ports rx_sysref]

# connections (adc)

connect_bd_net -net axi_daq1_gt_rx_clk [get_bd_pins axi_daq1_gt/rx_clk_g]
connect_bd_net -net axi_daq1_gt_rx_clk [get_bd_pins axi_daq1_gt/rx_clk]
connect_bd_net -net axi_daq1_gt_rx_clk [get_bd_pins axi_ad9250_core/rx_clk]
connect_bd_net -net axi_daq1_gt_rx_clk [get_bd_pins axi_ad9250_jesd/rx_core_clk]

connect_bd_net -net axi_daq1_gt_rx_rst            [get_bd_pins axi_daq1_gt/rx_rst]              [get_bd_pins axi_ad9250_jesd/rx_reset]
connect_bd_net -net axi_daq1_gt_rx_sysref         [get_bd_pins axi_daq1_gt/rx_sysref]           [get_bd_pins axi_ad9250_jesd/rx_sysref]
connect_bd_net -net axi_daq1_gt_rx_gt_charisk     [get_bd_pins axi_daq1_gt/rx_gt_charisk]       [get_bd_pins axi_ad9250_jesd/gt_rxcharisk_in]
connect_bd_net -net axi_daq1_gt_rx_gt_disperr     [get_bd_pins axi_daq1_gt/rx_gt_disperr]       [get_bd_pins axi_ad9250_jesd/gt_rxdisperr_in]
connect_bd_net -net axi_daq1_gt_rx_gt_notintable  [get_bd_pins axi_daq1_gt/rx_gt_notintable]    [get_bd_pins axi_ad9250_jesd/gt_rxnotintable_in]
connect_bd_net -net axi_daq1_gt_rx_gt_data        [get_bd_pins axi_daq1_gt/rx_gt_data]          [get_bd_pins axi_ad9250_jesd/gt_rxdata_in]
connect_bd_net -net axi_daq1_gt_rx_rst_done       [get_bd_pins axi_daq1_gt/rx_rst_done]         [get_bd_pins axi_ad9250_jesd/rx_reset_done]
connect_bd_net -net axi_daq1_gt_rx_ip_comma_align [get_bd_pins axi_daq1_gt/rx_ip_comma_align]   [get_bd_pins axi_ad9250_jesd/rxencommaalign_out]
connect_bd_net -net axi_daq1_gt_rx_ip_sync        [get_bd_pins axi_daq1_gt/rx_ip_sync]          [get_bd_pins axi_ad9250_jesd/rx_sync]
connect_bd_net -net axi_daq1_gt_rx_ip_sof         [get_bd_pins axi_daq1_gt/rx_ip_sof]           [get_bd_pins axi_ad9250_jesd/rx_start_of_frame]
connect_bd_net -net axi_daq1_gt_rx_ip_data        [get_bd_pins axi_daq1_gt/rx_ip_data]          [get_bd_pins axi_ad9250_jesd/rx_tdata]
connect_bd_net -net axi_daq1_gt_rx_data           [get_bd_pins axi_daq1_gt/rx_data]             [get_bd_pins axi_ad9250_core/rx_data]
connect_bd_net -net axi_ad9250_adc_clk            [get_bd_pins axi_ad9250_core/adc_clk]         [get_bd_pins axi_ad9250_dma/fifo_wr_clk]
connect_bd_net -net axi_ad9250_adc_enable_a       [get_bd_pins axi_ad9250_core/adc_enable_a]    [get_bd_ports adc_enable_a]
connect_bd_net -net axi_ad9250_adc_valid_a        [get_bd_pins axi_ad9250_core/adc_valid_a]     [get_bd_ports adc_valid_a]
connect_bd_net -net axi_ad9250_adc_data_a         [get_bd_pins axi_ad9250_core/adc_data_a]      [get_bd_ports adc_data_a]
connect_bd_net -net axi_ad9250_adc_enable_b       [get_bd_pins axi_ad9250_core/adc_enable_b]    [get_bd_ports adc_enable_b]
connect_bd_net -net axi_ad9250_adc_valid_b        [get_bd_pins axi_ad9250_core/adc_valid_b]     [get_bd_ports adc_valid_b]
connect_bd_net -net axi_ad9250_adc_data_b         [get_bd_pins axi_ad9250_core/adc_data_b]      [get_bd_ports adc_data_b]
connect_bd_net -net axi_ad9250_adc_dovf           [get_bd_pins axi_ad9250_core/adc_dovf]        [get_bd_pins axi_ad9250_dma/fifo_wr_overflow]
connect_bd_net -net axi_ad9250_dma_wr             [get_bd_pins axi_ad9250_dma/fifo_wr_en]       [get_bd_ports adc_dwr]
connect_bd_net -net axi_ad9250_dma_sync           [get_bd_pins axi_ad9250_dma/fifo_wr_sync]     [get_bd_ports adc_dsync]
connect_bd_net -net axi_ad9250_dma_data           [get_bd_pins axi_ad9250_dma/fifo_wr_din]      [get_bd_ports adc_ddata]
connect_bd_net -net axi_ad9250_dma_irq            [get_bd_pins axi_ad9250_dma/irq]              [get_bd_pins sys_concat_intc/In2]

connect_bd_net -net axi_ad9250_adc_clk            [get_bd_ports adc_clk]

# connections (dac)

connect_bd_net -net axi_ad9122_dac_clk_in_p       [get_bd_pins axi_ad9122_core/dac_clk_in_p]    [get_bd_ports tx_ref_clk_p]
connect_bd_net -net axi_ad9122_dac_clk_in_n       [get_bd_pins axi_ad9122_core/dac_clk_in_n]    [get_bd_ports tx_ref_clk_n]
connect_bd_net -net axi_ad9122_dac_clk_out_p      [get_bd_pins axi_ad9122_core/dac_clk_out_p]   [get_bd_ports tx_clk_p]
connect_bd_net -net axi_ad9122_dac_clk_out_n      [get_bd_pins axi_ad9122_core/dac_clk_out_n]   [get_bd_ports tx_clk_n]
connect_bd_net -net axi_ad9122_dac_frame_out_p    [get_bd_pins axi_ad9122_core/dac_frame_out_p] [get_bd_ports tx_frame_p]
connect_bd_net -net axi_ad9122_dac_frame_out_n    [get_bd_pins axi_ad9122_core/dac_frame_out_n] [get_bd_ports tx_frame_n]
connect_bd_net -net axi_ad9122_dac_data_out_p     [get_bd_pins axi_ad9122_core/dac_data_out_p]  [get_bd_ports tx_data_p]
connect_bd_net -net axi_ad9122_dac_data_out_n     [get_bd_pins axi_ad9122_core/dac_data_out_n]  [get_bd_ports tx_data_n]
connect_bd_net -net axi_ad9122_dac_div_clk        [get_bd_pins axi_ad9122_core/dac_div_clk]     [get_bd_pins axi_ad9122_dma/fifo_rd_clk]
connect_bd_net -net axi_ad9122_dac_valid_0        [get_bd_pins axi_ad9122_core/dac_valid_0]     [get_bd_ports dac_valid_0]
connect_bd_net -net axi_ad9122_dac_enable_0       [get_bd_pins axi_ad9122_core/dac_enable_0]    [get_bd_ports dac_enable_0]
connect_bd_net -net axi_ad9122_dac_ddata_0        [get_bd_pins axi_ad9122_core/dac_ddata_0]     [get_bd_ports dac_ddata_0]
connect_bd_net -net axi_ad9122_dac_valid_1        [get_bd_pins axi_ad9122_core/dac_valid_1]     [get_bd_ports dac_valid_1]
connect_bd_net -net axi_ad9122_dac_enable_1       [get_bd_pins axi_ad9122_core/dac_enable_1]    [get_bd_ports dac_enable_1]
connect_bd_net -net axi_ad9122_dac_ddata_1        [get_bd_pins axi_ad9122_core/dac_ddata_1]     [get_bd_ports dac_ddata_1]
connect_bd_net -net axi_ad9122_dma_drd            [get_bd_pins axi_ad9122_dma/fifo_rd_en]       [get_bd_ports dac_drd]
connect_bd_net -net axi_ad9122_dma_ddata          [get_bd_pins axi_ad9122_dma/fifo_rd_dout]     [get_bd_ports dac_ddata]
connect_bd_net -net axi_ad9122_dac_dunf           [get_bd_pins axi_ad9122_core/dac_dunf]        [get_bd_pins axi_ad9122_dma/fifo_rd_underflow]
connect_bd_net -net axi_ad9122_dma_irq            [get_bd_pins axi_ad9122_dma/irq]              [get_bd_pins sys_concat_intc/In3]

connect_bd_net -net axi_ad9122_dac_div_clk        [get_bd_ports dac_clk]

# interconnect (cpu)

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9122_dma/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9122_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9250_dma/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9250_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins axi_ad9250_jesd/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_daq1_gt/s_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq1_gt/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9122_core/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9122_dma/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9250_core/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9250_jesd/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9250_dma/s_axi_aclk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq1_gt/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9122_core/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9122_dma/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9250_core/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9250_jesd/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9250_dma/s_axi_aresetn]

# gt uses hp3, and 100MHz clock for both DRP and AXI4

connect_bd_intf_net -intf_net axi_daq1_gt_interconnect_m00_axi [get_bd_intf_pins axi_daq1_gt_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP3]
connect_bd_intf_net -intf_net axi_daq1_gt_interconnect_s00_axi [get_bd_intf_pins axi_daq1_gt_interconnect/S00_AXI] [get_bd_intf_pins axi_daq1_gt/m_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq1_gt_interconnect/ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq1_gt_interconnect/M00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq1_gt_interconnect/S00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP3_ACLK]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq1_gt/m_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq1_gt/drp_clk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq1_gt_interconnect/ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq1_gt_interconnect/M00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq1_gt_interconnect/S00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq1_gt/m_axi_aresetn]

# memory interconnects share the same clock (fclk2)

set sys_fmc_dma_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]
set sys_fmc_dma_resetn_source [get_bd_pins sys_ps7/FCLK_RESET2_N]

connect_bd_net -net sys_fmc_dma_clk $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_resetn $sys_fmc_dma_resetn_source

# interconnect (mem/dac)

connect_bd_intf_net -intf_net axi_ad9122_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9122_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
connect_bd_intf_net -intf_net axi_ad9122_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9122_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9122_dma/m_src_axi]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma/m_src_axi_aclk]
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9122_dma_interconnect/ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9122_dma_interconnect/M00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9122_dma_interconnect/S00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9122_dma/m_src_axi_aresetn]

connect_bd_intf_net -intf_net axi_ad9250_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9250_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
connect_bd_intf_net -intf_net axi_ad9250_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9250_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9250_dma/m_dest_axi]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9250_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9250_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9250_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9250_dma/m_dest_axi_aclk]
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9250_dma_interconnect/ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9250_dma_interconnect/M00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9250_dma_interconnect/S00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9250_dma/m_dest_axi_aresetn]

# ila

set ila_jesd_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_jesd_rx_mon]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {9}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH  {170} ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH  {4}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE2_WIDTH  {64}  ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE3_WIDTH  {1}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE4_WIDTH  {1}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE5_WIDTH  {32}  ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE6_WIDTH  {1}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE7_WIDTH  {1}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE8_WIDTH  {32}  ] $ila_jesd_rx_mon

connect_bd_net -net axi_daq1_gt_rx_mon_data     [get_bd_pins axi_daq1_gt/rx_mon_data]
connect_bd_net -net axi_daq1_gt_rx_mon_trigger  [get_bd_pins axi_daq1_gt/rx_mon_trigger]
connect_bd_net -net axi_daq1_gt_rx_clk          [get_bd_pins ila_jesd_rx_mon/CLK]
connect_bd_net -net axi_daq1_gt_rx_mon_data     [get_bd_pins ila_jesd_rx_mon/PROBE0]
connect_bd_net -net axi_daq1_gt_rx_mon_trigger  [get_bd_pins ila_jesd_rx_mon/PROBE1]
connect_bd_net -net axi_daq1_gt_rx_data         [get_bd_pins ila_jesd_rx_mon/PROBE2]
connect_bd_net -net axi_ad9250_adc_valid_a      [get_bd_pins ila_jesd_rx_mon/PROBE3]
connect_bd_net -net axi_ad9250_adc_enable_a     [get_bd_pins ila_jesd_rx_mon/PROBE4]
connect_bd_net -net axi_ad9250_adc_data_a       [get_bd_pins ila_jesd_rx_mon/PROBE5]
connect_bd_net -net axi_ad9250_adc_valid_b      [get_bd_pins ila_jesd_rx_mon/PROBE6]
connect_bd_net -net axi_ad9250_adc_enable_b     [get_bd_pins ila_jesd_rx_mon/PROBE7]
connect_bd_net -net axi_ad9250_adc_data_b       [get_bd_pins ila_jesd_rx_mon/PROBE8]

# address mapping

create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces sys_ps7/Data]          [get_bd_addr_segs axi_ad9122_core/s_axi/axi_lite]   SEG_data_ad9122_core
create_bd_addr_seg -range 0x00010000 -offset 0x7c400000 [get_bd_addr_spaces sys_ps7/Data]          [get_bd_addr_segs axi_ad9122_dma/s_axi/axi_lite]    SEG_data_ad9122_dma
create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces sys_ps7/Data]          [get_bd_addr_segs axi_ad9250_core/s_axi/axi_lite]   SEG_data_ad9250_core
create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 [get_bd_addr_spaces sys_ps7/Data]          [get_bd_addr_segs axi_ad9250_dma/s_axi/axi_lite]    SEG_data_ad9250_dma
create_bd_addr_seg -range 0x00001000 -offset 0x44A91000 [get_bd_addr_spaces sys_ps7/Data]          [get_bd_addr_segs axi_ad9250_jesd/s_axi/Reg]        SEG_data_ad9250_jesd
create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 [get_bd_addr_spaces sys_ps7/Data]          [get_bd_addr_segs axi_daq1_gt/s_axi/axi_lite]       SEG_data_daq1_gt

create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9122_dma/m_src_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM]   SEG_sys_ps7_hp1_ddr_lowocm
create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9250_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM]   SEG_sys_ps7_hp2_ddr_lowocm
create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_daq1_gt/m_axi]          [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM]   SEG_sys_ps7_hp3_ddr_lowocm
