###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../../hdl/scripts/adi_env.tcl
source ../../../../hdl/projects/scripts/adi_project_intel.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make JESD_MODE=64B66B RX_LANE_RATE=10.3125 TX_LANE_RATE=10.3125 RX_JESD_M=4 TX_JESD_M=4 RX_JESD_L=8 TX_JESD_L=8 RX_JESD_S=1 TX_JESD_S=1 RX_JESD_NP=16 TX_JESD_NP=16
#

#
# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#
#   REF_CLK_RATE : Reference clock frequency in MHz, should be Lane Rate / 66 for JESD204C or Lane Rate / 40 for JESD204B
#   DEVICE_CLK_RATE : Device clock frequency in MHz, usually the same as REF_CLK_RATE but it can vary based on the JESD configuration
#   ENABLE_HSCI : If set, adds and enables the HSCI core in the design
#   RX_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA )
#   TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links - only when ASYMMETRIC_A_B_MODE = 0
#   [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M)
#   ASYMMETRIC_A_B_MODE : When set, each Apollo side has its own JESD link
#   RX_B_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA ) for B side
#   TX_B_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo ) for B side
#   [RX/TX]_B_JESD_M : Number of converters per link for B side
#   [RX/TX]_B_JESD_L : Number of lanes per link for B side
#   [RX/TX]_B_JESD_NP : Number of bits per sample for B side
#   [RX/TX]_B_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M) for B side
#
# !!! Requires the following hdl branch: https://github.com/analogdevicesinc/hdl/tree/dev_fm87_avlfifo
#

adi_project ad9084_fmca_ebz_fm87 [list \
  JESD_MODE           [get_env_param JESD_MODE       64B66B ] \
  REF_CLK_RATE        [get_env_param REF_CLK_RATE     312.5 ] \
  DEVICE_CLK_RATE     [get_env_param DEVICE_CLK_RATE  312.5 ] \
  RX_LANE_RATE        [get_env_param RX_LANE_RATE    20.625 ] \
  TX_LANE_RATE        [get_env_param TX_LANE_RATE    20.625 ] \
  RX_JESD_M           [get_env_param RX_JESD_M            4 ] \
  RX_JESD_L           [get_env_param RX_JESD_L            8 ] \
  RX_JESD_S           [get_env_param RX_JESD_S            1 ] \
  RX_JESD_NP          [get_env_param RX_JESD_NP          16 ] \
  RX_NUM_LINKS        [get_env_param RX_NUM_LINKS         2 ] \
  TX_JESD_M           [get_env_param TX_JESD_M            4 ] \
  TX_JESD_L           [get_env_param TX_JESD_L            8 ] \
  TX_JESD_S           [get_env_param TX_JESD_S            1 ] \
  TX_JESD_NP          [get_env_param TX_JESD_NP          16 ] \
  TX_NUM_LINKS        [get_env_param TX_NUM_LINKS         2 ] \
  RX_KS_PER_CHANNEL   [get_env_param RX_KS_PER_CHANNEL   16 ] \
  TX_KS_PER_CHANNEL   [get_env_param TX_KS_PER_CHANNEL   16 ] \
]

# source common_assign.tcl

source $ad_hdl_dir/projects/common/fm87/fm87_system_assign.tcl
source $ad_hdl_dir/projects/common/fm87/fm87_plddr_system_assign.tcl

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_3w_spi.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_iobuf.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/projects/common/fm87/gpio_slave.v
set_global_assignment -name VERILOG_FILE ../common/ad9084_fmca_ebz_spi.v

set_instance_assignment -name IO_STANDARD "CURRENT MODE LOGIC (CML)"    -to fpga_refclk_in
set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to syncinb_a0
set_instance_assignment -name IO_STANDARD "Differential 1.2-V HSTL"     -to syncoutb_a0
set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to sysref_in
set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to device_clk

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to syncinb_a0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref_in

set_location_assignment PIN_CN56 -to "fpga_refclk_in"    ; ## D4  GBTCLK0_M2C_P
set_location_assignment PIN_CP57 -to "fpga_refclk_in(n)" ; ## D5  GBTCLK0_M2C_N

set_location_assignment PIN_DD47 -to "device_clk"         ; ## G2  C_FMC_B_CLK1_P
set_location_assignment PIN_DE48 -to "device_clk(n)"      ; ## G3  C_FMC_B_CLK1_N

# For some reason the F-tile IP reverses the order...
set_location_assignment PIN_BK63 -to tx_data_p[0]      ; ## M22  FGTL12A_TX_Q3_CH3P  FMC_B_TX_P_15  SRXA_11P_FMC
set_location_assignment PIN_BL62 -to tx_data_n[0]      ; ## M23  FGTL12A_TX_Q3_CH3N  FMC_B_TX_N_15  SRXA_11N_FMC
set_location_assignment PIN_BN60 -to tx_data_p[1]      ; ## M18  FGTL12A_TX_Q3_CH2P  FMC_B_TX_P_14  SRXA_9P_FMC
set_location_assignment PIN_BM59 -to tx_data_n[1]      ; ## M19  FGTL12A_TX_Q3_CH2N  FMC_B_TX_N_14  SRXA_9N_FMC
set_location_assignment PIN_BP63 -to tx_data_p[2]      ; ## Y30  FGTL12A_TX_Q3_CH1P  FMC_B_TX_P_13  SRXA_8P_FMC
set_location_assignment PIN_BR62 -to tx_data_n[2]      ; ## Y31  FGTL12A_TX_Q3_CH1N  FMC_B_TX_N_13  SRXA_8N_FMC
set_location_assignment PIN_BU60 -to tx_data_p[3]      ; ## Z28  FGTL12A_TX_Q3_CH0P  FMC_B_TX_P_12  SRXA_10P_FMC
set_location_assignment PIN_BT59 -to tx_data_n[3]      ; ## Z29  FGTL12A_TX_Q3_CH0N  FMC_B_TX_N_12  SRXA_10N_FMC
set_location_assignment PIN_BV63 -to tx_data_p[4]      ; ## Y26  FGTL12A_TX_Q2_CH3P  FMC_B_TX_P_11  SRXB_11P_FMC
set_location_assignment PIN_BW62 -to tx_data_n[4]      ; ## Y27  FGTL12A_TX_Q2_CH3N  FMC_B_TX_N_11  SRXB_11N_FMC
set_location_assignment PIN_CA60 -to tx_data_p[5]      ; ## Z24  FGTL12A_TX_Q2_CH2P  FMC_B_TX_P_10  SRXB_9P_FMC
set_location_assignment PIN_BY59 -to tx_data_n[5]      ; ## Z25  FGTL12A_TX_Q2_CH2N  FMC_B_TX_N_10  SRXB_9N_FMC
set_location_assignment PIN_CB63 -to tx_data_p[6]      ; ## B24  FGTL12A_TX_Q2_CH1P  FMC_B_TX_P_9   SRXB_8P_FMC
set_location_assignment PIN_CC62 -to tx_data_n[6]      ; ## B25  FGTL12A_TX_Q2_CH1N  FMC_B_TX_N_9   SRXB_8N_FMC
set_location_assignment PIN_CE60 -to tx_data_p[7]      ; ## B28  FGTL12A_TX_Q2_CH0P  FMC_B_TX_P_8   SRXB_5P_FMC
set_location_assignment PIN_CD59 -to tx_data_n[7]      ; ## B29  FGTL12A_TX_Q2_CH0N  FMC_B_TX_N_8   SRXB_5N_FMC
set_location_assignment PIN_CF63 -to tx_data_p[8]      ; ## B32  FGTL12A_TX_Q1_CH3P  FMC_B_TX_P_7   SRXA_7P_FMC
set_location_assignment PIN_CG62 -to tx_data_n[8]      ; ## B33  FGTL12A_TX_Q1_CH3N  FMC_B_TX_N_7   SRXA_7N_FMC
set_location_assignment PIN_CJ60 -to tx_data_p[9]      ; ## B36  FGTL12A_TX_Q1_CH2P  FMC_B_TX_P_6   SRXA_3P_FMC
set_location_assignment PIN_CH59 -to tx_data_n[9]      ; ## B37  FGTL12A_TX_Q1_CH2N  FMC_B_TX_N_6   SRXA_3N_FMC
set_location_assignment PIN_CK63 -to tx_data_p[10]     ; ## A38  FGTL12A_TX_Q1_CH1P  FMC_B_TX_P_5   SRXA_1P_FMC
set_location_assignment PIN_CL62 -to tx_data_n[10]     ; ## A39  FGTL12A_TX_Q1_CH1N  FMC_B_TX_N_5   SRXA_1N_FMC
set_location_assignment PIN_CN60 -to tx_data_p[11]     ; ## A34  FGTL12A_TX_Q1_CH0P  FMC_B_TX_P_4   SRXA_5P_FMC
set_location_assignment PIN_CM59 -to tx_data_n[11]     ; ## A35  FGTL12A_TX_Q1_CH0N  FMC_B_TX_N_4   SRXA_5N_FMC
set_location_assignment PIN_CP63 -to tx_data_p[12]     ; ## A30  FGTL12A_TX_Q0_CH3P  FMC_B_TX_P_3   SRXB_3P_FMC
set_location_assignment PIN_CR62 -to tx_data_n[12]     ; ## A31  FGTL12A_TX_Q0_CH3N  FMC_B_TX_N_3   SRXB_3N_FMC
set_location_assignment PIN_CU60 -to tx_data_p[13]     ; ## A26  FGTL12A_TX_Q0_CH2P  FMC_B_TX_P_2   SRXB_10P_FMC
set_location_assignment PIN_CT59 -to tx_data_n[13]     ; ## A27  FGTL12A_TX_Q0_CH2N  FMC_B_TX_N_2   SRXB_10N_FMC
set_location_assignment PIN_CV63 -to tx_data_p[14]     ; ## A22  FGTL12A_TX_Q0_CH1P  FMC_B_TX_P_1   SRXB_7P_FMC
set_location_assignment PIN_CW62 -to tx_data_n[14]     ; ## A23  FGTL12A_TX_Q0_CH1N  FMC_B_TX_N_1   SRXB_7N_FMC
set_location_assignment PIN_DA60 -to tx_data_p[15]     ; ## C2   FGTL12A_TX_Q0_CH0P  FMC_B_TX_P_0   SRXB_1P_FMC
set_location_assignment PIN_CY59 -to tx_data_n[15]     ; ## C3   FGTL12A_TX_Q0_CH0N  FMC_B_TX_N_0   SRXB_1N_FMC

set_location_assignment PIN_BK69 -to rx_data_p[0]      ; ## Y22  FGTL12A_RX_Q3_CH3P  FMC_B_RX_P_15  STXA_2P_FMC
set_location_assignment PIN_BL68 -to rx_data_n[0]      ; ## Y23  FGTL12A_RX_Q3_CH3N  FMC_B_RX_N_15  STXA_2N_FMC
set_location_assignment PIN_BN66 -to rx_data_p[1]      ; ## Y18  FGTL12A_RX_Q3_CH2P  FMC_B_RX_P_14  STXA_1P_FMC
set_location_assignment PIN_BM65 -to rx_data_n[1]      ; ## Y19  FGTL12A_RX_Q3_CH2N  FMC_B_RX_N_14  STXA_1N_FMC
set_location_assignment PIN_BP69 -to rx_data_p[2]      ; ## Z16  FGTL12A_RX_Q3_CH1P  FMC_B_RX_P_13  STXA_5P_FMC
set_location_assignment PIN_BR68 -to rx_data_n[2]      ; ## Z17  FGTL12A_RX_Q3_CH1N  FMC_B_RX_N_13  STXA_5N_FMC
set_location_assignment PIN_BU66 -to rx_data_p[3]      ; ## Y14  FGTL12A_RX_Q3_CH0P  FMC_B_RX_P_12  STXA_7P_FMC
set_location_assignment PIN_BT65 -to rx_data_n[3]      ; ## Y15  FGTL12A_RX_Q3_CH0N  FMC_B_RX_N_12  STXA_7N_FMC
set_location_assignment PIN_BV69 -to rx_data_p[4]      ; ## Z12  FGTL12A_RX_Q2_CH3P  FMC_B_RX_P_11  STXB_9P_FMC
set_location_assignment PIN_BW68 -to rx_data_n[4]      ; ## Z13  FGTL12A_RX_Q2_CH3N  FMC_B_RX_N_11  STXB_9N_FMC
set_location_assignment PIN_CA66 -to rx_data_p[5]      ; ## Y10  FGTL12A_RX_Q2_CH2P  FMC_B_RX_P_10  STXB_11P_FMC
set_location_assignment PIN_BY65 -to rx_data_n[5]      ; ## Y11  FGTL12A_RX_Q2_CH2N  FMC_B_RX_N_10  STXB_11N_FMC
set_location_assignment PIN_CB69 -to rx_data_p[6]      ; ## B4   FGTL12A_RX_Q2_CH1P  FMC_B_RX_P_9   STXB_1P_FMC
set_location_assignment PIN_CC68 -to rx_data_n[6]      ; ## B5   FGTL12A_RX_Q2_CH1N  FMC_B_RX_N_9   STXB_1N_FMC
set_location_assignment PIN_CE66 -to rx_data_p[7]      ; ## B8   FGTL12A_RX_Q2_CH0P  FMC_B_RX_P_8   STXB_8P_FMC
set_location_assignment PIN_CD65 -to rx_data_n[7]      ; ## B9   FGTL12A_RX_Q2_CH0N  FMC_B_RX_N_8   STXB_8N_FMC
set_location_assignment PIN_CF69 -to rx_data_p[8]      ; ## B12  FGTL12A_RX_Q1_CH3P  FMC_B_RX_P_7   STXA_9P_FMC
set_location_assignment PIN_CG68 -to rx_data_n[8]      ; ## B13  FGTL12A_RX_Q1_CH3N  FMC_B_RX_N_7   STXA_9N_FMC
set_location_assignment PIN_CJ66 -to rx_data_p[9]      ; ## B16  FGTL12A_RX_Q1_CH2P  FMC_B_RX_P_6   STXA_8P_FMC
set_location_assignment PIN_CH65 -to rx_data_n[9]      ; ## B17  FGTL12A_RX_Q1_CH2N  FMC_B_RX_N_6   STXA_8N_FMC
set_location_assignment PIN_CK69 -to rx_data_p[10]     ; ## A18  FGTL12A_RX_Q1_CH1P  FMC_B_RX_P_5   STXA_3P_FMC
set_location_assignment PIN_CL68 -to rx_data_n[10]     ; ## A19  FGTL12A_RX_Q1_CH1N  FMC_B_RX_N_5   STXA_3N_FMC
set_location_assignment PIN_CN66 -to rx_data_p[11]     ; ## A14  FGTL12A_RX_Q1_CH0P  FMC_B_RX_P_4   STXA_11P_FMC
set_location_assignment PIN_CM65 -to rx_data_n[11]     ; ## A15  FGTL12A_RX_Q1_CH0N  FMC_B_RX_N_4   STXA_11N_FMC
set_location_assignment PIN_CP69 -to rx_data_p[12]     ; ## A10  FGTL12A_RX_Q0_CH3P  FMC_B_RX_P_3   STXB_7P_FMC
set_location_assignment PIN_CR68 -to rx_data_n[12]     ; ## A11  FGTL12A_RX_Q0_CH3N  FMC_B_RX_N_3   STXB_7N_FMC
set_location_assignment PIN_CU66 -to rx_data_p[13]     ; ## A6   FGTL12A_RX_Q0_CH2P  FMC_B_RX_P_2   STXB_5P_FMC
set_location_assignment PIN_CT65 -to rx_data_n[13]     ; ## A7   FGTL12A_RX_Q0_CH2N  FMC_B_RX_N_2   STXB_5N_FMC
set_location_assignment PIN_CV69 -to rx_data_p[14]     ; ## A2   FGTL12A_RX_Q0_CH1P  FMC_B_RX_P_1   STXB_2P_FMC
set_location_assignment PIN_CW68 -to rx_data_n[14]     ; ## A3   FGTL12A_RX_Q0_CH1N  FMC_B_RX_N_1   STXB_2N_FMC
set_location_assignment PIN_DA66 -to rx_data_p[15]     ; ## C6   FGTL12A_RX_Q0_CH0P  FMC_B_RX_P_0   STXB_3P_FMC
set_location_assignment PIN_CY65 -to rx_data_n[15]     ; ## C7   FGTL12A_RX_Q0_CH0N  FMC_B_RX_N_0   STXB_3N_FMC

set_location_assignment PIN_DB37 -to "gpio[15]"           ; ## C10 FMC_B_LA_P6
set_location_assignment PIN_DA38 -to "gpio[16]"           ; ## C11 FMC_B_LA_N6
set_location_assignment PIN_DM45 -to "gpio[23]"           ; ## C18 FMC_B_LA_P14
set_location_assignment PIN_DL46 -to "gpio[24]"           ; ## C19 FMC_B_LA_N14
set_location_assignment PIN_CL42 -to "gpio[27]"           ; ## C22 FMC_B_LA_P18
set_location_assignment PIN_CM41 -to "gpio[28]"           ; ## C23 FMC_B_LA_N18
set_location_assignment PIN_DF37 -to "gpio[21]"           ; ## G15 FMC_B_LA_P12
set_location_assignment PIN_DG38 -to "gpio[22]"           ; ## G16 FMC_B_LA_N12
set_location_assignment PIN_DK37 -to "gpio[17]"           ; ## H13 FMC_B_LA_P7
set_location_assignment PIN_DJ38 -to "gpio[18]"           ; ## H14 FMC_B_LA_N7
set_location_assignment PIN_DF39 -to "gpio[19]"           ; ## H16 FMC_B_LA_P11
set_location_assignment PIN_DG40 -to "gpio[20]"           ; ## H17 FMC_B_LA_N11
set_location_assignment PIN_DB39 -to "gpio[25]"           ; ## H19 FMC_B_LA_P15
set_location_assignment PIN_DA40 -to "gpio[26]"           ; ## H20 FMC_B_LA_N15
set_location_assignment PIN_CT43 -to "gpio[29]"           ; ## H22 FMC_B_LA_P19
set_location_assignment PIN_CU44 -to "gpio[30]"           ; ## H23 FMC_B_LA_N19
set_location_assignment PIN_DL42 -to "aux_gpio"           ; ## D24 FMC_B_LA_N23

set_location_assignment PIN_DB41 -to "syncinb_a1_p_gpio"  ; ## G21 FMC_B_LA_P20
set_location_assignment PIN_DA42 -to "syncinb_a1_n_gpio"  ; ## G22 FMC_B_LA_N20
set_location_assignment PIN_DD41 -to "syncoutb_a1_p_gpio" ; ## H25 FMC_B_LA_P21
set_location_assignment PIN_DE42 -to "syncoutb_a1_n_gpio" ; ## H26 FMC_B_LA_N21

set_location_assignment PIN_DD39 -to "syncinb_a0"     ; ## H10 FMC_B_LA_P4
set_location_assignment PIN_DE40 -to "syncinb_a0(n)"  ; ## H11 FMC_B_LA_N4
set_location_assignment PIN_DF41 -to "syncoutb_a0"    ; ## D11 FMC_B_LA_P5
set_location_assignment PIN_DG42 -to "syncoutb_a0(n)" ; ## D12 FMC_B_LA_N5

set_location_assignment PIN_CW42 -to "sysref_in"     ; ## G36 FMC_B_LA_P33
set_location_assignment PIN_CY41 -to "sysref_in(n)"  ; ## G37 FMC_B_LA_N33

set_location_assignment PIN_DB45 -to "spi2_sclk"     ; ## H28 FMC_B_LA_P24
set_location_assignment PIN_DA46 -to "spi2_sdio"     ; ## H29 FMC_B_LA_N24
set_location_assignment PIN_DD43 -to "spi2_sdo"      ; ## D26 FMC_B_LA_P26
set_location_assignment PIN_DE44 -to "spi2_cs[0]"    ; ## D27 FMC_B_LA_N26
set_location_assignment PIN_CW46 -to "spi2_cs[1]"    ; ## G30 FMC_B_LA_P29
set_location_assignment PIN_CY45 -to "spi2_cs[2]"    ; ## G31 FMC_B_LA_N29
set_location_assignment PIN_CL46 -to "spi2_cs[3]"    ; ## H34 FMC_B_LA_P30
set_location_assignment PIN_CM45 -to "spi2_cs[4]"    ; ## H35 FMC_B_LA_N30
set_location_assignment PIN_DB43 -to "spi2_cs[5]"    ; ## H37 FMC_B_LA_P32

set_location_assignment PIN_DB47 -to "dut_sdio"      ; ## G9  FMC_B_LA_P3
set_location_assignment PIN_DA48 -to "dut_sdo"       ; ## G10 FMC_B_LA_N3
set_location_assignment PIN_DD37 -to "dut_sclk"      ; ## H7  FMC_B_LA_P2
set_location_assignment PIN_DE38 -to "dut_csb"       ; ## H8  FMC_B_LA_N2

set_location_assignment PIN_DM43 -to "trig_a[0]"     ; ## C14 FMC_B_LA_P10
set_location_assignment PIN_DL44 -to "trig_a[1]"     ; ## C15 FMC_B_LA_N10
set_location_assignment PIN_DP41 -to "trig_b[0]"     ; ## D17 FMC_B_LA_P13
set_location_assignment PIN_DR42 -to "trig_b[1]"     ; ## D18 FMC_B_LA_N13
set_location_assignment PIN_CU46 -to "trig_in"       ; ## D9  FMC_B_LA_N1
set_location_assignment PIN_CT45 -to "resetb"        ; ## D8  FMC_B_LA_P1

set common_lanes 16
# set common_lanes [get_env_param RX_JESD_L 4]
# if {$common_lanes > [get_env_param TX_JESD_L 4]} {
#   set common_lanes [get_env_param TX_JESD_L 4]
# }

# Merge RX and TX into single transceiver
for {set i 0} {$i < $common_lanes} {incr i} {
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to rx_data_p[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to tx_data_p[${i}]
}

# Apply default main-tap and pre-tap values
set tx_num_lanes [expr [get_env_param TX_JESD_L 8] * [get_env_param TX_NUM_LINKS 2]]
for {set j 0} {$j < $tx_num_lanes} {incr j} {
  set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to tx_data_p[$j]
  set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to tx_data_n[$j]

  set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35"  -to tx_data_p[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5"  -to tx_data_p[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0"  -to tx_data_p[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to tx_data_p[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35"  -to tx_data_n[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5"  -to tx_data_n[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0"  -to tx_data_n[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to tx_data_n[$j]
}

# Enable AC coupling, set termination to 100 ohms and enable VSR mode at high lane rates
set rx_num_lanes [expr [get_env_param RX_JESD_L 8] * [get_env_param RX_NUM_LINKS 2]]
set lane_rate [expr [get_env_param RX_LANE_RATE 20.625] * 1000]
for {set j 0} {$j < $rx_num_lanes} {incr j} {
  set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to rx_data_p[$j]
  set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to rx_data_n[$j]

  set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE"                      -to rx_data_p[$j]
  set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to rx_data_p[$j]
  set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE"                      -to rx_data_n[$j]
  set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to rx_data_n[$j]

  if {$lane_rate > 23000} {
    set_instance_assignment -name HSSI_PARAMETER "vsr_mode=VSR_MODE_LOW_LOSS" -to rx_data_p[$j]
    set_instance_assignment -name HSSI_PARAMETER "vsr_mode=VSR_MODE_LOW_LOSS" -to rx_data_n[$j]
  } else {
    set_instance_assignment -name HSSI_PARAMETER "vsr_mode=VSR_MODE_DISABLE" -to rx_data_p[$j]
    set_instance_assignment -name HSSI_PARAMETER "vsr_mode=VSR_MODE_DISABLE" -to rx_data_n[$j]
  }
}

for {set i 15} {$i < 31} {incr i} {
  set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[$i]
}

foreach port {aux_gpio trig_a[0] trig_a[1] trig_b[0] trig_b[1] trig_in resetb} {
  set_instance_assignment -name IO_STANDARD "1.2V" -to $port
}

foreach port {spi2_sclk spi2_sdio spi2_sdo spi2_cs[0] spi2_cs[1] spi2_cs[2] spi2_cs[3] spi2_cs[4] spi2_cs[5] dut_sdio dut_sdo dut_sclk dut_csb} {
  set_instance_assignment -name IO_STANDARD "1.2V" -to $port
}

foreach port {syncinb_a1_p_gpio syncinb_a1_n_gpio syncoutb_a1_p_gpio syncoutb_a1_n_gpio} {
  set_instance_assignment -name IO_STANDARD "1.2V" -to $port
}

set_global_assignment -name OPTIMIZATION_MODE "Superior Performance"

execute_flow -compile
