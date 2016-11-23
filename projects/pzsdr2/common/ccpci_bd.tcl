
# pci-express

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# peripherals in pl

set axi_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_spi]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_spi
set_property -dict [list CONFIG.C_NUM_SS_BITS {8}] $axi_spi
set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_spi

create_bd_port -dir O -from 7 -to 0 pl_spi_csn_o
create_bd_port -dir I -from 7 -to 0 pl_spi_csn_i
create_bd_port -dir I pl_spi_clk_i
create_bd_port -dir O pl_spi_clk_o
create_bd_port -dir I pl_spi_sdo_i
create_bd_port -dir O pl_spi_sdo_o
create_bd_port -dir I pl_spi_sdi_i

ad_connect  pl_spi_csn_i axi_spi/ss_i
ad_connect  pl_spi_csn_o axi_spi/ss_o
ad_connect  pl_spi_clk_i axi_spi/sck_i
ad_connect  pl_spi_clk_o axi_spi/sck_o
ad_connect  pl_spi_sdo_i axi_spi/io0_i
ad_connect  pl_spi_sdo_o axi_spi/io0_o
ad_connect  pl_spi_sdi_i axi_spi/io1_i

set axi_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio
set_property -dict [list CONFIG.C_GPIO_WIDTH {32}] $axi_gpio
set_property -dict [list CONFIG.C_GPIO2_WIDTH {32}] $axi_gpio
set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_gpio

create_bd_port -dir I -from 31 -to 0 pl_gpio0_i
create_bd_port -dir O -from 31 -to 0 pl_gpio0_o
create_bd_port -dir O -from 31 -to 0 pl_gpio0_t
create_bd_port -dir I -from 31 -to 0 pl_gpio1_i
create_bd_port -dir O -from 31 -to 0 pl_gpio1_o
create_bd_port -dir O -from 31 -to 0 pl_gpio1_t

ad_connect  pl_gpio0_i axi_gpio/gpio_io_i
ad_connect  pl_gpio0_o axi_gpio/gpio_io_o
ad_connect  pl_gpio0_t axi_gpio/gpio_io_t
ad_connect  pl_gpio1_i axi_gpio/gpio2_io_i
ad_connect  pl_gpio1_o axi_gpio/gpio2_io_o
ad_connect  pl_gpio1_t axi_gpio/gpio2_io_t

# pci-express

set axi_pcie_x4 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.8 axi_pcie_x4]
set_property -dict [list CONFIG.NO_OF_LANES {X4}] $axi_pcie_x4
set_property -dict [list CONFIG.MAX_LINK_SPEED {5.0_GT/s}] $axi_pcie_x4
set_property -dict [list CONFIG.VENDOR_ID {0x11D4}] $axi_pcie_x4
set_property -dict [list CONFIG.DEVICE_ID {0x9361}] $axi_pcie_x4
set_property -dict [list CONFIG.SUBSYSTEM_VENDOR_ID {0x11D4}] $axi_pcie_x4
set_property -dict [list CONFIG.SUBSYSTEM_ID {0x0405}] $axi_pcie_x4
set_property -dict [list CONFIG.ENABLE_CLASS_CODE {true}] $axi_pcie_x4
set_property -dict [list CONFIG.CLASS_CODE {0x0D1000}] $axi_pcie_x4
set_property -dict [list CONFIG.BAR0_ENABLED {true}] $axi_pcie_x4
set_property -dict [list CONFIG.BAR0_TYPE {Memory}] $axi_pcie_x4
set_property -dict [list CONFIG.BAR0_SCALE {Gigabytes}] $axi_pcie_x4
set_property -dict [list CONFIG.BAR0_SIZE {1}] $axi_pcie_x4
set_property -dict [list CONFIG.NUM_MSI_REQ {1}] $axi_pcie_x4
set_property -dict [list CONFIG.PCIEBAR2AXIBAR_0 {0x40000000}] $axi_pcie_x4
set_property -dict [list CONFIG.AXIBAR2PCIEBAR_0 {0x00000000}] $axi_pcie_x4

set axi_pcie_x4_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_pcie_x4_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {16}] $axi_pcie_x4_rstgen

set axi_pcie_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_pcie_intc]
set_property -dict [list CONFIG.C_HAS_FAST {0}] $axi_pcie_intc

set pcie_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pcie_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {5}] $pcie_concat_intc

create_bd_port -dir I -type rst pcie_rstn
create_bd_port -dir I -type clk pcie_ref_clk
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_data

ad_connect  pcie_rstn axi_pcie_x4_rstgen/ext_reset_in
ad_connect  pcie_ref_clk axi_pcie_x4/REFCLK
ad_connect  pcie_data axi_pcie_x4/pcie_7x_mgt
ad_connect  pcie_axi_clk axi_pcie_x4/axi_aclk_out
ad_connect  pcie_axi_resetn axi_pcie_x4_rstgen/interconnect_aresetn
ad_connect  sys_cpu_resetn axi_pcie_x4_rstgen/aux_reset_in
ad_connect  axi_pcie_x4/mmcm_lock axi_pcie_x4_rstgen/dcm_locked
ad_connect  axi_pcie_x4/axi_ctl_aclk_out axi_pcie_x4_rstgen/slowest_sync_clk
ad_connect  pcie_axi_resetn axi_pcie_x4/axi_aresetn

create_bd_port -dir O pcie_rst
create_bd_port -dir O pcie_clk

ad_connect  axi_pcie_x4_rstgen/bus_struct_reset pcie_rst
ad_connect  axi_pcie_x4/axi_ctl_aclk_out pcie_clk

# interrupts

ad_connect  axi_pcie_intc/irq axi_pcie_x4/INTX_MSI_Request
ad_connect  pcie_concat_intc/dout axi_pcie_intc/intr
ad_connect  pcie_concat_intc/In0 axi_iic_main/iic2intc_irpt
ad_connect  pcie_concat_intc/In1 axi_ad9361_adc_dma/irq
ad_connect  pcie_concat_intc/In2 axi_ad9361_dac_dma/irq
ad_connect  pcie_concat_intc/In3 axi_gpio/ip2intc_irpt
ad_connect  pcie_concat_intc/In4 axi_spi/ip2intc_irpt

# cpu interconnect

delete_bd_objs [get_bd_addr_segs sys_ps7/Data/SEG_axi_iic_main_Reg]
delete_bd_objs [get_bd_addr_segs sys_ps7/Data/SEG_axi_ad9361_axi_lite]
delete_bd_objs [get_bd_addr_segs sys_ps7/Data/SEG_axi_ad9361_dac_dma_axi_lite]
delete_bd_objs [get_bd_addr_segs sys_ps7/Data/SEG_axi_ad9361_adc_dma_axi_lite]

delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_cpu_interconnect/M00_AXI]]]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_cpu_interconnect/M01_AXI]]]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_cpu_interconnect/M02_AXI]]]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_cpu_interconnect/M03_AXI]]]

set_property CONFIG.NUM_MI 8 [get_bd_cells axi_cpu_interconnect]
set_property CONFIG.NUM_SI 2 [get_bd_cells axi_cpu_interconnect]

ad_connect  axi_pcie_x4/axi_ctl_aclk_out axi_cpu_interconnect/M04_ACLK
ad_connect  pcie_axi_resetn axi_cpu_interconnect/M04_ARESETN
ad_connect  pcie_axi_clk axi_cpu_interconnect/S01_ACLK
ad_connect  pcie_axi_resetn axi_cpu_interconnect/S01_ARESETN
ad_connect  axi_pcie_x4/M_AXI axi_cpu_interconnect/S01_AXI
ad_connect  pcie_axi_clk axi_pcie_intc/s_axi_aclk
ad_connect  pcie_axi_resetn axi_pcie_intc/s_axi_aresetn
ad_connect  pcie_axi_clk axi_cpu_interconnect/M05_ACLK
ad_connect  pcie_axi_resetn axi_cpu_interconnect/M05_ARESETN
ad_connect  sys_cpu_clk axi_gpio/s_axi_aclk
ad_connect  sys_cpu_resetn axi_gpio/s_axi_aresetn
ad_connect  sys_cpu_clk axi_cpu_interconnect/M06_ACLK
ad_connect  sys_cpu_resetn axi_cpu_interconnect/M06_ARESETN
ad_connect  sys_cpu_clk axi_spi/ext_spi_clk
ad_connect  sys_cpu_clk axi_spi/s_axi_aclk
ad_connect  sys_cpu_resetn axi_spi/s_axi_aresetn
ad_connect  sys_cpu_clk axi_cpu_interconnect/M07_ACLK
ad_connect  sys_cpu_resetn axi_cpu_interconnect/M07_ARESETN
ad_connect  axi_cpu_interconnect/M00_AXI axi_iic_main/S_AXI
ad_connect  axi_cpu_interconnect/M01_AXI axi_ad9361/s_axi
ad_connect  axi_cpu_interconnect/M02_AXI axi_ad9361_dac_dma/s_axi
ad_connect  axi_cpu_interconnect/M03_AXI axi_ad9361_adc_dma/s_axi
ad_connect  axi_cpu_interconnect/M04_AXI axi_pcie_x4/S_AXI_CTL
ad_connect  axi_cpu_interconnect/M05_AXI axi_pcie_intc/s_axi
ad_connect  axi_cpu_interconnect/M06_AXI axi_gpio/S_AXI
ad_connect  axi_cpu_interconnect/M07_AXI axi_spi/AXI_LITE

# remove hp1/hp2 interconnects (ipi error- same address on network)

delete_bd_objs [get_bd_addr_segs axi_ad9361_dac_dma/m_src_axi/SEG_sys_ps7_HP2_DDR_LOWOCM]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_hp1_interconnect/S00_AXI]]]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_hp1_interconnect/M00_AXI]]]

delete_bd_objs [get_bd_addr_segs axi_ad9361_adc_dma/m_dest_axi/SEG_sys_ps7_HP1_DDR_LOWOCM]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_hp2_interconnect/S00_AXI]]]
delete_bd_objs [get_bd_intf_nets -of_objects [find_bd_objs -relation connected_to [get_bd_intf_pins axi_hp2_interconnect/M00_AXI]]]

# pci-e slave

set axi_pcie_s_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_pcie_s_interconnect]
set_property -dict [list CONFIG.NUM_SI {2}] $axi_pcie_s_interconnect
set_property -dict [list CONFIG.NUM_MI {1}] $axi_pcie_s_interconnect
set_property -dict [list CONFIG.STRATEGY {2} ] $axi_pcie_s_interconnect

ad_connect  pcie_axi_clk axi_pcie_s_interconnect/ACLK
ad_connect  pcie_axi_clk axi_pcie_s_interconnect/M00_ACLK
ad_connect  sys_cpu_clk axi_pcie_s_interconnect/S00_ACLK
ad_connect  sys_cpu_clk axi_pcie_s_interconnect/S01_ACLK
ad_connect  pcie_axi_resetn axi_pcie_s_interconnect/ARESETN
ad_connect  pcie_axi_resetn axi_pcie_s_interconnect/M00_ARESETN
ad_connect  sys_cpu_resetn axi_pcie_s_interconnect/S00_ARESETN
ad_connect  sys_cpu_resetn axi_pcie_s_interconnect/S01_ARESETN
ad_connect  axi_ad9361_adc_dma/m_dest_axi axi_pcie_s_interconnect/S00_AXI
ad_connect  axi_ad9361_dac_dma/m_src_axi axi_pcie_s_interconnect/S01_AXI
ad_connect  axi_pcie_s_interconnect/M00_AXI axi_pcie_x4/S_AXI

# hps7  slave

set_property CONFIG.PCW_USE_S_AXI_HP0 {0} [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USE_S_AXI_HP1 {0} [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USE_S_AXI_HP2 {0} [get_bd_cells sys_ps7]

# reassign addresses

assign_bd_address [get_bd_addr_segs {axi_iic_main/S_AXI/Reg}]
assign_bd_address [get_bd_addr_segs {axi_ad9361/s_axi/axi_lite}]
assign_bd_address [get_bd_addr_segs {axi_ad9361_dac_dma/s_axi/axi_lite}]
assign_bd_address [get_bd_addr_segs {axi_ad9361_adc_dma/s_axi/axi_lite}]
assign_bd_address [get_bd_addr_segs {axi_pcie_x4/S_AXI_CTL/CTL0}]
assign_bd_address [get_bd_addr_segs {axi_pcie_intc/s_axi/Reg}]
assign_bd_address [get_bd_addr_segs {axi_gpio/S_AXI/Reg}]
assign_bd_address [get_bd_addr_segs {axi_spi/AXI_LITE/Reg}]

set_property offset 0x40000000 [get_bd_addr_segs {axi_pcie_x4/M_AXI/SEG_axi_gpio_Reg}]
set_property offset 0x44A00000 [get_bd_addr_segs {axi_pcie_x4/M_AXI/SEG_axi_spi_Reg}]
set_property offset 0x41600000 [get_bd_addr_segs {axi_pcie_x4/M_AXI/SEG_axi_iic_main_Reg}]
set_property offset 0x79020000 [get_bd_addr_segs {axi_pcie_x4/M_AXI/SEG_axi_ad9361_axi_lite}]
set_property offset 0x7C400000 [get_bd_addr_segs {axi_pcie_x4/M_AXI/SEG_axi_ad9361_dac_dma_axi_lite}]
set_property offset 0x7C420000 [get_bd_addr_segs {axi_pcie_x4/M_AXI/SEG_axi_ad9361_adc_dma_axi_lite}]
set_property offset 0x50000000 [get_bd_addr_segs {axi_pcie_x4/M_AXI/SEG_axi_pcie_x4_CTL0}]
set_property offset 0x41200000 [get_bd_addr_segs {axi_pcie_x4/M_AXI/SEG_axi_pcie_intc_Reg}]

set_property offset 0x40000000 [get_bd_addr_segs {sys_ps7/Data/SEG_axi_gpio_Reg}]
set_property offset 0x44A00000 [get_bd_addr_segs {sys_ps7/Data/SEG_axi_spi_Reg}]
set_property offset 0x41600000 [get_bd_addr_segs {sys_ps7/Data/SEG_axi_iic_main_Reg}]
set_property offset 0x79020000 [get_bd_addr_segs {sys_ps7/Data/SEG_axi_ad9361_axi_lite}]
set_property offset 0x7C400000 [get_bd_addr_segs {sys_ps7/Data/SEG_axi_ad9361_dac_dma_axi_lite}]
set_property offset 0x7C420000 [get_bd_addr_segs {sys_ps7/Data/SEG_axi_ad9361_adc_dma_axi_lite}]
set_property offset 0x50000000 [get_bd_addr_segs {sys_ps7/Data/SEG_axi_pcie_x4_CTL0}]
set_property offset 0x41200000 [get_bd_addr_segs {sys_ps7/Data/SEG_axi_pcie_intc_Reg}]

assign_bd_address [get_bd_addr_segs {axi_pcie_x4/S_AXI/BAR0}]



