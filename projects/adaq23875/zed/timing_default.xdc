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

set dco_clk_period 10
create_clock -period $dco_clk_period -name dco  [get_ports dco_p]

# input delays for 100MHz clk

set_input_delay -clock [get_clocks dco] -clock_fall -min -add_delay 2.300 [get_ports da_p]
set_input_delay -clock [get_clocks dco] -clock_fall -max -add_delay 2.700 [get_ports da_p]
set_input_delay -clock [get_clocks dco] -min -add_delay 2.300 [get_ports da_p]
set_input_delay -clock [get_clocks dco] -max -add_delay 2.700 [get_ports da_p]

set_input_delay -clock [get_clocks dco] -clock_fall -min -add_delay 2.300 [get_ports db_p]
set_input_delay -clock [get_clocks dco] -clock_fall -max -add_delay 2.700 [get_ports db_p]
set_input_delay -clock [get_clocks dco] -min -add_delay 2.300 [get_ports db_p]
set_input_delay -clock [get_clocks dco] -max -add_delay 2.700 [get_ports db_p]

set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387/inst/i_if/i_rx_db/i_rx_data_idelay]
set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387/inst/i_if/i_rx_da/i_rx_data_idelay]
