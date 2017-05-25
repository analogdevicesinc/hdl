
# lbfmc

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# un-used io (regular)

ad_ip_instance axi_gpreg axi_gpreg
ad_ip_parameter axi_gpreg CONFIG.NUM_OF_CLK_MONS 0
ad_ip_parameter axi_gpreg CONFIG.NUM_OF_IO 1

create_bd_port -dir I -from 31 -to 0 gp_in_0
create_bd_port -dir O -from 31 -to 0 gp_out_0

ad_connect  gp_in_0 axi_gpreg/up_gp_in_0
ad_connect  gp_out_0 axi_gpreg/up_gp_out_0
ad_cpu_interconnect 0x41200000 axi_gpreg

