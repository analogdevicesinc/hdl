###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

if {$INTF_CFG != "TX"} {
  ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
}
if {$INTF_CFG != "RX"} {
  ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1
}

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.SYS_CLK_SEL 0x0 ; # CPLL

ad_ip_parameter util_mxfe_xcvr   CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_mxfe_xcvr   CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_mxfe_xcvr   CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_mxfe_xcvr   CONFIG.RX_CLK25_DIV 20
ad_ip_parameter util_mxfe_xcvr   CONFIG.TX_CLK25_DIV 20
ad_ip_parameter util_mxfe_xcvr   CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_mxfe_xcvr   CONFIG.CPLL_CFG0 0x67f8
ad_ip_parameter util_mxfe_xcvr   CONFIG.CPLL_CFG1 0xa4ac
ad_ip_parameter util_mxfe_xcvr   CONFIG.CPLL_CFG2 0x0007
