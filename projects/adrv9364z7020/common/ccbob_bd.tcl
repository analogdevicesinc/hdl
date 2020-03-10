
# lbfmc

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# un-used io (regular)

ad_ip_instance axi_gpio gpio_0
ad_ip_parameter gpio_0 CONFIG.C_IS_DUAL 1
ad_ip_parameter gpio_0 CONFIG.C_GPIO_WIDTH 26
ad_ip_parameter gpio_0 CONFIG.C_GPIO2_WIDTH 28

create_bd_port -dir I -from 25 -to 0 gpio_0_c1_i
create_bd_port -dir O -from 25 -to 0 gpio_0_c1_o
create_bd_port -dir O -from 25 -to 0 gpio_0_c1_t
create_bd_port -dir I -from 27 -to 0 gpio_0_c2_i
create_bd_port -dir O -from 27 -to 0 gpio_0_c2_o
create_bd_port -dir O -from 27 -to 0 gpio_0_c2_t

ad_connect gpio_0_c1_i gpio_0/gpio_io_i
ad_connect gpio_0_c1_o gpio_0/gpio_io_o
ad_connect gpio_0_c1_t gpio_0/gpio_io_t
ad_connect gpio_0_c2_i gpio_0/gpio2_io_i
ad_connect gpio_0_c2_o gpio_0/gpio2_io_o
ad_connect gpio_0_c2_t gpio_0/gpio2_io_t

ad_cpu_interconnect 0x41200000 gpio_0
