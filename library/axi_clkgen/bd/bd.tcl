proc init {cellpath otherInfo} {
  set ip [get_bd_cells $cellpath]

  bd::mark_propagate_override $ip \
    "CLKIN_PERIOD CLKIN2_PERIOD"
}

proc axi_clkgen_get_infer_period {ip param clk_name} {
  set param_src [get_property "CONFIG.$param.VALUE_SRC" $ip]
  if {[string equal $param_src "USER"]} {
    return;
  }

  set clk [get_bd_pins "$ip/$clk_name"]
  set clk_freq [get_property CONFIG.FREQ_HZ $clk]

  if {$clk_freq != {}} {
    set clk_period [expr 1000000000.0 / $clk_freq]
    set_property "CONFIG.$param" [format "%.6f" $clk_period] $ip
  }
}

proc post_propagate {cellpath otherinfo} {
  set ip [get_bd_cells $cellpath]

  axi_clkgen_get_infer_period $ip CLKIN_PERIOD clk
  if {[get_property "CONFIG.ENABLE_CLKIN2" $ip] == "true"} {
    axi_clkgen_get_infer_period $ip CLKIN2_PERIOD clk2
  }
}
