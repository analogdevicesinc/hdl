
set_property ASYNC_REG TRUE \
	[get_cells -quiet -hier *cdc_sync_stage1_reg*] \
	[get_cells -quiet -hier *cdc_sync_stage2_reg*]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_waddr_sync_gray/cdc_sync_stage1_reg[*]/D}]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_raddr_sync_gray/cdc_sync_stage1_reg[*]/D}]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_axi_fifo_src_last_received_sync/cdc_sync_stage1_reg[*]/D}]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_axi_fifo_resetn_sync/cdc_sync_stage1_reg[*]/D}]

