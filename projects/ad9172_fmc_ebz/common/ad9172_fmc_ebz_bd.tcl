source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set NUM_OF_LANES 8
set NUM_OF_CHANNELS 2
set SAMPLE_WIDTH 16

# dac peripherals

ad_ip_instance axi_adxcvr axi_ad9172_xcvr
ad_ip_parameter axi_ad9172_xcvr CONFIG.NUM_OF_LANES $NUM_OF_LANES
ad_ip_parameter axi_ad9172_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9172_xcvr CONFIG.TX_OR_RX_N 1

adi_axi_jesd204_tx_create axi_ad9172_jesd 8

ad_ip_instance ad_ip_jesd204_tpl_dac ad9172_tpl_core
ad_ip_parameter ad9172_tpl_core CONFIG.NUM_LANES $NUM_OF_LANES
ad_ip_parameter ad9172_tpl_core CONFIG.NUM_CHANNELS $NUM_OF_CHANNELS
ad_ip_parameter ad9172_tpl_core CONFIG.CHANNEL_WIDTH $SAMPLE_WIDTH

ad_ip_instance util_upack axi_ad9172_upack
ad_ip_parameter axi_ad9172_upack CONFIG.CHANNEL_DATA_WIDTH 128
ad_ip_parameter axi_ad9172_upack CONFIG.NUM_OF_CHANNELS $NUM_OF_CHANNELS

ad_ip_instance axi_dmac axi_ad9172_dma
ad_ip_parameter axi_ad9172_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9172_dma CONFIG.DMA_DATA_WIDTH_DEST 256
ad_ip_parameter axi_ad9172_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9172_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9172_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9172_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9172_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9172_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9172_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9172_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9172_dma CONFIG.FIFO_SIZE 16

# transceiver core

ad_ip_instance util_adxcvr util_ad9172_xcvr
ad_ip_parameter util_ad9172_xcvr CONFIG.RX_NUM_OF_LANES 0
ad_ip_parameter util_ad9172_xcvr CONFIG.TX_NUM_OF_LANES $NUM_OF_LANES
ad_ip_parameter util_ad9172_xcvr CONFIG.TX_LANE_INVERT 15

ad_connect  sys_cpu_resetn util_ad9172_xcvr/up_rstn
ad_connect  sys_cpu_clk util_ad9172_xcvr/up_clk

# reference clocks & resets

create_bd_port -dir I tx_ref_clk_0

ad_xcvrpll  tx_ref_clk_0 util_ad9172_xcvr/qpll_ref_clk_*
ad_xcvrpll  tx_ref_clk_0 util_ad9172_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9172_xcvr/up_pll_rst util_ad9172_xcvr/up_qpll_rst_*

# connections (dac)

ad_xcvrcon  util_ad9172_xcvr axi_ad9172_xcvr axi_ad9172_jesd {1 0 3 2 4 7 5 6}
ad_connect  util_ad9172_xcvr/tx_out_clk_0 ad9172_tpl_core/link_clk
ad_connect  axi_ad9172_jesd/tx_data ad9172_tpl_core/link
ad_connect  util_ad9172_xcvr/tx_out_clk_0 axi_ad9172_upack/dac_clk

ad_ip_instance xlconcat ad9172_data_concat
ad_ip_parameter ad9172_data_concat CONFIG.NUM_PORTS $NUM_OF_CHANNELS

for {set i 0} {$i < $NUM_OF_CHANNELS} {incr i} {
  ad_ip_instance xlslice ad9172_enable_slice_$i
  ad_ip_parameter ad9172_enable_slice_$i CONFIG.DIN_WIDTH $NUM_OF_CHANNELS
  ad_ip_parameter ad9172_enable_slice_$i CONFIG.DIN_FROM $i
  ad_ip_parameter ad9172_enable_slice_$i CONFIG.DIN_TO $i

  ad_ip_instance xlslice ad9172_valid_slice_$i
  ad_ip_parameter ad9172_valid_slice_$i CONFIG.DIN_WIDTH $NUM_OF_CHANNELS
  ad_ip_parameter ad9172_valid_slice_$i CONFIG.DIN_FROM $i
  ad_ip_parameter ad9172_valid_slice_$i CONFIG.DIN_TO $i

  ad_connect ad9172_tpl_core/enable ad9172_enable_slice_$i/Din
  ad_connect ad9172_tpl_core/dac_valid ad9172_valid_slice_$i/Din

  ad_connect ad9172_enable_slice_$i/Dout axi_ad9172_upack/dac_enable_$i
  ad_connect ad9172_valid_slice_$i/Dout axi_ad9172_upack/dac_valid_$i
  ad_connect axi_ad9172_upack/dac_data_$i ad9172_data_concat/In$i

}
ad_connect ad9172_tpl_core/dac_ddata ad9172_data_concat/dout

ad_connect  util_ad9172_xcvr/tx_out_clk_0 axi_ad9172_fifo/dac_clk
ad_connect  axi_ad9172_jesd_rstgen/peripheral_reset axi_ad9172_fifo/dac_rst
ad_connect  axi_ad9172_upack/dac_valid axi_ad9172_fifo/dac_valid
ad_connect  axi_ad9172_upack/dac_data axi_ad9172_fifo/dac_data
ad_connect  ad9172_tpl_core/dac_dunf axi_ad9172_fifo/dac_dunf
ad_connect  sys_cpu_clk axi_ad9172_fifo/dma_clk
ad_connect  sys_cpu_reset axi_ad9172_fifo/dma_rst
ad_connect  sys_cpu_clk axi_ad9172_dma/m_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9172_dma/m_src_axi_aresetn
ad_connect  axi_ad9172_fifo/dma_xfer_req axi_ad9172_dma/m_axis_xfer_req
ad_connect  axi_ad9172_fifo/dma_ready axi_ad9172_dma/m_axis_ready
ad_connect  axi_ad9172_fifo/dma_data axi_ad9172_dma/m_axis_data
ad_connect  axi_ad9172_fifo/dma_valid axi_ad9172_dma/m_axis_valid
ad_connect  axi_ad9172_fifo/dma_xfer_last axi_ad9172_dma/m_axis_last


# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9172_xcvr
ad_cpu_interconnect 0x44A00000 ad9172_tpl_core
ad_cpu_interconnect 0x44A90000 axi_ad9172_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9172_dma


# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9172_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9172_jesd/irq
ad_cpu_interrupt ps-12 mb-13 axi_ad9172_dma/irq

ad_connect  axi_ad9172_fifo/bypass GND
