###############################################################################
## Copyright (C) 2019-2025 Analog Devices Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_fifo_address_width 13

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

source ../common/ad916x_fmc_bd.tcl

if {[info exists ::env(ADI_LANE_RATE)]} {
  set ADI_LANE_RATE [get_env_param ADI_LANE_RATE 12.5]
} elseif {![info exists ADI_LANE_RATE]} {
  set ADI_LANE_RATE 12.5
}

set ADI_DEVICE_CODE $ad_project_params(DEVICE_CODE)

# Common for both 12.5 and 4.16 GHz Lane Rate

ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG3       0x120
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_FBDIV      40
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG1       0xD038
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG1_G3    0xD038
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_OUT_DIV      1
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TXPI_CFG        0x0
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.A_TXDIFFCTRL    0xC
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.POR_CFG         0x0
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CP         0xFF
ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CP_G3      0xF

if { $ADI_LANE_RATE == 12.5 } {
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG2       0xFC1
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG0       0x331C
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG4       0x4
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG2_G3    0xFC1
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_CLK25_DIV    13
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_PI_BIASSET   2
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.PPF0_CFG        0x800
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.PPF1_CFG        0x600
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_LPF        0x37F
} elseif { $ADI_LANE_RATE == 4.16 } {
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RX_WIDEMODE_CDR           0x0
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXPI_CFG0                 0x2102
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXPI_CFG1                 0x45
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG3_GEN4           0x12
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_CFG3                 0x0
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG3                0x12
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CH_HSPMUX                 0x2424
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG3_GEN3           0x12
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG3_GEN2           0x12
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG0                0x3
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_CFG2                 0x2
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG2_GEN2           0x256
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_CFG0                 0x1FA
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_CFG1                 0x23
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG2_GEN4           0x164
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_FBDIV_4_5            5
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_CLK25_DIV              9
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RX_CLK25_DIV              9
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_OUT_DIV                2
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_FBDIV                2
} else {
    error "ADI_LANE_RATE must be either 4.16 or 12.5 GHz"
}

ad_ip_parameter  dac_jesd204_link/tx   CONFIG.SYSREF_IOB         false
ad_ip_parameter  dac_dma               CONFIG.DMA_DATA_WIDTH_SRC 128

if { $ADI_DEVICE_CODE == 3 } {
  ad_ip_parameter  util_dac_jesd204_xcvr CONFIG.TX_LANE_INVERT     240
}

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set ADI_DAC_DEVICE $::env(ADI_DAC_DEVICE)
set ADI_DAC_MODE $::env(ADI_DAC_MODE)
set sys_cstring "JESD:M=$ad_project_params(JESD_M)\
L=$ad_project_params(JESD_L)\
S=$ad_project_params(JESD_S)\
NP=$ad_project_params(JESD_NP)\
LINKS=$ad_project_params(NUM_LINKS)\
DEVICE_CODE=$ADI_DEVICE_CODE\
DAC_DEVICE=$ADI_DAC_DEVICE\
DAC_MODE=$ADI_DAC_MODE\
ADI_LANE_RATE=$ADI_LANE_RATE\
DAC_FIFO_ADDR_WIDTH=$dac_fifo_address_width"

sysid_gen_sys_init_file $sys_cstring
