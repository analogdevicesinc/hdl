set up_clk [get_clocks -of_objects [get_ports s_axi_aclk]]
set delay_clk [get_clocks -of_objects [get_ports drp_clk]]

set_property ASYNC_REG TRUE \
  [get_cells -hier *up_drp_locked_m1_reg*] \
  [get_cells -hier *up_drp_locked_m2_reg*] \
  [get_cells -hier *up_drp_ack_t_m1_reg*] \
  [get_cells -hier *up_drp_ack_t_m2_reg*] \
  [get_cells -hier *drp_sel_t_m1_reg*] \
  [get_cells -hier *drp_sel_t_m2_reg*] \
  [get_cells -hier *drp_locked_m1_reg*] \
  [get_cells -hier *drp_locked_reg*]

set_false_path \
  -from [get_cells -hier up_drp_sel_t_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier drp_sel_t_m1_reg* -filter {primitive_subgroup == flop}]
set_max_delay -datapath_only \
  -from [get_cells -hier up_drp_rwn_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier drp_wr_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $delay_clk]
set_max_delay -datapath_only \
  -from [get_cells -hier up_drp_addr_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier drp_addr_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $delay_clk]
set_max_delay -datapath_only \
  -from [get_cells -hier up_drp_wdata_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier drp_wdata_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $delay_clk]
set_false_path \
  -from [get_cells -hier drp_locked_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier up_drp_locked_m1_reg* -filter {primitive_subgroup == flop}]
set_false_path \
  -from [get_cells -hier drp_ack_t_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier up_drp_ack_t_m1_reg* -filter {primitive_subgroup == flop}]
set_max_delay -datapath_only \
  -from [get_cells -hier drp_rdata_int_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier up_drp_rdata_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $up_clk]

set_max_delay -datapath_only \
  -from [get_cells -hier drp_rdata_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier drp_rdata_int_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $delay_clk]

set_false_path \
  -to [get_pins -hier */PRE -filter {NAME =~ *i_*rst_reg*}]
