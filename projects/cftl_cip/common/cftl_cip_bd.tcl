
  global adc_spi_freq

  # pmod interfaces

  set pmod_spi_cs         [create_bd_port -dir O pmod_spi_cs]
  set pmod_spi_miso       [create_bd_port -dir I pmod_spi_miso]
  set pmod_spi_clk        [create_bd_port -dir O pmod_spi_clk]
  set pmod_spi_convst     [create_bd_port -dir O pmod_spi_convst]

  set pmod_gpio           [create_bd_port -dir I pmod_gpio]

  # interrupts
  set pmod_spi_dma_intr   [create_bd_port -dir O pmod_spi_dma_intr]

  # instances

  set pmod_spi_core [create_bd_cell -type ip -vlnv analog.com:user:util_pmod_adc:1.0 pmod_spi_core]
  set_property -dict [list CONFIG.FPGA_CLOCK_MHZ {100}] $pmod_spi_core

  set pmod_spi_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 pmod_spi_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $pmod_spi_dma
  set_property -dict [list CONFIG.PCORE_ID {0}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {16}] $pmod_spi_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $pmod_spi_dma

  set pmod_spi_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 pmod_spi_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $pmod_spi_dma_interconnect

  set pmod_gpio_core [create_bd_cell -type ip -vlnv analog.com:user:util_pmod_fmeter:1.0 pmod_gpio_core]

  # additional configurations
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
  set_property -dict [list CONFIG.NUM_MI {9}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ $adc_spi_freq] $sys_ps7

  # up axi interface connection
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07  [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins pmod_spi_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08  [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins pmod_gpio_core/s_axi]
  connect_bd_intf_net -intf_net pmod_spi_dma_interconnect_m00_axi [get_bd_intf_pins pmod_spi_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
  connect_bd_intf_net -intf_net pmod_spi_dma_interconnect_s00_axi [get_bd_intf_pins pmod_spi_dma_interconnect/S00_AXI] [get_bd_intf_pins pmod_spi_dma/m_dest_axi]

  set adc_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]

  connect_bd_net -net adc_clk      $adc_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_spi_dma_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_spi_dma_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_spi_dma_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_spi_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_spi_dma/fifo_wr_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_spi_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_spi_core/clk] $sys_100m_clk_source
  connect_bd_net -net adc_clk      [get_bd_pins pmod_spi_core/adc_spi_clk] $adc_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_gpio_core/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins pmod_gpio_core/ref_clk] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins pmod_spi_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins pmod_spi_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins pmod_spi_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins pmod_spi_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins pmod_spi_dma/m_dest_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_reset  [get_bd_pins pmod_spi_core/reset] [get_bd_pins sys_rstgen/peripheral_reset]
  connect_bd_net -net sys_100m_resetn [get_bd_pins pmod_gpio_core/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net pmod_spi_data     [get_bd_pins pmod_spi_core/adc_data]        [get_bd_pins pmod_spi_dma/fifo_wr_din]
  connect_bd_net -net pmod_spi_dvalid   [get_bd_pins pmod_spi_core/adc_valid]       [get_bd_pins pmod_spi_dma/fifo_wr_en]

  connect_bd_net -net pmod_spi_sdo      [get_bd_pins pmod_spi_core/adc_sdo]         [get_bd_ports pmod_spi_miso]
  connect_bd_net -net pmod_spi_sclk     [get_bd_pins pmod_spi_core/adc_sclk]        [get_bd_ports pmod_spi_clk]
  connect_bd_net -net pmod_spi_csn      [get_bd_pins pmod_spi_core/adc_cs_n]        [get_bd_ports pmod_spi_cs]
  connect_bd_net -net pmod_spi_convstn  [get_bd_pins pmod_spi_core/adc_convst_n]    [get_bd_ports pmod_spi_convst]

  connect_bd_net -net pmod_gpio_in      [get_bd_pins pmod_gpio_core/square_signal]  [get_bd_ports pmod_gpio]

  connect_bd_net -net pmod_spi_dma_irq  [get_bd_pins pmod_spi_dma/irq] [get_bd_ports pmod_spi_dma_intr]

  # address map

  create_bd_addr_seg -range 0x00010000 -offset 0x43010000 $sys_addr_cntrl_space   [get_bd_addr_segs pmod_spi_dma/s_axi/axi_lite]     SEG_data_pmod_spi_dma
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 $sys_addr_cntrl_space   [get_bd_addr_segs pmod_gpio_core/s_axi/axi_lite]     SEG_data_pmod_gpio

  create_bd_addr -range $sys_mem_size -offset 0x00000000  [get_bd_addr_spaces pmod_spi_dma/m_dest_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm

