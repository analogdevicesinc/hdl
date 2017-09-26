set_property ASYNC_REG TRUE \
  [get_cells -hier *dma_mem_*_m*] \
  [get_cells -hier *axi_xfer_*_m*] \
  [get_cells -hier *axi_mem_*_m*] \
  [get_cells -hier *axi_dma_*_m*] \
  [get_cells -hier *dac_mem_*_m*] \
  [get_cells -hier *dac_xfer_*_m*] \
  [get_cells -hier *dac_last_*_m*] \
  [get_cells -hier *dac_bypass_m*]

set_false_path -to [get_cells  -hier -filter {name =~ *_bypass_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells  -hier -filter {name =~ *dac_xfer_out_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells  -hier -filter {name =~ *_xfer_req_m_reg[0]* && IS_SEQUENTIAL}]

set_false_path -from [get_cells  -hier -filter {name =~ *dma_* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ *axi_*_m* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *axi_* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ *dma_*_m* && IS_SEQUENTIAL}]

set_false_path -from [get_cells  -hier -filter {name =~ *dac_* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ *axi_*_m* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *axi_* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ *dac_*_m* && IS_SEQUENTIAL}]

set_false_path -from [get_cells  -hier -filter {name =~ *dac_* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ *dma_*_m* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ *dma_* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ *dac_*_m* && IS_SEQUENTIAL}]

set_false_path -from [get_cells -hier -filter {name =~ *axi_mem_laddr* && IS_SEQUENTIAL}] \
               -to   [get_cells -hier -filter {name =~ *dac_mem_laddr* && IS_SEQUENTIAL}]

set_false_path -from [get_cells -hier -filter {name =~ *i_laddress_buffer*m_ram_reg* && IS_SEQUENTIAL}] \
               -to   [get_cells -hier -filter {name =~ *dac_mem_raddr_reg* && IS_SEQUENTIAL}]

