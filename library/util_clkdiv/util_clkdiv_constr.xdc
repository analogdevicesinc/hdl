set_clock_groups \
  -group [get_clocks -of_objects [get_pins clk_divide_sel_0/O]] \
  -group [get_clocks -of_objects [get_pins clk_divide_sel_1/O]] \
  -logically_exclusive
set_false_path -to [get_pins i_div_clk_gbuf/S*]
