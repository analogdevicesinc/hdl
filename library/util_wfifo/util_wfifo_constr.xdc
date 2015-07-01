set_property ASYNC_REG TRUE \
  [get_cells -hier *adc_wovf_m*] \
  [get_cells -hier *fifo_rst_p*]

set_false_path \
  -to [get_cells -hier adc_wovf_m_reg[0]* -filter {primitive_subgroup == flop}]

set_false_path \
  -to [get_pins -hier */PRE -filter {NAME =~ *i_*fifo_rst*}]

set_false_path \
  -to [get_pins -hier */CLR -filter {NAME =~ *i_*fifo_rstn_reg*}]
