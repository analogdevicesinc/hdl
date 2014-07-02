
create_clock -period "20.000 ns" -name clk_50m  [get_ports {sys_clk}]
create_clock -period  "4.000 ns" -name clk_250m [get_ports {rx_clk_in}]
create_clock -period "10.000 ns" -name clk_100m [get_pins {i_system_bd|sys_hps|fpga_interfaces|clocks_resets|h2f_user0_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from clk_50m     -to clk_100m
set_false_path -from clk_50m     -to clk_250m
set_false_path -from clk_100m    -to clk_50m 
set_false_path -from clk_100m    -to clk_250m 
set_false_path -from clk_250m    -to clk_50m 
set_false_path -from clk_250m    -to clk_100m 


