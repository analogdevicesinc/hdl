# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_clkgen
adi_ip_files axi_clkgen [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mmcm_drp.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clkgen.v" \
  "bd/bd.tcl" \
  "axi_clkgen.v" ]

adi_ip_properties axi_clkgen
adi_ip_bd axi_clkgen "bd/bd.tcl"

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk2 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_0 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_1 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

set cc [ipx::current_core]
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

set param [ipx::add_user_parameter ENABLE_CLKIN2 $cc]
set_property -dict {value_resolve_type user value_format bool value false} $param

set param [ipgui::add_param -name {ENABLE_CLKIN2} -component $cc -parent $page0]
set_property -dict [list \
	display_name {Enable secondary clock input} \
	widget {checkBox} \
] $param

set param [ipx::add_user_parameter ENABLE_CLKOUT1 $cc]
set_property -dict {value_resolve_type user value_format bool value false} $param

set param [ipgui::add_param -name {ENABLE_CLKOUT1} -component $cc -parent $page0]
set_property -dict [list \
	display_name {Enable secondary clock output} \
	widget {checkBox} \
] $param

set part [get_property PART [current_project]]

# capture the device speedgrade
set speed [get_property SPEED $part]

switch $speed {
	-1   { set speed_enc 10 }
	-1L  { set speed_enc 11 }
	-1H  { set speed_enc 12 }
	-1HV { set speed_enc 13 }
	-1LV { set speed_enc 14 }
	-2   { set speed_enc 20 }
	-2L  { set speed_enc 21 }
	-2LV { set speed_enc 22 }
	-3   { set speed_enc 30 }
	default {
		puts "Undefined speed grade \"$speed\"!"
		exit -1
	}
}

set_property value $speed [ipx::get_user_parameters SPEED_GRADE -of_objects [ipx::current_core]]
set_property value $speed_enc [ipx::get_hdl_parameters SPEED_GRADE -of_objects [ipx::current_core]]
set_property enablement_value false [ipx::get_user_parameters SPEED_GRADE -of_objects [ipx::current_core]]

# capture device package
set package_string [get_property PACKAGE $part]

switch -regexp -- $package_string {
	^rf   { set package_enc 1  }
	^fl   { set package_enc 2  }
	^ff   { set package_enc 3  }
	^fb   { set package_enc 4  }
	^hc   { set package_enc 5  }
	^fh   { set package_enc 6  }
	^cs   { set package_enc 7  }
	^cp   { set package_enc 8  }
	^ft   { set package_enc 9  }
	^fg   { set package_enc 10 }
	^sb   { set package_enc 11 }
	^rb   { set package_enc 12 }
	^rs   { set package_enc 13 }
	^cl   { set package_enc 14 }
	^sf   { set package_enc 15 }
	^ba   { set package_enc 16 }
	^fa   { set package_enc 17 }
	default {
		puts "Undefined pakage \"$package_enc\"!"
		exit -1
	}
}

set_property value $package_string [ipx::get_user_parameters FPGA_DEV_PACKAGE -of_objects [ipx::current_core]]
set_property value $package_enc [ipx::get_hdl_parameters FPGA_DEV_PACKAGE -of_objects [ipx::current_core]]
set_property enablement_value false [ipx::get_user_parameters FPGA_DEV_PACKAGE -of_objects [ipx::current_core]]

set_property enablement_tcl_expr {$ENABLE_CLKIN2} [ipx::get_user_parameters CLKIN2_PERIOD -of_objects $cc]
set_property enablement_tcl_expr {$ENABLE_CLKOUT1} [ipx::get_user_parameters CLK1_DIV -of_objects $cc]
set_property enablement_tcl_expr {$ENABLE_CLKOUT1} [ipx::get_user_parameters CLK1_PHASE -of_objects $cc]

adi_set_ports_dependency clk2 ENABLE_CLKIN2 0
adi_set_ports_dependency clk_1 ENABLE_CLKOUT1

ipx::create_xgui_files $cc
ipx::save_core $cc
