create_bd_port -dir I adrv1_rx1_dclk_in_n
create_bd_port -dir I adrv1_rx1_dclk_in_p
create_bd_port -dir I adrv1_rx1_idata_in_n
create_bd_port -dir I adrv1_rx1_idata_in_p
create_bd_port -dir I adrv1_rx1_qdata_in_n
create_bd_port -dir I adrv1_rx1_qdata_in_p
create_bd_port -dir I adrv1_rx1_strobe_in_n
create_bd_port -dir I adrv1_rx1_strobe_in_p
create_bd_port -dir I adrv2_rx1_dclk_in_n
create_bd_port -dir I adrv2_rx1_dclk_in_p
create_bd_port -dir I adrv2_rx1_idata_in_n
create_bd_port -dir I adrv2_rx1_idata_in_p
create_bd_port -dir I adrv2_rx1_qdata_in_n
create_bd_port -dir I adrv2_rx1_qdata_in_p
create_bd_port -dir I adrv2_rx1_strobe_in_n
create_bd_port -dir I adrv2_rx1_strobe_in_p

create_bd_port -dir I adrv1_rx2_dclk_in_n
create_bd_port -dir I adrv1_rx2_dclk_in_p
create_bd_port -dir I adrv1_rx2_idata_in_n
create_bd_port -dir I adrv1_rx2_idata_in_p
create_bd_port -dir I adrv1_rx2_qdata_in_n
create_bd_port -dir I adrv1_rx2_qdata_in_p
create_bd_port -dir I adrv1_rx2_strobe_in_n
create_bd_port -dir I adrv1_rx2_strobe_in_p
create_bd_port -dir I adrv2_rx2_dclk_in_n
create_bd_port -dir I adrv2_rx2_dclk_in_p
create_bd_port -dir I adrv2_rx2_idata_in_n
create_bd_port -dir I adrv2_rx2_idata_in_p
create_bd_port -dir I adrv2_rx2_qdata_in_n
create_bd_port -dir I adrv2_rx2_qdata_in_p
create_bd_port -dir I adrv2_rx2_strobe_in_n
create_bd_port -dir I adrv2_rx2_strobe_in_p

create_bd_port -dir O adrv1_tx1_dclk_out_n
create_bd_port -dir O adrv1_tx1_dclk_out_p
create_bd_port -dir I adrv1_tx1_dclk_in_n
create_bd_port -dir I adrv1_tx1_dclk_in_p
create_bd_port -dir O adrv1_tx1_idata_out_n
create_bd_port -dir O adrv1_tx1_idata_out_p
create_bd_port -dir O adrv1_tx1_qdata_out_n
create_bd_port -dir O adrv1_tx1_qdata_out_p
create_bd_port -dir O adrv1_tx1_strobe_out_n
create_bd_port -dir O adrv1_tx1_strobe_out_p
create_bd_port -dir O adrv2_tx1_dclk_out_n
create_bd_port -dir O adrv2_tx1_dclk_out_p
create_bd_port -dir I adrv2_tx1_dclk_in_n
create_bd_port -dir I adrv2_tx1_dclk_in_p
create_bd_port -dir O adrv2_tx1_idata_out_n
create_bd_port -dir O adrv2_tx1_idata_out_p
create_bd_port -dir O adrv2_tx1_qdata_out_n
create_bd_port -dir O adrv2_tx1_qdata_out_p
create_bd_port -dir O adrv2_tx1_strobe_out_n
create_bd_port -dir O adrv2_tx1_strobe_out_p

create_bd_port -dir O adrv1_tx2_dclk_out_n
create_bd_port -dir O adrv1_tx2_dclk_out_p
create_bd_port -dir I adrv1_tx2_dclk_in_n
create_bd_port -dir I adrv1_tx2_dclk_in_p
create_bd_port -dir O adrv1_tx2_idata_out_n
create_bd_port -dir O adrv1_tx2_idata_out_p
create_bd_port -dir O adrv1_tx2_qdata_out_n
create_bd_port -dir O adrv1_tx2_qdata_out_p
create_bd_port -dir O adrv1_tx2_strobe_out_n
create_bd_port -dir O adrv1_tx2_strobe_out_p
create_bd_port -dir O adrv2_tx2_dclk_out_n
create_bd_port -dir O adrv2_tx2_dclk_out_p
create_bd_port -dir I adrv2_tx2_dclk_in_n
create_bd_port -dir I adrv2_tx2_dclk_in_p
create_bd_port -dir O adrv2_tx2_idata_out_n
create_bd_port -dir O adrv2_tx2_idata_out_p
create_bd_port -dir O adrv2_tx2_qdata_out_n
create_bd_port -dir O adrv2_tx2_qdata_out_p
create_bd_port -dir O adrv2_tx2_strobe_out_n
create_bd_port -dir O adrv2_tx2_strobe_out_p

create_bd_port -dir O adrv1_rx1_enable
create_bd_port -dir O adrv1_rx2_enable
create_bd_port -dir O adrv1_tx1_enable
create_bd_port -dir O adrv1_tx2_enable
create_bd_port -dir O adrv2_rx1_enable
create_bd_port -dir O adrv2_rx2_enable
create_bd_port -dir O adrv2_tx1_enable
create_bd_port -dir O adrv2_tx2_enable

create_bd_port -dir I adrv1_gpio_rx1_enable_in
create_bd_port -dir I adrv1_gpio_rx2_enable_in
create_bd_port -dir I adrv1_gpio_tx1_enable_in
create_bd_port -dir I adrv1_gpio_tx2_enable_in
create_bd_port -dir I adrv2_gpio_rx1_enable_in
create_bd_port -dir I adrv2_gpio_rx2_enable_in
create_bd_port -dir I adrv2_gpio_tx1_enable_in
create_bd_port -dir I adrv2_gpio_tx2_enable_in

create_bd_port -dir I adrv1_ref_clk
create_bd_port -dir I tx_output_enable
create_bd_port -dir I mssi_sync
create_bd_port -dir I adrv1_fpga_mcs_in

set USE_RX_CLK_FOR_TX1 $ad_project_params(USE_RX_CLK_FOR_TX1)
set USE_RX_CLK_FOR_TX2 $ad_project_params(USE_RX_CLK_FOR_TX2)

###############################################################################
# adrv1

ad_ip_instance axi_adrv9001 axi_adrv9001_1
ad_ip_parameter axi_adrv9001_1 CONFIG.CMOS_LVDS_N $ad_project_params(CMOS_LVDS_N)
ad_ip_parameter axi_adrv9001_1 CONFIG.IODELAY_ENABLE 0
ad_ip_parameter axi_adrv9001_1 CONFIG.EXT_SYNC 1
ad_ip_parameter axi_adrv9001_1 CONFIG.USE_RX_CLK_FOR_TX1 $USE_RX_CLK_FOR_TX1
ad_ip_parameter axi_adrv9001_1 CONFIG.USE_RX_CLK_FOR_TX2 $USE_RX_CLK_FOR_TX2

# dma for rx1

ad_ip_instance axi_dmac axi_adrv9001_1_rx1_dma
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.CACHE_COHERENT 1
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.AXI_AXCACHE 0b1111
ad_ip_parameter axi_adrv9001_1_rx1_dma CONFIG.AXI_AXPROT 0b010

ad_ip_instance util_cpack2 adrv1_util_adc_1_pack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for rx2

ad_ip_instance axi_dmac axi_adrv9001_1_rx2_dma
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.CACHE_COHERENT 1
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.AXI_AXCACHE 0b1111
ad_ip_parameter axi_adrv9001_1_rx2_dma CONFIG.AXI_AXPROT 0b010

ad_ip_instance util_cpack2 adrv1_util_adc_2_pack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for tx1

ad_ip_instance axi_dmac axi_adrv9001_1_tx1_dma
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.CACHE_COHERENT 1
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.AXI_AXCACHE 0b1111
ad_ip_parameter axi_adrv9001_1_tx1_dma CONFIG.AXI_AXPROT 0b010

ad_ip_instance util_upack2 adrv1_util_dac_1_upack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for tx2

ad_ip_instance axi_dmac axi_adrv9001_1_tx2_dma
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.DMA_DATA_WIDTH_DEST 32
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.CACHE_COHERENT 1
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.AXI_AXCACHE 0b1111
ad_ip_parameter axi_adrv9001_1_tx2_dma CONFIG.AXI_AXPROT 0b010

ad_ip_instance util_upack2 adrv1_util_dac_2_upack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 16 \
}
# ad9001 connections

ad_connect  $sys_iodelay_clk         axi_adrv9001_1/delay_clk
ad_connect  axi_adrv9001_1/adc_1_clk axi_adrv9001_1_rx1_dma/fifo_wr_clk
ad_connect  axi_adrv9001_1/adc_1_clk adrv1_util_adc_1_pack/clk

ad_connect  axi_adrv9001_1/adc_2_clk axi_adrv9001_1_rx2_dma/fifo_wr_clk
ad_connect  axi_adrv9001_1/adc_2_clk adrv1_util_adc_2_pack/clk

ad_connect  axi_adrv9001_1/dac_1_clk axi_adrv9001_1_tx1_dma/m_axis_aclk
ad_connect  axi_adrv9001_1/dac_1_clk adrv1_util_dac_1_upack/clk

ad_connect  axi_adrv9001_1/dac_2_clk axi_adrv9001_1_tx2_dma/m_axis_aclk
ad_connect  axi_adrv9001_1/dac_2_clk adrv1_util_dac_2_upack/clk

ad_connect adrv1_ref_clk           axi_adrv9001_1/ref_clk

ad_connect tx_output_enable  axi_adrv9001_1/tx_output_enable

ad_connect mssi_sync         axi_adrv9001_1/mssi_sync_in

ad_connect adrv1_rx1_dclk_in_n     axi_adrv9001_1/rx1_dclk_in_n_NC
ad_connect adrv1_rx1_dclk_in_p     axi_adrv9001_1/rx1_dclk_in_p_dclk_in
ad_connect adrv1_rx1_idata_in_n    axi_adrv9001_1/rx1_idata_in_n_idata0
ad_connect adrv1_rx1_idata_in_p    axi_adrv9001_1/rx1_idata_in_p_idata1
ad_connect adrv1_rx1_qdata_in_n    axi_adrv9001_1/rx1_qdata_in_n_qdata2
ad_connect adrv1_rx1_qdata_in_p    axi_adrv9001_1/rx1_qdata_in_p_qdata3
ad_connect adrv1_rx1_strobe_in_n   axi_adrv9001_1/rx1_strobe_in_n_NC
ad_connect adrv1_rx1_strobe_in_p   axi_adrv9001_1/rx1_strobe_in_p_strobe_in

ad_connect adrv1_rx2_dclk_in_n     axi_adrv9001_1/rx2_dclk_in_n_NC
ad_connect adrv1_rx2_dclk_in_p     axi_adrv9001_1/rx2_dclk_in_p_dclk_in
ad_connect adrv1_rx2_idata_in_n    axi_adrv9001_1/rx2_idata_in_n_idata0
ad_connect adrv1_rx2_idata_in_p    axi_adrv9001_1/rx2_idata_in_p_idata1
ad_connect adrv1_rx2_qdata_in_n    axi_adrv9001_1/rx2_qdata_in_n_qdata2
ad_connect adrv1_rx2_qdata_in_p    axi_adrv9001_1/rx2_qdata_in_p_qdata3
ad_connect adrv1_rx2_strobe_in_n   axi_adrv9001_1/rx2_strobe_in_n_NC
ad_connect adrv1_rx2_strobe_in_p   axi_adrv9001_1/rx2_strobe_in_p_strobe_in

ad_connect adrv1_tx1_dclk_out_n    axi_adrv9001_1/tx1_dclk_out_n_NC
ad_connect adrv1_tx1_dclk_out_p    axi_adrv9001_1/tx1_dclk_out_p_dclk_out
ad_connect adrv1_tx1_dclk_in_n     axi_adrv9001_1/tx1_dclk_in_n_NC
ad_connect adrv1_tx1_dclk_in_p     axi_adrv9001_1/tx1_dclk_in_p_dclk_in
ad_connect adrv1_tx1_idata_out_n   axi_adrv9001_1/tx1_idata_out_n_idata0
ad_connect adrv1_tx1_idata_out_p   axi_adrv9001_1/tx1_idata_out_p_idata1
ad_connect adrv1_tx1_qdata_out_n   axi_adrv9001_1/tx1_qdata_out_n_qdata2
ad_connect adrv1_tx1_qdata_out_p   axi_adrv9001_1/tx1_qdata_out_p_qdata3
ad_connect adrv1_tx1_strobe_out_n  axi_adrv9001_1/tx1_strobe_out_n_NC
ad_connect adrv1_tx1_strobe_out_p  axi_adrv9001_1/tx1_strobe_out_p_strobe_out

ad_connect adrv1_tx2_dclk_out_n    axi_adrv9001_1/tx2_dclk_out_n_NC
ad_connect adrv1_tx2_dclk_out_p    axi_adrv9001_1/tx2_dclk_out_p_dclk_out
ad_connect adrv1_tx2_dclk_in_n     axi_adrv9001_1/tx2_dclk_in_n_NC
ad_connect adrv1_tx2_dclk_in_p     axi_adrv9001_1/tx2_dclk_in_p_dclk_in
ad_connect adrv1_tx2_idata_out_n   axi_adrv9001_1/tx2_idata_out_n_idata0
ad_connect adrv1_tx2_idata_out_p   axi_adrv9001_1/tx2_idata_out_p_idata1
ad_connect adrv1_tx2_qdata_out_n   axi_adrv9001_1/tx2_qdata_out_n_qdata2
ad_connect adrv1_tx2_qdata_out_p   axi_adrv9001_1/tx2_qdata_out_p_qdata3
ad_connect adrv1_tx2_strobe_out_n  axi_adrv9001_1/tx2_strobe_out_n_NC
ad_connect adrv1_tx2_strobe_out_p  axi_adrv9001_1/tx2_strobe_out_p_strobe_out

# RX1_RX2 - CPACK - RX_DMA1
ad_connect  axi_adrv9001_1/adc_1_rst       adrv1_util_adc_1_pack/reset
ad_connect  axi_adrv9001_1/adc_1_valid_i0  adrv1_util_adc_1_pack/fifo_wr_en
ad_connect  axi_adrv9001_1/adc_1_enable_i0 adrv1_util_adc_1_pack/enable_0
ad_connect  axi_adrv9001_1/adc_1_data_i0   adrv1_util_adc_1_pack/fifo_wr_data_0
ad_connect  axi_adrv9001_1/adc_1_enable_q0 adrv1_util_adc_1_pack/enable_1
ad_connect  axi_adrv9001_1/adc_1_data_q0   adrv1_util_adc_1_pack/fifo_wr_data_1
ad_connect  axi_adrv9001_1/adc_1_enable_i1 adrv1_util_adc_1_pack/enable_2
ad_connect  axi_adrv9001_1/adc_1_data_i1   adrv1_util_adc_1_pack/fifo_wr_data_2
ad_connect  axi_adrv9001_1/adc_1_enable_q1 adrv1_util_adc_1_pack/enable_3
ad_connect  axi_adrv9001_1/adc_1_data_q1   adrv1_util_adc_1_pack/fifo_wr_data_3

ad_connect  axi_adrv9001_1/adc_1_dovf      adrv1_util_adc_1_pack/fifo_wr_overflow

ad_connect adrv1_util_adc_1_pack/packed_fifo_wr axi_adrv9001_1_rx1_dma/fifo_wr
ad_connect adrv1_util_adc_1_pack/packed_sync axi_adrv9001_1_rx1_dma/sync

# RX2 - CPACK - RX_DMA2
ad_connect  axi_adrv9001_1/adc_2_rst       adrv1_util_adc_2_pack/reset
ad_connect  axi_adrv9001_1/adc_2_valid_i0  adrv1_util_adc_2_pack/fifo_wr_en
ad_connect  axi_adrv9001_1/adc_2_enable_i0 adrv1_util_adc_2_pack/enable_0
ad_connect  axi_adrv9001_1/adc_2_data_i0   adrv1_util_adc_2_pack/fifo_wr_data_0
ad_connect  axi_adrv9001_1/adc_2_enable_q0 adrv1_util_adc_2_pack/enable_1
ad_connect  axi_adrv9001_1/adc_2_data_q0   adrv1_util_adc_2_pack/fifo_wr_data_1

ad_connect  axi_adrv9001_1/adc_2_dovf       adrv1_util_adc_2_pack/fifo_wr_overflow

ad_connect adrv1_util_adc_2_pack/packed_fifo_wr axi_adrv9001_1_rx2_dma/fifo_wr
ad_connect adrv1_util_adc_2_pack/packed_sync axi_adrv9001_1_rx2_dma/sync

# TX_DMA1 - UPACK - TX1
ad_connect  axi_adrv9001_1/dac_1_rst        adrv1_util_dac_1_upack/reset
ad_connect  axi_adrv9001_1/dac_1_valid_i0   adrv1_util_dac_1_upack/fifo_rd_en
ad_connect  axi_adrv9001_1/dac_1_enable_i0  adrv1_util_dac_1_upack/enable_0
ad_connect  axi_adrv9001_1/dac_1_data_i0    adrv1_util_dac_1_upack/fifo_rd_data_0
ad_connect  axi_adrv9001_1/dac_1_enable_q0  adrv1_util_dac_1_upack/enable_1
ad_connect  axi_adrv9001_1/dac_1_data_q0    adrv1_util_dac_1_upack/fifo_rd_data_1
ad_connect  axi_adrv9001_1/dac_1_enable_i1  adrv1_util_dac_1_upack/enable_2
ad_connect  axi_adrv9001_1/dac_1_data_i1    adrv1_util_dac_1_upack/fifo_rd_data_2
ad_connect  axi_adrv9001_1/dac_1_enable_q1  adrv1_util_dac_1_upack/enable_3
ad_connect  axi_adrv9001_1/dac_1_data_q1    adrv1_util_dac_1_upack/fifo_rd_data_3

ad_connect  axi_adrv9001_1_tx1_dma/m_axis   adrv1_util_dac_1_upack/s_axis
ad_connect  axi_adrv9001_1/dac_1_dunf       adrv1_util_dac_1_upack/fifo_rd_underflow

# TX_DMA2 - UPACK - TX2
ad_connect  axi_adrv9001_1/dac_2_rst        adrv1_util_dac_2_upack/reset
ad_connect  axi_adrv9001_1/dac_2_valid_i0   adrv1_util_dac_2_upack/fifo_rd_en
ad_connect  axi_adrv9001_1/dac_2_enable_i0  adrv1_util_dac_2_upack/enable_0
ad_connect  axi_adrv9001_1/dac_2_data_i0    adrv1_util_dac_2_upack/fifo_rd_data_0
ad_connect  axi_adrv9001_1/dac_2_enable_q0  adrv1_util_dac_2_upack/enable_1
ad_connect  axi_adrv9001_1/dac_2_data_q0    adrv1_util_dac_2_upack/fifo_rd_data_1

ad_connect  axi_adrv9001_1_tx2_dma/m_axis   adrv1_util_dac_2_upack/s_axis
ad_connect  axi_adrv9001_1/dac_2_dunf       adrv1_util_dac_2_upack/fifo_rd_underflow

ad_connect  adrv1_gpio_rx1_enable_in        axi_adrv9001_1/gpio_rx1_enable_in
ad_connect  adrv1_gpio_rx2_enable_in        axi_adrv9001_1/gpio_rx2_enable_in
ad_connect  adrv1_gpio_tx1_enable_in        axi_adrv9001_1/gpio_tx1_enable_in
ad_connect  adrv1_gpio_tx2_enable_in        axi_adrv9001_1/gpio_tx2_enable_in

ad_connect  adrv1_rx1_enable                axi_adrv9001_1/rx1_enable
ad_connect  adrv1_rx2_enable                axi_adrv9001_1/rx2_enable
ad_connect  adrv1_tx1_enable                axi_adrv9001_1/tx1_enable
ad_connect  adrv1_tx2_enable                axi_adrv9001_1/tx2_enable

ad_connect  GND                             axi_adrv9001_1/tdd_sync

###############################################################################
# adrv2

ad_ip_instance axi_adrv9001 axi_adrv9001_2
ad_ip_parameter axi_adrv9001_2 CONFIG.CMOS_LVDS_N $ad_project_params(CMOS_LVDS_N)
ad_ip_parameter axi_adrv9001_2 CONFIG.IODELAY_ENABLE 0
ad_ip_parameter axi_adrv9001_2 CONFIG.EXT_SYNC 1
ad_ip_parameter axi_adrv9001_2 CONFIG.USE_RX_CLK_FOR_TX1 $USE_RX_CLK_FOR_TX1
ad_ip_parameter axi_adrv9001_2 CONFIG.USE_RX_CLK_FOR_TX2 $USE_RX_CLK_FOR_TX2

# dma for rx1

ad_ip_instance axi_dmac axi_adrv9001_2_rx1_dma
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.CACHE_COHERENT 1
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.AXI_AXCACHE 0b1111
ad_ip_parameter axi_adrv9001_2_rx1_dma CONFIG.AXI_AXPROT 0b010

ad_ip_instance util_cpack2 adrv2_util_adc_1_pack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for rx2

ad_ip_instance axi_dmac axi_adrv9001_2_rx2_dma
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.CACHE_COHERENT 1
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.AXI_AXCACHE 0b1111
ad_ip_parameter axi_adrv9001_2_rx2_dma CONFIG.AXI_AXPROT 0b010

ad_ip_instance util_cpack2 adrv2_util_adc_2_pack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for tx1

ad_ip_instance axi_dmac axi_adrv9001_2_tx1_dma
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.CACHE_COHERENT 1
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.AXI_AXCACHE 0b1111
ad_ip_parameter axi_adrv9001_2_tx1_dma CONFIG.AXI_AXPROT 0b010

ad_ip_instance util_upack2 adrv2_util_dac_1_upack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for tx2

ad_ip_instance axi_dmac axi_adrv9001_2_tx2_dma
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.DMA_DATA_WIDTH_DEST 32
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.CACHE_COHERENT 1
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.AXI_AXCACHE 0b1111
ad_ip_parameter axi_adrv9001_2_tx2_dma CONFIG.AXI_AXPROT 0b010

ad_ip_instance util_upack2 adrv2_util_dac_2_upack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 16 \
}
# ad9001 connections

ad_connect  $sys_iodelay_clk         axi_adrv9001_2/delay_clk
ad_connect  axi_adrv9001_2/adc_1_clk axi_adrv9001_2_rx1_dma/fifo_wr_clk
ad_connect  axi_adrv9001_2/adc_1_clk adrv2_util_adc_1_pack/clk

ad_connect  axi_adrv9001_2/adc_2_clk axi_adrv9001_2_rx2_dma/fifo_wr_clk
ad_connect  axi_adrv9001_2/adc_2_clk adrv2_util_adc_2_pack/clk

ad_connect  axi_adrv9001_2/dac_1_clk axi_adrv9001_2_tx1_dma/m_axis_aclk
ad_connect  axi_adrv9001_2/dac_1_clk adrv2_util_dac_1_upack/clk

ad_connect  axi_adrv9001_2/dac_2_clk axi_adrv9001_2_tx2_dma/m_axis_aclk
ad_connect  axi_adrv9001_2/dac_2_clk adrv2_util_dac_2_upack/clk

ad_connect adrv1_ref_clk           axi_adrv9001_2/ref_clk

ad_connect tx_output_enable  axi_adrv9001_2/tx_output_enable

ad_connect mssi_sync         axi_adrv9001_2/mssi_sync_in

ad_connect adrv2_rx1_dclk_in_n     axi_adrv9001_2/rx1_dclk_in_n_NC
ad_connect adrv2_rx1_dclk_in_p     axi_adrv9001_2/rx1_dclk_in_p_dclk_in
ad_connect adrv2_rx1_idata_in_n    axi_adrv9001_2/rx1_idata_in_n_idata0
ad_connect adrv2_rx1_idata_in_p    axi_adrv9001_2/rx1_idata_in_p_idata1
ad_connect adrv2_rx1_qdata_in_n    axi_adrv9001_2/rx1_qdata_in_n_qdata2
ad_connect adrv2_rx1_qdata_in_p    axi_adrv9001_2/rx1_qdata_in_p_qdata3
ad_connect adrv2_rx1_strobe_in_n   axi_adrv9001_2/rx1_strobe_in_n_NC
ad_connect adrv2_rx1_strobe_in_p   axi_adrv9001_2/rx1_strobe_in_p_strobe_in

ad_connect adrv2_rx2_dclk_in_n     axi_adrv9001_2/rx2_dclk_in_n_NC
ad_connect adrv2_rx2_dclk_in_p     axi_adrv9001_2/rx2_dclk_in_p_dclk_in
ad_connect adrv2_rx2_idata_in_n    axi_adrv9001_2/rx2_idata_in_n_idata0
ad_connect adrv2_rx2_idata_in_p    axi_adrv9001_2/rx2_idata_in_p_idata1
ad_connect adrv2_rx2_qdata_in_n    axi_adrv9001_2/rx2_qdata_in_n_qdata2
ad_connect adrv2_rx2_qdata_in_p    axi_adrv9001_2/rx2_qdata_in_p_qdata3
ad_connect adrv2_rx2_strobe_in_n   axi_adrv9001_2/rx2_strobe_in_n_NC
ad_connect adrv2_rx2_strobe_in_p   axi_adrv9001_2/rx2_strobe_in_p_strobe_in

ad_connect adrv2_tx1_dclk_out_n    axi_adrv9001_2/tx1_dclk_out_n_NC
ad_connect adrv2_tx1_dclk_out_p    axi_adrv9001_2/tx1_dclk_out_p_dclk_out
ad_connect adrv2_tx1_dclk_in_n     axi_adrv9001_2/tx1_dclk_in_n_NC
ad_connect adrv2_tx1_dclk_in_p     axi_adrv9001_2/tx1_dclk_in_p_dclk_in
ad_connect adrv2_tx1_idata_out_n   axi_adrv9001_2/tx1_idata_out_n_idata0
ad_connect adrv2_tx1_idata_out_p   axi_adrv9001_2/tx1_idata_out_p_idata1
ad_connect adrv2_tx1_qdata_out_n   axi_adrv9001_2/tx1_qdata_out_n_qdata2
ad_connect adrv2_tx1_qdata_out_p   axi_adrv9001_2/tx1_qdata_out_p_qdata3
ad_connect adrv2_tx1_strobe_out_n  axi_adrv9001_2/tx1_strobe_out_n_NC
ad_connect adrv2_tx1_strobe_out_p  axi_adrv9001_2/tx1_strobe_out_p_strobe_out

ad_connect adrv2_tx2_dclk_out_n    axi_adrv9001_2/tx2_dclk_out_n_NC
ad_connect adrv2_tx2_dclk_out_p    axi_adrv9001_2/tx2_dclk_out_p_dclk_out
ad_connect adrv2_tx2_dclk_in_n     axi_adrv9001_2/tx2_dclk_in_n_NC
ad_connect adrv2_tx2_dclk_in_p     axi_adrv9001_2/tx2_dclk_in_p_dclk_in
ad_connect adrv2_tx2_idata_out_n   axi_adrv9001_2/tx2_idata_out_n_idata0
ad_connect adrv2_tx2_idata_out_p   axi_adrv9001_2/tx2_idata_out_p_idata1
ad_connect adrv2_tx2_qdata_out_n   axi_adrv9001_2/tx2_qdata_out_n_qdata2
ad_connect adrv2_tx2_qdata_out_p   axi_adrv9001_2/tx2_qdata_out_p_qdata3
ad_connect adrv2_tx2_strobe_out_n  axi_adrv9001_2/tx2_strobe_out_n_NC
ad_connect adrv2_tx2_strobe_out_p  axi_adrv9001_2/tx2_strobe_out_p_strobe_out

# RX1_RX2 - CPACK - RX_DMA1
ad_connect  axi_adrv9001_2/adc_1_rst       adrv2_util_adc_1_pack/reset
ad_connect  axi_adrv9001_2/adc_1_valid_i0  adrv2_util_adc_1_pack/fifo_wr_en
ad_connect  axi_adrv9001_2/adc_1_enable_i0 adrv2_util_adc_1_pack/enable_0
ad_connect  axi_adrv9001_2/adc_1_data_i0   adrv2_util_adc_1_pack/fifo_wr_data_0
ad_connect  axi_adrv9001_2/adc_1_enable_q0 adrv2_util_adc_1_pack/enable_1
ad_connect  axi_adrv9001_2/adc_1_data_q0   adrv2_util_adc_1_pack/fifo_wr_data_1
ad_connect  axi_adrv9001_2/adc_1_enable_i1 adrv2_util_adc_1_pack/enable_2
ad_connect  axi_adrv9001_2/adc_1_data_i1   adrv2_util_adc_1_pack/fifo_wr_data_2
ad_connect  axi_adrv9001_2/adc_1_enable_q1 adrv2_util_adc_1_pack/enable_3
ad_connect  axi_adrv9001_2/adc_1_data_q1   adrv2_util_adc_1_pack/fifo_wr_data_3

ad_connect  axi_adrv9001_2/adc_1_dovf      adrv2_util_adc_1_pack/fifo_wr_overflow

ad_connect adrv2_util_adc_1_pack/packed_fifo_wr axi_adrv9001_2_rx1_dma/fifo_wr
ad_connect adrv2_util_adc_1_pack/packed_sync axi_adrv9001_2_rx1_dma/sync

# RX2 - CPACK - RX_DMA2
ad_connect  axi_adrv9001_2/adc_2_rst       adrv2_util_adc_2_pack/reset
ad_connect  axi_adrv9001_2/adc_2_valid_i0  adrv2_util_adc_2_pack/fifo_wr_en
ad_connect  axi_adrv9001_2/adc_2_enable_i0 adrv2_util_adc_2_pack/enable_0
ad_connect  axi_adrv9001_2/adc_2_data_i0   adrv2_util_adc_2_pack/fifo_wr_data_0
ad_connect  axi_adrv9001_2/adc_2_enable_q0 adrv2_util_adc_2_pack/enable_1
ad_connect  axi_adrv9001_2/adc_2_data_q0   adrv2_util_adc_2_pack/fifo_wr_data_1

ad_connect  axi_adrv9001_2/adc_2_dovf       adrv2_util_adc_2_pack/fifo_wr_overflow

ad_connect adrv2_util_adc_2_pack/packed_fifo_wr axi_adrv9001_2_rx2_dma/fifo_wr
ad_connect adrv2_util_adc_2_pack/packed_sync axi_adrv9001_2_rx2_dma/sync

# TX_DMA1 - UPACK - TX1
ad_connect  axi_adrv9001_2/dac_1_rst        adrv2_util_dac_1_upack/reset
ad_connect  axi_adrv9001_2/dac_1_valid_i0   adrv2_util_dac_1_upack/fifo_rd_en
ad_connect  axi_adrv9001_2/dac_1_enable_i0  adrv2_util_dac_1_upack/enable_0
ad_connect  axi_adrv9001_2/dac_1_data_i0    adrv2_util_dac_1_upack/fifo_rd_data_0
ad_connect  axi_adrv9001_2/dac_1_enable_q0  adrv2_util_dac_1_upack/enable_1
ad_connect  axi_adrv9001_2/dac_1_data_q0    adrv2_util_dac_1_upack/fifo_rd_data_1
ad_connect  axi_adrv9001_2/dac_1_enable_i1  adrv2_util_dac_1_upack/enable_2
ad_connect  axi_adrv9001_2/dac_1_data_i1    adrv2_util_dac_1_upack/fifo_rd_data_2
ad_connect  axi_adrv9001_2/dac_1_enable_q1  adrv2_util_dac_1_upack/enable_3
ad_connect  axi_adrv9001_2/dac_1_data_q1    adrv2_util_dac_1_upack/fifo_rd_data_3

ad_connect  axi_adrv9001_2_tx1_dma/m_axis   adrv2_util_dac_1_upack/s_axis
ad_connect  axi_adrv9001_2/dac_1_dunf       adrv2_util_dac_1_upack/fifo_rd_underflow

# TX_DMA2 - UPACK - TX2
ad_connect  axi_adrv9001_2/dac_2_rst        adrv2_util_dac_2_upack/reset
ad_connect  axi_adrv9001_2/dac_2_valid_i0   adrv2_util_dac_2_upack/fifo_rd_en
ad_connect  axi_adrv9001_2/dac_2_enable_i0  adrv2_util_dac_2_upack/enable_0
ad_connect  axi_adrv9001_2/dac_2_data_i0    adrv2_util_dac_2_upack/fifo_rd_data_0
ad_connect  axi_adrv9001_2/dac_2_enable_q0  adrv2_util_dac_2_upack/enable_1
ad_connect  axi_adrv9001_2/dac_2_data_q0    adrv2_util_dac_2_upack/fifo_rd_data_1

ad_connect  axi_adrv9001_2_tx2_dma/m_axis   adrv2_util_dac_2_upack/s_axis
ad_connect  axi_adrv9001_2/dac_2_dunf       adrv2_util_dac_2_upack/fifo_rd_underflow

ad_connect  adrv2_gpio_rx1_enable_in        axi_adrv9001_2/gpio_rx1_enable_in
ad_connect  adrv2_gpio_rx2_enable_in        axi_adrv9001_2/gpio_rx2_enable_in
ad_connect  adrv2_gpio_tx1_enable_in        axi_adrv9001_2/gpio_tx1_enable_in
ad_connect  adrv2_gpio_tx2_enable_in        axi_adrv9001_2/gpio_tx2_enable_in

ad_connect  adrv2_rx1_enable                axi_adrv9001_2/rx1_enable
ad_connect  adrv2_rx2_enable                axi_adrv9001_2/rx2_enable
ad_connect  adrv2_tx1_enable                axi_adrv9001_2/tx1_enable
ad_connect  adrv2_tx2_enable                axi_adrv9001_2/tx2_enable

ad_connect  GND                             axi_adrv9001_2/tdd_sync

ad_cpu_interconnect 0x44A00000  axi_adrv9001_1
ad_cpu_interconnect 0x44A30000  axi_adrv9001_1_rx1_dma
ad_cpu_interconnect 0x44A40000  axi_adrv9001_1_rx2_dma
ad_cpu_interconnect 0x44A50000  axi_adrv9001_1_tx1_dma
ad_cpu_interconnect 0x44A60000  axi_adrv9001_1_tx2_dma
ad_cpu_interconnect 0x44A70000  axi_adrv9001_2
ad_cpu_interconnect 0x44A80000  axi_adrv9001_2_rx1_dma
ad_cpu_interconnect 0x44A90000  axi_adrv9001_2_rx2_dma
ad_cpu_interconnect 0x44AA0000  axi_adrv9001_2_tx1_dma
ad_cpu_interconnect 0x44AB0000  axi_adrv9001_2_tx2_dma

ad_mem_hp0_interconnect $sys_dma_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect $sys_dma_clk axi_adrv9001_1_rx1_dma/m_dest_axi
ad_mem_hp0_interconnect $sys_dma_clk axi_adrv9001_1_rx2_dma/m_dest_axi
ad_mem_hp0_interconnect $sys_dma_clk axi_adrv9001_1_tx1_dma/m_src_axi
ad_mem_hp0_interconnect $sys_dma_clk axi_adrv9001_1_tx2_dma/m_src_axi

ad_mem_hp1_interconnect $sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9001_2_rx1_dma/m_dest_axi
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9001_2_rx2_dma/m_dest_axi
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9001_2_tx1_dma/m_src_axi
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9001_2_tx2_dma/m_src_axi

ad_connect $sys_dma_resetn axi_adrv9001_1_rx1_dma/m_dest_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_1_rx2_dma/m_dest_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_1_tx1_dma/m_src_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_1_tx2_dma/m_src_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_2_rx1_dma/m_dest_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_2_rx2_dma/m_dest_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_2_tx1_dma/m_src_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_2_tx2_dma/m_src_axi_aresetn

# interrupts
ad_cpu_interrupt ps-15 mb-xx axi_adrv9001_1_rx1_dma/irq
ad_cpu_interrupt ps-14 mb-xx axi_adrv9001_1_rx2_dma/irq
ad_cpu_interrupt ps-13 mb-xx axi_adrv9001_1_tx1_dma/irq
ad_cpu_interrupt ps-12 mb-xx axi_adrv9001_1_tx2_dma/irq
ad_cpu_interrupt ps-11 mb-xx axi_adrv9001_2_rx1_dma/irq
ad_cpu_interrupt ps-10 mb-xx axi_adrv9001_2_rx2_dma/irq
ad_cpu_interrupt ps-9  mb-xx axi_adrv9001_2_tx1_dma/irq
ad_cpu_interrupt ps-8  mb-xx axi_adrv9001_2_tx2_dma/irq


