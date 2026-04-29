###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/coraz7s/coraz7s_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# Remove unused I2C IP from base design (AD5529R is SPI-only)
delete_bd_objs [get_bd_intf_nets axi_iic_ard_IIC] [get_bd_intf_ports iic_ard]
delete_bd_objs [get_bd_nets axi_iic_ard_iic2intc_irpt] \
               [get_bd_intf_nets axi_gp0_interconnect_M00_AXI] \
               [get_bd_cells axi_iic_ard]

# System ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

source ../common/ad5529r_ardz_bd.tcl
