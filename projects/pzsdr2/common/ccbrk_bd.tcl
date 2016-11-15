
# lbfmc

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# un-used io (gt)

set axi_pz_xcvrlb [create_bd_cell -type ip -vlnv analog.com:user:axi_xcvrlb:1.0 axi_pz_xcvrlb]
set_property -dict [list CONFIG.NUM_OF_LANES {4}] $axi_pz_xcvrlb

create_bd_port -dir I gt_ref_clk
create_bd_port -dir I -from 3 -to 0 gt_rx_p
create_bd_port -dir I -from 3 -to 0 gt_rx_n
create_bd_port -dir O -from 3 -to 0 gt_tx_p
create_bd_port -dir O -from 3 -to 0 gt_tx_n

ad_cpu_interconnect 0x44A60000 axi_pz_xcvrlb
ad_connect  axi_pz_xcvrlb/ref_clk gt_ref_clk
ad_connect  axi_pz_xcvrlb/rx_p gt_rx_p
ad_connect  axi_pz_xcvrlb/rx_n gt_rx_n
ad_connect  axi_pz_xcvrlb/tx_p gt_tx_p
ad_connect  axi_pz_xcvrlb/tx_n gt_tx_n

# un-used io (regular)

set axi_gpreg [create_bd_cell -type ip -vlnv analog.com:user:axi_gpreg:1.0 axi_gpreg]
set_property -dict [list CONFIG.NUM_OF_CLK_MONS {0}] $axi_gpreg
set_property -dict [list CONFIG.NUM_OF_IO {4}] $axi_gpreg

create_bd_port -dir I -from 31 -to 0 gp_in_0
create_bd_port -dir I -from 31 -to 0 gp_in_1
create_bd_port -dir I -from 31 -to 0 gp_in_2
create_bd_port -dir I -from 31 -to 0 gp_in_3
create_bd_port -dir O -from 31 -to 0 gp_out_0
create_bd_port -dir O -from 31 -to 0 gp_out_1
create_bd_port -dir O -from 31 -to 0 gp_out_2
create_bd_port -dir O -from 31 -to 0 gp_out_3

ad_connect  gp_in_0 axi_gpreg/up_gp_in_0
ad_connect  gp_in_1 axi_gpreg/up_gp_in_1
ad_connect  gp_in_2 axi_gpreg/up_gp_in_2
ad_connect  gp_in_3 axi_gpreg/up_gp_in_3
ad_connect  gp_out_0 axi_gpreg/up_gp_out_0
ad_connect  gp_out_1 axi_gpreg/up_gp_out_1
ad_connect  gp_out_2 axi_gpreg/up_gp_out_2
ad_connect  gp_out_3 axi_gpreg/up_gp_out_3
ad_cpu_interconnect 0x41200000 axi_gpreg

