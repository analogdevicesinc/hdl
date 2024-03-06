###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 22.1std.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad4170_asdz_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_edge_detect.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/util_cdc/sync_bits.v

# ad4170 interface

set_location_assignment PIN_AH8  -to ad4170_dig_aux[1]     ; ##   P5.8 Arduino_IO07
set_location_assignment PIN_AG10 -to ad4170_dig_aux[0]     ; ##   P5.3 Arduino_IO02

set_location_assignment PIN_AF15 -to ad4170_spi_csn        ; ##   P4.3 Arduino_IO10
set_location_assignment PIN_AG16 -to ad4170_spi_mosi       ; ##   P4.4 Arduino_IO11
set_location_assignment PIN_AH11 -to ad4170_spi_miso       ; ##   P4.5 Arduino_IO12
set_location_assignment PIN_AH12 -to ad4170_spi_clk        ; ##   P4.6 Arduino_IO13

set_location_assignment PIN_AH9   -to i2c_sda              ; ##   P4.9 Arduino_IO14
set_location_assignment PIN_AG11  -to i2c_scl              ; ##   P4.10 Arduino_IO15

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_dig_aux[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_dig_aux[0]

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_spi_csn
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_spi_clk

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

execute_flow -compile
