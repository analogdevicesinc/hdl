###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../projects/scripts/adi_board.tcl

# Parameter description:
#   ip_name : The name of the created ip
#   jesd_mode : Used physical layer encoder mode
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
  set clk_divider              [expr {$jesd_mode == "64B66B" ? 66 : 40}]
  set datapath_width           [expr {$jesd_mode == "64B66B" ? 64 : 32}]
  set internal_datapath_width  [expr {$jesd_mode == "64B66B" ? 64 : 40}]
  set data_encoding            [expr {$jesd_mode == "64B66B" ? "64B66B_ASYNC" : "8B10B"}]
  set comma_mask               [expr {$jesd_mode == "64B66B" ? "0000000000" : "1111111111"}]
  set comma_p_enable           [expr {$jesd_mode == "64B66B" ? false : false}]
  set comma_m_enable           [expr {$jesd_mode == "64B66B" ? false : false}]
  set rx_progdiv_clock         [format %.3f [expr $rx_lane_rate * 1000.0 / ${clk_divider}]]
  set tx_progdiv_clock         [format %.3f [expr $tx_lane_rate * 1000.0 / ${clk_divider}]]

  if {$direction == "RXTX"} {
    set no_lanes   [expr max($rx_no_lanes, $tx_no_lanes)]
  } elseif {$direction == "RX"} {
    set no_lanes   $rx_no_lanes
  } else {
    set no_lanes   $tx_no_lanes
  }
  set num_quads [expr int(ceil(1.0 * $no_lanes / 4))]

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
  if {$jesd_mode == "8B10B"} {
    dict set xcvr_param RX_COMMA_P_ENABLE ${comma_p_enable}
    dict set xcvr_param RX_COMMA_M_ENABLE ${comma_m_enable}
    dict set xcvr_param RX_COMMA_SHOW_REALIGN_ENABLE {false}
    dict set xcvr_param RX_SLIDE_MODE {PCS}
  }

  # Tx parameters
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
  dict set phy_params CONFIG.LOCATE_BUFG {CORE}
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
    for {set i 0} {$i < [expr 4 * $num_quads]} {incr i} {
      set quad_idx [expr $i / 4]
      set lane_idx [expr $i % 4]
      dict set phy_params "CONFIG.QUAD${quad_idx}_PROT0_${direction}${lane_idx}_EN" [expr $i < $no_lanes]
    }
    for {set i 0} {$i < $num_quads} {incr i} {
        dict set phy_params "CONFIG.QUAD${i}_PROT0_LANES" [expr min(4, max(0, $no_lanes - 4 * $i))]
    }
  } else {
    # Interface 0 = RX
    # Interface 1 = TX

    dict set phy_params "CONFIG.QUAD0_RX0_OUTCLK_EN" {true}
    dict set phy_params "CONFIG.QUAD0_TX0_OUTCLK_EN" {true}
    dict set phy_params "CONFIG.QUAD0_PROT0_RXMSTCLK" {RX0}
    # Map RX lanes
    for {set i 0} {$i < $num_quads} {incr i} {
      set lanes [expr min(4, max(0, $rx_no_lanes - 4 * $i))]
      if {$lanes != 0} {
        dict set phy_params "CONFIG.QUAD${i}_PROT0_LANES" ${lanes}
        dict set phy_params "CONFIG.QUAD${i}_NO_PROT" {1}
      }
    }
    for {set i 0} {$i < [expr 4 * $num_quads]} {incr i} {
      set quad_idx [expr $i / 4]
      set lane_idx [expr $i % 4]
      dict set phy_params "CONFIG.QUAD${quad_idx}_PROT0_RX${lane_idx}_EN" [expr $i < $rx_no_lanes]
    }

    # Map TX lanes
    dict set phy_params "CONFIG.QUAD0_PROT1_TXMSTCLK" {TX0}
    for {set i 0} {$i < $num_quads} {incr i} {
      set lanes [expr min(4, max(0, $tx_no_lanes - 4 * $i))]
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
    for {set i 0} {$i < [expr 4 * $num_quads]} {incr i} {
      set quad_idx [expr $i / 4]
      set lane_idx [expr $i % 4]
      set prot_idx [expr {[dict get $phy_params "CONFIG.QUAD${quad_idx}_NO_PROT"] - 1}]
      dict set phy_params "CONFIG.QUAD${quad_idx}_PROT${prot_idx}_TX${lane_idx}_EN" [expr $i < $tx_no_lanes]
    }
  }

  # dict for {k v} $phy_params {puts "$k : $v"}
  set_property -dict $phy_params [get_bd_cells ${ip_name}]
}

# Parameter description:
#   ip_name : The name of the created ip
#   jesd_mode : Used physical layer encoder mode
#   rx_no_lanes :  Number of RX lanes
#   tx_no_lanes :  Number of TX lanes
#   ref_clock : Frequency of reference clock in MHz used in 64B66B mode (LANE_RATE/66) or 8B10B mode (LANE_RATE/40)
#   rx_lane_rate : Line rate of the Rx link ( e.g. MxFE to FPGA ) in GHz
#   tx_lane_rate : Line rate of the Tx link ( e.g. FPGA to MxFE ) in GHz
#   transceiver : Type of transceiver to use (GTY or GTYP)
#   intf_cfg : Direction of the transceivers
#       RXTX : Duplex mode
#       RX   : Rx link only
#       TX   : Tx link only
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
} {
  set rx_quads                 [expr int(ceil(1.0 * $rx_no_lanes / 4))]
  set tx_quads                 [expr int(ceil(1.0 * $tx_no_lanes / 4))]
  set num_quads                [expr max($rx_quads, $tx_quads)]
  set link_mode                [expr {$jesd_mode == "64B66B" ? 2 : 1}]

  if {$intf_cfg == "RXTX"} {
    set rx_intf 0
    set tx_intf 1
  } else {
    set rx_intf 0
    set tx_intf 0
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

  create_xcvr_subsystem ${ip_name}/xcvr $jesd_mode $rx_no_lanes $tx_no_lanes $rx_lane_rate $tx_lane_rate $ref_clock $transceiver $intf_cfg

  # Common xcvr connection
  for {set j 0} {$j < $num_quads} {incr j} {
    ad_connect ${ip_name}/GT_REFCLK ${ip_name}/xcvr/QUAD${j}_GTREFCLK0
  }

  if {$intf_cfg != "TX"} {
    ad_ip_instance bufg_gt ${ip_name}/bufg_gt_rx
    ad_connect ${ip_name}/xcvr/INTF${rx_intf}_rx_clr_out ${ip_name}/bufg_gt_rx/gt_bufgtclr
    ad_connect ${ip_name}/xcvr/QUAD0_RX0_outclk          ${ip_name}/bufg_gt_rx/outclk
    ad_connect ${ip_name}/bufg_gt_rx/usrclk              ${ip_name}/rxusrclk_out

    for {set j 0} {$j < $rx_quads} {incr j} {
      create_bd_pin -dir I -from 3 -to 0 ${ip_name}/rx_${j}_p
      create_bd_pin -dir I -from 3 -to 0 ${ip_name}/rx_${j}_n
      ad_connect ${ip_name}/xcvr/QUAD${j}_rxp ${ip_name}/rx_${j}_p
      ad_connect ${ip_name}/xcvr/QUAD${j}_rxn ${ip_name}/rx_${j}_n
    }

    for {set j 0} {$j < $rx_no_lanes} {incr j} {
      ad_ip_instance jesd204_versal_gt_adapter_rx ${ip_name}/rx_adapt_${j} [list \
        LINK_MODE $link_mode \
      ]
      ad_connect ${ip_name}/rx_adapt_${j}/RX_GT_IP_Interface ${ip_name}/xcvr/INTF${rx_intf}_RX${j}_GT_IP_Interface

      create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 ${ip_name}/rx${j}
      ad_connect ${ip_name}/rx${j} ${ip_name}/rx_adapt_${j}/RX
      ad_connect ${ip_name}/rx_adapt_${j}/usr_clk ${ip_name}/xcvr/INTF${rx_intf}_rx_usrclk
      ad_connect ${ip_name}/rx_adapt_${j}/en_char_align ${ip_name}/en_char_align
    }
  }

  if {$intf_cfg != "RX"} {
    ad_ip_instance bufg_gt ${ip_name}/bufg_gt_tx
    ad_connect ${ip_name}/xcvr/INTF${tx_intf}_tx_clr_out ${ip_name}/bufg_gt_tx/gt_bufgtclr
    ad_connect ${ip_name}/xcvr/QUAD0_TX0_outclk          ${ip_name}/bufg_gt_tx/outclk
    ad_connect ${ip_name}/bufg_gt_tx/usrclk              ${ip_name}/txusrclk_out

    for {set j 0} {$j < $tx_quads} {incr j} {
      create_bd_pin -dir O -from 3 -to 0 ${ip_name}/tx_${j}_p
      create_bd_pin -dir O -from 3 -to 0 ${ip_name}/tx_${j}_n
      ad_connect ${ip_name}/xcvr/QUAD${j}_txp ${ip_name}/tx_${j}_p
      ad_connect ${ip_name}/xcvr/QUAD${j}_txn ${ip_name}/tx_${j}_n
    }

    for {set j 0} {$j < $tx_no_lanes} {incr j} {
      ad_ip_instance jesd204_versal_gt_adapter_tx ${ip_name}/tx_adapt_${j} [list \
        LINK_MODE $link_mode \
      ]
      ad_connect ${ip_name}/tx_adapt_${j}/TX_GT_IP_Interface ${ip_name}/xcvr/INTF${tx_intf}_TX${j}_GT_IP_Interface

      create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 ${ip_name}/tx${j}
      ad_connect ${ip_name}/tx${j} ${ip_name}/tx_adapt_${j}/TX
      ad_connect ${ip_name}/tx_adapt_${j}/usr_clk ${ip_name}/xcvr/INTF${tx_intf}_tx_usrclk
    }
  }

  # Reset signals
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

  create_bd_cell -type module -reference sync_bits ${ip_name}/gtreset_sync
  ad_connect ${ip_name}/s_axi_clk ${ip_name}/gtreset_sync/out_clk
  ad_connect ${ip_name}/s_axi_resetn ${ip_name}/gtreset_sync/out_resetn
  ad_connect ${ip_name}/gtreset_in ${ip_name}/gtreset_sync/in_bits


  ad_connect ${ip_name}/gtreset_sync/out_bits ${ip_name}/xcvr/INTF${rx_intf}_rst_all_in
  if {$rx_intf != $tx_intf} {
    ad_connect ${ip_name}/gtreset_sync/out_bits ${ip_name}/xcvr/INTF${tx_intf}_rst_all_in
  }

  foreach port {pll_and_datapath datapath} {
    foreach rx_tx {rx tx} {
      if {($rx_tx == "rx" && $intf_cfg == "TX") || ($rx_tx == "tx" && $intf_cfg == "RX")} {
        continue
      }
      set intf [expr {$rx_tx == "rx" ? $rx_intf : $tx_intf}]
      create_bd_cell -type module -reference sync_bits ${ip_name}/gtreset_${rx_tx}_${port}_sync
      ad_connect ${ip_name}/s_axi_clk ${ip_name}/gtreset_${rx_tx}_${port}_sync/out_clk
      ad_connect ${ip_name}/s_axi_resetn ${ip_name}/gtreset_${rx_tx}_${port}_sync/out_resetn
      ad_connect ${ip_name}/gtreset_${rx_tx}_${port} ${ip_name}/gtreset_${rx_tx}_${port}_sync/in_bits
      ad_connect ${ip_name}/gtreset_${rx_tx}_${port}_sync/out_bits ${ip_name}/xcvr/INTF${intf}_rst_${rx_tx}_${port}_in
    }
  }

  ad_connect ${ip_name}/xcvr/gtpowergood ${ip_name}/gtpowergood
  if {$intf_cfg != "TX"} {
    ad_connect ${ip_name}/xcvr/INTF${rx_intf}_rst_rx_done_out ${ip_name}/rx_resetdone
  }
  if {$intf_cfg != "RX"} {
    ad_connect ${ip_name}/xcvr/INTF${tx_intf}_rst_tx_done_out ${ip_name}/tx_resetdone
  }

  # AXI interface
  ad_connect ${ip_name}/s_axi_clk ${ip_name}/xcvr/gtwiz_freerun_clk
  for {set j 0} {$j < $num_quads} {incr j} {
    ad_connect ${ip_name}/s_axi_resetn ${ip_name}/xcvr/QUAD${j}_s_axi_lite_resetn

    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ${ip_name}/s_axi_${j}
    ad_connect ${ip_name}/s_axi_${j} ${ip_name}/xcvr/Quad${j}_AXI_LITE
  }
}
