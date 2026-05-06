###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Extra configurations for PCIE functionality
# ad_ip_parameter sys_ps8 CONFIG.PSU__NUM_FABRIC_RESETS {2}

# Create the XDMA IP
create_bd_cell -type ip -vlnv xilinx.com:ip:xdma pcie_xdma

# PCIe MGT interface (bundles all 8 TX/RX lane pairs)
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt

# CLK
create_bd_port -dir I pcie_ref_clk
create_bd_port -dir I pcie_ref_clk_div2

# RST
create_bd_port -dir I -type rst pcie_perstn

# Status
create_bd_port -dir O user_link_up

# XDMA configuration
ad_ip_parameter pcie_xdma CONFIG.pl_link_cap_max_link_speed {8.0_GT/s}
ad_ip_parameter pcie_xdma CONFIG.pl_link_cap_max_link_width {X8}
ad_ip_parameter pcie_xdma CONFIG.xdma_axi_intf_mm {AXI_Memory_Mapped}
ad_ip_parameter pcie_xdma CONFIG.axi_data_width {256_bit}
ad_ip_parameter pcie_xdma CONFIG.axisten_freq {250}
ad_ip_parameter pcie_xdma CONFIG.pf0_device_id {9038}
ad_ip_parameter pcie_xdma CONFIG.xdma_sts_ports {true}
ad_ip_parameter pcie_xdma CONFIG.pcie_blk_locn {X1Y0}
ad_ip_parameter pcie_xdma CONFIG.axilite_master_en {true}
ad_ip_parameter pcie_xdma CONFIG.pf0_msi_enabled {false}
ad_ip_parameter pcie_xdma CONFIG.pciebar2axibar_0 {0x0000000000000000}

# PCIe lane connections
connect_bd_intf_net [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins pcie_xdma/pcie_mgt]

# Clock and reset connections
ad_connect pcie_ref_clk pcie_xdma/sys_clk_gt
ad_connect pcie_ref_clk_div2 pcie_xdma/sys_clk
ad_connect pcie_perstn pcie_xdma/sys_rst_n

# Status
ad_connect user_link_up pcie_xdma/user_lnk_up

# XDMA AXI clock domain reset generator
ad_ip_instance proc_sys_reset pcie_axi_rstgen
ad_ip_parameter pcie_axi_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect pcie_axi_clk pcie_xdma/axi_aclk
ad_connect pcie_axi_clk pcie_axi_rstgen/slowest_sync_clk
ad_connect pcie_xdma/axi_aresetn pcie_axi_rstgen/ext_reset_in
ad_connect pcie_axi_resetn pcie_axi_rstgen/peripheral_aresetn
# Reset from software
# ad_connect sys_ps8/pl_resetn1 pcie_axi_rstgen/aux_reset_in

# Connect XDMA M_AXI (DMA engine) to PS DDR4 via S_AXI_HP3
ad_mem_hp3_interconnect pcie_axi_clk sys_ps8/S_AXI_HP3
ad_mem_hp3_interconnect pcie_axi_clk pcie_xdma/M_AXI

# Connect XDMA M_AXI_LITE (host bypass BAR) to HP3
ad_mem_hp3_interconnect pcie_axi_clk pcie_xdma/M_AXI_LITE

# Address mapping: XDMA masters can access PS DDR4 (0x0 - 0x7FFFFFFF)
assign_bd_address -target_address_space pcie_xdma/M_AXI \
    [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW]
assign_bd_address -target_address_space pcie_xdma/M_AXI_LITE \
    [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW]
