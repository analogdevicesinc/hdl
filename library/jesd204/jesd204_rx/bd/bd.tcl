###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
#
# The ADI JESD204 Core is released under the following license, which is
# different than all other HDL cores in this repository.
#
# Please read this, and understand the freedoms and responsibilities you have
# by using this source code/core.
#
# The JESD204 HDL, is copyright © 2016-2023 Analog Devices Inc.
#
# This core is free software, you can use run, copy, study, change, ask
# questions about and improve this core. Distribution of source, or resulting
# binaries (including those inside an FPGA or ASIC) require you to release the
# source of the entire project (excluding the system libraries provide by the
# tools/compiler/FPGA vendor). These are the terms of the GNU General Public
# License version 2 as published by the Free Software Foundation.
#
# This core  is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License version 2
# along with this source code, and binary.  If not, see
# <http://www.gnu.org/licenses/>.
#
# Commercial licenses (with commercial support) of this JESD204 core are also
# available under terms different than the General Public License. (e.g. they
# do not require you to accompany any image (FPGA or ASIC) using the JESD204
# core with any corresponding source code.) For these alternate terms you must
# purchase a license from Analog Devices Technology Licensing Office. Users
# interested in such a license should contact jesd204-licensing@analog.com for
# more information. This commercial license is sub-licensable (if you purchase
# chips from Analog Devices, incorporate them into your PCB level product, and
# purchase a JESD204 license, end users of your product will also have a
# license to use this core in a commercial setting without releasing their
# source code).
#
# In addition, we kindly ask you to acknowledge ADI in any program, application
# or publication in which you use this JESD204 HDL core. (You are not required
# to do so; it is up to your common sense to decide whether you want to comply
# with this request or not.) For general publications, we suggest referencing :
# “The design and implementation of the JESD204 HDL Core used in this project
# is copyright © 2016-2023, Analog Devices, Inc.”

proc init {cellpath otherInfo} {
  set ip [get_bd_cells $cellpath]

  bd::mark_propagate_override $ip \
    "ASYNC_CLK"

}

proc detect_async_clk { cellpath ip param_name clk_a clk_b } {
  set param_src [get_property "CONFIG.$param_name.VALUE_SRC" $ip]
  if {[string equal $param_src "USER"]} {
    return;
  }

  set clk_domain_a [get_property CONFIG.CLK_DOMAIN $clk_a]
  set clk_domain_b [get_property CONFIG.CLK_DOMAIN $clk_b]
  set clk_freq_a [get_property CONFIG.FREQ_HZ $clk_a]
  set clk_freq_b [get_property CONFIG.FREQ_HZ $clk_b]
  set clk_phase_a [get_property CONFIG.PHASE $clk_a]
  set clk_phase_b [get_property CONFIG.PHASE $clk_b]

  # Only mark it as sync if we can make sure that it is sync, if the
  # relationship of the clocks is unknown mark it as async
  if {$clk_domain_a != {} && $clk_domain_b != {} && \
    $clk_domain_a == $clk_domain_b && $clk_freq_a == $clk_freq_b && \
    $clk_phase_a == $clk_phase_b} {
    set clk_async 0
  } else {
    set clk_async 1
  }

  set_property "CONFIG.$param_name" $clk_async $ip

}

proc propagate {cellpath otherinfo} {
  set ip [get_bd_cells $cellpath]

  set link_clk [get_bd_pins "$ip/clk"]
  set device_clk [get_bd_pins "$ip/device_clk"]

  detect_async_clk $cellpath $ip "ASYNC_CLK" $link_clk $device_clk
}

