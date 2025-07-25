###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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
