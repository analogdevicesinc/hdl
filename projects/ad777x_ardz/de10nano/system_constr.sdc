###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "20.000 ns"  -name sys_clk     [get_ports {sys_clk}]
create_clock -period "16.666 ns"  -name usb1_clk    [get_ports {usb1_clk}]
create_clock -period "488.00 ns"  -name adc_clk     [get_ports {adc_clk_in}]

derive_pll_clocks
derive_clock_uncertainty

set fall_min            224;       # period/2(=244) - skew_bfe(=20)        
set fall_max            264;       # period/2(=244) + skew_are(=20)  

set_input_delay -clock adc_clk -max  $fall_max  [get_ports adc_data_in[*]] -clock_fall -add_delay;
set_input_delay -clock adc_clk -min  $fall_min  [get_ports adc_data_in[*]] -clock_fall -add_delay;

set_input_delay -clock adc_clk -min  $fall_min  [get_ports adc_ready_in  ] -clock_fall -add_delay;
set_input_delay -clock adc_clk -min  $fall_min  [get_ports adc_ready_in  ] -clock_fall -add_delay;
