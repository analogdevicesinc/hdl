
set_property ASYNC_REG TRUE \
  [get_cells -hier *axi_waddr_m1_reg*] \
  [get_cells -hier *axi_waddr_m2_reg*] \
  [get_cells -hier *adc_xfer_req_m_reg*] \
  [get_cells -hier *axi_xfer_req_m_reg*] \
  [get_cells -hier *axi_rel_toggle_m_reg*]

## axi_adcfifo_wr CDC paths

set_false_path -to  [get_pins -hier -filter {name =~ *adc_xfer_req_m_reg[0]/D}]
set_false_path -to  [get_pins -hier -filter {name =~ *axi_rel_toggle_m_reg[0]/D}]

set_false_path -from  [get_cells -hier * -filter {name =~ *adc_rel_waddr_reg*}] \
               -to    [get_cells -hier * -filter {name =~ *axi_rel_waddr_reg*}] \

set_false_path -to  [get_pins -hier -filter {name =~ *axi_waddr_m1_reg[*]/D}]

## axi_adcfifo_rd CDC paths

set_false_path -to  [get_pins -hier -filter {name =~ *axi_xfer_req_m_reg[0]/D}]

## axi_adcfifo_dma CDC paths

set_false_path -to  [get_pins -hier -filter {name =~ *dma_waddr_rel_t_m_reg[0]/D}]

set_false_path -from  [get_cells -hier * -filter {name =~ *axi_waddr_rel_reg*}] \
               -to    [get_cells -hier * -filter {name =~ *dma_waddr_rel_reg*}] \

