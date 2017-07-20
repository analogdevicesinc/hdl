
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source ../common/fmcomms2_bd.tcl

set_property -dict [list CONFIG.SIM_DEVICE {ULTRASCALE}] $clkdiv

set_property CONFIG.DEVICE_TYPE 2 [get_bd_cells axi_ad9361]

