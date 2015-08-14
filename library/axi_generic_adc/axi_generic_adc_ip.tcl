# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_generic_adc
adi_ip_files axi_generic_adc [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "axi_generic_adc.v" \
]

adi_ip_properties axi_generic_adc

ipx::save_core [ipx::current_core]


