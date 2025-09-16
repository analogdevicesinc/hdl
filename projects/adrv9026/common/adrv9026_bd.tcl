###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl

set ORX_ENABLE $ad_project_params(ORX_ENABLE)      ; # 0 = Disabled ; 1 = Enabled

set JESD_MODE  $ad_project_params(JESD_MODE)
set TX_LANE_RATE $ad_project_params(TX_LANE_RATE)
set RX_LANE_RATE $ad_project_params(RX_LANE_RATE)

set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)
set RX_NUM_LINKS $ad_project_params(RX_NUM_LINKS)
set RX_OS_NUM_LINKS $ad_project_params(RX_OS_NUM_LINKS)

set TX_JESD_L  $ad_project_params(TX_JESD_L)
set TX_JESD_M  $ad_project_params(TX_JESD_M)
set TX_JESD_NP $ad_project_params(TX_JESD_NP)

set RX_JESD_L  $ad_project_params(RX_JESD_L)
set RX_JESD_M  $ad_project_params(RX_JESD_M)
set RX_JESD_NP $ad_project_params(RX_JESD_NP)

set RX_OS_JESD_L  $ad_project_params(RX_OS_JESD_L)
set RX_OS_JESD_M  $ad_project_params(RX_OS_JESD_M)
set RX_OS_JESD_NP $ad_project_params(RX_OS_JESD_NP)

if {$JESD_MODE == "8B10B"} {
  set DATAPATH_WIDTH 4
  set NP12_DATAPATH_WIDTH 6
  set ENCODER_SEL 1
} else {
  set DATAPATH_WIDTH 8
  set NP12_DATAPATH_WIDTH 12
  set ENCODER_SEL 2
}

# TX parameters
set TX_NUM_OF_LANES [expr $TX_JESD_L * $TX_NUM_LINKS]      ; # L
set TX_NUM_OF_CONVERTERS [expr $TX_JESD_M * $TX_NUM_LINKS] ; # M
set TX_SAMPLES_PER_FRAME $ad_project_params(TX_JESD_S)     ; # S
set TX_SAMPLE_WIDTH $TX_JESD_NP                            ; # N/NP

set TX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_NUM_OF_LANES $TX_NUM_OF_CONVERTERS $TX_SAMPLES_PER_FRAME $TX_SAMPLE_WIDTH]
set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8 * $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

# RX parameters
set RX_NUM_OF_LANES [expr $RX_JESD_L * $RX_NUM_LINKS]      ; # L
set RX_NUM_OF_CONVERTERS [expr $RX_JESD_M * $RX_NUM_LINKS] ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S)     ; # S
set RX_SAMPLE_WIDTH $RX_JESD_NP                            ; # N/NP

set RX_OCTETS_PER_FRAME [expr $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_FRAME * $RX_SAMPLE_WIDTH / (8 * $RX_NUM_OF_LANES)] ; # F
set RX_DATAPATH_WIDTH [expr max(4, $RX_OCTETS_PER_FRAME)] ; #max(4, F)
set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8 * $RX_DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 8 * RX_DATAPATH_WIDTH / (M* N)

set adc_dma_data_width [expr $RX_NUM_OF_LANES * 8 * $RX_DATAPATH_WIDTH]

# RX-OBS parameters
set RX_OS_NUM_OF_LANES [expr $RX_OS_JESD_L * $RX_OS_NUM_LINKS]      ; # L
set RX_OS_NUM_OF_CONVERTERS [expr $RX_OS_JESD_M * $RX_OS_NUM_LINKS] ; # M
set RX_OS_SAMPLES_PER_FRAME $ad_project_params(RX_OS_JESD_S)        ; # S
set RX_OS_SAMPLE_WIDTH $RX_OS_JESD_NP                               ; # N/NP

if {$ORX_ENABLE} {
  set RX_OS_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_OS_NUM_OF_LANES $RX_OS_NUM_OF_CONVERTERS $RX_OS_SAMPLES_PER_FRAME $RX_OS_SAMPLE_WIDTH]
  set RX_OS_SAMPLES_PER_CHANNEL [expr $RX_OS_NUM_OF_LANES * 8 * $RX_OS_DATAPATH_WIDTH / ($RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLE_WIDTH)]
}

set dac_offload_name adrv9026_data_offload
set dac_data_width [expr $TX_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_CHANNEL]

set MAX_RX_NUM_OF_LANES [expr $ORX_ENABLE ? [expr $RX_NUM_OF_LANES + $RX_OS_NUM_OF_LANES] : $RX_NUM_OF_LANES]

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl

# adrv9026

create_bd_port -dir I core_clk
create_bd_port -dir O rx_os_sync
create_bd_port -dir I rx_os_sysref

# dac peripherals
ad_ip_instance axi_clkgen axi_adrv9026_tx_clkgen
ad_ip_parameter axi_adrv9026_tx_clkgen CONFIG.ID 2
ad_ip_parameter axi_adrv9026_tx_clkgen CONFIG.CLKIN_PERIOD 4
ad_ip_parameter axi_adrv9026_tx_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_adrv9026_tx_clkgen CONFIG.VCO_MUL 4
ad_ip_parameter axi_adrv9026_tx_clkgen CONFIG.CLK0_DIV 4

ad_ip_instance axi_adxcvr axi_adrv9026_tx_xcvr
ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.TX_OR_RX_N 1
ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.SYS_CLK_SEL 3
ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.OUT_CLK_SEL 3

adi_axi_jesd204_tx_create axi_adrv9026_tx_jesd $TX_NUM_OF_LANES $TX_NUM_LINKS $ENCODER_SEL
ad_ip_parameter axi_adrv9026_tx_jesd/tx CONFIG.TPL_DATA_PATH_WIDTH $TX_DATAPATH_WIDTH

ad_ip_instance util_upack2 util_adrv9026_tx_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

adi_tpl_jesd204_tx_create tx_adrv9026_tpl_core $TX_NUM_OF_LANES \
                                               $TX_NUM_OF_CONVERTERS \
                                               $TX_SAMPLES_PER_FRAME \
                                               $TX_SAMPLE_WIDTH \
                                               $TX_DATAPATH_WIDTH \
                                               $TX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_adrv9026_tx_dma
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.AXI_SLICE_DEST {true}
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.AXI_SLICE_SRC {true}
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_data_width
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY

ad_data_offload_create $dac_offload_name \
                       1 \
                       $dac_offload_type \
                       $dac_offload_size \
                       $dac_data_width \
                       $dac_data_width

ad_ip_parameter $dac_offload_name/i_data_offload CONFIG.SYNC_EXT_ADD_INTERNAL_CDC 0
ad_connect $dac_offload_name/sync_ext GND

# adc peripherals
ad_ip_instance axi_clkgen axi_adrv9026_rx_clkgen
ad_ip_parameter axi_adrv9026_rx_clkgen CONFIG.ID 2
ad_ip_parameter axi_adrv9026_rx_clkgen CONFIG.CLKIN_PERIOD 4
ad_ip_parameter axi_adrv9026_rx_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_adrv9026_rx_clkgen CONFIG.VCO_MUL 4
ad_ip_parameter axi_adrv9026_rx_clkgen CONFIG.CLK0_DIV 4

ad_ip_instance axi_adxcvr axi_adrv9026_rx_xcvr
ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.SYS_CLK_SEL 0
ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.OUT_CLK_SEL 3

adi_axi_jesd204_rx_create axi_adrv9026_rx_jesd $RX_NUM_OF_LANES $RX_NUM_LINKS $ENCODER_SEL
ad_ip_parameter axi_adrv9026_rx_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $RX_DATAPATH_WIDTH

ad_ip_instance util_cpack2 util_adrv9026_rx_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
  ]

adi_tpl_jesd204_rx_create rx_adrv9026_tpl_core $RX_NUM_OF_LANES \
                                               $RX_NUM_OF_CONVERTERS \
                                               $RX_SAMPLES_PER_FRAME \
                                               $RX_SAMPLE_WIDTH \
                                               $RX_DATAPATH_WIDTH \
                                               $RX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_adrv9026_rx_dma
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY

if {$ORX_ENABLE} {
  # adc-obs peripherals
  ad_ip_instance axi_clkgen axi_adrv9026_rx_os_clkgen
  ad_ip_parameter axi_adrv9026_rx_os_clkgen CONFIG.ID 2
  ad_ip_parameter axi_adrv9026_rx_os_clkgen CONFIG.CLKIN_PERIOD 4
  ad_ip_parameter axi_adrv9026_rx_os_clkgen CONFIG.VCO_DIV 1
  ad_ip_parameter axi_adrv9026_rx_os_clkgen CONFIG.VCO_MUL 4
  ad_ip_parameter axi_adrv9026_rx_os_clkgen CONFIG.CLK0_DIV 4

  ad_ip_instance axi_adxcvr axi_adrv9026_rx_os_xcvr
  ad_ip_parameter axi_adrv9026_rx_os_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter axi_adrv9026_rx_os_xcvr CONFIG.NUM_OF_LANES $RX_OS_NUM_OF_LANES
  ad_ip_parameter axi_adrv9026_rx_os_xcvr CONFIG.QPLL_ENABLE 0
  ad_ip_parameter axi_adrv9026_rx_os_xcvr CONFIG.TX_OR_RX_N 0
  ad_ip_parameter axi_adrv9026_rx_os_xcvr CONFIG.SYS_CLK_SEL 0
  ad_ip_parameter axi_adrv9026_rx_os_xcvr CONFIG.OUT_CLK_SEL 3

  adi_axi_jesd204_rx_create axi_adrv9026_rx_os_jesd $RX_OS_NUM_OF_LANES $RX_OS_NUM_LINKS $ENCODER_SEL
  ad_ip_parameter axi_adrv9026_rx_os_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $RX_OS_DATAPATH_WIDTH

  ad_ip_instance util_cpack2 util_adrv9026_rx_os_cpack [list \
    NUM_OF_CHANNELS $RX_OS_NUM_OF_CONVERTERS \
    SAMPLES_PER_CHANNEL $RX_OS_SAMPLES_PER_CHANNEL \
    SAMPLE_DATA_WIDTH $RX_OS_SAMPLE_WIDTH \
    ]

  adi_tpl_jesd204_rx_create rx_os_adrv9026_tpl_core $RX_OS_NUM_OF_LANES \
                                                 $RX_OS_NUM_OF_CONVERTERS \
                                                 $RX_OS_SAMPLES_PER_FRAME \
                                                 $RX_OS_SAMPLE_WIDTH \
                                                 $RX_OS_DATAPATH_WIDTH \
                                                 $RX_OS_SAMPLE_WIDTH

  ad_ip_instance axi_dmac axi_adrv9026_rx_os_dma
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.DMA_TYPE_SRC 2
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.DMA_TYPE_DEST 0
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.CYCLIC 0
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.SYNC_TRANSFER_START 1
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $RX_OS_SAMPLE_WIDTH * $RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLES_PER_CHANNEL];
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.MAX_BYTES_PER_BURST 4096
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.DMA_DATA_WIDTH_DEST 128
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.FIFO_SIZE 32
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY
}

# common cores
ad_ip_instance util_adxcvr util_adrv9026_xcvr
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_NUM_OF_LANES $MAX_RX_NUM_OF_LANES
ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter util_adrv9026_xcvr CONFIG.LINK_MODE $ENCODER_SEL
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_LANE_RATE $RX_LANE_RATE
ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_LANE_RATE $TX_LANE_RATE
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_CDR_CFG 0x0b000023ff10400020
ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_LANE_INVERT 6
ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_LANE_INVERT 15

if {$JESD_MODE == "8B10B"} {
  ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_FBDIV 4
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_CLK25_DIV 10
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_CLK25_DIV 10
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_PMA_CFG 0x001E7080
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_FBDIV 40
} else {
  ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_FBDIV 2
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_CLK25_DIV 20
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_CLK25_DIV 20
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_PMA_CFG 0x280A
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_FBDIV 33
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_REFCLK_DIV 1
  ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_CFG0 0x1FA
  ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_CFG1 0x23
  ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_CFG2 0x2
  ad_ip_parameter util_adrv9026_xcvr CONFIG.A_TXDIFFCTRL 0xC
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG0 0x3
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG2_GEN2 0x269
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG2_GEN4 0x164
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG3 0x12
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG3_GEN3 0x12
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
  ad_ip_parameter util_adrv9026_xcvr CONFIG.CH_HSPMUX 0x6868
  ad_ip_parameter util_adrv9026_xcvr CONFIG.PREIQ_FREQ_BST 1
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXPI_CFG0 0x4
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXPI_CFG1 0x0
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TXPI_CFG 0x0
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_PI_BIASSET 3
  ad_ip_parameter util_adrv9026_xcvr CONFIG.POR_CFG 0x0
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CFG0 0x333C
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CFG4 0x45
  ad_ip_parameter util_adrv9026_xcvr CONFIG.PPF0_CFG 0xF00
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CP 0xFF
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_CP_G3 0xF
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_LPF 0x31D
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXDFE_KH_CFG2 {0x2631}
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RXDFE_KH_CFG3 {0x411C}
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_WIDEMODE_CDR {"01"}
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_XMODE_SEL {"0"}
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TXPI_CFG0 {0x0000}
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TXPI_CFG1 {0x0000}
}

# xcvr interfaces

set tx_ref_clk         tx_ref_clk_0
set rx_ref_clk         rx_ref_clk_0
set rx_obs_ref_clk     rx_os_ref_clk_0

create_bd_port -dir I $tx_ref_clk
create_bd_port -dir I $rx_ref_clk
create_bd_port -dir I $rx_obs_ref_clk

ad_connect  $sys_cpu_resetn util_adrv9026_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_adrv9026_xcvr/up_clk

# Tx
ad_connect adrv9026_tx_device_clk axi_adrv9026_tx_clkgen/clk_0
ad_connect core_clk axi_adrv9026_tx_clkgen/clk

ad_xcvrcon util_adrv9026_xcvr axi_adrv9026_tx_xcvr axi_adrv9026_tx_jesd {3 2 0 1} {} adrv9026_tx_device_clk $TX_NUM_OF_LANES
ad_xcvrpll $tx_ref_clk util_adrv9026_xcvr/qpll_ref_clk_0
ad_xcvrpll axi_adrv9026_tx_xcvr/up_pll_rst util_adrv9026_xcvr/up_qpll_rst_0

# Rx
ad_connect adrv9026_rx_device_clk axi_adrv9026_rx_clkgen/clk_0
ad_connect core_clk axi_adrv9026_rx_clkgen/clk

ad_xcvrcon  util_adrv9026_xcvr axi_adrv9026_rx_xcvr axi_adrv9026_rx_jesd {} {} adrv9026_rx_device_clk $RX_NUM_OF_LANES

for {set i 0} {$i < $RX_NUM_OF_LANES} {incr i} {
  set ch [expr $i]
  ad_xcvrpll  $rx_ref_clk util_adrv9026_xcvr/cpll_ref_clk_$ch
  ad_xcvrpll  axi_adrv9026_rx_xcvr/up_pll_rst util_adrv9026_xcvr/up_cpll_rst_$ch
}

if {$ORX_ENABLE} {
# Rx - OBS
  ad_connect adrv9026_rx_os_device_clk axi_adrv9026_rx_os_clkgen/clk_0
  ad_connect core_clk axi_adrv9026_rx_os_clkgen/clk
  ad_xcvrcon  util_adrv9026_xcvr axi_adrv9026_rx_os_xcvr axi_adrv9026_rx_os_jesd {} {} adrv9026_rx_os_device_clk $RX_OS_NUM_OF_LANES
  for {set i 0} {$i < $RX_OS_NUM_OF_LANES} {incr i} {
    set ch [expr $RX_NUM_OF_LANES + $i]
    ad_xcvrpll  $rx_obs_ref_clk util_adrv9026_xcvr/cpll_ref_clk_$ch
    ad_xcvrpll  axi_adrv9026_rx_os_xcvr/up_pll_rst util_adrv9026_xcvr/up_cpll_rst_$ch
  }

  delete_bd_objs [get_bd_ports rx_sync_$RX_NUM_OF_LANES]
  delete_bd_objs [get_bd_ports rx_sysref_$RX_NUM_OF_LANES]
  ad_connect rx_os_sync axi_adrv9026_rx_os_jesd_sync
  ad_connect rx_os_sysref sysref_3
}

# connections (dac)
ad_connect  adrv9026_tx_device_clk tx_adrv9026_tpl_core/link_clk
ad_connect  axi_adrv9026_tx_jesd/tx_data tx_adrv9026_tpl_core/link

ad_connect  adrv9026_tx_device_clk util_adrv9026_tx_upack/clk
ad_connect  adrv9026_tx_device_clk_rstgen/peripheral_reset util_adrv9026_tx_upack/reset

for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  tx_adrv9026_tpl_core/dac_enable_$i util_adrv9026_tx_upack/enable_$i
  ad_connect  util_adrv9026_tx_upack/fifo_rd_data_$i tx_adrv9026_tpl_core/dac_data_$i
}

ad_connect  tx_adrv9026_tpl_core/dac_valid_0  util_adrv9026_tx_upack/fifo_rd_en
ad_connect  adrv9026_tx_device_clk $dac_offload_name/m_axis_aclk
ad_connect  adrv9026_tx_device_clk_rstgen/peripheral_aresetn $dac_offload_name/m_axis_aresetn
ad_connect  util_adrv9026_tx_upack/s_axis $dac_offload_name/m_axis

ad_connect  $sys_dma_clk $dac_offload_name/s_axis_aclk
ad_connect  $sys_dma_resetn $dac_offload_name/s_axis_aresetn
ad_connect  $sys_dma_clk axi_adrv9026_tx_dma/m_axis_aclk
ad_connect  $dac_offload_name/s_axis axi_adrv9026_tx_dma/m_axis
ad_connect  $dac_offload_name/init_req axi_adrv9026_tx_dma/m_axis_xfer_req
ad_connect  tx_adrv9026_tpl_core/dac_dunf util_adrv9026_tx_upack/fifo_rd_underflow

# connections (adc)

ad_connect  adrv9026_rx_device_clk rx_adrv9026_tpl_core/link_clk
ad_connect  axi_adrv9026_rx_jesd/rx_sof rx_adrv9026_tpl_core/link_sof
ad_connect  axi_adrv9026_rx_jesd/rx_data_tdata rx_adrv9026_tpl_core/link_data
ad_connect  axi_adrv9026_rx_jesd/rx_data_tvalid rx_adrv9026_tpl_core/link_valid
ad_connect  adrv9026_rx_device_clk util_adrv9026_rx_cpack/clk
ad_connect  adrv9026_rx_device_clk_rstgen/peripheral_reset util_adrv9026_rx_cpack/reset

for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_adrv9026_tpl_core/adc_enable_$i util_adrv9026_rx_cpack/enable_$i
  ad_connect  rx_adrv9026_tpl_core/adc_data_$i util_adrv9026_rx_cpack/fifo_wr_data_$i
}
ad_connect  $sys_dma_resetn axi_adrv9026_rx_dma/m_dest_axi_aresetn

ad_connect  rx_adrv9026_tpl_core/adc_valid_0 util_adrv9026_rx_cpack/fifo_wr_en
ad_connect  rx_adrv9026_tpl_core/adc_dovf util_adrv9026_rx_cpack/fifo_wr_overflow

ad_connect  adrv9026_rx_device_clk axi_adrv9026_rx_dma/fifo_wr_clk
ad_connect  util_adrv9026_rx_cpack/packed_fifo_wr axi_adrv9026_rx_dma/fifo_wr
ad_connect  util_adrv9026_rx_cpack/packed_sync axi_adrv9026_rx_dma/sync

if {$ORX_ENABLE} {

  # connections (adc-obs)
  ad_connect  adrv9026_rx_os_device_clk rx_os_adrv9026_tpl_core/link_clk
  ad_connect  axi_adrv9026_rx_os_jesd/rx_sof rx_os_adrv9026_tpl_core/link_sof
  ad_connect  axi_adrv9026_rx_os_jesd/rx_data_tdata rx_os_adrv9026_tpl_core/link_data
  ad_connect  axi_adrv9026_rx_os_jesd/rx_data_tvalid rx_os_adrv9026_tpl_core/link_valid

  ad_connect  adrv9026_rx_os_device_clk util_adrv9026_rx_os_cpack/clk
  ad_connect  adrv9026_rx_os_device_clk_rstgen/peripheral_reset util_adrv9026_rx_os_cpack/reset
  ad_connect  adrv9026_rx_os_device_clk axi_adrv9026_rx_os_dma/fifo_wr_clk

  for {set i 0} {$i < $RX_OS_NUM_OF_CONVERTERS} {incr i} {
    ad_connect  rx_os_adrv9026_tpl_core/adc_enable_$i util_adrv9026_rx_os_cpack/enable_$i
    ad_connect  rx_os_adrv9026_tpl_core/adc_data_$i util_adrv9026_rx_os_cpack/fifo_wr_data_$i
  }
  ad_connect  $sys_dma_resetn axi_adrv9026_rx_os_dma/m_dest_axi_aresetn

  ad_connect  rx_os_adrv9026_tpl_core/adc_valid_0 util_adrv9026_rx_os_cpack/fifo_wr_en
  ad_connect  rx_os_adrv9026_tpl_core/adc_dovf util_adrv9026_rx_os_cpack/fifo_wr_overflow

  ad_connect  util_adrv9026_rx_os_cpack/packed_fifo_wr axi_adrv9026_rx_os_dma/fifo_wr
  ad_connect  util_adrv9026_rx_os_cpack/packed_sync axi_adrv9026_rx_os_dma/sync
}

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_adrv9026_tpl_core
ad_cpu_interconnect 0x44A04000 tx_adrv9026_tpl_core
ad_cpu_interconnect 0x44A80000 axi_adrv9026_tx_xcvr
ad_cpu_interconnect 0x44A90000 axi_adrv9026_tx_jesd
ad_cpu_interconnect 0x7C420000 axi_adrv9026_tx_dma
ad_cpu_interconnect 0x44A60000 axi_adrv9026_rx_xcvr
ad_cpu_interconnect 0x44AA0000 axi_adrv9026_rx_jesd
ad_cpu_interconnect 0x7C400000 axi_adrv9026_rx_dma
ad_cpu_interconnect 0x43C10000 axi_adrv9026_rx_clkgen
ad_cpu_interconnect 0x43C00000 axi_adrv9026_tx_clkgen
ad_cpu_interconnect 0x7C430000 $dac_offload_name
if {$ORX_ENABLE} {
  ad_cpu_interconnect 0x44A08000 rx_os_adrv9026_tpl_core
  ad_cpu_interconnect 0x7C800000 axi_adrv9026_rx_os_dma
  ad_cpu_interconnect 0x43C20000 axi_adrv9026_rx_os_clkgen
  ad_cpu_interconnect 0x45A60000 axi_adrv9026_rx_os_xcvr
  ad_cpu_interconnect 0x45AA0000 axi_adrv9026_rx_os_jesd
}

# interconnect (mem/dac)

ad_mem_hp0_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect $sys_cpu_clk axi_adrv9026_rx_xcvr/m_axi

if {$ORX_ENABLE} {
  ad_mem_hp0_interconnect $sys_cpu_clk axi_adrv9026_rx_os_xcvr/m_axi
}

if {$CACHE_COHERENCY} {
  ad_mem_hpc0_interconnect $sys_dma_clk sys_ps8/S_AXI_HPC0
  ad_mem_hpc0_interconnect $sys_dma_clk axi_adrv9026_rx_dma/m_dest_axi
  ad_mem_hpc1_interconnect $sys_dma_clk sys_ps8/S_AXI_HPC1
  ad_mem_hpc1_interconnect $sys_dma_clk axi_adrv9026_tx_dma/m_src_axi
  if {$ORX_ENABLE} {
    ad_mem_hpc1_interconnect $sys_dma_clk axi_adrv9026_rx_os_dma/m_dest_axi
  }
} else {
  ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
  ad_mem_hp2_interconnect $sys_dma_clk axi_adrv9026_rx_dma/m_dest_axi
  ad_mem_hp3_interconnect $sys_dma_clk sys_ps7/S_AXI_HP3
  ad_mem_hp3_interconnect $sys_dma_clk axi_adrv9026_tx_dma/m_src_axi
  if {$ORX_ENABLE} {
    ad_mem_hp1_interconnect $sys_dma_clk sys_ps7/S_AXI_HP1
    ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9026_rx_os_dma/m_dest_axi
  }
}

# interrupts

ad_cpu_interrupt ps-10 mb-7  axi_adrv9026_tx_jesd/irq
ad_cpu_interrupt ps-11 mb-8  axi_adrv9026_rx_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_adrv9026_tx_dma/irq
ad_cpu_interrupt ps-14 mb-13 axi_adrv9026_rx_dma/irq
if {$ORX_ENABLE} {
  ad_cpu_interrupt ps-12 mb-15 axi_adrv9026_rx_os_jesd/irq
  ad_cpu_interrupt ps-15 mb-14 axi_adrv9026_rx_os_dma/irq
}
