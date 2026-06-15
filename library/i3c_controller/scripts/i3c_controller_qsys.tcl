###############################################################################
## Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
