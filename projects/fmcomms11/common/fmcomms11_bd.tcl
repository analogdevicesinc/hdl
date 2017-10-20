
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# shared transceiver core

ad_xcvr_parameter number_of_lanes 8
ad_xcvr_parameter rx_lane_rate {6.25 Gbps}
ad_xcvr_parameter tx_lane_rate {12.5 Gbps}
ad_xcvr_parameter rx_ref_clk_frequency {156.250 MHz}
ad_xcvr_parameter tx_ref_clk_frequency {156.250 MHz}
ad_xcvr_instance axi_fmcomms11_xcvr

# dac peripherals (ad9162 jesd)

adi_axi_jesd204_tx_create axi_ad9162_jesd 8
create_bd_port -dir I tx_sysref
create_bd_port -dir I tx_sync
ad_connect tx_sysref axi_ad9162_jesd/sysref
ad_connect tx_sync axi_ad9162_jesd/sync
ad_connect axi_fmcomms11_xcvr_tx_core_clk axi_ad9162_jesd/device_clk

# dac peripherals (ad9162 core)

ad_ip_instance axi_ad9162 axi_ad9162_core
ad_connect axi_fmcomms11_xcvr_tx_core_clk axi_ad9162_core/tx_clk
ad_connect axi_ad9162_core/tx_data axi_ad9162_jesd/tx_data_tdata

# dac peripherals (ad9162 fifo, see system_bd.tcl)

ad_connect axi_fmcomms11_xcvr_tx_core_clk axi_ad9162_fifo/dac_clk
ad_connect axi_ad9162_core/dac_valid axi_ad9162_fifo/dac_valid
ad_connect axi_ad9162_core/dac_ddata axi_ad9162_fifo/dac_data
ad_connect axi_ad9162_fifo/dac_dunf axi_ad9162_core/dac_dunf
ad_connect axi_ad9162_fifo/dac_rst GND
ad_connect axi_ad9162_fifo/bypass GND
ad_connect sys_cpu_clk axi_ad9162_fifo/dma_clk
ad_connect sys_cpu_reset axi_ad9162_fifo/dma_rst

# dac peripherals (ad9162 dma)

ad_ip_instance axi_dmac axi_ad9162_dma
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9162_dma CONFIG.ID 1
ad_ip_parameter axi_ad9162_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9162_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9162_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_DATA_WIDTH_DEST 256
ad_connect sys_cpu_clk axi_ad9162_dma/m_axis_aclk
ad_connect sys_cpu_resetn axi_ad9162_dma/m_src_axi_aresetn
ad_connect axi_ad9162_fifo/dma_valid axi_ad9162_dma/m_axis_valid
ad_connect axi_ad9162_fifo/dma_data axi_ad9162_dma/m_axis_data
ad_connect axi_ad9162_dma/m_axis_ready axi_ad9162_fifo/dma_ready
ad_connect axi_ad9162_dma/m_axis_xfer_req axi_ad9162_fifo/dma_xfer_req
ad_connect axi_ad9162_dma/m_axis_last axi_ad9162_fifo/dma_xfer_last

# adc peripherals (ad9625 jesd)

adi_axi_jesd204_rx_create axi_ad9625_jesd 8
create_bd_port -dir I rx_sysref
create_bd_port -dir O rx_sync
ad_connect rx_sysref axi_ad9625_jesd/sysref
ad_connect axi_ad9625_jesd/sync rx_sync
ad_connect axi_fmcomms11_xcvr_rx_core_clk axi_ad9625_jesd/device_clk
ad_connect axi_ad9625_jesd/phy_en_char_align axi_fmcomms11_xcvr/rxencommaalign

# adc peripherals (ad9625 core)

ad_ip_instance axi_ad9625 axi_ad9625_core
ad_connect axi_fmcomms11_xcvr_rx_core_clk axi_ad9625_core/rx_clk
ad_connect axi_ad9625_jesd/rx_sof axi_ad9625_core/rx_sof
ad_connect axi_ad9625_jesd/rx_data_tdata axi_ad9625_core/rx_data

# adc peripherals (ad9625 fifo, see system_bd.tcl)

ad_connect axi_fmcomms11_xcvr_rx_core_clk axi_ad9625_fifo/adc_clk
ad_connect axi_ad9625_core/adc_valid axi_ad9625_fifo/adc_wr
ad_connect axi_ad9625_core/adc_data axi_ad9625_fifo/adc_wdata
ad_connect axi_ad9625_fifo/adc_wovf axi_ad9625_core/adc_dovf
ad_connect sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect axi_ad9625_fifo/adc_rst GND

# adc peripherals (ad9625 dma)

ad_ip_instance axi_dmac axi_ad9625_dma
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9625_dma CONFIG.ID 0
ad_ip_parameter axi_ad9625_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9625_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9625_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9625_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_connect sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn
ad_connect axi_ad9625_fifo/dma_wr axi_ad9625_dma/s_axis_valid
ad_connect axi_ad9625_fifo/dma_wdata axi_ad9625_dma/s_axis_data
ad_connect axi_ad9625_dma/s_axis_ready axi_ad9625_fifo/dma_wready
ad_connect axi_ad9625_dma/s_axis_xfer_req axi_ad9625_fifo/dma_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_fmcomms11_xcvr
ad_cpu_interconnect 0x44A00000 axi_ad9162_core
ad_cpu_interconnect 0x44A90000 axi_ad9162_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9162_dma
ad_cpu_interconnect 0x44A10000 axi_ad9625_core
ad_cpu_interconnect 0x44AA0000 axi_ad9625_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9625_dma

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9162_dma/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9162_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_ad9625_jesd/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9162_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9625_dma/irq

