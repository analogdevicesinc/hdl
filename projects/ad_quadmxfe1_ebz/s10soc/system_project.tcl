
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

adi_project ad_quadmxfe1_ebz_s10soc [list \
  RX_LANE_RATE [get_env_param RX_LANE_RATE 10 ] \
  TX_LANE_RATE [get_env_param TX_LANE_RATE 10 ] \
  RX_JESD_M    [get_env_param RX_JESD_M    16 ] \
  RX_JESD_L    [get_env_param RX_JESD_L    4 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  RX_JESD_NP   [get_env_param RX_JESD_NP   16 ] \
  RX_NUM_LINKS [get_env_param RX_NUM_LINKS 4 ] \
  TX_JESD_M    [get_env_param TX_JESD_M    16 ] \
  TX_JESD_L    [get_env_param TX_JESD_L    4 ] \
  TX_JESD_S    [get_env_param TX_JESD_S    1 ] \
  TX_JESD_NP   [get_env_param TX_JESD_NP   16 ] \
  TX_NUM_LINKS [get_env_param TX_NUM_LINKS 4 ] \
  RX_KS_PER_CHANNEL [get_env_param RX_KS_PER_CHANNEL 16 ] \
  TX_KS_PER_CHANNEL [get_env_param TX_KS_PER_CHANNEL 16 ] \
]

source $ad_hdl_dir/projects/common/s10soc/s10soc_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../../../library/common/ad_3w_spi.v
set_global_assignment -name VERILOG_FILE ../../../library/common/ad_iobuf.v
set_global_assignment -name VERILOG_FILE ../common/quad_mxfe_gpio_mux.v

################################################################################
## FMCA+ location assignments (connector P0 on the FMC board)
################################################################################

## ADF4371 SPI interface

set_location_assignment  PIN_BJ19  -to adf4371_cs[0]        ; ## C26  LA27_P
set_location_assignment  PIN_BJ20  -to adf4371_cs[1]        ; ## C27  LA27_N
set_location_assignment  PIN_BH18  -to adf4371_cs[2]        ; ## D26  LA26_P
set_location_assignment  PIN_BJ18  -to adf4371_cs[3]        ; ## D27  LA26_N
set_location_assignment  PIN_BG17  -to adf4371_sclk         ; ## C22  LA18_P_CC
set_location_assignment  PIN_BH17  -to adf4371_sdio         ; ## C23  LA18_N_CC
set_location_assignment  PIN_BC35  -to adrf5020_ctrl        ; ## D24  LA23_N

set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4371_cs[0]
set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4371_cs[1]
set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4371_cs[2]
set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4371_cs[3]
set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4371_sclk
set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4371_sdio
set_instance_assignment  -name IO_STANDARD "1.8V" -to adrf5020_ctrl

## ad_quadmxfe1_ebz TX high speed lanes

set_location_assignment  PIN_BC47  -to c2m[0]               ; ## A38  DP5_C2M_P
set_location_assignment  PIN_AV49  -to c2m[1]               ; ## Z28  DP12_C2M_P
set_location_assignment  PIN_AR47  -to c2m[2]               ; ## Y30  DP13_C2M_P
set_location_assignment  PIN_AU47  -to c2m[3]               ; ## Y26  DP11_C2M_P
set_location_assignment  PIN_BE47  -to c2m[4]               ; ## A30  DP3_C2M_P
set_location_assignment  PIN_BA47  -to c2m[5]               ; ## B32  DP7_C2M_P
set_location_assignment  PIN_BF49  -to c2m[6]               ; ## A34  DP4_C2M_P
set_location_assignment  PIN_BD49  -to c2m[7]               ; ## B36  DP6_C2M_P
set_location_assignment  PIN_AY49  -to c2m[8]               ; ## Z24  DP10_C2M_P
set_location_assignment  PIN_AW47  -to c2m[9]               ; ## B24  DP9_C2M_P
set_location_assignment  PIN_BG47  -to c2m[10]              ; ## A26  DP2_C2M_P
set_location_assignment  PIN_BB49  -to c2m[11]              ; ## B28  DP8_C2M_P
set_location_assignment  PIN_BJ46  -to c2m[12]              ; ## C2   DP0_C2M_P
set_location_assignment  PIN_AT49  -to c2m[13]              ; ## M18  DP14_C2M_P
set_location_assignment  PIN_BF45  -to c2m[14]              ; ## A22  DP1_C2M_P
set_location_assignment  PIN_AP49  -to c2m[15]              ; ## M22  DP15_C2M_P

## ad_quadmxfe1_ebz RX high speed lanes

set_location_assignment  PIN_BD45  -to m2c[0]               ; ## A18  DP5_M2C_P
set_location_assignment  PIN_AP45  -to m2c[1]               ; ## Y18  DP14_M2C_P
set_location_assignment  PIN_AN43  -to m2c[2]               ; ## Y22  DP15_M2C_P
set_location_assignment  PIN_AT45  -to m2c[3]               ; ## Z16  DP13_M2C_P
set_location_assignment  PIN_BE43  -to m2c[4]               ; ## A10  DP3_M2C_P
set_location_assignment  PIN_BB45  -to m2c[5]               ; ## B12  DP7_M2C_P
set_location_assignment  PIN_BC43  -to m2c[6]               ; ## A14  DP4_M2C_P
set_location_assignment  PIN_BA43  -to m2c[7]               ; ## B16  DP6_M2C_P
set_location_assignment  PIN_BG43  -to m2c[8]               ; ## A6   DP2_M2C_P
set_location_assignment  PIN_AY45  -to m2c[9]               ; ## B4   DP9_M2C_P
set_location_assignment  PIN_BH41  -to m2c[10]              ; ## C6   DP0_M2C_P
set_location_assignment  PIN_AW43  -to m2c[11]              ; ## B8   DP8_M2C_P
set_location_assignment  PIN_AR43  -to m2c[12]              ; ## Y14  DP12_M2C_P
set_location_assignment  PIN_AV45  -to m2c[13]              ; ## Z12  DP11_M2C_P
set_location_assignment  PIN_AU43  -to m2c[14]              ; ## Y10  DP10_M2C_P
set_location_assignment  PIN_BJ43  -to m2c[15]              ; ## A2   DP1_M2C_P

set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to m2c
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to c2m

set common_lanes 0
set common_lanes [get_env_param RX_JESD_L 16]
if {$common_lanes > [get_env_param TX_JESD_L 16]} {
  set common_lanes [get_env_param TX_JESD_L 16]
}

set tx_lane_map {12 14 10 4 6 0 7 5 11 9 8 3 1 2 13 15}
set rx_lane_map {10 15 8 4 6 0 7 5 11 9 14 13 12 3 1 2}

# Merge RX and TX into single transceiver
for {set i 0} {$i < $common_lanes} {incr i} {
  set tx_cur_lane [lindex $tx_lane_map $i]
  set rx_cur_lane [lindex $rx_lane_map $i]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to c2m[${tx_cur_lane}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to m2c[${rx_cur_lane}]
}

## clocks and synchronization signals

set_location_assignment  PIN_AW30  -to fpga_sysref_c2m      ; ## G6   LA00_P_CC
set_location_assignment  PIN_AR19  -to fpga_sysref_m2c      ; ## G2   CLK1_M2C_P
set_location_assignment  PIN_AP41  -to fpga_clk_m2c[0]      ; ## D4   GBTCLK0_M2C_P
set_location_assignment  PIN_AT17  -to fpga_clk_m2c[1]      ; ## D20  LA17_P_CC
set_location_assignment  PIN_BF21  -to fpga_clk_m2c[2]      ; ## H4   CLK0_M2C_P

set_location_assignment  PIN_AU35  -to mxfe_syncin_0_n      ; ## G31  LA29_N
set_location_assignment  PIN_AT16  -to mxfe_syncin_1_n      ; ## H17  LA11_N
set_location_assignment  PIN_BB20  -to mxfe_syncin_2_n      ; ## K8   HA02_N
set_location_assignment  PIN_BJ31  -to mxfe_syncin_3_n      ; ## E13  HA13_N

set_location_assignment  PIN_BG20  -to mxfe_syncin_0_p      ; ## G28  LA25_N
set_location_assignment  PIN_AV35  -to mxfe_syncin_1_p      ; ## G30  LA29_P
set_location_assignment  PIN_BE34  -to mxfe_syncin_2_p      ; ## H38  LA32_N
set_location_assignment  PIN_AT15  -to mxfe_syncin_3_p      ; ## H16  LA11_P
set_location_assignment  PIN_BF17  -to mxfe_syncin_4_p      ; ## J22  HA22_N
set_location_assignment  PIN_BC20  -to mxfe_syncin_5_p      ; ## K7   HA02_P
set_location_assignment  PIN_AY32  -to mxfe_syncin_6_p      ; ## E10  HA09_N
set_location_assignment  PIN_BH31  -to mxfe_syncin_7_p      ; ## E12  HA13_P

set_location_assignment  PIN_BG35  -to mxfe_syncout_0_n     ; ## G34  LA31_N
set_location_assignment  PIN_AN18  -to mxfe_syncout_1_n     ; ## H20  LA15_N
set_location_assignment  PIN_BD20  -to mxfe_syncout_2_n     ; ## K11  HA06_N
set_location_assignment  PIN_AV20  -to mxfe_syncout_3_n     ; ## E16  HA16_N

set_location_assignment  PIN_BF20  -to mxfe_syncout_0_p     ; ## G27  LA25_P
set_location_assignment  PIN_BH35  -to mxfe_syncout_1_p     ; ## G33  LA31_P
set_location_assignment  PIN_BE33  -to mxfe_syncout_2_p     ; ## H37  LA32_P
set_location_assignment  PIN_AN17  -to mxfe_syncout_3_p     ; ## H19  LA15_P
set_location_assignment  PIN_BE17  -to mxfe_syncout_4_p     ; ## J21  HA22_P
set_location_assignment  PIN_BD19  -to mxfe_syncout_5_p     ; ## K10  HA06_P
set_location_assignment  PIN_AY31  -to mxfe_syncout_6_p     ; ## E9   HA09_P
set_location_assignment  PIN_AV21  -to mxfe_syncout_7_p     ; ## E15  HA16_P

set_instance_assignment  -name IO_STANDARD LVDS -to fpga_sysref_c2m
set_instance_assignment  -name IO_STANDARD LVDS -to fpga_sysref_m2c
set_instance_assignment  -name IO_STANDARD LVDS -to fpga_clk_m2c[0]
set_instance_assignment  -name IO_STANDARD LVDS -to fpga_clk_m2c[1]
set_instance_assignment  -name IO_STANDARD LVDS -to fpga_clk_m2c[2]

set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_0_n
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_1_n
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_2_n
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_3_n

set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_0_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_1_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_2_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_3_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_4_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_5_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_6_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncin_7_p

set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_0_n
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_1_n
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_2_n
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_3_n

set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_0_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_1_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_2_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_3_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_4_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_5_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_6_p
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_syncout_7_p

set_instance_assignment  -name INPUT_TERMINATION DIFFERENTIAL -to fpga_clk_m2c[1]
set_instance_assignment  -name INPUT_TERMINATION DIFFERENTIAL -to fpga_clk_m2c[2]
set_instance_assignment  -name INPUT_TERMINATION DIFFERENTIAL -to fpga_sysref_m2c

## HMC425 GPIOs

set_location_assignment  PIN_AT32  -to hmc425a_v[1]         ; ## C19  LA14_N
set_location_assignment  PIN_AU32  -to hmc425a_v[2]         ; ## C18  LA14_P
set_location_assignment  PIN_BB34  -to hmc425a_v[3]         ; ## C15  LA10_N
set_location_assignment  PIN_BB33  -to hmc425a_v[4]         ; ## C14  LA10_P

set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc425a_v[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc425a_v[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc425a_v[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc425a_v[4]

## HMC7043 SPI interface

set_location_assignment  PIN_BC36  -to hmc7043_gpio         ; ## D23  LA23_P
set_location_assignment  PIN_AT21  -to hmc7043_reset        ; ## D17  LA13_P
set_location_assignment  PIN_BF31  -to hmc7043_sclk         ; ## C10  LA06_P
set_location_assignment  PIN_BF30  -to hmc7043_sdata        ; ## C11  LA06_N
set_location_assignment  PIN_AR21  -to hmc7043_slen         ; ## D18  LA13_N

set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc7043_gpio
set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc7043_reset
set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc7043_sclk
set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc7043_sdata
set_instance_assignment  -name IO_STANDARD "1.8V"  -to hmc7043_slen

## ad_quadmxfe1_ebz SPI interface

set_location_assignment  PIN_AV32  -to mxfe_cs[0]           ; ## F8   HA04_N
set_location_assignment  PIN_BD30  -to mxfe_cs[1]           ; ## H11  LA04_N
set_location_assignment  PIN_BA11  -to mxfe_cs[2]           ; ## K20  HA21_N
set_location_assignment  PIN_BH30  -to mxfe_cs[3]           ; ## D12  LA05_N
set_location_assignment  PIN_BB12  -to mxfe_miso[0]         ; ## F5   HA00_N_CC
set_location_assignment  PIN_BC32  -to mxfe_miso[1]         ; ## G10  LA03_N
set_location_assignment  PIN_AW11  -to mxfe_miso[2]         ; ## K17  HA17_N_CC
set_location_assignment  PIN_BE31  -to mxfe_miso[3]         ; ## D9   LA01_N_CC
set_location_assignment  PIN_AV33  -to mxfe_mosi[0]         ; ## F7   HA04_P
set_location_assignment  PIN_BC30  -to mxfe_mosi[1]         ; ## H10  LA04_P
set_location_assignment  PIN_BA10  -to mxfe_mosi[2]         ; ## K19  HA21_P
set_location_assignment  PIN_BG30  -to mxfe_mosi[3]         ; ## D11  LA05_P
set_location_assignment  PIN_BH32  -to mxfe_reset[0]        ; ## G12  LA08_P
set_location_assignment  PIN_BE18  -to mxfe_reset[1]        ; ## H22  LA19_P
set_location_assignment  PIN_BB30  -to mxfe_reset[2]        ; ## J6   HA03_P
set_location_assignment  PIN_AW28  -to mxfe_reset[3]        ; ## F13  HA12_P
set_location_assignment  PIN_BE32  -to mxfe_rx_en0[1]       ; ## H13  LA07_P
set_location_assignment  PIN_AW19  -to mxfe_rx_en0[2]       ; ## K13  HA10_P
set_location_assignment  PIN_BA12  -to mxfe_rx_en0[3]       ; ## E18  HA20_P
set_location_assignment  PIN_BF32  -to mxfe_rx_en1[1]       ; ## H14  LA07_N
set_location_assignment  PIN_AW20  -to mxfe_rx_en1[2]       ; ## K14  HA10_N
set_location_assignment  PIN_AY12  -to mxfe_rx_en1[3]       ; ## E19  HA20_N
set_location_assignment  PIN_BC12  -to mxfe_sclk[0]         ; ## F4   HA00_P_CC
set_location_assignment  PIN_BC31  -to mxfe_sclk[1]         ; ## G9   LA03_P
set_location_assignment  PIN_AY11  -to mxfe_sclk[2]         ; ## K16  HA17_P_CC
set_location_assignment  PIN_BD31  -to mxfe_sclk[3]         ; ## D8   LA01_P_CC

set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_cs[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_cs[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_cs[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_cs[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_miso[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_miso[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_miso[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_miso[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_mosi[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_mosi[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_mosi[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_mosi[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_reset[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_reset[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_reset[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_reset[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_rx_en0[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_rx_en0[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_rx_en0[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_rx_en1[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_rx_en1[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_rx_en1[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_sclk[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_sclk[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_sclk[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_sclk[3]

## ad_quadmxfe1_ebz GPIO lines

set_location_assignment  PIN_BD33  -to mxfe_tx_en0[0]       ; ## F10  HA08_P
set_location_assignment  PIN_AN20  -to mxfe_tx_en0[1]       ; ## H7   LA02_P
set_location_assignment  PIN_BC18  -to mxfe_tx_en0[2]       ; ## K22  HA23_P
set_location_assignment  PIN_BA31  -to mxfe_tx_en0[3]       ; ## D14  LA09_P
set_location_assignment  PIN_BC33  -to mxfe_tx_en1[0]       ; ## F11  HA08_N
set_location_assignment  PIN_AP20  -to mxfe_tx_en1[1]       ; ## H8   LA02_N
set_location_assignment  PIN_BB18  -to mxfe_tx_en1[2]       ; ## K23  HA23_N
set_location_assignment  PIN_BA30  -to mxfe_tx_en1[3]       ; ## D15  LA09_N
set_location_assignment  PIN_BG32  -to mxfe0_gpio[0]        ; ## G13  LA08_N
set_location_assignment  PIN_AU29  -to mxfe0_gpio[1]        ; ## G15  LA12_P
set_location_assignment  PIN_AU28  -to mxfe0_gpio[2]        ; ## G16  LA12_N
set_location_assignment  PIN_BA20  -to mxfe0_gpio[3]        ; ## G18  LA16_P
set_location_assignment  PIN_BA21  -to mxfe0_gpio[4]        ; ## G19  LA16_N
set_location_assignment  PIN_AN21  -to mxfe0_gpio[5]        ; ## G21  LA20_P
set_location_assignment  PIN_AP21  -to mxfe0_gpio[6]        ; ## G22  LA20_N
set_location_assignment  PIN_BJ35  -to mxfe0_gpio[7]        ; ## G24  LA22_P
set_location_assignment  PIN_BJ36  -to mxfe0_gpio[8]        ; ## G25  LA22_N
set_location_assignment  PIN_BD18  -to mxfe1_gpio[0]        ; ## H23  LA19_N
set_location_assignment  PIN_BG18  -to mxfe1_gpio[1]        ; ## H25  LA21_P
set_location_assignment  PIN_BG19  -to mxfe1_gpio[2]        ; ## H26  LA21_N
set_location_assignment  PIN_BH20  -to mxfe1_gpio[3]        ; ## H28  LA24_P
set_location_assignment  PIN_BH21  -to mxfe1_gpio[4]        ; ## H29  LA24_N
set_location_assignment  PIN_BF36  -to mxfe1_gpio[5]        ; ## H31  LA28_P
set_location_assignment  PIN_BF35  -to mxfe1_gpio[6]        ; ## H32  LA28_N
set_location_assignment  PIN_BE36  -to mxfe1_gpio[7]        ; ## H34  LA30_P
set_location_assignment  PIN_BD36  -to mxfe1_gpio[8]        ; ## H35  LA30_N
set_location_assignment  PIN_BB29  -to mxfe2_gpio[0]        ; ## J7   HA03_N
set_location_assignment  PIN_BD29  -to mxfe2_gpio[1]        ; ## J9   HA07_P
set_location_assignment  PIN_BE29  -to mxfe2_gpio[2]        ; ## J10  HA07_N
set_location_assignment  PIN_AW21  -to mxfe2_gpio[3]        ; ## J12  HA11_P
set_location_assignment  PIN_AY21  -to mxfe2_gpio[4]        ; ## J13  HA11_N
set_location_assignment  PIN_AW13  -to mxfe2_gpio[5]        ; ## J15  HA14_P
set_location_assignment  PIN_AY13  -to mxfe2_gpio[6]        ; ## J16  HA14_N
set_location_assignment  PIN_AV11  -to mxfe2_gpio[7]        ; ## J18  HA18_P
set_location_assignment  PIN_AV12  -to mxfe2_gpio[8]        ; ## J19  HA18_N
set_location_assignment  PIN_AV28  -to mxfe3_gpio[0]        ; ## F14  HA12_N
set_location_assignment  PIN_BB19  -to mxfe3_gpio[1]        ; ## F16  HA15_P
set_location_assignment  PIN_BA19  -to mxfe3_gpio[2]        ; ## F17  HA15_N
set_location_assignment  PIN_AT20  -to mxfe3_gpio[3]        ; ## F19  HA19_P
set_location_assignment  PIN_AU20  -to mxfe3_gpio[4]        ; ## F20  HA19_N
set_location_assignment  PIN_BC10  -to mxfe3_gpio[5]        ; ## E2   HA01_P_CC
set_location_assignment  PIN_BB10  -to mxfe3_gpio[6]        ; ## E3   HA01_N_CC
set_location_assignment  PIN_AU30  -to mxfe3_gpio[7]        ; ## E6   HA05_P
set_location_assignment  PIN_AV30  -to mxfe3_gpio[8]        ; ## E7   HA05_N

set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_tx_en0[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_tx_en0[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_tx_en0[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_tx_en0[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_tx_en1[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_tx_en1[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_tx_en1[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe_tx_en1[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[0] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[1] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[2] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[3] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[4] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[5] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[6] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[7] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe0_gpio[8] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[0] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[1] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[2] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[3] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[4] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[5] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[6] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[7] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe1_gpio[8] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[0] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[1] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[2] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[3] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[4] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[5] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[6] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[7] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe2_gpio[8] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[0] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[1] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[2] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[3] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[4] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[5] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[6]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[7] 
set_instance_assignment  -name IO_STANDARD "1.8V"  -to mxfe3_gpio[8] 

# set optimization to get a better timing and placement closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
set_global_assignment -name GLOBAL_PLACEMENT_EFFORT "MAXIMUM EFFORT"

execute_flow -compile
