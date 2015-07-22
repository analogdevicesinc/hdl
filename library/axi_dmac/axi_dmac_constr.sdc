

set_false_path -to    [get_registers *axi_dmac*cdc_sync_stage1*]
set_false_path -from  [get_registers *axi_dmac*cdc_sync_fifo_ram*]
set_false_path -from  [get_registers *axi_dmac*eot_mem*]
set_false_path -to    [get_registers *axi_dmac*reset_shift*]
set_false_path -to    [get_registers *axi_dmac*ram*]
set_false_path -from  [get_registers *axi_dmac*cdc_sync_stage2*]      -to [get_registers *axi_dmac*up_rdata*]
set_false_path -from  [get_registers *axi_dmac*id*]                   -to [get_registers *axi_dmac*up_rdata*]
set_false_path -from  [get_registers *axi_dmac*address*]              -to [get_registers *axi_dmac*up_rdata*]

