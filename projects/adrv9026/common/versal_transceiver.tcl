###############################################################################
## Copyright (C) 2021-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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
#   generate_link_clk : If 1 use the generated link clocks from the AMD's IP, else use the JESD reference clock as the link clock

proc create_versal_phy {
  {ip_name versal_phy}
  {jesd_mode 8B10B}
  {rx_num_lanes 4}
  {tx_num_lanes 4}
  {rx_lane_rate 9.83}
  {tx_lane_rate 9.83}
  {ref_clock 245.76}
  {intf_cfg RXTX}
  {generate_link_clk 0}
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
set asymmetric_mode          [expr { [expr $rx_num_lanes != $tx_num_lanes] ? true : false } ]
# When asymmetric_mode is true it means that the number of lanes on the Rx side is different from the number of lanes on the Tx side
# The 'gt_bridge_ip' can only be configured with the same number of lanes so we need to instantiate two ips, one for the Rx and one for the Tx
# Both 'gt_bridge_ip' will still share the same quad

set rx_progdiv_clock [format %.3f [expr $rx_lane_rate * 1000 / ${clk_divider}]]
set tx_progdiv_clock [format %.3f [expr $tx_lane_rate * 1000 / ${clk_divider}]]

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
if {$intf_cfg != "TX"} {
  create_bd_pin -dir O ${ip_name}/rxusrclk_out -type clk
  create_bd_pin -dir I ${ip_name}/resetn
  create_bd_pin -dir I ${ip_name}/en_char_align
}
if {$intf_cfg != "RX"} {
  create_bd_pin -dir O ${ip_name}/txusrclk_out -type clk
}
create_bd_pin -dir I ${ip_name}/GT_REFCLK -type clk
create_bd_pin -dir I ${ip_name}/apb3clk -type clk
create_bd_pin -dir I ${ip_name}/gtreset_in
create_bd_pin -dir O ${ip_name}/gtpowergood
create_bd_pin -dir O ${ip_name}/gtresetdone
if {!$generate_link_clk} {
  create_bd_pin -dir I ${ip_name}/link_clk
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
    CONFIG.IP_PRESET GTY-JESD204_${jesd_mode} \
    CONFIG.IP_GT_DIRECTION ${gt_direction} \
    ${no_lanes_property} ${num_lanes} \
    CONFIG.IP_LR0_SETTINGS [list \
      PRESET GTY-JESD204_${jesd_mode} \
      INTERNAL_PRESET JESD204_${jesd_mode} \
      GT_TYPE GTY \
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
      CONFIG.IP_PRESET GTY-JESD204_${jesd_mode} \
      CONFIG.IP_GT_DIRECTION {SIMPLEX_RX} \
      CONFIG.IP_NO_OF_RX_LANES ${rx_num_lanes} \
      CONFIG.IP_LR0_SETTINGS [list \
        PRESET GTY-JESD204_${jesd_mode} \
        INTERNAL_PRESET JESD204_${jesd_mode} \
        GT_TYPE GTY \
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
    CONFIG.IP_PRESET GTY-JESD204_${jesd_mode} \
    CONFIG.IP_GT_DIRECTION {SIMPLEX_TX} \
    CONFIG.IP_NO_OF_TX_LANES ${tx_num_lanes} \
    CONFIG.IP_LR0_SETTINGS [list \
      PRESET GTY-JESD204_${jesd_mode} \
      INTERNAL_PRESET JESD204_${jesd_mode} \
      GT_TYPE GTY \
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
  if {!$asymmetric_mode} {
    set_property -dict [list \
      CONFIG.PROT0_GT_DIRECTION ${gt_direction} \
    ] [get_bd_cells ${ip_name}/gt_quad_base_${j}]
  } else {
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
        PRESET GTY-JESD204_${jesd_mode} \
        INTERNAL_PRESET JESD204_${jesd_mode} \
        GT_TYPE GTY \
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
      CONFIG.PROT0_PRESET GTY-JESD204_${jesd_mode} \
      CONFIG.PROT1_ENABLE {true} \
      CONFIG.PROT1_GT_DIRECTION {SIMPLEX_TX} \
      CONFIG.PROT1_LR0_SETTINGS [list \
        PRESET GTY-JESD204_${jesd_mode} \
        INTERNAL_PRESET JESD204_${jesd_mode} \
        GT_TYPE GTY \
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
      CONFIG.PROT1_PRESET GTY-JESD204_${jesd_mode} \
    ] [get_bd_cells ${ip_name}/gt_quad_base_${j}]

    set_property -dict [list \
      CONFIG.TX0_LANE_SEL.VALUE_MODE MANUAL \
      CONFIG.TX1_LANE_SEL.VALUE_MODE MANUAL \
      CONFIG.TX2_LANE_SEL.VALUE_MODE MANUAL \
      CONFIG.TX3_LANE_SEL.VALUE_MODE MANUAL \
      CONFIG.RX0_LANE_SEL.VALUE_MODE MANUAL \
      CONFIG.RX1_LANE_SEL.VALUE_MODE MANUAL \
      CONFIG.RX2_LANE_SEL.VALUE_MODE MANUAL \
      CONFIG.RX3_LANE_SEL.VALUE_MODE MANUAL \
    ] [get_bd_cells ${ip_name}/gt_quad_base_${j}]
  }

  if {$intf_cfg != "TX"} {
    if {$generate_link_clk} {
      ad_ip_instance bufg_gt ${ip_name}/bufg_gt_rx_${j}
      ad_connect ${ip_name}/gt_quad_base_${j}/ch0_rxoutclk ${ip_name}/bufg_gt_rx_${j}/outclk
    }
    create_bd_pin -dir I -from 3 -to 0 ${ip_name}/rx_${j}_p
    create_bd_pin -dir I -from 3 -to 0 ${ip_name}/rx_${j}_n
    ad_connect ${ip_name}/gt_quad_base_${j}/rxp ${ip_name}/rx_${j}_p
    ad_connect ${ip_name}/gt_quad_base_${j}/rxn ${ip_name}/rx_${j}_n
  }
  if {$intf_cfg != "RX"} {
    if {$generate_link_clk} {
      ad_ip_instance bufg_gt ${ip_name}/bufg_gt_tx_${j}
      ad_connect ${ip_name}/gt_quad_base_${j}/ch0_txoutclk ${ip_name}/bufg_gt_tx_${j}/outclk
    }
    create_bd_pin -dir O -from 3 -to 0 ${ip_name}/tx_${j}_p
    create_bd_pin -dir O -from 3 -to 0 ${ip_name}/tx_${j}_n
    ad_connect ${ip_name}/gt_quad_base_${j}/txp ${ip_name}/tx_${j}_p
    ad_connect ${ip_name}/gt_quad_base_${j}/txn ${ip_name}/tx_${j}_n
  }
}

if {$intf_cfg != "TX"} {
  if {$generate_link_clk} {
    ad_connect ${ip_name}/bufg_gt_rx_0/usrclk ${ip_name}/${rx_bridge}/gt_rxusrclk
    ad_connect ${ip_name}/${rx_bridge}/rxusrclk_out ${ip_name}/rxusrclk_out
  } else {
    ad_connect ${ip_name}/link_clk ${ip_name}/${rx_bridge}/gt_rxusrclk
    ad_connect ${ip_name}/link_clk ${ip_name}/rxusrclk_out
  }

  for {set j 0} {$j < $rx_num_lanes} {incr j} {
    set quad_index [expr int($j / 4)]
    set rx_index [expr $j % 4]

    ad_ip_instance jesd204_versal_gt_adapter_rx ${ip_name}/rx_adapt_${j} [list \
      LINK_MODE $link_mode \
    ]
    ad_connect ${ip_name}/rx_adapt_${j}/RX_GT_IP_Interface ${ip_name}/${rx_bridge}/GT_RX${j}_EXT
    ad_connect ${ip_name}/${rx_bridge}/GT_RX${j} ${ip_name}/gt_quad_base_${quad_index}/RX${rx_index}_GT_IP_Interface

    create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 ${ip_name}/rx${j}
    ad_connect ${ip_name}/rx${j} ${ip_name}/rx_adapt_${j}/RX
    if {$generate_link_clk} {
      ad_connect ${ip_name}/rx_adapt_${j}/usr_clk ${ip_name}/bufg_gt_rx_${quad_index}/usrclk
    } else {
      ad_connect ${ip_name}/link_clk ${ip_name}/rx_adapt_${j}/usr_clk
    }
    ad_connect ${ip_name}/rx_adapt_${j}/resetn  ${ip_name}/resetn
    ad_connect ${ip_name}/rx_adapt_${j}/en_char_align ${ip_name}/en_char_align

    set_property CONFIG.RX${rx_index}_LANE_SEL {PROT0} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
  }
}
if {$intf_cfg != "RX"} {
  if {$generate_link_clk} {
    ad_connect ${ip_name}/bufg_gt_tx_0/usrclk ${ip_name}/${tx_bridge}/gt_txusrclk
    ad_connect ${ip_name}/${tx_bridge}/txusrclk_out ${ip_name}/txusrclk_out
  } else {
    ad_connect ${ip_name}/link_clk ${ip_name}/${tx_bridge}/gt_txusrclk
    ad_connect ${ip_name}/link_clk ${ip_name}/txusrclk_out
  }

  for {set j 0} {$j < $tx_num_lanes} {incr j} {
    set quad_index [expr int($j / 4)]
    set tx_index [expr $j % 4]

    ad_ip_instance jesd204_versal_gt_adapter_tx ${ip_name}/tx_adapt_${j} [list \
      LINK_MODE $link_mode \
    ]
    ad_connect ${ip_name}/tx_adapt_${j}/TX_GT_IP_Interface ${ip_name}/${tx_bridge}/GT_TX${j}_EXT
    ad_connect ${ip_name}/${tx_bridge}/GT_TX${j} ${ip_name}/gt_quad_base_${quad_index}/TX${tx_index}_GT_IP_Interface

    create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 ${ip_name}/tx${j}
    ad_connect ${ip_name}/tx${j} ${ip_name}/tx_adapt_${j}/TX
    if {$generate_link_clk} {
      ad_connect ${ip_name}/bufg_gt_tx_${quad_index}/usrclk ${ip_name}/tx_adapt_${j}/usr_clk
    } else {
      ad_connect ${ip_name}/link_clk ${ip_name}/tx_adapt_${j}/usr_clk
    }
    if {!$asymmetric_mode} {
      set_property CONFIG.TX${tx_index}_LANE_SEL {PROT0} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
    } else {
      set_property CONFIG.TX${tx_index}_LANE_SEL {PROT1} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
    }
  }
}

set max_num_of_lanes [expr $num_quads * 4]
for {set j $rx_num_lanes} {$j < $max_num_of_lanes} {incr j} {
  set quad_index [expr $j / 4]
  set lane_index [expr $j % 4]
  set_property CONFIG.RX${lane_index}_LANE_SEL {unconnected} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
}
for {set j $tx_num_lanes} {$j < $max_num_of_lanes} {incr j} {
  set quad_index [expr $j / 4]
  set lane_index [expr $j % 4]
  set_property CONFIG.TX${lane_index}_LANE_SEL {unconnected} [get_bd_cells ${ip_name}/gt_quad_base_${quad_index}]
}

for {set i 0} {$i < $num_quads} {incr i} {
  for {set j 0} {$j < 4} {incr j} {
    if {$intf_cfg != "TX"} {
      if {$generate_link_clk} {
        ad_connect ${ip_name}/bufg_gt_rx_${i}/usrclk ${ip_name}/gt_quad_base_${i}/ch${j}_rxusrclk
      } else {
        ad_connect ${ip_name}/link_clk ${ip_name}/gt_quad_base_${i}/ch${j}_rxusrclk
      }
    }
    if {$intf_cfg != "RX"} {
      if {$generate_link_clk} {
        ad_connect ${ip_name}/bufg_gt_tx_${i}/usrclk ${ip_name}/gt_quad_base_${i}/ch${j}_txusrclk
      } else {
        ad_connect ${ip_name}/link_clk ${ip_name}/gt_quad_base_${i}/ch${j}_txusrclk
      }
    }
  }
}

# Clocks and gtpowergood
ad_connect ${ip_name}/apb3clk ${ip_name}/${rx_bridge}/apb3clk
if {$asymmetric_mode} {
  ad_connect ${ip_name}/apb3clk ${ip_name}/${tx_bridge}/apb3clk
}

ad_ip_instance xlconcat ${ip_name}/xlconcat_0 [list \
   NUM_PORTS $num_quads \
 ]
ad_ip_instance util_reduced_logic ${ip_name}/util_reduced_logic_0 [list \
   C_SIZE $num_quads \
 ]

for {set j 0} {$j < $num_quads} {incr j} {
  ad_connect ${ip_name}/xlconcat_0/In${j} ${ip_name}/gt_quad_base_${j}/gtpowergood
  ad_connect ${ip_name}/apb3clk ${ip_name}/gt_quad_base_${j}/apb3clk
  ad_connect ${ip_name}/GT_REFCLK ${ip_name}/gt_quad_base_${j}/GT_REFCLK0
}

ad_connect ${ip_name}/xlconcat_0/dout ${ip_name}/util_reduced_logic_0/Op1
ad_connect ${ip_name}/util_reduced_logic_0/Res ${ip_name}/${rx_bridge}/gtpowergood
ad_connect ${ip_name}/util_reduced_logic_0/Res ${ip_name}/gtpowergood
if {$asymmetric_mode} {
  ad_connect ${ip_name}/util_reduced_logic_0/Res ${ip_name}/${tx_bridge}/gtpowergood
}

# Reset
ad_connect ${ip_name}/gtreset_in ${ip_name}/${rx_bridge}/gtreset_in
if {$asymmetric_mode} {
  ad_connect ${ip_name}/gtreset_in ${ip_name}/${tx_bridge}/gtreset_in
}
# Quad resets
for {set j 0} {$j < ${max_num_of_lanes}} {incr j} {
  set quad_index [expr int($j / 4)]
  set ch_index [expr $j % 4]
  ad_connect ${ip_name}/${rx_bridge}/gt_ilo_reset ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloreset
}
for {set j 0} {$j < ${num_quads}} {incr j} {
  ad_connect ${ip_name}/${rx_bridge}/gt_pll_reset ${ip_name}/gt_quad_base_${j}/hsclk0_lcpllreset
  ad_connect ${ip_name}/${rx_bridge}/gt_pll_reset ${ip_name}/gt_quad_base_${j}/hsclk1_lcpllreset
}
# Resets done
ad_ip_instance xlconcat ${ip_name}/xlconcat_iloresetdone_rx [list \
    NUM_PORTS ${rx_num_lanes} \
]
ad_ip_instance util_reduced_logic ${ip_name}/util_reduced_logic_iloresetdone_rx [list \
    C_SIZE ${rx_num_lanes} \
]
for {set j 0} {$j < ${rx_num_lanes}} {incr j} {
  set quad_index [expr int($j / 4)]
  set ch_index [expr $j % 4]
  ad_connect ${ip_name}/xlconcat_iloresetdone_rx/In${j} ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloresetdone
}
ad_connect ${ip_name}/xlconcat_iloresetdone_rx/dout ${ip_name}/util_reduced_logic_iloresetdone_rx/Op1
ad_connect ${ip_name}/util_reduced_logic_iloresetdone_rx/Res ${ip_name}/${rx_bridge}/ilo_resetdone
if {$asymmetric_mode} {
  ad_ip_instance xlconcat ${ip_name}/xlconcat_iloresetdone_tx [list \
    NUM_PORTS ${tx_num_lanes} \
]
  ad_ip_instance util_reduced_logic ${ip_name}/util_reduced_logic_iloresetdone_tx [list \
      C_SIZE ${tx_num_lanes} \
  ]
  for {set j 0} {$j < ${tx_num_lanes}} {incr j} {
    set quad_index [expr int($j / 4)]
    set ch_index [expr $j % 4]
    ad_connect ${ip_name}/xlconcat_iloresetdone_tx/In${j} ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloresetdone
  }
  ad_connect ${ip_name}/xlconcat_iloresetdone_tx/dout ${ip_name}/util_reduced_logic_iloresetdone_tx/Op1
  ad_connect ${ip_name}/util_reduced_logic_iloresetdone_tx/Res ${ip_name}/${tx_bridge}/ilo_resetdone
}

set num_cplllocks [expr 2 * ${num_quads}]
ad_ip_instance xlconcat ${ip_name}/xlconcat_cplllock [list \
    NUM_PORTS ${num_cplllocks} \
  ]
ad_ip_instance util_reduced_logic ${ip_name}/util_reduced_logic_cplllock [list \
    C_SIZE ${num_cplllocks} \
  ]

for {set j 0} {$j < ${num_quads}} {incr j} {
  set in_index_0 [expr $j * 2 + 0]
  set in_index_1 [expr $j * 2 + 1]
  ad_connect ${ip_name}/xlconcat_cplllock/In${in_index_0} ${ip_name}/gt_quad_base_${j}/hsclk0_lcplllock
  ad_connect ${ip_name}/xlconcat_cplllock/In${in_index_1} ${ip_name}/gt_quad_base_${j}/hsclk1_lcplllock
}

ad_connect ${ip_name}/xlconcat_cplllock/dout ${ip_name}/util_reduced_logic_cplllock/Op1
ad_connect ${ip_name}/util_reduced_logic_cplllock/Res ${ip_name}/${rx_bridge}/gt_lcpll_lock
if {$asymmetric_mode} {
  ad_connect ${ip_name}/util_reduced_logic_cplllock/Res ${ip_name}/${tx_bridge}/gt_lcpll_lock
}

ad_ip_instance xlconcat ${ip_name}/xlconcat_phystatus_rx [list \
    NUM_PORTS ${rx_num_lanes} \
 ]
for {set j 0} {$j < ${rx_num_lanes}} {incr j} {
  set quad_index [expr int($j / 4)]
  set ch_index [expr $j % 4]
  ad_connect ${ip_name}/xlconcat_phystatus_rx/In${j} ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_phystatus
}
ad_connect ${ip_name}/xlconcat_phystatus_rx/dout ${ip_name}/${rx_bridge}/ch_phystatus_in
if {$asymmetric_mode} {
  ad_ip_instance xlconcat ${ip_name}/xlconcat_phystatus_tx [list \
    NUM_PORTS ${tx_num_lanes} \
 ]
  for {set j 0} {$j < ${tx_num_lanes}} {incr j} {
    set quad_index [expr int($j / 4)]
    set ch_index [expr $j % 4]
    ad_connect ${ip_name}/xlconcat_phystatus_tx/In${j} ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_phystatus
  }
  ad_connect ${ip_name}/xlconcat_phystatus_tx/dout ${ip_name}/${tx_bridge}/ch_phystatus_in
}

ad_ip_instance xlconcat ${ip_name}/xlconcat_resetdone [list \
    NUM_PORTS {2} \
 ]
ad_ip_instance util_reduced_logic ${ip_name}/resetdone_and [list \
    C_SIZE {2} \
 ]
if {$intf_cfg != "TX"} {
  ad_connect ${ip_name}/${rx_bridge}/rx_resetdone_out ${ip_name}/xlconcat_resetdone/In0
} else {
  ad_connect VCC ${ip_name}/xlconcat_resetdone/In0
}
if {$intf_cfg != "RX"} {
  if {!$asymmetric_mode} {
    ad_connect ${ip_name}/${rx_bridge}/rx_resetdone_out ${ip_name}/xlconcat_resetdone/In1
  } else {
    ad_connect ${ip_name}/${tx_bridge}/tx_resetdone_out ${ip_name}/xlconcat_resetdone/In1
  }
} else {
  ad_connect VCC ${ip_name}/xlconcat_resetdone/In1
}
ad_connect ${ip_name}/xlconcat_resetdone/dout ${ip_name}/resetdone_and/Op1
ad_connect ${ip_name}/resetdone_and/Res ${ip_name}/gtresetdone

}
