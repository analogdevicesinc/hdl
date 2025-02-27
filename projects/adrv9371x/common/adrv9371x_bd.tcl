###############################################################################
## Copyright (C) 2016-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


# Parameter description:
#   [TX/RX/RX_OS]_JESD_M  : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L  : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S  : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample

set MAX_TX_NUM_OF_LANES 4
set MAX_RX_NUM_OF_LANES 2
set MAX_RX_OS_NUM_OF_LANES 2

# TX parameters
set TX_NUM_OF_LANES $ad_project_params(TX_JESD_L)      ; # L
set TX_NUM_OF_CONVERTERS $ad_project_params(TX_JESD_M) ; # M
set TX_SAMPLES_PER_FRAME $ad_project_params(TX_JESD_S) ; # S
set TX_SAMPLE_WIDTH 16                                 ; # N/NP

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 32 / \
                                ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

# RX parameters
set RX_NUM_OF_LANES $ad_project_params(RX_JESD_L)      ; # L
set RX_NUM_OF_CONVERTERS $ad_project_params(RX_JESD_M) ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S) ; # S
set RX_SAMPLE_WIDTH 16                                 ; # N/NP

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 32 / \
                                ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

# RX Observation parameters
set RX_OS_NUM_OF_LANES $ad_project_params(RX_OS_JESD_L)      ; # L
set RX_OS_NUM_OF_CONVERTERS $ad_project_params(RX_OS_JESD_M) ; # M
set RX_OS_SAMPLES_PER_FRAME $ad_project_params(RX_OS_JESD_S) ; # S
set RX_OS_SAMPLE_WIDTH 16                                    ; # N/NP

set RX_OS_SAMPLES_PER_CHANNEL [expr $RX_OS_NUM_OF_LANES * 32 / \
                                   ($RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLE_WIDTH)] ;  # L * 32 / (M * N)

set dac_fifo_name axi_ad9371_dacfifo
set dac_data_width [expr $TX_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_CHANNEL]
set dac_dma_data_width [expr $TX_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_CHANNEL]

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/projects/common/xilinx/adi_fir_filter_bd.tcl

# ad9371

create_bd_port -dir I ref_clk

create_bd_port -dir I dac_fifo_bypass
create_bd_port -dir I adc_fir_filter_active
create_bd_port -dir I dac_fir_filter_active

# dac peripherals

ad_ip_instance axi_clkgen axi_ad9371_tx_clkgen
ad_ip_parameter axi_ad9371_tx_clkgen CONFIG.ID 2
ad_ip_parameter axi_ad9371_tx_clkgen CONFIG.CLKIN_PERIOD 8
ad_ip_parameter axi_ad9371_tx_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_ad9371_tx_clkgen CONFIG.VCO_MUL 8
ad_ip_parameter axi_ad9371_tx_clkgen CONFIG.CLK0_DIV 8

ad_ip_instance axi_adxcvr axi_ad9371_tx_xcvr
ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.TX_OR_RX_N 1
ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.SYS_CLK_SEL 3
ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.OUT_CLK_SEL 3
ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.LPM_OR_DFE_N 0

adi_axi_jesd204_tx_create axi_ad9371_tx_jesd $TX_NUM_OF_LANES

ad_ip_instance util_upack2 util_ad9371_tx_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

ad_add_interpolation_filter "tx_fir_interpolator" 8 $TX_NUM_OF_CONVERTERS 2 {122.88} {15.36} \
                            "$ad_hdl_dir/library/util_fir_int/coefile_int.coe"

adi_tpl_jesd204_tx_create tx_ad9371_tpl_core $TX_NUM_OF_LANES \
                                             $TX_NUM_OF_CONVERTERS \
                                             $TX_SAMPLES_PER_FRAME \
                                             $TX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_ad9371_tx_dma
ad_ip_parameter axi_ad9371_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9371_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9371_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9371_tx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9371_tx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9371_tx_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_ad9371_tx_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_ad9371_tx_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_ad9371_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9371_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_dma_data_width
ad_ip_parameter axi_ad9371_tx_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

# adc peripherals

ad_ip_instance axi_clkgen axi_ad9371_rx_clkgen
ad_ip_parameter axi_ad9371_rx_clkgen CONFIG.ID 2
ad_ip_parameter axi_ad9371_rx_clkgen CONFIG.CLKIN_PERIOD 8
ad_ip_parameter axi_ad9371_rx_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_ad9371_rx_clkgen CONFIG.VCO_MUL 8
ad_ip_parameter axi_ad9371_rx_clkgen CONFIG.CLK0_DIV 8

ad_ip_instance axi_adxcvr axi_ad9371_rx_xcvr
ad_ip_parameter axi_ad9371_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_ad9371_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9371_rx_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9371_rx_xcvr CONFIG.SYS_CLK_SEL 0
ad_ip_parameter axi_ad9371_rx_xcvr CONFIG.OUT_CLK_SEL 3
ad_ip_parameter axi_ad9371_rx_xcvr CONFIG.LPM_OR_DFE_N 1

adi_axi_jesd204_rx_create axi_ad9371_rx_jesd $RX_NUM_OF_LANES
ad_ip_parameter axi_ad9371_rx_jesd/rx CONFIG.SYSREF_IOB {false}

ad_ip_instance util_cpack2 util_ad9371_rx_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
]

adi_tpl_jesd204_rx_create rx_ad9371_tpl_core $RX_NUM_OF_LANES \
                                             $RX_NUM_OF_CONVERTERS \
                                             $RX_SAMPLES_PER_FRAME \
                                             $RX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_ad9371_rx_dma
ad_ip_parameter axi_ad9371_rx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9371_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9371_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9371_rx_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9371_rx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9371_rx_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9371_rx_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_ad9371_rx_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_ad9371_rx_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_ad9371_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9371_rx_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $RX_SAMPLE_WIDTH * \
                                                                  $RX_NUM_OF_CONVERTERS * \
                                                                  $RX_SAMPLES_PER_CHANNEL]
ad_ip_parameter axi_ad9371_rx_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY

ad_add_decimation_filter "rx_fir_decimator" 8 $RX_NUM_OF_CONVERTERS 1 {122.88} {122.88} \
                         "$ad_hdl_dir/library/util_fir_int/coefile_int.coe"

# adc-os peripherals

ad_ip_instance axi_clkgen axi_ad9371_rx_os_clkgen
ad_ip_parameter axi_ad9371_rx_os_clkgen CONFIG.ID 2
ad_ip_parameter axi_ad9371_rx_os_clkgen CONFIG.CLKIN_PERIOD 8
ad_ip_parameter axi_ad9371_rx_os_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_ad9371_rx_os_clkgen CONFIG.VCO_MUL 8
ad_ip_parameter axi_ad9371_rx_os_clkgen CONFIG.CLK0_DIV 8

ad_ip_instance axi_adxcvr axi_ad9371_rx_os_xcvr
ad_ip_parameter axi_ad9371_rx_os_xcvr CONFIG.NUM_OF_LANES $RX_OS_NUM_OF_LANES
ad_ip_parameter axi_ad9371_rx_os_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9371_rx_os_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9371_rx_os_xcvr CONFIG.SYS_CLK_SEL 0
ad_ip_parameter axi_ad9371_rx_os_xcvr CONFIG.OUT_CLK_SEL 3
ad_ip_parameter axi_ad9371_rx_os_xcvr CONFIG.LPM_OR_DFE_N 1

adi_axi_jesd204_rx_create axi_ad9371_rx_os_jesd $RX_OS_NUM_OF_LANES
ad_ip_parameter axi_ad9371_rx_os_jesd/rx CONFIG.SYSREF_IOB {false}

ad_ip_instance util_cpack2 util_ad9371_rx_os_cpack [list \
  NUM_OF_CHANNELS $RX_OS_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_OS_SAMPLES_PER_CHANNEL\
  SAMPLE_DATA_WIDTH $RX_OS_SAMPLE_WIDTH \
]

adi_tpl_jesd204_rx_create rx_os_ad9371_tpl_core $RX_OS_NUM_OF_LANES \
                                                $RX_OS_NUM_OF_CONVERTERS \
                                                $RX_OS_SAMPLES_PER_FRAME \
                                                $RX_OS_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_ad9371_rx_os_dma
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $RX_OS_SAMPLE_WIDTH * \
                                                                     $RX_OS_NUM_OF_CONVERTERS * \
                                                                     $RX_OS_SAMPLES_PER_CHANNEL]
ad_ip_parameter axi_ad9371_rx_os_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY

# common cores

ad_ip_instance util_adxcvr util_ad9371_xcvr
ad_ip_parameter util_ad9371_xcvr CONFIG.RX_NUM_OF_LANES [expr $MAX_RX_NUM_OF_LANES+$MAX_RX_OS_NUM_OF_LANES]
ad_ip_parameter util_ad9371_xcvr CONFIG.TX_NUM_OF_LANES $MAX_TX_NUM_OF_LANES
ad_ip_parameter util_ad9371_xcvr CONFIG.TX_OUT_DIV 2
ad_ip_parameter util_ad9371_xcvr CONFIG.CPLL_FBDIV 4
ad_ip_parameter util_ad9371_xcvr CONFIG.RX_CLK25_DIV 5
ad_ip_parameter util_ad9371_xcvr CONFIG.TX_CLK25_DIV 5
ad_ip_parameter util_ad9371_xcvr CONFIG.RX_PMA_CFG 0x00018480
ad_ip_parameter util_ad9371_xcvr CONFIG.RX_CDR_CFG 0x03000023ff20400020
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_FBDIV 0x120

# xcvr interfaces

set tx_ref_clk     tx_ref_clk_0
set rx_ref_clk     rx_ref_clk_0
set rx_obs_ref_clk rx_ref_clk_$MAX_RX_NUM_OF_LANES

create_bd_port -dir I $tx_ref_clk
create_bd_port -dir I $rx_ref_clk
create_bd_port -dir I $rx_obs_ref_clk
ad_connect  $sys_cpu_resetn util_ad9371_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_ad9371_xcvr/up_clk

# Tx
ad_connect  ad9371_tx_device_clk axi_ad9371_tx_clkgen/clk_0
ad_xcvrcon  util_ad9371_xcvr axi_ad9371_tx_xcvr axi_ad9371_tx_jesd {1 2 3 0} ad9371_tx_device_clk {} $MAX_TX_NUM_OF_LANES
ad_connect  ref_clk axi_ad9371_tx_clkgen/clk
ad_xcvrpll  $tx_ref_clk util_ad9371_xcvr/qpll_ref_clk_0
ad_xcvrpll  axi_ad9371_tx_xcvr/up_pll_rst util_ad9371_xcvr/up_qpll_rst_0

# Rx
ad_connect  ad9371_rx_device_clk axi_ad9371_rx_clkgen/clk_0
ad_xcvrcon  util_ad9371_xcvr axi_ad9371_rx_xcvr axi_ad9371_rx_jesd {} ad9371_rx_device_clk {} $MAX_RX_NUM_OF_LANES
ad_connect  ref_clk axi_ad9371_rx_clkgen/clk
for {set i 0} {$i < $MAX_RX_NUM_OF_LANES} {incr i} {
  set ch [expr $i]
  ad_xcvrpll  $rx_ref_clk util_ad9371_xcvr/cpll_ref_clk_$ch
  ad_xcvrpll  axi_ad9371_rx_xcvr/up_pll_rst util_ad9371_xcvr/up_cpll_rst_$ch
}

# Rx - OBS
ad_connect  ad9371_rx_os_device_clk axi_ad9371_rx_os_clkgen/clk_0
ad_xcvrcon  util_ad9371_xcvr axi_ad9371_rx_os_xcvr axi_ad9371_rx_os_jesd {} ad9371_rx_os_device_clk {} $MAX_RX_OS_NUM_OF_LANES
ad_connect  ref_clk axi_ad9371_rx_os_clkgen/clk
for {set i 0} {$i < $MAX_RX_OS_NUM_OF_LANES} {incr i} {
  # channel indexing starts from the last RX
  set ch [expr $MAX_RX_NUM_OF_LANES + $i]
  ad_xcvrpll  $rx_obs_ref_clk util_ad9371_xcvr/cpll_ref_clk_$ch
  ad_xcvrpll  axi_ad9371_rx_os_xcvr/up_pll_rst util_ad9371_xcvr/up_cpll_rst_$ch
}

# dma clock & reset

ad_connect  $sys_dma_reset axi_ad9371_dacfifo/dma_rst

# connections (dac)

ad_connect  axi_ad9371_tx_clkgen/clk_0 tx_ad9371_tpl_core/link_clk
ad_connect  axi_ad9371_tx_jesd/tx_data tx_ad9371_tpl_core/link

ad_connect  axi_ad9371_tx_clkgen/clk_0 util_ad9371_tx_upack/clk
ad_connect  ad9371_tx_device_clk_rstgen/peripheral_reset util_ad9371_tx_upack/reset

ad_connect  axi_ad9371_tx_clkgen/clk_0 axi_ad9371_dacfifo/dac_clk
ad_connect  ad9371_tx_device_clk_rstgen/peripheral_reset axi_ad9371_dacfifo/dac_rst

ad_connect tx_fir_interpolator/aclk axi_ad9371_tx_clkgen/clk_0

for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  tx_ad9371_tpl_core/dac_enable_$i  tx_fir_interpolator/dac_enable_$i
  ad_connect  tx_ad9371_tpl_core/dac_valid_$i  tx_fir_interpolator/dac_valid_$i

  ad_connect  util_ad9371_tx_upack/fifo_rd_data_$i  tx_fir_interpolator/data_in_${i}
  ad_connect  util_ad9371_tx_upack/enable_$i  tx_fir_interpolator/enable_out_${i}

  ad_connect  tx_fir_interpolator/data_out_${i}  tx_ad9371_tpl_core/dac_data_$i
}

if {$TX_NUM_OF_CONVERTERS <= 2} {
  ad_connect  tx_fir_interpolator/valid_out_0  util_ad9371_tx_upack/fifo_rd_en
} else {
  ad_ip_instance util_vector_logic logic_or [list \
    C_OPERATION {or} \
    C_SIZE 1]

  ad_connect  logic_or/Op1  tx_fir_interpolator/valid_out_0
  ad_connect  logic_or/Op2  tx_fir_interpolator/valid_out_2
  ad_connect  logic_or/Res  util_ad9371_tx_upack/fifo_rd_en
}

ad_connect  tx_fir_interpolator/active dac_fir_filter_active

# TODO: Add streaming AXI interface for DAC FIFO
ad_connect  util_ad9371_tx_upack/s_axis_valid VCC
ad_connect  util_ad9371_tx_upack/s_axis_ready axi_ad9371_dacfifo/dac_valid
ad_connect  util_ad9371_tx_upack/s_axis_data axi_ad9371_dacfifo/dac_data

ad_connect  $sys_dma_clk axi_ad9371_dacfifo/dma_clk
ad_connect  $sys_dma_clk axi_ad9371_tx_dma/m_axis_aclk
ad_connect  axi_ad9371_dacfifo/dma_valid axi_ad9371_tx_dma/m_axis_valid
ad_connect  axi_ad9371_dacfifo/dma_data axi_ad9371_tx_dma/m_axis_data
ad_connect  axi_ad9371_dacfifo/dma_ready axi_ad9371_tx_dma/m_axis_ready
ad_connect  axi_ad9371_dacfifo/dma_xfer_req axi_ad9371_tx_dma/m_axis_xfer_req
ad_connect  axi_ad9371_dacfifo/dma_xfer_last axi_ad9371_tx_dma/m_axis_last
ad_connect  axi_ad9371_dacfifo/dac_dunf tx_ad9371_tpl_core/dac_dunf
ad_connect  axi_ad9371_dacfifo/bypass dac_fifo_bypass
ad_connect  $sys_dma_resetn axi_ad9371_tx_dma/m_src_axi_aresetn

# connections (adc)

ad_connect  axi_ad9371_rx_clkgen/clk_0 rx_ad9371_tpl_core/link_clk
ad_connect  axi_ad9371_rx_jesd/rx_sof rx_ad9371_tpl_core/link_sof
ad_connect  axi_ad9371_rx_jesd/rx_data_tdata rx_ad9371_tpl_core/link_data
ad_connect  axi_ad9371_rx_jesd/rx_data_tvalid rx_ad9371_tpl_core/link_valid
ad_connect  axi_ad9371_rx_clkgen/clk_0 util_ad9371_rx_cpack/clk
ad_connect  ad9371_rx_device_clk_rstgen/peripheral_reset util_ad9371_rx_cpack/reset

ad_connect rx_fir_decimator/aclk axi_ad9371_rx_clkgen/clk_0

for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_ad9371_tpl_core/adc_valid_$i rx_fir_decimator/valid_in_$i
  ad_connect  rx_ad9371_tpl_core/adc_enable_$i rx_fir_decimator/enable_in_$i
  ad_connect  rx_ad9371_tpl_core/adc_data_$i rx_fir_decimator/data_in_${i}

  ad_connect  rx_fir_decimator/enable_out_$i util_ad9371_rx_cpack/enable_$i
  ad_connect  rx_fir_decimator/data_out_${i} util_ad9371_rx_cpack/fifo_wr_data_$i
}

ad_connect  rx_fir_decimator/valid_out_0 util_ad9371_rx_cpack/fifo_wr_en
ad_connect  rx_ad9371_tpl_core/adc_dovf util_ad9371_rx_cpack/fifo_wr_overflow

ad_connect rx_fir_decimator/active adc_fir_filter_active

ad_connect  axi_ad9371_rx_clkgen/clk_0 axi_ad9371_rx_dma/fifo_wr_clk
ad_connect  util_ad9371_rx_cpack/packed_fifo_wr axi_ad9371_rx_dma/fifo_wr
ad_connect  util_ad9371_rx_cpack/packed_sync axi_ad9371_rx_dma/sync
ad_connect  $sys_dma_resetn axi_ad9371_rx_dma/m_dest_axi_aresetn

# connections (adc-os)

ad_connect  axi_ad9371_rx_os_clkgen/clk_0 rx_os_ad9371_tpl_core/link_clk
ad_connect  axi_ad9371_rx_os_jesd/rx_sof rx_os_ad9371_tpl_core/link_sof
ad_connect  axi_ad9371_rx_os_jesd/rx_data_tdata rx_os_ad9371_tpl_core/link_data
ad_connect  axi_ad9371_rx_os_jesd/rx_data_tvalid rx_os_ad9371_tpl_core/link_valid
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 util_ad9371_rx_os_cpack/clk
ad_connect  ad9371_rx_os_device_clk_rstgen/peripheral_reset util_ad9371_rx_os_cpack/reset
ad_connect  axi_ad9371_rx_os_clkgen/clk_0 axi_ad9371_rx_os_dma/fifo_wr_clk

ad_connect  rx_os_ad9371_tpl_core/adc_valid_0 util_ad9371_rx_os_cpack/fifo_wr_en
for {set i 0} {$i < $RX_OS_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_os_ad9371_tpl_core/adc_enable_$i util_ad9371_rx_os_cpack/enable_$i
  ad_connect  rx_os_ad9371_tpl_core/adc_data_$i util_ad9371_rx_os_cpack/fifo_wr_data_$i
}
ad_connect  rx_os_ad9371_tpl_core/adc_dovf util_ad9371_rx_os_cpack/fifo_wr_overflow
ad_connect  util_ad9371_rx_os_cpack/packed_fifo_wr axi_ad9371_rx_os_dma/fifo_wr
ad_connect  util_ad9371_rx_os_cpack/packed_sync axi_ad9371_rx_os_dma/sync

ad_connect  $sys_dma_resetn axi_ad9371_rx_os_dma/m_dest_axi_aresetn

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_ad9371_tpl_core
ad_cpu_interconnect 0x44A04000 tx_ad9371_tpl_core
ad_cpu_interconnect 0x44A08000 rx_os_ad9371_tpl_core
ad_cpu_interconnect 0x44A80000 axi_ad9371_tx_xcvr
ad_cpu_interconnect 0x43C00000 axi_ad9371_tx_clkgen
ad_cpu_interconnect 0x44A90000 axi_ad9371_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9371_tx_dma
ad_cpu_interconnect 0x44A60000 axi_ad9371_rx_xcvr
ad_cpu_interconnect 0x43C10000 axi_ad9371_rx_clkgen
ad_cpu_interconnect 0x44AA0000 axi_ad9371_rx_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9371_rx_dma
ad_cpu_interconnect 0x44A50000 axi_ad9371_rx_os_xcvr
ad_cpu_interconnect 0x43C20000 axi_ad9371_rx_os_clkgen
ad_cpu_interconnect 0x44AB0000 axi_ad9371_rx_os_jesd
ad_cpu_interconnect 0x7c440000 axi_ad9371_rx_os_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9371_rx_xcvr/m_axi
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9371_rx_os_xcvr/m_axi

# interconnect (mem/dac)

if {$CACHE_COHERENCY} {
  ad_mem_hpc1_interconnect $sys_dma_clk sys_ps8/S_AXI_HPC1
  ad_mem_hpc1_interconnect $sys_dma_clk axi_ad9371_tx_dma/m_src_axi
  ad_mem_hpc0_interconnect $sys_dma_clk sys_ps8/S_AXI_HPC0
  ad_mem_hpc0_interconnect $sys_dma_clk axi_ad9371_rx_dma/m_dest_axi
  ad_mem_hpc0_interconnect $sys_dma_clk axi_ad9371_rx_os_dma/m_dest_axi
} else {
  ad_mem_hp1_interconnect $sys_dma_clk sys_ps7/S_AXI_HP1
  ad_mem_hp1_interconnect $sys_dma_clk axi_ad9371_tx_dma/m_src_axi
  ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
  ad_mem_hp2_interconnect $sys_dma_clk axi_ad9371_rx_dma/m_dest_axi
  ad_mem_hp2_interconnect $sys_dma_clk axi_ad9371_rx_os_dma/m_dest_axi
}

# interrupts

ad_cpu_interrupt ps-8 mb-8 axi_ad9371_rx_os_jesd/irq
ad_cpu_interrupt ps-9 mb-7 axi_ad9371_tx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_ad9371_rx_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_ad9371_rx_os_dma/irq
ad_cpu_interrupt ps-12 mb-13- axi_ad9371_tx_dma/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9371_rx_dma/irq
