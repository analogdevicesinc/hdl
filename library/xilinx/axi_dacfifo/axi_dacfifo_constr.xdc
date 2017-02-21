
set_property ASYNC_REG TRUE \
  [get_cells -hier *_xfer_req_m[0]*] \
  [get_cells -hier *_xfer_last_m[0]*]

set_false_path -to [get_cells *_xfer_req_m[0]* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -to [get_cells *_xfer_last_m[0]* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -to [get_cells *dma_rst_m1* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

set_false_path -from [get_cells *dma_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *axi_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *axi_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *dma_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

set_false_path -from [get_cells *dac_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *axi_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *axi_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *dac_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

set_false_path -from [get_cells *dac_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *dma_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *dma_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *dac_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]

