
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set TX_NUM_OF_LANES 4           ; # L
set TX_NUM_OF_CONVERTERS 2      ; # M
set TX_SAMPLES_PER_FRAME 1      ; # S
set TX_SAMPLE_WIDTH 16          ; # N/NP

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 32 / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set dac_fifo_name axi_ad9144_fifo
set dac_data_width [expr $TX_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_CHANNEL]

set RX_NUM_OF_LANES 4           ; # L
set RX_NUM_OF_CONVERTERS 2      ; # M
set RX_SAMPLES_PER_FRAME 1      ; # S
set RX_SAMPLE_WIDTH 16          ; # N/NP

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 32 / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

set adc_fifo_name axi_ad9680_fifo
set adc_data_width [expr $RX_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width 64

# dac peripherals

ad_ip_instance axi_adxcvr axi_ad9144_xcvr
ad_ip_parameter axi_ad9144_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter axi_ad9144_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9144_xcvr CONFIG.TX_OR_RX_N 1

adi_axi_jesd204_tx_create axi_ad9144_jesd $TX_NUM_OF_LANES

adi_tpl_jesd204_tx_create axi_ad9144_tpl $TX_NUM_OF_LANES \
                                         $TX_NUM_OF_CONVERTERS \
                                         $TX_SAMPLES_PER_FRAME \
                                         $TX_SAMPLE_WIDTH \

ad_ip_instance util_upack2 axi_ad9144_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

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
ad_ip_parameter axi_ad9144_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_data_width

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_data_width $dac_fifo_address_width

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9680_xcvr
ad_ip_parameter axi_ad9680_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_ad9680_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9680_xcvr CONFIG.TX_OR_RX_N 0

adi_axi_jesd204_rx_create axi_ad9680_jesd $RX_NUM_OF_LANES


adi_tpl_jesd204_rx_create axi_ad9680_tpl $RX_NUM_OF_LANES \
                                         $RX_NUM_OF_CONVERTERS \
                                         $RX_SAMPLES_PER_FRAME \
                                         $RX_SAMPLE_WIDTH \

ad_ip_instance util_cpack2 axi_ad9680_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac axi_ad9680_dma
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9680_dma CONFIG.ID 0
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9680_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9680_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

# shared transceiver core

ad_ip_instance util_adxcvr util_daq2_xcvr
ad_ip_parameter util_daq2_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter util_daq2_xcvr CONFIG.TX_NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL_FBDIV_RATIO 1
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL_FBDIV 0x30; # 20
ad_ip_parameter util_daq2_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_daq2_xcvr CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_daq2_xcvr CONFIG.RX_DFE_LPM_CFG 0x0104
ad_ip_parameter util_daq2_xcvr CONFIG.RX_CDR_CFG 0x0B000023FF10400020

ad_connect  $sys_cpu_resetn util_daq2_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_daq2_xcvr/up_clk

# reference clocks & resets

create_bd_port -dir I tx_ref_clk_0
create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  tx_ref_clk_0 util_daq2_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_daq2_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9144_xcvr/up_pll_rst util_daq2_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9680_xcvr/up_pll_rst util_daq2_xcvr/up_cpll_rst_*

# connections (dac)

ad_xcvrcon  util_daq2_xcvr axi_ad9144_xcvr axi_ad9144_jesd {0 2 3 1}
ad_connect  util_daq2_xcvr/tx_out_clk_0 axi_ad9144_tpl/link_clk
ad_connect  axi_ad9144_jesd/tx_data axi_ad9144_tpl/link
ad_connect  util_daq2_xcvr/tx_out_clk_0 axi_ad9144_upack/clk
ad_connect  axi_ad9144_jesd_rstgen/peripheral_reset axi_ad9144_upack/reset


ad_connect  axi_ad9144_tpl/dac_valid_0 axi_ad9144_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  axi_ad9144_tpl/dac_enable_$i axi_ad9144_upack/enable_$i
  ad_connect  axi_ad9144_tpl/dac_data_$i axi_ad9144_upack/fifo_rd_data_$i
}

ad_connect  util_daq2_xcvr/tx_out_clk_0 axi_ad9144_fifo/dac_clk
ad_connect  axi_ad9144_jesd_rstgen/peripheral_reset axi_ad9144_fifo/dac_rst

# TODO: Add streaming AXI interface for DAC FIFO
ad_connect  axi_ad9144_upack/s_axis_valid VCC
ad_connect  axi_ad9144_upack/s_axis_ready axi_ad9144_fifo/dac_valid
ad_connect  axi_ad9144_upack/s_axis_data axi_ad9144_fifo/dac_data
ad_connect  axi_ad9144_tpl/dac_dunf axi_ad9144_fifo/dac_dunf

ad_connect  $sys_cpu_clk axi_ad9144_fifo/dma_clk
ad_connect  $sys_cpu_reset axi_ad9144_fifo/dma_rst
ad_connect  $sys_cpu_clk axi_ad9144_dma/m_axis_aclk
ad_connect  $sys_cpu_resetn axi_ad9144_dma/m_src_axi_aresetn

ad_connect  axi_ad9144_fifo/dma_xfer_req axi_ad9144_dma/m_axis_xfer_req
ad_connect  axi_ad9144_fifo/dma_ready axi_ad9144_dma/m_axis_ready
ad_connect  axi_ad9144_fifo/dma_data axi_ad9144_dma/m_axis_data
ad_connect  axi_ad9144_fifo/dma_valid axi_ad9144_dma/m_axis_valid
ad_connect  axi_ad9144_fifo/dma_xfer_last axi_ad9144_dma/m_axis_last

# connections (adc)

ad_xcvrcon  util_daq2_xcvr axi_ad9680_xcvr axi_ad9680_jesd
ad_connect  util_daq2_xcvr/rx_out_clk_0 axi_ad9680_tpl/link_clk
ad_connect  axi_ad9680_jesd/rx_sof axi_ad9680_tpl/link_sof
ad_connect  axi_ad9680_jesd/rx_data_tdata axi_ad9680_tpl/link_data
ad_connect  axi_ad9680_jesd/rx_data_tvalid axi_ad9680_tpl/link_valid

ad_connect  util_daq2_xcvr/rx_out_clk_0 axi_ad9680_cpack/clk
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_cpack/reset

ad_connect  axi_ad9680_tpl/adc_valid_0 axi_ad9680_cpack/fifo_wr_en
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  axi_ad9680_tpl/adc_enable_$i axi_ad9680_cpack/enable_$i
  ad_connect  axi_ad9680_tpl/adc_data_$i axi_ad9680_cpack/fifo_wr_data_$i
}
ad_connect  axi_ad9680_tpl/adc_dovf axi_ad9680_cpack/fifo_wr_overflow

ad_connect  util_daq2_xcvr/rx_out_clk_0 axi_ad9680_fifo/adc_clk
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_fifo/adc_rst

ad_connect  axi_ad9680_cpack/packed_fifo_wr_en axi_ad9680_fifo/adc_wr
ad_connect  axi_ad9680_cpack/packed_fifo_wr_data axi_ad9680_fifo/adc_wdata
ad_connect  axi_ad9680_cpack/packed_fifo_wr_overflow axi_ad9680_fifo/adc_wovf

ad_connect  $sys_cpu_clk axi_ad9680_fifo/dma_clk
ad_connect  $sys_cpu_clk axi_ad9680_dma/s_axis_aclk
ad_connect  $sys_cpu_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect  axi_ad9680_fifo/dma_wr axi_ad9680_dma/s_axis_valid
ad_connect  axi_ad9680_fifo/dma_wdata axi_ad9680_dma/s_axis_data
ad_connect  axi_ad9680_fifo/dma_wready axi_ad9680_dma/s_axis_ready
ad_connect  axi_ad9680_fifo/dma_xfer_req axi_ad9680_dma/s_axis_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9144_xcvr
ad_cpu_interconnect 0x44A04000 axi_ad9144_tpl
ad_cpu_interconnect 0x44A90000 axi_ad9144_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9144_dma
ad_cpu_interconnect 0x44A50000 axi_ad9680_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9680_tpl
ad_cpu_interconnect 0x44AA0000 axi_ad9680_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9680_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9680_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad9144_dma/m_src_axi
ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad9680_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9144_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_ad9680_jesd/irq
ad_cpu_interrupt ps-12 mb-13 axi_ad9144_dma/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9680_dma/irq

ad_connect  axi_ad9144_fifo/bypass GND

