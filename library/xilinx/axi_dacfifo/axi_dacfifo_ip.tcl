# ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_dacfifo

adi_ip_files axi_dacfifo [list \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "$ad_hdl_dir/library/util_axis_resize/util_axis_resize.v" \
  "axi_dacfifo_constr.xdc" \
  "axi_dacfifo_dac.v" \
  "axi_dacfifo_wr.v" \
  "axi_dacfifo_rd.v" \
  "axi_dacfifo.v"]

adi_ip_properties_lite axi_dacfifo
adi_ip_constraints axi_dacfifo [list \
  "axi_dacfifo_constr.xdc" ]

ipx::infer_bus_interfaces {{xilinx.com:interface:aximm:1.0}} [ipx::current_core]

ipx::save_core [ipx::current_core]

