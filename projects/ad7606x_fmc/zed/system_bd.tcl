
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

set DEV_CONFIG $ad_project_params(DEV_CONFIG)
set SIMPLE_STATUS_CRC $ad_project_params(SIMPLE_STATUS_CRC)
set EXT_CLK $ad_project_params(EXT_CLK)

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "$DEV_CONFIG,$SIMPLE_STATUS_CRC,$EXT_CLK"

sysid_gen_sys_init_file $sys_cstring

adi_project_files ad7606x_fmc_zed [list \
	"../../../library/common/ad_edge_detect.v" \
	"../../../library/util_cdc/sync_bits.v"]

source ../common/ad7606x_bd.tcl