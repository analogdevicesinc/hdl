
# lbfmc

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# un-used io (regular)

ad_ip_instance axi_gpreg axi_gpreg
ad_ip_parameter axi_gpreg CONFIG.NUM_OF_CLK_MONS 0
ad_ip_parameter axi_gpreg CONFIG.NUM_OF_IO 1

ad_ip_instance axi_clock_monitor clk_monitor_0
ad_ip_parameter clk_monitor_0 CONFIG.NUM_OF_CLOCKS 2

create_bd_port -dir I -from 25 -to 0 gpio_0_c1_i
create_bd_port -dir O -from 25 -to 0 gpio_0_c1_o
create_bd_port -dir O -from 25 -to 0 gpio_0_c1_t
create_bd_port -dir I -from 27 -to 0 gpio_0_c2_i
create_bd_port -dir O -from 27 -to 0 gpio_0_c2_o
create_bd_port -dir O -from 27 -to 0 gpio_0_c2_t
create_bd_port -dir I clkout_in_s

ad_connect clkout_in_s clk_monitor_0/clock_0
ad_connect sys_cpu_clk clk_monitor_0/clock_1
ad_connect gpio_0_c1_i gpio_0/gpio_io_i
ad_connect gpio_0_c1_o gpio_0/gpio_io_o
ad_connect gpio_0_c1_t gpio_0/gpio_io_t
ad_connect gpio_0_c2_i gpio_0/gpio2_io_i
ad_connect gpio_0_c2_o gpio_0/gpio2_io_o
ad_connect gpio_0_c2_t gpio_0/gpio2_io_t

ad_cpu_interconnect 0x41200000 gpio_0
ad_cpu_interconnect 0x41620000 clk_monitor_0
