
# fmcomms5

# master

set rx_clk_in_0_p       [create_bd_port -dir I rx_clk_in_0_p]
set rx_clk_in_0_n       [create_bd_port -dir I rx_clk_in_0_n]
set rx_frame_in_0_p     [create_bd_port -dir I rx_frame_in_0_p]
set rx_frame_in_0_n     [create_bd_port -dir I rx_frame_in_0_n]
set rx_data_in_0_p      [create_bd_port -dir I -from 5 -to 0 rx_data_in_0_p]
set rx_data_in_0_n      [create_bd_port -dir I -from 5 -to 0 rx_data_in_0_n]
set tx_clk_out_0_p      [create_bd_port -dir O tx_clk_out_0_p]
set tx_clk_out_0_n      [create_bd_port -dir O tx_clk_out_0_n]
set tx_frame_out_0_p    [create_bd_port -dir O tx_frame_out_0_p]
set tx_frame_out_0_n    [create_bd_port -dir O tx_frame_out_0_n]
set tx_data_out_0_p     [create_bd_port -dir O -from 5 -to 0 tx_data_out_0_p]
set tx_data_out_0_n     [create_bd_port -dir O -from 5 -to 0 tx_data_out_0_n]

# slave

set rx_clk_in_1_p       [create_bd_port -dir I rx_clk_in_1_p]
set rx_clk_in_1_n       [create_bd_port -dir I rx_clk_in_1_n]
set rx_frame_in_1_p     [create_bd_port -dir I rx_frame_in_1_p]
set rx_frame_in_1_n     [create_bd_port -dir I rx_frame_in_1_n]
set rx_data_in_1_p      [create_bd_port -dir I -from 5 -to 0 rx_data_in_1_p]
set rx_data_in_1_n      [create_bd_port -dir I -from 5 -to 0 rx_data_in_1_n]
set tx_clk_out_1_p      [create_bd_port -dir O tx_clk_out_1_p]
set tx_clk_out_1_n      [create_bd_port -dir O tx_clk_out_1_n]
set tx_frame_out_1_p    [create_bd_port -dir O tx_frame_out_1_p]
set tx_frame_out_1_n    [create_bd_port -dir O tx_frame_out_1_n]
set tx_data_out_1_p     [create_bd_port -dir O -from 5 -to 0 tx_data_out_1_p]
set tx_data_out_1_n     [create_bd_port -dir O -from 5 -to 0 tx_data_out_1_n]

# dma multiplexing

set ad9361_0_dac_ddata  [create_bd_port -dir I -from 63 -to 0 ad9361_0_dac_ddata]
set ad9361_1_dac_ddata  [create_bd_port -dir I -from 63 -to 0 ad9361_1_dac_ddata]
set ad9361_dac_ddata    [create_bd_port -dir O -from 127 -to 0 ad9361_dac_ddata]    

set ad9361_0_adc_ddata  [create_bd_port -dir O -from 63 -to 0 ad9361_0_adc_ddata]
set ad9361_1_adc_ddata  [create_bd_port -dir O -from 63 -to 0 ad9361_1_adc_ddata]    
set ad9361_adc_ddata    [create_bd_port -dir I -from 127 -to 0 ad9361_adc_ddata]

set sys_100m_resetn     [create_bd_port -dir O sys_100m_resetn]    
set sys_100m_clk        [create_bd_port -dir O sys_100m_clk]    

if {$sys_zynq == 0} {
  set gpio_i  [create_bd_port -dir I -from 32 -to 0 gpio_i]
  set gpio_o  [create_bd_port -dir O -from 32 -to 0 gpio_o]
  set gpio_t  [create_bd_port -dir O -from 32 -to 0 gpio_t]        
}

if {$sys_zynq == 1} {    
  set spi_csn_0_i [create_bd_port -dir I spi_csn_0_i]
  set spi_csn_0_o [create_bd_port -dir O spi_csn_0_o]
  set spi_csn_1_o [create_bd_port -dir O spi_csn_1_o]    
  set spi_csn_2_o [create_bd_port -dir O spi_csn_2_o]
} else {
  set spi_csn_i   [create_bd_port -dir I -from 2 -to 0 spi_csn_i]
  set spi_csn_o   [create_bd_port -dir O -from 2 -to 0 spi_csn_o]
}
  
set spi_sclk_i          [create_bd_port -dir I spi_sclk_i]
set spi_sclk_o          [create_bd_port -dir O spi_sclk_o]
set spi_mosi_i          [create_bd_port -dir I spi_mosi_i]
set spi_mosi_o          [create_bd_port -dir O spi_mosi_o]
set spi_miso_i          [create_bd_port -dir I spi_miso_i]

# instances

set axi_ad9361_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361_0]
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9361_0
set_property -dict [list CONFIG.PCORE_IODELAY_GROUP {dev_0_if_delay_group}] $axi_ad9361_0

set axi_ad9361_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361_1]
set_property -dict [list CONFIG.PCORE_ID {1}] $axi_ad9361_1
set_property -dict [list CONFIG.PCORE_IODELAY_GROUP {dev_1_if_delay_group}] $axi_ad9361_1

set axi_ad9361_dac_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {1}] $axi_ad9361_dac_dma 
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {128}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {128}] $axi_ad9361_dac_dma

if {$sys_zynq == 1} {
  set axi_ad9361_dac_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9361_dac_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9361_dac_dma_interconnect
}

set axi_ad9361_adc_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {128}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {128}] $axi_ad9361_adc_dma    

if {$sys_zynq == 1} {    
  set axi_ad9361_adc_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9361_adc_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9361_adc_dma_interconnect
}

if {$sys_zynq == 0} {
  set axi_fmcomms2_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 axi_fmcomms2_spi]
  set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_fmcomms2_spi
  set_property -dict [list CONFIG.C_NUM_SS_BITS {3}] $axi_fmcomms2_spi
  set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_fmcomms2_spi
}    

if {$sys_zynq == 0} {
  set axi_fmcomms2_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_fmcomms2_gpio]
  set_property -dict [list CONFIG.C_IS_DUAL {0}] $axi_fmcomms2_gpio
  set_property -dict [list CONFIG.C_GPIO_WIDTH {17}] $axi_fmcomms2_gpio
  set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_fmcomms2_gpio
}    

# additions to default configuration

if {$sys_zynq == 0} {
  set_property -dict [list CONFIG.NUM_MI {12}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.NUM_SI {10}] $axi_mem_interconnect
  set_property -dict [list CONFIG.NUM_PORTS {9}] $sys_concat_intc
} else {
  set_property -dict [list CONFIG.NUM_MI {11}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.NUM_PORTS {6}] $sys_concat_intc
}    

if {$sys_zynq == 1} {    
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
  set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {64}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7

  set_property LEFT 63 [get_bd_ports GPIO_I]
  set_property LEFT 63 [get_bd_ports GPIO_O]
  set_property LEFT 63 [get_bd_ports GPIO_T]
}

# connections (spi)

if {$sys_zynq == 0} {
  connect_bd_net -net spi_csn_i   [get_bd_pins axi_fmcomms2_spi/ss_i]           [get_bd_ports spi_csn_i]    
  connect_bd_net -net spi_csn_o   [get_bd_pins axi_fmcomms2_spi/ss_o]           [get_bd_ports spi_csn_o]    
  connect_bd_net -net spi_sclk_i  [get_bd_pins axi_fmcomms2_spi/sck_i]          [get_bd_ports spi_sclk_i]   
  connect_bd_net -net spi_sclk_o  [get_bd_pins axi_fmcomms2_spi/sck_o]          [get_bd_ports spi_sclk_o]   
  connect_bd_net -net spi_mosi_i  [get_bd_pins axi_fmcomms2_spi/io0_i]          [get_bd_ports spi_mosi_i]   
  connect_bd_net -net spi_mosi_o  [get_bd_pins axi_fmcomms2_spi/io0_o]          [get_bd_ports spi_mosi_o]   
  connect_bd_net -net spi_miso_i  [get_bd_pins axi_fmcomms2_spi/io1_i]          [get_bd_ports spi_miso_i]   
  connect_bd_net -net spi_irq     [get_bd_pins axi_fmcomms2_spi/ip2intc_irpt]   [get_bd_pins sys_concat_intc/In7]
} else {                                                                        
  connect_bd_net -net spi_csn_0_i [get_bd_pins sys_ps7/SPI0_SS_I]               [get_bd_ports spi_csn_0_i]  
  connect_bd_net -net spi_csn_0_o [get_bd_pins sys_ps7/SPI0_SS_O]               [get_bd_ports spi_csn_0_o]  
  connect_bd_net -net spi_csn_1_o [get_bd_pins sys_ps7/SPI0_SS1_O]              [get_bd_ports spi_csn_1_o]  
  connect_bd_net -net spi_csn_2_o [get_bd_pins sys_ps7/SPI0_SS2_O]              [get_bd_ports spi_csn_2_o]  
  connect_bd_net -net spi_sclk_i  [get_bd_pins sys_ps7/SPI0_SCLK_I]             [get_bd_ports spi_sclk_i]   
  connect_bd_net -net spi_sclk_o  [get_bd_pins sys_ps7/SPI0_SCLK_O]             [get_bd_ports spi_sclk_o]   
  connect_bd_net -net spi_mosi_i  [get_bd_pins sys_ps7/SPI0_MOSI_I]             [get_bd_ports spi_mosi_i]   
  connect_bd_net -net spi_mosi_o  [get_bd_pins sys_ps7/SPI0_MOSI_O]             [get_bd_ports spi_mosi_o]   
  connect_bd_net -net spi_miso_i  [get_bd_pins sys_ps7/SPI0_MISO_I]             [get_bd_ports spi_miso_i]   
}

# connections (gpio)

if {$sys_zynq == 0} {
  connect_bd_net -net gpio_i      [get_bd_pins axi_fmcomms2_gpio/gpio_io_i]     [get_bd_ports gpio_i]    
  connect_bd_net -net gpio_o      [get_bd_pins axi_fmcomms2_gpio/gpio_io_o]     [get_bd_ports gpio_o]    
  connect_bd_net -net gpio_t      [get_bd_pins axi_fmcomms2_gpio/gpio_io_t]     [get_bd_ports gpio_t]    
  connect_bd_net -net gpio_irq    [get_bd_pins axi_fmcomms2_gpio/ip2intc_irpt]  [get_bd_pins sys_concat_intc/In8]
}

# connections (ad9361)

connect_bd_net -net sys_100m_resetn [get_bd_ports sys_100m_resetn] 
connect_bd_net -net sys_100m_clk [get_bd_ports sys_100m_clk] 
connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9361_0/delay_clk] 
connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9361_1/delay_clk] 
connect_bd_net -net axi_ad9361_0_clk [get_bd_pins axi_ad9361_0/l_clk]
connect_bd_net -net axi_ad9361_1_clk [get_bd_pins axi_ad9361_1/l_clk]
connect_bd_net -net axi_ad9361_0_clk [get_bd_pins axi_ad9361_0/clk]
connect_bd_net -net axi_ad9361_0_clk [get_bd_pins axi_ad9361_1/clk]
connect_bd_net -net axi_ad9361_0_clk [get_bd_pins axi_ad9361_adc_dma/fifo_wr_clk]
connect_bd_net -net axi_ad9361_0_clk [get_bd_pins axi_ad9361_dac_dma/fifo_rd_clk]

connect_bd_net -net axi_ad9361_0_dac_enable [get_bd_pins axi_ad9361_0/dac_enable_out]
connect_bd_net -net axi_ad9361_0_dac_enable [get_bd_pins axi_ad9361_0/dac_enable_in]
connect_bd_net -net axi_ad9361_0_dac_enable [get_bd_pins axi_ad9361_1/dac_enable_in]

connect_bd_net -net axi_ad9361_0_rx_clk_in_p      [get_bd_ports rx_clk_in_0_p]            [get_bd_pins axi_ad9361_0/rx_clk_in_p]
connect_bd_net -net axi_ad9361_0_rx_clk_in_n      [get_bd_ports rx_clk_in_0_n]            [get_bd_pins axi_ad9361_0/rx_clk_in_n]
connect_bd_net -net axi_ad9361_0_rx_frame_in_p    [get_bd_ports rx_frame_in_0_p]          [get_bd_pins axi_ad9361_0/rx_frame_in_p]
connect_bd_net -net axi_ad9361_0_rx_frame_in_n    [get_bd_ports rx_frame_in_0_n]          [get_bd_pins axi_ad9361_0/rx_frame_in_n]
connect_bd_net -net axi_ad9361_0_rx_data_in_p     [get_bd_ports rx_data_in_0_p]           [get_bd_pins axi_ad9361_0/rx_data_in_p]
connect_bd_net -net axi_ad9361_0_rx_data_in_n     [get_bd_ports rx_data_in_0_n]           [get_bd_pins axi_ad9361_0/rx_data_in_n]
connect_bd_net -net axi_ad9361_0_tx_clk_out_p     [get_bd_ports tx_clk_out_0_p]           [get_bd_pins axi_ad9361_0/tx_clk_out_p]
connect_bd_net -net axi_ad9361_0_tx_clk_out_n     [get_bd_ports tx_clk_out_0_n]           [get_bd_pins axi_ad9361_0/tx_clk_out_n]
connect_bd_net -net axi_ad9361_0_tx_frame_out_p   [get_bd_ports tx_frame_out_0_p]         [get_bd_pins axi_ad9361_0/tx_frame_out_p]
connect_bd_net -net axi_ad9361_0_tx_frame_out_n   [get_bd_ports tx_frame_out_0_n]         [get_bd_pins axi_ad9361_0/tx_frame_out_n]
connect_bd_net -net axi_ad9361_0_tx_data_out_p    [get_bd_ports tx_data_out_0_p]          [get_bd_pins axi_ad9361_0/tx_data_out_p]
connect_bd_net -net axi_ad9361_0_tx_data_out_n    [get_bd_ports tx_data_out_0_n]          [get_bd_pins axi_ad9361_0/tx_data_out_n]
connect_bd_net -net axi_ad9361_1_rx_clk_in_p      [get_bd_ports rx_clk_in_1_p]            [get_bd_pins axi_ad9361_1/rx_clk_in_p]
connect_bd_net -net axi_ad9361_1_rx_clk_in_n      [get_bd_ports rx_clk_in_1_n]            [get_bd_pins axi_ad9361_1/rx_clk_in_n]
connect_bd_net -net axi_ad9361_1_rx_frame_in_p    [get_bd_ports rx_frame_in_1_p]          [get_bd_pins axi_ad9361_1/rx_frame_in_p]
connect_bd_net -net axi_ad9361_1_rx_frame_in_n    [get_bd_ports rx_frame_in_1_n]          [get_bd_pins axi_ad9361_1/rx_frame_in_n]
connect_bd_net -net axi_ad9361_1_rx_data_in_p     [get_bd_ports rx_data_in_1_p]           [get_bd_pins axi_ad9361_1/rx_data_in_p]
connect_bd_net -net axi_ad9361_1_rx_data_in_n     [get_bd_ports rx_data_in_1_n]           [get_bd_pins axi_ad9361_1/rx_data_in_n]
connect_bd_net -net axi_ad9361_1_tx_clk_out_p     [get_bd_ports tx_clk_out_1_p]           [get_bd_pins axi_ad9361_1/tx_clk_out_p]
connect_bd_net -net axi_ad9361_1_tx_clk_out_n     [get_bd_ports tx_clk_out_1_n]           [get_bd_pins axi_ad9361_1/tx_clk_out_n]
connect_bd_net -net axi_ad9361_1_tx_frame_out_p   [get_bd_ports tx_frame_out_1_p]         [get_bd_pins axi_ad9361_1/tx_frame_out_p]
connect_bd_net -net axi_ad9361_1_tx_frame_out_n   [get_bd_ports tx_frame_out_1_n]         [get_bd_pins axi_ad9361_1/tx_frame_out_n]
connect_bd_net -net axi_ad9361_1_tx_data_out_p    [get_bd_ports tx_data_out_1_p]          [get_bd_pins axi_ad9361_1/tx_data_out_p]
connect_bd_net -net axi_ad9361_1_tx_data_out_n    [get_bd_ports tx_data_out_1_n]          [get_bd_pins axi_ad9361_1/tx_data_out_n]

connect_bd_net -net axi_ad9361_0_adc_dwr          [get_bd_pins axi_ad9361_0/adc_dwr]      [get_bd_pins axi_ad9361_adc_dma/fifo_wr_en]
connect_bd_net -net axi_ad9361_0_adc_dsync        [get_bd_pins axi_ad9361_0/adc_dsync]    [get_bd_pins axi_ad9361_adc_dma/fifo_wr_sync]
connect_bd_net -net axi_ad9361_0_adc_ddata        [get_bd_pins axi_ad9361_0/adc_ddata]    [get_bd_ports ad9361_0_adc_ddata]       
connect_bd_net -net axi_ad9361_1_adc_ddata        [get_bd_pins axi_ad9361_1/adc_ddata]    [get_bd_ports ad9361_1_adc_ddata]       
connect_bd_net -net axi_ad9361_adc_ddata          [get_bd_ports ad9361_adc_ddata]         [get_bd_pins axi_ad9361_adc_dma/fifo_wr_din]
connect_bd_net -net axi_ad9361_0_adc_dovf         [get_bd_pins axi_ad9361_0/adc_dovf]     [get_bd_pins axi_ad9361_adc_dma/fifo_wr_overflow]
connect_bd_net -net axi_ad9361_adc_dma_irq        [get_bd_pins axi_ad9361_adc_dma/irq]    [get_bd_pins sys_concat_intc/In2]

connect_bd_net -net axi_ad9361_0_dac_drd          [get_bd_pins axi_ad9361_0/dac_drd]      [get_bd_pins axi_ad9361_dac_dma/fifo_rd_en]
connect_bd_net -net axi_ad9361_0_dac_ddata        [get_bd_pins axi_ad9361_0/dac_ddata]    [get_bd_ports ad9361_0_dac_ddata]       
connect_bd_net -net axi_ad9361_1_dac_ddata        [get_bd_pins axi_ad9361_1/dac_ddata]    [get_bd_ports ad9361_1_dac_ddata]       
connect_bd_net -net axi_ad9361_dac_ddata          [get_bd_ports ad9361_dac_ddata]         [get_bd_pins axi_ad9361_dac_dma/fifo_rd_dout]
connect_bd_net -net axi_ad9361_0_dac_dunf         [get_bd_pins axi_ad9361_0/dac_dunf]     [get_bd_pins axi_ad9361_dac_dma/fifo_rd_underflow]
connect_bd_net -net axi_ad9361_dac_dma_irq        [get_bd_pins axi_ad9361_dac_dma/irq]    [get_bd_pins sys_concat_intc/In3]

# interconnect (cpu)

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9361_0/s_axi]              
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9361_adc_dma/s_axi]      
connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9361_dac_dma/s_axi]    
connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9361_1/s_axi]              
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9361_0/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9361_adc_dma/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9361_dac_dma/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9361_1/s_axi_aclk]  
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_0/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_adc_dma/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_dac_dma/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_1/s_axi_aresetn]   

if {$sys_zynq == 0} {
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_fmcomms2_spi/axi_lite]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins axi_fmcomms2_gpio/s_axi] 
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcomms2_spi/s_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcomms2_spi/ext_spi_clk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcomms2_gpio/s_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcomms2_spi/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcomms2_gpio/s_axi_aresetn]
}   

# memory interconnects share the same clock (fclk2)

if {$sys_zynq == 1} {    
  set sys_fmc_dma_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]
  connect_bd_net -net sys_fmc_dma_clk $sys_fmc_dma_clk_source
}

# interconnect (mem/dac)

if {$sys_zynq == 0} {
  connect_bd_intf_net -intf_net axi_mem_interconnect_s08_axi [get_bd_intf_pins axi_mem_interconnect/S08_AXI] [get_bd_intf_pins axi_ad9361_dac_dma/m_src_axi]
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/S08_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aresetn]
  connect_bd_intf_net -intf_net axi_mem_interconnect_s09_axi [get_bd_intf_pins axi_mem_interconnect/S09_AXI] [get_bd_intf_pins axi_ad9361_adc_dma/m_dest_axi]
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/S09_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aresetn]
} else {
  connect_bd_intf_net -intf_net axi_ad9361_dac_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9361_dac_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9361_dac_dma/m_src_axi]
  connect_bd_intf_net -intf_net axi_ad9361_dac_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9361_dac_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_dac_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_dac_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_dac_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aclk]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_dac_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_dac_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_dac_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aresetn]      
  connect_bd_intf_net -intf_net axi_ad9361_adc_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9361_adc_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9361_adc_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_ad9361_adc_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9361_adc_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_adc_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_adc_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_adc_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_adc_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_adc_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_adc_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aresetn] 
}    

if {$xl_board eq "zc702"} {

  # ila (adc) master

  set ila_adc_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc_0]
  set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc_0
  set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc_0
  set_property -dict [list CONFIG.C_PROBE1_WIDTH {128}] $ila_adc_0

  connect_bd_net -net axi_ad9361_0_clk [get_bd_pins ila_adc_0/clk]
  connect_bd_net -net axi_ad9361_0_adc_dwr [get_bd_pins ila_adc_0/probe0]
  connect_bd_net -net axi_ad9361_adc_ddata [get_bd_pins ila_adc_0/probe1]

} else {

  # ila (adc) master

  set ila_adc_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc_0]
  set_property -dict [list CONFIG.C_NUM_OF_PROBES {5}] $ila_adc_0
  set_property -dict [list CONFIG.C_PROBE0_WIDTH {62}] $ila_adc_0
  set_property -dict [list CONFIG.C_PROBE1_WIDTH {112}] $ila_adc_0
  set_property -dict [list CONFIG.C_PROBE2_WIDTH {112}] $ila_adc_0
  set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] $ila_adc_0
  set_property -dict [list CONFIG.C_PROBE4_WIDTH {128}] $ila_adc_0

  connect_bd_net -net axi_ad9361_0_clk [get_bd_pins ila_adc_0/clk]
  connect_bd_net -net axi_ad9361_0_dev_l_dbg_data [get_bd_pins axi_ad9361_0/dev_l_dbg_data] [get_bd_pins ila_adc_0/probe0]
  connect_bd_net -net axi_ad9361_0_dev_dbg_data [get_bd_pins axi_ad9361_0/dev_dbg_data] [get_bd_pins ila_adc_0/probe1]
  connect_bd_net -net axi_ad9361_1_dev_dbg_data [get_bd_pins axi_ad9361_1/dev_dbg_data] [get_bd_pins ila_adc_0/probe2]
  connect_bd_net -net axi_ad9361_0_adc_dwr [get_bd_pins ila_adc_0/probe3]
  connect_bd_net -net axi_ad9361_adc_ddata [get_bd_pins ila_adc_0/probe4]

  # ila (adc) slave

  set ila_adc_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc_1]
  set_property -dict [list CONFIG.C_NUM_OF_PROBES {1}] $ila_adc_1
  set_property -dict [list CONFIG.C_PROBE0_WIDTH {62}] $ila_adc_1

  connect_bd_net -net axi_ad9361_1_clk [get_bd_pins ila_adc_1/clk]
  connect_bd_net -net axi_ad9361_1_dev_l_dbg_data [get_bd_pins axi_ad9361_1/dev_l_dbg_data] [get_bd_pins ila_adc_1/probe0]    
}

# address map

create_bd_addr_seg -range 0x00010000 -offset 0x79020000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9361_0/s_axi/axi_lite]        SEG_data_ad9361_0
create_bd_addr_seg -range 0x00010000 -offset 0x7C420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9361_dac_dma/s_axi/axi_lite]  SEG_data_ad9361_0_dac_dma
create_bd_addr_seg -range 0x00010000 -offset 0x7C400000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9361_adc_dma/s_axi/axi_lite]  SEG_data_ad9361_0_adc_dma
create_bd_addr_seg -range 0x00010000 -offset 0x79040000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9361_1/s_axi/axi_lite]        SEG_data_ad9361_1   

if {$sys_zynq == 0} {
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcomms2_spi/axi_lite/Reg]      SEG_data_fmcomms2_spi
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcomms2_gpio/S_AXI/Reg]        SEG_data_fmcomms2_gpio
}

if {$sys_zynq == 0} {
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9361_dac_dma/m_src_axi]  [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9361_adc_dma/m_dest_axi] [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl
} else {    
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9361_dac_dma/m_src_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9361_adc_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
}

