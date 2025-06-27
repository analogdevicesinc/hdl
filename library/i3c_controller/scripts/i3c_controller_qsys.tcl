###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc i3c_controller_create {{name "i3c_controller"} {async_clk 0} {i2c_mod 0} {offload 1} {max_devs 16}} {
  add_instance ${name}_host_interface i3c_controller_host_interface

  set_instance_parameter_value ${name}_host_interface {ASYNC_CLK} $async_clk
  set_instance_parameter_value ${name}_host_interface {OFFLOAD}   $offload

  add_instance ${name}_core i3c_controller_core

  set_instance_parameter_value ${name}_core {MAX_DEVS} $max_devs
  set_instance_parameter_value ${name}_core {I2C_MOD} $i2c_mod

  add_connection ${name}_host_interface.sdo  ${name}_core.sdo
  add_connection ${name}_host_interface.cmdp ${name}_core.cmdp
  add_connection ${name}_host_interface.rmap ${name}_core.rmap
  add_connection ${name}_core.sdi ${name}_host_interface.sdi
  add_connection ${name}_core.ibi ${name}_host_interface.ibi

  add_connection ${name}_host_interface.if_reset_n ${name}_core.if_reset_n
}
