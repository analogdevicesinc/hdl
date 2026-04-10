###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source ../common/ad9083_evb_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:L=$ad_project_params(RX_JESD_L)\
M=$ad_project_params(RX_JESD_M)\
S=$ad_project_params(RX_JESD_S)"

sysid_gen_sys_init_file $sys_cstring

# GTHE4 parameters for 15 Gbps lane rate with 375 MHz refclk
ad_ip_parameter util_ad9083_xcvr CONFIG.RX_CLK25_DIV 15
ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG0 0x1fa
ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG1 0x23
ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG2 0x2
ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_ad9083_xcvr CONFIG.CH_HSPMUX 0x6868
ad_ip_parameter util_ad9083_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_ad9083_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
ad_ip_parameter util_ad9083_xcvr CONFIG.RXPI_CFG0 0x4
ad_ip_parameter util_ad9083_xcvr CONFIG.RXPI_CFG1 0x0
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG0 0x3
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG2 0x1E9
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG2_GEN2 0x265
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG2_GEN4 0x164
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG3 0x1A
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG3_GEN2 0x1A
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG3_GEN3 0x1A
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
ad_ip_parameter util_ad9083_xcvr CONFIG.RX_WIDEMODE_CDR 0x1
ad_ip_parameter util_ad9083_xcvr CONFIG.RX_XMODE_SEL 0x0

# QPLL parameters for GTHE4 at 15 GHz VCO (375 MHz * 40)
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG1 0xD038
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG1_G3 0xD038
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG2 0x0fc0
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG2_G3 0x0fc0
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG4 0x45
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_FBDIV 40
ad_ip_parameter util_ad9083_xcvr CONFIG.PPF0_CFG 0xF00
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_LPF 0x31d
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CP 0xFF
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CP_G3 0xF
