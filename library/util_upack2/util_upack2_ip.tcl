# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_upack2
adi_ip_files util_upack2 [list \
  "pack_interconnect.v" \
  "pack_ctrl.v" \
  "util_upack2_impl.v" \
  "util_upack2.v" ]

adi_ip_properties_lite util_upack2

adi_add_bus "s_axis" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"s_axis_ready" "TREADY"} \
	  {"s_axis_valid" "TVALID"} \
	  {"s_axis_data" "TDATA"} \
  ]
adi_add_bus_clock "clk" "s_axis"

for {set i 1} {$i < 8} {incr i} {
  set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > $i" \
    [ipx::get_ports *_$i* -of_objects [ipx::current_core]]
}

ipx::save_core [ipx::current_core]
