
set_false_path -from [get_registers *dma_lastaddr_reg*] -to [get_registers *dac_lastaddr_d_reg*]
set_false_path -to [get_registers *dac_xfer_out_m_reg[0]*]

