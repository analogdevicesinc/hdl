
set_property ASYNC_REG TRUE \
  [get_cells -hier *axi_waddr_m1_reg*] \
  [get_cells -hier *axi_waddr_m2_reg*] \
  [get_cells -hier *adc_xfer_req_m_reg[0]*]
  [get_cells -hier *axi_xfer_req_m_reg[0]*]

set_false_path -from [get_cells  -hier -filter {name =~ *dma_raddr_rel_t* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *axi_raddr_rel_t_m*[0] && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *axi_waddr_rel_t* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *dma_waddr_rel_t_m*[0] && IS_SEQUENTIAL}]

set_false_path -to [get_cells -hier -filter {name =~ *axi_xfer_req_m*[0] && IS_SEQUENTIAL}]

set_false_path -to [get_cells  -hier -filter {name =~ *adc_xfer_req_m*[0] && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *adc_rel_waddr* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *axi_rel_waddr* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *adc_rel_toggle* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *axi_rel_toggle_m*[0] && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *adc_waddr_g* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *axi_waddr_m1_reg* && IS_SEQUENTIAL}]
set_false_path -to [get_cells  -hierarchical -filter {name =~ *axi_xfer_req_m*[0] && IS_SEQUENTIAL}]

