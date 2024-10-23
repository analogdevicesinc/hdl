###############################################################################
## Copyright (C) 2016-2022, 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

#
# For whatever strange reason all the interface of the native PHY become
# conduits when it is instantiated in a compose callback. This glue logic module
# converts the interfaces to their proper type.
#

ad_ip_create jesd204_phy_glue {Native PHY to JESD204 glue logic} \
 jesd204_phy_glue_elab
set_module_property INTERNAL true

# files

ad_ip_files jesd204_phy_glue [list \
  jesd204_phy_glue.v \
]

# parameters

ad_ip_parameter DEVICE STRING "" false
ad_ip_parameter TX_OR_RX_N BOOLEAN false false
ad_ip_parameter SOFT_PCS BOOLEAN false false
ad_ip_parameter BONDING_CLOCKS_EN BOOLEAN false false
ad_ip_parameter NUM_OF_LANES POSITIVE 4 true
ad_ip_parameter LINK_MODE POSITIVE 1 false
ad_ip_parameter LANE_INVERT INTEGER 0 true
ad_ip_parameter WIDTH NATURAL 20 true { \
  DERIVED true \
}
ad_ip_parameter CONST_WIDTH NATURAL 1 true { \
  DERIVED true \
}

proc glue_add_if {num name type dir {bcast false}} {
  if {$bcast} {
    add_interface ${name} $type $dir
  } else {
    for {set i 0} {$i < $num} {incr i} {
      add_interface ${name}_${i} $type $dir
    }
  }
  add_interface phy_${name} conduit end
}

proc glue_add_if_port {num ifname port role dir width {bcast false} {phy_role {}}} {
  variable sig_offset

  set phy_width [expr $num * $width]
  if {$dir == "Input"} {
    set sig "in"
    set phy_dir "Output"
    set phy_sig "out"
  } else {
    set sig "out"
    set phy_dir "Input"
    set phy_sig "in"
  }

  if {$bcast} {
    add_interface_port ${ifname} ${port} $role $dir $width
    set_port_property ${port} fragment_list \
      [format "%s(%d:%d)" $sig [expr $sig_offset + $width - 1] $sig_offset]
  } else {
    for {set i 0} {$i < $num} {incr i} {
      set base [expr $sig_offset + $width * $i]

      add_interface_port ${ifname}_${i} ${port}_${i} $role $dir $width
      set_port_property ${port}_${i} fragment_list \
        [format "%s(%d:%d)" $sig [expr $base + $width - 1] $base]
    }
  }

  set device [get_parameter DEVICE]
  if {[string equal $device "Agilex 7"]} {
    if {$phy_role == {}} {
      set phy_role $port
    }
    add_interface_port phy_${ifname} phy_${port} $phy_role $phy_dir $phy_width
  } else {
    add_interface_port phy_${ifname} phy_${port} $role $phy_dir $phy_width
  }

  if {$bcast} {
    set _frag [format "%s(%d:%d)" $phy_sig [expr $sig_offset + $width - 1] $sig_offset]
    set sig_offset [expr $sig_offset + $width]
    set frag "${_frag}"
    for {set i 1} {$i < $num} {incr i} {
      set frag [concat ${frag} ${_frag}]
    }
  } else {
    set frag [format "%s(%d:%d)" $phy_sig [expr $sig_offset + $phy_width - 1] $sig_offset]
    set sig_offset [expr $sig_offset + $phy_width]
  }

  set_port_property phy_${port} fragment_list $frag
}

proc glue_add_tx_serial_clk {num_of_lanes} {
  variable sig_offset

  # The serial clock is special. The first 6 transceivers use the x1 connection
  # since they are in the same bank as the PLL. The others have to use the xN
  # connection through the CGB.

  if {$num_of_lanes > 6} {
    set clk0_width 6
    set clk1_width [expr $num_of_lanes - 6]

  } else {
    set clk0_width $num_of_lanes
    set clk1_width 0
  }

  add_interface tx_serial_clk_x1 hssi_serial_clock sink
  add_interface_port tx_serial_clk_x1 tx_serial_clk_x1 clk Input 1
  set_port_property tx_serial_clk_x1 fragment_list \
    [format "in(%d:%d)" $sig_offset $sig_offset]

  add_interface phy_tx_serial_clk0 conduit end
  add_interface_port phy_tx_serial_clk0 phy_tx_serial_clk0 clk Output $num_of_lanes

  set _frag [format "out(%d:%d)" $sig_offset $sig_offset]
  set sig_offset [expr $sig_offset + 1]
  set frag "${_frag}"
  for {set i 1} {$i < $clk0_width} {incr i} {
    set frag [concat ${_frag} ${frag}]
  }

  if {$num_of_lanes > 6} {
    add_interface tx_serial_clk_xN hssi_serial_clock sink
    add_interface_port tx_serial_clk_xN tx_serial_clk_xN clk Input 1
    set_port_property tx_serial_clk_xN fragment_list \
      [format "in(%d:%d)" $sig_offset $sig_offset]

    set _frag [format "out(%d:%d)" $sig_offset $sig_offset]
    set sig_offset [expr $sig_offset + 1]
    for {set i 0} {$i < $clk1_width} {incr i} {
      set frag [concat ${_frag} ${frag}]
    }
  }

  set_port_property phy_tx_serial_clk0 fragment_list $frag
}

proc glue_add_if_port_conduit {num ifname port phy_port dir width} {
  variable sig_offset

  set phy_width [expr $num * $width]
  if {$dir == "Input"} {
    set sig "in"
    set phy_dir "Output"
    set phy_sig "out"
  } else {
    set sig "out"
    set phy_dir "Input"
    set phy_sig "in"
  }

  for {set i 0} {$i < $num} {incr i} {
    set base [expr $sig_offset + $width * $i]

    add_interface_port ${ifname}_${i} ${ifname}_${port}_${i} $port $dir $width
    set_port_property ${ifname}_${port}_${i} fragment_list \
      [format "%s(%d:%d)" $sig [expr $base + $width - 1] $base]
  }

  add_interface phy_${phy_port} conduit end
  add_interface_port phy_${phy_port} phy_${phy_port} $phy_port $phy_dir $phy_width

  set_port_property phy_${phy_port} fragment_list \
    [format "%s(%d:%d)" $phy_sig [expr $sig_offset + $phy_width - 1] $sig_offset]

  set sig_offset [expr $sig_offset + $phy_width]
}

proc glue_add_const_conduit {port width} {
  variable const_offset

  set ifname phy_${port}
  add_interface $ifname conduit end
  add_interface_port $ifname $ifname $port Output $width
  set_port_property $ifname fragment_list [format "const_out(%d:%d)" \
    [expr $const_offset + $width - 1] $const_offset]

  set const_offset [expr $const_offset + $width]
}

proc jesd204_phy_glue_elab {} {
  variable sig_offset
  variable const_offset

  set device [get_parameter DEVICE]
  set soft_pcs [get_parameter SOFT_PCS]
  set num_of_lanes [get_parameter NUM_OF_LANES]
  set bonding_clocks_en [get_parameter BONDING_CLOCKS_EN]
  set link_mode [get_parameter LINK_MODE]

  set sig_offset 0
  set const_offset 0

  set parallel_data_w 40

  if {[string equal $device "Arria 10"]} {
    set reconfig_avmm_address_width 10
    set unused_width_per_lane 88
  } elseif {[string equal $device "Stratix 10"]} {
    set reconfig_avmm_address_width 11
    set unused_width_per_lane 40
  } elseif {[string equal $device "Agilex 7"]} {
    set parallel_data_w 80
    set reconfig_avmm_address_width [expr 18 + int(ceil((log($num_of_lanes) / log(2))))]
    # Unused are unused here
    set unused_width_per_lane 88
  } else {
    send_message error "Only Arria 10/Stratix 10/Agilex 7 are supported."
  }

  if {[string equal $device "Agilex 7"]} {
    glue_add_if 1 reconfig_clk clock sink true
    glue_add_if_port 1 reconfig_clk reconfig_clk clk Input 1 true clk

    glue_add_if 1 reconfig_reset reset sink true
    glue_add_if_port 1 reconfig_reset reconfig_reset reset Input 1 true reset

    glue_add_if 1 reconfig_avmm avalon sink true
    set_interface_property reconfig_avmm associatedClock reconfig_clk
    set_interface_property reconfig_avmm associatedReset reconfig_reset

    glue_add_if_port 1 reconfig_avmm reconfig_address address Input $reconfig_avmm_address_width true address
    glue_add_if_port 1 reconfig_avmm reconfig_read read Input 1 true read
    glue_add_if_port 1 reconfig_avmm reconfig_readdata readdata Output 32 true readdata
    glue_add_if_port 1 reconfig_avmm reconfig_waitrequest waitrequest Output 1 true waitrequest
    glue_add_if_port 1 reconfig_avmm reconfig_write write Input 1 true write
    glue_add_if_port 1 reconfig_avmm reconfig_writedata writedata Input 32 true writedata
    glue_add_if_port 1 reconfig_avmm reconfig_byteenable byteenable Input 4 true byteenable

  } else {

    glue_add_if $num_of_lanes reconfig_clk clock sink true
    glue_add_if_port $num_of_lanes reconfig_clk reconfig_clk clk Input 1 true

    glue_add_if $num_of_lanes reconfig_reset reset sink true
    glue_add_if_port $num_of_lanes reconfig_reset reconfig_reset reset Input 1 true

    glue_add_if $num_of_lanes reconfig_avmm avalon sink
    for {set i 0} {$i < $num_of_lanes} {incr i} {
      set_interface_property reconfig_avmm_${i} associatedClock reconfig_clk
      set_interface_property reconfig_avmm_${i} associatedReset reconfig_reset
    }
    glue_add_if_port $num_of_lanes reconfig_avmm reconfig_address address Input $reconfig_avmm_address_width
    glue_add_if_port $num_of_lanes reconfig_avmm reconfig_read read Input 1
    glue_add_if_port $num_of_lanes reconfig_avmm reconfig_readdata readdata Output 32
    glue_add_if_port $num_of_lanes reconfig_avmm reconfig_waitrequest waitrequest Output 1
    glue_add_if_port $num_of_lanes reconfig_avmm reconfig_write write Input 1
    glue_add_if_port $num_of_lanes reconfig_avmm reconfig_writedata writedata Input 32

  }

  set_interface_property reconfig_reset associatedClock reconfig_clk
  set_interface_property reconfig_reset synchronousEdges DEASSERT

  if {[get_parameter TX_OR_RX_N]} {

    glue_add_if $num_of_lanes tx_coreclkin clock sink true
    glue_add_if_port $num_of_lanes tx_coreclkin tx_coreclkin clk Input 1 true

    if {[string equal $device "Agilex 7"]} {
      glue_add_if $num_of_lanes ref_clk ftile_hssi_reference_clock sink true
      glue_add_if_port $num_of_lanes ref_clk ref_clk clk Input 1 true clk

      glue_add_if $num_of_lanes tx_clkout2 clock source
      glue_add_if_port $num_of_lanes tx_clkout2 tx_clkout2 clk Output 1

      glue_add_if $num_of_lanes tx_clkout clock source
      glue_add_if_port $num_of_lanes tx_clkout tx_clkout clk Output 1
    } else {
      glue_add_if $num_of_lanes tx_clkout clock source
      glue_add_if_port $num_of_lanes tx_clkout tx_clkout clk Output 1

      if {$bonding_clocks_en && $num_of_lanes > 6} {
          glue_add_if $num_of_lanes tx_bonding_clocks hssi_bonded_clock sink true
          glue_add_if_port $num_of_lanes tx_bonding_clocks tx_bonding_clocks clk Input 6 true
      } else {
          glue_add_tx_serial_clk $num_of_lanes
      }
    }

    if {$soft_pcs} {
      set unused_width [expr $num_of_lanes * $unused_width_per_lane]

      glue_add_const_conduit tx_enh_data_valid $num_of_lanes

      for {set i 0} {$i < $num_of_lanes} {incr i} {
        add_interface tx_raw_data_${i} conduit start
      }
      glue_add_if_port_conduit $num_of_lanes tx_raw_data raw_data tx_parallel_data Input $parallel_data_w
    } else {
      set unused_width [expr $num_of_lanes * 92]

      for {set i 0} {$i < $num_of_lanes} {incr i} {
        add_interface tx_phy_${i} conduit start
      }
      glue_add_if_port_conduit $num_of_lanes tx_phy char tx_parallel_data Input 32
      glue_add_if_port_conduit $num_of_lanes tx_phy charisk tx_datak Input 4
    }

    glue_add_const_conduit unused_tx_parallel_data $unused_width

    add_interface phy_tx_polinv conduit end
    add_interface_port phy_tx_polinv polinv tx_polinv Output $num_of_lanes
    set_port_property polinv TERMINATION $soft_pcs
  } else {

    glue_add_if $num_of_lanes rx_coreclkin clock sink true
    glue_add_if_port $num_of_lanes rx_coreclkin rx_coreclkin clk Input 1 true

    if {[string equal $device "Agilex 7"]} {
      glue_add_if $num_of_lanes ref_clk ftile_hssi_reference_clock sink true
      glue_add_if_port $num_of_lanes ref_clk ref_clk clk Input 1 true clk

      glue_add_if $num_of_lanes rx_clkout2 clock source
      glue_add_if_port $num_of_lanes rx_clkout2 rx_clkout2 clk Output 1

      glue_add_if $num_of_lanes rx_clkout clock source
      glue_add_if_port $num_of_lanes rx_clkout rx_clkout clk Output 1
    } else {
      glue_add_if 1 rx_cdr_refclk0 clock sink true
      glue_add_if_port 1 rx_cdr_refclk0 rx_cdr_refclk0 clk Input 1 true

      glue_add_if $num_of_lanes rx_clkout clock source
      glue_add_if_port $num_of_lanes rx_clkout rx_clkout clk Output 1
    }

    if {$soft_pcs} {
      for {set i 0} {$i < $num_of_lanes} {incr i} {
        add_interface rx_raw_data_${i} conduit start
      }
      glue_add_if_port_conduit $num_of_lanes rx_raw_data raw_data rx_parallel_data Output $parallel_data_w
    } else {
      for {set i 0} {$i < $num_of_lanes} {incr i} {
        add_interface rx_phy_${i} conduit start
      }
      glue_add_if_port_conduit $num_of_lanes rx_phy char rx_parallel_data Output 32
      glue_add_if_port_conduit $num_of_lanes rx_phy charisk rx_datak Output 4
      glue_add_if_port_conduit $num_of_lanes rx_phy disperr rx_disperr Output 4
      glue_add_if_port_conduit $num_of_lanes rx_phy notintable rx_errdetect Output 4
      glue_add_if_port_conduit $num_of_lanes rx_phy patternalign_en rx_std_wa_patternalign Input 1
    }

    add_interface const_out conduit end
    add_interface_port const_out const_out const_out Output 1
    set_port_property const_out TERMINATION true
    set const_offset 1

    add_interface phy_rx_polinv conduit end
    add_interface_port phy_rx_polinv polinv rx_polinv Output $num_of_lanes
    set_port_property polinv TERMINATION $soft_pcs
  }

  set_parameter_value WIDTH $sig_offset
  set_parameter_value CONST_WIDTH $const_offset
}
