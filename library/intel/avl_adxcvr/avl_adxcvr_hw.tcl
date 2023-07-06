###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create avl_adxcvr {Avalon ADXCVR Core}
set_module_property COMPOSITION_CALLBACK p_avl_adxcvr

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter TX_OR_RX_N INTEGER 0 false
ad_ip_parameter ID INTEGER 0 false
ad_ip_parameter PCS_CONFIG STRING "JESD_PCS_CFG2" false
ad_ip_parameter LANE_RATE FLOAT 10000 false
ad_ip_parameter SYSCLK_FREQUENCY FLOAT 100.0 false
ad_ip_parameter REFCLK_FREQUENCY FLOAT 500.0 false
ad_ip_parameter NUM_OF_LANES INTEGER 4 false
ad_ip_parameter NUM_OF_CONVS INTEGER 2 false
ad_ip_parameter FRM_BCNT INTEGER 1 false
ad_ip_parameter FRM_SCNT INTEGER 1 false
ad_ip_parameter MF_FCNT INTEGER 32 false
ad_ip_parameter HD INTEGER 1 false
ad_ip_parameter TX_LANE_MAP STRING "" false

set_parameter_property LANE_RATE DISPLAY_UNITS "Mbps"
set_parameter_property SYSCLK_FREQUENCY UNITS Megahertz
set_parameter_property REFCLK_FREQUENCY UNITS Megahertz

proc p_avl_adxcvr {} {

  set m_id [get_parameter_value "ID"]
  set m_lane_rate [get_parameter_value "LANE_RATE"]
  set m_pcs_config [get_parameter_value "PCS_CONFIG"]
  set m_tx_or_rx_n [get_parameter_value "TX_OR_RX_N"]
  set m_num_of_lanes [get_parameter_value "NUM_OF_LANES"]
  set m_device_family [get_parameter_value "DEVICE_FAMILY"]
  set m_sysclk_frequency [get_parameter_value "SYSCLK_FREQUENCY"]
  set m_refclk_frequency [get_parameter_value "REFCLK_FREQUENCY"]
  set m_num_of_convs [get_parameter_value "NUM_OF_CONVS"]
  set m_frm_bcnt [get_parameter_value "FRM_BCNT"]
  set m_frm_scnt [get_parameter_value "FRM_SCNT"]
  set m_mf_fcnt [get_parameter_value "MF_FCNT"]
  set m_hd [get_parameter_value "HD"]
  set m_tx_lane_map [get_parameter_value "TX_LANE_MAP"]

  set m_pllclk_frequency [expr $m_lane_rate / 2]
  set m_coreclk_frequency [expr $m_lane_rate / 40]

  add_instance sys_clk clock_source
  set_instance_parameter_value sys_clk {clockFrequency} [expr $m_sysclk_frequency*1000000]
  add_interface sys_clk clock sink
  set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
  add_interface sys_resetn reset sink
  set_interface_property sys_resetn EXPORT_OF sys_clk.clk_in_reset

  add_instance xcvr_rst altera_reset_bridge
  add_connection sys_clk.clk xcvr_rst.clk
  add_interface rst reset sink
  set_interface_property rst EXPORT_OF xcvr_rst.in_reset

  add_instance ref_clk altera_clock_bridge
  set_instance_parameter_value ref_clk {EXPLICIT_CLOCK_RATE} [expr $m_refclk_frequency*1000000]
  add_interface ref_clk clock sink
  set_interface_property ref_clk EXPORT_OF ref_clk.in_clk

  add_instance fpll_rst_control altera_xcvr_reset_control
  set_instance_parameter_value fpll_rst_control {SYS_CLK_IN_MHZ} $m_sysclk_frequency
  set_instance_parameter_value fpll_rst_control {TX_PLL_ENABLE} {1}
  set_instance_parameter_value fpll_rst_control {T_PLL_POWERDOWN} {1000}
  set_instance_parameter_value fpll_rst_control {TX_ENABLE} {0}
  set_instance_parameter_value fpll_rst_control {RX_ENABLE} {0}
  add_connection sys_clk.clk fpll_rst_control.clock
  add_connection xcvr_rst.out_reset fpll_rst_control.reset
  add_connection sys_clk.clk_reset fpll_rst_control.reset

  add_instance core_pll altera_xcvr_fpll_a10
  set_instance_parameter_value core_pll {gui_fpll_mode} {0}
  set_instance_parameter_value core_pll {gui_reference_clock_frequency} $m_refclk_frequency
  set_instance_parameter_value core_pll {gui_number_of_output_clocks} 2
  set_instance_parameter_value core_pll {gui_enable_phase_alignment} 1
  set_instance_parameter_value core_pll {gui_desired_outclk0_frequency} $m_coreclk_frequency
  set m_pfdclk_frequency [get_instance_parameter_value core_pll gui_pfd_frequency]
  set_instance_parameter_value core_pll {gui_desired_outclk1_frequency} $m_pfdclk_frequency
  set_instance_parameter_value core_pll {enable_pll_reconfig} {1}
  set_instance_parameter_value core_pll {set_capability_reg_enable} {1}
  set_instance_parameter_value core_pll {set_csr_soft_logic_enable} {1}
  add_connection ref_clk.out_clk core_pll.pll_refclk0
  add_connection fpll_rst_control.pll_powerdown core_pll.pll_powerdown
  add_interface core_pll_locked conduit end
  set_interface_property core_pll_locked EXPORT_OF core_pll.pll_locked
  add_connection sys_clk.clk_reset core_pll.reconfig_reset0
  add_connection sys_clk.clk core_pll.reconfig_clk0
  add_interface core_pll_reconfig avalon slave
  set_interface_property core_pll_reconfig EXPORT_OF core_pll.reconfig_avmm0

  add_instance core_clk altera_clock_bridge
  set_instance_parameter_value core_clk {EXPLICIT_CLOCK_RATE} [expr $m_coreclk_frequency*1000000]
  add_connection core_pll.outclk0 core_clk.in_clk
  add_interface core_clk clock source
  set_interface_property core_clk EXPORT_OF core_clk.out_clk

  add_instance octet_swap avl_adxcvr_octet_swap
  set_instance_parameter_value octet_swap NUM_OF_LANES $m_num_of_lanes
  set_instance_parameter_value octet_swap TX_OR_RX_N m_tx_or_rx_n
  add_connection core_pll.outclk0 octet_swap.clock
  add_connection sys_clk.clk_reset octet_swap.reset

  if {$m_tx_or_rx_n == 1} {

    add_instance rst_control altera_xcvr_reset_control
    set_instance_parameter_value rst_control {CHANNELS} $m_num_of_lanes
    set_instance_parameter_value rst_control {SYS_CLK_IN_MHZ} $m_sysclk_frequency
    set_instance_parameter_value rst_control {TX_PLL_ENABLE} {1}
    set_instance_parameter_value rst_control {T_PLL_POWERDOWN} {1000}
    set_instance_parameter_value rst_control {TX_ENABLE} {1}
    set_instance_parameter_value rst_control {T_TX_ANALOGRESET} {70000}
    set_instance_parameter_value rst_control {T_TX_DIGITALRESET} {70000}
    set_instance_parameter_value rst_control {gui_pll_cal_busy} {1}
    set_instance_parameter_value rst_control {RX_ENABLE} {0}
    add_connection sys_clk.clk rst_control.clock
    add_connection xcvr_rst.out_reset rst_control.reset
    add_connection sys_clk.clk_reset rst_control.reset
    add_interface ready conduit end
    set_interface_property ready EXPORT_OF rst_control.tx_ready

    add_instance lane_pll altera_xcvr_atx_pll_a10
    set_instance_parameter_value lane_pll {enable_pll_reconfig} {1}
    set_instance_parameter_value lane_pll {rcfg_separate_avmm_busy} {1}
    set_instance_parameter_value lane_pll {set_capability_reg_enable} {1}
    set_instance_parameter_value lane_pll {set_user_identifier} $m_id
    set_instance_parameter_value lane_pll {set_csr_soft_logic_enable} {1}
    set_instance_parameter_value lane_pll {set_output_clock_frequency} $m_pllclk_frequency
    set_instance_parameter_value lane_pll {set_auto_reference_clock_frequency} $m_refclk_frequency
    add_connection rst_control.pll_powerdown lane_pll.pll_powerdown
    add_connection lane_pll.pll_locked rst_control.pll_locked
    add_connection lane_pll.pll_cal_busy rst_control.pll_cal_busy
    add_connection ref_clk.out_clk lane_pll.pll_refclk0
    add_connection sys_clk.clk lane_pll.reconfig_clk0
    add_connection sys_clk.clk_reset lane_pll.reconfig_reset0
    add_interface lane_pll_reconfig avalon slave
    set_interface_property lane_pll_reconfig EXPORT_OF lane_pll.reconfig_avmm0

    add_instance jesd204_ip altera_jesd204
    set_instance_parameter_value jesd204_ip {wrapper_opt} {base}
    set_instance_parameter_value jesd204_ip {DATA_PATH} {TX}
    set_instance_parameter_value jesd204_ip {lane_rate} $m_lane_rate
    set_instance_parameter_value jesd204_ip {L} $m_num_of_lanes
    set_instance_parameter_value jesd204_ip {M} $m_num_of_convs
    set_instance_parameter_value jesd204_ip {GUI_EN_CFG_F} {1}
    set_instance_parameter_value jesd204_ip {GUI_CFG_F} $m_frm_bcnt
    set_instance_parameter_value jesd204_ip {N} {16}
    set_instance_parameter_value jesd204_ip {N_PRIME} {16}
    set_instance_parameter_value jesd204_ip {S} $m_frm_scnt
    set_instance_parameter_value jesd204_ip {K} $m_mf_fcnt
    set_instance_parameter_value jesd204_ip {SCR} {1}
    set_instance_parameter_value jesd204_ip {HD} $m_hd
    add_connection core_pll.outclk0 jesd204_ip.txlink_clk
    add_connection sys_clk.clk_reset jesd204_ip.txlink_rst_n

    add_connection octet_swap.out jesd204_ip.jesd204_tx_link
    add_interface ip_data avalon_streaming sink
    set_interface_property ip_data EXPORT_OF octet_swap.in

    add_connection sys_clk.clk jesd204_ip.jesd204_tx_avs_clk
    add_connection sys_clk.clk_reset jesd204_ip.jesd204_tx_avs_rst_n
    add_interface ip_reconfig avalon slave
    set_interface_property ip_reconfig EXPORT_OF jesd204_ip.jesd204_tx_avs
    add_interface sysref conduit end
    set_interface_property sysref EXPORT_OF jesd204_ip.sysref
    add_interface sync conduit end
    set_interface_property sync EXPORT_OF jesd204_ip.sync_n
    add_connection jesd204_ip.dev_sync_n jesd204_ip.mdev_sync_n

    add_instance avl_xphy avl_adxphy
    set_instance_parameter_value avl_xphy {TX_OR_RX_N} {1}
    set_instance_parameter_value avl_xphy {NUM_OF_LANES} $m_num_of_lanes
    add_connection rst_control.tx_analogreset avl_xphy.tx_core_analogreset
    add_connection rst_control.tx_digitalreset avl_xphy.tx_core_digitalreset
    add_connection avl_xphy.tx_core_cal_busy rst_control.tx_cal_busy
    add_connection avl_xphy.tx_ip_cal_busy jesd204_ip.tx_cal_busy
    add_connection avl_xphy.tx_ip_pcfifo_full jesd204_ip.phy_csr_tx_pcfifo_full
    add_connection avl_xphy.tx_ip_pcfifo_empty jesd204_ip.phy_csr_tx_pcfifo_empty
    add_connection jesd204_ip.jesd204_tx_pcs_data avl_xphy.tx_ip_pcs_data
    add_connection jesd204_ip.jesd204_tx_pcs_kchar_data avl_xphy.tx_ip_pcs_kchar_data
    add_connection jesd204_ip.phy_tx_elecidle avl_xphy.tx_ip_elecidle
    add_connection jesd204_ip.csr_lane_polarity avl_xphy.tx_ip_csr_lane_polarity
    add_connection jesd204_ip.csr_lane_powerdown avl_xphy.tx_ip_csr_lane_powerdown
    add_connection jesd204_ip.csr_bit_reversal avl_xphy.tx_ip_csr_bit_reversal
    add_connection jesd204_ip.csr_byte_reversal avl_xphy.tx_ip_csr_byte_reversal

    set lane_map [regexp -all -inline {\S+} $m_tx_lane_map]

    for {set n 0} {$n < $m_num_of_lanes} {incr n} {

      add_instance phy_${n} altera_jesd204
      set_instance_parameter_value phy_${n} {wrapper_opt} {phy}
      set_instance_parameter_value phy_${n} {DATA_PATH} {TX}
      set_instance_parameter_value phy_${n} {lane_rate} $m_lane_rate
      set_instance_parameter_value phy_${n} {PCS_CONFIG} $m_pcs_config
      set_instance_parameter_value phy_${n} {bonded_mode} {non_bonded}
      set_instance_parameter_value phy_${n} {pll_reconfig_enable} {1}
      set_instance_parameter_value phy_${n} {set_capability_reg_enable} {1}
      set_instance_parameter_value phy_${n} {set_user_identifier} $m_id
      set_instance_parameter_value phy_${n} {set_csr_soft_logic_enable} {1}
      set_instance_parameter_value phy_${n} {L} 1
      add_connection core_pll.outclk0 phy_${n}.txlink_clk
      add_connection sys_clk.clk_reset phy_${n}.txlink_rst_n
      add_interface tx_data_${n} conduit end
      set_interface_property tx_data_${n} EXPORT_OF phy_${n}.tx_serial_data
      add_connection avl_xphy.tx_phy${n}_analogreset phy_${n}.tx_analogreset
      add_connection avl_xphy.tx_phy${n}_digitalreset phy_${n}.tx_digitalreset
      add_connection lane_pll.tx_serial_clk phy_${n}.tx_serial_clk0

      add_connection sys_clk.clk phy_${n}.reconfig_clk
      add_connection sys_clk.clk_reset phy_${n}.reconfig_reset
      add_interface phy_reconfig_${n} avalon slave
      set_interface_property phy_reconfig_${n} EXPORT_OF phy_${n}.reconfig_avmm

      if {$lane_map != {}} {
        set m [lindex $lane_map $n]
      } else {
        set m $n
      }

      add_connection phy_${n}.tx_cal_busy avl_xphy.tx_phy${m}_cal_busy
      add_connection phy_${n}.phy_csr_tx_pcfifo_full avl_xphy.tx_phy${m}_pcfifo_full
      add_connection phy_${n}.phy_csr_tx_pcfifo_empty avl_xphy.tx_phy${m}_pcfifo_empty
      add_connection avl_xphy.tx_phy${m}_pcs_data phy_${n}.jesd204_tx_pcs_data
      add_connection avl_xphy.tx_phy${m}_pcs_kchar_data phy_${n}.jesd204_tx_pcs_kchar_data
      add_connection avl_xphy.tx_phy${m}_elecidle phy_${n}.phy_tx_elecidle
      add_connection avl_xphy.tx_phy${m}_csr_lane_polarity phy_${n}.csr_lane_polarity
      add_connection avl_xphy.tx_phy${m}_csr_lane_powerdown phy_${n}.csr_lane_powerdown
      add_connection avl_xphy.tx_phy${m}_csr_bit_reversal phy_${n}.csr_bit_reversal
      add_connection avl_xphy.tx_phy${m}_csr_byte_reversal phy_${n}.csr_byte_reversal
    }
  }

  if {$m_tx_or_rx_n == 0} {

    add_instance rst_control altera_xcvr_reset_control
    set_instance_parameter_value rst_control {CHANNELS} $m_num_of_lanes
    set_instance_parameter_value rst_control {SYS_CLK_IN_MHZ} $m_sysclk_frequency
    set_instance_parameter_value rst_control {TX_PLL_ENABLE} {0}
    set_instance_parameter_value rst_control {TX_ENABLE} {0}
    set_instance_parameter_value rst_control {RX_ENABLE} {1}
    set_instance_parameter_value rst_control {T_RX_ANALOGRESET} {70000}
    set_instance_parameter_value rst_control {T_RX_DIGITALRESET} {4000}
    add_connection sys_clk.clk rst_control.clock
    add_connection xcvr_rst.out_reset rst_control.reset
    add_connection sys_clk.clk_reset rst_control.reset
    add_interface ready conduit end
    set_interface_property ready EXPORT_OF rst_control.rx_ready

    add_instance jesd204_ip altera_jesd204
    set_instance_parameter_value jesd204_ip {wrapper_opt} {base}
    set_instance_parameter_value jesd204_ip {DATA_PATH} {RX}
    set_instance_parameter_value jesd204_ip {lane_rate} $m_lane_rate
    set_instance_parameter_value jesd204_ip {L} $m_num_of_lanes
    set_instance_parameter_value jesd204_ip {M} $m_num_of_convs
    set_instance_parameter_value jesd204_ip {GUI_EN_CFG_F} {1}
    set_instance_parameter_value jesd204_ip {GUI_CFG_F} $m_frm_bcnt
    set_instance_parameter_value jesd204_ip {N} {16}
    set_instance_parameter_value jesd204_ip {N_PRIME} {16}
    set_instance_parameter_value jesd204_ip {S} $m_frm_scnt
    set_instance_parameter_value jesd204_ip {K} $m_mf_fcnt
    set_instance_parameter_value jesd204_ip {SCR} {1}
    set_instance_parameter_value jesd204_ip {HD} $m_hd
    add_connection core_pll.outclk0 jesd204_ip.rxlink_clk
    add_connection sys_clk.clk_reset jesd204_ip.rxlink_rst_n

    add_connection jesd204_ip.sof octet_swap.in_sof
    add_interface ip_sof conduit end
    set_interface_property ip_sof EXPORT_OF octet_swap.out_sof

    add_connection jesd204_ip.jesd204_rx_link octet_swap.in
    add_interface ip_data avalon_streaming source
    set_interface_property ip_data EXPORT_OF octet_swap.out

    add_connection sys_clk.clk jesd204_ip.jesd204_rx_avs_clk
    add_connection sys_clk.clk_reset jesd204_ip.jesd204_rx_avs_rst_n
    add_interface ip_reconfig avalon slave
    set_interface_property ip_reconfig EXPORT_OF jesd204_ip.jesd204_rx_avs
    add_interface sysref conduit end
    set_interface_property sysref EXPORT_OF jesd204_ip.sysref
    add_interface sync conduit end
    set_interface_property sync EXPORT_OF jesd204_ip.dev_sync_n
    add_connection jesd204_ip.dev_lane_aligned jesd204_ip.alldev_lane_aligned

    add_instance avl_xphy avl_adxphy
    set_instance_parameter_value avl_xphy {TX_OR_RX_N} {0}
    set_instance_parameter_value avl_xphy {NUM_OF_LANES} $m_num_of_lanes
    add_connection rst_control.rx_analogreset avl_xphy.rx_core_analogreset
    add_connection rst_control.rx_digitalreset avl_xphy.rx_core_digitalreset
    add_connection avl_xphy.rx_core_is_lockedtodata rst_control.rx_is_lockedtodata
    add_connection avl_xphy.rx_core_cal_busy rst_control.rx_cal_busy
    add_connection avl_xphy.rx_ip_is_lockedtodata jesd204_ip.rx_islockedtodata
    add_connection avl_xphy.rx_ip_cal_busy jesd204_ip.rx_cal_busy
    add_connection avl_xphy.rx_ip_pcs_data_valid jesd204_ip.jesd204_rx_pcs_data_valid
    add_connection avl_xphy.rx_ip_pcs_data jesd204_ip.jesd204_rx_pcs_data
    add_connection avl_xphy.rx_ip_pcs_disperr jesd204_ip.jesd204_rx_pcs_disperr
    add_connection avl_xphy.rx_ip_pcs_errdetect jesd204_ip.jesd204_rx_pcs_errdetect
    add_connection avl_xphy.rx_ip_pcs_kchar_data jesd204_ip.jesd204_rx_pcs_kchar_data
    add_connection avl_xphy.rx_ip_pcfifo_full jesd204_ip.phy_csr_rx_pcfifo_full
    add_connection avl_xphy.rx_ip_pcfifo_empty jesd204_ip.phy_csr_rx_pcfifo_empty
    add_connection avl_xphy.rx_ip_patternalign_en jesd204_ip.patternalign_en
    add_connection avl_xphy.rx_ip_csr_lane_polarity jesd204_ip.csr_lane_polarity
    add_connection avl_xphy.rx_ip_csr_lane_powerdown jesd204_ip.csr_lane_powerdown
    add_connection avl_xphy.rx_ip_csr_bit_reversal jesd204_ip.csr_bit_reversal
    add_connection avl_xphy.rx_ip_csr_byte_reversal jesd204_ip.csr_byte_reversal

    for {set n 0} {$n < $m_num_of_lanes} {incr n} {

      add_instance phy_${n} altera_jesd204
      set_instance_parameter_value phy_${n} {wrapper_opt} {phy}
      set_instance_parameter_value phy_${n} {DATA_PATH} {RX}
      set_instance_parameter_value phy_${n} {lane_rate} $m_lane_rate
      set_instance_parameter_value phy_${n} {PCS_CONFIG} $m_pcs_config
      set_instance_parameter_value phy_${n} {REFCLK_FREQ} $m_refclk_frequency
      set_instance_parameter_value phy_${n} {pll_reconfig_enable} {1}
      set_instance_parameter_value phy_${n} {set_capability_reg_enable} {1}
      set_instance_parameter_value phy_${n} {set_user_identifier} $m_id
      set_instance_parameter_value phy_${n} {set_csr_soft_logic_enable} {1}
      set_instance_parameter_value phy_${n} {L} 1

      add_connection sys_clk.clk phy_${n}.reconfig_clk
      add_connection sys_clk.clk_reset phy_${n}.reconfig_reset
      add_interface phy_reconfig_${n} avalon slave
      set_interface_property phy_reconfig_${n} EXPORT_OF phy_${n}.reconfig_avmm

      add_connection ref_clk.out_clk phy_${n}.pll_ref_clk
      add_connection core_pll.outclk0 phy_${n}.rxlink_clk
      add_connection sys_clk.clk_reset phy_${n}.rxlink_rst_n
      add_interface rx_data_${n} conduit end
      set_interface_property rx_data_${n} EXPORT_OF phy_${n}.rx_serial_data
      add_connection avl_xphy.rx_phy${n}_analogreset phy_${n}.rx_analogreset
      add_connection avl_xphy.rx_phy${n}_digitalreset phy_${n}.rx_digitalreset
      add_connection phy_${n}.rx_islockedtodata avl_xphy.rx_phy${n}_is_lockedtodata
      add_connection phy_${n}.rx_cal_busy avl_xphy.rx_phy${n}_cal_busy
      add_connection phy_${n}.jesd204_rx_pcs_data_valid avl_xphy.rx_phy${n}_pcs_data_valid
      add_connection phy_${n}.jesd204_rx_pcs_data avl_xphy.rx_phy${n}_pcs_data
      add_connection phy_${n}.jesd204_rx_pcs_disperr avl_xphy.rx_phy${n}_pcs_disperr
      add_connection phy_${n}.jesd204_rx_pcs_errdetect avl_xphy.rx_phy${n}_pcs_errdetect
      add_connection phy_${n}.jesd204_rx_pcs_kchar_data avl_xphy.rx_phy${n}_pcs_kchar_data
      add_connection phy_${n}.phy_csr_rx_pcfifo_full avl_xphy.rx_phy${n}_pcfifo_full
      add_connection phy_${n}.phy_csr_rx_pcfifo_empty avl_xphy.rx_phy${n}_pcfifo_empty
      add_connection avl_xphy.rx_phy${n}_patternalign_en phy_${n}.patternalign_en
      add_connection avl_xphy.rx_phy${n}_csr_lane_polarity phy_${n}.csr_lane_polarity
      add_connection avl_xphy.rx_phy${n}_csr_lane_powerdown phy_${n}.csr_lane_powerdown
      add_connection avl_xphy.rx_phy${n}_csr_bit_reversal phy_${n}.csr_bit_reversal
      add_connection avl_xphy.rx_phy${n}_csr_byte_reversal phy_${n}.csr_byte_reversal
    }
  }
}

