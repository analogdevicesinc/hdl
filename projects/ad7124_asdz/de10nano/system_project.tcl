###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 24.1std.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad7124_asdz_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# ad7124 interface

set_location_assignment PIN_U14  -to sync_err       ; ##   P4.5 Arduino_IO4

set_location_assignment PIN_AF15 -to spi_csn        ; ##   P4.3 Arduino_IO10
set_location_assignment PIN_AG16 -to spi_mosi       ; ##   P4.4 Arduino_IO11
set_location_assignment PIN_AH11 -to spi_miso       ; ##   P4.5 Arduino_IO12
set_location_assignment PIN_AH12 -to spi_clk        ; ##   P4.5 Arduino_IO13

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sync_err

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_csn
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_clk

execute_flow -compile
