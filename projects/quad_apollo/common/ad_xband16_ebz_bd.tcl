source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# Common parameter for TX and RX
set JESD_MODE  $ad_project_params(JESD_MODE)
set RX_LANE_RATE $ad_project_params(RX_LANE_RATE)
set TX_LANE_RATE $ad_project_params(TX_LANE_RATE)

set HSCI_BYPASS [ expr { [info exists ad_project_params(HSCI_BYPASS)] \
                          ? $ad_project_params(HSCI_BYPASS) : 0 } ]
set TDD_SUPPORT [ expr { [info exists ad_project_params(TDD_SUPPORT)] \
                          ? $ad_project_params(TDD_SUPPORT) : 0 } ]
set SHARED_DEVCLK [ expr { [info exists ad_project_params(SHARED_DEVCLK)] \
                            ? $ad_project_params(SHARED_DEVCLK) : 0 } ]

if {$TDD_SUPPORT && !$SHARED_DEVCLK} {
  error "ERROR: Cannot enable TDD support without shared deviceclocks!"
}

set adc_do_mem_type [ expr { [info exists ad_project_params(ADC_DO_MEM_TYPE)] \
                          ? $ad_project_params(ADC_DO_MEM_TYPE) : 0 } ]
set dac_do_mem_type [ expr { [info exists ad_project_params(DAC_DO_MEM_TYPE)] \
                          ? $ad_project_params(DAC_DO_MEM_TYPE) : 0 } ]

set do_axi_data_width [ expr { [info exists do_axi_data_width] \
                          ? $do_axi_data_width : 256 } ]

if {$JESD_MODE == "8B10B"} {
  set DATAPATH_WIDTH 4
  set ENCODER_SEL 1
} else {
  set DATAPATH_WIDTH 8
  set ENCODER_SEL 2
}

# These are max values specific to the board
set MAX_RX_LANES_PER_LINK 4
set MAX_TX_LANES_PER_LINK 4
set MAX_RX_LINKS 4
set MAX_TX_LINKS 4
set MAX_RX_LANES [expr $MAX_RX_LANES_PER_LINK*$MAX_RX_LINKS]
set MAX_TX_LANES [expr $MAX_TX_LANES_PER_LINK*$MAX_TX_LINKS]

# RX parameters
set RX_NUM_LINKS $ad_project_params(RX_NUM_LINKS)

# RX JESD parameter per link
set RX_JESD_M     $ad_project_params(RX_JESD_M)
set RX_JESD_L     $ad_project_params(RX_JESD_L)
set RX_JESD_S     $ad_project_params(RX_JESD_S)
set RX_JESD_NP    $ad_project_params(RX_JESD_NP)

set RX_NUM_OF_LANES      [expr $RX_JESD_L * $RX_NUM_LINKS]
set RX_NUM_OF_CONVERTERS [expr $RX_JESD_M * $RX_NUM_LINKS]
set RX_SAMPLES_PER_FRAME $RX_JESD_S
set RX_SAMPLE_WIDTH      $RX_JESD_NP

set RX_DMA_SAMPLE_WIDTH $RX_JESD_NP
if {$RX_DMA_SAMPLE_WIDTH == 12} {
  set RX_DMA_SAMPLE_WIDTH 16
}

set RX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_JESD_L $RX_JESD_M $RX_JESD_S $RX_JESD_NP]

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8 * $RX_DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

# TX parameters
set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)

# TX JESD parameter per link
set TX_JESD_M     $ad_project_params(TX_JESD_M)
set TX_JESD_L     $ad_project_params(TX_JESD_L)
set TX_JESD_S     $ad_project_params(TX_JESD_S)
set TX_JESD_NP    $ad_project_params(TX_JESD_NP)

set TX_NUM_OF_LANES      [expr $TX_JESD_L * $TX_NUM_LINKS]
set TX_NUM_OF_CONVERTERS [expr $TX_JESD_M * $TX_NUM_LINKS]
set TX_SAMPLES_PER_FRAME $TX_JESD_S
set TX_SAMPLE_WIDTH      $TX_JESD_NP

set TX_DMA_SAMPLE_WIDTH $TX_JESD_NP
if {$TX_DMA_SAMPLE_WIDTH == 12} {
  set TX_DMA_SAMPLE_WIDTH 16
}

set TX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_JESD_L $TX_JESD_M $TX_JESD_S $TX_JESD_NP]

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8 * $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set adc_data_offload_name apollo_rx_data_offload
set adc_data_width [expr $RX_DMA_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]

set dac_data_offload_name apollo_tx_data_offload
set dac_data_width [expr $TX_DMA_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL]
set dac_dma_data_width $dac_data_width
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_DMA_SAMPLE_WIDTH))/log(2)))]

create_bd_port -dir I rx_device_clk
create_bd_port -dir I tx_device_clk

##AXI_ADF4030 IP
create_bd_port -dir IO adf4030_bsync_p
create_bd_port -dir IO adf4030_bsync_n
create_bd_port -dir I adf4030_clk
create_bd_port -dir I adf4030_trigger
create_bd_port -dir O adf4030_sysref
create_bd_port -dir O -from 3 -to 0 adf4030_trig_channel

ad_ip_instance axi_adf4030 axi_adf4030_0
ad_ip_parameter axi_adf4030_0 CONFIG.CHANNEL_COUNT 4

ad_connect axi_adf4030_0/bsync_p adf4030_bsync_p
ad_connect axi_adf4030_0/bsync_n adf4030_bsync_n
ad_connect axi_adf4030_0/device_clk adf4030_clk
ad_connect axi_adf4030_0/trigger adf4030_trigger
ad_connect axi_adf4030_0/sysref adf4030_sysref
ad_connect axi_adf4030_0/trig_channel adf4030_trig_channel

##AXI_HSCI IP
if {!$HSCI_BYPASS} {
  for {set i 0} {$i < 2} {incr i} {
    create_bd_port -dir O hsci_pll_reset_$i
    create_bd_port -dir I hsci_pclk_$i
    create_bd_port -dir I hsci_rst_seq_done_$i
    create_bd_port -dir I hsci_pll_locked_$i
  }

  for {set i 0} {$i < 4} {incr i} {
    set j [expr $i > 1 ? 1 : 0]

    create_bd_port -dir O -from 7 -to 0 hsci_menc_clk_$i
    create_bd_port -dir O -from 7 -to 0 hsci_data_out_$i
    create_bd_port -dir I -from 7 -to 0 hsci_data_in_$i

    create_bd_port -dir I hsci_vtc_rdy_bsc_tx_$i
    create_bd_port -dir I hsci_dly_rdy_bsc_tx_$i
    create_bd_port -dir I hsci_vtc_rdy_bsc_rx_$i
    create_bd_port -dir I hsci_dly_rdy_bsc_rx_$i

    ad_ip_instance axi_hsci axi_hsci_$i
    ad_connect axi_hsci_${i}/hsci_miso_data hsci_data_in_$i
    ad_connect axi_hsci_${i}/hsci_menc_clk hsci_menc_clk_$i
    ad_connect axi_hsci_${i}/hsci_pclk hsci_pclk_$j
    ad_connect axi_hsci_${i}/hsci_rst_seq_done hsci_rst_seq_done_$j
    ad_connect axi_hsci_${i}/hsci_pll_locked hsci_pll_locked_$j
    ad_connect axi_hsci_${i}/hsci_vtc_rdy_bsc_tx hsci_vtc_rdy_bsc_tx_$i
    ad_connect axi_hsci_${i}/hsci_dly_rdy_bsc_tx hsci_dly_rdy_bsc_tx_$i
    ad_connect axi_hsci_${i}/hsci_vtc_rdy_bsc_rx hsci_vtc_rdy_bsc_rx_$i
    ad_connect axi_hsci_${i}/hsci_dly_rdy_bsc_rx hsci_dly_rdy_bsc_rx_$i
    ad_connect hsci_data_out_$i axi_hsci_${i}/hsci_mosi_data
  }

  ad_ip_instance  util_vector_logic hsci_pll_reset_logic_0
  ad_ip_parameter hsci_pll_reset_logic_0 config.c_operation {and}
  ad_ip_parameter hsci_pll_reset_logic_0 config.c_size {1}

  ad_connect axi_hsci_0/hsci_pll_reset hsci_pll_reset_logic_0/Op1
  ad_connect axi_hsci_1/hsci_pll_reset hsci_pll_reset_logic_0/Op2
  ad_connect hsci_pll_reset_logic_0/Res hsci_pll_reset_0

  ad_ip_instance  util_vector_logic hsci_pll_reset_logic_1
  ad_ip_parameter hsci_pll_reset_logic_1 config.c_operation {and}
  ad_ip_parameter hsci_pll_reset_logic_1 config.c_size {1}

  ad_connect axi_hsci_2/hsci_pll_reset hsci_pll_reset_logic_1/Op1
  ad_connect axi_hsci_3/hsci_pll_reset hsci_pll_reset_logic_1/Op2
  ad_connect hsci_pll_reset_logic_1/Res hsci_pll_reset_1

  ad_ip_instance axi_clkgen axi_hsci_clkgen
  ad_ip_parameter axi_hsci_clkgen CONFIG.ID 1
  ad_ip_parameter axi_hsci_clkgen CONFIG.CLKIN_PERIOD 10
  ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_DIV 1
  ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_MUL 8
  ad_ip_parameter axi_hsci_clkgen CONFIG.CLK0_DIV 4

  create_bd_port -dir O selectio_clk_in

  ad_connect axi_ddr_cntrl/addn_ui_clkout1 axi_hsci_clkgen/clk
  ad_connect selectio_clk_in axi_hsci_clkgen/clk_0
}

# common xcvr

ad_ip_instance util_adxcvr util_apollo_xcvr
ad_ip_parameter util_apollo_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_apollo_xcvr CONFIG.TX_NUM_OF_LANES $MAX_TX_LANES
ad_ip_parameter util_apollo_xcvr CONFIG.RX_NUM_OF_LANES $MAX_RX_LANES
ad_ip_parameter util_apollo_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_apollo_xcvr CONFIG.LINK_MODE $ENCODER_SEL
ad_ip_parameter util_apollo_xcvr CONFIG.RX_LANE_RATE $RX_LANE_RATE
ad_ip_parameter util_apollo_xcvr CONFIG.TX_LANE_RATE $TX_LANE_RATE

ad_ip_instance axi_adxcvr axi_apollo_rx_xcvr
ad_ip_parameter axi_apollo_rx_xcvr CONFIG.ID 0
ad_ip_parameter axi_apollo_rx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
ad_ip_parameter axi_apollo_rx_xcvr CONFIG.NUM_OF_LANES $MAX_RX_LANES
ad_ip_parameter axi_apollo_rx_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_apollo_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_apollo_rx_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_apollo_rx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0

ad_ip_instance axi_adxcvr axi_apollo_tx_xcvr
ad_ip_parameter axi_apollo_tx_xcvr CONFIG.ID 0
ad_ip_parameter axi_apollo_tx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
ad_ip_parameter axi_apollo_tx_xcvr CONFIG.NUM_OF_LANES $MAX_TX_LANES
ad_ip_parameter axi_apollo_tx_xcvr CONFIG.TX_OR_RX_N 1
ad_ip_parameter axi_apollo_tx_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_apollo_tx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0

# adc peripherals

adi_axi_jesd204_rx_create axi_apollo_rx_jesd $RX_NUM_OF_LANES $RX_NUM_LINKS $ENCODER_SEL
ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $RX_DATAPATH_WIDTH

ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 1

adi_tpl_jesd204_rx_create rx_apollo_tpl_core $RX_NUM_OF_LANES \
                                           $RX_NUM_OF_CONVERTERS \
                                           $RX_SAMPLES_PER_FRAME \
                                           $RX_SAMPLE_WIDTH \
                                           $RX_DATAPATH_WIDTH \
                                           $RX_DMA_SAMPLE_WIDTH

ad_ip_instance util_cpack2 util_apollo_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_DMA_SAMPLE_WIDTH \
]

set adc_data_offload_size [expr $adc_data_width / 8 * 2**$adc_fifo_address_width]
ad_data_offload_create $adc_data_offload_name \
                       0 \
                       $adc_do_mem_type \
                       $adc_data_offload_size \
                       $adc_data_width \
                       $adc_data_width \
                       $do_axi_data_width \
                       $SHARED_DEVCLK

ad_ip_instance axi_dmac axi_apollo_rx_dma
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.ID 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_apollo_rx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_apollo_rx_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_apollo_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 512

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

# dac peripherals

adi_axi_jesd204_tx_create axi_apollo_tx_jesd $TX_NUM_OF_LANES $TX_NUM_LINKS $ENCODER_SEL
ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.TPL_DATA_PATH_WIDTH $TX_DATAPATH_WIDTH

ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.SYSREF_IOB false
#ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

adi_tpl_jesd204_tx_create tx_apollo_tpl_core $TX_NUM_OF_LANES \
                                           $TX_NUM_OF_CONVERTERS \
                                           $TX_SAMPLES_PER_FRAME \
                                           $TX_SAMPLE_WIDTH \
                                           $TX_DATAPATH_WIDTH \
                                           $TX_DMA_SAMPLE_WIDTH

ad_ip_parameter tx_apollo_tpl_core/dac_tpl_core CONFIG.IQCORRECTION_DISABLE 0

ad_ip_instance util_upack2 util_apollo_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_DMA_SAMPLE_WIDTH \
]

set dac_data_offload_size [expr $dac_data_width / 8 * 2**$dac_fifo_address_width]
ad_data_offload_create $dac_data_offload_name \
                       1 \
                       $dac_do_mem_type \
                       $dac_data_offload_size \
                       $dac_data_width \
                       $dac_data_width \
                       $do_axi_data_width \
                       $SHARED_DEVCLK

ad_ip_instance axi_dmac axi_apollo_tx_dma
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.ID 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 512
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_dma_data_width

# reference clocks & resets

for {set i 0} {$i < [expr max($MAX_TX_LANES,$MAX_RX_LANES)]} {incr i} {
  set quad_index [expr int($i / 4)]
  if {[expr $i % 4] == 0} {
    create_bd_port -dir I ref_clk_q$quad_index
    ad_xcvrpll  ref_clk_q$quad_index  util_apollo_xcvr/qpll_ref_clk_$i
  }
  ad_xcvrpll  ref_clk_q$quad_index  util_apollo_xcvr/cpll_ref_clk_$i
}

ad_xcvrpll  axi_apollo_tx_xcvr/up_pll_rst util_apollo_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_apollo_rx_xcvr/up_pll_rst util_apollo_xcvr/up_cpll_rst_*

ad_connect  $sys_cpu_resetn util_apollo_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_apollo_xcvr/up_clk

# connections (adc)
set max_lane_map {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
set lane_map {}

for {set i 0}  {$i < $RX_NUM_LINKS} {incr i} {
  for {set j 0}  {$j < $RX_JESD_L} {incr j} {
    set cur_lane [expr $i*$MAX_RX_LANES_PER_LINK+$j]
    lappend lane_map $cur_lane
  }
}
ad_xcvrcon  util_apollo_xcvr axi_apollo_rx_xcvr axi_apollo_rx_jesd $max_lane_map {} rx_device_clk $MAX_RX_LANES $lane_map

# connections (dac)
set lane_map {}

for {set i 0}  {$i < $TX_NUM_LINKS} {incr i} {
  for {set j 0}  {$j < $TX_JESD_L} {incr j} {
    set cur_lane [expr $i*$MAX_TX_LANES_PER_LINK+$j]
    lappend lane_map $cur_lane
  }
}
ad_xcvrcon  util_apollo_xcvr axi_apollo_tx_xcvr axi_apollo_tx_jesd $max_lane_map {} tx_device_clk $MAX_TX_LANES $lane_map

# device clock domain
ad_connect  rx_device_clk rx_apollo_tpl_core/link_clk
ad_connect  rx_device_clk util_apollo_cpack/clk
ad_connect  rx_device_clk $adc_data_offload_name/s_axis_aclk

ad_connect  tx_device_clk tx_apollo_tpl_core/link_clk
ad_connect  tx_device_clk util_apollo_upack/clk
ad_connect  tx_device_clk $dac_data_offload_name/m_axis_aclk

# Clocks
ad_connect  $sys_dma_clk $adc_data_offload_name/m_axis_aclk
ad_connect  $sys_dma_clk $dac_data_offload_name/s_axis_aclk

ad_connect  $sys_dma_clk axi_apollo_rx_dma/s_axis_aclk
ad_connect  $sys_dma_clk axi_apollo_tx_dma/m_axis_aclk
ad_connect  $sys_cpu_clk $dac_data_offload_name/s_axi_aclk
ad_connect  $sys_cpu_clk $adc_data_offload_name/s_axi_aclk

# Resets
# create_bd_port -dir O rx_device_clk_rstn
ad_connect axi_adf4030_0/rstn rx_device_clk_rstgen/peripheral_aresetn

ad_connect  rx_device_clk_rstgen/peripheral_aresetn $adc_data_offload_name/s_axis_aresetn
ad_connect  $sys_dma_resetn $adc_data_offload_name/m_axis_aresetn
ad_connect  tx_device_clk_rstgen/peripheral_aresetn $dac_data_offload_name/m_axis_aresetn
ad_connect  $sys_dma_resetn $dac_data_offload_name/s_axis_aresetn

ad_connect  $sys_dma_resetn axi_apollo_rx_dma/m_dest_axi_aresetn
ad_connect  $sys_dma_resetn axi_apollo_tx_dma/m_src_axi_aresetn
ad_connect  $sys_cpu_resetn $dac_data_offload_name/s_axi_aresetn
ad_connect  $sys_cpu_resetn $adc_data_offload_name/s_axi_aresetn

#
# connect adc dataflow
#
# Connect Link Layer to Transport Layer
#
ad_connect  axi_apollo_rx_jesd/rx_sof rx_apollo_tpl_core/link_sof
ad_connect  axi_apollo_rx_jesd/rx_data_tdata rx_apollo_tpl_core/link_data
ad_connect  axi_apollo_rx_jesd/rx_data_tvalid rx_apollo_tpl_core/link_valid

ad_connect rx_apollo_tpl_core/adc_valid_0 util_apollo_cpack/fifo_wr_en
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_apollo_tpl_core/adc_enable_$i util_apollo_cpack/enable_$i
  ad_connect  rx_apollo_tpl_core/adc_data_$i util_apollo_cpack/fifo_wr_data_$i
}
ad_connect rx_apollo_tpl_core/adc_dovf util_apollo_cpack/fifo_wr_overflow

ad_connect  util_apollo_cpack/packed_fifo_wr_data $adc_data_offload_name/s_axis_tdata
ad_connect  util_apollo_cpack/packed_fifo_wr_en $adc_data_offload_name/s_axis_tvalid
ad_connect  $adc_data_offload_name/s_axis_tlast GND
ad_connect  $adc_data_offload_name/s_axis_tkeep VCC

ad_connect $adc_data_offload_name/m_axis axi_apollo_rx_dma/s_axis

# connect dac dataflow
#

# Connect Link Layer to Transport Layer
#
ad_connect  tx_apollo_tpl_core/link axi_apollo_tx_jesd/tx_data

ad_connect  tx_apollo_tpl_core/dac_valid_0 util_apollo_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  util_apollo_upack/fifo_rd_data_$i tx_apollo_tpl_core/dac_data_$i
  ad_connect  tx_apollo_tpl_core/dac_enable_$i  util_apollo_upack/enable_$i
}

ad_connect $dac_data_offload_name/s_axis axi_apollo_tx_dma/m_axis

ad_connect  util_apollo_upack/s_axis $dac_data_offload_name/m_axis

ad_connect $dac_data_offload_name/init_req axi_apollo_tx_dma/m_axis_xfer_req
ad_connect $adc_data_offload_name/init_req axi_apollo_rx_dma/s_axis_xfer_req
ad_connect tx_apollo_tpl_core/dac_dunf GND

# extra GPIOs

ad_connect gpio2_i axi_gpio_2/gpio_io_i
ad_connect gpio2_o axi_gpio_2/gpio_io_o
ad_connect gpio2_t axi_gpio_2/gpio_io_t
ad_connect gpio3_i axi_gpio_2/gpio2_io_i
ad_connect gpio3_o axi_gpio_2/gpio2_io_o
ad_connect gpio3_t axi_gpio_2/gpio2_io_t

# interconnect (cpu)

ad_cpu_interconnect 0x44a60000 axi_apollo_rx_xcvr
ad_cpu_interconnect 0x44b60000 axi_apollo_tx_xcvr
ad_cpu_interconnect 0x44a10000 rx_apollo_tpl_core
ad_cpu_interconnect 0x44b10000 tx_apollo_tpl_core
ad_cpu_interconnect 0x44a90000 axi_apollo_rx_jesd
ad_cpu_interconnect 0x44b90000 axi_apollo_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_apollo_rx_dma
ad_cpu_interconnect 0x7c430000 axi_apollo_tx_dma
ad_cpu_interconnect 0x7c440000 $dac_data_offload_name
ad_cpu_interconnect 0x7c450000 $adc_data_offload_name
ad_cpu_interconnect 0x7c470000 axi_gpio_2
if {!$HSCI_BYPASS} {
  ad_cpu_interconnect 0x44ad0000 axi_hsci_clkgen
  ad_cpu_interconnect 0x7c500000 axi_hsci_0
  ad_cpu_interconnect 0x7c600000 axi_hsci_1
  ad_cpu_interconnect 0x7c700000 axi_hsci_2
  ad_cpu_interconnect 0x7c800000 axi_hsci_3
}
ad_cpu_interconnect 0x7c900000 axi_adf4030_0
# Reserved for TDD! 0x7c460000

# interconnect (gt/adc)

ad_mem_hp0_interconnect $sys_cpu_clk axi_apollo_rx_xcvr/m_axi
ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk axi_apollo_rx_dma/m_dest_axi
ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_apollo_tx_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_apollo_rx_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_apollo_tx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_apollo_rx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_apollo_tx_jesd/irq
ad_cpu_interrupt ps-14 mb-8  axi_gpio_2/ip2intc_irpt

#
# Sync at TPL level 
#

create_bd_port -dir I ext_sync_in

# Enable ADC external sync
ad_ip_parameter rx_apollo_tpl_core/adc_tpl_core CONFIG.EXT_SYNC 1
ad_connect ext_sync_in rx_apollo_tpl_core/adc_tpl_core/adc_sync_in

# Enable DAC external sync
ad_ip_parameter tx_apollo_tpl_core/dac_tpl_core CONFIG.EXT_SYNC 1
ad_connect ext_sync_in tx_apollo_tpl_core/dac_tpl_core/dac_sync_in

ad_ip_instance util_vector_logic manual_sync_or [list \
  C_SIZE 1 \
  C_OPERATION {or} \
]

ad_connect rx_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_out manual_sync_or/Op1
ad_connect tx_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_out manual_sync_or/Op2

ad_connect manual_sync_or/Res tx_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_in
ad_connect manual_sync_or/Res rx_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_in

# Reset pack cores
ad_ip_instance util_reduced_logic cpack_rst_logic
ad_ip_parameter cpack_rst_logic config.c_operation {or}
ad_ip_parameter cpack_rst_logic config.c_size {3}

ad_ip_instance  util_vector_logic rx_do_rstout_logic
ad_ip_parameter rx_do_rstout_logic config.c_operation {not}
ad_ip_parameter rx_do_rstout_logic config.c_size {1}

ad_connect $adc_data_offload_name/s_axis_tready rx_do_rstout_logic/Op1

ad_ip_instance xlconcat cpack_reset_sources
ad_ip_parameter cpack_reset_sources config.num_ports {3}
ad_connect rx_device_clk_rstgen/peripheral_reset cpack_reset_sources/in0
ad_connect rx_apollo_tpl_core/adc_tpl_core/adc_rst cpack_reset_sources/in1
ad_connect rx_do_rstout_logic/res cpack_reset_sources/in2

ad_connect cpack_reset_sources/dout cpack_rst_logic/op1
ad_connect cpack_rst_logic/res util_apollo_cpack/reset

# Reset unpack cores
ad_ip_instance util_reduced_logic upack_rst_logic
ad_ip_parameter upack_rst_logic config.c_operation {or}
ad_ip_parameter upack_rst_logic config.c_size {2}

ad_ip_instance xlconcat upack_reset_sources
ad_ip_parameter upack_reset_sources config.num_ports {2}
ad_connect tx_device_clk_rstgen/peripheral_reset upack_reset_sources/in0
ad_connect tx_apollo_tpl_core/dac_tpl_core/dac_rst upack_reset_sources/in1

ad_connect upack_reset_sources/dout upack_rst_logic/op1
ad_connect upack_rst_logic/res util_apollo_upack/reset

if {$TDD_SUPPORT} {
  ad_ip_instance util_tdd_sync tdd_sync_0
  ad_connect tx_device_clk tdd_sync_0/clk
  ad_connect tx_device_clk_rstgen/peripheral_aresetn tdd_sync_0/rstn
  ad_connect tdd_sync_0/sync_in GND
  ad_connect tdd_sync_0/sync_mode GND
  ad_ip_parameter tdd_sync_0 CONFIG.TDD_SYNC_PERIOD 250000000; # More or less 1 PPS ;)

  ad_ip_instance axi_tdd axi_tdd_0 [list ASYNC_TDD_SYNC 0]
  ad_connect tx_device_clk axi_tdd_0/clk
  ad_connect tx_device_clk_rstgen/peripheral_reset axi_tdd_0/rst
  ad_connect $sys_cpu_clk axi_tdd_0/s_axi_aclk
  ad_connect $sys_cpu_resetn axi_tdd_0/s_axi_aresetn
  ad_cpu_interconnect 0x7c460000 axi_tdd_0

  ad_connect tdd_sync_0/sync_out axi_tdd_0/tdd_sync

  delete_bd_objs [get_bd_nets apollo_adc_fifo_dma_wr]

  ad_connect axi_tdd_0/tdd_tx_valid $dac_data_offload_name/sync_ext
  ad_connect axi_tdd_0/tdd_rx_valid $adc_data_offload_name/sync_ext

} else {
  ad_connect GND $dac_data_offload_name/sync_ext
  ad_connect GND $adc_data_offload_name/sync_ext
}
