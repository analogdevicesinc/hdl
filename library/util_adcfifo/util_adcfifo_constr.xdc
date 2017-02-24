
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *adc_xfer_req_m*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dma_waddr_rel_t*}]

set_false_path -from [get_cells -hier -filter {name =~ *adc_waddr_rel_t_reg* && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *dma_waddr_rel_t_m_reg[0]* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *adc_waddr_rel_reg* && IS_SEQUENTIAL}]   -to [get_cells -hier -filter {name =~ *dma_waddr_rel_reg* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *adc_xfer_req_m_reg[0]* && IS_SEQUENTIAL}]

