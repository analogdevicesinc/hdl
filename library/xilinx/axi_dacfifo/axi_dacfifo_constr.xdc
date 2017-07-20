
set_property ASYNC_REG TRUE \
  [get_cells -hier *_xfer_req_m*] \
  [get_cells -hier *_xfer_last_m*] \
  [get_cells -hier *dac_xfer_out*] \
  [get_cells -hier *dac_bypass_*] \
  [get_cells -hier *dma_bypass_*]


set_false_path -to [get_cells  -hier -filter {name =~ *_xfer_req_m_reg[0]* && IS_SEQUENTIAL}]
set_false_path -to [get_cells  -hier -filter {name =~ *_xfer_last_m_reg[0]* && IS_SEQUENTIAL}]
set_false_path -to [get_cells  -hier -filter {name =~ *dac_xfer_out_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells  -hier -filter {name =~ *_bypass_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells  -hier -filter {name =~ *dma_rst_m1* && IS_SEQUENTIAL}]

set_false_path -from [get_cells  -hier -filter {name =~ *dma_* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *axi_*_m* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *axi_* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *dma_*_m* && IS_SEQUENTIAL}]

set_false_path -from [get_cells  -hier -filter {name =~ *dac_* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *axi_*_m* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *axi_* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *dac_*_m* && IS_SEQUENTIAL}]

set_false_path -from [get_cells  -hier -filter {name =~ *dac_* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *dma_*_m* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *dma_* && IS_SEQUENTIAL}] \
  -to [get_cells  -hier -filter {name =~ *dac_*_m* && IS_SEQUENTIAL}]
