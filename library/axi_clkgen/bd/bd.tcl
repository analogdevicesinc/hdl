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

proc propagate {cellpath otherinfo} {
  set ip [get_bd_cells $cellpath]

  set vco_mul [get_property CONFIG.VCO_MUL $ip]
  set vco_div [get_property CONFIG.VCO_DIV $ip]
  set clk0_div [get_property CONFIG.CLK0_DIV $ip]
  set clk1_div [get_property CONFIG.CLK1_DIV $ip]

  if {$vco_mul == {} || $vco_mul < 1} {
    set vco_mul 1
  }
  if {$vco_div == {} || $vco_div < 1} {
    set vco_div 1
  }
  if {$clk0_div == {} || $clk0_div < 1} {
    set clk0_div 1
  }
  if {$clk1_div == {} || $clk0_div < 1} {
    set clk1_div 1
  }

  set clk [get_bd_pins "$ip/clk"]
  set clk_freq [get_property CONFIG.FREQ_HZ $clk]
  if {[get_property "CONFIG.ENABLE_CLKIN2" $ip] == "true"} {
    set clk2 [get_bd_pins "$ip/clk"]
    set clk2_freq [get_property CONFIG.FREQ_HZ $clk2]
    # Use the larger of the two
    if {$clk_freq == {} || $clk2_freq > $clk_freq} {
      set clk_freq $clk2_freq
    }
  }

  if {$clk_freq != {}} {
    set clk0_out [get_bd_pins "$ip/clk_0"]
    set clk0_out_freq [expr ($clk_freq + 0.0) * $vco_mul / ($vco_div * $clk0_div)]
    set_property CONFIG.FREQ_HZ $clk0_out_freq $clk0_out

    if {[get_property "CONFIG.ENABLE_CLKOUT1" $ip] == "true"} {
      set clk0_out [get_bd_pins "$ip/clk_1"]
      set clk1_out_freq [expr ($clk_freq + 0.0) * $vco_mul / ($vco_div * $clk1_div)]
      set_property CONFIG.FREQ_HZ $clk1_out_freq $clk1_out
    }
  }
}

proc post_propagate {cellpath otherinfo} {
  set ip [get_bd_cells $cellpath]

  axi_clkgen_get_infer_period $ip CLKIN_PERIOD clk
  if {[get_property "CONFIG.ENABLE_CLKIN2" $ip] == "true"} {
    axi_clkgen_get_infer_period $ip CLKIN2_PERIOD clk2
  }
}
