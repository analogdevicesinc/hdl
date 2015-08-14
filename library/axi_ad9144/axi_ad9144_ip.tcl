# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_ad9144
adi_ip_files axi_ad9144 [list \
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
  "axi_ad9144_channel.v" \
  "axi_ad9144_core.v" \
  "axi_ad9144_if.v" \
  "axi_ad9144.v" \
  "axi_ad9144_constr.xdc" ]

adi_ip_properties axi_ad9144

adi_ip_constraints axi_ad9144 [list \
  "axi_ad9144_constr.xdc" ]

ipx::save_core [ipx::current_core]

