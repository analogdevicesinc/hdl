###############################################################################
## Copyright (C) 2021 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

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

