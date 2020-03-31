
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad77681evb_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# files


# SPI interface

set_location_assignment PIN_AH12 -to ad77681_spi_sclk      ; ##   Arduino_IO13
set_location_assignment PIN_AH11 -to ad77681_spi_miso      ; ##   Arduino_IO12
set_location_assignment PIN_AG16 -to ad77681_spi_mosi      ; ##   Arduino_IO11
set_location_assignment PIN_AF15 -to ad77681_spi_cs        ; ##   Arduino_IO10

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_spi_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_spi_cs

# reset and GPIO signals

set_location_assignment PIN_AG9  -to ad77681_reset         ; ##   Arduino_IO3
set_location_assignment PIN_AE15 -to ad77681_fda_dis       ; ##   Arduino_IO9
set_location_assignment PIN_AF17 -to ad77681_fda_mode      ; ##   Arduino_IO8
set_location_assignment PIN_U13  -to ad77681_dac_buf_en    ; ##   Arduino_IO5
set_location_assignment PIN_U14  -to ad77681_io_int        ; ##   Arduino_IO4

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_reset
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_fda_dis
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_fda_mode
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_dac_buf_en
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_io_int

# synchronization and timing

set_location_assignment PIN_AG10 -to ad77681_drdy          ; ##   Arduino_IO2
set_location_assignment PIN_AG8  -to ad77681_sync_in       ; ##   Arduino_IO6

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_drdy
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad77681_sync_in


# set optimization to get a better timing closure
#set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

execute_flow -compile
