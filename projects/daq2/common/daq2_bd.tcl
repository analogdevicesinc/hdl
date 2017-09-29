
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# shared transceiver core

ad_xcvr_parameter number_of_lanes 4
ad_xcvr_parameter rx_ref_clk_frequency 500.000
ad_xcvr_parameter rx_lane_rate 10
ad_xcvr_parameter rx_pll_type 3
ad_xcvr_parameter tx_ref_clk_frequency 500.000
ad_xcvr_parameter tx_lane_rate 10
ad_xcvr_parameter tx_pll_type 3
ad_xcvr_instance axi_daq2_xcvr

create_bd_port -dir I -from 3 -to 0 rx_data_p
create_bd_port -dir I -from 3 -to 0 rx_data_n
ad_connect rx_data_p axi_daq2_xcvr/rxp_in
ad_connect rx_data_n axi_daq2_xcvr/rxn_in

create_bd_port -dir O -from 3 -to 0 tx_data_p
create_bd_port -dir O -from 3 -to 0 tx_data_n
ad_connect axi_daq2_xcvr/txp_out tx_data_p
ad_connect axi_daq2_xcvr/txn_out tx_data_n

ad_ip_instance util_ds_buf util_ad9680_clk
ad_ip_parameter util_ad9680_clk CONFIG.C_BUF_TYPE {BUFG}
ad_connect sys_cpu_reset axi_daq2_xcvr/rx_sys_reset
ad_connect sys_cpu_reset axi_daq2_xcvr/rx_reset_gt
ad_connect axi_daq2_xcvr/rxoutclk util_ad9680_clk/BUFG_I
ad_connect util_ad9680_clk/BUFG_O axi_daq2_xcvr/rx_core_clk

ad_ip_instance util_ds_buf util_ad9144_clk
ad_ip_parameter util_ad9144_clk CONFIG.C_BUF_TYPE {BUFG}
ad_connect sys_cpu_reset axi_daq2_xcvr/tx_sys_reset
ad_connect sys_cpu_reset axi_daq2_xcvr/tx_reset_gt
ad_connect axi_daq2_xcvr/txoutclk util_ad9144_clk/BUFG_I
ad_connect util_ad9144_clk/BUFG_O axi_daq2_xcvr/tx_core_clk

# dac peripherals (jesd)

adi_axi_jesd204_tx_create axi_ad9144_jesd 4
create_bd_port -dir I tx_sysref
create_bd_port -dir I tx_sync
ad_connect tx_sysref axi_ad9144_jesd/sysref
ad_connect tx_sync axi_ad9144_jesd/sync
ad_connect util_ad9144_clk/BUFG_O axi_ad9144_jesd/device_clk
ad_connect axi_ad9144_jesd/tx_phy0 axi_daq2_xcvr/gt0_tx
ad_connect axi_ad9144_jesd/tx_phy1 axi_daq2_xcvr/gt2_tx
ad_connect axi_ad9144_jesd/tx_phy2 axi_daq2_xcvr/gt3_tx
ad_connect axi_ad9144_jesd/tx_phy3 axi_daq2_xcvr/gt1_tx

# dac peripherals (ad9144 core)

ad_ip_instance axi_ad9144 axi_ad9144_core
ad_ip_parameter axi_ad9144_core CONFIG.QUAD_OR_DUAL_N 0
ad_connect util_ad9144_clk/BUFG_O axi_ad9144_core/tx_clk
ad_connect axi_ad9144_core/tx_data axi_ad9144_jesd/tx_data_tdata
ad_connect axi_ad9144_core/dac_ddata_2 GND
ad_connect axi_ad9144_core/dac_ddata_3 GND

# dac peripherals (channel unpack)

ad_ip_instance util_upack axi_ad9144_upack
ad_ip_parameter axi_ad9144_upack CONFIG.CHANNEL_DATA_WIDTH 64
ad_ip_parameter axi_ad9144_upack CONFIG.NUM_OF_CHANNELS 2
ad_connect util_ad9144_clk/BUFG_O axi_ad9144_upack/dac_clk
ad_connect axi_ad9144_core/dac_enable_0 axi_ad9144_upack/dac_enable_0
ad_connect axi_ad9144_core/dac_valid_0 axi_ad9144_upack/dac_valid_0
ad_connect axi_ad9144_upack/dac_data_0 axi_ad9144_core/dac_ddata_0
ad_connect axi_ad9144_core/dac_enable_1 axi_ad9144_upack/dac_enable_1
ad_connect axi_ad9144_core/dac_valid_1 axi_ad9144_upack/dac_valid_1
ad_connect axi_ad9144_upack/dac_data_1 axi_ad9144_core/dac_ddata_1

# dac peripherals (fifo, see system_bd.tcl)

ad_connect util_ad9144_clk/BUFG_O axi_ad9144_fifo/dac_clk
ad_connect axi_ad9144_upack/dac_valid axi_ad9144_fifo/dac_valid
ad_connect axi_ad9144_upack/dac_data axi_ad9144_fifo/dac_data
ad_connect axi_ad9144_fifo/dac_rst GND
ad_connect axi_ad9144_fifo/bypass GND
ad_connect sys_cpu_clk axi_ad9144_fifo/dma_clk
ad_connect sys_cpu_reset axi_ad9144_fifo/dma_rst

# dac peripherals (dma)

ad_ip_instance axi_dmac axi_ad9144_dma
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9144_dma CONFIG.ID 1
ad_ip_parameter axi_ad9144_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9144_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9144_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_connect sys_cpu_clk axi_ad9144_dma/m_axis_aclk
ad_connect sys_cpu_resetn axi_ad9144_dma/m_src_axi_aresetn
ad_connect axi_ad9144_fifo/dma_valid axi_ad9144_dma/m_axis_valid
ad_connect axi_ad9144_fifo/dma_data axi_ad9144_dma/m_axis_data
ad_connect axi_ad9144_dma/m_axis_ready axi_ad9144_fifo/dma_ready
ad_connect axi_ad9144_dma/m_axis_xfer_req axi_ad9144_fifo/dma_xfer_req
ad_connect axi_ad9144_dma/m_axis_last axi_ad9144_fifo/dma_xfer_last

# adc peripherals (jesd)

adi_axi_jesd204_rx_create axi_ad9680_jesd 4
create_bd_port -dir I rx_sysref
create_bd_port -dir O rx_sync
ad_connect rx_sysref axi_ad9680_jesd/sysref
ad_connect axi_ad9680_jesd/sync rx_sync
ad_connect util_ad9680_clk/BUFG_O axi_ad9680_jesd/device_clk
ad_connect axi_daq2_xcvr/gt0_rx axi_ad9680_jesd/rx_phy0
ad_connect axi_daq2_xcvr/gt1_rx axi_ad9680_jesd/rx_phy1
ad_connect axi_daq2_xcvr/gt2_rx axi_ad9680_jesd/rx_phy2
ad_connect axi_daq2_xcvr/gt3_rx axi_ad9680_jesd/rx_phy3
ad_connect axi_ad9680_jesd/phy_en_char_align axi_daq2_xcvr/rxencommaalign

# adc peripherals (ad9680 core)

ad_ip_instance axi_ad9680 axi_ad9680_core
ad_connect util_ad9680_clk/BUFG_O axi_ad9680_core/rx_clk
ad_connect axi_ad9680_jesd/rx_sof axi_ad9680_core/rx_sof
ad_connect axi_ad9680_jesd/rx_data_tdata axi_ad9680_core/rx_data

# adc peripherals (channel pack)

ad_ip_instance util_cpack axi_ad9680_cpack
ad_ip_parameter axi_ad9680_cpack CONFIG.CHANNEL_DATA_WIDTH 64
ad_ip_parameter axi_ad9680_cpack CONFIG.NUM_OF_CHANNELS 2
ad_connect util_ad9680_clk/BUFG_O axi_ad9680_cpack/adc_clk
ad_connect axi_ad9680_core/adc_enable_0 axi_ad9680_cpack/adc_enable_0
ad_connect axi_ad9680_core/adc_valid_0 axi_ad9680_cpack/adc_valid_0
ad_connect axi_ad9680_core/adc_data_0 axi_ad9680_cpack/adc_data_0
ad_connect axi_ad9680_core/adc_enable_1 axi_ad9680_cpack/adc_enable_1
ad_connect axi_ad9680_core/adc_valid_1 axi_ad9680_cpack/adc_valid_1
ad_connect axi_ad9680_core/adc_data_1 axi_ad9680_cpack/adc_data_1
ad_connect axi_ad9680_cpack/adc_rst GND

# adc peripherals (fifo, system_bd.tcl)

ad_connect util_ad9680_clk/BUFG_O axi_ad9680_fifo/adc_clk
ad_connect axi_ad9680_cpack/adc_valid axi_ad9680_fifo/adc_wr
ad_connect axi_ad9680_cpack/adc_data axi_ad9680_fifo/adc_wdata
ad_connect sys_cpu_clk axi_ad9680_fifo/dma_clk
ad_connect axi_ad9680_fifo/adc_wovf axi_ad9680_core/adc_dovf
ad_connect axi_ad9680_fifo/adc_rst GND

# adc peripherals (dma)

ad_ip_instance axi_dmac axi_ad9680_dma
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9680_dma CONFIG.ID 0
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9680_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9680_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_connect sys_cpu_clk axi_ad9680_dma/s_axis_aclk
ad_connect sys_cpu_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect axi_ad9680_fifo/dma_wr axi_ad9680_dma/s_axis_valid
ad_connect axi_ad9680_fifo/dma_wdata axi_ad9680_dma/s_axis_data
ad_connect axi_ad9680_fifo/dma_wready axi_ad9680_dma/s_axis_ready
ad_connect axi_ad9680_fifo/dma_xfer_req axi_ad9680_dma/s_axis_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_daq2_xcvr
ad_cpu_interconnect 0x44A00000 axi_ad9144_core
ad_cpu_interconnect 0x44A90000 axi_ad9144_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9144_dma
ad_cpu_interconnect 0x44A10000 axi_ad9680_core
ad_cpu_interconnect 0x44AA0000 axi_ad9680_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9680_dma

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9144_dma/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9680_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9144_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_ad9680_jesd/irq
ad_cpu_interrupt ps-12 mb-13 axi_ad9144_dma/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9680_dma/irq


