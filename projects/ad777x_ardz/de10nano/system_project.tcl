###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 22.1std.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad777x_ardz_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# ad777x interface

set_location_assignment PIN_AE15 -to adc_clk_in     ; ##   P4.2 Arduino_IO09
set_location_assignment PIN_AF17 -to adc_ready_in   ; ##   P4.1 Arduino_IO08
set_location_assignment PIN_AG8  -to adc_data_in[0] ; ##   P5.7 Arduino_IO06
set_location_assignment PIN_U13  -to adc_data_in[1] ; ##   P5.6 Arduino_IO05
set_location_assignment PIN_U14  -to adc_data_in[2] ; ##   P5.5 Arduino_IO04
set_location_assignment PIN_AG13 -to adc_data_in[3] ; ##   P5.1 Arduino_IO00

set_location_assignment PIN_AF13 -to sdp_convst     ; ##   P5.2 Arduino_IO01
set_location_assignment PIN_AH8  -to start_n        ; ##   P5.8 Arduino_IO07              
set_location_assignment PIN_AG10 -to reset_n        ; ##   P5.3 Arduino_IO02
set_location_assignment PIN_AG9  -to sdp_mclk       ; ##   P5.4 Arduino_IO03

set_location_assignment PIN_AF15 -to spi_csn        ; ##   P4.3 Arduino_IO10
set_location_assignment PIN_AG16 -to spi_mosi       ; ##   P4.4 Arduino_IO11
set_location_assignment PIN_AH11 -to spi_miso       ; ##   P4.5 Arduino_IO12
set_location_assignment PIN_AH12 -to spi_clk        ; ##   P4.5 Arduino_IO13

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_clk_in   
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_ready_in 

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_data_in[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_data_in[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_data_in[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_data_in[3]

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdp_convst   
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to start_n      
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to reset_n      
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdp_convst   
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdp_mclk

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_csn      
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_mosi     
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_miso     
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_clk      
       
execute_flow -compile
