set_false_path -from [get_cells *dma_lastaddr_reg* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *dma_lastaddr_d_reg* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
