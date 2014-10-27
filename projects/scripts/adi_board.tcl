###################################################################################################
###################################################################################################

variable sys_zynq
variable sys_addr_cntrl_space
variable sys_cpu_interconnect_index
variable sys_hp0_interconnect_index
variable sys_hp1_interconnect_index
variable sys_hp2_interconnect_index
variable sys_hp3_interconnect_index
variable sys_mem_interconnect_index
variable sys_interrupts_n
variable sys_interrupts_q

###################################################################################################
###################################################################################################

set sys_cpu_interconnect_index 0
set sys_hp0_interconnect_index -1
set sys_hp1_interconnect_index -1
set sys_hp2_interconnect_index -1
set sys_hp3_interconnect_index -1
set sys_mem_interconnect_index -1
set sys_interrupts_n 0

###################################################################################################
###################################################################################################

proc ad_connect_type {p_name} {

  set m_name ""

  if {$m_name eq ""} {set m_name [get_bd_nets       -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_pins       -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_ports      -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_intf_nets  -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_intf_pins  -quiet $p_name]}
  if {$m_name eq ""} {set m_name [get_bd_intf_ports -quiet $p_name]}

  return $m_name
}

proc ad_connect {p_name_1 p_name_2} {

  set m_name_1 [ad_connect_type $p_name_1]
  set m_name_2 [ad_connect_type $p_name_2]

  if {[get_property CLASS $m_name_1] eq "bd_intf_pin"} {
    connect_bd_intf_net $m_name_1 $m_name_2
    return
  }

  if {[get_property CLASS $m_name_1] eq "bd_pin"} {
    connect_bd_net $m_name_1 $m_name_2
    return
  }

  if {[get_property CLASS $m_name_1] eq "bd_net"} {
    set m_source_1 [filter [get_bd_pins -of_objects [get_bd_nets $m_name_1]] -regexp "DIR == O"]
    connect_bd_net -net $m_name_1 $m_name_2 $m_source_1
    return
  }
}

###################################################################################################
###################################################################################################

proc ad_mem_interconnect {p_clk p_name} {

  ad_mem_interconnect_int "MEM" $p_clk $p_name
}

proc ad_hp0_interconnect {p_clk p_name} {

  ad_mem_interconnect_int "HP0" $p_clk $p_name
}

proc ad_hp1_interconnect {p_clk p_name} {

  ad_mem_interconnect_int "HP1" $p_clk $p_name
}

proc ad_hp2_interconnect {p_clk p_name} {

  ad_mem_interconnect_int "HP2" $p_clk $p_name
}

proc ad_hp3_interconnect {p_name p_clk} {

  ad_mem_interconnect_int "HP3" $p_clk $p_name
}

###################################################################################################
###################################################################################################

proc ad_mem_interconnect_int {p_sel p_clk p_name} {

  global sys_zynq
  global sys_hp0_interconnect_index
  global sys_hp1_interconnect_index
  global sys_hp2_interconnect_index
  global sys_hp3_interconnect_index
  global sys_mem_interconnect_index

  set p_intf_name [lrange [split $p_name "/"] end end]
  set p_cell_name [lrange [split $p_name "/"] 0 0]
  set p_intf_clock [filter [get_bd_pins -quiet -of_objects [get_bd_cells $p_cell_name]] \
    -regexp "CONFIG.ASSOCIATED_BUSIF == ${p_intf_name}"]

  if {($p_sel eq "HP0") && ($sys_zynq == 1)} {
    if {$sys_hp0_interconnect_index == 0} {
    }
  }


  if {($p_sel eq "MEM") && ($sys_zynq == 1)} {

    set i_str "S$sys_mem_interconnect_index"
    if {$sys_mem_interconnect_index < 10} {
      set i_str "S0$sys_mem_interconnect_index"
    }

    if {$sys_mem_interconnect_index == -1} {
      ad_connect sys_cpu_resetn axi_mem_interconnect/ARESETN
      ad_connect $p_clk axi_mem_interconnect/ACLK
      ad_connect sys_cpu_resetn axi_mem_interconnect/M00_ARESETN
      ad_connect $p_clk axi_mem_interconnect/M00_ACLK
      ad_connect axi_mem_interconnect/M00_AXI $p_name
    } else {
      ad_connect sys_cpu_resetn axi_mem_interconnect/${i_str}_ARESETN
      ad_connect $p_clk axi_mem_interconnect/${i_str}_ACLK
      ad_connect axi_mem_interconnect/${i_str}_AXI $p_name
      ad_connect $p_clk $p_intf_clock
    }

    set sys_mem_interconnect_index [expr $sys_mem_interconnect_index + 1]
  }
}

###################################################################################################
###################################################################################################

proc ad_cpu_interconnect {p_address p_name} {

  global sys_zynq
  global sys_addr_cntrl_space
  global sys_cpu_interconnect_index

  set i_str "M$sys_cpu_interconnect_index"
  if {$sys_cpu_interconnect_index < 10} {
    set i_str "M0$sys_cpu_interconnect_index"
  }

  if {($sys_cpu_interconnect_index == 0) && ($sys_zynq == 1)} {
    ad_connect sys_cpu_clk sys_ps7/M_AXI_GP0_ACLK
    ad_connect sys_cpu_clk axi_cpu_interconnect/ACLK
    ad_connect sys_cpu_clk axi_cpu_interconnect/S00_ACLK
    ad_connect sys_cpu_resetn axi_cpu_interconnect/ARESETN
    ad_connect sys_cpu_resetn axi_cpu_interconnect/S00_ARESETN
    ad_connect axi_cpu_interconnect/S00_AXI sys_ps7/M_AXI_GP0
  }

  if {($sys_cpu_interconnect_index == 0) && ($sys_zynq == 0)} {
    ad_connect sys_cpu_clk axi_cpu_interconnect/ACLK
    ad_connect sys_cpu_clk axi_cpu_interconnect/S00_ACLK
    ad_connect sys_cpu_resetn axi_cpu_interconnect/ARESETN
    ad_connect sys_cpu_resetn axi_cpu_interconnect/S00_ARESETN
    ad_connect axi_cpu_interconnect/S00_AXI sys_mb/M_AXI_DP
  }

  set sys_cpu_interconnect_index [expr $sys_cpu_interconnect_index + 1]
  set p_intf [filter [get_bd_intf_pins -of_objects [get_bd_cells $p_name]] \
    -regexp "MODE == Slave && VLNV == xilinx.com:interface:aximm_rtl:1.0"]
  set p_intf_name [lrange [split $p_intf "/"] end end]
  set p_intf_clock [filter [get_bd_pins -quiet -of_objects [get_bd_cells $p_name]] \
    -regexp "CONFIG.ASSOCIATED_BUSIF == ${p_intf_name}"]
  set p_intf_reset [get_property CONFIG.ASSOCIATED_RESET [get_bd_pins ${p_intf_clock}]]

  set_property CONFIG.NUM_MI $sys_cpu_interconnect_index [get_bd_cells axi_cpu_interconnect]

  ad_connect sys_cpu_clk axi_cpu_interconnect/${i_str}_ACLK
  ad_connect sys_cpu_clk ${p_intf_clock}
  ad_connect sys_cpu_resetn axi_cpu_interconnect/${i_str}_ARESETN
  ad_connect sys_cpu_resetn ${p_name}/${p_intf_reset}
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

proc ad_cpu_interrupt {p_index p_name} {

  global sys_interrupts_n
  global sys_interrupts_q

  set i_str "In$p_index"

  if {$p_index >= $sys_interrupts_n} {
    set sys_interrupts_n [expr $p_index + 1]
    set_property CONFIG.NUM_PORTS $sys_interrupts_n [get_bd_cells sys_concat_intc]
  }

  set sys_interrupts_q($p_index) $p_name
  set p_intr [filter [get_bd_pins -quiet -of_objects [get_bd_cells $p_name]] \
    -regexp "TYPE == intr"]

  connect_bd_net -net "${p_name}_intr" \
    [get_bd_pins sys_concat_intc/${i_str}] \
    [get_bd_pins ${p_intr}]
}

proc ad_cpu_interrupt_update {} {

  global sys_zynq
  global sys_interrupts_n
  global sys_interrupts_q

  if {$sys_zynq == 1} {
    connect_bd_net -net sys_cpu_interrupt \
      [get_bd_pins sys_concat_intc/dout] \
      [get_bd_pins sys_ps7/IRQ_F2P]
  } else {
    connect_bd_net -net sys_cpu_interrupt \
      [get_bd_pins sys_concat_intc/dout] \
      [get_bd_pins axi_intc/intr]
  }

  for {set p_index 0} {$p_index < $sys_interrupts_n} {incr p_index} {
    if {![info exists sys_interrupts_q($p_index)]} {
      set i_str "In$p_index"
      set o_str "unc_intr_$p_index"
      create_bd_port -dir I ${o_str}
      connect_bd_net -net ${o_str} \
        [get_bd_pins sys_concat_intc/${i_str}] \
        [get_bd_ports ${o_str}]
    }
  }
}

###################################################################################################
###################################################################################################

