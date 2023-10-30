###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require math

## Global variables for interconnect interface indexing
#
set sys_cpu_interconnect_index 0
set sys_hpc0_interconnect_index -1
set sys_hpc1_interconnect_index -1
set sys_hp0_interconnect_index -1
set sys_hp1_interconnect_index -1
set sys_hp2_interconnect_index -1
set sys_hp3_interconnect_index -1
set sys_mem_interconnect_index -1
set sys_mem_clk_index 0

set xcvr_index -1
set xcvr_tx_index 0
set xcvr_rx_index 0
set xcvr_instance NONE

set use_smartconnect 1

## Add an instance of an IP to the block design.
#
# \param[i_ip] - name of the IP
# \param[i_name] - name of the instance
# \param[i_params] - a list of the parameters, the list must contain {name, value}
# pairs
#
proc ad_ip_instance {i_ip i_name {i_params {}}} {

  set cell [create_bd_cell -type ip -vlnv [get_ipdefs -all -filter "VLNV =~ *:${i_ip}:* && \
    design_tool_contexts =~ *IPI* && UPGRADE_VERSIONS == \"\""] ${i_name}]
  if {$i_params != {}} {
    set config {}
    # Add CONFIG. prefix to all config options
    foreach {k v} $i_params {
      lappend config "CONFIG.$k" $v
    }
    set_property -dict $config $cell
  }
}

## Define a parameter value of an IP instance.
#
# \param[i_name] - name of the instance
# \param[i_param] - name of the parameter
# \param[i_value] - value of the parameter
#
proc ad_ip_parameter {i_name i_param i_value} {

  set_property ${i_param} ${i_value} [get_bd_cells ${i_name}]
}

## Define the type of an IPI interface object, in general these objects an be:
#  interface pins, ports or nets; or cells pins, ports or nets.
#
# \param[p_name] - name of the object
#
# \return - the type of the object
#
proc ad_connect_type {p_name} {

  set m_name ""

  if {$m_name eq ""} {set m_name [get_bd_intf_pins  -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_pins       -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_intf_ports -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_ports      -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_intf_nets  -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_nets       -quiet $p_name]}

  return $m_name
}

## Get type of object, for internal use only!
proc ad_connect_int_class {p_name} {

  set m_name ""

  if {$m_name eq ""} {set m_name [get_bd_intf_pins  -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_pins       -quiet $p_name]}
  # All ports can be handled as pins
  # if {$m_name eq ""} {set m_name [get_bd_intf_ports -quiet $p_name]}
  # if {$m_name eq ""} {set m_name [get_bd_ports      -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_intf_nets  -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_nets       -quiet $p_name]}

  if {!($m_name eq "")} {
    return [get_property CLASS $m_name]
  }

  if {$p_name eq "GND" || $p_name eq "VCC"} {
    return "const"
  }

  return "newnet"
}

## Get constant source, for internal use only!
proc ad_connect_int_get_const {name width} {
  switch $name {
    GND {
      set value 0
    }
    VCC {
      set value [expr (1 << $width) - 1]
    }
    default {
      error "ERROR: ad_connect_int_get_const: Unhandled constant name $name"
    }
  }

  set cell_name "$name\_$width"

  set cell [get_bd_cells -quiet $cell_name]
  if {$cell eq ""} {
    # Create new constant source
    ad_ip_instance xlconstant $cell_name
    set cell [get_bd_cells -quiet $cell_name]
    set_property CONFIG.CONST_WIDTH $width $cell
    set_property CONFIG.CONST_VAL $value $cell
  }

  return $cell
}

## Determine pin/port/net width, for internal use only!
proc ad_connect_int_width {obj} {
  if {$obj eq ""} {
    error "ERROR: ad_connect_int_width: No object provided."
  }

  set classname [get_property -quiet CLASS $obj]
  if {$classname eq ""} {
    error "ERROR: ad_connect_int_width: Cannot determine width of class-less object: $obj"
  }
  if {[string first intf $classname] != -1} {
    error "ERROR: ad_connect_int_width: Cannot determine width of interface object: $obj ($classname)"
  }

  if {([get_property -quiet LEFT $obj] eq "") || ([get_property -quiet RIGHT $obj] eq "")} {
    return 1
  }

  set left [get_property LEFT $obj]
  set right [get_property RIGHT $obj]

  set high [::math::max $left $right]
  set low [::math::min $left $right]

  return [expr {1 + $high - $low}]
}


## Connect two IPI interface object together.
#
# \param[p_name_1] - first object name
# \param[p_name_2] - second object name
#
# Valid object types are: GND/VCC, net/port/pin names or interface names
#
# \return - N/A
#
proc ad_connect {name_a name_b} {
  set type_a [ad_connect_int_class $name_a]
  set type_b [ad_connect_int_class $name_b]

  set obj_a [ad_connect_type $name_a]
  set obj_b [ad_connect_type $name_b]

  if {!([string first intf $type_a]+1) != !([string first intf $type_b]+1)} {
    error "ERROR: ad_connect: Cannot connect non-interface to interface: $name_a ($type_a) <-/-> $name_b ($type_b)"
  }

  switch $type_a,$type_b {
    newnet,newnet {
      error "ERROR: ad_connect: Cannot create connection between two new nets: $name_a <-/-> $name_b"
    }
    const,const {
      error "ERROR: ad_connect: Cannot connect constant to constant: $name_a <-/-> $name_b"
    }
    bd_net,bd_net -
    bd_intf_net,bd_intf_net {
      error "ERROR: ad_connect: Cannot connect (intf) net to (intf) net: $name_a ($type_a) <-/-> $name_b ($type_b)"
    }
    bd_net,newnet -
    newnet,bd_net {
      error "ERROR: ad_connect: Cannot connect existing net to new net: $name_a ($type_a) <-/-> $name_b ($type_b)"
    }
    const,newnet -
    newnet,const {
      error "ERROR: ad_connect: Cannot connect new network to constant, instead you should connect to the constant directly: $name_a ($type_a) <-/-> $name_b ($type_b)"
    }

    bd_pin,bd_pin {
      connect_bd_net $obj_a $obj_b
      puts "connect_bd_net $obj_a $obj_b"
      return
    }
    bd_net,bd_pin {
      connect_bd_net -net $obj_a $obj_b
      puts "connect_bd_net -net $obj_a $obj_b"
      return
    }
    bd_pin,bd_net {
      connect_bd_net -net $obj_b $obj_a
      puts "connect_bd_net -net $obj_b $obj_a"
      return
    }
    bd_pin,newnet {
      connect_bd_net -net $name_b $obj_a
      puts "connect_bd_net -net $name_b $obj_a"
      return
    }
    newnet,bd_pin {
      connect_bd_net -net $name_a $obj_b
      puts "connect_bd_net -net $name_a $obj_b"
      return
    }
    bd_intf_pin,bd_intf_pin {
      connect_bd_intf_net $obj_a $obj_b
      puts "connect_bd_intf_net $obj_a $obj_b"
      return
    }
    const,bd_pin -
    const,bd_net {
      # Handled after the switch statement
    }
    bd_net,const -
    bd_pin,const {
      # Swap vars
      set tmp $obj_a
      set obj_a $obj_b
      set obj_b $tmp
      set tmp $name_a
      set name_a $name_b
      set name_b $tmp
      # Handled after the switch statement
    }
    default {
      error "ERROR: ad_connect: Cannot connect, case unhandled: $name_a ($type_a) <-/-> $name_b ($type_b)"
    }
  }

  # Continue working on nets that connect to constant. obj_b is the net/pin
  set width [ad_connect_int_width $obj_b]
  set cell [ad_connect_int_get_const $name_a $width]
  connect_bd_net [get_bd_pin $cell/dout] $obj_b
  puts "connect_bd_net [get_bd_pin $cell/dout] $obj_b"
}

## Disconnect two IPI interface object together.
#
# \param[p_name_1] - first object name
# \param[p_name_2] - second object name
#
# Valid object types are: GND/VCC, net/port/pin names or interface names
#
# \return - N/A
#
proc ad_disconnect {p_name_1 p_name_2} {

  set m_name_1 [ad_connect_type $p_name_1]
  set m_name_2 [ad_connect_type $p_name_2]

  if {[get_property CLASS $m_name_1] eq "bd_net"} {
    disconnect_bd_net $m_name_1 $m_name_2
    return
  }

  if {[get_property CLASS $m_name_1] eq "bd_port"} {
    delete_bd_objs -quiet [get_bd_nets -quiet -of_objects \
      [find_bd_objs -relation connected_to $m_name_1]]
    delete_bd_objs -quiet $m_name_1
    return
  }

  if {[get_property CLASS $m_name_1] eq "bd_pin"} {
    delete_bd_objs -quiet [get_bd_nets -quiet -of_objects \
      [find_bd_objs -relation connected_to $m_name_1]]
    delete_bd_objs -quiet $m_name_1
    return
  }
}

## Define all the connections between the transceiver IP, the transceiver
#  configuration IP and the JESD204 Link IP.
#
#  \param[u_xcvr] - name of the transceiver IP (util_adxcvr)
#  \param[a_xcvr] - name of the transceiver configuration IP (axi_adxcvr)
#  \param[a_jesd] - name of the JESD204 link IP
#  \param[lane_map] - lane_map maps the logical lane $n onto the physical lane
#  $lane_map[$n], otherwise logical lane $n is mapped onto physical lane $n.
#  \param[link_clk] - define a custom link clock, should be a net name
#  connected to the clock source. If not used, the rx|tx_clk_out_0 is used as
#  link clock. This should be lane rate / (encoder_ratio*datapath width in bits)
#  where encoder_ratio is 10/8 for 8b10b encoding or 66/64 for 64b66b link layer.
#  \param[device_clk] - define a custom device clock, should be a net name
#  connected to the clock source. If not used, the link_clk is used as
#  device clock
#  \param[num_of_max_lanes] - maximum number of used lanes at physical layer per link,
#  this parameter is used only when the project is parameterized in order to connect the unused lanes
#  to the util_adxcvr block. If not used, the number of connected lanes will be defined
#  by the axi_adxcvr.
#

proc ad_xcvrcon {u_xcvr a_xcvr a_jesd {lane_map {}} {link_clk {}} {device_clk {}} {num_of_max_lanes -1} {partial_lane_map {}} {connect_empty_lanes 1}} {

  global xcvr_index
  global xcvr_tx_index
  global xcvr_rx_index
  global xcvr_instance

  set qpll_enable [get_property CONFIG.QPLL_ENABLE [get_bd_cells $a_xcvr]]
  set tx_or_rx_n [get_property CONFIG.TX_OR_RX_N [get_bd_cells $a_xcvr]]

  set xcvr_type [get_property CONFIG.XCVR_TYPE [get_bd_cells $u_xcvr]]

  set link_mode_u [get_property CONFIG.LINK_MODE [get_bd_cells $u_xcvr]]
  set link_mode_a [get_property CONFIG.LINK_MODE [get_bd_cells $a_xcvr]]

  if {$link_mode_u != $link_mode_a} {
     puts "CRITICAL WARNING: LINK_MODE parameter mismatch between $u_xcvr ($link_mode_u) and $a_xcvr ($link_mode_a)"
  }
  set link_mode $link_mode_u

  set jesd204_bd_type [get_property TYPE [get_bd_cells $a_jesd]]

  if {$jesd204_bd_type == "hier"} {
    set jesd204_type 0
  } else {
    set jesd204_type 1
  }

  if {$xcvr_instance ne $u_xcvr} {
    set xcvr_index [expr ($xcvr_index + 1)]
    set xcvr_tx_index 0
    set xcvr_rx_index 0
    set xcvr_instance $u_xcvr
  }

  set txrx "rx"
  set data_dir "I"
  set ctrl_dir "O"
  set index $xcvr_rx_index

  if {$tx_or_rx_n == 1} {

    set txrx "tx"
    set data_dir "O"
    set ctrl_dir "I"
    set index $xcvr_tx_index
  }

  set m_sysref ${txrx}_sysref_${index}
  set m_sync ${txrx}_sync_${index}
  set m_data ${txrx}_data

  if {$xcvr_index >= 1} {

    set m_sysref ${txrx}_sysref_${xcvr_index}_${index}
    set m_sync ${txrx}_sync_${xcvr_index}_${index}
    set m_data ${txrx}_data_${xcvr_index}
  }

  if {$jesd204_type == 0} {
    set num_of_links [get_property CONFIG.NUM_LINKS [get_bd_cells $a_jesd/$txrx]]
  } else {
    set num_of_links 1
  }

  set no_of_lanes [get_property CONFIG.NUM_LANES [get_bd_cells $a_jesd/$txrx]]
  set max_no_of_lanes $no_of_lanes

  if {$num_of_max_lanes != -1} {
    set max_no_of_lanes $num_of_max_lanes
  }
  create_bd_port -dir I $m_sysref
  create_bd_port -from [expr $num_of_links - 1] -to 0 -dir ${ctrl_dir} $m_sync

  set use_2x_clk 0
  if {$link_clk == {}} {
    # For 204C modes on GTH a 2x clock is required to drive the PCS
    # In such case set the xcvr out clock to be the double of the lane rate/66(40)
    # and use the secondary div2 clock output for the link clock
    if {$link_mode == 2 && ($xcvr_type == 5 || $xcvr_type == 8)} {
      set link_clk ${u_xcvr}/${txrx}_out_clk_div2_${index}
      set link_clk_2x ${u_xcvr}/${txrx}_out_clk_${index}
      set use_2x_clk 1
    } else {
      if {$partial_lane_map != {}} {
        set cur_index [lindex $partial_lane_map $index]
        set link_clk ${u_xcvr}/${txrx}_out_clk_${cur_index}
      } else {
        set link_clk ${u_xcvr}/${txrx}_out_clk_${index}
      }
    }
    set rst_gen [regsub -all "/" ${a_jesd}_rstgen "_"]
    set create_rst_gen 1
  } else {
    set rst_gen ${link_clk}_rstgen
    # Only create one reset gen per clock
    set create_rst_gen [expr {[get_bd_cells -quiet ${rst_gen}] == {}}]
  }

  if {$device_clk == {}} {
    set device_clk $link_clk
  } else {
    set rst_gen ${device_clk}_rstgen
    # Only create one reset gen per clock
    set create_rst_gen [expr {[get_bd_cells -quiet ${rst_gen}] == {}}]
  }

  if {${create_rst_gen}} {
    ad_ip_instance proc_sys_reset ${rst_gen}
    ad_connect ${device_clk} ${rst_gen}/slowest_sync_clk
    ad_connect sys_cpu_resetn ${rst_gen}/ext_reset_in
  }

  if {$partial_lane_map != {}} {
    for {set n 0} {$n < $no_of_lanes} {incr n} {

      set phys_lane [lindex $partial_lane_map $n]

      if {$phys_lane != {}} {
        if {$jesd204_type == 0} {
          ad_connect  ${u_xcvr}/${txrx}_${phys_lane} ${a_jesd}/${txrx}_phy${n}
        } else {
          ad_connect  ${u_xcvr}/${txrx}_${phys_lane} ${a_jesd}/gt${n}_${txrx}
        }
      }

      if {$tx_or_rx_n == 0} {
        if {$jesd204_type == 0} {
          if {$link_mode == 1} {
            ad_connect  ${a_jesd}/phy_en_char_align ${u_xcvr}/${txrx}_calign_${phys_lane}
          }
        } else {
          ad_connect  ${a_jesd}/rxencommaalign_out ${u_xcvr}/${txrx}_calign_${phys_lane}
        }
      }
    }
    if {$connect_empty_lanes == 1} {
      for {set n 0} {$n < $max_no_of_lanes} {incr n} {

        set m [expr ($n + $index)]

        if {$lane_map != {}} {
          set phys_lane [lindex $lane_map $n]
        } else {
          set phys_lane $m
        }

        if {$tx_or_rx_n == 0} {
          ad_connect  ${a_xcvr}/up_es_${n} ${u_xcvr}/up_es_${phys_lane}
        }

        if {(($n%4) == 0) && ($qpll_enable == 1)} {
          ad_connect  ${a_xcvr}/up_cm_${n} ${u_xcvr}/up_cm_${m}
        }
        ad_connect  ${a_xcvr}/up_ch_${n} ${u_xcvr}/up_${txrx}_${phys_lane}
        ad_connect  ${link_clk} ${u_xcvr}/${txrx}_clk_${phys_lane}
        if {$use_2x_clk == 1} {
          ad_connect  ${link_clk_2x} ${u_xcvr}/${txrx}_clk_2x_${phys_lane}
        }

        create_bd_port -dir ${data_dir} ${m_data}_${m}_p
        create_bd_port -dir ${data_dir} ${m_data}_${m}_n
        ad_connect  ${u_xcvr}/${txrx}_${m}_p ${m_data}_${m}_p
        ad_connect  ${u_xcvr}/${txrx}_${m}_n ${m_data}_${m}_n
      }
    } else {
      ## Do nothing, the connections will be done manually
    }

  } else {
    for {set n 0} {$n < $no_of_lanes} {incr n} {

      set m [expr ($n + $index)]
      if {$lane_map != {}} {
        set phys_lane [lindex $lane_map $n]
      } else {
        set phys_lane $m
      }

      if {$tx_or_rx_n == 0} {
        ad_connect  ${a_xcvr}/up_es_${n} ${u_xcvr}/up_es_${phys_lane}
        if {$jesd204_type == 0} {
          if {$link_mode == 1} {
            ad_connect  ${a_jesd}/phy_en_char_align ${u_xcvr}/${txrx}_calign_${phys_lane}
          }
        } else {
          ad_connect  ${a_jesd}/rxencommaalign_out ${u_xcvr}/${txrx}_calign_${phys_lane}
        }
      }

      if {(($n%4) == 0) && ($qpll_enable == 1)} {
        ad_connect  ${a_xcvr}/up_cm_${n} ${u_xcvr}/up_cm_${m}
      }
      ad_connect  ${a_xcvr}/up_ch_${n} ${u_xcvr}/up_${txrx}_${phys_lane}
      ad_connect  ${link_clk} ${u_xcvr}/${txrx}_clk_${phys_lane}
      if {$use_2x_clk == 1} {
        ad_connect  ${link_clk_2x} ${u_xcvr}/${txrx}_clk_2x_${phys_lane}
      }
      if {$phys_lane != {}} {
        if {$jesd204_type == 0} {
          ad_connect  ${u_xcvr}/${txrx}_${phys_lane} ${a_jesd}/${txrx}_phy${n}
        } else {
          ad_connect  ${u_xcvr}/${txrx}_${phys_lane} ${a_jesd}/gt${n}_${txrx}
        }
      }

      create_bd_port -dir ${data_dir} ${m_data}_${m}_p
      create_bd_port -dir ${data_dir} ${m_data}_${m}_n
      ad_connect  ${u_xcvr}/${txrx}_${m}_p ${m_data}_${m}_p
      ad_connect  ${u_xcvr}/${txrx}_${m}_n ${m_data}_${m}_n
    }

    for {set n $no_of_lanes} {$n < $max_no_of_lanes} {incr n} {

      set m [expr ($n + $index)]

      if {$lane_map != {}} {
        set phys_lane [lindex $lane_map $n]
      } else {
        set phys_lane $m
      }

      create_bd_port -dir ${data_dir} ${m_data}_${m}_p
      create_bd_port -dir ${data_dir} ${m_data}_${m}_n
      ad_connect  ${u_xcvr}/${txrx}_${m}_p ${m_data}_${m}_p
      ad_connect  ${u_xcvr}/${txrx}_${m}_n ${m_data}_${m}_n
      ad_connect  ${link_clk} ${u_xcvr}/${txrx}_clk_${phys_lane}

      if {$tx_or_rx_n == 0} {
        if {$jesd204_type == 0} {
          if {$link_mode == 1} {
	    ad_connect  ${a_jesd}/phy_en_char_align ${u_xcvr}/${txrx}_calign_${phys_lane}
          }
	}
      }
    }
  }

  if {$jesd204_type == 0} {
    ad_connect  ${a_jesd}/sysref $m_sysref
    if {$link_mode == 1} {
      ad_connect  ${a_jesd}/sync $m_sync
    }
    ad_connect  ${device_clk} ${a_jesd}/device_clk
    ad_connect  ${link_clk} ${a_jesd}/link_clk
  } else {
    ad_connect  ${a_jesd}/${txrx}_sysref $m_sysref
    ad_connect  ${a_jesd}/${txrx}_sync $m_sync
    ad_connect  ${device_clk} ${a_jesd}/${txrx}_core_clk
    ad_connect  ${a_xcvr}/up_status ${a_jesd}/${txrx}_reset_done
    ad_connect  ${rst_gen}/peripheral_reset ${a_jesd}/${txrx}_reset
  }

  if {$tx_or_rx_n == 0} {
    set xcvr_rx_index [expr ($xcvr_rx_index + $max_no_of_lanes)]
  }

  if {$tx_or_rx_n == 1} {
    set xcvr_tx_index [expr ($xcvr_tx_index + $max_no_of_lanes)]
  }
}
## Connect all the PLL clock and reset ports of the transceiver IP to a clock
#  or reset source.
#
#  \param[m_src] - name of the clock or reset source
#  \param[m_dst] - name or list of names of the clock or reset sink
#
proc ad_xcvrpll {m_src m_dst} {

  foreach p_dst [get_bd_pins -quiet $m_dst] {
    connect_bd_net [ad_connect_type $m_src] $p_dst
  }
}

###################################################################################################
###################################################################################################

## Create an memory mapped interface connection to PS8 IP, using a
#  HPC0 high speed interface.
#
#  \param[p_clk]  - name of the clock or reset source
#  \param[p_name] - name or list of names of the clock or reset sink
#
proc ad_mem_hpc0_interconnect {p_clk p_name} {

  global sys_zynq

  if {$sys_zynq == 2} {ad_mem_hpx_interconnect "HPC0" $p_clk $p_name}
}

## Create an memory mapped interface connection to PS8 IP, using a
#  HPC1 high speed interface.
#
#  \param[p_clk]  - name of the clock or reset source
#  \param[p_name] - name or list of names of the clock or reset sink
#
proc ad_mem_hpc1_interconnect {p_clk p_name} {

  global sys_zynq

  if {$sys_zynq == 2} {ad_mem_hpx_interconnect "HPC1" $p_clk $p_name}
}

## Create an memory mapped interface connection to a MIG or PS7/8 IP, using a
#  HP0 high speed interface in case of PSx.
#
#  \param[p_clk]  - name of the clock or reset source
#  \param[p_name] - name or list of names of the clock or reset sink
#
proc ad_mem_hp0_interconnect {p_clk p_name} {

  global sys_zynq

  if {($sys_zynq != 1 && $sys_zynq != 2) && ($p_name eq "sys_ps7/S_AXI_HP0")} {return}
  if {$sys_zynq == -1} {ad_mem_hpx_interconnect "SIM" $p_clk $p_name}
  if {$sys_zynq == 0} {ad_mem_hpx_interconnect "MEM" $p_clk $p_name}
  if {$sys_zynq == 1} {ad_mem_hpx_interconnect "HP0" $p_clk $p_name}
  if {$sys_zynq == 2} {ad_mem_hpx_interconnect "HP0" $p_clk $p_name}
  if {$sys_zynq == 3} {ad_mem_hpx_interconnect "NOC" $p_clk $p_name}
}

## Create an memory mapped interface connection to a MIG or PS7/8 IP, using a
#  HP1 high speed interface in case of PSx.
#
#  \param[p_clk]  - name of the clock or reset source
#  \param[p_name] - name or list of names of the clock or reset sink
#
proc ad_mem_hp1_interconnect {p_clk p_name} {

  global sys_zynq

  if {($sys_zynq != 1 && $sys_zynq != 2) && ($p_name eq "sys_ps7/S_AXI_HP1")} {return}
  if {$sys_zynq == -1} {ad_mem_hpx_interconnect "SIM" $p_clk $p_name}
  if {$sys_zynq == 0} {ad_mem_hpx_interconnect "MEM" $p_clk $p_name}
  if {$sys_zynq == 1} {ad_mem_hpx_interconnect "HP1" $p_clk $p_name}
  if {$sys_zynq == 2} {ad_mem_hpx_interconnect "HP1" $p_clk $p_name}
  if {$sys_zynq == 3} {ad_mem_hpx_interconnect "NOC" $p_clk $p_name}
}

## Create an memory mapped interface connection to a MIG or PS7/8 IP, using a
#  HP2 high speed interface in case of PSx.
#
#  \param[p_clk]  - name of the clock or reset source
#  \param[p_name] - name or list of names of the clock or reset sink
#
proc ad_mem_hp2_interconnect {p_clk p_name} {

  global sys_zynq

  if {($sys_zynq != 1 && $sys_zynq != 2) && ($p_name eq "sys_ps7/S_AXI_HP2")} {return}
  if {$sys_zynq == -1} {ad_mem_hpx_interconnect "SIM" $p_clk $p_name}
  if {$sys_zynq == 0} {ad_mem_hpx_interconnect "MEM" $p_clk $p_name}
  if {$sys_zynq == 1} {ad_mem_hpx_interconnect "HP2" $p_clk $p_name}
  if {$sys_zynq == 2} {ad_mem_hpx_interconnect "HP2" $p_clk $p_name}
  if {$sys_zynq == 3} {ad_mem_hpx_interconnect "NOC" $p_clk $p_name}
}

## Create an memory mapped interface connection to a MIG or PS7/8 IP, using a
#  HP3 high speed interface in case of PSx.
#
#  \param[p_clk]  - name of the clock or reset source
#  \param[p_name] - name or list of names of the clock or reset sink
#
proc ad_mem_hp3_interconnect {p_clk p_name} {

  global sys_zynq

  if {($sys_zynq != 1 && $sys_zynq != 2) && ($p_name eq "sys_ps7/S_AXI_HP3")} {return}
  if {$sys_zynq == -1} {ad_mem_hpx_interconnect "SIM" $p_clk $p_name}
  if {$sys_zynq == 0} {ad_mem_hpx_interconnect "MEM" $p_clk $p_name}
  if {$sys_zynq == 1} {ad_mem_hpx_interconnect "HP3" $p_clk $p_name}
  if {$sys_zynq == 2} {ad_mem_hpx_interconnect "HP3" $p_clk $p_name}
  if {$sys_zynq == 3} {ad_mem_hpx_interconnect "NOC" $p_clk $p_name}
}

## Create an memory mapped interface connection to a MIG or PS7/8 IP, proc is
#  called in the ad_mem_hp[0|1|2|3]_interconnect processes, should never be
#  directly called in block designs.
#
#  \param[p_sel]  - name of the high speed interface, valid values are HP0, HP1
#  HP2, HP3, MEM in case of Microblaze, or SIM in case of simulation
#  \param[p_clk]  - name of the clock or reset source
#  \param[p_name] - name or list of names of the clock or reset sink
#
proc ad_mem_hpx_interconnect {p_sel p_clk p_name} {

  global sys_zynq
  global sys_ddr_addr_seg
  global sys_hpc0_interconnect_index
  global sys_hpc1_interconnect_index
  global sys_hp0_interconnect_index
  global sys_hp1_interconnect_index
  global sys_hp2_interconnect_index
  global sys_hp3_interconnect_index
  global sys_mem_interconnect_index
  global sys_mem_clk_index
  global use_smartconnect

  set p_name_int $p_name
  set p_clk_source [get_bd_pins -filter {DIR == O} -of_objects [get_bd_nets $p_clk]]

  set connect_type "smartconnect"
  if {$use_smartconnect == 0} {
    set connect_type "axi_interconnect"
  }

  if {$p_sel eq "SIM"} {
    if {$sys_mem_interconnect_index < 0} {
      ad_ip_instance $connect_type axi_mem_interconnect
    }
    set m_interconnect_index $sys_mem_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_mem_interconnect]
    set m_addr_seg [get_bd_addr_segs -of_objects [get_bd_cells ddr_axi_vip]]
  }

  if {$p_sel eq "MEM"} {
    if {$sys_mem_interconnect_index < 0} {
      ad_ip_instance $connect_type axi_mem_interconnect
    }
    set m_interconnect_index $sys_mem_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_mem_interconnect]
    set m_addr_seg [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl] -filter "USAGE == memory"]
  }

  if {($p_sel eq "HP0") && ($sys_zynq == 1)} {
    if {$sys_hp0_interconnect_index < 0} {
      set p_name_int sys_ps7/S_AXI_HP0
      set_property CONFIG.PCW_USE_S_AXI_HP0 {1} [get_bd_cells sys_ps7]
      ad_ip_instance $connect_type axi_hp0_interconnect
    }
    set m_interconnect_index $sys_hp0_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp0_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps7/S_AXI_HP0/HP0_DDR_LOWOCM]
  }

  if {($p_sel eq "HP1") && ($sys_zynq == 1)} {
    if {$sys_hp1_interconnect_index < 0} {
      set p_name_int sys_ps7/S_AXI_HP1
      set_property CONFIG.PCW_USE_S_AXI_HP1 {1} [get_bd_cells sys_ps7]
      ad_ip_instance $connect_type axi_hp1_interconnect
    }
    set m_interconnect_index $sys_hp1_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp1_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM]
  }

  if {($p_sel eq "HP2") && ($sys_zynq == 1)} {
    if {$sys_hp2_interconnect_index < 0} {
      set p_name_int sys_ps7/S_AXI_HP2
      set_property CONFIG.PCW_USE_S_AXI_HP2 {1} [get_bd_cells sys_ps7]
      ad_ip_instance $connect_type axi_hp2_interconnect
    }
    set m_interconnect_index $sys_hp2_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp2_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM]
  }

  if {($p_sel eq "HP3") && ($sys_zynq == 1)} {
    if {$sys_hp3_interconnect_index < 0} {
      set p_name_int sys_ps7/S_AXI_HP3
      set_property CONFIG.PCW_USE_S_AXI_HP3 {1} [get_bd_cells sys_ps7]
      ad_ip_instance $connect_type axi_hp3_interconnect
    }
    set m_interconnect_index $sys_hp3_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp3_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM]
  }

  if {($p_sel eq "HPC0") && ($sys_zynq == 2)} {
    if {$sys_hpc0_interconnect_index < 0} {
      set p_name_int sys_ps8/S_AXI_HPC0_FPD
      set_property CONFIG.PSU__USE__S_AXI_GP0 {1} [get_bd_cells sys_ps8]
      set_property CONFIG.PSU__AFI0_COHERENCY {1} [get_bd_cells sys_ps8]
      ad_ip_instance $connect_type axi_hpc0_interconnect
    }
    set m_interconnect_index $sys_hpc0_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hpc0_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps8/SAXIGP0/HPC0_DDR_*]
  }

  if {($p_sel eq "HPC1") && ($sys_zynq == 2)} {
    if {$sys_hpc1_interconnect_index < 0} {
      set p_name_int sys_ps8/S_AXI_HPC1_FPD
      set_property CONFIG.PSU__USE__S_AXI_GP1 {1} [get_bd_cells sys_ps8]
      set_property CONFIG.PSU__AFI1_COHERENCY {1} [get_bd_cells sys_ps8]
      ad_ip_instance $connect_type axi_hpc1_interconnect
    }
    set m_interconnect_index $sys_hpc1_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hpc1_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps8/SAXIGP1/HPC1_DDR_*]
  }

  if {($p_sel eq "HP0") && ($sys_zynq == 2)} {
    if {$sys_hp0_interconnect_index < 0} {
      set p_name_int sys_ps8/S_AXI_HP0_FPD
      set_property CONFIG.PSU__USE__S_AXI_GP2 {1} [get_bd_cells sys_ps8]
      ad_ip_instance $connect_type axi_hp0_interconnect
    }
    set m_interconnect_index $sys_hp0_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp0_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_DDR_*]
  }

  if {($p_sel eq "HP1") && ($sys_zynq == 2)} {
    if {$sys_hp1_interconnect_index < 0} {
      set p_name_int sys_ps8/S_AXI_HP1_FPD
      set_property CONFIG.PSU__USE__S_AXI_GP3 {1} [get_bd_cells sys_ps8]
      ad_ip_instance $connect_type axi_hp1_interconnect
    }
    set m_interconnect_index $sys_hp1_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp1_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps8/SAXIGP3/HP1_DDR_*]
  }

  if {($p_sel eq "HP2") && ($sys_zynq == 2)} {
    if {$sys_hp2_interconnect_index < 0} {
      set p_name_int sys_ps8/S_AXI_HP2_FPD
      set_property CONFIG.PSU__USE__S_AXI_GP4 {1} [get_bd_cells sys_ps8]
      ad_ip_instance $connect_type axi_hp2_interconnect
    }
    set m_interconnect_index $sys_hp2_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp2_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps8/SAXIGP4/HP2_DDR_*]
  }

  if {($p_sel eq "HP3") && ($sys_zynq == 2)} {
    if {$sys_hp3_interconnect_index < 0} {
      set p_name_int sys_ps8/S_AXI_HP3_FPD
      set_property CONFIG.PSU__USE__S_AXI_GP5 {1} [get_bd_cells sys_ps8]
      ad_ip_instance $connect_type axi_hp3_interconnect
    }
    set m_interconnect_index $sys_hp3_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp3_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_*]
  }

  if {$p_sel eq "NOC"} {
    set m_interconnect_index [get_property CONFIG.NUM_SI [get_bd_cells axi_noc_0]]
    set m_interconnect_cell [get_bd_cells axi_noc_0]
    set m_addr_seg [get_bd_addr_segs  axi_noc_0/S[format "%02s" [expr $m_interconnect_index +1]]_AXI/C0_DDR_LOW0]
    set sys_mem_clk_index [expr [get_property CONFIG.NUM_CLKS [get_bd_cells axi_noc_0]]-1]
  }

  set i_str "S$m_interconnect_index"
  if {$m_interconnect_index < 10} {
    set i_str "S0$m_interconnect_index"
  }

  set m_interconnect_index [expr $m_interconnect_index + 1]

  set p_intf_name [lrange [split $p_name_int "/"] end end]
  set p_cell_name [lrange [split $p_name_int "/"] 0 0]
  set p_intf_clock [get_bd_pins -filter "TYPE == clk && (CONFIG.ASSOCIATED_BUSIF == ${p_intf_name} || \
    CONFIG.ASSOCIATED_BUSIF =~ ${p_intf_name}:* || CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name} || \
    CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name}:*)" -quiet -of_objects [get_bd_cells $p_cell_name]]
  if {[find_bd_objs -quiet -relation connected_to $p_intf_clock] ne "" ||
      $p_intf_clock eq $p_clk_source} {
    set p_intf_clock ""
  }

  regsub clk $p_clk resetn p_rst
  if {[get_bd_nets -quiet $p_rst] eq ""} {
    set p_rst sys_cpu_resetn
  }

  if {$m_interconnect_index == 0} {
    set_property CONFIG.NUM_MI 1 $m_interconnect_cell
    set_property CONFIG.NUM_SI 1 $m_interconnect_cell
    ad_connect $p_rst $m_interconnect_cell/ARESETN
    ad_connect $p_clk $m_interconnect_cell/ACLK
    ad_connect $m_interconnect_cell/M00_AXI $p_name_int
    if {$use_smartconnect == 0} {
      ad_connect $p_rst $m_interconnect_cell/M00_ARESETN
      ad_connect $p_clk $m_interconnect_cell/M00_ACLK
    }
    if {$p_intf_clock ne ""} {
      ad_connect $p_clk $p_intf_clock
    }
  } else {

    set_property CONFIG.NUM_SI $m_interconnect_index $m_interconnect_cell
    if {$use_smartconnect == 1} {
      set clk_index [lsearch [get_bd_nets -of_object [get_bd_pins $m_interconnect_cell/ACLK*]] [get_bd_nets $p_clk]]
      if { $clk_index == -1 } {
          incr sys_mem_clk_index
          set_property CONFIG.NUM_CLKS [expr $sys_mem_clk_index +1] $m_interconnect_cell
          ad_connect $p_clk $m_interconnect_cell/ACLK$sys_mem_clk_index
          set asocc_clk_pin  $m_interconnect_cell/ACLK$sys_mem_clk_index
      } else {
        set asocc_clk_pin [lindex [get_bd_pins $m_interconnect_cell/ACLK*] $clk_index]
      }
    } else {
      ad_connect $p_rst $m_interconnect_cell/${i_str}_ARESETN
      ad_connect $p_clk $m_interconnect_cell/${i_str}_ACLK
    }
    ad_connect $m_interconnect_cell/${i_str}_AXI $p_name_int
    if {$p_intf_clock ne ""} {
      ad_connect $p_clk $p_intf_clock
    }

    if {$p_sel eq "NOC"} {
      set_property -dict [list CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/${i_str}_AXI]
      # Add the new bus as associated to the clock pin, append new if other exists
      set clk_asoc_port [get_property CONFIG.ASSOCIATED_BUSIF [get_bd_pins $asocc_clk_pin]]
      if {$clk_asoc_port != {}} {
       set clk_asoc_port ${clk_asoc_port}:
      }
      set_property -dict [list CONFIG.ASSOCIATED_BUSIF ${clk_asoc_port}${i_str}_AXI] [get_bd_pins $asocc_clk_pin]
    }

    set mem_mapped ""
    if {$p_sel eq "MEM"} {
      # Search a DDR segment that is at least 16MB
      set mem_mapped [get_bd_addr_segs -of [get_bd_addr_spaces -of  [get_bd_intf_pins -filter {NAME=~ *DLMB*} -of [get_bd_cells /sys_mb]]] -regexp -filter {NAME=~ ".*ddr.*" && RANGE=~".*0{6}$"}]
    }
    if {$p_sel eq "SIM"} {
      set mem_mapped [get_bd_addr_segs -of [get_bd_addr_spaces -of  [get_bd_intf_pins -filter {NAME=~ *M_AXI*} -of [get_bd_cells /mng_axi_vip]]] -filter {NAME=~ *DDR* || NAME=~ *ddr*}]
    }

    if {$mem_mapped eq ""} {
      assign_bd_address $m_addr_seg
    } else {
      assign_bd_address -offset [get_property OFFSET $mem_mapped] \
                        -range  [get_property RANGE $mem_mapped] $m_addr_seg
    }
  }

  if {($use_smartconnect == 0) && ($m_interconnect_index > 1)} {
    set_property CONFIG.STRATEGY {2} $m_interconnect_cell
  }

  if {$p_sel eq "SIM"} {set sys_mem_interconnect_index $m_interconnect_index}
  if {$p_sel eq "MEM"} {set sys_mem_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HPC0"} {set sys_hpc0_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HPC1"} {set sys_hpc1_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HP0"} {set sys_hp0_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HP1"} {set sys_hp1_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HP2"} {set sys_hp2_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HP3"} {set sys_hp3_interconnect_index $m_interconnect_index}

}

## Create an AXI4 Lite memory mapped interface connection for register maps,
#  instantiates an interconnect and reconfigure it at every process call.
#
#  \param[p_address] - address offset of the IP register map
#  \param[p_name] - name of the IP
#  \param[p_intf_name] - name of the AXI MM Slave interface (optional)
#
proc ad_cpu_interconnect {p_address p_name {p_intf_name {}}} {

  global sys_zynq
  global sys_cpu_interconnect_index
  global use_smartconnect

  set i_str "M$sys_cpu_interconnect_index"
  if {$sys_cpu_interconnect_index < 10} {
    set i_str "M0$sys_cpu_interconnect_index"
  }

  if {$sys_cpu_interconnect_index == 0} {

    if {$use_smartconnect == 1} {
      ad_ip_instance smartconnect axi_cpu_interconnect [ list \
        NUM_MI 1 \
        NUM_SI 1 \
      ]
      ad_connect sys_cpu_clk axi_cpu_interconnect/aclk
      ad_connect sys_cpu_resetn axi_cpu_interconnect/aresetn
    } else {
      ad_ip_instance axi_interconnect axi_cpu_interconnect
      ad_connect sys_cpu_clk axi_cpu_interconnect/ACLK
      ad_connect sys_cpu_clk axi_cpu_interconnect/S00_ACLK
      ad_connect sys_cpu_resetn axi_cpu_interconnect/ARESETN
      ad_connect sys_cpu_resetn axi_cpu_interconnect/S00_ARESETN
    }

    if {$sys_zynq == 3} {
      ad_connect sys_cpu_clk sys_cips/m_axi_fpd_aclk
      ad_connect axi_cpu_interconnect/S00_AXI sys_cips/M_AXI_FPD
    }
    if {$sys_zynq == 2} {
      ad_connect sys_cpu_clk sys_ps8/maxihpm0_lpd_aclk
      ad_connect axi_cpu_interconnect/S00_AXI sys_ps8/M_AXI_HPM0_LPD
    }
    if {$sys_zynq == 1} {
      ad_connect sys_cpu_clk sys_ps7/M_AXI_GP0_ACLK
      ad_connect axi_cpu_interconnect/S00_AXI sys_ps7/M_AXI_GP0
    }
    if {$sys_zynq == 0} {
      ad_connect axi_cpu_interconnect/S00_AXI sys_mb/M_AXI_DP
    }
    if {$sys_zynq == -1} {
      ad_connect axi_cpu_interconnect/S00_AXI mng_axi_vip/M_AXI
    }
  }

  if {$sys_zynq == 3} {
    set sys_addr_cntrl_space [get_bd_addr_spaces /sys_cips/M_AXI_FPD]
  }
  if {$sys_zynq == 2} {
    set sys_addr_cntrl_space [get_bd_addr_spaces sys_ps8/Data]
  }
  if {$sys_zynq == 1} {
    set sys_addr_cntrl_space [get_bd_addr_spaces sys_ps7/Data]
  }
  if {$sys_zynq == 0} {
    set sys_addr_cntrl_space [get_bd_addr_spaces sys_mb/Data]
  }
  if {$sys_zynq == -1} {
    set sys_addr_cntrl_space [get_bd_addr_spaces mng_axi_vip/Master_AXI]
  }

  set sys_cpu_interconnect_index [expr $sys_cpu_interconnect_index + 1]


  set p_cell [get_bd_cells $p_name]
  set p_intf [get_bd_intf_pins -filter \
    "MODE == Slave && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ *$p_intf_name*"\
    -of_objects $p_cell]

  set p_hier_cell $p_cell
  set p_hier_intf $p_intf

  while {$p_hier_intf != "" && [get_property TYPE $p_hier_cell] == "hier"} {
    set p_hier_intf [find_bd_objs -boundary_type lower \
      -relation connected_to $p_hier_intf]
    if {$p_hier_intf != {}} {
      set p_hier_cell [get_bd_cells -of_objects $p_hier_intf]
    } else {
      set p_hier_cell {}
    }
  }

  set p_intf_clock ""
  set p_intf_reset ""

  if {$p_hier_cell != {}} {
    set p_intf_name [lrange [split $p_hier_intf "/"] end end]

    set p_intf_clock [get_bd_pins -filter "TYPE == clk && \
      (CONFIG.ASSOCIATED_BUSIF == ${p_intf_name} || \
      CONFIG.ASSOCIATED_BUSIF =~ ${p_intf_name}:* || \
      CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name} || \
      CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name}:*)" \
      -quiet -of_objects $p_hier_cell]
    set p_intf_reset [get_bd_pins -filter "TYPE == rst && \
      (CONFIG.ASSOCIATED_BUSIF == ${p_intf_name} || \
       CONFIG.ASSOCIATED_BUSIF =~ ${p_intf_name}:* ||
       CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name} || \
       CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name}:*)" \
       -quiet -of_objects $p_hier_cell]

    if {($p_intf_clock ne "") && ($p_intf_reset eq "")} {
      set p_intf_reset [get_property CONFIG.ASSOCIATED_RESET [get_bd_pins ${p_intf_clock}]]
      if {$p_intf_reset ne ""} {
        set p_intf_reset [get_bd_pins -filter "NAME == $p_intf_reset" -of_objects $p_hier_cell]
      }
    }

    # Trace back up
    set p_hier_cell2 $p_hier_cell

    while {$p_intf_clock != {} && $p_hier_cell2 != $p_cell && $p_hier_cell2 != {}} {
      puts $p_intf_clock
      puts $p_hier_cell2
      set p_intf_clock [find_bd_objs -boundary_type upper \
        -relation connected_to $p_intf_clock]
      if {$p_intf_clock != {}} {
        set p_intf_clock [get_bd_pins [get_property PATH $p_intf_clock]]
        set p_hier_cell2 [get_bd_cells -of_objects $p_intf_clock]
      }
    }

    set p_hier_cell2 $p_hier_cell

    while {$p_intf_reset != {} && $p_hier_cell2 != $p_cell && $p_hier_cell2 != {}} {
      set p_intf_reset [find_bd_objs -boundary_type upper \
        -relation connected_to $p_intf_reset]
      if {$p_intf_reset != {}} {
        set p_intf_reset [get_bd_pins [get_property PATH $p_intf_reset]]
        set p_hier_cell2 [get_bd_cells -of_objects $p_intf_reset]
      }
    }
  }


  if {[find_bd_objs -quiet -relation connected_to $p_intf_clock] ne ""} {
    set p_intf_clock ""
  }
  if {$p_intf_reset ne ""} {
    if {[find_bd_objs -quiet -relation connected_to $p_intf_reset] ne ""} {
      set p_intf_reset ""
    }
  }

  set_property CONFIG.NUM_MI $sys_cpu_interconnect_index [get_bd_cells axi_cpu_interconnect]

  if {$use_smartconnect == 0} {
    ad_connect sys_cpu_clk axi_cpu_interconnect/${i_str}_ACLK
    ad_connect sys_cpu_resetn axi_cpu_interconnect/${i_str}_ARESETN
  }
  if {$p_intf_clock ne ""} {
    ad_connect sys_cpu_clk ${p_intf_clock}
  }
  if {$p_intf_reset ne ""} {
    ad_connect sys_cpu_resetn ${p_intf_reset}
  }
  ad_connect axi_cpu_interconnect/${i_str}_AXI ${p_intf}

  set p_seg [get_bd_addr_segs -of [get_bd_addr_spaces -of [get_bd_intf_pins -filter "NAME=~ *${p_intf_name}*" -of $p_hier_cell]]]
  set p_index 0
  foreach p_seg_name $p_seg {
    if {$p_index == 0} {
      set p_seg_range [get_property range $p_seg_name]
      if {$p_seg_range < 0x1000} {
        set p_seg_range 0x1000
      }
      if {$sys_zynq == 3} {
        if {($p_address >= 0x44000000) && ($p_address <= 0x4fffffff)} {
          # place axi peripherics in A400_0000-AFFF_FFFF range
          set p_address [expr ($p_address + 0x60000000)]
        } elseif {($p_address >= 0x70000000) && ($p_address <= 0x7fffffff)} {
          # place axi peripherics in B000_0000-BFFF_FFFF range
          set p_address [expr ($p_address + 0x40000000)]
        } else {
          error "ERROR: ad_cpu_interconnect : Cannot map ($p_address) to aperture, \
                Addess out of range 0x4400_0000 - 0X4FFF_FFFF; 0x7000_0000 - 0X7FFF_FFFF !"
        }
      }
      if {$sys_zynq == 2} {
        if {($p_address >= 0x40000000) && ($p_address <= 0x4fffffff)} {
          set p_address [expr ($p_address + 0x40000000)]
        }
        if {($p_address >= 0x70000000) && ($p_address <= 0x7fffffff)} {
          set p_address [expr ($p_address + 0x20000000)]
        }
      }
      create_bd_addr_seg -range $p_seg_range \
        -offset $p_address $sys_addr_cntrl_space \
        $p_seg_name "SEG_data_${p_name}"
    } else {
      assign_bd_address $p_seg_name
    }
    incr p_index
  }
}

## Connects an IP interrupt port to the system's interrupt controller interface.
#
#  \param[p_ps_index] - interrupt index used in PSx based architecture
#  \param[p_mb_index] - interrupt index used in Microblaze based architecture
#  \param[p_name] - name of the interrupt port
#
proc ad_cpu_interrupt {p_ps_index p_mb_index p_name} {

  global sys_zynq

  if {$sys_zynq <= 0} {set p_index_int $p_mb_index}
  if {$sys_zynq >= 1} {set p_index_int $p_ps_index}

  set p_index [regsub -all {[^0-9]} $p_index_int ""]
  set m_index [expr ($p_index - 8)]

  if {$sys_zynq == 3} {
   if {$p_index < 0 || $p_index > 15} {
      error "ERROR: ad_cpu_interrupt : Interrupt index ($p_index) out of range 0-15 "
    }
    ad_connect $p_name sys_cips/pl_ps_irq$p_index
  }

  if {($sys_zynq == 2) && ($p_index <= 7)} {
    set p_net [get_bd_nets -of_objects [get_bd_pins sys_concat_intc_0/In$p_index]]
    set p_pin [get_bd_pins sys_concat_intc_0/In$p_index]

    puts "disconnect_bd_net $p_net $p_pin"
    disconnect_bd_net $p_net $p_pin
    ad_connect sys_concat_intc_0/In$p_index $p_name
  }

  if {($sys_zynq == 2) && ($p_index >= 8)} {
    set p_net [get_bd_nets -of_objects [get_bd_pins sys_concat_intc_1/In$m_index]]
    set p_pin [get_bd_pins sys_concat_intc_1/In$m_index]

    puts "disconnect_bd_net $p_net $p_pin"
    disconnect_bd_net $p_net $p_pin
    ad_connect sys_concat_intc_1/In$m_index $p_name
  }

  if {$sys_zynq <= 1} {

    set p_net [get_bd_nets -of_objects [get_bd_pins sys_concat_intc/In$p_index]]
    set p_pin [get_bd_pins sys_concat_intc/In$p_index]

    puts "disconnect_bd_net $p_net $p_pin"
    disconnect_bd_net $p_net $p_pin
    ad_connect sys_concat_intc/In$p_index $p_name
  }
}
