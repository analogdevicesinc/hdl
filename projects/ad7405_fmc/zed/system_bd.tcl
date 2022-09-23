source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# System clock is 100 MHz for this base design

set sys_cpu_clk_freq  100

# ADC external clock generator configurations, the reference clock is the
# system clock
# NOTE: For '7 Series' FPGAs the FVCO must be between 600 MHz and 12000 MHz

set clkgen_vco_div 5
set clkgen_vco_mul 50

# specify the external clock rate in MHz (MCLKIN)

set ext_clk_rate 25

source ../common/ad7405_bd.tcl

