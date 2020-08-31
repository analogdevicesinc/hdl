
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project cn0501_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../../ad7768evb/common/ad7768_if.v

# I2C

set_location_assignment PIN_AG11  -to i2c_scl             ; ##   Arduino_IO15
set_location_assignment PIN_AH9   -to i2c_sda             ; ##   Arduino_IO14

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

# SPI

set_location_assignment PIN_AF15  -to cn_spi_cs           ; ##   Arduino_IO10
set_location_assignment PIN_AG16  -to cn_spi_mosi         ; ##   Arduino_IO11
set_location_assignment PIN_AH11  -to cn_spi_miso         ; ##   Arduino_IO12
set_location_assignment PIN_AH12  -to cn_spi_clk          ; ##   Arduino_IO13

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn_spi_cs
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn_spi_clk

# AD7768 interface

set_location_assignment PIN_AF17  -to clk_in              ; ##   Arduino_IO8
set_location_assignment PIN_AE15  -to ready_in            ; ##   Arduino_IO9
set_location_assignment PIN_AH8   -to data_in[0]          ; ##   Arduino_IO7
set_location_assignment PIN_AG8   -to data_in[1]          ; ##   Arduino_IO6
set_location_assignment PIN_U13   -to data_in[2]          ; ##   Arduino_IO5
set_location_assignment PIN_U14   -to data_in[3]          ; ##   Arduino_IO4
set_location_assignment PIN_AG9   -to data_in[4]          ; ##   Arduino_IO3
set_location_assignment PIN_AG10  -to data_in[5]          ; ##   Arduino_IO2
set_location_assignment PIN_AF13  -to data_in[6]          ; ##   Arduino_IO1
set_location_assignment PIN_AG13  -to data_in[7]          ; ##   Arduino_IO0

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk_in
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ready_in
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data_in[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data_in[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data_in[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data_in[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data_in[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data_in[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data_in[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data_in[7]

execute_flow -compile
