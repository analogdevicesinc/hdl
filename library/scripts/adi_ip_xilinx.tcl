
source $ad_hdl_dir/library/scripts/adi_xilinx_device_info_enc.tcl

# check tool version

if {![info exists REQUIRED_VIVADO_VERSION]} {
  set REQUIRED_VIVADO_VERSION "2018.3"
}

if {[info exists ::env(ADI_IGNORE_VERSION_CHECK)]} {
  set IGNORE_VERSION_CHECK 1
} elseif {![info exists IGNORE_VERSION_CHECK]} {
  set IGNORE_VERSION_CHECK 0
}

## Add a ttcl file to the project. XDC does not support if statements
#  in constraint definitions, this file can be used to add parameter dependent
#  constraints to the IP.
#
# \param[ip_name] - IP name
# \param[ip_constr_files] - .ttcl file name (full path)
#
proc adi_ip_ttcl {ip_name ip_constr_files} {

  set proj_filegroup [ipx::get_file_groups -of_objects [ipx::current_core] -filter {NAME =~ *synthesis*}]
  set f [ipx::add_file $ip_constr_files $proj_filegroup]
  set_property -dict [list \
    type ttcl \
  ] $f
  ipx::reorder_files -front $ip_constr_files $proj_filegroup
}

## Add ttcl file to generate simulation files for System Verilog environments.
#
# \param[ip_name] - IP name
# \param[ip_constr_files] - .ttcl file name (full path)
#
proc adi_ip_sim_ttcl {ip_name ip_files} {

  set proj_filegroup [ipx::get_file_groups -of_objects [ipx::current_core] -filter {NAME =~ *simulation*}]
  set f [ipx::add_file $ip_files $proj_filegroup]
  set_property -dict [list \
    type ttcl \
  ] $f
  ipx::reorder_files -front $ip_files $proj_filegroup
}

## Add a block design, defined by a tcl source, to the IP.
#
# \param[ip_name] - IP name
# \param[ip_bd_files] - Tcl source file
#
proc adi_ip_bd {ip_name ip_bd_files} {
  set proj_filegroup [ipx::get_file_groups xilinx_blockdiagram -of_objects [ipx::current_core]]
  if {$proj_filegroup == {}} {
    set proj_filegroup [ipx::add_file_group -type xilinx_blockdiagram "" [ipx::current_core]]
  }

  foreach file $ip_bd_files {
    set f [ipx::add_file $file $proj_filegroup]
    set_property -dict [list \
      type tclSource \
    ] $f
  }
}

## Infers an AXI Streaming interface. Note that the interface has to exist.
#
# \param[ip_name] - IP name
#
proc adi_ip_infer_streaming_interfaces {ip_name} {

  ipx::infer_bus_interfaces xilinx.com:interface:axis_rtl:1.0 [ipx::current_core]

}

## Infers an AXI Memory Mapped interface. Note that the interface has to exist.
#
# \param[ip_name] - IP name
#
proc adi_ip_infer_mm_interfaces {ip_name} {

  ipx::infer_bus_interfaces xilinx.com:interface:aximm_rtl:1.0 [ipx::current_core]

}

## Defines a dependency for a port.
#
# \param[port_prefix] - Port prefix, which defines an interface. All ports of an
# interface must have the same prefix. If it's a single port, the whole name
# shall be defined.
# \param[dependency] - Dependency (e.g "PARAMETER_NAME == 1") ??? {spirit:decode(id('MODELPARAM_VALUE.PARAM_NAME')) == CONST}
# \param[driver_value] - Driver value is optional. It defines the default driver
# value of the port.
#
proc adi_set_ports_dependency {port_prefix dependency {driver_value {}}} {
  foreach port [ipx::get_ports [format "%s%s" $port_prefix "*"]] {
    set_property ENABLEMENT_DEPENDENCY $dependency $port
    if {$driver_value != {}} {
      set_property DRIVER_VALUE $driver_value $port
    }
  }
}

## Defines a dependency for a bus.
#
# \param[bus] - Name of the bus
# \param[prefix] - Port prefix, in general same as the name of the bus
# \param[dependency] - Dependency (e.g "PARAMETER_NAME == 1") ??? {spirit:decode(id('MODELPARAM_VALUE.PARAM_NAME')) == CONST}
#
proc adi_set_bus_dependency {bus prefix dependency} {
  set_property ENABLEMENT_DEPENDENCY $dependency [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
  adi_set_ports_dependency $prefix $dependency 0
}

## Add a new port map definition to a bus interface.
#
# \param[bus] - Name of the bus interface
# \param[phys] - Physical name of the port
# \param[logic] - Logic name of the port (defined by the interface)
#
proc adi_add_port_map {bus phys logic} {
  set map [ipx::add_port_map $phys $bus]
  set_property "PHYSICAL_NAME" $phys $map
  set_property "LOGICAL_NAME" $logic $map
}

## Infers a new bus interface to an IP.
#
# \param[bus_name] - Bus name
# \param[mode] - Interface mode (master/slave)
# \param[abs_type] - Abstraction type, example: "xilinx.com:interface:axis_rtl:1.0"
# \param[bus_type] - Bus type, example: "xilinx.com:interface:axis:1.0"
# \param[port_maps] - Port map
#
# <b>Port map example:\n
#    [list \n
#        {"m_axis_ready" "TREADY"}\n
#        {"m_axis_valid" "TVALID"}\n
#        {"m_axis_data" "TDATA"} ]\n

proc adi_add_bus {bus_name mode abs_type bus_type port_maps} {
  set bus [ipx::add_bus_interface $bus_name [ipx::current_core]]

  set_property "ABSTRACTION_TYPE_VLNV" $abs_type $bus
  set_property "BUS_TYPE_VLNV" $bus_type $bus
  set_property "INTERFACE_MODE" $mode $bus

  foreach port_map $port_maps {
    adi_add_port_map $bus {*}$port_map
  }
}

## Add multiple bus interfaces of the same type to an IP.
#
# \param[num] - Number of interfaces
# \param[bus_name_prefix] - Prefix of the name of the interface
# \param[mode] - Interface mode (master/slave)
# \param[abs_type] - Abstraction type, example: "xilinx.com:interface:axis_rtl:1.0"
# \param[bus_type] - Bus type, example: "xilinx.com:interface:axis:1.0"
# \param[port_maps] - Port map, example: [list \n
#                                           {"m_axis_ready" "TREADY"}\n
#                                           {"m_axis_valid" "TVALID"}\n:
#                                           {"m_axis_data" "TDATA"} ]\n
# \param[dependency] - Dependency (e.g "PARAMETER_NAME == 1") ??? {spirit:decode(id('MODELPARAM_VALUE.PARAM_NAME')) == CONST}
#
proc adi_add_multi_bus {num bus_name_prefix mode abs_type bus_type port_maps dependency} {
  for {set i 0} {$i < $num} {incr i} {
    set bus_name [format "%s%d" $bus_name_prefix $i]
    set bus [ipx::add_bus_interface $bus_name [ipx::current_core]]

    set_property "ABSTRACTION_TYPE_VLNV" $abs_type $bus
    set_property "BUS_TYPE_VLNV" $bus_type $bus
    set_property "INTERFACE_MODE" $mode $bus

    if {$dependency ne ""} {
      set bus_dependency [string map [list "{i}" $i] $dependency]
      set_property ENABLEMENT_DEPENDENCY $bus_dependency $bus
    }

    foreach port_map $port_maps {
      lassign $port_map phys logic width
      set map [ipx::add_port_map $phys $bus]
      set_property "PHYSICAL_NAME" $phys $map
      set_property "LOGICAL_NAME" $logic $map
      set_property "PHYSICAL_RIGHT" [expr $i*$width] $map
      set_property "PHYSICAL_LEFT" [expr ($i+1)*$width-1] $map
    }
  }
}

## Assign clock and reset to an interface bus.
#
# \param[clock_signal_name] - Clock name
# \param[bus_inf_name] - Interface bus name. Note: If multiple interfaces uses
# the same clock, all shall be defined here. (e.g. "s_axis:m_axis")
# \param[reset_signal_name] - Reset signal name
# \param[reset_signal_mode] - Reset mode (master/slave)
#
proc adi_add_bus_clock {clock_signal_name bus_inf_name {reset_signal_name ""} {reset_signal_mode "slave"}} {
  set bus_inf_name_clean [string map {":" "_"} $bus_inf_name]
  set clock_inf_name [format "%s%s" $bus_inf_name_clean "_signal_clock"]
  set clock_inf [ipx::add_bus_interface $clock_inf_name [ipx::current_core]]
  set_property abstraction_type_vlnv "xilinx.com:signal:clock_rtl:1.0" $clock_inf
  set_property bus_type_vlnv "xilinx.com:signal:clock:1.0" $clock_inf
  set_property display_name $clock_inf_name $clock_inf
  set clock_map [ipx::add_port_map "CLK" $clock_inf]
  set_property physical_name $clock_signal_name $clock_map

  set assoc_busif [ipx::add_bus_parameter "ASSOCIATED_BUSIF" $clock_inf]
  set_property value $bus_inf_name $assoc_busif

  if { $reset_signal_name != "" } {
    set assoc_reset [ipx::add_bus_parameter "ASSOCIATED_RESET" $clock_inf]
    set_property value $reset_signal_name $assoc_reset

    set reset_inf_name [format "%s%s" $bus_inf_name_clean "_signal_reset"]
    set reset_inf [ipx::add_bus_interface $reset_inf_name [ipx::current_core]]
    set_property abstraction_type_vlnv "xilinx.com:signal:reset_rtl:1.0" $reset_inf
    set_property bus_type_vlnv "xilinx.com:signal:reset:1.0" $reset_inf
    set_property display_name $reset_inf_name $reset_inf
    set_property interface_mode $reset_signal_mode $reset_inf
    set reset_map [ipx::add_port_map "RST" $reset_inf]
    set_property physical_name $reset_signal_name $reset_map

    set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_inf]
    if {[string match {*[Nn]} $reset_signal_name] == 1} {
      set_property value "ACTIVE_LOW" $reset_polarity
    } else {
      set_property value "ACTIVE_HIGH" $reset_polarity
    }
  }
}

## Defines an IP as the current IP's dependency.
#
# \param[vlnvs] - VLNVs of the instantiated IPs (e.g. "analog.com:user:util_cdc:1.0")
#
proc adi_ip_add_core_dependencies {vlnvs} {
  foreach file_group [ipx::get_file_groups * -of_objects [ipx::current_core]] {
    foreach vlnv $vlnvs {
      ipx::add_subcore $vlnv $file_group
    }
  }
}

## List of all constraint files
#
set ip_constr_files ""

## Create a project which will be packed as an IP.
#
# \param[ip_name] - IP name
#
proc adi_ip_create {ip_name} {

  global ad_hdl_dir
  global ad_phdl_dir
  global ip_constr_files
  global REQUIRED_VIVADO_VERSION
  global IGNORE_VERSION_CHECK

  set VIVADO_VERSION [version -short]
  if {[string compare $VIVADO_VERSION $REQUIRED_VIVADO_VERSION] != 0} {
    puts -nonewline "CRITICAL WARNING: vivado version mismatch; "
    puts -nonewline "expected $REQUIRED_VIVADO_VERSION, "
    puts -nonewline "got $VIVADO_VERSION.\n"
  }

  create_project $ip_name . -force

  ## Load custom message severity definitions
  source $ad_hdl_dir/projects/scripts/adi_xilinx_msg.tcl

  set ip_constr_files ""
  set lib_dirs $ad_hdl_dir/library
  if {$ad_hdl_dir ne $ad_phdl_dir} {
    lappend lib_dirs $ad_phdl_dir/library
  }

  set_property ip_repo_paths $lib_dirs [current_fileset]
  update_ip_catalog
}

## Add all source files to the IP's project.
#
# \param[ip_name] - The ip name
# \param[ip_files] - IP files (*.v *.vhd *.xdc)
#
proc adi_ip_files {ip_name ip_files} {

  global ip_constr_files

  set ip_constr_files ""
  foreach m_file $ip_files {
    if {[file extension $m_file] eq ".xdc"} {
      lappend ip_constr_files $m_file
    }
  }

  set proj_fileset [get_filesets sources_1]
  add_files -norecurse -scan_for_includes -fileset $proj_fileset $ip_files
  set_property "top" "$ip_name" $proj_fileset
}

## Pack the IP and set its proprieties.
#
# \param[ip_name] - The ip name
#
proc adi_ip_properties_lite {ip_name} {

  global ip_constr_files

  ipx::package_project -root_dir . -vendor analog.com -library user -taxonomy /Analog_Devices
  set_property name $ip_name [ipx::current_core]
  set_property vendor_display_name {Analog Devices} [ipx::current_core]
  set_property company_url {http://www.analog.com} [ipx::current_core]

  set i_families ""
  foreach i_part [get_parts] {
    lappend i_families [get_property FAMILY $i_part]
  }
  set i_families [lsort -unique $i_families]
  set s_families [get_property supported_families [ipx::current_core]]
  foreach i_family $i_families {
    set s_families "$s_families $i_family Production"
    set s_families "$s_families $i_family Beta"
  }
  set_property supported_families $s_families [ipx::current_core]
  ipx::save_core

  ipx::remove_all_bus_interface [ipx::current_core]
  set memory_maps [ipx::get_memory_maps * -of_objects [ipx::current_core]]
  foreach map $memory_maps {
    ipx::remove_memory_map [lindex $map 2] [ipx::current_core ]
  }
  ipx::save_core

  set i_filegroup [ipx::get_file_groups -of_objects [ipx::current_core] -filter {NAME =~ *synthesis*}]
  foreach i_file $ip_constr_files {
    set i_module [file tail $i_file]
    regsub {_constr\.xdc} $i_module {} i_module
    ipx::add_file $i_file $i_filegroup
    ipx::reorder_files -front $i_file $i_filegroup
    set_property SCOPED_TO_REF $i_module [ipx::get_files $i_file -of_objects $i_filegroup]
  }
  ipx::save_core
}

## Set AXI interface IP proprieties.
#
# \param[ip_name] - The ip name
#
proc adi_ip_properties {ip_name} {

  adi_ip_properties_lite $ip_name

  ipx::infer_bus_interface {\
    s_axi_awvalid \
    s_axi_awaddr \
    s_axi_awprot \
    s_axi_awready \
    s_axi_wvalid \
    s_axi_wdata \
    s_axi_wstrb \
    s_axi_wready \
    s_axi_bvalid \
    s_axi_bresp \

    s_axi_bready \
    s_axi_arvalid \
    s_axi_araddr \
    s_axi_arprot \
    s_axi_arready \
    s_axi_rvalid \
    s_axi_rdata \
    s_axi_rresp \
    s_axi_rready} \
  xilinx.com:interface:aximm_rtl:1.0 [ipx::current_core]

  ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
  ipx::infer_bus_interface s_axi_aresetn xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

  set raddr_width [expr [get_property SIZE_LEFT [ipx::get_ports -nocase true s_axi_araddr -of_objects [ipx::current_core]]] + 1]
  set waddr_width [expr [get_property SIZE_LEFT [ipx::get_ports -nocase true s_axi_awaddr -of_objects [ipx::current_core]]] + 1]

  if {$raddr_width != $waddr_width} {
    puts [format "WARNING: AXI address width mismatch for %s (r=%d, w=%d)" $ip_name $raddr_width, $waddr_width]
    set range 65536
  } else {
    if {$raddr_width >= 16} {
      set range 65536
    } else {
      set range [expr 1 << $raddr_width]
    }
  }

  ipx::add_memory_map {s_axi} [ipx::current_core]
  set_property slave_memory_map_ref {s_axi} [ipx::get_bus_interfaces s_axi -of_objects [ipx::current_core]]
  ipx::add_address_block {axi_lite} [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]
  set_property range $range [ipx::get_address_blocks axi_lite \
    -of_objects [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]]
  ipx::associate_bus_interfaces -clock s_axi_aclk -reset s_axi_aresetn [ipx::current_core]
  ipx::save_core
}

## Create/overwrite temporary files containing particular build case dependencies.
#
#  DO NOT USE FOR: axi_dmac/jesd204/axi_clkgen
#
proc adi_init_bd_tcl {} {

  global auto_set_param_list
  global auto_set_param_list_overwritable
  set cc [ipx::current_core]

  if { [file exists bd] } {
    file delete -force bd
  }
  file mkdir bd

  set bd_tcl [open "bd/bd.tcl" w]

  puts $bd_tcl "# SCRIPT AUTO-GENERATED AT BUILD, DO NOT MODIFY!"
  puts $bd_tcl "proc init {cellpath otherInfo} {"
  puts $bd_tcl "  set ip \[get_bd_cells \$cellpath\]"
  puts $bd_tcl ""
  set auto_set_param ""
  foreach i $auto_set_param_list {
    if { [ipx::get_user_parameters $i -of_objects $cc -quiet] ne "" } {
      append auto_set_param "    $i \\\n"
    }
  }
  if { $auto_set_param ne "" } {
    puts $bd_tcl "  bd::mark_propagate_only \$ip \" \\"
    regsub "${i} \\\\" $auto_set_param "$i\"" auto_set_param
    puts $bd_tcl $auto_set_param
  }

  set auto_set_overwritable_param ""
  foreach i $auto_set_param_list_overwritable {
    if { [ipx::get_user_parameters $i -of_objects $cc -quiet] ne "" } {
      append auto_set_overwritable_param "    $i \\\n"
    }
  }
  if { $auto_set_overwritable_param ne "" } {
    puts $bd_tcl "  bd::mark_propagate_override \$ip \" \\"
    regsub "${i} \\\\" $auto_set_overwritable_param "$i\"" auto_set_overwritable_param
    puts $bd_tcl $auto_set_overwritable_param
  }
  puts $bd_tcl "  adi_auto_assign_device_spec \$cellpath"
  puts $bd_tcl "}"
  puts $bd_tcl ""
  puts $bd_tcl "# auto set parameters defined in auto_set_param_list (adi_xilinx_device_info_enc.tcl)"
  puts $bd_tcl "proc adi_auto_assign_device_spec {cellpath} {"
  puts $bd_tcl ""
  puts $bd_tcl "  set ip \[get_bd_cells \$cellpath\]"
  puts $bd_tcl "  set ip_param_list \[list_property \$ip\]"
  puts $bd_tcl "  set ip_path \[bd::get_vlnv_dir \[get_property VLNV \$ip\]\]"
  puts $bd_tcl ""
  puts $bd_tcl "  set parent_dir \"../\""
  puts $bd_tcl "  for {set x 1} {\$x<=4} {incr x} {"
  puts $bd_tcl "    set linkname \${ip_path}\${parent_dir}scripts/adi_xilinx_device_info_enc.tcl"
  puts $bd_tcl "    if { \[file exists \$linkname\] } {"
  puts $bd_tcl "      source \${ip_path}\${parent_dir}/scripts/adi_xilinx_device_info_enc.tcl"
  puts $bd_tcl "      break"
  puts $bd_tcl "    }"
  puts $bd_tcl "    append parent_dir \"../\""
  puts $bd_tcl "  }"
  puts $bd_tcl ""
  puts $bd_tcl "  # Find predefindes auto assignable parameters"
  puts $bd_tcl "  foreach i \$auto_set_param_list {"
  puts $bd_tcl "    if { \[lsearch \$ip_param_list \"CONFIG.\$i\"\] > 0 } {"
  puts $bd_tcl "      set val \[adi_device_spec \$cellpath \$i\]"
  puts $bd_tcl "      set_property CONFIG.\$i \$val \$ip"
  puts $bd_tcl "    }"
  puts $bd_tcl "  }"
  puts $bd_tcl ""
  puts $bd_tcl "  # Find predefindes auto assignable/overwritable parameters"
  puts $bd_tcl "  foreach i \$auto_set_param_list_overwritable {"
  puts $bd_tcl "    if { \[lsearch \$ip_param_list \"CONFIG.\$i\"\] > 0 } {"
  puts $bd_tcl "      set val \[adi_device_spec \$cellpath \$i\]"
  puts $bd_tcl "      set_property CONFIG.\$i \$val \$ip"
  puts $bd_tcl "    }"
  puts $bd_tcl "  }"
  puts $bd_tcl "}"
  puts $bd_tcl ""
  close $bd_tcl

  set proj_fileset [get_filesets sources_1]
  add_files -norecurse -scan_for_includes -fileset $proj_fileset "bd/bd.tcl"

  set local_mk [open "temporary_case_dependencies.mk" w]
  seek $local_mk 0 start
  puts $local_mk "CLEAN_TARGET += bd"
  puts $local_mk "CLEAN_TARGET += temporary_case_dependencies.mk"
  close $local_mk
}

## Search after device specific parameters and call the adi_add_device_spec_param
#  process with the result. The list of these parameters are defined in
#  library/scripts/adi_xilinx_device_info_enc.tcl
#
proc adi_add_auto_fpga_spec_params {} {

  global auto_set_param_list
  global auto_set_param_list_overwritable
  set cc [ipx::current_core]

  foreach i $auto_set_param_list {
    if { [ipx::get_user_parameters $i -of_objects $cc -quiet] ne ""} {
      adi_add_device_spec_param $i
    }
  }
  foreach i $auto_set_param_list_overwritable {
    if { [ipx::get_user_parameters $i -of_objects $cc -quiet] ne ""} {
      adi_add_device_spec_param $i
    }
  }
}

## Generate validation properties for a parameter, using predefined ranges or
#  set of values (the definition of the ranges can be found in
#  library/scripts/adi_xilinx_device_info_enc.tcl).
#
# \param[ip_parameter] - name of the HDL parameter
#
proc adi_add_device_spec_param {ip_param} {

  set cc [ipx::current_core]

  set list_pointer [string tolower $ip_param]
  set list_pointer [append list_pointer "_list"]

  global $list_pointer

  # set j 1D list from the original list
  foreach i [subst $$list_pointer] {lappend j [lindex $i 0] [lindex $i 1]}

  # set ranges or validation pairs (show x in GUI assign the corresponding y to HDL)
  if { [llength [subst $$list_pointer]] == 2 && [llength $j] == 4} {
    set_property -dict [list \
      "value_validation_type" "range" \
      "value_validation_range_minimum" [lindex [subst $$list_pointer] 0] \
      "value_validation_range_maximum" [lindex [subst $$list_pointer] 1] ] \
    [ipx::get_user_parameters $ip_param -of_objects $cc]
  } else {
    set_property -dict [list \
      "value_validation_type" "pairs" \
      "value_validation_pairs" $j ] \
    [ipx::get_user_parameters $ip_param -of_objects $cc]
  }

  # FPGA info grup
  set info_group_name "FPGA info"
  set info_group [ipgui::get_groupspec -name $info_group_name -component $cc -quiet]
  if { [string trim $info_group] eq "" } {
    set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]
    set info_group [ipgui::add_group -name $info_group_name -component $cc \
        -parent $page0 -display_name $info_group_name]
  }

  set p [ipgui::get_guiparamspec -name $ip_param -component $cc]
  set_property -dict [list "widget" "comboBox" ] $p
  ipgui::move_param -component $cc -order 0 $p -parent $info_group
}

## Define a custom interface bus.
#
# \param[name] - Interface name
#
proc adi_if_define {name} {

  ipx::create_abstraction_definition analog.com interface ${name}_rtl 1.0
  ipx::create_bus_definition analog.com interface $name 1.0

  set_property xml_file_name ${name}_rtl.xml [ipx::current_busabs]
  set_property xml_file_name ${name}.xml [ipx::current_busdef]
  set_property bus_type_vlnv analog.com:interface:${name}:1.0 [ipx::current_busabs]

  ipx::save_abstraction_definition [ipx::current_busabs]
  ipx::save_bus_definition [ipx::current_busdef]
}

## Add ports to a custom interface bus.
#
# \param[dir] - Port direction
# \param[width] - Port width
# \param[name] - Port logical name
# \param[type] - Type of the port (default "none")
#
proc adi_if_ports {dir width name {type none}} {

  ipx::add_bus_abstraction_port $name [ipx::current_busabs]
  set m_intf [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]
  set_property master_presence required $m_intf
  set_property slave_presence  required $m_intf
  set_property master_width $width $m_intf
  set_property slave_width  $width $m_intf

  set m_dir "in"
  set s_dir "out"
  if {$dir eq "output"} {
    set m_dir "out"
    set s_dir "in"
  }

  set_property master_direction $m_dir $m_intf
  set_property slave_direction  $s_dir $m_intf

  if {$type ne "none"} {
    set_property is_${type} true $m_intf
  }

  ipx::save_bus_definition [ipx::current_busdef]
  ipx::save_abstraction_definition [ipx::current_busabs]
}

## Infers a new bus interface to an IP.
#
# \param[if_name] -  Interface bus name
# \param[mode] - Type of the interface bus (master/slave)
# \param[name] - Interface bus instance name
# \param[maps] - Mapping of the physical ports
#
proc adi_if_infer_bus {if_name mode name maps} {

  ipx::add_bus_interface $name [ipx::current_core]
  set m_bus_if [ipx::get_bus_interfaces $name -of_objects [ipx::current_core]]
  set_property abstraction_type_vlnv ${if_name}_rtl:1.0 $m_bus_if
  set_property bus_type_vlnv ${if_name}:1.0 $m_bus_if
  set_property interface_mode $mode $m_bus_if

  foreach map $maps  {
    set m_maps [regexp -all -inline {\S+} $map]
    lassign $m_maps p_name p_map
    ipx::add_port_map $p_name $m_bus_if
    set_property physical_name $p_map [ipx::get_port_maps $p_name -of_objects $m_bus_if]
  }
}

