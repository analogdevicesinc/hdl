set_property ASYNC_REG TRUE \
  [get_cells -hier *adc_wovf_m*]

set_false_path \
  -to [get_cells -hier adc_wovf_m_reg[0]* -filter {primitive_subgroup == flop}]
