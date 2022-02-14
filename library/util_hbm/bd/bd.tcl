proc init {cellpath otherInfo} {
	set ip [get_bd_cells $cellpath]

	bd::mark_propagate_only $ip \
		"NUM_M"
}

# Executed when you close the config window
proc post_config_ip {cellpath otherinfo} {
	set ip [get_bd_cells $cellpath]

  set num_m [get_property "CONFIG.NUM_M" $ip]
  for {set idx 0} {$idx < $num_m} {incr idx} {

    set intf [get_bd_intf_pins [format "%s/MAXI_%d" $cellpath $idx]]
	
    # TODO : set correct values here
    set_property CONFIG.NUM_WRITE_OUTSTANDING 16 $intf
		set_property CONFIG.NUM_READ_OUTSTANDING  16 $intf

  }
}

# Executed when the block design is validated
proc propagate {cellpath otherinfo} {
	set ip [get_bd_cells $cellpath]

#  set src_data_width [get_property "CONFIG.SRC_DATA_WIDTH" $ip]
#  set axi_data_width [get_property "CONFIG.AXI_DATA_WIDTH" $ip]
#
#  set num_m [expr round(${src_data_width}.0 / ${axi_data_width}.0)]
#  puts "????????? $num_m ????????"
#	set_property "CONFIG.NUM_M" $num_m $ip
}
