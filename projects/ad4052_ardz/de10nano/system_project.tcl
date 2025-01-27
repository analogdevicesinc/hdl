###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 23.1std.1
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad4052_ardz_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# eeprom

set_location_assignment PIN_AH9   -to i2c_sda     ; ## Arduino_SDA
set_location_assignment PIN_AG11  -to i2c_scl     ; ## Arduino_SCL

# ad4052 interface

set_location_assignment PIN_AH12 -to adc_spi_sclk ; ## Arduino_IO13
set_location_assignment PIN_AH11 -to adc_spi_sdi  ; ## Arduino_IO12
set_location_assignment PIN_AG16 -to adc_spi_sdo  ; ## Arduino_IO11
set_location_assignment PIN_AF15 -to adc_spi_cs   ; ## Arduino_IO10
set_location_assignment PIN_AG8  -to adc_cnv      ; ## Arduino_IO06
set_location_assignment PIN_AE15 -to adc_gp0      ; ## Arduino_IO09
set_location_assignment PIN_AF17 -to adc_gp1      ; ## Arduino_IO08


set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_spi_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_spi_sdi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_spi_sdo
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_spi_cs
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_cnv
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_gp0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_gp1

set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

execute_flow -compile
