
  # pmod interface
  set pmod_cs         [create_bd_port -dir O pmod_cs]
  set pmod_miso       [create_bd_port -dir I pmod_miso]
  set pmod_clk        [create_bd_port -dir O pmod_clk]
  set pmod_convst     [create_bd_port -dir O pmod_convst]

  # interrupts
  set ad_ad7091r_dma_intr  [create_bd_port -dir O ad_ad7091r_dma_intr]

  # instances

  set ad_ad7091r_core [create_bd_cell -type ip -vlnv analog.com:user:util_pmod_adc:1.0 ad_ad7091r_core]

  set ad_ad7091r_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 ad_ad7091r_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.PCORE_ID {0}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {16}] $ad_ad7091r_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $ad_ad7091r_dma

  set ad_ad7091r_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ad_ad7091r_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $ad_ad7091r_dma_interconnect

  # additional configurations
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
  set_property -dict [list CONFIG.NUM_MI {8}] $axi_cpu_interconnect

  # up axi interface connection
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07  [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins ad_ad7091r_dma/s_axi]
  connect_bd_intf_net -intf_net ad_ad7091r_dma_interconnect_m00_axi [get_bd_intf_pins ad_ad7091r_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
  connect_bd_intf_net -intf_net ad_ad7091r_dma_interconnect_s00_axi [get_bd_intf_pins ad_ad7091r_dma_interconnect/S00_AXI] [get_bd_intf_pins ad_ad7091r_dma/m_dest_axi]

  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins ad_ad7091r_dma_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins ad_ad7091r_dma_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins ad_ad7091r_dma_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins ad_ad7091r_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins ad_ad7091r_dma/fifo_wr_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins ad_ad7091r_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins ad_ad7091r_core/clk] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins ad_ad7091r_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins ad_ad7091r_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins ad_ad7091r_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins ad_ad7091r_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins ad_ad7091r_dma/m_dest_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_reset [get_bd_pins ad_ad7091r_core/reset] [get_bd_pins sys_rstgen/peripheral_reset]

  connect_bd_net -net ad_ad7091r_data   [get_bd_pins ad_ad7091r_core/adc_data] [get_bd_pins ad_ad7091r_dma/fifo_wr_din]
  connect_bd_net -net ad_ad7091r_dvalid [get_bd_pins ad_ad7091r_core/adc_valid] [get_bd_pins ad_ad7091r_dma/fifo_wr_en]

  connect_bd_net -net ad_ad7091r_sdo      [get_bd_pins ad_ad7091r_core/adc_sdo]       [get_bd_ports pmod_miso]
  connect_bd_net -net ad_ad7091r_sclk     [get_bd_pins ad_ad7091r_core/adc_sclk]      [get_bd_ports pmod_clk]
  connect_bd_net -net ad_ad7091r_csn      [get_bd_pins ad_ad7091r_core/adc_cs_n]      [get_bd_ports pmod_cs]
  connect_bd_net -net ad_ad7091r_convstn  [get_bd_pins ad_ad7091r_core/adc_convst_n]  [get_bd_ports pmod_convst]

  connect_bd_net -net ad_ad7091r_dma_irq  [get_bd_pins ad_ad7091r_dma/irq] [get_bd_ports ad_ad7091r_dma_intr]

  # address map

  create_bd_addr_seg -range 0x00010000 -offset 0x43010000 $sys_addr_cntrl_space   [get_bd_addr_segs ad_ad7091r_dma/s_axi/axi_lite]     SEG_data_ad_ad7091r_dma

  create_bd_addr -range $sys_mem_size -offset 0x00000000  [get_bd_addr_spaces ad_ad7091r_dma/m_dest_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm

