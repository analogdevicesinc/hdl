
source $ad_hdl_dir/projects/common/pzsdr/pzsdr_system_bd.tcl
source ../common/ccbrk_bd.tcl

# CMOS Mode 

delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports tx_clk_out_p]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports tx_clk_out_n]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports tx_frame_out_p]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports tx_frame_out_n]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports tx_data_out_p]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports tx_data_out_n]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports rx_clk_in_p]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports rx_clk_in_n]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports rx_frame_in_p]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports rx_frame_in_n]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports rx_data_in_p]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports rx_data_in_n]]]

delete_bd_objs [get_bd_ports tx_clk_out_p]
delete_bd_objs [get_bd_ports tx_clk_out_n]
delete_bd_objs [get_bd_ports tx_frame_out_p]
delete_bd_objs [get_bd_ports tx_frame_out_n]
delete_bd_objs [get_bd_ports tx_data_out_p]
delete_bd_objs [get_bd_ports tx_data_out_n]
delete_bd_objs [get_bd_ports rx_clk_in_p]
delete_bd_objs [get_bd_ports rx_clk_in_n]
delete_bd_objs [get_bd_ports rx_frame_in_p]
delete_bd_objs [get_bd_ports rx_frame_in_n]
delete_bd_objs [get_bd_ports rx_data_in_p]
delete_bd_objs [get_bd_ports rx_data_in_n]

create_bd_port -dir I rx_clk_in
create_bd_port -dir I rx_frame_in
create_bd_port -dir I -from 11 -to 0 rx_data_in
create_bd_port -dir O tx_clk_out
create_bd_port -dir O tx_frame_out
create_bd_port -dir O -from 11 -to 0 tx_data_out

set_property CONFIG.CMOS_OR_LVDS_N 1 [get_bd_cells axi_ad9361]

ad_connect  rx_clk_in axi_ad9361/rx_clk_in
ad_connect  rx_frame_in axi_ad9361/rx_frame_in
ad_connect  rx_data_in axi_ad9361/rx_data_in
ad_connect  tx_clk_out axi_ad9361/tx_clk_out
ad_connect  tx_frame_out axi_ad9361/tx_frame_out
ad_connect  tx_data_out axi_ad9361/tx_data_out

