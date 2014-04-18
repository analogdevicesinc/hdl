
  # motor control

  # position detection interface

  set position_i [ create_bd_port -dir I -from 2 -to 0 position_i ]

  # current monitor 1 interface

  set adc_ia_dat_i [ create_bd_port -dir I adc_ia_dat_i ]
  set adc_ib_dat_i [ create_bd_port -dir I adc_ib_dat_i ]
  set adc_it_dat_i [ create_bd_port -dir I adc_it_dat_i ]
  set adc_vbus_dat_i [ create_bd_port -dir I adc_vbus_dat_i ]
  set adc_ia_clk_o [ create_bd_port -dir O adc_ia_clk_o ]
  set adc_ib_clk_o [ create_bd_port -dir O adc_ib_clk_o ]
  set adc_it_clk_o [ create_bd_port -dir O adc_it_clk_o ]
  set adc_vbus_clk_o [ create_bd_port -dir O adc_vbus_clk_o ]

  # cuurrent monitor 2 interface

  set adc_ia_dat_d_i [ create_bd_port -dir I adc_ia_dat_d_i ]
  set adc_ib_dat_d_i [ create_bd_port -dir I adc_ib_dat_d_i ]
  set adc_it_dat_d_i [ create_bd_port -dir I adc_it_dat_d_i ]
  set adc_ia_clk_d_o [ create_bd_port -dir O adc_ia_clk_d_o ]
  set adc_ib_clk_d_o [ create_bd_port -dir O adc_ib_clk_d_o ]
  set adc_it_clk_d_o [ create_bd_port -dir O adc_it_clk_d_o ]

  # motor control interface

  set fmc_m1_fault_i [ create_bd_port -dir I fmc_m1_fault_i ]
  set fmc_m1_en_o [ create_bd_port -dir O fmc_m1_en_o ]

  set pwm_al_o [ create_bd_port -dir O pwm_al_o]
  set pwm_ah_o [ create_bd_port -dir O pwm_ah_o]
  set pwm_cl_o [ create_bd_port -dir O pwm_cl_o]
  set pwm_ch_o [ create_bd_port -dir O pwm_ch_o]
  set pwm_bl_o [ create_bd_port -dir O pwm_bl_o]
  set pwm_bh_o [ create_bd_port -dir O pwm_bh_o]

  # gpo interface

  set gpo_o [ create_bd_port -dir O -from 7 -to 0 gpo_o ]

  # xadc interface

  set vp_in [ create_bd_port -dir I vp_in ]
  set vn_in [ create_bd_port -dir I vn_in ]
  set vauxp0 [ create_bd_port -dir I vauxp0 ]
  set vauxn0 [ create_bd_port -dir I vauxn0 ]
  set vauxp8 [ create_bd_port -dir I vauxp8 ]
  set vauxn8 [ create_bd_port -dir I vauxn8 ]
  set muxaddr_out [ create_bd_port -dir O -from 4 -to 0 muxaddr_out ]

  # additions to default configuration

  set_property -dict [list CONFIG.NUM_PORTS {7}] $sys_concat_intc
  set_property -dict [list CONFIG.NUM_MI {16}] $axi_cpu_interconnect
  set_property -dict [ list CONFIG.PCW_USE_S_AXI_HP1 {1} ] $sys_ps7

  # current monitor 1 peripherals

  set axi_mc_current_monitor_1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_current_monitor:1.0 axi_mc_current_monitor_1 ]

  set axi_current_monitor_1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_current_monitor_1_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_current_monitor_1_dma
#  set_property -dict [list CONFIG.C_ADDR_ALIGN_BITS {3}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_current_monitor_1_dma

  # current monitor 2 peripherals

  set axi_mc_current_monitor_2 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_current_monitor:1.0 axi_mc_current_monitor_2 ]

  set axi_current_monitor_2_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_current_monitor_2_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_current_monitor_2_dma
#  set_property -dict [list CONFIG.C_ADDR_ALIGN_BITS {3}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_current_monitor_2_dma

  # speed detector

  set axi_mc_speed_1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_speed:1.0 axi_mc_speed_1 ]

  set axi_speed_detector_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_speed_detector_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_speed_detector_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_speed_detector_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_speed_detector_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_speed_detector_dma
#  set_property -dict [list CONFIG.C_ADDR_ALIGN_BITS {2}] $axi_speed_detector_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_speed_detector_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {32}] $axi_speed_detector_dma

  # torque controller

  set axi_mc_torque_controller [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_torque_ctrl:1.0 axi_mc_torque_controller ]

  set axi_torque_controller_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_torque_controller_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_torque_controller_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_torque_controller_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_torque_controller_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_torque_controller_dma
#  set_property -dict [list CONFIG.C_ADDR_ALIGN_BITS {2}] $axi_torque_controller_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_torque_controller_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC  {32}] $axi_torque_controller_dma

  # xadc

  set xadc_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.0 xadc_wiz_1 ]
  set_property -dict [ list CONFIG.XADC_STARUP_SELECTION {simultaneous_sampling} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.OT_ALARM {false} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.USER_TEMP_ALARM {false} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.VCCINT_ALARM {false} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.VCCAUX_ALARM {false} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.ENABLE_EXTERNAL_MUX {true} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.EXTERNAL_MUX_CHANNEL {VAUXP0_VAUXN0} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.CHANNEL_ENABLE_VAUXP0_VAUXN0 {true} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.CHANNEL_ENABLE_VAUXP1_VAUXN1 {false}  ] $xadc_wiz_1

  # additional interconnect

  set axi_mem_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_interconnect ]
  set_property -dict [ list CONFIG.NUM_SI {4} CONFIG.NUM_MI {1}  ] $axi_mem_interconnect

  # connections

  # position

  connect_bd_net -net position_i_1 [get_bd_ports position_i] [get_bd_pins axi_mc_speed_1/position_i] [get_bd_pins axi_mc_speed_1/bemf_i]

  # current monitor 1

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_current_monitor_1/ref_clk] $sys_100m_clk_source

  connect_bd_net -net adc_ia_dat_i_1 [get_bd_ports adc_ia_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_ia_dat_i]
  connect_bd_net -net adc_ib_dat_i_1 [get_bd_ports adc_ib_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_ib_dat_i]
  connect_bd_net -net adc_it_dat_i_1 [get_bd_ports adc_it_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_it_dat_i]
  connect_bd_net -net adc_vbus_dat_i_1 [get_bd_ports adc_vbus_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_vbus_dat_i]

  connect_bd_net -net axi_mc_current_monitor_1_adc_ia_clk_o [get_bd_ports adc_ia_clk_o] [get_bd_pins axi_mc_current_monitor_1/adc_ia_clk_o]
  connect_bd_net -net axi_mc_current_monitor_1_adc_ib_clk_o [get_bd_ports adc_ib_clk_o] [get_bd_pins axi_mc_current_monitor_1/adc_ib_clk_o]
  connect_bd_net -net axi_mc_current_monitor_1_adc_it_clk_o [get_bd_ports adc_it_clk_o] [get_bd_pins axi_mc_current_monitor_1/adc_it_clk_o]
  connect_bd_net -net axi_mc_current_monitor_1_adc_vbus_clk_o [get_bd_ports adc_vbus_clk_o] [get_bd_pins axi_mc_current_monitor_1/adc_vbus_clk_o]

  connect_bd_net -net axi_mc_current_monitor_1_adc_clk    [get_bd_pins axi_mc_current_monitor_1/adc_clk_o]      [get_bd_pins axi_current_monitor_1_dma/fifo_wr_clk]
  connect_bd_net -net axi_mc_current_monitor_1_adc_dwr    [get_bd_pins axi_mc_current_monitor_1/adc_dwr_o]      [get_bd_pins axi_current_monitor_1_dma/fifo_wr_en]
  connect_bd_net -net axi_mc_current_monitor_1_adc_ddata  [get_bd_pins axi_mc_current_monitor_1/adc_ddata_o]    [get_bd_pins axi_current_monitor_1_dma/fifo_wr_din]
  connect_bd_net -net axi_mc_current_monitor_1_adc_dsync  [get_bd_pins axi_mc_current_monitor_1/adc_dsync_o]    [get_bd_pins axi_current_monitor_1_dma/fifo_wr_sync]
  connect_bd_net -net axi_mc_current_monitor_1_adc_mon_data   [get_bd_pins axi_mc_current_monitor_1/adc_mon_data]
  #connect_bd_net -net axi_mc_current_monitor_1_adc_dovf   [get_bd_pins axi_mc_current_monitor_1/adc_dovf_i]
  #connect_bd_net -net axi_mc_current_monitor_1_adc_dunf   [get_bd_pins axi_mc_current_monitor_1/adc_dunf_i]

  connect_bd_net [get_bd_pins axi_mc_current_monitor_1/i_ready_o] [get_bd_pins axi_mc_torque_controller/i_ready_i]

  # interrupt

  connect_bd_net -net axi_current_monitor_1_dma_irq [get_bd_pins axi_current_monitor_1_dma/irq] [get_bd_pins sys_concat_intc/In2]

  # current monitor 2

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_current_monitor_2/ref_clk] $sys_100m_clk_source

  connect_bd_net -net adc_ia_dat_d_i [get_bd_ports adc_ia_dat_d_i] [get_bd_pins axi_mc_current_monitor_2/adc_ia_dat_i]
  connect_bd_net -net axi_mc_current_monitor_2_adc_ia_clk_o [get_bd_ports adc_ia_clk_d_o] [get_bd_pins axi_mc_current_monitor_2/adc_ia_clk_o]
  connect_bd_net -net adc_ib_dat_d_i [get_bd_ports adc_ib_dat_d_i] [get_bd_pins axi_mc_current_monitor_2/adc_ib_dat_i]
  connect_bd_net -net axi_mc_current_monitor_2_adc_ib_clk_o [get_bd_ports adc_ib_clk_d_o] [get_bd_pins axi_mc_current_monitor_2/adc_ib_clk_o]
  connect_bd_net -net adc_it_dat_d_i [get_bd_ports adc_it_dat_d_i] [get_bd_pins axi_mc_current_monitor_2/adc_it_dat_i]
  connect_bd_net -net axi_mc_current_monitor_2_adc_it_clk_o [get_bd_ports adc_it_clk_d_o] [get_bd_pins axi_mc_current_monitor_2/adc_it_clk_o]

  connect_bd_net -net axi_mc_current_monitor_2_adc_clk    [get_bd_pins axi_mc_current_monitor_2/adc_clk_o]      [get_bd_pins axi_current_monitor_2_dma/fifo_wr_clk]
  connect_bd_net -net axi_mc_current_monitor_2_adc_dwr    [get_bd_pins axi_mc_current_monitor_2/adc_dwr_o]      [get_bd_pins axi_current_monitor_2_dma/fifo_wr_en]
  connect_bd_net -net axi_mc_current_monitor_2_adc_ddata  [get_bd_pins axi_mc_current_monitor_2/adc_ddata_o]    [get_bd_pins axi_current_monitor_2_dma/fifo_wr_din]
  connect_bd_net -net axi_mc_current_monitor_2_adc_dsync  [get_bd_pins axi_mc_current_monitor_2/adc_dsync_o]    [get_bd_pins axi_current_monitor_2_dma/fifo_wr_sync]
  #connect_bd_net -net axi_mc_current_monitor_2_adc_dovf   [get_bd_pins axi_mc_current_monitor_2/adc_dovf_i]
  #connect_bd_net -net axi_mc_current_monitor_2_adc_dunf   [get_bd_pins axi_mc_current_monitor_2/adc_dunf_i]

  #interrupt

  connect_bd_net -net axi_current_monitor_2_dma_irq [get_bd_pins axi_current_monitor_2_dma/irq] [get_bd_pins sys_concat_intc/In6]

  # speed detector

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_speed_1/ref_clk] $sys_100m_clk_source

  connect_bd_net -net axi_mc_speed_1_position_o [get_bd_pins axi_mc_speed_1/position_o]
  connect_bd_net -net axi_mc_speed_1_position_o [get_bd_pins axi_mc_speed_1/position_o]  [get_bd_pins axi_mc_torque_controller/position_i]
  connect_bd_net -net axi_mc_speed_1_new_speed_o [get_bd_pins axi_mc_speed_1/new_speed_o]
  connect_bd_net -net axi_mc_speed_1_new_speed_o [get_bd_pins axi_mc_speed_1/new_speed_o] [get_bd_pins axi_mc_torque_controller/new_speed_i]
  connect_bd_net -net axi_mc_speed_1_speed_o [get_bd_pins axi_mc_speed_1/speed_o]
  connect_bd_net -net axi_mc_speed_1_speed_o [get_bd_pins axi_mc_speed_1/speed_o] [get_bd_pins axi_mc_torque_controller/speed_i]

  connect_bd_net [get_bd_pins /axi_mc_torque_controller/fmc_m1_fault_i] [get_bd_ports /fmc_m1_fault_i]

  connect_bd_net -net speed_detector_adc_clk    [get_bd_pins axi_mc_speed_1/adc_clk_o]      [get_bd_pins axi_speed_detector_dma/fifo_wr_clk]
  connect_bd_net -net speed_detector_adc_dwr    [get_bd_pins axi_mc_speed_1/adc_dwr_o]      [get_bd_pins axi_speed_detector_dma/fifo_wr_en]
  connect_bd_net -net speed_detector_adc_ddata  [get_bd_pins axi_mc_speed_1/adc_ddata_o]    [get_bd_pins axi_speed_detector_dma/fifo_wr_din]
  #connect_bd_net -net speed_detector_adc_dovf   [get_bd_pins axi_mc_speed_1/adc_dovf_i]
  #connect_bd_net -net speed_detector_adc_dunf   [get_bd_pins axi_mc_speed_1/adc_dunf_i]

  # interrupt

  connect_bd_net -net axi_speed_detector_dma_irq [get_bd_pins axi_speed_detector_dma/irq] [get_bd_pins sys_concat_intc/In3]

  # torque controller

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_torque_controller/ref_clk] $sys_100m_clk_source

  connect_bd_net -net axi_mc_current_monitor_1_it_o [get_bd_pins axi_mc_current_monitor_1/it_o] [get_bd_pins axi_mc_torque_controller/it_i]
  connect_bd_net -net axi_mc_torque_controller_fmc_m1_en_o [get_bd_ports fmc_m1_en_o] [get_bd_pins axi_mc_torque_controller/fmc_m1_en_o]
  connect_bd_net -net axi_mc_torque_controller_pwm_al_o [get_bd_ports pwm_al_o] [get_bd_pins axi_mc_torque_controller/pwm_al_o]
  connect_bd_net -net axi_mc_torque_controller_pwm_ah_o [get_bd_ports pwm_ah_o] [get_bd_pins axi_mc_torque_controller/pwm_ah_o]
  connect_bd_net -net axi_mc_torque_controller_pwm_cl_o [get_bd_ports pwm_cl_o] [get_bd_pins axi_mc_torque_controller/pwm_cl_o]
  connect_bd_net -net axi_mc_torque_controller_pwm_ch_o [get_bd_ports pwm_ch_o] [get_bd_pins axi_mc_torque_controller/pwm_ch_o]
  connect_bd_net -net axi_mc_torque_controller_pwm_bl_o [get_bd_ports pwm_bl_o] [get_bd_pins axi_mc_torque_controller/pwm_bl_o]
  connect_bd_net -net axi_mc_torque_controller_pwm_bh_o [get_bd_ports pwm_bh_o] [get_bd_pins axi_mc_torque_controller/pwm_bh_o]
  connect_bd_net -net axi_mc_torque_controller_gpo_o [get_bd_ports gpo_o] [get_bd_pins axi_mc_torque_controller/gpo_o]
  connect_bd_net -net axi_mc_torque_controller_sensors_o [get_bd_pins axi_mc_torque_controller/sensors_o] [get_bd_pins axi_mc_speed_1/hall_bemf_i]

  connect_bd_net -net axi_mc_torque_controller_adc_clk    [get_bd_pins axi_mc_torque_controller/adc_clk_o]      [get_bd_pins axi_torque_controller_dma/fifo_wr_clk]
  connect_bd_net -net axi_mc_torque_controller_adc_dwr    [get_bd_pins axi_mc_torque_controller/adc_dwr_o]      [get_bd_pins axi_torque_controller_dma/fifo_wr_en]
  connect_bd_net -net axi_mc_torque_controller_adc_ddata  [get_bd_pins axi_mc_torque_controller/adc_ddata_o]    [get_bd_pins axi_torque_controller_dma/fifo_wr_din]
  #connect_bd_net -net axi_mc_torque_controller_adc_dsync  [get_bd_pins axi_mc_torque_controller/adc_dsync_o]    [get_bd_pins axi_torque_controller_dma/fifo_wr_sync]
  #connect_bd_net -net axi_mc_torque_controller_adc_dovf   [get_bd_pins axi_mc_torque_controller/adc_dovf_i]
  #connect_bd_net -net axi_mc_torque_controller_adc_dunf   [get_bd_pins axi_mc_torque_controller/adc_dunf_i]

  # interrupt

  connect_bd_net -net axi_torque_controller_dma_irq [get_bd_pins axi_torque_controller_dma/irq] [get_bd_pins sys_concat_intc/In5]

  # xadc

  connect_bd_net -net sys_100m_clk [get_bd_pins xadc_wiz_1/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins xadc_wiz_1/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net vp_in_1 [get_bd_ports vp_in] [get_bd_pins xadc_wiz_1/vp_in]
  connect_bd_net -net vn_in_1 [get_bd_ports vn_in] [get_bd_pins xadc_wiz_1/vn_in]
  connect_bd_net -net vauxp0_1 [get_bd_ports vauxp0] [get_bd_pins xadc_wiz_1/vauxp0]
  connect_bd_net -net vauxn0_1 [get_bd_ports vauxn0] [get_bd_pins xadc_wiz_1/vauxn0]
  connect_bd_net -net vauxp8_1 [get_bd_ports vauxp8] [get_bd_pins xadc_wiz_1/vauxp8]
  connect_bd_net -net vauxn8_1 [get_bd_ports vauxn8] [get_bd_pins xadc_wiz_1/vauxn8]
  connect_bd_net -net xadc_wiz_1_muxaddr_out [get_bd_ports muxaddr_out] [get_bd_pins xadc_wiz_1/muxaddr_out]

  # ila
  set ila_current_monitor [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_current_monitor]
  set_property -dict [list CONFIG.C_NUM_OF_PROBES {5}] $ila_current_monitor
  set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_current_monitor
  set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $ila_current_monitor
  set_property -dict [list CONFIG.C_PROBE2_WIDTH {1}] $ila_current_monitor
  set_property -dict [list CONFIG.C_PROBE3_WIDTH {64}] $ila_current_monitor
  set_property -dict [list CONFIG.C_PROBE4_WIDTH {32}] $ila_current_monitor
  set_property -dict [list CONFIG.C_EN_STRG_QUAL {1} ]  $ila_current_monitor
  set_property -dict [list CONFIG.C_ADV_TRIGGER {true}]  $ila_current_monitor

  connect_bd_net -net axi_mc_current_monitor_1_adc_clk        [get_bd_pins ila_current_monitor/probe0]
  connect_bd_net -net axi_mc_current_monitor_1_adc_dwr        [get_bd_pins ila_current_monitor/probe1]
  connect_bd_net -net axi_mc_current_monitor_1_adc_dsync      [get_bd_pins ila_current_monitor/probe2]
  connect_bd_net -net axi_mc_current_monitor_1_adc_ddata      [get_bd_pins ila_current_monitor/probe3]
  connect_bd_net -net axi_mc_current_monitor_1_adc_mon_data   [get_bd_pins ila_current_monitor/probe4]
  connect_bd_net -net sys_100m_clk                            [get_bd_pins ila_current_monitor/clk]

  # interconnect (cpu)

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_mc_current_monitor_1/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_mc_speed_1/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_mc_torque_controller/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_mc_current_monitor_2/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins xadc_wiz_1/s_axi_lite]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_speed_detector_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m13_axi [get_bd_intf_pins axi_cpu_interconnect/M13_AXI] [get_bd_intf_pins axi_current_monitor_1_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m14_axi [get_bd_intf_pins axi_cpu_interconnect/M14_AXI] [get_bd_intf_pins axi_current_monitor_2_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m15_axi [get_bd_intf_pins axi_cpu_interconnect/M15_AXI] [get_bd_intf_pins axi_torque_controller_dma/s_axi]

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M13_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M14_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M15_ACLK] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M13_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M14_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M15_ARESETN] $sys_100m_resetn_source

  #inteconnects (current monitor 1)

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_current_monitor_1/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mc_current_monitor_1/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_current_monitor_1_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_current_monitor_1_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_current_monitor_1_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_current_monitor_1_dma/m_dest_axi_aresetn] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_mem_interconnect_s01_axi [get_bd_intf_pins axi_mem_interconnect/S01_AXI] [get_bd_intf_pins axi_current_monitor_1_dma/m_dest_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S01_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S01_ARESETN] $sys_100m_resetn_source

  #interconnect (current monitor 2)

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_current_monitor_2/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mc_current_monitor_2/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_current_monitor_2_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_current_monitor_2_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_current_monitor_2_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_current_monitor_2_dma/m_dest_axi_aresetn] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_mem_interconnect_s02_axi [get_bd_intf_pins axi_mem_interconnect/S02_AXI] [get_bd_intf_pins axi_current_monitor_2_dma/m_dest_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S02_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S02_ARESETN] $sys_100m_resetn_source

  # interconnect (speed detector)

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_speed_1/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mc_speed_1/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_speed_detector_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_speed_detector_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_speed_detector_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_speed_detector_dma/m_dest_axi_aresetn] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_mem_interconnect_s00_axi [get_bd_intf_pins axi_mem_interconnect/S00_AXI] [get_bd_intf_pins axi_speed_detector_dma/m_dest_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S00_ARESETN] $sys_100m_resetn_source

  # interconnect (torque controller)

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_torque_controller/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mc_torque_controller/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_torque_controller_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_torque_controller_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_torque_controller_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_torque_controller_dma/m_dest_axi_aresetn] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_mem_interconnect_s03_axi [get_bd_intf_pins axi_mem_interconnect/S03_AXI] [get_bd_intf_pins axi_torque_controller_dma/m_dest_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S03_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S03_ARESETN] $sys_100m_resetn_source

  # interconnect (dmas)

  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/M00_ACLK] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/M00_ARESETN] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_mem_interconnect_m00_axi [get_bd_intf_pins axi_mem_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]

  # address map

  create_bd_addr_seg -range 0x10000 -offset 0x40400000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_current_monitor_1_dma/s_axi/axi_lite] SEG_data_c_m_1_dma
  create_bd_addr_seg -range 0x10000 -offset 0x40410000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_speed_detector_dma/s_axi/axi_lite] SEG_data_s_d_dma
  create_bd_addr_seg -range 0x10000 -offset 0x40420000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_torque_controller_dma/s_axi/axi_lite] SEG_data_t_c_dma
  create_bd_addr_seg -range 0x10000 -offset 0x40430000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_current_monitor_2_dma/s_axi/axi_lite] SEG_data_c_m_2_dma
  create_bd_addr_seg -range 0x10000 -offset 0x40500000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_mc_current_monitor_1/s_axi/axi_lite] SEG_data_c_m_1
  create_bd_addr_seg -range 0x10000 -offset 0x40510000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_mc_speed_1/s_axi/axi_lite] SEG_data_s_d
  create_bd_addr_seg -range 0x10000 -offset 0x40520000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_mc_torque_controller/s_axi/axi_lite] SEG_data_t_c
  create_bd_addr_seg -range 0x10000 -offset 0x40530000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_mc_current_monitor_2/s_axi/axi_lite] SEG_data_c_m_2
  create_bd_addr_seg -range 0x10000 -offset 0x43200000 $sys_addr_cntrl_space  [get_bd_addr_segs xadc_wiz_1/s_axi_lite/Reg] SEG_data_xadc

  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_current_monitor_1_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_speed_detector_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_torque_controller_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_current_monitor_2_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
