#
# Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
#
# In this HDL repository, there are many different and unique modules, consisting
# of various HDL (Verilog or VHDL) components. The individual modules are
# developed independently, and may be accompanied by separate and unique license
# terms.
#
# The user should read each of these license terms, and understand the
# freedoms and responsibilities that he or she has by using this source/core.
#
# This core is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.
#
# Redistribution and use of source or resulting binaries, with or without modification
# of this file, are permitted under one of the following two license terms:
#
#   1. The GNU General Public License version 2 as published by the
#      Free Software Foundation, which can be found in the top level directory
#      of this repository (LICENSE_GPL2), and also online at:
#      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
#
# OR
#
#   2. An ADI specific BSD license, which can be found in the top level directory
#      of this repository (LICENSE_ADIBSD), and also on-line at:
#      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
#      This will allow to generate bit files and not release the source code,
#      as long as it attaches to an ADI device.
#

source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

source ../common/config.tcl

adi_project dac_fmc_ebz_a10soc [list \
  JESD_L    [get_config_param L] \
  MODE      $mode \
  DEVICE    $device \
]

set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_assign.tcl

# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required:
#  LA01_P_CC
#    R612: R0 -> DNI
#    R610: DNI -> R0
#  LA01_N_CC
#    R613: R0 -> DNI
#    R611: DNI -> R0
#  LA05_P
#    R621: R0 -> DNI
#    R620: DNI -> R0
#  LA05_N
#    R633: R0 -> DNI
#    R632: DNI -> R0

set_location_assignment PIN_N29   -to tx_ref_clk            ; ## D04  FMCA_HPC_GBTCLK0_M2C_P
set_location_assignment PIN_N28   -to "tx_ref_clk(n)"       ; ## D05  FMCA_HPC_GBTCLK0_M2C_N

set_location_assignment PIN_N37   -to tx_serial_data[0]     ; ## C02  FMCA_HPC_DP0_C2M_P      SERDIN7_P
set_location_assignment PIN_N36   -to "tx_serial_data[0](n)"; ## C03  FMCA_HPC_DP0_C2M_N
set_location_assignment PIN_M39   -to tx_serial_data[1]     ; ## A22  FMCA_HPC_DP1_C2M_P      SERDIN6_P
set_location_assignment PIN_M38   -to "tx_serial_data[1](n)"; ## A23  FMCA_HPC_DP1_C2M_N
set_location_assignment PIN_L37   -to tx_serial_data[2]     ; ## A26  FMCA_HPC_DP2_C2M_P      SERDIN5_P
set_location_assignment PIN_L36   -to "tx_serial_data[2](n)"; ## A27  FMCA_HPC_DP2_C2M_N
set_location_assignment PIN_K39   -to tx_serial_data[3]     ; ## A30  FMCA_HPC_DP3_C2M_P      SERDIN4_P
set_location_assignment PIN_K38   -to "tx_serial_data[3](n)"; ## A31  FMCA_HPC_DP3_C2M_N
set_location_assignment PIN_J37   -to tx_serial_data[4]     ; ## A34  FMCA_HPC_DP4_C2M_P      SERDIN2_N
set_location_assignment PIN_J36   -to "tx_serial_data[4](n)"; ## A35  FMCA_HPC_DP4_C2M_N
set_location_assignment PIN_H39   -to tx_serial_data[5]     ; ## A38  FMCA_HPC_DP5_C2M_P      SERDIN0_N
set_location_assignment PIN_H38   -to "tx_serial_data[5](n)"; ## A39  FMCA_HPC_DP5_C2M_N
set_location_assignment PIN_G37   -to tx_serial_data[6]     ; ## B36  FMCA_HPC_DP6_C2M_P      SERDIN1_N
set_location_assignment PIN_G36   -to "tx_serial_data[6](n)"; ## B37  FMCA_HPC_DP6_C2M_N
set_location_assignment PIN_F39   -to tx_serial_data[7]     ; ## B32  FMCA_HPC_DP7_C2M_P      SERDIN3_N
set_location_assignment PIN_F38   -to "tx_serial_data[7](n)"; ## B33  FMCA_HPC_DP7_C2M_N

set_location_assignment PIN_E12   -to tx_sync               ; ## D08  FMCA_HPC_LA01_P
set_location_assignment PIN_E13   -to "tx_sync(n)"          ; ## D09  FMCA_HPC_LA01_N
# For AD9161/2/4-FMC-EBZ SYSREF is placed in other place
if {$device_code == 3} {
  set_location_assignment PIN_C13   -to tx_sysref            ; ## H07  FMCA_HPC_LA02_P
  set_location_assignment PIN_D13   -to "tx_sysref(n)"       ; ## H08  FMCA_HPC_LA02_N
} else {
  set_location_assignment PIN_G14   -to tx_sysref            ; ## G06  FMCA_HPC_LA00_P
  set_location_assignment PIN_H14   -to "tx_sysref(n)"       ; ## G07  FMCA_HPC_LA00_N
}

set_instance_assignment -name IO_STANDARD LVDS -to tx_ref_clk0
set_instance_assignment -name IO_STANDARD LVDS -to "tx_ref_clk0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_serial_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_serial_data
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync
set_instance_assignment -name IO_STANDARD LVDS -to "tx_sync(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to "tx_sync(n)"
set_instance_assignment -name IO_STANDARD LVDS -to tx_sysref
set_instance_assignment -name IO_STANDARD LVDS -to "tx_sysref(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sysref
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to "tx_sysref(n)"

# gpio

# For AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ, AD9152-FMC-EBZ, AD9154-FMC-EBZ
set_location_assignment PIN_A9   -to dac_txen[0]            ; ## H13  FMCA_LA07_P
set_location_assignment PIN_B9   -to dac_txen[1]            ; ## H14  FMCA_LA07_N

# For AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
set_location_assignment PIN_A10  -to dac_txen[2]            ; ## C10  FMCA_LA06_P
set_location_assignment PIN_B10  -to dac_txen[3]            ; ## C11  FMCA_LA06_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen[3]

# spi

set_location_assignment PIN_F14  -to spi_en                 ; ## D12  FMCA_LA05_N
set_location_assignment PIN_C14  -to spi_clk                ; ## G09  FMCA_LA03_P
set_location_assignment PIN_D14  -to spi_mosi               ; ## G10  FMCA_LA03_N
set_location_assignment PIN_H12  -to spi_miso               ; ## H10  FMCA_LA04_P
set_location_assignment PIN_H13  -to spi_csn_dac            ; ## H11  FMCA_LA04_N
set_location_assignment PIN_F13  -to spi_csn_clk            ; ## D11  FMCA_LA05_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_en_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_dac

execute_flow -compile
