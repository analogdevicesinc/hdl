
  # cftl

  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_cftl
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_cftl

  # iic

  set_property -dict [list CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} ] $sys_ps7

  # iic cftl

  ad_connect  iic_cftl sys_ps7/IIC_0
