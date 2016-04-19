
set_property ASYNC_REG TRUE \
  [get_cells -hier *dac_dovf_m_reg*] \
  [get_cells -hier *dac_xfer_req_m_reg*] \
  [get_cells -hier *dac_dunf_m_reg*]

set_false_path -from [get_cells *dac_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *axi_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *axi_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *dac_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

