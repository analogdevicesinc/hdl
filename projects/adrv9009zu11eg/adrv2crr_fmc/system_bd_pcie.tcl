###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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

# XDMA AXI-Stream mode, 2×C2H + 2×H2C
ad_ip_parameter pcie_xdma CONFIG.pl_link_cap_max_link_speed {8.0_GT/s}
ad_ip_parameter pcie_xdma CONFIG.pl_link_cap_max_link_width {X8}
ad_ip_parameter pcie_xdma CONFIG.xdma_axi_intf_mm {AXI_Stream}
ad_ip_parameter pcie_xdma CONFIG.xdma_rnum_chnl {2}
ad_ip_parameter pcie_xdma CONFIG.xdma_wnum_chnl {2}
ad_ip_parameter pcie_xdma CONFIG.axi_data_width {256_bit}
ad_ip_parameter pcie_xdma CONFIG.axisten_freq {250}
ad_ip_parameter pcie_xdma CONFIG.pf0_device_id {9038}
ad_ip_parameter pcie_xdma CONFIG.xdma_sts_ports {true}
ad_ip_parameter pcie_xdma CONFIG.pcie_blk_locn {X1Y0}
ad_ip_parameter pcie_xdma CONFIG.axilite_master_en {true}
ad_ip_parameter pcie_xdma CONFIG.pf0_msi_enabled {false}

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

# AXI DMA Engine 0 — connected to HP3
# All clocks = pcie_axi_clk (250 MHz). The HP3 SmartConnect handles
# the 250->333 MHz CDC to the PS DDR4 controller automatically
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma pcie_dma_0
set_property -dict [list \
  CONFIG.c_include_mm2s {1} \
  CONFIG.c_include_s2mm {1} \
  CONFIG.c_include_sg {0} \
  CONFIG.c_sg_include_stscntrl_strm {0} \
  CONFIG.c_sg_length_width {26} \
  CONFIG.c_m_axi_mm2s_data_width {256} \
  CONFIG.c_m_axi_s2mm_data_width {256} \
  CONFIG.c_m_axis_mm2s_tdata_width {256} \
  CONFIG.c_s_axis_s2mm_tdata_width {256} \
] [get_bd_cells pcie_dma_0]

# AXI DMA Engine 1 — connected to HPC1
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma pcie_dma_1
set_property -dict [list \
  CONFIG.c_include_mm2s {1} \
  CONFIG.c_include_s2mm {1} \
  CONFIG.c_include_sg {0} \
  CONFIG.c_sg_include_stscntrl_strm {0} \
  CONFIG.c_sg_length_width {26} \
  CONFIG.c_m_axi_mm2s_data_width {256} \
  CONFIG.c_m_axi_s2mm_data_width {256} \
  CONFIG.c_m_axis_mm2s_tdata_width {256} \
  CONFIG.c_s_axis_s2mm_tdata_width {256} \
] [get_bd_cells pcie_dma_1]

# Stream connections: XDMA <-> DMA engines (direct, no FIFOs, same 250 MHz clock)
# H2C channel 0: Host -> XDMA -> DMA0 -> DDR4
ad_connect pcie_xdma/M_AXIS_H2C_0 pcie_dma_0/S_AXIS_S2MM
# C2H channel 0: DDR4 -> DMA0 -> XDMA -> Host
ad_connect pcie_dma_0/M_AXIS_MM2S pcie_xdma/S_AXIS_C2H_0
# H2C channel 1: Host -> XDMA -> DMA1 -> DDR4
ad_connect pcie_xdma/M_AXIS_H2C_1 pcie_dma_1/S_AXIS_S2MM
# C2H channel 1: DDR4 -> DMA1 -> XDMA -> Host
ad_connect pcie_dma_1/M_AXIS_MM2S pcie_xdma/S_AXIS_C2H_1

# AXI DMA engine clocks and resets, all on pcie_axi_clk (250 MHz)
ad_connect pcie_axi_clk pcie_dma_0/s_axi_lite_aclk
ad_connect pcie_axi_clk pcie_dma_0/m_axi_mm2s_aclk
ad_connect pcie_axi_clk pcie_dma_0/m_axi_s2mm_aclk
ad_connect pcie_axi_resetn pcie_dma_0/axi_resetn

ad_connect pcie_axi_clk pcie_dma_1/s_axi_lite_aclk
ad_connect pcie_axi_clk pcie_dma_1/m_axi_mm2s_aclk
ad_connect pcie_axi_clk pcie_dma_1/m_axi_s2mm_aclk
ad_connect pcie_axi_resetn pcie_dma_1/axi_resetn

# Memory-mapped connections: DMA engines -> DDR4 via HP3 and HPC1
# The SmartConnects handle 250->333 MHz CDC automatically (multi-clock support)
# DMA0 -> HP3 (SAXIGP5)
ad_mem_hp3_interconnect pcie_axi_clk sys_ps8/S_AXI_HP3
ad_mem_hp3_interconnect pcie_axi_clk pcie_dma_0/M_AXI_MM2S
ad_mem_hp3_interconnect pcie_axi_clk pcie_dma_0/M_AXI_S2MM

# DMA1 -> HPC1 (SAXIGP1, shared with TX DMA)
ad_mem_hpc1_interconnect pcie_axi_clk pcie_dma_1/M_AXI_MM2S
ad_mem_hpc1_interconnect pcie_axi_clk pcie_dma_1/M_AXI_S2MM

# M_AXI_LITE: Host control path — DMA registers only
# SmartConnect: XDMA M_AXI_LITE (1 slave) -> 2 masters:
#   M00 -> DMA0 S_AXI_LITE (control registers)
#   M01 -> DMA1 S_AXI_LITE (control registers)
ad_ip_instance smartconnect pcie_lite_xbar [list \
  NUM_SI {1} \
  NUM_MI {2} \
  NUM_CLKS {1} \
]

ad_connect pcie_axi_clk pcie_lite_xbar/aclk
ad_connect pcie_axi_resetn pcie_lite_xbar/aresetn

ad_connect pcie_xdma/M_AXI_LITE pcie_lite_xbar/S00_AXI
ad_connect pcie_lite_xbar/M00_AXI pcie_dma_0/S_AXI_LITE
ad_connect pcie_lite_xbar/M01_AXI pcie_dma_1/S_AXI_LITE

# Address mapping, registers at BAR base, reachable from host /dev/xdma0_user
# DMA0 registers at 0x0000
create_bd_addr_seg -range 0x1000 -offset 0x00000000 \
    [get_bd_addr_spaces pcie_xdma/M_AXI_LITE] \
    [get_bd_addr_segs pcie_dma_0/S_AXI_LITE/Reg] \
    SEG_pcie_dma_0_lite

# DMA1 registers at 0x1000
create_bd_addr_seg -range 0x1000 -offset 0x00001000 \
    [get_bd_addr_spaces pcie_xdma/M_AXI_LITE] \
    [get_bd_addr_segs pcie_dma_1/S_AXI_LITE/Reg] \
    SEG_pcie_dma_1_lite
