proc i3c_controller_create {{name "i3c_controller"} {async_i3c_clk 0} {clk_div "4"} {sim_device "7SERIES"}} {

  create_bd_cell -type hier $name
  current_bd_instance /$name

  if {$async_i3c_clk == 1} {
    create_bd_pin -dir I -type clk i3c_clk
  }
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst reset_n
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:i3c_controller_rtl:1.0 m_i3c

  ad_ip_instance axi_i3c_controller axi_regmap
  ad_ip_parameter axi_regmap CONFIG.ASYNC_I3C_CLK $async_i3c_clk

  ad_ip_instance i3c_controller_host_interface host_interface

  ad_ip_instance i3c_controller_core core
  ad_ip_parameter core       CONFIG.SIM_DEVICE $sim_device
  ad_ip_parameter core       CONFIG.CLK_DIV $clk_div

  if {$async_i3c_clk == 1} {
    ad_connect i3c_clk host_interface/clk
    ad_connect i3c_clk core/clk
    ad_connect i3c_clk axi_regmap/i3c_clk
  } else {
    ad_connect clk host_interface/clk
    ad_connect clk core/clk
  }

  ad_connect core/i3c m_i3c
  ad_connect clk axi_regmap/s_axi_aclk
  ad_connect axi_regmap/ctrl host_interface/ctrl
  ad_connect axi_regmap/i3c_reset_n host_interface/reset_n
  ad_connect axi_regmap/i3c_reset_n core/reset_n
  ad_connect axi_regmap/rmap core/rmap

  ad_connect host_interface/cmdp core/cmdp
  ad_connect host_interface/sdio core/sdio

  ad_connect reset_n axi_regmap/s_axi_aresetn
  ad_connect irq axi_regmap/irq

  current_bd_instance /
}
