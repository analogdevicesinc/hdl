# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_adc_pack
adi_ip_files util_adc_pack [list \
  "util_adc_pack.v" ]

adi_ip_properties_lite util_adc_pack

ipx::remove_bus_interface {s} [ipx::current_core]
ipx::remove_bus_interface {m} [ipx::current_core]
ipx::remove_bus_interface {fifo} [ipx::current_core]
ipx::remove_bus_interface {signal_clock} [ipx::current_core]

ipx::remove_memory_map {m} [ipx::current_core]
ipx::remove_address_space {s} [ipx::current_core]
ipx::remove_address_space {fifo} [ipx::current_core]

for {set i 0} {$i < 8} {incr i} {
	foreach port {"chan_enable" "chan_valid" "chan_data"} {
		set name [format "%s_%d" $port $i]
		set_property ENABLEMENT_DEPENDENCY \
		"(spirit:decode(id('MODELPARAM_VALUE.CHANNELS')) > $i)" \
		[ipx::get_ports $name]
		set_property DRIVER_VALUE "0" [ipx::get_ports $name]
	}
}

ipx::save_core [ipx::current_core]
