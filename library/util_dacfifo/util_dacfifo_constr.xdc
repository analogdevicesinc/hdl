
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dma_raddr_m*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dac_waddr_m*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dac_lastaddr_m*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dac_xfer_out*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dma_bypass*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dac_bypass*}]

set_false_path -from [get_cells -hier -filter {name =~ *dac_raddr_g* && IS_SEQUENTIAL}] \
               -to [get_cells -hier -filter {name =~ *dma_raddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *dma_waddr_g* && IS_SEQUENTIAL}] \
               -to [get_cells -hier -filter {name =~ *dac_waddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *dma_lastaddr_g* && IS_SEQUENTIAL}] \
               -to [get_cells -hier -filter {name =~ *dac_lastaddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *dma_xfer_out_fifo* && IS_SEQUENTIAL}] \
               -to [get_cells -hier -filter {name =~ *dac_xfer_out_fifo_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *dma_xfer_out_bypass* && IS_SEQUENTIAL}] \
               -to [get_cells -hier -filter {name =~ *dac_xfer_out_bypass_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *dac_bypass_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *dma_bypass_m1* && IS_SEQUENTIAL}]
