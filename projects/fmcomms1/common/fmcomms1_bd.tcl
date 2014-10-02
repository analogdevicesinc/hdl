
  source $ad_hdl_dir/projects/common/xilinx/sys_wfifo.tcl

  # dac interface

  set dac_clk_in_p    [create_bd_port -dir I dac_clk_in_p]
  set dac_clk_in_n    [create_bd_port -dir I dac_clk_in_n]
  set dac_clk_out_p   [create_bd_port -dir O dac_clk_out_p]
  set dac_clk_out_n   [create_bd_port -dir O dac_clk_out_n]
  set dac_frame_out_p [create_bd_port -dir O dac_frame_out_p]
  set dac_frame_out_n [create_bd_port -dir O dac_frame_out_n]
  set dac_data_out_p  [create_bd_port -dir O -from 15 -to 0 dac_data_out_p]
  set dac_data_out_n  [create_bd_port -dir O -from 15 -to 0 dac_data_out_n]

  # adc interface

  set adc_clk_in_p    [create_bd_port -dir I adc_clk_in_p]
  set adc_clk_in_n    [create_bd_port -dir I adc_clk_in_n]
  set adc_or_in_p     [create_bd_port -dir I adc_or_in_p]
  set adc_or_in_n     [create_bd_port -dir I adc_or_in_n]
  set adc_data_in_p   [create_bd_port -dir I -from 13 -to 0 adc_data_in_p]
  set adc_data_in_n   [create_bd_port -dir I -from 13 -to 0 adc_data_in_n]

  # reference clock

  set ref_clk         [create_bd_port -dir O ref_clk]

  # dma interface

  set dac_clk         [create_bd_port -dir O dac_clk]
  set dac_valid_0     [create_bd_port -dir O dac_valid_0]
  set dac_enable_0    [create_bd_port -dir O dac_enable_0]
  set dac_ddata_0     [create_bd_port -dir I -from 63 -to 0 dac_ddata_0]
  set dac_valid_1     [create_bd_port -dir O dac_valid_1]
  set dac_enable_1    [create_bd_port -dir O dac_enable_1]
  set dac_ddata_1     [create_bd_port -dir I -from 63 -to 0 dac_ddata_1]
  set dac_dma_rd      [create_bd_port -dir I dac_dma_rd]
  set dac_dma_rdata   [create_bd_port -dir O -from 63 -to 0 dac_dma_rdata]

  set adc_clk         [create_bd_port -dir O adc_clk]
  set adc_valid_0     [create_bd_port -dir O adc_valid_0]
  set adc_enable_0    [create_bd_port -dir O adc_enable_0]
  set adc_data_0      [create_bd_port -dir O -from 15 -to 0 adc_data_0]
  set adc_valid_1     [create_bd_port -dir O adc_valid_1]
  set adc_enable_1    [create_bd_port -dir O adc_enable_1]
  set adc_data_1      [create_bd_port -dir O -from 15 -to 0 adc_data_1]
  set adc_dma_wr      [create_bd_port -dir I adc_dma_wr]
  set adc_dma_sync    [create_bd_port -dir I adc_dma_sync]
  set adc_dma_wdata   [create_bd_port -dir I -from 31 -to 0 adc_dma_wdata]

  # dac peripherals

  set axi_ad9122 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9122:1.0 axi_ad9122]

  set axi_ad9122_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9122_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9122_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9122_dma

if {$sys_zynq == 1} {
  set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_SRC {1}] $axi_ad9122_dma
}

  # adc peripherals

  set axi_ad9643 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9643:1.0 axi_ad9643]

  set axi_ad9643_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9643_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9643_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9643_dma

if {$sys_zynq == 1} {
  set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_DEST {1}] $axi_ad9643_dma
}

  # additions to default configuration

  set_property -dict [list CONFIG.NUM_MI {11}] $axi_cpu_interconnect

if {$sys_zynq == 0} {
  set_property -dict [list CONFIG.NUM_SI {10}] $axi_mem_interconnect
}

if {$sys_zynq == 1} {
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {125.0}] $sys_ps7
}

if {$sys_zynq == 0} {

  delete_bd_objs [get_bd_nets sys_concat_intc_din_2] [get_bd_ports unc_int2]
  delete_bd_objs [get_bd_nets sys_concat_intc_din_3] [get_bd_ports unc_int3]
}

# reference clock shared with audio clock

  set_property -dict [list CONFIG.CLKOUT2_USED {true}] $sys_audio_clkgen
  set_property -dict [list CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {30}] $sys_audio_clkgen

# connections (dac)

  connect_bd_net -net dac_div_clk [get_bd_ports dac_clk] [get_bd_pins axi_ad9122/dac_div_clk] [get_bd_pins axi_ad9122_dma/fifo_rd_clk]

  connect_bd_net -net axi_ad9122_dac_clk_in_p     [get_bd_ports dac_clk_in_p]                       [get_bd_pins axi_ad9122/dac_clk_in_p]
  connect_bd_net -net axi_ad9122_dac_clk_in_n     [get_bd_ports dac_clk_in_n]                       [get_bd_pins axi_ad9122/dac_clk_in_n]
  connect_bd_net -net axi_ad9122_dac_clk_out_p    [get_bd_ports dac_clk_out_p]                      [get_bd_pins axi_ad9122/dac_clk_out_p]
  connect_bd_net -net axi_ad9122_dac_clk_out_n    [get_bd_ports dac_clk_out_n]                      [get_bd_pins axi_ad9122/dac_clk_out_n]
  connect_bd_net -net axi_ad9122_dac_frame_out_p  [get_bd_ports dac_frame_out_p]                    [get_bd_pins axi_ad9122/dac_frame_out_p]
  connect_bd_net -net axi_ad9122_dac_frame_out_n  [get_bd_ports dac_frame_out_n]                    [get_bd_pins axi_ad9122/dac_frame_out_n]
  connect_bd_net -net axi_ad9122_dac_data_out_p   [get_bd_ports dac_data_out_p]                     [get_bd_pins axi_ad9122/dac_data_out_p]
  connect_bd_net -net axi_ad9122_dac_data_out_n   [get_bd_ports dac_data_out_n]                     [get_bd_pins axi_ad9122/dac_data_out_n]

  connect_bd_net -net axi_ad9122_dac_valid_0      [get_bd_pins axi_ad9122/dac_valid_0]              [get_bd_ports dac_valid_0]
  connect_bd_net -net axi_ad9122_dac_enable_0     [get_bd_pins axi_ad9122/dac_enable_0]             [get_bd_ports dac_enable_0]
  connect_bd_net -net axi_ad9122_dac_ddata_0      [get_bd_pins axi_ad9122/dac_ddata_0]              [get_bd_ports dac_ddata_0] 
  connect_bd_net -net axi_ad9122_dac_valid_1      [get_bd_pins axi_ad9122/dac_valid_1]              [get_bd_ports dac_valid_1]
  connect_bd_net -net axi_ad9122_dac_enable_1     [get_bd_pins axi_ad9122/dac_enable_1]             [get_bd_ports dac_enable_1]
  connect_bd_net -net axi_ad9122_dac_ddata_1      [get_bd_pins axi_ad9122/dac_ddata_1]              [get_bd_ports dac_ddata_1] 
  connect_bd_net -net axi_ad9122_dac_dunf         [get_bd_pins axi_ad9122/dac_dunf]                 [get_bd_pins axi_ad9122_dma/fifo_rd_underflow]

  connect_bd_net -net axi_ad9122_dma_drd          [get_bd_pins axi_ad9122_dma/fifo_rd_en]           [get_bd_ports dac_dma_rd]
  connect_bd_net -net axi_ad9122_dma_ddata        [get_bd_pins axi_ad9122_dma/fifo_rd_dout]         [get_bd_ports dac_dma_rdata]
  connect_bd_net -net axi_ad9122_dma_irq          [get_bd_pins axi_ad9122_dma/irq]                  [get_bd_pins sys_concat_intc/In3]

  # connections (adc)

  p_sys_wfifo [current_bd_instance .] sys_wfifo 32 64

  connect_bd_net -net adc_clk [get_bd_ports adc_clk] [get_bd_pins axi_ad9643/adc_clk] [get_bd_pins sys_wfifo/m_clk]
  connect_bd_net -net sys_200m_clk [get_bd_pins sys_wfifo/s_clk] [get_bd_pins axi_ad9643_dma/fifo_wr_clk] [get_bd_pins axi_ad9643/delay_clk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins sys_wfifo/rstn] $sys_100m_resetn_source

  connect_bd_net -net axi_ad9643_adc_clk_in_p     [get_bd_ports adc_clk_in_p]                       [get_bd_pins axi_ad9643/adc_clk_in_p]
  connect_bd_net -net axi_ad9643_adc_clk_in_n     [get_bd_ports adc_clk_in_n]                       [get_bd_pins axi_ad9643/adc_clk_in_n]
  connect_bd_net -net axi_ad9643_adc_or_in_p      [get_bd_ports adc_or_in_p]                        [get_bd_pins axi_ad9643/adc_or_in_p]
  connect_bd_net -net axi_ad9643_adc_or_in_n      [get_bd_ports adc_or_in_n]                        [get_bd_pins axi_ad9643/adc_or_in_n]
  connect_bd_net -net axi_ad9643_adc_data_in_p    [get_bd_ports adc_data_in_p]                      [get_bd_pins axi_ad9643/adc_data_in_p]
  connect_bd_net -net axi_ad9643_adc_data_in_n    [get_bd_ports adc_data_in_n]                      [get_bd_pins axi_ad9643/adc_data_in_n]

  connect_bd_net -net axi_ad9643_adc_valid_0      [get_bd_ports adc_valid_0]                        [get_bd_pins axi_ad9643/adc_valid_0]
  connect_bd_net -net axi_ad9643_adc_enable_0     [get_bd_ports adc_enable_0]                       [get_bd_pins axi_ad9643/adc_enable_0]
  connect_bd_net -net axi_ad9643_adc_data_0       [get_bd_ports adc_data_0]                         [get_bd_pins axi_ad9643/adc_data_0]
  connect_bd_net -net axi_ad9643_adc_valid_1      [get_bd_ports adc_valid_1]                        [get_bd_pins axi_ad9643/adc_valid_1]
  connect_bd_net -net axi_ad9643_adc_enable_1     [get_bd_ports adc_enable_1]                       [get_bd_pins axi_ad9643/adc_enable_1]
  connect_bd_net -net axi_ad9643_adc_data_1       [get_bd_ports adc_data_1]                         [get_bd_pins axi_ad9643/adc_data_1]
  connect_bd_net -net axi_ad9643_adc_dovf         [get_bd_pins axi_ad9643/adc_dovf]                 [get_bd_pins sys_wfifo/m_wovf]

  connect_bd_net -net axi_ad9643_fifo_wr          [get_bd_ports adc_dma_wr]                         [get_bd_pins sys_wfifo/m_wr]
  connect_bd_net -net axi_ad9643_fifo_wdata       [get_bd_ports adc_dma_wdata]                      [get_bd_pins sys_wfifo/m_wdata]

  connect_bd_net -net axi_ad9643_dma_dwr          [get_bd_pins sys_wfifo/s_wr]                      [get_bd_pins axi_ad9643_dma/fifo_wr_en]
  connect_bd_net -net axi_ad9643_dma_dsync        [get_bd_ports adc_dma_sync]                       [get_bd_pins axi_ad9643_dma/fifo_wr_sync]
  connect_bd_net -net axi_ad9643_dma_ddata        [get_bd_pins sys_wfifo/s_wdata]                   [get_bd_pins axi_ad9643_dma/fifo_wr_din]
  connect_bd_net -net axi_ad9643_dma_dovf         [get_bd_pins sys_wfifo/s_wovf]                    [get_bd_pins axi_ad9643_dma/fifo_wr_overflow]
  connect_bd_net -net axi_ad9643_dma_irq          [get_bd_pins axi_ad9643_dma/irq]                  [get_bd_pins sys_concat_intc/In2]


  # interconnect (cpu)

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9122/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9643/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9643_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9122_dma/s_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9122/s_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9122_dma/s_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9122/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9122_dma/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9643/s_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9643_dma/s_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9643/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9643_dma/s_axi_aresetn]

  # memory interconnects share the same clock (fclk2)

if {$sys_zynq == 1} {
  set sys_fmc_dma_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]
  connect_bd_net -net sys_fmc_dma_clk $sys_fmc_dma_clk_source
}

# interconnect (mem/dac)

if {$sys_zynq == 0 } { 
  connect_bd_intf_net -intf_net axi_mem_interconnect_s08_axi [get_bd_intf_pins axi_mem_interconnect/S08_AXI] [get_bd_intf_pins axi_ad9122_dma/m_src_axi]
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/S08_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9122_dma/m_src_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9122_dma/m_src_axi_aresetn]
} else {
  connect_bd_intf_net -intf_net axi_ad9122_dma_axi [get_bd_intf_pins sys_ps7/S_AXI_HP2] [get_bd_intf_pins axi_ad9122_dma/m_src_axi]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma/m_src_axi_aclk]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9122_dma/m_src_axi_aresetn]
}

# interconnect (mem/adc)

if {$sys_zynq == 0 } {
  connect_bd_intf_net -intf_net axi_mem_interconnect_s09_axi [get_bd_intf_pins axi_mem_interconnect/S09_AXI] [get_bd_intf_pins axi_ad9643_dma/m_dest_axi]
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/S09_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9643_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9643_dma/m_dest_axi_aresetn]
} else {
  connect_bd_intf_net -intf_net axi_ad9643_dma_axi [get_bd_intf_pins sys_ps7/S_AXI_HP1] [get_bd_intf_pins axi_ad9643_dma/m_dest_axi]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9643_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9643_dma/m_dest_axi_aresetn]
}

  # ila (adc)

  set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc]
  set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc
  set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc
  set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}] $ila_adc
  set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]  $ila_adc
  set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc

  connect_bd_net -net sys_200m_clk [get_bd_pins ila_adc/clk]
  connect_bd_net -net axi_ad9643_dma_dwr [get_bd_pins ila_adc/probe0]
  connect_bd_net -net axi_ad9643_dma_ddata [get_bd_pins ila_adc/probe1]

  # reference clock

  connect_bd_net -net fmcomms1_ref_clk [get_bd_pins sys_audio_clkgen/clk_out2] [get_bd_ports ref_clk]

  # address map

  create_bd_addr_seg -range 0x00010000 -offset 0x74200000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9122/s_axi/axi_lite]      SEG_data_ad9122
  create_bd_addr_seg -range 0x00010000 -offset 0x79020000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9643/s_axi/axi_lite]      SEG_data_ad9643
  create_bd_addr_seg -range 0x00010000 -offset 0x7c400000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9643_dma/s_axi/axi_lite]  SEG_data_ad9122_dma
  create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9122_dma/s_axi/axi_lite]  SEG_data_ad9643_dma

if {$sys_zynq == 0} {
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9643_dma/m_dest_axi]  [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr] SEG_axi_ddr_cntrl
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9122_dma/m_src_axi]   [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr] SEG_axi_ddr_cntrl
} else {
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9643_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9122_dma/m_src_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm
}
