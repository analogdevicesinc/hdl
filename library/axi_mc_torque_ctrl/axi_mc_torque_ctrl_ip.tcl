# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_mc_torque_ctrl
adi_ip_files axi_mc_torque_ctrl [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_drp_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_drp_cntrl.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "bldc_sim_fpga_cw.ngc" \
  "bldc_sim_fpga_cw.xdc" \
  "motor_driver.v" \
  "control_registers.v" \
  "bldc_sim_fpga_cw_bb.v" \
  "axi_mc_torque_ctrl.v" ]

adi_ip_properties axi_mc_torque_ctrl

ipx::save_core [ipx::current_core]


