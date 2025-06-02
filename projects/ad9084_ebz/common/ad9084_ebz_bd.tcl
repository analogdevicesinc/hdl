###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

if {![info exists ADI_PHY_SEL]} {
  set ADI_PHY_SEL 1
}

source ../../../../hdl/projects/common/xilinx/data_offload_bd.tcl
source ../../../../hdl/library/jesd204/scripts/jesd204.tcl

# Common parameter for TX and RX
set JESD_MODE  $ad_project_params(JESD_MODE)
set RX_LANE_RATE $ad_project_params(RX_LANE_RATE)
set TX_LANE_RATE $ad_project_params(TX_LANE_RATE)

if {$ASYMMETRIC_A_B_MODE} {
  set RX_B_LANE_RATE $ad_project_params(RX_B_LANE_RATE)
  set TX_B_LANE_RATE $ad_project_params(TX_B_LANE_RATE)
}

set HSCI_ENABLE [ expr { [info exists ad_project_params(HSCI_ENABLE)] \
                          ? $ad_project_params(HSCI_ENABLE) : 1 } ]
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
  set NP12_DATAPATH_WIDTH 6
  set ENCODER_SEL 1
} else {
  set DATAPATH_WIDTH 8
  set NP12_DATAPATH_WIDTH 12
  set ENCODER_SEL 2
}

# These are max values specific to the board
set MAX_RX_LANES_PER_LINK 12
set MAX_TX_LANES_PER_LINK 12
set MAX_RX_LINKS [expr $ASYMMETRIC_A_B_MODE ? 1 : 2]
set MAX_TX_LINKS [expr $ASYMMETRIC_A_B_MODE ? 1 : 2]
set MAX_RX_LANES [expr $MAX_RX_LANES_PER_LINK*$MAX_RX_LINKS]
set MAX_TX_LANES [expr $MAX_TX_LANES_PER_LINK*$MAX_TX_LINKS]
set MAX_APOLLO_LANES 24

# RX parameters
set RX_NUM_LINKS $ad_project_params(RX_NUM_LINKS)
if {$ASYMMETRIC_A_B_MODE} {
  set RX_NUM_LINKS 1
}

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

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8* $RX_DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

# TX parameters
set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)
if {$ASYMMETRIC_A_B_MODE} {
  set TX_NUM_LINKS 1
}

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

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8* $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set adc_data_offload_name apollo_rx_data_offload
set adc_data_width [expr $RX_DMA_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]

set dac_data_offload_name apollo_tx_data_offload
set dac_data_width [expr $TX_DMA_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL]
set dac_dma_data_width $dac_data_width
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_DMA_SAMPLE_WIDTH))/log(2)))]

set num_quads_a [expr int(ceil(1.0 * $RX_NUM_OF_LANES / 4))]
set num_quads_b 0

if {$ASYMMETRIC_A_B_MODE} {
  # RX B Side JESD parameter per link
  set RX_B_JESD_M     $ad_project_params(RX_B_JESD_M)
  set RX_B_JESD_L     $ad_project_params(RX_B_JESD_L)
  set RX_B_JESD_S     $ad_project_params(RX_B_JESD_S)
  set RX_B_JESD_NP    $ad_project_params(RX_B_JESD_NP)

  set RX_B_NUM_OF_LANES      $RX_B_JESD_L
  set RX_B_NUM_OF_CONVERTERS $RX_B_JESD_M
  set RX_B_SAMPLES_PER_FRAME $RX_B_JESD_S
  set RX_B_SAMPLE_WIDTH      $RX_B_JESD_NP

  set RX_B_DMA_SAMPLE_WIDTH $RX_B_JESD_NP
  if {$RX_B_DMA_SAMPLE_WIDTH == 12} {
    set RX_B_DMA_SAMPLE_WIDTH 16
  }

  set RX_B_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_B_JESD_L $RX_B_JESD_M $RX_B_JESD_S $RX_B_JESD_NP]

  set RX_B_SAMPLES_PER_CHANNEL [expr $RX_B_NUM_OF_LANES * 8 * $RX_B_DATAPATH_WIDTH / ($RX_B_NUM_OF_CONVERTERS * $RX_B_SAMPLE_WIDTH)]

  # TX B Side JESD parameter per link
  set TX_B_JESD_M     $ad_project_params(TX_B_JESD_M)
  set TX_B_JESD_L     $ad_project_params(TX_B_JESD_L)
  set TX_B_JESD_S     $ad_project_params(TX_B_JESD_S)
  set TX_B_JESD_NP    $ad_project_params(TX_B_JESD_NP)

  set TX_B_NUM_OF_LANES      $TX_B_JESD_L
  set TX_B_NUM_OF_CONVERTERS $TX_B_JESD_M
  set TX_B_SAMPLES_PER_FRAME $TX_B_JESD_S
  set TX_B_SAMPLE_WIDTH      $TX_B_JESD_NP

  set TX_B_DMA_SAMPLE_WIDTH $TX_B_JESD_NP
  if {$TX_B_DMA_SAMPLE_WIDTH == 12} {
    set TX_B_DMA_SAMPLE_WIDTH 16
  }

  set TX_B_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_B_JESD_L $TX_B_JESD_M $TX_B_JESD_S $TX_B_JESD_NP]

  set TX_B_SAMPLES_PER_CHANNEL [expr $TX_B_NUM_OF_LANES * 8 * $TX_B_DATAPATH_WIDTH / ($TX_B_NUM_OF_CONVERTERS * $TX_B_SAMPLE_WIDTH)]

  set adc_b_data_offload_name apollo_rx_b_data_offload
  set adc_b_data_width [expr $RX_B_DMA_SAMPLE_WIDTH*$RX_B_NUM_OF_CONVERTERS*$RX_B_SAMPLES_PER_CHANNEL]
  set adc_b_dma_data_width $adc_b_data_width
  set adc_b_fifo_address_width [expr int(ceil(log(($adc_b_fifo_samples_per_converter*$RX_B_NUM_OF_CONVERTERS) / ($adc_b_data_width/$RX_B_DMA_SAMPLE_WIDTH))/log(2)))]

  set dac_b_data_offload_name apollo_tx_b_data_offload
  set dac_b_data_width [expr $TX_B_DMA_SAMPLE_WIDTH*$TX_B_NUM_OF_CONVERTERS*$TX_B_SAMPLES_PER_CHANNEL]
  set dac_b_dma_data_width $dac_b_data_width
  set dac_b_fifo_address_width [expr int(ceil(log(($dac_b_fifo_samples_per_converter*$TX_B_NUM_OF_CONVERTERS) / ($dac_b_data_width/$TX_B_DMA_SAMPLE_WIDTH))/log(2)))]

  set num_quads_b [expr int(ceil(1.0 * $RX_B_NUM_OF_LANES / 4))]
}

set num_quads [expr $num_quads_a + $num_quads_b]

create_bd_port -dir I rx_device_clk
create_bd_port -dir I tx_device_clk
create_bd_port -dir I rx_b_device_clk
create_bd_port -dir I tx_b_device_clk

##AXI_HSCI IP
if {$HSCI_ENABLE} {
  if {$ADI_PHY_SEL} {
    create_bd_port -dir O selectio_clk_in
    create_bd_port -dir O hsci_pll_reset
    create_bd_port -dir O -from 7 -to 0 hsci_menc_clk
    create_bd_port -dir O -from 7 -to 0 hsci_data_out
    create_bd_port -dir I -from 7 -to 0 hsci_data_in
    create_bd_port -dir I hsci_pclk
    create_bd_port -dir I hsci_rst_seq_done
    create_bd_port -dir I hsci_pll_locked
    create_bd_port -dir I hsci_vtc_rdy_bsc_tx
    create_bd_port -dir I hsci_dly_rdy_bsc_tx
    create_bd_port -dir I hsci_vtc_rdy_bsc_rx
    create_bd_port -dir I hsci_dly_rdy_bsc_rx

    ad_ip_instance axi_hsci axi_hsci_0
    ad_connect axi_hsci_0/hsci_miso_data hsci_data_in
    ad_connect axi_hsci_0/hsci_menc_clk hsci_menc_clk
    ad_connect axi_hsci_0/hsci_pclk hsci_pclk
    ad_connect axi_hsci_0/hsci_rst_seq_done hsci_rst_seq_done
    ad_connect axi_hsci_0/hsci_pll_locked hsci_pll_locked
    ad_connect axi_hsci_0/hsci_vtc_rdy_bsc_tx hsci_vtc_rdy_bsc_tx
    ad_connect axi_hsci_0/hsci_dly_rdy_bsc_tx hsci_dly_rdy_bsc_tx
    ad_connect axi_hsci_0/hsci_vtc_rdy_bsc_rx hsci_vtc_rdy_bsc_rx
    ad_connect axi_hsci_0/hsci_dly_rdy_bsc_rx hsci_dly_rdy_bsc_rx
    ad_connect hsci_data_out axi_hsci_0/hsci_mosi_data
    ad_connect hsci_pll_reset axi_hsci_0/hsci_pll_reset

    ad_ip_instance axi_clkgen axi_hsci_clkgen
    ad_ip_parameter axi_hsci_clkgen CONFIG.ID 1
    ad_ip_parameter axi_hsci_clkgen CONFIG.CLKIN_PERIOD 10
    ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_DIV 1
    ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_MUL 8
    ad_ip_parameter axi_hsci_clkgen CONFIG.CLK0_DIV 4

    ad_connect axi_ddr_cntrl/addn_ui_clkout1 axi_hsci_clkgen/clk
    ad_connect selectio_clk_in axi_hsci_clkgen/clk_0
  } else {
    source ../common/versal_hsci_phy.tcl
    create_hsci_phy hsci_phy $HSCI_BANKS

    ad_ip_instance axi_hsci axi_hsci_0

    create_bd_port -dir O intf_rdy
    create_bd_port -dir O fifo_empty
    create_bd_port -dir O data_out_p
    create_bd_port -dir O data_out_n
    create_bd_port -dir O clk_out_p
    create_bd_port -dir O clk_out_n
    create_bd_port -dir O -from 7 -to 0 data_to_fabric
    create_bd_port -dir O -from 7 -to 0 hsci_data_out

    create_bd_port -dir I fifo_rd_en
    create_bd_port -dir I data_in_p
    create_bd_port -dir I data_in_n
    create_bd_port -dir I clk_in_p
    create_bd_port -dir I clk_in_n
    create_bd_port -dir I -from 7 -to 0 hsci_data_in
    create_bd_port -dir I -from 7 -to 0 data_from_fabric

    ad_connect axi_hsci_0/hsci_miso_data hsci_data_in
    ad_connect hsci_data_out axi_hsci_0/hsci_mosi_data

    ad_connect hsci_phy/data_from_fabric_data_out data_from_fabric
    ad_connect hsci_phy/data_from_fabric_clk_out axi_hsci_0/hsci_menc_clk

    ad_connect hsci_phy/fifo_rd_en fifo_rd_en
    ad_connect hsci_phy/data_in_p data_in_p
    ad_connect hsci_phy/data_in_n data_in_n
    ad_connect hsci_phy/clk_in_p clk_in_p
    ad_connect hsci_phy/clk_in_n clk_in_n
    ad_connect hsci_phy/bank0_pll_clkout0 hsci_phy/fifo_rd_clk
    ad_connect hsci_phy/bank0_pll_clkout0 axi_hsci_0/hsci_pclk
    ad_connect hsci_phy/bank0_pll_clkout0 hsci_phy/ctrl_clk
    ad_connect hsci_phy/en_vtc VCC
    ad_connect hsci_phy/t_data_out GND
    ad_connect hsci_phy/t_clk_out GND

    ad_ip_instance xlconcat hsci_pll_locked_concat [list \
     NUM_PORTS ${HSCI_BANKS} \
    ]
    ad_connect hsci_pll_locked_concat/In0  hsci_phy/bank0_pll_locked
    if {$HSCI_BANKS > 1} {
      ad_connect hsci_pll_locked_concat/In1  hsci_phy/bank1_pll_locked
    }

    ad_connect hsci_pll_locked_concat/dout axi_hsci_0/hsci_pll_locked

    ad_connect hsci_phy/phy_rdy axi_hsci_0/hsci_vtc_rdy_bsc_tx
    ad_connect hsci_phy/dly_rdy axi_hsci_0/hsci_dly_rdy_bsc_tx
    ad_connect hsci_phy/phy_rdy axi_hsci_0/hsci_vtc_rdy_bsc_rx
    ad_connect hsci_phy/dly_rdy axi_hsci_0/hsci_dly_rdy_bsc_rx
    ad_connect hsci_phy/intf_rdy axi_hsci_0/hsci_rst_seq_done

    ad_connect intf_rdy   hsci_phy/intf_rdy
    ad_connect fifo_empty hsci_phy/fifo_empty
    ad_connect data_to_fabric hsci_phy/data_to_fabric_data_in
    ad_connect data_out_p hsci_phy/data_out_p
    ad_connect data_out_n hsci_phy/data_out_n
    ad_connect clk_out_p hsci_phy/clk_out_p
    ad_connect clk_out_n hsci_phy/clk_out_n

    ad_ip_instance axi_clkgen axi_hsci_clkgen
    ad_ip_parameter axi_hsci_clkgen CONFIG.ID 1
    ad_ip_parameter axi_hsci_clkgen CONFIG.CLKIN_PERIOD 10
    ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_DIV 1
    ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_MUL 30
    ad_ip_parameter axi_hsci_clkgen CONFIG.CLK0_DIV 15

    ad_connect $sys_cpu_clk axi_hsci_clkgen/clk
    ad_connect axi_hsci_0/hsci_pll_reset hsci_phy/rst
    for {set i 0} {$i < $HSCI_BANKS} {incr i} {
      ad_connect axi_hsci_clkgen/clk_0 hsci_phy/bank${i}_pll_clkin
      ad_connect axi_hsci_0/hsci_pll_reset hsci_phy/bank${i}_pll_rst_pll
    }
  }
}

# common xcvr
if {$ASYMMETRIC_A_B_MODE} {
  set MAX_RX_LANE_RATE [expr max($RX_LANE_RATE, $RX_B_LANE_RATE)]
  set MAX_TX_LANE_RATE [expr max($TX_LANE_RATE, $TX_B_LANE_RATE)]
} else {
  set MAX_RX_LANE_RATE $RX_LANE_RATE
  set MAX_TX_LANE_RATE $TX_LANE_RATE
}

if {$ADI_PHY_SEL} {
  ad_ip_instance util_adxcvr util_apollo_xcvr
  ad_ip_parameter util_apollo_xcvr CONFIG.CPLL_FBDIV_4_5 5
  ad_ip_parameter util_apollo_xcvr CONFIG.TX_NUM_OF_LANES $MAX_APOLLO_LANES
  ad_ip_parameter util_apollo_xcvr CONFIG.RX_NUM_OF_LANES $MAX_APOLLO_LANES
  ad_ip_parameter util_apollo_xcvr CONFIG.RX_OUT_DIV 1
  ad_ip_parameter util_apollo_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter util_apollo_xcvr CONFIG.RX_LANE_RATE $MAX_RX_LANE_RATE
  ad_ip_parameter util_apollo_xcvr CONFIG.TX_LANE_RATE $MAX_TX_LANE_RATE

  ad_ip_instance axi_adxcvr axi_apollo_rx_xcvr
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.ID 0
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.TX_OR_RX_N 0
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.QPLL_ENABLE 0
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.LPM_OR_DFE_N 1
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0

  ad_ip_instance axi_adxcvr axi_apollo_tx_xcvr
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.ID 0
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.TX_OR_RX_N 1
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.QPLL_ENABLE 1
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0
} else {
  source ../common/versal_transceiver.tcl

  # Reset gpios
  create_bd_port -dir O gt_powergood
  create_bd_port -dir I gt_reset
  create_bd_port -dir I gt_reset_rx_datapath
  create_bd_port -dir I gt_reset_rx_pll_and_datapath
  create_bd_port -dir I gt_reset_tx_datapath
  create_bd_port -dir I gt_reset_tx_pll_and_datapath
  create_bd_port -dir O rx_resetdone
  create_bd_port -dir O tx_resetdone

  create_bd_port -dir I gt_b_reset
  create_bd_port -dir I gt_b_reset_rx_datapath
  create_bd_port -dir I gt_b_reset_rx_pll_and_datapath
  create_bd_port -dir I gt_b_reset_tx_datapath
  create_bd_port -dir I gt_b_reset_tx_pll_and_datapath
  create_bd_port -dir O rx_b_resetdone
  create_bd_port -dir O tx_b_resetdone

  create_bd_port -dir I ref_clk_a
  create_bd_port -dir I ref_clk_b
  create_bd_port -dir I rx_sysref_0
  create_bd_port -dir I tx_sysref_0
  create_bd_port -dir I rx_sysref_12
  create_bd_port -dir I tx_sysref_12

  set REF_CLK_RATE $ad_project_params(REF_CLK_RATE)
  # instantiate versal phy
  create_versal_phy jesd204_phy $JESD_MODE $RX_NUM_OF_LANES $TX_NUM_OF_LANES $MAX_RX_LANE_RATE $MAX_TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE RXTX
  # reset generator
  ad_ip_instance proc_sys_reset rx_device_clk_rstgen
  ad_connect rx_device_clk rx_device_clk_rstgen/slowest_sync_clk
  ad_connect $sys_cpu_resetn rx_device_clk_rstgen/ext_reset_in

  ad_ip_instance proc_sys_reset tx_device_clk_rstgen
  ad_connect tx_device_clk tx_device_clk_rstgen/slowest_sync_clk
  ad_connect $sys_cpu_resetn tx_device_clk_rstgen/ext_reset_in

  ad_connect gt_reset jesd204_phy/gtreset_in
  ad_connect gt_reset_rx_datapath jesd204_phy/gtreset_rx_datapath
  ad_connect gt_reset_rx_pll_and_datapath jesd204_phy/gtreset_rx_pll_and_datapath
  ad_connect gt_reset_tx_datapath jesd204_phy/gtreset_tx_datapath
  ad_connect gt_reset_tx_pll_and_datapath jesd204_phy/gtreset_tx_pll_and_datapath
  ad_connect rx_resetdone jesd204_phy/rx_resetdone
  ad_connect tx_resetdone jesd204_phy/tx_resetdone

  # gt powergood
  ad_ip_instance xlconcat gt_powergood_concat [list \
   NUM_PORTS 2 \
  ]
  ad_ip_instance util_reduced_logic gt_powergood_and [list \
     C_SIZE $num_quads \
  ]
  ad_connect jesd204_phy/gtpowergood gt_powergood_concat/In0
  if {!$ASYMMETRIC_A_B_MODE} {
    ad_connect VCC gt_powergood_concat/In1
  }
  ad_connect gt_powergood_concat/dout gt_powergood_and/Op1
  ad_connect gt_powergood_and/Res gt_powergood
}

if {$ASYMMETRIC_A_B_MODE} {
  if ($ADI_PHY_SEL) {
    ad_ip_instance axi_adxcvr axi_apollo_rx_b_xcvr
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.ID 0
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.LINK_MODE $ENCODER_SEL
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.NUM_OF_LANES $RX_B_NUM_OF_LANES
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.TX_OR_RX_N 0
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.QPLL_ENABLE 0
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.LPM_OR_DFE_N 1
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.SYS_CLK_SEL 0x2 ; # QPLL1

    ad_ip_instance axi_adxcvr axi_apollo_tx_b_xcvr
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.ID 0
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.LINK_MODE $ENCODER_SEL
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.NUM_OF_LANES $TX_B_NUM_OF_LANES
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.TX_OR_RX_N 1
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.QPLL_ENABLE 1
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.SYS_CLK_SEL 0x2 ; # QPLL1
  } else {
    # instantiate versal phy
    create_versal_phy jesd204_phy_b $JESD_MODE $RX_B_NUM_OF_LANES $TX_B_NUM_OF_LANES $MAX_RX_LANE_RATE $MAX_TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE RXTX

    ad_connect gt_b_reset jesd204_phy_b/gtreset_in
    ad_connect gt_b_reset_rx_datapath jesd204_phy_b/gtreset_rx_datapath
    ad_connect gt_b_reset_rx_pll_and_datapath jesd204_phy_b/gtreset_rx_pll_and_datapath
    ad_connect gt_b_reset_tx_datapath jesd204_phy_b/gtreset_tx_datapath
    ad_connect gt_b_reset_tx_pll_and_datapath jesd204_phy_b/gtreset_tx_pll_and_datapath
    ad_connect rx_b_resetdone jesd204_phy_b/rx_resetdone
    ad_connect tx_b_resetdone jesd204_phy_b/tx_resetdone

    ad_connect jesd204_phy_b/gtpowergood gt_powergood_concat/In1
    # reset generator
    ad_ip_instance proc_sys_reset rx_b_device_clk_rstgen
    ad_connect rx_b_device_clk rx_b_device_clk_rstgen/slowest_sync_clk
    ad_connect $sys_cpu_resetn rx_b_device_clk_rstgen/ext_reset_in

    ad_ip_instance proc_sys_reset tx_b_device_clk_rstgen
    ad_connect tx_b_device_clk tx_b_device_clk_rstgen/slowest_sync_clk
    ad_connect $sys_cpu_resetn tx_b_device_clk_rstgen/ext_reset_in
  }
}

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
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_data_width
if {$ADI_PHY_SEL} {
  ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_DATA_WIDTH_DEST $adc_data_width
} else {
  # Versal limitation
  ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_DATA_WIDTH_DEST [expr min(512, $adc_data_width)]
}

if {$ASYMMETRIC_A_B_MODE} {
  adi_axi_jesd204_rx_create axi_apollo_rx_b_jesd $RX_B_NUM_OF_LANES $RX_NUM_LINKS $ENCODER_SEL
  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $RX_B_DATAPATH_WIDTH

  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.SYSREF_IOB false
  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.NUM_INPUT_PIPELINE 1

  adi_tpl_jesd204_rx_create rx_b_apollo_tpl_core $RX_B_NUM_OF_LANES \
                                                 $RX_B_NUM_OF_CONVERTERS \
                                                 $RX_B_SAMPLES_PER_FRAME \
                                                 $RX_B_SAMPLE_WIDTH \
                                                 $RX_B_DATAPATH_WIDTH \
                                                 $RX_B_DMA_SAMPLE_WIDTH

  ad_ip_instance util_cpack2 util_apollo_cpack_b [list \
    NUM_OF_CHANNELS $RX_B_NUM_OF_CONVERTERS \
    SAMPLES_PER_CHANNEL $RX_B_SAMPLES_PER_CHANNEL \
    SAMPLE_DATA_WIDTH $RX_B_DMA_SAMPLE_WIDTH \
  ]

  set adc_b_data_offload_size [expr $adc_b_data_width / 8 * 2**$adc_b_fifo_address_width]
  ad_data_offload_create $adc_b_data_offload_name \
                         0 \
                         $adc_do_mem_type \
                         $adc_b_data_offload_size \
                         $adc_b_data_width \
                         $adc_b_data_width \
                         $do_axi_data_width \
                         $SHARED_DEVCLK

  ad_ip_instance axi_dmac axi_apollo_rx_b_dma
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_TYPE_SRC 1
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_TYPE_DEST 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.ID 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.AXI_SLICE_SRC 1
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.AXI_SLICE_DEST 1
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.SYNC_TRANSFER_START 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_LENGTH_WIDTH 24
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.MAX_BYTES_PER_BURST 4096
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.CYCLIC 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_b_data_width
  if {$ADI_PHY_SEL} {
    ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_DATA_WIDTH_DEST $adc_b_data_width
  } else {
  # Versal limitation
    ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_DATA_WIDTH_DEST [expr min(512, $adc_b_data_width)]
  }
}

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
ad_ip_parameter axi_apollo_tx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096
if {$ADI_PHY_SEL} {
  ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_DATA_WIDTH_SRC $dac_data_width
} else {
  # Versal limitation
  ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_DATA_WIDTH_SRC [expr min(512, $dac_data_width)]
}
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_data_width

if {$ASYMMETRIC_A_B_MODE} {
  adi_axi_jesd204_tx_create axi_apollo_tx_b_jesd $TX_B_NUM_OF_LANES $TX_NUM_LINKS $ENCODER_SEL
  ad_ip_parameter axi_apollo_tx_b_jesd/tx CONFIG.TPL_DATA_PATH_WIDTH $TX_B_DATAPATH_WIDTH

  ad_ip_parameter axi_apollo_tx_b_jesd/tx CONFIG.SYSREF_IOB false
  #ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

  adi_tpl_jesd204_tx_create tx_b_apollo_tpl_core $TX_B_NUM_OF_LANES \
                                                 $TX_B_NUM_OF_CONVERTERS \
                                                 $TX_B_SAMPLES_PER_FRAME \
                                                 $TX_B_SAMPLE_WIDTH \
                                                 $TX_B_DATAPATH_WIDTH \
                                                 $TX_B_DMA_SAMPLE_WIDTH

  ad_ip_parameter tx_b_apollo_tpl_core/dac_tpl_core CONFIG.IQCORRECTION_DISABLE 0

  ad_ip_instance util_upack2 util_apollo_upack_b [list \
    NUM_OF_CHANNELS $TX_B_NUM_OF_CONVERTERS \
    SAMPLES_PER_CHANNEL $TX_B_SAMPLES_PER_CHANNEL \
    SAMPLE_DATA_WIDTH $TX_B_DMA_SAMPLE_WIDTH \
  ]

  set dac_b_data_offload_size [expr $dac_b_data_width / 8 * 2**$dac_b_fifo_address_width]
  ad_data_offload_create $dac_b_data_offload_name \
                         1 \
                         $dac_do_mem_type \
                         $dac_b_data_offload_size \
                         $dac_b_data_width \
                         $dac_b_data_width \
                         $do_axi_data_width \
                         $SHARED_DEVCLK

  ad_ip_instance axi_dmac axi_apollo_tx_b_dma
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_TYPE_SRC 0
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_TYPE_DEST 1
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.ID 0
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.AXI_SLICE_SRC 1
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.AXI_SLICE_DEST 1
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.SYNC_TRANSFER_START 0
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_LENGTH_WIDTH 24
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.CYCLIC 1
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.MAX_BYTES_PER_BURST 4096
  if {$ADI_PHY_SEL} {
    ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_DATA_WIDTH_SRC $dac_b_data_width
  } else {
    # Versal limitation
    ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_DATA_WIDTH_SRC [expr min(512, $dac_b_data_width)]
  }
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_b_data_width
}

# reference clocks & resets

if {$ADI_PHY_SEL} {
  for {set i 0} {$i < $MAX_APOLLO_LANES} {incr i} {
    set quad_index [expr int($i / 4)]
    if {[expr $i % 4] == 0} {
      create_bd_port -dir I ref_clk_q$quad_index
      ad_xcvrpll  ref_clk_q$quad_index  util_apollo_xcvr/qpll_ref_clk_$i
    }
    ad_xcvrpll  ref_clk_q$quad_index  util_apollo_xcvr/cpll_ref_clk_$i
  }

  for {set i 0} {$i < [expr max($MAX_TX_LANES,$MAX_RX_LANES)]} {incr i} {
    set j [expr $i + [expr max($MAX_TX_LANES,$MAX_RX_LANES)]]
    ad_xcvrpll  axi_apollo_tx_xcvr/up_pll_rst util_apollo_xcvr/up_qpll_rst_${i}
    ad_xcvrpll  axi_apollo_rx_xcvr/up_pll_rst util_apollo_xcvr/up_cpll_rst_${i}
    ad_xcvrpll  axi_apollo_tx_b_xcvr/up_pll_rst util_apollo_xcvr/up_qpll_rst_${j}
    ad_xcvrpll  axi_apollo_rx_b_xcvr/up_pll_rst util_apollo_xcvr/up_cpll_rst_${j}
  }

  ad_connect  $sys_cpu_resetn util_apollo_xcvr/up_rstn
  ad_connect  $sys_cpu_clk util_apollo_xcvr/up_clk
} else {
  ad_connect ref_clk_a jesd204_phy/GT_REFCLK

  for {set j 0} {$j < $RX_NUM_OF_LANES} {incr j} {
    ad_connect axi_apollo_rx_jesd/rx_phy${j} jesd204_phy/rx${j}
    ad_connect axi_apollo_tx_jesd/tx_phy${j} jesd204_phy/tx${j}
  }

  ad_connect jesd204_phy/rxusrclk_out /axi_apollo_rx_jesd/link_clk
  ad_connect rx_device_clk /axi_apollo_rx_jesd/device_clk

  ad_connect jesd204_phy/txusrclk_out /axi_apollo_tx_jesd/link_clk
  ad_connect tx_device_clk /axi_apollo_tx_jesd/device_clk

  ad_connect axi_apollo_rx_jesd/sysref rx_sysref_0
  ad_connect axi_apollo_tx_jesd/sysref tx_sysref_0

  ad_connect $sys_cpu_clk jesd204_phy/s_axi_clk
  ad_connect $sys_cpu_resetn jesd204_phy/s_axi_resetn

  create_bd_port -dir O -from [expr $RX_NUM_LINKS - 1] -to 0 rx_sync_0
  if {$JESD_MODE == "8B10B"} {
    ad_connect axi_apollo_rx_jesd/phy_en_char_align jesd204_phy/en_char_align
    ad_connect axi_apollo_rx_jesd/sync rx_sync_0
  } else {
    ad_connect GND jesd204_phy/en_char_align
  }
  create_bd_port -dir I -from [expr $TX_NUM_LINKS - 1] -to 0 tx_sync_0
  if {$JESD_MODE == "8B10B"} {
    ad_connect axi_apollo_tx_jesd/sync tx_sync_0
  }

  if ($ASYMMETRIC_A_B_MODE) {
    ad_connect ref_clk_b jesd204_phy_b/GT_REFCLK

    for {set j 0} {$j < $RX_B_NUM_OF_LANES} {incr j} {
      ad_connect axi_apollo_rx_b_jesd/rx_phy${j} jesd204_phy_b/rx${j}
      ad_connect axi_apollo_tx_b_jesd/tx_phy${j} jesd204_phy_b/tx${j}
    }

    ad_connect jesd204_phy_b/rxusrclk_out /axi_apollo_rx_b_jesd/link_clk
    ad_connect rx_b_device_clk /axi_apollo_rx_b_jesd/device_clk

    ad_connect jesd204_phy_b/txusrclk_out /axi_apollo_tx_b_jesd/link_clk
    ad_connect tx_b_device_clk /axi_apollo_tx_b_jesd/device_clk

    ad_connect axi_apollo_rx_b_jesd/sysref rx_sysref_12
    ad_connect axi_apollo_tx_b_jesd/sysref tx_sysref_12

    ad_connect $sys_cpu_clk jesd204_phy_b/s_axi_clk
    ad_connect $sys_cpu_resetn jesd204_phy_b/s_axi_resetn
    create_bd_port -dir O -from [expr $RX_NUM_LINKS - 1] -to 0 rx_sync_12
    if {$JESD_MODE == "8B10B"} {
    ad_connect axi_apollo_rx_b_jesd/phy_en_char_align jesd204_phy_b/en_char_align
    ad_connect axi_apollo_rx_b_jesd/sync rx_sync_12
    } else {
      ad_connect GND jesd204_phy_b/en_char_align
    }
    create_bd_port -dir I -from [expr $TX_NUM_LINKS - 1] -to 0 tx_sync_12
    if {$JESD_MODE == "8B10B"} {
      ad_connect axi_apollo_tx_b_jesd/sync tx_sync_0
    }
  }

  # Export serial interfaces
  for {set j 0} {$j < $num_quads} {incr j} {
    if {$j < $num_quads_a} {
      create_bd_port -dir I -from 3 -to 0 rx_${j}_p
      create_bd_port -dir I -from 3 -to 0 rx_${j}_n
      create_bd_port -dir O -from 3 -to 0 tx_${j}_p
      create_bd_port -dir O -from 3 -to 0 tx_${j}_n
      ad_connect rx_${j}_p jesd204_phy/rx_${j}_p
      ad_connect rx_${j}_n jesd204_phy/rx_${j}_n
      ad_connect tx_${j}_p jesd204_phy/tx_${j}_p
      ad_connect tx_${j}_n jesd204_phy/tx_${j}_n
    } else {
      set jj [expr $j - $num_quads_a]
      create_bd_port -dir I -from 3 -to 0 rx_${j}_p
      create_bd_port -dir I -from 3 -to 0 rx_${j}_n
      create_bd_port -dir O -from 3 -to 0 tx_${j}_p
      create_bd_port -dir O -from 3 -to 0 tx_${j}_n
      ad_connect rx_${j}_p jesd204_phy_b/rx_${jj}_p
      ad_connect rx_${j}_n jesd204_phy_b/rx_${jj}_n
      ad_connect tx_${j}_p jesd204_phy_b/tx_${jj}_p
      ad_connect tx_${j}_n jesd204_phy_b/tx_${jj}_n
    }
  }

  if {$num_quads < $MAX_NUMBER_OF_QUADS} {
    # Create dummy ports for non-existing lanes
    for {set j $num_quads} {$j < $MAX_NUMBER_OF_QUADS} {incr j} {
      create_bd_port -dir I -from 3 -to 0 rx_${j}_p
      create_bd_port -dir I -from 3 -to 0 rx_${j}_n
      create_bd_port -dir O -from 3 -to 0 tx_${j}_p
      create_bd_port -dir O -from 3 -to 0 tx_${j}_n
    }
    # for {set j $num_quads_b} {$j < 1} {incr j} {
    #   create_bd_port -dir I -from 3 -to 0 GT_Serial _${j}_0_grx_p
    #   create_bd_port -dir I -from 3 -to 0 GT_Serial_${j}_0_grx_n
    #   create_bd_port -dir O -from 3 -to 0 GT_Serial_${j}_0_gtx_p
    #   create_bd_port -dir O -from 3 -to 0 GT_Serial_${j}_0_gtx_n
    # }

    # for {set j $num_quads_a} {$j < 2} {incr j} {
    #   create_bd_port -dir I -from 3 -to 0 GT_Serial_A_${j}_0_grx_p
    #   create_bd_port -dir I -from 3 -to 0 GT_Serial_A_${j}_0_grx_n
    #   create_bd_port -dir O -from 3 -to 0 GT_Serial_A_${j}_0_gtx_p
    #   create_bd_port -dir O -from 3 -to 0 GT_Serial_A_${j}_0_gtx_n
    # }
  }
}

# connections (adc)
#  map the logical lane $n onto the physical lane  $lane_map[$n]
#         n     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
#  lane_map = {11  2  3  5 10  1  9  0  6  7  8  4 15 21 17 16 14 18 13 19 20 23 12 22}
#

if {$ASYMMETRIC_A_B_MODE} {
  if {$ADI_PHY_SEL} {
    # set lane_map {11 2 3 5 10 1 9 0 6 7 8 4}
    ad_xcvrcon  util_apollo_xcvr axi_apollo_rx_xcvr axi_apollo_rx_jesd {0 1 2 3 4 5 6 7 8 9 10 11} {} rx_device_clk $MAX_RX_LANES

    # set lane_map {15 21 17 16 14 18 13 19 20 23 12 22}
    ad_xcvrcon  util_apollo_xcvr axi_apollo_rx_b_xcvr axi_apollo_rx_b_jesd {12 13 14 15 16 17 18 19 20 21 22 23} {} rx_b_device_clk $MAX_RX_LANES
  }
} else {
  set max_lane_map {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23}
  # set lane_map {}

  # for {set i 0}  {$i < $RX_NUM_LINKS} {incr i} {
  #   for {set j 0}  {$j < $RX_JESD_L} {incr j} {
  #     set cur_lane [expr $i*$MAX_RX_LANES_PER_LINK+$j]
  #     lappend lane_map [lindex $max_lane_map $cur_lane]
  #   }
  # }
  if {$ADI_PHY_SEL} {
    ad_xcvrcon  util_apollo_xcvr axi_apollo_rx_xcvr axi_apollo_rx_jesd $max_lane_map {} rx_device_clk $MAX_RX_LANES
    create_bd_port -dir I rx_sysref_12
    create_bd_port -dir O rx_sync_12
  }
}

# connections (dac)
#  map the logical lane $n onto the physical lane  $lane_map[$n]
#         n     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
#  lane_map = {11  5 10  6  8  4  9  7  1  2  0  3 15 16 14 19 12 20 13 17 21 22 18 23}
#

if {$ASYMMETRIC_A_B_MODE} {
  if {$ADI_PHY_SEL} {
    # set lane_map {11 5 10 6 8 4 9 7 1 2 0 3}
    ad_xcvrcon  util_apollo_xcvr axi_apollo_tx_xcvr axi_apollo_tx_jesd {0 1 2 3 4 5 6 7 8 9 10 11} {} tx_device_clk $MAX_TX_LANES

    # set lane_map {15 16 14 19 12 20 13 17 21 22 18 23}
    ad_xcvrcon  util_apollo_xcvr axi_apollo_tx_b_xcvr axi_apollo_tx_b_jesd {12 13 14 15 16 17 18 19 20 21 22 23} {} tx_b_device_clk $MAX_TX_LANES
  }
} else {
  set max_lane_map {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23}
  # set lane_map {}

  # for {set i 0}  {$i < $TX_NUM_LINKS} {incr i} {
  #   for {set j 0}  {$j < $TX_JESD_L} {incr j} {
  #     set cur_lane [expr $i*$MAX_TX_LANES_PER_LINK+$j]
  #     lappend lane_map [lindex $max_lane_map $cur_lane]
  #   }
  # }
  if {$ADI_PHY_SEL} {
    ad_xcvrcon  util_apollo_xcvr axi_apollo_tx_xcvr axi_apollo_tx_jesd $max_lane_map {} tx_device_clk $MAX_TX_LANES
    create_bd_port -dir I tx_sysref_12
    create_bd_port -dir I tx_sync_12
  }
}

# device clock domain
ad_connect  rx_device_clk rx_apollo_tpl_core/link_clk
ad_connect  rx_device_clk util_apollo_cpack/clk
ad_connect  rx_device_clk $adc_data_offload_name/s_axis_aclk

ad_connect  tx_device_clk tx_apollo_tpl_core/link_clk
ad_connect  tx_device_clk util_apollo_upack/clk
ad_connect  tx_device_clk $dac_data_offload_name/m_axis_aclk

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  rx_b_device_clk rx_b_apollo_tpl_core/link_clk
  ad_connect  rx_b_device_clk util_apollo_cpack_b/clk
  ad_connect  rx_b_device_clk $adc_b_data_offload_name/s_axis_aclk

  ad_connect  tx_b_device_clk tx_b_apollo_tpl_core/link_clk
  ad_connect  tx_b_device_clk util_apollo_upack_b/clk
  ad_connect  tx_b_device_clk $dac_b_data_offload_name/m_axis_aclk
}

# Clocks
ad_connect  $sys_dma_clk $adc_data_offload_name/m_axis_aclk
ad_connect  $sys_dma_clk $dac_data_offload_name/s_axis_aclk

ad_connect  $sys_dma_clk axi_apollo_rx_dma/s_axis_aclk
ad_connect  $sys_dma_clk axi_apollo_tx_dma/m_axis_aclk
ad_connect  $sys_cpu_clk $dac_data_offload_name/s_axi_aclk
ad_connect  $sys_cpu_clk $adc_data_offload_name/s_axi_aclk

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  $sys_dma_clk $adc_b_data_offload_name/m_axis_aclk
  ad_connect  $sys_dma_clk $dac_b_data_offload_name/s_axis_aclk

  ad_connect  $sys_dma_clk axi_apollo_rx_b_dma/s_axis_aclk
  ad_connect  $sys_dma_clk axi_apollo_tx_b_dma/m_axis_aclk
  ad_connect  $sys_cpu_clk $dac_b_data_offload_name/s_axi_aclk
  ad_connect  $sys_cpu_clk $adc_b_data_offload_name/s_axi_aclk
}

# Resets
# create_bd_port -dir O rx_device_clk_rstn
# ad_connect rx_device_clk_rstn rx_device_clk_rstgen/peripheral_aresetn

ad_connect  rx_device_clk_rstgen/peripheral_aresetn $adc_data_offload_name/s_axis_aresetn
ad_connect  $sys_dma_resetn $adc_data_offload_name/m_axis_aresetn
ad_connect  tx_device_clk_rstgen/peripheral_aresetn $dac_data_offload_name/m_axis_aresetn
ad_connect  $sys_dma_resetn $dac_data_offload_name/s_axis_aresetn

ad_connect  $sys_dma_resetn axi_apollo_rx_dma/m_dest_axi_aresetn
ad_connect  $sys_dma_resetn axi_apollo_tx_dma/m_src_axi_aresetn
ad_connect  $sys_cpu_resetn $dac_data_offload_name/s_axi_aresetn
ad_connect  $sys_cpu_resetn $adc_data_offload_name/s_axi_aresetn

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  rx_b_device_clk_rstgen/peripheral_aresetn $adc_b_data_offload_name/s_axis_aresetn
  ad_connect  $sys_dma_resetn $adc_b_data_offload_name/m_axis_aresetn
  ad_connect  tx_b_device_clk_rstgen/peripheral_aresetn $dac_b_data_offload_name/m_axis_aresetn
  ad_connect  $sys_dma_resetn $dac_b_data_offload_name/s_axis_aresetn

  ad_connect  $sys_dma_resetn axi_apollo_rx_b_dma/m_dest_axi_aresetn
  ad_connect  $sys_dma_resetn axi_apollo_tx_b_dma/m_src_axi_aresetn
  ad_connect  $sys_cpu_resetn $dac_b_data_offload_name/s_axi_aresetn
  ad_connect  $sys_cpu_resetn $adc_b_data_offload_name/s_axi_aresetn
}

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

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  axi_apollo_rx_b_jesd/rx_sof rx_b_apollo_tpl_core/link_sof
  ad_connect  axi_apollo_rx_b_jesd/rx_data_tdata rx_b_apollo_tpl_core/link_data
  ad_connect  axi_apollo_rx_b_jesd/rx_data_tvalid rx_b_apollo_tpl_core/link_valid

  ad_connect rx_b_apollo_tpl_core/adc_valid_0 util_apollo_cpack_b/fifo_wr_en
  for {set i 0} {$i < $RX_B_NUM_OF_CONVERTERS} {incr i} {
    ad_connect  rx_b_apollo_tpl_core/adc_enable_$i util_apollo_cpack_b/enable_$i
    ad_connect  rx_b_apollo_tpl_core/adc_data_$i util_apollo_cpack_b/fifo_wr_data_$i
  }
  ad_connect rx_b_apollo_tpl_core/adc_dovf util_apollo_cpack_b/fifo_wr_overflow

  ad_connect  util_apollo_cpack_b/packed_fifo_wr_data $adc_b_data_offload_name/s_axis_tdata
  ad_connect  util_apollo_cpack_b/packed_fifo_wr_en $adc_b_data_offload_name/s_axis_tvalid
  ad_connect  $adc_b_data_offload_name/s_axis_tlast GND
  ad_connect  $adc_b_data_offload_name/s_axis_tkeep VCC

  ad_connect $adc_b_data_offload_name/m_axis axi_apollo_rx_b_dma/s_axis
}

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

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  tx_b_apollo_tpl_core/link axi_apollo_tx_b_jesd/tx_data

  ad_connect  tx_b_apollo_tpl_core/dac_valid_0 util_apollo_upack_b/fifo_rd_en
  for {set i 0} {$i < $TX_B_NUM_OF_CONVERTERS} {incr i} {
    ad_connect  util_apollo_upack_b/fifo_rd_data_$i tx_b_apollo_tpl_core/dac_data_$i
    ad_connect  tx_b_apollo_tpl_core/dac_enable_$i  util_apollo_upack_b/enable_$i
  }

  ad_connect $dac_b_data_offload_name/s_axis axi_apollo_tx_b_dma/m_axis

  ad_connect  util_apollo_upack_b/s_axis $dac_b_data_offload_name/m_axis

  ad_connect $dac_b_data_offload_name/init_req axi_apollo_tx_b_dma/m_axis_xfer_req
  ad_connect $adc_b_data_offload_name/init_req axi_apollo_rx_b_dma/s_axis_xfer_req
  ad_connect tx_b_apollo_tpl_core/dac_dunf GND
}

# interconnect (cpu)

if {$ADI_PHY_SEL} {
  ad_cpu_interconnect 0x44a60000 axi_apollo_rx_xcvr
  ad_cpu_interconnect 0x44b60000 axi_apollo_tx_xcvr
} else {
  # ad_cpu_interconnect 0x44a40000 jesd204_phy
}
ad_cpu_interconnect 0x44a10000 rx_apollo_tpl_core
ad_cpu_interconnect 0x44b10000 tx_apollo_tpl_core
ad_cpu_interconnect 0x44a90000 axi_apollo_rx_jesd
ad_cpu_interconnect 0x44b90000 axi_apollo_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_apollo_rx_dma
ad_cpu_interconnect 0x7c430000 axi_apollo_tx_dma
ad_cpu_interconnect 0x7c440000 $dac_data_offload_name
ad_cpu_interconnect 0x7c450000 $adc_data_offload_name
if {$HSCI_ENABLE} {
  ad_cpu_interconnect 0x44ad0000 axi_hsci_clkgen
  ad_cpu_interconnect 0x7c500000 axi_hsci_0
}
# Reserved for TDD! 0x7c460000

if {$ASYMMETRIC_A_B_MODE} {
  if {$ADI_PHY_SEL} {
    ad_cpu_interconnect 0x44aa0000 axi_apollo_rx_b_xcvr
    ad_cpu_interconnect 0x44ba0000 axi_apollo_tx_b_xcvr
  } else {
    # ad_cpu_interconnect 0x45a40000 jesd204_phy_b
  }
  ad_cpu_interconnect 0x44ab0000 rx_b_apollo_tpl_core
  ad_cpu_interconnect 0x44bb0000 tx_b_apollo_tpl_core
  ad_cpu_interconnect 0x44ac0000 axi_apollo_rx_b_jesd
  ad_cpu_interconnect 0x44bc0000 axi_apollo_tx_b_jesd
  ad_cpu_interconnect 0x7c470000 axi_apollo_rx_b_dma
  ad_cpu_interconnect 0x7c480000 axi_apollo_tx_b_dma
  ad_cpu_interconnect 0x7c490000 $dac_b_data_offload_name
  ad_cpu_interconnect 0x7c4a0000 $adc_b_data_offload_name
}

# interconnect (gt/adc)

if ${ADI_PHY_SEL} {
  ad_mem_hp0_interconnect $sys_cpu_clk axi_apollo_rx_xcvr/m_axi
}
ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk axi_apollo_rx_dma/m_dest_axi
ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_apollo_tx_dma/m_src_axi

if {$ASYMMETRIC_A_B_MODE} {
  if ${ADI_PHY_SEL} {
    ad_mem_hp0_interconnect $sys_cpu_clk axi_apollo_rx_b_xcvr/m_axi
  }
  ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
  ad_mem_hp1_interconnect $sys_dma_clk axi_apollo_rx_b_dma/m_dest_axi
  ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
  ad_mem_hp2_interconnect $sys_dma_clk axi_apollo_tx_b_dma/m_src_axi
}

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_apollo_rx_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_apollo_tx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_apollo_rx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_apollo_tx_jesd/irq

if {$ASYMMETRIC_A_B_MODE} {
  ad_cpu_interrupt ps-4 mb-5 axi_apollo_rx_b_dma/irq
  ad_cpu_interrupt ps-3 mb-6 axi_apollo_tx_b_dma/irq
  ad_cpu_interrupt ps-2 mb-7 axi_apollo_rx_b_jesd/irq
  ad_cpu_interrupt ps-1 mb-8 axi_apollo_tx_b_jesd/irq
}

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

if {$ASYMMETRIC_A_B_MODE == 0} {
  ad_connect manual_sync_or/Res tx_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_in
  ad_connect manual_sync_or/Res rx_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_in
} else {
  # Enable ADC B side external sync
  ad_ip_parameter rx_b_apollo_tpl_core/adc_tpl_core CONFIG.EXT_SYNC 1
  ad_connect ext_sync_in rx_b_apollo_tpl_core/adc_tpl_core/adc_sync_in

  # Enable DAC B side external sync
  ad_ip_parameter tx_b_apollo_tpl_core/dac_tpl_core CONFIG.EXT_SYNC 1
  ad_connect ext_sync_in tx_b_apollo_tpl_core/dac_tpl_core/dac_sync_in

  ad_ip_instance util_vector_logic manual_sync_or_b [list \
    C_SIZE 1 \
    C_OPERATION {or} \
  ]

  ad_connect rx_b_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_out manual_sync_or_b/Op1
  ad_connect tx_b_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_out manual_sync_or_b/Op2

  ad_ip_instance util_vector_logic manual_sync_or_res [list \
    C_SIZE 1 \
    C_OPERATION {or} \
  ]

  ad_connect manual_sync_or/Res manual_sync_or_res/Op1
  ad_connect manual_sync_or_b/Res manual_sync_or_res/Op2

  ad_connect manual_sync_or_res/Res tx_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_in
  ad_connect manual_sync_or_res/Res rx_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_in
  ad_connect manual_sync_or_res/Res tx_b_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_in
  ad_connect manual_sync_or_res/Res rx_b_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_in
}

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

if {$ASYMMETRIC_A_B_MODE} {
  ad_ip_instance util_reduced_logic cpack_b_rst_logic
  ad_ip_parameter cpack_b_rst_logic config.c_operation {or}
  ad_ip_parameter cpack_b_rst_logic config.c_size {3}

  ad_ip_instance  util_vector_logic rx_b_do_rstout_logic
  ad_ip_parameter rx_b_do_rstout_logic config.c_operation {not}
  ad_ip_parameter rx_b_do_rstout_logic config.c_size {1}

  ad_connect $adc_b_data_offload_name/s_axis_tready rx_b_do_rstout_logic/Op1

  ad_ip_instance xlconcat cpack_b_reset_sources
  ad_ip_parameter cpack_b_reset_sources config.num_ports {3}
  ad_connect rx_b_device_clk_rstgen/peripheral_reset cpack_b_reset_sources/in0
  ad_connect rx_b_apollo_tpl_core/adc_tpl_core/adc_rst cpack_b_reset_sources/in1
  ad_connect rx_b_do_rstout_logic/res cpack_b_reset_sources/in2

  ad_connect cpack_b_reset_sources/dout cpack_b_rst_logic/op1
  ad_connect cpack_b_rst_logic/res util_apollo_cpack_b/reset
}

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

if {$ASYMMETRIC_A_B_MODE} {
  ad_ip_instance util_reduced_logic upack_b_rst_logic
  ad_ip_parameter upack_b_rst_logic config.c_operation {or}
  ad_ip_parameter upack_b_rst_logic config.c_size {2}

  ad_ip_instance xlconcat upack_b_reset_sources
  ad_ip_parameter upack_b_reset_sources config.num_ports {2}
  ad_connect tx_b_device_clk_rstgen/peripheral_reset upack_b_reset_sources/in0
  ad_connect tx_b_apollo_tpl_core/dac_tpl_core/dac_rst upack_b_reset_sources/in1

  ad_connect upack_b_reset_sources/dout upack_b_rst_logic/op1
  ad_connect upack_b_rst_logic/res util_apollo_upack_b/reset
}

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

  if {$ASYMMETRIC_A_B_MODE} {
    ad_connect GND $dac_b_data_offload_name/sync_ext
    ad_connect GND $adc_b_data_offload_name/sync_ext
  }
}