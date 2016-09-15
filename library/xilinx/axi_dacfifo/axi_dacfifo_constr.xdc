
set_property shreg_extract no [get_cells -hier -filter {name =~ *xfer_req_m*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *xfer_last_m*}]

set_false_path -to [get_cells axi_xfer_*_m* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
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

