###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make OFFLOAD=1
#
# Parameter description:
#
# OFFLOAD : Enable offload mode, includes AXI_DMAC and AXI_PWM to the design
#       1 - enabled
#       0 - disabled (default)

adi_project ad4062_ardz_de10nano [list \
  OFFLOAD [get_env_param OFFLOAD 0]]

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# I3C interface bus

set_location_assignment PIN_AG11 -to i3c_scl ; ##   Arduino_IO15
set_location_assignment PIN_AH9  -to i3c_sda ; ##   Arduino_IO14

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i3c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i3c_sda

# Enable if not using an external 2.2k ohm passive pull-up
#set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to i3c_sda

# reset and GPIO signals

set_location_assignment PIN_AE15 -to common_shutdown      ; ##   Arduino_IO9
set_location_assignment PIN_AH8  -to common_reset_adc     ; ##   Arduino_IO7
set_location_assignment PIN_U13  -to common_csb_aux       ; ##   Arduino_IO5
set_location_assignment PIN_U14  -to common_sw_ff         ; ##   Arduino_IO4
set_location_assignment PIN_AG9  -to common_drdy_aux      ; ##   Arduino_IO3
set_location_assignment PIN_AF13 -to common_blue_led      ; ##   Arduino_IO1
set_location_assignment PIN_AG13 -to common_yellow_led    ; ##   Arduino_IO0

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to common_shutdown
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to common_reset_adc
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to common_csb_aux
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to common_sw_ff
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to common_drdy_aux
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to common_blue_led
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to common_yellow_led

# synchronization and timing

set_location_assignment PIN_AG8  -to common_sync_in       ; ##   arduino_IO6

set_instance_assignment -name io_standard "3.3-v lvttl" -to common_sync_in

execute_flow -compile
