###############################################################################
## Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
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
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."""
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad411x_ad717x_de10nano

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

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to i2c_scl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to i2c_sda

execute_flow -compile
