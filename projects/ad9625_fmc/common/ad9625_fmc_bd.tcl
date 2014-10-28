
# ad9625

if {$sys_zynq == 1} {

  set spi_csn_1_o     [create_bd_port -dir O spi_csn_1_o]
  set spi_csn_0_o     [create_bd_port -dir O spi_csn_0_o]
  set spi_csn_i       [create_bd_port -dir I spi_csn_i]

} else {

  set spi_csn_o       [create_bd_port -dir O -from 1 -to 0 spi_csn_o]
  set spi_csn_i       [create_bd_port -dir I -from 1 -to 0 spi_csn_i]
}

set spi_clk_i       [create_bd_port -dir I spi_clk_i]
set spi_clk_o       [create_bd_port -dir O spi_clk_o]
set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

set rx_ref_clk      [create_bd_port -dir I rx_ref_clk]
set rx_sync         [create_bd_port -dir O rx_sync]
set rx_sysref       [create_bd_port -dir O rx_sysref]
set rx_data_p       [create_bd_port -dir I -from 7 -to 0 rx_data_p]
set rx_data_n       [create_bd_port -dir I -from 7 -to 0 rx_data_n]

set ad9625_spi_intr  [create_bd_port -dir O ad9625_spi_intr]
set ad9625_gpio_intr [create_bd_port -dir O ad9625_gpio_intr]
set ad9625_dma_intr  [create_bd_port -dir O ad9625_dma_intr]

if {$sys_zynq == 0} {

  set gpio_ad9625_i   [create_bd_port -dir I -from 1 -to 0 gpio_ad9625_i]
  set gpio_ad9625_o   [create_bd_port -dir O -from 1 -to 0 gpio_ad9625_o]
  set gpio_ad9625_t   [create_bd_port -dir O -from 1 -to 0 gpio_ad9625_t]
}

# adc peripherals

set axi_ad9625_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_core]

set axi_ad9625_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.2 axi_ad9625_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_jesd

set axi_ad9625_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_ad9625_gt]
set_property -dict [list CONFIG.PCORE_NUM_OF_LANES {8}] $axi_ad9625_gt
set_property -dict [list CONFIG.PCORE_CPLL_FBDIV {1}] $axi_ad9625_gt
set_property -dict [list CONFIG.PCORE_RX_OUT_DIV {1}] $axi_ad9625_gt
set_property -dict [list CONFIG.PCORE_TX_OUT_DIV {1}] $axi_ad9625_gt
set_property -dict [list CONFIG.PCORE_RX_CLK25_DIV {25}] $axi_ad9625_gt
set_property -dict [list CONFIG.PCORE_TX_CLK25_DIV {25}] $axi_ad9625_gt
set_property -dict [list CONFIG.PCORE_PMA_RSV {0x00018480}] $axi_ad9625_gt
set_property -dict [list CONFIG.PCORE_RX_CDR_CFG {0x03000023ff20400020}] $axi_ad9625_gt

set axi_ad9625_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9625_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {1}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9625_dma

if {$sys_zynq == 1} {

  set axi_ad9625_gt_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9625_gt_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9625_gt_interconnect

  set axi_ad9625_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9625_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9625_dma_interconnect
}

if {$sys_zynq == 1} {

  set DDR3    [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR3]
  set sys_clk [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk]

  p_plddr3_fifo [current_bd_instance .] axi_ad9625_fifo 256

  connect_bd_intf_net -intf_net DDR3    [get_bd_intf_ports DDR3]    [get_bd_intf_pins axi_ad9625_fifo/DDR3]
  connect_bd_intf_net -intf_net sys_clk [get_bd_intf_ports sys_clk] [get_bd_intf_pins axi_ad9625_fifo/sys_clk]

} else {

  p_sys_dmafifo [current_bd_instance .] axi_ad9625_fifo 256
}

# spi

if {$sys_zynq == 0} {

  set axi_ad9625_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_ad9625_gpio]
  set_property -dict [list CONFIG.C_IS_DUAL {0}] $axi_ad9625_gpio
  set_property -dict [list CONFIG.C_GPIO_WIDTH {2}] $axi_ad9625_gpio
  set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_ad9625_gpio

  set axi_ad9625_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_ad9625_spi]
  set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_ad9625_spi
  set_property -dict [list CONFIG.C_NUM_SS_BITS {2}] $axi_ad9625_spi
  set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_ad9625_spi
}

# additions to default configuration

if {$sys_zynq == 1} {

  set_property -dict [list CONFIG.NUM_MI {11}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
  set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {17}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7

  set_property LEFT 16 [get_bd_ports GPIO_I]
  set_property LEFT 16 [get_bd_ports GPIO_O]
  set_property LEFT 16 [get_bd_ports GPIO_T]

} else {

  set_property -dict [list CONFIG.NUM_MI {13}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.NUM_SI {10}] $axi_mem_interconnect
}

# connections (spi and gpio)

if {$sys_zynq == 1 } {

  connect_bd_net -net spi_csn_1_o [get_bd_ports spi_csn_1_o]  [get_bd_pins sys_ps7/SPI0_SS1_O]
  connect_bd_net -net spi_csn_0_o [get_bd_ports spi_csn_0_o]  [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]    [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi_clk_i   [get_bd_ports spi_clk_i]    [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi_clk_o   [get_bd_ports spi_clk_o]    [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net spi_sdo_i   [get_bd_ports spi_sdo_i]    [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi_sdo_o   [get_bd_ports spi_sdo_o]    [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi_sdi_i   [get_bd_ports spi_sdi_i]    [get_bd_pins sys_ps7/SPI0_MISO_I]

} else {

  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]                [get_bd_pins axi_ad9625_spi/ss_i]
  connect_bd_net -net spi_csn_o   [get_bd_ports spi_csn_o]                [get_bd_pins axi_ad9625_spi/ss_o]
  connect_bd_net -net spi_clk_i   [get_bd_ports spi_clk_i]                [get_bd_pins axi_ad9625_spi/sck_i]
  connect_bd_net -net spi_clk_o   [get_bd_ports spi_clk_o]                [get_bd_pins axi_ad9625_spi/sck_o]
  connect_bd_net -net spi_sdo_i   [get_bd_ports spi_sdo_i]                [get_bd_pins axi_ad9625_spi/io0_i]
  connect_bd_net -net spi_sdo_o   [get_bd_ports spi_sdo_o]                [get_bd_pins axi_ad9625_spi/io0_o]
  connect_bd_net -net spi_sdi_i   [get_bd_ports spi_sdi_i]                [get_bd_pins axi_ad9625_spi/io1_i]

  connect_bd_net -net gpio_ad9625_i [get_bd_ports gpio_ad9625_i]    [get_bd_pins axi_ad9625_gpio/gpio_io_i]
  connect_bd_net -net gpio_ad9625_o [get_bd_ports gpio_ad9625_o]    [get_bd_pins axi_ad9625_gpio/gpio_io_o]
  connect_bd_net -net gpio_ad9625_t [get_bd_ports gpio_ad9625_t]    [get_bd_pins axi_ad9625_gpio/gpio_io_t]

  connect_bd_net -net axi_ad9625_spi_intr  [get_bd_pins axi_ad9625_spi/ip2intc_irpt]   [get_bd_ports ad9625_spi_intr]
  connect_bd_net -net axi_ad9625_gpio_intr [get_bd_pins axi_ad9625_gpio/ip2intc_irpt]  [get_bd_ports ad9625_gpio_intr]
}

# connections (gt)

connect_bd_net -net axi_ad9625_gt_ref_clk_c         [get_bd_pins axi_ad9625_gt/ref_clk_c]         [get_bd_ports rx_ref_clk]   
connect_bd_net -net axi_ad9625_gt_rx_data_p         [get_bd_pins axi_ad9625_gt/rx_data_p]         [get_bd_ports rx_data_p]   
connect_bd_net -net axi_ad9625_gt_rx_data_n         [get_bd_pins axi_ad9625_gt/rx_data_n]         [get_bd_ports rx_data_n]   
connect_bd_net -net axi_ad9625_gt_rx_sync           [get_bd_pins axi_ad9625_gt/rx_sync]           [get_bd_ports rx_sync]   
connect_bd_net -net axi_ad9625_gt_rx_sysref         [get_bd_pins axi_ad9625_gt/rx_sysref]         [get_bd_ports rx_sysref]   

# connections (adc)

connect_bd_net -net axi_ad9625_gt_rx_clk [get_bd_pins axi_ad9625_gt/rx_clk_g]
connect_bd_net -net axi_ad9625_gt_rx_clk [get_bd_pins axi_ad9625_gt/rx_clk]
connect_bd_net -net axi_ad9625_gt_rx_clk [get_bd_pins axi_ad9625_core/rx_clk]
connect_bd_net -net axi_ad9625_gt_rx_clk [get_bd_pins axi_ad9625_jesd/rx_core_clk]
connect_bd_net -net axi_ad9625_gt_rx_rst [get_bd_pins axi_ad9625_gt/rx_rst]
connect_bd_net -net axi_ad9625_gt_rx_rst [get_bd_pins axi_ad9625_jesd/rx_reset]
connect_bd_net -net axi_ad9625_gt_rx_rst [get_bd_pins axi_ad9625_fifo/adc_rst]  [get_bd_pins axi_ad9625_gt/rx_rst]
connect_bd_net -net sys_100m_resetn      [get_bd_pins axi_ad9625_fifo/dma_rstn] $sys_100m_resetn_source

connect_bd_net -net axi_ad9625_gt_rx_sysref         [get_bd_pins axi_ad9625_jesd/rx_sysref]
connect_bd_net -net axi_ad9625_gt_rx_gt_charisk     [get_bd_pins axi_ad9625_gt/rx_gt_charisk]     [get_bd_pins axi_ad9625_jesd/gt_rxcharisk_in]
connect_bd_net -net axi_ad9625_gt_rx_gt_disperr     [get_bd_pins axi_ad9625_gt/rx_gt_disperr]     [get_bd_pins axi_ad9625_jesd/gt_rxdisperr_in]
connect_bd_net -net axi_ad9625_gt_rx_gt_notintable  [get_bd_pins axi_ad9625_gt/rx_gt_notintable]  [get_bd_pins axi_ad9625_jesd/gt_rxnotintable_in]
connect_bd_net -net axi_ad9625_gt_rx_gt_data        [get_bd_pins axi_ad9625_gt/rx_gt_data]        [get_bd_pins axi_ad9625_jesd/gt_rxdata_in]
connect_bd_net -net axi_ad9625_gt_rx_rst_done       [get_bd_pins axi_ad9625_gt/rx_rst_done]       [get_bd_pins axi_ad9625_jesd/rx_reset_done]
connect_bd_net -net axi_ad9625_gt_rx_ip_comma_align [get_bd_pins axi_ad9625_gt/rx_ip_comma_align] [get_bd_pins axi_ad9625_jesd/rxencommaalign_out]
connect_bd_net -net axi_ad9625_gt_rx_ip_sync        [get_bd_pins axi_ad9625_gt/rx_ip_sync]        [get_bd_pins axi_ad9625_jesd/rx_sync]
connect_bd_net -net axi_ad9625_gt_rx_ip_sof         [get_bd_pins axi_ad9625_gt/rx_ip_sof]         [get_bd_pins axi_ad9625_jesd/rx_start_of_frame]
connect_bd_net -net axi_ad9625_gt_rx_ip_data        [get_bd_pins axi_ad9625_gt/rx_ip_data]        [get_bd_pins axi_ad9625_jesd/rx_tdata]
connect_bd_net -net axi_ad9625_gt_rx_data           [get_bd_pins axi_ad9625_gt/rx_data]           [get_bd_pins axi_ad9625_core/rx_data]
connect_bd_net -net axi_ad9625_adc_clk              [get_bd_pins axi_ad9625_core/adc_clk]         [get_bd_pins axi_ad9625_fifo/adc_clk]
connect_bd_net -net axi_ad9625_adc_enable           [get_bd_pins axi_ad9625_core/adc_enable]      [get_bd_pins axi_ad9625_fifo/adc_wr]
connect_bd_net -net axi_ad9625_adc_data             [get_bd_pins axi_ad9625_core/adc_data]        [get_bd_pins axi_ad9625_fifo/adc_wdata]
connect_bd_net -net axi_ad9625_adc_dovf             [get_bd_pins axi_ad9625_core/adc_dovf]        [get_bd_pins axi_ad9625_fifo/adc_wovf]

connect_bd_net -net sys_100m_clk                    [get_bd_pins axi_ad9625_fifo/dma_clk]         [get_bd_pins axi_ad9625_dma/s_axis_aclk]
connect_bd_net -net axi_ad9625_dma_dvalid           [get_bd_pins axi_ad9625_fifo/dma_wvalid]      [get_bd_pins axi_ad9625_dma/s_axis_valid]
connect_bd_net -net axi_ad9625_dma_dready           [get_bd_pins axi_ad9625_fifo/dma_wready]      [get_bd_pins axi_ad9625_dma/s_axis_ready]
connect_bd_net -net axi_ad9625_dma_ddata            [get_bd_pins axi_ad9625_fifo/dma_wdata]       [get_bd_pins axi_ad9625_dma/s_axis_data]
connect_bd_net -net axi_ad9625_dma_intr             [get_bd_pins axi_ad9625_dma/irq]              [get_bd_ports ad9625_dma_intr]

if {$sys_zynq == 0} {

  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9625_fifo/axi_clk] $sys_200m_clk_source
}

# interconnect (cpu)

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9625_dma/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9625_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9625_jesd/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9625_gt/s_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_gt/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_core/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_jesd/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_dma/s_axi_aclk] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_gt/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_core/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_jesd/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_dma/s_axi_aresetn]

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins axi_ad9625_spi/axi_lite]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_ad9625_gpio/s_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_spi/s_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_gpio/s_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_spi/ext_spi_clk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_spi/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_gpio/s_axi_aresetn]
}

# interconnect (gt es)

if {$sys_zynq == 1} {

  connect_bd_intf_net -intf_net axi_ad9625_gt_interconnect_s00_axi [get_bd_intf_pins axi_ad9625_gt_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9625_gt/m_axi]
  connect_bd_intf_net -intf_net axi_ad9625_gt_interconnect_m00_axi [get_bd_intf_pins axi_ad9625_gt_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP3]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_gt_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_gt_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_gt_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP3_ACLK]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_gt_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_gt_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_gt_interconnect/S00_ARESETN] $sys_100m_resetn_source

} else {

  connect_bd_intf_net -intf_net axi_mem_interconnect_s08_axi [get_bd_intf_pins axi_mem_interconnect/S08_AXI] [get_bd_intf_pins axi_ad9625_gt/m_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S08_ARESETN] $sys_100m_resetn_source
}

connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_gt/m_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_gt/drp_clk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_gt/m_axi_aresetn] 

# interconnect (dma)

if {$sys_zynq == 1} {

  connect_bd_intf_net -intf_net axi_ad9625_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9625_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_ad9625_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9625_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9625_dma/m_dest_axi]    
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_dma_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_dma_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_dma_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_dma/m_dest_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_dma/m_dest_axi_aresetn] 

} else {

  connect_bd_intf_net -intf_net axi_mem_interconnect_s09_axi [get_bd_intf_pins axi_mem_interconnect/S09_AXI] [get_bd_intf_pins axi_ad9625_dma/m_dest_axi]
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/S09_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9625_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_200m_resetn [get_bd_pins axi_mem_interconnect/S09_ARESETN] $sys_200m_resetn_source
  connect_bd_net -net sys_200m_resetn [get_bd_pins axi_ad9625_dma/m_dest_axi_aresetn]
}

# ila

set ila_jesd_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_jesd_rx_mon]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_NUM_OF_PROBES {3}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {662}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {10}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE2_WIDTH {256}] $ila_jesd_rx_mon

connect_bd_net -net axi_ad9625_gt_rx_mon_data       [get_bd_pins axi_ad9625_gt/rx_mon_data]
connect_bd_net -net axi_ad9625_gt_rx_mon_trigger    [get_bd_pins axi_ad9625_gt/rx_mon_trigger]
connect_bd_net -net axi_ad9625_gt_rx_clk            [get_bd_pins ila_jesd_rx_mon/CLK]
connect_bd_net -net axi_ad9625_gt_rx_mon_data       [get_bd_pins ila_jesd_rx_mon/PROBE0]
connect_bd_net -net axi_ad9625_gt_rx_mon_trigger    [get_bd_pins ila_jesd_rx_mon/PROBE1]
connect_bd_net -net axi_ad9625_gt_rx_data           [get_bd_pins ila_jesd_rx_mon/PROBE2]

# address map

create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_core/s_axi/axi_lite]   SEG_data_ad9625_core
create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_gt/s_axi/axi_lite]     SEG_data_ad9625_gt
create_bd_addr_seg -range 0x00001000 -offset 0x44A91000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_jesd/s_axi/Reg]        SEG_data_ad9625_jesd
create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_dma/s_axi/axi_lite]    SEG_data_ad9625_dma

if {$sys_zynq == 0} {
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_spi/axi_lite/Reg]    SEG_data_ad9625_spi
  create_bd_addr_seg -range 0x00010000 -offset 0x40030000 [get_bd_addr_spaces sys_mb/Data]          [get_bd_addr_segs axi_ad9625_gpio/s_axi/Reg]    SEG_data_gpio_3
}

if {$sys_zynq == 1} {

  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9625_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM]    SEG_sys_ps7_hp2_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9625_gt/m_axi]        [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM]    SEG_sys_ps7_hp3_ddr_lowocm
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_ad9625_fifo/axi_fifo2s/axi] [get_bd_addr_segs axi_ad9625_fifo/axi_ddr_cntrl/memmap/memaddr] SEG_axi_ddr_cntrl_memaddr

} else {

  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9625_dma/m_dest_axi]  [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9625_gt/m_axi]        [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl
  create_bd_addr_seg -range 0x00200000 -offset 0xc0000000 [get_bd_addr_spaces axi_ad9625_fifo/axi_fifo2s/axi] [get_bd_addr_segs axi_ad9625_fifo/axi_bram_ctl/S_AXI/Mem0] SEG_axi_bram_ctl_mem
}
