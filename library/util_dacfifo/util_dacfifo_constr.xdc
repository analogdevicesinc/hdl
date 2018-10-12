
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {name =~ *dac_waddr_m*}] \
  [get_cells -hierarchical -filter {name =~ *dac_lastaddr_m*}] \
  [get_cells -hierarchical -filter {name =~ *dac_xfer_out_*}] \
  [get_cells -hierarchical -filter {name =~ *dma_bypass*}] \
  [get_cells -hierarchical -filter {name =~ *dac_bypass*}] \
  [get_cells -hierarchical -filter {name =~ *dac_xfer_req_m*}]

set_false_path -from [get_cells -hierarchical -filter {name =~ *dma_waddr_g* && IS_SEQUENTIAL}] \
               -to [get_cells -hierarchical -filter {name =~ *dac_waddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hierarchical -filter {name =~ *dma_lastaddr_g* && IS_SEQUENTIAL}] \
               -to [get_cells -hierarchical -filter {name =~ *dac_lastaddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hierarchical -filter {name =~ *dma_xfer_out_fifo* && IS_SEQUENTIAL}] \
               -to [get_cells -hierarchical -filter {name =~ *dac_xfer_out_fifo_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hierarchical -filter {name =~ *dac_bypass_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hierarchical -filter {name =~ *dma_bypass_m1* && IS_SEQUENTIAL}]

# util_dacfifo_bypass CDC false-paths

set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {name =~ *dac_mem_*_m*}] \
  [get_cells -hierarchical -filter {name =~ *dma_mem_*_m*}] \
  [get_cells -hierarchical -filter {name =~ *dma_rst_m1*}] \

set_false_path -from [get_cells  -hierarchical -filter {name =~ */dma_mem_waddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hierarchical -filter {name =~ */dac_mem_waddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hierarchical -filter {name =~ */dac_mem_raddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hierarchical -filter {name =~ */dma_mem_raddr_m1* && IS_SEQUENTIAL}]
set_false_path -to   [get_cells  -hierarchical -filter {name =~ */dma_rst_m1_reg && IS_SEQUENTIAL}]
set_false_path -to   [get_cells  -hierarchical -filter {name =~ */dac_xfer_req_m1_reg && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hierarchical -filter {name =~ */dma_xfer_req* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hierarchical -filter {name =~ */dac_mem_waddr_m1* && IS_SEQUENTIAL}]

