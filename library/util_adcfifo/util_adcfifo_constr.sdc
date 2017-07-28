
set_false_path -from [get_registers *adc_waddr*] -to [get_registers *dma_waddr*]
set_false_path -to [get_registers *adc_xfer_req_m[0]*]

