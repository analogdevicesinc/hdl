set REQUIRED_QUARTUS_VERSION 21.1.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project cn0540_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

#
## down-rade Critical Warning reated to a asynchronous RAM in DMAC
#
## "mixed_port_feed_through_mode" parameter of RAM can not have value "old"
set_global_assignment -name MESSAGE_DISABLE 15003

# files

# SPI interface for ad7768-1

set_location_assignment PIN_AH12 -to cn0540_spi_sclk      ; ##   Arduino_IO13
set_location_assignment PIN_AH11 -to cn0540_spi_miso      ; ##   Arduino_IO12
set_location_assignment PIN_AG16 -to cn0540_spi_mosi      ; ##   Arduino_IO11
set_location_assignment PIN_AF15 -to cn0540_spi_cs        ; ##   Arduino_IO10

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_spi_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_spi_cs

# I2C

set_location_assignment PIN_AG11  -to i2c_scl             ; ##   Arduino_IO15
set_location_assignment PIN_AH9   -to i2c_sda             ; ##   Arduino_IO14

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

# reset and GPIO signals

set_location_assignment PIN_AE15 -to cn0540_shutdown      ; ##   Arduino_IO9
set_location_assignment PIN_AH8	 -to cn0540_reset_adc     ; ##   Arduino_IO7
set_location_assignment PIN_U13  -to cn0540_csb_aux       ; ##   Arduino_IO5
set_location_assignment PIN_U14  -to cn0540_sw_ff         ; ##   Arduino_IO4
set_location_assignment PIN_AG9  -to cn0540_drdy_aux      ; ##   Arduino_IO3
set_location_assignment PIN_AF13 -to cn0540_blue_led      ; ##   Arduino_IO1
set_location_assignment PIN_AG13 -to cn0540_yellow_led    ; ##   Arduino_IO0

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_shutdown
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_reset_adc
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_csb_aux
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_sw_ff
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_drdy_aux
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_blue_led
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_yellow_led

# synchronization and timing

set_location_assignment PIN_AG8  -to cn0540_sync_in       ; ##   Arduino_IO6
set_location_assignment PIN_AG10 -to cn0540_drdy          ; ##   Arduino_IO2

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_sync_in
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_drdy

execute_flow -compile
