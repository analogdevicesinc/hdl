
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

source ../common/pulsar_adc_pmdz_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set AD40XX_ADAQ400X_N [get_env_param AD40XX_ADAQ400X_N 1]
set sys_cstring "ad40xx: $AD40XX_ADAQ400X_N"
sysid_gen_sys_init_file $sys_cstring

