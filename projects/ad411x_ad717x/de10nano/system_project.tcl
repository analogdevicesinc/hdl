###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 22.1std.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad411x_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

#
## down-grade Critical Warning related to asynchronous RAM in DMAC
#
## "mixed_port_feed_through_mode" parameter of RAM can not have value "old"

set_global_assignment -name MESSAGE_DISABLE 15003

# files

# ad411x_ad717x interface

set_location_assignment PIN_U14  -to error;      ## J7.5 Arduino_IO04
set_location_assignment PIN_AG9  -to sync_error; ## J7.4 Arduino_IO03

set_location_assignment PIN_AF15 -to spi_csn;    ## J5.3 Arduino_IO10
set_location_assignment PIN_AG16 -to spi_mosi;   ## J5.4 Arduino_IO11
set_location_assignment PIN_AH11 -to spi_miso;   ## J5.5 Arduino_IO12
set_location_assignment PIN_AH12 -to spi_clk;    ## J5.6 Arduino_IO13

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to error
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sync_error

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_csn
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_clk

# I2C

set_location_assignment PIN_AG11  -to i2c_scl;   ## Arduino_IO15
set_location_assignment PIN_AH9   -to i2c_sda;   ## Arduino_IO14

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

execute_flow -compile
