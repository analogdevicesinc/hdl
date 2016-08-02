
set_property shreg_extract no [get_cells -hier -filter {name =~ *dac_lastaddr_d*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *dac_xfer_out_m*}]

set_false_path -from [get_cells -hier -filter {name =~ *dma_lastaddr_reg* && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *dac_lastaddr_d_reg* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *dac_xfer_out_m_reg[0]* && IS_SEQUENTIAL}]

