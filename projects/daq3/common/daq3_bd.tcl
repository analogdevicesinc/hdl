
  # daq3

if {$sys_zynq == 1} {

  set spi_csn_2_o     [create_bd_port -dir O spi_csn_2_o]
  set spi_csn_1_o     [create_bd_port -dir O spi_csn_1_o]
  set spi_csn_0_o     [create_bd_port -dir O spi_csn_0_o]
  set spi_csn_i       [create_bd_port -dir I spi_csn_i]

} else {

  set spi_csn_o       [create_bd_port -dir O -from 2 -to 0 spi_csn_o]
  set spi_csn_i       [create_bd_port -dir I -from 2 -to 0 spi_csn_i]
}

  set spi_clk_i       [create_bd_port -dir I spi_clk_i]
  set spi_clk_o       [create_bd_port -dir O spi_clk_o]
  set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
  set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
  set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

  set rx_ref_clk      [create_bd_port -dir I rx_ref_clk]
  set rx_sync         [create_bd_port -dir O rx_sync]
  set rx_sysref       [create_bd_port -dir I rx_sysref]
  set rx_data_p       [create_bd_port -dir I -from 3 -to 0 rx_data_p]
  set rx_data_n       [create_bd_port -dir I -from 3 -to 0 rx_data_n]

  set tx_ref_clk      [create_bd_port -dir I tx_ref_clk]
  set tx_sync         [create_bd_port -dir I tx_sync]
  set tx_sysref       [create_bd_port -dir I tx_sysref]
  set tx_data_p       [create_bd_port -dir O -from 3 -to 0 tx_data_p]
  set tx_data_n       [create_bd_port -dir O -from 3 -to 0 tx_data_n]

if {$sys_zynq == 0} {

  set gpio_ctl_i      [create_bd_port -dir I -from 5 -to 0 gpio_ctl_i]
  set gpio_ctl_o      [create_bd_port -dir O -from 5 -to 0 gpio_ctl_o]
  set gpio_ctl_t      [create_bd_port -dir O -from 5 -to 0 gpio_ctl_t]
  set gpio_status_i   [create_bd_port -dir I -from 4 -to 0 gpio_status_i]
  set gpio_status_o   [create_bd_port -dir O -from 4 -to 0 gpio_status_o]
  set gpio_status_t   [create_bd_port -dir O -from 4 -to 0 gpio_status_t]
}

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
  set adc_enable_0    [create_bd_port -dir O adc_enable_0]
  set adc_valid_0     [create_bd_port -dir O adc_valid_0]
  set adc_data_0      [create_bd_port -dir O -from 63 -to 0 adc_data_0]
  set adc_enable_1    [create_bd_port -dir O adc_enable_1]
  set adc_valid_1     [create_bd_port -dir O adc_valid_1]
  set adc_data_1      [create_bd_port -dir O -from 63 -to 0 adc_data_1]
  set adc_dwr         [create_bd_port -dir I adc_dwr]
  set adc_dsync       [create_bd_port -dir I adc_dsync]
  set adc_ddata       [create_bd_port -dir I -from 127 -to 0 adc_ddata]

  # dac peripherals

  set axi_ad9152_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9152:1.0 axi_ad9152_core]

  set axi_ad9152_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.2 axi_ad9152_jesd]
  set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {1}] $axi_ad9152_jesd
  set_property -dict [list CONFIG.C_LANES {4}] $axi_ad9152_jesd

  set axi_ad9152_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9152_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9152_dma
  set_property -dict [list CONFIG.PCORE_ID {1}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {128}] $axi_ad9152_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {128}] $axi_ad9152_dma

if {$sys_zynq == 1} {

  set axi_ad9152_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9152_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9152_dma_interconnect
}

  # adc peripherals

  set axi_ad9680_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9680:1.0 axi_ad9680_core]

  set axi_ad9680_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.2 axi_ad9680_jesd]
  set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9680_jesd
  set_property -dict [list CONFIG.C_LANES {4}] $axi_ad9680_jesd

  set axi_ad9680_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9680_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {1}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9680_dma
  set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9680_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9680_dma

if {$sys_zynq == 1} {

  set axi_ad9680_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9680_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9680_dma_interconnect
}

  # dac/adc common gt/gpio

  set axi_daq3_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_daq3_gt]
  set_property -dict [list CONFIG.PCORE_NUM_OF_TX_LANES {4}] $axi_daq3_gt
  set_property -dict [list CONFIG.PCORE_NUM_OF_RX_LANES {4}] $axi_daq3_gt
  set_property -dict [list CONFIG.PCORE_TX_LANE_SEL_0 {0}] $axi_daq3_gt
  set_property -dict [list CONFIG.PCORE_TX_LANE_SEL_1 {3}] $axi_daq3_gt
  set_property -dict [list CONFIG.PCORE_TX_LANE_SEL_2 {1}] $axi_daq3_gt
  set_property -dict [list CONFIG.PCORE_TX_LANE_SEL_3 {2}] $axi_daq3_gt

if {$sys_zynq == 1} {

  set axi_daq3_gt_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_daq3_gt_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_daq3_gt_interconnect
}

  # gpio and spi

if {$sys_zynq == 0} {

  set axi_daq3_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_daq3_spi]
  set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_daq3_spi
  set_property -dict [list CONFIG.C_NUM_SS_BITS {3}] $axi_daq3_spi
  set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_daq3_spi

  set axi_daq3_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_daq3_gpio]
  set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_daq3_gpio
  set_property -dict [list CONFIG.C_GPIO_WIDTH {5}] $axi_daq3_gpio
  set_property -dict [list CONFIG.C_GPIO2_WIDTH {6}] $axi_daq3_gpio
  set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_daq3_gpio
}

  # additions to default configuration

if {$sys_zynq == 0} {

  set_property -dict [list CONFIG.NUM_MI {16}] $axi_cpu_interconnect

} else {

  set_property -dict [list CONFIG.NUM_MI {14}] $axi_cpu_interconnect
}

if {$sys_zynq == 0} {

  set_property -dict [list CONFIG.NUM_SI {11}] $axi_mem_interconnect
}

if {$sys_zynq == 1} {

  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
  set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {43}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7

  set_property LEFT 42 [get_bd_ports GPIO_I]
  set_property LEFT 42 [get_bd_ports GPIO_O]
  set_property LEFT 42 [get_bd_ports GPIO_T]
}

  # connections (spi and gpio)

if {$sys_zynq == 0} {

  connect_bd_net -net spi_csn_i [get_bd_ports spi_csn_i]  [get_bd_pins axi_daq3_spi/ss_i]
  connect_bd_net -net spi_csn_o [get_bd_ports spi_csn_o]  [get_bd_pins axi_daq3_spi/ss_o]
  connect_bd_net -net spi_clk_i [get_bd_ports spi_clk_i]  [get_bd_pins axi_daq3_spi/sck_i]
  connect_bd_net -net spi_clk_o [get_bd_ports spi_clk_o]  [get_bd_pins axi_daq3_spi/sck_o]
  connect_bd_net -net spi_sdo_i [get_bd_ports spi_sdo_i]  [get_bd_pins axi_daq3_spi/io0_i]
  connect_bd_net -net spi_sdo_o [get_bd_ports spi_sdo_o]  [get_bd_pins axi_daq3_spi/io0_o]
  connect_bd_net -net spi_sdi_i [get_bd_ports spi_sdi_i]  [get_bd_pins axi_daq3_spi/io1_i]

} else {

  connect_bd_net -net spi_csn_2_o [get_bd_ports spi_csn_2_o]  [get_bd_pins sys_ps7/SPI0_SS2_O]
  connect_bd_net -net spi_csn_1_o [get_bd_ports spi_csn_1_o]  [get_bd_pins sys_ps7/SPI0_SS1_O]
  connect_bd_net -net spi_csn_0_o [get_bd_ports spi_csn_0_o]  [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]    [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi_clk_i   [get_bd_ports spi_clk_i]    [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi_clk_o   [get_bd_ports spi_clk_o]    [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net spi_sdo_i   [get_bd_ports spi_sdo_i]    [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi_sdo_o   [get_bd_ports spi_sdo_o]    [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi_sdi_i   [get_bd_ports spi_sdi_i]    [get_bd_pins sys_ps7/SPI0_MISO_I]
}

if {$sys_zynq == 0} {

  connect_bd_net -net gpio_status_i [get_bd_ports gpio_status_i]  [get_bd_pins axi_daq3_gpio/gpio_io_i]   
  connect_bd_net -net gpio_status_o [get_bd_ports gpio_status_o]  [get_bd_pins axi_daq3_gpio/gpio_io_o]   
  connect_bd_net -net gpio_status_t [get_bd_ports gpio_status_t]  [get_bd_pins axi_daq3_gpio/gpio_io_t]   
  connect_bd_net -net gpio_ctl_i    [get_bd_ports gpio_ctl_i]     [get_bd_pins axi_daq3_gpio/gpio2_io_i]  
  connect_bd_net -net gpio_ctl_o    [get_bd_ports gpio_ctl_o]     [get_bd_pins axi_daq3_gpio/gpio2_io_o]  
  connect_bd_net -net gpio_ctl_t    [get_bd_ports gpio_ctl_t]     [get_bd_pins axi_daq3_gpio/gpio2_io_t]  
}

  # connections (gt)

  connect_bd_net -net axi_daq3_gt_ref_clk_q         [get_bd_pins axi_daq3_gt/ref_clk_q]         [get_bd_ports rx_ref_clk]   
  connect_bd_net -net axi_daq3_gt_ref_clk_c         [get_bd_pins axi_daq3_gt/ref_clk_c]         [get_bd_ports tx_ref_clk]   
  connect_bd_net -net axi_daq3_gt_rx_data_p         [get_bd_pins axi_daq3_gt/rx_data_p]         [get_bd_ports rx_data_p]   
  connect_bd_net -net axi_daq3_gt_rx_data_n         [get_bd_pins axi_daq3_gt/rx_data_n]         [get_bd_ports rx_data_n]   
  connect_bd_net -net axi_daq3_gt_rx_sync           [get_bd_pins axi_daq3_gt/rx_sync]           [get_bd_ports rx_sync]   
  connect_bd_net -net axi_daq3_gt_rx_ext_sysref     [get_bd_pins axi_daq3_gt/rx_ext_sysref]     [get_bd_ports rx_sysref]   
  connect_bd_net -net axi_daq3_gt_tx_data_p         [get_bd_pins axi_daq3_gt/tx_data_p]         [get_bd_ports tx_data_p]   
  connect_bd_net -net axi_daq3_gt_tx_data_n         [get_bd_pins axi_daq3_gt/tx_data_n]         [get_bd_ports tx_data_n]   
  connect_bd_net -net axi_daq3_gt_tx_sync           [get_bd_pins axi_daq3_gt/tx_sync]           [get_bd_ports tx_sync]   
  connect_bd_net -net axi_daq3_gt_tx_ext_sysref     [get_bd_pins axi_daq3_gt/tx_ext_sysref]     [get_bd_ports tx_sysref]   

  # connections (dac)

  connect_bd_net -net axi_daq3_gt_tx_clk [get_bd_pins axi_daq3_gt/tx_clk_g]
  connect_bd_net -net axi_daq3_gt_tx_clk [get_bd_pins axi_daq3_gt/tx_clk]
  connect_bd_net -net axi_daq3_gt_tx_clk [get_bd_pins axi_ad9152_core/tx_clk]
  connect_bd_net -net axi_daq3_gt_tx_clk [get_bd_pins axi_ad9152_jesd/tx_core_clk]

  connect_bd_net -net axi_daq3_gt_tx_rst            [get_bd_pins axi_daq3_gt/tx_rst]            [get_bd_pins axi_ad9152_jesd/tx_reset]
  connect_bd_net -net axi_daq3_gt_tx_sysref         [get_bd_pins axi_daq3_gt/tx_sysref]         [get_bd_pins axi_ad9152_jesd/tx_sysref]
  connect_bd_net -net axi_daq3_gt_tx_gt_charisk     [get_bd_pins axi_daq3_gt/tx_gt_charisk]     [get_bd_pins axi_ad9152_jesd/gt_txcharisk_out]
  connect_bd_net -net axi_daq3_gt_tx_gt_data        [get_bd_pins axi_daq3_gt/tx_gt_data]        [get_bd_pins axi_ad9152_jesd/gt_txdata_out]
  connect_bd_net -net axi_daq3_gt_tx_rst_done       [get_bd_pins axi_daq3_gt/tx_rst_done]       [get_bd_pins axi_ad9152_jesd/tx_reset_done]
  connect_bd_net -net axi_daq3_gt_tx_ip_sync        [get_bd_pins axi_daq3_gt/tx_ip_sync]        [get_bd_pins axi_ad9152_jesd/tx_sync]
  connect_bd_net -net axi_daq3_gt_tx_ip_sof         [get_bd_pins axi_daq3_gt/tx_ip_sof]         [get_bd_pins axi_ad9152_jesd/tx_start_of_frame]
  connect_bd_net -net axi_daq3_gt_tx_ip_data        [get_bd_pins axi_daq3_gt/tx_ip_data]        [get_bd_pins axi_ad9152_jesd/tx_tdata]
  connect_bd_net -net axi_daq3_gt_tx_data           [get_bd_pins axi_daq3_gt/tx_data]           [get_bd_pins axi_ad9152_core/tx_data]
  connect_bd_net -net axi_ad9152_dac_clk            [get_bd_pins axi_ad9152_core/dac_clk]       [get_bd_pins axi_ad9152_dma/fifo_rd_clk]
  connect_bd_net -net axi_ad9152_dac_valid_0        [get_bd_pins axi_ad9152_core/dac_valid_0]   [get_bd_ports dac_valid_0]  
  connect_bd_net -net axi_ad9152_dac_enable_0       [get_bd_pins axi_ad9152_core/dac_enable_0]  [get_bd_ports dac_enable_0]
  connect_bd_net -net axi_ad9152_dac_ddata_0        [get_bd_pins axi_ad9152_core/dac_ddata_0]   [get_bd_ports dac_ddata_0]
  connect_bd_net -net axi_ad9152_dac_valid_1        [get_bd_pins axi_ad9152_core/dac_valid_1]   [get_bd_ports dac_valid_1]
  connect_bd_net -net axi_ad9152_dac_enable_1       [get_bd_pins axi_ad9152_core/dac_enable_1]  [get_bd_ports dac_enable_1]
  connect_bd_net -net axi_ad9152_dac_ddata_1        [get_bd_pins axi_ad9152_core/dac_ddata_1]   [get_bd_ports dac_ddata_1]
  connect_bd_net -net axi_ad9152_dac_drd            [get_bd_ports dac_drd]                      [get_bd_pins axi_ad9152_dma/fifo_rd_en]
  connect_bd_net -net axi_ad9152_dac_ddata          [get_bd_ports dac_ddata]                    [get_bd_pins axi_ad9152_dma/fifo_rd_dout]
  connect_bd_net -net axi_ad9152_dac_dunf           [get_bd_pins axi_ad9152_core/dac_dunf]      [get_bd_pins axi_ad9152_dma/fifo_rd_underflow]

  # connections (adc)

  connect_bd_net -net axi_daq3_gt_rx_clk [get_bd_pins axi_daq3_gt/rx_clk_g]
  connect_bd_net -net axi_daq3_gt_rx_clk [get_bd_pins axi_daq3_gt/rx_clk]
  connect_bd_net -net axi_daq3_gt_rx_clk [get_bd_pins axi_ad9680_core/rx_clk]
  connect_bd_net -net axi_daq3_gt_rx_clk [get_bd_pins axi_ad9680_jesd/rx_core_clk]

  connect_bd_net -net axi_daq3_gt_rx_rst            [get_bd_pins axi_daq3_gt/rx_rst]            [get_bd_pins axi_ad9680_jesd/rx_reset]
  connect_bd_net -net axi_daq3_gt_rx_sysref         [get_bd_pins axi_daq3_gt/rx_sysref]         [get_bd_pins axi_ad9680_jesd/rx_sysref]
  connect_bd_net -net axi_daq3_gt_rx_gt_charisk     [get_bd_pins axi_daq3_gt/rx_gt_charisk]     [get_bd_pins axi_ad9680_jesd/gt_rxcharisk_in]
  connect_bd_net -net axi_daq3_gt_rx_gt_disperr     [get_bd_pins axi_daq3_gt/rx_gt_disperr]     [get_bd_pins axi_ad9680_jesd/gt_rxdisperr_in]
  connect_bd_net -net axi_daq3_gt_rx_gt_notintable  [get_bd_pins axi_daq3_gt/rx_gt_notintable]  [get_bd_pins axi_ad9680_jesd/gt_rxnotintable_in]
  connect_bd_net -net axi_daq3_gt_rx_gt_data        [get_bd_pins axi_daq3_gt/rx_gt_data]        [get_bd_pins axi_ad9680_jesd/gt_rxdata_in]
  connect_bd_net -net axi_daq3_gt_rx_rst_done       [get_bd_pins axi_daq3_gt/rx_rst_done]       [get_bd_pins axi_ad9680_jesd/rx_reset_done]
  connect_bd_net -net axi_daq3_gt_rx_ip_comma_align [get_bd_pins axi_daq3_gt/rx_ip_comma_align] [get_bd_pins axi_ad9680_jesd/rxencommaalign_out]
  connect_bd_net -net axi_daq3_gt_rx_ip_sync        [get_bd_pins axi_daq3_gt/rx_ip_sync]        [get_bd_pins axi_ad9680_jesd/rx_sync]
  connect_bd_net -net axi_daq3_gt_rx_ip_sof         [get_bd_pins axi_daq3_gt/rx_ip_sof]         [get_bd_pins axi_ad9680_jesd/rx_start_of_frame]
  connect_bd_net -net axi_daq3_gt_rx_ip_data        [get_bd_pins axi_daq3_gt/rx_ip_data]        [get_bd_pins axi_ad9680_jesd/rx_tdata]
  connect_bd_net -net axi_daq3_gt_rx_data           [get_bd_pins axi_daq3_gt/rx_data]           [get_bd_pins axi_ad9680_core/rx_data]

  connect_bd_net -net axi_ad9680_adc_enable_0       [get_bd_pins axi_ad9680_core/adc_enable_0]  [get_bd_ports adc_enable_0]
  connect_bd_net -net axi_ad9680_adc_valid_0        [get_bd_pins axi_ad9680_core/adc_valid_0]   [get_bd_ports adc_valid_0]
  connect_bd_net -net axi_ad9680_adc_data_0         [get_bd_pins axi_ad9680_core/adc_data_0]    [get_bd_ports adc_data_0]
  connect_bd_net -net axi_ad9680_adc_enable_1       [get_bd_pins axi_ad9680_core/adc_enable_1]  [get_bd_ports adc_enable_1]
  connect_bd_net -net axi_ad9680_adc_valid_1        [get_bd_pins axi_ad9680_core/adc_valid_1]   [get_bd_ports adc_valid_1]
  connect_bd_net -net axi_ad9680_adc_data_1         [get_bd_pins axi_ad9680_core/adc_data_1]    [get_bd_ports adc_data_1]

  connect_bd_net -net axi_daq3_gt_rx_rst            [get_bd_pins axi_ad9680_fifo/adc_rst]       [get_bd_pins axi_daq3_gt/rx_rst]
  connect_bd_net -net axi_ad9680_adc_clk            [get_bd_pins axi_ad9680_core/adc_clk]       [get_bd_pins axi_ad9680_fifo/adc_clk]
  connect_bd_net -net axi_ad9680_adc_dovf           [get_bd_pins axi_ad9680_core/adc_dovf]      [get_bd_pins axi_ad9680_fifo/adc_wovf]
  connect_bd_net -net axi_ad9680_adc_dwr            [get_bd_ports adc_dwr]                      [get_bd_pins axi_ad9680_fifo/adc_wr]
  connect_bd_net -net axi_ad9680_adc_ddata          [get_bd_ports adc_ddata]                    [get_bd_pins axi_ad9680_fifo/adc_wdata]

  connect_bd_net -net sys_100m_clk                  [get_bd_pins axi_ad9680_fifo/dma_clk]       [get_bd_pins axi_ad9680_dma/s_axis_aclk]
  connect_bd_net -net axi_ad9680_dma_dvalid         [get_bd_pins axi_ad9680_fifo/dma_wr]        [get_bd_pins axi_ad9680_dma/s_axis_valid]
  connect_bd_net -net axi_ad9680_dma_ddata          [get_bd_pins axi_ad9680_fifo/dma_wdata]     [get_bd_pins axi_ad9680_dma/s_axis_data]
  connect_bd_net -net axi_ad9680_dma_dready         [get_bd_pins axi_ad9680_fifo/dma_wready]    [get_bd_pins axi_ad9680_dma/s_axis_ready]
  connect_bd_net -net axi_ad9680_dma_xfer_req       [get_bd_pins axi_ad9680_fifo/dma_xfer_req]  [get_bd_pins axi_ad9680_dma/s_axis_xfer_req]

  # dac/adc clocks

  connect_bd_net -net axi_ad9152_dac_clk [get_bd_ports dac_clk]
  connect_bd_net -net axi_ad9680_adc_clk [get_bd_ports adc_clk]

  # interconnect (cpu)

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9152_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9152_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9152_jesd/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9680_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins axi_ad9680_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_ad9680_jesd/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m13_axi [get_bd_intf_pins axi_cpu_interconnect/M13_AXI] [get_bd_intf_pins axi_daq3_gt/s_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M13_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gt/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9152_core/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9152_jesd/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9152_dma/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9680_core/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9680_jesd/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9680_dma/s_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M13_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq3_gt/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9152_core/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9152_jesd/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9152_dma/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9680_core/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9680_jesd/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9680_dma/s_axi_aresetn]

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m14_axi [get_bd_intf_pins axi_cpu_interconnect/M14_AXI] [get_bd_intf_pins axi_daq3_spi/axi_lite]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m15_axi [get_bd_intf_pins axi_cpu_interconnect/M15_AXI] [get_bd_intf_pins axi_daq3_gpio/s_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M14_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M15_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_spi/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_spi/ext_spi_clk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gpio/s_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M14_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M15_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq3_spi/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq3_gpio/s_axi_aresetn] 
}

if {$sys_zynq == 0} {

  delete_bd_objs [get_bd_nets mb_intr_10_s] [get_bd_ports mb_intr_10]
  delete_bd_objs [get_bd_nets mb_intr_11_s] [get_bd_ports mb_intr_11]
  delete_bd_objs [get_bd_nets mb_intr_12_s] [get_bd_ports mb_intr_12]
  delete_bd_objs [get_bd_nets mb_intr_13_s] [get_bd_ports mb_intr_13]
  connect_bd_net -net axi_daq3_spi_intr     [get_bd_pins axi_daq3_spi/ip2intc_irpt]   [get_bd_pins sys_concat_intc/In10]
  connect_bd_net -net axi_daq3_gpio_intr    [get_bd_pins axi_daq3_gpio/ip2intc_irpt]  [get_bd_pins sys_concat_intc/In11]
  connect_bd_net -net axi_ad9152_dma_intr   [get_bd_pins axi_ad9152_dma/irq]          [get_bd_pins sys_concat_intc/In12]
  connect_bd_net -net axi_ad9680_dma_intr   [get_bd_pins axi_ad9680_dma/irq]          [get_bd_pins sys_concat_intc/In13]

} else {

  delete_bd_objs [get_bd_nets ps_intr_12_s] [get_bd_ports ps_intr_12]
  delete_bd_objs [get_bd_nets ps_intr_13_s] [get_bd_ports ps_intr_13]
  connect_bd_net -net axi_ad9152_dma_intr   [get_bd_pins axi_ad9152_dma/irq]            [get_bd_pins sys_concat_intc/In12]
  connect_bd_net -net axi_ad9680_dma_intr   [get_bd_pins axi_ad9680_dma/irq]            [get_bd_pins sys_concat_intc/In13]

}

  # gt uses hp3, and 100MHz clock for both DRP and AXI4

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_mem_interconnect_s08_axi [get_bd_intf_pins axi_mem_interconnect/S08_AXI] [get_bd_intf_pins axi_daq3_gt/m_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gt/m_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gt/drp_clk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq3_gt/m_axi_aresetn] 

} else {

  connect_bd_intf_net -intf_net axi_daq3_gt_interconnect_m00_axi [get_bd_intf_pins axi_daq3_gt_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP3]
  connect_bd_intf_net -intf_net axi_daq3_gt_interconnect_s00_axi [get_bd_intf_pins axi_daq3_gt_interconnect/S00_AXI] [get_bd_intf_pins axi_daq3_gt/m_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gt_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gt_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gt_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP3_ACLK]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gt/m_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_daq3_gt/drp_clk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq3_gt_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq3_gt_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq3_gt_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_daq3_gt/m_axi_aresetn] 
}

  # memory interconnects share the same clock (fclk2)

  # interconnect (mem/dac)

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_mem_interconnect_s09_axi [get_bd_intf_pins axi_mem_interconnect/S09_AXI] [get_bd_intf_pins axi_ad9152_dma/m_src_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9152_dma/m_src_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9152_dma/m_src_axi_aresetn] 

  connect_bd_intf_net -intf_net axi_mem_interconnect_s10_axi [get_bd_intf_pins axi_mem_interconnect/S10_AXI] [get_bd_intf_pins axi_ad9680_dma/m_dest_axi]    
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9680_dma/m_dest_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9680_dma/m_dest_axi_aresetn] 

} else {

  connect_bd_intf_net -intf_net axi_ad9152_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9152_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_ad9152_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9152_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9152_dma/m_src_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9152_dma_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9152_dma_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9152_dma_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9152_dma/m_src_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9152_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9152_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9152_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9152_dma/m_src_axi_aresetn] 

  connect_bd_intf_net -intf_net axi_ad9680_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9680_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_ad9680_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9680_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9680_dma/m_dest_axi]    
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9680_dma_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9680_dma_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9680_dma_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9680_dma/m_dest_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9680_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9680_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9680_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9680_dma/m_dest_axi_aresetn] 
}

  # ila

  set ila_jesd_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_jesd_rx_mon]
  set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_jesd_rx_mon
  set_property -dict [list CONFIG.C_NUM_OF_PROBES {1}] $ila_jesd_rx_mon
  set_property -dict [list CONFIG.C_PROBE0_WIDTH {128}] $ila_jesd_rx_mon

  connect_bd_net -net axi_daq3_gt_rx_clk            [get_bd_pins ila_jesd_rx_mon/CLK]
  connect_bd_net -net axi_ad9680_adc_ddata          [get_bd_pins ila_jesd_rx_mon/PROBE0]

  # address map

  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9152_core/s_axi/axi_lite]   SEG_data_ad9152_core
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9680_core/s_axi/axi_lite]   SEG_data_ad9680_core
  create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 $sys_addr_cntrl_space [get_bd_addr_segs axi_daq3_gt/s_axi/axi_lite]       SEG_data_daq3_gt
  create_bd_addr_seg -range 0x00001000 -offset 0x44A90000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9152_jesd/s_axi/Reg]        SEG_data_ad9152_jesd
  create_bd_addr_seg -range 0x00001000 -offset 0x44A91000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9680_jesd/s_axi/Reg]        SEG_data_ad9680_jesd
  create_bd_addr_seg -range 0x00010000 -offset 0x7c400000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9680_dma/s_axi/axi_lite]    SEG_data_ad9680_dma
  create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9152_dma/s_axi/axi_lite]    SEG_data_ad9152_dma

if {$sys_zynq == 0} {

  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_daq3_gpio/S_AXI/Reg]          SEG_data_daq3_gpio
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_daq3_spi/axi_lite/Reg]        SEG_data_daq3_spi
}

if {$sys_zynq == 0} {

  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9152_dma/m_src_axi]   $sys_addr_mem_seg SEG_axi_ddr_cntrl
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9680_dma/m_dest_axi]  $sys_addr_mem_seg SEG_axi_ddr_cntrl
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_daq3_gt/m_axi]          $sys_addr_mem_seg SEG_axi_ddr_cntrl

} else {

  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9152_dma/m_src_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM]    SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9680_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM]    SEG_sys_ps7_hp2_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_daq3_gt/m_axi]          [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM]    SEG_sys_ps7_hp3_ddr_lowocm

}

