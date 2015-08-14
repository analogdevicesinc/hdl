set up_clk [get_clocks -of_objects [get_ports s_axi_aclk]]
set speed_clk [get_clocks -of_objects [get_ports ref_clk]]

set_property ASYNC_REG TRUE \
  [get_cells -hier *toggle_m1_reg*] \
  [get_cells -hier *toggle_m2_reg*] \
  [get_cells -hier *state_m1_reg*] \
  [get_cells -hier *state_m2_reg*]

set_false_path \
  -to [get_pins -hier */PRE -filter {NAME =~ *i_*rst_reg*}]
