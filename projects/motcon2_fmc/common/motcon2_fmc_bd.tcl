
  # motor control

  # position detection interface

  set position_i [ create_bd_port -dir I -from 2 -to 0 position_i ]

  # current monitor 1 interface

  set adc_clk_o [ create_bd_port -dir O adc_clk_o ]

  set adc_m1_ia_dat_i [ create_bd_port -dir I adc_m1_ia_dat_i ]
  set adc_m1_ib_dat_i [ create_bd_port -dir I adc_m1_ib_dat_i ]
  set adc_m1_vbus_dat_i [ create_bd_port -dir I adc_m1_vbus_dat_i ]

  # current monitor 2 interface

  set adc_m2_ia_dat_i [ create_bd_port -dir I adc_m2_ia_dat_i ]
  set adc_m2_ib_dat_i [ create_bd_port -dir I adc_m2_ib_dat_i ]
  set adc_m2_vbus_dat_i [ create_bd_port -dir I adc_m2_vbus_dat_i ]

  # motor control interface

  set fmc_m1_en_o [ create_bd_port -dir O fmc_m1_en_o ]
  set fmc_m2_en_o [ create_bd_port -dir O fmc_m2_en_o ]

  # gpo interface

  set gpo_o [ create_bd_port -dir O -from 3 -to 0 gpo_o ]

  # interrupts

  set motcon2_c_m_1_irq [create_bd_port -dir O motcon2_c_m_1_irq]
  set motcon2_c_m_2_irq [create_bd_port -dir O motcon2_c_m_2_irq]
  set motcon2_s_d_irq   [create_bd_port -dir O motcon2_s_d_irq]

  # Ethernet

  set eth2_mdio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 eth2_mdio ]
  set eth2_rgmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 eth2_rgmii ]

  set eth2_phy_rst_n [ create_bd_port -dir O eth2_phy_rst_n ]

  # xadc interface

  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn

  # additions to default configuration

  set_property -dict [list CONFIG.NUM_MI {14}] $axi_cpu_interconnect


  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1} ] $sys_ps7

  # current monitor 1 peripherals

  set axi_mc_current_monitor_1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_current_monitor:1.0 axi_mc_current_monitor_1 ]

  set axi_current_monitor_1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_current_monitor_1_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_current_monitor_1_dma
  set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_DEST {1}] $axi_current_monitor_1_dma

  # current monitor 2 peripherals

  set axi_mc_current_monitor_2 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_current_monitor:1.0 axi_mc_current_monitor_2 ]

  set axi_current_monitor_2_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_current_monitor_2_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_current_monitor_2_dma
  set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_DEST {1}] $axi_current_monitor_2_dma

  # speed detector

#  set axi_mc_speed_1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_speed:1.0 axi_mc_speed_1 ]

#  set axi_speed_detector_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_speed_detector_dma]
#  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_speed_detector_dma
#  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_speed_detector_dma
#  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_speed_detector_dma
#  set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_speed_detector_dma
#  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_speed_detector_dma
#  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {32}] $axi_speed_detector_dma
#  set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_DEST {1}] $axi_speed_detector_dma

  # xadc

  set xadc_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.0 xadc_wiz_1 ]
  set_property -dict [ list CONFIG.CHANNEL_ENABLE_VAUXP0_VAUXN0 {true} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.ENABLE_EXTERNAL_MUX {false} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.OT_ALARM {false} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.USER_TEMP_ALARM {false}  ] $xadc_wiz_1
  set_property -dict [ list CONFIG.VCCAUX_ALARM {false} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.VCCINT_ALARM {false} ] $xadc_wiz_1
  set_property -dict [ list CONFIG.XADC_STARUP_SELECTION {simultaneous_sampling} ] $xadc_wiz_1

  #ethernet

  set gmii_to_rgmii_eth2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii:3.0 gmii_to_rgmii_eth2 ]
  set_property -dict [ list CONFIG.C_PHYADDR {1} CONFIG.SupportLevel {Include_Shared_Logic_in_Core}  ] $gmii_to_rgmii_eth2

  # connections

  # position

#  connect_bd_net -net position_i_1 [get_bd_ports position_i] [get_bd_pins axi_mc_speed_1/position_i]
#  connect_bd_net -net position_i_1 [get_bd_pins axi_mc_speed_1/bemf_i]

  # current monitor 1

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_current_monitor_1/ref_clk] $sys_100m_clk_source

  connect_bd_net -net adc_m1_ia_dat_i_1 [get_bd_ports adc_m1_ia_dat_i]     [get_bd_pins axi_mc_current_monitor_1/adc_ia_dat_i]
  connect_bd_net -net adc_m1_ib_dat_i_1 [get_bd_ports adc_m1_ib_dat_i]     [get_bd_pins axi_mc_current_monitor_1/adc_ib_dat_i]
  connect_bd_net -net adc_m1_vbus_dat_i_1 [get_bd_ports adc_m1_vbus_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_vbus_dat_i]

  connect_bd_net -net axi_mc_current_monitor_1_adc_ia_clk_o   [get_bd_ports adc_clk_o]   [get_bd_pins axi_mc_current_monitor_1/adc_ia_clk_o]

  connect_bd_net -net axi_mc_current_monitor_1_adc_clk    [get_bd_pins axi_mc_current_monitor_1/adc_clk_o]    [get_bd_pins axi_current_monitor_1_dma/fifo_wr_clk]
  connect_bd_net -net axi_mc_current_monitor_1_adc_dwr    [get_bd_pins axi_mc_current_monitor_1/adc_dwr_o]    [get_bd_pins axi_current_monitor_1_dma/fifo_wr_en]
  connect_bd_net -net axi_mc_current_monitor_1_adc_ddata  [get_bd_pins axi_mc_current_monitor_1/adc_ddata_o]  [get_bd_pins axi_current_monitor_1_dma/fifo_wr_din]
  connect_bd_net -net axi_mc_current_monitor_1_adc_dsync  [get_bd_pins axi_mc_current_monitor_1/adc_dsync_o]  [get_bd_pins axi_current_monitor_1_dma/fifo_wr_sync]
  connect_bd_net -net axi_mc_current_monitor_1_adc_dovf   [get_bd_pins axi_mc_current_monitor_1/adc_dovf_i]   [get_bd_pins axi_current_monitor_1_dma/fifo_wr_overflow]

  # interrupt

  connect_bd_net -net axi_current_monitor_1_dma_irq [get_bd_pins axi_current_monitor_1_dma/irq] [get_bd_ports motcon2_c_m_1_irq]

  # current monitor 2

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_current_monitor_2/ref_clk] $sys_100m_clk_source

  connect_bd_net -net adc_m2_ia_dat_i [get_bd_ports adc_m2_ia_dat_i] [get_bd_pins axi_mc_current_monitor_2/adc_ia_dat_i]
  connect_bd_net -net adc_m2_ib_dat_i [get_bd_ports adc_m2_ib_dat_i] [get_bd_pins axi_mc_current_monitor_2/adc_ib_dat_i]
  connect_bd_net -net adc_m2_vbus_dat_i_1 [get_bd_ports adc_m2_vbus_dat_i] [get_bd_pins axi_mc_current_monitor_2/adc_vbus_dat_i]

  connect_bd_net -net axi_mc_current_monitor_2_adc_clk    [get_bd_pins axi_mc_current_monitor_2/adc_clk_o]    [get_bd_pins axi_current_monitor_2_dma/fifo_wr_clk]
  connect_bd_net -net axi_mc_current_monitor_2_adc_dwr    [get_bd_pins axi_mc_current_monitor_2/adc_dwr_o]    [get_bd_pins axi_current_monitor_2_dma/fifo_wr_en]
  connect_bd_net -net axi_mc_current_monitor_2_adc_ddata  [get_bd_pins axi_mc_current_monitor_2/adc_ddata_o]  [get_bd_pins axi_current_monitor_2_dma/fifo_wr_din]
  connect_bd_net -net axi_mc_current_monitor_2_adc_dsync  [get_bd_pins axi_mc_current_monitor_2/adc_dsync_o]  [get_bd_pins axi_current_monitor_2_dma/fifo_wr_sync]
  connect_bd_net -net axi_mc_current_monitor_2_adc_dovf   [get_bd_pins axi_mc_current_monitor_2/adc_dovf_i]   [get_bd_pins axi_current_monitor_2_dma/fifo_wr_overflow]

  #interrupt

  connect_bd_net -net axi_current_monitor_2_dma_irq [get_bd_pins axi_current_monitor_2_dma/irq] [get_bd_ports motcon2_c_m_2_irq]

  # speed detector

#  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_speed_1/ref_clk] $sys_100m_clk_source


#  connect_bd_net -net speed_detector_adc_clk    [get_bd_pins axi_mc_speed_1/adc_clk_o] [get_bd_pins axi_speed_detector_dma/fifo_wr_clk]
#  connect_bd_net -net speed_detector_adc_dwr    [get_bd_pins axi_mc_speed_1/adc_dwr_o] [get_bd_pins axi_speed_detector_dma/fifo_wr_en]
#  connect_bd_net -net speed_detector_adc_ddata  [get_bd_pins axi_mc_speed_1/adc_ddata_o] [get_bd_pins axi_speed_detector_dma/fifo_wr_din]
#  connect_bd_net -net speed_detector_adc_dovf   [get_bd_pins axi_mc_speed_1/adc_dovf_i] [get_bd_pins axi_speed_detector_dma/fifo_wr_overflow]

  # interrupt

#  connect_bd_net -net axi_speed_detector_dma_irq [get_bd_pins axi_speed_detector_dma/irq] [get_bd_ports motcon2_s_d_irq]

  # xadc

  connect_bd_net -net sys_100m_clk [get_bd_pins xadc_wiz_1/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins xadc_wiz_1/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net Vp_Vn_1 [get_bd_intf_pins xadc_wiz_1/Vp_Vn] [get_bd_intf_ports Vp_Vn]
  connect_bd_intf_net -intf_net Vaux0_1 [get_bd_intf_pins xadc_wiz_1/Vaux0] [get_bd_intf_ports Vaux0]
  connect_bd_intf_net -intf_net Vaux8_1 [get_bd_intf_pins xadc_wiz_1/Vaux8] [get_bd_intf_ports Vaux8]

  #ethernet

  connect_bd_intf_net -intf_net gmii_to_rgmii_eth2_eth2_mdio [get_bd_intf_ports eth2_mdio] [get_bd_intf_pins gmii_to_rgmii_eth2/MDIO_PHY]
  connect_bd_intf_net -intf_net gmii_to_rgmii_eth2_eth2_rgmii [get_bd_intf_ports eth2_rgmii] [get_bd_intf_pins gmii_to_rgmii_eth2/RGMII]
  connect_bd_intf_net -intf_net sys_ps7_GMII_ETHERNET_1 [get_bd_intf_pins gmii_to_rgmii_eth2/GMII] [get_bd_intf_pins sys_ps7/GMII_ETHERNET_1]
  connect_bd_intf_net -intf_net sys_ps7_MDIO_ETHERNET_1 [get_bd_intf_pins gmii_to_rgmii_eth2/MDIO_GEM] [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_1]

  connect_bd_net -net sys_200m_clk [get_bd_pins gmii_to_rgmii_eth2/clkin] $sys_200m_clk_source
  connect_bd_net -net sys_rstgen_peripheral_reset [get_bd_pins gmii_to_rgmii_eth2/rx_reset] [get_bd_pins gmii_to_rgmii_eth2/tx_reset] [get_bd_pins sys_rstgen/peripheral_reset]
  connect_bd_net -net [get_bd_nets sys_100m_resetn] [get_bd_ports eth2_phy_rst_n] [get_bd_pins sys_rstgen/peripheral_aresetn]

  # interconnect (cpu)

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_mc_current_monitor_1/s_axi]
#  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_mc_speed_1/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_current_monitor_2_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_mc_current_monitor_2/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins axi_current_monitor_1_dma/s_axi]
#  connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_speed_detector_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m13_axi [get_bd_intf_pins axi_cpu_interconnect/M13_AXI] [get_bd_intf_pins xadc_wiz_1/s_axi_lite]

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M13_ACLK] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M13_ARESETN] $sys_100m_resetn_source

  #inteconnects (current monitor 1)

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_current_monitor_1/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mc_current_monitor_1/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_current_monitor_1_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_current_monitor_1_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_current_monitor_1_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_current_monitor_1_dma/m_dest_axi_aresetn] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_current_monitor_1_dma [get_bd_intf_pins axi_current_monitor_1_dma/m_dest_axi] [get_bd_intf_pins sys_ps7/S_AXI_HP1]

  #interconnect (current monitor 2)

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_current_monitor_2/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mc_current_monitor_2/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins axi_current_monitor_2_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_current_monitor_2_dma/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_current_monitor_2_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_current_monitor_2_dma/m_dest_axi_aresetn] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_current_monitor_2_dma [get_bd_intf_pins axi_current_monitor_2_dma/m_dest_axi] [get_bd_intf_pins sys_ps7/S_AXI_HP2]

  # interconnect (speed detector)

#  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mc_speed_1/s_axi_aclk] $sys_100m_clk_source
#  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mc_speed_1/s_axi_aresetn] $sys_100m_resetn_source

#  connect_bd_net -net sys_100m_clk [get_bd_pins axi_speed_detector_dma/m_dest_axi_aclk] $sys_100m_clk_source
#  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_speed_detector_dma/s_axi_aresetn] $sys_100m_resetn_source
#  connect_bd_net -net sys_100m_clk [get_bd_pins axi_speed_detector_dma/s_axi_aclk] $sys_100m_clk_source
#  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_speed_detector_dma/m_dest_axi_aresetn] $sys_100m_resetn_source

#  connect_bd_intf_net -intf_net axi_speed_detector_dma [get_bd_intf_pins axi_speed_detector_dma/m_dest_axi] [get_bd_intf_pins sys_ps7/S_AXI_HP3]

  # interconnect (dmas)

  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP3_ACLK] $sys_100m_clk_source

  # address map

  create_bd_addr_seg -range 0x10000   -offset 0x40400000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_current_monitor_1_dma/s_axi/axi_lite] SEG_data_c_m_1_dma
#  create_bd_addr_seg -range 0x10000   -offset 0x40410000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_speed_detector_dma/s_axi/axi_lite] SEG_data_s_d_dma
  create_bd_addr_seg -range 0x10000   -offset 0x40430000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_current_monitor_2_dma/s_axi/axi_lite] SEG_data_c_m_2_dma
  create_bd_addr_seg -range 0x10000   -offset 0x40500000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_mc_current_monitor_1/s_axi/axi_lite] SEG_data_c_m_1
#  create_bd_addr_seg -range 0x10000   -offset 0x40510000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_mc_speed_1/s_axi/axi_lite] SEG_data_s_d
  create_bd_addr_seg -range 0x10000   -offset 0x40530000 $sys_addr_cntrl_space  [get_bd_addr_segs axi_mc_current_monitor_2/s_axi/axi_lite] SEG_data_c_m_2
  create_bd_addr_seg -range 0x10000   -offset 0x43200000 $sys_addr_cntrl_space  [get_bd_addr_segs xadc_wiz_1/s_axi_lite/Reg] SEG_data_xadc

  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_current_monitor_1_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_current_monitor_2_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm
#  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_speed_detector_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_sys_ps7_hp3_ddr_lowocm
