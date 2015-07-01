# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_dac_unpack
adi_ip_files util_dac_unpack [list \
  "util_dac_unpack.v" ]

adi_ip_properties_lite util_dac_unpack

ipx::remove_bus_interface {s} [ipx::current_core]
ipx::remove_bus_interface {m} [ipx::current_core]
ipx::remove_bus_interface {fifo} [ipx::current_core]
ipx::remove_bus_interface {signal_clock} [ipx::current_core]

ipx::remove_memory_map {m} [ipx::current_core]
ipx::remove_address_space {s} [ipx::current_core]
ipx::remove_address_space {fifo} [ipx::current_core]

for {set i 0} {$i < 8} {incr i} {
	foreach port {"dac_enable" "dac_valid" "dac_data"} {
		set name [format "%s_%.2d" $port $i]
		set_property ENABLEMENT_DEPENDENCY \
		"(spirit:decode(id('MODELPARAM_VALUE.CHANNELS')) > $i)" \
		[ipx::get_ports $name]
	}
	foreach port {"dac_enable" "dac_valid"} {
		set name [format "%s_%.2d" $port $i]
		set_property DRIVER_VALUE "0" [ipx::get_ports $name]
	}
}

adi_add_bus "fifo_rd" "master" \
	"analog.com:interface:fifo_rd_rtl:1.0" \
	"analog.com:interface:fifo_rd:1.0" \
	{ \
		{"dma_rd" "EN"} \
		{"dma_data" "DATA"} \
		{"fifo_valid" "VALID"} \
	}
adi_add_bus_clock "clk" "fifo_rd"

ipx::save_core [ipx::current_core]


