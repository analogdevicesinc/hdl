
# pci-express

set axi_pcie_x4 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.6 axi_pcie_x4]
set_property -dict [list CONFIG.NO_OF_LANES {X4}] $axi_pcie_x4
set_property -dict [list CONFIG.MAX_LINK_SPEED {5.0_GT/s}] $axi_pcie_x4
set_property -dict [list CONFIG.DEVICE_ID {0x7022}] $axi_pcie_x4

ad_cpu_interconnect 0x44A60000 axi_pcie_x4
ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_pcie_x4/M_AXI

