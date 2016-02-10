
# keep interface-mess out of the way - keeping it pretty is a waste of time

proc ad_alt_intf {type name dir width {arg_1 ""} {arg_2 ""}} {

  if {(($type eq "clock") && ($dir eq "input"))} {
    add_interface if_${name} clock sink
    add_interface_port if_${name} ${name} clk ${dir} ${width}
    return
  }

  if {(($type eq "clock") && ($dir eq "output"))} {
    add_interface if_${name} clock source
    add_interface_port if_${name} ${name} clk ${dir} ${width}
    return
  }

  if {(($type eq "reset") && ($dir eq "input"))} {
    add_interface if_${name} reset sink
    add_interface_port if_${name} ${name} reset ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  if {(($type eq "reset") && ($dir eq "output"))} {
    add_interface if_${name} reset source
    add_interface_port if_${name} ${name} reset ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    set_interface_property if_${name} associatedResetSinks ${arg_2}
    return
  }

  if {(($type eq "reset-n") && ($dir eq "input"))} {
    add_interface if_${name} reset sink
    add_interface_port if_${name} ${name} reset_n ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  if {(($type eq "reset-n") && ($dir eq "output"))} {
    add_interface if_${name} reset source
    add_interface_port if_${name} ${name} reset_n ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    set_interface_property if_${name} associatedResetSinks ${arg_2}
    return
  }

  if {(($type eq "intr") && ($dir eq "output"))} {
    add_interface if_${name} interrupt source
    add_interface_port if_${name} ${name} irq ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  set remap $arg_1
  if {$arg_1 eq ""} {
    set remap $name
  }

  if {$type eq "signal"} {
    add_interface if_${name} conduit end
    add_interface_port if_${name} ${name} ${remap} ${dir} ${width}
    return
  }
}

