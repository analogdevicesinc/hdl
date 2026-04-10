###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
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

ad_ip_parameter util_ad9083_xcvr CONFIG.RX_CLK25_DIV 15
ad_ip_parameter util_ad9083_xcvr CONFIG.TX_CLK25_DIV 15
ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG0 0x1fa
ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG1 0x2b
ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG2 0x2
ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_ad9083_xcvr CONFIG.CH_HSPMUX 0x4040
ad_ip_parameter util_ad9083_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_ad9083_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
ad_ip_parameter util_ad9083_xcvr CONFIG.RXPI_CFG0 0x3002
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG2 0x1E9
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG3 0x23
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG3_GEN2 0x23
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG3_GEN3 0x23
ad_ip_parameter util_ad9083_xcvr CONFIG.RXCDR_CFG3_GEN4 0x23
ad_ip_parameter util_ad9083_xcvr CONFIG.RX_WIDEMODE_CDR 0x1
ad_ip_parameter util_ad9083_xcvr CONFIG.RX_XMODE_SEL 0x0
ad_ip_parameter util_ad9083_xcvr CONFIG.TXDRV_FREQBAND 1
ad_ip_parameter util_ad9083_xcvr CONFIG.TXFE_CFG1 0xAA00
ad_ip_parameter util_ad9083_xcvr CONFIG.TXFE_CFG2 0xAA00
ad_ip_parameter util_ad9083_xcvr CONFIG.TXFE_CFG3 0xAA00
ad_ip_parameter util_ad9083_xcvr CONFIG.TXPI_CFG0 0x3100
ad_ip_parameter util_ad9083_xcvr CONFIG.TXPI_CFG1 0x0
ad_ip_parameter util_ad9083_xcvr CONFIG.TX_PI_BIASSET 1
ad_ip_parameter util_ad9083_xcvr CONFIG.RXPI_CFG1 0x54

ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG1 0xD038
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG1_G3 0xD038
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG2 0x0fc0
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG2_G3 0x0fc0
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG4 0x2
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_FBDIV 40
ad_ip_parameter util_ad9083_xcvr CONFIG.PPF0_CFG 0xB00
ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_LPF 0x31d

# ad_ip_parameter util_ad9083_xcvr CONFIG.RX_CLK25_DIV 15
# # ad_ip_parameter util_ad9083_xcvr CONFIG.RX_CLK25_DIV 30
# ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG0 0x1fa
# ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG1 0x2b
# ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_CFG2 0x2
# ad_ip_parameter util_ad9083_xcvr CONFIG.CPLL_FBDIV 2
# ad_ip_parameter util_ad9083_xcvr CONFIG.CH_HSPMUX 0x4040
# ad_ip_parameter util_ad9083_xcvr CONFIG.PREIQ_FREQ_BST 1
# ad_ip_parameter util_ad9083_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
# ad_ip_parameter util_ad9083_xcvr CONFIG.RXPI_CFG0 0x3002
# ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_REFCLK_DIV 1
# ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG0 0x333c
# ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_CFG4 0x2
# ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_FBDIV 40
# # ad_ip_parameter util_ad9083_xcvr CONFIG.QPLL_FBDIV 20
# ad_ip_parameter util_ad9083_xcvr CONFIG.PPF0_CFG 0xB00

# set_property -dict [list \
#   CONFIG.QPLL_REFCLK_DIV {1} \
#   CONFIG.RX_OUT_DIV {1} \
#   CONFIG.QPLL_CFG0 {0x333C} \
#   CONFIG.QPLL_CFG1 {0xD038} \
#   CONFIG.QPLL_CFG1_G3 {0xD038} \
#   CONFIG.QPLL_CFG2 {0x0fc0} \
#   CONFIG.QPLL_CFG2_G3 {0x0fc0} \
#   CONFIG.QPLL_CFG4 {0x2} \
#   CONFIG.QPLL_FBDIV {40} \
#   CONFIG.QPLL_FBDIV_RATIO {1} \
#   CONFIG.QPLL_LPF {0x31d} \
#   CONFIG.RX_CLK25_DIV {15} \
#   CONFIG.RX_LANE_RATE {15} \
#   CONFIG.TX_CLK25_DIV {15} \
#   CONFIG.TX_LANE_RATE {15} \
# ] [get_bd_cells util_ad9083_xcvr]

# set_property -dict [list \
#   CONFIG.CH_HSPMUX {0x4040} \
#   CONFIG.PREIQ_FREQ_BST {1} \
#   CONFIG.PPF0_CFG {0xB00} \
#   CONFIG.QPLL_REFCLK_DIV {1} \
#   CONFIG.RTX_BUF_CML_CTRL {0x5} \
#   CONFIG.QPLL_CFG0 {0x333C} \
#   CONFIG.QPLL_CFG1 {0xD038} \
#   CONFIG.QPLL_CFG1_G3 {0xD038} \
#   CONFIG.QPLL_CFG2 {0x0fc0} \
#   CONFIG.QPLL_CFG2_G3 {0x0fc0} \
#   CONFIG.QPLL_CFG4 {0x2} \
#   CONFIG.QPLL_FBDIV {40} \
#   CONFIG.QPLL_LPF {0x31d} \
#   CONFIG.RXPI_CFG0 {0x3002} \
#   CONFIG.RXPI_CFG1 {0x0054} \
#   CONFIG.RX_CLK25_DIV {15} \
#   CONFIG.RX_LANE_RATE {15} \
#   CONFIG.TX_CLK25_DIV {15} \
#   CONFIG.TX_LANE_RATE {15} \
# ] [get_bd_cells util_ad9083_xcvr]

# set_property -dict [list \
#   CONFIG.CH_HSPMUX {0x4040} \
#   CONFIG.PREIQ_FREQ_BST {1} \
#   CONFIG.PPF0_CFG {0xB00} \
#   CONFIG.QPLL_REFCLK_DIV {1} \
#   CONFIG.RX_OUT_DIV {1} \
#   CONFIG.RTX_BUF_CML_CTRL {0x5} \
#   CONFIG.QPLL_CFG0 {0x333C} \
#   CONFIG.QPLL_CFG1 {0xD038} \
#   CONFIG.QPLL_CFG1_G3 {0xD038} \
#   CONFIG.QPLL_CFG2 {0x0fc0} \
#   CONFIG.QPLL_CFG2_G3 {0x0fc0} \
#   CONFIG.QPLL_CFG4 {0x2} \
#   CONFIG.QPLL_FBDIV {40} \
#   CONFIG.QPLL_FBDIV_RATIO {1} \
#   CONFIG.QPLL_LPF {0x31d} \
#   CONFIG.RXCDR_CFG2 {0x01e9} \
#   CONFIG.RXCDR_CFG3 {0x0023} \
#   CONFIG.RXCDR_CFG3_GEN2 {0x23} \
#   CONFIG.RXCDR_CFG3_GEN3 {0x0023} \
#   CONFIG.RXCDR_CFG3_GEN4 {0x0023} \
#   CONFIG.RXPI_CFG0 {0x3002} \
#   CONFIG.RXPI_CFG1 {0x0054} \
#   CONFIG.RX_CLK25_DIV {15} \
#   CONFIG.RX_LANE_RATE {15} \
#   CONFIG.RX_WIDEMODE_CDR {0x1} \
#   CONFIG.RX_XMODE_SEL {"0"} \
#   CONFIG.TXDRV_FREQBAND {1} \
#   CONFIG.TXFE_CFG1 {0xAA00} \
#   CONFIG.TXFE_CFG2 {0xAA00} \
#   CONFIG.TXFE_CFG3 {0xAA00} \
#   CONFIG.TX_CLK25_DIV {15} \
#   CONFIG.TX_LANE_RATE {15} \
# ] [get_bd_cells util_ad9083_xcvr]
