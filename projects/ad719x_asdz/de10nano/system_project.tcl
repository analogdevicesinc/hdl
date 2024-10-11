###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 22.1std.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad719x_asdz_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

#
## down-rade Critical Warning reated to a asynchronous RAM in DMAC
#
## "mixed_port_feed_through_mode" parameter of RAM can not have value "old"
set_global_assignment -name MESSAGE_DISABLE 15003

# files

# SPI interface for ad719x

set_location_assignment PIN_AH12 -to ad719x_spi_sclk      ; ##   Arduino_IO13
set_location_assignment PIN_AH11 -to ad719x_spi_miso      ; ##   Arduino_IO12
set_location_assignment PIN_AG16 -to ad719x_spi_mosi      ; ##   Arduino_IO11
set_location_assignment PIN_AF15 -to ad719x_spi_cs_1      ; ##   Arduino_IO10
set_location_assignment PIN_AE15 -to ad719x_spi_cs_2      ; ##   Arduino_IO9

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad719x_spi_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad719x_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad719x_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad719x_spi_cs_1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad719x_spi_cs_2

# I2C

set_location_assignment PIN_AG11  -to i2c_scl             ; ##   Arduino_IO15
set_location_assignment PIN_AH9   -to i2c_sda             ; ##   Arduino_IO14

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

# synchronization and timing

set_location_assignment PIN_U14  -to ad719x_sync_n        ; ##   Arduino_IO4

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad719x_sync_n

execute_flow -compile
