
source $ad_hdl_dir/projects/common/ac701/ac701_system_bd.tcl
set_property -dict [list CONFIG.NUM_MI {7}] $axi_cpu_interconnect
set_property -dict [list CONFIG.NUM_SI {8}] $axi_mem_interconnect
set_property -dict [list CONFIG.NUM_MI {1}] $axi_mem_interconnect
set_property -dict [list CONFIG.c_m_axi_mm2s_data_width {512}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma

