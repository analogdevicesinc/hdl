set REQUIRED_QUARTUS_VERSION 21.1
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project cn0579_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# ad77684 interface

set_location_assignment PIN_AF17 -to adc_clk_in    ; ##   P12.10 Arduino_IO08
set_location_assignment PIN_AE15 -to adc_ready_in  ; ##   P12.9  Arduino_IO09

set_location_assignment PIN_AH8  -to adc_data_in[0]; ##   P14.1 Arduino_IO07
set_location_assignment PIN_AG8  -to adc_data_in[1]; ##   P14.2 Arduino_IO06
set_location_assignment PIN_U13  -to adc_data_in[2]; ##   P14.3 Arduino_IO05
set_location_assignment PIN_U14  -to adc_data_in[3]; ##   P14.4 Arduino_IO04 

set_location_assignment PIN_AG9  -to shutdown_n    ; ##   P14.5 Arduino_IO03 
set_location_assignment PIN_AG10 -to reset_n       ; ##   P14.6 Arduino_IO02
           
set_location_assignment PIN_AF15 -to spi_csn       ; ##   P12.8 Arduino_IO10
set_location_assignment PIN_AG16 -to spi_mosi      ; ##   P12.7 Arduino_IO11
set_location_assignment PIN_AH11 -to spi_miso      ; ##   P12.6 Arduino_IO12
set_location_assignment PIN_AH12 -to spi_clk       ; ##   P12.5 Arduino_IO13

set_location_assignment PIN_AG11 -to dac_i2c_scl   ; ##   P12.1 Arduino_IO15
set_location_assignment PIN_AH9  -to dac_i2c_sda   ; ##   P12.2 Arduino_IO14

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_clk_in   
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_ready_in 

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_data_in[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_data_in[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_data_in[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adc_data_in[3]

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to shutdown_n         
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to reset_n      

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_csn      
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_mosi     
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_miso     
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_clk     

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dac_i2c_scl     
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dac_i2c_sda
       
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to dac_i2c_scl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to dac_i2c_sda

execute_flow -compile
