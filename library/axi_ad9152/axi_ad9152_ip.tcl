# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_ad9152
adi_ip_files axi_ad9152 [list \
  "$ad_hdl_dir/library/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "axi_ad9152_channel.v" \
  "axi_ad9152_core.v" \
  "axi_ad9152_if.v" \
  "axi_ad9152_constr.xdc" \
  "axi_ad9152.v" ]

adi_ip_properties axi_ad9152

adi_ip_constraints axi_ad9152 [list \
  "axi_ad9152_constr.xdc" ]

ipx::save_core [ipx::current_core]

