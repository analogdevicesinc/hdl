
package require qsys

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

set_module_property NAME avl_adxphy
set_module_property DESCRIPTION "Avalon ADXPHY Core"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME avl_adxphy
set_module_property ELABORATION_CALLBACK p_avl_adxphy

# files

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL avl_adxphy
add_fileset_file avl_adxphy.v VERILOG PATH avl_adxphy.v TOP_LEVEL_FILE

# parameters

add_parameter TX_OR_RX_N INTEGER 0
set_parameter_property TX_OR_RX_N DISPLAY_NAME TX_OR_RX_N
set_parameter_property TX_OR_RX_N UNITS None
set_parameter_property TX_OR_RX_N HDL_PARAMETER false

add_parameter NUM_OF_LANES INTEGER 4
set_parameter_property NUM_OF_LANES DISPLAY_NAME NUM_OF_LANES
set_parameter_property NUM_OF_LANES UNITS None
set_parameter_property NUM_OF_LANES HDL_PARAMETER true

proc p_avl_adxphy {} {

  set m_tx_or_rx_n [get_parameter_value TX_OR_RX_N]
  set m_num_of_lanes [get_parameter_value NUM_OF_LANES]

  if {$m_tx_or_rx_n == 1} {

    ad_conduit tx_core_analogreset tx_analogreset tx_core_analogreset input $m_num_of_lanes
    ad_conduit tx_core_digitalreset tx_digitalreset tx_core_digitalreset input $m_num_of_lanes
    ad_conduit tx_core_cal_busy tx_cal_busy tx_core_cal_busy output $m_num_of_lanes

    ad_conduit tx_ip_cal_busy tx_cal_busy tx_ip_cal_busy output $m_num_of_lanes
    ad_conduit tx_ip_pcfifo_full export tx_ip_full output $m_num_of_lanes
    ad_conduit tx_ip_pcfifo_empty export tx_ip_empty output $m_num_of_lanes
    ad_conduit tx_ip_pcs_data export tx_ip_data input 32*$m_num_of_lanes
    ad_conduit tx_ip_pcs_kchar_data export tx_ip_kchar input 4*$m_num_of_lanes
    ad_conduit tx_ip_elecidle export tx_ip_elecidle input $m_num_of_lanes
    ad_conduit tx_ip_csr_lane_polarity export tx_ip_lane_polarity input $m_num_of_lanes
    ad_conduit tx_ip_csr_lane_powerdown export tx_ip_lane_powerdown input $m_num_of_lanes
    ad_conduit tx_ip_csr_bit_reversal export rx_ip_bit_reversal input 1
    ad_conduit tx_ip_csr_byte_reversal export rx_ip_byte_reversal input 1

    for {set n 0} {$n < $m_num_of_lanes} {incr n} {

      ad_conduit tx_phy${n}_cal_busy tx_cal_busy tx_phy_cal_busy_${n} input 1
      ad_conduit tx_phy${n}_pcfifo_full export tx_phy_full_${n} input 1
      ad_conduit tx_phy${n}_pcfifo_empty export tx_phy_empty_${n} input 1
      ad_conduit tx_phy${n}_pcs_data export tx_phy_data_${n} output 32
      ad_conduit tx_phy${n}_pcs_kchar_data export tx_phy_kchar_${n} output 4
      ad_conduit tx_phy${n}_elecidle export tx_phy_elecidle_${n} output 1
      ad_conduit tx_phy${n}_csr_lane_polarity export tx_phy_lane_polarity_${n} output 1
      ad_conduit tx_phy${n}_csr_lane_powerdown export tx_phy_lane_powerdown_${n} output 1
      ad_conduit tx_phy${n}_csr_bit_reversal export tx_phy_bit_reversal_${n} output 1
      ad_conduit tx_phy${n}_csr_byte_reversal export tx_phy_byte_reversal_${n} output 1
      ad_conduit tx_phy${n}_analogreset tx_analogreset tx_phy_analogreset_${n} output 1
      ad_conduit tx_phy${n}_digitalreset tx_digitalreset tx_phy_digitalreset_${n} output 1
    }
  }

  if {$m_tx_or_rx_n == 0} {

    ad_conduit rx_core_analogreset rx_analogreset rx_core_analogreset input $m_num_of_lanes
    ad_conduit rx_core_digitalreset rx_digitalreset rx_core_digitalreset input $m_num_of_lanes
    ad_conduit rx_core_is_lockedtodata rx_is_lockedtodata rx_core_locked output $m_num_of_lanes
    ad_conduit rx_core_cal_busy rx_cal_busy rx_core_cal_busy output $m_num_of_lanes

    ad_conduit rx_ip_is_lockedtodata rx_is_lockedtodata rx_ip_locked output $m_num_of_lanes
    ad_conduit rx_ip_cal_busy rx_cal_busy rx_ip_cal_busy output $m_num_of_lanes
    ad_conduit rx_ip_pcs_data_valid export rx_ip_valid output $m_num_of_lanes
    ad_conduit rx_ip_pcs_data export rx_ip_data output 32*$m_num_of_lanes
    ad_conduit rx_ip_pcs_disperr export rx_ip_disperr output 4*$m_num_of_lanes
    ad_conduit rx_ip_pcs_errdetect export rx_ip_deterr output 4*$m_num_of_lanes
    ad_conduit rx_ip_pcs_kchar_data export rx_ip_kchar output 4*$m_num_of_lanes
    ad_conduit rx_ip_pcfifo_full export rx_ip_full output $m_num_of_lanes
    ad_conduit rx_ip_pcfifo_empty export rx_ip_empty output $m_num_of_lanes
    ad_conduit rx_ip_patternalign_en export rx_ip_align_en input $m_num_of_lanes
    ad_conduit rx_ip_csr_lane_polarity export rx_ip_lane_polarity input $m_num_of_lanes
    ad_conduit rx_ip_csr_lane_powerdown export rx_ip_lane_powerdown input $m_num_of_lanes
    ad_conduit rx_ip_csr_bit_reversal export rx_ip_bit_reversal input 1
    ad_conduit rx_ip_csr_byte_reversal export rx_ip_byte_reversal input 1

    for {set n 0} {$n < $m_num_of_lanes} {incr n} {

      ad_conduit rx_phy${n}_is_lockedtodata rx_is_lockedtodata rx_phy_locked_${n} input 1
      ad_conduit rx_phy${n}_cal_busy rx_cal_busy rx_phy_cal_busy_${n} input 1
      ad_conduit rx_phy${n}_pcs_data_valid export rx_phy_valid_${n} input 1
      ad_conduit rx_phy${n}_pcs_data export rx_phy_data_${n} input 32
      ad_conduit rx_phy${n}_pcs_disperr export rx_phy_disperr_${n} input 4
      ad_conduit rx_phy${n}_pcs_errdetect export rx_phy_deterr_${n} input 4
      ad_conduit rx_phy${n}_pcs_kchar_data export rx_phy_kchar_${n} input 4
      ad_conduit rx_phy${n}_pcfifo_full export rx_phy_full_${n} input 1
      ad_conduit rx_phy${n}_pcfifo_empty export rx_phy_empty_${n} input 1
      ad_conduit rx_phy${n}_patternalign_en export rx_phy_align_en_${n} output 1
      ad_conduit rx_phy${n}_csr_lane_polarity export rx_phy_lane_polarity_${n} output 1
      ad_conduit rx_phy${n}_csr_lane_powerdown export rx_phy_lane_powerdown_${n} output 1
      ad_conduit rx_phy${n}_csr_bit_reversal export rx_phy_bit_reversal_${n} output 1
      ad_conduit rx_phy${n}_csr_byte_reversal export rx_phy_byte_reversal_${n} output 1
      ad_conduit rx_phy${n}_analogreset rx_analogreset rx_phy_analogreset_${n} output 1
      ad_conduit rx_phy${n}_digitalreset rx_digitalreset rx_phy_digitalreset_${n} output 1
    }
  }
}


