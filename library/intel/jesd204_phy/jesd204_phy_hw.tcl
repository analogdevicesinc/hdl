###############################################################################
## Copyright (C) 2016-2022, 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

#
# Instantiates the Arria 10 native PHY and configures it for JESD204 operation.
# The datapath width is configured for 4 octets per beat.
#
# Optionally a soft-logic PCS is instantiated, this can be used if the lane rate
# is too high for the hard-logic PCS.
#

ad_ip_create jesd204_phy "ADI JESD204 PHY"
set_module_property COMPOSITION_CALLBACK jesd204_phy_composition_callback
set_module_property INTERNAL false

# parameters

ad_ip_parameter DEVICE STRING "Stratix 10" false
ad_ip_parameter ID NATURAL 0 false
ad_ip_parameter LINK_MODE INTEGER 1 false
ad_ip_parameter SOFT_PCS BOOLEAN false false
ad_ip_parameter TX_OR_RX_N BOOLEAN false false
ad_ip_parameter LANE_RATE FLOAT 10000 false
ad_ip_parameter REFCLK_FREQUENCY FLOAT 500.0 false
ad_ip_parameter NUM_OF_LANES POSITIVE 4 false
ad_ip_parameter REGISTER_INPUTS INTEGER 0 false
ad_ip_parameter LANE_INVERT INTEGER 0 false
ad_ip_parameter BONDING_CLOCKS_EN BOOLEAN false false

proc log2 {x} {
    expr (log($x) / log(2))
}

#proc log2 {x} {
#  return [tcl::mathfunc::int [tcl::mathfunc::ceil [expr [tcl::mathfunc::log $x] / [tcl::mathfunc::log 2]]]]
#}

proc jesd204_phy_composition_callback {} {

  set device [get_parameter_value "DEVICE"]
  set soft_pcs [get_parameter_value "SOFT_PCS"]
  set link_mode [get_parameter_value "LINK_MODE"]
  set tx [get_parameter_value "TX_OR_RX_N"]
  set lane_rate [get_parameter_value "LANE_RATE"]
  set refclk_frequency [get_parameter_value "REFCLK_FREQUENCY"]
  set id [get_parameter_value "ID"]
  set num_of_lanes [get_parameter_value "NUM_OF_LANES"]
  set register_inputs [get_parameter_value "REGISTER_INPUTS"]
  set lane_invert [get_parameter_value "LANE_INVERT"]
  set bonding_clocks_en [get_parameter_value "BONDING_CLOCKS_EN"]

  if {$link_mode == 1} {
    set link_clk_frequency [expr $lane_rate / 40]
    set phy_clk_frequency [expr $lane_rate / 20]
    set pma_width 20
    set datapath_width 4
    set usr_pll_div 40
  } else {
    set link_clk_frequency [expr $lane_rate / 66]
    set phy_clk_frequency [expr $lane_rate / 32]
    set pma_width 32
    set datapath_width 8
    if {$lane_rate >= 16300} {
      set usr_pll_div 33
    } else {
      set usr_pll_div 66
    }
  }

  if {[string equal $device "Arria 10"]} {
    set device_type 1
  } elseif {[string equal $device "Stratix 10"]} {
    set device_type 2
  } elseif {[string equal $device "Agilex 7"]} {
    set device_type 3
  } else {
    set device_type 0
  }

  add_instance link_clock clock_source
  set_instance_parameter_value link_clock {clockFrequency} [expr $link_clk_frequency*1000000]
  add_interface link_clk clock sink
  set_interface_property link_clk EXPORT_OF link_clock.clk_in
  add_interface link_reset reset sink
  set_interface_property link_reset EXPORT_OF link_clock.clk_in_reset

  ## Arria10
  if {$device_type == 1} {
    add_instance native_phy altera_xcvr_native_a10
    set_instance_parameter_value native_phy {enh_txfifo_mode} "Phase compensation"
    set_instance_parameter_value native_phy {enh_rxfifo_mode} "Phase compensation"
    set_instance_property native_phy SUPPRESS_ALL_WARNINGS true
    set_instance_property native_phy SUPPRESS_ALL_INFO_MESSAGES true
  ## Stratix 10
  } elseif {$device_type == 2} {
    add_instance native_phy altera_xcvr_native_s10_htile
    set_instance_parameter_value native_phy {tx_fifo_mode} "Phase compensation"
    set_instance_parameter_value native_phy {rx_fifo_mode} "Phase compensation"
  ## Agilex F-Tile
  } elseif {$device_type == 3} {
    add_instance native_phy directphy_f
    set_instance_parameter_value native_phy xcvr_type "FGT"
    set_instance_parameter_value native_phy num_xcvr_per_sys $num_of_lanes
    set_instance_parameter_value native_phy clocking_mode "xcvr"
    set_instance_parameter_value native_phy pma_modulation "NRZ"
    set_instance_parameter_value native_phy pma_data_rate $lane_rate
    set_instance_parameter_value native_phy pma_width $pma_width
    set_instance_parameter_value native_phy rx_deskew_en 0

  ## Unsupported device
  } else {
    send_message error "Only Arria 10/Stratix 10/Agilex 7 are supported."
  }

  # Common paramters to all PHYs
  if {$tx} {
    set tx_rx "tx"
  } else {
    set tx_rx "rx"
  }
  set_instance_parameter_value native_phy {duplex_mode} $tx_rx

  if {$device_type == 1 || $device_type == 2} {
    if {$soft_pcs} {
      set_instance_parameter_value native_phy {protocol_mode} "basic_enh"
    } else {
      set_instance_parameter_value native_phy {protocol_mode} "basic_std"
      set_instance_parameter_value native_phy {std_pcs_pma_width} 20

      if {$tx} {
        set_instance_parameter_value native_phy {std_tx_byte_ser_mode} "Serialize x2"
        set_instance_parameter_value native_phy {std_tx_8b10b_enable} 1
        set_instance_parameter_value native_phy {std_tx_polinv_enable} 1
        set_instance_parameter_value native_phy {enable_port_tx_polinv} 1
      } else {
        set_instance_parameter_value native_phy {std_rx_byte_deser_mode} "Deserialize x2"
        set_instance_parameter_value native_phy {std_rx_8b10b_enable} 1
        set_instance_parameter_value native_phy {std_rx_word_aligner_mode} "manual (PLD controlled)"
        set_instance_parameter_value native_phy {std_rx_word_aligner_pattern_len} 20
        set_instance_parameter_value native_phy {std_rx_word_aligner_pattern} 0xA0D7C
        set_instance_parameter_value native_phy {enable_port_rx_std_wa_patternalign} 1
        set_instance_parameter_value native_phy {std_rx_polinv_enable} 1
        set_instance_parameter_value native_phy {enable_port_rx_polinv} 1
      }
    }

    if {$tx} {
      if {$bonding_clocks_en && $num_of_lanes > 6} {
          set_instance_parameter_value native_phy {bonded_mode} "pma_only"
      } else {
          set_instance_parameter_value native_phy {bonded_mode} "not_bonded"
      }
      set_instance_parameter_value native_phy {enable_port_tx_pma_elecidle} 0
    } else {
      set_instance_parameter_value native_phy {set_cdr_refclk_freq} $refclk_frequency
      set_instance_parameter_value native_phy {enable_port_rx_is_lockedtodata} 1
      set_instance_parameter_value native_phy {enable_port_rx_is_lockedtoref} 0
      set_instance_parameter_value native_phy {enable_ports_rx_manual_cdr_mode} 0
    }

    set_instance_parameter_value native_phy {channels} $num_of_lanes
    set_instance_parameter_value native_phy {set_data_rate} $lane_rate
    set_instance_parameter_value native_phy {enable_simple_interface} 1
    set_instance_parameter_value native_phy {enh_pcs_pma_width} 40
    set_instance_parameter_value native_phy {enh_pld_pcs_width} 40
    set_instance_parameter_value native_phy {rcfg_enable} 1
    set_instance_parameter_value native_phy {rcfg_shared} 0
    set_instance_parameter_value native_phy {rcfg_jtag_enable} 0
    set_instance_parameter_value native_phy {rcfg_sv_file_enable} 0
    set_instance_parameter_value native_phy {rcfg_h_file_enable} 0
    set_instance_parameter_value native_phy {rcfg_mif_file_enable} 0
    set_instance_parameter_value native_phy {set_user_identifier} $id
    set_instance_parameter_value native_phy {set_capability_reg_enable} 1
    set_instance_parameter_value native_phy {set_csr_soft_logic_enable} 1
    set_instance_parameter_value native_phy {set_prbs_soft_logic_enable} 0

  } elseif {$device_type == 3} {
    if {$tx} {
      set_instance_parameter_value native_phy fgt_tx_pll_refclk_freq_mhz [format {%.6f} $refclk_frequency]
      set_instance_parameter_value native_phy pmaif_tx_fifo_mode_s "phase_comp"
      set_instance_parameter_value native_phy pldif_tx_double_width_transfer_enable 1
      set_instance_parameter_value native_phy pldif_tx_fifo_mode "phase_comp"
      set_instance_parameter_value native_phy pldif_tile_tx_fifo_mode "phase_comp"
      set_instance_parameter_value native_phy pldif_tx_fifo_pfull_thld 10
      set_instance_parameter_value native_phy fgt_tx_pll_txuserclk1_enable 1
      set_instance_parameter_value native_phy fgt_tx_pll_txuserclk_div $usr_pll_div
      set_instance_parameter_value native_phy enable_port_tx_clkout2 1
      set_instance_parameter_value native_phy pldif_tx_clkout_sel "TX_USER_CLK1"
      set_instance_parameter_value native_phy pldif_tx_clkout2_sel "TX_WORD_CLK"
      set_instance_parameter_value native_phy pldif_tx_clkout2_div 2
      set_instance_parameter_value native_phy avmm2_enable 1
    } else {
      set_instance_parameter_value native_phy fgt_rx_pll_refclk_freq_mhz [format {%.6f} $refclk_frequency]
      set_instance_parameter_value native_phy pmaif_rx_fifo_mode_s "register"
      set_instance_parameter_value native_phy pldif_rx_double_width_transfer_enable 1
      set_instance_parameter_value native_phy fgt_rx_cdr_rxuserclk_enable 1
      set_instance_parameter_value native_phy fgt_rx_cdr_rxuserclk_div $usr_pll_div
      set_instance_parameter_value native_phy pldif_rx_fifo_pfull_thld 10
      set_instance_parameter_value native_phy enable_port_rx_clkout2 1
      set_instance_parameter_value native_phy pldif_rx_clkout_sel "RX_USER_CLK1"
      set_instance_parameter_value native_phy pldif_rx_clkout2_sel "RX_WORD_CLK"
      set_instance_parameter_value native_phy pldif_rx_clkout2_div 2
      set_instance_parameter_value native_phy avmm2_enable 1
      set_instance_parameter_value native_phy fgt_rx_serdes_adapt_mode {auto}
    }
  }

  add_instance phy_glue jesd204_phy_glue
  set_instance_parameter_value phy_glue DEVICE $device
  set_instance_parameter_value phy_glue TX_OR_RX_N $tx
  set_instance_parameter_value phy_glue SOFT_PCS $soft_pcs
  set_instance_parameter_value phy_glue NUM_OF_LANES $num_of_lanes
  set_instance_parameter_value phy_glue LANE_INVERT $lane_invert
  set_instance_parameter_value phy_glue BONDING_CLOCKS_EN $bonding_clocks_en
  set_instance_parameter_value phy_glue LINK_MODE $link_mode

  add_interface reconfig_clk clock sink
  set_interface_property reconfig_clk EXPORT_OF phy_glue.reconfig_clk

  add_interface reconfig_reset reset sink
  set_interface_property reconfig_reset EXPORT_OF phy_glue.reconfig_reset

  # Connect PHY with GLUE
  if {$device_type == 1 || $device_type == 2} {

    if {$tx} {
      if {$bonding_clocks_en && $num_of_lanes > 6} {
          add_interface bonding_clocks hssi_bonded_clock end
          set_interface_property bonding_clocks EXPORT_OF phy_glue.tx_bonding_clocks
          add_connection phy_glue.phy_tx_bonding_clocks native_phy.tx_bonding_clocks
      } else {
          add_interface serial_clk_x1 hssi_serial_clock end
          set_interface_property serial_clk_x1 EXPORT_OF phy_glue.tx_serial_clk_x1
          if {$num_of_lanes > 6} {
             add_interface serial_clk_xN hssi_serial_clock end
             set_interface_property serial_clk_xN EXPORT_OF phy_glue.tx_serial_clk_xN
          }
          add_connection phy_glue.phy_tx_serial_clk0 native_phy.tx_serial_clk0
      }

      add_connection link_clock.clk phy_glue.tx_coreclkin

      if { $soft_pcs == true && $device_type == 1 }  {
        add_connection phy_glue.phy_tx_enh_data_valid native_phy.tx_enh_data_valid
      }

      foreach x {reconfig_clk reconfig_reset reconfig_avmm tx_coreclkin \
        tx_clkout tx_parallel_data unused_tx_parallel_data} {
        add_connection phy_glue.phy_${x} native_phy.${x}
      }

      foreach x {serial_data analogreset digitalreset cal_busy} {
        add_interface ${x} conduit end
        set_interface_property ${x} EXPORT_OF native_phy.tx_${x}
      }

      if {$soft_pcs == false} {
        add_connection phy_glue.phy_tx_datak native_phy.tx_datak
        add_connection phy_glue.phy_tx_polinv native_phy.tx_polinv
      }

      ## Startix 10
      if {$device_type == 2} {
        foreach x {analogreset_stat digitalreset_stat} {
          add_interface ${x} conduit end
          set_interface_property ${x} EXPORT_OF native_phy.tx_${x}
        }
      }

    } else {

      add_interface ref_clk clock sink
      set_interface_property ref_clk EXPORT_OF phy_glue.rx_cdr_refclk0

      add_connection link_clock.clk phy_glue.rx_coreclkin

      foreach x {serial_data analogreset digitalreset cal_busy is_lockedtodata} {
        add_interface ${x} conduit end
        set_interface_property ${x} EXPORT_OF native_phy.rx_${x}
      }

      foreach x {reconfig_clk reconfig_reset reconfig_avmm rx_coreclkin \
        rx_clkout rx_parallel_data rx_cdr_refclk0} {
        add_connection phy_glue.phy_${x} native_phy.${x}
      }

      if {$soft_pcs == false} {
        foreach x {rx_datak rx_disperr rx_errdetect rx_std_wa_patternalign} {
          add_connection phy_glue.phy_${x} native_phy.${x}
        }
        add_connection phy_glue.phy_rx_polinv native_phy.rx_polinv
      }

      ## Startix 10
      if {$device_type == 2} {
        foreach x {analogreset_stat digitalreset_stat} {
          add_interface ${x} conduit end
          set_interface_property ${x} EXPORT_OF native_phy.rx_${x}
        }
      }

    }

    # Connect GLUE with PCS
    for {set i 0} {$i < $num_of_lanes} {incr i} {
      add_interface reconfig_avmm_${i} avalon slave
      set_interface_property reconfig_avmm_${i} EXPORT_OF phy_glue.reconfig_avmm_${i}

      add_interface phy_${i} conduit start

      if {$tx} {
        if {$soft_pcs} {
          add_instance soft_pcs_${i} jesd204_soft_pcs_tx
          set_instance_parameter_value soft_pcs_${i} INVERT_OUTPUTS \
            [expr ($lane_invert >> $i) & 1]
          add_connection link_clock.clk soft_pcs_${i}.clock
          add_connection link_clock.clk_reset soft_pcs_${i}.reset
          add_connection soft_pcs_${i}.tx_raw_data phy_glue.tx_raw_data_${i}

          set_interface_property phy_${i} EXPORT_OF soft_pcs_${i}.tx_phy
        } else {
          set_interface_property phy_${i} EXPORT_OF phy_glue.tx_phy_${i}
        }
      } else {
        if {$soft_pcs} {
          add_instance soft_pcs_${i} jesd204_soft_pcs_rx
          set_instance_parameter_value soft_pcs_${i} REGISTER_INPUTS $register_inputs
          set_instance_parameter_value soft_pcs_${i} INVERT_INPUTS \
            [expr ($lane_invert >> $i) & 1]
          add_connection link_clock.clk soft_pcs_${i}.clock
          add_connection link_clock.clk_reset soft_pcs_${i}.reset
          add_connection phy_glue.rx_raw_data_${i} soft_pcs_${i}.rx_raw_data

          set_interface_property phy_${i} EXPORT_OF soft_pcs_${i}.rx_phy
        } else {
          set_interface_property phy_${i} EXPORT_OF phy_glue.rx_phy_${i}
        }
      }
    }

  # Agilex
  } elseif {$device_type == 3} {

    add_instance phy_clk clock_source
    set_instance_parameter_value phy_clk {clockFrequency} [expr $phy_clk_frequency*1000000]
    add_interface phy_clk clock sink
    set_interface_property phy_clk EXPORT_OF phy_clk.clk_in
    add_interface phy_reset reset sink
    set_interface_property phy_reset EXPORT_OF phy_clk.clk_in_reset

    add_interface ref_clk ftile_hssi_reference_clock end
    set_interface_property ref_clk EXPORT_OF phy_glue.ref_clk

    # export ${tx_rx}_reset, ${tx_rx}_ready, ${tx_rx}_reset_ack
    # This conects to axi_xcvr
    foreach x {reset reset_ack ready} {
      add_interface ${x} conduit end
      set_interface_property ${x} EXPORT_OF native_phy.${tx_rx}_${x}
    }

    if {$tx} {
      add_interface pll_locked conduit end
      set_interface_property pll_locked EXPORT_OF native_phy.tx_pll_locked
    } else {
      add_interface rx_lockedtodata conduit end
      set_interface_property rx_lockedtodata EXPORT_OF native_phy.rx_is_lockedtodata
    }

    # export ${tx_rx}_serial_data, ${tx_rx}_serial_data_n
    foreach x {serial_data serial_data_n} {
      add_interface ${x} conduit end
      set_interface_property ${x} EXPORT_OF native_phy.${tx_rx}_${x}
    }

    if {$link_mode == 2} {
      # this is lane rate / 64
      add_connection phy_clk.clk phy_glue.${tx_rx}_coreclkin
    } else {
      # this is lane rate / 40
      add_connection link_clock.clk phy_glue.${tx_rx}_coreclkin
    }
    add_connection phy_glue.phy_${tx_rx}_coreclkin native_phy.${tx_rx}_coreclkin

    # Reconfig interface
    add_connection phy_glue.phy_reconfig_clk native_phy.reconfig_xcvr_clk
    add_connection phy_glue.phy_reconfig_reset native_phy.reconfig_xcvr_reset
    add_connection phy_glue.phy_reconfig_avmm native_phy.reconfig_xcvr_avmm

    add_interface reconfig_avmm avalon slave
    set_interface_property reconfig_avmm EXPORT_OF phy_glue.reconfig_avmm

    # connect ref clock and output clock from - to GLUE
    # tx_pll_refclk_link
    if {$tx} {
      set tx_rx_ref_name "pll"
    } else {
      set tx_rx_ref_name "cdr"
    }
    add_connection phy_glue.phy_ref_clk native_phy.${tx_rx}_${tx_rx_ref_name}_refclk_link

    foreach x [list ${tx_rx}_parallel_data ${tx_rx}_clkout2 ${tx_rx}_clkout] {
      add_connection phy_glue.phy_${x} native_phy.${x}
    }

    # This is lane rate / 40 (jesd204b) or lane rate / 64 (jesd204c)
    add_interface clkout2 clock source
    set_interface_property clkout2 EXPORT_OF phy_glue.${tx_rx}_clkout2_0

    # This is lane rate / 40 (jesd204b) or lane rate / 66 (jesd204c)
    add_interface clkout clock source
    set_interface_property clkout EXPORT_OF phy_glue.${tx_rx}_clkout_0

    # Connect GLUE with PCS
    for {set i 0} {$i < $num_of_lanes} {incr i} {
      add_interface phy_${i} conduit end

      if {$tx} {
        if {$link_mode == 1} {
          # JESD204B
          add_instance soft_pcs_${i} jesd204_soft_pcs_tx
          set_instance_parameter_value soft_pcs_${i} IFC_TYPE 1
          set_instance_parameter_value soft_pcs_${i} INVERT_OUTPUTS \
            [expr ($lane_invert >> $i) & 1]
          add_connection link_clock.clk soft_pcs_${i}.clock
          add_connection link_clock.clk_reset soft_pcs_${i}.reset
          add_connection phy_glue.tx_raw_data_${i} soft_pcs_${i}.tx_raw_data

          set_interface_property phy_${i} EXPORT_OF soft_pcs_${i}.tx_phy
        } else {
          # JESD204C
          add_instance tx_adapter_${i} jesd204_f_tile_adapter_tx
          add_connection phy_clk.clk               tx_adapter_${i}.phy_tx_clock
          add_connection link_clock.clk            tx_adapter_${i}.link_clock
          add_connection link_clock.clk_reset      tx_adapter_${i}.reset
          add_connection phy_glue.tx_raw_data_${i} tx_adapter_${i}.phy_tx_parallel_data

          set_interface_property phy_${i} EXPORT_OF tx_adapter_${i}.link_tx

          # instantiate the CDC fifo
          add_instance tx_fifo_${i} fifo
          set_instance_parameter_value tx_fifo_${i} GUI_CLOCKS_ARE_SYNCHRONIZED {0}
          set_instance_parameter_value tx_fifo_${i} GUI_Clock {4}
          set_instance_parameter_value tx_fifo_${i} GUI_DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT {1}
          set_instance_parameter_value tx_fifo_${i} GUI_Depth {32}
          set_instance_parameter_value tx_fifo_${i} GUI_Empty {1}
          set_instance_parameter_value tx_fifo_${i} GUI_Full {1}
          set_instance_parameter_value tx_fifo_${i} GUI_LegacyRREQ {1}
          set_instance_parameter_value tx_fifo_${i} GUI_MAX_DEPTH {Auto}
          set_instance_parameter_value tx_fifo_${i} GUI_RAM_BLOCK_TYPE {Auto}
          set_instance_parameter_value tx_fifo_${i} GUI_UsedW {1}
          set_instance_parameter_value tx_fifo_${i} GUI_Width {66}
          set_instance_parameter_value tx_fifo_${i} GUI_dc_aclr {1}
          set_instance_parameter_value tx_fifo_${i} GUI_delaypipe {5}
          set_instance_parameter_value tx_fifo_${i} GUI_diff_widths {0}
          set_instance_parameter_value tx_fifo_${i} GUI_output_width {8}
          set_instance_parameter_value tx_fifo_${i} GUI_read_aclr_synch {1}
          set_instance_parameter_value tx_fifo_${i} GUI_rsEmpty {1}
          set_instance_parameter_value tx_fifo_${i} GUI_synStage {3}
          set_instance_parameter_value tx_fifo_${i} GUI_write_aclr_synch {1}
          set_instance_parameter_value tx_fifo_${i} GUI_wsEmpty {0}
          set_instance_parameter_value tx_fifo_${i} GUI_wsFull {1}

          add_connection tx_fifo_${i}.fifo_input  tx_adapter_${i}.fifo_input
          add_connection tx_fifo_${i}.fifo_output tx_adapter_${i}.fifo_output
        }
      } else {
        # JESD204B
        if {$link_mode == 1} {
          add_instance soft_pcs_${i} jesd204_soft_pcs_rx
          set_instance_parameter_value soft_pcs_${i} IFC_TYPE 1
          set_instance_parameter_value soft_pcs_${i} REGISTER_INPUTS $register_inputs
          set_instance_parameter_value soft_pcs_${i} INVERT_INPUTS \
            [expr ($lane_invert >> $i) & 1]
          add_connection link_clock.clk soft_pcs_${i}.clock
          add_connection link_clock.clk_reset soft_pcs_${i}.reset
          add_connection phy_glue.rx_raw_data_${i} soft_pcs_${i}.rx_raw_data

          set_interface_property phy_${i} EXPORT_OF soft_pcs_${i}.rx_phy
        } else {
          # JESD204C
          add_instance rx_adapter_${i} jesd204_f_tile_adapter_rx
          add_connection phy_clk.clk                rx_adapter_${i}.phy_rx_clock
          add_connection link_clock.clk             rx_adapter_${i}.link_clock
          add_connection link_clock.clk_reset       rx_adapter_${i}.reset
          add_connection phy_glue.rx_raw_data_${i}  rx_adapter_${i}.phy_rx_parallel_data

          set_interface_property phy_${i} EXPORT_OF rx_adapter_${i}.link_rx

          # instantiate the CDC fifo
          add_instance rx_fifo_${i} fifo
          set_instance_parameter_value rx_fifo_${i} GUI_CLOCKS_ARE_SYNCHRONIZED {0}
          set_instance_parameter_value rx_fifo_${i} GUI_Clock {4}
          set_instance_parameter_value rx_fifo_${i} GUI_DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT {1}
          set_instance_parameter_value rx_fifo_${i} GUI_Depth {32}
          set_instance_parameter_value rx_fifo_${i} GUI_Empty {1}
          set_instance_parameter_value rx_fifo_${i} GUI_Full {1}
          set_instance_parameter_value rx_fifo_${i} GUI_LegacyRREQ {1}
          set_instance_parameter_value rx_fifo_${i} GUI_MAX_DEPTH {Auto}
          set_instance_parameter_value rx_fifo_${i} GUI_RAM_BLOCK_TYPE {Auto}
          set_instance_parameter_value rx_fifo_${i} GUI_UsedW {1}
          set_instance_parameter_value rx_fifo_${i} GUI_Width {66}
          set_instance_parameter_value rx_fifo_${i} GUI_dc_aclr {1}
          set_instance_parameter_value rx_fifo_${i} GUI_delaypipe {5}
          set_instance_parameter_value rx_fifo_${i} GUI_diff_widths {0}
          set_instance_parameter_value rx_fifo_${i} GUI_output_width {8}
          set_instance_parameter_value rx_fifo_${i} GUI_read_aclr_synch {1}
          set_instance_parameter_value rx_fifo_${i} GUI_rsEmpty {1}
          set_instance_parameter_value rx_fifo_${i} GUI_synStage {3}
          set_instance_parameter_value rx_fifo_${i} GUI_write_aclr_synch {1}
          set_instance_parameter_value rx_fifo_${i} GUI_wsEmpty {0}
          set_instance_parameter_value rx_fifo_${i} GUI_wsFull {1}

          add_connection rx_fifo_${i}.fifo_input  rx_adapter_${i}.fifo_input
          add_connection rx_fifo_${i}.fifo_output rx_adapter_${i}.fifo_output
        }
      }
    }
  }
}
