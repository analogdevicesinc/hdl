###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

source [file join [file dirname [info script]] adi_xcvr_versal.tcl]

# Parameter description:
#   ip_name : The name of the created ip
#   jesd_mode : Used physical layer encoder mode (64B66B or 8B10B)
#   rx_no_lanes :  Number of RX lanes
#   tx_no_lanes :  Number of TX lanes
#   ref_clock : Frequency of reference clock in MHz used in 64B66B mode (LANE_RATE/66) or 8B10B mode (LANE_RATE/40)
#   rx_lane_rate : Line rate of the Rx link ( e.g. MxFE to FPGA ) in GHz
#   tx_lane_rate : Line rate of the Tx link ( e.g. FPGA to MxFE ) in GHz
#   transceiver : Type of transceiver to use (GTY, GTYP or GTM)
#   direction : Direction of the transceivers
#       RXTX : Duplex mode
#       RX   : Rx link only
#       TX   : Tx link only
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
  ad_ip_instance gtwiz_versal ${ip_name}
  set_property -dict [versal_xcvr_wizard_params $jesd_mode $rx_no_lanes $tx_no_lanes \
    [list $rx_lane_rate] [list $tx_lane_rate] $ref_clock $transceiver $direction] \
    [get_bd_cells ${ip_name}]
}

# Utility function to connect the datapath of the transceiver subsystem
# Parameter description:
#   ip_name : The name of the created ip
#   xcvr : The name of the transceiver instance inside the ip
#   transceiver: Transceiver type (GTY / GTYP / GTM)
#   intf : Interface number
#   num_lanes : Number of lanes
#   link_mode : 1 for 8b10b, 2 for 64b66b
#   usrclk : The usrclk signal to use as the link clock (LR / 66)
#   rx_or_tx : "RX" or "TX"
#   lane_offset : Offset to apply to lane numbering (default 0)
#   phy_clk: The clock signals use as the PHY clk (GTM only) (LR / 64)
#   phy_rstn: The signal used to reset the 64b/66b gearboxes (GTM only)
#
# Returns: Nothing. Creates pins and connections for the datapath.
proc xcvr_connect_datapath {ip_name transceiver xcvr intf num_lanes link_mode usrclk rx_or_tx {lane_offset 0} {phy_clk {}} {phy_rstn {}}} {
  global LANES_PER_QUAD

  if {$rx_or_tx ni {RX TX}} {
    error "Invalid rx_or_tx '$rx_or_tx'. Must be RX or TX."
  }

  set is_rx [expr {$rx_or_tx == "RX"}]
  set dir_lower [string tolower $rx_or_tx]
  set quad_usrclk [expr {($transceiver != "GTM" || $link_mode == 1)? ${usrclk} : ${phy_clk}}]

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
        TRANSCEIVER $transceiver \
      ]
      ad_connect ${ip_name}/${dir_lower}_adapt_${idx}/RX_GT_IP_Interface ${ip_name}/${xcvr}/INTF${intf}_RX${j}_GT_IP_Interface

      create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 ${ip_name}/${dir_lower}${idx}
      ad_connect ${ip_name}/${dir_lower}${idx} ${ip_name}/${dir_lower}_adapt_${idx}/RX
      if {$link_mode == 1} {
        ad_connect ${ip_name}/${dir_lower}_adapt_${idx}/en_char_align ${ip_name}/en_char_align
      }
    } else {
      ad_ip_instance jesd204_versal_gt_adapter_tx ${ip_name}/${dir_lower}_adapt_${idx} [list \
        LINK_MODE $link_mode \
        TRANSCEIVER $transceiver \
      ]
      ad_connect ${ip_name}/${dir_lower}_adapt_${idx}/TX_GT_IP_Interface ${ip_name}/${xcvr}/INTF${intf}_TX${j}_GT_IP_Interface

      create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 ${ip_name}/${dir_lower}${idx}
      ad_connect ${ip_name}/${dir_lower}${idx} ${ip_name}/${dir_lower}_adapt_${idx}/TX
    }

    ad_connect ${usrclk} ${ip_name}/${dir_lower}_adapt_${idx}/usr_clk
    ad_connect ${quad_usrclk} ${ip_name}/${xcvr}/QUAD${quad_idx}_${rx_or_tx}${lane_idx}_usrclk

    if {$phy_clk != {} && $transceiver == "GTM"} {
      ad_connect ${phy_clk} ${ip_name}/${dir_lower}_adapt_${idx}/phy_clk
    }
    if {$phy_rstn != {} && $transceiver == "GTM"} {
      ad_connect ${phy_rstn} ${ip_name}/${dir_lower}_adapt_${idx}/phy_rstn
    }
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
#   transceiver : Type of transceiver to use (GTY, GTYP or GTM)
#   intf_cfg : Direction of the transceivers (RXTX, RX, or TX)
#   consecutive_quad_mode : true to use consecutive quads for RX and TX, false to split RX and TX across different quads
#   external_link_clk : applies to GTM and JESD204C:
#       - when not set a clk_wizard is added to generate the LR / 66 clock for the gearbox
#       - when set the LR / 66 clock is expected to be external to the subsystem and connected from the BD
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
  {external_link_clk 0}
} {
  global LANES_PER_QUAD
  puts "WARNING: create_versal_jesd_xcvr_subsystem is deprecated, use util_adxcvr + axi_adxcvr with ad_xcvrcon"

  # Input validation
  if {$intf_cfg ni {RXTX RX TX}} {
    error "Invalid intf_cfg '$intf_cfg'. Must be RXTX, RX, or TX."
  }

  set rx_quads          [expr {int(ceil(1.0 * $rx_no_lanes / $LANES_PER_QUAD))}]
  set tx_quads          [expr {int(ceil(1.0 * $tx_no_lanes / $LANES_PER_QUAD))}]
  set num_quads         [expr {max($rx_quads, $tx_quads)}]
  set link_mode         [expr {$jesd_mode == "64B66B" ? 2 : 1}]
  set max_no_lanes      [expr {max($rx_no_lanes, $tx_no_lanes)}]
  set has_rx            [expr {$intf_cfg != "TX"}]
  set has_tx            [expr {$intf_cfg != "RX"}]
  set has_single_clock  [expr {$transceiver != "GTM" || $link_mode == 1}]

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
    create_bd_pin -dir O ${ip_name}/rxusrclk_out
    if {$link_mode == 1} {
      create_bd_pin -dir I ${ip_name}/en_char_align
    }
  }
  if {$has_tx} {
    create_bd_pin -dir O ${ip_name}/txusrclk_out
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
    # This shouldn't be necessary, we could use the INTF_out_clk but there is a bug
    # where the divider is not properly set in the generated code.
    ad_ip_instance bufg_gt ${ip_name}/bufg_gt_rx
    ad_connect ${ip_name}/xcvr/INTF${rx_intf}_rx_clr_out ${ip_name}/bufg_gt_rx/gt_bufgtclr
    ad_connect ${ip_name}/xcvr/QUAD0_RX0_outclk          ${ip_name}/bufg_gt_rx/outclk
    if {$has_single_clock} {
      ad_connect ${ip_name}/bufg_gt_rx/usrclk            ${ip_name}/rxusrclk_out
    } elseif {$external_link_clk} {
        create_bd_pin -dir I ${ip_name}/rx_usrclk_in
        ad_connect ${ip_name}/rx_usrclk_in ${ip_name}/rxusrclk_out
    } else {
      ad_ip_instance clk_wizard ${ip_name}/rx_clkwiz
      ad_ip_parameter ${ip_name}/rx_clkwiz CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY [format %.5f [expr $rx_lane_rate * 1000.0 / 66]]
      ad_ip_parameter ${ip_name}/rx_clkwiz CONFIG.USE_PHASE_ALIGNMENT {true}
      ad_ip_parameter ${ip_name}/rx_clkwiz CONFIG.USE_LOCKED {true}
      ad_ip_parameter ${ip_name}/rx_clkwiz CONFIG.JITTER_SEL {Min_O_Jitter}
      ad_ip_parameter ${ip_name}/rx_clkwiz CONFIG.PRIMITIVE_TYPE {Auto}
      ad_ip_parameter ${ip_name}/rx_clkwiz CONFIG.PRIM_SOURCE {Global_buffer}

      ad_connect ${ip_name}/bufg_gt_rx/usrclk   ${ip_name}/rx_clkwiz/clk_in1
      ad_connect ${ip_name}/rx_clkwiz/clk_out1  ${ip_name}/rxusrclk_out
    }

    set rx_usrclk   ${ip_name}/bufg_gt_rx/usrclk
    set rx_phy_clk  {}
    set rx_phy_rstn ${ip_name}/xcvr/INTF${rx_intf}_rst_rx_done_out

    if {!$has_single_clock} {
      if {$external_link_clk} {
        set rx_phy_clk  ${ip_name}/bufg_gt_rx/usrclk
        set rx_usrclk   ${ip_name}/rx_usrclk_in
      } else {
        set rx_phy_clk  ${ip_name}/bufg_gt_rx/usrclk
        set rx_usrclk   ${ip_name}/rx_clkwiz/clk_out1
        set rx_phy_rstn ${ip_name}/rx_clkwiz/locked
      }
    }

    if {$consecutive_quad_mode} {
      xcvr_connect_datapath ${ip_name} $transceiver xcvr $rx_intf $rx_no_lanes $link_mode $rx_usrclk RX 0 $rx_phy_clk $rx_phy_rstn
    } else {
      set half_lanes [expr {int(ceil($rx_no_lanes / 2.0))}]
      xcvr_connect_datapath ${ip_name} $transceiver xcvr   $rx_intf $half_lanes $link_mode $rx_usrclk RX 0           $rx_phy_clk $rx_phy_rstn
      xcvr_connect_datapath ${ip_name} $transceiver xcvr_b $rx_intf $half_lanes $link_mode $rx_usrclk RX $half_lanes $rx_phy_clk $rx_phy_rstn
    }
  }

  # TX datapath
  if {$has_tx} {
    # This shouldn't be necessary, we could use the INTF_out_clk but there is a bug
    # where the divider is not properly set in the generated code.
    ad_ip_instance bufg_gt ${ip_name}/bufg_gt_tx
    ad_connect ${ip_name}/xcvr/INTF${tx_intf}_tx_clr_out ${ip_name}/bufg_gt_tx/gt_bufgtclr
    ad_connect ${ip_name}/xcvr/QUAD0_TX0_outclk          ${ip_name}/bufg_gt_tx/outclk
    if {$has_single_clock} {
      ad_connect ${ip_name}/bufg_gt_tx/usrclk            ${ip_name}/txusrclk_out
    } elseif {$external_link_clk} {
      create_bd_pin -dir I ${ip_name}/tx_usrclk_in
      ad_connect ${ip_name}/tx_usrclk_in ${ip_name}/txusrclk_out
    } else {
      ad_ip_instance clk_wizard ${ip_name}/tx_clkwiz
      ad_ip_parameter ${ip_name}/tx_clkwiz CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY [format %.5f [expr $tx_lane_rate * 1000.0 / 66]]
      ad_ip_parameter ${ip_name}/tx_clkwiz CONFIG.USE_PHASE_ALIGNMENT {true}
      ad_ip_parameter ${ip_name}/tx_clkwiz CONFIG.USE_LOCKED {true}
      ad_ip_parameter ${ip_name}/tx_clkwiz CONFIG.JITTER_SEL {Min_O_Jitter}
      ad_ip_parameter ${ip_name}/tx_clkwiz CONFIG.PRIMITIVE_TYPE {Auto}
      ad_ip_parameter ${ip_name}/tx_clkwiz CONFIG.PRIM_SOURCE {Global_buffer}

      ad_connect ${ip_name}/bufg_gt_tx/usrclk ${ip_name}/tx_clkwiz/clk_in1
      ad_connect ${ip_name}/tx_clkwiz/clk_out1 ${ip_name}/txusrclk_out
    }

    set tx_usrclk   ${ip_name}/bufg_gt_tx/usrclk
    set tx_phy_clk  {}
    set tx_phy_rstn ${ip_name}/xcvr/INTF${tx_intf}_rst_tx_done_out

    if {!$has_single_clock} {
      if {$external_link_clk} {
        set tx_phy_clk  ${ip_name}/bufg_gt_tx/usrclk
        set tx_usrclk   ${ip_name}/tx_usrclk_in
      } else {
        set tx_phy_clk  ${ip_name}/bufg_gt_tx/usrclk
        set tx_usrclk   ${ip_name}/tx_clkwiz/clk_out1
        set tx_phy_rstn ${ip_name}/tx_clkwiz/locked
      }
    }

    if {$consecutive_quad_mode} {
      xcvr_connect_datapath ${ip_name} $transceiver xcvr $tx_intf $tx_no_lanes $link_mode $tx_usrclk TX 0 $tx_phy_clk $tx_phy_rstn
    } else {
      set half_lanes [expr {int(ceil($tx_no_lanes / 2.0))}]
      xcvr_connect_datapath ${ip_name} $transceiver xcvr   $tx_intf $half_lanes $link_mode $tx_usrclk TX 0           $tx_phy_clk $tx_phy_rstn
      xcvr_connect_datapath ${ip_name} $transceiver xcvr_b $tx_intf $half_lanes $link_mode $tx_usrclk TX $half_lanes $tx_phy_clk $tx_phy_rstn
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
