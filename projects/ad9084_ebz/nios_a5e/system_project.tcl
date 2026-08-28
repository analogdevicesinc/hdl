###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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
#      make JESD_MODE=8B10B RX_LANE_RATE=10 TX_LANE_RATE=10 RX_JESD_M=4 TX_JESD_M=4 RX_JESD_L=4 TX_JESD_L=4 RX_JESD_S=1 TX_JESD_S=1 RX_JESD_NP=16 TX_JESD_NP=16
#

#
# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#
#   REF_CLK_RATE : Reference clock frequency in MHz, should be Lane Rate / 66 for JESD204C or Lane Rate / 40 for JESD204B
#   DEVICE_CLK_RATE : Device clock frequency in MHz, usually the same as REF_CLK_RATE but it can vary based on the JESD configuration
#   RX_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA )
#   TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links
#   [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M)
#
# NOTE: The Agilex 5 carrier exposes 8 transceiver lanes on the FMC connector,
# of which 4 are routed as receive (DP4..DP7 M2C) and 4 as transmit
# (DP4..DP7 C2M). The maximum usable configuration is therefore
# [RX/TX]_JESD_L * [RX/TX]_NUM_LINKS = 4.
#

adi_project ad9084_ebz_nios_a5e [list \
  JESD_MODE           [get_env_param JESD_MODE        8B10B ] \
  REF_CLK_RATE        [get_env_param REF_CLK_RATE       250 ] \
  DEVICE_CLK_RATE     [get_env_param DEVICE_CLK_RATE    250 ] \
  RX_LANE_RATE        [get_env_param RX_LANE_RATE        10 ] \
  TX_LANE_RATE        [get_env_param TX_LANE_RATE        10 ] \
  RX_JESD_M           [get_env_param RX_JESD_M            4 ] \
  RX_JESD_L           [get_env_param RX_JESD_L            2 ] \
  RX_JESD_S           [get_env_param RX_JESD_S            1 ] \
  RX_JESD_NP          [get_env_param RX_JESD_NP          16 ] \
  RX_NUM_LINKS        [get_env_param RX_NUM_LINKS         2 ] \
  TX_JESD_M           [get_env_param TX_JESD_M            4 ] \
  TX_JESD_L           [get_env_param TX_JESD_L            2 ] \
  TX_JESD_S           [get_env_param TX_JESD_S            1 ] \
  TX_JESD_NP          [get_env_param TX_JESD_NP          16 ] \
  TX_NUM_LINKS        [get_env_param TX_NUM_LINKS         2 ] \
  RX_KS_PER_CHANNEL   [get_env_param RX_KS_PER_CHANNEL   32 ] \
  TX_KS_PER_CHANNEL   [get_env_param TX_KS_PER_CHANNEL   32 ] \
]

source $ad_hdl_dir/projects/common/nios_a5e/nios_a5e_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_3w_spi.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/util_cdc/sync_bits.v
set_global_assignment -name VERILOG_FILE ./gts_refclk_reset.v

# FMC clocks and JESD204 control signals

set_instance_assignment -name IO_STANDARD "CURRENT MODE LOGIC (CML)"          -to fpga_refclk_in_a
set_instance_assignment -name IO_STANDARD "CURRENT MODE LOGIC (CML)"          -to fpga_refclk_in_b
set_instance_assignment -name IO_STANDARD "1.2-V TRUE DIFFERENTIAL SIGNALING" -to rx_device_clk
set_instance_assignment -name IO_STANDARD "1.2-V TRUE DIFFERENTIAL SIGNALING" -to tx_device_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS"                      -to sysref_in
set_instance_assignment -name IO_STANDARD "1.2-V TRUE DIFFERENTIAL SIGNALING" -to syncinb_a0
set_instance_assignment -name IO_STANDARD "1.2-V TRUE DIFFERENTIAL SIGNALING" -to syncinb_b0
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V HSTL"           -to syncoutb_a0
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V HSTL"           -to syncoutb_b0

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to syncinb_a0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to syncinb_b0
#TODO: Fix me
# set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref_in

set_instance_assignment -name GLOBAL_SIGNAL "GLOBAL CLOCK" -to rx_device_clk
set_instance_assignment -name GLOBAL_SIGNAL "GLOBAL CLOCK" -to tx_device_clk

set_location_assignment PIN_AP16  -to "fpga_refclk_in_b"     ; ## D04  GBTCLK0_M2C_P
set_location_assignment PIN_AP21  -to "fpga_refclk_in_b(n)"  ; ## D05  GBTCLK0_M2C_N
set_location_assignment PIN_AV16  -to "fpga_refclk_in_a"     ; ## B20  GBTCLK1_M2C_P
set_location_assignment PIN_AV21  -to "fpga_refclk_in_a(n)"  ; ## B21  GBTCLK1_M2C_N

set_location_assignment PIN_P55   -to "rx_device_clk"        ; ## G02  CLK1_M2C_P
set_location_assignment PIN_T55   -to "rx_device_clk(n)"     ; ## G03  CLK1_M2C_N

set_location_assignment PIN_Y44   -to "tx_device_clk"        ; ## H04  CLK0_M2C_P
set_location_assignment PIN_Y47   -to "tx_device_clk(n)"     ; ## H05  CLK0_M2C_N

set_location_assignment PIN_J1    -to "sysref_in"            ; ## G36  LA33_P
set_location_assignment PIN_G1    -to "sysref_in(n)"         ; ## G37  LA33_N

set_location_assignment PIN_BF1   -to "rx_data_a_p[0]"       ; ## A14  FMC_RX4_P STXA_11_P
set_location_assignment PIN_BF3   -to "rx_data_a_n[0]"       ; ## A15  FMC_RX4_N STXA_11_N
set_location_assignment PIN_BD1   -to "rx_data_a_p[1]"       ; ## A18  FMC_RX5_P STXA_3_P
set_location_assignment PIN_BD3   -to "rx_data_a_n[1]"       ; ## A19  FMC_RX5_N STXA_3_N
set_location_assignment PIN_AV1   -to "rx_data_b_p[0]"       ; ##  C7  FMC_RX0_P STXB_3_P
set_location_assignment PIN_AV3   -to "rx_data_b_n[0]"       ; ##  C8  FMC_RX0_N STXB_3_N
set_location_assignment PIN_AT1   -to "rx_data_b_p[1]"       ; ##  A2  FMC_RX1_P STXB_2_P
set_location_assignment PIN_AT3   -to "rx_data_b_n[1]"       ; ##  A3  FMC_RX1_N STXB_2_N

set_location_assignment PIN_BE7   -to "tx_data_a_p[0]"       ; ## A35  FMC_TX4_P SRXA_5_P
set_location_assignment PIN_BE10  -to "tx_data_a_n[0]"       ; ## A36  FMC_TX4_N SRXA_5_N
set_location_assignment PIN_BC7   -to "tx_data_a_p[1]"       ; ## A38  FMC_TX5_P SRXA_1_P
set_location_assignment PIN_BC10  -to "tx_data_a_n[1]"       ; ## A39  FMC_TX5_N SRXA_1_N
set_location_assignment PIN_AU7   -to "tx_data_b_p[0]"       ; ##  C2  FMC_TX0_P SRXB_1_P
set_location_assignment PIN_AU10  -to "tx_data_b_n[0]"       ; ##  C3  FMC_TX0_N SRXB_1_N
set_location_assignment PIN_AR7   -to "tx_data_b_p[1]"       ; ## A22  FMC_TX1_P SRXB_7_P
set_location_assignment PIN_AR10  -to "tx_data_b_n[1]"       ; ## A23  FMC_TX1_N SRXB_7_N

set_location_assignment PIN_A63   -to "syncinb_a0"           ; ## H10  LA04_P
set_location_assignment PIN_B60   -to "syncinb_a0(n)"        ; ## H11  LA04_N
set_location_assignment PIN_F55   -to "syncinb_b0"           ; ## D14  LA09_P
set_location_assignment PIN_D55   -to "syncinb_b0(n)"        ; ## D15  LA09_N
set_location_assignment PIN_B56   -to "syncoutb_a0"          ; ## D11  LA05_P
set_location_assignment PIN_A60   -to "syncoutb_a0(n)"       ; ## D12  LA05_N
set_location_assignment PIN_M47   -to "syncoutb_b0"          ; ## G12  LA08_P
set_location_assignment PIN_K47   -to "syncoutb_b0(n)"       ; ## G13  LA08_N

set_location_assignment PIN_Y67   -to "syncinb_a1_p_gpio"    ; ## G21  LA20_P
set_location_assignment PIN_Y65   -to "syncinb_a1_n_gpio"    ; ## G22  LA20_N
set_location_assignment PIN_Y77   -to "syncoutb_a1_p_gpio"   ; ## H25  LA21_P
set_location_assignment PIN_Y74   -to "syncoutb_a1_n_gpio"   ; ## H26  LA21_N

# Apollo (DUT) SPI

set_location_assignment PIN_B51   -to "dut_sclk"             ; ## H07  LA02_P
set_location_assignment PIN_A51   -to "dut_csb"              ; ## H08  LA02_N
set_location_assignment PIN_A54   -to "dut_sdio"             ; ## G09  LA03_P
set_location_assignment PIN_B54   -to "dut_sdo"              ; ## G10  LA03_N

# Clock chip / board SPI

set_location_assignment PIN_P74  -to "spi2_sclk"             ; ## H28  LA24_P
set_location_assignment PIN_T74  -to "spi2_sdio"             ; ## H29  LA24_N
set_location_assignment PIN_AC64 -to "spi2_sdo"              ; ## D26  LA26_P
set_location_assignment PIN_AG64 -to "spi2_cs[0]"            ; ## D27  LA26_N
set_location_assignment PIN_F8   -to "spi2_cs[1]"            ; ## G30  LA29_P
set_location_assignment PIN_H8   -to "spi2_cs[2]"            ; ## G31  LA29_N
set_location_assignment PIN_C2   -to "spi2_cs[3]"            ; ## H34  LA30_P
set_location_assignment PIN_D4   -to "spi2_cs[4]"            ; ## H35  LA30_N
set_location_assignment PIN_G2   -to "spi2_cs[5]"            ; ## H37  LA32_P

# FMC GPIOs

set_location_assignment PIN_D44   -to "gpio[15]"             ; ## C10  LA06_P
set_location_assignment PIN_F44   -to "gpio[16]"             ; ## C11  LA06_N
set_location_assignment PIN_F47   -to "gpio[17]"             ; ## H13  LA07_P
set_location_assignment PIN_H47   -to "gpio[18]"             ; ## H14  LA07_N
set_location_assignment PIN_H58   -to "gpio[19]"             ; ## H16  LA11_P
set_location_assignment PIN_F58   -to "gpio[20]"             ; ## H17  LA11_N
set_location_assignment PIN_Y58   -to "gpio[21]"             ; ## G15  LA12_P
set_location_assignment PIN_Y55   -to "gpio[22]"             ; ## G16  LA12_N
set_location_assignment PIN_K44   -to "gpio[23]"             ; ## C18  LA14_P
set_location_assignment PIN_M44   -to "gpio[24]"             ; ## C19  LA14_N
set_location_assignment PIN_V58   -to "gpio[25]"             ; ## H19  LA15_P
set_location_assignment PIN_T58   -to "gpio[26]"             ; ## H20  LA15_N
set_location_assignment PIN_AG57  -to "gpio[27]"             ; ## C22  LA18_CC_P
set_location_assignment PIN_AG53  -to "gpio[28]"             ; ## C23  LA18_CC_N
set_location_assignment PIN_B85   -to "gpio[29]"             ; ## H22  LA19_P
set_location_assignment PIN_A85   -to "gpio[30]"             ; ## H23  LA19_N

set_location_assignment PIN_D24   -to "aux_gpio"             ; ## D24  LA23_N

# Triggers and reset

set_location_assignment PIN_M58   -to "trig_a[0]"            ; ## C14  LA10_P
set_location_assignment PIN_K58   -to "trig_a[1]"            ; ## C15  LA10_N
set_location_assignment PIN_V47   -to "trig_b[0]"            ; ## D17  LA13_P
set_location_assignment PIN_T47   -to "trig_b[1]"            ; ## D18  LA13_N
set_location_assignment PIN_A48   -to "trig_in"              ; ## D09  LA01_CC_N
set_location_assignment PIN_B45   -to "resetb"               ; ## D08  LA01_CC_P

# Apply default main-tap and pre-tap values

## The lane buses are split per PHY, so each half is only TX_L*LINKS/2 wide.
set tx_num_lanes [expr [get_env_param TX_JESD_L 4] * [get_env_param TX_NUM_LINKS 1] / 2]
foreach half {a b} {
  for {set j 0} {$j < $tx_num_lanes} {incr j} {
    foreach pin [list tx_data_${half}_p[$j] tx_data_${half}_n[$j]] {
      set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to $pin

      set_instance_assignment -name HSSI_PARAMETER "tx_eq_main_tap=55"   -to $pin
      set_instance_assignment -name HSSI_PARAMETER "tx_eq_pre_tap_1=0"   -to $pin
      set_instance_assignment -name HSSI_PARAMETER "tx_eq_pre_tap_2=0"   -to $pin
      set_instance_assignment -name HSSI_PARAMETER "tx_eq_post_tap_1=0"  -to $pin
    }
  }
}

set rx_num_lanes [expr [get_env_param RX_JESD_L 4] * [get_env_param RX_NUM_LINKS 1] / 2]
foreach half {a b} {
  for {set j 0} {$j < $rx_num_lanes} {incr j} {
    foreach pin [list rx_data_${half}_p[$j] rx_data_${half}_n[$j]] {
      set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to $pin

    }
  }
}

for {set i 15} {$i < 31} {incr i} {
  set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[$i]
}

foreach port {trig_a[0] trig_a[1] trig_b[0] trig_b[1] trig_in resetb} {
  set_instance_assignment -name IO_STANDARD "1.2 V" -to $port
}

foreach port {dut_sdio dut_sdo dut_sclk dut_csb} {
  set_instance_assignment -name IO_STANDARD "1.2 V" -to $port
}

foreach port {syncinb_a1_p_gpio syncinb_a1_n_gpio syncoutb_a1_p_gpio syncoutb_a1_n_gpio} {
  set_instance_assignment -name IO_STANDARD "1.2 V" -to $port
}

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "Superior Performance with Maximum Placement Effort"

execute_flow -compile
