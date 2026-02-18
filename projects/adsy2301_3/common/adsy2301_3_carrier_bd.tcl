###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# GPIO

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_out
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_in

ad_ip_instance axi_gpio gpio_ctrl [list \
  C_IS_DUAL 1 \
  C_ALL_OUTPUTS 1 \
  C_GPIO_WIDTH 4 \
  C_ALL_INPUTS_2 1 \
  C_GPIO2_WIDTH 2\
]

ad_connect gpio_ctrl/GPIO gpio_out
ad_connect gpio_ctrl/GPIO2 gpio_in

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
