
# spi2

ad_ip_instance axi_quad_spi axi_fmcomms7_spi
ad_ip_parameter axi_fmcomms7_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_fmcomms7_spi CONFIG.C_NUM_SS_BITS 12
ad_ip_parameter axi_fmcomms7_spi CONFIG.C_SCK_RATIO 8

# connections (spi2)

create_bd_port -dir O -from 11 -to 0 spi2_csn_o
create_bd_port -dir I -from 11 -to 0 spi2_csn_i
create_bd_port -dir I spi2_clk_i
create_bd_port -dir O spi2_clk_o
create_bd_port -dir I spi2_sdo_i
create_bd_port -dir O spi2_sdo_o
create_bd_port -dir I spi2_sdi_i

ad_connect  spi2_csn_i axi_fmcomms7_spi/ss_i
ad_connect  spi2_csn_o axi_fmcomms7_spi/ss_o
ad_connect  spi2_clk_i axi_fmcomms7_spi/sck_i
ad_connect  spi2_clk_o axi_fmcomms7_spi/sck_o
ad_connect  spi2_sdo_i axi_fmcomms7_spi/io0_i
ad_connect  spi2_sdo_o axi_fmcomms7_spi/io0_o
ad_connect  spi2_sdi_i axi_fmcomms7_spi/io1_i
ad_connect  sys_cpu_clk axi_fmcomms7_spi/ext_spi_clk

# dac peripherals

ad_ip_instance axi_adxcvr axi_ad9144_xcvr
ad_ip_parameter axi_ad9144_xcvr CONFIG.NUM_OF_LANES 8
ad_ip_parameter axi_ad9144_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9144_xcvr CONFIG.TX_OR_RX_N 1

ad_ip_instance jesd204 axi_ad9144_jesd
ad_ip_parameter axi_ad9144_jesd CONFIG.C_NODE_IS_TRANSMIT 1
ad_ip_parameter axi_ad9144_jesd CONFIG.C_LANES 8

ad_ip_instance axi_ad9144 axi_ad9144_core
ad_ip_parameter axi_ad9144_core CONFIG.QUAD_OR_DUAL_N 1

ad_ip_instance axi_dmac axi_ad9144_dma
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9144_dma CONFIG.ID 1
ad_ip_parameter axi_ad9144_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9144_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9144_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_DATA_WIDTH_DEST 256

ad_ip_instance util_upack axi_ad9144_upack
ad_ip_parameter axi_ad9144_upack CONFIG.CHANNEL_DATA_WIDTH 64
ad_ip_parameter axi_ad9144_upack CONFIG.NUM_OF_CHANNELS 4

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9680_xcvr
ad_ip_parameter axi_ad9680_xcvr CONFIG.NUM_OF_LANES 4
ad_ip_parameter axi_ad9680_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9680_xcvr CONFIG.TX_OR_RX_N 0

ad_ip_instance jesd204 axi_ad9680_jesd
ad_ip_parameter axi_ad9680_jesd CONFIG.C_NODE_IS_TRANSMIT 0
ad_ip_parameter axi_ad9680_jesd CONFIG.C_LANES 4

ad_ip_instance axi_ad9680 axi_ad9680_core

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

ad_ip_instance util_cpack axi_ad9680_cpack
ad_ip_parameter axi_ad9680_cpack CONFIG.CHANNEL_DATA_WIDTH 64
ad_ip_parameter axi_ad9680_cpack CONFIG.NUM_OF_CHANNELS 2

# dac/adc common gt

ad_ip_instance util_adxcvr util_fmcomms7_xcvr
ad_ip_parameter util_fmcomms7_xcvr CONFIG.RX_NUM_OF_LANES 4
ad_ip_parameter util_fmcomms7_xcvr CONFIG.TX_NUM_OF_LANES 8

# reference clocks & resets

create_bd_port -dir I tx_ref_clk_0
create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  tx_ref_clk_0 util_fmcomms7_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcomms7_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9144_xcvr/up_pll_rst util_fmcomms7_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9680_xcvr/up_pll_rst util_fmcomms7_xcvr/up_cpll_rst_*
ad_connect  sys_cpu_resetn util_fmcomms7_xcvr/up_rstn
ad_connect  sys_cpu_clk util_fmcomms7_xcvr/up_clk

# connections (dac)

ad_xcvrcon  util_fmcomms7_xcvr axi_ad9144_xcvr axi_ad9144_jesd
ad_reconct  util_fmcomms7_xcvr/tx_0 axi_ad9144_jesd/gt5_tx
ad_reconct  util_fmcomms7_xcvr/tx_1 axi_ad9144_jesd/gt3_tx
ad_reconct  util_fmcomms7_xcvr/tx_2 axi_ad9144_jesd/gt6_tx
ad_reconct  util_fmcomms7_xcvr/tx_3 axi_ad9144_jesd/gt7_tx
ad_reconct  util_fmcomms7_xcvr/tx_4 axi_ad9144_jesd/gt2_tx
ad_reconct  util_fmcomms7_xcvr/tx_5 axi_ad9144_jesd/gt0_tx
ad_reconct  util_fmcomms7_xcvr/tx_6 axi_ad9144_jesd/gt1_tx
ad_reconct  util_fmcomms7_xcvr/tx_7 axi_ad9144_jesd/gt4_tx

ad_connect  util_fmcomms7_xcvr/tx_out_clk_0 axi_ad9144_core/tx_clk
ad_connect  axi_ad9144_jesd/tx_tdata axi_ad9144_core/tx_data

ad_connect  util_fmcomms7_xcvr/tx_out_clk_0 axi_ad9144_upack/dac_clk
ad_connect  axi_ad9144_core/dac_enable_0 axi_ad9144_upack/dac_enable_0
ad_connect  axi_ad9144_core/dac_ddata_0 axi_ad9144_upack/dac_data_0
ad_connect  axi_ad9144_core/dac_valid_0 axi_ad9144_upack/dac_valid_0
ad_connect  axi_ad9144_core/dac_enable_1 axi_ad9144_upack/dac_enable_1
ad_connect  axi_ad9144_core/dac_ddata_1 axi_ad9144_upack/dac_data_1
ad_connect  axi_ad9144_core/dac_valid_1 axi_ad9144_upack/dac_valid_1
ad_connect  axi_ad9144_core/dac_enable_2 axi_ad9144_upack/dac_enable_2
ad_connect  axi_ad9144_core/dac_ddata_2 axi_ad9144_upack/dac_data_2
ad_connect  axi_ad9144_core/dac_valid_2 axi_ad9144_upack/dac_valid_2
ad_connect  axi_ad9144_core/dac_enable_3 axi_ad9144_upack/dac_enable_3
ad_connect  axi_ad9144_core/dac_ddata_3 axi_ad9144_upack/dac_data_3
ad_connect  axi_ad9144_core/dac_valid_3 axi_ad9144_upack/dac_valid_3
ad_connect  util_fmcomms7_xcvr/tx_out_clk_0 axi_ad9144_fifo/dac_clk
ad_connect  axi_ad9144_jesd_rstgen/peripheral_reset axi_ad9144_fifo/dac_rst
ad_connect  axi_ad9144_upack/dac_valid axi_ad9144_fifo/dac_valid
ad_connect  axi_ad9144_upack/dac_data axi_ad9144_fifo/dac_data
ad_connect  sys_cpu_clk axi_ad9144_fifo/dma_clk
ad_connect  sys_cpu_reset axi_ad9144_fifo/dma_rst
ad_connect  sys_cpu_clk axi_ad9144_dma/m_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9144_dma/m_src_axi_aresetn
ad_connect  axi_ad9144_fifo/dma_xfer_req axi_ad9144_dma/m_axis_xfer_req
ad_connect  axi_ad9144_fifo/dma_ready axi_ad9144_dma/m_axis_ready
ad_connect  axi_ad9144_fifo/dma_data axi_ad9144_dma/m_axis_data
ad_connect  axi_ad9144_fifo/dma_valid axi_ad9144_dma/m_axis_valid
ad_connect  axi_ad9144_fifo/dma_xfer_last axi_ad9144_dma/m_axis_last

# connections (adc)

ad_xcvrcon  util_fmcomms7_xcvr axi_ad9680_xcvr axi_ad9680_jesd
ad_connect  util_fmcomms7_xcvr/rx_out_clk_0 axi_ad9680_core/rx_clk
ad_connect  axi_ad9680_jesd/rx_start_of_frame axi_ad9680_core/rx_sof
ad_connect  axi_ad9680_jesd/rx_tdata axi_ad9680_core/rx_data

ad_connect  util_fmcomms7_xcvr/rx_out_clk_0 axi_ad9680_cpack/adc_clk
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_cpack/adc_rst
ad_connect  axi_ad9680_core/adc_enable_0 axi_ad9680_cpack/adc_enable_0
ad_connect  axi_ad9680_core/adc_valid_0 axi_ad9680_cpack/adc_valid_0
ad_connect  axi_ad9680_core/adc_data_0 axi_ad9680_cpack/adc_data_0
ad_connect  axi_ad9680_core/adc_enable_1 axi_ad9680_cpack/adc_enable_1
ad_connect  axi_ad9680_core/adc_valid_1 axi_ad9680_cpack/adc_valid_1
ad_connect  axi_ad9680_core/adc_data_1 axi_ad9680_cpack/adc_data_1
ad_connect  util_fmcomms7_xcvr/rx_out_clk_0 axi_ad9680_fifo/adc_clk
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_fifo/adc_rst
ad_connect  axi_ad9680_cpack/adc_valid axi_ad9680_fifo/adc_wr
ad_connect  axi_ad9680_cpack/adc_data axi_ad9680_fifo/adc_wdata
ad_connect  sys_cpu_clk axi_ad9680_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9680_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect  axi_ad9680_fifo/dma_wr axi_ad9680_dma/s_axis_valid
ad_connect  axi_ad9680_fifo/dma_wdata axi_ad9680_dma/s_axis_data
ad_connect  axi_ad9680_fifo/dma_wready axi_ad9680_dma/s_axis_ready
ad_connect  axi_ad9680_fifo/dma_xfer_req axi_ad9680_dma/s_axis_xfer_req
ad_connect  axi_ad9680_core/adc_dovf axi_ad9680_fifo/adc_wovf

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9144_xcvr
ad_cpu_interconnect 0x44A00000 axi_ad9144_core
ad_cpu_interconnect 0x44A90000 axi_ad9144_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9144_dma
ad_cpu_interconnect 0x44A50000 axi_ad9680_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9680_core
ad_cpu_interconnect 0x44A91000 axi_ad9680_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9680_dma
ad_cpu_interconnect 0x44A80000 axi_fmcomms7_spi

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9680_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9144_dma/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9680_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-9  mb-9  axi_ad9144_dma/irq
ad_cpu_interrupt ps-10 mb-10 axi_ad9680_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_fmcomms7_spi/ip2intc_irpt

ad_connect  axi_ad9144_fifo/bypass GND
