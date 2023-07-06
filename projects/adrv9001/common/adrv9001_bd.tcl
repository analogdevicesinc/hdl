###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# create debug ports
create_bd_port -dir O adc1_div_clk
create_bd_port -dir O adc2_div_clk
create_bd_port -dir O dac1_div_clk
create_bd_port -dir O dac2_div_clk

create_bd_port -dir I ref_clk

create_bd_port -dir I tx_output_enable

create_bd_port -dir I mssi_sync

# adrv9001 interface
create_bd_port -dir I rx1_dclk_in_n
create_bd_port -dir I rx1_dclk_in_p
create_bd_port -dir I rx1_idata_in_n
create_bd_port -dir I rx1_idata_in_p
create_bd_port -dir I rx1_qdata_in_n
create_bd_port -dir I rx1_qdata_in_p
create_bd_port -dir I rx1_strobe_in_n
create_bd_port -dir I rx1_strobe_in_p

create_bd_port -dir I rx2_dclk_in_n
create_bd_port -dir I rx2_dclk_in_p
create_bd_port -dir I rx2_idata_in_n
create_bd_port -dir I rx2_idata_in_p
create_bd_port -dir I rx2_qdata_in_n
create_bd_port -dir I rx2_qdata_in_p
create_bd_port -dir I rx2_strobe_in_n
create_bd_port -dir I rx2_strobe_in_p

create_bd_port -dir O tx1_dclk_out_n
create_bd_port -dir O tx1_dclk_out_p
create_bd_port -dir I tx1_dclk_in_n
create_bd_port -dir I tx1_dclk_in_p
create_bd_port -dir O tx1_idata_out_n
create_bd_port -dir O tx1_idata_out_p
create_bd_port -dir O tx1_qdata_out_n
create_bd_port -dir O tx1_qdata_out_p
create_bd_port -dir O tx1_strobe_out_n
create_bd_port -dir O tx1_strobe_out_p

create_bd_port -dir O tx2_dclk_out_n
create_bd_port -dir O tx2_dclk_out_p
create_bd_port -dir I tx2_dclk_in_n
create_bd_port -dir I tx2_dclk_in_p
create_bd_port -dir O tx2_idata_out_n
create_bd_port -dir O tx2_idata_out_p
create_bd_port -dir O tx2_qdata_out_n
create_bd_port -dir O tx2_qdata_out_p
create_bd_port -dir O tx2_strobe_out_n
create_bd_port -dir O tx2_strobe_out_p

create_bd_port -dir O rx1_enable
create_bd_port -dir O rx2_enable
create_bd_port -dir O tx1_enable
create_bd_port -dir O tx2_enable

create_bd_port -dir I gpio_rx1_enable_in
create_bd_port -dir I gpio_rx2_enable_in
create_bd_port -dir I gpio_tx1_enable_in
create_bd_port -dir I gpio_tx2_enable_in

create_bd_port -dir I tdd_sync
create_bd_port -dir O tdd_sync_cntr

# adrv9001

ad_ip_instance axi_adrv9001 axi_adrv9001
ad_ip_parameter axi_adrv9001 CONFIG.CMOS_LVDS_N  $ad_project_params(CMOS_LVDS_N)

# dma for rx1

ad_ip_instance axi_dmac axi_adrv9001_rx1_dma
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.DMA_DATA_WIDTH_SRC 64

ad_ip_instance util_cpack2 util_adc_1_pack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for rx2

ad_ip_instance axi_dmac axi_adrv9001_rx2_dma
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.DMA_DATA_WIDTH_SRC 32

ad_ip_instance util_cpack2 util_adc_2_pack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for tx1

ad_ip_instance axi_dmac axi_adrv9001_tx1_dma
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance util_upack2 util_dac_1_upack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for tx1

ad_ip_instance axi_dmac axi_adrv9001_tx2_dma
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.DMA_DATA_WIDTH_DEST 32

ad_ip_instance util_upack2 util_dac_2_upack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 16 \
}

# ad9001 connections

ad_connect  $sys_iodelay_clk       axi_adrv9001/delay_clk
ad_connect  axi_adrv9001/adc_1_clk axi_adrv9001_rx1_dma/fifo_wr_clk
ad_connect  axi_adrv9001/adc_1_clk util_adc_1_pack/clk

ad_connect  axi_adrv9001/adc_2_clk axi_adrv9001_rx2_dma/fifo_wr_clk
ad_connect  axi_adrv9001/adc_2_clk util_adc_2_pack/clk

ad_connect  axi_adrv9001/dac_1_clk axi_adrv9001_tx1_dma/m_axis_aclk
ad_connect  axi_adrv9001/dac_1_clk util_dac_1_upack/clk

ad_connect  axi_adrv9001/dac_2_clk axi_adrv9001_tx2_dma/m_axis_aclk
ad_connect  axi_adrv9001/dac_2_clk util_dac_2_upack/clk

ad_connect ref_clk           axi_adrv9001/ref_clk

ad_connect tx_output_enable  axi_adrv9001/tx_output_enable

ad_connect mssi_sync         axi_adrv9001/mssi_sync

ad_connect rx1_dclk_in_n     axi_adrv9001/rx1_dclk_in_n_NC
ad_connect rx1_dclk_in_p     axi_adrv9001/rx1_dclk_in_p_dclk_in
ad_connect rx1_idata_in_n    axi_adrv9001/rx1_idata_in_n_idata0
ad_connect rx1_idata_in_p    axi_adrv9001/rx1_idata_in_p_idata1
ad_connect rx1_qdata_in_n    axi_adrv9001/rx1_qdata_in_n_qdata2
ad_connect rx1_qdata_in_p    axi_adrv9001/rx1_qdata_in_p_qdata3
ad_connect rx1_strobe_in_n   axi_adrv9001/rx1_strobe_in_n_NC
ad_connect rx1_strobe_in_p   axi_adrv9001/rx1_strobe_in_p_strobe_in

ad_connect rx2_dclk_in_n     axi_adrv9001/rx2_dclk_in_n_NC
ad_connect rx2_dclk_in_p     axi_adrv9001/rx2_dclk_in_p_dclk_in
ad_connect rx2_idata_in_n    axi_adrv9001/rx2_idata_in_n_idata0
ad_connect rx2_idata_in_p    axi_adrv9001/rx2_idata_in_p_idata1
ad_connect rx2_qdata_in_n    axi_adrv9001/rx2_qdata_in_n_qdata2
ad_connect rx2_qdata_in_p    axi_adrv9001/rx2_qdata_in_p_qdata3
ad_connect rx2_strobe_in_n   axi_adrv9001/rx2_strobe_in_n_NC
ad_connect rx2_strobe_in_p   axi_adrv9001/rx2_strobe_in_p_strobe_in

ad_connect tx1_dclk_out_n    axi_adrv9001/tx1_dclk_out_n_NC
ad_connect tx1_dclk_out_p    axi_adrv9001/tx1_dclk_out_p_dclk_out
ad_connect tx1_dclk_in_n     axi_adrv9001/tx1_dclk_in_n_NC
ad_connect tx1_dclk_in_p     axi_adrv9001/tx1_dclk_in_p_dclk_in
ad_connect tx1_idata_out_n   axi_adrv9001/tx1_idata_out_n_idata0
ad_connect tx1_idata_out_p   axi_adrv9001/tx1_idata_out_p_idata1
ad_connect tx1_qdata_out_n   axi_adrv9001/tx1_qdata_out_n_qdata2
ad_connect tx1_qdata_out_p   axi_adrv9001/tx1_qdata_out_p_qdata3
ad_connect tx1_strobe_out_n  axi_adrv9001/tx1_strobe_out_n_NC
ad_connect tx1_strobe_out_p  axi_adrv9001/tx1_strobe_out_p_strobe_out

ad_connect tx2_dclk_out_n    axi_adrv9001/tx2_dclk_out_n_NC
ad_connect tx2_dclk_out_p    axi_adrv9001/tx2_dclk_out_p_dclk_out
ad_connect tx2_dclk_in_n     axi_adrv9001/tx2_dclk_in_n_NC
ad_connect tx2_dclk_in_p     axi_adrv9001/tx2_dclk_in_p_dclk_in
ad_connect tx2_idata_out_n   axi_adrv9001/tx2_idata_out_n_idata0
ad_connect tx2_idata_out_p   axi_adrv9001/tx2_idata_out_p_idata1
ad_connect tx2_qdata_out_n   axi_adrv9001/tx2_qdata_out_n_qdata2
ad_connect tx2_qdata_out_p   axi_adrv9001/tx2_qdata_out_p_qdata3
ad_connect tx2_strobe_out_n  axi_adrv9001/tx2_strobe_out_n_NC
ad_connect tx2_strobe_out_p  axi_adrv9001/tx2_strobe_out_p_strobe_out

ad_connect rx1_enable        axi_adrv9001/rx1_enable
ad_connect rx2_enable        axi_adrv9001/rx2_enable
ad_connect tx1_enable        axi_adrv9001/tx1_enable
ad_connect tx2_enable        axi_adrv9001/tx2_enable

ad_connect gpio_rx1_enable_in  axi_adrv9001/gpio_rx1_enable_in
ad_connect gpio_rx2_enable_in  axi_adrv9001/gpio_rx2_enable_in
ad_connect gpio_tx1_enable_in  axi_adrv9001/gpio_tx1_enable_in
ad_connect gpio_tx2_enable_in  axi_adrv9001/gpio_tx2_enable_in

ad_connect tdd_sync axi_adrv9001/tdd_sync
ad_connect tdd_sync_cntr axi_adrv9001/tdd_sync_cntr

# RX1_RX2 - CPACK - RX_DMA1
ad_connect  axi_adrv9001/adc_1_rst       util_adc_1_pack/reset
ad_connect  axi_adrv9001/adc_1_valid_i0  util_adc_1_pack/fifo_wr_en
ad_connect  axi_adrv9001/adc_1_enable_i0 util_adc_1_pack/enable_0
ad_connect  axi_adrv9001/adc_1_data_i0   util_adc_1_pack/fifo_wr_data_0
ad_connect  axi_adrv9001/adc_1_enable_q0 util_adc_1_pack/enable_1
ad_connect  axi_adrv9001/adc_1_data_q0   util_adc_1_pack/fifo_wr_data_1
ad_connect  axi_adrv9001/adc_1_enable_i1 util_adc_1_pack/enable_2
ad_connect  axi_adrv9001/adc_1_data_i1   util_adc_1_pack/fifo_wr_data_2
ad_connect  axi_adrv9001/adc_1_enable_q1 util_adc_1_pack/enable_3
ad_connect  axi_adrv9001/adc_1_data_q1   util_adc_1_pack/fifo_wr_data_3

ad_connect  axi_adrv9001/adc_1_dovf      util_adc_1_pack/fifo_wr_overflow

ad_connect util_adc_1_pack/packed_fifo_wr axi_adrv9001_rx1_dma/fifo_wr

# RX2 - CPACK - RX_DMA2
ad_connect  axi_adrv9001/adc_2_rst       util_adc_2_pack/reset
ad_connect  axi_adrv9001/adc_2_valid_i0  util_adc_2_pack/fifo_wr_en
ad_connect  axi_adrv9001/adc_2_enable_i0 util_adc_2_pack/enable_0
ad_connect  axi_adrv9001/adc_2_data_i0   util_adc_2_pack/fifo_wr_data_0
ad_connect  axi_adrv9001/adc_2_enable_q0 util_adc_2_pack/enable_1
ad_connect  axi_adrv9001/adc_2_data_q0   util_adc_2_pack/fifo_wr_data_1

ad_connect  axi_adrv9001/adc_2_dovf       util_adc_2_pack/fifo_wr_overflow

ad_connect util_adc_2_pack/packed_fifo_wr axi_adrv9001_rx2_dma/fifo_wr

# TX_DMA1 - UPACK - TX1
ad_connect  axi_adrv9001/dac_1_rst        util_dac_1_upack/reset
ad_connect  axi_adrv9001/dac_1_valid_i0   util_dac_1_upack/fifo_rd_en
ad_connect  axi_adrv9001/dac_1_enable_i0  util_dac_1_upack/enable_0
ad_connect  axi_adrv9001/dac_1_data_i0    util_dac_1_upack/fifo_rd_data_0
ad_connect  axi_adrv9001/dac_1_enable_q0  util_dac_1_upack/enable_1
ad_connect  axi_adrv9001/dac_1_data_q0    util_dac_1_upack/fifo_rd_data_1
ad_connect  axi_adrv9001/dac_1_enable_i1  util_dac_1_upack/enable_2
ad_connect  axi_adrv9001/dac_1_data_i1    util_dac_1_upack/fifo_rd_data_2
ad_connect  axi_adrv9001/dac_1_enable_q1  util_dac_1_upack/enable_3
ad_connect  axi_adrv9001/dac_1_data_q1    util_dac_1_upack/fifo_rd_data_3

ad_connect  axi_adrv9001_tx1_dma/m_axis   util_dac_1_upack/s_axis
ad_connect  axi_adrv9001/dac_1_dunf       util_dac_1_upack/fifo_rd_underflow

# TX_DMA2 - UPACK - TX2
ad_connect  axi_adrv9001/dac_2_rst        util_dac_2_upack/reset
ad_connect  axi_adrv9001/dac_2_valid_i0   util_dac_2_upack/fifo_rd_en
ad_connect  axi_adrv9001/dac_2_enable_i0  util_dac_2_upack/enable_0
ad_connect  axi_adrv9001/dac_2_data_i0    util_dac_2_upack/fifo_rd_data_0
ad_connect  axi_adrv9001/dac_2_enable_q0  util_dac_2_upack/enable_1
ad_connect  axi_adrv9001/dac_2_data_q0    util_dac_2_upack/fifo_rd_data_1

ad_connect  axi_adrv9001_tx2_dma/m_axis   util_dac_2_upack/s_axis
ad_connect  axi_adrv9001/dac_2_dunf       util_dac_2_upack/fifo_rd_underflow

# interconnect

ad_cpu_interconnect 0x44A00000  axi_adrv9001
ad_cpu_interconnect 0x44A30000  axi_adrv9001_rx1_dma
ad_cpu_interconnect 0x44A40000  axi_adrv9001_rx2_dma
ad_cpu_interconnect 0x44A50000  axi_adrv9001_tx1_dma
ad_cpu_interconnect 0x44A60000  axi_adrv9001_tx2_dma

# memory inteconnect

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_adrv9001_rx1_dma/m_dest_axi
ad_mem_hp1_interconnect $sys_cpu_clk axi_adrv9001_rx2_dma/m_dest_axi
ad_mem_hp1_interconnect $sys_cpu_clk axi_adrv9001_tx1_dma/m_src_axi
ad_mem_hp1_interconnect $sys_cpu_clk axi_adrv9001_tx2_dma/m_src_axi

ad_connect $sys_cpu_resetn axi_adrv9001_rx1_dma/m_dest_axi_aresetn
ad_connect $sys_cpu_resetn axi_adrv9001_rx2_dma/m_dest_axi_aresetn
ad_connect $sys_cpu_resetn axi_adrv9001_tx1_dma/m_src_axi_aresetn
ad_connect $sys_cpu_resetn axi_adrv9001_tx2_dma/m_src_axi_aresetn
# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_adrv9001_rx1_dma/irq
ad_cpu_interrupt ps-12 mb-11 axi_adrv9001_rx2_dma/irq
ad_cpu_interrupt ps-9  mb-6 axi_adrv9001_tx1_dma/irq
ad_cpu_interrupt ps-10 mb-5 axi_adrv9001_tx2_dma/irq


# Connect debug ports
ad_connect  axi_adrv9001/adc_1_clk adc1_div_clk
ad_connect  axi_adrv9001/adc_2_clk adc2_div_clk
ad_connect  axi_adrv9001/dac_1_clk dac1_div_clk
ad_connect  axi_adrv9001/dac_2_clk dac2_div_clk

