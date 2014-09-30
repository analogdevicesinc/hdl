
    source $ad_hdl_dir/projects/common/xilinx/sys_wfifo.tcl

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
    set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9361_dac_dma

    # channel packing for the ADC
    set util_adc_pack [create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 util_adc_pack]
    set_property -dict [list CONFIG.CHANNELS {4}] $util_adc_pack

    set util_dac_unpack [create_bd_cell -type ip -vlnv analog.com:user:util_dac_unpack:1.0 util_dac_unpack]
    set_property -dict [list CONFIG.CHANNELS {4}] $util_dac_unpack

    # constant 0
    set constant_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.0 constant_0]
    set_property -dict [list CONFIG.CONST_VAL {0}] $constant_0

if {$sys_zynq == 1} {
    set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_SRC {1}] $axi_ad9361_dac_dma
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
    set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}]  $axi_ad9361_adc_dma

if {$sys_zynq == 1} {
    set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_DEST {1}] $axi_ad9361_adc_dma
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
    connect_bd_net -net axi_ad9361_clk [get_bd_pins axi_ad9361/l_clk]
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

    connect_bd_net -net axi_ad9361_clk              [get_bd_pins util_adc_pack/clk]
    connect_bd_net -net axi_ad9361_adc_valid_i0     [get_bd_pins axi_ad9361/adc_valid_i0]  [get_bd_pins util_adc_pack/chan_valid_0]
    connect_bd_net -net axi_ad9361_adc_valid_q0     [get_bd_pins axi_ad9361/adc_valid_q0]  [get_bd_pins util_adc_pack/chan_valid_1]
    connect_bd_net -net axi_ad9361_adc_valid_i1     [get_bd_pins axi_ad9361/adc_valid_i1]  [get_bd_pins util_adc_pack/chan_valid_2]
    connect_bd_net -net axi_ad9361_adc_valid_q1     [get_bd_pins axi_ad9361/adc_valid_q1]  [get_bd_pins util_adc_pack/chan_valid_3]
    connect_bd_net -net axi_ad9361_adc_enable_i0    [get_bd_pins axi_ad9361/adc_enable_i0]  [get_bd_pins util_adc_pack/chan_enable_0]
    connect_bd_net -net axi_ad9361_adc_enable_q0    [get_bd_pins axi_ad9361/adc_enable_q0]  [get_bd_pins util_adc_pack/chan_enable_1]
    connect_bd_net -net axi_ad9361_adc_enable_i1    [get_bd_pins axi_ad9361/adc_enable_i1]  [get_bd_pins util_adc_pack/chan_enable_2]
    connect_bd_net -net axi_ad9361_adc_enable_q1    [get_bd_pins axi_ad9361/adc_enable_q1]  [get_bd_pins util_adc_pack/chan_enable_3]
    connect_bd_net -net axi_ad9361_adc_chan_i0      [get_bd_pins axi_ad9361/adc_data_i0]  [get_bd_pins util_adc_pack/chan_data_0]
    connect_bd_net -net axi_ad9361_adc_chan_q0      [get_bd_pins axi_ad9361/adc_data_q0]  [get_bd_pins util_adc_pack/chan_data_1]
    connect_bd_net -net axi_ad9361_adc_chan_i1      [get_bd_pins axi_ad9361/adc_data_i1]  [get_bd_pins util_adc_pack/chan_data_2]
    connect_bd_net -net axi_ad9361_adc_chan_q1      [get_bd_pins axi_ad9361/adc_data_q1]  [get_bd_pins util_adc_pack/chan_data_3]
    connect_bd_net -net util_adc_pack_dvalid        [get_bd_pins util_adc_pack/dvalid] [get_bd_pins axi_ad9361_adc_dma/fifo_wr_en]
    connect_bd_net -net util_adc_pack_dsync         [get_bd_pins util_adc_pack/dsync]  [get_bd_pins axi_ad9361_adc_dma/fifo_wr_sync]
    connect_bd_net -net util_adc_pack_ddata         [get_bd_pins util_adc_pack/ddata]  [get_bd_pins axi_ad9361_adc_dma/fifo_wr_din]
    connect_bd_net -net axi_ad9361_adc_dovf         [get_bd_pins axi_ad9361/adc_dovf]  [get_bd_pins axi_ad9361_adc_dma/fifo_wr_overflow]


    connect_bd_net -net axi_ad9361_clk              [get_bd_pins util_dac_unpack/clk]
    connect_bd_net -net axi_ad9361_dac_valid_0      [get_bd_pins util_dac_unpack/dac_valid_00] [get_bd_pins axi_ad9361/dac_valid_i0]
    connect_bd_net -net axi_ad9361_dac_valid_1      [get_bd_pins util_dac_unpack/dac_valid_01] [get_bd_pins axi_ad9361/dac_valid_q0]
    connect_bd_net -net axi_ad9361_dac_valid_2      [get_bd_pins util_dac_unpack/dac_valid_02] [get_bd_pins axi_ad9361/dac_valid_i1]
    connect_bd_net -net axi_ad9361_dac_valid_3      [get_bd_pins util_dac_unpack/dac_valid_03] [get_bd_pins axi_ad9361/dac_valid_q1]
    connect_bd_net -net axi_ad9361_dac_enable_0     [get_bd_pins util_dac_unpack/dac_enable_00] [get_bd_pins axi_ad9361/dac_enable_i0]
    connect_bd_net -net axi_ad9361_dac_enable_1     [get_bd_pins util_dac_unpack/dac_enable_01] [get_bd_pins axi_ad9361/dac_enable_q0]
    connect_bd_net -net axi_ad9361_dac_enable_2     [get_bd_pins util_dac_unpack/dac_enable_02] [get_bd_pins axi_ad9361/dac_enable_i1]
    connect_bd_net -net axi_ad9361_dac_enable_3     [get_bd_pins util_dac_unpack/dac_enable_03] [get_bd_pins axi_ad9361/dac_enable_q1]
    connect_bd_net -net axi_ad9361_dac_data_0       [get_bd_pins util_dac_unpack/dac_data_00] [get_bd_pins axi_ad9361/dac_data_i0]
    connect_bd_net -net axi_ad9361_dac_data_1       [get_bd_pins util_dac_unpack/dac_data_01] [get_bd_pins axi_ad9361/dac_data_q0]
    connect_bd_net -net axi_ad9361_dac_data_2       [get_bd_pins util_dac_unpack/dac_data_02] [get_bd_pins axi_ad9361/dac_data_i1]
    connect_bd_net -net axi_ad9361_dac_data_3       [get_bd_pins util_dac_unpack/dac_data_03] [get_bd_pins axi_ad9361/dac_data_q1]

    connect_bd_net -net fifo_data                   [get_bd_pins util_dac_unpack/dma_data] [get_bd_pins axi_ad9361_dac_dma/fifo_rd_dout]
    connect_bd_net -net fifo_valid                  [get_bd_pins axi_ad9361_dac_dma/fifo_rd_valid] [get_bd_pins util_dac_unpack/fifo_valid]
    connect_bd_net -net axi_ad9361_dac_drd          [get_bd_pins util_dac_unpack/dma_rd]  [get_bd_pins axi_ad9361_dac_dma/fifo_rd_en]
    connect_bd_net -net axi_ad9361_dac_dunf         [get_bd_pins axi_ad9361/dac_dunf]   [get_bd_pins axi_ad9361_dac_dma/fifo_rd_underflow]


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
    connect_bd_intf_net -intf_net axi_ad9361_dac_dma_axi [get_bd_intf_pins axi_ad9361_dac_dma/m_src_axi] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aclk]
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
    connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aresetn]

    connect_bd_intf_net -intf_net axi_ad9361_adc_dma_axi [get_bd_intf_pins axi_ad9361_adc_dma/m_dest_axi] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aclk]
    connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aresetn]
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]

}

    # ila (adc)

    set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc]
    set_property -dict [list CONFIG.C_NUM_OF_PROBES {8}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE2_WIDTH {1}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE4_WIDTH {16}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE5_WIDTH {16}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE6_WIDTH {16}] $ila_adc
    set_property -dict [list CONFIG.C_PROBE7_WIDTH {16}] $ila_adc
    set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc
    set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc

    p_sys_wfifo [current_bd_instance .] sys_wfifo_0 16 16
    p_sys_wfifo [current_bd_instance .] sys_wfifo_1 16 16
    p_sys_wfifo [current_bd_instance .] sys_wfifo_2 16 16
    p_sys_wfifo [current_bd_instance .] sys_wfifo_3 16 16

    if {$sys_zynq == 0} {
    connect_bd_net -net sys_200m_clk [get_bd_pins ila_adc/clk]
    connect_bd_net -net sys_200m_clk [get_bd_pins sys_wfifo_0/s_clk] $sys_200m_clk_source
    connect_bd_net -net sys_200m_clk [get_bd_pins sys_wfifo_1/s_clk] $sys_200m_clk_source
    connect_bd_net -net sys_200m_clk [get_bd_pins sys_wfifo_2/s_clk] $sys_200m_clk_source
    connect_bd_net -net sys_200m_clk [get_bd_pins sys_wfifo_3/s_clk] $sys_200m_clk_source
  } else {
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins ila_adc/clk]
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_wfifo_0/s_clk] $sys_fmc_dma_clk_source
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_wfifo_1/s_clk] $sys_fmc_dma_clk_source
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_wfifo_2/s_clk] $sys_fmc_dma_clk_source
    connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_wfifo_3/s_clk] $sys_fmc_dma_clk_source
  }

    connect_bd_net -net axi_ad9361_clk [get_bd_pins sys_wfifo_0/m_clk] [get_bd_pins axi_ad9361/l_clk]
    connect_bd_net -net axi_ad9361_clk [get_bd_pins sys_wfifo_1/m_clk] [get_bd_pins axi_ad9361/l_clk]
    connect_bd_net -net axi_ad9361_clk [get_bd_pins sys_wfifo_2/m_clk] [get_bd_pins axi_ad9361/l_clk]
    connect_bd_net -net axi_ad9361_clk [get_bd_pins sys_wfifo_3/m_clk] [get_bd_pins axi_ad9361/l_clk]
    connect_bd_net -net sys_100m_resetn [get_bd_pins sys_wfifo_0/rstn] $sys_100m_resetn_source
    connect_bd_net -net sys_100m_resetn [get_bd_pins sys_wfifo_1/rstn] $sys_100m_resetn_source
    connect_bd_net -net sys_100m_resetn [get_bd_pins sys_wfifo_2/rstn] $sys_100m_resetn_source
    connect_bd_net -net sys_100m_resetn [get_bd_pins sys_wfifo_3/rstn] $sys_100m_resetn_source
    connect_bd_net -net axi_ad9361_adc_valid_i0 [get_bd_pins sys_wfifo_0/m_wr] [get_bd_pins axi_ad9361/adc_valid_i0]
    connect_bd_net -net axi_ad9361_adc_valid_q0 [get_bd_pins sys_wfifo_1/m_wr] [get_bd_pins axi_ad9361/adc_valid_q0]
    connect_bd_net -net axi_ad9361_adc_valid_i1 [get_bd_pins sys_wfifo_2/m_wr] [get_bd_pins axi_ad9361/adc_valid_i1]
    connect_bd_net -net axi_ad9361_adc_valid_q1 [get_bd_pins sys_wfifo_3/m_wr] [get_bd_pins axi_ad9361/adc_valid_q1]
    connect_bd_net -net axi_ad9361_adc_chan_i0  [get_bd_pins sys_wfifo_0/m_wdata] [get_bd_pins axi_ad9361/adc_data_i0]
    connect_bd_net -net axi_ad9361_adc_chan_q0  [get_bd_pins sys_wfifo_1/m_wdata] [get_bd_pins axi_ad9361/adc_data_q0]
    connect_bd_net -net axi_ad9361_adc_chan_i1  [get_bd_pins sys_wfifo_2/m_wdata] [get_bd_pins axi_ad9361/adc_data_i1]
    connect_bd_net -net axi_ad9361_adc_chan_q1  [get_bd_pins sys_wfifo_3/m_wdata] [get_bd_pins axi_ad9361/adc_data_q1]

    connect_bd_net -net util_wfifo_0_s_wr     [get_bd_pins sys_wfifo_0/s_wr]  [get_bd_pins ila_adc/probe0]
    connect_bd_net -net util_wfifo_1_s_wr     [get_bd_pins sys_wfifo_1/s_wr]  [get_bd_pins ila_adc/probe1]
    connect_bd_net -net util_wfifo_2_s_wr     [get_bd_pins sys_wfifo_2/s_wr]  [get_bd_pins ila_adc/probe2]
    connect_bd_net -net util_wfifo_3_s_wr     [get_bd_pins sys_wfifo_3/s_wr]  [get_bd_pins ila_adc/probe3]
    connect_bd_net -net util_wfifo_0_s_wdata  [get_bd_pins sys_wfifo_0/s_wdata] [get_bd_pins ila_adc/probe4]
    connect_bd_net -net util_wfifo_1_s_wdata  [get_bd_pins sys_wfifo_1/s_wdata] [get_bd_pins ila_adc/probe5]
    connect_bd_net -net util_wfifo_2_s_wdata  [get_bd_pins sys_wfifo_2/s_wdata] [get_bd_pins ila_adc/probe6]
    connect_bd_net -net util_wfifo_3_s_wdata  [get_bd_pins sys_wfifo_3/s_wdata] [get_bd_pins ila_adc/probe7]

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
