
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# transceiver core

ad_xcvr_parameter number_of_lanes 2
ad_xcvr_parameter rx_lane_rate {4.000 Gbps}
ad_xcvr_parameter rx_ref_clk_frequency {200.000 MHz}
ad_xcvr_instance axi_ad6676_xcvr

# adc peripherals (jesd)

adi_axi_jesd204_rx_create axi_ad6676_jesd 2
create_bd_port -dir I rx_sysref
create_bd_port -dir O rx_sync
ad_connect rx_sysref axi_ad6676_jesd/sysref
ad_connect axi_ad6676_jesd/sync rx_sync
ad_connect axi_ad6676_xcvr_rx_core_clk axi_ad6676_jesd/device_clk
ad_connect axi_ad6676_jesd/phy_en_char_align axi_ad6676_xcvr/rxencommaalign

# adc peripherals (ad6676-core)

ad_ip_instance axi_ad6676 axi_ad6676_core
ad_connect axi_ad6676_xcvr_rx_core_clk axi_ad6676_core/rx_clk
ad_connect axi_ad6676_jesd/rx_sof axi_ad6676_core/rx_sof
ad_connect axi_ad6676_jesd/rx_data_tdata axi_ad6676_core/rx_data

# adc peripherals (cpack)

ad_ip_instance util_cpack axi_ad6676_cpack
ad_ip_parameter axi_ad6676_cpack CONFIG.NUM_OF_CHANNELS 2
ad_connect axi_ad6676_xcvr_rx_core_clk axi_ad6676_cpack/adc_clk
ad_connect axi_ad6676_core/adc_enable_0 axi_ad6676_cpack/adc_enable_0
ad_connect axi_ad6676_core/adc_valid_0 axi_ad6676_cpack/adc_valid_0
ad_connect axi_ad6676_core/adc_data_0 axi_ad6676_cpack/adc_data_0
ad_connect axi_ad6676_core/adc_enable_1 axi_ad6676_cpack/adc_enable_1
ad_connect axi_ad6676_core/adc_valid_1 axi_ad6676_cpack/adc_valid_1
ad_connect axi_ad6676_core/adc_data_1 axi_ad6676_cpack/adc_data_1
ad_connect axi_ad6676_cpack/adc_rst GND

# adc peripherals (dma)

ad_ip_instance axi_dmac axi_ad6676_dma
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad6676_dma CONFIG.ID 0
ad_ip_parameter axi_ad6676_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad6676_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad6676_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad6676_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_connect axi_ad6676_xcvr_rx_core_clk axi_ad6676_dma/fifo_wr_clk
ad_connect axi_ad6676_dma/fifo_wr_en axi_ad6676_cpack/adc_valid
ad_connect axi_ad6676_dma/fifo_wr_sync axi_ad6676_cpack/adc_sync
ad_connect axi_ad6676_dma/fifo_wr_din axi_ad6676_cpack/adc_data
ad_connect axi_ad6676_dma/fifo_wr_overflow axi_ad6676_core/adc_dovf
ad_connect sys_cpu_resetn axi_ad6676_dma/m_dest_axi_aresetn

# core clock port

create_bd_port -dir O rx_core_clk
ad_connect axi_ad6676_xcvr_rx_core_clk rx_core_clk

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad6676_xcvr
ad_cpu_interconnect 0x44AA0000 axi_ad6676_jesd
ad_cpu_interconnect 0x44A10000 axi_ad6676_core
ad_cpu_interconnect 0x7c420000 axi_ad6676_dma

# interconnect (adc)

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad6676_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad6676_jesd/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad6676_dma/irq

