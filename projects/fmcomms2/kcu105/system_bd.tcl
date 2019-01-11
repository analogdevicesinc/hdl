
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_mig.tcl
source ../common/fmcomms2_bd.tcl

ad_ip_parameter util_ad9361_divclk CONFIG.SIM_DEVICE ULTRASCALE

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 11

