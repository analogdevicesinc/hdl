###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project fmcomms8_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_assign.tcl

# files

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/projects/fmcomms8/common/fmcomms8_spi.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_iobuf.v

# fmcomms8

set_location_assignment PIN_N29   -to ref_clk_c                ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_location_assignment PIN_N28   -to "ref_clk_c(n)"           ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_location_assignment PIN_R29   -to ref_clk_d                ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_location_assignment PIN_R28   -to "ref_clk_d(n)"           ; ## B21  FMC_HPC_GBTCLK1_M2C_N
set_location_assignment PIN_T31   -to rx_serial_data_c[0]      ; ## C06  FMC_HPC_DP0_M2C_P
set_location_assignment PIN_T30   -to "rx_serial_data_c[0](n)" ; ## C07  FMC_HPC_DP0_M2C_N
set_location_assignment PIN_R33   -to rx_serial_data_c[1]      ; ## A02  FMC_HPC_DP1_M2C_P
set_location_assignment PIN_R32   -to "rx_serial_data_c[1](n)" ; ## A03  FMC_HPC_DP1_M2C_N
set_location_assignment PIN_P35   -to rx_serial_data_c[2]      ; ## A06  FMC_HPC_DP2_M2C_P
set_location_assignment PIN_P34   -to "rx_serial_data_c[2](n)" ; ## A07  FMC_HPC_DP2_M2C_N
set_location_assignment PIN_P31   -to rx_serial_data_c[3]      ; ## A10  FMC_HPC_DP3_M2C_P
set_location_assignment PIN_P30   -to "rx_serial_data_c[3](n)" ; ## A11  FMC_HPC_DP3_M2C_N
set_location_assignment PIN_N37   -to tx_serial_data_c[0]      ; ## C02  FMC_HPC_DP0_C2M_P (tx_serial_data_p[1])
set_location_assignment PIN_N36   -to "tx_serial_data_c[0](n)" ; ## C03  FMC_HPC_DP0_C2M_N (tx_serial_data_n[1])
set_location_assignment PIN_M39   -to tx_serial_data_c[1]      ; ## A22  FMC_HPC_DP1_C2M_P (tx_serial_data_p[0])
set_location_assignment PIN_M38   -to "tx_serial_data_c[1](n)" ; ## A23  FMC_HPC_DP1_C2M_N (tx_serial_data_n[0])
set_location_assignment PIN_L37   -to tx_serial_data_c[2]      ; ## A26  FMC_HPC_DP2_C2M_P
set_location_assignment PIN_L36   -to "tx_serial_data_c[2](n)" ; ## A27  FMC_HPC_DP2_C2M_N
set_location_assignment PIN_K39   -to tx_serial_data_c[3]      ; ## A30  FMC_HPC_DP3_C2M_P
set_location_assignment PIN_K38   -to "tx_serial_data_c[3](n)" ; ## A31  FMC_HPC_DP3_C2M_N

set_location_assignment PIN_N33   -to rx_serial_data_d[0]      ; ## A14  FMC_HPC_DP4_M2C_P
set_location_assignment PIN_N32   -to "rx_serial_data_d[0](n)" ; ## A15  FMC_HPC_DP4_M2C_N
set_location_assignment PIN_M35   -to rx_serial_data_d[1]      ; ## A18  FMC_HPC_DP5_M2C_P
set_location_assignment PIN_M34   -to "rx_serial_data_d[1](n)" ; ## A19  FMC_HPC_DP5_M2C_N
set_location_assignment PIN_M31   -to rx_serial_data_d[2]      ; ## B16  FMC_HPC_DP6_M2C_P
set_location_assignment PIN_M30   -to "rx_serial_data_d[2](n)" ; ## B17  FMC_HPC_DP6_M2C_N
set_location_assignment PIN_L33   -to rx_serial_data_d[3]      ; ## B12  FMC_HPC_DP7_M2C_P
set_location_assignment PIN_L32   -to "rx_serial_data_d[3](n)" ; ## B13  FMC_HPC_DP7_M2C_N
set_location_assignment PIN_J37   -to tx_serial_data_d[0]      ; ## A34  FMC_HPC_DP4_C2M_P
set_location_assignment PIN_J36   -to "tx_serial_data_d[0](n)" ; ## A35  FMC_HPC_DP4_C2M_N
set_location_assignment PIN_H39   -to tx_serial_data_d[1]      ; ## A38  FMC_HPC_DP5_C2M_P
set_location_assignment PIN_H38   -to "tx_serial_data_d[1](n)" ; ## A39  FMC_HPC_DP5_C2M_N
set_location_assignment PIN_G37   -to tx_serial_data_d[2]      ; ## B36  FMC_HPC_DP6_C2M_P
set_location_assignment PIN_G36   -to "tx_serial_data_d[2](n)" ; ## B37  FMC_HPC_DP6_C2M_N
set_location_assignment PIN_F39   -to tx_serial_data_d[3]      ; ## B32  FMC_HPC_DP7_C2M_P
set_location_assignment PIN_F38   -to "tx_serial_data_d[3](n)" ; ## B33  FMC_HPC_DP7_C2M_N

set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial_data_c
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial_data_d
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_serial_data_c
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_serial_data_d

set_instance_assignment -name IO_STANDARD LVDS -to ref_clk_c
set_instance_assignment -name IO_STANDARD LVDS -to ref_clk_d
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_serial_data_c
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_serial_data_c
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_serial_data_d
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_serial_data_d

# Merge RX and TX into single transceiver
for {set i 0} {$i < 4} {incr i} {
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_c_${i} -to rx_serial_data_c[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_c_${i} -to tx_serial_data_c[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_d_${i} -to rx_serial_data_d[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_d_${i} -to tx_serial_data_d[${i}]
}

set_location_assignment PIN_C9    -to rx_sync_c               ; ## H16  FMC_HPC_LA11_P
set_location_assignment PIN_D9    -to rx_sync_c(n)            ; ## H17  FMC_HPC_LA11_N
set_location_assignment PIN_M12   -to rx_os_sync_c            ; ## G15  FMC_HPC_LA12_P
set_location_assignment PIN_N13   -to rx_os_sync_c(n)         ; ## G16  FMC_HPC_LA12_N
set_location_assignment PIN_G5    -to tx_sync_c               ; ## H22  FMC_HPC_LA19_P
set_location_assignment PIN_G6    -to tx_sync_c(n)            ; ## H23  FMC_HPC_LA19_N
set_location_assignment PIN_E12   -to core_clk_c              ; ## D08  FMC_HPC_LA01_CC_P
set_location_assignment PIN_E13   -to core_clk_c(n)           ; ## D09  FMC_HPC_LA01_CC_N
set_location_assignment PIN_E5    -to sysref_c                ; ## H04  FMC_HPC_CLK0_M2C_P
set_location_assignment PIN_F5    -to sysref_c(n)             ; ## H05  FMC_HPC_CLK0_M2C_N
set_location_assignment PIN_C3    -to tx_sync_c_1             ; ## G21  FMC_HPC_LA20_P
set_location_assignment PIN_C4    -to tx_sync_c_1(n)          ; ## G22  FMC_HPC_LA20_N

set_instance_assignment -name IO_STANDARD LVDS -to rx_sync_c
set_instance_assignment -name IO_STANDARD LVDS -to rx_os_sync_c
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync_c
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync_c_1
set_instance_assignment -name IO_STANDARD LVDS -to sysref_c
set_instance_assignment -name IO_STANDARD LVDS -to core_clk_c
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync_c
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync_c_1
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref_c
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to core_clk_c

set_location_assignment PIN_D4    -to rx_sync_d               ; ## H19  FMC_HPC_LA15_P
set_location_assignment PIN_D5    -to rx_sync_d(n)            ; ## H20  FMC_HPC_LA15_N
set_location_assignment PIN_D6    -to rx_os_sync_d            ; ## G18  FMC_HPC_LA16_P
set_location_assignment PIN_E6    -to rx_os_sync_d(n)         ; ## G19  FMC_HPC_LA16_N
set_location_assignment PIN_C2    -to tx_sync_d               ; ## H25  FMC_HPC_LA21_P
set_location_assignment PIN_D3    -to tx_sync_d(n)            ; ## H26  FMC_HPC_LA21_N
set_location_assignment PIN_W5    -to sysref_d                ; ## G02  FMC_HPC_CLK1_M2C_P
set_location_assignment PIN_W6    -to sysref_d(n)             ; ## G03  FMC_HPC_CLK1_M2C_N
set_location_assignment PIN_G14   -to core_clk_d              ; ## G06  FMC_HPC_LA00_CC_P
set_location_assignment PIN_H14   -to core_clk_d(n)           ; ## G07  FMC_HPC_LA00_CC_N
set_location_assignment PIN_F4    -to tx_sync_d_1             ; ## G24  FMC_HPC_LA22_P
set_location_assignment PIN_G4    -to tx_sync_d_1(n)          ; ## G25  FMC_HPC_LA22_N

set_instance_assignment -name IO_STANDARD LVDS -to rx_sync_d
set_instance_assignment -name IO_STANDARD LVDS -to rx_os_sync_d
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync_d
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync_d_1
set_instance_assignment -name IO_STANDARD LVDS -to sysref_d
set_instance_assignment -name IO_STANDARD LVDS -to core_clk_d
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync_d
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync_d_1
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref_d
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to core_clk_d

set_location_assignment PIN_D1    -to spi_csn_hmc7044       ; ## D24  FMC_HPC_LA23_N
set_location_assignment PIN_F13   -to spi_csn_adrv9009_c    ; ## D11  FMC_HPC_LA05_P
set_location_assignment PIN_A12   -to spi_csn_adrv9009_d    ; ## D14  FMC_HPC_LA09_P
set_location_assignment PIN_C1    -to spi_clk               ; ## D23  FMC_HPC_LA23_P
set_location_assignment PIN_G2    -to spi_sdio              ; ## D27  FMC_HPC_LA26_N
set_location_assignment PIN_F2    -to spi_miso              ; ## D26  FMC_HPC_LA26_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_hmc7044
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_adrv9009_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_adrv9009_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_sdio
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso

set_location_assignment PIN_A7    -to adrv9009_tx1_enable_c   ; ## C14  FMC_HPC_LA10_P
set_location_assignment PIN_A8    -to adrv9009_tx2_enable_c   ; ## C15  FMC_HPC_LA10_N
set_location_assignment PIN_A10   -to adrv9009_rx1_enable_c   ; ## C10  FMC_HPC_LA06_P
set_location_assignment PIN_B10   -to adrv9009_rx2_enable_c   ; ## C11  FMC_HPC_LA06_N
set_location_assignment PIN_J11   -to adrv9009_reset_b_c      ; ## D17  FMC_HPC_LA13_P
set_location_assignment PIN_E3    -to adrv9009_gpint_c        ; ## G27  FMC_HPC_LA25_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_tx1_enable_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_tx2_enable_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_rx1_enable_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_rx2_enable_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_reset_b_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpint_c

set_location_assignment PIN_G1    -to adrv9009_tx1_enable_d   ; ## C26  FMC_HPC_LA27_P
set_location_assignment PIN_H2    -to adrv9009_tx2_enable_d   ; ## C27  FMC_HPC_LA27_N
set_location_assignment PIN_J9    -to adrv9009_rx1_enable_d   ; ## C18  FMC_HPC_LA14_P
set_location_assignment PIN_J10   -to adrv9009_rx2_enable_d   ; ## C19  FMC_HPC_LA14_N
set_location_assignment PIN_K11   -to adrv9009_reset_b_d      ; ## D18  FMC_HPC_LA13_N
set_location_assignment PIN_F3    -to adrv9009_gpint_d        ; ## G28  FMC_HPC_LA25_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_tx1_enable_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_tx2_enable_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_rx1_enable_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_rx2_enable_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_reset_b_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpint_d

set_location_assignment PIN_G7    -to fan_tach              ; ## C22  FMC_HPC_LA18_CC_P
set_location_assignment PIN_H7    -to fan_pwm               ; ## C23  FMC_HPC_LA18_CC_P
set_location_assignment PIN_C14   -to hmc7044_reset         ; ## G09  FMC_HPC_LA03_P
set_location_assignment PIN_D14   -to hmc7044_sync          ; ## G10  FMC_HPC_LA03_N
set_location_assignment PIN_B11   -to hmc7044_gpio_1        ; ## G12  FMC_HPC_LA08_P
set_location_assignment PIN_B12   -to hmc7044_gpio_2        ; ## G13  FMC_HPC_LA08_N
set_location_assignment PIN_A9    -to hmc7044_gpio_3        ; ## H13  FMC_HPC_LA07_P
set_location_assignment PIN_B9    -to hmc7044_gpio_4        ; ## H14  FMC_HPC_LA07_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to fan_tach
set_instance_assignment -name IO_STANDARD "1.8 V" -to fan_pwm
set_instance_assignment -name IO_STANDARD "1.8 V" -to hmc7044_reset
set_instance_assignment -name IO_STANDARD "1.8 V" -to hmc7044_sync
set_instance_assignment -name IO_STANDARD "1.8 V" -to hmc7044_gpio_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hmc7044_gpio_2
set_instance_assignment -name IO_STANDARD "1.8 V" -to hmc7044_gpio_3
set_instance_assignment -name IO_STANDARD "1.8 V" -to hmc7044_gpio_4

# single ended default

set_location_assignment PIN_N9    -to adrv9009_gpio_00_c       ; ## G30  FMC_HPC_LA29_P
set_location_assignment PIN_P8    -to adrv9009_gpio_01_c       ; ## G33  FMC_HPC_LA31_P
set_location_assignment PIN_P11   -to adrv9009_gpio_02_c       ; ## G36  FMC_HPC_LA33_P
set_location_assignment PIN_C13   -to adrv9009_gpio_03_c       ; ## H07  FMC_HPC_LA02_P
set_location_assignment PIN_H12   -to adrv9009_gpio_04_c       ; ## H10  FMC_HPC_LA04_P
set_location_assignment PIN_E1    -to adrv9009_gpio_05_c       ; ## H28  FMC_HPC_LA24_P
set_location_assignment PIN_L5    -to adrv9009_gpio_06_c       ; ## H31  FMC_HPC_LA28_P
set_location_assignment PIN_P9    -to adrv9009_gpio_07_c       ; ## H34  FMC_HPC_LA30_P
set_location_assignment PIN_L8    -to adrv9009_gpio_08_c       ; ## H37  FMC_HPC_LA32_P
set_location_assignment PIN_P10   -to adrv9009_gpio_00_d       ; ## G31  FMC_HPC_LA29_N
set_location_assignment PIN_R8    -to adrv9009_gpio_01_d       ; ## G34  FMC_HPC_LA31_N
set_location_assignment PIN_R11   -to adrv9009_gpio_02_d       ; ## G37  FMC_HPC_LA33_N
set_location_assignment PIN_D13   -to adrv9009_gpio_03_d       ; ## H08  FMC_HPC_LA02_N
set_location_assignment PIN_H13   -to adrv9009_gpio_04_d       ; ## H11  FMC_HPC_LA04_N
set_location_assignment PIN_E2    -to adrv9009_gpio_05_d       ; ## H29  FMC_HPC_LA24_N
set_location_assignment PIN_M5    -to adrv9009_gpio_06_d       ; ## H32  FMC_HPC_LA28_N
set_location_assignment PIN_R10   -to adrv9009_gpio_07_d       ; ## H35  FMC_HPC_LA30_N
set_location_assignment PIN_L9    -to adrv9009_gpio_08_d       ; ## H38  FMC_HPC_LA32_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_00_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_01_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_02_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_03_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_04_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_05_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_06_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_07_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_08_c
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_00_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_01_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_02_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_03_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_04_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_05_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_06_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_07_d
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio_08_d

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
set_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER 1.2

execute_flow -compile
