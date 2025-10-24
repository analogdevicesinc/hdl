###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc init {cellpath otherInfo} {
	set ip [get_bd_cells $cellpath]

	bd::mark_propagate_overrideable $ip \
		"ASYNC_CLK"

	bd::mark_propagate_overrideable $ip \
		"DATA_WIDTH TLAST_EN TKEEP_EN TSTRB_EN TUSER_WIDTH TID_WIDTH TDEST_WIDTH"

	set_property CONFIG.FREQ_HZ.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/m_axis_aclk]
	set_property CONFIG.FREQ_HZ.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/s_axis_aclk]
}

proc async_clock_check {cellpath} {
	set ip [get_bd_cells $cellpath]

	set input_clk [get_bd_pins "$ip/m_axis_aclk"]
	set output_clk [get_bd_pins "$ip/s_axis_aclk"]

	set param_src [get_property "CONFIG.ASYNC_CLK.VALUE_SRC" $ip]
	if {[string equal $param_src "USER"]} {
		return;
	}

	set clk_domain_a [get_property CONFIG.CLK_DOMAIN $input_clk]
	set clk_domain_b [get_property CONFIG.CLK_DOMAIN $output_clk]
	set clk_freq_a [get_property CONFIG.FREQ_HZ $input_clk]
	set clk_freq_b [get_property CONFIG.FREQ_HZ $output_clk]
	set clk_phase_a [get_property CONFIG.PHASE $input_clk]
	set clk_phase_b [get_property CONFIG.PHASE $output_clk]

	# Only mark it as sync if we can make sure that it is sync, if the
	# relationship of the clocks is unknown mark it as async
	if {$clk_domain_a != {} && $clk_domain_b != {} && \
		$clk_domain_a == $clk_domain_b && $clk_freq_a == $clk_freq_b && \
		$clk_phase_a == $clk_phase_b} {
		set clk_async 0
	} else {
		set clk_async 1
	}

	set_property "CONFIG.ASYNC_CLK" $clk_async $ip
}

proc parameter_set {cellpath} {
	set ip [get_bd_cells $cellpath]
	set interface_pin_source [find_bd_objs -relation connected_to [get_bd_intf_pins -of_objects $ip -filter {NAME =~ s_axis}]]

	set data_width [get_property "CONFIG.TDATA_NUM_BYTES" $interface_pin_source]
	set_property "CONFIG.DATA_WIDTH" [expr $data_width * 8] $ip

	set tlast_en [get_property "CONFIG.HAS_TLAST" $interface_pin_source]
	set_property "CONFIG.TLAST_EN" $tlast_en $ip

	set tkeep_en [get_property "CONFIG.HAS_TKEEP" $interface_pin_source]
	set_property "CONFIG.TKEEP_EN" $tkeep_en $ip

	set tstrb_en [get_property "CONFIG.HAS_TSTRB" $interface_pin_source]
	set_property "CONFIG.TSTRB_EN" $tstrb_en $ip

	set tuser_width [get_property "CONFIG.TUSER_WIDTH" $interface_pin_source]
	set_property "CONFIG.TUSER_WIDTH" $tuser_width $ip

	set tid_width [get_property "CONFIG.TID_WIDTH" $interface_pin_source]
	set_property "CONFIG.TID_WIDTH" $tid_width $ip

	set tdest_width [get_property "CONFIG.TDEST_WIDTH" $interface_pin_source]
	set_property "CONFIG.TDEST_WIDTH" $tdest_width $ip
}

proc pre_propagate {cellpath otherinfo} {

}

proc propagate {cellpath otherinfo} {
	parameter_set $cellpath
}

proc post_propagate {cellpath otherinfo} {
	async_clock_check $cellpath
}
