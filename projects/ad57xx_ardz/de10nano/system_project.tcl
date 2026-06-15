###############################################################################
## Copyright (C) 2024, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad57xx_ardz_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# ad57xx interface

set_location_assignment PIN_AG11 -to ad57xx_ardz_scl      ; # Arduino_IO15
set_location_assignment PIN_AH9  -to ad57xx_ardz_sda      ; # Arduino_IO14
set_location_assignment PIN_AH12 -to ad57xx_ardz_spi_sclk ; # Arduino_IO13
set_location_assignment PIN_AH11 -to ad57xx_ardz_spi_miso ; # Arduino_IO12
set_location_assignment PIN_AG16 -to ad57xx_ardz_spi_mosi ; # Arduino_IO11
set_location_assignment PIN_AF15 -to ad57xx_ardz_syncb    ; # Arduino_IO10
set_location_assignment PIN_AH8  -to ad57xx_ardz_resetb   ; # Arduino_IO7
set_location_assignment PIN_AG9  -to ad57xx_ardz_ldacb    ; # Arduino_IO3
set_location_assignment PIN_AG10 -to ad57xx_ardz_clrb     ; # Arduino_IO2

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_sda
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_spi_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_syncb
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_ldacb
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_clrb
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad57xx_ardz_resetb

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

set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
execute_flow -compile
