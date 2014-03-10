# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_rfifo
adi_ip_files util_rfifo [list \
  "util_rfifo.v" ]

adi_ip_properties_lite util_rfifo

ipx::remove_bus_interface {s} [ipx::current_core]
ipx::remove_bus_interface {m} [ipx::current_core]
ipx::remove_bus_interface {fifo} [ipx::current_core]
ipx::remove_bus_interface {signal_clock} [ipx::current_core]

ipx::remove_memory_map {m} [ipx::current_core]
ipx::remove_address_space {s} [ipx::current_core]
ipx::remove_address_space {fifo} [ipx::current_core]

ipx::save_core [ipx::current_core]


