
  # fmcadc3

if {$sys_zynq == 0} {

  set spi_csn_i       [create_bd_port -dir I -from 2 -to 0 spi_csn_i]
  set spi_csn_o       [create_bd_port -dir O -from 2 -to 0 spi_csn_o]

} else {

  set spi_csn_0       [create_bd_port -dir O spi_csn_0]
  set spi_csn_1       [create_bd_port -dir O spi_csn_1]
  set spi_csn_2       [create_bd_port -dir O spi_csn_2]
  set spi_csn_i       [create_bd_port -dir I spi_csn_i]
}

  set spi_clk_i       [create_bd_port -dir I spi_clk_i]
  set spi_clk_o       [create_bd_port -dir O spi_clk_o]
  set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
  set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
  set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

  set rx_ref_clk      [create_bd_port -dir I rx_ref_clk]
  set rx_sync         [create_bd_port -dir O rx_sync]
  set rx_sysref       [create_bd_port -dir I rx_sysref]
  set rx_data_p       [create_bd_port -dir I -from 7 -to 0 rx_data_p]
  set rx_data_n       [create_bd_port -dir I -from 7 -to 0 rx_data_n]

if {$sys_zynq == 0} {

  set gpio_ctl_i      [create_bd_port -dir I gpio_ctl_i]
  set gpio_ctl_o      [create_bd_port -dir O gpio_ctl_o]
  set gpio_ctl_t      [create_bd_port -dir O gpio_ctl_t]
  set gpio_status_i   [create_bd_port -dir I -from 4 -to 0 gpio_status_i]
  set gpio_status_o   [create_bd_port -dir O -from 4 -to 0 gpio_status_o]
  set gpio_status_t   [create_bd_port -dir O -from 4 -to 0 gpio_status_t]
}

  set gt_data         [create_bd_port -dir O -from 255 -to 0 gt_data]
  set gt_data_0       [create_bd_port -dir I -from 127 -to 0 gt_data_0]
  set gt_data_1       [create_bd_port -dir I -from 127 -to 0 gt_data_1]
  set adc_clk         [create_bd_port -dir O adc_clk]
  set adc_enable_0    [create_bd_port -dir O adc_enable_0]
  set adc_valid_0     [create_bd_port -dir O adc_valid_0]
  set adc_data_0      [create_bd_port -dir O -from 63 -to 0 adc_data_0]
  set adc_enable_1    [create_bd_port -dir O adc_enable_1]
  set adc_valid_1     [create_bd_port -dir O adc_valid_1]
  set adc_data_1      [create_bd_port -dir O -from 63 -to 0 adc_data_1]
  set adc_enable_2    [create_bd_port -dir O adc_enable_2]
  set adc_valid_2     [create_bd_port -dir O adc_valid_2]
  set adc_data_2      [create_bd_port -dir O -from 63 -to 0 adc_data_2]
  set adc_enable_3    [create_bd_port -dir O adc_enable_3]
  set adc_valid_3     [create_bd_port -dir O adc_valid_3]
  set adc_data_3      [create_bd_port -dir O -from 63 -to 0 adc_data_3]
  set adc_dwr         [create_bd_port -dir I adc_dwr]
  set adc_dsync       [create_bd_port -dir I adc_dsync]
  set adc_ddata       [create_bd_port -dir I -from 255 -to 0 adc_ddata]

  # adc peripherals

  set axi_ad9234_core_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9234:1.0 axi_ad9234_core_0]
  set axi_ad9234_core_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9234:1.0 axi_ad9234_core_1]

  set axi_ad9234_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.2 axi_ad9234_jesd]
  set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9234_jesd
  set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9234_jesd

  set axi_ad9234_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9234_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9234_dma
  set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {256}] $axi_ad9234_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {256}] $axi_ad9234_dma

if {$sys_zynq == 1} {

  set axi_ad9234_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9234_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9234_dma_interconnect
}

  # dac/adc common gt/gpio

  set axi_fmcadc3_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_fmcadc3_gt]
  set_property -dict [list CONFIG.PCORE_NUM_OF_LANES {8}] $axi_fmcadc3_gt

if {$sys_zynq == 1} {

  set axi_fmcadc3_gt_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_fmcadc3_gt_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_fmcadc3_gt_interconnect
}

  # gpio and spi

if {$sys_zynq == 0} {

  set axi_fmcadc3_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 axi_fmcadc3_spi]
  set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_fmcadc3_spi
  set_property -dict [list CONFIG.C_NUM_SS_BITS {3}] $axi_fmcadc3_spi
  set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_fmcadc3_spi

  set axi_fmcadc3_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_fmcadc3_gpio]
  set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_fmcadc3_gpio
  set_property -dict [list CONFIG.C_GPIO_WIDTH {5}] $axi_fmcadc3_gpio
  set_property -dict [list CONFIG.C_GPIO2_WIDTH {1}] $axi_fmcadc3_gpio
  set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_fmcadc3_gpio
}

  # additions to default configuration

if {$sys_zynq == 0} {

  set_property -dict [list CONFIG.NUM_MI {14}] $axi_cpu_interconnect

} else {

  set_property -dict [list CONFIG.NUM_MI {12}] $axi_cpu_interconnect
}

if {$sys_zynq == 0} {

  set_property -dict [list CONFIG.NUM_SI {11}] $axi_mem_interconnect
  set_property -dict [list CONFIG.NUM_PORTS {7}] $sys_concat_intc
}

if {$sys_zynq == 1} {

  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
  set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {38}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7

  set_property LEFT 37 [get_bd_ports GPIO_I]
  set_property LEFT 37 [get_bd_ports GPIO_O]
  set_property LEFT 37 [get_bd_ports GPIO_T]
}

  # connections (spi and gpio)

if {$sys_zynq == 0} {

  connect_bd_net -net spi_csn_i [get_bd_ports spi_csn_i]  [get_bd_pins axi_fmcadc3_spi/ss_i]
  connect_bd_net -net spi_csn_o [get_bd_ports spi_csn_o]  [get_bd_pins axi_fmcadc3_spi/ss_o]
  connect_bd_net -net spi_clk_i [get_bd_ports spi_clk_i]  [get_bd_pins axi_fmcadc3_spi/sck_i]
  connect_bd_net -net spi_clk_o [get_bd_ports spi_clk_o]  [get_bd_pins axi_fmcadc3_spi/sck_o]
  connect_bd_net -net spi_sdo_i [get_bd_ports spi_sdo_i]  [get_bd_pins axi_fmcadc3_spi/io0_i]
  connect_bd_net -net spi_sdo_o [get_bd_ports spi_sdo_o]  [get_bd_pins axi_fmcadc3_spi/io0_o]
  connect_bd_net -net spi_sdi_i [get_bd_ports spi_sdi_i]  [get_bd_pins axi_fmcadc3_spi/io1_i]

} else {

  connect_bd_net -net spi_csn_0 [get_bd_ports spi_csn_0]  [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi_csn_1 [get_bd_ports spi_csn_1]  [get_bd_pins sys_ps7/SPI0_SS1_O]
  connect_bd_net -net spi_csn_2 [get_bd_ports spi_csn_2]  [get_bd_pins sys_ps7/SPI0_SS2_O]
  connect_bd_net -net spi_csn_i [get_bd_ports spi_csn_i]  [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi_clk_i [get_bd_ports spi_clk_i]  [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi_clk_o [get_bd_ports spi_clk_o]  [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net spi_sdo_i [get_bd_ports spi_sdo_i]  [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi_sdo_o [get_bd_ports spi_sdo_o]  [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi_sdi_i [get_bd_ports spi_sdi_i]  [get_bd_pins sys_ps7/SPI0_MISO_I]
}

if {$sys_zynq == 0} {

  connect_bd_net -net gpio_status_i [get_bd_ports gpio_status_i]  [get_bd_pins axi_fmcadc3_gpio/gpio_io_i]   
  connect_bd_net -net gpio_status_o [get_bd_ports gpio_status_o]  [get_bd_pins axi_fmcadc3_gpio/gpio_io_o]   
  connect_bd_net -net gpio_status_t [get_bd_ports gpio_status_t]  [get_bd_pins axi_fmcadc3_gpio/gpio_io_t]   
  connect_bd_net -net gpio_ctl_i    [get_bd_ports gpio_ctl_i]     [get_bd_pins axi_fmcadc3_gpio/gpio2_io_i]  
  connect_bd_net -net gpio_ctl_o    [get_bd_ports gpio_ctl_o]     [get_bd_pins axi_fmcadc3_gpio/gpio2_io_o]  
  connect_bd_net -net gpio_ctl_t    [get_bd_ports gpio_ctl_t]     [get_bd_pins axi_fmcadc3_gpio/gpio2_io_t]  
}

if {$sys_zynq == 0} {

  delete_bd_objs [get_bd_nets sys_concat_intc_din_2] [get_bd_ports unc_int2]
  delete_bd_objs [get_bd_nets sys_concat_intc_din_3] [get_bd_ports unc_int3]
}

  # connections (gt)

  connect_bd_net -net axi_fmcadc3_gt_ref_clk_q         [get_bd_pins axi_fmcadc3_gt/ref_clk_q]         [get_bd_ports rx_ref_clk]   
  connect_bd_net -net axi_fmcadc3_gt_rx_data_p         [get_bd_pins axi_fmcadc3_gt/rx_data_p]         [get_bd_ports rx_data_p]   
  connect_bd_net -net axi_fmcadc3_gt_rx_data_n         [get_bd_pins axi_fmcadc3_gt/rx_data_n]         [get_bd_ports rx_data_n]   
  connect_bd_net -net axi_fmcadc3_gt_rx_sync           [get_bd_pins axi_fmcadc3_gt/rx_sync]           [get_bd_ports rx_sync]   
  connect_bd_net -net axi_fmcadc3_gt_rx_ext_sysref     [get_bd_pins axi_fmcadc3_gt/rx_ext_sysref]     [get_bd_ports rx_sysref]   

  # connections (adc)

  connect_bd_net -net axi_fmcadc3_gt_rx_clk [get_bd_pins axi_fmcadc3_gt/rx_clk_g]
  connect_bd_net -net axi_fmcadc3_gt_rx_clk [get_bd_pins axi_fmcadc3_gt/rx_clk]
  connect_bd_net -net axi_fmcadc3_gt_rx_clk [get_bd_pins axi_ad9234_core_0/rx_clk]
  connect_bd_net -net axi_fmcadc3_gt_rx_clk [get_bd_pins axi_ad9234_core_1/rx_clk]
  connect_bd_net -net axi_fmcadc3_gt_rx_clk [get_bd_pins axi_ad9234_jesd/rx_core_clk]

  connect_bd_net -net axi_fmcadc3_gt_rx_rst            [get_bd_pins axi_fmcadc3_gt/rx_rst]            [get_bd_pins axi_ad9234_jesd/rx_reset]
  connect_bd_net -net axi_fmcadc3_gt_rx_sysref         [get_bd_pins axi_fmcadc3_gt/rx_sysref]         [get_bd_pins axi_ad9234_jesd/rx_sysref]
  connect_bd_net -net axi_fmcadc3_gt_rx_gt_charisk     [get_bd_pins axi_fmcadc3_gt/rx_gt_charisk]     [get_bd_pins axi_ad9234_jesd/gt_rxcharisk_in]
  connect_bd_net -net axi_fmcadc3_gt_rx_gt_disperr     [get_bd_pins axi_fmcadc3_gt/rx_gt_disperr]     [get_bd_pins axi_ad9234_jesd/gt_rxdisperr_in]
  connect_bd_net -net axi_fmcadc3_gt_rx_gt_notintable  [get_bd_pins axi_fmcadc3_gt/rx_gt_notintable]  [get_bd_pins axi_ad9234_jesd/gt_rxnotintable_in]
  connect_bd_net -net axi_fmcadc3_gt_rx_gt_data        [get_bd_pins axi_fmcadc3_gt/rx_gt_data]        [get_bd_pins axi_ad9234_jesd/gt_rxdata_in]
  connect_bd_net -net axi_fmcadc3_gt_rx_rst_done       [get_bd_pins axi_fmcadc3_gt/rx_rst_done]       [get_bd_pins axi_ad9234_jesd/rx_reset_done]
  connect_bd_net -net axi_fmcadc3_gt_rx_ip_comma_align [get_bd_pins axi_fmcadc3_gt/rx_ip_comma_align] [get_bd_pins axi_ad9234_jesd/rxencommaalign_out]
  connect_bd_net -net axi_fmcadc3_gt_rx_ip_sync        [get_bd_pins axi_fmcadc3_gt/rx_ip_sync]        [get_bd_pins axi_ad9234_jesd/rx_sync]
  connect_bd_net -net axi_fmcadc3_gt_rx_ip_sof         [get_bd_pins axi_fmcadc3_gt/rx_ip_sof]         [get_bd_pins axi_ad9234_jesd/rx_start_of_frame]
  connect_bd_net -net axi_fmcadc3_gt_rx_ip_data        [get_bd_pins axi_fmcadc3_gt/rx_ip_data]        [get_bd_pins axi_ad9234_jesd/rx_tdata]
  connect_bd_net -net axi_fmcadc3_gt_rx_data           [get_bd_pins axi_fmcadc3_gt/rx_data]           [get_bd_ports gt_data]
  connect_bd_net -net axi_fmcadc3_gt_0_rx_data         [get_bd_pins axi_ad9234_core_0/rx_data]        [get_bd_ports gt_data_0]
  connect_bd_net -net axi_fmcadc3_gt_1_rx_data         [get_bd_pins axi_ad9234_core_1/rx_data]        [get_bd_ports gt_data_1]
  connect_bd_net -net axi_ad9234_adc_clk               [get_bd_pins axi_ad9234_core_0/adc_clk]        [get_bd_pins axi_ad9234_dma/fifo_wr_clk]
  connect_bd_net -net axi_ad9234_0_adc_enable_0        [get_bd_pins axi_ad9234_core_0/adc_enable_0]   [get_bd_ports adc_enable_0]
  connect_bd_net -net axi_ad9234_0_adc_valid_0         [get_bd_pins axi_ad9234_core_0/adc_valid_0]    [get_bd_ports adc_valid_0]
  connect_bd_net -net axi_ad9234_0_adc_data_0          [get_bd_pins axi_ad9234_core_0/adc_data_0]     [get_bd_ports adc_data_0]
  connect_bd_net -net axi_ad9234_0_adc_enable_1        [get_bd_pins axi_ad9234_core_0/adc_enable_1]   [get_bd_ports adc_enable_1]
  connect_bd_net -net axi_ad9234_0_adc_valid_1         [get_bd_pins axi_ad9234_core_0/adc_valid_1]    [get_bd_ports adc_valid_1]
  connect_bd_net -net axi_ad9234_0_adc_data_1          [get_bd_pins axi_ad9234_core_0/adc_data_1]     [get_bd_ports adc_data_1]
  connect_bd_net -net axi_ad9234_1_adc_enable_0        [get_bd_pins axi_ad9234_core_1/adc_enable_0]   [get_bd_ports adc_enable_2]
  connect_bd_net -net axi_ad9234_1_adc_valid_0         [get_bd_pins axi_ad9234_core_1/adc_valid_0]    [get_bd_ports adc_valid_2]
  connect_bd_net -net axi_ad9234_1_adc_data_0          [get_bd_pins axi_ad9234_core_1/adc_data_0]     [get_bd_ports adc_data_2]
  connect_bd_net -net axi_ad9234_1_adc_enable_1        [get_bd_pins axi_ad9234_core_1/adc_enable_1]   [get_bd_ports adc_enable_3]
  connect_bd_net -net axi_ad9234_1_adc_valid_1         [get_bd_pins axi_ad9234_core_1/adc_valid_1]    [get_bd_ports adc_valid_3]
  connect_bd_net -net axi_ad9234_1_adc_data_1          [get_bd_pins axi_ad9234_core_1/adc_data_1]     [get_bd_ports adc_data_3]
  connect_bd_net -net axi_ad9234_adc_dwr               [get_bd_ports adc_dwr]                         [get_bd_pins axi_ad9234_dma/fifo_wr_en]
  connect_bd_net -net axi_ad9234_adc_dsync             [get_bd_ports adc_dsync]                       [get_bd_pins axi_ad9234_dma/fifo_wr_sync]
  connect_bd_net -net axi_ad9234_adc_ddata             [get_bd_ports adc_ddata]                       [get_bd_pins axi_ad9234_dma/fifo_wr_din]
  connect_bd_net -net axi_ad9234_adc_dovf              [get_bd_pins axi_ad9234_core_0/adc_dovf]       [get_bd_pins axi_ad9234_dma/fifo_wr_overflow]
  connect_bd_net -net axi_ad9234_dma_irq               [get_bd_pins axi_ad9234_dma/irq]               [get_bd_pins sys_concat_intc/In2] 

  # dac/adc clocks

  connect_bd_net -net axi_ad9234_adc_clk [get_bd_ports adc_clk]

  # interconnect (cpu)

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9234_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9234_core_0/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9234_core_1/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9234_jesd/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins axi_fmcadc3_gt/s_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gt/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9234_core_0/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9234_core_1/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9234_jesd/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9234_dma/s_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcadc3_gt/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9234_core_0/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9234_core_1/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9234_jesd/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9234_dma/s_axi_aresetn]

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_fmcadc3_spi/axi_lite]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m13_axi [get_bd_intf_pins axi_cpu_interconnect/M13_AXI] [get_bd_intf_pins axi_fmcadc3_gpio/s_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M13_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_spi/s_axi_aclk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_spi/ext_spi_clk] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gpio/s_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M13_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcadc3_spi/s_axi_aresetn] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcadc3_gpio/s_axi_aresetn] 

  connect_bd_net -net axi_fmcadc3_spi_irq  [get_bd_pins axi_fmcadc3_spi/ip2intc_irpt]   [get_bd_pins sys_concat_intc/In5]  
  connect_bd_net -net axi_fmcadc3_gpio_irq [get_bd_pins axi_fmcadc3_gpio/ip2intc_irpt]  [get_bd_pins sys_concat_intc/In6] 
}

  # gt uses hp3, and 100MHz clock for both DRP and AXI4

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_mem_interconnect_s08_axi [get_bd_intf_pins axi_mem_interconnect/S08_AXI] [get_bd_intf_pins axi_fmcadc3_gt/m_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gt/m_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gt/drp_clk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcadc3_gt/m_axi_aresetn] 

} else {

  connect_bd_intf_net -intf_net axi_fmcadc3_gt_interconnect_m00_axi [get_bd_intf_pins axi_fmcadc3_gt_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP3]
  connect_bd_intf_net -intf_net axi_fmcadc3_gt_interconnect_s00_axi [get_bd_intf_pins axi_fmcadc3_gt_interconnect/S00_AXI] [get_bd_intf_pins axi_fmcadc3_gt/m_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gt_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gt_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gt_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP3_ACLK]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gt/m_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcadc3_gt/drp_clk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcadc3_gt_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcadc3_gt_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcadc3_gt_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcadc3_gt/m_axi_aresetn] 
}

  # memory interconnects share the same clock (fclk2)

if {$sys_zynq == 1} {
  set sys_fmc_dma_sync_reset [create_bd_cell -type ip -vlnv analog.com:user:util_sync_reset:1.0 sys_fmc_dma_sync_reset]

  set sys_fmc_dma_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]
  set sys_fmc_dma_resetn_source [get_bd_pins sys_fmc_dma_sync_reset/sync_resetn]

  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_fmc_dma_sync_reset/clk]
  connect_bd_net -net sys_fmc_dma_async_reset \
	[get_bd_pins sys_fmc_dma_sync_reset/async_resetn] \
	[get_bd_pins sys_ps7/FCLK_RESET2_N]

  connect_bd_net -net sys_fmc_dma_clk $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_resetn $sys_fmc_dma_resetn_source
}

  # interconnect (mem/dac)

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_mem_interconnect_s09_axi [get_bd_intf_pins axi_mem_interconnect/S09_AXI] [get_bd_intf_pins axi_ad9234_dma/m_dest_axi]    
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/S09_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9234_dma/m_dest_axi_aclk] 
  connect_bd_net -net sys_200m_resetn [get_bd_pins axi_mem_interconnect/S09_ARESETN] $sys_200m_resetn_source
  connect_bd_net -net sys_200m_resetn [get_bd_pins axi_ad9234_dma/m_dest_axi_aresetn] 

} else {

  connect_bd_intf_net -intf_net axi_ad9234_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9234_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_ad9234_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9234_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9234_dma/m_dest_axi]    
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9234_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9234_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9234_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9234_dma/m_dest_axi_aclk] 
  connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9234_dma_interconnect/ARESETN] $sys_fmc_dma_resetn_source
  connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9234_dma_interconnect/M00_ARESETN] $sys_fmc_dma_resetn_source
  connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9234_dma_interconnect/S00_ARESETN] $sys_fmc_dma_resetn_source
  connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9234_dma/m_dest_axi_aresetn] 
}

  # ila

  set ila_jesd_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_jesd_rx_mon]
  set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_jesd_rx_mon
  set_property -dict [list CONFIG.C_NUM_OF_PROBES {4}] $ila_jesd_rx_mon
  set_property -dict [list CONFIG.C_PROBE0_WIDTH {662}] $ila_jesd_rx_mon
  set_property -dict [list CONFIG.C_PROBE1_WIDTH {10}] $ila_jesd_rx_mon
  set_property -dict [list CONFIG.C_PROBE2_WIDTH {256}] $ila_jesd_rx_mon
  set_property -dict [list CONFIG.C_PROBE3_WIDTH {256}] $ila_jesd_rx_mon

  connect_bd_net -net axi_fmcadc3_gt_rx_mon_data       [get_bd_pins axi_fmcadc3_gt/rx_mon_data]
  connect_bd_net -net axi_fmcadc3_gt_rx_mon_trigger    [get_bd_pins axi_fmcadc3_gt/rx_mon_trigger]
  connect_bd_net -net axi_fmcadc3_gt_rx_clk            [get_bd_pins ila_jesd_rx_mon/CLK]
  connect_bd_net -net axi_fmcadc3_gt_rx_mon_data       [get_bd_pins ila_jesd_rx_mon/PROBE0]
  connect_bd_net -net axi_fmcadc3_gt_rx_mon_trigger    [get_bd_pins ila_jesd_rx_mon/PROBE1]
  connect_bd_net -net axi_fmcadc3_gt_rx_data           [get_bd_pins ila_jesd_rx_mon/PROBE2]
  connect_bd_net -net axi_ad9234_adc_ddata             [get_bd_pins ila_jesd_rx_mon/PROBE3]

  # address map

  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9234_core_0/s_axi/axi_lite] SEG_data_ad9234_0_core
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9234_core_1/s_axi/axi_lite] SEG_data_ad9234_1_core
  create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcadc3_gt/s_axi/axi_lite]    SEG_data_fmcadc3_gt
  create_bd_addr_seg -range 0x00001000 -offset 0x44A91000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9234_jesd/s_axi/Reg]        SEG_data_ad9234_jesd
  create_bd_addr_seg -range 0x00010000 -offset 0x7c400000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9234_dma/s_axi/axi_lite]    SEG_data_ad9234_dma

if {$sys_zynq == 0} {

  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcadc3_gpio/S_AXI/Reg]       SEG_data_fmcadc3_gpio
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcadc3_spi/axi_lite/Reg]     SEG_data_fmcadc3_spi
}

if {$sys_zynq == 0} {

  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9234_dma/m_dest_axi]  [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]        SEG_axi_ddr_cntrl
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_fmcadc3_gt/m_axi]       [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]        SEG_axi_ddr_cntrl

} else {

  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9234_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM]    SEG_sys_ps7_hp2_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_fmcadc3_gt/m_axi]       [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM]    SEG_sys_ps7_hp3_ddr_lowocm
}

