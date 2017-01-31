# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_logic_analyzer
adi_ip_files axi_logic_analyzer [list \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_logic_analyzer_constr.xdc" \
  "axi_logic_analyzer_reg.v" \
  "axi_logic_analyzer_trigger.v" \
  "axi_logic_analyzer.v" ]

adi_ip_properties axi_logic_analyzer
adi_ip_constraints axi_logic_analyzer [list \
  "axi_logic_analyzer_constr.xdc" ]

ipx::remove_bus_interface {clk} [ipx::current_core]
ipx::associate_bus_interfaces -busif s_axi -clock s_axi_aclk [ipx::current_core]

ipx::save_core [ipx::current_core]

