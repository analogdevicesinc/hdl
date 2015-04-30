set up_clk [get_clocks -of_objects [get_ports s_axi_aclk]]
set master_clk [get_clocks -of_objects [get_ports m_axi_aclk]]
set delay_clk [get_clocks -of_objects [get_ports drp_clk]]

set_property ASYNC_REG TRUE \
  [get_cells -hier *toggle_m1_reg*] \
  [get_cells -hier *toggle_m2_reg*] \
  [get_cells -hier *state_m1_reg*] \
  [get_cells -hier *state_m2_reg*] \
  [get_cells -hier *axi_req_toggle_m1_reg*] \
  [get_cells -hier *axi_req_toggle_m2_reg*] \
  [get_cells -hier *es_dma_ack_toggle_m1_reg*] \
  [get_cells -hier *es_dma_ack_toggle_m2_reg*] \
  [get_cells -hier *rx_sysref_m1_reg*] \
  [get_cells -hier *rx_sysref_m2_reg*] \
  [get_cells -hier *tx_sysref_m1_reg*] \
  [get_cells -hier *tx_sysref_m2_reg*] \
  [get_cells -hier *rx_sync_m1_reg*] \
  [get_cells -hier *rx_sync_m2_reg*] \
  [get_cells -hier *tx_ip_sync_m1_reg*] \
  [get_cells -hier *tx_ip_sync_m2_reg*] \
  [get_cells -hier *up_rx_status_m1_reg*] \
  [get_cells -hier *up_tx_status_m1_reg*] \
  [get_cells -hier *up_rx_rst_done_m1_reg*] \
  [get_cells -hier *up_tx_rst_done_m1_reg*]

set_false_path \
  -from [get_cells -hier es_dma_req_toggle_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier axi_req_toggle_m1_reg* -filter {primitive_subgroup == flop}]
set_false_path \
  -from [get_cells -hier axi_ack_toggle_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier es_dma_ack_toggle_m1_reg* -filter {primitive_subgroup == flop}]
set_max_delay -datapath_only \
  -from [get_cells -hier es_dma_data_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier axi_wdata_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $master_clk]
set_max_delay -datapath_only \
  -from [get_cells -hier es_dma_addr_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier axi_awaddr_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $master_clk]

set_false_path \
  -from [get_cells -hier up_rx_sysref_sel_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier rx_sysref_m1_reg* -filter {primitive_subgroup == flop}]
set_false_path \
  -from [get_cells -hier up_rx_sysref_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier rx_sysref_m1_reg* -filter {primitive_subgroup == flop}]
#set_false_path \
#  -from [get_cells -hier tx_sysref_reg* -filter {primitive_subgroup == flop}] \
#  -to [get_cells -hier tx_sysref_m1_reg* -filter {primitive_subgroup == flop}]
set_false_path \
  -from [get_cells -hier up_rx_sync_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier rx_sync_m1_reg* -filter {primitive_subgroup == flop}]
set_false_path \
  -from [get_cells -hier rx_sync_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier up_rx_status_m1_reg* -filter {primitive_subgroup == flop}]

set_false_path \
  -from [get_cells -hier up_xfer_toggle_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier d_xfer_toggle_m1_reg* -filter {primitive_subgroup == flop}]
set_false_path \
  -from [get_cells -hier d_xfer_toggle_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier up_xfer_state_m1_reg* -filter {primitive_subgroup == flop}]
set_max_delay -datapath_only \
  -from [get_cells -hier up_xfer_data_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier d_data_cntrl_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $delay_clk]

set_false_path \
  -from [get_cells -hier d_xfer_toggle_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier up_xfer_toggle_m1_reg* -filter {primitive_subgroup == flop}]
set_false_path \
  -from [get_cells -hier up_xfer_toggle_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier d_xfer_state_m1_reg* -filter {primitive_subgroup == flop}]
set_max_delay -datapath_only \
  -from [get_cells -hier d_xfer_data_reg* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier up_data_status_reg* -filter {primitive_subgroup == flop}] \
  [get_property PERIOD $up_clk]

set_false_path \
  -from [get_pins -hier *RXUSRCLK2* ] \
  -to [get_pins -hier up_rx_rst_done_m1_reg*/D ]

set_false_path \
  -from [get_pins -hier *TXUSRCLK2* ] \
  -to [get_pins -hier up_tx_rst_done_m1_reg*/D ]

set_false_path \
  -to [get_pins -hier */PRE -filter {NAME =~ *i_*rst_reg*}]
