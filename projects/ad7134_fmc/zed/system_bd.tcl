
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

# specify ADC resolution -- the design supports 16/24/32 bit resolutions

set adc_resolution 24

# ADC number of channels

set adc_num_of_channels 8

source ../common/ad7134_bd.tcl
