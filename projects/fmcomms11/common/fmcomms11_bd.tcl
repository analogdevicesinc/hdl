
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# JESD204 TX parameters
set TX_NUM_OF_LANES 8      ; # L
set TX_NUM_OF_CONVERTERS 2 ; # M
set TX_SAMPLES_PER_FRAME 2 ; # S
set TX_SAMPLE_WIDTH 16     ; # N/NP

set TX_SAMPLES_PER_CHANNEL [expr [expr $TX_NUM_OF_LANES * 32 ] / \
                                 [expr $TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH]] ; # L * 32 / (M * N)

# JESD204 RX parameters
set RX_NUM_OF_LANES 8      ; # L
set RX_NUM_OF_CONVERTERS 1 ; # M
set RX_SAMPLES_PER_FRAME 4 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

# Data path FIFO attributes

set adc_fifo_name axi_ad9625_fifo
set adc_data_width 256
set adc_dma_data_width 64

set dac_fifo_name axi_ad9162_fifo
set dac_data_width 256
set dac_dma_data_width 256

# DAC FIFO bypass

create_bd_port -dir I dac_fifo_bypass

# dac peripherals

ad_ip_instance axi_adxcvr axi_ad9162_xcvr [list \
  NUM_OF_LANES 8 \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 1 \
]

adi_axi_jesd204_tx_create axi_ad9162_jesd 8

adi_tpl_jesd204_tx_create axi_ad9162_core $TX_NUM_OF_LANES \
                                          $TX_NUM_OF_CONVERTERS \
                                          $TX_SAMPLES_PER_FRAME \
                                          $TX_SAMPLE_WIDTH

ad_ip_instance util_upack2 util_ad9162_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac axi_ad9162_dma [list \
  DMA_TYPE_SRC 0 \
  DMA_TYPE_DEST 1 \
  ID 1 \
  AXI_SLICE_SRC 0 \
  AXI_SLICE_DEST 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  CYCLIC 0 \
  DMA_DATA_WIDTH_SRC 256 \
  DMA_DATA_WIDTH_DEST 256 \
]

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9625_xcvr [list \
  NUM_OF_LANES 8 \
  QPLL_ENABLE 0 \
  TX_OR_RX_N 0 \
]

adi_tpl_jesd204_rx_create axi_ad9625_core $RX_NUM_OF_LANES \
                                          $RX_NUM_OF_CONVERTERS \
                                          $RX_SAMPLES_PER_FRAME \
                                          $RX_SAMPLE_WIDTH

adi_axi_jesd204_rx_create axi_ad9625_jesd 8

ad_ip_instance axi_dmac axi_ad9625_dma [list \
  DMA_TYPE_SRC 1 \
  DMA_TYPE_DEST 0 \
  ID 0 \
  AXI_SLICE_SRC 0 \
  AXI_SLICE_DEST 0 \
  SYNC_TRANSFER_START 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  CYCLIC 0 \
  DMA_DATA_WIDTH_SRC 64 \
  DMA_DATA_WIDTH_DEST 64 \
]

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

# shared transceiver core

ad_ip_instance util_adxcvr util_fmcomms11_xcvr [list \
  QPLL_FBDIV 0x120 \
  CPLL_FBDIV 4 \
  TX_NUM_OF_LANES 8 \
  TX_CLK25_DIV 7 \
  RX_NUM_OF_LANES 8 \
  RX_CLK25_DIV 7 \
  RX_DFE_LPM_CFG 0x0904 \
  RX_CDR_CFG 0x03000023ff10400020 \
]

# reference clocks & resets

create_bd_port -dir I tx_ref_clk_0
create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  tx_ref_clk_0 util_fmcomms11_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcomms11_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9162_xcvr/up_pll_rst util_fmcomms11_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_xcvr/up_pll_rst util_fmcomms11_xcvr/up_cpll_rst_*
ad_connect  $sys_cpu_resetn util_fmcomms11_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_fmcomms11_xcvr/up_clk

# connections (dac)

ad_xcvrcon  util_fmcomms11_xcvr axi_ad9162_xcvr axi_ad9162_jesd {0 1 2 3 7 4 6 5}
ad_connect  util_fmcomms11_xcvr/tx_out_clk_0 axi_ad9162_core/link_clk
ad_connect  axi_ad9162_jesd/tx_data axi_ad9162_core/link

ad_connect  util_fmcomms11_xcvr/tx_out_clk_0 util_ad9162_upack/clk
ad_connect  axi_ad9162_jesd_rstgen/peripheral_reset util_ad9162_upack/reset

ad_connect  axi_ad9162_core/dac_valid_0 util_ad9162_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  util_ad9162_upack/fifo_rd_data_$i axi_ad9162_core/dac_data_$i
  ad_connect  axi_ad9162_core/dac_enable_$i  util_ad9162_upack/enable_$i
}

ad_connect  util_fmcomms11_xcvr/tx_out_clk_0 axi_ad9162_fifo/dac_clk
ad_connect  axi_ad9162_jesd_rstgen/peripheral_reset axi_ad9162_fifo/dac_rst
ad_connect  $sys_cpu_clk axi_ad9162_fifo/dma_clk
ad_connect  $sys_cpu_reset axi_ad9162_fifo/dma_rst
ad_connect  $sys_cpu_clk axi_ad9162_dma/m_axis_aclk
ad_connect  $sys_cpu_resetn axi_ad9162_dma/m_src_axi_aresetn
ad_connect  util_ad9162_upack/s_axis_valid VCC
ad_connect  util_ad9162_upack/s_axis_ready axi_ad9162_fifo/dac_valid
ad_connect  util_ad9162_upack/s_axis_data axi_ad9162_fifo/dac_data
ad_connect  axi_ad9162_core/dac_dunf axi_ad9162_fifo/dac_dunf
ad_connect  axi_ad9162_fifo/dma_xfer_req axi_ad9162_dma/m_axis_xfer_req
ad_connect  axi_ad9162_fifo/dma_ready axi_ad9162_dma/m_axis_ready
ad_connect  axi_ad9162_fifo/dma_data axi_ad9162_dma/m_axis_data
ad_connect  axi_ad9162_fifo/dma_valid axi_ad9162_dma/m_axis_valid
ad_connect  axi_ad9162_fifo/dma_xfer_last axi_ad9162_dma/m_axis_last
ad_connect  dac_fifo_bypass axi_ad9162_fifo/bypass

# connections (adc)

ad_xcvrcon  util_fmcomms11_xcvr axi_ad9625_xcvr axi_ad9625_jesd {0 1 2 3 7 4 6 5}
ad_connect  util_fmcomms11_xcvr/rx_out_clk_0 axi_ad9625_core/link_clk

ad_connect  axi_ad9625_jesd/rx_sof axi_ad9625_core/link_sof
ad_connect  axi_ad9625_jesd/rx_data_tdata axi_ad9625_core/link_data
ad_connect  axi_ad9625_jesd/rx_data_tvalid axi_ad9625_core/link_valid

ad_connect  util_fmcomms11_xcvr/rx_out_clk_0 axi_ad9625_fifo/adc_clk
ad_connect  axi_ad9625_jesd_rstgen/peripheral_reset axi_ad9625_fifo/adc_rst
ad_connect  axi_ad9625_core/adc_valid_0 axi_ad9625_fifo/adc_wr
ad_connect  axi_ad9625_core/adc_data_0 axi_ad9625_fifo/adc_wdata
ad_connect  $sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect  $sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect  $sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn
ad_connect  axi_ad9625_fifo/dma_wr axi_ad9625_dma/s_axis_valid
ad_connect  axi_ad9625_fifo/dma_wdata axi_ad9625_dma/s_axis_data
ad_connect  axi_ad9625_fifo/dma_wready axi_ad9625_dma/s_axis_ready
ad_connect  axi_ad9625_fifo/dma_xfer_req axi_ad9625_dma/s_axis_xfer_req
ad_connect  axi_ad9625_core/adc_dovf axi_ad9625_fifo/adc_wovf

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9162_xcvr
ad_cpu_interconnect 0x44A00000 axi_ad9162_core
ad_cpu_interconnect 0x44A90000 axi_ad9162_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9162_dma
ad_cpu_interconnect 0x44A50000 axi_ad9625_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9625_core
ad_cpu_interconnect 0x44AA0000 axi_ad9625_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9625_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9625_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad9162_dma/m_src_axi
ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9162_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_ad9625_jesd/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9162_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9625_dma/irq

