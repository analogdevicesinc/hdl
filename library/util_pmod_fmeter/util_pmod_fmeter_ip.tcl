# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_pmod_fmeter
adi_ip_files util_pmod_fmeter [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_pmod.v" \
  "util_pmod_fmeter.v" \
  "util_pmod_fmeter_core.v"]

adi_ip_properties util_pmod_fmeter

ipx::save_core [ipx::current_core]

