
# create board design
# default ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io

create_bd_port -dir O spi0_csn_2_o
create_bd_port -dir O spi0_csn_1_o
create_bd_port -dir O spi0_csn_0_o
create_bd_port -dir I spi0_csn_i
create_bd_port -dir I spi0_clk_i
create_bd_port -dir O spi0_clk_o
create_bd_port -dir I spi0_sdo_i
create_bd_port -dir O spi0_sdo_o
create_bd_port -dir I spi0_sdi_i

create_bd_port -dir O spi1_csn_2_o
create_bd_port -dir O spi1_csn_1_o
create_bd_port -dir O spi1_csn_0_o
create_bd_port -dir I spi1_csn_i
create_bd_port -dir I spi1_clk_i
create_bd_port -dir O spi1_clk_o
create_bd_port -dir I spi1_sdo_i
create_bd_port -dir O spi1_sdo_o
create_bd_port -dir I spi1_sdi_i

create_bd_port -dir I -from 63 -to 0 gpio_i
create_bd_port -dir O -from 63 -to 0 gpio_o
create_bd_port -dir O -from 63 -to 0 gpio_t

# otg

set otg_vbusoc      [create_bd_port -dir I otg_vbusoc]

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
create_bd_port -dir I -type intr ps_intr_15

# instance: sys_ps7

set sys_ps7  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 sys_ps7]
set_property -dict [list CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V}] $sys_ps7
set_property -dict [list CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}] $sys_ps7
set_property -dict [list CONFIG.PCW_PACKAGE_NAME {fbg676}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET_RESET_SELECT {Separate reset pins}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_RESET_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET0_RESET_IO {MIO 8}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET1_RESET_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_ENET1_RESET_IO {MIO 51}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_GRP_CD_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_GRP_CD_IO {MIO 50}] $sys_ps7
set_property -dict [list CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_RESET_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_RESET_IO {MIO 7}] $sys_ps7
set_property -dict [list CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.110}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.095}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.249}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.249}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.202}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.217}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.216}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.217}] $sys_ps7
set_property -dict [list CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {64}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_MODE {REVERSE}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_SPI1_IO {EMIO}] $sys_ps7

set axi_iic_main [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_main]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true}] $axi_iic_main
set_property -dict [list CONFIG.IIC_BOARD_INTERFACE {Custom}] $axi_iic_main

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {16}] $sys_concat_intc

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_rstgen

set sys_logic_inv [create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 sys_logic_inv]
set_property -dict [list CONFIG.C_SIZE {1}] $sys_logic_inv
set_property -dict [list CONFIG.C_OPERATION {not}] $sys_logic_inv

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect  sys_200m_clk sys_ps7/FCLK_CLK1
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# interface connections

ad_connect  ddr sys_ps7/DDR
ad_connect  gpio_i sys_ps7/GPIO_I
ad_connect  gpio_o sys_ps7/GPIO_O
ad_connect  gpio_t sys_ps7/GPIO_T
ad_connect  fixed_io sys_ps7/FIXED_IO
ad_connect  iic_main axi_iic_main/iic
ad_connect  sys_logic_inv/Res sys_ps7/USB0_VBUS_PWRFAULT
ad_connect  sys_logic_inv/Op1 otg_vbusoc

# spi connections

ad_connect  spi0_csn_2_o sys_ps7/SPI0_SS2_O
ad_connect  spi0_csn_1_o sys_ps7/SPI0_SS1_O
ad_connect  spi0_csn_0_o sys_ps7/SPI0_SS_O
ad_connect  spi0_csn_i sys_ps7/SPI0_SS_I
ad_connect  spi0_clk_i sys_ps7/SPI0_SCLK_I
ad_connect  spi0_clk_o sys_ps7/SPI0_SCLK_O
ad_connect  spi0_sdo_i sys_ps7/SPI0_MOSI_I
ad_connect  spi0_sdo_o sys_ps7/SPI0_MOSI_O
ad_connect  spi0_sdi_i sys_ps7/SPI0_MISO_I

ad_connect  spi1_csn_2_o sys_ps7/SPI1_SS2_O
ad_connect  spi1_csn_1_o sys_ps7/SPI1_SS1_O
ad_connect  spi1_csn_0_o sys_ps7/SPI1_SS_O
ad_connect  spi1_csn_i sys_ps7/SPI1_SS_I
ad_connect  spi1_clk_i sys_ps7/SPI1_SCLK_I
ad_connect  spi1_clk_o sys_ps7/SPI1_SCLK_O
ad_connect  spi1_sdo_i sys_ps7/SPI1_MOSI_I
ad_connect  spi1_sdo_o sys_ps7/SPI1_MOSI_O
ad_connect  spi1_sdi_i sys_ps7/SPI1_MISO_I

# interrupts

ad_connect  sys_concat_intc/dout sys_ps7/IRQ_F2P
ad_connect  sys_concat_intc/In15 ps_intr_15
ad_connect  sys_concat_intc/In14 axi_iic_main/iic2intc_irpt
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

# interconnects

ad_cpu_interconnect 0x41600000 axi_iic_main

# ad9361

create_bd_port -dir O enable
create_bd_port -dir O txnrx
create_bd_port -dir I up_enable
create_bd_port -dir I up_txnrx
create_bd_port -dir O tdd_sync_o
create_bd_port -dir I tdd_sync_i
create_bd_port -dir O tdd_sync_t

# ad9361 core

set axi_ad9361 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361]
set_property -dict [list CONFIG.ID {0}] $axi_ad9361
set_property -dict [list CONFIG.DAC_IODELAY_ENABLE {0}] $axi_ad9361

set axi_ad9361_dac_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.CYCLIC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad9361_dac_dma

set util_ad9361_dac_upack [create_bd_cell -type ip -vlnv analog.com:user:util_upack:1.0 util_ad9361_dac_upack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9361_dac_upack
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_ad9361_dac_upack

set axi_ad9361_adc_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}]  $axi_ad9361_adc_dma

set util_ad9361_adc_pack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_ad9361_adc_pack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9361_adc_pack
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_ad9361_adc_pack

set util_ad9361_adc_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 util_ad9361_adc_fifo]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9361_adc_fifo
set_property -dict [list CONFIG.DIN_ADDRESS_WIDTH {4}] $util_ad9361_adc_fifo
set_property -dict [list CONFIG.DIN_DATA_WIDTH {16}] $util_ad9361_adc_fifo
set_property -dict [list CONFIG.DOUT_DATA_WIDTH {16}] $util_ad9361_adc_fifo

set util_ad9361_tdd_sync [create_bd_cell -type ip -vlnv analog.com:user:util_tdd_sync:1.0 util_ad9361_tdd_sync]
set_property -dict [list CONFIG.TDD_SYNC_PERIOD {10000000}] $util_ad9361_tdd_sync

set clkdiv [ create_bd_cell -type ip -vlnv analog.com:user:util_clkdiv:1.0 clkdiv ]

set clkdiv_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 clkdiv_reset]

set dac_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_rfifo:1.0 dac_fifo]
set_property -dict [list CONFIG.DIN_DATA_WIDTH {16}] $dac_fifo
set_property -dict [list CONFIG.DOUT_DATA_WIDTH {16}] $dac_fifo
set_property -dict [list CONFIG.DIN_ADDRESS_WIDTH {4}] $dac_fifo

set clkdiv_sel_logic [create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 clkdiv_sel_logic]
set_property -dict [list CONFIG.C_SIZE {2}] $clkdiv_sel_logic

set concat_logic [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_logic]
set_property -dict [list CONFIG.NUM_PORTS {2}] $concat_logic

# connections

ad_connect  sys_200m_clk axi_ad9361/delay_clk
ad_connect  axi_ad9361_clk axi_ad9361/l_clk
ad_connect  axi_ad9361_clk axi_ad9361/clk
ad_connect  enable axi_ad9361/enable
ad_connect  txnrx axi_ad9361/txnrx
ad_connect  up_enable axi_ad9361/up_enable
ad_connect  up_txnrx axi_ad9361/up_txnrx
ad_connect  axi_ad9361_clk util_ad9361_adc_fifo/din_clk
ad_connect  axi_ad9361/rst util_ad9361_adc_fifo/din_rst
ad_connect  axi_ad9361_clk clkdiv/clk
ad_connect  clkdiv/clk_out axi_ad9361_adc_dma/fifo_wr_clk
ad_connect  clkdiv/clk_out util_ad9361_adc_fifo/dout_clk
ad_connect  clkdiv/clk_out util_ad9361_adc_pack/adc_clk
ad_connect  clkdiv_reset/ext_reset_in sys_rstgen/peripheral_aresetn
ad_connect  clkdiv_reset/slowest_sync_clk clkdiv/clk_out
ad_connect  util_ad9361_adc_pack/adc_rst clkdiv_reset/peripheral_reset
ad_connect  util_ad9361_adc_fifo/dout_rstn clkdiv_reset/peripheral_aresetn
ad_connect  axi_ad9361/adc_enable_i0 util_ad9361_adc_fifo/din_enable_0
ad_connect  axi_ad9361/adc_valid_i0 util_ad9361_adc_fifo/din_valid_0
ad_connect  axi_ad9361/adc_data_i0 util_ad9361_adc_fifo/din_data_0
ad_connect  axi_ad9361/adc_enable_q0 util_ad9361_adc_fifo/din_enable_1
ad_connect  axi_ad9361/adc_valid_q0 util_ad9361_adc_fifo/din_valid_1
ad_connect  axi_ad9361/adc_data_q0 util_ad9361_adc_fifo/din_data_1
ad_connect  axi_ad9361/adc_enable_i1 util_ad9361_adc_fifo/din_enable_2
ad_connect  axi_ad9361/adc_valid_i1 util_ad9361_adc_fifo/din_valid_2
ad_connect  axi_ad9361/adc_data_i1 util_ad9361_adc_fifo/din_data_2
ad_connect  axi_ad9361/adc_enable_q1 util_ad9361_adc_fifo/din_enable_3
ad_connect  axi_ad9361/adc_valid_q1 util_ad9361_adc_fifo/din_valid_3
ad_connect  axi_ad9361/adc_data_q1 util_ad9361_adc_fifo/din_data_3
ad_connect  util_ad9361_adc_fifo/dout_enable_0 util_ad9361_adc_pack/adc_enable_0
ad_connect  util_ad9361_adc_fifo/dout_valid_0 util_ad9361_adc_pack/adc_valid_0
ad_connect  util_ad9361_adc_fifo/dout_data_0 util_ad9361_adc_pack/adc_data_0
ad_connect  util_ad9361_adc_fifo/dout_enable_1 util_ad9361_adc_pack/adc_enable_1
ad_connect  util_ad9361_adc_fifo/dout_valid_1 util_ad9361_adc_pack/adc_valid_1
ad_connect  util_ad9361_adc_fifo/dout_data_1 util_ad9361_adc_pack/adc_data_1
ad_connect  util_ad9361_adc_fifo/dout_enable_2 util_ad9361_adc_pack/adc_enable_2
ad_connect  util_ad9361_adc_fifo/dout_valid_2 util_ad9361_adc_pack/adc_valid_2
ad_connect  util_ad9361_adc_fifo/dout_data_2 util_ad9361_adc_pack/adc_data_2
ad_connect  util_ad9361_adc_fifo/dout_enable_3 util_ad9361_adc_pack/adc_enable_3
ad_connect  util_ad9361_adc_fifo/dout_valid_3 util_ad9361_adc_pack/adc_valid_3
ad_connect  util_ad9361_adc_fifo/dout_data_3 util_ad9361_adc_pack/adc_data_3
ad_connect  util_ad9361_adc_pack/adc_valid axi_ad9361_adc_dma/fifo_wr_en
ad_connect  util_ad9361_adc_pack/adc_sync axi_ad9361_adc_dma/fifo_wr_sync
ad_connect  util_ad9361_adc_pack/adc_data axi_ad9361_adc_dma/fifo_wr_din
ad_connect  axi_ad9361_adc_dma/fifo_wr_overflow util_ad9361_adc_fifo/dout_ovf
ad_connect  util_ad9361_adc_fifo/din_ovf axi_ad9361/adc_dovf
ad_connect  axi_ad9361/adc_r1_mode concat_logic/In0
ad_connect  axi_ad9361/dac_r1_mode concat_logic/In1
ad_connect  concat_logic/dout clkdiv_sel_logic/Op1
ad_connect  clkdiv/clk_sel clkdiv_sel_logic/Res
ad_connect  util_ad9361_dac_upack/dac_valid axi_ad9361_dac_dma/fifo_rd_en
ad_connect  util_ad9361_dac_upack/dac_data axi_ad9361_dac_dma/fifo_rd_dout
ad_connect  clkdiv/clk_out axi_ad9361_dac_dma/fifo_rd_clk
ad_connect  axi_ad9361/dac_dunf dac_fifo/dout_unf
ad_connect  dac_fifo/din_clk clkdiv/clk_out
ad_connect  dac_fifo/din_rstn clkdiv_reset/peripheral_aresetn
ad_connect  axi_ad9361_clk dac_fifo/dout_clk
ad_connect  dac_fifo/dout_rst axi_ad9361/rst
ad_connect  util_ad9361_dac_upack/dac_clk clkdiv/clk_out
ad_connect  dac_fifo/din_enable_0 util_ad9361_dac_upack/dac_enable_0
ad_connect  dac_fifo/din_valid_0 util_ad9361_dac_upack/dac_valid_0
ad_connect  dac_fifo/din_data_0 util_ad9361_dac_upack/dac_data_0
ad_connect  dac_fifo/din_enable_1 util_ad9361_dac_upack/dac_enable_1
ad_connect  dac_fifo/din_valid_1 util_ad9361_dac_upack/dac_valid_1
ad_connect  dac_fifo/din_data_1 util_ad9361_dac_upack/dac_data_1
ad_connect  dac_fifo/din_enable_2 util_ad9361_dac_upack/dac_enable_2
ad_connect  dac_fifo/din_valid_2 util_ad9361_dac_upack/dac_valid_2
ad_connect  dac_fifo/din_data_2 util_ad9361_dac_upack/dac_data_2
ad_connect  dac_fifo/din_enable_3 util_ad9361_dac_upack/dac_enable_3
ad_connect  dac_fifo/din_valid_3 util_ad9361_dac_upack/dac_valid_3
ad_connect  dac_fifo/din_data_3 util_ad9361_dac_upack/dac_data_3
ad_connect  axi_ad9361/dac_enable_i0 dac_fifo/dout_enable_0
ad_connect  axi_ad9361/dac_valid_i0 dac_fifo/dout_valid_0
ad_connect  axi_ad9361/dac_data_i0 dac_fifo/dout_data_0
ad_connect  axi_ad9361/dac_enable_q0 dac_fifo/dout_enable_1
ad_connect  axi_ad9361/dac_valid_q0 dac_fifo/dout_valid_1
ad_connect  axi_ad9361/dac_data_q0 dac_fifo/dout_data_1
ad_connect  axi_ad9361/dac_enable_i1 dac_fifo/dout_enable_2
ad_connect  axi_ad9361/dac_valid_i1 dac_fifo/dout_valid_2
ad_connect  axi_ad9361/dac_data_i1 dac_fifo/dout_data_2
ad_connect  axi_ad9361/dac_enable_q1 dac_fifo/dout_enable_3
ad_connect  axi_ad9361/dac_valid_q1 dac_fifo/dout_valid_3
ad_connect  axi_ad9361/dac_data_q1 dac_fifo/dout_data_3
ad_connect  sys_cpu_clk util_ad9361_tdd_sync/clk
ad_connect  sys_cpu_resetn util_ad9361_tdd_sync/rstn
ad_connect  util_ad9361_tdd_sync/sync_out axi_ad9361/tdd_sync
ad_connect  util_ad9361_tdd_sync/sync_mode axi_ad9361/tdd_sync_cntr
ad_connect  tdd_sync_t axi_ad9361/tdd_sync_cntr
ad_connect  tdd_sync_o util_ad9361_tdd_sync/sync_out
ad_connect  tdd_sync_i util_ad9361_tdd_sync/sync_in

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

## customization of core to disable data path logic (less resources)
## interface type - 1R1T (1) or 2R2T (0) (default is 2R2T)
## 2R2T supports 1R1T as a run time option.
## 1R1T allows core to run at a lower rate (1/2 of 2R2T)

set_property CONFIG.MODE_1R1T 1 [get_bd_cells axi_ad9361]

## interface type - CMOS (1) or LVDS (0) (default is LVDS)
## CMOS allows core to run at a lower rate (1/2 of LVDS)

set_property CONFIG.CMOS_OR_LVDS_N 0  [get_bd_cells axi_ad9361]

## data-path disable (global control)- allows removal of DSP functions within the core.
## also removes the corresponding AXI control interface registers

set_property CONFIG.ADC_DATAPATH_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.DAC_DATAPATH_DISABLE 0  [get_bd_cells axi_ad9361]

## data-path disable (individual control)- effective ONLY if DATAPATH_DISABLE is 0x0.

set_property CONFIG.ADC_DATAFORMAT_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.ADC_DCFILTER_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.ADC_IQCORRECTION_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.ADC_USERPORTS_DISABLE 0 [get_bd_cells axi_ad9361]

set_property CONFIG.DAC_DDS_DISABLE 0 [get_bd_cells axi_ad9361]
set_property CONFIG.DAC_IQCORRECTION_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.DAC_USERPORTS_DISABLE 0 [get_bd_cells axi_ad9361]

## tdd-disable (control is moved exclusively to GPIO)

set_property CONFIG.TDD_DISABLE 0 [get_bd_cells axi_ad9361]

## lvds/cmos configuration
## core digital interface -- cmos (1) or lvds (0)

proc cfg_ad9361_interface {cmos_or_lvds} {

  if {$cmos_or_lvds eq "LVDS"} {

    set_property CONFIG.CMOS_OR_LVDS_N 0 [get_bd_cells axi_ad9361]

    create_bd_port -dir I rx_clk_in_p
    create_bd_port -dir I rx_clk_in_n
    create_bd_port -dir I rx_frame_in_p
    create_bd_port -dir I rx_frame_in_n
    create_bd_port -dir I -from 5 -to 0 rx_data_in_p
    create_bd_port -dir I -from 5 -to 0 rx_data_in_n

    create_bd_port -dir O tx_clk_out_p
    create_bd_port -dir O tx_clk_out_n
    create_bd_port -dir O tx_frame_out_p
    create_bd_port -dir O tx_frame_out_n
    create_bd_port -dir O -from 5 -to 0 tx_data_out_p
    create_bd_port -dir O -from 5 -to 0 tx_data_out_n

    ad_connect  rx_clk_in_p axi_ad9361/rx_clk_in_p
    ad_connect  rx_clk_in_n axi_ad9361/rx_clk_in_n
    ad_connect  rx_frame_in_p axi_ad9361/rx_frame_in_p
    ad_connect  rx_frame_in_n axi_ad9361/rx_frame_in_n
    ad_connect  rx_data_in_p axi_ad9361/rx_data_in_p
    ad_connect  rx_data_in_n axi_ad9361/rx_data_in_n
    ad_connect  tx_clk_out_p axi_ad9361/tx_clk_out_p
    ad_connect  tx_clk_out_n axi_ad9361/tx_clk_out_n
    ad_connect  tx_frame_out_p axi_ad9361/tx_frame_out_p
    ad_connect  tx_frame_out_n axi_ad9361/tx_frame_out_n
    ad_connect  tx_data_out_p axi_ad9361/tx_data_out_p
    ad_connect  tx_data_out_n axi_ad9361/tx_data_out_n

    return
  }

  if {$cmos_or_lvds eq "CMOS"} {

    set_property CONFIG.CMOS_OR_LVDS_N 1 [get_bd_cells axi_ad9361]

    create_bd_port -dir I rx_clk_in
    create_bd_port -dir I rx_frame_in
    create_bd_port -dir I -from 11 -to 0 rx_data_in
    create_bd_port -dir O tx_clk_out
    create_bd_port -dir O tx_frame_out
    create_bd_port -dir O -from 11 -to 0 tx_data_out

    ad_connect  rx_clk_in axi_ad9361/rx_clk_in
    ad_connect  rx_frame_in axi_ad9361/rx_frame_in
    ad_connect  rx_data_in axi_ad9361/rx_data_in
    ad_connect  tx_clk_out axi_ad9361/tx_clk_out
    ad_connect  tx_frame_out axi_ad9361/tx_frame_out
    ad_connect  tx_data_out axi_ad9361/tx_data_out

    return
  }

}


