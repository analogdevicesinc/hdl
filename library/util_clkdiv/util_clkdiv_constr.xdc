set_clock_groups -group [get_clocks clk_div_4_s] -group [get_clocks clk_div_2_s] -logically_exclusive
set_false_path -to [get_pins i_div_clk_gbuf/S*]
