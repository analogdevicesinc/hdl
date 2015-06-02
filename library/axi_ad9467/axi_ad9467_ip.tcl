# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_ad9467
adi_ip_files axi_ad9467 [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_lvds_clk.v" \
  "$ad_hdl_dir/library/common/ad_lvds_in.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_ad9467_pnmon.v" \
  "axi_ad9467_if.v" \
  "axi_ad9467_channel.v" \
  "axi_ad9467_constr.xdc" \
  "axi_ad9467.v"]

adi_ip_properties axi_ad9467

adi_ip_constraints axi_ad9467 [list \
  "axi_ad9467_constr.xdc" ]

ipx::save_core [ipx::current_core]
