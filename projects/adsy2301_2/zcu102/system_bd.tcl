###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

source ../common/adsy2301_2_bd.tcl

# Reconfigure PS
# - Additional general SPI clock @ 6.25 MHz
set_property -dict [list \
  CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {12.5} \
  CONFIG.PSU__FPGA_PL3_ENABLE {1} \
] [get_bd_cells sys_ps8]

ad_connect sys_ps8/pl_clk3 bf_spi_01/ext_spi_clk
ad_connect sys_ps8/pl_clk3 bf_spi_02/ext_spi_clk
ad_connect sys_ps8/pl_clk3 fmc_spi_03/ext_spi_clk
ad_connect sys_ps8/pl_clk3 fmc_spi_04/ext_spi_clk

ad_connect sys_ps8/pl_clk3 xud_spi/ext_spi_clk

# Interconnect

ad_cpu_interconnect 0x80000000 bf_spi_01
ad_cpu_interconnect 0x80010000 bf_spi_02
ad_cpu_interconnect 0x80020000 fmc_spi_03
ad_cpu_interconnect 0x80030000 fmc_spi_04

ad_cpu_interconnect 0x80040000 axi_bf_iic_01
ad_cpu_interconnect 0x80050000 axi_bf_iic_02
ad_cpu_interconnect 0x80060000 axi_bf_iic_03
ad_cpu_interconnect 0x80070000 axi_bf_iic_04

ad_cpu_interconnect 0x80080000 xud_spi

ad_cpu_interconnect 0x80090000 gpio_0

# Interrupts

ad_cpu_interrupt ps-0 mb-0 bf_spi_01/ip2intc_irpt
ad_cpu_interrupt ps-1 mb-1 bf_spi_02/ip2intc_irpt
ad_cpu_interrupt ps-2 mb-2 fmc_spi_03/ip2intc_irpt
ad_cpu_interrupt ps-3 mb-3 fmc_spi_04/ip2intc_irpt

ad_cpu_interrupt ps-4 mb-4 axi_bf_iic_01/iic2intc_irpt
ad_cpu_interrupt ps-5 mb-5 axi_bf_iic_02/iic2intc_irpt
ad_cpu_interrupt ps-6 mb-6 axi_bf_iic_03/iic2intc_irpt
ad_cpu_interrupt ps-7 mb-7 axi_bf_iic_04/iic2intc_irpt

ad_cpu_interrupt ps-8 mb-8 xud_spi/ip2intc_irpt
