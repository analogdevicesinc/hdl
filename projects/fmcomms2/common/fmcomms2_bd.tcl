
    # fmcomms2

    set spi_csn_i       [create_bd_port -dir I spi_csn_i]
    set spi_csn_o       [create_bd_port -dir O spi_csn_o]
    set spi_sclk_i      [create_bd_port -dir I spi_sclk_i]
    set spi_sclk_o      [create_bd_port -dir O spi_sclk_o]
    set spi_mosi_i      [create_bd_port -dir I spi_mosi_i]
    set spi_mosi_o      [create_bd_port -dir O spi_mosi_o]
    set spi_miso_i      [create_bd_port -dir I spi_miso_i]

    set rx_clk_in_p     [create_bd_port -dir I rx_clk_in_p]
    set rx_clk_in_n     [create_bd_port -dir I rx_clk_in_n]
    set rx_frame_in_p   [create_bd_port -dir I rx_frame_in_p]
    set rx_frame_in_n   [create_bd_port -dir I rx_frame_in_n]
    set rx_data_in_p    [create_bd_port -dir I -from 5 -to 0 rx_data_in_p]
    set rx_data_in_n    [create_bd_port -dir I -from 5 -to 0 rx_data_in_n]

    set tx_clk_out_p    [create_bd_port -dir O tx_clk_out_p]
    set tx_clk_out_n    [create_bd_port -dir O tx_clk_out_n]
    set tx_frame_out_p  [create_bd_port -dir O tx_frame_out_p]
    set tx_frame_out_n  [create_bd_port -dir O tx_frame_out_n]
    set tx_data_out_p   [create_bd_port -dir O -from 5 -to 0 tx_data_out_p]
    set tx_data_out_n   [create_bd_port -dir O -from 5 -to 0 tx_data_out_n]

    if {$sys_zynq == 0} {
        set gpio_fmcomms2_i       [create_bd_port -dir I -from 16 -to 0 gpio_fmcomms2_i]
        set gpio_fmcomms2_o       [create_bd_port -dir O -from 16 -to 0 gpio_fmcomms2_o]
        set gpio_fmcomms2_t       [create_bd_port -dir O -from 16 -to 0 gpio_fmcomms2_t]
    }

    # ad9361 core

    set axi_ad9361 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361]
    set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9361

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

if {$sys_zynq == 1} {
    set axi_ad9361_adc_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9361_adc_dma_interconnect]
    set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9361_adc_dma_interconnect
}

    # spi
if {$sys_zynq == 0} {
    set axi_fmcomms2_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 axi_fmcomms2_spi]
    set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_fmcomms2_spi
    set_property -dict [list CONFIG.C_NUM_SS_BITS {1}] $axi_fmcomms2_spi
    set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_fmcomms2_spi
}

    # gpio
if {$sys_zynq == 0} {
    set axi_fmcomms2_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_fmcomms2_gpio]
    set_property -dict [list CONFIG.C_IS_DUAL {0}] $axi_fmcomms2_gpio
    set_property -dict [list CONFIG.C_GPIO_WIDTH {17}] $axi_fmcomms2_gpio
    set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_fmcomms2_gpio
}

    # additions to default configuration

if {$sys_zynq == 0} {
    set_property -dict [list CONFIG.NUM_MI {12}] $axi_cpu_interconnect
} else {
    set_property -dict [list CONFIG.NUM_MI {10}] $axi_cpu_interconnect
}

if {$sys_zynq == 0} {
    set_property -dict [list CONFIG.NUM_SI {10}] $axi_mem_interconnect
    set_property -dict [list CONFIG.NUM_PORTS {9}] $sys_concat_intc
}

if {$sys_zynq == 1} {
    set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
    set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
    set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
    set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
    set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
    set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {49}] $sys_ps7
    set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
    set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7

    set_property LEFT 48 [get_bd_ports GPIO_I]
    set_property LEFT 48 [get_bd_ports GPIO_O]
    set_property LEFT 48 [get_bd_ports GPIO_T]
}

    # connections (spi)

if {$sys_zynq == 0} {
    connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]    [get_bd_pins axi_fmcomms2_spi/ss_i]
    connect_bd_net -net spi_csn_o   [get_bd_ports spi_csn_o]    [get_bd_pins axi_fmcomms2_spi/ss_o]
    connect_bd_net -net spi_sclk_i  [get_bd_ports spi_sclk_i]   [get_bd_pins axi_fmcomms2_spi/sck_i]
    connect_bd_net -net spi_sclk_o  [get_bd_ports spi_sclk_o]   [get_bd_pins axi_fmcomms2_spi/sck_o]
    connect_bd_net -net spi_mosi_i  [get_bd_ports spi_mosi_i]   [get_bd_pins axi_fmcomms2_spi/io0_i]
    connect_bd_net -net spi_mosi_o  [get_bd_ports spi_mosi_o]   [get_bd_pins axi_fmcomms2_spi/io0_o]
    connect_bd_net -net spi_miso_i  [get_bd_ports spi_miso_i]   [get_bd_pins axi_fmcomms2_spi/io1_i]
    connect_bd_net -net axi_fmcomms2_spi_irq [get_bd_pins axi_fmcomms2_spi/ip2intc_irpt] [get_bd_pins sys_concat_intc/In7]
} else {
    connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]    [get_bd_pins sys_ps7/SPI0_SS_I]
    connect_bd_net -net spi_csn_o   [get_bd_ports spi_csn_o]    [get_bd_pins sys_ps7/SPI0_SS_O]
    connect_bd_net -net spi_sclk_i  [get_bd_ports spi_sclk_i]   [get_bd_pins sys_ps7/SPI0_SCLK_I]
    connect_bd_net -net spi_sclk_o  [get_bd_ports spi_sclk_o]   [get_bd_pins sys_ps7/SPI0_SCLK_O]
    connect_bd_net -net spi_mosi_i  [get_bd_ports spi_mosi_i]   [get_bd_pins sys_ps7/SPI0_MOSI_I]
    connect_bd_net -net spi_mosi_o  [get_bd_ports spi_mosi_o]   [get_bd_pins sys_ps7/SPI0_MOSI_O]
    connect_bd_net -net spi_miso_i  [get_bd_ports spi_miso_i]   [get_bd_pins sys_ps7/SPI0_MISO_I]
}

    # connections (gpio)
if {$sys_zynq == 0} {
    connect_bd_net -net gpio_fmcomms2_i [get_bd_ports gpio_fmcomms2_i]    [get_bd_pins axi_fmcomms2_gpio/gpio_io_i]
    connect_bd_net -net gpio_fmcomms2_o [get_bd_ports gpio_fmcomms2_o]    [get_bd_pins axi_fmcomms2_gpio/gpio_io_o]
    connect_bd_net -net gpio_fmcomms2_t [get_bd_ports gpio_fmcomms2_t]    [get_bd_pins axi_fmcomms2_gpio/gpio_io_t]
    connect_bd_net -net axi_fmcomms2_gpio_irq [get_bd_pins axi_fmcomms2_gpio/ip2intc_irpt] [get_bd_pins sys_concat_intc/In8]
}
    # connections (ad9361)

    connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9361/delay_clk]
    connect_bd_net -net axi_ad9361_clk [get_bd_pins axi_ad9361/clk]
    connect_bd_net -net axi_ad9361_clk [get_bd_pins axi_ad9361_adc_dma/fifo_wr_clk]
    connect_bd_net -net axi_ad9361_clk [get_bd_pins axi_ad9361_dac_dma/fifo_rd_clk]

    connect_bd_net -net axi_ad9361_rx_clk_in_p      [get_bd_ports rx_clk_in_p]            [get_bd_pins axi_ad9361/rx_clk_in_p]
    connect_bd_net -net axi_ad9361_rx_clk_in_n      [get_bd_ports rx_clk_in_n]            [get_bd_pins axi_ad9361/rx_clk_in_n]
    connect_bd_net -net axi_ad9361_rx_frame_in_p    [get_bd_ports rx_frame_in_p]          [get_bd_pins axi_ad9361/rx_frame_in_p]
    connect_bd_net -net axi_ad9361_rx_frame_in_n    [get_bd_ports rx_frame_in_n]          [get_bd_pins axi_ad9361/rx_frame_in_n]
    connect_bd_net -net axi_ad9361_rx_data_in_p     [get_bd_ports rx_data_in_p]           [get_bd_pins axi_ad9361/rx_data_in_p]
    connect_bd_net -net axi_ad9361_rx_data_in_n     [get_bd_ports rx_data_in_n]           [get_bd_pins axi_ad9361/rx_data_in_n]
    connect_bd_net -net axi_ad9361_tx_clk_out_p     [get_bd_ports tx_clk_out_p]           [get_bd_pins axi_ad9361/tx_clk_out_p]
    connect_bd_net -net axi_ad9361_tx_clk_out_n     [get_bd_ports tx_clk_out_n]           [get_bd_pins axi_ad9361/tx_clk_out_n]
    connect_bd_net -net axi_ad9361_tx_frame_out_p   [get_bd_ports tx_frame_out_p]         [get_bd_pins axi_ad9361/tx_frame_out_p]
    connect_bd_net -net axi_ad9361_tx_frame_out_n   [get_bd_ports tx_frame_out_n]         [get_bd_pins axi_ad9361/tx_frame_out_n]
    connect_bd_net -net axi_ad9361_tx_data_out_p    [get_bd_ports tx_data_out_p]          [get_bd_pins axi_ad9361/tx_data_out_p]
    connect_bd_net -net axi_ad9361_tx_data_out_n    [get_bd_ports tx_data_out_n]          [get_bd_pins axi_ad9361/tx_data_out_n]
    connect_bd_net -net axi_ad9361_adc_dwr          [get_bd_pins axi_ad9361/adc_dwr]      [get_bd_pins axi_ad9361_adc_dma/fifo_wr_en]
    connect_bd_net -net axi_ad9361_adc_dsync        [get_bd_pins axi_ad9361/adc_dsync]    [get_bd_pins axi_ad9361_adc_dma/fifo_wr_sync]
    connect_bd_net -net axi_ad9361_adc_ddata        [get_bd_pins axi_ad9361/adc_ddata]    [get_bd_pins axi_ad9361_adc_dma/fifo_wr_din]
    connect_bd_net -net axi_ad9361_adc_dovf         [get_bd_pins axi_ad9361/adc_dovf]     [get_bd_pins axi_ad9361_adc_dma/fifo_wr_overflow]
    connect_bd_net -net axi_ad9361_dac_drd          [get_bd_pins axi_ad9361/dac_drd]      [get_bd_pins axi_ad9361_dac_dma/fifo_rd_en]
    connect_bd_net -net axi_ad9361_dac_ddata        [get_bd_pins axi_ad9361/dac_ddata]    [get_bd_pins axi_ad9361_dac_dma/fifo_rd_dout]
    connect_bd_net -net axi_ad9361_dac_dunf         [get_bd_pins axi_ad9361/dac_dunf]     [get_bd_pins axi_ad9361_dac_dma/fifo_rd_underflow]

if {$sys_zynq == 0} {
    connect_bd_net -net axi_ad9361_adc_dma_irq      [get_bd_pins axi_ad9361_adc_dma/irq]  [get_bd_pins sys_concat_intc/In5]
    connect_bd_net -net axi_ad9361_dac_dma_irq      [get_bd_pins axi_ad9361_dac_dma/irq]  [get_bd_pins sys_concat_intc/In6]
} else {
    connect_bd_net -net axi_ad9361_adc_dma_irq      [get_bd_pins axi_ad9361_adc_dma/irq]  [get_bd_pins sys_concat_intc/In2]
    connect_bd_net -net axi_ad9361_dac_dma_irq      [get_bd_pins axi_ad9361_dac_dma/irq]  [get_bd_pins sys_concat_intc/In3]
}

    # interconnect (cpu)

    connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9361/s_axi]
    connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9361_adc_dma/s_axi]
    connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9361_dac_dma/s_axi]
    connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
    connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
    connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
    connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9361/s_axi_aclk]
    connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9361_adc_dma/s_axi_aclk]
    connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9361_dac_dma/s_axi_aclk]
    connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
    connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
    connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
    connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361/s_axi_aresetn]
    connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_adc_dma/s_axi_aresetn]
    connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_dac_dma/s_axi_aresetn]

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

    # ila (adc)

    set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc]
    set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE1_WIDTH {48}] $ila_adc
    set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc

    connect_bd_net -net axi_ad9361_clk  [get_bd_pins ila_adc/clk]
    connect_bd_net -net axi_ad9361_adc_mon_valid  [get_bd_pins axi_ad9361/adc_mon_valid]  [get_bd_pins ila_adc/probe0]
    connect_bd_net -net axi_ad9361_adc_mon_data   [get_bd_pins axi_ad9361/adc_mon_data]   [get_bd_pins ila_adc/probe1]

    # address map

    create_bd_addr_seg -range 0x00010000 -offset 0x79020000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9361/s_axi/axi_lite]          SEG_data_ad9361
    create_bd_addr_seg -range 0x00010000 -offset 0x7C420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9361_dac_dma/s_axi/axi_lite]  SEG_data_ad9361_dac_dma
    create_bd_addr_seg -range 0x00010000 -offset 0x7C400000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9361_adc_dma/s_axi/axi_lite]  SEG_data_ad9361_adc_dma

if {$sys_zynq == 0} {
    create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcomms2_spi/axi_lite/Reg]      SEG_data_fmcomms2_spi
    create_bd_addr_seg -range 0x00010000 -offset 0x40000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcomms2_gpio/S_AXI/Reg]        SEG_data_fmcomms2_gpio
}

if {$sys_zynq == 0} {
    create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9361_dac_dma/m_src_axi] [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl
    create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9361_adc_dma/m_dest_axi] [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl
} else {
    create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9361_dac_dma/m_src_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm
    create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9361_adc_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
}
