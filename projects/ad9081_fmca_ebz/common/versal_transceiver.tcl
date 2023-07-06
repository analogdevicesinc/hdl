###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc create_versal_phy {
  {ip_name versal_phy}
  {num_lanes 4}
  {rx_lane_rate 24.75}
  {tx_lane_rate 24.75}
  {ref_clock 375}
  {intf_cfg RXTX}
} {

set num_quads [expr int(round(1.0 * $num_lanes / 4))]
set rx_progdiv_clock [format %.3f [expr $rx_lane_rate * 1000 / 66]]
set tx_progdiv_clock [format %.3f [expr $tx_lane_rate * 1000 / 66]]

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
}
if {$intf_cfg != "RX"} {
  create_bd_pin -dir O ${ip_name}/txusrclk_out -type clk
}
create_bd_pin -dir I ${ip_name}/GT_REFCLK -type clk
create_bd_pin -dir I ${ip_name}/apb3clk -type clk
create_bd_pin -dir I ${ip_name}/gtreset_in

ad_ip_instance gt_bridge_ip ${ip_name}/gt_bridge_ip_0
set_property -dict [list \
  CONFIG.BYPASS_MODE {true} \
  CONFIG.IP_PRESET {GTY-JESD204_64B66B} \
  CONFIG.IP_GT_DIRECTION ${gt_direction} \
  ${no_lanes_property} ${num_lanes} \
  CONFIG.IP_LR0_SETTINGS [list \
     PRESET GTY-JESD204_64B66B \
     INTERNAL_PRESET JESD204_64B66B \
     GT_TYPE GTY \
     GT_DIRECTION $gt_direction \
     TX_LINE_RATE $tx_lane_rate \
     TX_PLL_TYPE LCPLL \
     TX_REFCLK_FREQUENCY $ref_clock \
     TX_ACTUAL_REFCLK_FREQUENCY $ref_clock \
     TX_FRACN_ENABLED true \
     TX_FRACN_NUMERATOR 0 \
     TX_REFCLK_SOURCE R0 \
     TX_DATA_ENCODING 64B66B_ASYNC \
     TX_USER_DATA_WIDTH 64 \
     TX_INT_DATA_WIDTH 64 \
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
     RX_DATA_DECODING 64B66B_ASYNC \
     RX_USER_DATA_WIDTH 64 \
     RX_INT_DATA_WIDTH 64 \
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
     RX_COMMA_SHOW_REALIGN_ENABLE true \
     PCIE_ENABLE false \
     RX_COMMA_P_ENABLE false \
     RX_COMMA_M_ENABLE false \
     RX_COMMA_DOUBLE_ENABLE false \
     RX_COMMA_P_VAL 0101111100 \
     RX_COMMA_M_VAL 1010000011 \
     RX_COMMA_MASK 0000000000 \
     RX_SLIDE_MODE OFF \
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
] [get_bd_cells ${ip_name}/gt_bridge_ip_0]

for {set j 0} {$j < $num_quads} {incr j} {
  ad_ip_instance gt_quad_base ${ip_name}/gt_quad_base_${j}
  set_property -dict [list \
    CONFIG.PROT0_GT_DIRECTION ${gt_direction} \
  ] [get_bd_cells ${ip_name}/gt_quad_base_${j}]

  if {$intf_cfg != "TX"} {
    ad_ip_instance bufg_gt ${ip_name}/bufg_gt_rx_${j}
    ad_connect ${ip_name}/gt_quad_base_${j}/ch0_rxoutclk ${ip_name}/bufg_gt_rx_${j}/outclk
  }
  if {$intf_cfg != "RX"} {
    ad_ip_instance bufg_gt ${ip_name}/bufg_gt_tx_${j}
    ad_connect ${ip_name}/gt_quad_base_${j}/ch0_txoutclk ${ip_name}/bufg_gt_tx_${j}/outclk
  }

  create_bd_intf_pin -mode Master -vlnv	xilinx.com:interface:gt_rtl:1.0 ${ip_name}/GT_Serial_${j}
  ad_connect ${ip_name}/gt_quad_base_${j}/GT_Serial ${ip_name}/GT_Serial_${j}
}

if {$intf_cfg != "TX"} {
  ad_connect ${ip_name}/bufg_gt_rx_0/usrclk ${ip_name}/gt_bridge_ip_0/gt_rxusrclk
  ad_connect ${ip_name}/gt_bridge_ip_0/rxusrclk_out ${ip_name}/rxusrclk_out

  for {set j 0} {$j < $num_lanes} {incr j} {
    set quad_index [expr int($j / 4)]
    set rx_index [expr $j % 4]

    ad_ip_instance jesd204_versal_gt_adapter_rx ${ip_name}/rx_adapt_${j}
    ad_connect ${ip_name}/rx_adapt_${j}/RX_GT_IP_Interface ${ip_name}/gt_bridge_ip_0/GT_RX${j}_EXT
    ad_connect ${ip_name}/gt_bridge_ip_0/GT_RX${j} ${ip_name}/gt_quad_base_${quad_index}/RX${rx_index}_GT_IP_Interface

    create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 ${ip_name}/rx${j}
    ad_connect ${ip_name}/rx${j} ${ip_name}/rx_adapt_${j}/RX

    ad_connect ${ip_name}/bufg_gt_rx_${quad_index}/usrclk ${ip_name}/rx_adapt_${j}/usr_clk
  }
}
if {$intf_cfg != "RX"} {
  ad_connect ${ip_name}/bufg_gt_tx_0/usrclk ${ip_name}/gt_bridge_ip_0/gt_txusrclk
  ad_connect ${ip_name}/gt_bridge_ip_0/txusrclk_out ${ip_name}/txusrclk_out

  for {set j 0} {$j < $num_lanes} {incr j} {
    set quad_index [expr int($j / 4)]
    set tx_index [expr $j % 4]

    ad_ip_instance jesd204_versal_gt_adapter_tx ${ip_name}/tx_adapt_${j}
    ad_connect ${ip_name}/tx_adapt_${j}/TX_GT_IP_Interface ${ip_name}/gt_bridge_ip_0/GT_TX${j}_EXT
    ad_connect ${ip_name}/gt_bridge_ip_0/GT_TX${j} ${ip_name}/gt_quad_base_${quad_index}/TX${tx_index}_GT_IP_Interface

    create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 ${ip_name}/tx${j}
    ad_connect ${ip_name}/tx${j} ${ip_name}/tx_adapt_${j}/TX

    ad_connect ${ip_name}/bufg_gt_tx_${quad_index}/usrclk ${ip_name}/tx_adapt_${j}/usr_clk
  }
}

for {set i 0} {$i < $num_quads} {incr i} {
  for {set j 0} {$j < 4} {incr j} {
    if {$intf_cfg != "TX"} {
      ad_connect ${ip_name}/bufg_gt_rx_${i}/usrclk ${ip_name}/gt_quad_base_${i}/ch${j}_rxusrclk
    }
    if {$intf_cfg != "RX"} {
      ad_connect ${ip_name}/bufg_gt_tx_${i}/usrclk ${ip_name}/gt_quad_base_${i}/ch${j}_txusrclk
    }
  }
}

# Clocks and gtpowergood
ad_connect ${ip_name}/apb3clk ${ip_name}/gt_bridge_ip_0/apb3clk

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
ad_connect ${ip_name}/util_reduced_logic_0/Res ${ip_name}/gt_bridge_ip_0/gtpowergood

# Reset
ad_connect ${ip_name}/gtreset_in ${ip_name}/gt_bridge_ip_0/gtreset_in

for {set j 0} {$j < ${num_lanes}} {incr j} {
  set quad_index [expr int($j / 4)]
  set ch_index [expr $j % 4]
  ad_connect ${ip_name}/gt_bridge_ip_0/gt_ilo_reset ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloreset
}
ad_ip_instance xlconcat ${ip_name}/xlconcat_iloresetdone [list \
    NUM_PORTS ${num_lanes} \
 ]
ad_ip_instance util_reduced_logic ${ip_name}/util_reduced_logic_iloresetdone [list \
    C_SIZE ${num_lanes} \
 ]
for {set j 0} {$j < ${num_lanes}} {incr j} {
  set quad_index [expr int($j / 4)]
  set ch_index [expr $j % 4]
  ad_connect ${ip_name}/xlconcat_iloresetdone/In${j} ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_iloresetdone
}
ad_connect ${ip_name}/xlconcat_iloresetdone/dout ${ip_name}/util_reduced_logic_iloresetdone/Op1
ad_connect ${ip_name}/util_reduced_logic_iloresetdone/Res ${ip_name}/gt_bridge_ip_0/ilo_resetdone

for {set j 0} {$j < ${num_quads}} {incr j} {
  ad_connect ${ip_name}/gt_bridge_ip_0/gt_pll_reset ${ip_name}/gt_quad_base_${j}/hsclk0_lcpllreset
  ad_connect ${ip_name}/gt_bridge_ip_0/gt_pll_reset ${ip_name}/gt_quad_base_${j}/hsclk1_lcpllreset
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
ad_connect ${ip_name}/util_reduced_logic_cplllock/Res ${ip_name}/gt_bridge_ip_0/gt_lcpll_lock

ad_ip_instance xlconcat ${ip_name}/xlconcat_ch [list \
   NUM_PORTS ${num_lanes} \
 ]
for {set j 0} {$j < ${num_lanes}} {incr j} {
  set quad_index [expr int($j / 4)]
  set ch_index [expr $j % 4]
  ad_ip_instance xlslice ${ip_name}/slice_ch${j} [list \
    DIN_WIDTH 16 \
  ]
  ad_connect ${ip_name}/slice_ch${j}/Din ${ip_name}/gt_quad_base_${quad_index}/ch${ch_index}_pcsrsvdout

  ad_connect ${ip_name}/slice_ch${j}/Dout ${ip_name}/xlconcat_ch/In${j}
}
ad_connect ${ip_name}/xlconcat_ch/dout ${ip_name}/gt_bridge_ip_0/ch_phystatus_in

}
