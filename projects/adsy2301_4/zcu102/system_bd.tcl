###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

source ../common/adsy2301_4_carrier_bd.tcl

# Reconfigure PS
# - Additional general SPI clock @ 10 MHz
set_property -dict [list \
  CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {20} \
  CONFIG.PSU__FPGA_PL3_ENABLE {1} \
] [get_bd_cells sys_ps8]

ad_connect sys_ps8/pl_clk3 cmd_spi/ext_spi_clk

# Interconnect

ad_cpu_interconnect 0x80000000 cmd_spi
ad_cpu_interconnect 0x80010000 gpio_ctrl

if {$ad_project_params(TDD_SUPPORT) == 1} {
  ad_cpu_interconnect 0x80020000 axi_tdd_carrier
}

# Interrupts

disconnect_bd_net /GND_1_dout [get_bd_pins sys_concat_intc_0/In5]
disconnect_bd_net /GND_1_dout [get_bd_pins sys_concat_intc_0/In6]
disconnect_bd_net /GND_1_dout [get_bd_pins sys_concat_intc_0/In7]
ad_ip_parameter sys_concat_intc_0 CONFIG.NUM_PORTS 5

ad_cpu_interrupt ps-0 mb-0 cmd_spi/ip2intc_irpt

# System ID

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 10
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 10

sysid_gen_sys_init_file
