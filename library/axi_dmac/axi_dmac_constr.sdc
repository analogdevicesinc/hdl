

set_false_path -to    [get_registers *axi_dmac*cdc_sync_stage1*]
set_false_path -from  [get_registers *axi_dmac*cdc_sync_fifo_ram*]
set_false_path -from  [get_registers *axi_dmac*eot_mem*]
set_false_path -from  [get_registers *axi_dmac*bl_mem*]

# Burst memory
set_false_path -from  [get_registers *axi_dmac*burst_len_mem*]

# Reset manager
set_false_path \
  -from [get_registers {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|do_reset}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[*]|clrn}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[0]}] \
  -to   [get_registers {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[3]}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[0]}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync_in|clrn}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync[0]}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync_in|clrn}]

# Debug signals
set_false_path -from  [get_registers *axi_dmac*|*i_request_arb*|cdc_sync_stage2*]  -to [get_registers *axi_dmac*up_rdata*]
set_false_path -from  [get_registers *axi_dmac*|*i_request_arb*|*id*]              -to [get_registers *axi_dmac*up_rdata*]
set_false_path -from  [get_registers *axi_dmac*|*i_request_arb*|address*]          -to [get_registers *axi_dmac*up_rdata*]
set_false_path \
  -from [get_registers {*|axi_dmac_transfer:i_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync[0]}] \
  -to   [get_registers {*|axi_dmac_regmap:i_regmap|up_rdata[*]}]
