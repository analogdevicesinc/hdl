source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

 adi_project ad9081_fmca_ebz_intel_ip_fm87 [list \
  RX_LANE_RATE       [get_env_param RX_LANE_RATE      10 ] \
  TX_LANE_RATE       [get_env_param TX_LANE_RATE      10 ] \
  RX_JESD_M          [get_env_param RX_JESD_M          8 ] \
  RX_JESD_L          [get_env_param RX_JESD_L          8 ] \
  RX_JESD_S          [get_env_param RX_JESD_S          1 ] \
  RX_JESD_NP         [get_env_param RX_JESD_NP        16 ] \
  RX_NUM_LINKS       [get_env_param RX_NUM_LINKS       1 ] \
  RX_WIDTH_MULP      [get_env_param RX_WIDTH_MULP      4 ] \
  RX_KS_PER_CHANNEL  [get_env_param RX_KS_PER_CHANNEL 32 ] \
  TX_JESD_M          [get_env_param TX_JESD_M          8 ] \
  TX_JESD_L          [get_env_param TX_JESD_L          8 ] \
  TX_JESD_S          [get_env_param TX_JESD_S          1 ] \
  TX_JESD_NP         [get_env_param TX_JESD_NP        16 ] \
  TX_NUM_LINKS       [get_env_param TX_NUM_LINKS       1 ] \
  TX_WIDTH_MULP      [get_env_param TX_WIDTH_MULP      4 ] \
  TX_KS_PER_CHANNEL  [get_env_param TX_KS_PER_CHANNEL 32 ] \
]

source $ad_hdl_dir/projects/common/fm87/fm87_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_3w_spi.v
set_global_assignment -name VERILOG_FILE ../../common/fm87/gpio_slave.v
set_global_assignment -name VERILOG_FILE ../../common/fm87/switch_debouncer.v

set_instance_assignment -name IO_STANDARD "HCSL" -to fpga_refclk_in
foreach port {clkin6 fpga_syncin_0 fpga_syncin_1 fpga_syncout_0 fpga_syncout_1 sysref2} {
  set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to $port
}
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to fpga_syncin_0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to fpga_syncout_0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref2

# CLK
set_location_assigment PIN_AY57 -to "fpga_refclk_in"    ; ## D4  GBTCLK0_M2C_P
set_location_assigment PIN_BA56 -to "fpga_refclk_in(n)" ; ## D5  GBTCLK0_M2C_N
set_location_assigment PIN_U42  -to "clkin6"            ; ## G2  CLK1_M2C_P
set_location_assigment PIN_T43  -to "clkin6(n)"         ; ## G3  CLK1_M2C_N
set_location_assigment PIN_E54  -to "sysref2"           ; ## H4  CLK0_M2C_P
set_location_assigment PIN_D55  -to "sysref2(n)"        ; ## H5  CLK0_M2C_N
# -- Unused CLKs
#set_location_assigment PIN_R46  -to ""                 ; ## G6  LA00_P_CC
#set_location_assigment PIN_P47  -to ""                 ; ## G7  LA00_N_CC
#set_location_assigment PIN_BB57 -to ""                 ; ## B20 CLKIN8_P
#set_location_assigment PIN_BD57 -to ""                 ; ## B21 CLKIN8_N
#set_location_assigment PIN_G52  -to ""                 ; ## K4  CLK2_BIDIR_P
#set_location_assigment PIN_F53  -to ""                 ; ## K5  CLK2_BIDIR_N
# -----
# AGC
set_location_assignment PIN_J50 -to "agc0[0]"           ; ## D20 LA17_P_CC
set_location_assignment PIN_K51 -to "agc0[1]"           ; ## D21 LA17_N_CC
set_location_assignment PIN_G50 -to "agc1[0]"           ; ## C22 LA18_P_CC
set_location_assignment PIN_F51 -to "agc1[1]"           ; ## C23 LA18_N_CC
set_location_assignment PIN_A60 -to "agc2[0]"           ; ## G21 LA20_P
set_location_assignment PIN_B61 -to "agc2[1]"           ; ## G22 LA20_N
set_location_assignment PIN_J46 -to "agc3[0]"           ; ## H25 LA21_P
set_location_assignment PIN_K47 -to "agc3[1]"           ; ## H26 LA21_N
# GPIO
set_location_assignment PIN_W44 -to "gpio[ 0]"          ; ## H19 LA15_P
set_location_assignment PIN_Y45 -to "gpio[ 1]"          ; ## H20 LA15_N
set_location_assignment PIN_J48 -to "gpio[ 2]"          ; ## H22 LA19_P
set_location_assignment PIN_K49 -to "gpio[ 3]"          ; ## H23 LA19_N
set_location_assignment PIN_E60 -to "gpio[ 4]"          ; ## D17 LA13_P
set_location_assignment PIN_D61 -to "gpio[ 5]"          ; ## D18 LA13_N
set_location_assignment PIN_J56 -to "gpio[ 6]"          ; ## C18 LA14_P
set_location_assignment PIN_K57 -to "gpio[ 7]"          ; ## C19 LA14_N
set_location_assignment PIN_W42 -to "gpio[ 8]"          ; ## G18 LA16_P
set_location_assignment PIN_Y43 -to "gpio[ 9]"          ; ## G19 LA16_N
set_location_assignment PIN_B59 -to "gpio[10]"          ; ## G25 LA22_N
# RX
set_location_assigment PIN_BE66 -to "rx_data[0]"        ; ## A6  DP2_M2C_P
set_location_assigment PIN_BD65 -to "rx_data[0](n)"     ; ## A7  DP2_M2C_N
set_location_assigment PIN_BJ66 -to "rx_data[1]"        ; ## C7  DP7_M2C_P
set_location_assigment PIN_BH65 -to "rx_data[1](n)"     ; ## C7  DP7_M2C_N
set_location_assigment PIN_AP69 -to "rx_data[2]"        ; ## B12 DP6_M2C_P
set_location_assigment PIN_AR68 -to "rx_data[2](n)"     ; ## B13 DP6_M2C_N
set_location_assigment PIN_AU66 -to "rx_data[3]"        ; ## B16 DP1_C2M_P
set_location_assigment PIN_AT65 -to "rx_data[3](n)"     ; ## B17 DP1_C2M_N
set_location_assigment PIN_AV69 -to "rx_data[4]"        ; ## A18 DP5_C2M_P
set_location_assigment PIN_AW68 -to "rx_data[4](n)"     ; ## A19 DP5_C2M_N
set_location_assigment PIN_BA66 -to "rx_data[5]"        ; ## A14 DP4_M2C_P
set_location_assigment PIN_AY65 -to "rx_data[5](n)"     ; ## A15 DP4_M2C_N
set_location_assigment PIN_BB69 -to "rx_data[6]"        ; ## A10 DP3_M2C_P
set_location_assigment PIN_BC68 -to "rx_data[6](n)"     ; ## A11 DP3_M2C_N
set_location_assigment PIN_BF69 -to "rx_data[7]"        ; ## A2  DP1_M2C_P
set_location_assigment PIN_BG68 -to "rx_data[7](n)"     ; ## A3  DP1_M2C_N
# TX
set_location_assigment PIN_BJ60 -to "tx_data[0]"        ; ## C2  DP0_C2M_P
set_location_assigment PIN_BH59 -to "tx_data[0](n)"     ; ## C3  DP0_C2M_N
set_location_assigment PIN_BE60 -to "tx_data[1]"        ; ## A26 DP2_C2M_P
set_location_assigment PIN_BD59 -to "tx_data[1](n)"     ; ## A27 DP2_C2M_N
set_location_assigment PIN_AP63 -to "tx_data[2]"        ; ## B32 DP7_C2M_P
set_location_assigment PIN_AR62 -to "tx_data[2](n)"     ; ## B33 DP7_C2M_N
set_location_assigment PIN_AU60 -to "tx_data[3]"        ; ## B36 DP6_C2M_P
set_location_assigment PIN_AT59 -to "tx_data[3](n)"     ; ## B37 DP6_C2M_N
set_location_assigment PIN_BF63 -to "tx_data[4]"        ; ## A22 DP1_C2M_P
set_location_assigment PIN_BG62 -to "tx_data[4](n)"     ; ## A23 DP1_C2M_N
set_location_assigment PIN_AV63 -to "tx_data[5]"        ; ## A38 DP5_C2M_P
set_location_assigment PIN_AW62 -to "tx_data[5](n)"     ; ## A39 DP5_C2M_N
set_location_assigment PIN_BA60 -to "tx_data[6]"        ; ## A34 DP4_C2M_P
set_location_assigment PIN_AY59 -to "tx_data[6](n)"     ; ## A35 DP4_C2M_N
set_location_assigment PIN_BB63 -to "tx_data[7]"        ; ## A30 DP3_C2M_P
set_location_assigment PIN_BC62 -to "tx_data[7](n)"     ; ## A31 DP3_C2M_N
# RXEN
set_location_assigment PIN_J52  -to "rxen[0]"           ; ## C14 LA10_P
set_location_assigment PIN_K53  -to "rxen[1]"           ; ## C15 LA10_N
# TXEN
set_location_assigment PIN_J54  -to "txen[0]"           ; ## D14 LA09_P
set_location_assigment PIN_K55  -to "txen[1]"           ; ## D15 LA09_N
# Unused interfaces
#set_location_assigment PIN_E64  -to ""                 ; ## C30 SCL
#set_location_assigment PIN_D65  -to ""                 ; ## C31 SDA
#set_location_assigment PIN_V5   -to ""                 ; ## D1  PG_C2M
# -----
# SYNCOUT
set_location_assigment PIN_U44  -to "fpga_syncout_0"    ; ## D8  LA01_P_CC
set_location_assigment PIN_T45  -to "fpga_syncout_0(n)" ; ## D9  LA01_N_CC
set_location_assigment PIN_AA42 -to "fpga_syncout_1"    ; ## C10 LA06_P
set_location_assigment PIN_AB43 -to "fpga_syncout_1(n)" ; ## C11 LA06_N

# SYNCIN
set_location_assigment PIN_AA46 -to "fpga_syncin_0"     ; ## H7  LA02_P
set_location_assigment PIN_AB47 -to "fpga_syncin_0(n)"  ; ## H8  LA02_N
set_location_assigment PIN_R48  -to "fpga_syncin_1"     ; ## G9  LA03_P
set_location_assigment PIN_P49  -to "fpga_syncin_1(n)"  ; ## G10 LA03_N
# IRQ
set_location_assigment PIN_AE46 -to "irqb[0]"           ; ## G12 LA08_P
set_location_assigment PIN_AD47 -to "irqb[1]"           ; ## G13 LA08_N
# RSTB
set_location_assigment PIN_W46  -to "rstb"              ; ## H13 LA07_P
# HMC
set_location_assigment PIN_Y47  -to "hmc_sync"          ; ## H14 LA07_N
set_location_assigment PIN_T47  -to "hmc_gpio1"         ; ## H17 LA11_N
# SPI 0
set_location_assigment PIN_L50  -to "spi0_csb"          ; ## D11 LA05_P
set_location_assigment PIN_M51  -to "spi0_miso"         ; ## D12 LA05_N
set_location_assigment PIN_AB45 -to "spi0_mosi"         ; ## H10 LA04_P
set_location_assigment PIN_AA44 -to "spi0_sclk"         ; ## H11 LA04_N
# SPI 1
set_location_assigment PIN_AE44 -to "spi1_csb"          ; ## G15 LA12_P
set_location_assigment PIN_U46  -to "spi1_sclk"         ; ## H16 LA11_P
set_location_assigment PIN_AD45 -to "spi1_sdio"         ; ## G16 LA12_N

# FMC ports not connected to the FPGA:
# C39 D36 D38 D40 E39 F40 G39 H40 J3 C34 C35 C37 D32 D35

# Non-FMC signals
# HIGH to supply GBTCLK0_M2C_P/N
set_location_assigment PIN_K2 -to "mux_fpga_clkin"      ; ## MUX_SEL1
# HIGH to supply CLKIN8_P/N (unused)
#set_location_assigment PIN_K1 -to ""                   ; ## MUX_SEL2

set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_data
for {set i 0} {$i < 11} {incr i} {
  set_instance_assignment -name IO_STANDARD "1.2 V" -to gpio[$i]
}
foreach port {agc0 agc1 agc2 agc3 irqb rxen txen} {
  foreach i {0 1} {
    set_instance_assignment -name IO_STANDARD "1.2 V" -to $port[$i]
  }
}
set single_signals
foreach port {hmc_gpio1 hmc_sync rstb spi0_csb spi0_miso spi0_mosi spi0_sclk spi1_csb spi1_sclk spi1_sdio} {
  set_instance_assignment -name IO_STANDARD "1.2 V" -to $port
}

set_instance_assignment -name IO_STANDARD "1.2 V" -to  mux_fpga_clkin

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

execute_flow -compile
