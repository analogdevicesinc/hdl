###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# GPIO

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_out
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_in

ad_ip_instance axi_gpio gpio_0 [list \
  C_IS_DUAL 1 \
  C_ALL_OUTPUTS 1 \
  C_GPIO_WIDTH 22 \
  C_ALL_INPUTS_2 1 \
  C_GPIO2_WIDTH 4 \
]

ad_connect gpio_0/GPIO gpio_out
ad_connect gpio_0/GPIO2 gpio_in

# BF SPI ports

create_bd_port -dir O bf_spi_sclk_01
create_bd_port -dir O -from 1 -to 0 bf_spi_csb_01
create_bd_port -dir O bf_spi_mosi_01
create_bd_port -dir I bf_spi_miso_01

create_bd_port -dir O bf_spi_sclk_02
create_bd_port -dir O -from 1 -to 0 bf_spi_csb_02
create_bd_port -dir O bf_spi_mosi_02
create_bd_port -dir I bf_spi_miso_02

create_bd_port -dir O fmc_spi_sclk_03
create_bd_port -dir O fmc_spi_csb_03
create_bd_port -dir O fmc_spi_mosi_03
create_bd_port -dir I fmc_spi_miso_03

create_bd_port -dir O fmc_spi_sclk_04
create_bd_port -dir O fmc_spi_csb_04
create_bd_port -dir O fmc_spi_mosi_04
create_bd_port -dir I fmc_spi_miso_04

if {$ad_project_params(MULTI_SPI) == 0} {
  # BF SPI 01

  ad_ip_instance axi_quad_spi bf_spi_01 [list \
    C_USE_STARTUP 0 \
    C_NUM_SS_BITS 2 \
    C_SCK_RATIO 2 \
  ]

  # BF SPI 02

  ad_ip_instance axi_quad_spi bf_spi_02 [list \
    C_USE_STARTUP 0 \
    C_NUM_SS_BITS 2 \
    C_SCK_RATIO 2 \
  ]
} else {
  # BF SPI 01

  ad_ip_instance axi_quad_spi bf_spi_01 [list \
    C_USE_STARTUP 0 \
    C_NUM_SS_BITS 1 \
    C_SCK_RATIO 2 \
  ]

  # BF SPI 02

  ad_ip_instance axi_quad_spi bf_spi_02 [list \
    C_USE_STARTUP 0 \
    C_NUM_SS_BITS 1 \
    C_SCK_RATIO 2 \
  ]

  # FMC SPI 03

  ad_ip_instance axi_quad_spi fmc_spi_03 [list \
    C_USE_STARTUP 0 \
    C_NUM_SS_BITS 1 \
    C_SCK_RATIO 2 \
  ]

  ad_connect fmc_spi_03/sck_o fmc_spi_sclk_03
  ad_connect fmc_spi_03/ss_o fmc_spi_csb_03
  ad_connect fmc_spi_03/io0_o fmc_spi_mosi_03
  ad_connect fmc_spi_03/io1_i fmc_spi_miso_03

  # FMC SPI 04

  ad_ip_instance axi_quad_spi fmc_spi_04 [list \
    C_USE_STARTUP 0 \
    C_NUM_SS_BITS 1 \
    C_SCK_RATIO 2 \
  ]

  ad_connect fmc_spi_04/sck_o fmc_spi_sclk_04
  ad_connect fmc_spi_04/ss_o fmc_spi_csb_04
  ad_connect fmc_spi_04/io0_o fmc_spi_mosi_04
  ad_connect fmc_spi_04/io1_i fmc_spi_miso_04
}

ad_connect bf_spi_01/sck_o bf_spi_sclk_01
ad_connect bf_spi_01/ss_o bf_spi_csb_01
ad_connect bf_spi_01/io0_o bf_spi_mosi_01
ad_connect bf_spi_01/io1_i bf_spi_miso_01

ad_connect bf_spi_02/sck_o bf_spi_sclk_02
ad_connect bf_spi_02/ss_o bf_spi_csb_02
ad_connect bf_spi_02/io0_o bf_spi_mosi_02
ad_connect bf_spi_02/io1_i bf_spi_miso_02

# BF I2C 01

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 bf_iic_01

ad_ip_instance axi_iic axi_bf_iic_01

ad_connect axi_bf_iic_01/IIC bf_iic_01

# BF I2C 02

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 bf_iic_02

ad_ip_instance axi_iic axi_bf_iic_02

ad_connect axi_bf_iic_02/IIC bf_iic_02

# BF I2C 03

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 bf_iic_03

ad_ip_instance axi_iic axi_bf_iic_03

ad_connect axi_bf_iic_03/IIC bf_iic_03

# BF I2C 04

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 bf_iic_04

ad_ip_instance axi_iic axi_bf_iic_04

ad_connect axi_bf_iic_04/IIC bf_iic_04

# XUD SPI

create_bd_port -dir O xud_spi_sclk
create_bd_port -dir O xud_spi_csb
create_bd_port -dir O xud_spi_mosi
create_bd_port -dir I xud_spi_miso

ad_ip_instance axi_quad_spi xud_spi [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect xud_spi/sck_o xud_spi_sclk
ad_connect xud_spi/ss_o xud_spi_csb
ad_connect xud_spi/io0_o xud_spi_mosi
ad_connect xud_spi/io1_i xud_spi_miso
