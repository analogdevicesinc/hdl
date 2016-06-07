
# transmit-path (refclk)

add_instance xcvr_tx_ref_clk altera_clock_bridge 15.1
set_instance_parameter_value xcvr_tx_ref_clk {EXPLICIT_CLOCK_RATE} {500000000.0}

# transmit-path (pll-core)

add_instance xcvr_tx_pll altera_iopll 15.1
add_instance xcvr_tx_pll_reconfig altera_pll_reconfig 15.1
set_instance_parameter_value xcvr_tx_pll {gui_en_reconf} {1}
set_instance_parameter_value xcvr_tx_pll {gui_reference_clock_frequency} {500.0}
set_instance_parameter_value xcvr_tx_pll {gui_use_locked} {0}
set_instance_parameter_value xcvr_tx_pll {gui_output_clock_frequency0} {250.0}

# transmit-path (pll-atx)

add_instance xcvr_tx_lane_pll altera_xcvr_atx_pll_a10 15.1
set_instance_parameter_value xcvr_tx_lane_pll {enable_pll_reconfig} {1}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_separate_avmm_busy} {1}
set_instance_parameter_value xcvr_tx_lane_pll {set_capability_reg_enable} {1}
set_instance_parameter_value xcvr_tx_lane_pll {set_csr_soft_logic_enable} {1}
set_instance_parameter_value xcvr_tx_lane_pll {set_output_clock_frequency} {5000.0}
set_instance_parameter_value xcvr_tx_lane_pll {set_auto_reference_clock_frequency} {500.0}

# receive-path (refclk)

add_instance xcvr_rx_ref_clk altera_clock_bridge 15.1
set_instance_parameter_value xcvr_rx_ref_clk {EXPLICIT_CLOCK_RATE} {500000000.0}

# receive-path (pll-core)

add_instance xcvr_rx_pll altera_iopll 15.1
add_instance xcvr_rx_pll_reconfig altera_pll_reconfig 15.1
set_instance_parameter_value xcvr_rx_pll {gui_en_reconf} {1}
set_instance_parameter_value xcvr_rx_pll {gui_reference_clock_frequency} {500.0}
set_instance_parameter_value xcvr_rx_pll {gui_use_locked} {0}
set_instance_parameter_value xcvr_rx_pll {gui_output_clock_frequency0} {250.0}

# transceiver-control

add_instance axi_jesd_xcvr axi_jesd_xcvr 1.0
set_instance_parameter_value axi_jesd_xcvr {DEVICE_TYPE} {0}
set_instance_parameter_value axi_jesd_xcvr {TX_NUM_OF_LANES} {4}
set_instance_parameter_value axi_jesd_xcvr {RX_NUM_OF_LANES} {4}

# transceiver-reset

add_instance xcvr_rst_cntrl altera_xcvr_reset_control 15.1
set_instance_parameter_value xcvr_rst_cntrl {CHANNELS} {4}
set_instance_parameter_value xcvr_rst_cntrl {SYS_CLK_IN_MHZ} {100}
set_instance_parameter_value xcvr_rst_cntrl {TX_PLL_ENABLE} {1}
set_instance_parameter_value xcvr_rst_cntrl {T_PLL_POWERDOWN} {1000}
set_instance_parameter_value xcvr_rst_cntrl {TX_ENABLE} {1}
set_instance_parameter_value xcvr_rst_cntrl {T_TX_ANALOGRESET} {70000}
set_instance_parameter_value xcvr_rst_cntrl {T_TX_DIGITALRESET} {70000}
set_instance_parameter_value xcvr_rst_cntrl {gui_pll_cal_busy} {1}
set_instance_parameter_value xcvr_rst_cntrl {RX_ENABLE} {1}
set_instance_parameter_value xcvr_rst_cntrl {T_RX_ANALOGRESET} {70000}
set_instance_parameter_value xcvr_rst_cntrl {T_RX_DIGITALRESET} {4000}

# transceiver-core (+ jesd)

add_instance xcvr_core altera_jesd204 15.1
set_instance_parameter_value xcvr_core {wrapper_opt} {base_phy}
set_instance_parameter_value xcvr_core {DATA_PATH} {RX_TX}
set_instance_parameter_value xcvr_core {lane_rate} {10000.0}
set_instance_parameter_value xcvr_core {PCS_CONFIG} {JESD_PCS_CFG2}
set_instance_parameter_value xcvr_core {bonded_mode} {non_bonded}
set_instance_parameter_value xcvr_core {REFCLK_FREQ} {500.0}
set_instance_parameter_value xcvr_core {pll_reconfig_enable} {1}
set_instance_parameter_value xcvr_core {set_capability_reg_enable} {1}
set_instance_parameter_value xcvr_core {set_csr_soft_logic_enable} {1}
set_instance_parameter_value xcvr_core {L} {4}
set_instance_parameter_value xcvr_core {M} {2}
set_instance_parameter_value xcvr_core {GUI_EN_CFG_F} {1}
set_instance_parameter_value xcvr_core {GUI_CFG_F} {1}
set_instance_parameter_value xcvr_core {N} {16}
set_instance_parameter_value xcvr_core {S} {1}
set_instance_parameter_value xcvr_core {K} {32}
set_instance_parameter_value xcvr_core {SCR} {1}
set_instance_parameter_value xcvr_core {HD} {1}

# transceiver + jesd interfaces

add_connection xcvr_tx_ref_clk.out_clk xcvr_tx_pll.refclk
add_connection xcvr_tx_ref_clk.out_clk xcvr_tx_lane_pll.pll_refclk0
add_interface tx_ref_clk clock sink
set_interface_property tx_ref_clk EXPORT_OF xcvr_tx_ref_clk.in_clk

add_connection xcvr_rx_ref_clk.out_clk xcvr_rx_pll.refclk
add_connection xcvr_rx_ref_clk.out_clk xcvr_core.rx_pll_ref_clk
add_interface rx_ref_clk clock sink
set_interface_property rx_ref_clk EXPORT_OF xcvr_rx_ref_clk.in_clk

add_connection sys_clk.clk_reset xcvr_tx_pll.reset
add_connection axi_jesd_xcvr.if_rst xcvr_tx_pll.reset
add_connection xcvr_tx_pll.outclk0 xcvr_core.txlink_clk
add_connection sys_clk.clk_reset xcvr_tx_pll_reconfig.mgmt_reset
add_connection sys_clk.clk xcvr_tx_pll_reconfig.mgmt_clk
add_connection sys_cpu.data_master xcvr_tx_pll_reconfig.mgmt_avalon_slave
add_connection xcvr_tx_pll_reconfig.reconfig_from_pll xcvr_tx_pll.reconfig_from_pll
add_connection xcvr_tx_pll.reconfig_to_pll xcvr_tx_pll_reconfig.reconfig_to_pll

add_connection sys_clk.clk_reset xcvr_rx_pll.reset
add_connection axi_jesd_xcvr.if_rst xcvr_rx_pll.reset
add_connection xcvr_rx_pll.outclk0 xcvr_core.rxlink_clk
add_connection sys_clk.clk_reset xcvr_rx_pll_reconfig.mgmt_reset
add_connection sys_clk.clk xcvr_rx_pll_reconfig.mgmt_clk
add_connection sys_cpu.data_master xcvr_rx_pll_reconfig.mgmt_avalon_slave
add_connection xcvr_rx_pll.reconfig_from_pll xcvr_rx_pll_reconfig.reconfig_from_pll
add_connection xcvr_rx_pll_reconfig.reconfig_to_pll xcvr_rx_pll.reconfig_to_pll

add_connection xcvr_rst_cntrl.pll_powerdown xcvr_tx_lane_pll.pll_powerdown
add_connection xcvr_tx_lane_pll.pll_cal_busy xcvr_rst_cntrl.pll_cal_busy
add_connection xcvr_tx_lane_pll.pll_locked xcvr_rst_cntrl.pll_locked
add_connection xcvr_tx_lane_pll.tx_serial_clk xcvr_core.tx_serial_clk0_ch0
add_connection xcvr_tx_lane_pll.tx_serial_clk xcvr_core.tx_serial_clk0_ch1
add_connection xcvr_tx_lane_pll.tx_serial_clk xcvr_core.tx_serial_clk0_ch2
add_connection xcvr_tx_lane_pll.tx_serial_clk xcvr_core.tx_serial_clk0_ch3
add_connection sys_clk.clk_reset xcvr_tx_lane_pll.reconfig_reset0
add_connection sys_clk.clk xcvr_tx_lane_pll.reconfig_clk0
add_connection sys_cpu.data_master xcvr_tx_lane_pll.reconfig_avmm0

add_connection sys_clk.clk_reset xcvr_rst_cntrl.reset
add_connection sys_clk.clk xcvr_rst_cntrl.clock
add_connection xcvr_rst_cntrl.tx_analogreset xcvr_core.tx_analogreset
add_connection xcvr_rst_cntrl.tx_digitalreset xcvr_core.tx_digitalreset
add_connection xcvr_rst_cntrl.tx_cal_busy xcvr_core.tx_cal_busy
add_connection xcvr_rst_cntrl.rx_analogreset xcvr_core.rx_analogreset
add_connection xcvr_rst_cntrl.rx_digitalreset xcvr_core.rx_digitalreset
add_connection xcvr_rst_cntrl.rx_cal_busy xcvr_core.rx_cal_busy
add_connection xcvr_rst_cntrl.rx_is_lockedtodata xcvr_core.rx_islockedtodata
add_connection axi_jesd_xcvr.if_rst xcvr_rst_cntrl.reset
add_connection xcvr_tx_pll.outclk0 axi_jesd_xcvr.if_tx_clk
add_connection axi_jesd_xcvr.if_tx_rstn xcvr_core.txlink_rst_n
add_connection axi_jesd_xcvr.if_tx_ready xcvr_rst_cntrl.tx_ready
add_connection axi_jesd_xcvr.if_tx_ip_sysref xcvr_core.tx_sysref
add_connection axi_jesd_xcvr.if_tx_ip_sync xcvr_core.sync_n
add_connection axi_jesd_xcvr.if_tx_ip_avl xcvr_core.jesd204_tx_link
add_connection xcvr_rx_pll.outclk0 axi_jesd_xcvr.if_rx_clk
add_connection axi_jesd_xcvr.if_rx_rstn xcvr_core.rxlink_rst_n
add_connection axi_jesd_xcvr.if_rx_ready xcvr_rst_cntrl.rx_ready
add_connection axi_jesd_xcvr.if_rx_ip_sysref xcvr_core.rx_sysref
add_connection axi_jesd_xcvr.if_rx_ip_sync xcvr_core.rx_dev_sync_n
add_connection axi_jesd_xcvr.if_rx_ip_sof xcvr_core.rx_sof
add_connection xcvr_core.jesd204_rx_link axi_jesd_xcvr.if_rx_ip_avl
add_connection sys_clk.clk_reset axi_jesd_xcvr.s_axi_reset
add_connection sys_clk.clk axi_jesd_xcvr.s_axi_clock
add_connection sys_cpu.data_master axi_jesd_xcvr.s_axi
add_interface tx_sysref conduit end
add_interface tx_sync conduit end
add_interface rx_sysref conduit end
add_interface rx_sync conduit end
set_interface_property tx_sysref EXPORT_OF axi_jesd_xcvr.if_tx_ext_sysref_in
set_interface_property tx_sync EXPORT_OF axi_jesd_xcvr.if_tx_sync
set_interface_property rx_sysref EXPORT_OF axi_jesd_xcvr.if_rx_ext_sysref_in
set_interface_property rx_sync EXPORT_OF axi_jesd_xcvr.if_rx_sync

add_connection sys_clk.clk_reset xcvr_core.reconfig_reset
add_connection sys_clk.clk xcvr_core.reconfig_clk
add_connection sys_clk.clk_reset xcvr_core.jesd204_tx_avs_rst_n
add_connection sys_clk.clk xcvr_core.jesd204_tx_avs_clk
add_connection sys_clk.clk_reset xcvr_core.jesd204_rx_avs_rst_n
add_connection sys_clk.clk xcvr_core.jesd204_rx_avs_clk
add_connection xcvr_core.alldev_lane_aligned xcvr_core.dev_lane_aligned
add_connection xcvr_core.tx_dev_sync_n xcvr_core.mdev_sync_n
add_connection sys_cpu.data_master xcvr_core.reconfig_avmm
add_connection sys_cpu.data_master xcvr_core.jesd204_tx_avs
add_connection sys_cpu.data_master xcvr_core.jesd204_rx_avs
add_interface tx_data conduit end
add_interface rx_data conduit end
set_interface_property tx_data EXPORT_OF xcvr_core.tx_serial_data
set_interface_property rx_data EXPORT_OF xcvr_core.rx_serial_data

# ad9144

add_instance axi_ad9144_core axi_ad9144 1.0
set_instance_parameter_value axi_ad9144_core {QUAD_OR_DUAL_N} {0}

add_connection xcvr_tx_pll.outclk0 axi_ad9144_core.if_tx_clk
add_connection axi_jesd_xcvr.if_tx_data axi_ad9144_core.if_tx_data
add_connection sys_clk.clk_reset axi_ad9144_core.s_axi_reset
add_connection sys_clk.clk axi_ad9144_core.s_axi_clock
add_connection sys_cpu.data_master axi_ad9144_core.s_axi

# ad9144-unpack

add_instance util_ad9144_upack util_upack 1.0
set_instance_parameter_value util_ad9144_upack {CHANNEL_DATA_WIDTH} {64}
set_instance_parameter_value util_ad9144_upack {NUM_OF_CHANNELS} {2}

add_connection xcvr_tx_pll.outclk0 util_ad9144_upack.if_dac_clk
add_connection axi_ad9144_core.dac_ch_0 util_ad9144_upack.dac_ch_0
add_connection axi_ad9144_core.dac_ch_1 util_ad9144_upack.dac_ch_1

# ad9144-dma

add_instance axi_ad9144_dma axi_dmac 1.0
set_instance_parameter_value axi_ad9144_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value axi_ad9144_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9144_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9144_dma {DMA_TYPE_DEST} {2}
set_instance_parameter_value axi_ad9144_dma {DMA_TYPE_SRC} {0}

add_connection xcvr_tx_pll.outclk0 axi_ad9144_dma.if_fifo_rd_clk
add_connection util_ad9144_upack.if_dac_valid axi_ad9144_dma.if_fifo_rd_en
add_connection util_ad9144_upack.if_dac_data axi_ad9144_dma.if_fifo_rd_dout
add_connection axi_ad9144_dma.if_fifo_rd_underflow axi_ad9144_core.if_dac_dunf
add_connection sys_clk.clk_reset axi_ad9144_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9144_dma.s_axi_clock
add_connection sys_cpu.data_master axi_ad9144_dma.s_axi
add_connection sys_ddr3_cntrl.emif_usr_reset_n axi_ad9144_dma.m_src_axi_reset
add_connection sys_ddr3_cntrl.emif_usr_clk axi_ad9144_dma.m_src_axi_clock
add_connection axi_ad9144_dma.m_src_axi sys_ddr3_cntrl.ctrl_amm_0
add_connection sys_cpu.irq axi_ad9144_dma.interrupt_sender

# ad9680

add_instance axi_ad9680_core axi_ad9680 1.0

add_connection xcvr_rx_pll.outclk0 axi_ad9680_core.if_rx_clk
add_connection axi_jesd_xcvr.if_rx_data axi_ad9680_core.if_rx_data
add_connection sys_clk.clk_reset axi_ad9680_core.s_axi_reset
add_connection sys_clk.clk axi_ad9680_core.s_axi_clock
add_connection sys_cpu.data_master axi_ad9680_core.s_axi

# ad9680-pack

add_instance util_ad9680_cpack util_cpack 1.0
set_instance_parameter_value util_ad9680_cpack {CHANNEL_DATA_WIDTH} {64}
set_instance_parameter_value util_ad9680_cpack {NUM_OF_CHANNELS} {2}

add_connection sys_clk.clk_reset util_ad9680_cpack.if_adc_rst
add_connection sys_ddr3_cntrl.emif_usr_reset_n util_ad9680_cpack.if_adc_rst
add_connection xcvr_rx_pll.outclk0 util_ad9680_cpack.if_adc_clk
add_connection axi_ad9680_core.adc_ch_0 util_ad9680_cpack.adc_ch_0
add_connection axi_ad9680_core.adc_ch_1 util_ad9680_cpack.adc_ch_1

# ad9680-fifo

add_instance ad9680_adcfifo util_adcfifo 1.0
set_instance_parameter_value ad9680_adcfifo {ADC_DATA_WIDTH} {128}
set_instance_parameter_value ad9680_adcfifo {DMA_DATA_WIDTH} {128}
set_instance_parameter_value ad9680_adcfifo {DMA_ADDRESS_WIDTH} {16}

add_connection sys_clk.clk_reset ad9680_adcfifo.if_adc_rst
add_connection sys_ddr3_cntrl.emif_usr_reset_n ad9680_adcfifo.if_adc_rst
add_connection xcvr_rx_pll.outclk0 ad9680_adcfifo.if_adc_clk
add_connection util_ad9680_cpack.if_adc_valid ad9680_adcfifo.if_adc_wr
add_connection util_ad9680_cpack.if_adc_data ad9680_adcfifo.if_adc_wdata
add_connection sys_ddr3_cntrl.emif_usr_clk ad9680_adcfifo.if_dma_clk

# ad9680-dma

add_instance axi_ad9680_dma axi_dmac 1.0
set_instance_parameter_value axi_ad9680_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value axi_ad9680_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9680_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9680_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9680_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_ad9680_dma {CYCLIC} {0}
set_instance_parameter_value axi_ad9680_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9680_dma {DMA_TYPE_SRC} {1}

add_connection sys_ddr3_cntrl.emif_usr_clk axi_ad9680_dma.if_s_axis_aclk
add_connection ad9680_adcfifo.if_dma_wr axi_ad9680_dma.if_s_axis_valid
add_connection ad9680_adcfifo.if_dma_wdata axi_ad9680_dma.if_s_axis_data
add_connection ad9680_adcfifo.if_dma_wready axi_ad9680_dma.if_s_axis_ready
add_connection ad9680_adcfifo.if_dma_xfer_req axi_ad9680_dma.if_s_axis_xfer_req
add_connection ad9680_adcfifo.if_adc_wovf axi_ad9680_core.if_adc_dovf
add_connection sys_clk.clk_reset axi_ad9680_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9680_dma.s_axi_clock
add_connection sys_cpu.data_master axi_ad9680_dma.s_axi
add_connection sys_ddr3_cntrl.emif_usr_reset_n axi_ad9680_dma.m_dest_axi_reset
add_connection sys_ddr3_cntrl.emif_usr_clk axi_ad9680_dma.m_dest_axi_clock
add_connection axi_ad9680_dma.m_dest_axi sys_ddr3_cntrl.ctrl_amm_0
add_connection sys_cpu.irq axi_ad9680_dma.interrupt_sender

# addresses

set_connection_parameter_value sys_cpu.data_master/xcvr_rx_pll_reconfig.mgmt_avalon_slave baseAddress {0x1003d800}
set_connection_parameter_value sys_cpu.data_master/xcvr_tx_pll_reconfig.mgmt_avalon_slave baseAddress {0x1003d000}
set_connection_parameter_value sys_cpu.data_master/xcvr_tx_lane_pll.reconfig_avmm0        baseAddress {0x1003c000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9680_dma.s_axi                   baseAddress {0x10034000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9680_core.s_axi                  baseAddress {0x10010000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9144_dma.s_axi                   baseAddress {0x10038000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9144_core.s_axi                  baseAddress {0x10020000}
set_connection_parameter_value sys_cpu.data_master/xcvr_core.reconfig_avmm                baseAddress {0x10030000}
set_connection_parameter_value sys_cpu.data_master/axi_jesd_xcvr.s_axi                    baseAddress {0x10000000}
set_connection_parameter_value sys_cpu.data_master/xcvr_core.jesd204_tx_avs               baseAddress {0x1003e000}
set_connection_parameter_value sys_cpu.data_master/xcvr_core.jesd204_rx_avs               baseAddress {0x1003e400}
set_connection_parameter_value axi_ad9680_dma.m_dest_axi/sys_ddr3_cntrl.ctrl_amm_0        baseAddress {0x00000000}
set_connection_parameter_value axi_ad9144_dma.m_src_axi/sys_ddr3_cntrl.ctrl_amm_0         baseAddress {0x00000000}

# interrupts

set_connection_parameter_value sys_cpu.irq/axi_ad9680_dma.interrupt_sender irqNumber {10}
set_connection_parameter_value sys_cpu.irq/axi_ad9144_dma.interrupt_sender irqNumber {11}
