###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_fifo_address_width 13

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/ad9166_ebz_bd.tcl

if {[info exists ::env(ADI_LANE_RATE)]} {
  set ADI_LANE_RATE [get_env_param ADI_LANE_RATE 12.5]
} elseif {![info exists ADI_LANE_RATE]} {
  set ADI_LANE_RATE 12.5
}

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

if { $ADI_LANE_RATE <= 12.5 } {
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG2       0xFC1
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG0       0x331C
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG4       0x4
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_CFG2_G3    0xFC1
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_CLK25_DIV    13
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.TX_PI_BIASSET   2
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.PPF0_CFG        0x800
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.PPF1_CFG        0x600
    ad_ip_parameter util_dac_jesd204_xcvr CONFIG.QPLL_LPF        0x37F
} else {
    error "ADI_LANE_RATE must be below 12.5 GHz!"
}

ad_ip_parameter  dac_jesd204_link/tx   CONFIG.SYSREF_IOB         false
ad_ip_parameter  dac_dma               CONFIG.DMA_DATA_WIDTH_SRC 128

ad_ip_parameter  util_dac_jesd204_xcvr CONFIG.TX_LANE_INVERT     240

create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0
set_property -dict [list \
  CONFIG.C_ADV_TRIGGER {false} \
  CONFIG.C_DATA_DEPTH {4096} \
  CONFIG.C_EN_STRG_QUAL {1} \
  CONFIG.C_MONITOR_TYPE {Native} \
  CONFIG.C_NUM_OF_PROBES {6} \
  CONFIG.C_PROBE0_WIDTH {128} \
  CONFIG.C_PROBE1_WIDTH {128} \
  CONFIG.C_TRIGIN_EN {false} \
  CONFIG.C_TRIGOUT_EN {false} \
] [get_bd_cells ila_0]
connect_bd_net [get_bd_pins ila_0/clk] [get_bd_pins util_dac_jesd204_xcvr/tx_out_clk_0]
connect_bd_net [get_bd_pins dac_upack/fifo_rd_data_0] [get_bd_pins ila_0/probe0]
connect_bd_net [get_bd_pins dac_upack/fifo_rd_data_1] [get_bd_pins ila_0/probe1]
connect_bd_net [get_bd_pins dac_upack/enable_0] [get_bd_pins ila_0/probe2]
connect_bd_net [get_bd_pins dac_upack/enable_1] [get_bd_pins ila_0/probe3]
connect_bd_net [get_bd_pins dac_upack/fifo_rd_underflow] [get_bd_pins ila_0/probe4]
connect_bd_net [get_bd_pins dac_upack/fifo_rd_valid] [get_bd_pins ila_0/probe5]

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set ADI_DAC_MODE [get_env_param ADI_DAC_MODE 08]
set sys_cstring "JESD:M=$ad_project_params(JESD_M)\
L=$ad_project_params(JESD_L)\
S=$ad_project_params(JESD_S)\
NP=$ad_project_params(JESD_NP)\
DAC_DEVICE=AD9166\
DAC_MODE=$ADI_DAC_MODE\
ADI_LANE_RATE=$ADI_LANE_RATE\
DAC_FIFO_ADDR_WIDTH=$dac_fifo_address_width"

sysid_gen_sys_init_file $sys_cstring
