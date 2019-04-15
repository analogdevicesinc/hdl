create_generated_clock -name [current_instance]/pwm_ctrl -source [get_ports ref_clk]  \
  -divide_by 2 [get_pins pwm_gen_clk_reg/Q]

