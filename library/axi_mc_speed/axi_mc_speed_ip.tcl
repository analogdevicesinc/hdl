# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_mc_speed
adi_ip_files axi_mc_speed [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "debouncer.v" \
  "speed_detector.v" \
  "delay_30_degrees.v" \
  "axi_mc_speed_constr.xdc" \
  "axi_mc_speed.v" ]

adi_ip_properties axi_mc_speed

adi_ip_constraints axi_mc_speed [list \
  "axi_mc_speed_constr.xdc" ]

ipx::save_core [ipx::current_core]


