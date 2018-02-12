
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
  # iic
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0  iic_ee2

  # xadc interface
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vaux0
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vaux8


  # core instantiation and configuration


  # additions to default configuration
    # Enable additional peripherals from the PS7 block
  ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP2 1
  ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_ENET0_IO EMIO
  ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_IO EMIO
  ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_PERIPHERAL_ENABLE 1
  ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_GRP_MDIO_ENABLE 1
  ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_GRP_MDIO_IO EMIO

  # Add additional clocks to be used by gmii to rgmii modules and current monitoring modules
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT2_USED true
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT3_USED true
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT4_USED true
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT5_USED true
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT2_REQUESTED_OUT_FREQ 125
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT3_REQUESTED_OUT_FREQ 25
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT4_REQUESTED_OUT_FREQ 20
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT5_REQUESTED_OUT_FREQ 20
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT2_DRIVES No_buffer
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT3_DRIVES No_buffer
  ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT4_DRIVES No_buffer

  # speed detectors
    # speed detector core motor 1
  ad_ip_instance axi_mc_speed speed_detector_m1
    # dma motor 1
  ad_ip_instance axi_dmac speed_detector_m1_dma
  ad_ip_parameter speed_detector_m1_dma CONFIG.DMA_TYPE_SRC 2
  ad_ip_parameter speed_detector_m1_dma CONFIG.DMA_TYPE_DEST 0
  ad_ip_parameter speed_detector_m1_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter speed_detector_m1_dma CONFIG.CYCLIC 0
  ad_ip_parameter speed_detector_m1_dma CONFIG.DMA_DATA_WIDTH_DEST 64
  ad_ip_parameter speed_detector_m1_dma CONFIG.DMA_DATA_WIDTH_SRC 32
  ad_ip_parameter speed_detector_m1_dma CONFIG.DMA_AXI_PROTOCOL_DEST 0
    # speed detector core motor 2
  ad_ip_instance axi_mc_speed speed_detector_m2
    # dma motor 2
  ad_ip_instance axi_dmac speed_detector_m2_dma
  ad_ip_parameter speed_detector_m2_dma CONFIG.DMA_TYPE_SRC 2
  ad_ip_parameter speed_detector_m2_dma CONFIG.DMA_TYPE_DEST 0
  ad_ip_parameter speed_detector_m2_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter speed_detector_m2_dma CONFIG.CYCLIC 0
  ad_ip_parameter speed_detector_m2_dma CONFIG.DMA_DATA_WIDTH_DEST 64
  ad_ip_parameter speed_detector_m2_dma CONFIG.DMA_DATA_WIDTH_SRC 32
  ad_ip_parameter speed_detector_m2_dma CONFIG.DMA_AXI_PROTOCOL_DEST 0

  # current monitor peripherals
    # current monitor core motor 1
  ad_ip_instance axi_mc_current_monitor current_monitor_m1
    # dma motor 1
  ad_ip_instance axi_dmac current_monitor_m1_dma
  ad_ip_parameter current_monitor_m1_dma CONFIG.DMA_DATA_WIDTH_SRC 64
  ad_ip_parameter current_monitor_m1_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter current_monitor_m1_dma CONFIG.CYCLIC 0
  ad_ip_parameter current_monitor_m1_dma CONFIG.DMA_AXI_PROTOCOL_DEST 0
  ad_ip_parameter current_monitor_m1_dma CONFIG.SYNC_TRANSFER_START true
    # data packer motor 1
  #
  ad_ip_instance util_cpack2 current_monitor_m1_pack { \
    NUM_OF_CHANNELS 3 \
    SAMPLE_DATA_WIDTH 16 \
  }

    # current monitor core motor 2
  ad_ip_instance axi_mc_current_monitor current_monitor_m2
    # dma motor 2
  ad_ip_instance axi_dmac current_monitor_m2_dma
  ad_ip_parameter current_monitor_m2_dma CONFIG.DMA_DATA_WIDTH_SRC 64
  ad_ip_parameter current_monitor_m2_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter current_monitor_m2_dma CONFIG.CYCLIC 0
  ad_ip_parameter current_monitor_m2_dma CONFIG.DMA_AXI_PROTOCOL_DEST 0
  ad_ip_parameter current_monitor_m2_dma CONFIG.SYNC_TRANSFER_START true
    # data packer motor 2
  ad_ip_instance util_cpack2 current_monitor_m2_pack { \
    NUM_OF_CHANNELS 3 \
    SAMPLE_DATA_WIDTH 16 \
  }

  #controller
    # controller core motor 1
  ad_ip_instance axi_mc_controller controller_m1
    # controller core motor 2
  ad_ip_instance axi_mc_controller controller_m2

  #ethernet gmii to rgmii converters
    # phy 1
  ad_ip_instance util_gmii_to_rgmii gmii_to_rgmii_eth1
  ad_ip_parameter gmii_to_rgmii_eth1 CONFIG.PHY_AD "00000"
  ad_ip_parameter gmii_to_rgmii_eth1 CONFIG.IODELAY_CTRL 1

    # phy 2
  ad_ip_instance util_gmii_to_rgmii gmii_to_rgmii_eth2
  ad_ip_parameter gmii_to_rgmii_eth2 CONFIG.PHY_AD "00001"

  # iic
  ad_ip_instance axi_iic iic_ee2

  # xadc
  ad_ip_instance xadc_wiz xadc_core
  ad_ip_parameter xadc_core CONFIG.XADC_STARUP_SELECTION simultaneous_sampling
  ad_ip_parameter xadc_core CONFIG.ENABLE_EXTERNAL_MUX true
  ad_ip_parameter xadc_core CONFIG.EXTERNAL_MUX_CHANNEL  VAUXP0_VAUXN0
  ad_ip_parameter xadc_core CONFIG.CHANNEL_ENABLE_VP_VN  false
  ad_ip_parameter xadc_core CONFIG.CHANNEL_ENABLE_VAUXP0_VAUXN0  true
  ad_ip_parameter xadc_core CONFIG.CHANNEL_ENABLE_VAUXP8_VAUXN8  true
  ad_ip_parameter xadc_core CONFIG.OT_ALARM false
  ad_ip_parameter xadc_core CONFIG.USER_TEMP_ALARM false
  ad_ip_parameter xadc_core CONFIG.VCCAUX_ALARM false
  ad_ip_parameter xadc_core CONFIG.VCCINT_ALARM false

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


  ad_connect sys_cpu_clk   current_monitor_m1_pack/clk
  ad_connect sys_cpu_reset current_monitor_m1_pack/reset

  ad_connect current_monitor_m1/adc_enable_ia     current_monitor_m1_pack/enable_0
  ad_connect current_monitor_m1/adc_enable_ib     current_monitor_m1_pack/enable_1
  ad_connect current_monitor_m1/adc_enable_vbus   current_monitor_m1_pack/enable_2
  ad_connect current_monitor_m1/i_ready_o         current_monitor_m1_pack/fifo_wr_en
  ad_connect current_monitor_m1/ia_o              current_monitor_m1_pack/fifo_wr_data_0
  ad_connect current_monitor_m1/ib_o              current_monitor_m1_pack/fifo_wr_data_1
  ad_connect current_monitor_m1/vbus_o            current_monitor_m1_pack/fifo_wr_data_2

  ad_connect current_monitor_m1_pack/packed_fifo_wr current_monitor_m1_dma/fifo_wr

  # motor 2
  ad_connect  sys_cpu_clk current_monitor_m2/ref_clk

  ad_connect  sys_cpu_clk current_monitor_m2_dma/fifo_wr_clk

  ad_connect  current_monitor_m2/adc_clk_i sys_audio_clkgen/clk_out5
  ad_connect  adc_m2_ia_dat_i  current_monitor_m2/adc_ia_dat_i
  ad_connect  adc_m2_ib_dat_i  current_monitor_m2/adc_ib_dat_i
  ad_connect  adc_m2_vbus_dat_i current_monitor_m2/adc_vbus_dat_i

  ad_connect sys_cpu_clk current_monitor_m2_pack/clk
  ad_connect sys_cpu_reset current_monitor_m2_pack/reset

  ad_connect current_monitor_m2/adc_enable_ia     current_monitor_m2_pack/enable_0
  ad_connect current_monitor_m2/adc_enable_ib     current_monitor_m2_pack/enable_1
  ad_connect current_monitor_m2/adc_enable_vbus   current_monitor_m2_pack/enable_2
  ad_connect current_monitor_m2/i_ready_o         current_monitor_m2_pack/fifo_wr_en
  ad_connect current_monitor_m2/ia_o              current_monitor_m2_pack/fifo_wr_data_0
  ad_connect current_monitor_m2/ib_o              current_monitor_m2_pack/fifo_wr_data_1
  ad_connect current_monitor_m2/vbus_o            current_monitor_m2_pack/fifo_wr_data_2

  ad_connect current_monitor_m2_pack/packed_fifo_wr current_monitor_m2_dma/fifo_wr

  #controller
    # motor 1
  ad_connect sys_cpu_clk controller_m1/ref_clk
  ad_connect controller_m1/ctrl_data_clk sys_audio_clkgen/clk_out5

  ad_connect fmc_m1_en_o   controller_m1/fmc_en_o
  ad_connect pwm_m1_al_o   controller_m1/pwm_al_o
  ad_connect pwm_m1_ah_o   controller_m1/pwm_ah_o
  ad_connect pwm_m1_bl_o   controller_m1/pwm_bl_o
  ad_connect pwm_m1_bh_o   controller_m1/pwm_bh_o
  ad_connect pwm_m1_cl_o   controller_m1/pwm_cl_o
  ad_connect pwm_m1_ch_o   controller_m1/pwm_ch_o

  ad_connect controller_m1/sensors_o          speed_detector_m1/hall_bemf_i
  ad_connect controller_m1/position_i         speed_detector_m1/position_o
  ad_connect controller_m1/gpo_o              gpo_o

  ad_connect controller_m1/pwm_a_i GND
  ad_connect controller_m1/pwm_b_i GND
  ad_connect controller_m1/pwm_c_i GND
  ad_connect controller_m2/pwm_a_i GND
  ad_connect controller_m2/pwm_b_i GND
  ad_connect controller_m2/pwm_c_i GND

    # motor 2
  ad_connect sys_cpu_clk controller_m2/ref_clk
  ad_connect controller_m2/ctrl_data_clk sys_audio_clkgen/clk_out5

  ad_connect  fmc_m2_en_o controller_m2/fmc_en_o
  ad_connect  pwm_m2_al_o controller_m2/pwm_al_o
  ad_connect  pwm_m2_ah_o controller_m2/pwm_ah_o
  ad_connect  pwm_m2_bl_o controller_m2/pwm_bl_o
  ad_connect  pwm_m2_bh_o controller_m2/pwm_bh_o
  ad_connect  pwm_m2_cl_o controller_m2/pwm_cl_o
  ad_connect  pwm_m2_ch_o controller_m2/pwm_ch_o

  ad_connect controller_m2/sensors_o          speed_detector_m2/hall_bemf_i
  ad_connect controller_m2/position_i         speed_detector_m2/position_o

  # ethernet

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

  # iic
  ad_connect iic_ee2/IIC iic_ee2

  ad_connect  sys_cpu_resetn speed_detector_m1_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn speed_detector_m2_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn current_monitor_m1_dma/m_dest_axi_aresetn
  ad_connect  sys_cpu_resetn current_monitor_m2_dma/m_dest_axi_aresetn
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
  ad_cpu_interconnect  0x40540000 speed_detector_m2_dma
  ad_cpu_interconnect  0x40550000 current_monitor_m2_dma
  ad_cpu_interconnect  0x43200000 xadc_core
  ad_cpu_interconnect  0x41510000 iic_ee2

  ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
  ad_mem_hp2_interconnect sys_cpu_clk speed_detector_m1_dma/m_dest_axi
  ad_mem_hp2_interconnect sys_cpu_clk speed_detector_m2_dma/m_dest_axi
  ad_mem_hp2_interconnect sys_cpu_clk current_monitor_m1_dma/m_dest_axi
  ad_mem_hp2_interconnect sys_cpu_clk current_monitor_m2_dma/m_dest_axi

  ad_cpu_interrupt ps-7 mb-7 xadc_core/ip2intc_irpt
  ad_cpu_interrupt ps-8 mb-8 current_monitor_m2_dma/irq
  ad_cpu_interrupt ps-9 mb-9 speed_detector_m2_dma/irq
  ad_cpu_interrupt ps-10 mb-10 current_monitor_m1_dma/irq
  ad_cpu_interrupt ps-12 mb-12 iic_ee2/iic2intc_irpt
  ad_cpu_interrupt ps-13 mb-13 speed_detector_m1_dma/irq
