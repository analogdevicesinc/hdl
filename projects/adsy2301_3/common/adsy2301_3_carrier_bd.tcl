###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

# TDD

create_bd_port -dir I tdd_sync_in
create_bd_port -dir O tdd_sync_out
create_bd_port -dir O -from [expr $TDD_CHANNEL_CNT - 1] -to 0 tdd_channels

if {$TDD_SUPPORT} {
  ad_tdd_gen_create axi_tdd_carrier $TDD_CHANNEL_CNT \
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

  ad_connect sys_250m_clk    axi_tdd_carrier/clk
  ad_connect sys_250m_resetn axi_tdd_carrier/resetn
  ad_connect sys_cpu_clk     axi_tdd_carrier/s_axi_aclk
  ad_connect sys_cpu_resetn  axi_tdd_carrier/s_axi_aresetn

  for {set j 0} {$j < $TDD_CHANNEL_CNT} {incr j} {
    ad_connect axi_tdd_carrier/tdd_channel_${j} tdd_channel_concat/In${j}
  }

  ad_connect tdd_sync_in  axi_tdd_carrier/sync_in
  ad_connect tdd_sync_out axi_tdd_carrier/sync_out
  ad_connect tdd_channels tdd_channel_concat/dout
}
