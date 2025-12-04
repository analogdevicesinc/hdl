###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Corundum NIC
create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qsfp_rtl:1.0 qsfp
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 aux_reset_inv

set_property -dict [list \
  CONFIG.C_OPERATION {not} \
  CONFIG.C_SIZE {1} \
] [get_bd_cells aux_reset_inv]

create_bd_port -dir O -from 0 -to 0 -type rst qsfp_rst
create_bd_port -dir I qsfp_mgt_refclk_p
create_bd_port -dir I qsfp_mgt_refclk_n

create_bd_port -dir O -from 3 -to 0 qsfp_led

# Extra configurations for Corundum functionality
ad_ip_parameter sys_ps8 CONFIG.PSU__NUM_FABRIC_RESETS {2}
set_property -dict [list CONFIG.PSU__GPIO_EMIO_WIDTH {95}] [get_bd_cells sys_ps8]

# Corundum connections
connect_bd_net [get_bd_ports qsfp_led] [get_bd_pins corundum_hierarchy/ethernet_core/qsfp_led]

# All Corundum related IPs are connected to the same clock source
# sys_ps8/pl_clk1

ad_connect corundum_hierarchy/clk_corundum sys_ps8/pl_clk1

ad_connect corundum_hierarchy/qsfp qsfp
ad_connect corundum_hierarchy/qsfp_rst qsfp_rst
ad_connect corundum_hierarchy/qsfp_mgt_refclk_p qsfp_mgt_refclk_p
ad_connect corundum_hierarchy/qsfp_mgt_refclk_n qsfp_mgt_refclk_n

ad_ip_instance axi_interconnect smartconnect_corundum
ad_ip_parameter smartconnect_corundum CONFIG.NUM_MI 2
ad_ip_parameter smartconnect_corundum CONFIG.NUM_SI 1

# Regarding the resets, the Corundum Reset Generator (Proc. System Rst. IP)
# is driven by two PS resets: pl_resetn0 (the general reset used to reset
# the whole System) and pl_resetn1 (which is the reset used only for the
# Corundum IPs, which is controlled from software).
# The Corundum Reset Generator (corundum_rstgen) is used to reset the other
# Corundum IPs (smartconnect_corundum and corundum_hierarchy).

ad_connect corundum_rstgen/slowest_sync_clk sys_ps8/pl_clk1
ad_connect corundum_rstgen/ext_reset_in sys_ps8/pl_resetn0

# Invert the pl_resetn1 before connecting to the corundum_rstgen/aux_reset_in of
# corundum_rstgen because it's driven HIGH.
ad_connect sys_ps8/pl_resetn1 aux_reset_inv/Op1
ad_connect aux_reset_inv/Res corundum_rstgen/aux_reset_in

ad_connect smartconnect_corundum/ARESETN corundum_rstgen/interconnect_aresetn
ad_connect smartconnect_corundum/S00_ARESETN corundum_rstgen/interconnect_aresetn
ad_connect smartconnect_corundum/M00_ARESETN corundum_rstgen/interconnect_aresetn
ad_connect smartconnect_corundum/M01_ARESETN corundum_rstgen/interconnect_aresetn

ad_connect smartconnect_corundum/ACLK sys_ps8/pl_clk1
ad_connect smartconnect_corundum/S00_ACLK sys_ps8/pl_clk1
ad_connect smartconnect_corundum/M00_ACLK sys_ps8/pl_clk1
ad_connect smartconnect_corundum/M01_ACLK sys_ps8/pl_clk1

ad_connect smartconnect_corundum/M00_AXI corundum_hierarchy/s_axil_corundum

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 1
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP0__DATA_WIDTH 32
ad_connect smartconnect_corundum/S00_AXI sys_ps8/M_AXI_HPM0_FPD
ad_connect sys_ps8/maxihpm0_fpd_aclk sys_200m_clk

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP5 1
ad_connect sys_200m_clk sys_ps8/saxihp3_fpd_aclk

assign_bd_address -offset 0xA000_0000 [get_bd_addr_segs \
  corundum_hierarchy/corundum_core/s_axil_ctrl/Reg
] -target_address_space sys_ps8/Data

ad_ip_instance util_reduced_logic util_reduced_logic_0
ad_ip_parameter util_reduced_logic_0 CONFIG.C_OPERATION {or}
ad_ip_parameter util_reduced_logic_0 CONFIG.C_SIZE $IRQ_COUNT

ad_connect util_reduced_logic_0/Op1 corundum_hierarchy/irq

ad_cpu_interrupt ps-4 mb-4 util_reduced_logic_0/Res

ad_mem_hpc0_interconnect sys_200m_clk corundum_hierarchy/m_axi

assign_bd_address [get_bd_addr_segs { \
  sys_ps8/SAXIGP0/HPC0_LPS_OCM \
  sys_ps8/SAXIGP0/HPC0_QSPI \
  sys_ps8/SAXIGP0/HPC0_DDR_LOW \
  sys_ps8/SAXIGP0/HPC0_DDR_HIGH \
}]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_port

ad_ip_instance axi_iic axi_iic
ad_connect iic_port axi_iic/iic

ad_cpu_interconnect 0x43000000 axi_iic

ad_cpu_interrupt ps-5  mb-14  axi_iic/iic2intc_irpt
