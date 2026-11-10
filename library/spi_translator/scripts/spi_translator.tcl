###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Builds an SPI translator hierarchy: the spi_translator_slave module, the
## spi_translator_interconnect and ceil(num_cs / 8) spi_engine_execution
## instances, 8 chip selects each and the remainder on the last one. A slave
## is numbered {engine, cs[2:0]}: the host SELECTs the engine, then uses the
## engine's chip select in CHIPSELECT.
##
## Usage (Xilinx):
##   source $ad_hdl_dir/library/spi_translator/scripts/spi_translator.tcl
##   spi_translator_create spi_translator 12 4 0x0 0xA
##
## Hierarchy pins:
##   clk, resetn             core clock and active-low reset
##   sclk, sdi, sdo, sdi_t,  upstream SPI slave (sdi = MOSI, sdo = MISO,
##   cs                      sdi_t = MISO tristate)
##   gpio_i/o/t              num_gpio wide, only when num_gpio > 0
##   m_spi_<k>               downstream SPI of engine k (spi_engine_rtl)
##   echo_sclk_<k>           echo clock of engine k, only when echo_sclk = 1
##
## \param[name] - hierarchy name
## \param[num_cs] - total downstream chip selects, 1 to 128
## \param[num_gpio] - number of GPIOs, 0 to 256
## \param[gpio_default_dir] - GPIO reset direction, bit g for GPIO g, 1 = input
## \param[gpio_default_out] - GPIO reset output value, bit g for GPIO g
## \param[up_cpol] - upstream SPI clock polarity
## \param[up_cpha] - upstream SPI clock phase
## \param[up_early_launch] - launch MISO on the sample edge, see the slave module
## \param[cmd_fifo_addr_width] - CMD FIFO depth, log2
## \param[sdo_fifo_addr_width] - SDO FIFO depth, log2
## \param[resp_fifo_addr_width] - response (SDI) FIFO depth, log2
## \param[sdi_delay] - SDI_DELAY of every engine
## \param[echo_sclk] - ECHO_SCLK of every engine

proc spi_translator_create {name num_cs {num_gpio 0} \
                            {gpio_default_dir 0x0} {gpio_default_out 0x0} \
                            {up_cpol 0} {up_cpha 0} {up_early_launch 0} \
                            {cmd_fifo_addr_width 8} {sdo_fifo_addr_width 8} \
                            {resp_fifo_addr_width 8} \
                            {sdi_delay 0} {echo_sclk 0}} {

  if {$num_cs < 1 || $num_cs > 128} {
    error "ERROR: spi_translator_create: num_cs must be 1 to 128, got $num_cs"
  }

  set num_engines [expr {($num_cs + 7) / 8}]

  set slave "${name}_slave"
  set interconnect "${name}_interconnect"

  create_bd_cell -type hier $name
  current_bd_instance /$name

  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst resetn

  create_bd_pin -dir I sclk
  create_bd_pin -dir I sdi
  create_bd_pin -dir O sdo
  create_bd_pin -dir O sdi_t
  create_bd_pin -dir I cs

  if {$num_gpio > 0} {
    create_bd_pin -dir I -from [expr {$num_gpio - 1}] -to 0 gpio_i
    create_bd_pin -dir O -from [expr {$num_gpio - 1}] -to 0 gpio_o
    create_bd_pin -dir O -from [expr {$num_gpio - 1}] -to 0 gpio_t
  }

  for {set k 0} {$k < $num_engines} {incr k} {
    create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 m_spi_$k
    if {$echo_sclk == 1} {
      create_bd_pin -dir I -type clk echo_sclk_$k
    }
  }

  # slave module

  ad_ip_instance spi_translator_slave $slave
  ad_ip_parameter $slave CONFIG.NUM_OF_CS $num_cs
  ad_ip_parameter $slave CONFIG.NUM_OF_GPIO $num_gpio
  ad_ip_parameter $slave CONFIG.UP_CPOL [expr {$up_cpol ? "true" : "false"}]
  ad_ip_parameter $slave CONFIG.UP_CPHA [expr {$up_cpha ? "true" : "false"}]
  ad_ip_parameter $slave CONFIG.UP_EARLY_LAUNCH [expr {$up_early_launch ? "true" : "false"}]
  ad_ip_parameter $slave CONFIG.CMD_FIFO_ADDRESS_WIDTH $cmd_fifo_addr_width
  ad_ip_parameter $slave CONFIG.SDO_FIFO_ADDRESS_WIDTH $sdo_fifo_addr_width
  ad_ip_parameter $slave CONFIG.RESP_FIFO_ADDRESS_WIDTH $resp_fifo_addr_width
  if {$num_gpio > 0} {
    ad_ip_parameter $slave CONFIG.GPIO_DEFAULT_DIR $gpio_default_dir
    ad_ip_parameter $slave CONFIG.GPIO_DEFAULT_OUT $gpio_default_out
  }

  ad_ip_instance spi_translator_interconnect $interconnect
  ad_ip_parameter $interconnect CONFIG.NUM_OF_ENGINES $num_engines

  ad_connect clk $slave/clk
  ad_connect resetn $slave/resetn
  ad_connect sclk $slave/sclk
  ad_connect sdi $slave/sdi
  ad_connect sdo $slave/sdo
  ad_connect sdi_t $slave/sdi_t
  ad_connect cs $slave/cs

  if {$num_gpio > 0} {
    ad_connect gpio_i $slave/gpio_i
    ad_connect gpio_o $slave/gpio_o
    ad_connect gpio_t $slave/gpio_t
  }

  # the engines and the interconnect are reset by FLUSH through spi_resetn

  ad_connect clk $interconnect/clk
  ad_connect $slave/spi_resetn $interconnect/resetn
  ad_connect $slave/spi_engine_ctrl $interconnect/s_ctrl

  # engines: 8 chip selects each, the last one the remainder

  for {set k 0} {$k < $num_engines} {incr k} {
    set execution "${name}_execution_$k"
    set engine_cs [expr {($k == $num_engines - 1) ? ($num_cs - 8 * $k) : 8}]

    ad_ip_instance spi_engine_execution $execution
    ad_ip_parameter $execution CONFIG.DATA_WIDTH 8
    ad_ip_parameter $execution CONFIG.NUM_OF_SDIO 1
    ad_ip_parameter $execution CONFIG.NUM_OF_CS $engine_cs
    ad_ip_parameter $execution CONFIG.SDI_DELAY $sdi_delay
    ad_ip_parameter $execution CONFIG.ECHO_SCLK $echo_sclk

    ad_connect clk $execution/clk
    ad_connect $slave/spi_resetn $execution/resetn
    ad_connect $interconnect/m${k}_ctrl $execution/ctrl
    ad_connect $execution/spi m_spi_$k
    if {$echo_sclk == 1} {
      ad_connect echo_sclk_$k $execution/echo_sclk
    }
  }

  current_bd_instance /
}
