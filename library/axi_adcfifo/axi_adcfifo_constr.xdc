
set_property ASYNC_REG TRUE \
  [get_cells -hier *axi_waddr_m1_reg*] \
  [get_cells -hier *axi_waddr_m2_reg*] \
  [get_cells -hier *adc_xfer_req_m_reg[0]*]

set_false_path -from [get_cells *dma_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *axi_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *axi_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *dma_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

set_false_path -from [get_cells *adc_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *axi_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *axi_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *adc_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

set_false_path -from [get_cells *d_xfer_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *up_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *up_xfer_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *d_xfer_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *adc_rel_waddr* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *axi_rel_waddr* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

set_false_path \
  -to [get_cells *adc_xfer_req_m_reg[0]* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

