###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# System clock is 100 MHz for this base design

set sys_cpu_clk_freq  100

# ADC external clock generator configurations, the reference clock is the
# system clock
# NOTE: For '7 Series' FPGAs the FVCO must be between 600 MHz and 12000 MHz

set clkgen_vco_div 1
set clkgen_vco_mul 10

# specify the external clock rate in MHz (MCLKIN)

set ext_clk_rate 20

source ../common/ad7405_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "SYS_CPU_CLK_FREQ=$sys_cpu_clk_freq\
CLKGEN_VCO_DIV=$clkgen_vco_div\
CLKGEN_VCO_MUL=$clkgen_vco_mul\
EXT_CLK_RATE=$ext_clk_rate\
LVDS_CMOS_N=$ad_project_params(LVDS_CMOS_N) "

sysid_gen_sys_init_file $sys_cstring
