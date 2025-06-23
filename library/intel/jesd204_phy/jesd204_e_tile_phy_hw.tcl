###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204_e_tile_phy "ADI JESD204 E-Tile PHY"
set_module_property COMPOSITION_CALLBACK jesd204_e_tile_phy_composition_callback
set_module_property INTERNAL false

# parameters

ad_ip_parameter DEVICE STRING "Agilex 5" false
ad_ip_parameter ID NATURAL 0 false
ad_ip_parameter LINK_MODE INTEGER 1 false
ad_ip_parameter LANE_RATE FLOAT 10000 false
ad_ip_parameter REFCLK_FREQUENCY FLOAT 500.0 false
ad_ip_parameter NUM_OF_LANES POSITIVE 4 false
ad_ip_parameter INPUT_PIPELINE_STAGES INTEGER 0 false
ad_ip_parameter LANE_INVERT INTEGER 0 false
ad_ip_parameter EXTERNAL_LINK_CLK BOOLEAN false false

proc jesd204_e_tile_phy_composition_callback {} {
  set device [get_parameter_value "DEVICE"]
  set link_mode [get_parameter_value "LINK_MODE"]
  set lane_rate [get_parameter_value "LANE_RATE"]
  set refclk_frequency [get_parameter_value "REFCLK_FREQUENCY"]
  set id [get_parameter_value "ID"]
  set num_of_lanes [get_parameter_value "NUM_OF_LANES"]
  set register_inputs [get_parameter_value "INPUT_PIPELINE_STAGES"]
  set lane_invert [get_parameter_value "LANE_INVERT"]
  set external_link_clk [get_parameter_value "EXTERNAL_LINK_CLK"]

  if {$device != "Agilex 5"} {
    send_message error "Only Agilex 5 is supported."
  }

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

  add_instance tx_link_clock clock_source
  set_instance_parameter_value tx_link_clock {clockFrequency} [expr $link_clk_frequency*1000000]
  add_interface tx_link_clock clock sink
  set_interface_property tx_link_clock EXPORT_OF tx_link_clock.clk_in
  add_interface tx_link_reset reset sink
  set_interface_property tx_link_reset EXPORT_OF tx_link_clock.clk_in_reset

  add_instance rx_link_clock clock_source
  set_instance_parameter_value rx_link_clock {clockFrequency} [expr $link_clk_frequency*1000000]
  add_interface rx_link_clock clock sink
  set_interface_property rx_link_clock EXPORT_OF rx_link_clock.clk_in
  add_interface rx_link_reset reset sink
  set_interface_property rx_link_reset EXPORT_OF rx_link_clock.clk_in_reset

  # Instantiate native PHY in duplex mode because
  # Agilex 5 can't merge transceivers in dual simplex mode
  # unless you use an "approved" intel protocol IP
  add_instance native_phy intel_directphy_gts
  set_instance_parameter_value native_phy duplex_mode {duplex}
  set_instance_parameter_value native_phy xcvr_type "FGT"
  set_instance_parameter_value native_phy num_xcvr_per_sys $num_of_lanes
  set_instance_parameter_value native_phy clocking_mode "xcvr"
  set_instance_parameter_value native_phy pma_modulation "NRZ"
  set_instance_parameter_value native_phy pma_data_rate $lane_rate
  set_instance_parameter_value native_phy pma_width $pma_width
  set_instance_parameter_value native_phy l_av1_enable 1

  # TX side parameters
  set_instance_parameter_value native_phy tx_pll_refclk_freq_mhz [format {%.6f} $refclk_frequency]
  set_instance_parameter_value native_phy pmaif_tx_fifo_mode_s "register"
  set_instance_parameter_value native_phy pldif_tx_double_width_transfer_enable 1
  set_instance_parameter_value native_phy pldif_tx_fifo_mode "phase_comp"
  set_instance_parameter_value native_phy pldif_tile_tx_fifo_mode "phase_comp"
  set_instance_parameter_value native_phy pldif_tx_fifo_pfull_thld 10
  set_instance_parameter_value native_phy tx_pll_txuserclk1_enable 1
  set_instance_parameter_value native_phy tx_pll_txuserclk_div $usr_pll_div
  set_instance_parameter_value native_phy enable_port_tx_clkout2 1
  set_instance_parameter_value native_phy pldif_tx_clkout_sel "TX_USER_CLK1"
  set_instance_parameter_value native_phy pldif_tx_clkout_div 1
  set_instance_parameter_value native_phy pldif_tx_clkout2_sel "TX_WORD_CLK"
  set_instance_parameter_value native_phy pldif_tx_clkout2_div 2
  set_instance_parameter_value native_phy rx_deskew_en 0

  # RX side parameters
  set_instance_parameter_value native_phy rx_pll_refclk_freq_mhz [format {%.6f} $refclk_frequency]
  set_instance_parameter_value native_phy pmaif_rx_fifo_mode_s "register"
  set_instance_parameter_value native_phy pldif_rx_double_width_transfer_enable 1
  set_instance_parameter_value native_phy rx_cdr_rxuserclk_enable 1
  set_instance_parameter_value native_phy rx_cdr_rxuserclk_div $usr_pll_div
  set_instance_parameter_value native_phy pldif_rx_fifo_pfull_thld 10
  set_instance_parameter_value native_phy enable_port_rx_clkout2 1
  set_instance_parameter_value native_phy pldif_rx_clkout_sel "RX_USER_CLK1"
  set_instance_parameter_value native_phy pldif_rx_clkout_div 1
  set_instance_parameter_value native_phy pldif_rx_clkout2_sel "RX_WORD_CLK"
  set_instance_parameter_value native_phy pldif_rx_clkout2_div 2
  set_instance_parameter_value native_phy rx_serdes_adapt_mode {auto}

  # GTS Reset IP
  add_instance gts_reset_phy intel_srcss_gts
  set_instance_parameter_value gts_reset_phy NUM_BANKS_SHORELINE [expr int(ceil($num_of_lanes / 4.0))]
  set_instance_parameter_value gts_reset_phy NUM_LANES_SHORELINE $num_of_lanes

  add_connection gts_reset_phy.o_pma_cu_clk native_phy.i_pma_cu_clk
  add_connection gts_reset_phy.o_src_rs_grant native_phy.i_src_rs_grant
  add_connection native_phy.o_src_rs_req gts_reset_phy.i_src_rs_req
  add_connection native_phy.o_refclk_bus_out gts_reset_phy.i_refclk_bus_out

  add_interface gts_reset_src_rs_priority conduit end
  set_interface_property gts_reset_src_rs_priority EXPORT_OF gts_reset_phy.i_src_rs_priority

  # Instantiate PHY glues (RX and TX)
  add_instance phy_glue jesd204_phy_glue
  set_instance_parameter_value phy_glue DEVICE $device
  set_instance_parameter_value phy_glue SOFT_PCS 1
  set_instance_parameter_value phy_glue NUM_OF_LANES $num_of_lanes
  set_instance_parameter_value phy_glue LANE_INVERT $lane_invert
  set_instance_parameter_value phy_glue BONDING_CLOCKS_EN 0
  set_instance_parameter_value phy_glue LINK_MODE $link_mode

  # Connect PHY to GLUE
  add_interface rx_ref_clk clock sink
  set_interface_property rx_ref_clk EXPORT_OF phy_glue.rx_ref_clk

  add_interface tx_ref_clk clock sink
  set_interface_property tx_ref_clk EXPORT_OF phy_glue.tx_ref_clk

  add_interface tx_reset conduit end
  set_interface_property tx_reset EXPORT_OF native_phy.i_tx_reset
  add_interface rx_reset conduit end
  set_interface_property rx_reset EXPORT_OF native_phy.i_rx_reset
  foreach x {reset_ack ready} {
    add_interface tx_${x} conduit end
    set_interface_property tx_${x} EXPORT_OF native_phy.o_tx_${x}
    add_interface rx_${x} conduit end
    set_interface_property rx_${x} EXPORT_OF native_phy.o_rx_${x}
  }

  add_interface tx_pll_locked conduit end
  set_interface_property tx_pll_locked EXPORT_OF native_phy.o_tx_pll_locked

  add_interface rx_is_lockedtodata conduit end
  set_interface_property rx_is_lockedtodata EXPORT_OF native_phy.o_rx_is_lockedtodata

  foreach x {serial_data serial_data_n} {
    add_interface tx_${x} conduit end
    set_interface_property tx_${x} EXPORT_OF native_phy.o_tx_${x}
    add_interface rx_${x} conduit end
    set_interface_property rx_${x} EXPORT_OF native_phy.i_rx_${x}
  }

  if {$link_mode == 2} {
    # lane rate / 64
    add_connection phy_glue.tx_clkout2_0 phy_glue.tx_coreclkin
    add_connection phy_glue.rx_clkout2_0 phy_glue.rx_coreclkin
  } else {
    # device_clk (lane rate / 40)
    add_connection tx_link_clock.clk phy_glue.tx_coreclkin
    add_connection rx_link_clock.clk phy_glue.rx_coreclkin
  }

  add_connection phy_glue.phy_tx_coreclkin native_phy.i_tx_coreclkin
  add_connection phy_glue.phy_rx_coreclkin native_phy.i_rx_coreclkin

  # Reconfig interface
  add_connection phy_glue.phy_reconfig_clk native_phy.i_reconfig_clk
  add_connection phy_glue.phy_reconfig_reset native_phy.i_reconfig_reset
  add_connection phy_glue.phy_reconfig_avmm native_phy.reconfig

  add_interface reconfig_clk clock sink
  set_interface_property reconfig_clk EXPORT_OF phy_glue.reconfig_clk

  add_interface reconfig_reset reset sink
  set_interface_property reconfig_reset EXPORT_OF phy_glue.reconfig_reset

  add_interface reconfig_avmm avalon slave
  set_interface_property reconfig_avmm EXPORT_OF phy_glue.reconfig_avmm

  # connect ref clock and output clock from - to GLUE
  add_connection phy_glue.phy_tx_ref_clk native_phy.i_tx_pll_refclk_p
  add_connection phy_glue.phy_rx_ref_clk native_phy.i_rx_cdr_refclk_p

  foreach x [list clkout2 clkout] {
    add_connection phy_glue.phy_tx_${x} native_phy.o_tx_${x}
    add_connection phy_glue.phy_rx_${x} native_phy.o_rx_${x}
  }

  # This is lane rate / 40 (jesd204b) or lane rate / 64 (jesd204c)
  add_interface tx_clkout2 clock source
  set_interface_property tx_clkout2 EXPORT_OF phy_glue.tx_clkout2_0
  add_interface rx_clkout2 clock source
  set_interface_property rx_clkout2 EXPORT_OF phy_glue.rx_clkout2_0

  # This is lane rate / 40 (jesd204b) or lane rate / 66 (jesd204c)
  add_interface tx_clkout clock source
  set_interface_property tx_clkout EXPORT_OF phy_glue.tx_clkout_0
  add_interface rx_clkout clock source
  set_interface_property rx_clkout EXPORT_OF phy_glue.rx_clkout_0

  add_connection phy_glue.phy_i_tx_parallel_data native_phy.i_tx_parallel_data
  add_connection phy_glue.phy_o_rx_parallel_data native_phy.o_rx_parallel_data

  # Connect GLUE with PCS
  for {set i 0} {$i < $num_of_lanes} {incr i} {
    add_interface phy_tx_${i} conduit end
    add_interface phy_rx_${i} conduit end
    if {$link_mode == 1} {
      # JESD204B
      # TX
      add_instance soft_pcs_tx_${i} jesd204_soft_pcs_tx
      set_instance_parameter_value soft_pcs_tx_${i} IFC_TYPE 1
      set_instance_parameter_value soft_pcs_tx_${i} INVERT_OUTPUTS \
        [expr ($lane_invert >> $i) & 1]
      add_connection tx_link_clock.clk soft_pcs_tx_${i}.clock
      add_connection tx_link_clock.clk_reset soft_pcs_tx_${i}.reset
      add_connection phy_glue.tx_raw_data_${i} soft_pcs_tx_${i}.tx_raw_data

      set_interface_property phy_tx_${i} EXPORT_OF soft_pcs_tx_${i}.tx_phy

      # RX
      add_instance soft_pcs_rx_${i} jesd204_soft_pcs_rx
      set_instance_parameter_value soft_pcs_rx_${i} IFC_TYPE 1
      set_instance_parameter_value soft_pcs_rx_${i} REGISTER_INPUTS $register_inputs
      set_instance_parameter_value soft_pcs_rx_${i} INVERT_INPUTS \
        [expr ($lane_invert >> $i) & 1]
      add_connection rx_link_clock.clk soft_pcs_rx_${i}.clock
      add_connection rx_link_clock.clk_reset soft_pcs_rx_${i}.reset
      add_connection phy_glue.rx_raw_data_${i} soft_pcs_rx_${i}.rx_raw_data

      set_interface_property phy_rx_${i} EXPORT_OF soft_pcs_rx_${i}.rx_phy
    } else {
      # JESD204C
      # TX
      add_instance tx_adapter_${i} jesd204_f_tile_adapter_tx
      set_instance_parameter_value tx_adapter_${i} DEVICE {Agilex 5}

      add_connection phy_glue.tx_clkout2_0     tx_adapter_${i}.phy_tx_clock
      add_connection tx_link_clock.clk         tx_adapter_${i}.link_clock
      add_connection tx_link_clock.clk_reset   tx_adapter_${i}.reset
      add_connection phy_glue.tx_raw_data_${i} tx_adapter_${i}.phy_tx_parallel_data

      set_interface_property phy_tx_${i} EXPORT_OF tx_adapter_${i}.link_tx

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

      # RX
      add_instance rx_adapter_${i} jesd204_f_tile_adapter_rx
      set_instance_parameter_value rx_adapter_${i} DEVICE {Agilex 5}

      add_connection phy_glue.rx_clkout2_0      rx_adapter_${i}.phy_rx_clock
      add_connection rx_link_clock.clk          rx_adapter_${i}.link_clock
      add_connection rx_link_clock.clk_reset    rx_adapter_${i}.reset
      add_connection phy_glue.rx_raw_data_${i}  rx_adapter_${i}.phy_rx_parallel_data

      set_interface_property phy_rx_${i} EXPORT_OF rx_adapter_${i}.link_rx

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
