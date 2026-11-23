###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Clocking

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 clk_in
set_property CONFIG.FREQ_HZ 156250000 [get_bd_intf_ports clk_in]
create_bd_port -dir O -type clk clk_out

ad_ip_instance clk_wiz clk_wizard [list \
  PRIM_SOURCE "Differential_clock_capable_pin" \
  CLKOUT1_REQUESTED_OUT_FREQ 100 \
]

ad_connect clk_wizard/CLK_IN1_D clk_in
ad_connect clk_wizard/reset GND
ad_connect sys_cpu_clk clk_wizard/clk_out1

ad_connect sys_cpu_clk clk_out

# Reset

create_bd_port -dir I -type rst ext_rst

ad_ip_instance proc_sys_reset sys_rstgen

ad_connect sys_rstgen/slowest_sync_clk sys_cpu_clk
ad_connect sys_rstgen/ext_reset_in ext_rst

ad_connect sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect sys_cpu_resetn sys_rstgen/peripheral_aresetn

# SPI link from the zcu102 and the SPI translator
# The link is a plain SPI slave (mode 0) on the SCLK, CS and MOSI pins, MISO
# tristated while CS is high. The engines, 8 chip selects each, are numbered
# {engine, cs[2:0]}:
#   engine 0  slaves 0..7   spi_0  TX SPI CS 1..4 = cs[3:0], RX SPI CS 1..4 = cs[7:4]
#                                  (TX and RX share SCLK, MOSI and the MISO mux)
#   engine 1  slave  8      spi_1  LO SPI (CS 0)
# The BF SPI and RF FL SPI buses are not controlled for now.
# The 151 translator GPIOs are the former axi_gpio banks and a 32 + 32 loopback
# test, in this order:
#   [29:0] out1   [61:30] out2   [69:62] out3     outputs, reset driven 0
#   [86:70] in                                    inputs
#   [118:87] test outputs   [150:119] test inputs outputs reset driven 0,
#                                                 input 119 + g reads output 87 + g
# As the axi_gpio they replace, the outputs reset as outputs driven 0 (axi_gpio
# C_DOUT_DEFAULT = 0) and the inputs as inputs. The loop is closed in
# system_top.v.

source $ad_hdl_dir/library/spi_translator/scripts/spi_translator.tcl

set num_cs 9
set num_gpio 151

create_bd_port -dir I link_sclk
create_bd_port -dir I link_cs
create_bd_port -dir I link_mosi
create_bd_port -dir O link_miso
create_bd_port -dir O link_miso_t

create_bd_port -dir I -from [expr $num_gpio - 1] -to 0 gpio_i
create_bd_port -dir O -from [expr $num_gpio - 1] -to 0 gpio_o
create_bd_port -dir O -from [expr $num_gpio - 1] -to 0 gpio_t

for {set k 0} {$k < 2} {incr k} {
  create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 spi_$k
}

spi_translator_create spi_translator $num_cs $num_gpio 0x7fffffff800000007fffc00000000000000000 0x0

ad_connect sys_cpu_clk spi_translator/clk
ad_connect sys_cpu_resetn spi_translator/resetn

ad_connect link_sclk spi_translator/sclk
ad_connect link_cs spi_translator/cs
ad_connect link_mosi spi_translator/sdi
ad_connect link_miso spi_translator/sdo
ad_connect link_miso_t spi_translator/sdi_t

ad_connect gpio_i spi_translator/gpio_i
ad_connect gpio_o spi_translator/gpio_o
ad_connect gpio_t spi_translator/gpio_t

for {set k 0} {$k < 2} {incr k} {
  ad_connect spi_translator/m_spi_$k spi_$k
}

# ILA on the loopback test GPIO outputs 87..118; the inputs 119..150 read the
# same values

ad_ip_instance xlslice ila_gpio_out [list \
  DIN_WIDTH $num_gpio \
  DIN_FROM 118 \
  DIN_TO 87 \
  DOUT_WIDTH 32 \
]

ad_connect gpio_o ila_gpio_out/Din

create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_gpio
set_property -dict [list \
  CONFIG.C_DATA_DEPTH {8192} \
  CONFIG.C_MONITOR_TYPE {Native} \
  CONFIG.C_NUM_OF_PROBES {1} \
  CONFIG.C_PROBE0_WIDTH {32} \
] [get_bd_cells ila_gpio]

ad_connect sys_cpu_clk ila_gpio/clk
ad_connect ila_gpio_out/Dout ila_gpio/probe0
