
# RX parameters for each converter
set RX_NUM_OF_LANES 8      ; # L
set RX_NUM_OF_CONVERTERS 2 ; # M
set RX_SAMPLES_PER_FRAME 2 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 8 ; # L * 32 / (M * N)

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# adc peripherals

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

adi_tpl_jesd204_rx_create axi_ad9208_core $RX_NUM_OF_LANES \
                                               $RX_NUM_OF_CONVERTERS \
                                               $RX_SAMPLES_PER_FRAME \
                                               $RX_SAMPLE_WIDTH

adi_axi_jesd204_rx_create axi_ad9208_jesd 8

ad_ip_instance axi_adxcvr axi_ad9208_xcvr
ad_ip_parameter axi_ad9208_xcvr CONFIG.NUM_OF_LANES 8
ad_ip_parameter axi_ad9208_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9208_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9208_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_ad9208_xcvr CONFIG.SYS_CLK_SEL 3
ad_ip_parameter axi_ad9208_xcvr CONFIG.OUT_CLK_SEL 3

ad_ip_instance axi_dmac axi_ad9208_dma
ad_ip_parameter axi_ad9208_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9208_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9208_dma CONFIG.ID 0
ad_ip_parameter axi_ad9208_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9208_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9208_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9208_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9208_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9208_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9208_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9208_dma CONFIG.DMA_DATA_WIDTH_DEST 128

ad_ip_instance util_adxcvr util_ad9208_xcvr
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_FBDIV 40
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_ad9208_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_ad9208_xcvr CONFIG.RX_NUM_OF_LANES 8
ad_ip_parameter util_ad9208_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_ad9208_xcvr CONFIG.RX_CLK25_DIV 15
ad_ip_parameter util_ad9208_xcvr CONFIG.POR_CFG 0x0
ad_ip_parameter util_ad9208_xcvr CONFIG.PPF0_CFG 0xf00
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CFG1 0xd038
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CFG1_G3 0xd038
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CFG2 0xfc0
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CFG2_G3 0xfc0
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CFG3 0x120
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CFG4 0x45
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CP 0xff
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_CP_G3 0xf
ad_ip_parameter util_ad9208_xcvr CONFIG.QPLL_LPF 0x31d
ad_ip_parameter util_ad9208_xcvr CONFIG.GTH4_CH_HSPMUX 0x2468
ad_ip_parameter util_ad9208_xcvr CONFIG.GTH4_PREIQ_FREQ_BST 1
ad_ip_parameter util_ad9208_xcvr CONFIG.GTH4_RXPI_CFG0 0x4
ad_ip_parameter util_ad9208_xcvr CONFIG.GTH4_RXPI_CFG1 0x0
ad_ip_parameter util_ad9208_xcvr CONFIG.RXCDR_CFG0 0x3
ad_ip_parameter util_ad9208_xcvr CONFIG.RXCDR_CFG2_GEN2 0x265
ad_ip_parameter util_ad9208_xcvr CONFIG.RXCDR_CFG2_GEN4 0x164
ad_ip_parameter util_ad9208_xcvr CONFIG.RXCDR_CFG3 0x1a
ad_ip_parameter util_ad9208_xcvr CONFIG.RXCDR_CFG3_GEN2 0x1a
ad_ip_parameter util_ad9208_xcvr CONFIG.RXCDR_CFG3_GEN3 0x1a
ad_ip_parameter util_ad9208_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12


ad_ip_instance util_cpack2 ad9208_cpack
ad_ip_parameter ad9208_cpack CONFIG.SAMPLES_PER_CHANNEL 8
ad_ip_parameter ad9208_cpack CONFIG.SAMPLE_DATA_WIDTH 16
ad_ip_parameter ad9208_cpack CONFIG.NUM_OF_CHANNELS 2

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I rx_core_clk

ad_xcvrpll  rx_ref_clk_0 util_ad9208_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_ad9208_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9208_xcvr/up_pll_rst util_ad9208_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9208_xcvr/up_pll_rst util_ad9208_xcvr/up_cpll_rst_*
ad_connect  sys_cpu_resetn util_ad9208_xcvr/up_rstn
ad_connect  sys_cpu_clk util_ad9208_xcvr/up_clk

# connections (adc)

ad_xcvrcon  util_ad9208_xcvr axi_ad9208_xcvr axi_ad9208_jesd {} rx_core_clk
ad_connect  rx_core_clk axi_ad9208_core/link_clk
ad_connect  axi_ad9208_jesd/rx_data_tdata axi_ad9208_core/link_data
ad_connect  axi_ad9208_jesd/rx_data_tvalid axi_ad9208_core/link_valid
ad_connect  axi_ad9208_jesd/rx_sof axi_ad9208_core/link_sof

ad_connect rx_core_clk ad9208_cpack/clk
ad_connect axi_ad9208_core/adc_enable_0 ad9208_cpack/enable_0
ad_connect axi_ad9208_core/adc_valid_0 ad9208_cpack/fifo_wr_en
ad_connect axi_ad9208_core/adc_data_0 ad9208_cpack/fifo_wr_data_0
ad_connect axi_ad9208_core/adc_enable_1 ad9208_cpack/enable_1
ad_connect axi_ad9208_core/adc_data_1 ad9208_cpack/fifo_wr_data_1

ad_connect axi_ad9208_core/adc_dovf ad9208_cpack/fifo_wr_overflow

ad_connect sys_cpu_resetn axi_ad9208_dma/m_dest_axi_aresetn

ad_connect ad9208_cpack/packed_fifo_wr_data axi_ad9208_fifo/adc_wdata
ad_connect ad9208_cpack/packed_fifo_wr_en axi_ad9208_fifo/adc_wr
ad_connect axi_ad9208_fifo/adc_clk rx_core_clk
ad_connect rx_core_clk_rstgen/peripheral_reset ad9208_cpack/reset
ad_connect axi_ad9208_fifo/adc_rst rx_core_clk_rstgen/peripheral_reset
ad_connect axi_ad9208_dma/s_axis_ready axi_ad9208_fifo/dma_wready
ad_connect axi_ad9208_dma/s_axis_valid axi_ad9208_fifo/dma_wr
ad_connect axi_ad9208_dma/s_axis_data axi_ad9208_fifo/dma_wdata
ad_connect $sys_cpu_clk axi_ad9208_fifo/dma_clk
ad_connect $sys_cpu_clk axi_ad9208_dma/s_axis_aclk
ad_connect axi_ad9208_dma/s_axis_xfer_req axi_ad9208_fifo/dma_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9208_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9208_core
ad_cpu_interconnect 0x44AA0000 axi_ad9208_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9208_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9208_xcvr/m_axi

# interconnect (mem/adc)

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad9208_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-13 axi_ad9208_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9208_dma/irq

#delete_bd_objs [get_bd_nets sys_500m_clk] [get_bd_nets sys_500m_reset] [get_bd_nets sys_500m_resetn] [get_bd_cells sys_500m_rstgen]
set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {150}] [get_bd_cells sys_ps8]

