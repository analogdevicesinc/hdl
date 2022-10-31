###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

if {$ad_project_params(SI_OR_PI) == 0} {
    set C_SI_OR_PI "SI"
} else {
    set C_SI_OR_PI "PI"
}

# system level parameters
set SER_PAR_N $ad_project_params(SER_PAR_N)

set sys_cstring "$C_SI_OR_PI\
SER_PAR_N=$SER_PAR_N\
ADC_SAMPLING_RATE=$adc_sampling_rate"

sysid_gen_sys_init_file $sys_cstring

adi_project_files ad7616_sdz_zed [list \
	"../../../library/common/ad_edge_detect.v" \
	"../../../library/util_cdc/sync_bits.v"]

source ../common/ad7616_bd.tcl
