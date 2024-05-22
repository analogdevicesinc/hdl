###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# axi gpio

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_gpio_o1
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_gpio_o2

ad_ip_instance axi_gpio fmc_gpio [list \
  C_IS_DUAL 1 \
  C_ALL_OUTPUTS 1 \
  C_ALL_OUTPUTS_2 1 \
  C_GPIO2_WIDTH 19 \
]

ad_connect fmc_gpio/GPIO fmc_gpio_o1
ad_connect fmc_gpio/GPIO2 fmc_gpio_o2

# axi spi

create_bd_port -dir O fmc_spi_sck
create_bd_port -dir O -from 11 -to 0 fmc_spi_cs_n
create_bd_port -dir O fmc_spi_mosi
create_bd_port -dir I fmc_spi_miso

ad_ip_instance axi_quad_spi fmc_spi [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 12 \
]

ad_connect fmc_spi/sck_o fmc_spi_sck
ad_connect fmc_spi/ss_o fmc_spi_cs_n
ad_connect fmc_spi/io0_o fmc_spi_mosi
ad_connect fmc_spi/io1_i fmc_spi_miso

ad_ip_instance clk_wiz fmc_spi_clk_wiz [list \
  USE_LOCKED false \
  CLKOUT1_REQUESTED_OUT_FREQ 50 \
]

# axi i2c

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 fmc_iic

ad_ip_instance axi_iic fmc_i2c

ad_connect fmc_i2c/IIC fmc_iic

ad_connect fmc_spi_clk_wiz/reset sys_cpu_reset
ad_connect fmc_spi_clk_wiz/clk_in1 sys_cpu_clk
ad_connect fmc_spi_clk_wiz/clk_out1 fmc_spi/ext_spi_clk

# interconnect

ad_cpu_interconnect  0x50000000 fmc_gpio
ad_cpu_interconnect  0x50010000 fmc_spi
ad_cpu_interconnect  0x50020000 fmc_i2c

# interrupts

ad_cpu_interrupt ps-12 mb-12 fmc_spi/ip2intc_irpt
ad_cpu_interrupt ps-13 mb-13 fmc_i2c/iic2intc_irpt
