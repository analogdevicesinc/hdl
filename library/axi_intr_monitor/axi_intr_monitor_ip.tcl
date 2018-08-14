# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_intr_monitor
adi_ip_files axi_intr_monitor [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_intr_monitor.v" ]

adi_ip_properties axi_intr_monitor

ipx::infer_bus_interface irq xilinx.com:signal:interrupt_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]


