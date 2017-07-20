
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

create_bd_port -dir I -from 16 -to 0 gpio_i
create_bd_port -dir O -from 16 -to 0 gpio_o
create_bd_port -dir O -from 16 -to 0 gpio_t

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
set_property -dict [list CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_PACKAGE_NAME {clg225}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {17}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART1_UART1_IO {MIO 12 .. 13}] $sys_ps7
set_property -dict [list CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_RESET_IO {MIO 52}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_RESET_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_MODE {REVERSE}] $sys_ps7

# DDR MT41K256M16 HA-125 (32M, 16bit, 8banks)

set_property -dict [list CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.048}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.050}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.241}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.240}] $sys_ps7

set axi_iic_main [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_main]

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
ad_connect  gpio_i sys_ps7/GPIO_I
ad_connect  gpio_o sys_ps7/GPIO_O
ad_connect  gpio_t sys_ps7/GPIO_T
ad_connect  fixed_io sys_ps7/FIXED_IO
ad_connect  iic_main axi_iic_main/iic

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

source ../common/m2k_bd.tcl

set_property -dict [list CONFIG.DAC_DATAPATH_DISABLE {1}] $axi_ad9963
set_property -dict [list CONFIG.ADC_DATAPATH_DISABLE {1}] $axi_ad9963
