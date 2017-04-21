
source $ad_hdl_dir/projects/common/kc705/kc705_system_bd.tcl
source $ad_hdl_dir/projects/adv7511/common/adv7511_bd.tcl

ad_ip_parameter axi_hdmi_dma CONFIG.c_m_axi_mm2s_data_width 512
ad_ip_parameter axi_hdmi_dma CONFIG.c_m_axis_mm2s_tdata_width 64
