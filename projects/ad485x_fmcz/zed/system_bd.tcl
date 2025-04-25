##############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/ad485x_fmcz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

delete_bd_objs [get_bd_nets spi1_clk_i_1] \
               [get_bd_nets sys_ps7_SPI1_SCLK_O] \
               [get_bd_nets spi1_sdo_i_1] \
               [get_bd_nets sys_ps7_SPI1_MOSI_O] \
               [get_bd_nets spi1_sdi_i_1] \
               [get_bd_nets spi1_csn_i_1] \
               [get_bd_nets sys_ps7_SPI1_SS_O] \
               [get_bd_nets sys_ps7_SPI1_SS1_O] \
               [get_bd_nets sys_ps7_SPI1_SS2_O]

# Connect SPI1 to MIO pins JE1 PMOD
ad_ip_parameter sys_ps7 PCW_SPI1_SPI1_IO {MIO 10 .. 15}
ad_ip_parameter sys_ps7 PCW_QSPI_GRP_SINGLE_SS_ENABLE 1

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "LVDS_CMOS_N=$LVDS_CMOS_N, DEVICE=$DEVICE"
sysid_gen_sys_init_file $sys_cstring
