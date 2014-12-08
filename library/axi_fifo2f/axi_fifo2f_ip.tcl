# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_fifo2f
adi_ip_files axi_fifo2f [list \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "axi_fifo2f.v" \
  "axi_fifo2f_constr.xdc" ]

adi_ip_properties_lite axi_fifo2f
adi_ip_constraints axi_fifo2f [list \
  "axi_fifo2f_constr.xdc" ]

ipx::save_core [ipx::current_core]


