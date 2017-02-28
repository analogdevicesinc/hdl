
set_false_path -to [get_registers *_xfer_req_m*[0]*]
set_false_path -to [get_registers *_xfer_last_m*[0]*]
set_false_path -to [get_registers *dac_xfer_out_m1*]
set_false_path -to [get_registers *_bypass_m1*]
set_false_path -to [get_registers *dma_rst_m1*]

set_false_path -from [get_registers *dma_*] -to [get_registers *axi_*_m*]
set_false_path -from [get_registers *axi_*] -to [get_registers *dma_*_m*]
set_false_path -from [get_registers *dac_*] -to [get_registers *axi_*_m*]
set_false_path -from [get_registers *axi_*] -to [get_registers *dac_*_m*]
set_false_path -from [get_registers *dac_*] -to [get_registers *dma_*_m*]
set_false_path -from [get_registers *dma_*] -to [get_registers *dac_*_m*]

