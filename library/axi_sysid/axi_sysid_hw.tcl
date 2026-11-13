###############################################################################
## Copyright (C) 2020-2023, 2026 Analog Devices, Inc. All rights reserved.
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

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_sysid
set_module_property DESCRIPTION "AXI System ID"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_sysid
set_module_property ELABORATION_CALLBACK p_elaboration

# source files

ad_ip_files axi_sysid [list \
  "$ad_hdl_dir/library/common/up_apb.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_sysid.v"]

# IP parameters

add_parameter ROM_WIDTH INTEGER 32
set_parameter_property ROM_WIDTH DEFAULT_VALUE 32
set_parameter_property ROM_WIDTH DISPLAY_NAME "ROM width"
set_parameter_property ROM_WIDTH UNITS None
set_parameter_property ROM_WIDTH HDL_PARAMETER true

add_parameter ROM_ADDR_BITS INTEGER 9
set_parameter_property ROM_ADDR_BITS DEFAULT_VALUE 9
set_parameter_property ROM_ADDR_BITS DISPLAY_NAME "ROM address bits"
set_parameter_property ROM_ADDR_BITS HDL_PARAMETER true

add_parameter REGMAP_INTERFACE INTEGER 0
set_parameter_property REGMAP_INTERFACE DEFAULT_VALUE 0
set_parameter_property REGMAP_INTERFACE DISPLAY_NAME "Register Map Interface"
set_parameter_property REGMAP_INTERFACE ALLOWED_RANGES {"0:AXI" "1:APB"}
set_parameter_property REGMAP_INTERFACE HDL_PARAMETER true

proc p_elaboration {} {

  set regmap_interface [get_parameter_value REGMAP_INTERFACE]

  # AXI4 Memory Mapped Interface

  ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 15

  # register map interface: AXI (REGMAP_INTERFACE = 0) or APB (1)

  ad_interface clock   s_apb_pclk    input  1
  ad_interface reset-n s_apb_presetn input  1  if_s_apb_pclk
  add_interface s_apb apb end
  set_interface_property s_apb associatedClock if_s_apb_pclk
  set_interface_property s_apb associatedReset if_s_apb_presetn
  add_interface_port s_apb s_apb_paddr   paddr   Input  16
  add_interface_port s_apb s_apb_psel    psel    Input  1
  add_interface_port s_apb s_apb_penable penable Input  1
  add_interface_port s_apb s_apb_pwrite  pwrite  Input  1
  add_interface_port s_apb s_apb_pwdata  pwdata  Input  32
  add_interface_port s_apb s_apb_prdata  prdata  Output 32
  add_interface_port s_apb s_apb_pready  pready  Output 1
  add_interface_port s_apb s_apb_pslverr pslverr Output 1

  if {$regmap_interface == 1} {
    set_interface_property s_axi ENABLED false
    foreach port {s_axi_awvalid s_axi_awaddr s_axi_awprot s_axi_wvalid \
                  s_axi_wdata s_axi_wstrb s_axi_bready s_axi_arvalid \
                  s_axi_araddr s_axi_arprot s_axi_rready} {
      set_port_property $port termination true
    }
    set_port_property s_axi_aclk termination true
    set_port_property s_axi_aresetn termination true
    set_port_property s_axi_aresetn termination_value 1
  } else {
    set_interface_property s_apb ENABLED false
    foreach port {paddr penable psel pwdata pwrite} {
      set_port_property s_apb_$port termination true
    }
    set_interface_property if_s_apb_pclk ENABLED false
    set_interface_property if_s_apb_presetn ENABLED false
    set_port_property s_apb_pclk termination true
    set_port_property s_apb_presetn termination true
    set_port_property s_apb_presetn termination_value 1
  }
}

# external clock and control/status ports

ad_interface signal sys_rom_data       input  ROM_WIDTH rom_data
ad_interface signal pr_rom_data        input  ROM_WIDTH rom_data
ad_interface signal rom_addr           output ROM_ADDR_BITS
