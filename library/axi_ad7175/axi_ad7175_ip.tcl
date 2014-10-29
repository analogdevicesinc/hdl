# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_ad7175
adi_ip_files axi_ad7175 [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_drp_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "up_adc_common.v" \
  "ad_datafmt.v" \
  "ad7175_if.v" \
  "axi_ad7175.v" \
  "axi_ad7175_channel.v" \
  "clk_div.v" ]

adi_ip_properties axi_ad7175

ipx::save_core [ipx::current_core]


