
source $ad_hdl_dir/projects/common/ac701/ac701_system_bd.tcl
source $ad_hdl_dir/projects/adv7511/common/adv7511_bd.tcl

set_property -dict [list CONFIG.c_m_axi_mm2s_data_width {512}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
