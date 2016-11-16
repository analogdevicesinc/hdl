
source ../common/pzsdr2_bd.tcl
source ../common/ccpci_bd.tcl

## core digital interface -- cmos (1) or lvds (0)

set_property CONFIG.CMOS_OR_LVDS_N 0 [get_bd_cells axi_ad9361]

create_bd_port -dir I rx_clk_in_p
create_bd_port -dir I rx_clk_in_n
create_bd_port -dir I rx_frame_in_p
create_bd_port -dir I rx_frame_in_n
create_bd_port -dir I -from 5 -to 0 rx_data_in_p
create_bd_port -dir I -from 5 -to 0 rx_data_in_n

create_bd_port -dir O tx_clk_out_p
create_bd_port -dir O tx_clk_out_n
create_bd_port -dir O tx_frame_out_p
create_bd_port -dir O tx_frame_out_n
create_bd_port -dir O -from 5 -to 0 tx_data_out_p
create_bd_port -dir O -from 5 -to 0 tx_data_out_n

ad_connect  rx_clk_in_p axi_ad9361/rx_clk_in_p
ad_connect  rx_clk_in_n axi_ad9361/rx_clk_in_n
ad_connect  rx_frame_in_p axi_ad9361/rx_frame_in_p
ad_connect  rx_frame_in_n axi_ad9361/rx_frame_in_n
ad_connect  rx_data_in_p axi_ad9361/rx_data_in_p
ad_connect  rx_data_in_n axi_ad9361/rx_data_in_n
ad_connect  tx_clk_out_p axi_ad9361/tx_clk_out_p
ad_connect  tx_clk_out_n axi_ad9361/tx_clk_out_n
ad_connect  tx_frame_out_p axi_ad9361/tx_frame_out_p
ad_connect  tx_frame_out_n axi_ad9361/tx_frame_out_n
ad_connect  tx_data_out_p axi_ad9361/tx_data_out_p
ad_connect  tx_data_out_n axi_ad9361/tx_data_out_n


