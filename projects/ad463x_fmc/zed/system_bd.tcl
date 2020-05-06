
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

# specify the spi reference clock frequency in MHz
set spi_clk_ref_frequency 160

# specify ADC sampling rate in samples/seconds
set adc_sampling_rate 1000000

# add RTL source that will be instantiated in system_bd directly
adi_project_files ad463x_fmc_zed [list \
  "../common/ad463x_axis_reorder.v" \
]

# block design
source ../common/ad463x_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

