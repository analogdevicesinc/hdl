###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/axi_tdd/scripts/axi_tdd.tcl

set TDD_SUPPORT      $ad_project_params(TDD_SUPPORT)
set TDD_CHANNEL_CNT  $ad_project_params(TDD_CHANNEL_CNT)
set TDD_DEFAULT_POL  $ad_project_params(TDD_DEFAULT_POL)
set TDD_REG_WIDTH    $ad_project_params(TDD_REG_WIDTH)
set TDD_BURST_WIDTH  $ad_project_params(TDD_BURST_WIDTH)
set TDD_SYNC_WIDTH   $ad_project_params(TDD_SYNC_WIDTH)
set TDD_SYNC_INT     $ad_project_params(TDD_SYNC_INT)
set TDD_SYNC_EXT     $ad_project_params(TDD_SYNC_EXT)
set TDD_SYNC_EXT_CDC $ad_project_params(TDD_SYNC_EXT_CDC)

# GPIO

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_out
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_in

ad_ip_instance axi_gpio gpio_0 [list \
  C_IS_DUAL 1 \
  C_ALL_OUTPUTS 1 \
  C_GPIO_WIDTH 26 \
  C_ALL_INPUTS_2 1 \
  C_GPIO2_WIDTH 4 \
]

ad_connect gpio_0/GPIO gpio_out
ad_connect gpio_0/GPIO2 gpio_in

# BF SPI 01

create_bd_port -dir O bf_spi_sclk_01
create_bd_port -dir O bf_spi_csb_01
create_bd_port -dir O bf_spi_mosi_01
create_bd_port -dir I bf_spi_miso_01

ad_ip_instance axi_quad_spi bf_spi_01 [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect bf_spi_01/sck_o bf_spi_sclk_01
ad_connect bf_spi_01/ss_o bf_spi_csb_01
ad_connect bf_spi_01/io0_o bf_spi_mosi_01
ad_connect bf_spi_01/io1_i bf_spi_miso_01

# BF SPI 02

create_bd_port -dir O bf_spi_sclk_02
create_bd_port -dir O bf_spi_csb_02
create_bd_port -dir O bf_spi_mosi_02
create_bd_port -dir I bf_spi_miso_02

ad_ip_instance axi_quad_spi bf_spi_02 [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect bf_spi_02/sck_o bf_spi_sclk_02
ad_connect bf_spi_02/ss_o bf_spi_csb_02
ad_connect bf_spi_02/io0_o bf_spi_mosi_02
ad_connect bf_spi_02/io1_i bf_spi_miso_02

# BF SPI 03

create_bd_port -dir O bf_spi_sclk_03
create_bd_port -dir O bf_spi_csb_03
create_bd_port -dir O bf_spi_mosi_03
create_bd_port -dir I bf_spi_miso_03

ad_ip_instance axi_quad_spi bf_spi_03 [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect bf_spi_03/sck_o bf_spi_sclk_03
ad_connect bf_spi_03/ss_o bf_spi_csb_03
ad_connect bf_spi_03/io0_o bf_spi_mosi_03
ad_connect bf_spi_03/io1_i bf_spi_miso_03

# BF SPI 04

create_bd_port -dir O bf_spi_sclk_04
create_bd_port -dir O bf_spi_csb_04
create_bd_port -dir O bf_spi_mosi_04
create_bd_port -dir I bf_spi_miso_04

ad_ip_instance axi_quad_spi bf_spi_04 [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect bf_spi_04/sck_o bf_spi_sclk_04
ad_connect bf_spi_04/ss_o bf_spi_csb_04
ad_connect bf_spi_04/io0_o bf_spi_mosi_04
ad_connect bf_spi_04/io1_i bf_spi_miso_04

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

# TDD

create_bd_port -dir I tdd_sync
create_bd_port -dir O tdd_sync_out
create_bd_port -dir O -from [expr $TDD_CHANNEL_CNT - 1] -to 0 tdd_channels

if {$TDD_SUPPORT} {
  ad_tdd_gen_create axi_tdd_0 $TDD_CHANNEL_CNT \
                              $TDD_DEFAULT_POL \
                              $TDD_REG_WIDTH \
                              $TDD_BURST_WIDTH \
                              $TDD_SYNC_WIDTH \
                              $TDD_SYNC_INT \
                              $TDD_SYNC_EXT \
                              $TDD_SYNC_EXT_CDC

  ad_ip_instance ilconcat tdd_channel_concat [list \
    NUM_PORTS ${TDD_CHANNEL_CNT} \
  ]

  ad_connect sys_250m_clk     axi_tdd_0/clk
  ad_connect sys_250m_resetn  axi_tdd_0/resetn
  ad_connect sys_cpu_clk      axi_tdd_0/s_axi_aclk
  ad_connect sys_cpu_resetn   axi_tdd_0/s_axi_aresetn
  for {set j 0} {$j < $TDD_CHANNEL_CNT} {incr j} {
    ad_connect axi_tdd_0/tdd_channel_${j} tdd_channel_concat/In${j}
  }

  ad_connect tdd_sync         axi_tdd_0/sync_in
  ad_connect tdd_sync_out     axi_tdd_0/sync_out
  ad_connect tdd_channels     tdd_channel_concat/dout
}
