
# RX parameters
set RX_NUM_OF_LINKS 4

set RX_NUM_OF_LANES 4      ; # L
set RX_NUM_OF_CONVERTERS 8 ; # M
set RX_SAMPLES_PER_FRAME 1 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 1 ; # L * 32 / (M * N)


# TX parameters
set TX_NUM_OF_LINKS 4

set TX_NUM_OF_LANES 4      ; # L
set TX_NUM_OF_CONVERTERS 8 ; # M
set TX_SAMPLES_PER_FRAME 1 ; # S
set TX_SAMPLE_WIDTH 16     ; # N/NP

set TX_SAMPLES_PER_CHANNEL 1 ; # L * 32 / (M * N)



source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set adc_fifo_name mxfe_adc_fifo
set adc_data_width [expr 32*$RX_NUM_OF_LANES*$RX_NUM_OF_LINKS]
set adc_dma_data_width [expr 32*$RX_NUM_OF_LANES*$RX_NUM_OF_LINKS]
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS*$RX_NUM_OF_LINKS) / ($adc_data_width/$RX_SAMPLE_WIDTH))/log(2)))]


set dac_fifo_name mxfe_dac_fifo
set dac_data_width [expr 32*$TX_NUM_OF_LANES*$TX_NUM_OF_LINKS]
set dac_dma_data_width [expr 32*$TX_NUM_OF_LANES*$TX_NUM_OF_LINKS]
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS*$TX_NUM_OF_LINKS) / ($dac_data_width/$TX_SAMPLE_WIDTH))/log(2)))]


create_bd_port -dir I device_clk

# common xcvr
ad_ip_instance util_adxcvr util_mxfe_xcvr [list \
  CPLL_FBDIV_4_5 5 \
  TX_NUM_OF_LANES [expr $TX_NUM_OF_LANES*$TX_NUM_OF_LINKS] \
  RX_NUM_OF_LANES [expr $RX_NUM_OF_LANES*$RX_NUM_OF_LINKS] \
  RX_OUT_DIV 1 \
]

# adc peripherals

ad_ip_instance axi_adxcvr axi_mxfe_rx_xcvr [list \
  ID 0 \
  NUM_OF_LANES [expr $RX_NUM_OF_LANES*$RX_NUM_OF_LINKS] \
  TX_OR_RX_N 0 \
  QPLL_ENABLE 0 \
  LPM_OR_DFE_N 1 \
  SYS_CLK_SEL 0x3 \
]

adi_axi_jesd204_rx_create axi_mxfe_rx_jesd [expr $RX_NUM_OF_LANES*$RX_NUM_OF_LINKS] $RX_NUM_OF_LINKS

ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 1

adi_tpl_jesd204_rx_create rx_mxfe_tpl_core [expr $RX_NUM_OF_LANES*$RX_NUM_OF_LINKS] \
                                           [expr $RX_NUM_OF_CONVERTERS*$RX_NUM_OF_LINKS] \
                                           $RX_SAMPLES_PER_FRAME \
                                           $RX_SAMPLE_WIDTH

ad_ip_instance util_cpack2 util_mxfe_cpack [list \
  NUM_OF_CHANNELS [expr $RX_NUM_OF_CONVERTERS*$RX_NUM_OF_LINKS] \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
]

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

ad_ip_instance axi_dmac axi_mxfe_rx_dma [list \
  DMA_TYPE_SRC 1 \
  DMA_TYPE_DEST 0 \
  ID 0 \
  AXI_SLICE_SRC 1 \
  AXI_SLICE_DEST 1 \
  SYNC_TRANSFER_START 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  MAX_BYTES_PER_BURST 4096 \
  CYCLIC 0 \
  DMA_DATA_WIDTH_SRC $adc_dma_data_width \
  DMA_DATA_WIDTH_DEST $adc_dma_data_width \
]

# dac peripherals

ad_ip_instance axi_adxcvr axi_mxfe_tx_xcvr [list \
  ID 0 \
  NUM_OF_LANES [expr $TX_NUM_OF_LANES*$TX_NUM_OF_LINKS] \
  TX_OR_RX_N 1 \
  QPLL_ENABLE 1 \
  SYS_CLK_SEL 0x3 \
]

adi_axi_jesd204_tx_create axi_mxfe_tx_jesd [expr $TX_NUM_OF_LANES*$TX_NUM_OF_LINKS] $TX_NUM_OF_LINKS

ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.SYSREF_IOB false


adi_tpl_jesd204_tx_create tx_mxfe_tpl_core [expr $TX_NUM_OF_LANES*$TX_NUM_OF_LINKS] \
                                           [expr $TX_NUM_OF_CONVERTERS*$TX_NUM_OF_LINKS] \
                                           $TX_SAMPLES_PER_FRAME \
                                           $TX_SAMPLE_WIDTH

ad_ip_instance util_upack2 util_mxfe_upack [list \
  NUM_OF_CHANNELS [expr $TX_NUM_OF_CONVERTERS*$TX_NUM_OF_LINKS] \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

ad_ip_instance axi_dmac axi_mxfe_tx_dma [list \
  DMA_TYPE_SRC 0 \
  DMA_TYPE_DEST 1 \
  ID 0 \
  AXI_SLICE_SRC 1 \
  AXI_SLICE_DEST 1 \
  SYNC_TRANSFER_START 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  CYCLIC 1 \
  DMA_DATA_WIDTH_SRC $dac_dma_data_width \
  DMA_DATA_WIDTH_DEST $dac_dma_data_width \
]

# extra GPIO peripheral
ad_ip_instance axi_gpio axi_gpio_2 [list \
  C_INTERRUPT_PRESENT 1 \
  C_IS_DUAL 1 \
]

create_bd_port -dir I -from 31 -to 0 gpio2_i
create_bd_port -dir O -from 31 -to 0 gpio2_o
create_bd_port -dir O -from 31 -to 0 gpio2_t
create_bd_port -dir I -from 31 -to 0 gpio3_i
create_bd_port -dir O -from 31 -to 0 gpio3_o
create_bd_port -dir O -from 31 -to 0 gpio3_t

# reference clocks & resets

create_bd_port -dir I ref_clk_q0
create_bd_port -dir I ref_clk_q1
create_bd_port -dir I ref_clk_q2
create_bd_port -dir I ref_clk_q3

ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/qpll_ref_clk_0
ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/cpll_ref_clk_0
ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/cpll_ref_clk_1
ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/cpll_ref_clk_2
ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/cpll_ref_clk_3
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/qpll_ref_clk_4
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/cpll_ref_clk_4
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/cpll_ref_clk_5
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/cpll_ref_clk_6
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/cpll_ref_clk_7
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/qpll_ref_clk_8
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/cpll_ref_clk_8
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/cpll_ref_clk_9
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/cpll_ref_clk_10
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/cpll_ref_clk_11
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/qpll_ref_clk_12
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/cpll_ref_clk_12
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/cpll_ref_clk_13
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/cpll_ref_clk_14
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/cpll_ref_clk_15

ad_xcvrpll  axi_mxfe_rx_xcvr/up_pll_rst util_mxfe_xcvr/up_cpll_rst_*

ad_xcvrpll  axi_mxfe_tx_xcvr/up_pll_rst util_mxfe_xcvr/up_qpll_rst_*

ad_connect  $sys_cpu_resetn util_mxfe_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_mxfe_xcvr/up_clk


# connections (adc)
ad_xcvrcon  util_mxfe_xcvr axi_mxfe_rx_xcvr axi_mxfe_rx_jesd {13 10 11 9 3 15 12 14 2 5 0 4 8 7 6 1} device_clk


# connections (dac)
ad_xcvrcon  util_mxfe_xcvr axi_mxfe_tx_xcvr axi_mxfe_tx_jesd {13 8 9 7 3 15 12 14 6 5 2 4 0 10 1 11} device_clk

# device clock domain
ad_connect  device_clk rx_mxfe_tpl_core/link_clk
ad_connect  device_clk util_mxfe_cpack/clk
ad_connect  device_clk mxfe_adc_fifo/adc_clk

ad_connect  device_clk tx_mxfe_tpl_core/link_clk
ad_connect  device_clk util_mxfe_upack/clk
ad_connect  device_clk mxfe_dac_fifo/dac_clk

# dma clock domain
ad_connect  $sys_cpu_clk mxfe_adc_fifo/dma_clk
ad_connect  $sys_dma_clk mxfe_dac_fifo/dma_clk
ad_connect  $sys_cpu_clk axi_mxfe_rx_dma/s_axis_aclk
ad_connect  $sys_dma_clk axi_mxfe_tx_dma/m_axis_aclk

# connect resets
ad_connect  device_clk_rstgen/peripheral_reset mxfe_adc_fifo/adc_rst
ad_connect  device_clk_rstgen/peripheral_reset mxfe_dac_fifo/dac_rst
ad_connect  device_clk_rstgen/peripheral_reset util_mxfe_cpack/reset
ad_connect  device_clk_rstgen/peripheral_reset util_mxfe_upack/reset
ad_connect  $sys_cpu_resetn axi_mxfe_rx_dma/m_dest_axi_aresetn
ad_connect  $sys_dma_resetn axi_mxfe_tx_dma/m_src_axi_aresetn
ad_connect  $sys_dma_reset mxfe_dac_fifo/dma_rst

# connect adc dataflow
#
# rx link layer to tpl
#
ad_connect  axi_mxfe_rx_jesd/rx_sof rx_mxfe_tpl_core/link_sof
ad_connect  axi_mxfe_rx_jesd/rx_data_tdata rx_mxfe_tpl_core/link_data
ad_connect  axi_mxfe_rx_jesd/rx_data_tvalid rx_mxfe_tpl_core/link_valid

#
# rx tpl to cpack
#
ad_connect rx_mxfe_tpl_core/adc_valid_0 util_mxfe_cpack/fifo_wr_en
for {set i 0} {$i < [expr $RX_NUM_OF_CONVERTERS*$RX_NUM_OF_LINKS]} {incr i} {
  ad_connect  rx_mxfe_tpl_core/adc_enable_$i util_mxfe_cpack/enable_$i
  ad_connect  rx_mxfe_tpl_core/adc_data_$i util_mxfe_cpack/fifo_wr_data_$i
}
ad_connect rx_mxfe_tpl_core/adc_dovf util_mxfe_cpack/fifo_wr_overflow

#
# cpack to adc_fifo
#
ad_connect  util_mxfe_cpack/packed_fifo_wr_data mxfe_adc_fifo/adc_wdata
ad_connect  util_mxfe_cpack/packed_fifo_wr_en mxfe_adc_fifo/adc_wr
#
# adc_fifo to dma
#
ad_connect  mxfe_adc_fifo/dma_wr axi_mxfe_rx_dma/s_axis_valid
ad_connect  mxfe_adc_fifo/dma_wdata axi_mxfe_rx_dma/s_axis_data
ad_connect  mxfe_adc_fifo/dma_wready axi_mxfe_rx_dma/s_axis_ready
ad_connect  mxfe_adc_fifo/dma_xfer_req axi_mxfe_rx_dma/s_axis_xfer_req


#
#connect dac dataflow
#

#
# tpl to link layer
#
ad_connect  tx_mxfe_tpl_core/link axi_mxfe_tx_jesd/tx_data

ad_connect  tx_mxfe_tpl_core/dac_valid_0 util_mxfe_upack/fifo_rd_en
for {set i 0} {$i < [expr $TX_NUM_OF_CONVERTERS*$TX_NUM_OF_LINKS]} {incr i} {
  ad_connect  util_mxfe_upack/fifo_rd_data_$i tx_mxfe_tpl_core/dac_data_$i
  ad_connect  tx_mxfe_tpl_core/dac_enable_$i  util_mxfe_upack/enable_$i
}

#
# dac fifo to upack
#

# TODO: Add streaming AXI interface for DAC FIFO
ad_connect  util_mxfe_upack/s_axis_valid VCC
ad_connect  util_mxfe_upack/s_axis_ready mxfe_dac_fifo/dac_valid
ad_connect  util_mxfe_upack/s_axis_data mxfe_dac_fifo/dac_data

#
# dma to dac fifo
#
ad_connect  mxfe_dac_fifo/dma_valid axi_mxfe_tx_dma/m_axis_valid
ad_connect  mxfe_dac_fifo/dma_data axi_mxfe_tx_dma/m_axis_data
ad_connect  mxfe_dac_fifo/dma_ready axi_mxfe_tx_dma/m_axis_ready
ad_connect  mxfe_dac_fifo/dma_xfer_req axi_mxfe_tx_dma/m_axis_xfer_req
ad_connect  mxfe_dac_fifo/dma_xfer_last axi_mxfe_tx_dma/m_axis_last
ad_connect  mxfe_dac_fifo/dac_dunf tx_mxfe_tpl_core/dac_dunf

create_bd_port -dir I dac_fifo_bypass
ad_connect  mxfe_dac_fifo/bypass dac_fifo_bypass

# extra GPIOs
ad_connect gpio2_i axi_gpio_2/gpio_io_i
ad_connect gpio2_o axi_gpio_2/gpio_io_o
ad_connect gpio2_t axi_gpio_2/gpio_io_t
ad_connect gpio3_i axi_gpio_2/gpio2_io_i
ad_connect gpio3_o axi_gpio_2/gpio2_io_o
ad_connect gpio3_t axi_gpio_2/gpio2_io_t

# interconnect (cpu)

ad_cpu_interconnect 0x44a60000 axi_mxfe_rx_xcvr
ad_cpu_interconnect 0x44b60000 axi_mxfe_tx_xcvr
ad_cpu_interconnect 0x44a10000 rx_mxfe_tpl_core
ad_cpu_interconnect 0x44b10000 tx_mxfe_tpl_core
ad_cpu_interconnect 0x44a90000 axi_mxfe_rx_jesd
ad_cpu_interconnect 0x44b90000 axi_mxfe_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_mxfe_rx_dma
ad_cpu_interconnect 0x7c430000 axi_mxfe_tx_dma
ad_cpu_interconnect 0x7c440000 axi_gpio_2

# interconnect (gt/adc)
#
ad_mem_hp0_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect $sys_cpu_clk axi_mxfe_rx_xcvr/m_axi

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp0_interconnect $sys_cpu_clk axi_mxfe_rx_dma/m_dest_axi
ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp0_interconnect $sys_dma_clk axi_mxfe_tx_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_mxfe_rx_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_mxfe_tx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_mxfe_rx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_mxfe_tx_jesd/irq
ad_cpu_interrupt ps-14 mb-8  axi_gpio_2/ip2intc_irpt


