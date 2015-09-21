
# pci-express

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

set axi_pcie_x4 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.6 axi_pcie_x4]
set_property -dict [list CONFIG.NO_OF_LANES {X4}] $axi_pcie_x4
set_property -dict [list CONFIG.MAX_LINK_SPEED {5.0_GT/s}] $axi_pcie_x4
set_property -dict [list CONFIG.DEVICE_ID {0x7022}] $axi_pcie_x4

set axi_pcie_x4_cpu_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_pcie_x4_cpu_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_pcie_x4_cpu_interconnect

set axi_pcie_x4_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_pcie_x4_rstgen]

create_bd_port -dir I -type rst pcie_rstn
create_bd_port -dir I -type clk pcie_ref_clk
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_data

set m_intc_index [get_property CONFIG.NUM_MI [get_bd_cells axi_cpu_interconnect]]
set m_intc_str "M$m_intc_index"
if {$m_intc_index < 10} {
  set m_intc_str "M0$m_intc_index"
}
set m_intc_index [expr $m_intc_index + 1]
set_property CONFIG.NUM_MI $m_intc_index [get_bd_cells axi_cpu_interconnect]

ad_connect  pcie_rstn axi_pcie_x4_rstgen/ext_reset_in
ad_connect  pcie_ref_clk axi_pcie_x4/REFCLK
ad_connect  pcie_data axi_pcie_x4/pcie_7x_mgt
ad_connect  pcie_axi_clk axi_pcie_x4/axi_aclk_out
ad_connect  pcie_axi_resetn axi_pcie_x4_rstgen/interconnect_aresetn
ad_connect  sys_cpu_resetn axi_pcie_x4_rstgen/aux_reset_in
ad_connect  axi_pcie_x4/mmcm_lock axi_pcie_x4_rstgen/dcm_locked
ad_connect  axi_pcie_x4/axi_ctl_aclk_out axi_pcie_x4_rstgen/slowest_sync_clk
ad_connect  pcie_axi_resetn axi_pcie_x4/axi_aresetn
ad_connect  axi_pcie_x4/axi_ctl_aclk_out axi_pcie_x4_cpu_interconnect/M00_ACLK
ad_connect  pcie_axi_resetn axi_pcie_x4_cpu_interconnect/M00_ARESETN
ad_connect  axi_pcie_x4_cpu_interconnect/M00_AXI axi_pcie_x4/S_AXI_CTL
ad_connect  sys_cpu_clk axi_pcie_x4_cpu_interconnect/ACLK
ad_connect  sys_cpu_clk axi_pcie_x4_cpu_interconnect/S00_ACLK
ad_connect  sys_cpu_clk axi_cpu_interconnect/${m_intc_str}_ACLK
ad_connect  sys_cpu_resetn axi_pcie_x4_cpu_interconnect/ARESETN
ad_connect  sys_cpu_resetn axi_pcie_x4_cpu_interconnect/S00_ARESETN
ad_connect  sys_cpu_resetn axi_cpu_interconnect/${m_intc_str}_ARESETN
ad_connect  axi_pcie_x4_cpu_interconnect/S00_AXI axi_cpu_interconnect/${m_intc_str}_AXI

delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_hp1_interconnect/S00_AXI]]]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_hp2_interconnect/S00_AXI]]]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_hp1_interconnect/M00_AXI]]]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_hp2_interconnect/M00_AXI]]]
delete_bd_objs [get_bd_addr_segs axi_ad9361_dac_dma/m_src_axi/SEG_sys_ps7_HP2_DDR_LOWOCM]
delete_bd_objs [get_bd_addr_segs axi_ad9361_adc_dma/m_dest_axi/SEG_sys_ps7_HP1_DDR_LOWOCM]

set axi_pcie_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_pcie_interconnect]
set_property -dict [list CONFIG.NUM_SI {2}] $axi_pcie_interconnect
set_property -dict [list CONFIG.NUM_MI {1}] $axi_pcie_interconnect

ad_connect  pcie_axi_clk axi_pcie_interconnect/ACLK
ad_connect  pcie_axi_clk axi_pcie_interconnect/M00_ACLK
ad_connect  pcie_axi_resetn axi_pcie_interconnect/ARESETN
ad_connect  pcie_axi_resetn axi_pcie_interconnect/M00_ARESETN
ad_connect  axi_pcie_interconnect/M00_AXI axi_pcie_x4/S_AXI

set axi_adc_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_adc_dma_interconnect]
set_property -dict [list CONFIG.NUM_SI {1}] $axi_adc_dma_interconnect
set_property -dict [list CONFIG.NUM_MI {2}] $axi_adc_dma_interconnect

ad_connect  sys_cpu_clk axi_adc_dma_interconnect/ACLK
ad_connect  sys_cpu_clk axi_adc_dma_interconnect/S00_ACLK
ad_connect  sys_cpu_clk axi_adc_dma_interconnect/M00_ACLK
ad_connect  sys_cpu_clk axi_adc_dma_interconnect/M01_ACLK
ad_connect  sys_cpu_clk axi_pcie_interconnect/S00_ACLK
ad_connect  sys_cpu_resetn axi_adc_dma_interconnect/ARESETN
ad_connect  sys_cpu_resetn axi_adc_dma_interconnect/S00_ARESETN
ad_connect  sys_cpu_resetn axi_adc_dma_interconnect/M00_ARESETN
ad_connect  sys_cpu_resetn axi_adc_dma_interconnect/M01_ARESETN
ad_connect  sys_cpu_resetn axi_pcie_interconnect/S00_ARESETN
ad_connect  axi_ad9361_adc_dma/m_dest_axi axi_adc_dma_interconnect/S00_AXI
ad_connect  axi_adc_dma_interconnect/M00_AXI axi_hp1_interconnect/S00_AXI
ad_connect  axi_adc_dma_interconnect/M01_AXI axi_pcie_interconnect/S00_AXI

set axi_dac_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_dac_dma_interconnect]
set_property -dict [list CONFIG.NUM_SI {1}] $axi_dac_dma_interconnect
set_property -dict [list CONFIG.NUM_MI {2}] $axi_dac_dma_interconnect

ad_connect  sys_cpu_clk axi_dac_dma_interconnect/ACLK
ad_connect  sys_cpu_clk axi_dac_dma_interconnect/S00_ACLK
ad_connect  sys_cpu_clk axi_dac_dma_interconnect/M00_ACLK
ad_connect  sys_cpu_clk axi_dac_dma_interconnect/M01_ACLK
ad_connect  sys_cpu_clk axi_pcie_interconnect/S01_ACLK
ad_connect  sys_cpu_resetn axi_dac_dma_interconnect/ARESETN
ad_connect  sys_cpu_resetn axi_dac_dma_interconnect/S00_ARESETN
ad_connect  sys_cpu_resetn axi_dac_dma_interconnect/M00_ARESETN
ad_connect  sys_cpu_resetn axi_dac_dma_interconnect/M01_ARESETN
ad_connect  sys_cpu_resetn axi_pcie_interconnect/S01_ARESETN
ad_connect  axi_ad9361_dac_dma/m_src_axi axi_dac_dma_interconnect/S00_AXI
ad_connect  axi_dac_dma_interconnect/M00_AXI axi_hp2_interconnect/S00_AXI
ad_connect  axi_dac_dma_interconnect/M01_AXI axi_pcie_interconnect/S01_AXI

ad_mem_hp0_interconnect pcie_axi_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect pcie_axi_clk axi_pcie_x4/M_AXI

assign_bd_address [get_bd_addr_segs {axi_pcie_x4/S_AXI_CTL/CTL0}]
assign_bd_address [get_bd_addr_segs {axi_pcie_x4/S_AXI/BAR0}]

#create_bd_addr_seg -range 0x10000000 -offset 0x44a60000 [get_bd_addr_spaces sys_ps7/Data] \
#  [get_bd_addr_segs axi_pcie_x4/S_AXI_CTL/CTL0] SEG_data_axi_pcie_x4



