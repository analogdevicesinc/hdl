# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_usb_fx3
adi_ip_files axi_usb_fx3 [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_usb_fx3_core.v" \
  "axi_usb_fx3_if.v" \
  "axi_usb_fx3_reg.v" \
  "axi_usb_fx3.v"]

adi_ip_properties axi_usb_fx3

adi_ip_infer_streaming_interfaces axi_usb_fx3

ipx::associate_bus_interfaces -busif m_axis -clock s_axi_aclk [ipx::current_core]
ipx::associate_bus_interfaces -busif s_axis -clock s_axi_aclk [ipx::current_core]

ipx::save_core [ipx::current_core]
