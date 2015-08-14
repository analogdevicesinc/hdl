
  # motor control


  # port definition


  # position detection interface
  create_bd_port -dir I -from 2 -to 0 position_m1_i
  create_bd_port -dir I -from 2 -to 0 position_m2_i

  # current monitor interface
    # clock
  create_bd_port -dir O adc_clk_o
    # data motor 1
  create_bd_port -dir I adc_m1_ia_dat_i
  create_bd_port -dir I adc_m1_ib_dat_i
  create_bd_port -dir I adc_m1_vbus_dat_i
    # data motor 2
  create_bd_port -dir I adc_m2_ia_dat_i
  create_bd_port -dir I adc_m2_ib_dat_i
  create_bd_port -dir I adc_m2_vbus_dat_i

  # motor control interface
  create_bd_port -dir o -from 3 -to 0 gpo_o
    # motor 1
  create_bd_port -dir O fmc_m1_en_o
  create_bd_port -dir O pwm_m1_al_o
  create_bd_port -dir O pwm_m1_ah_o
  create_bd_port -dir O pwm_m1_cl_o
  create_bd_port -dir O pwm_m1_ch_o
  create_bd_port -dir O pwm_m1_bl_o
  create_bd_port -dir O pwm_m1_bh_o
    # motor 2
  create_bd_port -dir O fmc_m2_en_o
  create_bd_port -dir O pwm_m2_al_o
  create_bd_port -dir O pwm_m2_ah_o
  create_bd_port -dir O pwm_m2_cl_o
  create_bd_port -dir O pwm_m2_ch_o
  create_bd_port -dir O pwm_m2_bl_o
  create_bd_port -dir O pwm_m2_bh_o

  # Ethernet
    # phy 1
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 eth1_rgmii
    # phy 2
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 eth2_rgmii
    #common mdio interface
  create_bd_port -dir O eth_mdio_mdc
  create_bd_port -dir O eth_mdio_o
  create_bd_port -dir O eth_mdio_t
  create_bd_port -dir I eth_mdio_i
    #common reset
  create_bd_port -dir O eth_phy_rst_n
    # reference clock for the delay interface used for the gmii to rgmii conversion
  create_bd_port -dir o -type clk refclk
  create_bd_port -dir o -from 0 -to 0 -type rst refclk_rst

  # iic
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0  iic_ee2

  # xadc interface
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vaux0
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vaux8
  create_bd_port -dir O -from 4 -to 0 muxaddr_out


  # core instantiation and configuration


  # additions to default configuration
    # Enable additional peripherals from the PS7 block
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_ENET0_ENET0_IO {EMIO} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1} ] $sys_ps7

  # Add additional clocks to be used by gmii to rgmii modules and current monitoring modules
  set_property -dict [ list CONFIG.CLKOUT2_USED {true} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT3_USED {true} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT4_USED {true} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT5_USED {true} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {125} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {25} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {20} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {20} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT2_DRIVES {No_buffer} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT3_DRIVES {No_buffer} ] $sys_audio_clkgen
  set_property -dict [ list CONFIG.CLKOUT4_DRIVES {No_buffer} ] $sys_audio_clkgen

  # speed detectors
    # speed detector core motor 1
  set speed_detector_m1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_speed:1.0 speed_detector_m1 ]
    # dma motor 1
  set speed_detector_m1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 speed_detector_m1_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $speed_detector_m1_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $speed_detector_m1_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $speed_detector_m1_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $speed_detector_m1_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $speed_detector_m1_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {32}] $speed_detector_m1_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {0}] $speed_detector_m1_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {0}] $speed_detector_m1_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $speed_detector_m1_dma
    # speed detector core motor 2
  set speed_detector_m2 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_speed:1.0 speed_detector_m2 ]
    # dma motor 2
  set speed_detector_m2_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 speed_detector_m2_dma]
  set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $speed_detector_m2_dma
  set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $speed_detector_m2_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $speed_detector_m2_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $speed_detector_m2_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $speed_detector_m2_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {32}] $speed_detector_m2_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {0}] $speed_detector_m2_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {0}] $speed_detector_m2_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $speed_detector_m2_dma

  # current monitor peripherals
    # current monitor core motor 1
  set current_monitor_m1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_current_monitor:1.0 current_monitor_m1 ]
    # dma motor 1
  set current_monitor_m1_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 current_monitor_m1_dma ]
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $current_monitor_m1_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $current_monitor_m1_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $current_monitor_m1_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {0}] $current_monitor_m1_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {0}] $current_monitor_m1_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $current_monitor_m1_dma
    # data packer motor 1
  #
  set current_monitor_m1_apack [create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 current_monitor_m1_apack]
  set_property -dict [list CONFIG.CHANNELS {4}] $current_monitor_m1_apack

    # current monitor core motor 2
  set current_monitor_m2 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_current_monitor:1.0 current_monitor_m2 ]
    # dma motor 2
  set current_monitor_m2_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 current_monitor_m2_dma ]
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $current_monitor_m2_dma
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $current_monitor_m2_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $current_monitor_m2_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {0}] $current_monitor_m2_dma
  set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {0}] $current_monitor_m2_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $current_monitor_m2_dma
    # data packer motor 2
  set current_monitor_m2_apack [create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 current_monitor_m2_apack]
  set_property -dict [list CONFIG.CHANNELS {4}] $current_monitor_m2_apack

  #controller
    # controller core motor 1
  set controller_m1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_controller:1.0 controller_m1 ]
    # dma motor 1
  set controller_m1_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 controller_m1_dma ]
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $controller_m1_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $controller_m1_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {256}] $controller_m1_dma
    # data packer motor 1
  set controller_m1_apack [create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 controller_m1_apack]
  set_property -dict [list CONFIG.CHANNELS {8}] $controller_m1_apack
  set_property -dict [list CONFIG.DATA_WIDTH {32}] $controller_m1_apack

    # controller core motor 2
  set controller_m2 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_controller:1.0 controller_m2 ]
    # dma motor 2
  set controller_m2_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 controller_m2_dma ]
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $controller_m2_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $controller_m2_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {256}] $controller_m2_dma
    # data packer motor 2
  set controller_m2_apack [create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 controller_m2_apack]
  set_property -dict [list CONFIG.CHANNELS {8}] $controller_m2_apack
  set_property -dict [list CONFIG.DATA_WIDTH {32}] $controller_m2_apack

  #ethernet gmii to rgmii converters
    # phy 1
  set gmii_to_rgmii_eth1 [ create_bd_cell -type ip -vlnv analog.com:user:util_gmii_to_rgmii:1.0 gmii_to_rgmii_eth1 ]
  set_property -dict [list CONFIG.PHY_AD {"00000"}] $gmii_to_rgmii_eth1
  set_property -dict [list CONFIG.IODELAY_CTRL {1}] $gmii_to_rgmii_eth1
    # phy 2
  set gmii_to_rgmii_eth2 [ create_bd_cell -type ip -vlnv analog.com:user:util_gmii_to_rgmii:1.0 gmii_to_rgmii_eth2 ]
  set_property -dict [list CONFIG.PHY_AD {"00001"}] $gmii_to_rgmii_eth2

  # iic
  set iic_ee2  [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 iic_ee2 ]

  # xadc
  set xadc_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.0 xadc_core ]
  set_property -dict [ list CONFIG.XADC_STARUP_SELECTION {simultaneous_sampling} ] $xadc_core
  set_property -dict [ list CONFIG.ENABLE_EXTERNAL_MUX {true} ] $xadc_core
  set_property -dict [ list CONFIG.EXTERNAL_MUX_CHANNEL  {VAUXP0_VAUXN0} ] $xadc_core
  set_property -dict [ list CONFIG.OT_ALARM {false} ] $xadc_core
  set_property -dict [ list CONFIG.USER_TEMP_ALARM {false}  ] $xadc_core
  set_property -dict [ list CONFIG.VCCAUX_ALARM {false} ] $xadc_core
  set_property -dict [ list CONFIG.VCCINT_ALARM {false} ] $xadc_core

  # connections


  # speed detector
    # motor 1
  ad_connect  sys_cpu_clk speed_detector_m1/ref_clk

  ad_connect  sys_cpu_clk speed_detector_m1_dma/fifo_wr_clk

  ad_connect  position_m1_i speed_detector_m1/position_i
  ad_connect  speed_detector_m1/new_speed_o speed_detector_m1_dma/fifo_wr_en
  ad_connect  speed_detector_m1/speed_o speed_detector_m1_dma/fifo_wr_din
    # motor 2
  ad_connect sys_cpu_clk speed_detector_m2/ref_clk

  ad_connect sys_cpu_clk speed_detector_m2_dma/fifo_wr_clk

  ad_connect position_m2_i speed_detector_m2/position_i
  ad_connect speed_detector_m2/new_speed_o speed_detector_m2_dma/fifo_wr_en
  ad_connect speed_detector_m2/speed_o speed_detector_m2_dma/fifo_wr_din

  # current monitor
  ad_connect adc_clk_o current_monitor_m1/adc_clk_o
    # motor 1
  ad_connect sys_cpu_clk current_monitor_m1/ref_clk

  ad_connect sys_cpu_clk current_monitor_m1_dma/fifo_wr_clk

  ad_connect current_monitor_m1/adc_clk_i sys_audio_clkgen/clk_out5
  ad_connect adc_m1_ia_dat_i current_monitor_m1/adc_ia_dat_i
  ad_connect adc_m1_ib_dat_i current_monitor_m1/adc_ib_dat_i
  ad_connect adc_m1_vbus_dat_i current_monitor_m1/adc_vbus_dat_i

  ad_connect sys_cpu_clk current_monitor_m1_apack/clk
  ad_connect current_monitor_m1/adc_enable_ia current_monitor_m1_apack/chan_enable_0
  ad_connect current_monitor_m1/adc_enable_ib current_monitor_m1_apack/chan_enable_1
  ad_connect current_monitor_m1/adc_enable_vbus current_monitor_m1_apack/chan_enable_2
  ad_connect current_monitor_m1/adc_enable_stub current_monitor_m1_apack/chan_enable_3
  ad_connect current_monitor_m1_apack/chan_valid_0 current_monitor_m1/i_ready_o
  ad_connect current_monitor_m1_apack/chan_valid_1 current_monitor_m1/i_ready_o
  ad_connect current_monitor_m1_apack/chan_valid_2 current_monitor_m1/i_ready_o
  ad_connect current_monitor_m1_apack/chan_valid_3 current_monitor_m1/i_ready_o
  ad_connect current_monitor_m1/ia_o current_monitor_m1_apack/chan_data_0
  ad_connect current_monitor_m1/ib_o current_monitor_m1_apack/chan_data_1
  ad_connect current_monitor_m1/vbus_o current_monitor_m1_apack/chan_data_2
  ad_connect current_monitor_m1/vbus_o current_monitor_m1_apack/chan_data_3
  ad_connect current_monitor_m1_apack/ddata current_monitor_m1_dma/fifo_wr_din
  ad_connect current_monitor_m1_apack/dvalid current_monitor_m1_dma/fifo_wr_en

    # motor 2
  ad_connect  sys_cpu_clk current_monitor_m2/ref_clk

  ad_connect  sys_cpu_clk current_monitor_m2_dma/fifo_wr_clk

  ad_connect  current_monitor_m2/adc_clk_i sys_audio_clkgen/clk_out5
  ad_connect  adc_m2_ia_dat_i  current_monitor_m2/adc_ia_dat_i
  ad_connect  adc_m2_ib_dat_i  current_monitor_m2/adc_ib_dat_i
  ad_connect  adc_m2_vbus_dat_i current_monitor_m2/adc_vbus_dat_i

  ad_connect   sys_cpu_clk current_monitor_m2_apack/clk
  ad_connect   current_monitor_m2/adc_enable_ia current_monitor_m2_apack/chan_enable_0
  ad_connect   current_monitor_m2/adc_enable_ib current_monitor_m2_apack/chan_enable_1
  ad_connect   current_monitor_m2/adc_enable_vbus current_monitor_m2_apack/chan_enable_2
  ad_connect   current_monitor_m2/adc_enable_stub current_monitor_m2_apack/chan_enable_3
  ad_connect   current_monitor_m2_apack/chan_valid_0 current_monitor_m2/i_ready_o
  ad_connect   current_monitor_m2_apack/chan_valid_1 current_monitor_m2/i_ready_o
  ad_connect   current_monitor_m2_apack/chan_valid_2 current_monitor_m2/i_ready_o
  ad_connect   current_monitor_m2_apack/chan_valid_3 current_monitor_m2/i_ready_o
  ad_connect   current_monitor_m2/ia_o current_monitor_m2_apack/chan_data_0
  ad_connect   current_monitor_m2/ib_o current_monitor_m2_apack/chan_data_1
  ad_connect   current_monitor_m2/vbus_o current_monitor_m2_apack/chan_data_2
  ad_connect   current_monitor_m2/vbus_o current_monitor_m2_apack/chan_data_3
  ad_connect   current_monitor_m2_apack/ddata current_monitor_m2_dma/fifo_wr_din
  ad_connect   current_monitor_m2_apack/dvalid current_monitor_m2_dma/fifo_wr_en

  #controller
    # motor 1
  ad_connect sys_cpu_clk controller_m1/ref_clk
  ad_connect controller_m1/ctrl_data_clk sys_audio_clkgen/clk_out5

  ad_connect sys_cpu_clk controller_m1_dma/fifo_wr_clk

  ad_connect fmc_m1_en_o   controller_m1/fmc_en_o
  ad_connect pwm_m1_al_o   controller_m1/pwm_al_o
  ad_connect pwm_m1_ah_o   controller_m1/pwm_ah_o
  ad_connect pwm_m1_bl_o   controller_m1/pwm_bl_o
  ad_connect pwm_m1_bh_o   controller_m1/pwm_bh_o
  ad_connect pwm_m1_cl_o   controller_m1/pwm_cl_o
  ad_connect pwm_m1_ch_o   controller_m1/pwm_ch_o

  ad_connect controller_m1/sensors_o speed_detector_m1/hall_bemf_i
  ad_connect controller_m1/position_i speed_detector_m1/position_o
  ad_connect controller_m1/ctrl_data_valid_i current_monitor_m1/i_ready_o

  ad_connect  sys_cpu_clk controller_m1_apack/clk

  ad_connect  controller_m1/adc_enable_c0 controller_m1_apack/chan_enable_0
  ad_connect  controller_m1/adc_enable_c1 controller_m1_apack/chan_enable_1
  ad_connect  controller_m1/adc_enable_c2 controller_m1_apack/chan_enable_2
  ad_connect  controller_m1/adc_enable_c3 controller_m1_apack/chan_enable_3
  ad_connect  controller_m1/adc_enable_c4 controller_m1_apack/chan_enable_4
  ad_connect  controller_m1/adc_enable_c5 controller_m1_apack/chan_enable_5
  ad_connect  controller_m1/adc_enable_c6 controller_m1_apack/chan_enable_6
  ad_connect  controller_m1/adc_enable_c7 controller_m1_apack/chan_enable_7

  ad_connect  controller_m1/adc_valid_c0 controller_m1_apack/chan_valid_0
  ad_connect  controller_m1/adc_valid_c1 controller_m1_apack/chan_valid_1
  ad_connect  controller_m1/adc_valid_c2 controller_m1_apack/chan_valid_2
  ad_connect  controller_m1/adc_valid_c3 controller_m1_apack/chan_valid_3
  ad_connect  controller_m1/adc_valid_c4 controller_m1_apack/chan_valid_4
  ad_connect  controller_m1/adc_valid_c5 controller_m1_apack/chan_valid_5
  ad_connect  controller_m1/adc_valid_c6 controller_m1_apack/chan_valid_6
  ad_connect  controller_m1/adc_valid_c7 controller_m1_apack/chan_valid_7

  ad_connect  controller_m1/adc_data_c0 controller_m1_apack/chan_data_0
  ad_connect  controller_m1/adc_data_c1 controller_m1_apack/chan_data_1
  ad_connect  controller_m1/adc_data_c2 controller_m1_apack/chan_data_2
  ad_connect  controller_m1/adc_data_c3 controller_m1_apack/chan_data_3
  ad_connect  controller_m1/adc_data_c4 controller_m1_apack/chan_data_4
  ad_connect  controller_m1/adc_data_c5 controller_m1_apack/chan_data_5
  ad_connect  controller_m1/adc_data_c6 controller_m1_apack/chan_data_6
  ad_connect  controller_m1/adc_data_c7 controller_m1_apack/chan_data_7

  ad_connect controller_m1_apack/ddata controller_m1_dma/fifo_wr_din
  ad_connect controller_m1_apack/dvalid controller_m1_dma/fifo_wr_en

    # motor 2
  ad_connect sys_cpu_clk controller_m2/ref_clk
  ad_connect controller_m2/ctrl_data_clk sys_audio_clkgen/clk_out5

  ad_connect sys_cpu_clk controller_m2_dma/fifo_wr_clk

  ad_connect  fmc_m2_en_o controller_m2/fmc_en_o
  ad_connect  pwm_m2_al_o controller_m2/pwm_al_o
  ad_connect  pwm_m2_ah_o controller_m2/pwm_ah_o
  ad_connect  pwm_m2_bl_o controller_m2/pwm_bl_o
  ad_connect  pwm_m2_bh_o controller_m2/pwm_bh_o
  ad_connect  pwm_m2_cl_o controller_m2/pwm_cl_o
  ad_connect  pwm_m2_ch_o controller_m2/pwm_ch_o

  ad_connect controller_m2/sensors_o speed_detector_m2/hall_bemf_i
  ad_connect controller_m2/position_i speed_detector_m2/position_o
  ad_connect controller_m2/ctrl_data_valid_i current_monitor_m2/i_ready_o

  ad_connect sys_cpu_clk controller_m2_apack/clk

  ad_connect  controller_m2/adc_enable_c0 controller_m2_apack/chan_enable_0
  ad_connect  controller_m2/adc_enable_c1 controller_m2_apack/chan_enable_1
  ad_connect  controller_m2/adc_enable_c2 controller_m2_apack/chan_enable_2
  ad_connect  controller_m2/adc_enable_c3 controller_m2_apack/chan_enable_3
  ad_connect  controller_m2/adc_enable_c4 controller_m2_apack/chan_enable_4
  ad_connect  controller_m2/adc_enable_c5 controller_m2_apack/chan_enable_5
  ad_connect  controller_m2/adc_enable_c6 controller_m2_apack/chan_enable_6
  ad_connect  controller_m2/adc_enable_c7 controller_m2_apack/chan_enable_7

  ad_connect  controller_m2/adc_valid_c0 controller_m2_apack/chan_valid_0
  ad_connect  controller_m2/adc_valid_c1 controller_m2_apack/chan_valid_1
  ad_connect  controller_m2/adc_valid_c2 controller_m2_apack/chan_valid_2
  ad_connect  controller_m2/adc_valid_c3 controller_m2_apack/chan_valid_3
  ad_connect  controller_m2/adc_valid_c4 controller_m2_apack/chan_valid_4
  ad_connect  controller_m2/adc_valid_c5 controller_m2_apack/chan_valid_5
  ad_connect  controller_m2/adc_valid_c6 controller_m2_apack/chan_valid_6
  ad_connect  controller_m2/adc_valid_c7 controller_m2_apack/chan_valid_7

  ad_connect  controller_m2/adc_data_c0 controller_m2_apack/chan_data_0
  ad_connect  controller_m2/adc_data_c1 controller_m2_apack/chan_data_1
  ad_connect  controller_m2/adc_data_c2 controller_m2_apack/chan_data_2
  ad_connect  controller_m2/adc_data_c3 controller_m2_apack/chan_data_3
  ad_connect  controller_m2/adc_data_c4 controller_m2_apack/chan_data_4
  ad_connect  controller_m2/adc_data_c5 controller_m2_apack/chan_data_5
  ad_connect  controller_m2/adc_data_c6 controller_m2_apack/chan_data_6
  ad_connect  controller_m2/adc_data_c7 controller_m2_apack/chan_data_7

  ad_connect controller_m2_apack/ddata controller_m2_dma/fifo_wr_din
  ad_connect controller_m2_apack/dvalid controller_m2_dma/fifo_wr_en

  # ethernet


  ad_connect sys_200m_clk refclk
  ad_connect sys_cpu_resetn refclk_rst
  ad_connect sys_cpu_resetn eth_phy_rst_n
  ad_connect sys_ps7/ENET0_MDIO_MDC eth_mdio_mdc
  ad_connect sys_ps7/ENET0_MDIO_O eth_mdio_o
  ad_connect sys_ps7/ENET0_MDIO_T eth_mdio_t
  ad_connect sys_ps7/ENET0_MDIO_I eth_mdio_i
    # phy 1
  ad_connect sys_200m_clk gmii_to_rgmii_eth1/idelayctrl_clk
  ad_connect gmii_to_rgmii_eth1/gmii sys_ps7/GMII_ETHERNET_0
  ad_connect eth1_rgmii gmii_to_rgmii_eth1/rgmii
  ad_connect gmii_to_rgmii_eth1/reset sys_rstgen/peripheral_reset

  ad_connect gmii_to_rgmii_eth1/clk_20m sys_audio_clkgen/clk_out4
  ad_connect gmii_to_rgmii_eth1/clk_25m sys_audio_clkgen/clk_out3
  ad_connect gmii_to_rgmii_eth1/clk_125m sys_audio_clkgen/clk_out2
  ad_connect eth_mdio_mdc gmii_to_rgmii_eth1/mdio_mdc
  ad_connect eth_mdio_o gmii_to_rgmii_eth1/mdio_in_w
  ad_connect eth_mdio_i gmii_to_rgmii_eth1/mdio_in_r
    # phy 2
  ad_connect gmii_to_rgmii_eth2/gmii sys_ps7/GMII_ETHERNET_1
  ad_connect eth2_rgmii gmii_to_rgmii_eth2/rgmii
  ad_connect gmii_to_rgmii_eth2/reset sys_rstgen/peripheral_reset
  ad_connect gmii_to_rgmii_eth2/clk_20m sys_audio_clkgen/clk_out4
  ad_connect gmii_to_rgmii_eth2/clk_25m sys_audio_clkgen/clk_out3
  ad_connect gmii_to_rgmii_eth2/clk_125m sys_audio_clkgen/clk_out2

  ad_connect eth_mdio_mdc gmii_to_rgmii_eth2/mdio_mdc
  ad_connect eth_mdio_o gmii_to_rgmii_eth2/mdio_in_w
  ad_connect eth_mdio_i gmii_to_rgmii_eth2/mdio_in_r

  # xadc
  ad_connect xadc_core/Vaux0 vaux0
  ad_connect xadc_core/Vaux8 vaux8
  ad_connect xadc_core/muxaddr_out muxaddr_out

  # iic
  ad_connect iic_ee2/IIC iic_ee2

  ad_connect  sys_cpu_resetn speed_detector_m1_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn speed_detector_m2_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn current_monitor_m1_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn current_monitor_m2_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn controller_m1_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn controller_m2_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn xadc_core/s_axi_aresetn

  # address map
  ad_cpu_interconnect  0x40410000 speed_detector_m1
  ad_cpu_interconnect  0x40420000 current_monitor_m1
  ad_cpu_interconnect  0x40430000 controller_m1
  ad_cpu_interconnect  0x40440000 speed_detector_m2
  ad_cpu_interconnect  0x40450000 current_monitor_m2
  ad_cpu_interconnect  0x40460000 controller_m2
  ad_cpu_interconnect  0x40510000 speed_detector_m1_dma
  ad_cpu_interconnect  0x40520000 current_monitor_m1_dma
  ad_cpu_interconnect  0x40530000 controller_m1_dma
  ad_cpu_interconnect  0x40540000 speed_detector_m2_dma
  ad_cpu_interconnect  0x40550000 current_monitor_m2_dma
  ad_cpu_interconnect  0x40560000 controller_m2_dma
  ad_cpu_interconnect  0x43200000 xadc_core
  ad_cpu_interconnect  0x41510000 iic_ee2

  ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
  ad_mem_hp1_interconnect sys_cpu_clk speed_detector_m1_dma/m_dest_axi
  ad_mem_hp1_interconnect sys_cpu_clk speed_detector_m2_dma/m_dest_axi
  ad_mem_hp1_interconnect sys_cpu_clk current_monitor_m1_dma/m_dest_axi
  ad_mem_hp1_interconnect sys_cpu_clk current_monitor_m2_dma/m_dest_axi
  ad_mem_hp1_interconnect sys_cpu_clk controller_m1_dma/m_dest_axi
  ad_mem_hp1_interconnect sys_cpu_clk controller_m2_dma/m_dest_axi

  ad_cpu_interrupt ps-5 mb-5 xadc_core/ip2intc_irpt
  ad_cpu_interrupt ps-6 mb-6 controller_m2_dma/irq
  ad_cpu_interrupt ps-7 mb-7 current_monitor_m2_dma/irq
  ad_cpu_interrupt ps-8 mb-8 speed_detector_m2_dma/irq
  ad_cpu_interrupt ps-9 mb-9 controller_m1_dma/irq
  ad_cpu_interrupt ps-10 mb-10 current_monitor_m1_dma/irq
  ad_cpu_interrupt ps-12 mb-12 iic_ee2/iic2intc_irpt
  ad_cpu_interrupt ps-13 mb-13 speed_detector_m1_dma/irq
