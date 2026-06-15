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

adi_project ad4170_asdz_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_edge_detect.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/util_cdc/sync_bits.v

# ad4170 interface

set_location_assignment PIN_AH8  -to ad4170_dig_aux[1]     ; ##   P5.8 Arduino_IO07
set_location_assignment PIN_AG10 -to ad4170_dig_aux[0]     ; ##   P5.3 Arduino_IO02

set_location_assignment PIN_AF15 -to ad4170_spi_csn        ; ##   P4.3 Arduino_IO10
set_location_assignment PIN_AG16 -to ad4170_spi_mosi       ; ##   P4.4 Arduino_IO11
set_location_assignment PIN_AH11 -to ad4170_spi_miso       ; ##   P4.5 Arduino_IO12
set_location_assignment PIN_AH12 -to ad4170_spi_clk        ; ##   P4.6 Arduino_IO13

set_location_assignment PIN_AH9   -to i2c_sda              ; ##   P4.9 Arduino_IO14
set_location_assignment PIN_AG11  -to i2c_scl              ; ##   P4.10 Arduino_IO15

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_dig_aux[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_dig_aux[0]

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_spi_csn
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ad4170_spi_clk

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

execute_flow -compile
