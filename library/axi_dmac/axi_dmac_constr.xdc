
set req_clk [get_clocks -of_objects [get_ports s_axi_aclk]]
set src_clk [get_clocks -of_objects [get_ports {fifo_wr_clk s_axis_aclk m_src_axi_aclk}]]
set dest_clk [get_clocks -of_objects [get_ports {fifo_rd_clk m_axis_aclk m_dest_axi_aclk}]]

set_property ASYNC_REG TRUE \
	[get_cells -hier cdc_sync_stage1_reg*] \
	[get_cells -hier cdc_sync_stage2_reg*]

#proc get_flops {name inst} {
#	return [get_cells -hier $name \
#			-filter [format {NAME =~ *%s* && PRIMITIVE_SUBGROUP == flop} $name]]
#}
#
#proc set_single_bit_cdc_constraints {name clk} {
#	set_false_path -from $clk -to [get_flops cdc_sync_stage1_reg* ${name}]
#}
#
#proc set_multi_bit_cdc_constraints {name clk} {
#	set_max_delay -from $clk -to [get_flops cdc_sync_stage1_reg* ${name}] \
#		[get_property PERIOD $clk] -datapath_only
#}
#
#proc set_fifo_cdc_constraints {name clk_a clk_b} {
#	set_multi_bit_cdc_constraints ${name}/i_waddr_sync $clk_a
#	set_multi_bit_cdc_constraints ${name}/i_raddr_sync $clk_b
#	set_max_delay -from [get_flops cdc_sync_fifo_ram_reg* ${name}] -to $clk_b [get_property PERIOD $clk_b] -datapath_only
#}

#set_multi_bit_constraints i_sync_src_request_id $req_clk
#set_multi_bit_constraints i_sync_dest_request_id $src_clk
#set_multi_bit_constraints i_sync_req_response_id $dest_clk

set_max_delay \
	-from $req_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_sync_src_request_id* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $req_clk] -datapath_only
set_max_delay \
	-from $src_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_sync_dest_request_id* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $src_clk] -datapath_only
set_max_delay \
	-from $dest_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_sync_req_response_id* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $dest_clk] -datapath_only

#set_single_bit_cdc_constraints i_sync_status_src $src_clk
#set_single_bit_cdc_constraints i_sync_control_src $req_clk
#set_single_bit_cdc_constraints i_sync_status_dest $dest_clk
#set_single_bit_cdc_constraints i_sync_control_dest $req_clk

set_false_path \
	-from $src_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_sync_status_src* && PRIMITIVE_SUBGROUP == flop}]
set_false_path \
	-from $req_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_sync_control_src* && PRIMITIVE_SUBGROUP == flop}]
set_false_path \
	-from $dest_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_sync_status_dest* && PRIMITIVE_SUBGROUP == flop}]
set_false_path \
	-from $req_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_sync_control_dest* && PRIMITIVE_SUBGROUP == flop}]

#set_fifo_cdc_constraints i_dest_req_fifo $req_clk $dest_clk
#set_fifo_cdc_constraints i_dest_response_fifo $dest_clk $req_clk
#set_fifo_cdc_constraints i_src_req_fifo $req_clk $src_clk
#set_fifo_cdc_constraints i_src_response_fifo $src_clk $req_clk

set_max_delay \
	-from $req_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_dest_req_fifo/i_waddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $req_clk] -datapath_only
set_max_delay \
	-from $dest_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_dest_req_fifo/i_raddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $dest_clk] -datapath_only
set_max_delay \
	-from [get_cells -hier cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_dest_req_fifo* && PRIMITIVE_SUBGROUP == flop}] \
	-to $dest_clk \
	[get_property PERIOD $dest_clk] -datapath_only

set_max_delay \
	-from $dest_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_dest_response_fifo/i_waddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $dest_clk] -datapath_only
set_max_delay \
	-from $req_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_dest_response_fifo/i_raddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $req_clk] -datapath_only
set_max_delay \
	-from [get_cells -hier cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_dest_response_fifo* && PRIMITIVE_SUBGROUP == flop}] \
	-to $req_clk \
	[get_property PERIOD $req_clk] -datapath_only

set_max_delay \
	-from $req_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_src_req_fifo/i_waddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $req_clk] -datapath_only
set_max_delay \
	-from $src_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_src_req_fifo/i_raddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $src_clk] -datapath_only
set_max_delay \
	-from [get_cells -hier cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_src_req_fifo* && PRIMITIVE_SUBGROUP == flop}] \
	-to $src_clk \
	[get_property PERIOD $src_clk] -datapath_only


#set_max_delay \
#	-from $src_clk \
#	-to [get_cells -hier cdc_sync_stage1_reg* \
#		-filter {NAME =~ *i_src_response_fifo/i_waddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
#	[get_property PERIOD $src_clk] -datapath_only
#set_max_delay \
#	-from $req_clk \
#	-to [get_cells -hier cdc_sync_stage1_reg* \
#		-filter {NAME =~ *i_src_response_fifo/i_raddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
#	[get_property PERIOD $req_clk] -datapath_only
#set_max_delay \
#	-from [get_cells -hier cdc_sync_fifo_ram_reg* \
#		-filter {NAME =~ *i_src_response_fifo* && PRIMITIVE_SUBGROUP == flop}] \
#	-to $req_clk \
#	[get_property PERIOD $req_clk] -datapath_only

#set_max_delay -from [get_flops eot_mem_reg* i_request_arb] -to $src_clk [get_property PERIOD $src_clk] -datapath_only
#set_max_delay -from [get_flops eot_mem_reg* i_request_arb] -to $dest_clk [get_property PERIOD $dest_clk] -datapath_only
set_max_delay \
	-from [get_cells -hier eot_mem_reg* \
		-filter {NAME =~ *i_request_arb* && PRIMITIVE_SUBGROUP == flop}] \
	-to $src_clk [get_property PERIOD $src_clk] -datapath_only
set_max_delay \
	-from [get_cells -hier eot_mem_reg* \
		-filter {NAME =~ *i_request_arb* && PRIMITIVE_SUBGROUP == flop}] \
	-to $dest_clk [get_property PERIOD $dest_clk] -datapath_only

#set_fifo_cdc_constraints i_fifo $src_clk $dest_clk
set_max_delay \
	-from $src_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_fifo/i_address_gray/i_waddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $src_clk] -datapath_only
set_max_delay \
	-from $dest_clk \
	-to [get_cells -hier cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_fifo/i_address_gray/i_raddr_sync* && PRIMITIVE_SUBGROUP == flop}] \
	[get_property PERIOD $dest_clk] -datapath_only

# Reset signals
set_false_path \
	-from $req_clk
	-to [get_pins -hier *resetn_shift_reg*/CLR]

# Not sure why, but it seems the built-in constraints for the RAM36B are wrong
set_max_delay \
	-from $dest_clk \
	-to [get_pins -hier ram_reg/REGCEB -filter {NAME =~ *i_fifo*}] \
	[get_property PERIOD $dest_clk] -datapath_only

# Ignore timing for debug signals to register map
set_false_path \
	-from [get_cells -hier cdc_sync_stage2_reg* \
		-filter {name =~ *i_sync_src_request_id* && primitive_subgroup == flop}] \
	-to [get_cells -hier up_rdata_reg* -filter {primitive_subgroup == flop}]
set_false_path \
	-from [get_cells -hier cdc_sync_stage2_reg* \
		-filter {name =~ *i_sync_dest_request_id* && primitive_subgroup == flop}] \
	-to [get_cells -hier up_rdata_reg* -filter {primitive_subgroup == flop}]
set_false_path \
	-from [get_cells -hier *id_reg* -filter {primitive_subgroup == flop}] \ 
	-to [get_cells -hier up_rdata_reg* -filter {primitive_subgroup == flop}]
