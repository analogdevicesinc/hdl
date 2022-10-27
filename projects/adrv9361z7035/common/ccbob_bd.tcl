
# lbfmc

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# un-used io (gt)

ad_ip_instance axi_xcvrlb axi_pz_xcvrlb
ad_ip_parameter axi_pz_xcvrlb CONFIG.NUM_OF_LANES 4

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

create_bd_port -dir I -from 21 -to 0 gpio_p2_c1_i
create_bd_port -dir O -from 21 -to 0 gpio_p2_c1_o
create_bd_port -dir O -from 21 -to 0 gpio_p2_c1_t
create_bd_port -dir I -from 21 -to 0 gpio_p2_c2_i
create_bd_port -dir O -from 21 -to 0 gpio_p2_c2_o
create_bd_port -dir O -from 21 -to 0 gpio_p2_c2_t

create_bd_port -dir I -from 21 -to 0 gpio_p13_c1_i
create_bd_port -dir O -from 21 -to 0 gpio_p13_c1_o
create_bd_port -dir O -from 21 -to 0 gpio_p13_c1_t
create_bd_port -dir I -from 21 -to 0 gpio_p13_c2_i
create_bd_port -dir O -from 21 -to 0 gpio_p13_c2_o
create_bd_port -dir O -from 21 -to 0 gpio_p13_c2_t

create_bd_port -dir I -from 23 -to 0 gpio_p4_p5_c1_i
create_bd_port -dir O -from 23 -to 0 gpio_p4_p5_c1_o
create_bd_port -dir O -from 23 -to 0 gpio_p4_p5_c1_t
create_bd_port -dir I -from 23 -to 0 gpio_p4_p5_c2_i
create_bd_port -dir O -from 23 -to 0 gpio_p4_p5_c2_o
create_bd_port -dir O -from 23 -to 0 gpio_p4_p5_c2_t

create_bd_port -dir I -from 15 -to 0 gpio_p6_p7_c1_i
create_bd_port -dir O -from 15 -to 0 gpio_p6_p7_c1_o
create_bd_port -dir O -from 15 -to 0 gpio_p6_p7_c1_t
create_bd_port -dir I -from 17 -to 0 gpio_p6_p7_c2_i
create_bd_port -dir O -from 17 -to 0 gpio_p6_p7_c2_o
create_bd_port -dir O -from 17 -to 0 gpio_p6_p7_c2_t

ad_ip_instance axi_gpio gpio_p2
ad_ip_parameter gpio_p2 CONFIG.C_IS_DUAL 1
ad_ip_parameter gpio_p2 CONFIG.C_GPIO_WIDTH 22
ad_ip_parameter gpio_p2 CONFIG.C_GPIO2_WIDTH 22

ad_ip_instance axi_gpio gpio_p13
ad_ip_parameter gpio_p13 CONFIG.C_IS_DUAL 1
ad_ip_parameter gpio_p13 CONFIG.C_GPIO_WIDTH 22
ad_ip_parameter gpio_p13 CONFIG.C_GPIO2_WIDTH 22

ad_ip_instance axi_gpio gpio_p4_p5
ad_ip_parameter gpio_p4_p5 CONFIG.C_IS_DUAL 1
ad_ip_parameter gpio_p4_p5 CONFIG.C_GPIO_WIDTH 24
ad_ip_parameter gpio_p4_p5 CONFIG.C_GPIO2_WIDTH 24

ad_ip_instance axi_gpio gpio_p6_p7
ad_ip_parameter gpio_p6_p7 CONFIG.C_IS_DUAL 1
ad_ip_parameter gpio_p6_p7 CONFIG.C_GPIO_WIDTH 16
ad_ip_parameter gpio_p6_p7 CONFIG.C_GPIO2_WIDTH 18

ad_connect gpio_p2_c1_i gpio_p2/gpio_io_i
ad_connect gpio_p2_c1_o gpio_p2/gpio_io_o
ad_connect gpio_p2_c1_t gpio_p2/gpio_io_t
ad_connect gpio_p2_c2_i gpio_p2/gpio2_io_i
ad_connect gpio_p2_c2_o gpio_p2/gpio2_io_o
ad_connect gpio_p2_c2_t gpio_p2/gpio2_io_t

ad_connect gpio_p13_c1_i gpio_p13/gpio_io_i
ad_connect gpio_p13_c1_o gpio_p13/gpio_io_o
ad_connect gpio_p13_c1_t gpio_p13/gpio_io_t
ad_connect gpio_p13_c2_i gpio_p13/gpio2_io_i
ad_connect gpio_p13_c2_o gpio_p13/gpio2_io_o
ad_connect gpio_p13_c2_t gpio_p13/gpio2_io_t

ad_connect gpio_p4_p5_c1_i gpio_p4_p5/gpio_io_i
ad_connect gpio_p4_p5_c1_o gpio_p4_p5/gpio_io_o
ad_connect gpio_p4_p5_c1_t gpio_p4_p5/gpio_io_t
ad_connect gpio_p4_p5_c2_i gpio_p4_p5/gpio2_io_i
ad_connect gpio_p4_p5_c2_o gpio_p4_p5/gpio2_io_o
ad_connect gpio_p4_p5_c2_t gpio_p4_p5/gpio2_io_t

ad_connect gpio_p6_p7_c1_i gpio_p6_p7/gpio_io_i
ad_connect gpio_p6_p7_c1_o gpio_p6_p7/gpio_io_o
ad_connect gpio_p6_p7_c1_t gpio_p6_p7/gpio_io_t
ad_connect gpio_p6_p7_c2_i gpio_p6_p7/gpio2_io_i
ad_connect gpio_p6_p7_c2_o gpio_p6_p7/gpio2_io_o
ad_connect gpio_p6_p7_c2_t gpio_p6_p7/gpio2_io_t

ad_cpu_interconnect 0x412A0000 gpio_p2
ad_cpu_interconnect 0x412B0000 gpio_p13
ad_cpu_interconnect 0x412C0000 gpio_p4_p5
ad_cpu_interconnect 0x412D0000 gpio_p6_p7

#ad_ip_instance axi_gpreg axi_gpreg
#ad_ip_parameter axi_gpreg CONFIG.NUM_OF_CLK_MONS 0
#ad_ip_parameter axi_gpreg CONFIG.NUM_OF_IO 4

#create_bd_port -dir I -from 31 -to 0 gp_in_0
#create_bd_port -dir I -from 31 -to 0 gp_in_1
#create_bd_port -dir I -from 31 -to 0 gp_in_2
#create_bd_port -dir I -from 31 -to 0 gp_in_3
#create_bd_port -dir O -from 31 -to 0 gp_out_0
#create_bd_port -dir O -from 31 -to 0 gp_out_1
#create_bd_port -dir O -from 31 -to 0 gp_out_2
#create_bd_port -dir O -from 31 -to 0 gp_out_3

#ad_connect  gp_in_0 axi_gpreg/up_gp_in_0
#ad_connect  gp_in_1 axi_gpreg/up_gp_in_1
#ad_connect  gp_in_2 axi_gpreg/up_gp_in_2
#ad_connect  gp_in_3 axi_gpreg/up_gp_in_3
#ad_connect  gp_out_0 axi_gpreg/up_gp_out_0
#ad_connect  gp_out_1 axi_gpreg/up_gp_out_1
#ad_connect  gp_out_2 axi_gpreg/up_gp_out_2
#ad_connect  gp_out_3 axi_gpreg/up_gp_out_3
#ad_cpu_interconnect 0x41200000 axi_gpreg
