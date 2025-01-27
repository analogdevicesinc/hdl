###############################################################################
## Copyright (C) 2016-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0
package require quartus::device
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

#
# Wrapper module that instantiates and connects all the components required to
# for a JESD204 link.
#
# The following components are created:
#   * Transceiver for each lane
#   * Transceiver lane PLL (TX only)
#   * Transceiver reset controller
#   * Link PLL
#   * JESD204 link layer processing
#   * JESD204 link layer processing control interface
#   * axi_adxcvr link management peripheral
#

ad_ip_create adi_jesd204 {Analog Devices JESD204}
set_module_property VALIDATION_CALLBACK jesd204_validate
set_module_property COMPOSITION_CALLBACK jesd204_compose

# parameters

ad_ip_parameter DEVICE_FAMILY STRING "" false {
  VISIBLE true
}

ad_ip_parameter DEVICE STRING "" false {
  SYSTEM_INFO DEVICE
  VISIBLE false
}

ad_ip_parameter TX_OR_RX_N BOOLEAN 0 false { \
  DISPLAY_HINT "radio" \
  DISPLAY_NAME "Data Path" \
  ALLOWED_RANGES { "0:Receive" "1:Transmit" }
}

ad_ip_parameter LINK_MODE POSITIVE 1 false { \
  DISPLAY_NAME "Link Mode" \
  ALLOWED_RANGES { "1:JESD204B" "2:JESD204C" }
}

ad_ip_parameter ID NATURAL 0 false { \
  DISPLAY_NAME "Core ID" \
}

ad_ip_parameter LANE_RATE FLOAT 10000 false { \
  DISPLAY_NAME "Lane Rate" \
  DISPLAY_UNITS "Mbps" \
}

ad_ip_parameter SYSCLK_FREQUENCY FLOAT 100.0 false { \
  DISPLAY_NAME "System Clock Frequency" \
  UNITS Megahertz
}

ad_ip_parameter REFCLK_FREQUENCY FLOAT 500.0 false { \
  DISPLAY_NAME "Reference Clock Frequency" \
  UNITS Megahertz \
}

ad_ip_parameter NUM_OF_LANES POSITIVE 4 false { \
  DISPLAY_NAME "Number of Lanes" \
  ALLOWED_RANGES 1:16
}

ad_ip_parameter BONDING_CLOCKS_EN BOOLEAN 0 false { \
  DISPLAY_HINT "Clock Network" \
  DISPLAY_NAME "Clock Network" \
  ALLOWED_RANGES { "0:x1/xN (Non-bonded)" "1:x6/xN (Bonded)" }
}

ad_ip_parameter LANE_MAP STRING "" false { \
  DISPLAY_NAME "Lane Mapping" \
}

ad_ip_parameter LANE_INVERT STD_LOGIC_VECTOR 0 false { \
  DISPLAY_NAME "Lane Invert Mask" \
  DISPLAY_HINT "hexadecimal" \
  WIDTH 8 \
}

ad_ip_parameter SOFT_PCS BOOLEAN true false { \
  DISPLAY_NAME "Enable Soft PCS" \
}

ad_ip_parameter INPUT_PIPELINE_STAGES INTEGER 0 false { \
  DISPLAY_NAME "Enable input pipeline" \
}

ad_ip_parameter EXT_DEVICE_CLK_EN BOOLEAN 0 false { \
  DISPLAY_NAME "External Device Clock Enable" \
}

ad_ip_parameter TPL_DATA_PATH_WIDTH INTEGER 4 false { \
  DISPLAY_NAME "Transport layer datapath width" \
  DISPLAY_UNITS "octets" \
  ALLOWED_RANGES {4 6 8 12} \
}

ad_ip_parameter DATA_PATH_WIDTH INTEGER 4 false { \
  DISPLAY_NAME "Data path width" \
  DISPLAY_UNITS "octets" \
  ALLOWED_RANGES {4 8} \
}

proc create_phy_reset_control {tx num_of_lanes sysclk_frequency} {

  set device [get_parameter_value DEVICE_FAMILY]

  if {[string equal $device "Arria 10"]} {

    add_instance phy_reset_control altera_xcvr_reset_control
    set_instance_property phy_reset_control SUPPRESS_ALL_WARNINGS true
    set_instance_parameter_value phy_reset_control {SYNCHRONIZE_RESET} {0}
    set_instance_parameter_value phy_reset_control {CHANNELS} $num_of_lanes
    set_instance_parameter_value phy_reset_control {SYS_CLK_IN_MHZ} $sysclk_frequency
    set_instance_parameter_value phy_reset_control {TX_PLL_ENABLE} $tx
    set_instance_parameter_value phy_reset_control {TX_ENABLE} $tx
    set_instance_parameter_value phy_reset_control {RX_ENABLE} [expr !$tx]

    add_connection sys_clock.clk phy_reset_control.clock
    add_connection link_reset.out_reset phy_reset_control.reset
    add_connection sys_clock.clk_reset phy_reset_control.reset

    if {$tx} {
      set_instance_parameter_value phy_reset_control {T_PLL_POWERDOWN} {1000}
      set_instance_parameter_value phy_reset_control {gui_pll_cal_busy} {1}
      set_instance_parameter_value phy_reset_control {T_TX_ANALOGRESET} {70000}
      set_instance_parameter_value phy_reset_control {T_TX_DIGITALRESET} {70000}

      add_connection phy_reset_control.tx_ready axi_xcvr.ready
    } else {
      set_instance_parameter_value phy_reset_control {T_RX_ANALOGRESET} {70000}
      set_instance_parameter_value phy_reset_control {T_RX_DIGITALRESET} {4000}

      add_connection phy_reset_control.rx_ready axi_xcvr.ready
    }

  } elseif {[string equal $device "Stratix 10"]} {

    add_instance phy_reset_control altera_xcvr_reset_control_s10
    set_instance_parameter_value phy_reset_control {CHANNELS} $num_of_lanes
    set_instance_parameter_value phy_reset_control {SYS_CLK_IN_MHZ} $sysclk_frequency
    set_instance_parameter_value phy_reset_control {TX_ENABLE} $tx
    set_instance_parameter_value phy_reset_control {RX_ENABLE} [expr !$tx]
    set_instance_parameter_value phy_reset_control {REDUCED_SIM_TIME} {1}
    set_instance_parameter_value phy_reset_control {T_PLL_POWERDOWN} {1000}
    set_instance_parameter_value phy_reset_control {T_PLL_LOCK_HYST} {1000}

    add_connection sys_clock.clk phy_reset_control.clock
    add_connection link_reset.out_reset phy_reset_control.reset
    add_connection sys_clock.clk_reset phy_reset_control.reset

    if {$tx} {
      set_instance_parameter_value phy_reset_control {gui_pll_cal_busy} {1}
      set_instance_parameter_value phy_reset_control {TX_MANUAL_RESET} {0}
      set_instance_parameter_value phy_reset_control {T_TX_ANALOGRESET} {0}
      set_instance_parameter_value phy_reset_control {T_TX_DIGITALRESET} {20}

      add_connection phy_reset_control.tx_ready axi_xcvr.ready
    } else {
      set_instance_parameter_value phy_reset_control {RX_MANUAL_RESET} {0}
      set_instance_parameter_value phy_reset_control {T_RX_ANALOGRESET} {40}
      set_instance_parameter_value phy_reset_control {T_RX_DIGITALRESET} {5000}

      add_connection phy_reset_control.rx_ready axi_xcvr.ready
    }

  } else {
    send_message error "Only Arria 10 and Stratix 10 are supported."
  }
}

proc create_lane_pll {id tx_or_rx_n pllclk_frequency refclk_frequency num_lanes bonding_clocks_en} {

  set device_family [get_parameter_value "DEVICE_FAMILY"]

  if {$device_family == "Arria 10"} {
    add_instance lane_pll altera_xcvr_atx_pll_a10
    if {$num_lanes > 6} {
      set_instance_parameter_value lane_pll enable_mcgb {true}
      if {$bonding_clocks_en} {
          set_instance_parameter_value lane_pll {enable_bonding_clks} {true}
          set_instance_parameter_value lane_pll {mcgb_div} {1}
          set_instance_parameter_value lane_pll {set_ref_clk_div} {1}
          set_instance_parameter_value lane_pll {pma_width} {40}
      } else {
          set_instance_parameter_value lane_pll enable_hfreq_clk {true}
      }

      add_instance glue adi_jesd204_glue
      add_connection phy_reset_control.pll_powerdown glue.in_pll_powerdown
      add_connection glue.out_pll_powerdown lane_pll.pll_powerdown
      add_connection glue.out_mcgb_rst lane_pll.mcgb_rst
    } else {
      add_connection phy_reset_control.pll_powerdown lane_pll.pll_powerdown
    }
    set_instance_parameter_value lane_pll {enable_pll_reconfig} {1}
  } elseif {$device_family == "Stratix 10"} {
    add_instance lane_pll altera_xcvr_atx_pll_s10_htile
    set_instance_parameter_value lane_pll {rcfg_enable} {1}
    if {$num_lanes > 6} {
      set_instance_parameter_value lane_pll enable_mcgb {true}
      if {$bonding_clocks_en} {
          set_instance_parameter_value lane_pll {enable_bonding_clks} {true}
          set_instance_parameter_value lane_pll {mcgb_div} {1}
          set_instance_parameter_value lane_pll {set_ref_clk_div} {1}
          set_instance_parameter_value lane_pll {pma_width} {40}
      } else {
          set_instance_parameter_value lane_pll enable_hfreq_clk {true}
      }
    }

    ## tie pll_select to GND
    add_instance glue adi_jesd204_glue
    set_instance_parameter_value glue {IN_PLL_POWERDOWN_EN} {0}
    if {$tx_or_rx_n} {
      add_connection glue.out_pll_select_gnd phy_reset_control.pll_select
    }

  } else {
    send_message error "Only Arria 10 and Stratix 10 are supported."
  }

  set_instance_parameter_value lane_pll {rcfg_separate_avmm_busy} {1}
  set_instance_parameter_value lane_pll {set_capability_reg_enable} {1}
  set_instance_parameter_value lane_pll {set_user_identifier} $id
  set_instance_parameter_value lane_pll {set_csr_soft_logic_enable} {1}
  set_instance_parameter_value lane_pll {set_output_clock_frequency} $pllclk_frequency
  set_instance_parameter_value lane_pll {set_auto_reference_clock_frequency} $refclk_frequency

  add_connection lane_pll.pll_locked phy_reset_control.pll_locked
  add_connection lane_pll.pll_cal_busy phy_reset_control.pll_cal_busy
  add_connection ref_clock.out_clk lane_pll.pll_refclk0
  add_connection sys_clock.clk lane_pll.reconfig_clk0
  add_connection sys_clock.clk_reset lane_pll.reconfig_reset0
  add_interface lane_pll_reconfig avalon slave
  set_interface_property lane_pll_reconfig EXPORT_OF lane_pll.reconfig_avmm0
}

proc jesd204_get_max_lane_rate {device soft_pcs} {
  if {[string range $device 0 2] == "10A"} {
    set device_speedgrade [string range $device 13 13]
    set pma_speedgrade [string range $device 8 8]
  } elseif {[string range $device 0 1] == "1S"} {
    set device_speedgrade [string range $device 13 13]
    set pma_speedgrade [string range $device 8 8]
  } else {
    # Assume fastest speed grade
    set device_speedgrade 1
    set pma_speedgrade 1
  }

  if {$soft_pcs} {
    if {$pma_speedgrade == 1 || $pma_speedgrade == 2} {
      return "15000"
    } elseif {$pma_speedgrade == 3} {
      return "14200"
    } else {
      return "12500"
    }
  } else {
    if {$device_speedgrade == 1} {
      return "12000"
    } elseif {$device_speedgrade == 2} {
      return "9830"
    } else {
      return "8936"
    }
  }
}

proc jesd204_validate {{quiet false}} {
  set soft_pcs [get_parameter_value "SOFT_PCS"]
  set input_pipeline [get_parameter_value "INPUT_PIPELINE_STAGES"]
  set device_family [get_parameter_value "DEVICE_FAMILY"]
  set device [get_parameter_value "DEVICE"]
  set lane_rate [get_parameter_value "LANE_RATE"]
  set num_of_lanes [get_parameter_value "NUM_OF_LANES"]
  set tx_or_rx_n [get_parameter_value "TX_OR_RX_N"]
  set link_mode [get_parameter_value "LINK_MODE"]

  if {$device_family != "Arria 10" && $device_family != "Stratix 10" && $device_family != "Agilex 7"} {
    if {!$quiet} {
      send_message error "Only Arria 10/Startix 10/Agilex 7 are supported."
    }
    return false
  }

  if {$link_mode == 1} {
    set max_lane_rate [jesd204_get_max_lane_rate $device $soft_pcs]

    if {$lane_rate < 2000 || $lane_rate > $max_lane_rate} {
      if {!$quiet} {
        send_message error "Lane rate must be in the range 2000-${max_lane_rate} Mbps."
        if {!$soft_pcs} {
          send_message error "Consider enabling soft PCS for a higher maximum lane rate."
          if {$input_pipeline} {
            send_message error "Input pipeline can be active just when soft PCS is used."
          }
        }
      }
      return false
    }
  } else {
    if {$device_family != "Agilex 7"} {
      if {!$quiet} {
        send_message error "JESD204C is only supported on Agilex 7 devices."
        return false
      }
    }
  }

  set_parameter_property BONDING_CLOCKS_EN VISIBLE [expr ($num_of_lanes > 6) && ($tx_or_rx_n)]

  return true
}

proc jesd204_compose {} {

  set id [get_parameter_value "ID"]
  set lane_rate [get_parameter_value "LANE_RATE"]
  set tx_or_rx_n [get_parameter_value "TX_OR_RX_N"]
  set num_of_lanes [get_parameter_value "NUM_OF_LANES"]
  set sysclk_frequency [get_parameter_value "SYSCLK_FREQUENCY"]
  set refclk_frequency [get_parameter_value "REFCLK_FREQUENCY"]
  set lane_map [get_parameter_value "LANE_MAP"]
  set lane_invert [get_parameter_value "LANE_INVERT"]
  set soft_pcs [get_parameter_value "SOFT_PCS"]
  set device_family [get_parameter_value "DEVICE_FAMILY"]
  set device [get_parameter_value "DEVICE"]
  set ext_device_clk_en [get_parameter_value "EXT_DEVICE_CLK_EN"]
  set bonding_clocks_en [get_parameter_value "BONDING_CLOCKS_EN"]
  set input_pipeline [get_parameter_value "INPUT_PIPELINE_STAGES"]
  set tpl_data_path_width [get_parameter_value "TPL_DATA_PATH_WIDTH"]
  set data_path_width [get_parameter_value "DATA_PATH_WIDTH"]
  set link_mode [get_parameter_value "LINK_MODE"]

  set sip_tile ""
  set sip_tile_info [quartus::device::get_part_info -sip_tile $device]
  regexp -nocase {([a-z])\-tile} $sip_tile_info -> sip_tile
  set sip_tile [string toupper $sip_tile]

  if {$link_mode == 1} {
    # jesd204b
    set link_clk_div 40
  } else {
    set link_clk_div 66
  }

  set pllclk_frequency [expr $lane_rate / 2]
  set linkclk_frequency [expr $lane_rate / $link_clk_div]
  set deviceclk_frequency [expr $linkclk_frequency * $data_path_width / $tpl_data_path_width]

  set dual_clk_mode [expr $tpl_data_path_width > 4 || $link_mode == 2]

  if {![jesd204_validate true]} {
    return
  }

  add_instance sys_clock clock_source
  set_instance_parameter_value sys_clock {clockFrequency} [expr $sysclk_frequency*1000000]
  set_instance_parameter_value sys_clock {resetSynchronousEdges} {deassert}
  add_interface sys_clk clock sink
  set_interface_property sys_clk EXPORT_OF sys_clock.clk_in
  add_interface sys_resetn reset sink
  set_interface_property sys_resetn EXPORT_OF sys_clock.clk_in_reset

  if {$device_family == "Arria 10" || $device_family == "Stratix 10"} {
    add_instance ref_clock altera_clock_bridge
    set_instance_parameter_value ref_clock {EXPLICIT_CLOCK_RATE} [expr $refclk_frequency*1000000]
    set_instance_parameter_value ref_clock {NUM_CLOCK_OUTPUTS} 2
    add_interface ref_clk clock sink
    set_interface_property ref_clk EXPORT_OF ref_clock.in_clk
  }

  set outclk_name ""

  ## link clock configuration (also known as device clock, which will be used
  ## by the upper layers for the data path, it can come from the PCS or external)

  add_instance link_clock altera_clock_bridge
  set_instance_parameter_value link_clock {EXPLICIT_CLOCK_RATE} [expr $linkclk_frequency*1000000]
  set_instance_parameter_value link_clock {NUM_CLOCK_OUTPUTS} 2

  add_instance link_reset altera_reset_bridge
  set_instance_parameter_value link_reset {NUM_RESET_OUTPUTS} 2

  if {$dual_clk_mode} {
    if {$ext_device_clk_en} {
      set link_clock          link_clock.out_clk
      set device_clock        ext_device_clock.out_clk
      set device_clock_export ext_device_clock.out_clk_1
    } else {
      set link_clock          link_clock.out_clk
      set device_clock        ref_clock.out_clk
      set device_clock_export ref_clock.out_clk_1
    }
  } else {
    if {$ext_device_clk_en} {
      set link_clock          ext_device_clock.out_clk
      set device_clock        ext_device_clock.out_clk
      set device_clock_export ext_device_clock.out_clk_1
    } else {
      set link_clock          link_clock.out_clk
      set device_clock        link_clock.out_clk
      set device_clock_export link_clock.out_clk_1
    }
  }

  if {$device_family == "Arria 10"} {

    add_instance link_pll altera_xcvr_fpll_a10
    set_instance_parameter_value link_pll {gui_fpll_mode} {0}
    set_instance_parameter_value link_pll {gui_reference_clock_frequency} $refclk_frequency
    set_instance_parameter_value link_pll {gui_number_of_output_clocks} 2
    set_instance_parameter_value link_pll {gui_enable_phase_alignment} 1
    set_instance_parameter_value link_pll {gui_desired_outclk0_frequency} $linkclk_frequency
    set_instance_parameter_value link_pll {enable_pll_reconfig} {1}
    set pfdclk_frequency [get_instance_parameter_value link_pll gui_pfd_frequency]
    set_instance_parameter_value link_pll {gui_desired_outclk1_frequency} $pfdclk_frequency

    set outclk_name "outclk0"
    add_connection link_pll.$outclk_name link_clock.in_clk

    add_instance link_pll_reset_control altera_xcvr_reset_control
    set_instance_parameter_value link_pll_reset_control {SYNCHRONIZE_RESET} {0}
    set_instance_parameter_value link_pll_reset_control {SYS_CLK_IN_MHZ} $sysclk_frequency
    set_instance_parameter_value link_pll_reset_control {TX_PLL_ENABLE} {1}
    set_instance_parameter_value link_pll_reset_control {T_PLL_POWERDOWN} {1000}
    set_instance_parameter_value link_pll_reset_control {TX_ENABLE} {0}
    set_instance_parameter_value link_pll_reset_control {RX_ENABLE} {0}
    add_connection sys_clock.clk link_pll_reset_control.clock
    add_connection link_reset.out_reset link_pll_reset_control.reset
    add_connection sys_clock.clk_reset link_pll_reset_control.reset
    add_connection link_pll_reset_control.pll_powerdown link_pll.pll_powerdown

  } elseif {$device_family == "Stratix 10" && $sip_tile == "H"} {

    send_message info "Instantiate a fpll_s10_htile for link_pll."
    add_instance link_pll altera_xcvr_fpll_s10_htile
    ## Primary Use is Core mode
    set_instance_parameter_value link_pll {set_primary_use} 0
    ## Basic Mode
    set_instance_parameter_value link_pll {set_prot_mode} 0
    set_instance_parameter_value link_pll {message_level} {error}
    set_instance_parameter_value link_pll {set_refclk_cnt} {1}
    set_instance_parameter_value link_pll {set_auto_reference_clock_frequency} $refclk_frequency
    set_instance_parameter_value link_pll {set_output_clock_frequency} $linkclk_frequency
    set_instance_parameter_value link_pll {set_bw_sel} {medium}
    set_instance_parameter_value link_pll {rcfg_enable} {1}
    set_instance_parameter_value link_pll {set_csr_soft_logic_enable} {1}
    set_instance_parameter_value link_pll {set_capability_reg_enable} {1}

    set outclk_name "outclk_div1"
    add_connection link_pll.$outclk_name link_clock.in_clk

  } elseif {$device_family == "Stratix 10" && $sip_tile == "E"} {

    ## No fPLL here, PLL embedded in Native PHY

  } elseif {$device_family == "Agilex 7"} {

    ## No fPLL here, PLL embedded in Native PHY

  } else {
    ## Unsupported device
    send_message error "Only Arria 10/Stratix 10/Agilex 7 are supported."
  }

  add_interface link_clk clock source

  add_connection sys_clock.clk link_reset.clk
  add_interface link_reset reset source
  set_interface_property link_reset EXPORT_OF link_reset.out_reset_1

  if {$device_family == "Arria 10" || $device_family == "Stratix 10"} {
    set_instance_parameter_value link_pll {set_capability_reg_enable} {1}
    set_instance_parameter_value link_pll {set_csr_soft_logic_enable} {1}
    set_instance_parameter_value link_pll {rcfg_separate_avmm_busy} {1}
    add_connection ref_clock.out_clk link_pll.pll_refclk0

    add_connection sys_clock.clk_reset link_pll.reconfig_reset0
    add_connection sys_clock.clk link_pll.reconfig_clk0
  }

  add_instance axi_xcvr axi_adxcvr
  set_instance_parameter_value axi_xcvr {ID} $id
  set_instance_parameter_value axi_xcvr {TX_OR_RX_N} $tx_or_rx_n
  set_instance_parameter_value axi_xcvr {NUM_OF_LANES} $num_of_lanes

  add_connection sys_clock.clk axi_xcvr.s_axi_clock
  add_connection sys_clock.clk_reset axi_xcvr.s_axi_reset
  add_connection axi_xcvr.if_up_rst link_reset.in_reset

  add_interface link_management axi4lite slave
  set_interface_property link_management EXPORT_OF axi_xcvr.s_axi

  if {$device_family == "Arria 10" || $device_family == "Stratix 10"} {
    add_connection link_pll.pll_locked axi_xcvr.core_pll_locked

    add_interface link_pll_reconfig avalon slave
    set_interface_property link_pll_reconfig EXPORT_OF link_pll.reconfig_avmm0
    set_interface_property link_pll_reconfig associatedClock sys_clk
    set_interface_property link_pll_reconfig associatedReset sys_resetn

    create_phy_reset_control $tx_or_rx_n $num_of_lanes $sysclk_frequency
  }

  add_instance phy jesd204_phy
  set_instance_parameter_value phy ID $id
  set_instance_parameter_value phy LINK_MODE $link_mode
  set_instance_parameter_value phy DEVICE $device_family
  set_instance_parameter_value phy SOFT_PCS $soft_pcs
  set_instance_parameter_value phy TX_OR_RX_N $tx_or_rx_n
  set_instance_parameter_value phy LANE_RATE $lane_rate
  set_instance_parameter_value phy REFCLK_FREQUENCY $refclk_frequency
  set_instance_parameter_value phy NUM_OF_LANES $num_of_lanes
  set_instance_parameter_value phy REGISTER_INPUTS $input_pipeline
  set_instance_parameter_value phy LANE_INVERT $lane_invert
  set_instance_parameter_value phy BONDING_CLOCKS_EN $bonding_clocks_en

  add_connection link_reset.out_reset phy.link_reset
  add_connection sys_clock.clk phy.reconfig_clk
  add_connection sys_clock.clk_reset phy.reconfig_reset

  ## connect the required device clock

  if {$ext_device_clk_en} {
    add_instance ext_device_clock altera_clock_bridge
    set_instance_parameter_value ext_device_clock {EXPLICIT_CLOCK_RATE} [expr $deviceclk_frequency*1000000]
    set_instance_parameter_value ext_device_clock {NUM_CLOCK_OUTPUTS} 2
    add_interface device_clk clock sink
    set_interface_property device_clk EXPORT_OF ext_device_clock.in_clk
  }

  add_connection $link_clock phy.link_clk
  set_interface_property link_clk EXPORT_OF $device_clock_export

  if {$device_family == "Arria 10" || $device_family == "Stratix 10"} {
    if {$tx_or_rx_n} {
      create_lane_pll $id $tx_or_rx_n $pllclk_frequency $refclk_frequency $num_of_lanes $bonding_clocks_en
      if {$num_of_lanes > 6} {
          if {$bonding_clocks_en} {
              add_connection lane_pll.tx_bonding_clocks phy.bonding_clocks
          } else {
              add_connection lane_pll.tx_serial_clk   phy.serial_clk_x1
              add_connection lane_pll.mcgb_serial_clk phy.serial_clk_xN
          }
      } else {
          add_connection lane_pll.tx_serial_clk phy.serial_clk_x1
      }
    }
  }

  if {$device_family == "Arria 10" || $device_family == "Stratix 10"} {
   # add_connection ref_clock.out_clk phy.ref_clk

  } elseif {$device_family == "Agilex 7"} {
    add_connection phy.clkout link_clock.in_clk

    add_connection phy.clkout2 phy.phy_clk
    add_connection link_reset.out_reset phy.phy_reset

    # PHY <-> AXI_XCVR
    if {$tx_or_rx_n} {
      add_connection axi_xcvr.core_pll_locked phy.pll_locked
    } else {
      add_connection axi_xcvr.rx_lockedtodata phy.rx_lockedtodata
    }
    add_connection axi_xcvr.ready     phy.ready
    add_connection axi_xcvr.reset     phy.reset
    add_connection axi_xcvr.reset_ack phy.reset_ack

    add_connection axi_xcvr.if_up_rst phy.link_reset

    ## Export ref clocks
    add_interface ref_clk ftile_hssi_reference_clock sink
    set_interface_property ref_clk EXPORT_OF phy.ref_clk
  } else {
    ## Unsupported device
    send_message error "Only Arria 10/Stratix 10/Agilex 7 are supported."
  }

  if {$tx_or_rx_n} {
    set data_direction sink
    set jesd204_intfs {config device_config control ilas_config device_event status}
    set tx_rx "tx"
  } else {
    set data_direction source
    set jesd204_intfs {config device_config ilas_config device_event status}
    set tx_rx "rx"
    if {$device_family == "Arria 10" || $device_family == "Stratix 10"} {
      add_connection ref_clock.out_clk phy.ref_clk
    }
  }

  add_instance axi_jesd204_${tx_rx} axi_jesd204_${tx_rx}
  set_instance_parameter_value axi_jesd204_${tx_rx} {NUM_LANES} $num_of_lanes
  set_instance_parameter_value axi_jesd204_${tx_rx} {LINK_MODE} $link_mode

  add_connection sys_clock.clk axi_jesd204_${tx_rx}.s_axi_clock
  add_connection sys_clock.clk_reset axi_jesd204_${tx_rx}.s_axi_reset

  add_instance jesd204_${tx_rx} jesd204_${tx_rx}
  set_instance_parameter_value jesd204_${tx_rx} {NUM_LANES} $num_of_lanes
  set_instance_parameter_value jesd204_${tx_rx} {ASYNC_CLK} $dual_clk_mode
  set_instance_parameter_value jesd204_${tx_rx} {TPL_DATA_PATH_WIDTH} $tpl_data_path_width
  set_instance_parameter_value jesd204_${tx_rx} {DATA_PATH_WIDTH} $data_path_width
  set_instance_parameter_value jesd204_${tx_rx} {LINK_MODE} $link_mode

  add_connection $link_clock axi_jesd204_${tx_rx}.core_clock
  add_connection $device_clock axi_jesd204_${tx_rx}.device_clock
  add_connection $link_clock jesd204_${tx_rx}.clock
  add_connection $device_clock jesd204_${tx_rx}.device_clock

  add_connection link_reset.out_reset axi_jesd204_${tx_rx}.core_reset_ext
  add_connection axi_jesd204_${tx_rx}.core_reset jesd204_${tx_rx}.reset
  add_connection axi_jesd204_${tx_rx}.device_reset jesd204_${tx_rx}.device_reset

  foreach intf $jesd204_intfs {
    add_connection axi_jesd204_${tx_rx}.${intf} jesd204_${tx_rx}.${intf}
  }

  if {$device_family == "Arria 10" || $device_family == "Stratix 10"} {

    set phy_reset_intfs_s10 {analogreset_stat digitalreset_stat}

    if {$tx_or_rx_n} {
      set phy_reset_intfs {analogreset digitalreset cal_busy}

    } else {
      set phy_reset_intfs {analogreset digitalreset cal_busy is_lockedtodata}
    }

    foreach intf $phy_reset_intfs {
      add_connection phy_reset_control.${tx_rx}_${intf} phy.${intf}
    }

    ## connect phy_reset_control interfaces specific to Stratix 10
    if {$device_family == "Stratix 10"} {
      foreach intf $phy_reset_intfs_s10 {
        add_connection phy_reset_control.${tx_rx}_${intf} phy.${intf}
      }
    }
  }

  set lane_map [regexp -all -inline {\S+} $lane_map]
  for {set i 0} {$i < $num_of_lanes} {incr i} {
    if {$lane_map != {}} {
      set j [lindex $lane_map $i]
    } else {
      set j $i
    }
    add_connection jesd204_${tx_rx}.${tx_rx}_phy${j} phy.phy_${i}
  }

  if {$device_family == "Arria 10" || $device_family == "Stratix 10"} {
    for {set i 0} {$i < $num_of_lanes} {incr i} {
      add_interface phy_reconfig_${i} avalon slave
      set_interface_property phy_reconfig_${i} EXPORT_OF phy.reconfig_avmm_${i}
    }
  } elseif {$device_family == "Agilex 7"} {
    add_interface phy_reconfig avalon slave
    set_interface_property phy_reconfig EXPORT_OF phy.reconfig_avmm
  }

  add_interface interrupt interrupt end
  set_interface_property interrupt EXPORT_OF axi_jesd204_${tx_rx}.interrupt
  add_interface link_reconfig axi4lite slave
  set_interface_property link_reconfig EXPORT_OF axi_jesd204_${tx_rx}.s_axi

  add_interface link_data avalon_streaming $data_direction
  set_interface_property link_data EXPORT_OF jesd204_${tx_rx}.${tx_rx}_data

  if {!$tx_or_rx_n} {
    add_interface link_sof conduit end
    set_interface_property link_sof EXPORT_OF jesd204_rx.rx_sof
  }

  add_interface sysref conduit end
  set_interface_property sysref EXPORT_OF jesd204_${tx_rx}.sysref

  add_interface sync conduit end
  set_interface_property sync EXPORT_OF jesd204_${tx_rx}.sync

  add_interface serial_data conduit end
  set_interface_property serial_data EXPORT_OF phy.serial_data

  if {$device_family == "Agilex 7"} {
    add_interface serial_data_n conduit end
    set_interface_property serial_data_n EXPORT_OF phy.serial_data_n
  }
}
