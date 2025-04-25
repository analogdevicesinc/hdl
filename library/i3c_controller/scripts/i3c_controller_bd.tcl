###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc i3c_controller_create {{name "i3c_controller"} {async_clk 0} {i2c_mod 0} {offload 1} {max_devs 16}} {

  create_bd_cell -type hier $name
  current_bd_instance /$name

  if {$async_clk == 1} {
    create_bd_pin -dir I -type clk aclk
  }
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst reset_n
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:i3c_controller_rtl:1.0 m_i3c
  if {$offload == 1} {
    create_bd_pin -dir I trigger
    create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 offload_sdi
  }

  ad_ip_instance i3c_controller_host_interface host_interface
  ad_ip_parameter host_interface CONFIG.ASYNC_CLK $async_clk
  ad_ip_parameter host_interface CONFIG.OFFLOAD $offload

  ad_ip_instance i3c_controller_core core
  ad_ip_parameter core CONFIG.MAX_DEVS $max_devs
  ad_ip_parameter core CONFIG.i2c_MOD $i2c_mod

  ad_connect clk host_interface/s_axi_aclk
  if {$async_clk == 1} {
    ad_connect aclk host_interface/clk
    ad_connect aclk core/clk
  } else {
    ad_connect clk core/clk
  }
  if {$offload == 1} {
    ad_connect trigger host_interface/offload_trigger
    ad_connect host_interface/offload_sdi offload_sdi
  }

  ad_connect core/i3c m_i3c
  ad_connect host_interface/reset_n core/reset_n
  ad_connect host_interface/rmap core/rmap
  ad_connect host_interface/cmdp core/cmdp
  ad_connect host_interface/sdio core/sdio

  ad_connect reset_n host_interface/s_axi_aresetn
  ad_connect irq     host_interface/irq

  current_bd_instance /
}
