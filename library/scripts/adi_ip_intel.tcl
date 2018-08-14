
## Define an interface for Platform Designer.
#
# \param[type] - Type of the interface, valid values are : clock, reset, reset-n,
# signal, intr
# \param[name] - The name of the interface
# \param[dir] - The direction of the interface
# \param[width] - The width of the interface
# \param[arg_1] - Optional argument to define the associated clock for a reset
# interface
# \param[arg_2] - Optional argument to define the associated reset sink for a
# reset interface
#
proc ad_interface {type name dir width {arg_1 ""} {arg_2 ""}} {

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

## Create a point-to-point conduit interface.
#
# \param[if_name] - the name of the interface
# \param[if_port] - the type of signal for this port, which must be unique
# \param[port] - the name of the port, this name must match the signal name
# in HDL
# \param[dir] - the direction of the signal, expected values: input/output/bidir
# \param[width] - the width of the port, in bits
#
proc ad_conduit {if_name if_port port dir width} {

  add_interface $if_name conduit end
  add_interface_port $if_name $port $if_port $dir $width
}

## Create an IP.
#
# \param[pname] - name of the IP, general equivalent to the top HDL module name
# \param[pdisplay_name] - displayed name
# \param[pelabfunction] - name of the elaboration callback function
# \param[pcomposefunction] - name of the composition callback function
#
proc ad_ip_create {pname pdisplay_name {pelabfunction ""} {pcomposefunction ""}} {

  set_module_property NAME $pname
  set_module_property DISPLAY_NAME $pdisplay_name
  set_module_property DESCRIPTION $pdisplay_name
  set_module_property VERSION 1.0
  set_module_property GROUP "Analog Devices"

  if {$pelabfunction ne ""} {
    set_module_property ELABORATION_CALLBACK $pelabfunction
  }

  if {$pcomposefunction ne ""} {
    set_module_property COMPOSITION_CALLBACK $pcomposefunction
  }
}

## Create an IP parameter.
#
# \param[pname] - name of the IP, general equivalent to the top HDL module name
# \param[ptype] - the data type of the parameter
# \param[pdefault] - the initial value of the parameter
# \param[phdl] - define if the parameter is an HDL parameter or not
# \param[properties] - can define different properties for the parameter, must be
# a list of {key, value} pairs
#
proc ad_ip_parameter {pname ptype pdefault {phdl true} {properties {}}} {

  if {$pname eq "DEVICE_FAMILY"} {
    add_parameter DEVICE_FAMILY STRING
    set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
    set_parameter_property DEVICE_FAMILY AFFECTS_GENERATION true
    set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
    set_parameter_property DEVICE_FAMILY ENABLED true
  } else {
    add_parameter $pname $ptype $pdefault
    set_parameter_property $pname HDL_PARAMETER $phdl
    set_parameter_property $pname ENABLED true
  }

  foreach {key value} $properties {
    set_parameter_property $pname $key $value
  }
}

## Adds the generic ADI spec parameters to the current IP, with the help of
#  adi_add_device_spec_param. The spec parameter list is auto_gen_param_list,
#  from library/scripts/adi_intel_device_info_enc.tcl.
#
proc adi_add_auto_fpga_spec_params {} {

    global ad_hdl_dir
    source $ad_hdl_dir/library/scripts/adi_intel_device_info_enc.tcl

    ad_ip_parameter DEVICE STRING "" false {
      SYSTEM_INFO DEVICE
      VISIBLE false
    }

    foreach p $auto_gen_param_list {
      adi_add_device_spec_param $p
    }
}

## Generate validation properties for a parameter, using predefined ranges or
#  set of values (the definition of the ranges can be found in
#  library/scripts/adi_intel_device_info_enc.tcl).
#
#  In Intel callback flow, one cannot directly change a parameter value, the value
#  can only be calculated/deduced from the environment.
#  Adding a second parameter with the same name followed by "_MANUAL", will add
#  in the environment the desired value that is still constrained to a predefined
#  set. Having the second parameter is not enough, to activate the manual
#  overwriting of a parameter one must call the adi_add_indep_spec_params_overwrite
#  process.
#
# \param[param] - Name of the HDL parameter. The list of accepted values for
#  the parameter are defined with the same name as the parameter's one(lower case),
#  followed by "_list"
#
proc adi_add_device_spec_param {param} {

    global auto_gen_param_list
    global auto_set_param_list
    global fpga_technology_list
    global fpga_family_list
    global speed_grade_list
    global dev_package_list
    global xcvr_type_list
    global fpga_voltage_list

    set group "FPGA info"

    set list_pointer [string tolower $param]
    set list_pointer [append list_pointer "_list"]

    set enc_list [subst $$list_pointer]

    set ranges ""

    add_parameter $param INTEGER
    set_parameter_property $param DISPLAY_NAME $param
    set_parameter_property $param GROUP $group
    set_parameter_property $param UNITS None
    set_parameter_property $param HDL_PARAMETER true
    set_parameter_property $param VISIBLE true
    set_parameter_property $param DERIVED true

    add_parameter ${param}_MANUAL INTEGER
    set_parameter_property ${param}_MANUAL DISPLAY_NAME $param
    set_parameter_property ${param}_MANUAL GROUP $group
    set_parameter_property ${param}_MANUAL UNITS None
    set_parameter_property ${param}_MANUAL HDL_PARAMETER false
    set_parameter_property ${param}_MANUAL VISIBLE false
    set_parameter_property ${param}_MANUAL DEFAULT_VALUE [lindex $enc_list 0 1]

    foreach i $enc_list {
     set value [lindex $i 0]
     set encode [lindex $i 1]
     append ranges "\"$encode\:$value\" "
    }
    set_parameter_property $param ALLOWED_RANGES $ranges
    set_parameter_property ${param}_MANUAL ALLOWED_RANGES $ranges
}

## Creates a boolean type parameter that allows this user to manually overwrite
#  parameter values.
#
# \param[param] - Name of the HDL parameter.
#
proc adi_add_indep_spec_params_overwrite {param} {
    add_parameter ${param}_USER_OVERWRITE BOOLEAN 0
    set_parameter_property ${param}_USER_OVERWRITE DISPLAY_NAME "Manually overwrite $param parameter"
    set_parameter_property ${param}_USER_OVERWRITE HDL_PARAMETER false
    set_parameter_property ${param}_USER_OVERWRITE GROUP {FPGA info}
}

## In this process the IP parameters are compared against predefined parameter lists
#  in library/scripts/adi_intel_device_info_enc.tcl. For the matching parameters,
#  a search is started after a pair *_USER_OVERWRITE(boolean) parameter. If the pair
#  *_USER_OVERWRITE parameter is found, and its value is true, the target parameter
#  will take the value of the *_MANUAL parameter. The GUI parameter is set as
#  writable in the qsys GUI (${parameter_name} is replaced by ${parameter_name}_MANUAL).
#
proc info_param_validate {} {
  global ad_hdl_dir
  global fpga_technology
  global fpga_family
  global speed_grade
  global dev_package
  global xcvr_type
  global fpga_voltage

  source $ad_hdl_dir/library/scripts/adi_intel_device_info_enc.tcl

  set device [get_parameter_value DEVICE]
  set auto_populate true ;# for future code dev

  set all_ip_param_list [get_parameters]
  set validate_list ""
  set independent_overwrite_list ""
  foreach param $all_ip_param_list {
    foreach elem [concat $auto_gen_param_list $auto_set_param_list] {
      if { "$elem" == "$param" } {
        append validate_list "$param "
      }
      if { [regexp ${elem}_USER_OVERWRITE $param] } {
        append independent_overwrite_list "$elem "
      }
    }
  }

  set indep_overwrite [expr {[llength $independent_overwrite_list] != 0} ? 1 : 0]

  if { $auto_populate == true } {

    get_part_param ;# in adi_intel_device_info_enc.tcl

    # point parameters and assign
    foreach param $validate_list {
      set ls_param [string tolower $param]
      set list_pointer $ls_param
      append list_pointer "_list"
      set pointer_to_sys_val [subst $$ls_param]   ;# e.g., $fpga_technology
      set enc_list_pointer [subst $$list_pointer] ;# e.g., $fpga_technology_list

      # get_part_info returns '{'#value'}'
      regsub -all "{" $pointer_to_sys_val "" pointer_to_sys_val
      regsub -all "}" $pointer_to_sys_val "" pointer_to_sys_val

      # the list defines a range or pairs of values
      set get_list_correspondence 1
      if { [llength $enc_list_pointer] != 0 } {
        if { [llength $enc_list_pointer] == 2 } {
          if { [llength [lindex $enc_list_pointer 0]] == 1 } {
            set get_list_correspondence 0
          }
        }
      } else {
        send_message ERROR "No list $list_pointer defined in adi_intel_device_info_enc.tcl for parameter $param"
      }

      # auto assign parameter value
      if { $get_list_correspondence } {
        set matched ""
        foreach i $enc_list_pointer {
          if { [regexp ^[lindex $i 0] $pointer_to_sys_val] } {
            set matched [lindex $i 1]
          }
        }
        if { $matched == "" } {
          send_message ERROR "Unknown or undefined(adi_intel_device_info_enc.tcl) $param \"$pointer_to_sys_val\" form \"$device\" device"
        } else {
          set_parameter_value $param $matched
        }
      } else {
          set_parameter_value $param $pointer_to_sys_val
      }
    }
  } else {
    foreach p $validate_list {
      set_parameter_value $p [get_parameter_value ${p}_MANUAL]
    }
  }

  # display manual(writable) or auto(non-writable) parameters
  foreach p $validate_list {
    set_parameter_property ${p}_MANUAL VISIBLE [expr $auto_populate ? false : true]
    set_parameter_property $p VISIBLE $auto_populate
    if { $indep_overwrite == 1 } {
      foreach p_overwrite $independent_overwrite_list {
        if { $p == $p_overwrite } {
          set p_over_val [get_parameter_value ${p}_USER_OVERWRITE]
          # set the hdl parameter with the independent manual overwritten value
          if { $p_over_val } {
            set_parameter_value $p [get_parameter_value ${p}_MANUAL]
            set_parameter_property ${p}_MANUAL VISIBLE $p_over_val
            set_parameter_property $p VISIBLE [expr $p_over_val ? false : true]
          }
        }
      }
    }
  }
}

## Add source files to an IP, automatically find the file type using its extension.
#
# \param[pname] - name of the IP, general equivalent to the top HDL module name
# \param[pfile] - name of the file
#
proc ad_ip_addfile {pname pfile} {

  set pmodule [file tail $pfile]

  regsub {\..$} $pmodule {} mname
  if {$pname eq $mname} {
    add_fileset_file $pmodule VERILOG PATH $pfile TOP_LEVEL_FILE
    return
  }

  set ptype [file extension $pfile]
  if {$ptype eq ".v"} {
    add_fileset_file $pmodule VERILOG PATH $pfile
    return
  }
  if {$ptype eq ".vh"} {
    add_fileset_file $pmodule VERILOG_INCLUDE PATH $pfile
    return
  }
  if {$ptype eq ".sdc"} {
    add_fileset_file $pmodule SDC PATH $pfile
    return
  }
  if {$ptype eq ".tcl"} {
    add_fileset_file $pmodule OTHER PATH $pfile
    return
  }
}

## Add source files to an IP, automatically find the file type using its extension.
#
# \param[pname] - name of the IP, general equivalent to the top HDL module name
# \param[pfile] - name of the file
#
proc ad_ip_files {pname pfiles {pfunction ""}} {

  add_fileset quartus_synth QUARTUS_SYNTH $pfunction ""
  set_fileset_property quartus_synth TOP_LEVEL $pname
  foreach pfile $pfiles {
    ad_ip_addfile $pname $pfile
  }

  add_fileset quartus_sim SIM_VERILOG $pfunction ""
  set_fileset_property quartus_sim TOP_LEVEL $pname
  foreach pfile $pfiles {
    ad_ip_addfile $pname $pfile
  }
}

## Infer an AXI4 Lite memory mapped interface.
#
# \param[aclk] - name of the interface clock
# \param[arstn] - name fo the interface reset
# \param[addr_width] - address width of the read and write channels
#
proc ad_ip_intf_s_axi {aclk arstn {addr_width 16}} {

  add_interface s_axi_clock clock end
  add_interface_port s_axi_clock ${aclk} clk Input 1

  add_interface s_axi_reset reset end
  set_interface_property s_axi_reset associatedClock s_axi_clock
  add_interface_port s_axi_reset ${arstn} reset_n Input 1

  add_interface s_axi axi4lite end
  set_interface_property s_axi associatedClock s_axi_clock
  set_interface_property s_axi associatedReset s_axi_reset
  add_interface_port s_axi s_axi_awvalid awvalid Input 1
  add_interface_port s_axi s_axi_awaddr awaddr Input $addr_width
  add_interface_port s_axi s_axi_awprot awprot Input 3
  add_interface_port s_axi s_axi_awready awready Output 1
  add_interface_port s_axi s_axi_wvalid wvalid Input 1
  add_interface_port s_axi s_axi_wdata wdata Input 32
  add_interface_port s_axi s_axi_wstrb wstrb Input 4
  add_interface_port s_axi s_axi_wready wready Output 1
  add_interface_port s_axi s_axi_bvalid bvalid Output 1
  add_interface_port s_axi s_axi_bresp bresp Output 2
  add_interface_port s_axi s_axi_bready bready Input 1
  add_interface_port s_axi s_axi_arvalid arvalid Input 1
  add_interface_port s_axi s_axi_araddr araddr Input $addr_width
  add_interface_port s_axi s_axi_arprot arprot Input 3
  add_interface_port s_axi s_axi_arready arready Output 1
  add_interface_port s_axi s_axi_rvalid rvalid Output 1
  add_interface_port s_axi s_axi_rresp rresp Output 2
  add_interface_port s_axi s_axi_rdata rdata Output 32
  add_interface_port s_axi s_axi_rready rready Input 1
}

