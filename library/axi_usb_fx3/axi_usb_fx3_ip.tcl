# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_usb_fx3
adi_ip_files axi_usb_fx3 [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_usb_fx3_core.v" \
  "axi_usb_fx3_if.v" \
  "axi_usb_fx3_reg.v" \
  "axi_usb_fx3.v"]

adi_ip_properties axi_usb_fx3
adi_ip_infer_streaming_interfaces axi_usb_fx3

adi_add_bus_clock "s_axi_aclk" "s_axis"
adi_add_bus_clock "s_axi_aclk" "m_axis"

ipx::save_core [ipx::current_core]
