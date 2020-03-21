#
# Timing constraints go here
#

create_clock -name refclk_q0_0         -period  4.00 [get_ports qmxfe_0_ref_clk_p[0]]
create_clock -name refclk_q0_1         -period  4.00 [get_ports qmxfe_0_ref_clk_p[1]]
create_clock -name refclk_q0_2         -period  4.00 [get_ports qmxfe_0_ref_clk_p[2]]
create_clock -name refclk_q0_3         -period  4.00 [get_ports qmxfe_0_ref_clk_p[3]]

create_clock -name refclk_q1_0         -period  4.00 [get_ports qmxfe_1_ref_clk_p[0]]
create_clock -name refclk_q1_1         -period  4.00 [get_ports qmxfe_1_ref_clk_p[1]]
create_clock -name refclk_q1_2         -period  4.00 [get_ports qmxfe_1_ref_clk_p[2]]
create_clock -name refclk_q1_3         -period  4.00 [get_ports qmxfe_1_ref_clk_p[3]]

create_clock -name refclk_q2_0         -period  4.00 [get_ports qmxfe_2_ref_clk_p[0]]
create_clock -name refclk_q2_1         -period  4.00 [get_ports qmxfe_2_ref_clk_p[1]]
create_clock -name refclk_q2_2         -period  4.00 [get_ports qmxfe_2_ref_clk_p[2]]
create_clock -name refclk_q2_3         -period  4.00 [get_ports qmxfe_2_ref_clk_p[3]]

create_clock -name refclk_q3_0         -period  4.00 [get_ports qmxfe_3_ref_clk_p[0]]
create_clock -name refclk_q3_1         -period  4.00 [get_ports qmxfe_3_ref_clk_p[1]]
create_clock -name refclk_q3_2         -period  4.00 [get_ports qmxfe_3_ref_clk_p[2]]
create_clock -name refclk_q3_3         -period  4.00 [get_ports qmxfe_3_ref_clk_p[3]]


create_clock -name device_clk     -period  4.00 [get_ports device_clk_p]
