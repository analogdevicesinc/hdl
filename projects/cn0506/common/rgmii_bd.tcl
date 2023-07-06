###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_port -dir I ref_clk_125
create_bd_port -dir O reset

create_bd_port -dir O -from 1 -to 0 -type data speed_mode_a
create_bd_port -dir O -from 1 -to 0 -type data speed_mode_b

ad_ip_instance gmii_to_rgmii gmii_to_rgmii_0
ad_ip_parameter gmii_to_rgmii_0 CONFIG.SupportLevel Include_Shared_Logic_in_Core

# 200MHz for 7 series; 375 for ultrascale
ad_ip_instance clk_wiz clk_wiz
ad_ip_parameter clk_wiz CONFIG.PRIM_IN_FREQ 125
ad_ip_parameter clk_wiz CONFIG.MMCM_CLKIN1_PERIOD 8.000
ad_ip_parameter clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 375
ad_ip_parameter clk_wiz CONFIG.PRIM_SOURCE "No_buffer"

make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_0/MDIO_PHY]
make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_0/RGMII]

ad_ip_instance proc_sys_reset proc_rgmii_reset

ad_connect gmii_to_rgmii_0/clkin clk_wiz/clk_out1

ad_connect ref_clk_125 clk_wiz/clk_in1
ad_connect sys_rstgen/peripheral_reset clk_wiz/reset
ad_connect proc_rgmii_reset/ext_reset_in sys_rstgen/peripheral_reset

ad_connect reset proc_rgmii_reset/peripheral_reset

ad_connect proc_rgmii_reset/dcm_locked clk_wiz/locked
ad_connect proc_rgmii_reset/slowest_sync_clk clk_wiz/clk_out1
ad_connect proc_rgmii_reset/peripheral_reset gmii_to_rgmii_0/tx_reset
ad_connect gmii_to_rgmii_0/rx_reset proc_rgmii_reset/peripheral_reset

make_bd_pins_external  [get_bd_pins gmii_to_rgmii_0/clock_speed]

ad_ip_instance gmii_to_rgmii gmii_to_rgmii_1
ad_ip_parameter gmii_to_rgmii_1 CONFIG.SupportLevel {Include_Shared_Logic_in_Example_Design}

make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_1/MDIO_PHY]
make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_1/RGMII]

ad_connect gmii_to_rgmii_1/ref_clk_in       gmii_to_rgmii_0/ref_clk_out
ad_connect gmii_to_rgmii_1/mmcm_locked_in   gmii_to_rgmii_0/mmcm_locked_out
ad_connect gmii_to_rgmii_1/gmii_clk_125m_in gmii_to_rgmii_0/gmii_clk_125m_out
ad_connect gmii_to_rgmii_1/gmii_clk_25m_in  gmii_to_rgmii_0/gmii_clk_25m_out
ad_connect gmii_to_rgmii_1/gmii_clk_2_5m_in gmii_to_rgmii_0/gmii_clk_2_5m_out

ad_connect proc_rgmii_reset/peripheral_reset gmii_to_rgmii_1/tx_reset
ad_connect gmii_to_rgmii_1/rx_reset proc_rgmii_reset/peripheral_reset

ad_connect gmii_to_rgmii_0/speed_mode speed_mode_a
ad_connect gmii_to_rgmii_1/speed_mode speed_mode_b
