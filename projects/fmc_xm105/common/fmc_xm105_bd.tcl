###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#fmc_xm105

create_bd_port -dir I -from 32 -to 1 gp_in_0
create_bd_port -dir I -from 32 -to 1 gp_in_1
create_bd_port -dir I -from 32 -to 1 gp_in_2

create_bd_port -dir O -from 32 -to 1 gp_out_0
create_bd_port -dir O -from 32 -to 1 gp_out_1
create_bd_port -dir O -from 32 -to 1 gp_out_2

create_bd_port -dir O -from 32 -to 1 gp_t_0
create_bd_port -dir O -from 32 -to 1 gp_t_1
create_bd_port -dir O -from 32 -to 1 gp_t_2

create_bd_port -dir I clk0
create_bd_port -dir I clk1

#gpreg

ad_ip_instance axi_gpreg axi_gpreg
ad_ip_parameter axi_gpreg CONFIG.NUM_OF_IO 3
ad_ip_parameter axi_gpreg CONFIG.NUM_OF_CLK_MONS 4

ad_connect axi_gpreg/up_gp_ioenb_0 gp_t_0
ad_connect axi_gpreg/up_gp_ioenb_1 gp_t_1
ad_connect axi_gpreg/up_gp_ioenb_2 gp_t_2

ad_connect axi_gpreg/up_gp_in_0 gp_in_0
ad_connect axi_gpreg/up_gp_in_1 gp_in_1
ad_connect axi_gpreg/up_gp_in_2 gp_in_2

ad_connect axi_gpreg/up_gp_out_0 gp_out_0
ad_connect axi_gpreg/up_gp_out_1 gp_out_1
ad_connect axi_gpreg/up_gp_out_2 gp_out_2

ad_connect clk0 axi_gpreg/d_clk_0
ad_connect clk1 axi_gpreg/d_clk_1
#clock wizard

create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property -dict [list \
  CONFIG.PRIM_SOURCE {No_buffer} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {20} \
  CONFIG.USE_LOCKED {false} \
  CONFIG.USE_RESET {false} \
] [get_bd_cells clk_wiz_0]

ad_connect clk0 clk_wiz_0/clk_in1
ad_connect clk_wiz_0/clk_out1 axi_gpreg/d_clk_2

create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1
set_property -dict [list \
  CONFIG.PRIM_SOURCE {No_buffer} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {20} \
  CONFIG.USE_LOCKED {false} \
  CONFIG.USE_RESET {false} \
] [get_bd_cells clk_wiz_1]

ad_connect clk1 clk_wiz_1/clk_in1
ad_connect clk_wiz_1/clk_out1 axi_gpreg/d_clk_3

#interconnects

ad_cpu_interconnect 0x79020000 axi_gpreg

#ILA

set my_ila [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 my_ila]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $my_ila
set_property -dict [list CONFIG.C_NUM_OF_PROBES {9}] $my_ila
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $my_ila
set_property -dict [list CONFIG.C_DATA_DEPTH {4096}] $my_ila
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $my_ila
set_property -dict [list CONFIG.C_PROBE1_MU_CNT {2} ] $my_ila
set_property -dict [list CONFIG.C_PROBE0_MU_CNT {2} ] $my_ila
set_property -dict [list CONFIG.ALL_PROBE_SAME_MU_CNT {2}] $my_ila
set_property -dict [list CONFIG.C_PROBE0_WIDTH {32}] $my_ila
set_property -dict [list CONFIG.C_PROBE1_WIDTH {32}] $my_ila
set_property -dict [list CONFIG.C_PROBE2_WIDTH {32}] $my_ila
set_property -dict [list CONFIG.C_PROBE3_WIDTH {32}] $my_ila
set_property -dict [list CONFIG.C_PROBE4_WIDTH {32}] $my_ila
set_property -dict [list CONFIG.C_PROBE5_WIDTH {32}] $my_ila
set_property -dict [list CONFIG.C_PROBE6_WIDTH {32}] $my_ila
set_property -dict [list CONFIG.C_PROBE7_WIDTH {32}] $my_ila
set_property -dict [list CONFIG.C_PROBE8_WIDTH {32}] $my_ila

ad_connect my_ila/clk sys_cpu_clk
ad_connect my_ila/probe0 gp_in_0
ad_connect my_ila/probe1 gp_in_1
ad_connect my_ila/probe2 gp_in_2
ad_connect my_ila/probe3 gp_out_0
ad_connect my_ila/probe4 gp_out_1
ad_connect my_ila/probe5 gp_out_2
ad_connect my_ila/probe6 gp_t_0
ad_connect my_ila/probe7 gp_t_1
ad_connect my_ila/probe8 gp_t_2