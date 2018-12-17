
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/flock_bd.tcl


ad_ip_parameter axi_hdmi_dma CONFIG.ENABLE_FRAME_LOCK 1


ad_connect axi_tpg_dma/m_framelock axi_hdmi_dma/s_framelock

set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {axi_tpg_dma_m_framelock }]

