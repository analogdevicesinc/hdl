
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source ../common/fmcomms2_bd.tcl

ad_ip_parameter util_ad9361_divclk CONFIG.SIM_DEVICE ULTRASCALE

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 11

