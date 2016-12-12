
  # dac interface

  create_bd_port -dir I dac_clk_in_p
  create_bd_port -dir I dac_clk_in_n
  create_bd_port -dir O dac_clk_out_p
  create_bd_port -dir O dac_clk_out_n
  create_bd_port -dir O dac_frame_out_p
  create_bd_port -dir O dac_frame_out_n
  create_bd_port -dir O -from 15 -to 0 dac_data_out_p
  create_bd_port -dir O -from 15 -to 0 dac_data_out_n

  # adc interface

  create_bd_port -dir I adc_clk_in_p
  create_bd_port -dir I adc_clk_in_n
  create_bd_port -dir I adc_or_in_p
  create_bd_port -dir I adc_or_in_n
  create_bd_port -dir I -from 13 -to 0 adc_data_in_p
  create_bd_port -dir I -from 13 -to 0 adc_data_in_n

  # reference clock

  create_bd_port -dir O ref_clk

  # dac peripherals

  set axi_ad9122 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9122:1.0 axi_ad9122]

  set axi_ad9122_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9122_dma]
  set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9122_dma
  set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $axi_ad9122_dma
  set_property -dict [list CONFIG.FIFO_SIZE {16}] $axi_ad9122_dma
  set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9122_dma
  set_property -dict [list CONFIG.CYCLIC {1}] $axi_ad9122_dma
  set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_ad9122_dma
  set_property -dict [list CONFIG.AXI_SLICE_SRC {1}]  $axi_ad9122_dma
  set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {128}] $axi_ad9122_dma

  set util_upack_ad9122 [create_bd_cell -type ip -vlnv analog.com:user:util_upack:1.0 util_upack_ad9122]
  set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {64}] $util_upack_ad9122
  set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_upack_ad9122

  # adc peripherals

  set axi_ad9643 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9643:1.0 axi_ad9643]

  set axi_ad9643_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9643_dma]
  set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9643_dma
  set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.FIFO_SIZE {16}] $axi_ad9643_dma
  set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9643_dma
  set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_ad9643_dma
  set_property -dict [list CONFIG.AXI_SLICE_SRC {1}]  $axi_ad9643_dma
  set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad9643_dma

  set util_cpack_ad9643 [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_cpack_ad9643]
  set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {32}] $util_cpack_ad9643
  set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_cpack_ad9643

  set util_ad9643_adc_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 util_ad9643_adc_fifo]
  set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_ad9643_adc_fifo
  set_property -dict [list CONFIG.DIN_ADDRESS_WIDTH {4}] $util_ad9643_adc_fifo
  set_property -dict [list CONFIG.DIN_DATA_WIDTH {16}] $util_ad9643_adc_fifo
  set_property -dict [list CONFIG.DOUT_DATA_WIDTH {32}] $util_ad9643_adc_fifo

  # reference clock

  set refclk_clkgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 refclk_clkgen]
  set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {30} ] $refclk_clkgen
  set_property -dict [list CONFIG.USE_PHASE_ALIGNMENT {false} ] $refclk_clkgen
  set_property -dict [list CONFIG.JITTER_SEL {Min_O_Jitter} ] $refclk_clkgen
  set_property -dict [list CONFIG.USE_LOCKED {false} ] $refclk_clkgen
  set_property -dict [list CONFIG.USE_RESET {false} ] $refclk_clkgen

  # reference clock connections

  ad_connect sys_200m_clk refclk_clkgen/clk_in1
  ad_connect ref_clk      refclk_clkgen/clk_out1

  # connections (dac)

  ad_connect dac_clk axi_ad9122/dac_div_clk
  ad_connect dac_clk axi_ad9122_dma/fifo_rd_clk
  ad_connect dac_clk util_upack_ad9122/dac_clk

  ad_connect dac_clk_in_p     axi_ad9122/dac_clk_in_p
  ad_connect dac_clk_in_n     axi_ad9122/dac_clk_in_n
  ad_connect dac_clk_out_p    axi_ad9122/dac_clk_out_p
  ad_connect dac_clk_out_n    axi_ad9122/dac_clk_out_n
  ad_connect dac_frame_out_p  axi_ad9122/dac_frame_out_p
  ad_connect dac_frame_out_n  axi_ad9122/dac_frame_out_n
  ad_connect dac_data_out_p   axi_ad9122/dac_data_out_p
  ad_connect dac_data_out_n   axi_ad9122/dac_data_out_n

  ad_connect axi_ad9122/dac_valid_0   util_upack_ad9122/dac_valid_0
  ad_connect axi_ad9122/dac_enable_0  util_upack_ad9122/dac_enable_0
  ad_connect axi_ad9122/dac_ddata_0   util_upack_ad9122/dac_data_0
  ad_connect axi_ad9122/dac_valid_1   util_upack_ad9122/dac_valid_1
  ad_connect axi_ad9122/dac_enable_1  util_upack_ad9122/dac_enable_1
  ad_connect axi_ad9122/dac_ddata_1   util_upack_ad9122/dac_data_1
  ad_connect axi_ad9122/dac_dunf      axi_ad9122_dma/fifo_rd_underflow

  ad_connect util_upack_ad9122/dac_valid  axi_ad9122_dma/fifo_rd_en
  ad_connect util_upack_ad9122/dac_data   axi_ad9122_dma/fifo_rd_dout
  ad_connect util_upack_ad9122/dac_sync   axi_ad9122/dac_sync_in

  # connections (adc)

  ad_connect  adc_clk             axi_ad9643/adc_clk
  ad_connect  adc_clk             util_ad9643_adc_fifo/din_clk
  ad_connect  sys_200m_clk        util_cpack_ad9643/adc_clk
  ad_connect  sys_200m_clk        axi_ad9643/delay_clk
  ad_connect  sys_200m_clk        axi_ad9643_dma/fifo_wr_clk
  ad_connect  sys_200m_clk        util_ad9643_adc_fifo/dout_clk
  ad_connect  adc_rst             axi_ad9643/adc_rst
  ad_connect  adc_rst             util_ad9643_adc_fifo/din_rst
  ad_connect  sys_cpu_resetn      util_ad9643_adc_fifo/dout_rstn
  ad_connect  sys_cpu_reset       util_cpack_ad9643/adc_rst

  ad_connect  adc_clk_in_p  axi_ad9643/adc_clk_in_p
  ad_connect  adc_clk_in_n  axi_ad9643/adc_clk_in_n
  ad_connect  adc_or_in_p   axi_ad9643/adc_or_in_p
  ad_connect  adc_or_in_n   axi_ad9643/adc_or_in_n
  ad_connect  adc_data_in_p axi_ad9643/adc_data_in_p
  ad_connect  adc_data_in_n axi_ad9643/adc_data_in_n

  ad_connect  axi_ad9643/adc_valid_0  util_ad9643_adc_fifo/din_valid_0
  ad_connect  axi_ad9643/adc_enable_0 util_ad9643_adc_fifo/din_enable_0
  ad_connect  axi_ad9643/adc_data_0   util_ad9643_adc_fifo/din_data_0
  ad_connect  axi_ad9643/adc_valid_1  util_ad9643_adc_fifo/din_valid_1
  ad_connect  axi_ad9643/adc_enable_1 util_ad9643_adc_fifo/din_enable_1
  ad_connect  axi_ad9643/adc_data_1   util_ad9643_adc_fifo/din_data_1

  ad_connect  util_ad9643_adc_fifo/dout_valid_0   util_cpack_ad9643/adc_valid_0
  ad_connect  util_ad9643_adc_fifo/dout_enable_0  util_cpack_ad9643/adc_enable_0
  ad_connect  util_ad9643_adc_fifo/dout_data_0    util_cpack_ad9643/adc_data_0
  ad_connect  util_ad9643_adc_fifo/dout_valid_1   util_cpack_ad9643/adc_valid_1
  ad_connect  util_ad9643_adc_fifo/dout_enable_1  util_cpack_ad9643/adc_enable_1
  ad_connect  util_ad9643_adc_fifo/dout_data_1    util_cpack_ad9643/adc_data_1

  ad_connect  util_ad9643_adc_fifo/din_ovf    axi_ad9643/adc_dovf

  ad_connect  util_cpack_ad9643/adc_valid     axi_ad9643_dma/fifo_wr_en
  ad_connect  util_cpack_ad9643/adc_sync      axi_ad9643_dma/fifo_wr_sync
  ad_connect  util_cpack_ad9643/adc_data      axi_ad9643_dma/fifo_wr_din
  ad_connect  util_ad9643_adc_fifo/dout_ovf   axi_ad9643_dma/fifo_wr_overflow

  ad_connect  sys_cpu_resetn axi_ad9122_dma/m_src_axi_aresetn
  ad_connect  sys_cpu_resetn axi_ad9643_dma/m_dest_axi_aresetn

  # address map

  ad_cpu_interconnect 0x74200000  axi_ad9122
  ad_cpu_interconnect 0x79020000  axi_ad9643
  ad_cpu_interconnect 0x7c400000  axi_ad9643_dma
  ad_cpu_interconnect 0x7c420000  axi_ad9122_dma
  ad_mem_hp1_interconnect sys_200m_clk sys_ps7/S_AXI_HP1
  ad_mem_hp1_interconnect sys_200m_clk axi_ad9643_dma/m_dest_axi
  ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
  ad_mem_hp2_interconnect sys_200m_clk axi_ad9122_dma/m_src_axi

  # interrupts

  ad_cpu_interrupt ps-12 mb-12 axi_ad9122_dma/irq
  ad_cpu_interrupt ps-13 mb-13 axi_ad9643_dma/irq

