create_generated_clock -name [current_instance]/ia_clk -source [get_ports adc_clk_i] \
  -divide_by 256 [get_pins ia_if/filter/word_count_reg[7]/Q]
create_generated_clock -name [current_instance]/ib_clk -source [get_ports adc_clk_i] \
  -divide_by 256 [get_pins ib_if/filter/word_count_reg[7]/Q]
create_generated_clock -name [current_instance]/vbus_clk -source [get_ports adc_clk_i] \
  -divide_by 256 [get_pins vbus_if/filter/word_count_reg[7]/Q]

