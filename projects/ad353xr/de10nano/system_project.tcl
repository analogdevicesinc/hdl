###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 23.1std.1
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad353xr_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# SPI connections
set_location_assignment PIN_AG18 -to spiml_clk      ; ## GPIO1 JP7 [33]
set_location_assignment PIN_AF18 -to spiml_miso     ; ## GPIO1 JP7 [35]
set_location_assignment PIN_AG15 -to spiml_mosi     ; ## GPIO1 JP7 [37]
set_location_assignment PIN_AE19 -to spiml_ss0      ; ## GPIO1 JP7 [39]

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spiml_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spiml_clk_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spiml_clk_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spiml_clk_ss0

# GPIO connections
set_location_assignment PIN_AE20 -to dac_resetb      ; ## GPIO1 JP7 [38]
set_location_assignment PIN_AE17 -to dac_ldacb       ; ## GPIO1 JP7 [40]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dac_resetb
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dac_ldacb

execute_flow -compile
