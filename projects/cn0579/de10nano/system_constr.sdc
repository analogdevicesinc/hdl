###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "20.000 ns"  -name sys_clk     [get_ports {sys_clk}]
create_clock -period "16.666 ns"  -name usb1_clk    [get_ports {usb1_clk}]
create_clock -period "122.07 ns"  -name adc_clk     [get_ports {adc_clk_in}]

derive_pll_clocks
derive_clock_uncertainty

set input_clock_period  30.51;    # Period of input clock fMAX_DCLK=32.768MHz
set hold_time           8.5;               
set setup_time          8.5;       

set_input_delay -clock adc_clk -max   [expr $input_clock_period - $setup_time]  [get_ports data_in[*]] -clock_fall -add_delay;
set_input_delay -clock adc_clk -min   $hold_time  [get_ports data_in[*]] -clock_fall -add_delay;
