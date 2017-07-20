# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_adc_trigger
adi_ip_files axi_adc_trigger [list \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_adc_trigger_constr.xdc" \
  "axi_adc_trigger_reg.v" \
  "axi_adc_trigger.v" ]

adi_ip_properties axi_adc_trigger
adi_ip_constraints axi_adc_trigger [list \
  "axi_adc_trigger_constr.xdc" ]

ipx::remove_bus_interface {clk} [ipx::current_core]
ipx::associate_bus_interfaces -busif s_axi -clock s_axi_aclk [ipx::current_core]

ipx::save_core [ipx::current_core]

