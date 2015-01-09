
  # cftl

  set gpio_cftl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_cftl ]
  set iic_cftl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_cftl ]
  set spi1_cftl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi1_cftl ]
  set spi_cftl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi_cftl ]

  # gpio_cftl

  set axi_gpio_cftl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_cftl ]
  set_property -dict [ list CONFIG.C_GPIO_WIDTH {2}  ] $axi_gpio_cftl

  # spi0, spi1, iic

  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} ] $sys_ps7

  # interconnect

  set_property -dict [list CONFIG.NUM_MI {8}] $axi_cpu_interconnect

  # gpio_cftl

  connect_bd_intf_net -intf_net axi_gpio_cftl_GPIO [get_bd_intf_ports gpio_cftl] [get_bd_intf_pins axi_gpio_cftl/GPIO]

  # iic cftl

  connect_bd_intf_net -intf_net sys_ps7_IIC_0 [get_bd_intf_ports iic_cftl] [get_bd_intf_pins sys_ps7/IIC_0]

  # spi0 cftl

  connect_bd_intf_net -intf_net sys_ps7_SPI_0 [get_bd_intf_ports spi_cftl] [get_bd_intf_pins sys_ps7/SPI_0]

  # spi1 cftl

  connect_bd_intf_net -intf_net sys_ps7_SPI_1 [get_bd_intf_ports spi1_cftl] [get_bd_intf_pins sys_ps7/SPI_1]

  # interconnect (cpu)

  connect_bd_intf_net -intf_net axi_cpu_interconnect_M07_AXI [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_gpio_cftl/S_AXI]

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source

  # interconnects (gpio_cftl)

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_gpio_cftl/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_gpio_cftl/s_axi_aresetn] $sys_100m_resetn_source


  # address map

  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_gpio_cftl/S_AXI/Reg] SEG_axi_gpio_cftl_Reg
