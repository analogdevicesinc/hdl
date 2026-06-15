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
