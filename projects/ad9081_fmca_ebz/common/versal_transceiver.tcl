
# TODO: This works only up to 4 lanes on 64B66B
proc create_versal_phy {
  {ip_name versal_phy}
  {num_lanes 2}
  {lane_rate 11.88}
  {ref_clock 360}
} {

set num_quads [expr round(1.0*$num_lanes/4)]
set progdiv_clock [format %.3f [expr $lane_rate * 1000 / 66]]

create_bd_cell -type hier ${ip_name}

# Common interface
create_bd_pin -dir O ${ip_name}/rxusrclk_out -type clk
create_bd_pin -dir O ${ip_name}/txusrclk_out -type clk

create_bd_pin -dir I ${ip_name}/GT_REFCLK -type clk

create_bd_pin -dir I ${ip_name}/apb3clk -type clk
create_bd_pin -dir I ${ip_name}/reset_rx_pll_and_datapath_in
create_bd_pin -dir I ${ip_name}/reset_tx_pll_and_datapath_in

ad_ip_instance gt_bridge_ip ${ip_name}/gt_bridge_ip_0

set_property -dict [list \
  CONFIG.BYPASS_MODE {true} \
  CONFIG.IP_NO_OF_LANES ${num_lanes} \
  CONFIG.IP_PRESET {GTY-JESD204_64B66B} \
  CONFIG.IP_LR0_SETTINGS [list \
     PRESET GTY-JESD204_64B66B \
     INTERNAL_PRESET JESD204_64B66B \
     GT_TYPE GTY \
     GT_DIRECTION DUPLEX \
     TX_LINE_RATE $lane_rate \
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
     TXPROGDIV_FREQ_VAL $progdiv_clock \
     TX_DIFF_SWING_EMPH_MODE CUSTOM \
     TX_64B66B_SCRAMBLER false \
     TX_64B66B_ENCODER false \
     TX_64B66B_CRC false \
     TX_RATE_GROUP A \
     RX_LINE_RATE $lane_rate \
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
     RXPROGDIV_FREQ_VAL $progdiv_clock \
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

ad_ip_instance gt_quad_base ${ip_name}/gt_quad_base_0
create_bd_intf_pin -mode Master -vlnv	xilinx.com:interface:gt_rtl:1.0 ${ip_name}/GT_Serial
ad_connect ${ip_name}/gt_quad_base_0/GT_Serial ${ip_name}/GT_Serial

ad_ip_instance bufg_gt ${ip_name}/bufg_gt_rx
ad_ip_instance bufg_gt ${ip_name}/bufg_gt_tx

ad_connect ${ip_name}/gt_quad_base_0/ch0_rxoutclk ${ip_name}/bufg_gt_rx/outclk
ad_connect ${ip_name}/gt_quad_base_0/ch0_txoutclk ${ip_name}/bufg_gt_tx/outclk

ad_connect ${ip_name}/bufg_gt_rx/usrclk ${ip_name}/gt_bridge_ip_0/gt_rxusrclk
ad_connect ${ip_name}/bufg_gt_tx/usrclk ${ip_name}/gt_bridge_ip_0/gt_txusrclk

ad_connect ${ip_name}/gt_bridge_ip_0/rxusrclk_out ${ip_name}/rxusrclk_out
ad_connect ${ip_name}/gt_bridge_ip_0/txusrclk_out ${ip_name}/txusrclk_out

for {set j 0} {$j < $num_lanes} {incr j} {
  ad_ip_instance jesd204_versal_gt_adapter_tx ${ip_name}/tx_adapt_${j}
  ad_connect ${ip_name}/tx_adapt_${j}/TX_GT_IP_Interface ${ip_name}/gt_bridge_ip_0/GT_TX${j}_EXT

  # TODO: This works only up to 4 lanes
  ad_connect ${ip_name}/gt_bridge_ip_0/GT_TX${j} ${ip_name}/gt_quad_base_0/TX${j}_GT_IP_Interface
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 ${ip_name}/tx${j}
  ad_connect ${ip_name}/tx${j} ${ip_name}/tx_adapt_${j}/TX

  ad_connect ${ip_name}/bufg_gt_tx/usrclk ${ip_name}/tx_adapt_${j}/usr_clk

}

for {set j 0} {$j < $num_lanes} {incr j} {
  ad_ip_instance jesd204_versal_gt_adapter_rx ${ip_name}/rx_adapt_${j}
  ad_connect ${ip_name}/rx_adapt_${j}/RX_GT_IP_Interface ${ip_name}/gt_bridge_ip_0/GT_RX${j}_EXT

  # TODO: This works only up to 4 lanes
  ad_connect ${ip_name}/gt_bridge_ip_0/GT_RX${j} ${ip_name}/gt_quad_base_0/RX${j}_GT_IP_Interface
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 ${ip_name}/rx${j}
  ad_connect ${ip_name}/rx${j} ${ip_name}/rx_adapt_${j}/RX

  ad_connect ${ip_name}/bufg_gt_rx/usrclk ${ip_name}/rx_adapt_${j}/usr_clk

}

for {set i 0} {$i < $num_quads} {incr i} {
  for {set j 0} {$j < 4} {incr j} {
    ad_connect ${ip_name}/bufg_gt_rx/usrclk ${ip_name}/gt_quad_base_${i}/ch${j}_rxusrclk
    ad_connect ${ip_name}/bufg_gt_tx/usrclk ${ip_name}/gt_quad_base_${i}/ch${j}_txusrclk
  }
}

# Clocks and resets
ad_connect ${ip_name}/apb3clk ${ip_name}/gt_bridge_ip_0/apb3clk
ad_connect GND ${ip_name}/gt_bridge_ip_0/gtreset_in
ad_connect ${ip_name}/reset_rx_pll_and_datapath_in ${ip_name}/gt_bridge_ip_0/reset_rx_pll_and_datapath_in
ad_connect ${ip_name}/reset_tx_pll_and_datapath_in ${ip_name}/gt_bridge_ip_0/reset_tx_pll_and_datapath_in

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

}

