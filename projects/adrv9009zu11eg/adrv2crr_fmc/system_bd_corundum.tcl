###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Corundum NIC
create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qsfp_rtl:1.0 qsfp

create_bd_port -dir O -from 0 -to 0 -type rst qsfp_rst
create_bd_port -dir I qsfp_mgt_refclk_p
create_bd_port -dir I qsfp_mgt_refclk_n

create_bd_port -dir O -from 3 -to 0 qsfp_led

# collect build information
set build_date [clock seconds]
set git_hash 00000000
catch {
  set git_hash [exec git rev-parse --short=8 HEAD]
}
set tag_ver 0.0.0

# FW and board IDs
set fpga_id [expr 0x4738093]
set fw_id [expr 0x00000000]
set fw_ver $tag_ver
set board_vendor_id [expr 0x10ee]
set board_device_id [expr 0x9066]
set board_ver 1.0
set release_info [expr 0x00000000]

# General variables
set IRQ_SIZE 8
set PORTS_PER_IF "1"
set TX_QUEUE_INDEX_WIDTH "11"
set RX_QUEUE_INDEX_WIDTH "8"
set CQN_WIDTH [expr max($TX_QUEUE_INDEX_WIDTH, $RX_QUEUE_INDEX_WIDTH) + 1]
set TX_QUEUE_PIPELINE [expr 3 + max($TX_QUEUE_INDEX_WIDTH - 12, 0)]
set RX_QUEUE_PIPELINE [expr 3 + max($RX_QUEUE_INDEX_WIDTH - 12, 0)]
set TX_DESC_TABLE_SIZE "32"
set RX_DESC_TABLE_SIZE "32"
set TX_RAM_SIZE "32768"
set RX_RAM_SIZE "32768"

connect_bd_net [get_bd_ports qsfp_led] [get_bd_pins corundum_hierarchy/ethernet_core/qsfp_led]

ad_connect corundum_hierarchy/clk_corundum sys_ps8/pl_clk1

# Use Utility Logic Vector IP which takes sys_ps8/pl_resetn1 and negates it and connects
# it to corundum_hierarchy/rstn_corundum
ad_ip_instance util_vector_logic util_vector_logic_0
ad_ip_parameter util_vector_logic_0 CONFIG.C_OPERATION {not}
ad_ip_parameter util_vector_logic_0 CONFIG.C_SIZE 1

ad_connect corundum_hierarchy/rstn_corundum util_vector_logic_0/Res

ad_connect corundum_hierarchy/qsfp qsfp
ad_connect corundum_hierarchy/qsfp_rst qsfp_rst
ad_connect corundum_hierarchy/qsfp_mgt_refclk_p qsfp_mgt_refclk_p
ad_connect corundum_hierarchy/qsfp_mgt_refclk_n qsfp_mgt_refclk_n

ad_ip_instance axi_interconnect smartconnect_corundum
ad_ip_parameter smartconnect_corundum CONFIG.NUM_MI 2
ad_ip_parameter smartconnect_corundum CONFIG.NUM_SI 1

ad_connect smartconnect_corundum/ARESETN sys_ps8/pl_resetn1
ad_connect smartconnect_corundum/S00_ARESETN sys_ps8/pl_resetn1
ad_connect smartconnect_corundum/M00_ARESETN sys_ps8/pl_resetn1
ad_connect smartconnect_corundum/M01_ARESETN sys_ps8/pl_resetn1

ad_connect smartconnect_corundum/ACLK sys_ps8/pl_clk1
ad_connect smartconnect_corundum/S00_ACLK sys_ps8/pl_clk1
ad_connect smartconnect_corundum/M00_ACLK sys_ps8/pl_clk1
ad_connect smartconnect_corundum/M01_ACLK sys_ps8/pl_clk1

ad_connect smartconnect_corundum/M00_AXI corundum_hierarchy/s_axil_corundum

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 1
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP0__DATA_WIDTH 32
ad_connect smartconnect_corundum/S00_AXI sys_ps8/M_AXI_HPM0_FPD
ad_connect sys_ps8/maxihpm0_fpd_aclk sys_200m_clk

ad_connect corundum_rstgen/slowest_sync_clk sys_200m_clk
ad_connect corundum_rstgen/ext_reset_in sys_ps8/pl_resetn0
ad_connect corundum_rstgen/peripheral_aresetn corundum_rstn

# not sure to add them or not
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP5 1
ad_connect sys_200m_clk sys_ps8/saxihp3_fpd_aclk

assign_bd_address -offset 0xA000_0000 [get_bd_addr_segs \
  corundum_hierarchy/corundum_core/s_axil_ctrl/Reg
] -target_address_space sys_ps8/Data

ad_ip_instance util_reduced_logic util_reduced_logic_0
ad_ip_parameter util_reduced_logic_0 CONFIG.C_OPERATION {or}
ad_ip_parameter util_reduced_logic_0 CONFIG.C_SIZE $IRQ_SIZE

ad_connect util_reduced_logic_0/Op1 corundum_hierarchy/irq

ad_cpu_interrupt ps-4 mb-4 util_reduced_logic_0/Res

# ad_mem_hpc0_interconnect sys_dma_clk sys_ps8/S_AXI_HPC0_FPD
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