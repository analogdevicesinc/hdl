# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_adcfifo
adi_ip_files util_adcfifo [list \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "util_adcfifo.v" \
  "util_adcfifo_constr.xdc" ]

adi_ip_properties_lite util_adcfifo
adi_ip_constraints util_adcfifo [list \
  "util_adcfifo_constr.xdc" ]

ipx::save_core [ipx::current_core]


