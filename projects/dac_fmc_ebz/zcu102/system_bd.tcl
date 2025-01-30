###############################################################################
## Copyright (C) 2019-2023 Analog Devices Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_fifo_address_width 13

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

source ../common/dac_fmc_ebz_bd.tcl

if {[info exists ::env(ADI_LANE_RATE)]} {
  set ADI_LANE_RATE [get_env_param ADI_LANE_RATE 4.16]
} elseif {![info exists ADI_LANE_RATE]} {
  set ADI_LANE_RATE 4.16
}

# Common for both 12.5 and 15.4 GHz Lane Rate

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

if { $ADI_LANE_RATE == 15.4 } {
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG2       0xFC0
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG0       0x333C
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG4       0x45
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG2_G3    0xFC0
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_CLK25_DIV    15
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_PI_BIASSET   3
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.PPF0_CFG        0xF00
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_LPF        0x31D
} elseif { $ADI_LANE_RATE == 12.5 } {
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

  # channel
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RX_WIDEMODE_CDR           0x0
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXPI_CFG0                 0x3300
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXPI_CFG1                 0xFD
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG3_GEN4           0x12
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_CFG3                 0x0
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXDFE_PWR_SAVING          0x1
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXBUF_EN                  "TRUE"
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_DATA_WIDTH             40
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.ALIGN_MCOMMA_DET          "TRUE"
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.ALIGN_PCOMMA_DET          "TRUE"
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RX_DATA_WIDTH             40
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG3                0x12
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TXBUF_EN                  "TRUE"
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CH_HSPMUX                 0x3C3C
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG3_GEN3           0x12
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG3_GEN2           0x12
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.DEC_MCOMMA_DETECT         "TRUE"
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXGEARBOX_EN              "FALSE"
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG0                0x3
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_CFG2                 0x2
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.GEARBOX_MODE              0x0
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXBUF_THRESH_UNDFLW       3
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG2_GEN2           0x256
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.DEC_PCOMMA_DETECT         "TRUE"
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_CFG0                 0x1FA
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_CFG1                 0x23
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.c                         "FALSE"
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXCDR_CFG2_GEN4           0x164
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXGBOX_FIFO_INIT_RD_ADDR  4
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.PREIQ_FREQ_BST            0x0
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CBCC_DATA_SOURCE_SEL      "DECODED"
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.ALIGN_COMMA_ENABLE        0x3FF

  # pll_dividers
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_FBDIV_4_5            5
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_CLK25_DIV              9
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RXOUT_DIV                 1
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.RX_CLK25_DIV              5
    #ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_REFCLK_DIV           1
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_OUT_DIV                1
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.CPLL_FBDIV                2

} else {
    error "ADI_LANE_RATE must be either 4.16, 12.5 GHz or 15.4GHz"
}

ad_ip_parameter  dac_jesd204_link/tx   CONFIG.SYSREF_IOB         false
ad_ip_parameter  dac_dma               CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter  util_dac_jesd204_xcvr CONFIG.TX_LANE_INVERT     240

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
DEVICE_CODE=$ad_project_params(DEVICE_CODE)\
DAC_DEVICE=$ADI_DAC_DEVICE\
DAC_MODE=$ADI_DAC_MODE\
ADI_LANE_RATE=$ADI_LANE_RATE\
DAC_FIFO_ADDR_WIDTH=$dac_fifo_address_width"

sysid_gen_sys_init_file $sys_cstring
