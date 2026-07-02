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

create_clock -period "20.000 ns"  -name sys_clk     [get_ports {sys_clk}]
create_clock -period "16.666 ns"  -name usb1_clk    [get_ports {usb1_clk}]

derive_pll_clocks
derive_clock_uncertainty

set i3c_clk sys_clk

# Input data driven the peripherals toggles every 4 cycles max (PP) of the capture clock
# gets registered by rx_reg
set_multicycle_path -from [get_ports i3c_sda] -to [get_clocks $i3c_clk] -setup 4
set_multicycle_path -from [get_ports i3c_sda] -to [get_clocks $i3c_clk] -hold 3

# Output data toggles every 2 cycles max of the capture clock (PP)
set_multicycle_path -from [get_clocks $i3c_clk] -to [get_ports i3c_sda] -setup 2
set_multicycle_path -from [get_clocks $i3c_clk] -to [get_ports i3c_sda] -hold 1
set_multicycle_path -from [get_clocks $i3c_clk] -to [get_ports i3c_scl] -setup 2
set_multicycle_path -from [get_clocks $i3c_clk] -to [get_ports i3c_scl] -hold 1


# Notes
# tcr/tcf rising/fall time for SCL is 150e06 * 1 / fSCL, at fSCL = 12.5 MHz => 12ns, at fSCL = 6.25 MHz, 24ns.
# and t_SCO has a minimum/default value of 8ns and max of 12 ns
# The input_delay and output_delay are selected for the worst case scenario.
# One i3c_clk clock cycle is included in the sdo signal to ensure thd_pp(min) is met.
set tsco_max   12;
set tsco_min    8;
set trc_dly_max 1;
set trc_dly_min 0;
set_input_delay  -clock $i3c_clk -max [expr $tsco_max + $trc_dly_max] [get_ports i3c_sda]
set_input_delay  -clock $i3c_clk -min [expr $tsco_min + $trc_dly_min] [get_ports i3c_sda]
set tsu         2;
set thd         0;
set_output_delay  -clock $i3c_clk -max [expr $trc_dly_max + $tsu] [get_ports i3c_sda]
set_output_delay  -clock $i3c_clk -min [expr $trc_dly_min - $thd] [get_ports i3c_sda]
set_output_delay  -clock $i3c_clk -max [expr $trc_dly_max + $tsu] [get_ports i3c_scl]
set_output_delay  -clock $i3c_clk -min [expr $trc_dly_min - $thd] [get_ports i3c_scl]
