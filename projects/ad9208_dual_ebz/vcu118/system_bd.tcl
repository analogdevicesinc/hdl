###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## FIFO depth is 4Mb - 250k samples (65k samples per converter)
set adc_fifo_address_width 13

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source ../common/dual_ad9208_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

foreach i {0 1} {

  ad_ip_parameter util_adc_${i}_xcvr CONFIG.RX_CLK25_DIV 30
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.CPLL_CFG0 0x1fa
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.CPLL_CFG1 0x2b
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.CPLL_CFG2 0x2
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.CPLL_FBDIV 2
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.CH_HSPMUX 0x4040
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.PREIQ_FREQ_BST 1
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.RXPI_CFG0 0x3002

  ad_ip_parameter util_adc_${i}_xcvr CONFIG.QPLL_REFCLK_DIV 1
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.QPLL_CFG0 0x333c
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.QPLL_CFG4 0x2
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.QPLL_FBDIV 20
  ad_ip_parameter util_adc_${i}_xcvr CONFIG.PPF0_CFG 0xB00

}


