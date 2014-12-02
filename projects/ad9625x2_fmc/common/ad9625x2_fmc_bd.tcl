
# ad9625

set spi_csn_o       [create_bd_port -dir O -from 1 -to 0 spi_csn_o]
set spi_csn_i       [create_bd_port -dir I -from 1 -to 0 spi_csn_i]
set spi_clk_i       [create_bd_port -dir I spi_clk_i]
set spi_clk_o       [create_bd_port -dir O spi_clk_o]
set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

set rx_ref_clk_0    [create_bd_port -dir I rx_ref_clk_0]
set rx_data_0_p     [create_bd_port -dir I -from 7 -to 0 rx_data_0_p]
set rx_data_0_n     [create_bd_port -dir I -from 7 -to 0 rx_data_0_n]
set rx_sync_0       [create_bd_port -dir O rx_sync_0]

set rx_ref_clk_1    [create_bd_port -dir I rx_ref_clk_1]
set rx_data_1_p     [create_bd_port -dir I -from 7 -to 0 rx_data_1_p]
set rx_data_1_n     [create_bd_port -dir I -from 7 -to 0 rx_data_1_n]
set rx_sync_1       [create_bd_port -dir O rx_sync_1]

set rx_sysref       [create_bd_port -dir O rx_sysref]

set ad9625_spi_intr  [create_bd_port -dir O ad9625_spi_intr]
set ad9625_gpio_intr [create_bd_port -dir O ad9625_gpio_intr]
set ad9625_dma_intr  [create_bd_port -dir O ad9625_dma_intr]
set dac_spi_intr     [create_bd_port -dir O dac_spi_intr]

set gpio_ad9625_i   [create_bd_port -dir I -from 18 -to 0 gpio_ad9625_i]
set gpio_ad9625_o   [create_bd_port -dir O -from 18 -to 0 gpio_ad9625_o]
set gpio_ad9625_t   [create_bd_port -dir O -from 18 -to 0 gpio_ad9625_t]

set adc_clk         [create_bd_port -dir O adc_clk]
set adc_valid_0     [create_bd_port -dir O adc_valid_0]
set adc_enable_0    [create_bd_port -dir O adc_enable_0]
set adc_data_0      [create_bd_port -dir O -from 255 -to 0 adc_data_0]
set adc_valid_1     [create_bd_port -dir O adc_valid_1]
set adc_enable_1    [create_bd_port -dir O adc_enable_1]
set adc_data_1      [create_bd_port -dir O -from 255 -to 0 adc_data_1]
set adc_wr          [create_bd_port -dir I adc_wr]
set adc_wdata       [create_bd_port -dir I -from 511 -to 0 adc_wdata]

# dac spi interface

set dac_sync_o        [create_bd_port -dir O -from 1 -to 0 dac_sync_o]
set dac_sync_i        [create_bd_port -dir I -from 1 -to 0 dac_sync_i]
set dac_clk_o         [create_bd_port -dir O dac_clk_o]
set dac_clk_i         [create_bd_port -dir I dac_clk_i]
set dac_do_o          [create_bd_port -dir O dac_do_o]
set dac_do_i          [create_bd_port -dir I dac_do_i]
set dac_di_i          [create_bd_port -dir I dac_di_i]

# adc peripherals

set axi_ad9625_0_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_0_core]
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9625_0_core

set axi_ad9625_0_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.2 axi_ad9625_0_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_0_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_0_jesd

set axi_ad9625_0_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_ad9625_0_gt]
set_property -dict [list CONFIG.PCORE_NUM_OF_RX_LANES {8}] $axi_ad9625_0_gt
set_property -dict [list CONFIG.PCORE_CPLL_FBDIV {1}] $axi_ad9625_0_gt
set_property -dict [list CONFIG.PCORE_RX_OUT_DIV {1}] $axi_ad9625_0_gt
set_property -dict [list CONFIG.PCORE_TX_OUT_DIV {1}] $axi_ad9625_0_gt
set_property -dict [list CONFIG.PCORE_RX_CLK25_DIV {25}] $axi_ad9625_0_gt
set_property -dict [list CONFIG.PCORE_TX_CLK25_DIV {25}] $axi_ad9625_0_gt
set_property -dict [list CONFIG.PCORE_PMA_RSV {0x00018480}] $axi_ad9625_0_gt
set_property -dict [list CONFIG.PCORE_RX_CDR_CFG {0x03000023ff20400020}] $axi_ad9625_0_gt

set axi_ad9625_1_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9625:1.0 axi_ad9625_1_core]
set_property -dict [list CONFIG.PCORE_ID {1}] $axi_ad9625_1_core

set axi_ad9625_1_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.2 axi_ad9625_1_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9625_1_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_ad9625_1_jesd

set axi_ad9625_1_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_ad9625_1_gt]
set_property -dict [list CONFIG.PCORE_NUM_OF_RX_LANES {8}] $axi_ad9625_1_gt
set_property -dict [list CONFIG.PCORE_CPLL_FBDIV {1}] $axi_ad9625_1_gt
set_property -dict [list CONFIG.PCORE_RX_OUT_DIV {1}] $axi_ad9625_1_gt
set_property -dict [list CONFIG.PCORE_TX_OUT_DIV {1}] $axi_ad9625_1_gt
set_property -dict [list CONFIG.PCORE_RX_CLK25_DIV {25}] $axi_ad9625_1_gt
set_property -dict [list CONFIG.PCORE_TX_CLK25_DIV {25}] $axi_ad9625_1_gt
set_property -dict [list CONFIG.PCORE_PMA_RSV {0x00018480}] $axi_ad9625_1_gt
set_property -dict [list CONFIG.PCORE_RX_CDR_CFG {0x03000023ff20400020}] $axi_ad9625_1_gt

set axi_ad9625_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9625_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {1}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9625_dma

set axi_ad9625_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_ad9625_gpio]
set_property -dict [list CONFIG.C_IS_DUAL {0}] $axi_ad9625_gpio
set_property -dict [list CONFIG.C_GPIO_WIDTH {15}] $axi_ad9625_gpio
set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_ad9625_gpio

set axi_ad9625_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_ad9625_spi]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_ad9625_spi
set_property -dict [list CONFIG.C_NUM_SS_BITS {2}] $axi_ad9625_spi
set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_ad9625_spi

set axi_dac_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_dac_spi]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_dac_spi
set_property -dict [list CONFIG.C_NUM_SS_BITS {2}] $axi_dac_spi
set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_dac_spi

p_sys_dmafifo [current_bd_instance .] axi_ad9625_fifo 512 18

# additions to default configuration

set_property -dict [list CONFIG.NUM_MI {17}] $axi_cpu_interconnect
set_property -dict [list CONFIG.NUM_SI {11}] $axi_mem_interconnect

# connections (spi and gpio)

connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]      [get_bd_pins axi_ad9625_spi/ss_i]
connect_bd_net -net spi_csn_o   [get_bd_ports spi_csn_o]      [get_bd_pins axi_ad9625_spi/ss_o]
connect_bd_net -net spi_clk_i   [get_bd_ports spi_clk_i]      [get_bd_pins axi_ad9625_spi/sck_i]
connect_bd_net -net spi_clk_o   [get_bd_ports spi_clk_o]      [get_bd_pins axi_ad9625_spi/sck_o]
connect_bd_net -net spi_sdo_i   [get_bd_ports spi_sdo_i]      [get_bd_pins axi_ad9625_spi/io0_i]
connect_bd_net -net spi_sdo_o   [get_bd_ports spi_sdo_o]      [get_bd_pins axi_ad9625_spi/io0_o]
connect_bd_net -net spi_sdi_i   [get_bd_ports spi_sdi_i]      [get_bd_pins axi_ad9625_spi/io1_i]

connect_bd_net -net dac_sync_i  [get_bd_ports dac_sync_i]     [get_bd_pins axi_dac_spi/ss_i]
connect_bd_net -net dac_sync_o  [get_bd_ports dac_sync_o]     [get_bd_pins axi_dac_spi/ss_o]
connect_bd_net -net dac_clk_i   [get_bd_ports dac_clk_i]      [get_bd_pins axi_dac_spi/sck_i]
connect_bd_net -net dac_clk_o   [get_bd_ports dac_clk_o]      [get_bd_pins axi_dac_spi/sck_o]
connect_bd_net -net dac_do_i    [get_bd_ports dac_do_i]       [get_bd_pins axi_dac_spi/io0_i]
connect_bd_net -net dac_do_o    [get_bd_ports dac_do_o]       [get_bd_pins axi_dac_spi/io0_o]
connect_bd_net -net dac_di_i    [get_bd_ports dac_di_i]       [get_bd_pins axi_dac_spi/io1_i]

connect_bd_net -net gpio_ad9625_i  [get_bd_ports gpio_ad9625_i]     [get_bd_pins axi_ad9625_gpio/gpio_io_i]
connect_bd_net -net gpio_ad9625_o  [get_bd_ports gpio_ad9625_o]     [get_bd_pins axi_ad9625_gpio/gpio_io_o]
connect_bd_net -net gpio_ad9625_t  [get_bd_ports gpio_ad9625_t]     [get_bd_pins axi_ad9625_gpio/gpio_io_t]

connect_bd_net -net axi_ad9625_spi_irq  [get_bd_pins axi_ad9625_spi/ip2intc_irpt]   [get_bd_ports ad9625_spi_intr]
connect_bd_net -net axi_dac_spi_irq  [get_bd_pins axi_dac_spi/ip2intc_irpt]   [get_bd_ports dac_spi_intr]
connect_bd_net -net axi_ad9625_gpio_irq [get_bd_pins axi_ad9625_gpio/ip2intc_irpt]  [get_bd_ports ad9625_gpio_intr]

# connections (gt)

connect_bd_net -net axi_ad9625_0_gt_ref_clk_c         [get_bd_pins axi_ad9625_0_gt/ref_clk_c]         [get_bd_ports rx_ref_clk_0]
connect_bd_net -net axi_ad9625_0_gt_rx_data_p         [get_bd_pins axi_ad9625_0_gt/rx_data_p]         [get_bd_ports rx_data_0_p]
connect_bd_net -net axi_ad9625_0_gt_rx_data_n         [get_bd_pins axi_ad9625_0_gt/rx_data_n]         [get_bd_ports rx_data_0_n]
connect_bd_net -net axi_ad9625_0_gt_rx_sync           [get_bd_pins axi_ad9625_0_gt/rx_sync]           [get_bd_ports rx_sync_0]
connect_bd_net -net axi_ad9625_0_gt_rx_sysref         [get_bd_pins axi_ad9625_0_gt/rx_sysref]         [get_bd_ports rx_sysref]

connect_bd_net -net axi_ad9625_1_gt_ref_clk_c         [get_bd_pins axi_ad9625_1_gt/ref_clk_c]         [get_bd_ports rx_ref_clk_1]
connect_bd_net -net axi_ad9625_1_gt_rx_data_p         [get_bd_pins axi_ad9625_1_gt/rx_data_p]         [get_bd_ports rx_data_1_p]
connect_bd_net -net axi_ad9625_1_gt_rx_data_n         [get_bd_pins axi_ad9625_1_gt/rx_data_n]         [get_bd_ports rx_data_1_n]
connect_bd_net -net axi_ad9625_1_gt_rx_sync           [get_bd_pins axi_ad9625_1_gt/rx_sync]           [get_bd_ports rx_sync_1]

# connections (adc)

connect_bd_net -net axi_ad9625_0_gt_rx_rst            [get_bd_pins axi_ad9625_0_gt/rx_rst]
connect_bd_net -net axi_ad9625_0_gt_rx_rst            [get_bd_pins axi_ad9625_0_jesd/rx_reset]
connect_bd_net -net axi_ad9625_0_gt_rx_rst            [get_bd_pins axi_ad9625_1_jesd/rx_reset]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins axi_ad9625_0_gt/rx_clk_g]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins axi_ad9625_0_gt/rx_clk]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins axi_ad9625_0_core/rx_clk]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins axi_ad9625_0_jesd/rx_core_clk]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins axi_ad9625_1_gt/rx_clk]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins axi_ad9625_1_core/rx_clk]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins axi_ad9625_1_jesd/rx_core_clk]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_ports adc_clk]
connect_bd_net -net axi_ad9625_0_gt_rx_sysref         [get_bd_pins axi_ad9625_0_jesd/rx_sysref]
connect_bd_net -net axi_ad9625_0_gt_rx_sysref         [get_bd_pins axi_ad9625_1_jesd/rx_sysref]
connect_bd_net -net axi_ad9625_0_core_raddr           [get_bd_pins axi_ad9625_0_core/adc_raddr_out]
connect_bd_net -net axi_ad9625_0_core_raddr           [get_bd_pins axi_ad9625_0_core/adc_raddr_in]
connect_bd_net -net axi_ad9625_0_core_raddr           [get_bd_pins axi_ad9625_1_core/adc_raddr_in]

connect_bd_net -net axi_ad9625_0_gt_rx_gt_charisk     [get_bd_pins axi_ad9625_0_gt/rx_gt_charisk]     [get_bd_pins axi_ad9625_0_jesd/gt_rxcharisk_in]
connect_bd_net -net axi_ad9625_0_gt_rx_gt_disperr     [get_bd_pins axi_ad9625_0_gt/rx_gt_disperr]     [get_bd_pins axi_ad9625_0_jesd/gt_rxdisperr_in]
connect_bd_net -net axi_ad9625_0_gt_rx_gt_notintable  [get_bd_pins axi_ad9625_0_gt/rx_gt_notintable]  [get_bd_pins axi_ad9625_0_jesd/gt_rxnotintable_in]
connect_bd_net -net axi_ad9625_0_gt_rx_gt_data        [get_bd_pins axi_ad9625_0_gt/rx_gt_data]        [get_bd_pins axi_ad9625_0_jesd/gt_rxdata_in]
connect_bd_net -net axi_ad9625_0_gt_rx_rst_done       [get_bd_pins axi_ad9625_0_gt/rx_rst_done]       [get_bd_pins axi_ad9625_0_jesd/rx_reset_done]
connect_bd_net -net axi_ad9625_0_gt_rx_ip_comma_align [get_bd_pins axi_ad9625_0_gt/rx_ip_comma_align] [get_bd_pins axi_ad9625_0_jesd/rxencommaalign_out]
connect_bd_net -net axi_ad9625_0_gt_rx_ip_sync        [get_bd_pins axi_ad9625_0_gt/rx_ip_sync]        [get_bd_pins axi_ad9625_0_jesd/rx_sync]
connect_bd_net -net axi_ad9625_0_gt_rx_ip_sof         [get_bd_pins axi_ad9625_0_gt/rx_ip_sof]         [get_bd_pins axi_ad9625_0_jesd/rx_start_of_frame]
connect_bd_net -net axi_ad9625_0_gt_rx_ip_data        [get_bd_pins axi_ad9625_0_gt/rx_ip_data]        [get_bd_pins axi_ad9625_0_jesd/rx_tdata]
connect_bd_net -net axi_ad9625_1_gt_rx_gt_charisk     [get_bd_pins axi_ad9625_1_gt/rx_gt_charisk]     [get_bd_pins axi_ad9625_1_jesd/gt_rxcharisk_in]
connect_bd_net -net axi_ad9625_1_gt_rx_gt_disperr     [get_bd_pins axi_ad9625_1_gt/rx_gt_disperr]     [get_bd_pins axi_ad9625_1_jesd/gt_rxdisperr_in]
connect_bd_net -net axi_ad9625_1_gt_rx_gt_notintable  [get_bd_pins axi_ad9625_1_gt/rx_gt_notintable]  [get_bd_pins axi_ad9625_1_jesd/gt_rxnotintable_in]
connect_bd_net -net axi_ad9625_1_gt_rx_gt_data        [get_bd_pins axi_ad9625_1_gt/rx_gt_data]        [get_bd_pins axi_ad9625_1_jesd/gt_rxdata_in]
connect_bd_net -net axi_ad9625_1_gt_rx_rst_done       [get_bd_pins axi_ad9625_1_gt/rx_rst_done]       [get_bd_pins axi_ad9625_1_jesd/rx_reset_done]
connect_bd_net -net axi_ad9625_1_gt_rx_ip_comma_align [get_bd_pins axi_ad9625_1_gt/rx_ip_comma_align] [get_bd_pins axi_ad9625_1_jesd/rxencommaalign_out]
connect_bd_net -net axi_ad9625_1_gt_rx_ip_sync        [get_bd_pins axi_ad9625_1_gt/rx_ip_sync]        [get_bd_pins axi_ad9625_1_jesd/rx_sync]
connect_bd_net -net axi_ad9625_1_gt_rx_ip_sof         [get_bd_pins axi_ad9625_1_gt/rx_ip_sof]         [get_bd_pins axi_ad9625_1_jesd/rx_start_of_frame]
connect_bd_net -net axi_ad9625_1_gt_rx_ip_data        [get_bd_pins axi_ad9625_1_gt/rx_ip_data]        [get_bd_pins axi_ad9625_1_jesd/rx_tdata]
connect_bd_net -net axi_ad9625_0_gt_rx_data           [get_bd_pins axi_ad9625_0_gt/rx_data]           [get_bd_pins axi_ad9625_0_core/rx_data]
connect_bd_net -net axi_ad9625_1_gt_rx_data           [get_bd_pins axi_ad9625_1_gt/rx_data]           [get_bd_pins axi_ad9625_1_core/rx_data]
connect_bd_net -net axi_ad9625_0_core_adc_valid       [get_bd_pins axi_ad9625_0_core/adc_valid]       [get_bd_ports adc_valid_0]
connect_bd_net -net axi_ad9625_0_core_adc_enable      [get_bd_pins axi_ad9625_0_core/adc_enable]      [get_bd_ports adc_enable_0]
connect_bd_net -net axi_ad9625_0_core_adc_data        [get_bd_pins axi_ad9625_0_core/adc_data]        [get_bd_ports adc_data_0]
connect_bd_net -net axi_ad9625_1_core_adc_valid       [get_bd_pins axi_ad9625_1_core/adc_valid]       [get_bd_ports adc_valid_1]
connect_bd_net -net axi_ad9625_1_core_adc_enable      [get_bd_pins axi_ad9625_1_core/adc_enable]      [get_bd_ports adc_enable_1]
connect_bd_net -net axi_ad9625_1_core_adc_data        [get_bd_pins axi_ad9625_1_core/adc_data]        [get_bd_ports adc_data_1]
connect_bd_net -net axi_ad9625_0_gt_rx_rst            [get_bd_pins axi_ad9625_fifo/adc_rst]           [get_bd_pins axi_ad9625_0_gt/rx_rst]
connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins axi_ad9625_fifo/adc_clk]           [get_bd_pins axi_ad9625_0_gt/rx_clk_g]
connect_bd_net -net axi_ad9625_adc_wr                 [get_bd_ports adc_wr]                           [get_bd_pins axi_ad9625_fifo/adc_wr]
connect_bd_net -net axi_ad9625_adc_wdata              [get_bd_ports adc_wdata]                        [get_bd_pins axi_ad9625_fifo/adc_wdata]
connect_bd_net -net axi_ad9625_adc_wovf               [get_bd_pins axi_ad9625_0_core/adc_dovf]        [get_bd_pins axi_ad9625_fifo/adc_wovf]
connect_bd_net -net sys_100m_clk                      [get_bd_pins axi_ad9625_fifo/dma_clk]           [get_bd_pins axi_ad9625_dma/s_axis_aclk]
connect_bd_net -net axi_ad9625_dma_dvalid             [get_bd_pins axi_ad9625_fifo/dma_wr]            [get_bd_pins axi_ad9625_dma/s_axis_valid]
connect_bd_net -net axi_ad9625_dma_dready             [get_bd_pins axi_ad9625_fifo/dma_wready]        [get_bd_pins axi_ad9625_dma/s_axis_ready]
connect_bd_net -net axi_ad9625_dma_ddata              [get_bd_pins axi_ad9625_fifo/dma_wdata]         [get_bd_pins axi_ad9625_dma/s_axis_data]
connect_bd_net -net axi_ad9625_dma_xfer_req           [get_bd_pins axi_ad9625_fifo/dma_xfer_req]      [get_bd_pins axi_ad9625_dma/s_axis_xfer_req]
connect_bd_net -net axi_ad9625_dma_intr               [get_bd_pins axi_ad9625_dma/irq]                [get_bd_ports ad9625_dma_intr]

# interconnect (cpu)

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9625_dma/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9625_0_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9625_0_jesd/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9625_0_gt/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins axi_ad9625_spi/axi_lite]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_ad9625_gpio/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m13_axi [get_bd_intf_pins axi_cpu_interconnect/M13_AXI] [get_bd_intf_pins axi_ad9625_1_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m14_axi [get_bd_intf_pins axi_cpu_interconnect/M14_AXI] [get_bd_intf_pins axi_ad9625_1_jesd/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m15_axi [get_bd_intf_pins axi_cpu_interconnect/M15_AXI] [get_bd_intf_pins axi_ad9625_1_gt/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m16_axi [get_bd_intf_pins axi_cpu_interconnect/M16_AXI] [get_bd_intf_pins axi_dac_spi/axi_lite]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M13_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M14_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M15_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M16_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_0_gt/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_0_core/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_0_jesd/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_dma/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_spi/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_spi/ext_spi_clk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_gpio/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_1_gt/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_1_core/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_1_jesd/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_dac_spi/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_dac_spi/ext_spi_clk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M13_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M14_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M15_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M16_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_0_gt/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_0_core/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_0_jesd/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_dma/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_spi/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_gpio/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_1_gt/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_1_core/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_1_jesd/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_dac_spi/s_axi_aresetn]

# interconnect (gt es)

connect_bd_intf_net -intf_net axi_mem_interconnect_s08_axi [get_bd_intf_pins axi_mem_interconnect/S08_AXI] [get_bd_intf_pins axi_ad9625_0_gt/m_axi]
connect_bd_intf_net -intf_net axi_mem_interconnect_s09_axi [get_bd_intf_pins axi_mem_interconnect/S09_AXI] [get_bd_intf_pins axi_ad9625_dma/m_dest_axi]
connect_bd_intf_net -intf_net axi_mem_interconnect_s10_axi [get_bd_intf_pins axi_mem_interconnect/S10_AXI] [get_bd_intf_pins axi_ad9625_1_gt/m_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/S09_ACLK] $sys_200m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S10_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_0_gt/m_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_0_gt/drp_clk]
connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9625_dma/m_dest_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_1_gt/m_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9625_1_gt/drp_clk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_200m_resetn [get_bd_pins axi_mem_interconnect/S09_ARESETN] $sys_200m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S10_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_0_gt/m_axi_aresetn]
connect_bd_net -net sys_200m_resetn [get_bd_pins axi_ad9625_dma/m_dest_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9625_1_gt/m_axi_aresetn]

# ila

set ila_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_rx_mon]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_rx_mon
set_property -dict [list CONFIG.C_NUM_OF_PROBES {5}] $ila_rx_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {512}] $ila_rx_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {256}] $ila_rx_mon
set_property -dict [list CONFIG.C_PROBE2_WIDTH {256}] $ila_rx_mon
set_property -dict [list CONFIG.C_PROBE3_WIDTH {16}] $ila_rx_mon
set_property -dict [list CONFIG.C_PROBE4_WIDTH {16}] $ila_rx_mon

connect_bd_net -net axi_ad9625_0_gt_rx_clk            [get_bd_pins ila_rx_mon/CLK]
connect_bd_net -net axi_ad9625_adc_wdata              [get_bd_pins ila_rx_mon/probe0]
connect_bd_net -net axi_ad9625_0_gt_rx_data           [get_bd_pins ila_rx_mon/probe1]
connect_bd_net -net axi_ad9625_1_gt_rx_data           [get_bd_pins ila_rx_mon/probe2]
connect_bd_net -net axi_ad9625_0_core_adc_sref        [get_bd_pins axi_ad9625_0_core/adc_sref]  [get_bd_pins ila_rx_mon/probe3]
connect_bd_net -net axi_ad9625_1_core_adc_sref        [get_bd_pins axi_ad9625_1_core/adc_sref]  [get_bd_pins ila_rx_mon/probe4]

# address map

create_bd_addr_seg -range 0x00010000 -offset 0x44a10000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_0_core/s_axi/axi_lite]   SEG_data_ad9625_0_core
create_bd_addr_seg -range 0x00010000 -offset 0x44a60000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_0_gt/s_axi/axi_lite]     SEG_data_ad9625_0_gt
create_bd_addr_seg -range 0x00001000 -offset 0x44a91000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_0_jesd/s_axi/Reg]        SEG_data_ad9625_0_jesd
create_bd_addr_seg -range 0x00010000 -offset 0x44b10000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_1_core/s_axi/axi_lite]   SEG_data_ad9625_1_core
create_bd_addr_seg -range 0x00010000 -offset 0x44b60000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_1_gt/s_axi/axi_lite]     SEG_data_ad9625_1_gt
create_bd_addr_seg -range 0x00001000 -offset 0x44b91000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_1_jesd/s_axi/Reg]        SEG_data_ad9625_1_jesd
create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_dma/s_axi/axi_lite]      SEG_data_ad9625_dma
create_bd_addr_seg -range 0x00010000 -offset 0x44a70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_spi/axi_lite/Reg]        SEG_data_ad9625_spi
create_bd_addr_seg -range 0x00010000 -offset 0x40030000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9625_gpio/s_axi/Reg]          SEG_data_ad9625_gpio
create_bd_addr_seg -range 0x00010000 -offset 0x44a80000 $sys_addr_cntrl_space [get_bd_addr_segs axi_dac_spi/axi_lite/Reg]           SEG_data_dac_spi


create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9625_dma/m_dest_axi]  [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9625_0_gt/m_axi]      [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9625_1_gt/m_axi]      [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]    SEG_axi_ddr_cntrl

