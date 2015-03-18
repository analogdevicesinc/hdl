
  # motor control


  # port definition


  # gpio
  set_property LEFT 34 [get_bd_ports GPIO_I]
  set_property LEFT 34 [get_bd_ports GPIO_O]
  set_property LEFT 34 [get_bd_ports GPIO_T]

  # position detection interface
  set position_m1_i [ create_bd_port -dir I -from 2 -to 0 position_m1_i ]
  set position_m2_i [ create_bd_port -dir I -from 2 -to 0 position_m2_i ]

  # current monitor interface
    # clock
  set adc_clk_o [ create_bd_port -dir O adc_clk_o ]
    # data motor 1
  set adc_m1_ia_dat_i [ create_bd_port -dir I adc_m1_ia_dat_i ]
  set adc_m1_ib_dat_i [ create_bd_port -dir I adc_m1_ib_dat_i ]
  set adc_m1_vbus_dat_i [ create_bd_port -dir I adc_m1_vbus_dat_i ]
    # data motor 2
  set adc_m2_ia_dat_i [ create_bd_port -dir I adc_m2_ia_dat_i ]
  set adc_m2_ib_dat_i [ create_bd_port -dir I adc_m2_ib_dat_i ]
  set adc_m2_vbus_dat_i [ create_bd_port -dir I adc_m2_vbus_dat_i ]

  # motor control interface
  set gpo_o [ create_bd_port -dir o -from 3 -to 0 gpo_o]
    # motor 1
  set fmc_m1_en_o [ create_bd_port -dir O fmc_m1_en_o]
  set pwm_m1_al_o [ create_bd_port -dir O pwm_m1_al_o]
  set pwm_m1_ah_o [ create_bd_port -dir O pwm_m1_ah_o]
  set pwm_m1_cl_o [ create_bd_port -dir O pwm_m1_cl_o]
  set pwm_m1_ch_o [ create_bd_port -dir O pwm_m1_ch_o]
  set pwm_m1_bl_o [ create_bd_port -dir O pwm_m1_bl_o]
  set pwm_m1_bh_o [ create_bd_port -dir O pwm_m1_bh_o]
    # motor 2
  set fmc_m2_en_o [ create_bd_port -dir O fmc_m2_en_o]
  set pwm_m2_al_o [ create_bd_port -dir O pwm_m2_al_o]
  set pwm_m2_ah_o [ create_bd_port -dir O pwm_m2_ah_o]
  set pwm_m2_cl_o [ create_bd_port -dir O pwm_m2_cl_o]
  set pwm_m2_ch_o [ create_bd_port -dir O pwm_m2_ch_o]
  set pwm_m2_bl_o [ create_bd_port -dir O pwm_m2_bl_o]
  set pwm_m2_bh_o [ create_bd_port -dir O pwm_m2_bh_o]

  # Ethernet
    # phy 1
  set eth1_rgmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 eth1_rgmii ]
    # phy 2
  set eth2_rgmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 eth2_rgmii ]
    #common mdio interface
  set eth_mdio_mdc [ create_bd_port -dir O eth_mdio_mdc ]
  set eth_mdio_o [ create_bd_port -dir O eth_mdio_o ]
  set eth_mdio_t [ create_bd_port -dir O eth_mdio_t ]
  set eth_mdio_i [ create_bd_port -dir I eth_mdio_i ]
    #common reset
  set eth_phy_rst_n [ create_bd_port -dir O eth_phy_rst_n ]
    # reference clock for the delay interface used for the gmii to rgmii conversion
  set refclk [ create_bd_port -dir o -type clk refclk ]
  set refclk_rst [ create_bd_port -dir o -from 0 -to 0 -type rst refclk_rst ]

  # iic
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0  iic_ee2

  # spi
  set spi_csn_i       [create_bd_port -dir I spi_csn_i]
  set spi_csn_o       [create_bd_port -dir O spi_csn_o]
  set spi_sclk_i      [create_bd_port -dir I spi_sclk_i]
  set spi_sclk_o      [create_bd_port -dir O spi_sclk_o]
  set spi_mosi_i      [create_bd_port -dir I spi_mosi_i]
  set spi_mosi_o      [create_bd_port -dir O spi_mosi_o]
  set spi_miso_i      [create_bd_port -dir I spi_miso_i]

  # xadc interface
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8
  #create_bd_port -dir O -from 4 -to 0 muxaddr_out


  # core instantiation and configuration


  # additions to default configuration
    # increase cpu interconnect to accomodate new cores
  set_property -dict [list CONFIG.NUM_MI {21}] $axi_cpu_interconnect
    # Enable additional peripherals from the PS7 block
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_ENET0_ENET0_IO {EMIO} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1} ] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
  set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {35}] $sys_ps7

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
#  set current_monitor_m1_pack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 current_monitor_m1_pack ]
#  set_property -dict [ list CONFIG.CH_CNT {4}  ] $current_monitor_m1_pack
#  set_property -dict [ list CONFIG.CH_DW {16}  ] $current_monitor_m1_pack

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
  #set current_monitor_m2_pack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 current_monitor_m2_pack ]
  #set_property -dict [ list CONFIG.CH_CNT {4}  ] $current_monitor_m2_pack
  #set_property -dict [ list CONFIG.CH_DW {16}  ] $current_monitor_m2_pack

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

  #set controller_m1_pack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 controller_m1_pack ]
  #set_property -dict [ list CONFIG.CH_CNT {8}  ] $controller_m1_pack
  #set_property -dict [ list CONFIG.CH_DW {32}  ] $controller_m1_pack
    # controller core motor 2
  set controller_m2 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_controller:1.0 controller_m2 ]
    # dma motor 2
  set controller_m2_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 controller_m2_dma ]
  set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $controller_m2_dma
  set_property -dict [list CONFIG.C_CYCLIC {0}] $controller_m2_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {256}] $controller_m2_dma
    # data packer motor 2
  #set controller_m2_pack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 controller_m2_pack ]
  #set_property -dict [ list CONFIG.CH_CNT {8}  ] $controller_m2_pack
  set controller_m2_apack [create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 controller_m2_apack]
  set_property -dict [list CONFIG.CHANNELS {8}] $controller_m2_apack
  set_property -dict [list CONFIG.DATA_WIDTH {32}] $controller_m2_apack

  #ethernet gmii to rgmii converters
    # phy 1
  set gmii_to_rgmii_eth1 [ create_bd_cell -type ip -vlnv analog.com:user:util_gmii_to_rgmii:1.0 gmii_to_rgmii_eth1 ]
  set_property -dict [list CONFIG.PHY_AD {"00000"}] [get_bd_cells gmii_to_rgmii_eth1]
    # phy 2
  set gmii_to_rgmii_eth2 [ create_bd_cell -type ip -vlnv analog.com:user:util_gmii_to_rgmii:1.0 gmii_to_rgmii_eth2 ]
  set_property -dict [list CONFIG.PHY_AD {"00001"}] [get_bd_cells gmii_to_rgmii_eth2]

  # iic
  set iic_ee2  [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 iic_ee2 ]

  # xadc
  set xadc_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.0 xadc_core ]
  set_property -dict [ list CONFIG.XADC_STARUP_SELECTION {simultaneous_sampling} ] $xadc_core
  set_property -dict [ list CONFIG.ENABLE_EXTERNAL_MUX {false} ] $xadc_core
  set_property -dict [ list CONFIG.CHANNEL_ENABLE_VAUXP0_VAUXN0  {true} ] $xadc_core
  set_property -dict [ list CONFIG.OT_ALARM {false} ] $xadc_core
  set_property -dict [ list CONFIG.USER_TEMP_ALARM {false}  ] $xadc_core
  set_property -dict [ list CONFIG.VCCAUX_ALARM {false} ] $xadc_core
  set_property -dict [ list CONFIG.VCCINT_ALARM {false} ] $xadc_core

  # additional interconnect
  set axi_mem_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_interconnect ]
  set_property -dict [ list CONFIG.NUM_SI {6} CONFIG.NUM_MI {1}  ] $axi_mem_interconnect


  # connections


  # speed detector
    # motor 1
  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m1/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m1/ref_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins speed_detector_m1/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m1_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m1_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m1_dma/fifo_wr_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins speed_detector_m1_dma/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins speed_detector_m1_dma/m_dest_axi_aresetn]

  connect_bd_net -net position_m1_i_1 [get_bd_ports position_m1_i] [get_bd_pins speed_detector_m1/position_i]
  connect_bd_net -net speed_detector_adc_new_speed_m1    [get_bd_pins speed_detector_m1/new_speed_o] [get_bd_pins speed_detector_m1_dma/fifo_wr_en]
  connect_bd_net -net speed_detector_adc_speed_m1  [get_bd_pins speed_detector_m1/speed_o] [get_bd_pins speed_detector_m1_dma/fifo_wr_din]
    # motor 2
  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m2/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m2/ref_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins speed_detector_m2/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m2_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m2_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins speed_detector_m2_dma/fifo_wr_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins speed_detector_m2_dma/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins speed_detector_m2_dma/m_dest_axi_aresetn]

  connect_bd_net -net position_m2_i_1 [get_bd_ports position_m2_i] [get_bd_pins speed_detector_m2/position_i]
  connect_bd_net -net speed_detector_adc_new_speed_m2    [get_bd_pins speed_detector_m2/new_speed_o] [get_bd_pins speed_detector_m2_dma/fifo_wr_en]
  connect_bd_net -net speed_detector_adc_speed_m2 [get_bd_pins speed_detector_m2/speed_o] [get_bd_pins speed_detector_m2_dma/fifo_wr_din]

  # current monitor
  connect_bd_net -net current_monitor_m1_adc_clk_o   [get_bd_ports adc_clk_o]   [get_bd_pins current_monitor_m1/adc_clk_o]
    # motor 1
  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m1/ref_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m1/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins current_monitor_m1/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m1_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m1_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m1_dma/fifo_wr_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins current_monitor_m1_dma/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins current_monitor_m1_dma/m_dest_axi_aresetn]

  connect_bd_net -net sys_audio_clkgen_clk_out5      [get_bd_pins current_monitor_m1/adc_clk_i] [get_bd_pins sys_audio_clkgen/clk_out5]
  connect_bd_net -net adc_m1_ia_dat_i_1 [get_bd_ports adc_m1_ia_dat_i]     [get_bd_pins current_monitor_m1/adc_ia_dat_i]
  connect_bd_net -net adc_m1_ib_dat_i_1 [get_bd_ports adc_m1_ib_dat_i]     [get_bd_pins current_monitor_m1/adc_ib_dat_i]
  connect_bd_net -net adc_m1_vbus_dat_i_1 [get_bd_ports adc_m1_vbus_dat_i] [get_bd_pins current_monitor_m1/adc_vbus_dat_i]

  connect_bd_net -net [get_bd_nets sys_100m_clk] [get_bd_pins current_monitor_m1_apack/clk] [get_bd_pins sys_ps7/FCLK_CLK0]
  connect_bd_net -net current_monitor_m1_adc_enable_ia [get_bd_pins current_monitor_m1/adc_enable_ia] [get_bd_pins current_monitor_m1_apack/chan_enable_0]
  connect_bd_net -net current_monitor_m1_adc_enable_ib [get_bd_pins current_monitor_m1/adc_enable_ib] [get_bd_pins current_monitor_m1_apack/chan_enable_1]
  connect_bd_net -net current_monitor_m1_adc_enable_vbus [get_bd_pins current_monitor_m1/adc_enable_vbus] [get_bd_pins current_monitor_m1_apack/chan_enable_2]
  connect_bd_net -net current_monitor_m1_adc_enable_stub [get_bd_pins current_monitor_m1/adc_enable_stub] [get_bd_pins current_monitor_m1_apack/chan_enable_3]
  connect_bd_net -net current_monitor_m1_i_ready_o [get_bd_pins current_monitor_m1_apack/chan_valid_0] [get_bd_pins current_monitor_m1/i_ready_o]
  connect_bd_net -net current_monitor_m1_i_ready_o [get_bd_pins current_monitor_m1_apack/chan_valid_1] [get_bd_pins current_monitor_m1/i_ready_o]
  connect_bd_net -net current_monitor_m1_i_ready_o [get_bd_pins current_monitor_m1_apack/chan_valid_2] [get_bd_pins current_monitor_m1/i_ready_o]
  connect_bd_net -net current_monitor_m1_i_ready_o [get_bd_pins current_monitor_m1_apack/chan_valid_3] [get_bd_pins current_monitor_m1/i_ready_o]
  connect_bd_net [get_bd_pins current_monitor_m1/ia_o] [get_bd_pins current_monitor_m1_apack/chan_data_0]
  connect_bd_net [get_bd_pins current_monitor_m1/ib_o] [get_bd_pins current_monitor_m1_apack/chan_data_1]
  connect_bd_net [get_bd_pins current_monitor_m1/vbus_o] [get_bd_pins current_monitor_m1_apack/chan_data_2]
  connect_bd_net [get_bd_pins current_monitor_m1/vbus_o] [get_bd_pins current_monitor_m1_apack/chan_data_3]
  connect_bd_net [get_bd_pins current_monitor_m1_apack/ddata] [get_bd_pins current_monitor_m1_dma/fifo_wr_din]
  connect_bd_net [get_bd_pins current_monitor_m1_apack/dvalid] [get_bd_pins current_monitor_m1_dma/fifo_wr_en]

#  connect_bd_net -net [get_bd_nets sys_100m_clk] [get_bd_pins current_monitor_m1_pack/adc_clk] [get_bd_pins sys_ps7/FCLK_CLK0]
#  connect_bd_net -net [get_bd_nets sys_rstgen_peripheral_reset] [get_bd_pins current_monitor_m1_pack/adc_rst] [get_bd_pins sys_rstgen/peripheral_reset]
#  connect_bd_net -net current_monitor_m1_adc_enable_ia [get_bd_pins current_monitor_m1/adc_enable_ia] [get_bd_pins current_monitor_m1_pack/adc_enable_0]
#  connect_bd_net -net current_monitor_m1_adc_enable_ib [get_bd_pins current_monitor_m1/adc_enable_ib] [get_bd_pins current_monitor_m1_pack/adc_enable_1]
#  connect_bd_net -net current_monitor_m1_adc_enable_vbus [get_bd_pins current_monitor_m1/adc_enable_vbus] [get_bd_pins current_monitor_m1_pack/adc_enable_2]
#  connect_bd_net -net current_monitor_m1_adc_enable_stub [get_bd_pins current_monitor_m1/adc_enable_stub] [get_bd_pins current_monitor_m1_pack/adc_enable_3]
#  connect_bd_net -net current_monitor_m1_i_ready_o [get_bd_pins current_monitor_m1_pack/adc_valid_0] [get_bd_pins current_monitor_m1/i_ready_o]
#  connect_bd_net -net current_monitor_m1_i_ready_o [get_bd_pins current_monitor_m1_pack/adc_valid_1] [get_bd_pins current_monitor_m1/i_ready_o]
#  connect_bd_net -net current_monitor_m1_i_ready_o [get_bd_pins current_monitor_m1_pack/adc_valid_2] [get_bd_pins current_monitor_m1/i_ready_o]
#  connect_bd_net -net current_monitor_m1_i_ready_o [get_bd_pins current_monitor_m1_pack/adc_valid_3] [get_bd_pins current_monitor_m1/i_ready_o]
#  connect_bd_net [get_bd_pins current_monitor_m1/ia_o] [get_bd_pins current_monitor_m1_pack/adc_data_0]
#  connect_bd_net [get_bd_pins current_monitor_m1/ib_o] [get_bd_pins current_monitor_m1_pack/adc_data_1]
#  connect_bd_net [get_bd_pins current_monitor_m1/vbus_o] [get_bd_pins current_monitor_m1_pack/adc_data_2]
#  connect_bd_net [get_bd_pins current_monitor_m1/vbus_o] [get_bd_pins current_monitor_m1_pack/adc_data_3]
#  connect_bd_net [get_bd_pins current_monitor_m1_pack/adc_data] [get_bd_pins current_monitor_m1_dma/fifo_wr_din]
#  connect_bd_net [get_bd_pins current_monitor_m1_pack/adc_valid] [get_bd_pins current_monitor_m1_dma/fifo_wr_en]

    # motor 2
  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m2/ref_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m2/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins current_monitor_m2/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m2_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m2_dma/fifo_wr_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins current_monitor_m2_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins current_monitor_m2_dma/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins current_monitor_m2_dma/m_dest_axi_aresetn]

  connect_bd_net -net sys_audio_clkgen_clk_out5      [get_bd_pins current_monitor_m2/adc_clk_i] [get_bd_pins sys_audio_clkgen/clk_out5]
  connect_bd_net -net adc_m2_ia_dat_i_1 [get_bd_ports adc_m2_ia_dat_i]     [get_bd_pins current_monitor_m2/adc_ia_dat_i]
  connect_bd_net -net adc_m2_ib_dat_i_1 [get_bd_ports adc_m2_ib_dat_i]     [get_bd_pins current_monitor_m2/adc_ib_dat_i]
  connect_bd_net -net adc_m2_vbus_dat_i_1 [get_bd_ports adc_m2_vbus_dat_i] [get_bd_pins current_monitor_m2/adc_vbus_dat_i]

  connect_bd_net -net [get_bd_nets sys_100m_clk] [get_bd_pins current_monitor_m2_apack/clk] [get_bd_pins sys_ps7/FCLK_CLK0]
  connect_bd_net -net current_monitor_m2_adc_enable_ia [get_bd_pins current_monitor_m2/adc_enable_ia] [get_bd_pins current_monitor_m2_apack/chan_enable_0]
  connect_bd_net -net current_monitor_m2_adc_enable_ib [get_bd_pins current_monitor_m2/adc_enable_ib] [get_bd_pins current_monitor_m2_apack/chan_enable_1]
  connect_bd_net -net current_monitor_m2_adc_enable_vbus [get_bd_pins current_monitor_m2/adc_enable_vbus] [get_bd_pins current_monitor_m2_apack/chan_enable_2]
  connect_bd_net -net current_monitor_m2_adc_enable_stub [get_bd_pins current_monitor_m2/adc_enable_stub] [get_bd_pins current_monitor_m2_apack/chan_enable_3]
  connect_bd_net -net current_monitor_m2_i_ready_o [get_bd_pins current_monitor_m2_apack/chan_valid_0] [get_bd_pins current_monitor_m2/i_ready_o]
  connect_bd_net -net current_monitor_m2_i_ready_o [get_bd_pins current_monitor_m2_apack/chan_valid_1] [get_bd_pins current_monitor_m2/i_ready_o]
  connect_bd_net -net current_monitor_m2_i_ready_o [get_bd_pins current_monitor_m2_apack/chan_valid_2] [get_bd_pins current_monitor_m2/i_ready_o]
  connect_bd_net -net current_monitor_m2_i_ready_o [get_bd_pins current_monitor_m2_apack/chan_valid_3] [get_bd_pins current_monitor_m2/i_ready_o]
  connect_bd_net [get_bd_pins current_monitor_m2/ia_o] [get_bd_pins current_monitor_m2_apack/chan_data_0]
  connect_bd_net [get_bd_pins current_monitor_m2/ib_o] [get_bd_pins current_monitor_m2_apack/chan_data_1]
  connect_bd_net [get_bd_pins current_monitor_m2/vbus_o] [get_bd_pins current_monitor_m2_apack/chan_data_2]
  connect_bd_net [get_bd_pins current_monitor_m2/vbus_o] [get_bd_pins current_monitor_m2_apack/chan_data_3]
  connect_bd_net [get_bd_pins current_monitor_m2_apack/ddata] [get_bd_pins current_monitor_m2_dma/fifo_wr_din]
  connect_bd_net [get_bd_pins current_monitor_m2_apack/dvalid] [get_bd_pins current_monitor_m2_dma/fifo_wr_en]
#  connect_bd_net -net [get_bd_nets sys_100m_clk] [get_bd_pins current_monitor_m2_pack/adc_clk] [get_bd_pins sys_ps7/FCLK_CLK0]
#  connect_bd_net -net [get_bd_nets sys_rstgen_peripheral_reset] [get_bd_pins current_monitor_m2_pack/adc_rst] [get_bd_pins sys_rstgen/peripheral_reset]
#  connect_bd_net -net current_monitor_m2_adc_enable_ia [get_bd_pins current_monitor_m2/adc_enable_ia] [get_bd_pins current_monitor_m2_pack/adc_enable_0]
#  connect_bd_net -net current_monitor_m2_adc_enable_ib [get_bd_pins current_monitor_m2/adc_enable_ib] [get_bd_pins current_monitor_m2_pack/adc_enable_1]
#  connect_bd_net -net current_monitor_m2_adc_enable_vbus [get_bd_pins current_monitor_m2/adc_enable_vbus] [get_bd_pins current_monitor_m2_pack/adc_enable_2]
#  connect_bd_net -net current_monitor_m2_adc_enable_stub [get_bd_pins current_monitor_m2/adc_enable_stub] [get_bd_pins current_monitor_m2_pack/adc_enable_3]
#  connect_bd_net -net current_monitor_m2_i_ready_o [get_bd_pins current_monitor_m2_pack/adc_valid_0] [get_bd_pins current_monitor_m2/i_ready_o]
#  connect_bd_net -net current_monitor_m2_i_ready_o [get_bd_pins current_monitor_m2_pack/adc_valid_1] [get_bd_pins current_monitor_m2/i_ready_o]
#  connect_bd_net -net current_monitor_m2_i_ready_o [get_bd_pins current_monitor_m2_pack/adc_valid_2] [get_bd_pins current_monitor_m2/i_ready_o]
#  connect_bd_net -net current_monitor_m2_i_ready_o [get_bd_pins current_monitor_m2_pack/adc_valid_3] [get_bd_pins current_monitor_m2/i_ready_o]
#  connect_bd_net [get_bd_pins current_monitor_m2/ia_o] [get_bd_pins current_monitor_m2_pack/adc_data_0]
#  connect_bd_net [get_bd_pins current_monitor_m2/ib_o] [get_bd_pins current_monitor_m2_pack/adc_data_1]
#  connect_bd_net [get_bd_pins current_monitor_m2/vbus_o] [get_bd_pins current_monitor_m2_pack/adc_data_2]
#  connect_bd_net [get_bd_pins current_monitor_m2/vbus_o] [get_bd_pins current_monitor_m2_pack/adc_data_3]
#  connect_bd_net [get_bd_pins current_monitor_m2_pack/adc_valid] [get_bd_pins current_monitor_m2_dma/fifo_wr_en]
#  connect_bd_net [get_bd_pins current_monitor_m2_pack/adc_data] [get_bd_pins current_monitor_m2_dma/fifo_wr_din]

  #controller
    # motor 1
  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m1/ref_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m1/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_audio_clkgen_clk_out5 [get_bd_pins controller_m1/ctrl_data_clk] [get_bd_pins sys_audio_clkgen/clk_out5]
  connect_bd_net -net sys_100m_resetn [get_bd_pins controller_m1/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m1_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m1_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m1_dma/fifo_wr_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins controller_m1_dma/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins controller_m1_dma/m_dest_axi_aresetn]

  connect_bd_net -net axi_mc_controller_fmc_m1_en_o   [get_bd_ports fmc_m1_en_o]  [get_bd_pins controller_m1/fmc_m1_en_o]
  connect_bd_net -net axi_mc_controller_m1_pwm_al_o   [get_bd_ports pwm_m1_al_o]  [get_bd_pins controller_m1/pwm_al_o]
  connect_bd_net -net axi_mc_controller_m1_pwm_ah_o   [get_bd_ports pwm_m1_ah_o]  [get_bd_pins controller_m1/pwm_ah_o]
  connect_bd_net -net axi_mc_controller_m1_pwm_bl_o   [get_bd_ports pwm_m1_bl_o]  [get_bd_pins controller_m1/pwm_bl_o]
  connect_bd_net -net axi_mc_controller_m1_pwm_bh_o   [get_bd_ports pwm_m1_bh_o]  [get_bd_pins controller_m1/pwm_bh_o]
  connect_bd_net -net axi_mc_controller_m1_pwm_cl_o   [get_bd_ports pwm_m1_cl_o]  [get_bd_pins controller_m1/pwm_cl_o]
  connect_bd_net -net axi_mc_controller_m1_pwm_ch_o   [get_bd_ports pwm_m1_ch_o]  [get_bd_pins controller_m1/pwm_ch_o]

  connect_bd_net -net axi_mc_controller_m1_sensors_o  [get_bd_pins controller_m1/sensors_o] [get_bd_pins speed_detector_m1/hall_bemf_i]
  connect_bd_net -net axi_mc_speed_1_position_o       [get_bd_pins controller_m1/position_i] [get_bd_pins speed_detector_m1/position_o]
  connect_bd_net -net current_monitor_m1_i_ready_o     [get_bd_pins controller_m1/ctrl_data_valid_i] [get_bd_pins current_monitor_m1/i_ready_o]

  #connect_bd_net -net controller_m1_adc_clk_o [get_bd_pins controller_m1_pack/adc_clk] [get_bd_pins controller_m1/adc_clk_o]
  #connect_bd_net -net [get_bd_nets sys_rstgen_peripheral_reset] [get_bd_pins controller_m1_pack/adc_rst] [get_bd_pins sys_rstgen/peripheral_reset]

  #connect_bd_net -net controller_m1_adc_enable_c0 [get_bd_pins controller_m1/adc_enable_c0] [get_bd_pins controller_m1_pack/adc_enable_0]
  #connect_bd_net -net controller_m1_adc_enable_c1 [get_bd_pins controller_m1/adc_enable_c1] [get_bd_pins controller_m1_pack/adc_enable_1]
  #connect_bd_net -net controller_m1_adc_enable_c2 [get_bd_pins controller_m1/adc_enable_c2] [get_bd_pins controller_m1_pack/adc_enable_2]
  #connect_bd_net -net controller_m1_adc_enable_c3 [get_bd_pins controller_m1/adc_enable_c3] [get_bd_pins controller_m1_pack/adc_enable_3]
  #connect_bd_net -net controller_m1_adc_enable_c4 [get_bd_pins controller_m1/adc_enable_c4] [get_bd_pins controller_m1_pack/adc_enable_4]
  #connect_bd_net -net controller_m1_adc_enable_c5 [get_bd_pins controller_m1/adc_enable_c5] [get_bd_pins controller_m1_pack/adc_enable_5]
  #connect_bd_net -net controller_m1_adc_enable_c6 [get_bd_pins controller_m1/adc_enable_c6] [get_bd_pins controller_m1_pack/adc_enable_6]
  #connect_bd_net -net controller_m1_adc_enable_c7 [get_bd_pins controller_m1/adc_enable_c7] [get_bd_pins controller_m1_pack/adc_enable_7]

  #connect_bd_net -net controller_m1_adc_valid_c0 [get_bd_pins controller_m1/adc_valid_c0] [get_bd_pins controller_m1_pack/adc_valid_0]
  #connect_bd_net -net controller_m1_adc_valid_c1 [get_bd_pins controller_m1/adc_valid_c1] [get_bd_pins controller_m1_pack/adc_valid_1]
  #connect_bd_net -net controller_m1_adc_valid_c2 [get_bd_pins controller_m1/adc_valid_c2] [get_bd_pins controller_m1_pack/adc_valid_2]
  #connect_bd_net -net controller_m1_adc_valid_c3 [get_bd_pins controller_m1/adc_valid_c3] [get_bd_pins controller_m1_pack/adc_valid_3]
  #connect_bd_net -net controller_m1_adc_valid_c4 [get_bd_pins controller_m1/adc_valid_c4] [get_bd_pins controller_m1_pack/adc_valid_4]
  #connect_bd_net -net controller_m1_adc_valid_c5 [get_bd_pins controller_m1/adc_valid_c5] [get_bd_pins controller_m1_pack/adc_valid_5]
  #connect_bd_net -net controller_m1_adc_valid_c6 [get_bd_pins controller_m1/adc_valid_c6] [get_bd_pins controller_m1_pack/adc_valid_6]
  #connect_bd_net -net controller_m1_adc_valid_c7 [get_bd_pins controller_m1/adc_valid_c7] [get_bd_pins controller_m1_pack/adc_valid_7]

  #connect_bd_net -net controller_m1_data_c0 [get_bd_pins controller_m1/adc_data_c0] [get_bd_pins controller_m1_pack/adc_data_0]
  #connect_bd_net -net controller_m1_data_c1 [get_bd_pins controller_m1/adc_data_c1] [get_bd_pins controller_m1_pack/adc_data_1]
  #connect_bd_net -net controller_m1_data_c2 [get_bd_pins controller_m1/adc_data_c2] [get_bd_pins controller_m1_pack/adc_data_2]
  #connect_bd_net -net controller_m1_data_c3 [get_bd_pins controller_m1/adc_data_c3] [get_bd_pins controller_m1_pack/adc_data_3]
  #connect_bd_net -net controller_m1_data_c4 [get_bd_pins controller_m1/adc_data_c4] [get_bd_pins controller_m1_pack/adc_data_4]
  #connect_bd_net -net controller_m1_data_c5 [get_bd_pins controller_m1/adc_data_c5] [get_bd_pins controller_m1_pack/adc_data_5]
  #connect_bd_net -net controller_m1_data_c6 [get_bd_pins controller_m1/adc_data_c6] [get_bd_pins controller_m1_pack/adc_data_6]
  #connect_bd_net -net controller_m1_data_c7 [get_bd_pins controller_m1/adc_data_c7] [get_bd_pins controller_m1_pack/adc_data_7]

  #connect_bd_net [get_bd_pins controller_m1_pack/adc_data] [get_bd_pins controller_m1_dma/fifo_wr_din]
  #connect_bd_net [get_bd_pins controller_m1_pack/adc_valid] [get_bd_pins controller_m1_dma/fifo_wr_en]

  connect_bd_net -net  [get_bd_nets sys_100m_clk] [get_bd_pins controller_m1_apack/clk] [get_bd_pins sys_ps7/FCLK_CLK0]

  connect_bd_net -net controller_m1_adc_enable_c0 [get_bd_pins controller_m1/adc_enable_c0] [get_bd_pins controller_m1_apack/chan_enable_0]
  connect_bd_net -net controller_m1_adc_enable_c1 [get_bd_pins controller_m1/adc_enable_c1] [get_bd_pins controller_m1_apack/chan_enable_1]
  connect_bd_net -net controller_m1_adc_enable_c2 [get_bd_pins controller_m1/adc_enable_c2] [get_bd_pins controller_m1_apack/chan_enable_2]
  connect_bd_net -net controller_m1_adc_enable_c3 [get_bd_pins controller_m1/adc_enable_c3] [get_bd_pins controller_m1_apack/chan_enable_3]
  connect_bd_net -net controller_m1_adc_enable_c4 [get_bd_pins controller_m1/adc_enable_c4] [get_bd_pins controller_m1_apack/chan_enable_4]
  connect_bd_net -net controller_m1_adc_enable_c5 [get_bd_pins controller_m1/adc_enable_c5] [get_bd_pins controller_m1_apack/chan_enable_5]
  connect_bd_net -net controller_m1_adc_enable_c6 [get_bd_pins controller_m1/adc_enable_c6] [get_bd_pins controller_m1_apack/chan_enable_6]
  connect_bd_net -net controller_m1_adc_enable_c7 [get_bd_pins controller_m1/adc_enable_c7] [get_bd_pins controller_m1_apack/chan_enable_7]

  connect_bd_net -net controller_m1_adc_valid_c0 [get_bd_pins controller_m1/adc_valid_c0] [get_bd_pins controller_m1_apack/chan_valid_0]
  connect_bd_net -net controller_m1_adc_valid_c1 [get_bd_pins controller_m1/adc_valid_c1] [get_bd_pins controller_m1_apack/chan_valid_1]
  connect_bd_net -net controller_m1_adc_valid_c2 [get_bd_pins controller_m1/adc_valid_c2] [get_bd_pins controller_m1_apack/chan_valid_2]
  connect_bd_net -net controller_m1_adc_valid_c3 [get_bd_pins controller_m1/adc_valid_c3] [get_bd_pins controller_m1_apack/chan_valid_3]
  connect_bd_net -net controller_m1_adc_valid_c4 [get_bd_pins controller_m1/adc_valid_c4] [get_bd_pins controller_m1_apack/chan_valid_4]
  connect_bd_net -net controller_m1_adc_valid_c5 [get_bd_pins controller_m1/adc_valid_c5] [get_bd_pins controller_m1_apack/chan_valid_5]
  connect_bd_net -net controller_m1_adc_valid_c6 [get_bd_pins controller_m1/adc_valid_c6] [get_bd_pins controller_m1_apack/chan_valid_6]
  connect_bd_net -net controller_m1_adc_valid_c7 [get_bd_pins controller_m1/adc_valid_c7] [get_bd_pins controller_m1_apack/chan_valid_7]

  connect_bd_net -net controller_m1_data_c0 [get_bd_pins controller_m1/adc_data_c0] [get_bd_pins controller_m1_apack/chan_data_0]
  connect_bd_net -net controller_m1_data_c1 [get_bd_pins controller_m1/adc_data_c1] [get_bd_pins controller_m1_apack/chan_data_1]
  connect_bd_net -net controller_m1_data_c2 [get_bd_pins controller_m1/adc_data_c2] [get_bd_pins controller_m1_apack/chan_data_2]
  connect_bd_net -net controller_m1_data_c3 [get_bd_pins controller_m1/adc_data_c3] [get_bd_pins controller_m1_apack/chan_data_3]
  connect_bd_net -net controller_m1_data_c4 [get_bd_pins controller_m1/adc_data_c4] [get_bd_pins controller_m1_apack/chan_data_4]
  connect_bd_net -net controller_m1_data_c5 [get_bd_pins controller_m1/adc_data_c5] [get_bd_pins controller_m1_apack/chan_data_5]
  connect_bd_net -net controller_m1_data_c6 [get_bd_pins controller_m1/adc_data_c6] [get_bd_pins controller_m1_apack/chan_data_6]
  connect_bd_net -net controller_m1_data_c7 [get_bd_pins controller_m1/adc_data_c7] [get_bd_pins controller_m1_apack/chan_data_7]

  connect_bd_net [get_bd_pins controller_m1_apack/ddata] [get_bd_pins controller_m1_dma/fifo_wr_din]
  connect_bd_net [get_bd_pins controller_m1_apack/dvalid] [get_bd_pins controller_m1_dma/fifo_wr_en]

    # motor 2
  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m2/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m2/ref_clk] $sys_100m_clk_source
  connect_bd_net -net sys_audio_clkgen_clk_out5 [get_bd_pins controller_m2/ctrl_data_clk] [get_bd_pins sys_audio_clkgen/clk_out5]
  connect_bd_net -net sys_100m_resetn [get_bd_pins controller_m2/s_axi_aresetn] $sys_100m_resetn_source

  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m2_dma/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m2_dma/m_dest_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins controller_m2_dma/fifo_wr_clk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins controller_m2_dma/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins controller_m2_dma/m_dest_axi_aresetn]

  connect_bd_net -net axi_mc_controller_m2_fmc_m1_en_o [get_bd_ports fmc_m2_en_o]     [get_bd_pins controller_m2/fmc_m1_en_o]
  connect_bd_net -net axi_mc_controller_m2_pwm_al_o    [get_bd_ports pwm_m2_al_o]     [get_bd_pins controller_m2/pwm_al_o]
  connect_bd_net -net axi_mc_controller_m2_pwm_ah_o    [get_bd_ports pwm_m2_ah_o]     [get_bd_pins controller_m2/pwm_ah_o]
  connect_bd_net -net axi_mc_controller_m2_pwm_bl_o    [get_bd_ports pwm_m2_bl_o]     [get_bd_pins controller_m2/pwm_bl_o]
  connect_bd_net -net axi_mc_controller_m2_pwm_bh_o    [get_bd_ports pwm_m2_bh_o]     [get_bd_pins controller_m2/pwm_bh_o]
  connect_bd_net -net axi_mc_controller_m2_pwm_cl_o    [get_bd_ports pwm_m2_cl_o]     [get_bd_pins controller_m2/pwm_cl_o]
  connect_bd_net -net axi_mc_controller_m2_pwm_ch_o    [get_bd_ports pwm_m2_ch_o]     [get_bd_pins controller_m2/pwm_ch_o]

  connect_bd_net -net axi_mc_controller_m2_sensors_o  [get_bd_pins controller_m2/sensors_o] [get_bd_pins speed_detector_m2/hall_bemf_i]
  connect_bd_net -net axi_mc_speed_2_position_o       [get_bd_pins controller_m2/position_i] [get_bd_pins speed_detector_m2/position_o]
  connect_bd_net -net current_monitor_m2_i_ready_o     [get_bd_pins controller_m2/ctrl_data_valid_i] [get_bd_pins current_monitor_m2/i_ready_o]

  #connect_bd_net -net controller_m2_adc_clk_o [get_bd_pins controller_m2_pack/adc_clk] [get_bd_pins controller_m2/adc_clk_o]
  #connect_bd_net -net [get_bd_nets sys_rstgen_peripheral_reset] [get_bd_pins controller_m2_pack/adc_rst] [get_bd_pins sys_rstgen/peripheral_reset]

  #connect_bd_net -net controller_m2_adc_enable_c0 [get_bd_pins controller_m2/adc_enable_c0] [get_bd_pins controller_m2_pack/adc_enable_0]
  #connect_bd_net -net controller_m2_adc_enable_c1 [get_bd_pins controller_m2/adc_enable_c1] [get_bd_pins controller_m2_pack/adc_enable_1]
  #connect_bd_net -net controller_m2_adc_enable_c2 [get_bd_pins controller_m2/adc_enable_c2] [get_bd_pins controller_m2_pack/adc_enable_2]
  #connect_bd_net -net controller_m2_adc_enable_c3 [get_bd_pins controller_m2/adc_enable_c3] [get_bd_pins controller_m2_pack/adc_enable_3]
  #connect_bd_net -net controller_m2_adc_enable_c4 [get_bd_pins controller_m2/adc_enable_c4] [get_bd_pins controller_m2_pack/adc_enable_4]
  #connect_bd_net -net controller_m2_adc_enable_c5 [get_bd_pins controller_m2/adc_enable_c5] [get_bd_pins controller_m2_pack/adc_enable_5]
  #connect_bd_net -net controller_m2_adc_enable_c6 [get_bd_pins controller_m2/adc_enable_c6] [get_bd_pins controller_m2_pack/adc_enable_6]
  #connect_bd_net -net controller_m2_adc_enable_c7 [get_bd_pins controller_m2/adc_enable_c7] [get_bd_pins controller_m2_pack/adc_enable_7]

  #connect_bd_net -net controller_m2_adc_valid_c0 [get_bd_pins controller_m2/adc_valid_c0] [get_bd_pins controller_m2_pack/adc_valid_0]
  #connect_bd_net -net controller_m2_adc_valid_c1 [get_bd_pins controller_m2/adc_valid_c1] [get_bd_pins controller_m2_pack/adc_valid_1]
  #connect_bd_net -net controller_m2_adc_valid_c2 [get_bd_pins controller_m2/adc_valid_c2] [get_bd_pins controller_m2_pack/adc_valid_2]
  #connect_bd_net -net controller_m2_adc_valid_c3 [get_bd_pins controller_m2/adc_valid_c3] [get_bd_pins controller_m2_pack/adc_valid_3]
  #connect_bd_net -net controller_m2_adc_valid_c4 [get_bd_pins controller_m2/adc_valid_c4] [get_bd_pins controller_m2_pack/adc_valid_4]
  #connect_bd_net -net controller_m2_adc_valid_c5 [get_bd_pins controller_m2/adc_valid_c5] [get_bd_pins controller_m2_pack/adc_valid_5]
  #connect_bd_net -net controller_m2_adc_valid_c6 [get_bd_pins controller_m2/adc_valid_c6] [get_bd_pins controller_m2_pack/adc_valid_6]
  #connect_bd_net -net controller_m2_adc_valid_c7 [get_bd_pins controller_m2/adc_valid_c7] [get_bd_pins controller_m2_pack/adc_valid_7]

  #connect_bd_net -net controller_m2_data_c0 [get_bd_pins controller_m2/adc_data_c0] [get_bd_pins controller_m2_pack/adc_data_0]
  #connect_bd_net -net controller_m2_data_c1 [get_bd_pins controller_m2/adc_data_c1] [get_bd_pins controller_m2_pack/adc_data_1]
  #connect_bd_net -net controller_m2_data_c2 [get_bd_pins controller_m2/adc_data_c2] [get_bd_pins controller_m2_pack/adc_data_2]
  #connect_bd_net -net controller_m2_data_c3 [get_bd_pins controller_m2/adc_data_c3] [get_bd_pins controller_m2_pack/adc_data_3]
  #connect_bd_net -net controller_m2_data_c4 [get_bd_pins controller_m2/adc_data_c4] [get_bd_pins controller_m2_pack/adc_data_4]
  #connect_bd_net -net controller_m2_data_c5 [get_bd_pins controller_m2/adc_data_c5] [get_bd_pins controller_m2_pack/adc_data_5]
  #connect_bd_net -net controller_m2_data_c6 [get_bd_pins controller_m2/adc_data_c6] [get_bd_pins controller_m2_pack/adc_data_6]
  #connect_bd_net -net controller_m2_data_c7 [get_bd_pins controller_m2/adc_data_c7] [get_bd_pins controller_m2_pack/adc_data_7]

  #connect_bd_net [get_bd_pins controller_m2_pack/adc_data] [get_bd_pins controller_m2_dma/fifo_wr_din]
  #connect_bd_net [get_bd_pins controller_m2_pack/adc_valid] [get_bd_pins controller_m2_dma/fifo_wr_en]

  connect_bd_net -net  [get_bd_nets sys_100m_clk] [get_bd_pins controller_m2_apack/clk] [get_bd_pins sys_ps7/FCLK_CLK0]

  connect_bd_net -net controller_m2_adc_enable_c0 [get_bd_pins controller_m2/adc_enable_c0] [get_bd_pins controller_m2_apack/chan_enable_0]
  connect_bd_net -net controller_m2_adc_enable_c1 [get_bd_pins controller_m2/adc_enable_c1] [get_bd_pins controller_m2_apack/chan_enable_1]
  connect_bd_net -net controller_m2_adc_enable_c2 [get_bd_pins controller_m2/adc_enable_c2] [get_bd_pins controller_m2_apack/chan_enable_2]
  connect_bd_net -net controller_m2_adc_enable_c3 [get_bd_pins controller_m2/adc_enable_c3] [get_bd_pins controller_m2_apack/chan_enable_3]
  connect_bd_net -net controller_m2_adc_enable_c4 [get_bd_pins controller_m2/adc_enable_c4] [get_bd_pins controller_m2_apack/chan_enable_4]
  connect_bd_net -net controller_m2_adc_enable_c5 [get_bd_pins controller_m2/adc_enable_c5] [get_bd_pins controller_m2_apack/chan_enable_5]
  connect_bd_net -net controller_m2_adc_enable_c6 [get_bd_pins controller_m2/adc_enable_c6] [get_bd_pins controller_m2_apack/chan_enable_6]
  connect_bd_net -net controller_m2_adc_enable_c7 [get_bd_pins controller_m2/adc_enable_c7] [get_bd_pins controller_m2_apack/chan_enable_7]

  connect_bd_net -net controller_m2_adc_valid_c0 [get_bd_pins controller_m2/adc_valid_c0] [get_bd_pins controller_m2_apack/chan_valid_0]
  connect_bd_net -net controller_m2_adc_valid_c1 [get_bd_pins controller_m2/adc_valid_c1] [get_bd_pins controller_m2_apack/chan_valid_1]
  connect_bd_net -net controller_m2_adc_valid_c2 [get_bd_pins controller_m2/adc_valid_c2] [get_bd_pins controller_m2_apack/chan_valid_2]
  connect_bd_net -net controller_m2_adc_valid_c3 [get_bd_pins controller_m2/adc_valid_c3] [get_bd_pins controller_m2_apack/chan_valid_3]
  connect_bd_net -net controller_m2_adc_valid_c4 [get_bd_pins controller_m2/adc_valid_c4] [get_bd_pins controller_m2_apack/chan_valid_4]
  connect_bd_net -net controller_m2_adc_valid_c5 [get_bd_pins controller_m2/adc_valid_c5] [get_bd_pins controller_m2_apack/chan_valid_5]
  connect_bd_net -net controller_m2_adc_valid_c6 [get_bd_pins controller_m2/adc_valid_c6] [get_bd_pins controller_m2_apack/chan_valid_6]
  connect_bd_net -net controller_m2_adc_valid_c7 [get_bd_pins controller_m2/adc_valid_c7] [get_bd_pins controller_m2_apack/chan_valid_7]

  connect_bd_net -net controller_m2_data_c0 [get_bd_pins controller_m2/adc_data_c0] [get_bd_pins controller_m2_apack/chan_data_0]
  connect_bd_net -net controller_m2_data_c1 [get_bd_pins controller_m2/adc_data_c1] [get_bd_pins controller_m2_apack/chan_data_1]
  connect_bd_net -net controller_m2_data_c2 [get_bd_pins controller_m2/adc_data_c2] [get_bd_pins controller_m2_apack/chan_data_2]
  connect_bd_net -net controller_m2_data_c3 [get_bd_pins controller_m2/adc_data_c3] [get_bd_pins controller_m2_apack/chan_data_3]
  connect_bd_net -net controller_m2_data_c4 [get_bd_pins controller_m2/adc_data_c4] [get_bd_pins controller_m2_apack/chan_data_4]
  connect_bd_net -net controller_m2_data_c5 [get_bd_pins controller_m2/adc_data_c5] [get_bd_pins controller_m2_apack/chan_data_5]
  connect_bd_net -net controller_m2_data_c6 [get_bd_pins controller_m2/adc_data_c6] [get_bd_pins controller_m2_apack/chan_data_6]
  connect_bd_net -net controller_m2_data_c7 [get_bd_pins controller_m2/adc_data_c7] [get_bd_pins controller_m2_apack/chan_data_7]

  connect_bd_net [get_bd_pins controller_m2_apack/ddata] [get_bd_pins controller_m2_dma/fifo_wr_din]
  connect_bd_net [get_bd_pins controller_m2_apack/dvalid] [get_bd_pins controller_m2_dma/fifo_wr_en]

  # ethernet


  connect_bd_net -net sys_200m_clk [get_bd_ports refclk] [get_bd_pins sys_ps7/FCLK_CLK1]
  connect_bd_net -net sys_rstgen_peripheral_reset [get_bd_ports refclk_rst] [get_bd_pins sys_rstgen/peripheral_reset]
  connect_bd_net -net sys_100m_resetn [get_bd_ports eth_phy_rst_n]
  connect_bd_net [get_bd_pins /sys_ps7/ENET0_MDIO_MDC] [get_bd_ports eth_mdio_mdc]
  connect_bd_net [get_bd_pins /sys_ps7/ENET0_MDIO_O] [get_bd_ports eth_mdio_o]
  connect_bd_net [get_bd_pins /sys_ps7/ENET0_MDIO_T] [get_bd_ports eth_mdio_t]
  connect_bd_net [get_bd_pins /sys_ps7/ENET0_MDIO_I] [get_bd_ports eth_mdio_i]
    # phy 1
  connect_bd_intf_net -intf_net sys_ps7_GMII_ETHERNET_1 [get_bd_intf_pins gmii_to_rgmii_eth1/gmii] [get_bd_intf_pins sys_ps7/GMII_ETHERNET_0]
  connect_bd_intf_net -intf_net gmii_to_rgmii_eth1_rgmii [get_bd_intf_ports eth1_rgmii] [get_bd_intf_pins gmii_to_rgmii_eth1/rgmii]
  connect_bd_net -net sys_rstgen_peripheral_reset [get_bd_pins gmii_to_rgmii_eth1/reset] [get_bd_pins sys_rstgen/peripheral_reset]

  connect_bd_net -net sys_audio_clkgen_clk_out4 [get_bd_pins gmii_to_rgmii_eth1/clk_20m] [get_bd_pins sys_audio_clkgen/clk_out4]
  connect_bd_net -net sys_audio_clkgen_clk_out3 [get_bd_pins gmii_to_rgmii_eth1/clk_25m] [get_bd_pins sys_audio_clkgen/clk_out3]
  connect_bd_net -net sys_audio_clkgen_clk_out2 [get_bd_pins gmii_to_rgmii_eth1/clk_125m] [get_bd_pins sys_audio_clkgen/clk_out2]
  connect_bd_net [get_bd_ports eth_mdio_mdc] [get_bd_pins gmii_to_rgmii_eth1/mdio_mdc]
  connect_bd_net [get_bd_ports eth_mdio_o] [get_bd_pins gmii_to_rgmii_eth1/mdio_in_w]
  connect_bd_net [get_bd_ports eth_mdio_i] [get_bd_pins gmii_to_rgmii_eth1/mdio_in_r]
    # phy 2
  connect_bd_intf_net -intf_net sys_ps7_GMII_ETHERNET_2 [get_bd_intf_pins gmii_to_rgmii_eth2/gmii] [get_bd_intf_pins sys_ps7/GMII_ETHERNET_1]
  connect_bd_intf_net -intf_net gmii_to_rgmii_eth2_rgmii [get_bd_intf_ports eth2_rgmii] [get_bd_intf_pins gmii_to_rgmii_eth2/rgmii]
  connect_bd_net -net sys_rstgen_peripheral_reset [get_bd_pins gmii_to_rgmii_eth2/reset] [get_bd_pins sys_rstgen/peripheral_reset]
  connect_bd_net -net sys_audio_clkgen_clk_out4 [get_bd_pins gmii_to_rgmii_eth2/clk_20m] [get_bd_pins sys_audio_clkgen/clk_out4]
  connect_bd_net -net sys_audio_clkgen_clk_out3 [get_bd_pins gmii_to_rgmii_eth2/clk_25m] [get_bd_pins sys_audio_clkgen/clk_out3]
  connect_bd_net -net sys_audio_clkgen_clk_out2 [get_bd_pins gmii_to_rgmii_eth2/clk_125m] [get_bd_pins sys_audio_clkgen/clk_out2]

  connect_bd_net [get_bd_ports eth_mdio_mdc] [get_bd_pins gmii_to_rgmii_eth2/mdio_mdc]
  connect_bd_net [get_bd_ports eth_mdio_o] [get_bd_pins gmii_to_rgmii_eth2/mdio_in_w]
  connect_bd_net [get_bd_ports eth_mdio_i] [get_bd_pins gmii_to_rgmii_eth2/mdio_in_r]

  # xadc
  connect_bd_net -net sys_100m_clk [get_bd_pins xadc_core/s_axi_aclk] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins xadc_core/s_axi_aresetn] $sys_100m_resetn_source
  connect_bd_intf_net -intf_net Vaux0_1 [get_bd_intf_pins xadc_core/Vaux0] [get_bd_intf_ports Vaux0]
  connect_bd_intf_net -intf_net Vaux8_1 [get_bd_intf_pins xadc_core/Vaux8] [get_bd_intf_ports Vaux8]
  #connect_bd_net -net xadc_muxout       [get_bd_pins /xadc_core/muxaddr_out] [get_bd_ports muxaddr_out]

  # iic
  connect_bd_net -net sys_100m_clk [get_bd_pins iic_ee2/s_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins iic_ee2/s_axi_aresetn]
  connect_bd_intf_net [get_bd_intf_pins iic_ee2/IIC] [get_bd_intf_ports  iic_ee2]

  # spi
  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]    [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi_csn_o   [get_bd_ports spi_csn_o]    [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi_sclk_i  [get_bd_ports spi_sclk_i]   [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi_sclk_o  [get_bd_ports spi_sclk_o]   [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net spi_mosi_i  [get_bd_ports spi_mosi_i]   [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi_mosi_o  [get_bd_ports spi_mosi_o]   [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi_miso_i  [get_bd_ports spi_miso_i]   [get_bd_pins sys_ps7/SPI0_MISO_I]

  # interrupts
  delete_bd_objs [get_bd_nets ps_intr_6_s] [get_bd_ports ps_intr_6]
  delete_bd_objs [get_bd_nets ps_intr_7_s] [get_bd_ports ps_intr_7]
  delete_bd_objs [get_bd_nets ps_intr_8_s] [get_bd_ports ps_intr_8]
  delete_bd_objs [get_bd_nets ps_intr_9_s] [get_bd_ports ps_intr_9]
  delete_bd_objs [get_bd_nets ps_intr_10_s] [get_bd_ports ps_intr_10]
  delete_bd_objs [get_bd_nets ps_intr_12_s] [get_bd_ports ps_intr_12]
  delete_bd_objs [get_bd_nets ps_intr_13_s] [get_bd_ports ps_intr_13]
  connect_bd_net -net controller_m2_dma_intr          [get_bd_pins controller_m2_dma/irq]       [get_bd_pins sys_concat_intc/In6]
  connect_bd_net -net axi_current_monitor_2_dma_intr  [get_bd_pins current_monitor_m2_dma/irq]  [get_bd_pins sys_concat_intc/In7]
  connect_bd_net -net speed_detector_m2_dma_intr      [get_bd_pins speed_detector_m2_dma/irq]   [get_bd_pins sys_concat_intc/In8]
  connect_bd_net -net controller_m1_dma_intr          [get_bd_pins controller_m1_dma/irq]       [get_bd_pins sys_concat_intc/In9]
  connect_bd_net -net axi_current_monitor_1_dma_intr  [get_bd_pins current_monitor_m1_dma/irq]  [get_bd_pins sys_concat_intc/In10]
  connect_bd_net -net iic_ee2_irq                     [get_bd_pins iic_ee2/iic2intc_irpt]       [get_bd_pins sys_concat_intc/In12]
  connect_bd_net -net speed_detector_m1_dma_intr      [get_bd_pins speed_detector_m1_dma/irq]   [get_bd_pins sys_concat_intc/In13]

  # cpu interconnect
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M13_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M14_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M15_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M16_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M17_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M18_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M19_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M20_ACLK] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M13_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M14_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M15_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M16_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M17_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M18_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M19_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M20_ARESETN] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins iic_ee2/S_AXI] -boundary_type upper [get_bd_intf_pins axi_cpu_interconnect/M07_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins xadc_core/s_axi_lite]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins speed_detector_m1/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins speed_detector_m1_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins speed_detector_m2/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins speed_detector_m2_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m13_axi [get_bd_intf_pins axi_cpu_interconnect/M13_AXI] [get_bd_intf_pins current_monitor_m1/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m14_axi [get_bd_intf_pins axi_cpu_interconnect/M14_AXI] [get_bd_intf_pins current_monitor_m1_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m15_axi [get_bd_intf_pins axi_cpu_interconnect/M15_AXI] [get_bd_intf_pins current_monitor_m2/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m16_axi [get_bd_intf_pins axi_cpu_interconnect/M16_AXI] [get_bd_intf_pins current_monitor_m2_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m17_axi [get_bd_intf_pins axi_cpu_interconnect/M17_AXI] [get_bd_intf_pins controller_m1/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m18_axi [get_bd_intf_pins axi_cpu_interconnect/M18_AXI] [get_bd_intf_pins controller_m1_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m19_axi [get_bd_intf_pins axi_cpu_interconnect/M19_AXI] [get_bd_intf_pins controller_m2/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m20_axi [get_bd_intf_pins axi_cpu_interconnect/M20_AXI] [get_bd_intf_pins controller_m2_dma/s_axi]

  # mem interconnect
  connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/M00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S00_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S01_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S02_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S03_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S04_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S05_ACLK] $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S01_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S02_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S03_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S04_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S05_ARESETN] $sys_100m_resetn_source

  connect_bd_intf_net -intf_net axi_mem_interconnect_m00_axi [get_bd_intf_pins axi_mem_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_mem_interconnect_s00_axi [get_bd_intf_pins axi_mem_interconnect/S00_AXI] [get_bd_intf_pins speed_detector_m1_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_mem_interconnect_s01_axi [get_bd_intf_pins axi_mem_interconnect/S01_AXI] [get_bd_intf_pins speed_detector_m2_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_mem_interconnect_s02_axi [get_bd_intf_pins axi_mem_interconnect/S02_AXI] [get_bd_intf_pins current_monitor_m1_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_mem_interconnect_s03_axi [get_bd_intf_pins axi_mem_interconnect/S03_AXI] [get_bd_intf_pins current_monitor_m2_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_mem_interconnect_s04_axi [get_bd_intf_pins axi_mem_interconnect/S04_AXI] [get_bd_intf_pins controller_m1_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_mem_interconnect_s05_axi [get_bd_intf_pins axi_mem_interconnect/S05_AXI] [get_bd_intf_pins controller_m2_dma/m_dest_axi]

  # address map
  create_bd_addr_seg -range 0x10000   -offset 0x40410000 $sys_addr_cntrl_space  [get_bd_addr_segs speed_detector_m1/s_axi/axi_lite] SEG_data_s_d1
  create_bd_addr_seg -range 0x10000   -offset 0x40420000 $sys_addr_cntrl_space  [get_bd_addr_segs current_monitor_m1/s_axi/axi_lite] SEG_data_c_m1
  create_bd_addr_seg -range 0x10000   -offset 0x40430000 $sys_addr_cntrl_space  [get_bd_addr_segs controller_m1/s_axi/axi_lite] SEG_data_c1
  create_bd_addr_seg -range 0x10000   -offset 0x40440000 $sys_addr_cntrl_space  [get_bd_addr_segs speed_detector_m2/s_axi/axi_lite] SEG_data_s_d2
  create_bd_addr_seg -range 0x10000   -offset 0x40450000 $sys_addr_cntrl_space  [get_bd_addr_segs current_monitor_m2/s_axi/axi_lite] SEG_data_c_m2
  create_bd_addr_seg -range 0x10000   -offset 0x40460000 $sys_addr_cntrl_space  [get_bd_addr_segs controller_m2/s_axi/axi_lite] SEG_data_c2
  create_bd_addr_seg -range 0x10000   -offset 0x40510000 $sys_addr_cntrl_space  [get_bd_addr_segs speed_detector_m1_dma/s_axi/axi_lite] SEG_data_s_d1_dma
  create_bd_addr_seg -range 0x10000   -offset 0x40520000 $sys_addr_cntrl_space  [get_bd_addr_segs current_monitor_m1_dma/s_axi/axi_lite] SEG_data_c_m1_dma
  create_bd_addr_seg -range 0x10000   -offset 0x40530000 $sys_addr_cntrl_space  [get_bd_addr_segs controller_m1_dma/s_axi/axi_lite] SEG_data_c1_dma
  create_bd_addr_seg -range 0x10000   -offset 0x40540000 $sys_addr_cntrl_space  [get_bd_addr_segs speed_detector_m2_dma/s_axi/axi_lite] SEG_data_s_d2_dma
  create_bd_addr_seg -range 0x10000   -offset 0x40550000 $sys_addr_cntrl_space  [get_bd_addr_segs current_monitor_m2_dma/s_axi/axi_lite] SEG_data_c_m2_dma
  create_bd_addr_seg -range 0x10000   -offset 0x40560000 $sys_addr_cntrl_space  [get_bd_addr_segs controller_m2_dma/s_axi/axi_lite] SEG_data_c2_dma
  create_bd_addr_seg -range 0x10000   -offset 0x43200000 $sys_addr_cntrl_space  [get_bd_addr_segs xadc_core/s_axi_lite/Reg] SEG_data_xadc
  create_bd_addr_seg -range 0x10000   -offset 0x41510000 $sys_addr_cntrl_space  [get_bd_addr_segs iic_ee2/S_AXI/Reg] SEG_iic_ee2_Reg

  create_bd_addr_seg -range $sys_mem_size -offset 0x0 [get_bd_addr_spaces speed_detector_m1_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x0 [get_bd_addr_spaces speed_detector_m2_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x0 [get_bd_addr_spaces current_monitor_m1_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x0 [get_bd_addr_spaces current_monitor_m2_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x0 [get_bd_addr_spaces controller_m1_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range $sys_mem_size -offset 0x0 [get_bd_addr_spaces controller_m2_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
