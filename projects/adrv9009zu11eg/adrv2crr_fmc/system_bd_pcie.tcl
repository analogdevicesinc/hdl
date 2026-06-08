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

# AXI FIFO Generator — full AXI4 (256-bit, for M_AXI DMA engine port)
# Async CDC: XDMA axi_aclk (250 MHz) → sys_dma_clk (~333 MHz)
# Deep data FIFOs (512) to absorb DDR4 refresh pauses
create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator pcie_fifo_mm
set_property -dict [list \
  CONFIG.INTERFACE_TYPE {AXI_MEMORY_MAPPED} \
  CONFIG.Clock_Type_AXI {Independent_Clock} \
  CONFIG.DATA_WIDTH {256} \
  CONFIG.Input_Depth_wach {16} \
  CONFIG.Input_Depth_wdch {512} \
  CONFIG.Input_Depth_wrch {16} \
  CONFIG.Input_Depth_rach {16} \
  CONFIG.Input_Depth_rdch {512} \
] [get_bd_cells pcie_fifo_mm]

# AXI FIFO Generator — AXI4-Lite (32-bit, for M_AXI_LITE bypass port)
create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator pcie_fifo_lite
set_property -dict [list \
  CONFIG.INTERFACE_TYPE {AXI_MEMORY_MAPPED} \
  CONFIG.PROTOCOL {AXI4_Lite} \
  CONFIG.Clock_Type_AXI {Independent_Clock} \
  CONFIG.DATA_WIDTH {32} \
  CONFIG.Input_Depth_wach {16} \
  CONFIG.Input_Depth_wdch {512} \
  CONFIG.Input_Depth_wrch {16} \
  CONFIG.Input_Depth_rach {16} \
  CONFIG.Input_Depth_rdch {512} \
] [get_bd_cells pcie_fifo_lite]

# FIFO slave side: XDMA clock domain (250 MHz)
ad_connect pcie_xdma/M_AXI pcie_fifo_mm/S_AXI
ad_connect pcie_axi_clk pcie_fifo_mm/s_aclk
ad_connect pcie_axi_resetn pcie_fifo_mm/s_aresetn

ad_connect pcie_xdma/M_AXI_LITE pcie_fifo_lite/S_AXI
ad_connect pcie_axi_clk pcie_fifo_lite/s_aclk
ad_connect pcie_axi_resetn pcie_fifo_lite/s_aresetn

# FIFO master side: sys_dma_clk domain (~333 MHz)
# Note: AXI FIFO Generator has only s_aresetn — no m_aresetn pin.
# The IP internally synchronizes the reset to the master clock domain.
ad_connect sys_dma_clk pcie_fifo_mm/m_aclk
ad_connect sys_dma_clk pcie_fifo_lite/m_aclk

# Connect FIFO master ports to PS DDR4 via S_AXI_HP3 SmartConnect (333 MHz)
ad_mem_hp3_interconnect sys_dma_clk sys_ps8/S_AXI_HP3
ad_mem_hp3_interconnect sys_dma_clk pcie_fifo_mm/M_AXI
ad_mem_hp3_interconnect sys_dma_clk pcie_fifo_lite/M_AXI

# Address mapping: XDMA masters can access PS DDR4 (0x0 - 0x7FFFFFFF)
assign_bd_address -target_address_space pcie_xdma/M_AXI \
    [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW]
assign_bd_address -target_address_space pcie_xdma/M_AXI_LITE \
    [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW]
