set ctrl_clk [get_clocks -of_objects [get_ports S_AXI_ACLK]]
set data_clk [get_clocks -of_objects [get_ports DATA_CLK_I]]

set_property ASYNC_REG TRUE \
	[get_cells -hier cdc_sync_stage1_*_reg] \
	[get_cells -hier cdc_sync_stage2_*_reg]

set_false_path \
	-from [get_cells -hier cdc_sync_stage0_*_reg -filter {PRIMITIVE_SUBGROUP == flop}] \
	-to [get_cells -hier cdc_sync_stage1_*_reg -filter {PRIMITIVE_SUBGROUP == flop}]

# TX FIFO
set_max_delay \
	-from $ctrl_clk  \
	-to [get_cells -hier out_data_reg* -filter {PRIMITIVE_SUBGROUP == flop && NAME =~ *tx_sync*}] \
	[get_property PERIOD $data_clk] -datapath_only

# RX FIFO
set_max_delay \
	-from $data_clk  \
	-to [get_cells -hier out_data_reg* -filter {PRIMITIVE_SUBGROUP == flop && NAME =~ *rx_sync*}] \
	[get_property PERIOD $ctrl_clk] -datapath_only

# Reset
set_false_path \
	-to [get_pins -hier data_reset_vec_reg*/PRE]
