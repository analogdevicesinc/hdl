
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# transceiver core

ad_xcvr_parameter number_of_lanes 8
ad_xcvr_parameter rx_lane_rate {6.250 Gbps}
ad_xcvr_parameter rx_ref_clk_frequency {625.000 MHz}
ad_xcvr_instance axi_ad9625_xcvr

# adc peripherals (jesd)

adi_axi_jesd204_rx_create axi_ad9625_jesd 8
create_bd_port -dir I rx_sysref
create_bd_port -dir O rx_sync
ad_connect rx_sysref axi_ad9625_jesd/sysref
ad_connect axi_ad9625_jesd/sync rx_sync
ad_connect axi_ad9625_xcvr_rx_core_clk axi_ad9625_jesd/device_clk
ad_connect axi_ad9625_jesd/phy_en_char_align axi_ad9625_xcvr/rxencommaalign

# adc peripherals (ad9625-core)

ad_ip_instance axi_ad9625 axi_ad9625_core
ad_connect axi_ad9625_xcvr_rx_core_clk axi_ad9625_core/rx_clk
ad_connect axi_ad9625_jesd/rx_sof axi_ad9625_core/rx_sof
ad_connect axi_ad9625_jesd/rx_data_tdata axi_ad9625_core/rx_data

# adc peripherals (fifo, see system_bd.tcl)

ad_connect axi_ad9625_xcvr_rx_core_clk axi_ad9625_fifo/adc_clk
ad_connect axi_ad9625_core/adc_enable axi_ad9625_fifo/adc_wr
ad_connect axi_ad9625_core/adc_data axi_ad9625_fifo/adc_wdata
ad_connect axi_ad9625_fifo/adc_wovf axi_ad9625_core/adc_dovf
ad_connect sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect axi_ad9625_fifo/adc_rst GND

# adc peripherals (dma)

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

# core clock port

create_bd_port -dir O rx_core_clk
ad_connect axi_ad9625_xcvr_rx_core_clk rx_core_clk

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9625_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9625_core
ad_cpu_interconnect 0x44AA0000 axi_ad9625_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9625_dma

# interconnect (mem/adc)

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-13 axi_ad9625_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9625_dma/irq

