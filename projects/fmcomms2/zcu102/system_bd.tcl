###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_disconnect  gpio_i sys_ps8/emio_gpio_i
ad_disconnect  gpio_o sys_ps8/emio_gpio_o
ad_disconnect  gpio_t sys_ps8/emio_gpio_t

create_bd_port -dir I -from 93 -to 0 gpio_i
create_bd_port -dir O -from 93 -to 0 gpio_o
create_bd_port -dir O -from 93 -to 0 gpio_t

ad_connect  gpio_i sys_ps8/emio_gpio_i
ad_connect  gpio_o sys_ps8/emio_gpio_o
ad_connect  gpio_t sys_ps8/emio_gpio_t

ad_ip_parameter sys_ps8 CONFIG.PSU__NUM_FABRIC_RESETS {2}

source ../common/fmcomms2_bd.tcl


#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter util_ad9361_divclk CONFIG.SIM_DEVICE ULTRASCALE

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 11
ad_ip_parameter axi_ad9361 CONFIG.DELAY_REFCLK_FREQUENCY 500
