###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## FIFO depth is 8Mb - 500k samples
set dac_fifo_address_width 16

## NOTE: With this configuration the #36Kb BRAM utilization is at ~68%

source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_mig.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT3_FREQ_HZ 200

source ../common/adrv9371x_bd.tcl

ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_ad9371_xcvr CONFIG.CPLL_CFG0 0x67f8
ad_ip_parameter util_ad9371_xcvr CONFIG.CPLL_CFG1 0xa4ac
ad_ip_parameter util_ad9371_xcvr CONFIG.CPLL_CFG2 0x0007

