###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/vck190/vck190_system_bd.tcl

source $ad_hdl_dir/library/corundum/scripts/corundum_vck190_cfg.tcl

set ETH_LOOPBACK_ENABLE [expr {[info exists ad_project_params(LOOPBACK)] \
                               ? $ad_project_params(LOOPBACK) : 0}]

set PTP_CLK_PERIOD_NS_NUM   32
set PTP_CLK_PERIOD_NS_DENOM 5

source $ad_hdl_dir/library/corundum/scripts/corundum.tcl

create_bd_port -dir I gt_ref_clk_p
create_bd_port -dir I gt_ref_clk_n
ad_connect gt_ref_clk_p corundum_hierarchy/gt_ref_clk_p
ad_connect gt_ref_clk_n corundum_hierarchy/gt_ref_clk_n

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 qsfp_serial
ad_connect corundum_hierarchy/qsfp_serial qsfp_serial

create_bd_port -dir O mrmac_link_ready
ad_connect corundum_hierarchy/mrmac_link_ready mrmac_link_ready

create_bd_port -dir I mrmac_loopback_en
create_bd_port -dir I mrmac_loopback_mac_swap
ad_connect corundum_hierarchy/mrmac_loopback_en       mrmac_loopback_en
ad_connect corundum_hierarchy/mrmac_loopback_mac_swap mrmac_loopback_mac_swap

ad_ip_instance clk_wizard corundum_clkgen
ad_ip_parameter corundum_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY \
  {250.000,100.000,100.000,100.000,100.000,100.000,100.000}
ad_ip_parameter corundum_clkgen CONFIG.CLKOUT_USED \
  {true,false,false,false,false,false,false}
ad_ip_parameter corundum_clkgen CONFIG.PRIM_SOURCE {Global_buffer}
ad_ip_parameter corundum_clkgen CONFIG.USE_LOCKED true
ad_connect corundum_clkgen/clk_in1 sys_cpu_clk

ad_connect corundum_hierarchy/clk_corundum    corundum_clkgen/clk_out1
ad_connect corundum_hierarchy/gt_freerun_clk  sys_cpu_clk

ad_ip_instance clk_wizard corundum_mac_clkgen
ad_ip_parameter corundum_mac_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY \
  {390.625,100.000,100.000,100.000,100.000,100.000,100.000}
ad_ip_parameter corundum_mac_clkgen CONFIG.CLKOUT_USED \
  {true,false,false,false,false,false,false}
ad_ip_parameter corundum_mac_clkgen CONFIG.PRIM_SOURCE {Global_buffer}

ad_ip_instance clk_wizard corundum_mac_ts_clkgen
ad_ip_parameter corundum_mac_ts_clkgen CONFIG.PRIMITIVE_TYPE {PLL}
ad_ip_parameter corundum_mac_ts_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY \
  {250.000,100.000,100.000,100.000,100.000,100.000,100.000}
ad_ip_parameter corundum_mac_ts_clkgen CONFIG.CLKOUT_USED \
  {true,false,false,false,false,false,false}
ad_ip_parameter corundum_mac_ts_clkgen CONFIG.PRIM_SOURCE {Global_buffer}

ad_connect corundum_mac_clkgen/clk_in1    sys_cpu_clk
ad_connect corundum_mac_ts_clkgen/clk_in1 sys_cpu_clk
ad_connect corundum_hierarchy/mrmac_axis_clk corundum_mac_clkgen/clk_out1
ad_connect corundum_hierarchy/mrmac_ts_clk   corundum_mac_ts_clkgen/clk_out1

ad_connect corundum_hierarchy/ptp_clk corundum_hierarchy/ptp_refclk_bufg

ad_connect corundum_hierarchy/ptp_sample_clk sys_350m_clk

ad_connect corundum_hierarchy/mac_resetn sys_cpu_resetn

ad_ip_instance proc_sys_reset corundum_ptp_rstgen
ad_ip_parameter corundum_ptp_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_connect corundum_ptp_rstgen/slowest_sync_clk corundum_hierarchy/ptp_refclk_bufg
ad_connect corundum_ptp_rstgen/ext_reset_in     sys_cips/pl0_resetn
ad_connect corundum_hierarchy/ptp_rst corundum_ptp_rstgen/peripheral_reset

ad_connect corundum_rstgen/slowest_sync_clk corundum_clkgen/clk_out1
ad_connect corundum_rstgen/ext_reset_in     sys_cips/pl0_resetn
ad_connect corundum_rstgen/dcm_locked       corundum_clkgen/locked
ad_connect corundum_rstgen/aux_reset_in     GND

ad_cpu_interconnect 0x46000000 corundum_hierarchy s_axil_corundum
ad_cpu_interconnect 0x47000000 corundum_hierarchy s_axi_mac
ad_cpu_interconnect 0x48000000 corundum_hierarchy s_axi_gt

ad_ip_parameter axi_fpd_interconnect CONFIG.NUM_CLKS 2
ad_connect axi_fpd_interconnect/aclk1 corundum_clkgen/clk_out1

ad_mem_hp0_interconnect corundum_clkgen/clk_out1 corundum_hierarchy/m_axi

ad_cpu_interrupt "ps-5" "mb-5" corundum_hierarchy/irq
