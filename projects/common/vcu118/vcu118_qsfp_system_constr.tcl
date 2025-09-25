###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc qsfp_constraints {qsfp_position qsfp_order} {
  switch $qsfp_order {
    "1" {
      # U145 QSFP+ Module QSFP1
      set_property -dict {PACKAGE_PIN Y2} [get_ports "qsfp_rx_p[$qsfp_position*4 + 0]"]
      set_property -dict {PACKAGE_PIN Y1} [get_ports "qsfp_rx_n[$qsfp_position*4 + 0]"]
      set_property -dict {PACKAGE_PIN V7} [get_ports "qsfp_tx_p[$qsfp_position*4 + 0]"]
      set_property -dict {PACKAGE_PIN V6} [get_ports "qsfp_tx_n[$qsfp_position*4 + 0]"]
      set_property -dict {PACKAGE_PIN W4} [get_ports "qsfp_rx_p[$qsfp_position*4 + 1]"]
      set_property -dict {PACKAGE_PIN W3} [get_ports "qsfp_rx_n[$qsfp_position*4 + 1]"]
      set_property -dict {PACKAGE_PIN T7} [get_ports "qsfp_tx_p[$qsfp_position*4 + 1]"]
      set_property -dict {PACKAGE_PIN T6} [get_ports "qsfp_tx_n[$qsfp_position*4 + 1]"]
      set_property -dict {PACKAGE_PIN V2} [get_ports "qsfp_rx_p[$qsfp_position*4 + 2]"]
      set_property -dict {PACKAGE_PIN V1} [get_ports "qsfp_rx_n[$qsfp_position*4 + 2]"]
      set_property -dict {PACKAGE_PIN P7} [get_ports "qsfp_tx_p[$qsfp_position*4 + 2]"]
      set_property -dict {PACKAGE_PIN P6} [get_ports "qsfp_tx_n[$qsfp_position*4 + 2]"]
      set_property -dict {PACKAGE_PIN U4} [get_ports "qsfp_rx_p[$qsfp_position*4 + 3]"]
      set_property -dict {PACKAGE_PIN U3} [get_ports "qsfp_rx_n[$qsfp_position*4 + 3]"]
      set_property -dict {PACKAGE_PIN M7} [get_ports "qsfp_tx_p[$qsfp_position*4 + 3]"]
      set_property -dict {PACKAGE_PIN M6} [get_ports "qsfp_tx_n[$qsfp_position*4 + 3]"]

      set_property -dict {PACKAGE_PIN AN23 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_modsell[$qsfp_position]]
      set_property -dict {PACKAGE_PIN AY22 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_resetl[$qsfp_position]]
      set_property -dict {PACKAGE_PIN AT24 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_lpmode[$qsfp_position]]
      set_property -dict {PACKAGE_PIN AN24 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports qsfp_modprsl[$qsfp_position]]
      set_property -dict {PACKAGE_PIN AT21 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports qsfp_intl[$qsfp_position]]

      set_property LOC CMACE4_X0Y7 [get_cells -hierarchical -filter {NAME =~ */qsfp[$qsfp_position].qsfp_cmac_inst/cmac_inst/inst/i_cmac_usplus_top/* && REF_NAME==CMACE4}]
    }
    "2" {
      # U145 QSFP+ Module QSFP2
      set_property -dict {PACKAGE_PIN T2} [get_ports "qsfp_rx_p[$qsfp_position*4 + 0]"]
      set_property -dict {PACKAGE_PIN T1} [get_ports "qsfp_rx_n[$qsfp_position*4 + 0]"]
      set_property -dict {PACKAGE_PIN L5} [get_ports "qsfp_tx_p[$qsfp_position*4 + 0]"]
      set_property -dict {PACKAGE_PIN L4} [get_ports "qsfp_tx_n[$qsfp_position*4 + 0]"]
      set_property -dict {PACKAGE_PIN R4} [get_ports "qsfp_rx_p[$qsfp_position*4 + 1]"]
      set_property -dict {PACKAGE_PIN R3} [get_ports "qsfp_rx_n[$qsfp_position*4 + 1]"]
      set_property -dict {PACKAGE_PIN K7} [get_ports "qsfp_tx_p[$qsfp_position*4 + 1]"]
      set_property -dict {PACKAGE_PIN K6} [get_ports "qsfp_tx_n[$qsfp_position*4 + 1]"]
      set_property -dict {PACKAGE_PIN P2} [get_ports "qsfp_rx_p[$qsfp_position*4 + 2]"]
      set_property -dict {PACKAGE_PIN P1} [get_ports "qsfp_rx_n[$qsfp_position*4 + 2]"]
      set_property -dict {PACKAGE_PIN J5} [get_ports "qsfp_tx_p[$qsfp_position*4 + 2]"]
      set_property -dict {PACKAGE_PIN J4} [get_ports "qsfp_tx_n[$qsfp_position*4 + 2]"]
      set_property -dict {PACKAGE_PIN M2} [get_ports "qsfp_rx_p[$qsfp_position*4 + 3]"]
      set_property -dict {PACKAGE_PIN M1} [get_ports "qsfp_rx_n[$qsfp_position*4 + 3]"]
      set_property -dict {PACKAGE_PIN H7} [get_ports "qsfp_tx_p[$qsfp_position*4 + 3]"]
      set_property -dict {PACKAGE_PIN H6} [get_ports "qsfp_tx_n[$qsfp_position*4 + 3]"]

      set_property -dict {PACKAGE_PIN AM21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_modsell[$qsfp_position]]
      set_property -dict {PACKAGE_PIN BA22 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_resetl[$qsfp_position]]
      set_property -dict {PACKAGE_PIN AN21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_lpmode[$qsfp_position]]
      set_property -dict {PACKAGE_PIN AL21 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports qsfp_modprsl[$qsfp_position]]
      set_property -dict {PACKAGE_PIN AP21 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports qsfp_intl[$qsfp_position]]

      set_property LOC CMACE4_X0Y8 [get_cells -hierarchical -filter {NAME =~ */qsfp[$qsfp_position].qsfp_cmac_inst/cmac_inst/inst/i_cmac_usplus_top/* && REF_NAME==CMACE4}]
    }
  }

  set_false_path -to [get_ports {qsfp_modsell[$qsfp_position] qsfp_resetl[$qsfp_position] qsfp_lpmode[$qsfp_position]}]
  set_output_delay 0.000 [get_ports {qsfp_modsell[$qsfp_position] qsfp_resetl[$qsfp_position] qsfp_lpmode[$qsfp_position]}]
  set_false_path -from [get_ports {qsfp_modprsl[$qsfp_position] qsfp_intl[$qsfp_position]}]
  set_input_delay 0.000 [get_ports {qsfp_modprsl[$qsfp_position] qsfp_intl[$qsfp_position]}]
}

if {[info exists ::env(CORUNDUM)]} {
  if {[info exists ::env(QSFP_CNT)]} {
    set QSFP_CNT $::env(QSFP_CNT)
    if {$QSFP_CNT > 2} {
      error "VCU118 has only 2 QSFP ports available!"
    }
  } else {
    set QSFP_CNT 1
  }

  if {[info exists ::env(QSFP_ORDER)]} {
    set QSFP_ORDER $::env(QSFP_ORDER)
  } else {
    set QSFP_ORDER "1"
  }

  set qsfp_order_list [split $QSFP_ORDER ""]

  if {[llength $qsfp_order_list] != $QSFP_CNT} {
    error "QSFP_ORDER \"$qsfp_order_list\" doesn't contain the same QSFP_CNT $QSFP_CNT number of elements!"
  }

  # check for duplicate elements and their validity in the order list
  set counts {}
  set reggular_expression "\[^0-9\]"
  foreach qsfp_order $qsfp_order_list {
    if {[regexp $reggular_expression $qsfp_order]} {
      error "QSFP_ORDER \"$qsfp_order_list\" can only contain numbers!"
    }

    dict incr counts $qsfp_order
  }
  foreach {qsfp_order count} $counts {
    if {$count > 1} {
      error "The QSFP order cannot contain duplicate elements!"
    }
  }

  # QSFP constraints
  for {set i 0} {$i < $QSFP_CNT} {incr i} {
    set qsfp_order [lindex $qsfp_order_list $i]

    qsfp_constraints $i $qsfp_order
  }

  # REF clock
  set_property -dict {PACKAGE_PIN W9} [get_ports qsfp_mgt_refclk_p]
  set_property -dict {PACKAGE_PIN W8} [get_ports qsfp_mgt_refclk_n]

  # 156.25 MHz MGT reference clock
  create_clock -period 6.400 -name qsfp_mgt_refclk [get_ports qsfp_mgt_refclk_p]

  # QSPI flash
  set_property -dict {PACKAGE_PIN AM19 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[0]}]
  set_property -dict {PACKAGE_PIN AM18 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[1]}]
  set_property -dict {PACKAGE_PIN AN20 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[2]}]
  set_property -dict {PACKAGE_PIN AP20 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[3]}]
  set_property -dict {PACKAGE_PIN BF16 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports qspi1_cs]

  set_false_path -to [get_ports {{qspi1_dq[*]} qspi1_cs}]
  set_output_delay 0.000 [get_ports {{qspi1_dq[*]} qspi1_cs}]
  set_false_path -from [get_ports qspi1_dq]
  set_input_delay 0.000 [get_ports qspi1_dq]
}
