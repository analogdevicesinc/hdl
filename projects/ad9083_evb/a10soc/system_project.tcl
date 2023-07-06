###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad9083_evb_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_3w_spi.v

# lane interface

# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required:
#  R610: DNI -> R0
#  R611: DNI -> R0
#  R612: R0 -> DNI
#  R613: R0 -> DNI
#  R620: DNI -> R0
#  R632: DNI -> R0
#  R621: R0 -> DNI
#  R633: R0 -> DNI

set_location_assignment PIN_G14   -to rx_device_clk              ; ## G06  FMCA_HPC_LA00_CC_P
set_location_assignment PIN_H14   -to "rx_device_clk(n)"         ; ## G07  FMCA_HPC_LA00_CC_N

set_location_assignment PIN_N29   -to rx_ref_clk                 ; ## D04  FMCA_HPC_GBTCLK0_M2C_P
set_location_assignment PIN_N28   -to "rx_ref_clk(n)"            ; ## D05  FMCA_HPC_GBTCLK0_M2C_N

set_location_assignment PIN_T31   -to rx_serial_data[0]          ; ## C06  FMCA_HPC_DP0_M2C_P
set_location_assignment PIN_T30   -to "rx_serial_data[0](n)"     ; ## C07  FMCA_HPC_DP0_M2C_N
set_location_assignment PIN_R33   -to rx_serial_data[1]          ; ## A02  FMCA_HPC_DP1_M2C_P
set_location_assignment PIN_R32   -to "rx_serial_data[1](n)"     ; ## A03  FMCA_HPC_DP1_M2C_N
set_location_assignment PIN_P35   -to rx_serial_data[2]          ; ## A06  FMCA_HPC_DP2_M2C_P
set_location_assignment PIN_P34   -to "rx_serial_data[2](n)"     ; ## A07  FMCA_HPC_DP2_M2C_N
set_location_assignment PIN_P31   -to rx_serial_data[3]          ; ## A10  FMCA_HPC_DP3_M2C_P
set_location_assignment PIN_P30   -to "rx_serial_data[3](n)"     ; ## A11  FMCA_HPC_DP3_M2C_N

set_location_assignment PIN_H12   -to rx_sync                    ; ## H10  FMCA_HPC_LA04_P
set_location_assignment PIN_H13   -to "rx_sync(n)"               ; ## H11  FMCA_HPC_LA04_N
set_location_assignment PIN_B11   -to rx_sysref                  ; ## G12  FMCA_HPC_LA08_P
set_location_assignment PIN_B12   -to "rx_sysref(n)"             ; ## G13  FMCA_HPC_LA08_N

set_instance_assignment -name IO_STANDARD LVDS -to rx_device_clk
set_instance_assignment -name IO_STANDARD LVDS -to "rx_device_clk(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_device_clk
set_instance_assignment -name IO_STANDARD LVDS -to rx_ref_clk
set_instance_assignment -name IO_STANDARD LVDS -to "rx_ref_clk(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_serial_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial_data
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sync(n)"
set_instance_assignment -name IO_STANDARD LVDS -to rx_sysref
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sysref(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_sysref

set_location_assignment PIN_D13   -to pwdn               ; ## H08  FMCA_HPC_LA02_N
set_location_assignment PIN_A9    -to rstb               ; ## H13  FMCA_HPC_LA07_P
set_location_assignment PIN_C14   -to refsel             ; ## G09  FMCA_HPC_LA03_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to pwdn
set_instance_assignment -name IO_STANDARD "1.8 V" -to rstb
set_instance_assignment -name IO_STANDARD "1.8 V" -to refsel

# spi

set_location_assignment PIN_B9  -to spi_csn_clk             ; ## H14  FMCA_LA07_N
set_location_assignment PIN_C13  -to spi_csn_adc            ; ## H07  FMCA_LA02_P
set_location_assignment PIN_E12  -to spi_clk                ; ## D08  FMCA_LA01_P_CC
set_location_assignment PIN_E13  -to spi_sdio               ; ## D09  FMCA_LA01_N_CC

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_adc
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_sdio

execute_flow -compile
