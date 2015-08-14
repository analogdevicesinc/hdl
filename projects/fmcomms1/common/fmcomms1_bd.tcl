
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

  # dma interface

  create_bd_port -dir O dac_clk
  create_bd_port -dir O dac_valid_0
  create_bd_port -dir O dac_enable_0
  create_bd_port -dir I -from 63 -to 0 dac_ddata_0
  create_bd_port -dir O dac_valid_1
  create_bd_port -dir O dac_enable_1
  create_bd_port -dir I -from 63 -to 0 dac_ddata_1
  create_bd_port -dir I dac_dma_rd
  create_bd_port -dir O -from 63 -to 0 dac_dma_rdata

  create_bd_port -dir O adc_clk
  create_bd_port -dir O adc_valid_0
  create_bd_port -dir O adc_enable_0
  create_bd_port -dir O -from 15 -to 0 adc_data_0
  create_bd_port -dir O adc_valid_1
  create_bd_port -dir O adc_enable_1
  create_bd_port -dir O -from 15 -to 0 adc_data_1
  create_bd_port -dir I adc_dma_wr
  create_bd_port -dir I -from 31 -to 0 adc_dma_wdata

  # dac peripherals

  set axi_ad9122 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9122:1.0 axi_ad9122]

  set axi_ad9122_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9122_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_FIFO_SIZE {16}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {1}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {1}]  $axi_ad9122_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9122_dma

  # adc peripherals

  set axi_ad9643 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9643:1.0 axi_ad9643]

  set axi_ad9643_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9643_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_FIFO_SIZE {16}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_DEST {1}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_AXI_SLICE_SRC {1}]  $axi_ad9643_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9643_dma

  # reference clock

  set refclk_clkgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 refclk_clkgen]
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

  ad_connect dac_clk_in_p     axi_ad9122/dac_clk_in_p
  ad_connect dac_clk_in_n     axi_ad9122/dac_clk_in_n
  ad_connect dac_clk_out_p    axi_ad9122/dac_clk_out_p
  ad_connect dac_clk_out_n    axi_ad9122/dac_clk_out_n
  ad_connect dac_frame_out_p  axi_ad9122/dac_frame_out_p
  ad_connect dac_frame_out_n  axi_ad9122/dac_frame_out_n
  ad_connect dac_data_out_p   axi_ad9122/dac_data_out_p
  ad_connect dac_data_out_n   axi_ad9122/dac_data_out_n

  ad_connect axi_ad9122/dac_valid_0   dac_valid_0
  ad_connect axi_ad9122/dac_enable_0  dac_enable_0
  ad_connect axi_ad9122/dac_ddata_0   dac_ddata_0
  ad_connect axi_ad9122/dac_valid_1   dac_valid_1
  ad_connect axi_ad9122/dac_enable_1  dac_enable_1
  ad_connect axi_ad9122/dac_ddata_1   dac_ddata_1
  ad_connect axi_ad9122/dac_dunf      axi_ad9122_dma/fifo_rd_underflow

  ad_connect dac_dma_rd     axi_ad9122_dma/fifo_rd_en
  ad_connect dac_dma_rdata  axi_ad9122_dma/fifo_rd_dout

  # connections (adc)

  p_sys_wfifo [current_bd_instance .] sys_wfifo 32 64

  ad_connect  adc_clk             axi_ad9643/adc_clk
  ad_connect  adc_clk             sys_wfifo/adc_clk
  ad_connect  sys_200m_clk        axi_ad9643/delay_clk
  ad_connect  sys_200m_clk        axi_ad9643_dma/fifo_wr_clk
  ad_connect  sys_200m_clk        sys_wfifo/dma_clk
  ad_connect  axi_ad9643/adc_rst  sys_wfifo/adc_rst

  ad_connect  adc_clk_in_p  axi_ad9643/adc_clk_in_p
  ad_connect  adc_clk_in_n  axi_ad9643/adc_clk_in_n
  ad_connect  adc_or_in_p   axi_ad9643/adc_or_in_p
  ad_connect  adc_or_in_n   axi_ad9643/adc_or_in_n
  ad_connect  adc_data_in_p axi_ad9643/adc_data_in_p
  ad_connect  adc_data_in_n axi_ad9643/adc_data_in_n

  ad_connect  adc_valid_0         axi_ad9643/adc_valid_0
  ad_connect  adc_enable_0        axi_ad9643/adc_enable_0
  ad_connect  adc_data_0          axi_ad9643/adc_data_0
  ad_connect  adc_valid_1         axi_ad9643/adc_valid_1
  ad_connect  adc_enable_1        axi_ad9643/adc_enable_1
  ad_connect  adc_data_1          axi_ad9643/adc_data_1
  ad_connect  axi_ad9643/adc_dovf sys_wfifo/adc_wovf

  ad_connect  adc_dma_wr    sys_wfifo/adc_wr
  ad_connect  adc_dma_wdata sys_wfifo/adc_wdata

  ad_connect  sys_wfifo/dma_wr     axi_ad9643_dma/fifo_wr_en
  ad_connect  sys_wfifo/dma_wdata  axi_ad9643_dma/fifo_wr_din
  ad_connect  sys_wfifo/dma_wovf   axi_ad9643_dma/fifo_wr_overflow

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

  # ila (adc)

  set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_adc]
  set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc
  set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc
  set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc
  set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}] $ila_adc
  set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]  $ila_adc
  set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc

  ad_connect sys_200m_clk         ila_adc/clk
  ad_connect sys_wfifo/dma_wr     ila_adc/PROBE0
  ad_connect sys_wfifo/dma_wdata  ila_adc/PROBE1

