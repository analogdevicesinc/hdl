
set_msg_config -id {PSU-1} -new_severity {WARNING}

set DEBUG_BUILD 0

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

# instance: sys_ps7

ad_ip_instance processing_system7 sys_ps7

ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V}
ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_PACKAGE_NAME {clg225}
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP2 {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO {17}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_UART1_IO {MIO 12 .. 13}
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_SPI0_IO {EMIO}
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_FABRIC_INTERRUPT {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_IO {MIO 52}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_INTR {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_MODE {REVERSE}

# Clock the whole system of the DDR PLL, disable ARM and IO PLL
# * PLL: 1000 MHz
# * DDR: 500 MHz (2.0Gb/s),
# * CPU: 500 MHz (downclocked to 250 MHz when idle)
ad_ip_parameter sys_ps7 CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {500}
ad_ip_parameter sys_ps7 CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {500}
ad_ip_parameter sys_ps7 CONFIG.PCW_OVERRIDE_BASIC_CLOCK {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {20}
ad_ip_parameter sys_ps7 CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {16}
ad_ip_parameter sys_ps7 CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {6}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {40}
ad_ip_parameter sys_ps7 CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {40}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {6}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {6}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {5}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {2}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {6}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {3}
ad_ip_parameter sys_ps7 CONFIG.PCW_IOPLL_CTRL_FBDIV {30}
ad_ip_parameter sys_ps7 CONFIG.PCW_ARMPLL_CTRL_FBDIV {30}
ad_ip_parameter sys_ps7 CONFIG.PCW_DDRPLL_CTRL_FBDIV {30}

# DDR MT41K256M16 HA-125 (32M, 16bit, 8banks)

ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.048}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.050}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.241}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.240}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {500.0}

ad_ip_instance axi_iic axi_iic_main

ad_ip_instance xlconcat sys_concat_intc
ad_ip_parameter sys_concat_intc CONFIG.NUM_PORTS 16

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
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
ad_connect  sys_concat_intc/In15 GND
ad_connect  sys_concat_intc/In14 axi_iic_main/iic2intc_irpt
ad_connect  sys_concat_intc/In13 GND
ad_connect  sys_concat_intc/In12 GND
ad_connect  sys_concat_intc/In11 GND
ad_connect  sys_concat_intc/In10 GND
ad_connect  sys_concat_intc/In9 GND
ad_connect  sys_concat_intc/In8 GND
ad_connect  sys_concat_intc/In7 GND
ad_connect  sys_concat_intc/In6 GND
ad_connect  sys_concat_intc/In5 GND
ad_connect  sys_concat_intc/In4 GND
ad_connect  sys_concat_intc/In3 GND
ad_connect  sys_concat_intc/In2 GND
ad_connect  sys_concat_intc/In1 GND
ad_connect  sys_concat_intc/In0 GND

# interconnects

ad_cpu_interconnect 0x41600000 axi_iic_main

source ../common/m2k_bd.tcl
