
  # cftl

  set gpio_cftl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_cftl ]
  set iic_cftl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_cftl ]

  set spi0_cftl_csn_i       [create_bd_port -dir I spi0_cftl_csn_i]
  set spi0_cftl_csn_o       [create_bd_port -dir O spi0_cftl_csn_o]
  set spi0_cftl_sclk_i      [create_bd_port -dir I spi0_cftl_sclk_i]
  set spi0_cftl_sclk_o      [create_bd_port -dir O spi0_cftl_sclk_o]
  set spi0_cftl_mosi_i      [create_bd_port -dir I spi0_cftl_mosi_i]
  set spi0_cftl_mosi_o      [create_bd_port -dir O spi0_cftl_mosi_o]
  set spi0_cftl_miso_i      [create_bd_port -dir I spi0_cftl_miso_i]

  set spi1_cftl_sclk_i      [create_bd_port -dir I spi1_cftl_sclk_i]
  set spi1_cftl_sclk_o      [create_bd_port -dir O spi1_cftl_sclk_o]
  set spi1_cftl_csn_i       [create_bd_port -dir I spi1_cftl_csn_i]
  set spi1_cftl_csn0_o      [create_bd_port -dir O spi1_cftl_csn0_o]
  set spi1_cftl_csn1_o      [create_bd_port -dir O spi1_cftl_csn1_o]
  set spi1_cftl_mosi_i      [create_bd_port -dir I spi1_cftl_mosi_i]
  set spi1_cftl_mosi_o      [create_bd_port -dir O spi1_cftl_mosi_o]
  set spi1_cftl_miso_i      [create_bd_port -dir I spi1_cftl_miso_i]
  # gpio_cftl

  set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {34}] $sys_ps7
  set_property LEFT 33 [get_bd_ports GPIO_I]
  set_property LEFT 33 [get_bd_ports GPIO_O]
  set_property LEFT 33 [get_bd_ports GPIO_T]

  # spi0, spi1, iic

  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI1_SPI1_IO {EMIO}] $sys_ps7
  set_property -dict [list CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} ] $sys_ps7

  # interconnect

  set_property -dict [list CONFIG.NUM_MI {7}] $axi_cpu_interconnect

  # iic cftl

  connect_bd_intf_net -intf_net sys_ps7_IIC_0 [get_bd_intf_ports iic_cftl] [get_bd_intf_pins sys_ps7/IIC_0]

  # spi0 cftl

  connect_bd_net -net spi0_cftl_csn_i   [get_bd_ports spi0_cftl_csn_i]    [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi0_cftl_csn_o   [get_bd_ports spi0_cftl_csn_o]    [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi0_cftl_sclk_i  [get_bd_ports spi0_cftl_sclk_i]   [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi0_cftl_sclk_o  [get_bd_ports spi0_cftl_sclk_o]   [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net spi0_cftl_mosi_i  [get_bd_ports spi0_cftl_mosi_i]   [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi0_cftl_mosi_o  [get_bd_ports spi0_cftl_mosi_o]   [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi0_cftl_miso_i  [get_bd_ports spi0_cftl_miso_i]   [get_bd_pins sys_ps7/SPI0_MISO_I]

  # spi1 cftl

  connect_bd_net -net spi1_cftl_csn_i       [get_bd_ports spi1_cftl_csn_i]    [get_bd_pins sys_ps7/SPI1_SS_I]
  connect_bd_net -net spi1_cftl_csn0_o      [get_bd_ports spi1_cftl_csn0_o]   [get_bd_pins sys_ps7/SPI1_SS_O]
  connect_bd_net -net spi1_cftl_csn1_o      [get_bd_ports spi1_cftl_csn1_o]   [get_bd_pins sys_ps7/SPI1_SS1_O]
  connect_bd_net -net spi1_cftl_sclk_i      [get_bd_ports spi1_cftl_sclk_i]   [get_bd_pins sys_ps7/SPI1_SCLK_I]
  connect_bd_net -net spi1_cftl_sclk_o      [get_bd_ports spi1_cftl_sclk_o]   [get_bd_pins sys_ps7/SPI1_SCLK_O]
  connect_bd_net -net spi1_cftl_mosi_i      [get_bd_ports spi1_cftl_mosi_i]   [get_bd_pins sys_ps7/SPI1_MOSI_I]
  connect_bd_net -net spi1_cftl_mosi_o      [get_bd_ports spi1_cftl_mosi_o]   [get_bd_pins sys_ps7/SPI1_MOSI_O]
  connect_bd_net -net spi1_cftl_miso_i      [get_bd_ports spi1_cftl_miso_i]   [get_bd_pins sys_ps7/SPI1_MISO_I]
