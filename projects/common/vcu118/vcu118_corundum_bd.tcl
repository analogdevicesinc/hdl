###############################################################################
## Copyright (C) 2019-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/corundum/scripts/corundum.tcl

ad_ip_parameter axi_dp_interconnect CONFIG.NUM_CLKS 3
ad_connect axi_dp_interconnect/aclk2 sys_250m_clk

ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT4_FREQ_HZ 125

ad_connect corundum_rstgen/slowest_sync_clk sys_250m_clk
ad_connect corundum_rstgen/ext_reset_in axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst

create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qsfp_rtl:1.0 qsfp

create_bd_port -dir O -from 0 -to 0 -type rst qsfp_rst
create_bd_port -dir I -type rst ptp_rst
set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports ptp_rst]
create_bd_port -dir I -type clk qsfp_mgt_refclk
create_bd_port -dir I -type clk qsfp_mgt_refclk_bufg

ad_connect sys_cpu_clk corundum_hierarchy/clk_125mhz
ad_connect sys_250m_clk corundum_hierarchy/clk_corundum

ad_connect sys_cpu_reset corundum_hierarchy/rst_125mhz

ad_connect corundum_hierarchy/qsfp qsfp
ad_connect corundum_hierarchy/qsfp_rst qsfp_rst
ad_connect corundum_hierarchy/ptp_rst ptp_rst
ad_connect corundum_hierarchy/qsfp_mgt_refclk qsfp_mgt_refclk
ad_connect corundum_hierarchy/qsfp_mgt_refclk_bufg qsfp_mgt_refclk_bufg

ad_cpu_interconnect 0x50000000 corundum_hierarchy s_axil_corundum
ad_cpu_interconnect 0x52000000 corundum_gpio_reset

ad_mem_hp1_interconnect sys_250m_clk corundum_hierarchy/m_axi

ad_cpu_interrupt "ps-5" "mb-5" corundum_hierarchy/irq
