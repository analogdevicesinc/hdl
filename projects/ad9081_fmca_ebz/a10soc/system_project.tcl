###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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
#      make RX_LANE_RATE=10 TX_LANE_RATE=10 RX_JESD_L=4 RX_JESD_M=8 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=4 TX_JESD_M=8 TX_JESD_S=1 TX_JESD_NP=16
#      make RX_LANE_RATE=2.5 TX_LANE_RATE=2.5 RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1 TX_JESD_NP=16
#      make RX_LANE_RATE=10 TX_LANE_RATE=10 RX_JESD_L=2 RX_JESD_M=8 RX_JESD_S=1 RX_JESD_NP=12 TX_JESD_L=2 TX_JESD_M=8 TX_JESD_S=1 TX_JESD_NP=12
#
# Lane Rate = I/Q Sample Rate x M x N' x (10 \ 8) \ L

# Parameter description:
#
#   RX_LANE_RATE :  Lane rate of the Rx link ( MxFE to FPGA )
#   TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to MxFE )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links
#   [RX/TX]_KS_PER_CHANNEL : Number of samples stored in internal buffers in kilosamples per converter (M)
#

adi_project ad9081_fmca_ebz_a10soc [list \
  RX_LANE_RATE       [get_env_param RX_LANE_RATE      10 ] \
  TX_LANE_RATE       [get_env_param TX_LANE_RATE      10 ] \
  RX_JESD_M          [get_env_param RX_JESD_M          8 ] \
  RX_JESD_L          [get_env_param RX_JESD_L          4 ] \
  RX_JESD_S          [get_env_param RX_JESD_S          1 ] \
  RX_JESD_NP         [get_env_param RX_JESD_NP        16 ] \
  RX_NUM_LINKS       [get_env_param RX_NUM_LINKS       1 ] \
  TX_JESD_M          [get_env_param TX_JESD_M          8 ] \
  TX_JESD_L          [get_env_param TX_JESD_L          4 ] \
  TX_JESD_S          [get_env_param TX_JESD_S          1 ] \
  TX_JESD_NP         [get_env_param TX_JESD_NP        16 ] \
  TX_NUM_LINKS       [get_env_param TX_NUM_LINKS       1 ] \
  RX_KS_PER_CHANNEL  [get_env_param RX_KS_PER_CHANNEL 32 ] \
  TX_KS_PER_CHANNEL  [get_env_param TX_KS_PER_CHANNEL 32 ] \
]

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl


# files

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_3w_spi.v


# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required:
#  R610: DNI -> R0    PIN_E12
#  R611: DNI -> R0    PIN_E13
#  R612: R0 -> DNI
#  R613: R0 -> DNI
#  R620: DNI -> R0    PIN_F13
#  R632: DNI -> R0    PIN_F14
#  R621: R0 -> DNI
#  R633: R0 -> DNI
#  R574: DNI -> R0    PIN_W5
#  R577: DNI -> R0    PIN_W6
#  R576: R0 -> DNI
#  R575: R0 -> DNI


set_location_assignment PIN_F9    -to "agc0[0]"             ; ## D20  LA17_CC_P
set_location_assignment PIN_G9    -to "agc0[1]"             ; ## D21  LA17_CC_N
set_location_assignment PIN_G7    -to "agc1[0]"             ; ## C22  LA18_CC_P
set_location_assignment PIN_H7    -to "agc1[1]"             ; ## C23  LA18_CC_N
set_location_assignment PIN_C3    -to "agc2[0]"             ; ## G21  LA20_P
set_location_assignment PIN_C4    -to "agc2[1]"             ; ## G22  LA20_N
set_location_assignment PIN_C2    -to "agc3[0]"             ; ## H25  LA21_P
set_location_assignment PIN_D3    -to "agc3[1]"             ; ## H26  LA21_N
set_location_assignment PIN_W6    -to "clkin6(n)"           ; ## G03  CLK1_M2C_N
set_location_assignment PIN_W5    -to "clkin6"              ; ## G02  CLK1_M2C_P
set_location_assignment PIN_N28   -to "fpga_refclk_in(n)"   ; ## D05  GBTCLK0_M2C_N
set_location_assignment PIN_N29   -to "fpga_refclk_in"      ; ## D04  GBTCLK0_M2C_P
set_location_assignment PIN_P34   -to "rx_data[2](n)"       ; ## A07  DP2_M2C_N
set_location_assignment PIN_P35   -to "rx_data[2]"          ; ## A06  DP2_M2C_P
set_location_assignment PIN_T30   -to "rx_data[0](n)"       ; ## C07  DP0_M2C_N
set_location_assignment PIN_T31   -to "rx_data[0]"          ; ## C06  DP0_M2C_P
set_location_assignment PIN_L32   -to "rx_data[7](n)"       ; ## B13  DP7_M2C_N
set_location_assignment PIN_L33   -to "rx_data[7]"          ; ## B12  DP7_M2C_P
set_location_assignment PIN_M30   -to "rx_data[6](n)"       ; ## B17  DP6_M2C_N
set_location_assignment PIN_M31   -to "rx_data[6]"          ; ## B16  DP6_M2C_P
set_location_assignment PIN_M34   -to "rx_data[5](n)"       ; ## A19  DP5_M2C_N
set_location_assignment PIN_M35   -to "rx_data[5]"          ; ## A18  DP5_M2C_P
set_location_assignment PIN_N32   -to "rx_data[4](n)"       ; ## A15  DP4_M2C_N
set_location_assignment PIN_N33   -to "rx_data[4]"          ; ## A14  DP4_M2C_P
set_location_assignment PIN_P30   -to "rx_data[3](n)"       ; ## A11  DP3_M2C_N
set_location_assignment PIN_P31   -to "rx_data[3]"          ; ## A10  DP3_M2C_P
set_location_assignment PIN_R32   -to "rx_data[1](n)"       ; ## A03  DP1_M2C_N
set_location_assignment PIN_R33   -to "rx_data[1]"          ; ## A02  DP1_M2C_P
set_location_assignment PIN_N36   -to "tx_data[0](n)"       ; ## C03  DP0_C2M_N
set_location_assignment PIN_N37   -to "tx_data[0]"          ; ## C02  DP0_C2M_P
set_location_assignment PIN_L36   -to "tx_data[2](n)"       ; ## A27  DP2_C2M_N
set_location_assignment PIN_L37   -to "tx_data[2]"          ; ## A26  DP2_C2M_P
set_location_assignment PIN_F38   -to "tx_data[7](n)"       ; ## B33  DP7_C2M_N
set_location_assignment PIN_F39   -to "tx_data[7]"          ; ## B32  DP7_C2M_P
set_location_assignment PIN_G36   -to "tx_data[6](n)"       ; ## B37  DP6_C2M_N
set_location_assignment PIN_G37   -to "tx_data[6]"          ; ## B36  DP6_C2M_P
set_location_assignment PIN_M38   -to "tx_data[1](n)"       ; ## A23  DP1_C2M_N
set_location_assignment PIN_M39   -to "tx_data[1]"          ; ## A22  DP1_C2M_P
set_location_assignment PIN_H38   -to "tx_data[5](n)"       ; ## A39  DP5_C2M_N
set_location_assignment PIN_H39   -to "tx_data[5]"          ; ## A38  DP5_C2M_P
set_location_assignment PIN_J36   -to "tx_data[4](n)"       ; ## A35  DP4_C2M_N
set_location_assignment PIN_J37   -to "tx_data[4]"          ; ## A34  DP4_C2M_P
set_location_assignment PIN_K38   -to "tx_data[3](n)"       ; ## A31  DP3_C2M_N
set_location_assignment PIN_K39   -to "tx_data[3]"          ; ## A30  DP3_C2M_P
set_location_assignment PIN_D13   -to "fpga_syncin_0(n)"    ; ## H08  LA02_N
set_location_assignment PIN_C13   -to "fpga_syncin_0"       ; ## H07  LA02_P
set_location_assignment PIN_D14   -to "fpga_syncin_1_n"     ; ## G10  LA03_N
set_location_assignment PIN_C14   -to "fpga_syncin_1_p"     ; ## G09  LA03_P
set_location_assignment PIN_E13   -to "fpga_syncout_0(n)"   ; ## D09  LA01_CC_N
set_location_assignment PIN_E12   -to "fpga_syncout_0"      ; ## D08  LA01_CC_P
set_location_assignment PIN_B10   -to "fpga_syncout_1_n"    ; ## C11  LA06_N
set_location_assignment PIN_A10   -to "fpga_syncout_1_p"    ; ## C10  LA06_P
set_location_assignment PIN_D4    -to "gpio[0]"             ; ## H19  LA15_P
set_location_assignment PIN_D5    -to "gpio[1]"             ; ## H20  LA15_N
set_location_assignment PIN_G5    -to "gpio[2]"             ; ## H22  LA19_P
set_location_assignment PIN_G6    -to "gpio[3]"             ; ## H23  LA19_N
set_location_assignment PIN_J11   -to "gpio[4]"             ; ## D17  LA13_P
set_location_assignment PIN_K11   -to "gpio[5]"             ; ## D18  LA13_N
set_location_assignment PIN_J9    -to "gpio[6]"             ; ## C18  LA14_P
set_location_assignment PIN_J10   -to "gpio[7]"             ; ## C19  LA14_N
set_location_assignment PIN_D6    -to "gpio[8]"             ; ## G18  LA16_P
set_location_assignment PIN_E6    -to "gpio[9]"             ; ## G19  LA16_N
set_location_assignment PIN_G4    -to "gpio[10]"            ; ## G25  LA22_N
set_location_assignment PIN_D9    -to "hmc_gpio1"           ; ## H17  LA11_N
set_location_assignment PIN_B9    -to "hmc_sync"            ; ## H14  LA07_N
set_location_assignment PIN_B11   -to "irqb[0]"             ; ## G12  LA08_P
set_location_assignment PIN_B12   -to "irqb[1]"             ; ## G13  LA08_N
set_location_assignment PIN_A9    -to "rstb"                ; ## H13  LA07_P
set_location_assignment PIN_A7    -to "rxen[0]"             ; ## C14  LA10_P
set_location_assignment PIN_A8    -to "rxen[1]"             ; ## C15  LA10_N
set_location_assignment PIN_F13   -to "spi0_csb"            ; ## D11  LA05_P
set_location_assignment PIN_F14   -to "spi0_miso"           ; ## D12  LA05_N
set_location_assignment PIN_H12   -to "spi0_mosi"           ; ## H10  LA04_P
set_location_assignment PIN_H13   -to "spi0_sclk"           ; ## H11  LA04_N
set_location_assignment PIN_M12   -to "spi1_csb"            ; ## G15  LA12_P
set_location_assignment PIN_C9    -to "spi1_sclk"           ; ## H16  LA11_P
set_location_assignment PIN_N13   -to "spi1_sdio"           ; ## G16  LA12_N
set_location_assignment PIN_F5    -to "sysref2(n)"          ; ## H05  CLK0_M2C_N
set_location_assignment PIN_E5    -to "sysref2"             ; ## H04  CLK0_M2C_P
set_location_assignment PIN_A12   -to "txen[0]"             ; ## D14  LA09_P
set_location_assignment PIN_A13   -to "txen[1]"             ; ## D15  LA09_N


set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_data

set_instance_assignment -name IO_STANDARD LVDS -to fpga_refclk_in
set_instance_assignment -name IO_STANDARD LVDS -to clkin6
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_data

set common_lanes 0
set common_lanes [get_env_param RX_JESD_L 4]
if {$common_lanes > [get_env_param TX_JESD_L 4]} {
  set common_lanes [get_env_param TX_JESD_L 4]
}

# Merge RX and TX into single transceiver
for {set i 0} {$i < $common_lanes} {incr i} {
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to rx_data[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to tx_data[${i}]
}

set_instance_assignment -name IO_STANDARD LVDS -to fpga_syncin_0
set_instance_assignment -name IO_STANDARD LVDS -to fpga_syncout_0
set_instance_assignment -name IO_STANDARD LVDS -to sysref2
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to fpga_syncin_0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref2

set_instance_assignment -name IO_STANDARD "1.8 V" -to agc0[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to agc0[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to agc1[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to agc1[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to agc2[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to agc2[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to agc3[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to agc3[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hmc_gpio1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hmc_sync
set_instance_assignment -name IO_STANDARD "1.8 V" -to irqb[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to irqb[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to rstb
set_instance_assignment -name IO_STANDARD "1.8 V" -to rxen[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to rxen[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi0_csb
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi0_miso
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi0_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi0_sclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi1_csb
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi1_sclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi1_sdio
set_instance_assignment -name IO_STANDARD "1.8 V" -to txen[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to txen[1]

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
set_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER 1.2

execute_flow -compile
