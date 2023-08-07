###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project adrv9026_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_assign.tcl

#adrv9026

set_location_assignment PIN_N29 -to ref_clk                ; ## D4   FMCA_GBTCLK0_M2C_P  REFCLK_GXBL1H_CHTp
set_location_assignment PIN_N28 -to "ref_clk(n)"           ; ## D5   FMCA_GBTCLK0_M2C_N  REFCLK_GXBL1H_CHTn
#set_location_assignment PIN_E5  -to core_clk               ; ## H4   FMCA_CLK0_M2C_P     IO,CLK_3G_1p,LVDS3G_12p
#set_location_assignment PIN_F5  -to "core_clk(n)"          ; ## H5   FMCA_CLK0_M2C_N     IO,CLK_3G_1n,LVDS3G_12n

set_instance_assignment -name IO_STANDARD LVDS -to core_clk

set_location_assignment PIN_R33 -to rx_serial_data[0]      ; ## A2   FMCA_DP01_M2C_P     GXBL1H_RX_CH1p,GXBL1H_REFCLK1p
set_location_assignment PIN_R32 -to "rx_serial_data[0](n)" ; ## A3   FMCA_DP01_M2C_N     GXBL1H_RX_CH1n,GXBL1H_REFCLK1n
set_location_assignment PIN_T31 -to rx_serial_data[1]      ; ## C6   FMCA_DP00_M2C_P     GXBL1H_RX_CH0p,GXBL1H_REFCLK0p
set_location_assignment PIN_T30 -to "rx_serial_data[1](n)" ; ## C7   FMCA_DP00_M2C_N     GXBL1H_RX_CH0n,GXBL1H_REFCLK0n
set_location_assignment PIN_P35 -to rx_serial_data[2]      ; ## A6   FMCA_DP02_M2C_P     GXBL1H_RX_CH2p,GXBL1H_REFCLK2p
set_location_assignment PIN_P34 -to "rx_serial_data[2](n)" ; ## A7   FMCA_DP02_M2C_N     GXBL1H_RX_CH2n,GXBL1H_REFCLK2n
set_location_assignment PIN_P31 -to rx_serial_data[3]      ; ## A10  FMCA_DP03_M2C_P     GXBL1H_RX_CH3p,GXBL1H_REFCLK3p
set_location_assignment PIN_P30 -to "rx_serial_data[3](n)" ; ## A11  FMCA_DP03_M2C_N     GXBL1H_RX_CH3n,GXBL1H_REFCLK3n

set_location_assignment PIN_M39 -to tx_serial_data[0]      ; ## A22  FMCA_DP01_C2M_P     GXBL1H_TX_CH1p
set_location_assignment PIN_M38 -to "tx_serial_data[0](n)" ; ## A23  FMCA_DP01_C2M_N     GXBL1H_TX_CH1n
set_location_assignment PIN_N37 -to tx_serial_data[1]      ; ## C2   FMCA_DP00_C2M_P     GXBL1H_TX_CH0p
set_location_assignment PIN_N36 -to "tx_serial_data[1](n)" ; ## C3   FMCA_DP00_C2M_N     GXBL1H_TX_CH0n
set_location_assignment PIN_L37 -to tx_serial_data[2]      ; ## A26  FMCA_DP02_C2M_P     GXBL1H_TX_CH2p
set_location_assignment PIN_L36 -to "tx_serial_data[2](n)" ; ## A27  FMCA_DP02_C2M_N     GXBL1H_TX_CH2n
set_location_assignment PIN_K39 -to tx_serial_data[3]      ; ## A30  FMCA_DP03_C2M_P     GXBL1H_TX_CH3p
set_location_assignment PIN_K38 -to "tx_serial_data[3](n)" ; ## A31  FMCA_DP03_C2M_N     GXBL1H_TX_CH3n

set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_serial_data
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_serial_data
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_serial_data

for {set i 0} {$i < 4} {incr i} {
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to rx_serial_data[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to tx_serial_data[${i}]
}

set_location_assignment PIN_C14 -to rx_sync                ; ## G9   FMCA_LA03_P         IO,LVDS3H_8p
set_location_assignment PIN_D14 -to "rx_sync(n)"           ; ## G10  FMCA_LA03_N         IO,LVDS3H_8n
set_location_assignment PIN_P11 -to rx_sync_2              ; ## G36  FMCA_LA33_P         IO,LVDS3F_23
set_location_assignment PIN_R11 -to "rx_sync_2(n)"         ; ## G37  FMCA_LA33_N         IO,LVDS3F_23
set_location_assignment PIN_E3  -to rx_os_sync             ; ## G27  FMCA_LA25_P         IO,LVDS3F_4p
set_location_assignment PIN_F3  -to "rx_os_sync(n)"        ; ## G28  FMCA_LA25_N         IO,LVDS3F_4n

set_instance_assignment -name IO_STANDARD LVDS -to rx_sync
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync_2
set_instance_assignment -name IO_STANDARD LVDS -to rx_os_sync

set_location_assignment PIN_G14 -to sysref                 ; ## G6   FMCA_LA00_CC_P      IO,LVDS3H_7p
set_location_assignment PIN_H14 -to "sysref(n)"            ; ## G7   FMCA_LA00_CC_N      IO,LVDS3H_7n

set_instance_assignment -name IO_STANDARD LVDS -to sysref
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref

set_location_assignment PIN_C13 -to tx_sync                ; ## H7   FMCA_LA02_P         IO,LVDS3H_9p
set_location_assignment PIN_D13 -to "tx_sync(n)"           ; ## H8   FMCA_LA02_N         IO,LVDS3H_9n
set_location_assignment PIN_E1  -to tx_sync_1              ; ## H28  FMCA_LA24_P         IO,LVDS3F_3p
set_location_assignment PIN_E2  -to "tx_sync_1(n)"         ; ## H29  FMCA_LA24_N         IO,LVDS3F_3n

set_instance_assignment -name IO_STANDARD LVDS -to tx_sync
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync_1
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync_1

set_location_assignment PIN_G1  -to ad9528_reset_b         ; ## C26  FMCA_LA27_P         IO,LVDS3F_6p
set_location_assignment PIN_H2  -to ad9528_sysref_req      ; ## C27  FMCA_LA27_N         IO,LVDS3F_6n
set_location_assignment PIN_F13 -to adrv9026_test          ; ## D11  FMCA_LA05_P         IO,CLK_3H_1p,LVDS3H_12p

set_instance_assignment -name IO_STANDARD "1.8 V" -to ad9528_reset_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to ad9528_sysref_req
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_test

set_location_assignment PIN_A10 -to adrv9026_orx_ctrl_a    ; ## C10  FMCA_LA06_P         IO,LVDS3H_19p
set_location_assignment PIN_B10 -to adrv9026_orx_ctrl_b    ; ## C11  FMCA_LA06_N         IO,LVDS3H_19n
set_location_assignment PIN_F2  -to adrv9026_orx_ctrl_c    ; ## D26  FMCA_LA26_P         IO,LVDS3F_5p
set_location_assignment PIN_A8  -to adrv9026_orx_ctrl_d    ; ## C15  FMCA_LA10_N         IO,LVDS3H_23n

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_orx_ctrl_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_orx_ctrl_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_orx_ctrl_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_orx_ctrl_d

set_location_assignment PIN_K11 -to adrv9026_rx1_enable    ; ## D18  FMCA_LA13_N         IO,LVDS3G_20n
set_location_assignment PIN_J10 -to adrv9026_rx2_enable    ; ## C19  FMCA_LA14_N         IO,LVDS3G_23n
set_location_assignment PIN_D1  -to adrv9026_rx3_enable    ; ## D24  FMCA_LA23_N         IO,LVDS3F_2n
set_location_assignment PIN_C1  -to adrv9026_rx4_enable    ; ## D23  FMCA_LA23_P         IO,LVDS3F_2p

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_rx1_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_rx2_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_rx3_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_rx4_enable

set_location_assignment PIN_J11 -to adrv9026_tx1_enable    ; ## D17  FMCA_LA13_P         IO,LVDS3G_20p
set_location_assignment PIN_J9  -to adrv9026_tx2_enable    ; ## C18  FMCA_LA14_P         IO,LVDS3G_23p
set_location_assignment PIN_G2  -to adrv9026_tx3_enable    ; ## D27  FMCA_LA26_N         IO,LVDS3F_5n
set_location_assignment PIN_A7  -to adrv9026_tx4_enable    ; ## C14  FMCA_LA10_P         IO,LVDS3H_23p

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_tx1_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_tx2_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_tx3_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_tx4_enable

set_location_assignment PIN_H13 -to adrv9026_gpint1        ; ## H11  FMCA_LA04_N         IO,LVDS3H_11n
set_location_assignment PIN_L5  -to adrv9026_gpint2        ; ## H31  FMCA_LA28_P         IO,LVDS3F_18p
set_location_assignment PIN_H12 -to adrv9026_reset_b       ; ## H10  FMCA_LA04_P         IO,RZQ_3H,LVDS3H_11p

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpint1
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpint2
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_reset_b

set_location_assignment PIN_D4  -to adrv9026_gpio[0]       ; ## H19  FMCA_LA15_P         IO,PLL_3G_CLKOUT1p,PLL_3G_CLKOUT1,PLL_3G_FB1,LVDS3G_10p
set_location_assignment PIN_D5  -to adrv9026_gpio[1]       ; ## H20  FMCA_LA15_N         IO,PLL_3G_CLKOUT1n,LVDS3G_10n
set_location_assignment PIN_D6  -to adrv9026_gpio[2]       ; ## G18  FMCA_LA16_P         IO,RZQ_3G,LVDS3G_11p
set_location_assignment PIN_E6  -to adrv9026_gpio[3]       ; ## G19  FMCA_LA16_N         IO,LVDS3G_11n
set_location_assignment PIN_C2  -to adrv9026_gpio[4]       ; ## H25  FMCA_LA21_P         IO,LVDS3G_8p
set_location_assignment PIN_D3  -to adrv9026_gpio[5]       ; ## H26  FMCA_LA21_N         IO,LVDS3G_8n
set_location_assignment PIN_G7  -to adrv9026_gpio[6]       ; ## C22  FMCA_LA18_CC_P      IO,LVDS3G_17p
set_location_assignment PIN_H7  -to adrv9026_gpio[7]       ; ## C23  FMCA_LA18_CC_N      IO,LVDS3G_17n
set_location_assignment PIN_G4  -to adrv9026_gpio[8]       ; ## G25  FMCA_LA22_N         IO,LVDS3F_1n
set_location_assignment PIN_G5  -to adrv9026_gpio[9]       ; ## H22  FMCA_LA19_P         IO,LVDS3G_16p
set_location_assignment PIN_G6  -to adrv9026_gpio[10]       ; ## H23  FMCA_LA19_N         IO,LVDS3G_16n
set_location_assignment PIN_C3  -to adrv9026_gpio[11]       ; ## G21  FMCA_LA20_P         IO,LVDS3G_7p
set_location_assignment PIN_C4  -to adrv9026_gpio[12]       ; ## G22  FMCA_LA20_N         IO,LVDS3G_7n
set_location_assignment PIN_P10 -to adrv9026_gpio[13]       ; ## G31  FMCA_LA29_N         IO,LVDS3F_19n
set_location_assignment PIN_N9  -to adrv9026_gpio[14]       ; ## G30  FMCA_LA29_P         IO,LVDS3F_19p
set_location_assignment PIN_F4  -to adrv9026_gpio[15]       ; ## G24  FMCA_LA22_P         IO,LVDS3F_1p
set_location_assignment PIN_N13 -to adrv9026_gpio[16]       ; ## G16  FMCA_LA12_N         IO,LVDS3G_21n
set_location_assignment PIN_M12 -to adrv9026_gpio[17]       ; ## G15  FMCA_LA12_P         IO,LVDS3G_21p
set_location_assignment PIN_F14 -to adrv9026_gpio[18]       ; ## D12  FMCA_LA05_N         IO,CLK_3H_1n,LVDS3H_12n

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9026_gpio[18]

set_location_assignment PIN_A12 -to spi_csn_adrv9026       ; ## D14  FMCA_LA09_P         IO,LVDS3H_22p
set_location_assignment PIN_A13 -to spi_csn_ad9528         ; ## D15  FMCA_LA09_N         IO,LVDS3H_22n
set_location_assignment PIN_A9  -to spi_clk                ; ## H13  FMCA_LA07_P         IO,LVDS3H_20p
set_location_assignment PIN_B11 -to spi_miso               ; ## G12  FMCA_LA08_P         IO,LVDS3H_21p
set_location_assignment PIN_B9  -to spi_mosi               ; ## H14  FMCA_LA07_N         IO,LVDS3H_20n

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_adrv9026
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_ad9528
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi

execute_flow -compile
