create_clock -period "20.000 ns"  -name sys_clk     [get_ports {sys_clk}]
create_clock -period "16.666 ns"  -name usb1_clk    [get_ports {usb1_clk}]
create_clock -period "122.07 ns"  -name adc_clk     [get_ports {adc_clk_in}]

derive_pll_clocks
derive_clock_uncertainty

set fall_min            52.53;       # period/2(=61.03) - skew_bfe(=8.5)        
set fall_max            69.53;       # period/2(=61.03) + skew_afe(=8.5)  

set_input_delay -max  $fall_max  -clock {adc_clk} [get_ports {get_ports adc_data_in[*]}] -clock_fall -add_delay;
set_input_delay -min  $fall_min  -clock {adc_clk} [get_ports {get_ports adc_data_in[*]}] -clock_fall -add_delay;

#set_input_delay -max  $fall_max  -clock {adc_clk} [get_ports {adc_ready_in}] -clock_fall -add_delay;
#set_input_delay -min  $fall_min  -clock {adc_clk} [get_ports {adc_ready_in}] -clock_fall -add_delay;