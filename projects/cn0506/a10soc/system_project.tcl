###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project cn0506_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required (D08-FMC):
#
#  R610: DNI -> R0
#  R611: DNI -> R0
#  R612: R0 -> DNI
#  R613: R0 -> DNI
#  R620: DNI -> R0
#  R632: DNI -> R0
#  R621: R0 -> DNI
#  R633: R0 -> DNI

set_location_assignment PIN_G14    -to  mii_rx_clk_a            ; ## G06 FMCA_HPC_LA00_CC_P
set_location_assignment PIN_E13    -to  mii_rx_er_a             ; ## D09 FMCA_HPC_LA01_CC_N
set_location_assignment PIN_B9     -to  mii_rx_dv_a             ; ## H14 FMCA_HPC_LA07_N
set_location_assignment PIN_C13    -to  mii_rxd_a[0]            ; ## H07 FMCA_HPC_LA02_P
set_location_assignment PIN_D13    -to  mii_rxd_a[1]            ; ## H08 FMCA_HPC_LA02_N
set_location_assignment PIN_C14    -to  mii_rxd_a[2]            ; ## G09 FMCA_HPC_LA03_P
set_location_assignment PIN_D14    -to  mii_rxd_a[3]            ; ## G10 FMCA_HPC_LA03_N
set_location_assignment PIN_H13    -to  mii_tx_clk_a            ; ## H11 FMCA_HPC_LA04_N
set_location_assignment PIN_A9     -to  mii_tx_en_a             ; ## H13 FMCA_HPC_LA07_P
set_location_assignment PIN_A12    -to  mii_txd_a[0]            ; ## D14 FMCA_HPC_LA09_P
set_location_assignment PIN_A13    -to  mii_txd_a[1]            ; ## D15 FMCA_HPC_LA09_N
set_location_assignment PIN_A10    -to  mii_txd_a[2]            ; ## C10 FMCA_HPC_LA06_P
set_location_assignment PIN_B10    -to  mii_txd_a[3]            ; ## C11 FMCA_HPC_LA06_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rx_clk_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rx_dv_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rxd_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_tx_clk_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_tx_en_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_txd_a

set_location_assignment PIN_C9     -to  mdio_fmc_a                ; ## H16 FMCA_HPC_LA11_P
set_location_assignment PIN_D9     -to  mdc_fmc_a                 ; ## H17 FMCA_HPC_LA11_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mdio_fmc_a
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to mdio_fmc_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to mdc_fmc_a

set_location_assignment PIN_D4     -to  reset_a                   ; ## H19 FMCA_HPC_LA15_P
set_location_assignment PIN_H12    -to  link_st_a                 ; ## H10 FMCA_HPC_LA04_P
set_location_assignment PIN_B12    -to  mii_crs_a                 ; ## G13 FMCA_HPC_LA08_N
set_location_assignment PIN_B11    -to  led_0_a                   ; ## G12 FMCA_HPC_LA08_P
set_location_assignment PIN_M12    -to  led_ar_c_c2m              ; ## G15 FMCA_HPC_LA12_P
set_location_assignment PIN_N13    -to  led_ar_a_c2m              ; ## G16 FMCA_HPC_LA12_N
set_location_assignment PIN_J11    -to  led_al_c_c2m              ; ## D17 FMCA_HPC_LA13_P
set_location_assignment PIN_K11    -to  led_al_a_c2m              ; ## D18 FMCA_HPC_LA13_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to reset_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to link_st_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_crs_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_0_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_ar_c_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_ar_a_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_al_c_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_al_a_c2m

set_location_assignment PIN_G7     -to  mii_rx_clk_b            ; ## C22 FMCA_HPC_LA18_CC_P
set_location_assignment PIN_G9     -to  mii_rx_er_b             ; ## D21 FMCA_HPC_LA17_CC_N
set_location_assignment PIN_E2     -to  mii_rx_dv_b             ; ## H29 FMCA_HPC_LA24_N
set_location_assignment PIN_G5     -to  mii_rxd_b[0]            ; ## H22 FMCA_HPC_LA19_P
set_location_assignment PIN_G6     -to  mii_rxd_b[1]            ; ## H23 FMCA_HPC_LA19_N
set_location_assignment PIN_C3     -to  mii_rxd_b[2]            ; ## G21 FMCA_HPC_LA20_P
set_location_assignment PIN_C4     -to  mii_rxd_b[3]            ; ## G22 FMCA_HPC_LA20_N
set_location_assignment PIN_F3     -to  mii_tx_clk_b            ; ## G28 FMCA_HPC_LA25_N
set_location_assignment PIN_E1     -to  mii_tx_en_b             ; ## H28 FMCA_HPC_LA24_P
set_location_assignment PIN_C2     -to  mii_txd_b[0]            ; ## H25 FMCA_HPC_LA21_P
set_location_assignment PIN_D3     -to  mii_txd_b[1]            ; ## H26 FMCA_HPC_LA21_N
set_location_assignment PIN_F4     -to  mii_txd_b[2]            ; ## G24 FMCA_HPC_LA22_P
set_location_assignment PIN_G4     -to  mii_txd_b[3]            ; ## G25 FMCA_HPC_LA22_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rx_clk_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rx_dv_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rxd_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_tx_clk_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_tx_en_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_txd_b

set_location_assignment PIN_L5     -to  mdio_fmc_b                ; ## H31 FMCA_HPC_LA28_P
set_location_assignment PIN_M5     -to  mdc_fmc_b                 ; ## H32 FMCA_HPC_LA28_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mdio_fmc_b
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to mdio_fmc_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to mdc_fmc_b

set_location_assignment PIN_D5     -to  reset_b                   ; ## H20 FMCA_HPC_LA15_N
set_location_assignment PIN_E3     -to  link_st_b                 ; ## G27 FMCA_HPC_LA25_P
set_location_assignment PIN_D1     -to  mii_crs_b                 ; ## D24 FMCA_HPC_LA23_N
set_location_assignment PIN_C1     -to  led_0_b                   ; ## D23 FMCA_HPC_LA23_P
set_location_assignment PIN_F2     -to  led_bl_c_c2m              ; ## D26 FMCA_HPC_LA26_P
set_location_assignment PIN_G2     -to  led_bl_a_c2m              ; ## D27 FMCA_HPC_LA26_N
set_location_assignment PIN_D6     -to  led_br_c_c2m              ; ## G18 FMCA_HPC_LA16_P
set_location_assignment PIN_E6     -to  led_br_a_c2m              ; ## G19 FMCA_HPC_LA16_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to reset_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to link_st_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_crs_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_0_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_bl_c_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_bl_a_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_br_c_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_br_a_c2m


execute_flow -compile
