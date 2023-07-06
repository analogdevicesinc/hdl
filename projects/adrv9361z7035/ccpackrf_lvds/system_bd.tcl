###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../common/adrv9361z7035_bd.tcl
source ../common/ccpackrf_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

cfg_ad9361_interface LVDS

create_bd_port -dir O sys_cpu_clk_out
ad_connect  sys_cpu_clk sys_cpu_clk_out

set_property CONFIG.ADC_INIT_DELAY 29 [get_bd_cells axi_ad9361]

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file
