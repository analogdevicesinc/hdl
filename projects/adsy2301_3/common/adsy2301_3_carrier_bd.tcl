###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# GPIO

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_pins

create_bd_port -dir I -from 5 -to 0 gpio_pins_i
create_bd_port -dir O -from 5 -to 0 gpio_pins_o
create_bd_port -dir O -from 5 -to 0 gpio_pins_t

# 0 - output
# 1 - input
# 0. FPGA_BOOT_GOOD / INIT_B - bidirectional - low / high / input (high good / low bad)
# 1. RX_LOAD - out
# 2. TX_LOAD - out
# 3. TR_PULSE - out
# 4. UDC_PG - in
# 5. FPGA_TRIG - out

ad_ip_instance axi_gpio gpio_ctrl [list \
  C_IS_DUAL 0 \
  C_GPIO_WIDTH 6 \
  C_TRI_DEFAULT 0x00000010 \
]

ad_connect gpio_ctrl/gpio_io_i gpio_pins_i
ad_connect gpio_ctrl/gpio_io_o gpio_pins_o
ad_connect gpio_ctrl/gpio_io_t gpio_pins_t

# CMD SPI

create_bd_port -dir O cmd_spi_sclk
create_bd_port -dir O cmd_spi_csb
create_bd_port -dir O cmd_spi_mosi
create_bd_port -dir I cmd_spi_miso

ad_ip_instance axi_quad_spi cmd_spi [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect cmd_spi/sck_o cmd_spi_sclk
ad_connect cmd_spi/ss_o cmd_spi_csb
ad_connect cmd_spi/io0_o cmd_spi_mosi
ad_connect cmd_spi/io1_i cmd_spi_miso
