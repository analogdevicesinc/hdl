
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source ../common/adv7511_bd.tcl

set_property -dict [list CONFIG.PCORE_DEVICE_TYPE {1}] $axi_hdmi_core

