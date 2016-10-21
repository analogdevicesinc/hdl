
# keep interface-mess out of the way - keeping it pretty is a waste of time

proc ad_alt_intf {type name dir width {arg_1 ""} {arg_2 ""}} {

  if {([string equal -nocase ${type} "clock"]) && ([string equal -nocase ${dir} "input"])} {
    add_interface if_${name} clock sink
    add_interface_port if_${name} ${name} clk ${dir} ${width}
    return
  }

  if {([string equal -nocase ${type} "clock"]) && ([string equal -nocase ${dir} "output"])} {
    add_interface if_${name} clock source
    add_interface_port if_${name} ${name} clk ${dir} ${width}
    return
  }

  if {([string equal -nocase ${type} "reset"]) && ([string equal -nocase ${dir} "input"])} {
    add_interface if_${name} reset sink
    add_interface_port if_${name} ${name} reset ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  if {([string equal -nocase ${type} "reset"]) && ([string equal -nocase ${dir} "output"])} {
    add_interface if_${name} reset source
    add_interface_port if_${name} ${name} reset ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    set_interface_property if_${name} associatedResetSinks ${arg_2}
    return
  }

  if {([string equal -nocase ${type} "reset-n"]) && ([string equal -nocase ${dir} "input"])} {
    add_interface if_${name} reset sink
    add_interface_port if_${name} ${name} reset_n ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  if {([string equal -nocase ${type} "reset-n"]) && ([string equal -nocase ${dir} "output"])} {
    add_interface if_${name} reset source
    add_interface_port if_${name} ${name} reset_n ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    set_interface_property if_${name} associatedResetSinks ${arg_2}
    return
  }

  if {([string equal -nocase ${type} "intr"]) && ([string equal -nocase ${dir} "output"])} {
    add_interface if_${name} interrupt source
    add_interface_port if_${name} ${name} irq ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  set remap $arg_1
  if {$arg_1 eq ""} {
    set remap $name
  }

  if {[string equal -nocase ${type} "signal"]} {
    add_interface if_${name} conduit end
    add_interface_port if_${name} ${name} ${remap} ${dir} ${width}
    return
  }
}

proc ad_conduit {if_name if_port port dir width} {

  add_interface $if_name conduit end
  add_interface_port $if_name $port $if_port $dir $width
}

proc ad_generate_module_inst { inst_name mark source_file target_file } {

  set fp_source [open $source_file "r"]
  set fp_target [open $target_file "w+"]

  fconfigure $fp_source -buffering line

  while { [gets $fp_source data] >= 0 } {

    # update the required module name
    regsub $inst_name $data "&_$mark" data
    puts $data
    puts $fp_target $data
  }

  close $fp_source
  close $fp_target
}

