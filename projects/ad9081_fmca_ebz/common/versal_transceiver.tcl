###############################################################################
## Copyright (C) 2021-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Parameter description:
#   ip_name : The name of the versal phy ip
#   rx_num_lanes : The number of used RX lanes for the JESD mode
#   tx_num_lanes : The number of used TX lanes for the JESD mode
proc create_reset_logic {
  {ip_name versal_phy}
  {rx_num_lanes 4}
  {tx_num_lanes 4}
  {intf_cfg RXTX}
} {
  set rx_bridge gt_bridge_ip_0
  set asymmetric_mode [expr {$intf_cfg == "RXTX" && $rx_num_lanes != $tx_num_lanes}]
  set tx_bridge [expr {$asymmetric_mode == 0 ? "gt_bridge_ip_0" : "gt_bridge_ip_1"}]

  create_bd_pin -dir I ${ip_name}/gtreset_in
  create_bd_pin -dir O ${ip_name}/gtpowergood
  if {$intf_cfg != "TX"} {
    create_bd_pin -dir I ${ip_name}/gtreset_rx_pll_and_datapath
    create_bd_pin -dir I ${ip_name}/gtreset_rx_datapath
    create_bd_pin -dir O ${ip_name}/rx_resetdone
  }
  if {$intf_cfg != "RX"} {
    create_bd_pin -dir I ${ip_name}/gtreset_tx_pll_and_datapath
    create_bd_pin -dir I ${ip_name}/gtreset_tx_datapath
    create_bd_pin -dir O ${ip_name}/tx_resetdone
  }
  # Sync resets to apb3clk

  create_bd_cell -type module -reference sync_bits ${ip_name}/gtreset_sync
  ad_connect ${ip_name}/s_axi_clk ${ip_name}/gtreset_sync/out_clk
  ad_connect ${ip_name}/s_axi_resetn ${ip_name}/gtreset_sync/out_resetn
  ad_connect ${ip_name}/gtreset_in ${ip_name}/gtreset_sync/in_bits
  ad_connect ${ip_name}/gtreset_sync/out_bits ${ip_name}/${rx_bridge}/gtreset_in
  if {$asymmetric_mode} {
    ad_connect ${ip_name}/gtreset_sync/out_bits ${ip_name}/${tx_bridge}/gtreset_in
  }

  foreach port {pll_and_datapath datapath} {
    foreach rx_tx {rx tx} {
      if {($rx_tx == "rx" && $intf_cfg == "TX") || ($rx_tx == "tx" && $intf_cfg == "RX")} {
        continue
      }
      set bridge [expr {$rx_tx == "rx" ? $rx_bridge : $tx_bridge}]
      create_bd_cell -type module -reference sync_bits ${ip_name}/gtreset_${rx_tx}_${port}_sync
      ad_connect ${ip_name}/s_axi_clk ${ip_name}/gtreset_${rx_tx}_${port}_sync/out_clk
      ad_connect ${ip_name}/s_axi_resetn ${ip_name}/gtreset_${rx_tx}_${port}_sync/out_resetn
      ad_connect ${ip_name}/gtreset_${rx_tx}_${port} ${ip_name}/gtreset_${rx_tx}_${port}_sync/in_bits
      ad_connect ${ip_name}/gtreset_${rx_tx}_${port}_sync/out_bits ${ip_name}/${bridge}/reset_${rx_tx}_${port}_in
    }
  }

  set max_lanes [expr max($rx_num_lanes, $tx_num_lanes)]
  set num_quads [expr int(ceil(1.0 * $max_lanes / 4))]

  ad_ip_instance xlconcat ${ip_name}/concat_powergood [list \
   NUM_PORTS $num_quads \
 ]

  ad_ip_instance util_reduced_logic ${ip_name}/and_powergood [list \
    C_SIZE $num_quads \
  ]

  for {set j 0} {$j < $num_quads} {incr j} {
    ad_connect ${ip_name}/concat_powergood/In${j} ${ip_name}/gt_quad_base_${j}/gtpowergood
  }

  ad_connect ${ip_name}/concat_powergood/dout ${ip_name}/and_powergood/Op1
  ad_connect ${ip_name}/and_powergood/Res ${ip_name}/${rx_bridge}/gtpowergood
  if {$asymmetric_mode} {
    ad_connect ${ip_name}/and_powergood/Res ${ip_name}/${tx_bridge}/gtpowergood
  }

  for {set j 0} {$j < ${rx_num_lanes}} {incr j} {
    set quad_index [expr int($j / 4)]
    set ch_index [expr $j % 4]
    ad_connect ${ip_name}/${rx_bridge}/gt_ilo_reset ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloreset
  }
  if {$asymmetric_mode} {
    for {set j 0} {$j < ${rx_num_lanes}} {incr j} {
      set quad_index [expr int($j / 4)]
      set ch_index [expr $j % 4]
      ad_connect ${ip_name}/${tx_bridge}/gt_ilo_reset ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloreset
    }
  }
  ad_ip_instance xlconcat ${ip_name}/xlconcat_iloresetdone [list \
      NUM_PORTS ${rx_num_lanes} \
  ]
  ad_ip_instance util_reduced_logic ${ip_name}/and_iloresetdone [list \
      C_SIZE ${rx_num_lanes} \
  ]
  for {set j 0} {$j < ${rx_num_lanes}} {incr j} {
    set quad_index [expr int($j / 4)]
    set ch_index [expr $j % 4]
    ad_connect ${ip_name}/xlconcat_iloresetdone/In${j} ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloresetdone
  }
  ad_connect ${ip_name}/xlconcat_iloresetdone/dout ${ip_name}/and_iloresetdone/Op1
  ad_connect ${ip_name}/and_iloresetdone/Res ${ip_name}/${rx_bridge}/ilo_resetdone
  if {$asymmetric_mode} {
    ad_ip_instance xlconcat ${ip_name}/xlconcat_iloresetdone_tx [list \
      NUM_PORTS ${tx_num_lanes} \
    ]
    ad_ip_instance util_reduced_logic ${ip_name}/and_iloresetdone_tx [list \
        C_SIZE ${tx_num_lanes} \
    ]
    for {set j 0} {$j < ${tx_num_lanes}} {incr j} {
      set quad_index [expr int($j / 4)]
      set ch_index [expr $j % 4]
      ad_connect ${ip_name}/xlconcat_iloresetdone_tx/In${j} ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloresetdone
    }
    ad_connect ${ip_name}/xlconcat_iloresetdone_tx/dout ${ip_name}/and_iloresetdone_tx/Op1
    ad_connect ${ip_name}/and_iloresetdone_tx/Res ${ip_name}/${tx_bridge}/ilo_resetdone
  }

  for {set j 0} {$j < ${num_quads}} {incr j} {
    ad_connect ${ip_name}/${rx_bridge}/gt_pll_reset ${ip_name}/gt_quad_base_${j}/hsclk0_lcpllreset
    ad_connect ${ip_name}/${rx_bridge}/gt_pll_reset ${ip_name}/gt_quad_base_${j}/hsclk1_lcpllreset
  }

  set num_cplllocks [expr 2 * ${num_quads}]
  ad_ip_instance xlconcat ${ip_name}/concat_cplllock [list \
      NUM_PORTS ${num_cplllocks} \
  ]
  ad_ip_instance util_reduced_logic ${ip_name}/and_cplllock [list \
      C_SIZE ${num_cplllocks} \
  ]

  for {set j 0} {$j < ${num_quads}} {incr j} {
    set in_index_0 [expr $j * 2 + 0]
    set in_index_1 [expr $j * 2 + 1]
    ad_connect ${ip_name}/concat_cplllock/In${in_index_0} ${ip_name}/gt_quad_base_${j}/hsclk0_lcplllock
    ad_connect ${ip_name}/concat_cplllock/In${in_index_1} ${ip_name}/gt_quad_base_${j}/hsclk1_lcplllock
  }

  ad_connect ${ip_name}/concat_cplllock/dout ${ip_name}/and_cplllock/Op1
  ad_connect ${ip_name}/and_cplllock/Res ${ip_name}/${rx_bridge}/gt_lcpll_lock
  if {$asymmetric_mode} {
    ad_connect ${ip_name}/and_cplllock/Res ${ip_name}/${tx_bridge}/gt_lcpll_lock
  }

  ad_ip_instance xlconcat ${ip_name}/concat_phystatus [list \
    NUM_PORTS ${rx_num_lanes} \
  ]
  for {set j 0} {$j < ${rx_num_lanes}} {incr j} {
    set quad_index [expr int($j / 4)]
    set ch_index [expr $j % 4]

    ad_connect ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_phystatus ${ip_name}/concat_phystatus/In${j}
  }
  ad_connect ${ip_name}/concat_phystatus/dout ${ip_name}/${rx_bridge}/ch_phystatus_in
  if {$asymmetric_mode} {
    ad_ip_instance xlconcat ${ip_name}/concat_phystatus_tx [list \
      NUM_PORTS ${rx_num_lanes} \
    ]
    for {set j 0} {$j < ${rx_num_lanes}} {incr j} {
      set quad_index [expr int($j / 4)]
      set ch_index [expr $j % 4]

      ad_connect ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_phystatus ${ip_name}/concat_phystatus_tx/In${j}
    }
    ad_connect ${ip_name}/concat_phystatus_tx/dout ${ip_name}/${tx_bridge}/ch_phystatus_in
  }

  # Outputs
  ad_connect ${ip_name}/and_powergood/Res ${ip_name}/gtpowergood
  if {$intf_cfg != "TX"} {
    ad_connect ${ip_name}/gt_bridge_ip_0/rx_resetdone_out ${ip_name}/rx_resetdone
  }
  if {$intf_cfg != "RX"} {
    ad_connect ${ip_name}/gt_bridge_ip_0/tx_resetdone_out ${ip_name}/tx_resetdone
  }
}

# Parameter description:
#   ip_name : The name of the created ip
#   jesd_mode : Used physical layer encoder mode
#   rx_num_lanes :  Number of RX lanes
#   tx_num_lanes :  Number of TX lanes
#   ref_clock : Frequency of reference clock in MHz used in 64B66B mode (LANE_RATE/66) or 8B10B mode (LANE_RATE/40)
#   rx_lane_rate : Line rate of the Rx link ( e.g. MxFE to FPGA ) in GHz
#   tx_lane_rate : Line rate of the Tx link ( e.g. FPGA to MxFE ) in GHz
#   intf_cfg : Direction of the transceivers
#       RXTX : Duplex mode
#       RX   : Rx link only
#       TX   : Tx link only
proc create_versal_phy {
  {ip_name versal_phy}
  {jesd_mode 64B66B}
  {rx_num_lanes 4}
  {tx_num_lanes 4}
  {rx_lane_rate 24.75}
  {tx_lane_rate 24.75}
  {ref_clock 375}
  {transceiver GTY}
  {intf_cfg RXTX}
} {

  set clk_divider              [expr { $jesd_mode == "64B66B" ? 66 : 40} ]
  set datapath_width           [expr { $jesd_mode == "64B66B" ? 64 : 32} ]
  set internal_datapath_width  [expr { $jesd_mode == "64B66B" ? 64 : 40} ]
  set data_encoding            [expr { $jesd_mode == "64B66B" ? "64B66B_ASYNC" : "8B10B"} ]
  set link_mode                [expr { $jesd_mode == "64B66B" ? 2 : 1} ]
  set comma_mask               [expr { $jesd_mode == "64B66B" ? "0000000000" : "1111111111"} ]
  set comma_p_enable           [expr { $jesd_mode == "64B66B" ? false : false} ]
  set comma_m_enable           [expr { $jesd_mode == "64B66B" ? false : false} ]
  set num_quads                [expr int(ceil(1.0 * max($rx_num_lanes, $tx_num_lanes) / 4))]
  set asymmetric_mode          [expr { $intf_cfg == "RXTX" && $rx_num_lanes != $tx_num_lanes ? true : false } ]
  # When asymmetric_mode is true it means that the number of lanes on the Rx side is different from the number of lanes on the Tx side
  # The 'gt_bridge_ip' can only be configured with the same number of lanes so we need to instantiate two ips, one for the Rx and one for the Tx
  # Both 'gt_bridge_ip' will still share the same quad
  puts "intf_cfg: ${intf_cfg}"
  puts "assymmetric_mode: ${asymmetric_mode}"

  set rx_progdiv_clock [format %.3f [expr $rx_lane_rate * 1000 / ${clk_divider}]]
  set tx_progdiv_clock [format %.3f [expr $tx_lane_rate * 1000 / ${clk_divider}]]
  set preset ${transceiver}-JESD204_64B66B

  if {$intf_cfg == "RX"} {
    set gt_direction "SIMPLEX_RX"
    set no_lanes_property "CONFIG.IP_NO_OF_RX_LANES"
  } elseif {$intf_cfg == "TX"} {
    set gt_direction "SIMPLEX_TX"
    set no_lanes_property "CONFIG.IP_NO_OF_TX_LANES"
  } else {
    set gt_direction "DUPLEX"
    set no_lanes_property "CONFIG.IP_NO_OF_LANES"
  }

  create_bd_cell -type hier ${ip_name}

  # Common interface
  create_bd_pin -dir I ${ip_name}/GT_REFCLK -type clk
  create_bd_pin -dir I ${ip_name}/s_axi_clk
  create_bd_pin -dir I ${ip_name}/s_axi_resetn
  if {$intf_cfg != "TX"} {
    create_bd_pin -dir O ${ip_name}/rxusrclk_out -type clk
    create_bd_pin -dir I ${ip_name}/en_char_align
  }
  if {$intf_cfg != "RX"} {
    create_bd_pin -dir O ${ip_name}/txusrclk_out -type clk
  }

  ad_ip_instance gt_bridge_ip ${ip_name}/gt_bridge_ip_0
  set rx_bridge gt_bridge_ip_0
  set tx_bridge gt_bridge_ip_0
  if {$asymmetric_mode} {
    ad_ip_instance gt_bridge_ip ${ip_name}/gt_bridge_ip_1
    set tx_bridge gt_bridge_ip_1
  }
  if {!$asymmetric_mode} {
    set num_lanes [expr max($rx_num_lanes, $tx_num_lanes)]
    set_property -dict [list \
      CONFIG.BYPASS_MODE {true} \
      CONFIG.IP_PRESET ${preset} \
      CONFIG.IP_GT_DIRECTION ${gt_direction} \
      ${no_lanes_property} ${num_lanes} \
      CONFIG.IP_LR0_SETTINGS [list \
        PRESET $preset \
        INTERNAL_PRESET JESD204_${jesd_mode} \
        GT_TYPE $transceiver \
        GT_DIRECTION $gt_direction \
        TX_LINE_RATE $tx_lane_rate \
        TX_PLL_TYPE LCPLL \
        TX_REFCLK_FREQUENCY $ref_clock \
        TX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
        TX_FRACN_ENABLED true \
        TX_FRACN_NUMERATOR 0 \
        TX_REFCLK_SOURCE R0 \
        TX_DATA_ENCODING $data_encoding \
        TX_USER_DATA_WIDTH $datapath_width \
        TX_INT_DATA_WIDTH $internal_datapath_width \
        TX_BUFFER_MODE 1 \
        TX_BUFFER_BYPASS_MODE Fast_Sync \
        TX_PIPM_ENABLE false \
        TX_OUTCLK_SOURCE TXPROGDIVCLK \
        TXPROGDIV_FREQ_ENABLE true \
        TXPROGDIV_FREQ_SOURCE LCPLL \
        TXPROGDIV_FREQ_VAL $tx_progdiv_clock \
        TX_DIFF_SWING_EMPH_MODE CUSTOM \
        TX_64B66B_SCRAMBLER false \
        TX_64B66B_ENCODER false \
        TX_64B66B_CRC false \
        TX_RATE_GROUP A \
        RX_LINE_RATE $rx_lane_rate \
        RX_PLL_TYPE LCPLL \
        RX_REFCLK_FREQUENCY $ref_clock \
        RX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
        RX_FRACN_ENABLED true \
        RX_FRACN_NUMERATOR 0 \
        RX_REFCLK_SOURCE R0 \
        RX_DATA_DECODING $data_encoding \
        RX_USER_DATA_WIDTH $datapath_width \
        RX_INT_DATA_WIDTH $internal_datapath_width \
        RX_BUFFER_MODE 1 \
        RX_OUTCLK_SOURCE RXPROGDIVCLK \
        RXPROGDIV_FREQ_ENABLE true \
        RXPROGDIV_FREQ_SOURCE LCPLL \
        RXPROGDIV_FREQ_VAL $rx_progdiv_clock \
        INS_LOSS_NYQ 12 \
        RX_EQ_MODE LPM \
        RX_COUPLING AC \
        RX_TERMINATION PROGRAMMABLE \
        RX_RATE_GROUP A \
        RX_TERMINATION_PROG_VALUE 800 \
        RX_PPM_OFFSET 0 \
        RX_64B66B_DESCRAMBLER false \
        RX_64B66B_DECODER false \
        RX_64B66B_CRC false \
        OOB_ENABLE false \
        RX_COMMA_ALIGN_WORD 1 \
        RX_COMMA_SHOW_REALIGN_ENABLE false \
        PCIE_ENABLE false \
        RX_COMMA_P_ENABLE $comma_p_enable \
        RX_COMMA_M_ENABLE $comma_m_enable \
        RX_COMMA_DOUBLE_ENABLE false \
        RX_COMMA_P_VAL 0101111100 \
        RX_COMMA_M_VAL 1010000011 \
        RX_COMMA_MASK $comma_mask \
        RX_SLIDE_MODE PCS \
        RX_SSC_PPM 0 \
        RX_CB_NUM_SEQ 0 \
        RX_CB_LEN_SEQ 1 \
        RX_CB_MAX_SKEW 1 \
        RX_CB_MAX_LEVEL 1 \
        RX_CB_MASK_0_0 false \
        RX_CB_VAL_0_0 00000000 \
        RX_CB_K_0_0 false \
        RX_CB_DISP_0_0 false \
        RX_CB_MASK_0_1 false \
        RX_CB_VAL_0_1 00000000 \
        RX_CB_K_0_1 false \
        RX_CB_DISP_0_1 false \
        RX_CB_MASK_0_2 false \
        RX_CB_VAL_0_2 00000000 \
        RX_CB_K_0_2 false \
        RX_CB_DISP_0_2 false \
        RX_CB_MASK_0_3 false \
        RX_CB_VAL_0_3 00000000 \
        RX_CB_K_0_3 false \
        RX_CB_DISP_0_3 false \
        RX_CB_MASK_1_0 false \
        RX_CB_VAL_1_0 00000000 \
        RX_CB_K_1_0 false \
        RX_CB_DISP_1_0 false \
        RX_CB_MASK_1_1 false \
        RX_CB_VAL_1_1 00000000 \
        RX_CB_K_1_1 false \
        RX_CB_DISP_1_1 false \
        RX_CB_MASK_1_2 false \
        RX_CB_VAL_1_2 00000000 \
        RX_CB_K_1_2 false \
        RX_CB_DISP_1_2 false \
        RX_CB_MASK_1_3 false \
        RX_CB_VAL_1_3 00000000 \
        RX_CB_K_1_3 false \
        RX_CB_DISP_1_3 false \
        RX_CC_NUM_SEQ 0 \
        RX_CC_LEN_SEQ 1 \
        RX_CC_PERIODICITY 5000 \
        RX_CC_KEEP_IDLE DISABLE \
        RX_CC_PRECEDENCE ENABLE \
        RX_CC_REPEAT_WAIT 0 \
        RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 \
        RX_CC_MASK_0_0 false \
        RX_CC_VAL_0_0 00000000 \
        RX_CC_K_0_0 false \
        RX_CC_DISP_0_0 false \
        RX_CC_MASK_0_1 false \
        RX_CC_VAL_0_1 00000000 \
        RX_CC_K_0_1 false \
        RX_CC_DISP_0_1 false \
        RX_CC_MASK_0_2 false \
        RX_CC_VAL_0_2 00000000 \
        RX_CC_K_0_2 false \
        RX_CC_DISP_0_2 false \
        RX_CC_MASK_0_3 false \
        RX_CC_VAL_0_3 00000000 \
        RX_CC_K_0_3 false \
        RX_CC_DISP_0_3 false \
        RX_CC_MASK_1_0 false \
        RX_CC_VAL_1_0 00000000 \
        RX_CC_K_1_0 false \
        RX_CC_DISP_1_0 false \
        RX_CC_MASK_1_1 false \
        RX_CC_VAL_1_1 00000000 \
        RX_CC_K_1_1 false \
        RX_CC_DISP_1_1 false \
        RX_CC_MASK_1_2 false \
        RX_CC_VAL_1_2 00000000 \
        RX_CC_K_1_2 false \
        RX_CC_DISP_1_2 false \
        RX_CC_MASK_1_3 false \
        RX_CC_VAL_1_3 00000000 \
        RX_CC_K_1_3 false \
        RX_CC_DISP_1_3 false \
        PCIE_USERCLK2_FREQ 250 \
        PCIE_USERCLK_FREQ 250 \
        RX_JTOL_FC 10 \
        RX_JTOL_LF_SLOPE -20 \
        RX_BUFFER_BYPASS_MODE Fast_Sync \
        RX_BUFFER_BYPASS_MODE_LANE MULTI \
        RX_BUFFER_RESET_ON_CB_CHANGE ENABLE \
        RX_BUFFER_RESET_ON_COMMAALIGN DISABLE \
        RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
        TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
        RESET_SEQUENCE_INTERVAL 0 \
        RX_COMMA_PRESET NONE \
        RX_COMMA_VALID_ONLY 0 \
        ] \
    ] [get_bd_cells ${ip_name}/${rx_bridge}]
  } else {
    set_property -dict [list \
        CONFIG.BYPASS_MODE {true} \
        CONFIG.IP_PRESET ${preset} \
        CONFIG.IP_GT_DIRECTION {SIMPLEX_RX} \
        CONFIG.IP_NO_OF_RX_LANES ${rx_num_lanes} \
        CONFIG.IP_LR0_SETTINGS [list \
          PRESET $preset \
          INTERNAL_PRESET JESD204_${jesd_mode} \
          GT_TYPE $transceiver \
          GT_DIRECTION SIMPLEX_RX \
          TX_LINE_RATE $tx_lane_rate \
          TX_PLL_TYPE LCPLL \
          TX_REFCLK_FREQUENCY $ref_clock \
          TX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
          TX_FRACN_ENABLED true \
          TX_FRACN_NUMERATOR 0 \
          TX_REFCLK_SOURCE R0 \
          TX_DATA_ENCODING $data_encoding \
          TX_USER_DATA_WIDTH $datapath_width \
          TX_INT_DATA_WIDTH $internal_datapath_width \
          TX_BUFFER_MODE 1 \
          TX_BUFFER_BYPASS_MODE Fast_Sync \
          TX_PIPM_ENABLE false \
          TX_OUTCLK_SOURCE TXPROGDIVCLK \
          TXPROGDIV_FREQ_ENABLE true \
          TXPROGDIV_FREQ_SOURCE LCPLL \
          TXPROGDIV_FREQ_VAL $tx_progdiv_clock \
          TX_DIFF_SWING_EMPH_MODE CUSTOM \
          TX_64B66B_SCRAMBLER false \
          TX_64B66B_ENCODER false \
          TX_64B66B_CRC false \
          TX_RATE_GROUP A \
          RX_LINE_RATE $rx_lane_rate \
          RX_PLL_TYPE LCPLL \
          RX_REFCLK_FREQUENCY $ref_clock \
          RX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
          RX_FRACN_ENABLED true \
          RX_FRACN_NUMERATOR 0 \
          RX_REFCLK_SOURCE R0 \
          RX_DATA_DECODING $data_encoding \
          RX_USER_DATA_WIDTH $datapath_width \
          RX_INT_DATA_WIDTH $internal_datapath_width \
          RX_BUFFER_MODE 1 \
          RX_OUTCLK_SOURCE RXPROGDIVCLK \
          RXPROGDIV_FREQ_ENABLE true \
          RXPROGDIV_FREQ_SOURCE LCPLL \
          RXPROGDIV_FREQ_VAL $rx_progdiv_clock \
          INS_LOSS_NYQ 12 \
          RX_EQ_MODE LPM \
          RX_COUPLING AC \
          RX_TERMINATION PROGRAMMABLE \
          RX_RATE_GROUP A \
          RX_TERMINATION_PROG_VALUE 800 \
          RX_PPM_OFFSET 0 \
          RX_64B66B_DESCRAMBLER false \
          RX_64B66B_DECODER false \
          RX_64B66B_CRC false \
          OOB_ENABLE false \
          RX_COMMA_ALIGN_WORD 1 \
          RX_COMMA_SHOW_REALIGN_ENABLE false \
          PCIE_ENABLE false \
          RX_COMMA_P_ENABLE $comma_p_enable \
          RX_COMMA_M_ENABLE $comma_m_enable \
          RX_COMMA_DOUBLE_ENABLE false \
          RX_COMMA_P_VAL 0101111100 \
          RX_COMMA_M_VAL 1010000011 \
          RX_COMMA_MASK $comma_mask \
          RX_SLIDE_MODE PCS \
          RX_SSC_PPM 0 \
          RX_CB_NUM_SEQ 0 \
          RX_CB_LEN_SEQ 1 \
          RX_CB_MAX_SKEW 1 \
          RX_CB_MAX_LEVEL 1 \
          RX_CB_MASK_0_0 false \
          RX_CB_VAL_0_0 00000000 \
          RX_CB_K_0_0 false \
          RX_CB_DISP_0_0 false \
          RX_CB_MASK_0_1 false \
          RX_CB_VAL_0_1 00000000 \
          RX_CB_K_0_1 false \
          RX_CB_DISP_0_1 false \
          RX_CB_MASK_0_2 false \
          RX_CB_VAL_0_2 00000000 \
          RX_CB_K_0_2 false \
          RX_CB_DISP_0_2 false \
          RX_CB_MASK_0_3 false \
          RX_CB_VAL_0_3 00000000 \
          RX_CB_K_0_3 false \
          RX_CB_DISP_0_3 false \
          RX_CB_MASK_1_0 false \
          RX_CB_VAL_1_0 00000000 \
          RX_CB_K_1_0 false \
          RX_CB_DISP_1_0 false \
          RX_CB_MASK_1_1 false \
          RX_CB_VAL_1_1 00000000 \
          RX_CB_K_1_1 false \
          RX_CB_DISP_1_1 false \
          RX_CB_MASK_1_2 false \
          RX_CB_VAL_1_2 00000000 \
          RX_CB_K_1_2 false \
          RX_CB_DISP_1_2 false \
          RX_CB_MASK_1_3 false \
          RX_CB_VAL_1_3 00000000 \
          RX_CB_K_1_3 false \
          RX_CB_DISP_1_3 false \
          RX_CC_NUM_SEQ 0 \
          RX_CC_LEN_SEQ 1 \
          RX_CC_PERIODICITY 5000 \
          RX_CC_KEEP_IDLE DISABLE \
          RX_CC_PRECEDENCE ENABLE \
          RX_CC_REPEAT_WAIT 0 \
          RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 \
          RX_CC_MASK_0_0 false \
          RX_CC_VAL_0_0 00000000 \
          RX_CC_K_0_0 false \
          RX_CC_DISP_0_0 false \
          RX_CC_MASK_0_1 false \
          RX_CC_VAL_0_1 00000000 \
          RX_CC_K_0_1 false \
          RX_CC_DISP_0_1 false \
          RX_CC_MASK_0_2 false \
          RX_CC_VAL_0_2 00000000 \
          RX_CC_K_0_2 false \
          RX_CC_DISP_0_2 false \
          RX_CC_MASK_0_3 false \
          RX_CC_VAL_0_3 00000000 \
          RX_CC_K_0_3 false \
          RX_CC_DISP_0_3 false \
          RX_CC_MASK_1_0 false \
          RX_CC_VAL_1_0 00000000 \
          RX_CC_K_1_0 false \
          RX_CC_DISP_1_0 false \
          RX_CC_MASK_1_1 false \
          RX_CC_VAL_1_1 00000000 \
          RX_CC_K_1_1 false \
          RX_CC_DISP_1_1 false \
          RX_CC_MASK_1_2 false \
          RX_CC_VAL_1_2 00000000 \
          RX_CC_K_1_2 false \
          RX_CC_DISP_1_2 false \
          RX_CC_MASK_1_3 false \
          RX_CC_VAL_1_3 00000000 \
          RX_CC_K_1_3 false \
          RX_CC_DISP_1_3 false \
          PCIE_USERCLK2_FREQ 250 \
          PCIE_USERCLK_FREQ 250 \
          RX_JTOL_FC 10 \
          RX_JTOL_LF_SLOPE -20 \
          RX_BUFFER_BYPASS_MODE Fast_Sync \
          RX_BUFFER_BYPASS_MODE_LANE MULTI \
          RX_BUFFER_RESET_ON_CB_CHANGE ENABLE \
          RX_BUFFER_RESET_ON_COMMAALIGN DISABLE \
          RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
          TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
          RESET_SEQUENCE_INTERVAL 0 \
          RX_COMMA_PRESET NONE \
          RX_COMMA_VALID_ONLY 0 \
          ] \
      ] [get_bd_cells ${ip_name}/${rx_bridge}]

    set_property -dict [list \
      CONFIG.BYPASS_MODE {true} \
      CONFIG.IP_PRESET ${preset} \
      CONFIG.IP_GT_DIRECTION {SIMPLEX_TX} \
      CONFIG.IP_NO_OF_TX_LANES ${tx_num_lanes} \
      CONFIG.IP_LR0_SETTINGS [list \
        PRESET $preset \
        INTERNAL_PRESET JESD204_${jesd_mode} \
        GT_TYPE $transceiver \
        GT_DIRECTION SIMPLEX_TX \
        TX_LINE_RATE $tx_lane_rate \
        TX_PLL_TYPE LCPLL \
        TX_REFCLK_FREQUENCY $ref_clock \
        TX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
        TX_FRACN_ENABLED true \
        TX_FRACN_NUMERATOR 0 \
        TX_REFCLK_SOURCE R0 \
        TX_DATA_ENCODING $data_encoding \
        TX_USER_DATA_WIDTH $datapath_width \
        TX_INT_DATA_WIDTH $internal_datapath_width \
        TX_BUFFER_MODE 1 \
        TX_BUFFER_BYPASS_MODE Fast_Sync \
        TX_PIPM_ENABLE false \
        TX_OUTCLK_SOURCE TXPROGDIVCLK \
        TXPROGDIV_FREQ_ENABLE true \
        TXPROGDIV_FREQ_SOURCE LCPLL \
        TXPROGDIV_FREQ_VAL $tx_progdiv_clock \
        TX_DIFF_SWING_EMPH_MODE CUSTOM \
        TX_64B66B_SCRAMBLER false \
        TX_64B66B_ENCODER false \
        TX_64B66B_CRC false \
        TX_RATE_GROUP A \
        RX_LINE_RATE $rx_lane_rate \
        RX_PLL_TYPE LCPLL \
        RX_REFCLK_FREQUENCY $ref_clock \
        RX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
        RX_FRACN_ENABLED true \
        RX_FRACN_NUMERATOR 0 \
        RX_REFCLK_SOURCE R0 \
        RX_DATA_DECODING $data_encoding \
        RX_USER_DATA_WIDTH $datapath_width \
        RX_INT_DATA_WIDTH $internal_datapath_width \
        RX_BUFFER_MODE 1 \
        RX_OUTCLK_SOURCE RXPROGDIVCLK \
        RXPROGDIV_FREQ_ENABLE true \
        RXPROGDIV_FREQ_SOURCE LCPLL \
        RXPROGDIV_FREQ_VAL $rx_progdiv_clock \
        INS_LOSS_NYQ 12 \
        RX_EQ_MODE LPM \
        RX_COUPLING AC \
        RX_TERMINATION PROGRAMMABLE \
        RX_RATE_GROUP A \
        RX_TERMINATION_PROG_VALUE 800 \
        RX_PPM_OFFSET 0 \
        RX_64B66B_DESCRAMBLER false \
        RX_64B66B_DECODER false \
        RX_64B66B_CRC false \
        OOB_ENABLE false \
        RX_COMMA_ALIGN_WORD 1 \
        RX_COMMA_SHOW_REALIGN_ENABLE false \
        PCIE_ENABLE false \
        RX_COMMA_P_ENABLE $comma_p_enable \
        RX_COMMA_M_ENABLE $comma_m_enable \
        RX_COMMA_DOUBLE_ENABLE false \
        RX_COMMA_P_VAL 0101111100 \
        RX_COMMA_M_VAL 1010000011 \
        RX_COMMA_MASK $comma_mask \
        RX_SLIDE_MODE PCS \
        RX_SSC_PPM 0 \
        RX_CB_NUM_SEQ 0 \
        RX_CB_LEN_SEQ 1 \
        RX_CB_MAX_SKEW 1 \
        RX_CB_MAX_LEVEL 1 \
        RX_CB_MASK_0_0 false \
        RX_CB_VAL_0_0 00000000 \
        RX_CB_K_0_0 false \
        RX_CB_DISP_0_0 false \
        RX_CB_MASK_0_1 false \
        RX_CB_VAL_0_1 00000000 \
        RX_CB_K_0_1 false \
        RX_CB_DISP_0_1 false \
        RX_CB_MASK_0_2 false \
        RX_CB_VAL_0_2 00000000 \
        RX_CB_K_0_2 false \
        RX_CB_DISP_0_2 false \
        RX_CB_MASK_0_3 false \
        RX_CB_VAL_0_3 00000000 \
        RX_CB_K_0_3 false \
        RX_CB_DISP_0_3 false \
        RX_CB_MASK_1_0 false \
        RX_CB_VAL_1_0 00000000 \
        RX_CB_K_1_0 false \
        RX_CB_DISP_1_0 false \
        RX_CB_MASK_1_1 false \
        RX_CB_VAL_1_1 00000000 \
        RX_CB_K_1_1 false \
        RX_CB_DISP_1_1 false \
        RX_CB_MASK_1_2 false \
        RX_CB_VAL_1_2 00000000 \
        RX_CB_K_1_2 false \
        RX_CB_DISP_1_2 false \
        RX_CB_MASK_1_3 false \
        RX_CB_VAL_1_3 00000000 \
        RX_CB_K_1_3 false \
        RX_CB_DISP_1_3 false \
        RX_CC_NUM_SEQ 0 \
        RX_CC_LEN_SEQ 1 \
        RX_CC_PERIODICITY 5000 \
        RX_CC_KEEP_IDLE DISABLE \
        RX_CC_PRECEDENCE ENABLE \
        RX_CC_REPEAT_WAIT 0 \
        RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 \
        RX_CC_MASK_0_0 false \
        RX_CC_VAL_0_0 00000000 \
        RX_CC_K_0_0 false \
        RX_CC_DISP_0_0 false \
        RX_CC_MASK_0_1 false \
        RX_CC_VAL_0_1 00000000 \
        RX_CC_K_0_1 false \
        RX_CC_DISP_0_1 false \
        RX_CC_MASK_0_2 false \
        RX_CC_VAL_0_2 00000000 \
        RX_CC_K_0_2 false \
        RX_CC_DISP_0_2 false \
        RX_CC_MASK_0_3 false \
        RX_CC_VAL_0_3 00000000 \
        RX_CC_K_0_3 false \
        RX_CC_DISP_0_3 false \
        RX_CC_MASK_1_0 false \
        RX_CC_VAL_1_0 00000000 \
        RX_CC_K_1_0 false \
        RX_CC_DISP_1_0 false \
        RX_CC_MASK_1_1 false \
        RX_CC_VAL_1_1 00000000 \
        RX_CC_K_1_1 false \
        RX_CC_DISP_1_1 false \
        RX_CC_MASK_1_2 false \
        RX_CC_VAL_1_2 00000000 \
        RX_CC_K_1_2 false \
        RX_CC_DISP_1_2 false \
        RX_CC_MASK_1_3 false \
        RX_CC_VAL_1_3 00000000 \
        RX_CC_K_1_3 false \
        RX_CC_DISP_1_3 false \
        PCIE_USERCLK2_FREQ 250 \
        PCIE_USERCLK_FREQ 250 \
        RX_JTOL_FC 10 \
        RX_JTOL_LF_SLOPE -20 \
        RX_BUFFER_BYPASS_MODE Fast_Sync \
        RX_BUFFER_BYPASS_MODE_LANE MULTI \
        RX_BUFFER_RESET_ON_CB_CHANGE ENABLE \
        RX_BUFFER_RESET_ON_COMMAALIGN DISABLE \
        RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
        TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
        RESET_SEQUENCE_INTERVAL 0 \
        RX_COMMA_PRESET NONE \
        RX_COMMA_VALID_ONLY 0 \
        ] \
    ] [get_bd_cells ${ip_name}/${tx_bridge}]
  }

  for {set j 0} {$j < $num_quads} {incr j} {
    ad_ip_instance gt_quad_base ${ip_name}/gt_quad_base_${j}
    set_property -dict [list \
      CONFIG.REG_CONF_INTF.VALUE_MODE {MANUAL} \
      CONFIG.REG_CONF_INTF {AXI_LITE} \
    ] [get_bd_cells ${ip_name}/gt_quad_base_${j}]
    if {$asymmetric_mode} {
      # When we have multiple protocols (different number of lanes on Rx and Tx) we have to manually set the protocols to pass design validation
      set_property -dict [list \
        CONFIG.PROT1_LR0_SETTINGS.VALUE_MODE MANUAL \
        CONFIG.GT_TYPE.VALUE_MODE AUTO \
        CONFIG.PROT0_RX_MASTERCLK_SRC.VALUE_MODE MANUAL \
        CONFIG.PROT1_TX_MASTERCLK_SRC.VALUE_MODE MANUAL \
        CONFIG.PROT0_TX_MASTERCLK_SRC.VALUE_MODE MANUAL \
        CONFIG.PROT1_PRESET.VALUE_MODE MANUAL \
        CONFIG.PROT1_ENABLE.VALUE_MODE MANUAL \
        CONFIG.PROT0_PRESET.VALUE_MODE MANUAL \
        CONFIG.PROT0_GT_DIRECTION.VALUE_MODE MANUAL \
        CONFIG.TX0_LANE_SEL.VALUE_MODE AUTO \
        CONFIG.PROT0_NO_OF_LANES.VALUE_MODE MANUAL \
        CONFIG.PROT0_NO_OF_RX_LANES.VALUE_MODE MANUAL \
        CONFIG.PROT1_NO_OF_TX_LANES.VALUE_MODE MANUAL \
        CONFIG.PROT1_GT_DIRECTION.VALUE_MODE MANUAL \
        CONFIG.PROT0_LR0_SETTINGS.VALUE_MODE MANUAL \
      ] [get_bd_cells ${ip_name}/gt_quad_base_${j}]

      set_property -dict [list \
        CONFIG.PROT0_GT_DIRECTION {SIMPLEX_RX} \
        CONFIG.PROT0_LR0_SETTINGS [list \
          PRESET $preset \
          INTERNAL_PRESET JESD204_${jesd_mode} \
          GT_TYPE $transceiver \
          GT_DIRECTION {SIMPLEX_RX} \
          TX_LINE_RATE $tx_lane_rate \
          TX_PLL_TYPE LCPLL \
          TX_REFCLK_FREQUENCY $ref_clock \
          TX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
          TX_FRACN_ENABLED true \
          TX_FRACN_NUMERATOR 0 \
          TX_REFCLK_SOURCE R0 \
          TX_DATA_ENCODING $data_encoding \
          TX_USER_DATA_WIDTH $datapath_width \
          TX_INT_DATA_WIDTH $internal_datapath_width \
          TX_BUFFER_MODE 1 \
          TX_BUFFER_BYPASS_MODE Fast_Sync \
          TX_PIPM_ENABLE false \
          TX_OUTCLK_SOURCE TXPROGDIVCLK \
          TXPROGDIV_FREQ_ENABLE true \
          TXPROGDIV_FREQ_SOURCE LCPLL \
          TXPROGDIV_FREQ_VAL $tx_progdiv_clock \
          TX_DIFF_SWING_EMPH_MODE CUSTOM \
          TX_64B66B_SCRAMBLER false \
          TX_64B66B_ENCODER false \
          TX_64B66B_CRC false \
          TX_RATE_GROUP A \
          RX_LINE_RATE $rx_lane_rate \
          RX_PLL_TYPE LCPLL \
          RX_REFCLK_FREQUENCY $ref_clock \
          RX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
          RX_FRACN_ENABLED true \
          RX_FRACN_NUMERATOR 0 \
          RX_REFCLK_SOURCE R0 \
          RX_DATA_DECODING $data_encoding \
          RX_USER_DATA_WIDTH $datapath_width \
          RX_INT_DATA_WIDTH $internal_datapath_width \
          RX_BUFFER_MODE 1 \
          RX_OUTCLK_SOURCE RXPROGDIVCLK \
          RXPROGDIV_FREQ_ENABLE true \
          RXPROGDIV_FREQ_SOURCE LCPLL \
          RXPROGDIV_FREQ_VAL $rx_progdiv_clock \
          INS_LOSS_NYQ 12 \
          RX_EQ_MODE LPM \
          RX_COUPLING AC \
          RX_TERMINATION PROGRAMMABLE \
          RX_RATE_GROUP A \
          RX_TERMINATION_PROG_VALUE 800 \
          RX_PPM_OFFSET 0 \
          RX_64B66B_DESCRAMBLER false \
          RX_64B66B_DECODER false \
          RX_64B66B_CRC false \
          OOB_ENABLE false \
          RX_COMMA_ALIGN_WORD 1 \
          RX_COMMA_SHOW_REALIGN_ENABLE false \
          PCIE_ENABLE false \
          RX_COMMA_P_ENABLE $comma_p_enable \
          RX_COMMA_M_ENABLE $comma_m_enable \
          RX_COMMA_DOUBLE_ENABLE false \
          RX_COMMA_P_VAL 0101111100 \
          RX_COMMA_M_VAL 1010000011 \
          RX_COMMA_MASK $comma_mask \
          RX_SLIDE_MODE PCS \
          RX_SSC_PPM 0 \
          RX_CB_NUM_SEQ 0 \
          RX_CB_LEN_SEQ 1 \
          RX_CB_MAX_SKEW 1 \
          RX_CB_MAX_LEVEL 1 \
          RX_CB_MASK_0_0 false \
          RX_CB_VAL_0_0 00000000 \
          RX_CB_K_0_0 false \
          RX_CB_DISP_0_0 false \
          RX_CB_MASK_0_1 false \
          RX_CB_VAL_0_1 00000000 \
          RX_CB_K_0_1 false \
          RX_CB_DISP_0_1 false \
          RX_CB_MASK_0_2 false \
          RX_CB_VAL_0_2 00000000 \
          RX_CB_K_0_2 false \
          RX_CB_DISP_0_2 false \
          RX_CB_MASK_0_3 false \
          RX_CB_VAL_0_3 00000000 \
          RX_CB_K_0_3 false \
          RX_CB_DISP_0_3 false \
          RX_CB_MASK_1_0 false \
          RX_CB_VAL_1_0 00000000 \
          RX_CB_K_1_0 false \
          RX_CB_DISP_1_0 false \
          RX_CB_MASK_1_1 false \
          RX_CB_VAL_1_1 00000000 \
          RX_CB_K_1_1 false \
          RX_CB_DISP_1_1 false \
          RX_CB_MASK_1_2 false \
          RX_CB_VAL_1_2 00000000 \
          RX_CB_K_1_2 false \
          RX_CB_DISP_1_2 false \
          RX_CB_MASK_1_3 false \
          RX_CB_VAL_1_3 00000000 \
          RX_CB_K_1_3 false \
          RX_CB_DISP_1_3 false \
          RX_CC_NUM_SEQ 0 \
          RX_CC_LEN_SEQ 1 \
          RX_CC_PERIODICITY 5000 \
          RX_CC_KEEP_IDLE DISABLE \
          RX_CC_PRECEDENCE ENABLE \
          RX_CC_REPEAT_WAIT 0 \
          RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 \
          RX_CC_MASK_0_0 false \
          RX_CC_VAL_0_0 00000000 \
          RX_CC_K_0_0 false \
          RX_CC_DISP_0_0 false \
          RX_CC_MASK_0_1 false \
          RX_CC_VAL_0_1 00000000 \
          RX_CC_K_0_1 false \
          RX_CC_DISP_0_1 false \
          RX_CC_MASK_0_2 false \
          RX_CC_VAL_0_2 00000000 \
          RX_CC_K_0_2 false \
          RX_CC_DISP_0_2 false \
          RX_CC_MASK_0_3 false \
          RX_CC_VAL_0_3 00000000 \
          RX_CC_K_0_3 false \
          RX_CC_DISP_0_3 false \
          RX_CC_MASK_1_0 false \
          RX_CC_VAL_1_0 00000000 \
          RX_CC_K_1_0 false \
          RX_CC_DISP_1_0 false \
          RX_CC_MASK_1_1 false \
          RX_CC_VAL_1_1 00000000 \
          RX_CC_K_1_1 false \
          RX_CC_DISP_1_1 false \
          RX_CC_MASK_1_2 false \
          RX_CC_VAL_1_2 00000000 \
          RX_CC_K_1_2 false \
          RX_CC_DISP_1_2 false \
          RX_CC_MASK_1_3 false \
          RX_CC_VAL_1_3 00000000 \
          RX_CC_K_1_3 false \
          RX_CC_DISP_1_3 false \
          PCIE_USERCLK2_FREQ 250 \
          PCIE_USERCLK_FREQ 250 \
          RX_JTOL_FC 10 \
          RX_JTOL_LF_SLOPE -20 \
          RX_BUFFER_BYPASS_MODE Fast_Sync \
          RX_BUFFER_BYPASS_MODE_LANE MULTI \
          RX_BUFFER_RESET_ON_CB_CHANGE ENABLE \
          RX_BUFFER_RESET_ON_COMMAALIGN DISABLE \
          RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
          TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
          RESET_SEQUENCE_INTERVAL 0 \
          RX_COMMA_PRESET NONE \
          RX_COMMA_VALID_ONLY 0 \
        ] \
        CONFIG.PROT0_NO_OF_RX_LANES $rx_num_lanes \
        CONFIG.PROT0_PRESET ${preset} \
        CONFIG.PROT1_ENABLE {true} \
        CONFIG.PROT1_GT_DIRECTION {SIMPLEX_TX} \
        CONFIG.PROT1_LR0_SETTINGS [list \
          PRESET $preset \
          INTERNAL_PRESET JESD204_${jesd_mode} \
          GT_TYPE $transceiver \
          GT_DIRECTION {SIMPLEX_TX} \
          TX_LINE_RATE $tx_lane_rate \
          TX_PLL_TYPE LCPLL \
          TX_REFCLK_FREQUENCY $ref_clock \
          TX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
          TX_FRACN_ENABLED true \
          TX_FRACN_NUMERATOR 0 \
          TX_REFCLK_SOURCE R0 \
          TX_DATA_ENCODING $data_encoding \
          TX_USER_DATA_WIDTH $datapath_width \
          TX_INT_DATA_WIDTH $internal_datapath_width \
          TX_BUFFER_MODE 1 \
          TX_BUFFER_BYPASS_MODE Fast_Sync \
          TX_PIPM_ENABLE false \
          TX_OUTCLK_SOURCE TXPROGDIVCLK \
          TXPROGDIV_FREQ_ENABLE true \
          TXPROGDIV_FREQ_SOURCE LCPLL \
          TXPROGDIV_FREQ_VAL $tx_progdiv_clock \
          TX_DIFF_SWING_EMPH_MODE CUSTOM \
          TX_64B66B_SCRAMBLER false \
          TX_64B66B_ENCODER false \
          TX_64B66B_CRC false \
          TX_RATE_GROUP A \
          RX_LINE_RATE $rx_lane_rate \
          RX_PLL_TYPE LCPLL \
          RX_REFCLK_FREQUENCY $ref_clock \
          RX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
          RX_FRACN_ENABLED true \
          RX_FRACN_NUMERATOR 0 \
          RX_REFCLK_SOURCE R0 \
          RX_DATA_DECODING $data_encoding \
          RX_USER_DATA_WIDTH $datapath_width \
          RX_INT_DATA_WIDTH $internal_datapath_width \
          RX_BUFFER_MODE 1 \
          RX_OUTCLK_SOURCE RXPROGDIVCLK \
          RXPROGDIV_FREQ_ENABLE true \
          RXPROGDIV_FREQ_SOURCE LCPLL \
          RXPROGDIV_FREQ_VAL $rx_progdiv_clock \
          INS_LOSS_NYQ 12 \
          RX_EQ_MODE LPM \
          RX_COUPLING AC \
          RX_TERMINATION PROGRAMMABLE \
          RX_RATE_GROUP A \
          RX_TERMINATION_PROG_VALUE 800 \
          RX_PPM_OFFSET 0 \
          RX_64B66B_DESCRAMBLER false \
          RX_64B66B_DECODER false \
          RX_64B66B_CRC false \
          OOB_ENABLE false \
          RX_COMMA_ALIGN_WORD 1 \
          RX_COMMA_SHOW_REALIGN_ENABLE false \
          PCIE_ENABLE false \
          RX_COMMA_P_ENABLE $comma_p_enable \
          RX_COMMA_M_ENABLE $comma_m_enable \
          RX_COMMA_DOUBLE_ENABLE false \
          RX_COMMA_P_VAL 0101111100 \
          RX_COMMA_M_VAL 1010000011 \
          RX_COMMA_MASK $comma_mask \
          RX_SLIDE_MODE PCS \
          RX_SSC_PPM 0 \
          RX_CB_NUM_SEQ 0 \
          RX_CB_LEN_SEQ 1 \
          RX_CB_MAX_SKEW 1 \
          RX_CB_MAX_LEVEL 1 \
          RX_CB_MASK_0_0 false \
          RX_CB_VAL_0_0 00000000 \
          RX_CB_K_0_0 false \
          RX_CB_DISP_0_0 false \
          RX_CB_MASK_0_1 false \
          RX_CB_VAL_0_1 00000000 \
          RX_CB_K_0_1 false \
          RX_CB_DISP_0_1 false \
          RX_CB_MASK_0_2 false \
          RX_CB_VAL_0_2 00000000 \
          RX_CB_K_0_2 false \
          RX_CB_DISP_0_2 false \
          RX_CB_MASK_0_3 false \
          RX_CB_VAL_0_3 00000000 \
          RX_CB_K_0_3 false \
          RX_CB_DISP_0_3 false \
          RX_CB_MASK_1_0 false \
          RX_CB_VAL_1_0 00000000 \
          RX_CB_K_1_0 false \
          RX_CB_DISP_1_0 false \
          RX_CB_MASK_1_1 false \
          RX_CB_VAL_1_1 00000000 \
          RX_CB_K_1_1 false \
          RX_CB_DISP_1_1 false \
          RX_CB_MASK_1_2 false \
          RX_CB_VAL_1_2 00000000 \
          RX_CB_K_1_2 false \
          RX_CB_DISP_1_2 false \
          RX_CB_MASK_1_3 false \
          RX_CB_VAL_1_3 00000000 \
          RX_CB_K_1_3 false \
          RX_CB_DISP_1_3 false \
          RX_CC_NUM_SEQ 0 \
          RX_CC_LEN_SEQ 1 \
          RX_CC_PERIODICITY 5000 \
          RX_CC_KEEP_IDLE DISABLE \
          RX_CC_PRECEDENCE ENABLE \
          RX_CC_REPEAT_WAIT 0 \
          RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 \
          RX_CC_MASK_0_0 false \
          RX_CC_VAL_0_0 00000000 \
          RX_CC_K_0_0 false \
          RX_CC_DISP_0_0 false \
          RX_CC_MASK_0_1 false \
          RX_CC_VAL_0_1 00000000 \
          RX_CC_K_0_1 false \
          RX_CC_DISP_0_1 false \
          RX_CC_MASK_0_2 false \
          RX_CC_VAL_0_2 00000000 \
          RX_CC_K_0_2 false \
          RX_CC_DISP_0_2 false \
          RX_CC_MASK_0_3 false \
          RX_CC_VAL_0_3 00000000 \
          RX_CC_K_0_3 false \
          RX_CC_DISP_0_3 false \
          RX_CC_MASK_1_0 false \
          RX_CC_VAL_1_0 00000000 \
          RX_CC_K_1_0 false \
          RX_CC_DISP_1_0 false \
          RX_CC_MASK_1_1 false \
          RX_CC_VAL_1_1 00000000 \
          RX_CC_K_1_1 false \
          RX_CC_DISP_1_1 false \
          RX_CC_MASK_1_2 false \
          RX_CC_VAL_1_2 00000000 \
          RX_CC_K_1_2 false \
          RX_CC_DISP_1_2 false \
          RX_CC_MASK_1_3 false \
          RX_CC_VAL_1_3 00000000 \
          RX_CC_K_1_3 false \
          RX_CC_DISP_1_3 false \
          PCIE_USERCLK2_FREQ 250 \
          PCIE_USERCLK_FREQ 250 \
          RX_JTOL_FC 10 \
          RX_JTOL_LF_SLOPE -20 \
          RX_BUFFER_BYPASS_MODE Fast_Sync \
          RX_BUFFER_BYPASS_MODE_LANE MULTI \
          RX_BUFFER_RESET_ON_CB_CHANGE ENABLE \
          RX_BUFFER_RESET_ON_COMMAALIGN DISABLE \
          RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
          TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE \
          RESET_SEQUENCE_INTERVAL 0 \
          RX_COMMA_PRESET NONE \
          RX_COMMA_VALID_ONLY 0 \
        ] \
        CONFIG.PROT1_NO_OF_TX_LANES $tx_num_lanes \
        CONFIG.PROT1_PRESET ${preset} \
      ] [get_bd_cells ${ip_name}/gt_quad_base_${j}]

      for {set i 0} {$i < 4} {incr i} {
        set_property -dict [list \
          CONFIG.TX${i}_LANE_SEL.VALUE_MODE MANUAL \
          CONFIG.RX${i}_LANE_SEL.VALUE_MODE MANUAL \
        ] [get_bd_cells ${ip_name}/gt_quad_base_${j}]
      }
    }

    if {$intf_cfg != "TX"} {
      # Share the link clock generated by the first quad
      if {$j == 0} {
        ad_ip_instance bufg_gt ${ip_name}/bufg_gt_rx
        ad_connect ${ip_name}/gt_quad_base_0/ch0_rxoutclk ${ip_name}/bufg_gt_rx/outclk
        ad_connect ${ip_name}/${rx_bridge}/rx_clr_out ${ip_name}/bufg_gt_rx/gt_bufgtclr
        ad_connect ${ip_name}/${rx_bridge}/rxusrclk_out ${ip_name}/rxusrclk_out
        ad_connect ${ip_name}/bufg_gt_rx/usrclk ${ip_name}/${rx_bridge}/gt_rxusrclk
      }
      create_bd_pin -dir I -from 3 -to 0 ${ip_name}/rx_${j}_p
      create_bd_pin -dir I -from 3 -to 0 ${ip_name}/rx_${j}_n
      ad_connect ${ip_name}/gt_quad_base_${j}/rxp ${ip_name}/rx_${j}_p
      ad_connect ${ip_name}/gt_quad_base_${j}/rxn ${ip_name}/rx_${j}_n
    }
    if {$intf_cfg != "RX"} {
      # Share the link clock generated by the first quad
      if {$j == 0} {
        ad_ip_instance bufg_gt ${ip_name}/bufg_gt_tx
        ad_connect ${ip_name}/gt_quad_base_0/ch0_txoutclk ${ip_name}/bufg_gt_tx/outclk
        ad_connect ${ip_name}/${tx_bridge}/tx_clr_out ${ip_name}/bufg_gt_tx/gt_bufgtclr
        ad_connect ${ip_name}/${tx_bridge}/txusrclk_out ${ip_name}/txusrclk_out
        ad_connect ${ip_name}/bufg_gt_tx/usrclk ${ip_name}/${tx_bridge}/gt_txusrclk
      }
      create_bd_pin -dir O -from 3 -to 0 ${ip_name}/tx_${j}_p
      create_bd_pin -dir O -from 3 -to 0 ${ip_name}/tx_${j}_n
      ad_connect ${ip_name}/gt_quad_base_${j}/txp ${ip_name}/tx_${j}_p
      ad_connect ${ip_name}/gt_quad_base_${j}/txn ${ip_name}/tx_${j}_n
    }
  }

  if {$intf_cfg != "TX"} {
    for {set j 0} {$j < $rx_num_lanes} {incr j} {
      set quad_index [expr int($j / 4)]
      set rx_index [expr $j % 4]

      ad_connect ${ip_name}/bufg_gt_rx/usrclk ${ip_name}/gt_quad_base_${quad_index}/ch${rx_index}_rxusrclk
      ad_connect ${ip_name}/bufg_gt_rx/usrclk ${ip_name}/gt_quad_base_${quad_index}/ch${rx_index}_txusrclk

      ad_ip_instance jesd204_versal_gt_adapter_rx ${ip_name}/rx_adapt_${j} [list \
        LINK_MODE $link_mode \
      ]
      ad_connect ${ip_name}/rx_adapt_${j}/RX_GT_IP_Interface ${ip_name}/${rx_bridge}/GT_RX${j}_EXT
      ad_connect ${ip_name}/${rx_bridge}/GT_RX${j} ${ip_name}/gt_quad_base_${quad_index}/RX${rx_index}_GT_IP_Interface

      create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 ${ip_name}/rx${j}
      ad_connect ${ip_name}/rx${j} ${ip_name}/rx_adapt_${j}/RX
      ad_connect ${ip_name}/rx_adapt_${j}/usr_clk ${ip_name}/bufg_gt_rx/usrclk
      ad_connect ${ip_name}/rx_adapt_${j}/en_char_align ${ip_name}/en_char_align

      if {$asymmetric_mode} {
        set_property CONFIG.RX${rx_index}_LANE_SEL {PROT0} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
      }
    }
  }
  if {$intf_cfg != "RX"} {
    for {set j 0} {$j < $tx_num_lanes} {incr j} {
      set quad_index [expr int($j / 4)]
      set tx_index [expr $j % 4]

      ad_connect ${ip_name}/bufg_gt_tx/usrclk ${ip_name}/gt_quad_base_${quad_index}/ch${tx_index}_txusrclk

      ad_ip_instance jesd204_versal_gt_adapter_tx ${ip_name}/tx_adapt_${j} [list \
        LINK_MODE $link_mode \
      ]
      ad_connect ${ip_name}/tx_adapt_${j}/TX_GT_IP_Interface ${ip_name}/${tx_bridge}/GT_TX${j}_EXT
      ad_connect ${ip_name}/${tx_bridge}/GT_TX${j} ${ip_name}/gt_quad_base_${quad_index}/TX${tx_index}_GT_IP_Interface

      create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 ${ip_name}/tx${j}
      ad_connect ${ip_name}/tx${j} ${ip_name}/tx_adapt_${j}/TX
      ad_connect ${ip_name}/tx_adapt_${j}/usr_clk ${ip_name}/bufg_gt_tx/usrclk

      if {$asymmetric_mode} {
        set_property CONFIG.TX${tx_index}_LANE_SEL {PROT1} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
      }
    }
  }

  if {$asymmetric_mode} {
    # Map unused quad lanes as unconnected
    set max_num_of_lanes [expr $num_quads * 4]
    for {set j $rx_num_lanes} {$intf_cfg != "TX" && $j < $max_num_of_lanes} {incr j} {
      set quad_index [expr $j / 4]
      set lane_index [expr $j % 4]
      set_property CONFIG.RX${lane_index}_LANE_SEL {unconnected} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
    }
    for {set j $tx_num_lanes} {$intf_cfg != "RX" && $j < $max_num_of_lanes} {incr j} {
      set quad_index [expr $j / 4]
      set lane_index [expr $j % 4]
      set_property CONFIG.TX${lane_index}_LANE_SEL {unconnected} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
    }
  }

  # Clocks
  ad_connect ${ip_name}/s_axi_clk ${ip_name}/${rx_bridge}/apb3clk
  if {$asymmetric_mode} {
    ad_connect ${ip_name}/s_axi_clk ${ip_name}/${tx_bridge}/apb3clk
  }
  for {set j 0} {$j < $num_quads} {incr j} {
    ad_connect ${ip_name}/GT_REFCLK    ${ip_name}/gt_quad_base_${j}/GT_REFCLK0
    ad_connect ${ip_name}/s_axi_clk    ${ip_name}/gt_quad_base_${j}/s_axi_lite_clk
    ad_connect ${ip_name}/s_axi_resetn ${ip_name}/gt_quad_base_${j}/s_axi_lite_resetn
  }

  # Instantiate reset helper logic
  create_reset_logic $ip_name $rx_num_lanes $tx_num_lanes $intf_cfg
}
