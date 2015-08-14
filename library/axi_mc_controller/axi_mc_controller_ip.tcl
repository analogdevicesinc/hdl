# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_mc_controller
adi_ip_files axi_mc_controller [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "motor_driver.v" \
  "delay.v" \
  "control_registers.v" \
  "axi_mc_controller_constr.xdc" \
  "axi_mc_controller.v" ]

adi_ip_properties axi_mc_controller

adi_ip_constraints axi_mc_controller [list \
  "axi_mc_controller_constr.xdc" ]

ipx::save_core [ipx::current_core]


