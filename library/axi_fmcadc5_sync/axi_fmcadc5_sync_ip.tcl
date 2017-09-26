# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_fmcadc5_sync
adi_ip_files axi_fmcadc5_sync [list \
  "$ad_hdl_dir/library/xilinx/common/ad_data_out.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_fmcadc5_sync_constr.xdc" \
  "axi_fmcadc5_sync_calcor.v" \
  "axi_fmcadc5_sync.v" ]

adi_ip_properties axi_fmcadc5_sync
ipx::save_core [ipx::current_core]

