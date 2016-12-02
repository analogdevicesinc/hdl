# create board design
# default ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io

create_bd_port -dir O spi0_csn_0
create_bd_port -dir O spi0_csn_1
create_bd_port -dir O spi0_csn_2
create_bd_port -dir O spi0_clk
create_bd_port -dir O spi0_mosi
create_bd_port -dir I spi0_miso

create_bd_port -dir I spi1_csn
create_bd_port -dir I spi1_clk
create_bd_port -dir I spi1_mosi
create_bd_port -dir O spi1_miso

create_bd_port -dir I -from 63 -to 0 ps_gpio_i
create_bd_port -dir O -from 63 -to 0 ps_gpio_o
create_bd_port -dir O -from 63 -to 0 ps_gpio_t

# interrupts

create_bd_port -dir I -type intr ps_intr_00
create_bd_port -dir I -type intr ps_intr_01
create_bd_port -dir I -type intr ps_intr_02
create_bd_port -dir I -type intr ps_intr_03
create_bd_port -dir I -type intr ps_intr_04
create_bd_port -dir I -type intr ps_intr_05
create_bd_port -dir I -type intr ps_intr_06
create_bd_port -dir I -type intr ps_intr_07
create_bd_port -dir I -type intr ps_intr_08
create_bd_port -dir I -type intr ps_intr_09
create_bd_port -dir I -type intr ps_intr_10
create_bd_port -dir I -type intr ps_intr_11
create_bd_port -dir I -type intr ps_intr_12
create_bd_port -dir I -type intr ps_intr_13
create_bd_port -dir I -type intr ps_intr_14
create_bd_port -dir I -type intr ps_intr_15

# instance: sys_ps7

set sys_ps7  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 sys_ps7]

# ps7 settings

set_property -dict [list CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V}] $sys_ps7
set_property -dict [list CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_RESET_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_RESET_IO {MIO 11}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_RESET_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_RESET_IO {MIO 9}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_GRP_CD_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_GRP_CD_IO {MIO 0}] $sys_ps7
set_property -dict [list CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_SPI1_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49}] $sys_ps7
set_property -dict [list CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_I2C0_I2C0_IO {MIO 46 .. 47}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_MODE {REVERSE}] $sys_ps7

# DDR MT41K256M16 HA-125 (32M, 16bit, 8banks)

set_property -dict [list CONFIG.PCW_UIPARAM_DDR_PARTNO {Custom}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_CWL {6}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_T_RC {48.75}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1}] $sys_ps7

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {16}] $sys_concat_intc

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_rstgen

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect  sys_200m_clk sys_ps7/FCLK_CLK1
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# interface connections

ad_connect  ddr sys_ps7/DDR
ad_connect  ps_gpio_i sys_ps7/GPIO_I
ad_connect  ps_gpio_o sys_ps7/GPIO_O
ad_connect  ps_gpio_t sys_ps7/GPIO_T
ad_connect  fixed_io sys_ps7/FIXED_IO

# spi connections

ad_connect  sys_ps7/SPI0_SS_O spi0_csn_0
ad_connect  sys_ps7/SPI0_SS1_O spi0_csn_1
ad_connect  sys_ps7/SPI0_SS2_O spi0_csn_2
ad_connect  sys_ps7/SPI0_SCLK_O spi0_clk
ad_connect  sys_ps7/SPI0_MOSI_O spi0_mosi
ad_connect  sys_ps7/SPI0_MISO_I spi0_miso 
ad_connect  sys_ps7/SPI0_SS_I VCC
ad_connect  sys_ps7/SPI0_SCLK_I GND
ad_connect  sys_ps7/SPI0_MOSI_I GND

ad_connect  sys_ps7/SPI1_SS_I spi1_csn
ad_connect  sys_ps7/SPI1_SCLK_I spi1_clk
ad_connect  sys_ps7/SPI1_MOSI_I spi1_mosi
ad_connect  sys_ps7/SPI1_MISO_O spi1_miso
ad_connect  sys_ps7/SPI1_MISO_I GND 

# interrupts

ad_connect  sys_concat_intc/dout sys_ps7/IRQ_F2P
ad_connect  sys_concat_intc/In15 ps_intr_15
ad_connect  sys_concat_intc/In14 ps_intr_14
ad_connect  sys_concat_intc/In13 ps_intr_13
ad_connect  sys_concat_intc/In12 ps_intr_12
ad_connect  sys_concat_intc/In11 ps_intr_11
ad_connect  sys_concat_intc/In10 ps_intr_10
ad_connect  sys_concat_intc/In9 ps_intr_09
ad_connect  sys_concat_intc/In8 ps_intr_08
ad_connect  sys_concat_intc/In7 ps_intr_07
ad_connect  sys_concat_intc/In6 ps_intr_06
ad_connect  sys_concat_intc/In5 ps_intr_05
ad_connect  sys_concat_intc/In4 ps_intr_04
ad_connect  sys_concat_intc/In3 ps_intr_03
ad_connect  sys_concat_intc/In2 ps_intr_02
ad_connect  sys_concat_intc/In1 ps_intr_01
ad_connect  sys_concat_intc/In0 ps_intr_00

# ad9361

create_bd_port -dir I rx_clk_in
create_bd_port -dir I rx_frame_in
create_bd_port -dir I -from 11 -to 0 rx_data_in

create_bd_port -dir O tx_clk_out
create_bd_port -dir O tx_frame_out
create_bd_port -dir O -from 11 -to 0 tx_data_out

create_bd_port -dir O enable
create_bd_port -dir O txnrx
create_bd_port -dir I up_enable
create_bd_port -dir I up_txnrx

# ad9361 core(s)

set axi_ad9361 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361]
set_property -dict [list CONFIG.ID {0}] $axi_ad9361
set_property -dict [list CONFIG.CMOS_OR_LVDS_N {1}] $axi_ad9361

set axi_ad9361_dac_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.CYCLIC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {32}] $axi_ad9361_dac_dma

set util_ad9361_dac_upack [create_bd_cell -type ip -vlnv analog.com:user:util_upack:1.0 util_ad9361_dac_upack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_ad9361_dac_upack
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_ad9361_dac_upack

set axi_ad9361_adc_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {32}]  $axi_ad9361_adc_dma

set util_ad9361_adc_pack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_ad9361_adc_pack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_ad9361_adc_pack
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_ad9361_adc_pack

# connections

ad_connect  rx_clk_in axi_ad9361/rx_clk_in
ad_connect  rx_frame_in axi_ad9361/rx_frame_in
ad_connect  rx_data_in axi_ad9361/rx_data_in
ad_connect  tx_clk_out axi_ad9361/tx_clk_out
ad_connect  tx_frame_out axi_ad9361/tx_frame_out
ad_connect  tx_data_out axi_ad9361/tx_data_out
ad_connect  enable axi_ad9361/enable
ad_connect  txnrx axi_ad9361/txnrx
ad_connect  up_enable axi_ad9361/up_enable
ad_connect  up_txnrx axi_ad9361/up_txnrx

ad_connect  sys_200m_clk axi_ad9361/delay_clk
ad_connect  axi_ad9361/l_clk axi_ad9361/clk

ad_connect  axi_ad9361/l_clk util_ad9361_adc_pack/adc_clk
ad_connect  axi_ad9361/rst util_ad9361_adc_pack/adc_rst
ad_connect  axi_ad9361/adc_enable_i0 util_ad9361_adc_pack/adc_enable_0
ad_connect  axi_ad9361/adc_valid_i0 util_ad9361_adc_pack/adc_valid_0
ad_connect  axi_ad9361/adc_data_i0 util_ad9361_adc_pack/adc_data_0
ad_connect  axi_ad9361/adc_enable_q0 util_ad9361_adc_pack/adc_enable_1
ad_connect  axi_ad9361/adc_valid_q0 util_ad9361_adc_pack/adc_valid_1
ad_connect  axi_ad9361/adc_data_q0 util_ad9361_adc_pack/adc_data_1
ad_connect  axi_ad9361/l_clk axi_ad9361_adc_dma/fifo_wr_clk
ad_connect  util_ad9361_adc_pack/adc_valid axi_ad9361_adc_dma/fifo_wr_en
ad_connect  util_ad9361_adc_pack/adc_sync axi_ad9361_adc_dma/fifo_wr_sync
ad_connect  util_ad9361_adc_pack/adc_data axi_ad9361_adc_dma/fifo_wr_din
ad_connect  axi_ad9361_adc_dma/fifo_wr_overflow axi_ad9361/adc_dovf
ad_connect  axi_ad9361/l_clk util_ad9361_dac_upack/dac_clk
ad_connect  axi_ad9361/dac_enable_i0 util_ad9361_dac_upack/dac_enable_0
ad_connect  axi_ad9361/dac_valid_i0 util_ad9361_dac_upack/dac_valid_0
ad_connect  util_ad9361_dac_upack/dac_data_0 axi_ad9361/dac_data_i0
ad_connect  axi_ad9361/dac_enable_q0 util_ad9361_dac_upack/dac_enable_1
ad_connect  axi_ad9361/dac_valid_q0 util_ad9361_dac_upack/dac_valid_1
ad_connect  util_ad9361_dac_upack/dac_data_1 axi_ad9361/dac_data_q0
ad_connect  axi_ad9361/l_clk axi_ad9361_dac_dma/fifo_rd_clk
ad_connect  util_ad9361_dac_upack/dac_valid axi_ad9361_dac_dma/fifo_rd_en
ad_connect  axi_ad9361_dac_dma/fifo_rd_dout util_ad9361_dac_upack/dac_data
ad_connect  axi_ad9361_dac_dma/fifo_rd_underflow axi_ad9361/dac_dunf
ad_connect  axi_ad9361/dac_data_i1 GND
ad_connect  axi_ad9361/dac_data_q1 GND

# interconnects

ad_cpu_interconnect 0x79020000 axi_ad9361
ad_cpu_interconnect 0x7C400000 axi_ad9361_adc_dma
ad_cpu_interconnect 0x7C420000 axi_ad9361_dac_dma
ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9361_adc_dma/m_dest_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9361_dac_dma/m_src_axi
ad_connect  sys_cpu_resetn axi_ad9361_adc_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9361_dac_dma/m_src_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9361_adc_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9361_dac_dma/irq

# tdd-sync

set util_ad9361_tdd_sync [create_bd_cell -type ip -vlnv analog.com:user:util_tdd_sync:1.0 util_ad9361_tdd_sync]
set_property -dict [list CONFIG.TDD_SYNC_PERIOD {10000000}] $util_ad9361_tdd_sync

create_bd_port -dir I tdd_sync

ad_connect  tdd_sync util_ad9361_tdd_sync/sync_in
ad_connect  sys_cpu_clk util_ad9361_tdd_sync/clk
ad_connect  sys_cpu_resetn util_ad9361_tdd_sync/rstn
ad_connect  util_ad9361_tdd_sync/sync_out axi_ad9361/tdd_sync
ad_connect  util_ad9361_tdd_sync/sync_mode axi_ad9361/tdd_sync_cntr

# gpio

create_bd_port -dir I -from 31 -to 0 pl_gpio_i
create_bd_port -dir O -from 31 -to 0 pl_gpio_o
create_bd_port -dir O -from 31 -to 0 pl_gpio_t

set axi_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio]
set_property -dict [list CONFIG.C_GPIO_WIDTH {32}] $axi_gpio
set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_gpio

ad_connect  pl_gpio_i axi_gpio/gpio_io_i
ad_connect  pl_gpio_o axi_gpio/gpio_io_o
ad_connect  pl_gpio_t axi_gpio/gpio_io_t

ad_cpu_interconnect 0x41600000 axi_gpio
ad_cpu_interrupt ps-15 mb-15 axi_gpio/ip2intc_irpt

