
# lbfmc

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# un-used io

set axi_gpreg [create_bd_cell -type ip -vlnv analog.com:user:axi_gpreg:1.0 axi_gpreg]
set_property -dict [list CONFIG.NUM_OF_CLK_MONS {0}] $axi_gpreg
set_property -dict [list CONFIG.NUM_OF_IO {2}] $axi_gpreg

ad_cpu_interconnect 0x41200000 axi_gpreg

create_bd_port -dir I -from 31 -to 0 gp_in_0
create_bd_port -dir I -from 31 -to 0 gp_in_1
create_bd_port -dir O -from 31 -to 0 gp_out_0
create_bd_port -dir O -from 31 -to 0 gp_out_1

ad_connect  gp_in_0 axi_gpreg/up_gp_in_0
ad_connect  gp_in_1 axi_gpreg/up_gp_in_1
ad_connect  gp_out_0 axi_gpreg/up_gp_out_0
ad_connect  gp_out_1 axi_gpreg/up_gp_out_1

## temporary (remove ila indirectly)

delete_bd_objs [get_bd_cells ila_adc]
delete_bd_objs [get_bd_nets axi_ad9361_tdd_dbg] [get_bd_cells ila_tdd]

