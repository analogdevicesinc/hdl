# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_mc_controller
adi_ip_files axi_mc_controller [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "motor_driver.v" \
  "delay.v" \
  "control_registers.v" \
  "axi_mc_controller_constr.xdc" \
  "axi_mc_controller.v" ]

adi_ip_properties axi_mc_controller

ipx::infer_bus_interface ref_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface ctrl_data_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]


