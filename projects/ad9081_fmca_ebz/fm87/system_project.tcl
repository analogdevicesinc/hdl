###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make RX_RATE=10 TX_RATE=10 RX_JESD_L=4 RX_JESD_M=8 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=4 TX_JESD_M=8 TX_JESD_S=1 TX_JESD_NP=16
#      make RX_RATE=2.5 TX_RATE=2.5 RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1 TX_JESD_NP=16
#      make RX_RATE=10 TX_RATE=10 RX_JESD_L=2 RX_JESD_M=8 RX_JESD_S=1 RX_JESD_NP=12 TX_JESD_L=2 TX_JESD_M=8 TX_JESD_S=1 TX_JESD_NP=12
#
# Lane Rate = I/Q Sample Rate x M x N' x (10 \ 8) \ L

# Parameter description:
#
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C, uses Intel IP with a custom gearbox as Physical layer
#      8B10B  - 8b10b link layer defined in JESD 204B, uses Intel IP as Physical layer
#
#   RX_LANE_RATE :  Lane rate of the Rx link ( MxFE to FPGA )
#   TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to MxFE )
#   REF_CLK_RATE : Frequency of reference clock in MHz used in 64B66B mode (LANE_RATE/66) or 8B10B mode (LANE_RATE/40)
#   DEVICE_CLK_RATE: Frequency of the device clock in MHz, usually equal to REF_CLK_RATE
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links
#   [RX/TX]_KS_PER_CHANNEL : Number of samples stored in internal buffers in kilosamples per converter (M)
#

adi_project ad9081_fmca_ebz_fm87 [list \
  JESD_MODE         [get_env_param JESD_MODE      64B66B ] \
  RX_LANE_RATE      [get_env_param RX_LANE_RATE    24.75 ] \
  TX_LANE_RATE      [get_env_param TX_LANE_RATE    24.75 ] \
  REF_CLK_RATE      [get_env_param REF_CLK_RATE      375 ] \
  DEVICE_CLK_RATE   [get_env_param DEVICE_CLK_RATE   375 ] \
  RX_JESD_M         [get_env_param RX_JESD_M           8 ] \
  RX_JESD_L         [get_env_param RX_JESD_L           8 ] \
  RX_JESD_S         [get_env_param RX_JESD_S           1 ] \
  RX_JESD_NP        [get_env_param RX_JESD_NP         16 ] \
  RX_NUM_LINKS      [get_env_param RX_NUM_LINKS        1 ] \
  TX_JESD_M         [get_env_param TX_JESD_M           8 ] \
  TX_JESD_L         [get_env_param TX_JESD_L           8 ] \
  TX_JESD_S         [get_env_param TX_JESD_S           1 ] \
  TX_JESD_NP        [get_env_param TX_JESD_NP         16 ] \
  TX_NUM_LINKS      [get_env_param TX_NUM_LINKS        1 ] \
  RX_KS_PER_CHANNEL [get_env_param RX_KS_PER_CHANNEL  16 ] \
  TX_KS_PER_CHANNEL [get_env_param TX_KS_PER_CHANNEL  16 ] \
]

source $ad_hdl_dir/projects/common/fm87/fm87_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../../../library/common/ad_3w_spi.v
set_global_assignment -name VERILOG_FILE ../../common/fm87/gpio_slave.v

# Note: This projects requires a hardware rework to function correctly.
#
# Changes required (Agilex FMC A):
# R1433, R1434: 50 ohm
# R1777, R1778: 50 ohm
# C2488, C4289:  0 ohm
# R1231, R1234: 1k ohm
# R1230, R1233: 1k ohm

# Changes required (MxFE):
# C39B, C40B: 50 ohm

set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to fpga_syncin_0
set_instance_assignment -name IO_STANDARD "Differential 1.2-V HSTL"     -to fpga_syncout_0
set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to sysref2
set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to clkin6
set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to clkin10
set_instance_assignment -name IO_STANDARD "CURRENT MODE LOGIC (CML)"    -to fpga_refclk_in

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to fpga_syncin_0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref2

set_location_assignment PIN_J50    -to "agc0[0]"             ; ## D20  LA17_CC_P
set_location_assignment PIN_K51    -to "agc0[1]"             ; ## D21  LA17_CC_N
set_location_assignment PIN_G50    -to "agc1[0]"             ; ## C22  LA18_CC_P
set_location_assignment PIN_F51    -to "agc1[1]"             ; ## C23  LA18_CC_N
set_location_assignment PIN_A60    -to "agc2[0]"             ; ## G21  LA20_P
set_location_assignment PIN_B61    -to "agc2[1]"             ; ## G22  LA20_N
set_location_assignment PIN_J46    -to "agc3[0]"             ; ## H25  LA21_P
set_location_assignment PIN_K47    -to "agc3[1]"             ; ## H26  LA21_N
set_location_assignment PIN_T43    -to "clkin6(n)"           ; ## G03  CLK1_M2C_N
set_location_assignment PIN_U42    -to "clkin6"              ; ## G02  CLK1_M2C_P
set_location_assignment PIN_P47    -to "clkin10(n)"          ; ## G07  LA00_P_CC
set_location_assignment PIN_R46    -to "clkin10"             ; ## G06  LA00_N_CC
set_location_assignment PIN_BB57   -to "fpga_refclk_in"      ; ## D04  GBTCLK0_M2C_P

set_location_assignment PIN_AP69   -to "rx_data[0]"          ; ## C06  DP0_M2C_P
set_location_assignment PIN_AR68   -to "rx_data_n[0]"        ; ## C07  DP0_M2C_N
set_location_assignment PIN_AU66   -to "rx_data[1]"          ; ## A02  DP1_M2C_P
set_location_assignment PIN_AT65   -to "rx_data_n[1]"        ; ## A03  DP1_M2C_N
set_location_assignment PIN_AV69   -to "rx_data[2]"          ; ## A06  DP2_M2C_P
set_location_assignment PIN_AW68   -to "rx_data_n[2]"        ; ## A07  DP2_M2C_N
set_location_assignment PIN_BA66   -to "rx_data[3]"          ; ## A10  DP3_M2C_P
set_location_assignment PIN_AY65   -to "rx_data_n[3]"        ; ## A11  DP3_M2C_N
set_location_assignment PIN_BB69   -to "rx_data[4]"          ; ## A14  DP4_M2C_P
set_location_assignment PIN_BC68   -to "rx_data_n[4]"        ; ## A15  DP4_M2C_N
set_location_assignment PIN_BE66   -to "rx_data[5]"          ; ## A18  DP5_M2C_P
set_location_assignment PIN_BD65   -to "rx_data_n[5]"        ; ## A19  DP5_M2C_N
set_location_assignment PIN_BF69   -to "rx_data[6]"          ; ## B16  DP6_M2C_P
set_location_assignment PIN_BG68   -to "rx_data_n[6]"        ; ## B17  DP6_M2C_N
set_location_assignment PIN_BJ66   -to "rx_data[7]"          ; ## B12  DP7_M2C_P
set_location_assignment PIN_BH65   -to "rx_data_n[7]"        ; ## B13  DP7_M2C_N

set_location_assignment PIN_AP63   -to "tx_data[0]"          ; ## C02  DP0_C2M_P
set_location_assignment PIN_AR62   -to "tx_data_n[0]"        ; ## C03  DP0_C2M_N
set_location_assignment PIN_AU60   -to "tx_data[1]"          ; ## A22  DP1_C2M_P
set_location_assignment PIN_AT59   -to "tx_data_n[1]"        ; ## A23  DP1_C2M_N
set_location_assignment PIN_AV63   -to "tx_data[2]"          ; ## A26  DP2_C2M_P
set_location_assignment PIN_AW62   -to "tx_data_n[2]"        ; ## A27  DP2_C2M_N
set_location_assignment PIN_BA60   -to "tx_data[3]"          ; ## A30  DP3_C2M_P
set_location_assignment PIN_AY59   -to "tx_data_n[3]"        ; ## A31  DP3_C2M_N
set_location_assignment PIN_BB63   -to "tx_data[4]"          ; ## A34  DP4_C2M_P
set_location_assignment PIN_BC62   -to "tx_data_n[4]"        ; ## A35  DP4_C2M_N
set_location_assignment PIN_BE60   -to "tx_data[5]"          ; ## A38  DP5_C2M_P
set_location_assignment PIN_BD59   -to "tx_data_n[5]"        ; ## A39  DP5_C2M_N
set_location_assignment PIN_BF63   -to "tx_data[6]"          ; ## B36  DP6_C2M_P
set_location_assignment PIN_BG62   -to "tx_data_n[6]"        ; ## B37  DP6_C2M_N
set_location_assignment PIN_BJ60   -to "tx_data[7]"          ; ## B32  DP7_C2M_P
set_location_assignment PIN_BH59   -to "tx_data_n[7]"        ; ## B33  DP7_C2M_N

set_location_assignment PIN_AB47   -to "fpga_syncin_0(n)"    ; ## H08  LA02_N
set_location_assignment PIN_AA46   -to "fpga_syncin_0"       ; ## H07  LA02_P
set_location_assignment PIN_P49    -to "fpga_syncin_1_n"     ; ## G10  LA03_N
set_location_assignment PIN_R48    -to "fpga_syncin_1_p"     ; ## G09  LA03_P
set_location_assignment PIN_T45    -to "fpga_syncout_0(n)"   ; ## D09  LA01_CC_N
set_location_assignment PIN_U44    -to "fpga_syncout_0"      ; ## D08  LA01_CC_P
set_location_assignment PIN_AB43   -to "fpga_syncout_1_n"    ; ## C11  LA06_N
set_location_assignment PIN_AA42   -to "fpga_syncout_1_p"    ; ## C10  LA06_P
set_location_assignment PIN_W44    -to "gpio[0]"             ; ## H19  LA15_P
set_location_assignment PIN_Y45    -to "gpio[1]"             ; ## H20  LA15_N
set_location_assignment PIN_J48    -to "gpio[2]"             ; ## H22  LA19_P
set_location_assignment PIN_K49    -to "gpio[3]"             ; ## H23  LA19_N
set_location_assignment PIN_E60    -to "gpio[4]"             ; ## D17  LA13_P
set_location_assignment PIN_D61    -to "gpio[5]"             ; ## D18  LA13_N
set_location_assignment PIN_J56    -to "gpio[6]"             ; ## C18  LA14_P
set_location_assignment PIN_K57    -to "gpio[7]"             ; ## C19  LA14_N
set_location_assignment PIN_W42    -to "gpio[8]"             ; ## G18  LA16_P
set_location_assignment PIN_Y43    -to "gpio[9]"             ; ## G19  LA16_N
set_location_assignment PIN_B59    -to "gpio[10]"            ; ## G25  LA22_N
set_location_assignment PIN_T47    -to "hmc_gpio1"           ; ## H17  LA11_N
set_location_assignment PIN_Y47    -to "hmc_sync"            ; ## H14  LA07_N
set_location_assignment PIN_AE46   -to "irqb[0]"             ; ## G12  LA08_P
set_location_assignment PIN_AD47   -to "irqb[1]"             ; ## G13  LA08_N
set_location_assignment PIN_W46    -to "rstb"                ; ## H13  LA07_P
set_location_assignment PIN_J52    -to "rxen[0]"             ; ## C14  LA10_P
set_location_assignment PIN_K53    -to "rxen[1]"             ; ## C15  LA10_N
set_location_assignment PIN_L50    -to "spi0_csb"            ; ## D11  LA05_P
set_location_assignment PIN_M51    -to "spi0_miso"           ; ## D12  LA05_N
set_location_assignment PIN_AB45   -to "spi0_mosi"           ; ## H10  LA04_P
set_location_assignment PIN_AA44   -to "spi0_sclk"           ; ## H11  LA04_N
set_location_assignment PIN_AE44   -to "spi1_csb"            ; ## G15  LA12_P
set_location_assignment PIN_U46    -to "spi1_sclk"           ; ## H16  LA11_P
set_location_assignment PIN_AD45   -to "spi1_sdio"           ; ## G16  LA12_N
set_location_assignment PIN_D55    -to "sysref2(n)"          ; ## H05  CLK0_M2C_N
set_location_assignment PIN_E54    -to "sysref2"             ; ## H04  CLK0_M2C_P
set_location_assignment PIN_J54    -to "txen[0]"             ; ## D14  LA09_P
set_location_assignment PIN_K55    -to "txen[1]"             ; ## D15  LA09_N

set common_lanes [get_env_param RX_JESD_L 4]
if {$common_lanes > [get_env_param TX_JESD_L 4]} {
  set common_lanes [get_env_param TX_JESD_L 4]
}

# Merge RX and TX into single transceiver
for {set i 0} {$i < $common_lanes} {incr i} {
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to rx_data[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to tx_data[${i}]
}

# Apply default main-tap and pre-tap values
set tx_num_lanes [get_env_param TX_JESD_L 8]
for {set j 0} {$j < $tx_num_lanes} {incr j} {
  set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to tx_data[$j]
  set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to tx_data_n[$j]

  set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35"  -to tx_data[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5"  -to tx_data[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0"  -to tx_data[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to tx_data[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35"  -to tx_data_n[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5"  -to tx_data_n[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0"  -to tx_data_n[$j]
  set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to tx_data_n[$j]
}

# Enable AC coupling, set termination to 100 ohms and enable VSR mode at high lane rates
set rx_num_lanes [get_env_param RX_JESD_L 8]
set lane_rate [expr [get_env_param RX_LANE_RATE 24.75] * 1000]
for {set j 0} {$j < $rx_num_lanes} {incr j} {
  set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to rx_data[$j]
  set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to rx_data_n[$j]

  set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE"                      -to rx_data[$j]
  set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to rx_data[$j]
  set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE"                      -to rx_data_n[$j]
  set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to rx_data_n[$j]

  if {$lane_rate > 23000} {
    set_instance_assignment -name HSSI_PARAMETER "vsr_mode=VSR_MODE_LOW_LOSS" -to rx_data[$j]
    set_instance_assignment -name HSSI_PARAMETER "vsr_mode=VSR_MODE_LOW_LOSS" -to rx_data_n[$j]
  } else {
    set_instance_assignment -name HSSI_PARAMETER "vsr_mode=VSR_MODE_DISABLE" -to rx_data[$j]
    set_instance_assignment -name HSSI_PARAMETER "vsr_mode=VSR_MODE_DISABLE" -to rx_data_n[$j]
  }
}

set_instance_assignment -name IO_STANDARD "1.2 V" -to agc0[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc0[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc1[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc1[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc2[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc2[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc3[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc3[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_syncin_1_p
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_syncin_1_n
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_syncout_1_p
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_syncout_1_n
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[2]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[3]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[4]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[5]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[6]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[7]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[8]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[9]
set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[10]
set_instance_assignment -name IO_STANDARD "1.2 V" -to hmc_gpio1
set_instance_assignment -name IO_STANDARD "1.2 V" -to hmc_sync
set_instance_assignment -name IO_STANDARD "1.2 V" -to irqb[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to irqb[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to rstb
set_instance_assignment -name IO_STANDARD "1.2 V" -to rxen[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to rxen[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to spi0_csb
set_instance_assignment -name IO_STANDARD "1.2 V" -to spi0_miso
set_instance_assignment -name IO_STANDARD "1.2 V" -to spi0_mosi
set_instance_assignment -name IO_STANDARD "1.2 V" -to spi0_sclk
set_instance_assignment -name IO_STANDARD "1.2 V" -to spi1_csb
set_instance_assignment -name IO_STANDARD "1.2 V" -to spi1_sclk
set_instance_assignment -name IO_STANDARD "1.2 V" -to spi1_sdio
set_instance_assignment -name IO_STANDARD "1.2 V" -to txen[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to txen[1]

set_global_assignment -name MESSAGE_DISABLE 15714

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "Superior Performance"

execute_flow -compile
