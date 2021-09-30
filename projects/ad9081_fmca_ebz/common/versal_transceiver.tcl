
set top_design [current_bd_design]

create_bd_design "jesd_phy"

create_bd_cell -type ip -vlnv xilinx.com:ip:gt_bridge_ip:1.1 gt_bridge_ip_0

set_property -dict [list \
  CONFIG.BYPASS_MODE {true} \
  CONFIG.IP_PRESET {GTY-JESD204_64B66B} \
  CONFIG.IP_LR0_SETTINGS { \
     PRESET GTY-JESD204_64B66B \
     INTERNAL_PRESET JESD204_64B66B \
     GT_TYPE GTY \
     GT_DIRECTION DUPLEX \
     TX_LINE_RATE 24.75 \
     TX_PLL_TYPE LCPLL \
     TX_REFCLK_FREQUENCY 375 \
     TX_ACTUAL_REFCLK_FREQUENCY 375.000000000000 \
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
     TXPROGDIV_FREQ_VAL 375.000 \
     TX_DIFF_SWING_EMPH_MODE CUSTOM \
     TX_64B66B_SCRAMBLER false \
     TX_64B66B_ENCODER false \
     TX_64B66B_CRC false \
     TX_RATE_GROUP A \
     RX_LINE_RATE 24.75 \
     RX_PLL_TYPE LCPLL \
     RX_REFCLK_FREQUENCY 375 \
     RX_ACTUAL_REFCLK_FREQUENCY 375.000000000000 \
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
     RXPROGDIV_FREQ_VAL 375.000 \
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
     } \
] [get_bd_cells gt_bridge_ip_0]

apply_bd_automation -rule xilinx.com:bd_rule:gt_ips -config { DataPath_Interface_Connection {Auto} Lane0_selection {NULL} Lane10_selection {NULL} Lane11_selection {NULL} Lane12_selection {NULL} Lane13_selection {NULL} Lane14_selection {NULL} Lane15_selection {NULL} Lane16_selection {NULL} Lane17_selection {NULL} Lane18_selection {NULL} Lane19_selection {NULL} Lane1_selection {NULL} Lane2_selection {NULL} Lane3_selection {NULL} Lane4_selection {NULL} Lane5_selection {NULL} Lane6_selection {NULL} Lane7_selection {NULL} Lane8_selection {NULL} Lane9_selection {NULL} Quad0_selection {NULL} Quad10_selection {NULL} Quad11_selection {NULL} Quad12_selection {NULL} Quad13_selection {NULL} Quad14_selection {NULL} Quad15_selection {NULL} Quad16_selection {NULL} Quad17_selection {NULL} Quad18_selection {NULL} Quad19_selection {NULL} Quad1_selection {NULL} Quad2_selection {NULL} Quad3_selection {NULL} Quad4_selection {NULL} Quad5_selection {NULL} Quad6_selection {NULL} Quad7_selection {NULL} Quad8_selection {NULL} Quad9_selection {NULL}}  [get_bd_cells gt_bridge_ip_0]

validate_bd_design

save_bd_design
close_bd_design [current_bd_design]

current_bd_design [get_bd_designs $top_design]

