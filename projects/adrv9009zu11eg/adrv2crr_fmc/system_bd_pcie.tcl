###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Create a Concat for XDMA interrupts
ad_ip_instance ilconcat concat_xdma_int
ad_ip_parameter concat_xdma_int CONFIG.NUM_PORTS {5}

# Instead of using PS SPI controller, use a PL based SPI controller
# which will be connected to the XDMA

# Delete old SPI lines
delete_bd_objs [get_bd_nets sys_ps8_emio_spi0_sclk_o] [get_bd_nets sys_ps8_emio_spi0_m_o] [get_bd_nets sys_ps8_emio_spi0_ss2_o_n] [get_bd_nets sys_ps8_emio_spi0_ss_o_n] [get_bd_nets spi0_csn_concat_dout] [get_bd_nets sys_ps8_emio_spi0_ss1_o_n] [get_bd_nets spi0_miso_1]
delete_bd_objs [get_bd_cells spi0_csn_concat]

# Delete old GPIO lines
delete_bd_objs [get_bd_nets sys_ps8_emio_gpio_o] [get_bd_nets gpio_i_1] [get_bd_nets sys_ps8_emio_gpio_t]

# SPI CONTROLLER
# Create a SPI controller, standard mode, for controlling 3 slaves
# The SPI controller will be controlled via the PCIe bridge
ad_ip_instance axi_quad_spi axi_spi
ad_ip_parameter axi_spi CONFIG.C_SPI_MODE {0}
ad_ip_parameter axi_spi CONFIG.C_NUM_SS_BITS {3}
ad_ip_parameter axi_spi CONFIG.C_USE_STARTUP {0}
ad_ip_parameter axi_spi CONFIG.C_NUM_TRANSFER_BITS {8}
ad_ip_parameter axi_spi CONFIG.C_SCK_RATIO {8}

ad_connect axi_spi/io0_o spi0_mosi
ad_connect axi_spi/io1_i spi0_miso
ad_connect axi_spi/sck_o spi0_sclk
ad_connect axi_spi/ss_o spi0_csn
ad_connect axi_spi/ext_spi_clk sys_cpu_clk

# GPIO controller

# Create 3 Slice instances for breaking the [94:0] GPIO signals into 3 sub-arrays
# for GPIO_I signals

# first [31:0]
ad_ip_instance ilslice slice_gpio1
ad_ip_parameter slice_gpio1 CONFIG.DIN_WIDTH {95}
ad_ip_parameter slice_gpio1 CONFIG.DIN_FROM {31}
ad_ip_parameter slice_gpio1 CONFIG.DIN_TO {0}
ad_ip_parameter slice_gpio1 CONFIG.DOUT_WIDTH {32}

# second [63:32]
ad_ip_instance ilslice slice_gpio2
ad_ip_parameter slice_gpio2 CONFIG.DIN_WIDTH {95}
ad_ip_parameter slice_gpio2 CONFIG.DIN_FROM {63}
ad_ip_parameter slice_gpio2 CONFIG.DIN_TO {32}
ad_ip_parameter slice_gpio2 CONFIG.DOUT_WIDTH {32}

# third [94:64]
ad_ip_instance ilslice slice_gpio3
ad_ip_parameter slice_gpio3 CONFIG.DIN_WIDTH {95}
ad_ip_parameter slice_gpio3 CONFIG.DIN_FROM {94}
ad_ip_parameter slice_gpio3 CONFIG.DIN_TO {64}
ad_ip_parameter slice_gpio3 CONFIG.DOUT_WIDTH {31}

# Create 2 Concat instances for concatenating the 3 sub-arrays GPIO signals into an array [94:0]
# for GPIO_O and GPIO_T signals

# GPIO_O
ad_ip_instance ilconcat concat_gpio1
ad_ip_parameter concat_gpio1 CONFIG.NUM_PORTS {3}
ad_ip_parameter concat_gpio1 CONFIG.IN0_WIDTH {32}
ad_ip_parameter concat_gpio1 CONFIG.IN1_WIDTH {32}
ad_ip_parameter concat_gpio1 CONFIG.IN2_WIDTH {31}

# GPIO_T
ad_ip_instance ilconcat concat_gpio2
ad_ip_parameter concat_gpio2 CONFIG.NUM_PORTS {3}
ad_ip_parameter concat_gpio2 CONFIG.IN0_WIDTH {32}
ad_ip_parameter concat_gpio2 CONFIG.IN1_WIDTH {32}
ad_ip_parameter concat_gpio2 CONFIG.IN2_WIDTH {31}

# Create 2 GPIO controllers to fit the 95 GPIO signals
# first GPIO controller in dual mode
ad_ip_instance axi_gpio axi_gpio1
ad_ip_parameter axi_gpio1 CONFIG.C_INTERRUPT_PRESENT {1}
ad_ip_parameter axi_gpio1 CONFIG.C_IS_DUAL {1}

ad_ip_instance axi_gpio axi_gpio2
ad_ip_parameter axi_gpio2 CONFIG.C_INTERRUPT_PRESENT {1}
ad_ip_parameter axi_gpio2 CONFIG.C_GPIO_WIDTH {31}

# Connect the concat & slice modules to the AXI GPIOs
# GPIO_I
ad_connect gpio_i slice_gpio1/Din
ad_connect gpio_i slice_gpio2/Din
ad_connect gpio_i slice_gpio3/Din
ad_connect slice_gpio1/Dout axi_gpio1/gpio_io_i
ad_connect slice_gpio2/Dout axi_gpio1/gpio2_io_i
ad_connect slice_gpio3/Dout axi_gpio2/gpio_io_i

# GPIO_O
ad_connect concat_gpio1/In0 axi_gpio1/gpio_io_o
ad_connect concat_gpio1/In1 axi_gpio1/gpio2_io_o
ad_connect concat_gpio1/In2 axi_gpio2/gpio_io_o
ad_connect concat_gpio1/dout gpio_o

# GPIO_T
ad_connect concat_gpio2/In0 axi_gpio1/gpio_io_t
ad_connect concat_gpio2/In1 axi_gpio1/gpio2_io_t
ad_connect concat_gpio2/In2 axi_gpio2/gpio_io_t
ad_connect concat_gpio2/dout gpio_t

# PCIe XDMA in AXI Bridge mode + ADI axi_dmac controllers
# Architecture: XDMA bridge provides M_AXI_B (host->FPGA) and S_AXI_B (FPGA->host)
#   - Two axi_dmac instances (C2H + H2C), both MM-to-MM with scatter-gather
#   - Host programs DMA registers via M_AXI_B BAR
#   - axi_dmac bus-masters into host RAM via S_AXI_B
#   - DDR4 access via HP3

create_bd_cell -type ip -vlnv xilinx.com:ip:xdma pcie_xdma

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt

create_bd_port -dir I pcie_ref_clk
create_bd_port -dir I pcie_ref_clk_div2
create_bd_port -dir I -type rst pcie_perstn
create_bd_port -dir O user_link_up

ad_ip_parameter pcie_xdma CONFIG.functional_mode {AXI_Bridge}
ad_ip_parameter pcie_xdma CONFIG.pl_link_cap_max_link_speed {8.0_GT/s}
ad_ip_parameter pcie_xdma CONFIG.pl_link_cap_max_link_width {X8}
ad_ip_parameter pcie_xdma CONFIG.axi_data_width {256_bit}
ad_ip_parameter pcie_xdma CONFIG.axisten_freq {250}
ad_ip_parameter pcie_xdma CONFIG.pf0_device_id {9038}
ad_ip_parameter pcie_xdma CONFIG.pcie_blk_locn {X1Y0}
ad_ip_parameter pcie_xdma CONFIG.pf0_msi_enabled {true}
ad_ip_parameter pcie_xdma CONFIG.xdma_num_usr_irq {5}

# M_AXI_B BAR: host accesses axi_dmac registers (64 KB window)
ad_ip_parameter pcie_xdma CONFIG.pciebar2axibar_0 {0x0000000000000000}

# S_AXI_B: FPGA masters into host memory
ad_ip_parameter pcie_xdma CONFIG.axibar_num {1}
ad_ip_parameter pcie_xdma CONFIG.axibar2pciebar_0 {0x0000000000000000}

# PCIe lane connections
connect_bd_intf_net [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins pcie_xdma/pcie_mgt]

# Clock and reset
ad_connect pcie_ref_clk pcie_xdma/sys_clk_gt
ad_connect pcie_ref_clk_div2 pcie_xdma/sys_clk
ad_connect pcie_perstn pcie_xdma/sys_rst_n

ad_connect user_link_up pcie_xdma/user_lnk_up

# XDMA AXI clock domain reset generator
ad_ip_instance proc_sys_reset pcie_axi_rstgen
ad_ip_parameter pcie_axi_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect pcie_axi_clk pcie_xdma/axi_aclk
ad_connect pcie_axi_clk pcie_axi_rstgen/slowest_sync_clk
ad_connect pcie_xdma/axi_aresetn pcie_axi_rstgen/ext_reset_in
ad_connect pcie_axi_resetn pcie_axi_rstgen/peripheral_aresetn

# ADI axi_dmac: C2H (Card-to-Host)
# Reads RF data from PS DDR4 (m_src_axi -> HP3)
# Writes to host RAM (m_dest_axi -> S_AXI_B -> PCIe)
# SG descriptors in host RAM (m_sg_axi -> S_AXI_B -> PCIe)

ad_ip_instance axi_dmac pcie_c2h_dma
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_AXI_ADDR_WIDTH 64
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_SG_TRANSFER 1
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_AXI_PROTOCOL_SRC 0
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_AXI_PROTOCOL_DEST 0
ad_ip_parameter pcie_c2h_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter pcie_c2h_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter pcie_c2h_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter pcie_c2h_dma CONFIG.MAX_BYTES_PER_BURST 128
ad_ip_parameter pcie_c2h_dma CONFIG.CYCLIC 0

# ADI axi_dmac: H2C (Host-to-Card)
# Reads from host RAM (m_src_axi -> S_AXI_B -> PCIe)
# Writes TX data to PS DDR4 (m_dest_axi -> HP3)
# SG descriptors in host RAM (m_sg_axi -> S_AXI_B -> PCIe)

ad_ip_instance axi_dmac pcie_h2c_dma
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_AXI_ADDR_WIDTH 64
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_SG_TRANSFER 1
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_AXI_PROTOCOL_SRC 0
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_AXI_PROTOCOL_DEST 0
ad_ip_parameter pcie_h2c_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter pcie_h2c_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter pcie_h2c_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter pcie_h2c_dma CONFIG.MAX_BYTES_PER_BURST 128
ad_ip_parameter pcie_h2c_dma CONFIG.CYCLIC 0

# Clock connections for axi_dmac
# s_axi (register access) clocked by pcie_axi_clk (host-facing)
# m_src_axi / m_dest_axi / m_sg_axi clocked by pcie_axi_clk
# HP3 SmartConnect handles CDC to sys_dma_clk (~333 MHz)

ad_connect pcie_axi_clk pcie_c2h_dma/s_axi_aclk
ad_connect pcie_axi_resetn pcie_c2h_dma/s_axi_aresetn
ad_connect pcie_axi_clk pcie_c2h_dma/m_src_axi_aclk
ad_connect pcie_axi_resetn pcie_c2h_dma/m_src_axi_aresetn
ad_connect pcie_axi_clk pcie_c2h_dma/m_dest_axi_aclk
ad_connect pcie_axi_resetn pcie_c2h_dma/m_dest_axi_aresetn
ad_connect pcie_axi_clk pcie_c2h_dma/m_sg_axi_aclk
ad_connect pcie_axi_resetn pcie_c2h_dma/m_sg_axi_aresetn

ad_connect pcie_axi_clk pcie_h2c_dma/s_axi_aclk
ad_connect pcie_axi_resetn pcie_h2c_dma/s_axi_aresetn
ad_connect pcie_axi_clk pcie_h2c_dma/m_src_axi_aclk
ad_connect pcie_axi_resetn pcie_h2c_dma/m_src_axi_aresetn
ad_connect pcie_axi_clk pcie_h2c_dma/m_dest_axi_aclk
ad_connect pcie_axi_resetn pcie_h2c_dma/m_dest_axi_aresetn
ad_connect pcie_axi_clk pcie_h2c_dma/m_sg_axi_aclk
ad_connect pcie_axi_resetn pcie_h2c_dma/m_sg_axi_aresetn

# SPI contoller clock & resets
ad_connect axi_spi/s_axi_aclk pcie_axi_clk
ad_connect axi_spi/s_axi_aresetn pcie_axi_resetn

# GPIOs controllers clock & resets
ad_connect pcie_axi_clk axi_gpio1/s_axi_aclk
ad_connect pcie_axi_resetn axi_gpio1/s_axi_aresetn
ad_connect pcie_axi_clk axi_gpio2/s_axi_aclk
ad_connect pcie_axi_resetn axi_gpio2/s_axi_aresetn

# M_AXI_B path: Host -> axi_dmac registers
# SmartConnect: 1 slave (XDMA M_AXI_B) -> 2 masters (C2H + H2C S_AXI_LITE)

ad_ip_instance smartconnect pcie_ctrl_sc
ad_ip_parameter pcie_ctrl_sc CONFIG.NUM_SI {1}
ad_ip_parameter pcie_ctrl_sc CONFIG.NUM_MI {5}
ad_ip_parameter pcie_ctrl_sc CONFIG.NUM_CLKS {1}

ad_connect pcie_axi_clk pcie_ctrl_sc/aclk
ad_connect pcie_axi_resetn pcie_ctrl_sc/aresetn

ad_connect pcie_xdma/M_AXI_B pcie_ctrl_sc/S00_AXI
ad_connect pcie_ctrl_sc/M00_AXI pcie_c2h_dma/s_axi
ad_connect pcie_ctrl_sc/M01_AXI pcie_h2c_dma/s_axi
ad_connect pcie_ctrl_sc/M02_AXI axi_spi/AXI_LITE
ad_connect pcie_ctrl_sc/M03_AXI axi_gpio1/S_AXI
ad_connect pcie_ctrl_sc/M04_AXI axi_gpio2/S_AXI

# Address mapping: host -> axi_dmac registers
assign_bd_address -target_address_space pcie_xdma/M_AXI_B \
  [get_bd_addr_segs pcie_c2h_dma/s_axi/axi_lite]
set_property offset 0x00000000 [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_pcie_c2h_dma_axi_lite}]
set_property range 4K [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_pcie_c2h_dma_axi_lite}]

assign_bd_address -target_address_space pcie_xdma/M_AXI_B \
  [get_bd_addr_segs pcie_h2c_dma/s_axi/axi_lite]
set_property offset 0x00010000  [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_pcie_h2c_dma_axi_lite}]
set_property range 4K [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_pcie_h2c_dma_axi_lite}]

# Adress mapping: host -> axi_spi_controller registers
assign_bd_address -target_address_space pcie_xdma/M_AXI_B \
  [get_bd_addr_segs axi_spi/AXI_LITE/Reg]
set_property offset 0x00020000 [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_axi_spi_Reg}]
set_property range 4K [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_axi_spi_Reg}]

# Address mapping: host -> axi_gpio_controller1 registers
assign_bd_address -target_address_space pcie_xdma/M_AXI_B \
  [get_bd_addr_segs axi_gpio1/S_AXI/Reg]
set_property offset 0x00030000 [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_axi_gpio1_Reg}]
set_property range 4K [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_axi_gpio1_Reg}]

# Address mapping: host -> axi_gpio_controller2 registers
assign_bd_address -target_address_space pcie_xdma/M_AXI_B \
  [get_bd_addr_segs axi_gpio2/S_AXI/Reg]
set_property offset 0x00040000 [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_axi_gpio2_Reg}]
set_property range 4K [get_bd_addr_segs {pcie_xdma/M_AXI_B/SEG_axi_gpio2_Reg}]

# S_AXI_B path: axi_dmac -> host RAM via PCIe
# SmartConnect: 4 slaves (C2H dest + SG, H2C src + SG) -> 1 master (XDMA S_AXI_B)

ad_ip_instance smartconnect pcie_saxi_sc
ad_ip_parameter pcie_saxi_sc CONFIG.NUM_SI {4}
ad_ip_parameter pcie_saxi_sc CONFIG.NUM_MI {1}
ad_ip_parameter pcie_saxi_sc CONFIG.NUM_CLKS {1}

ad_connect pcie_axi_clk pcie_saxi_sc/aclk
ad_connect pcie_axi_resetn pcie_saxi_sc/aresetn

ad_connect pcie_c2h_dma/m_dest_axi pcie_saxi_sc/S00_AXI
ad_connect pcie_c2h_dma/m_sg_axi pcie_saxi_sc/S01_AXI
ad_connect pcie_h2c_dma/m_src_axi pcie_saxi_sc/S02_AXI
ad_connect pcie_h2c_dma/m_sg_axi pcie_saxi_sc/S03_AXI

ad_connect pcie_saxi_sc/M00_AXI pcie_xdma/S_AXI_B

# Address mapping: axi_dmac -> host RAM via S_AXI_B
# Map the full XDMA S_AXI_B address space for each DMA master
assign_bd_address -target_address_space pcie_c2h_dma/m_dest_axi \
  [get_bd_addr_segs pcie_xdma/S_AXI_B/BAR0]
assign_bd_address -target_address_space pcie_c2h_dma/m_sg_axi \
  [get_bd_addr_segs pcie_xdma/S_AXI_B/BAR0]
assign_bd_address -target_address_space pcie_h2c_dma/m_src_axi \
  [get_bd_addr_segs pcie_xdma/S_AXI_B/BAR0]
assign_bd_address -target_address_space pcie_h2c_dma/m_sg_axi \
  [get_bd_addr_segs pcie_xdma/S_AXI_B/BAR0]

# DDR4 path: axi_dmac -> PS DDR4 via HP3
# C2H reads DDR4 (m_src_axi), H2C writes DDR4 (m_dest_axi)

ad_mem_hp3_interconnect pcie_axi_clk sys_ps8/S_AXI_HP3
ad_mem_hp3_interconnect pcie_axi_clk pcie_c2h_dma/m_src_axi
ad_mem_hp3_interconnect pcie_axi_clk pcie_h2c_dma/m_dest_axi

# Address mapping: axi_dmac -> PS DDR4
assign_bd_address -target_address_space pcie_c2h_dma/m_src_axi \
  [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW]
assign_bd_address -target_address_space pcie_h2c_dma/m_dest_axi \
  [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW]

# XDMA interupts
ad_connect pcie_xdma/usr_irq_req concat_xdma_int/dout
ad_connect concat_xdma_int/In0 pcie_c2h_dma/irq
ad_connect concat_xdma_int/In1 pcie_h2c_dma/irq
ad_connect concat_xdma_int/In2 axi_spi/ip2intc_irpt
ad_connect concat_xdma_int/In3 axi_gpio1/ip2intc_irpt
ad_connect concat_xdma_int/In4 axi_gpio2/ip2intc_irpt