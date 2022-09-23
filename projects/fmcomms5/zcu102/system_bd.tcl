source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source ../common/fmcomms5_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter axi_ad9361_0 CONFIG.ADC_INIT_DELAY 8
ad_ip_parameter axi_ad9361_0 CONFIG.DELAY_REFCLK_FREQUENCY 500
ad_ip_parameter axi_ad9361_1 CONFIG.ADC_INIT_DELAY 8
ad_ip_parameter axi_ad9361_1 CONFIG.DELAY_REFCLK_FREQUENCY 500

ad_ip_parameter util_ad9361_divclk CONFIG.SIM_DEVICE ULTRASCALE
