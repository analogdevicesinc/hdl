
# RX parameters for each converter
set RX_NUM_OF_LANES 16     ; # L
set RX_NUM_OF_CONVERTERS 1 ; # M
set RX_SAMPLES_PER_FRAME 1 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 32 ; # L * 32 / (M * N)

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set adc_fifo_name axi_ad9213_fifo
set adc_data_width 512
set adc_dma_data_width 512

create_bd_port -dir I glbl_clk_0

# adc peripherals

ad_ip_instance util_adxcvr util_adc_xcvr
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_adc_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_adc_xcvr CONFIG.RX_NUM_OF_LANES 16
ad_ip_parameter util_adc_xcvr CONFIG.RX_OUT_DIV 1

ad_ip_instance axi_adxcvr axi_ad9213_xcvr
ad_ip_parameter axi_ad9213_xcvr CONFIG.ID 0
ad_ip_parameter axi_ad9213_xcvr CONFIG.NUM_OF_LANES 16
ad_ip_parameter axi_ad9213_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9213_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9213_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_ad9213_xcvr CONFIG.SYS_CLK_SEL 0x3

adi_axi_jesd204_rx_create axi_ad9213_jesd 16
ad_ip_parameter axi_ad9213_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_ad9213_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2

adi_tpl_jesd204_rx_create rx_ad9213_tpl_core $RX_NUM_OF_LANES \
                                             $RX_NUM_OF_CONVERTERS \
                                             $RX_SAMPLES_PER_FRAME \
                                             $RX_SAMPLE_WIDTH

ad_ip_instance util_cpack2 util_ad9213_cpack [list \
  NUM_OF_CHANNELS [expr $RX_NUM_OF_CONVERTERS] \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
]

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

ad_ip_instance axi_dmac axi_ad9213_dma
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9213_dma CONFIG.ID 0
ad_ip_parameter axi_ad9213_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9213_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9213_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9213_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_ad9213_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_DATA_WIDTH_DEST $adc_dma_data_width

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I rx_ref_clk_1

ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/qpll_ref_clk_0
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_4
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_8
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_12

ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_0
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_1
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_2
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_3
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_4
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_5
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_6
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_7
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_8
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_9
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_10
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_11
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_12
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_13
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_14
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_15

ad_xcvrpll  axi_ad9213_xcvr/up_pll_rst util_adc_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9213_xcvr/up_pll_rst util_adc_xcvr/up_cpll_rst_*

ad_connect  $sys_cpu_resetn util_adc_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_adc_xcvr/up_clk

# connections (adc)

ad_xcvrcon  util_adc_xcvr axi_ad9213_xcvr axi_ad9213_jesd {} glbl_clk_0

## use global clock as device clock instead of rx_out_clk
delete_bd_objs [get_bd_nets util_adc_xcvr_rx_out_clk_0]

# connect clocks
# device clock domain
ad_connect  glbl_clk_0 rx_ad9213_tpl_core/link_clk

ad_connect  glbl_clk_0 util_ad9213_cpack/clk
ad_connect  glbl_clk_0 axi_ad9213_fifo/adc_clk

# dma clock domain
ad_connect  $sys_cpu_clk axi_ad9213_fifo/dma_clk
ad_connect  $sys_cpu_clk axi_ad9213_dma/s_axis_aclk

# connect resets
ad_connect  glbl_clk_0_rstgen/peripheral_reset axi_ad9213_fifo/adc_rst
ad_connect  glbl_clk_0_rstgen/peripheral_reset util_ad9213_cpack/reset
ad_connect  $sys_cpu_resetn axi_ad9213_dma/m_dest_axi_aresetn

# connect dataflow
ad_connect  axi_ad9213_jesd/rx_sof rx_ad9213_tpl_core/link_sof
ad_connect  axi_ad9213_jesd/rx_data_tdata rx_ad9213_tpl_core/link_data
ad_connect  axi_ad9213_jesd/rx_data_tvalid rx_ad9213_tpl_core/link_valid

ad_connect rx_ad9213_tpl_core/adc_valid_0 util_ad9213_cpack/fifo_wr_en
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_ad9213_tpl_core/adc_enable_$i util_ad9213_cpack/enable_$i
  ad_connect  rx_ad9213_tpl_core/adc_data_$i util_ad9213_cpack/fifo_wr_data_$i
}
ad_connect rx_ad9213_tpl_core/adc_dovf util_ad9213_cpack/fifo_wr_overflow

ad_connect  util_ad9213_cpack/packed_fifo_wr_data axi_ad9213_fifo/adc_wdata
ad_connect  util_ad9213_cpack/packed_fifo_wr_en axi_ad9213_fifo/adc_wr

ad_connect  axi_ad9213_fifo/dma_wr axi_ad9213_dma/s_axis_valid
ad_connect  axi_ad9213_fifo/dma_wdata axi_ad9213_dma/s_axis_data
ad_connect  axi_ad9213_fifo/dma_wready axi_ad9213_dma/s_axis_ready
ad_connect  axi_ad9213_fifo/dma_xfer_req axi_ad9213_dma/s_axis_xfer_req

# interconnect (cpu)
ad_cpu_interconnect 0x44a60000 axi_ad9213_xcvr
ad_cpu_interconnect 0x44a10000 rx_ad9213_tpl_core
ad_cpu_interconnect 0x44a90000 axi_ad9213_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9213_dma

# interconnect (gt/adc)
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9213_xcvr/m_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9213_dma/m_dest_axi

# interrupts
ad_cpu_interrupt ps-12 mb-12 axi_ad9213_dma/irq
ad_cpu_interrupt ps-11 mb-13 axi_ad9213_jesd/irq
