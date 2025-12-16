###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Constants
set ::LANES_PER_QUAD 4

# Parameter description:
#   ip_name : The name of the created ip
#   jesd_mode : Used physical layer encoder mode (64B66B or 8B10B)
#   rx_no_lanes :  Number of RX lanes
#   tx_no_lanes :  Number of TX lanes
#   ref_clock : Frequency of reference clock in MHz used in 64B66B mode (LANE_RATE/66) or 8B10B mode (LANE_RATE/40)
#   rx_lane_rate : Line rate of the Rx link ( e.g. MxFE to FPGA ) in GHz
#   tx_lane_rate : Line rate of the Tx link ( e.g. FPGA to MxFE ) in GHz
#   transceiver : Type of transceiver to use (GTY or GTYP)
#   direction : Direction of the transceivers
#       RXTX : Duplex mode
#       RX   : Rx link only
#       TX   : Tx link only
#
# Returns: Nothing. Creates and configures a gtwiz_versal IP instance.
proc create_xcvr_subsystem {
  {ip_name xcvr}
  {jesd_mode 64B66B}
  {rx_no_lanes 4}
  {tx_no_lanes 4}
  {rx_lane_rate 24.75}
  {tx_lane_rate 24.75}
  {ref_clock 375}
  {transceiver GTY}
  {direction RX}
} {
  global LANES_PER_QUAD

  # Input validation
  if {$jesd_mode ni {64B66B 8B10B}} {
    error "Invalid jesd_mode '$jesd_mode'. Must be 64B66B or 8B10B."
  }
  if {$direction ni {RXTX RX TX}} {
    error "Invalid direction '$direction'. Must be RXTX, RX, or TX."
  }
  if {$transceiver ni {GTY GTYP}} {
    error "Invalid transceiver '$transceiver'. Must be GTY or GTYP."
  }

  set is_64b66b [expr {$jesd_mode == "64B66B"}]
  set clk_divider              [expr {$is_64b66b ? 66 : 40}]
  set datapath_width           [expr {$is_64b66b ? 64 : 32}]
  set internal_datapath_width  [expr {$is_64b66b ? 64 : 40}]
  set data_encoding            [expr {$is_64b66b ? "64B66B_ASYNC" : "8B10B"}]
  set comma_mask               [expr {$is_64b66b ? "0000000000" : "1111111111"}]
  set comma_p_enable           [expr {$is_64b66b ? false : false}]
  set comma_m_enable           [expr {$is_64b66b ? false : false}]
  set rx_progdiv_clock         [format %.3f [expr {$rx_lane_rate * 1000.0 / $clk_divider}]]
  set tx_progdiv_clock         [format %.3f [expr {$tx_lane_rate * 1000.0 / $clk_divider}]]

  if {$direction == "RXTX"} {
    set no_lanes [expr {max($rx_no_lanes, $tx_no_lanes)}]
  } elseif {$direction == "RX"} {
    set no_lanes $rx_no_lanes
  } else {
    set no_lanes $tx_no_lanes
  }
  set num_quads [expr {int(ceil(1.0 * $no_lanes / $LANES_PER_QUAD))}]

  ad_ip_instance gtwiz_versal ${ip_name}

  set xcvr_param [dict create]

  # RX parameters
  dict set xcvr_param RX_LINE_RATE ${rx_lane_rate}
  dict set xcvr_param RX_DATA_DECODING ${data_encoding}
  dict set xcvr_param RX_REFCLK_FREQUENCY ${ref_clock}
  dict set xcvr_param RX_USER_DATA_WIDTH ${datapath_width}
  dict set xcvr_param RX_INT_DATA_WIDTH ${internal_datapath_width}
  dict set xcvr_param RX_OUTCLK_SOURCE {RXPROGDIVCLK}
  dict set xcvr_param RXRECCLK_FREQ_VAL ${rx_progdiv_clock}
  dict set xcvr_param RXPROGDIV_FREQ_VAL ${rx_progdiv_clock}
  dict set xcvr_param RX_PLL_TYPE {LCPLL}
  if {!$is_64b66b} {
    dict set xcvr_param RX_COMMA_P_ENABLE ${comma_p_enable}
    dict set xcvr_param RX_COMMA_M_ENABLE ${comma_m_enable}
    dict set xcvr_param RX_COMMA_SHOW_REALIGN_ENABLE {false}
    dict set xcvr_param RX_SLIDE_MODE {PCS}
  }

  # TX parameters
  dict set xcvr_param TX_LINE_RATE ${tx_lane_rate}
  dict set xcvr_param TX_DATA_ENCODING ${data_encoding}
  dict set xcvr_param TX_REFCLK_FREQUENCY ${ref_clock}
  dict set xcvr_param TX_USER_DATA_WIDTH ${datapath_width}
  dict set xcvr_param TX_INT_DATA_WIDTH ${internal_datapath_width}
  dict set xcvr_param TXPROGDIV_FREQ_VAL ${tx_progdiv_clock}
  dict set xcvr_param TX_OUTCLK_SOURCE {TXPROGDIVCLK}
  dict set xcvr_param TX_PLL_TYPE {LCPLL}

  set phy_params [dict create]
  dict set phy_params CONFIG.ENABLE_REG_INTERFACE {true}
  dict set phy_params CONFIG.REG_CONF_INTF {AXI_LITE}
  dict set phy_params CONFIG.NO_OF_QUADS ${num_quads}
  dict set phy_params CONFIG.NO_OF_INTERFACE {1}
  dict set phy_params CONFIG.LOCATE_BUFG {EXAMPLE_DESIGN}
  dict set phy_params CONFIG.INTF0_PRESET ${transceiver}-JESD204_${jesd_mode}
  dict set phy_params CONFIG.INTF0_GT_SETTINGS(LR0_SETTINGS) ${xcvr_param}
  if {$direction != "RXTX"} {
    dict set phy_params CONFIG.INTF0_GT_DIRECTION SIMPLEX_${direction}
    dict set phy_params CONFIG.INTF0_NO_OF_LANES ${no_lanes}
  } else {
    # When RXTX is selected, create two interfaces
    # Interface 0 for RX
    # Interface 1 for TX
    # This is mandatory if we want to have different number of lanes for RX and TX
    dict set phy_params CONFIG.NO_OF_INTERFACE {2}
    dict set phy_params CONFIG.INTF0_GT_DIRECTION {SIMPLEX_RX}
    dict set phy_params CONFIG.INTF1_GT_DIRECTION {SIMPLEX_TX}
    dict set phy_params CONFIG.INTF0_NO_OF_LANES $rx_no_lanes
    dict set phy_params CONFIG.INTF1_NO_OF_LANES $tx_no_lanes
    dict set phy_params CONFIG.INTF1_PRESET ${transceiver}-JESD204_${jesd_mode}
    dict set phy_params CONFIG.INTF1_GT_SETTINGS(LR0_SETTINGS) ${xcvr_param}
  }

  if {$direction != "RXTX"} {
    # Simplex RX or Simplex TX
    # One single interface (Interface 0)
    dict set phy_params "CONFIG.QUAD0_${direction}0_OUTCLK_EN" {true}
    dict set phy_params "CONFIG.QUAD0_PROT0_${direction}MSTCLK" ${direction}0
    for {set i 0} {$i < [expr {$LANES_PER_QUAD * $num_quads}]} {incr i} {
      set quad_idx [expr {$i / $LANES_PER_QUAD}]
      set lane_idx [expr {$i % $LANES_PER_QUAD}]
      dict set phy_params "CONFIG.QUAD${quad_idx}_PROT0_${direction}${lane_idx}_EN" [expr {$i < $no_lanes}]
    }
    for {set i 0} {$i < $num_quads} {incr i} {
      dict set phy_params "CONFIG.QUAD${i}_PROT0_LANES" [expr {min($LANES_PER_QUAD, max(0, $no_lanes - $LANES_PER_QUAD * $i))}]
    }
  } else {
    # Interface 0 = RX
    # Interface 1 = TX

    dict set phy_params "CONFIG.QUAD0_RX0_OUTCLK_EN" {true}
    dict set phy_params "CONFIG.QUAD0_TX0_OUTCLK_EN" {true}
    dict set phy_params "CONFIG.QUAD0_PROT0_RXMSTCLK" {RX0}
    # Map RX lanes
    for {set i 0} {$i < $num_quads} {incr i} {
      set lanes [expr {min($LANES_PER_QUAD, max(0, $rx_no_lanes - $LANES_PER_QUAD * $i))}]
      if {$lanes != 0} {
        dict set phy_params "CONFIG.QUAD${i}_PROT0_LANES" ${lanes}
        dict set phy_params "CONFIG.QUAD${i}_NO_PROT" {1}
      }
    }
    for {set i 0} {$i < [expr {$LANES_PER_QUAD * $num_quads}]} {incr i} {
      set quad_idx [expr {$i / $LANES_PER_QUAD}]
      set lane_idx [expr {$i % $LANES_PER_QUAD}]
      dict set phy_params "CONFIG.QUAD${quad_idx}_PROT0_RX${lane_idx}_EN" [expr {$i < $rx_no_lanes}]
    }

    # Map TX lanes
    dict set phy_params "CONFIG.QUAD0_PROT1_TXMSTCLK" {TX0}
    for {set i 0} {$i < $num_quads} {incr i} {
      set lanes [expr {min($LANES_PER_QUAD, max(0, $tx_no_lanes - $LANES_PER_QUAD * $i))}]
      if {$lanes != 0} {
        if {[dict exists $phy_params "CONFIG.QUAD${i}_PROT0_LANES"]} {
          # Both RX and TX lanes in the same quad
          dict set phy_params "CONFIG.QUAD${i}_NO_PROT" {2}
          dict set phy_params "CONFIG.QUAD${i}_PROT1_LANES" ${lanes}
        } else {
          # Only TX lanes in this quad
          dict set phy_params "CONFIG.QUAD${i}_NO_PROT" {1}
          dict set phy_params "CONFIG.QUAD${i}_PROT0" {INTF1}
          dict set phy_params "CONFIG.QUAD${i}_PROT0_LANES" ${lanes}
        }
      }
    }
    for {set i 0} {$i < [expr {$LANES_PER_QUAD * $num_quads}]} {incr i} {
      set quad_idx [expr {$i / $LANES_PER_QUAD}]
      set lane_idx [expr {$i % $LANES_PER_QUAD}]
      # Safely check if NO_PROT exists before accessing
      if {[dict exists $phy_params "CONFIG.QUAD${quad_idx}_NO_PROT"]} {
        set prot_idx [expr {[dict get $phy_params "CONFIG.QUAD${quad_idx}_NO_PROT"] - 1}]
        dict set phy_params "CONFIG.QUAD${quad_idx}_PROT${prot_idx}_TX${lane_idx}_EN" [expr {$i < $tx_no_lanes}]
      }
    }
  }

  for {set i 0} {$i < $num_quads} {incr i} {
    # Calculate lanes used in this specific quad
    set lanes_in_quad [expr {min($LANES_PER_QUAD, max(0, $no_lanes - $LANES_PER_QUAD * $i))}]
    # HSCLK1 is needed only if lanes 2-3 are used in this quad
    set needs_hsclk1 [expr {$lanes_in_quad > 2}]

    for {set j 0} {$j < $lanes_in_quad} {incr j} {
      dict set phy_params "CONFIG.QUAD${i}_CH${j}_ILORESET_EN" {true}
    }
    dict set phy_params "CONFIG.QUAD${i}_HSCLK0_LCPLLRESET_EN" {true}
    dict set phy_params "CONFIG.QUAD${i}_HSCLK1_LCPLLRESET_EN" $needs_hsclk1
    dict set phy_params "CONFIG.QUAD${i}_HSCLK0_LCPLL_LOCK_EN" {true}
    dict set phy_params "CONFIG.QUAD${i}_HSCLK1_LCPLL_LOCK_EN" $needs_hsclk1
  }

  set_property -dict $phy_params [get_bd_cells ${ip_name}]
}

# Utility function to connect the datapath of the transceiver subsystem
# Parameter description:
#   ip_name : The name of the created ip
#   xcvr : The name of the transceiver instance inside the ip
#   intf : Interface number
#   num_lanes : Number of lanes
#   link_mode : 1 for 8b10b, 2 for 64b66b
#   usrclk : The usrclk signal to use as the link clock
#   rx_or_tx : "RX" or "TX"
#   lane_offset : Offset to apply to lane numbering (default 0)
#
# Returns: Nothing. Creates pins and connections for the datapath.
proc xcvr_connect_datapath {ip_name xcvr intf num_lanes link_mode usrclk rx_or_tx {lane_offset 0}} {
  global LANES_PER_QUAD

  if {$rx_or_tx ni {RX TX}} {
    error "Invalid rx_or_tx '$rx_or_tx'. Must be RX or TX."
  }

  set is_rx [expr {$rx_or_tx == "RX"}]
  set dir_lower [string tolower $rx_or_tx]

  # Connect differential pairs (grouped by quad)
  for {set j 0} {$j < $num_lanes} {incr j $LANES_PER_QUAD} {
    set idx [expr {((($lane_offset + 3) / $LANES_PER_QUAD * $LANES_PER_QUAD + $j)) / $LANES_PER_QUAD}]
    set quad_idx [expr {$j / $LANES_PER_QUAD}]

    if {$is_rx} {
      create_bd_pin -dir I -from 3 -to 0 ${ip_name}/${dir_lower}_${idx}_p
      create_bd_pin -dir I -from 3 -to 0 ${ip_name}/${dir_lower}_${idx}_n
    } else {
      create_bd_pin -dir O -from 3 -to 0 ${ip_name}/${dir_lower}_${idx}_p
      create_bd_pin -dir O -from 3 -to 0 ${ip_name}/${dir_lower}_${idx}_n
    }
    ad_connect ${ip_name}/${xcvr}/QUAD${quad_idx}_${dir_lower}p ${ip_name}/${dir_lower}_${idx}_p
    ad_connect ${ip_name}/${xcvr}/QUAD${quad_idx}_${dir_lower}n ${ip_name}/${dir_lower}_${idx}_n
  }

  # Connect individual lanes
  for {set j 0} {$j < $num_lanes} {incr j} {
    set idx [expr {$j + $lane_offset}]
    set quad_idx [expr {$j / $LANES_PER_QUAD}]
    set lane_idx [expr {$j % $LANES_PER_QUAD}]

    if {$is_rx} {
      ad_ip_instance jesd204_versal_gt_adapter_rx ${ip_name}/${dir_lower}_adapt_${idx} [list \
        LINK_MODE $link_mode \
      ]
      ad_connect ${ip_name}/${dir_lower}_adapt_${idx}/RX_GT_IP_Interface ${ip_name}/${xcvr}/INTF${intf}_RX${j}_GT_IP_Interface

      create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 ${ip_name}/${dir_lower}${idx}
      ad_connect ${ip_name}/${dir_lower}${idx} ${ip_name}/${dir_lower}_adapt_${idx}/RX
      ad_connect ${ip_name}/${dir_lower}_adapt_${idx}/en_char_align ${ip_name}/en_char_align
    } else {
      ad_ip_instance jesd204_versal_gt_adapter_tx ${ip_name}/${dir_lower}_adapt_${idx} [list \
        LINK_MODE $link_mode \
      ]
      ad_connect ${ip_name}/${dir_lower}_adapt_${idx}/TX_GT_IP_Interface ${ip_name}/${xcvr}/INTF${intf}_TX${j}_GT_IP_Interface

      create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 ${ip_name}/${dir_lower}${idx}
      ad_connect ${ip_name}/${dir_lower}${idx} ${ip_name}/${dir_lower}_adapt_${idx}/TX
    }

    ad_connect ${ip_name}/${dir_lower}_adapt_${idx}/usr_clk ${usrclk}
    ad_connect ${ip_name}/${xcvr}/QUAD${quad_idx}_${rx_or_tx}${lane_idx}_usrclk ${usrclk}
  }
}

# Utility function to connect the lcpll resets of the transceiver subsystem
# Parameter description:
#   ip_name : The name of the created ip
#   xcvr : The name of the transceiver instance inside the ip
#   no_lanes : Number of lanes
#   reset_pin : The reset_pin signal to use for the lcpll reset
#
# Returns: Nothing. Creates reset logic connections.
proc xcvr_connect_lcpll_resets {ip_name xcvr no_lanes reset_pin} {
  global LANES_PER_QUAD

  set num_quads [expr {int(ceil($no_lanes / double($LANES_PER_QUAD)))}]

  ad_ip_instance ilconcat ${ip_name}/${xcvr}_lcplllock_concat
  ad_ip_parameter ${ip_name}/${xcvr}_lcplllock_concat CONFIG.NUM_PORTS [expr {2 * $num_quads}]

  for {set i 0} {$i < $num_quads} {incr i} {
    # Calculate lanes in this specific quad
    set lanes_in_quad [expr {min($LANES_PER_QUAD, max(0, $no_lanes - $LANES_PER_QUAD * $i))}]
    set needs_hsclk1 [expr {$lanes_in_quad > 2}]

    ad_connect $reset_pin ${ip_name}/${xcvr}/QUAD${i}_hsclk0_lcpllreset
    if {$needs_hsclk1} {
      ad_connect $reset_pin ${ip_name}/${xcvr}/QUAD${i}_hsclk1_lcpllreset
    }

    ad_connect ${ip_name}/${xcvr}/QUAD${i}_hsclk0_lcplllock ${ip_name}/${xcvr}_lcplllock_concat/In[expr {2 * $i}]
    if {$needs_hsclk1} {
      ad_connect ${ip_name}/${xcvr}/QUAD${i}_hsclk1_lcplllock ${ip_name}/${xcvr}_lcplllock_concat/In[expr {2 * $i + 1}]
    } else {
      ad_connect ${ip_name}/${xcvr}/QUAD${i}_hsclk0_lcplllock ${ip_name}/${xcvr}_lcplllock_concat/In[expr {2 * $i + 1}]
    }
  }

  ad_ip_instance ilreduced_logic ${ip_name}/${xcvr}_lcplllock_and
  ad_ip_parameter ${ip_name}/${xcvr}_lcplllock_and CONFIG.C_SIZE [expr {2 * $num_quads}]
  ad_ip_parameter ${ip_name}/${xcvr}_lcplllock_and CONFIG.C_OPERATION {and}

  ad_connect ${ip_name}/${xcvr}_lcplllock_concat/dout ${ip_name}/${xcvr}_lcplllock_and/Op1

  ad_ip_instance ilvector_logic ${ip_name}/${xcvr}_lcplllock_not
  ad_ip_parameter ${ip_name}/${xcvr}_lcplllock_not CONFIG.C_SIZE {1}
  ad_ip_parameter ${ip_name}/${xcvr}_lcplllock_not CONFIG.C_OPERATION {not}

  ad_connect ${ip_name}/${xcvr}_lcplllock_not/Op1 ${ip_name}/${xcvr}_lcplllock_and/Res

  for {set i 0} {$i < $no_lanes} {incr i} {
    set quad_idx [expr {$i / $LANES_PER_QUAD}]
    set lane_idx [expr {$i % $LANES_PER_QUAD}]
    ad_connect ${ip_name}/${xcvr}_lcplllock_not/Res ${ip_name}/${xcvr}/QUAD${quad_idx}_ch${lane_idx}_iloreset
  }
}

# Helper proc to connect reset signals for a direction
# Parameter description:
#   ip_name : The name of the created ip
#   xcvr_list : List of transceiver names to connect
#   intf : Interface number
#   dir : Direction (rx or tx)
proc xcvr_connect_reset_signals {ip_name xcvr_list intf dir} {
  foreach port {pll_and_datapath datapath} {
    foreach xcvr $xcvr_list {
      ad_connect ${ip_name}/gtreset_${dir}_${port} ${ip_name}/${xcvr}/INTF${intf}_rst_${dir}_${port}_in
    }
  }
}

# Helper proc to create resetdone logic
# Parameter description:
#   ip_name : The name of the created ip
#   xcvr_list : List of transceiver names
#   intf : Interface number
#   dir : Direction (rx or tx)
proc xcvr_create_resetdone_logic {ip_name xcvr_list intf dir} {
  ad_ip_instance ilconcat ${ip_name}/${dir}_resetdone_concat
  ad_ip_parameter ${ip_name}/${dir}_resetdone_concat CONFIG.NUM_PORTS [llength $xcvr_list]

  set port_idx 0
  foreach xcvr $xcvr_list {
    ad_connect ${ip_name}/${xcvr}/INTF${intf}_rst_${dir}_done_out ${ip_name}/${dir}_resetdone_concat/In${port_idx}
    incr port_idx
  }

  ad_ip_instance ilreduced_logic ${ip_name}/${dir}_resetdone_and
  ad_ip_parameter ${ip_name}/${dir}_resetdone_and CONFIG.C_SIZE [llength $xcvr_list]
  ad_ip_parameter ${ip_name}/${dir}_resetdone_and CONFIG.C_OPERATION {and}
  ad_connect ${ip_name}/${dir}_resetdone_concat/dout ${ip_name}/${dir}_resetdone_and/Op1
  ad_connect ${ip_name}/${dir}_resetdone_and/Res ${ip_name}/${dir}_resetdone
}

# Main procedure to create the complete Versal JESD transceiver subsystem
# Parameter description:
#   ip_name : The name of the created ip
#   jesd_mode : Used physical layer encoder mode (64B66B or 8B10B)
#   rx_no_lanes :  Number of RX lanes
#   tx_no_lanes :  Number of TX lanes
#   ref_clock : Frequency of reference clock in MHz used in 64B66B mode (LANE_RATE/66) or 8B10B mode (LANE_RATE/40)
#   rx_lane_rate : Line rate of the Rx link ( e.g. MxFE to FPGA ) in GHz
#   tx_lane_rate : Line rate of the Tx link ( e.g. FPGA to MxFE ) in GHz
#   transceiver : Type of transceiver to use (GTY or GTYP)
#   intf_cfg : Direction of the transceivers (RXTX, RX, or TX)
#   consecutive_quad_mode : true to use consecutive quads for RX and TX, false to split RX and TX across different quads
#
# Returns: Nothing. Creates a hierarchical block with the complete transceiver subsystem.
proc create_versal_jesd_xcvr_subsystem {
  {ip_name versal_phy}
  {jesd_mode 64B66B}
  {rx_no_lanes 4}
  {tx_no_lanes 4}
  {rx_lane_rate 24.75}
  {tx_lane_rate 24.75}
  {ref_clock 375}
  {transceiver GTY}
  {intf_cfg RXTX}
  {consecutive_quad_mode true}
} {
  global LANES_PER_QUAD

  # Input validation
  if {$intf_cfg ni {RXTX RX TX}} {
    error "Invalid intf_cfg '$intf_cfg'. Must be RXTX, RX, or TX."
  }

  set rx_quads     [expr {int(ceil(1.0 * $rx_no_lanes / $LANES_PER_QUAD))}]
  set tx_quads     [expr {int(ceil(1.0 * $tx_no_lanes / $LANES_PER_QUAD))}]
  set num_quads    [expr {max($rx_quads, $tx_quads)}]
  set link_mode    [expr {$jesd_mode == "64B66B" ? 2 : 1}]
  set max_no_lanes [expr {max($rx_no_lanes, $tx_no_lanes)}]

  set has_rx [expr {$intf_cfg != "TX"}]
  set has_tx [expr {$intf_cfg != "RX"}]

  if {$intf_cfg == "RXTX"} {
    set rx_intf 0
    set tx_intf 1
  } else {
    set rx_intf 0
    set tx_intf 0
  }

  # Determine transceiver instances to create
  if {$consecutive_quad_mode} {
    set xcvr_list [list xcvr]
  } else {
    set xcvr_list [list xcvr xcvr_b]
  }

  create_bd_cell -type hier ${ip_name}

  # Common interface
  create_bd_pin -dir I ${ip_name}/GT_REFCLK -type clk
  create_bd_pin -dir I ${ip_name}/s_axi_clk
  create_bd_pin -dir I ${ip_name}/s_axi_resetn
  if {$has_rx} {
    create_bd_pin -dir O ${ip_name}/rxusrclk_out -type clk
    create_bd_pin -dir I ${ip_name}/en_char_align
  }
  if {$has_tx} {
    create_bd_pin -dir O ${ip_name}/txusrclk_out -type clk
  }

  # Create transceiver subsystem(s)
  if {$consecutive_quad_mode} {
    create_xcvr_subsystem ${ip_name}/xcvr $jesd_mode $rx_no_lanes $tx_no_lanes $rx_lane_rate $tx_lane_rate $ref_clock $transceiver $intf_cfg
  } else {
    set half_rx_lanes [expr {int(ceil($rx_no_lanes / 2.0))}]
    set half_tx_lanes [expr {int(ceil($tx_no_lanes / 2.0))}]
    create_xcvr_subsystem ${ip_name}/xcvr   $jesd_mode $half_rx_lanes $half_tx_lanes $rx_lane_rate $tx_lane_rate $ref_clock $transceiver $intf_cfg
    create_xcvr_subsystem ${ip_name}/xcvr_b $jesd_mode $half_rx_lanes $half_tx_lanes $rx_lane_rate $tx_lane_rate $ref_clock $transceiver $intf_cfg
    set_property -dict [list \
      CONFIG.QUAD0_PROT0_RXMSTCLK {None} \
      CONFIG.QUAD0_PROT1_TXMSTCLK {None} \
      CONFIG.QUAD0_RX0_OUTCLK_EN {false} \
      CONFIG.QUAD0_TX0_OUTCLK_EN {false} \
    ] [get_bd_cells ${ip_name}/xcvr_b]
  }

  # Connect reference clocks
  set quads_per_xcvr [expr {$consecutive_quad_mode ? $num_quads : int(ceil($num_quads / 2.0))}]
  for {set j 0} {$j < $quads_per_xcvr} {incr j} {
    foreach xcvr $xcvr_list {
      ad_connect ${ip_name}/GT_REFCLK ${ip_name}/${xcvr}/QUAD${j}_GTREFCLK0
    }
  }

  # RX datapath
  if {$has_rx} {
    ad_ip_instance bufg_gt ${ip_name}/bufg_gt_rx
    ad_connect ${ip_name}/xcvr/INTF${rx_intf}_rx_clr_out ${ip_name}/bufg_gt_rx/gt_bufgtclr
    ad_connect ${ip_name}/xcvr/QUAD0_RX0_outclk          ${ip_name}/bufg_gt_rx/outclk
    ad_connect ${ip_name}/bufg_gt_rx/usrclk              ${ip_name}/rxusrclk_out

    if {$consecutive_quad_mode} {
      xcvr_connect_datapath ${ip_name} xcvr $rx_intf $rx_no_lanes $link_mode ${ip_name}/bufg_gt_rx/usrclk RX
    } else {
      set half_lanes [expr {int(ceil($rx_no_lanes / 2.0))}]
      xcvr_connect_datapath ${ip_name} xcvr   $rx_intf $half_lanes $link_mode ${ip_name}/bufg_gt_rx/usrclk RX 0
      xcvr_connect_datapath ${ip_name} xcvr_b $rx_intf $half_lanes $link_mode ${ip_name}/bufg_gt_rx/usrclk RX $half_lanes
    }
  }

  # TX datapath
  if {$has_tx} {
    ad_ip_instance bufg_gt ${ip_name}/bufg_gt_tx
    ad_connect ${ip_name}/xcvr/INTF${tx_intf}_tx_clr_out ${ip_name}/bufg_gt_tx/gt_bufgtclr
    ad_connect ${ip_name}/xcvr/QUAD0_TX0_outclk          ${ip_name}/bufg_gt_tx/outclk
    ad_connect ${ip_name}/bufg_gt_tx/usrclk              ${ip_name}/txusrclk_out

    if {$consecutive_quad_mode} {
      xcvr_connect_datapath ${ip_name} xcvr $tx_intf $tx_no_lanes $link_mode ${ip_name}/bufg_gt_tx/usrclk TX
    } else {
      set half_lanes [expr {int(ceil($tx_no_lanes / 2.0))}]
      xcvr_connect_datapath ${ip_name} xcvr   $tx_intf $half_lanes $link_mode ${ip_name}/bufg_gt_tx/usrclk TX 0
      xcvr_connect_datapath ${ip_name} xcvr_b $tx_intf $half_lanes $link_mode ${ip_name}/bufg_gt_tx/usrclk TX $half_lanes
    }
  }

  # Reset signals
  create_bd_pin -dir I ${ip_name}/gtreset_in
  create_bd_pin -dir O ${ip_name}/gtpowergood
  if {$has_rx} {
    create_bd_pin -dir I ${ip_name}/gtreset_rx_pll_and_datapath
    create_bd_pin -dir I ${ip_name}/gtreset_rx_datapath
    create_bd_pin -dir O ${ip_name}/rx_resetdone
  }
  if {$has_tx} {
    create_bd_pin -dir I ${ip_name}/gtreset_tx_pll_and_datapath
    create_bd_pin -dir I ${ip_name}/gtreset_tx_datapath
    create_bd_pin -dir O ${ip_name}/tx_resetdone
  }

  # Connect global reset to all interfaces
  foreach xcvr $xcvr_list {
    ad_connect ${ip_name}/gtreset_in ${ip_name}/${xcvr}/INTF${rx_intf}_rst_all_in
    if {$rx_intf != $tx_intf} {
      ad_connect ${ip_name}/gtreset_in ${ip_name}/${xcvr}/INTF${tx_intf}_rst_all_in
    }
  }

  # Connect direction-specific resets
  if {$has_rx} {
    xcvr_connect_reset_signals ${ip_name} $xcvr_list $rx_intf rx
  }
  if {$has_tx} {
    xcvr_connect_reset_signals ${ip_name} $xcvr_list $tx_intf tx
  }

  # LCPLL resets
  set reset_pin [expr {$has_tx ? "${ip_name}/gtreset_tx_pll_and_datapath"
                                : "${ip_name}/gtreset_rx_pll_and_datapath"}]

  if {$consecutive_quad_mode} {
    xcvr_connect_lcpll_resets ${ip_name} xcvr $max_no_lanes $reset_pin
  } else {
    set half_max_lanes [expr {int(ceil($max_no_lanes / 2.0))}]
    xcvr_connect_lcpll_resets ${ip_name} xcvr   $half_max_lanes $reset_pin
    xcvr_connect_lcpll_resets ${ip_name} xcvr_b $half_max_lanes $reset_pin
  }

  # Power good signal
  ad_ip_instance ilconcat ${ip_name}/gtpowergood_concat
  ad_ip_parameter ${ip_name}/gtpowergood_concat CONFIG.NUM_PORTS [llength $xcvr_list]
  set port_idx 0
  foreach xcvr $xcvr_list {
    ad_connect ${ip_name}/${xcvr}/gtpowergood ${ip_name}/gtpowergood_concat/In${port_idx}
    incr port_idx
  }

  ad_ip_instance ilreduced_logic ${ip_name}/gtpowergood_and
  ad_ip_parameter ${ip_name}/gtpowergood_and CONFIG.C_SIZE [llength $xcvr_list]
  ad_ip_parameter ${ip_name}/gtpowergood_and CONFIG.C_OPERATION {and}
  ad_connect ${ip_name}/gtpowergood_concat/dout ${ip_name}/gtpowergood_and/Op1
  ad_connect ${ip_name}/gtpowergood_and/Res ${ip_name}/gtpowergood

  # Reset done signals
  if {$has_rx} {
    xcvr_create_resetdone_logic ${ip_name} $xcvr_list $rx_intf rx
  }
  if {$has_tx} {
    xcvr_create_resetdone_logic ${ip_name} $xcvr_list $tx_intf tx
  }

  # AXI interface
  foreach xcvr $xcvr_list {
    ad_connect ${ip_name}/s_axi_clk ${ip_name}/${xcvr}/gtwiz_freerun_clk
  }

  set axi_idx 0
  for {set j 0} {$j < $quads_per_xcvr} {incr j} {
    foreach xcvr $xcvr_list {
      ad_connect ${ip_name}/s_axi_resetn ${ip_name}/${xcvr}/QUAD${j}_s_axi_lite_resetn
      create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ${ip_name}/s_axi_${axi_idx}
      ad_connect ${ip_name}/s_axi_${axi_idx} ${ip_name}/${xcvr}/Quad${j}_AXI_LITE
      incr axi_idx
    }
  }
}
