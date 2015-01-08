
  # adv7511

  set fmc_hdmi_rx_clk       [create_bd_port -dir I  fmc_hdmi_rx_clk]
  set fmc_hdmi_rx_data      [create_bd_port -dir I  -from 15 -to 0 fmc_hdmi_rx_data]

  # adv7611

  set fmc_hdmi_tx_clk       [create_bd_port -dir O  fmc_hdmi_tx_clk]
  set fmc_hdmi_tx_spdif     [create_bd_port -dir O  fmc_hdmi_tx_spdif]
  set fmc_hdmi_tx_data      [create_bd_port -dir O -from 15 -to 0 fmc_hdmi_tx_data]

  # hdmi interrupt

  set fmc_hdmi_tx_dma_intr  [create_bd_port -dir O fmc_hdmi_tx_dma_intr]
  set fmc_hdmi_rx_dma_intr  [create_bd_port -dir O fmc_hdmi_rx_dma_intr]
  set fmc_hdmi_iic_intr     [create_bd_port -dir O fmc_hdmi_iic_intr]

  # iic interface

  set IIC_FMC [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_FMC]
  set fmc_iic_rstn          [create_bd_port -dir O fmc_iic_rstn]

  # fmc hdmi peripherals

  set fmc_hdmi_tx_core  [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 fmc_hdmi_tx_core]
  set fmc_hdmi_rx_core  [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_rx:1.0 fmc_hdmi_rx_core]

  set fmc_hdmi_tx_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 fmc_hdmi_tx_dma]
  set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $fmc_hdmi_tx_dma
  set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $fmc_hdmi_tx_dma
  set_property -dict [list CONFIG.c_include_s2mm {0}] $fmc_hdmi_tx_dma

  set fmc_hdmi_rx_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 fmc_hdmi_rx_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {1}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {1}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {14}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $fmc_hdmi_rx_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $fmc_hdmi_rx_dma

  set fmc_hdmi_tx_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 fmc_hdmi_tx_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $fmc_hdmi_tx_interconnect

  set fmc_hdmi_rx_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 fmc_hdmi_rx_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $fmc_hdmi_rx_interconnect

  set fmc_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 fmc_spdif_tx_core]
  set_property -dict [list CONFIG.C_DMA_TYPE {1}] $fmc_spdif_tx_core
  set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $fmc_spdif_tx_core

  set axi_iic_fmc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_fmc]
  set_property -dict [list CONFIG.USE_BOARD_FLOW {true} CONFIG.IIC_BOARD_INTERFACE {IIC_FMC}] $axi_iic_fmc

  # additions to default configurations

  set_property -dict [list CONFIG.NUM_MI {13}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_DMA1 {1}] $sys_ps7

  # up axi interface connections

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07  [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins fmc_hdmi_tx_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08  [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins fmc_hdmi_rx_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09  [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins fmc_hdmi_tx_dma/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10  [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins fmc_hdmi_rx_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m11  [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins fmc_spdif_tx_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m12  [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_iic_fmc/s_axi]

  connect_bd_net -net sys_100m_clk  [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source


  # fmc hdmi tx data path

  connect_bd_intf_net -intf fmc_hdmi_tx_interconnect_s00  [get_bd_intf_pins fmc_hdmi_tx_interconnect/S00_AXI] [get_bd_intf_pins fmc_hdmi_tx_dma/M_AXI_MM2S]
  connect_bd_intf_net -intf fmc_hdmi_tx_interconnect_m00  [get_bd_intf_pins fmc_hdmi_tx_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]

  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_tx_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_tx_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_tx_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_tx_dma/s_axi_lite_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_tx_dma/m_axi_mm2s_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_tx_dma/m_axis_mm2s_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_tx_core/m_axis_mm2s_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_tx_core/s_axi_aclk] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_tx_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_tx_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_tx_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_tx_dma/axi_resetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_tx_core/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net axi_hdmi_tx_core_hdmi_clk      [get_bd_pins fmc_hdmi_tx_core/hdmi_clk]              [get_bd_pins axi_hdmi_clkgen/clk_0]
  connect_bd_net -net fmc_hdmi_tx_core_hdmi_out_clk  [get_bd_pins fmc_hdmi_tx_core/hdmi_out_clk]          [get_bd_ports fmc_hdmi_tx_clk]
  connect_bd_net -net fmc_hdmi_tx_core_hdmi_data     [get_bd_pins fmc_hdmi_tx_core/hdmi_16_es_data]       [get_bd_ports fmc_hdmi_tx_data]
  connect_bd_net -net fmc_hdmi_tx_core_mm2s_tvalid   [get_bd_pins fmc_hdmi_tx_core/m_axis_mm2s_tvalid]    [get_bd_pins fmc_hdmi_tx_dma/m_axis_mm2s_tvalid]
  connect_bd_net -net fmc_hdmi_tx_core_mm2s_tdata    [get_bd_pins fmc_hdmi_tx_core/m_axis_mm2s_tdata]     [get_bd_pins fmc_hdmi_tx_dma/m_axis_mm2s_tdata]
  connect_bd_net -net fmc_hdmi_tx_core_mm2s_tkeep    [get_bd_pins fmc_hdmi_tx_core/m_axis_mm2s_tkeep]     [get_bd_pins fmc_hdmi_tx_dma/m_axis_mm2s_tkeep]
  connect_bd_net -net fmc_hdmi_tx_core_mm2s_tlast    [get_bd_pins fmc_hdmi_tx_core/m_axis_mm2s_tlast]     [get_bd_pins fmc_hdmi_tx_dma/m_axis_mm2s_tlast]
  connect_bd_net -net fmc_hdmi_tx_core_mm2s_tready   [get_bd_pins fmc_hdmi_tx_core/m_axis_mm2s_tready]    [get_bd_pins fmc_hdmi_tx_dma/m_axis_mm2s_tready]
  connect_bd_net -net fmc_hdmi_tx_core_mm2s_fsync    [get_bd_pins fmc_hdmi_tx_core/m_axis_mm2s_fsync]     [get_bd_pins fmc_hdmi_tx_dma/mm2s_fsync]
  connect_bd_net -net fmc_hdmi_tx_core_mm2s_fsync    [get_bd_pins fmc_hdmi_tx_core/m_axis_mm2s_fsync_ret]

  # fmc hdmi rx data path

  connect_bd_intf_net -intf fmc_hdmi_rx_interconnect_s00  [get_bd_intf_pins fmc_hdmi_rx_interconnect/S00_AXI] [get_bd_intf_pins fmc_hdmi_rx_dma/m_dest_axi]
  connect_bd_intf_net -intf fmc_hdmi_rx_interconnect_m00  [get_bd_intf_pins fmc_hdmi_rx_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]

  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_rx_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_rx_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_rx_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins sys_ps7/S_AXI_HP2_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_rx_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_rx_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_hdmi_rx_core/s_axi_aclk] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_rx_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_rx_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_rx_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_rx_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_rx_dma/m_dest_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins fmc_hdmi_rx_core/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net hdmi_rx_fifo_wr_data    [get_bd_pins fmc_hdmi_rx_core/video_data]     [get_bd_pins fmc_hdmi_rx_dma/fifo_wr_din]
  connect_bd_net -net hdmi_rx_fifo_wr_dvalid  [get_bd_pins fmc_hdmi_rx_core/video_valid]    [get_bd_pins fmc_hdmi_rx_dma/fifo_wr_en]
  connect_bd_net -net hdmi_rx_fifo_wr_clk     [get_bd_pins fmc_hdmi_rx_core/video_clk]      [get_bd_pins fmc_hdmi_rx_dma/fifo_wr_clk]
  connect_bd_net -net hdmi_rx_fifo_wr_sync    [get_bd_pins fmc_hdmi_rx_core/video_sync]     [get_bd_pins fmc_hdmi_rx_dma/fifo_wr_sync]
  connect_bd_net -net hdmi_rx_fifo_overflow   [get_bd_pins fmc_hdmi_rx_core/video_overflow] [get_bd_pins fmc_hdmi_rx_dma/fifo_wr_overflow]

  connect_bd_net -net fmc_hdmi_rx_core_clk    [get_bd_pins fmc_hdmi_rx_core/hdmi_clk]       [get_bd_ports fmc_hdmi_rx_clk]
  connect_bd_net -net fmc_hdmi_rx_core_data   [get_bd_pins fmc_hdmi_rx_core/hdmi_data]      [get_bd_ports fmc_hdmi_rx_data]

  # fmc spdif audio

  connect_bd_intf_net -intf_net fmc_spdif_dma_req_tx [get_bd_intf_pins sys_ps7/DMA1_REQ] [get_bd_intf_pins fmc_spdif_tx_core/DMA_REQ]
  connect_bd_intf_net -intf_net fmc_spdif_dma_ack_tx [get_bd_intf_pins sys_ps7/DMA1_ACK] [get_bd_intf_pins fmc_spdif_tx_core/DMA_ACK]

  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_spdif_tx_core/S_AXI_ACLK]
  connect_bd_net -net sys_100m_clk  [get_bd_pins fmc_spdif_tx_core/DMA_REQ_ACLK]
  connect_bd_net -net sys_100m_clk  [get_bd_pins sys_ps7/DMA1_ACLK]

  connect_bd_net -net sys_100m_resetn [get_bd_pins fmc_spdif_tx_core/S_AXI_ARESETN]
  connect_bd_net -net sys_100m_resetn [get_bd_pins fmc_spdif_tx_core/DMA_REQ_RSTN]

  connect_bd_net -net sys_audio_clkgen_clk [get_bd_pins sys_audio_clkgen/clk_out1] [get_bd_pins fmc_spdif_tx_core/spdif_data_clk]
  connect_bd_net -net fmc_spdif [get_bd_ports fmc_hdmi_tx_spdif] [get_bd_pins fmc_spdif_tx_core/spdif_tx_o]

  # fmc iic connections

  connect_bd_intf_net -intf_net axi_iic_fmc_iic [get_bd_intf_ports IIC_FMC] [get_bd_intf_pins axi_iic_fmc/iic]

  connect_bd_net -net sys_100m_clk    [get_bd_pins axi_iic_fmc/s_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_iic_fmc/s_axi_aresetn]

  connect_bd_net -net fmc_hdmi_iic_rstn   [get_bd_pins axi_iic_fmc/gpo]   [get_bd_ports fmc_iic_rstn]

  # fmc hdmi interrupts

  connect_bd_net -net fmc_hdmi_tx_interrupt   [get_bd_pins fmc_hdmi_tx_dma/mm2s_introut]  [get_bd_ports fmc_hdmi_tx_dma_intr]
  connect_bd_net -net fmc_hdmi_rx_interrupt   [get_bd_pins fmc_hdmi_rx_dma/irq]           [get_bd_ports fmc_hdmi_rx_dma_intr]
  connect_bd_net -net fmc_hdmi_iic_interrupt  [get_bd_pins axi_iic_fmc/iic2intc_irpt]     [get_bd_ports fmc_hdmi_iic_intr]

  # address map

  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 $sys_addr_cntrl_space [get_bd_addr_segs fmc_hdmi_tx_core/s_axi/axi_lite]    SEG_data_fmc_hdmi_tx_core
  create_bd_addr_seg -range 0x00010000 -offset 0x43100000 $sys_addr_cntrl_space [get_bd_addr_segs fmc_hdmi_rx_core/s_axi/axi_lite]    SEG_data_fmc_hdmi_rx_core
  create_bd_addr_seg -range 0x00010000 -offset 0x43010000 $sys_addr_cntrl_space [get_bd_addr_segs fmc_hdmi_tx_dma/S_AXI_LITE/Reg]     SEG_data_fmc_hdmi_tx_dma
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 $sys_addr_cntrl_space [get_bd_addr_segs fmc_hdmi_rx_dma/s_axi/axi_lite]     SEG_data_fmc_hdmi_rx_dma
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 $sys_addr_cntrl_space [get_bd_addr_segs fmc_spdif_tx_core/S_AXI/reg0]       SEG_data_fmc_spdif_tx_core
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 $sys_addr_cntrl_space [get_bd_addr_segs axi_iic_fmc/s_axi/Reg]              SEG_data_fmc_hdmi_iic

  create_bd_addr -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces fmc_hdmi_tx_dma/Data_MM2S]   [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces fmc_hdmi_rx_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm

