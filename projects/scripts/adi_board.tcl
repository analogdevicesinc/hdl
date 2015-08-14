###################################################################################################
###################################################################################################

variable sys_cpu_interconnect_index
variable sys_hp0_interconnect_index
variable sys_hp1_interconnect_index
variable sys_hp2_interconnect_index
variable sys_hp3_interconnect_index
variable sys_mem_interconnect_index

###################################################################################################
###################################################################################################

set sys_cpu_interconnect_index 0
set sys_hp0_interconnect_index -1
set sys_hp1_interconnect_index -1
set sys_hp2_interconnect_index -1
set sys_hp3_interconnect_index -1
set sys_mem_interconnect_index -1

###################################################################################################
###################################################################################################

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

proc ad_connect {p_name_1 p_name_2} {

  if {($p_name_2 eq "GND") || ($p_name_2 eq "VCC")} {
    set p_size 1
    set p_msb [get_property left [get_bd_pins $p_name_1]]
    set p_lsb [get_property right [get_bd_pins $p_name_1]]
    if {($p_msb ne "") && ($p_lsb ne "")} {
      set p_size [expr (($p_msb + 1) - $p_lsb)]
    }
    set p_cell_name [regsub -all {/} $p_name_1 "_"]
    set p_cell_name "${p_cell_name}_${p_name_2}"
    if {$p_name_2 eq "VCC"} {
      set p_value -1
    } else {
      set p_value 0
    }
    puts "create_bd_cell(xlconstant) size($p_size) value($p_value) name($p_cell_name)"
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 $p_cell_name
    set_property CONFIG.CONST_WIDTH $p_size [get_bd_cells $p_cell_name]
    set_property CONFIG.CONST_VAL $p_value [get_bd_cells $p_cell_name]
    puts "connect_bd_net $p_cell_name/dout $p_name_1"
    connect_bd_net [get_bd_pins $p_cell_name/dout] [get_bd_pins $p_name_1]
    return
  }

  set m_name_1 [ad_connect_type $p_name_1]
  set m_name_2 [ad_connect_type $p_name_2]

  if {$m_name_1 eq ""} {
    if {[get_property CLASS $m_name_2] eq "bd_intf_pin"} {
      puts "create_bd_intf_net $p_name_1"
      create_bd_intf_net $p_name_1
    }
    if {[get_property CLASS $m_name_2] eq "bd_pin"} {
      puts "create_bd_net $p_name_1"
      create_bd_net $p_name_1
    }
    set m_name_1 [ad_connect_type $p_name_1]
  }

  if {[get_property CLASS $m_name_1] eq "bd_intf_pin"} {
    puts "connect_bd_intf_net $m_name_1 $m_name_2"
    connect_bd_intf_net $m_name_1 $m_name_2
    return
  }

  if {[get_property CLASS $m_name_1] eq "bd_pin"} {
    puts "connect_bd_net $m_name_1 $m_name_2"
    connect_bd_net $m_name_1 $m_name_2
    return
  }

  if {[get_property CLASS $m_name_1] eq "bd_net"} {
    puts "connect_bd_net -net $m_name_1 $m_name_2"
    connect_bd_net -net $m_name_1 $m_name_2
    return
  }
}

###################################################################################################
###################################################################################################

proc ad_mem_hp0_interconnect {p_clk p_name} {

  global sys_zynq

  if {($sys_zynq == 0) && ($p_name eq "sys_ps7/S_AXI_HP0")} {return}
  if {$sys_zynq == 0} {ad_mem_hpx_interconnect "MEM" $p_clk $p_name}
  if {$sys_zynq == 1} {ad_mem_hpx_interconnect "HP0" $p_clk $p_name}
}

proc ad_mem_hp1_interconnect {p_clk p_name} {

  global sys_zynq

  if {($sys_zynq == 0) && ($p_name eq "sys_ps7/S_AXI_HP1")} {return}
  if {$sys_zynq == 0} {ad_mem_hpx_interconnect "MEM" $p_clk $p_name}
  if {$sys_zynq == 1} {ad_mem_hpx_interconnect "HP1" $p_clk $p_name}
}

proc ad_mem_hp2_interconnect {p_clk p_name} {

  global sys_zynq

  if {($sys_zynq == 0) && ($p_name eq "sys_ps7/S_AXI_HP2")} {return}
  if {$sys_zynq == 0} {ad_mem_hpx_interconnect "MEM" $p_clk $p_name}
  if {$sys_zynq == 1} {ad_mem_hpx_interconnect "HP2" $p_clk $p_name}
}

proc ad_mem_hp3_interconnect {p_clk p_name} {

  global sys_zynq

  if {($sys_zynq == 0) && ($p_name eq "sys_ps7/S_AXI_HP3")} {return}
  if {$sys_zynq == 0} {ad_mem_hpx_interconnect "MEM" $p_clk $p_name}
  if {$sys_zynq == 1} {ad_mem_hpx_interconnect "HP3" $p_clk $p_name}
}

###################################################################################################
###################################################################################################

proc ad_mem_hpx_interconnect {p_sel p_clk p_name} {

  global sys_zynq
  global sys_ddr_addr_seg
  global sys_hp0_interconnect_index
  global sys_hp1_interconnect_index
  global sys_hp2_interconnect_index
  global sys_hp3_interconnect_index
  global sys_mem_interconnect_index

  set p_clk_source [get_bd_pins -filter {DIR == O} -of_objects [get_bd_nets $p_clk]]

  if {$p_sel eq "MEM"} {
    if {$sys_mem_interconnect_index < 0} {
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_interconnect
    }
    set m_interconnect_index $sys_mem_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_mem_interconnect]
    set m_addr_seg [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl]]
  }

  if {$p_sel eq "HP0"} {
    if {$sys_hp0_interconnect_index < 0} {
      set_property CONFIG.PCW_USE_S_AXI_HP0 {1} [get_bd_cells sys_ps7]
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hp0_interconnect
    }
    set m_interconnect_index $sys_hp0_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp0_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps7/S_AXI_HP0/HP0_DDR_LOWOCM]
  }

  if {$p_sel eq "HP1"} {
    if {$sys_hp1_interconnect_index < 0} {
      set_property CONFIG.PCW_USE_S_AXI_HP1 {1} [get_bd_cells sys_ps7]
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hp1_interconnect
    }
    set m_interconnect_index $sys_hp1_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp1_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM]
  }

  if {$p_sel eq "HP2"} {
    if {$sys_hp2_interconnect_index < 0} {
      set_property CONFIG.PCW_USE_S_AXI_HP2 {1} [get_bd_cells sys_ps7]
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hp2_interconnect
    }
    set m_interconnect_index $sys_hp2_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp2_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM]
  }

  if {$p_sel eq "HP3"} {
    if {$sys_hp3_interconnect_index < 0} {
      set_property CONFIG.PCW_USE_S_AXI_HP3 {1} [get_bd_cells sys_ps7]
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hp3_interconnect
    }
    set m_interconnect_index $sys_hp3_interconnect_index
    set m_interconnect_cell [get_bd_cells axi_hp3_interconnect]
    set m_addr_seg [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM]
  }

  set i_str "S$m_interconnect_index"
  if {$m_interconnect_index < 10} {
    set i_str "S0$m_interconnect_index"
  }

  set m_interconnect_index [expr $m_interconnect_index + 1]

  set p_intf_name [lrange [split $p_name "/"] end end]
  set p_cell_name [lrange [split $p_name "/"] 0 0]
  set p_intf_clock [get_bd_pins -filter "TYPE == clk && (CONFIG.ASSOCIATED_BUSIF == ${p_intf_name} || \
    CONFIG.ASSOCIATED_BUSIF =~ ${p_intf_name}:* || CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name} || \
    CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name}:*)" -quiet -of_objects [get_bd_cells $p_cell_name]]
  if {[find_bd_objs -quiet -relation connected_to $p_intf_clock] ne "" ||
      $p_intf_clock eq $p_clk_source} {
    set p_intf_clock ""
  }

  if {$m_interconnect_index == 0} {
    set_property CONFIG.NUM_MI 1 $m_interconnect_cell
    set_property CONFIG.NUM_SI 1 $m_interconnect_cell
    ad_connect sys_cpu_resetn $m_interconnect_cell/ARESETN
    ad_connect $p_clk $m_interconnect_cell/ACLK
    ad_connect sys_cpu_resetn $m_interconnect_cell/M00_ARESETN
    ad_connect $p_clk $m_interconnect_cell/M00_ACLK
    ad_connect $m_interconnect_cell/M00_AXI $p_name
    if {$p_intf_clock ne ""} {
      ad_connect $p_clk $p_intf_clock
    }
  } else {
    set_property CONFIG.NUM_SI $m_interconnect_index $m_interconnect_cell
    ad_connect sys_cpu_resetn $m_interconnect_cell/${i_str}_ARESETN
    ad_connect $p_clk $m_interconnect_cell/${i_str}_ACLK
    ad_connect $m_interconnect_cell/${i_str}_AXI $p_name
    if {$p_intf_clock ne ""} {
      ad_connect $p_clk $p_intf_clock
    }
    assign_bd_address $m_addr_seg
  }

  if {$m_interconnect_index == 3} {
    set_property CONFIG.STRATEGY {2} $m_interconnect_cell
  }

  if {$p_sel eq "MEM"} {set sys_mem_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HP0"} {set sys_hp0_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HP1"} {set sys_hp1_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HP2"} {set sys_hp2_interconnect_index $m_interconnect_index}
  if {$p_sel eq "HP3"} {set sys_hp3_interconnect_index $m_interconnect_index}
}

###################################################################################################
###################################################################################################

proc ad_cpu_interconnect {p_address p_name} {

  global sys_zynq
  global sys_cpu_interconnect_index

  set i_str "M$sys_cpu_interconnect_index"
  if {$sys_cpu_interconnect_index < 10} {
    set i_str "M0$sys_cpu_interconnect_index"
  }

  if {$sys_cpu_interconnect_index == 0} {
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect
    if {$sys_zynq == 1} {
      ad_connect sys_cpu_clk sys_ps7/M_AXI_GP0_ACLK
      ad_connect sys_cpu_clk axi_cpu_interconnect/ACLK
      ad_connect sys_cpu_clk axi_cpu_interconnect/S00_ACLK
      ad_connect sys_cpu_resetn axi_cpu_interconnect/ARESETN
      ad_connect sys_cpu_resetn axi_cpu_interconnect/S00_ARESETN
      ad_connect axi_cpu_interconnect/S00_AXI sys_ps7/M_AXI_GP0
    } else {
      ad_connect sys_cpu_clk axi_cpu_interconnect/ACLK
      ad_connect sys_cpu_clk axi_cpu_interconnect/S00_ACLK
      ad_connect sys_cpu_resetn axi_cpu_interconnect/ARESETN
      ad_connect sys_cpu_resetn axi_cpu_interconnect/S00_ARESETN
      ad_connect axi_cpu_interconnect/S00_AXI sys_mb/M_AXI_DP
    }
  }

  if {$sys_zynq == 1} {
    set sys_addr_cntrl_space [get_bd_addr_spaces sys_ps7/Data]
  } else {
    set sys_addr_cntrl_space [get_bd_addr_spaces sys_mb/Data]
  }

  set sys_cpu_interconnect_index [expr $sys_cpu_interconnect_index + 1]
  set p_intf [get_bd_intf_pins -filter "MODE == Slave && VLNV == xilinx.com:interface:aximm_rtl:1.0"\
    -of_objects [get_bd_cells $p_name]]
  set p_intf_name [lrange [split $p_intf "/"] end end]
  set p_intf_clock [get_bd_pins -filter "TYPE == clk && (CONFIG.ASSOCIATED_BUSIF == ${p_intf_name} || \
    CONFIG.ASSOCIATED_BUSIF =~ ${p_intf_name}:* || CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name} || \
    CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name}:*)" -quiet -of_objects [get_bd_cells $p_name]]
  set p_intf_reset [get_bd_pins -filter "TYPE == rst && (CONFIG.ASSOCIATED_BUSIF == ${p_intf_name} || \
    CONFIG.ASSOCIATED_BUSIF =~ ${p_intf_name}:* || CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name} || \
    CONFIG.ASSOCIATED_BUSIF =~ *:${p_intf_name}:*)" -quiet -of_objects [get_bd_cells $p_name]]
  if {($p_intf_clock ne "") && ($p_intf_reset eq "")} {
    set p_intf_reset [get_property CONFIG.ASSOCIATED_RESET [get_bd_pins ${p_intf_clock}]]
    if {$p_intf_reset ne ""} {
      set p_intf_reset [get_bd_pins $p_name/$p_intf_reset]
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

  ad_connect sys_cpu_clk axi_cpu_interconnect/${i_str}_ACLK
  if {$p_intf_clock ne ""} {
    ad_connect sys_cpu_clk ${p_intf_clock}
  }
  ad_connect sys_cpu_resetn axi_cpu_interconnect/${i_str}_ARESETN
  if {$p_intf_reset ne ""} {
    ad_connect sys_cpu_resetn ${p_intf_reset}
  }
  ad_connect axi_cpu_interconnect/${i_str}_AXI ${p_intf}

  set p_seg [get_bd_addr_segs -of_objects [get_bd_cells $p_name]]
  set p_index 0
  foreach p_seg_name $p_seg {
    if {$p_index == 0} {
      set p_seg_range [get_property range $p_seg_name]
      create_bd_addr_seg -range $p_seg_range \
        -offset $p_address $sys_addr_cntrl_space \
        $p_seg_name "SEG_data_${p_name}"
    } else {
      assign_bd_address $p_seg_name
    }
    incr p_index
  }
}

###################################################################################################
###################################################################################################

proc ad_cpu_interrupt {p_ps_index p_mb_index p_name} {

  global sys_zynq

  if {$sys_zynq == 1} {
    set p_index [regsub -all {[^0-9]} $p_ps_index ""]
  } else {
    set p_index [regsub -all {[^0-9]} $p_mb_index ""]
  }

  set p_net [get_bd_nets -of_objects [get_bd_pins sys_concat_intc/In$p_index]] 
  set p_pin [find_bd_objs -relation connected_to [get_bd_pins sys_concat_intc/In$p_index]]

  puts "delete_bd_objs $p_net $p_pin"
  delete_bd_objs $p_net $p_pin
  ad_connect sys_concat_intc/In$p_index $p_name
}

###################################################################################################
###################################################################################################

