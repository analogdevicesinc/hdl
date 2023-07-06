###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad9213_dual_ebz_s10soc

source $ad_hdl_dir/projects/common/s10soc/s10soc_system_assign.tcl

# verilog file for top instantiations

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_3w_spi.v

################################################################################
## FMCB+ location assignments (connector P1 on the FMC board)
################################################################################

## ad9213_a high speed lanes

set_location_assignment  PIN_AC43  -to rx_serial_data_a[0]         ; ## C06 FBD0_M2C_P
set_location_assignment  PIN_AD45  -to rx_serial_data_a[1]         ; ## A02 FBD1_M2C_P
set_location_assignment  PIN_AA43  -to rx_serial_data_a[2]         ; ## A06 FBD2_M2C_P
set_location_assignment  PIN_AB45  -to rx_serial_data_a[3]         ; ## A10 FBD3_M2C_P
set_location_assignment  PIN_W43   -to rx_serial_data_a[4]         ; ## A15 FBD4_M2C_P
set_location_assignment  PIN_Y45   -to rx_serial_data_a[5]         ; ## A19 FBD5_M2C_P
set_location_assignment  PIN_V45   -to rx_serial_data_a[6]         ; ## B16 FBD6_M2C_P
set_location_assignment  PIN_U43   -to rx_serial_data_a[7]         ; ## B12 FBD7_M2C_P
set_location_assignment  PIN_T45   -to rx_serial_data_a[8]         ; ## B08 FBD8_M2C_P
set_location_assignment  PIN_P45   -to rx_serial_data_a[9]         ; ## B04 FBD9_M2C_P
set_location_assignment  PIN_R43   -to rx_serial_data_a[10]        ; ## Y10 FBD10_M2C_P
set_location_assignment  PIN_M45   -to rx_serial_data_a[11]        ; ## Z12 FBD11_M2C_P
set_location_assignment  PIN_N43   -to rx_serial_data_a[12]        ; ## Y14 FBD12_M2C_P
set_location_assignment  PIN_K45   -to rx_serial_data_a[13]        ; ## Z16 FBD13_M2C_P
set_location_assignment  PIN_L43   -to rx_serial_data_a[14]        ; ## Y18 FBD14_M2C_P
set_location_assignment  PIN_H45   -to rx_serial_data_a[15]        ; ## Y22 FBD15_M2C_P

## clocks and synchronization signals

set_location_assignment  PIN_AB41  -to rx_ref_a_clk0               ; ## B20 FBGBT_CLK1_M2C_P
set_location_assignment  PIN_P41   -to rx_ref_a_clk1               ; ## L08 FBGBT_CLK3_M2C_P
set_location_assignment  PIN_BE39  -to rx_sync_a                   ; ## H10 FBLA_04_P
set_location_assignment  PIN_BH36  -to rx_device_clk_0             ; ## G06 FBLA_00_P_CC
set_location_assignment  PIN_BG37  -to rx_sysref_a                 ; ## H07 FBLA_02_P

set_instance_assignment  -name IO_STANDARD LVDS -to rx_ref_a_clk0
set_instance_assignment  -name IO_STANDARD LVDS -to rx_ref_a_clk1
set_instance_assignment  -name IO_STANDARD LVDS -to rx_sync_a
set_instance_assignment  -name IO_STANDARD LVDS -to rx_device_clk_0
set_instance_assignment  -name IO_STANDARD LVDS -to rx_sysref_a

set_instance_assignment  -name INPUT_TERMINATION DIFFERENTIAL -to rx_sync_a
set_instance_assignment  -name INPUT_TERMINATION DIFFERENTIAL -to rx_sysref_a

## ad9213 SPI interface

set_location_assignment  PIN_AT38  -to ad9213_dual_sdio            ; ## C10 FBLA_06_P
set_location_assignment  PIN_AR37  -to ad9213_dual_sclk            ; ## C11 FBLA_06_N
set_location_assignment  PIN_BF40  -to ad9213_dual_csn[0]          ; ## H13 FBLA_07_P
set_location_assignment  PIN_BF39  -to ad9213_dual_csn[1]          ; ## H14 FBLA_07_N

set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_dual_sdio
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_dual_sclk
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_dual_csn[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_dual_csn[1]

## ad9213_a & ad9213_b GPIO lines

set_location_assignment  PIN_BE40 -to ad9213_a_gpio[0]              ; ## G12 FBLA_08_P
set_location_assignment  PIN_BD40 -to ad9213_a_gpio[1]              ; ## G13 FBLA_08_N
set_location_assignment  PIN_AW40 -to ad9213_a_gpio[2]              ; ## D14 FBLA_09_P
set_location_assignment  PIN_AV40 -to ad9213_a_gpio[3]              ; ## D15 FBLA_09_N
set_location_assignment  PIN_AN33 -to ad9213_a_gpio[4]              ; ## C14 FBLA_10_P
set_location_assignment  PIN_AP33 -to ad9213_b_gpio[0]              ; ## C15 FBLA_10_N
set_location_assignment  PIN_BC40 -to ad9213_b_gpio[1]              ; ## H16 FBLA_11_P
set_location_assignment  PIN_BB40 -to ad9213_b_gpio[2]              ; ## H17 FBLA_11_N
set_location_assignment  PIN_BD39 -to ad9213_b_gpio[3]              ; ## G15 FBLA_12_P
set_location_assignment  PIN_BD38 -to ad9213_b_gpio[4]              ; ## G16 FBLA_12_N

set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_a_gpio[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_a_gpio[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_a_gpio[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_a_gpio[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_a_gpio[4]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_b_gpio[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_b_gpio[1]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_b_gpio[2]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_b_gpio[3]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ad9213_b_gpio[4]

## ad9213 reset lines

set_location_assignment  PIN_AT37  -to ad9213_a_rst                 ; ## D17 FBLA_13_P
set_location_assignment  PIN_AT36  -to ad9213_b_rst                 ; ## D18 FBLA_13_N

set_instance_assignment  -name IO_STANDARD "1.8V" -to ad9213_a_rst
set_instance_assignment  -name IO_STANDARD "1.8V" -to ad9213_b_rst

## ltc SPI interface

set_location_assignment  PIN_BB39  -to ltc6952_csn             ; ## G21 FBLA_20_P
set_location_assignment  PIN_AY40  -to ltc6946_csn             ; ## G10 FBLA_03_N
set_location_assignment  PIN_AP31  -to ltc_sclk                ; ## C19 FBLA_14_N
set_location_assignment  PIN_BB38  -to ltc_sdi                 ; ## H19 FBLA_15_P
set_location_assignment  PIN_BA40  -to ltc6946_sdo             ; ## G09 FBLA_03_P
set_location_assignment  PIN_BA39  -to ltc6952_sdo             ; ## G22 FBLA_20_N

set_instance_assignment  -name IO_STANDARD "1.8V"  -to ltc_sdi
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ltc_0_sdo
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ltc_1_sdo
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ltc_sclk
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ltc_csn[0]
set_instance_assignment  -name IO_STANDARD "1.8V"  -to ltc_csn[1]

## ADF4377 SPI interface

set_location_assignment  PIN_BF37 -to adf4377_sclk       ; ## G18 FBLA_16_P
set_location_assignment  PIN_BE37 -to adf4377_sdio       ; ## G19 FBLA_16_N
set_location_assignment  PIN_AY38 -to adf4377_csn[0]     ; ## H22 FBLA_19_P
set_location_assignment  PIN_AY39 -to adf4377_csn[1]     ; ## H23 FBLA_19_N

set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4377_sdio
set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4377_sclk
set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4377_csn[0]
set_instance_assignment  -name IO_STANDARD "1.8V" -to adf4377_csn[1]

################################################################################
## FMCA+ location assignments (connector P2 on the FMC board)
################################################################################

## ad9213_1

set_location_assignment  PIN_BH41  -to rx_serial_data_b[0]         ; ## C06 FAD0M2CP
set_location_assignment  PIN_BJ43  -to rx_serial_data_b[1]         ; ## A02 FAD1M2CP
set_location_assignment  PIN_BG43  -to rx_serial_data_b[2]         ; ## A06 FAD2M2CP
set_location_assignment  PIN_BE43  -to rx_serial_data_b[3]         ; ## A10 FAD3M2CP
set_location_assignment  PIN_BC43  -to rx_serial_data_b[4]         ; ## A14 FAD4M2CP
set_location_assignment  PIN_BD45  -to rx_serial_data_b[5]         ; ## A18 FAD5M2CP
set_location_assignment  PIN_BA43  -to rx_serial_data_b[6]         ; ## B16 FAD6M2CP
set_location_assignment  PIN_BB45  -to rx_serial_data_b[7]         ; ## B12 FAD7M2CP
set_location_assignment  PIN_AW43  -to rx_serial_data_b[8]         ; ## B08 FAD8M2CP
set_location_assignment  PIN_AY45  -to rx_serial_data_b[9]         ; ## B04 FAD9M2CP
set_location_assignment  PIN_AU43  -to rx_serial_data_b[10]        ; ## Y10 FAD10M2CP
set_location_assignment  PIN_AV45  -to rx_serial_data_b[11]        ; ## Z12 FAD11M2CP
set_location_assignment  PIN_AR43  -to rx_serial_data_b[12]        ; ## Y14 FAD12M2CP
set_location_assignment  PIN_AT45  -to rx_serial_data_b[13]        ; ## Z16 FAD13M2CP
set_location_assignment  PIN_AP45  -to rx_serial_data_b[14]        ; ## Y18 FAD14M2CP
set_location_assignment  PIN_AN43  -to rx_serial_data_b[15]        ; ## Y22 FAD15M2CP


## clocks and synchronization signals

set_location_assignment  PIN_AK41  -to rx_ref_b_clk0               ; ## B20 FAGBTCLK1M2CP
set_location_assignment  PIN_AM41  -to rx_ref_b_clk1               ; ## L08 FAGBTCLK3M2CP
set_location_assignment  PIN_BC30  -to rx_sync_b                   ; ## H10 FALA04P

set_instance_assignment  -name IO_STANDARD LVDS  -to rx_ref_b_clk0
set_instance_assignment  -name IO_STANDARD LVDS  -to rx_ref_b_clk1
set_instance_assignment  -name IO_STANDARD LVDS  -to rx_sync_b
set_instance_assignment  -name INPUT_TERMINATION DIFFERENTIAL -to rx_sync_b

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

execute_flow -compile
