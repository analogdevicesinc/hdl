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
#   RX_RATE :  Lane rate of the Rx link ( MxFE to FPGA )
#   TX_RATE :  Lane rate of the Tx link ( FPGA to MxFE )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links
#   [RX/TX]_KS_PER_CHANNEL : Number of samples stored in internal buffers in kilosamples per converter (M)
#

 adi_project ad9081_fmca_ebz_fm87 [list \
  RX_LANE_RATE       [get_env_param RX_RATE      10 ] \
  TX_LANE_RATE       [get_env_param TX_RATE      10 ] \
  RX_JESD_M          [get_env_param RX_JESD_M    8 ] \
  RX_JESD_L          [get_env_param RX_JESD_L    8 ] \
  RX_JESD_S          [get_env_param RX_JESD_S    1 ] \
  RX_JESD_NP         [get_env_param RX_JESD_NP   16 ] \
  RX_NUM_LINKS       [get_env_param RX_NUM_LINKS 1 ] \
  TX_JESD_M          [get_env_param TX_JESD_M    8 ] \
  TX_JESD_L          [get_env_param TX_JESD_L    8 ] \
  TX_JESD_S          [get_env_param TX_JESD_S    1 ] \
  TX_JESD_NP         [get_env_param TX_JESD_NP   16 ] \
  TX_NUM_LINKS       [get_env_param TX_NUM_LINKS 1 ] \
  RX_KS_PER_CHANNEL  [get_env_param RX_KS_PER_CHANNEL 32 ] \
  TX_KS_PER_CHANNEL  [get_env_param TX_KS_PER_CHANNEL 32 ] \
]

source $ad_hdl_dir/projects/common/fm87/fm87_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../../../library/common/ad_3w_spi.v

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
#set_location_assignment PIN_BD57   -to "fpga_refclk_in(n)"   ; ## D05  GBTCLK0_M2C_N
set_location_assignment PIN_AM57   -to "fpga_refclk_in"      ; ## D04  GBTCLK0_M2C_P

set_location_assignment PIN_AP69   -to "rx_data[0]"          ; ## C06  DP0_M2C_P
set_location_assignment PIN_AR68   -to "rx_data[0](n)"       ; ## C07  DP0_M2C_N
set_location_assignment PIN_AU66   -to "rx_data[1]"          ; ## A02  DP1_M2C_P
set_location_assignment PIN_AT65   -to "rx_data[1](n)"       ; ## A03  DP1_M2C_N
set_location_assignment PIN_AV69   -to "rx_data[2]"          ; ## A06  DP2_M2C_P
set_location_assignment PIN_AW68   -to "rx_data[2](n)"       ; ## A07  DP2_M2C_N
set_location_assignment PIN_BA66   -to "rx_data[3]"          ; ## A10  DP3_M2C_P
set_location_assignment PIN_AY65   -to "rx_data[3](n)"       ; ## A11  DP3_M2C_N
set_location_assignment PIN_BB69   -to "rx_data[4]"          ;
set_location_assignment PIN_BC68   -to "rx_data[4](n)"       ;
set_location_assignment PIN_BE66   -to "rx_data[5]"          ;
set_location_assignment PIN_BD65   -to "rx_data[5](n)"       ;
set_location_assignment PIN_BF69   -to "rx_data[6]"          ;
set_location_assignment PIN_BG68   -to "rx_data[6](n)"       ;
set_location_assignment PIN_BJ66   -to "rx_data[7]"          ;
set_location_assignment PIN_BH65   -to "rx_data[7](n)"       ;

set_location_assignment PIN_AP63   -to "tx_data[0]"          ; ## C02  DP0_C2M_P
set_location_assignment PIN_AR62   -to "tx_data[0](n)"       ; ## C03  DP0_C2M_N
set_location_assignment PIN_AU60   -to "tx_data[1]"          ; ## A22  DP1_C2M_P
set_location_assignment PIN_AT59   -to "tx_data[1](n)"       ; ## A23  DP1_C2M_N
set_location_assignment PIN_AV63   -to "tx_data[2]"          ; ## A26  DP2_C2M_P
set_location_assignment PIN_AW62   -to "tx_data[2](n)"       ; ## A27  DP2_C2M_N
set_location_assignment PIN_BA60   -to "tx_data[3]"          ; ## A30  DP3_C2M_P
set_location_assignment PIN_AY59   -to "tx_data[3](n)"       ; ## A31  DP3_C2M_N
set_location_assignment PIN_BB63   -to "tx_data[4]"          ;
set_location_assignment PIN_BC62   -to "tx_data[4](n)"       ;
set_location_assignment PIN_BE60   -to "tx_data[5]"          ;
set_location_assignment PIN_BD59   -to "tx_data[5](n)"       ;
set_location_assignment PIN_BF63   -to "tx_data[6]"          ;
set_location_assignment PIN_BG62   -to "tx_data[6](n)"       ;
set_location_assignment PIN_BJ60   -to "tx_data[7]"          ;
set_location_assignment PIN_BH59   -to "tx_data[7](n)"       ;

# set_location_assignment PIN_DH13   -to "rx_data[3](n)"       ; ## A11  DP3_M2C_N
# set_location_assignment PIN_DJ12   -to "rx_data[3]"          ; ## A10  DP3_M2C_P
# set_location_assignment PIN_BW2    -to "rx_data[2](n)"       ; ## A07  DP2_M2C_N
# set_location_assignment PIN_BY1    -to "rx_data[2]"          ; ## A06  DP2_M2C_P
# set_location_assignment PIN_DJ16   -to "rx_data[1](n)"       ; ## A03  DP1_M2C_N
# set_location_assignment PIN_BK15   -to "rx_data[1]"          ; ## A02  DP1_M2C_P
# set_location_assignment PIN_BP5    -to "rx_data[0](n)"       ; ## C07  DP0_M2C_N
# set_location_assignment PIN_BN4    -to "rx_data[0]"          ; ## C06  DP0_M2C_P
# set_location_assignment PIN_CC2    -to "rx_data[7](n)"       ; ## B13  DP7_M2C_N
# set_location_assignment PIN_CD1    -to "rx_data[7]"          ; ## B12  DP7_M2C_P
# set_location_assignment PIN_CF5    -to "rx_data[6](n)"       ; ## B17  DP6_M2C_N
# set_location_assignment PIN_CE4    -to "rx_data[6]"          ; ## B16  DP6_M2C_P
# set_location_assignment PIN_DD9    -to "rx_data[5](n)"       ; ## A19  DP5_M2C_N
# set_location_assignment PIN_DC10   -to "rx_data[5]"          ; ## A18  DP5_M2C_P
# set_location_assignment PIN_DE12   -to "rx_data[4](n)"       ; ## A15  DP4_M2C_N
# set_location_assignment PIN_DD13   -to "rx_data[4]"          ; ## A14  DP4_M2C_P

# set_location_assignment PIN_DM13   -to "tx_data[3](n)"       ; ## A31  DP3_C2M_N
# set_location_assignment PIN_DN12   -to "tx_data[3]"          ; ## A30  DP3_C2M_P
# set_location_assignment PIN_BW8    -to "tx_data[2](n)"       ; ## A27  DP2_C2M_N
# set_location_assignment PIN_BY7    -to "tx_data[2]"          ; ## A26  DP2_C2M_P
# set_location_assignment PIN_DG6    -to "tx_data[1](n)"       ; ## A23  DP1_C2M_N
# set_location_assignment PIN_DF7    -to "tx_data[1]"          ; ## A22  DP1_C2M_P
# set_location_assignment PIN_BV11   -to "tx_data[0](n)"       ; ## C03  DP0_C2M_N
# set_location_assignment PIN_BU10   -to "tx_data[0]"          ; ## C02  DP0_C2M_P
# set_location_assignment PIN_CB11   -to "tx_data[7](n)"       ; ## B33  DP7_C2M_N
# set_location_assignment PIN_CA10   -to "tx_data[7]"          ; ## B32  DP7_C2M_P
# set_location_assignment PIN_BR8    -to "tx_data[6](n)"       ; ## B37  DP6_C2M_N
# set_location_assignment PIN_BT7    -to "tx_data[6]"          ; ## B36  DP6_C2M_P
# set_location_assignment PIN_DH9    -to "tx_data[5](n)"       ; ## A39  DP5_C2M_N
# set_location_assignment PIN_DG10   -to "tx_data[5]"          ; ## A38  DP5_C2M_P
# set_location_assignment PIN_DL10   -to "tx_data[4](n)"       ; ## A35  DP4_C2M_N
# set_location_assignment PIN_DM9    -to "tx_data[4]"          ; ## A34  DP4_C2M_P

set_location_assignment PIN_AB47   -to "fpga_syncin_0(n)"    ; ## H08  LA02_N
set_location_assignment PIN_AA46   -to "fpga_syncin_0"       ; ## H07  LA02_P
# set_location_assignment PIN_P49    -to "fpga_syncin_1_n"     ; ## G10  LA03_N
# set_location_assignment PIN_R48    -to "fpga_syncin_1_p"     ; ## G09  LA03_P
set_location_assignment PIN_T45    -to "fpga_syncout_0(n)"   ; ## D09  LA01_CC_N
set_location_assignment PIN_U44    -to "fpga_syncout_0"      ; ## D08  LA01_CC_P
# set_location_assignment PIN_AB43   -to "fpga_syncout_1_n"    ; ## C11  LA06_N
# set_location_assignment PIN_AA42   -to "fpga_syncout_1_p"    ; ## C10  LA06_P
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

set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_data

set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_data
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data

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

set_instance_assignment -name IO_STANDARD "HCSL" -to fpga_refclk_in
set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to clkin6
set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to fpga_syncin_0
set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to fpga_syncout_0
set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to sysref2
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to fpga_syncin_0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref2
# set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to fpga_syncin_0
# set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to fpga_syncin_1_p
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V HSTL" -to fpga_syncout_0
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V HSTL" -to fpga_syncout_1_p
# set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to sysref2
# set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to fpga_syncin_0
# set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref2

set_instance_assignment -name IO_STANDARD "1.2 V" -to agc0[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc0[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc1[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc1[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc2[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc2[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc3[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to agc3[1]
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
# set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_syncin_0
# set_instance_assignment -name IO_STANDARD "1.2 V" -to "fpga_syncin_0(n)"
# set_instance_assignment -name IO_STANDARD "1.2 V" -to "fpga_syncin_1_n"
# set_instance_assignment -name IO_STANDARD "1.2 V" -to "fpga_syncin_1_p"
set_instance_assignment -name IO_STANDARD "1.2 V" -to "fpga_syncout_0"
set_instance_assignment -name IO_STANDARD "1.2 V" -to "fpga_syncout_0(n)"
# set_instance_assignment -name IO_STANDARD "1.2 V" -to "fpga_syncout_1_n"
# set_instance_assignment -name IO_STANDARD "1.2 V" -to "fpga_syncout_1_p"


# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
#set_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER 1.2

execute_flow -compile