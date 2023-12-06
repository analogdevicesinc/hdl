###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr 64*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr 64*1024]

## NOTE: With this configuration the #36Kb BRAM utilization is at ~57%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring;

source ../common/adrv9026_bd.tcl

ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_adrv9026_xcvr CONFIG.A_TXDIFFCTRL 0xC
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG0 0x3
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG2_GEN2 0x269
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG2_GEN4 0x164
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG3 0x12
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG3_GEN3 0x12
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
ad_ip_parameter util_adrv9026_xcvr CONFIG.CH_HSPMUX 0x4040
ad_ip_parameter util_adrv9026_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXPI_CFG0 0x3002
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXPI_CFG1 0x54
ad_ip_parameter util_adrv9026_xcvr CONFIG.POR_CFG 0x0
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_FBDIV 33
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CFG1 0xD038
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CFG2 0xFC0
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CFG3 0x120
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CFG4 0x2
ad_ip_parameter util_adrv9026_xcvr CONFIG.PPF0_CFG 0xB00
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CP 0xFF
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CP_G3 0xF
ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_LPF 0x31D
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_CLK25_DIV 20
ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_CLK25_DIV 20
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_PMA_CFG 0x280A
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXDFE_KH_CFG2 0x200
ad_ip_parameter util_adrv9026_xcvr CONFIG.RXDFE_KH_CFG3 0x4101 
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_WIDEMODE_CDR 1 
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_XMODE_SEL 0 


