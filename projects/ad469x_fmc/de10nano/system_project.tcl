###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 22.1std.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad469x_fmc_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_edge_detect.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/util_cdc/sync_bits.v

# ad469x interface

set_location_assignment PIN_AH8  -to ad469x_spi_cnv        ; ##   P4.7 Arduino_IO07
set_location_assignment PIN_AG10 -to ad469x_resetn         ; ##   P4.5 Arduino_IO02

set_location_assignment PIN_AE15 -to ad469x_busy_alt_gp0   ; ##   P3.2 Arduino_IO09

set_location_assignment PIN_AF15 -to ad469x_spi_cs         ; ##   P3.3 Arduino_IO10
set_location_assignment PIN_AG16 -to ad469x_spi_sdo        ; ##   P3.4 Arduino_IO11
set_location_assignment PIN_AH11 -to ad469x_spi_sdi        ; ##   P3.5 Arduino_IO12
set_location_assignment PIN_AH12 -to ad469x_spi_sclk       ; ##   P3.6 Arduino_IO13

set_location_assignment PIN_AH9   -to i2c_sda              ; ##   P3.9 Arduino_IO14
set_location_assignment PIN_AG11  -to i2c_scl              ; ##   P3.10 Arduino_IO15

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad469x_spi_cnv
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad469x_resetn

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad469x_busy_alt_gp0

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad469x_spi_cs
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad469x_spi_sdo
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad469x_spi_sdi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad469x_spi_sclk

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

execute_flow -compile