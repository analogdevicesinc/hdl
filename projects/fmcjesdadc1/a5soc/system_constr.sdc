
create_clock -period "20.000 ns" -name clk_50m  [get_ports {sys_clk}]
create_clock -period  "4.000 ns" -name clk_250m [get_ports {ref_clk}]
create_clock -period  "6.666 ns" -name clk_150m [get_pins {i_system_bd|sys_hps|fpga_interfaces|clocks_resets|h2f_user0_clk}]

derive_pll_clocks
derive_clock_uncertainty

set clk_148m    [get_clocks {i_system_bd|sys_hdmi_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}]
set clk_rxlink  [get_clocks {i_system_bd|sys_jesd204b_s1_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from clk_50m     -to clk_150m
set_false_path -from clk_50m     -to $clk_148m
set_false_path -from clk_50m     -to $clk_rxlink
set_false_path -from clk_150m    -to clk_50m 
set_false_path -from clk_150m    -to $clk_148m
set_false_path -from clk_150m    -to $clk_rxlink
set_false_path -from $clk_rxlink -to clk_50m 
set_false_path -from $clk_rxlink -to clk_150m
set_false_path -from $clk_rxlink -to $clk_148m
set_false_path -from $clk_148m   -to clk_50m 
set_false_path -from $clk_148m   -to clk_150m
set_false_path -from $clk_148m   -to $clk_rxlink


