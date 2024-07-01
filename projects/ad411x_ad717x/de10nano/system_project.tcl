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

# ad4170 interface

set_location_assignment PIN_U14  -to error          ; ##   J7.5 Arduino_IO04
set_location_assignment PIN_AG9  -to sync_error     ; ##   J7.4 Arduino_IO03

set_location_assignment PIN_AF15 -to spi_csn        ; ##   J5.3 Arduino_IO10
set_location_assignment PIN_AG16 -to spi_mosi       ; ##   J5.4 Arduino_IO11
set_location_assignment PIN_AH11 -to spi_miso       ; ##   J5.5 Arduino_IO12
set_location_assignment PIN_AH12 -to spi_clk        ; ##   J5.6 Arduino_IO13

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to error
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sync_error

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_csn
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_clk

# Arduino shield connections on de10_nano

                  ####################################
                  #                                  #       ## JP2 ##
                  #                             *1   #    1  Arduino_IO15
                  #                             *2   #    2  Arduino_IO14
                  #                             *3   #    3  Arduino_VREF
   ## JP5 ##      #                             *4   #    4  Arduino_GND
 # 1  NC          #                             *5   #    5  Arduino_IO13
 # 2  VCC3P3      #     *1                      *6   #    6  Arduino_IO12
 # 3  Reset_n     #     *2                      *7   #    7  Arduino_IO11
 # 4  VCC3P3      #     *3                  JP2 *8   #    8  Arduino_IO10
 # 5  VCC5        #     *4                      *9   #    9  Arduino_IO9
 # 6  GND         # JP5 *5                      *10  #    10 Arduino_IO8
 # 7  GND         #     *6                           #
 # 8  VCC9        #     *7                           #       ## JP3 ##
                  #     *8                      *1   #    1  Arduino_IO7
                  #                             *2   #    2  Arduino_IO6
   ## JP6 ##      #     *1                      *3   #    3  Arduino_IO5
 # 1 ADC_IN0      #     *2                      *4   #    4  Arduino_IO4
 # 2 ADC_IN1      # JP6 *3          531     JP3 *5   #    5  Arduino_IO3
 # 3 ADC_IN2      #     *4      JP4 ***         *6   #    6  Arduino_IO2
 # 4 ADC_IN3      #     *5          ***         *7   #    7  Arduino_IO1
 # 5 ADC_IN4      #     *6          642         *8   #    8  Arduino_IO0
 # 6 ADC_IN5      #                                  #
                   #                                #
                    #                              #
                     ##############################

                                ## JP4 ##
                              # 1 Arduino_I12
                              # 2 VCC5
                              # 3 Arduino_I13
                              # 4 Arduino_IO11
                              # 5 Arduino_Reset_n
                              # 6 GND


execute_flow -compile
