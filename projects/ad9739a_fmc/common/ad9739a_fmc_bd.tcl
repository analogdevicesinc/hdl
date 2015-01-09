
  # dac interface

  set dac_clk_in_p      [create_bd_port -dir I dac_clk_in_p]
  set dac_clk_in_n      [create_bd_port -dir I dac_clk_in_n]
  set dac_clk_out_p     [create_bd_port -dir O dac_clk_out_p]
  set dac_clk_out_n     [create_bd_port -dir O dac_clk_out_n]
  set dac_data_out_a_p  [create_bd_port -dir O -from 13 -to 0 dac_data_out_a_p]
  set dac_data_out_a_n  [create_bd_port -dir O -from 13 -to 0 dac_data_out_a_n]
  set dac_data_out_b_p  [create_bd_port -dir O -from 13 -to 0 dac_data_out_b_p]
  set dac_data_out_b_n  [create_bd_port -dir O -from 13 -to 0 dac_data_out_b_n]

  set spi_csn_1_o     [create_bd_port -dir O spi_csn_1_o]
  set spi_csn_0_o     [create_bd_port -dir O spi_csn_0_o]
  set spi_csn_i       [create_bd_port -dir I spi_csn_i]
  set spi_clk_i       [create_bd_port -dir I spi_clk_i]
  set spi_clk_o       [create_bd_port -dir O spi_clk_o]
  set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
  set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
  set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

  # interrupts

  set ad9739a_dma_irq  [create_bd_port -dir O ad9739a_dma_irq]

  # dac peripherals

  set axi_ad9739a [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9739a:1.0 axi_ad9739a]

  set axi_ad9739a_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9739a_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_FIFO_SIZE {64}] $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {1}] $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {1}]  $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {256}] $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {256}] $axi_ad9739a_dma
  set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_SRC {1}] $axi_ad9739a_dma

  # additions to default configuration

  set_property -dict [list CONFIG.NUM_MI {9}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7

  # connections (dac)

  connect_bd_net -net axi_ad9739a_dac_clk_in_p        [get_bd_ports dac_clk_in_p]             [get_bd_pins axi_ad9739a/dac_clk_in_p]
  connect_bd_net -net axi_ad9739a_dac_clk_in_n        [get_bd_ports dac_clk_in_n]             [get_bd_pins axi_ad9739a/dac_clk_in_n]
  connect_bd_net -net axi_ad9739a_dac_clk_out_p       [get_bd_ports dac_clk_out_p]            [get_bd_pins axi_ad9739a/dac_clk_out_p]
  connect_bd_net -net axi_ad9739a_dac_clk_out_n       [get_bd_ports dac_clk_out_n]            [get_bd_pins axi_ad9739a/dac_clk_out_n]
  connect_bd_net -net axi_ad9739a_dac_data_out_a_p    [get_bd_ports dac_data_out_a_p]         [get_bd_pins axi_ad9739a/dac_data_out_a_p]
  connect_bd_net -net axi_ad9739a_dac_data_out_a_n    [get_bd_ports dac_data_out_a_n]         [get_bd_pins axi_ad9739a/dac_data_out_a_n]
  connect_bd_net -net axi_ad9739a_dac_data_out_b_p    [get_bd_ports dac_data_out_b_p]         [get_bd_pins axi_ad9739a/dac_data_out_b_p]
  connect_bd_net -net axi_ad9739a_dac_data_out_b_n    [get_bd_ports dac_data_out_b_n]         [get_bd_pins axi_ad9739a/dac_data_out_b_n]
  connect_bd_net -net axi_ad9739a_dac_div_clk         [get_bd_pins axi_ad9739a/dac_div_clk]   [get_bd_pins axi_ad9739a_dma/fifo_rd_clk]
  connect_bd_net -net axi_ad9739a_dac_valid           [get_bd_pins axi_ad9739a/dac_valid]     [get_bd_pins axi_ad9739a_dma/fifo_rd_en]  
  connect_bd_net -net axi_ad9739a_dac_ddata           [get_bd_pins axi_ad9739a/dac_ddata]     [get_bd_pins axi_ad9739a_dma/fifo_rd_dout]
  connect_bd_net -net axi_ad9739a_dac_dunf            [get_bd_pins axi_ad9739a/dac_dunf]      [get_bd_pins axi_ad9739a_dma/fifo_rd_underflow]
  connect_bd_net -net axi_ad9739a_dma_irq             [get_bd_pins axi_ad9739a_dma/irq]       [get_bd_ports ad9739a_dma_irq]

  # interconnect (cpu)

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9739a/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9739a_dma/s_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9739a/s_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9739a_dma/s_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9739a/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9739a_dma/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source

  # interconnect (mem/dac)

  set axi_ad9739a_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9739a_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9739a_dma_interconnect

  connect_bd_intf_net -intf_net axi_ad9739a_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9739a_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_ad9739a_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9739a_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9739a_dma/m_src_axi]
  connect_bd_net -net axi_ad9739a_dac_div_clk [get_bd_pins axi_ad9739a_dma_interconnect/ACLK] [get_bd_pins axi_ad9739a/dac_div_clk]
  connect_bd_net -net axi_ad9739a_dac_div_clk [get_bd_pins axi_ad9739a_dma_interconnect/M00_ACLK] [get_bd_pins axi_ad9739a/dac_div_clk]
  connect_bd_net -net axi_ad9739a_dac_div_clk [get_bd_pins axi_ad9739a_dma_interconnect/S00_ACLK] [get_bd_pins axi_ad9739a/dac_div_clk]
  connect_bd_net -net axi_ad9739a_dac_div_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
  connect_bd_net -net axi_ad9739a_dac_div_clk [get_bd_pins axi_ad9739a_dma/m_src_axi_aclk] 
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9739a_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9739a_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9739a_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9739a_dma/m_src_axi_aresetn] 

  # spi

  connect_bd_net -net spi_csn_1_o [get_bd_ports spi_csn_1_o]  [get_bd_pins sys_ps7/SPI0_SS1_O]
  connect_bd_net -net spi_csn_0_o [get_bd_ports spi_csn_0_o]  [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]    [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi_clk_i   [get_bd_ports spi_clk_i]    [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi_clk_o   [get_bd_ports spi_clk_o]    [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net spi_sdo_i   [get_bd_ports spi_sdo_i]    [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi_sdo_o   [get_bd_ports spi_sdo_o]    [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi_sdi_i   [get_bd_ports spi_sdi_i]    [get_bd_pins sys_ps7/SPI0_MISO_I]

  # address map

  create_bd_addr_seg -range 0x00010000 -offset 0x74200000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9739a/s_axi/axi_lite]      SEG_data_ad9739a
  create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9739a_dma/s_axi/axi_lite]  SEG_data_ad9739a_dma
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9739a_dma/m_src_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm

