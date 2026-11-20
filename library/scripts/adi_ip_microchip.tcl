###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

###############################################################################
# Microchip Libero SoC – HDL+ core packaging helpers.
#
# Provides procedures for creating HDL+ cores and automatically adding
# interfaces from parsed top-level Verilog port lists so that ADI library IP
# modules can be instantiated inside SmartDesign block diagrams.
#
# Typical flow: import the original HDL sources into the open project, call
# build_design_hierarchy, then create an HDL+ core from a generated wrapper
# that lives in a sibling ../ip/ tree next to the project directory.
#
# Typical usage in a per-library *_mc.tcl script:
#
#   source $ad_hdl_dir/library/scripts/adi_ip_microchip.tcl
#
#   ipm::package_hdl_core axi_sysid axi_sysid_0
#
###############################################################################

namespace eval ipm {
  variable mc_script_map {}
}

###############################################################################
## Lightweight tracing helper for Microchip HDL+ packaging steps.
###############################################################################
proc ipm::trace {message} {
  puts $message
  flush stdout
}

###############################################################################
## Normalizes a logical core name by stripping known generated wrapper suffixes.
##
## This keeps the *_mc.tcl lookup stable even when wrapper instances append
## width- or wrapper-specific postfixes to the base core name.
###############################################################################
proc ipm::base_core_name {core_name} {
  set base_name $core_name
  regsub {_w_[0-9a-fA-F]+$} $base_name {} base_name
  regsub {_w$} $base_name {} base_name
  return $base_name
}

###############################################################################
## Normalizes HDL+ parameter override entries into sorted NAME:VALUE strings.
##
##
## \param[params] - Tcl list of NAME:VALUE override strings
## \return sorted Tcl list of normalized NAME:VALUE entries
###############################################################################
proc ipm::normalize_instance_params {params} {
  set normalized {}

  foreach entry $params {
    if {![regexp {^([^:]+):(.*)$} $entry -> param_name param_value]} {
      error "Invalid HDL+ core parameter override '$entry'. Expected NAME:VALUE."
    }

    set param_name [string trim $param_name]
    set param_value [string trim $param_value]
    if {$param_name eq ""} {
      error "Invalid HDL+ core parameter override '$entry'. Parameter name is empty."
    }

    lappend normalized "${param_name}:${param_value}"
  }

  return [lsort $normalized]
}

###############################################################################
## Converts normalized NAME:VALUE overrides into a Tcl dict.
##
## \param[params] - Tcl list of NAME:VALUE override strings
## \return Tcl dict keyed by parameter name
###############################################################################
proc ipm::parameter_override_dict {params} {
  set overrides {}

  foreach entry [ipm::normalize_instance_params $params] {
    regexp {^([^:]+):(.*)$} $entry -> param_name param_value
    dict set overrides $param_name $param_value
  }

  return $overrides
}

###############################################################################
## Recursively finds Microchip HDL+ helper scripts below the given root.
##
## Directories such as .git, .github, and _bld are skipped to avoid scanning
## repository metadata and generated build trees.
###############################################################################
proc ipm::find_mc_scripts {root_dir} {
  set scripts {}

  foreach entry [glob -nocomplain -directory $root_dir *] {
    if {[file isdirectory $entry]} {
      set tail [file tail $entry]
      if {$tail in {.git .github _bld}} {
        continue
      }
      set scripts [concat $scripts [ipm::find_mc_scripts $entry]]
    } elseif {[string match *_mc.tcl [file tail $entry]]} {
      lappend scripts [file normalize $entry]
    }
  }

  return $scripts
}

###############################################################################
## Rebuilds the in-memory map from logical core names to *_mc.tcl scripts.
##
## \return Tcl dict mapping core names to matching script paths
###############################################################################
proc ipm::refresh_mc_script_map {} {
  global ad_hdl_dir
  variable mc_script_map

  set mc_script_map {}
  if {![info exists ad_hdl_dir] || $ad_hdl_dir eq "" || ![file isdirectory $ad_hdl_dir]} {
    return $mc_script_map
  }

  foreach script_path [ipm::find_mc_scripts $ad_hdl_dir] {
    set script_name [file rootname [file tail $script_path]]
    regsub {_mc$} $script_name {} core_name
    dict lappend mc_script_map $core_name $script_path
  }

  return $mc_script_map
}

###############################################################################
## Resolves the unique *_mc.tcl script path for a logical HDL+ core name.
##
## \param[core_name] - logical core name, optionally with generated suffixes
## \return normalized path to the matching *_mc.tcl helper script
###############################################################################
proc ipm::get_mc_script_path {core_name} {
  variable mc_script_map

  if {[dict size $mc_script_map] == 0} {
    ipm::refresh_mc_script_map
  }

  set base_name [ipm::base_core_name $core_name]
  if {![dict exists $mc_script_map $base_name]} {
    error "No _mc.tcl script mapped for HDL+ core '$base_name'."
  }

  set script_paths [dict get $mc_script_map $base_name]
  if {[llength $script_paths] != 1} {
    error "Multiple _mc.tcl scripts mapped for HDL+ core '$base_name': $script_paths"
  }

  return [lindex $script_paths 0]
}

###############################################################################
## Applies parameter overrides to parsed module metadata.
##
## \param[mod_data]   - parsed module dict returned by ipm::parse_module
## \param[overrides]  - Tcl dict of NAME -> VALUE overrides
## \return updated module metadata dict
###############################################################################
proc ipm::apply_parameter_overrides {mod_data overrides} {
  if {[dict size $overrides] == 0} {
    return $mod_data
  }

  set updated_parlist {}
  set seen {}
  foreach param [dict get $mod_data parlist] {
    set param_name [dict get $param name]
    if {[dict exists $overrides $param_name]} {
      dict set param value [dict get $overrides $param_name]
      lappend seen $param_name
    }
    lappend updated_parlist $param
  }

  foreach param_name [dict keys $overrides] {
    if {[lsearch -exact $seen $param_name] == -1} {
      error "Unknown HDL+ core parameter '$param_name' for module [dict get $mod_data mod_name]."
    }
  }

  dict set mod_data parlist $updated_parlist
  return $mod_data
}

###############################################################################
## Reuses an existing packaged HDL+ core or repackages it when needed.
##
## The corresponding *_mc.tcl script is sourced to discover the original HDL
## source file, then the flow is delegated to ipm::package_hdl_core_from_file.
###############################################################################
proc ipm::resolve_packaged_hdl_core {core_name instance_name args} {
  global ad_project_dir

  array set opt [list \
    -params {} \
    -output_dir {} \
    -axi_xptn_portlist {} \
    -apb_xptn_portlist {} \
    -bif_roles {} \
    -add_axi_interfaces 1 \
    -add_apb_interfaces 1 \
    {*}$args]

  set generated_core_name $instance_name
  if {
    [info exists ad_project_dir] &&
    $ad_project_dir ne "" &&
    [file isdirectory [file join $ad_project_dir component User Private $generated_core_name]]
  } {
    if {[llength $opt(-params)] > 0} {
      ipm::trace "TRACE: forcing repackaging for HDL+ core $generated_core_name with params $opt(-params)"
    } else {
      return $generated_core_name
    }
  }

  set base_name [ipm::base_core_name $core_name]
  set script_path [ipm::get_mc_script_path $base_name]

  uplevel 1 {unset -nocomplain src_file}
  ipm::trace "TRACE: sourcing HDL+ core script $script_path for $base_name"
  uplevel 1 [list source $script_path]
  if {[catch {uplevel 1 {set src_file}} src_file] || $src_file eq ""} {
    error "HDL+ core script '$script_path' did not set src_file."
  }

  return [ipm::package_hdl_core_from_file \
    $generated_core_name \
    $src_file \
    -params $opt(-params) \
    -output_dir $opt(-output_dir) \
    -axi_xptn_portlist $opt(-axi_xptn_portlist) \
    -apb_xptn_portlist $opt(-apb_xptn_portlist) \
    -bif_roles $opt(-bif_roles) \
    -add_axi_interfaces $opt(-add_axi_interfaces) \
    -add_apb_interfaces $opt(-add_apb_interfaces)]
}

###############################################################################
## Packages an HDL+ core if needed, then instantiates it in SmartDesign.
##
## Required arguments are positional. Optional arguments are passed through to
## the packaging step before sd_instantiate_hdl_core is called.
###############################################################################
proc ipm::instantiate_hdl_core {hdl_core_name instance_name args} {
  set local_opt [list \
    -params {} \
    -axi_xptn_portlist {} \
    -apb_xptn_portlist {} \
    -bif_roles {} \
    -output_dir {} \
    -add_axi_interfaces 1 \
    -add_apb_interfaces 1]

  foreach forbidden_opt {-hdl_core_name -instance_name} {
    if {[dict exists $args $forbidden_opt]} {
      error "ipm::instantiate_hdl_core uses positional required arguments; remove $forbidden_opt from the option list."
    }
  }

  array set opt [list \
    {*}$local_opt \
    {*}$args]

  set packaged_core_name [ipm::package_hdl_core \
    $hdl_core_name \
    $instance_name \
    -params $opt(-params) \
    -axi_xptn_portlist $opt(-axi_xptn_portlist) \
    -apb_xptn_portlist $opt(-apb_xptn_portlist) \
    -bif_roles $opt(-bif_roles) \
    -output_dir $opt(-output_dir) \
    -add_axi_interfaces $opt(-add_axi_interfaces) \
    -add_apb_interfaces $opt(-add_apb_interfaces)]
  set instantiate_args [dict remove [array get opt] -params -axi_xptn_portlist -apb_xptn_portlist -bif_roles -output_dir -add_axi_interfaces -add_apb_interfaces]
  dict set instantiate_args -instance_name $instance_name
  dict set instantiate_args -hdl_core_name $packaged_core_name

  ipm::trace "TRACE: before sd_instantiate_hdl_core for $packaged_core_name with $instantiate_args"
  set instantiate_result [uplevel 1 [concat sd_instantiate_hdl_core $instantiate_args]]
  ipm::trace "TRACE: after sd_instantiate_hdl_core for $packaged_core_name"
  return $instantiate_result
}

###############################################################################
## Packages or reuses an HDL+ core.
#
# Public arguments:
# core_name             - logical HDL core name used to find the *_mc.tcl script
# instance_name         - generated HDL+ core/module name for this project instance
#
# Optional arguments:
# \opt[params]              - NAME:VALUE overrides applied in the generated wrapper
# \opt[output_dir]          - wrapper output directory; defaults to the project hdl/ dir
# \opt[axi_xptn_portlist]   - ports excluded from automatic AXI detection
# \opt[apb_xptn_portlist]   - ports excluded from automatic APB detection
# \opt[bif_roles]           - {prefix role ...} bus interface roles instead of the detected
#                             master/slave (the role field of the hdl_core_add_bif
#                             definition), for AXI and APB; e.g. {s_apb mirroredMaster}
#                             for a slave port that a master drives directly (the MSS
#                             FIC3): SmartDesign connects a master only to a
#                             mirroredMaster and a slave only to a mirroredSlave
# \opt[add_axi_interfaces]  - 1 (default) auto-adds detected AXI interfaces; 0 skips them
# \opt[add_apb_interfaces]  - 1 (default) auto-adds detected APB interfaces; 0 skips them
###############################################################################
proc ipm::package_hdl_core {core_name instance_name args} {
  foreach forbidden_opt {-hdl_core_name -instance_name -file} {
    if {[dict exists $args $forbidden_opt]} {
      error "ipm::package_hdl_core uses positional required arguments; remove $forbidden_opt from the option list."
    }
  }

  array set opt [list \
    -params {} \
    -output_dir {} \
    -axi_xptn_portlist {} \
    -apb_xptn_portlist {} \
    -bif_roles {} \
    -add_axi_interfaces 1 \
    -add_apb_interfaces 1 \
    {*}$args]

  return [ipm::resolve_packaged_hdl_core \
    $core_name \
    $instance_name \
    -params $opt(-params) \
    -output_dir $opt(-output_dir) \
    -axi_xptn_portlist $opt(-axi_xptn_portlist) \
    -apb_xptn_portlist $opt(-apb_xptn_portlist) \
    -bif_roles $opt(-bif_roles) \
    -add_axi_interfaces $opt(-add_axi_interfaces) \
    -add_apb_interfaces $opt(-add_apb_interfaces)]
}

###############################################################################
## Packages an HDL+ core directly from a source file.
##
## This flow parses the HDL, generates a project-local wrapper when needed,
## imports that wrapper, creates the HDL+ core, and adds supported interfaces.
###############################################################################
proc ipm::package_hdl_core_from_file {core_name file_path args} {
  global ad_project_dir

  array set opt [list \
    -params {} \
    -output_dir {} \
    -axi_xptn_portlist {} \
    -apb_xptn_portlist {} \
    -bif_roles {} \
    -add_axi_interfaces 1 \
    -add_apb_interfaces 1 \
    {*}$args]

  set param_overrides [ipm::parameter_override_dict $opt(-params)]

  set mod_data [ipm::parse_module $file_path]
  set mod_data [ipm::apply_parameter_overrides $mod_data $param_overrides]
  lassign [ipm::generate_param_wrapper \
    $core_name \
    $file_path \
    $mod_data \
    -output_dir $opt(-output_dir)] \
    wrapper_module_name wrapper_file_path create_hdl_core_file_path

  ipm::trace "INFO: Creating HDL+ core: $wrapper_module_name from $create_hdl_core_file_path"

  ipm::trace "TRACE: importing wrapper source $wrapper_file_path"
  import_files -library work -hdl_source $wrapper_file_path
  ipm::trace "TRACE: rebuilding hierarchy after wrapper import"
  build_design_hierarchy

  ipm::trace "TRACE: before ::create_hdl_core for $wrapper_module_name"
  create_hdl_core \
    -file $create_hdl_core_file_path \
    -module $wrapper_module_name \
    -library {work} \
    -package {}
  ipm::trace "TRACE: after ::create_hdl_core for $wrapper_module_name"

  ipm::trace "TRACE: before hdl_core_extract_ports_and_parameters for $wrapper_module_name"
  hdl_core_extract_ports_and_parameters -hdl_core_name $wrapper_module_name
  ipm::trace "TRACE: after hdl_core_extract_ports_and_parameters for $wrapper_module_name"

  if {$opt(-add_axi_interfaces)} {
    ipm::trace "TRACE: before ipm::add_axi_interfaces for $wrapper_module_name"
    ipm::add_axi_interfaces $wrapper_module_name $mod_data \
      -xptn_portlist $opt(-axi_xptn_portlist) \
      -roles $opt(-bif_roles)
    ipm::trace "TRACE: after ipm::add_axi_interfaces for $wrapper_module_name"
  } else {
    ipm::trace "TRACE: skipping ipm::add_axi_interfaces for $wrapper_module_name"
  }

  if {$opt(-add_apb_interfaces)} {
    ipm::trace "TRACE: before ipm::add_apb_interfaces for $wrapper_module_name"
    ipm::add_apb_interfaces $wrapper_module_name $mod_data \
      -xptn_portlist $opt(-apb_xptn_portlist) \
      -roles $opt(-bif_roles)
    ipm::trace "TRACE: after ipm::add_apb_interfaces for $wrapper_module_name"
  } else {
    ipm::trace "TRACE: skipping ipm::add_apb_interfaces for $wrapper_module_name"
  }

  return $wrapper_module_name
}

###############################################################################
## Rewrites a generated wrapper path into the project-relative path expected by
## create_hdl_core when the wrapper lives under the active project directory.
##
## \param[file_path] - absolute or relative wrapper file path
## \return project-relative path when possible, otherwise normalized absolute path
###############################################################################
proc ipm::get_create_hdl_core_source_path {file_path} {
  global ad_project_dir

  set normalized_path [file normalize $file_path]

  if {[info exists ad_project_dir] && $ad_project_dir ne ""} {
    set normalized_project_dir [file normalize $ad_project_dir]
    set project_prefix "${normalized_project_dir}[file separator]"
    if {[string first $project_prefix $normalized_path] == 0} {
      return [string range $normalized_path [string length $project_prefix] end]
    }
  }

  return $normalized_path
}

###############################################################################
## Parses the top-level Verilog module and extracts flat port and parameter
## lists.
#
# The returned dict contains:
#   mod_name - top-level module name
#   portlist - list of parsed port dicts
#   parlist  - list of parsed parameter dicts
###############################################################################
proc ipm::parse_module {path} {
  set file [open $path]
  set data [read $file]
  close $file

  if {![regexp {(^|\n)\s*module\s+([^;#(\n]+)} $data -> _ mod_name]} {
    puts "ERROR: no module found in the Verilog file: $path"
    exit 2
  }

  set portlist {}
  set parlist {}
  set param_lines [regexp -all -inline {\n\s*parameter[^\n]+} $data]
  set port_lines [regexp -all -inline {\n\s*input[^\n]+|\n\s*output[^\n]+|\n\s*inout[^\n]+} $data]
  set regx_port {\s*(input|output|inout)\s+(\w+\s+)?(\[.+:.+\]\s+)?(\w+)\s*}
  set regx_param {\s*parameter\s+(\w+\s+)?(\[.+:.+\]\s+)?(\w+)\s*(=\s*)?([^,;]+)?\s*}

  foreach line $port_lines {
    foreach cap [split $line {,;}] {
      if {$cap eq ""} {
        continue
      }
      if {[regexp $regx_port $cap -> direction type size name]} {
        lappend portlist [ipm::format_port $direction $type $size $name]
      }
    }
  }

  if {[llength $param_lines] != 0} {
    set last_param_line [lindex $param_lines end]
    foreach line [lrange $param_lines 0 end-1] {
      foreach cap [split $line {,;}] {
        if {$cap eq ""} {
          continue
        }
        if {[regexp $regx_param $cap -> type size name sign value]} {
          lappend parlist [ipm::format_parameter $type $size $name $value]
        }
      }
    }

    foreach cap [split $last_param_line {,;}] {
      if {$cap eq ""} {
        continue
      }
      if {[regexp $regx_param $cap -> type size name sign value]} {
        if {$value ne "" && [string first "(" $value] != -1} {
          set value [ipm::get_balanced_section $value]
        }
        lappend parlist [ipm::format_parameter $type $size $name $value]
      }
    }
  }

  return [dict create mod_name [string trim $mod_name] portlist $portlist parlist $parlist]
}

###############################################################################
## Extracts a balanced substring, primarily for parameter values containing
## parenthesized expressions.
###############################################################################
proc ipm::get_balanced_section {str {open {(}} {close {)}}} {
  set diff 0
  set last_index 0

  for {set i 0} {$i < [string length $str]} {incr i} {
    set char [string index $str $i]
    if {$char == $open} {
      incr diff
    } elseif {$char == $close} {
      if {$diff == 0} {
        set last_index $i
        break
      }
      incr diff -1
    }
    if {$diff == 0} {
      set last_index [expr {$i + 1}]
    }
  }

  return [string range $str 0 [expr {$last_index - 1}]]
}

###############################################################################
## Formats one parsed Verilog parameter into the returned module-data dict
## shape.
###############################################################################
proc ipm::format_parameter {type size name value} {
  if {$type ne ""} {
    dict set param type [string map {" " ""} $type]
  }
  if {$size ne ""} {
    set size [string map {"[" "" "]" "" " " ""} $size]
    set size [split $size {:}]
    dict set param from [lindex $size 0]
    dict set param to [lindex $size 1]
  }
  dict set param name $name
  if {$value ne ""} {
    dict set param value [string map {" " ""} $value]
  }
  return $param
}

###############################################################################
## Formats one parsed Verilog port into the returned module-data dict shape.
###############################################################################
proc ipm::format_port {direction type size name} {
  dict set port dir $direction
  if {$type ne ""} {
    dict set port type [string map {" " ""} $type]
  }
  if {$size ne ""} {
    set size [string map {"[" "" "]" "" " " ""} $size]
    set size [split $size {:}]
    dict set port from [lindex $size 0]
    dict set port to [lindex $size 1]
  }
  dict set port name $name
  return $port
}

###############################################################################
## Returns 1 when the parameter can be exposed as a GUI-editable HDL+ core
## parameter. String parameters are kept internal; boolean and integer-like
## parameters stay visible to the GUI.
###############################################################################
proc ipm::is_gui_parameter {param} {
  set type ""
  set value ""
  if {[dict exists $param type]} {
    set type [string tolower [dict get $param type]]
  }
  if {[dict exists $param value]} {
    set value [dict get $param value]
  }

  if {$type eq "string"} {
    return 0
  }

  if {$type ne ""} {
    return [expr {$type in {integer int longint shortint byte bit bool boolean}}]
  }

  if {$value eq ""} {
    return 1
  }

  if {[regexp {^\s*".*"\s*$} $value]} {
    return 0
  }

  return 1
}

###############################################################################
## Splits parsed parameters into GUI-safe parameter ports and internal
## localparams used by the generated wrapper.
###############################################################################
proc ipm::split_parameters {mod_data} {
  set gui_params {}
  set local_params {}

  foreach param [dict get $mod_data parlist] {
    if {[ipm::is_gui_parameter $param]} {
      lappend gui_params $param
    } else {
      lappend local_params $param
    }
  }

  return [list $gui_params $local_params]
}

###############################################################################
## Generates a wrapper module. In a project build, the wrapper is written
## directly into the project's hdl/ directory and then added to the design.
## Non-GUI-safe parameters become localparams in the wrapper; GUI-safe
## parameters remain wrapper parameters.
###############################################################################
proc ipm::generate_param_wrapper {wrapper_module_name file_path mod_data args} {
  global ad_project_dir

  array set opt [list \
    -output_dir {} \
    {*}$args]

  set original_module_name [dict get $mod_data mod_name]
  set extension [file extension $file_path]

  if {$opt(-output_dir) ne {}} {
    set wrapper_dir [file normalize $opt(-output_dir)]
  } elseif {[info exists ad_project_dir] && $ad_project_dir ne ""} {
    set wrapper_dir [file normalize [file join $ad_project_dir hdl]]
  } else {
    set wrapper_dir [file normalize [file join [file dirname $file_path] .. ip $original_module_name]]
  }
  file mkdir $wrapper_dir

  lassign [ipm::split_parameters $mod_data] gui_params local_params
  set wrapper_path [file join $wrapper_dir ${wrapper_module_name}$extension]
  set wrapper_params [ipm::render_parameter_port_list $gui_params]
  set wrapper_ports [ipm::render_port_list [dict get $mod_data portlist]]
  set instance_params [ipm::render_parameter_assignment_list [dict get $mod_data parlist]]
  set instance_ports [ipm::render_port_assignment_list [dict get $mod_data portlist]]

  set fh [open $wrapper_path w]
  if {$wrapper_params eq ""} {
    puts $fh "module $wrapper_module_name ("
  } else {
    puts $fh "module $wrapper_module_name$wrapper_params ("
  }
  puts $fh $wrapper_ports
  puts $fh ");"

  foreach param $local_params {
    puts $fh "  [ipm::render_wrapper_localparam_declaration $param];"
  }

  puts $fh ""
  if {$instance_params eq ""} {
    puts $fh "  $original_module_name i_original ("
  } else {
    puts $fh "  $original_module_name$instance_params i_original ("
  }
  puts $fh $instance_ports
  puts $fh "  );"
  puts $fh "endmodule"
  close $fh

  set create_hdl_core_file_path [ipm::get_create_hdl_core_source_path $wrapper_path]
  return [list $wrapper_module_name [file normalize $wrapper_path] $create_hdl_core_file_path]
}

proc ipm::render_wrapper_localparam_declaration {param} {
  set wrapper_param $param
  if {[dict exists $wrapper_param type]} {
    if {[string tolower [dict get $wrapper_param type]] eq "string"} {
      dict unset wrapper_param type
    }
  }

  return [ipm::render_parameter_declaration localparam $wrapper_param]
}

###############################################################################
## Renders the wrapper module parameter-port list for GUI-visible parameters.
###############################################################################
proc ipm::render_parameter_port_list {params} {
  if {[llength $params] == 0} {
    return ""
  }

  set lines " #(\n"
  set last_index [expr {[llength $params] - 1}]
  for {set i 0} {$i < [llength $params]} {incr i} {
    set param [lindex $params $i]
    append lines "  [ipm::render_parameter_declaration parameter $param]"
    if {$i != $last_index} {
      append lines ","
    }
    append lines "\n"
  }
  append lines ")"
  return $lines
}

###############################################################################
## Renders one parameter or localparam declaration from parsed metadata.
###############################################################################
proc ipm::render_parameter_declaration {keyword param} {
  set decl $keyword
  if {[dict exists $param type]} {
    append decl " [dict get $param type]"
  }
  if {[dict exists $param from] && [dict exists $param to]} {
    append decl { [}
    append decl [dict get $param from]
    append decl :
    append decl [dict get $param to]
    append decl {]}
  }
  append decl " [dict get $param name]"
  if {[dict exists $param value]} {
    append decl " = [dict get $param value]"
  }
  return $decl
}

###############################################################################
## Renders the wrapper module port list from parsed port metadata.
###############################################################################
proc ipm::render_port_list {ports} {
  set lines ""
  set last_index [expr {[llength $ports] - 1}]
  for {set i 0} {$i < [llength $ports]} {incr i} {
    set port [lindex $ports $i]
    append lines "  [ipm::render_port_declaration $port]"
    if {$i != $last_index} {
      append lines ","
    }
    append lines "\n"
  }
  return $lines
}

###############################################################################
## Renders one port declaration from parsed metadata.
###############################################################################
proc ipm::render_port_declaration {port} {
  set decl [dict get $port dir]
  if {[dict exists $port type]} {
    append decl " [dict get $port type]"
  }
  if {[dict exists $port from] && [dict exists $port to]} {
    append decl { [}
    append decl [dict get $port from]
    append decl :
    append decl [dict get $port to]
    append decl {]}
  }
  append decl " [dict get $port name]"
  return $decl
}

###############################################################################
## Renders the parameter assignment list used on the wrapped instance.
###############################################################################
proc ipm::render_parameter_assignment_list {params} {
  if {[llength $params] == 0} {
    return ""
  }

  set lines " #(\n"
  set last_index [expr {[llength $params] - 1}]
  for {set i 0} {$i < [llength $params]} {incr i} {
    set param [lindex $params $i]
    append lines "    .[dict get $param name] ([dict get $param name])"
    if {$i != $last_index} {
      append lines ","
    }
    append lines "\n"
  }
  append lines "  )"
  return $lines
}

###############################################################################
## Renders the wrapped-instance port assignment list.
##
## \param[ports]          - parsed port metadata list
## \param[signal_prefix]  - optional prefix for generated internal signals
###############################################################################
proc ipm::render_port_assignment_list {ports {signal_prefix ""}} {
  set lines ""
  set last_index [expr {[llength $ports] - 1}]
  for {set i 0} {$i < [llength $ports]} {incr i} {
    set port [lindex $ports $i]
    set port_name [dict get $port name]
    if {$signal_prefix ne "" && [dict get $port dir] ne "inout"} {
      set signal_name ${signal_prefix}${port_name}
    } else {
      set signal_name $port_name
    }
    append lines "    .${port_name} (${signal_name})"
    if {$i != $last_index} {
      append lines ","
    }
    append lines "\n"
  }
  return $lines
}

###############################################################################
## Returns all non-excluded port names whose names match the given prefix and,
## optionally, a known suffix list.
#
# \opt[mod_data]          -mod_data $mod_data
# \opt[v_prefix]          -v_prefix s_axi
# \opt[xptn_portlist]     -xptn_portlist {s_axi_aclk s_axi_aresetn}
# \opt[allowed_suffixes]  -allowed_suffixes [suffixes axi4]
###############################################################################
proc ipm::get_ports_by_prefix {args} {
  array set opt [list \
    -mod_data "" \
    -v_prefix "" \
    -xptn_portlist {} \
    -allowed_suffixes {} \
    {*}$args]

  set result {}
  foreach port [dict get $opt(-mod_data) portlist] {
    set name [dict get $port name]
    if {[lsearch -exact $opt(-xptn_portlist) $name] != -1} {
      continue
    }
    if {[string match "$opt(-v_prefix)_*" $name]} {
      if {$opt(-allowed_suffixes) != {}} {
        set suffix [string map [list $opt(-v_prefix)_ ""] $name]
        if {[lsearch -exact $opt(-allowed_suffixes) $suffix] == -1} {
          continue
        }
      }
      lappend result $name
    }
  }
  return $result
}

###############################################################################
## Returns the recognized standard signal suffixes for a supported interface
## kind.
###############################################################################
proc ipm::suffixes {interface_kind} {
  switch -- $interface_kind {
    axi4 {
      return {
        awid awaddr awlen awsize awburst awlock awcache awprot awqos awvalid
        awready wdata wstrb wlast wvalid wready bid bresp bvalid bready
        arid araddr arlen arsize arburst arlock arcache arprot arqos arvalid
        arready rid rdata rresp rlast rvalid rready
      }
    }
    axi4_lite {
      return {
        awaddr awprot awvalid awready wdata wstrb wvalid wready bresp bvalid
        bready araddr arprot arvalid arready rdata rresp rvalid rready
      }
    }
    axi4_stream {
      return {tvalid tready tdata tstrb tkeep tlast tid tdest tuser}
    }
    axi4_stream_short {
      return {valid ready data strb keep last id dest user}
    }
    apb {
      return {paddr psel pselx penable pwrite prdata pwdata pready pslverr}
    }
  }

  error "Unknown interface kind: $interface_kind"
}

###############################################################################
## Internal helper: adds one interface by prefix, optionally constraining the
## accepted signals to a known suffix set. -roles {bif_name role ...} replaces
## the role (the last field of the definition) of the named interfaces.
###############################################################################
proc ipm::add_interface_by_prefix {core_name bif_name vlnv mod_data v_prefix args} {
  array set opt [list \
    -xptn_portlist {} \
    -t "" \
    -allowed_suffixes {} \
    -logical_overrides {} \
    -roles {} \
    {*}$args]

  if {[dict exists $opt(-roles) $bif_name]} {
    set vlnv [join [lreplace [split $vlnv :] end end [dict get $opt(-roles) $bif_name]] :]
    ipm::trace "TRACE: interface $bif_name of $core_name with the role of $vlnv"
  }

  set prefixed_ports [ipm::get_ports_by_prefix \
    -mod_data $mod_data \
    -v_prefix $v_prefix \
    -xptn_portlist $opt(-xptn_portlist) \
    -allowed_suffixes $opt(-allowed_suffixes)]

  set signal_map {}
  foreach pname $prefixed_ports {
    set suffix [string map [list ${v_prefix}_ ""] $pname]
    if {[dict exists $opt(-logical_overrides) $suffix]} {
      set logical [dict get $opt(-logical_overrides) $suffix]
    } else {
      set logical [string toupper "$opt(-t)$suffix"]
    }
    lappend signal_map $logical:$pname
  }

  if {[llength $signal_map] == 0} {
    ipm::trace "TRACE: no signals matched for interface $bif_name on core $core_name"
    return
  }

  ipm::trace "TRACE: adding interface $bif_name to $core_name with signals $signal_map"

  hdl_core_add_bif \
    -hdl_core_name $core_name \
    -bif_definition $vlnv \
    -bif_name $bif_name \
    -signal_map $signal_map
}

###############################################################################
## Internal helper: automatically adds AXI interfaces from parsed module data.
#
# The supported naming styles match the useful Lattice behavior:
#   <prefix>_aclk / <prefix>_aresetn anchors an interface group
#   AXI4      detected from *_arid or *_awid
#   AXI4-Lite detected from *_araddr or *_awaddr
#   AXIS      detected from *_tvalid or *_tready
#   AXIS      shortened naming from *_valid or *_ready using logical t* names
###############################################################################
proc ipm::add_axi_interfaces {core_name mod_data args} {
  array set opt [list \
    -clock "aclk" \
    -reset "aresetn" \
    -xptn_portlist {} \
    -roles {} \
    {*}$args]

  set ports [dict get $mod_data portlist]
  set clk_list {}
  foreach port $ports {
    set name [dict get $port name]
    if {[string match "*_${opt(-clock)}" $name]} {
      lappend clk_list $name
    }
  }

  foreach clk_name $clk_list {
    set prefix [string map [list _${opt(-clock)} ""] $clk_name]
    set excluded [list {*}$opt(-xptn_portlist) ${prefix}_${opt(-clock)} ${prefix}_${opt(-reset)}]
    ipm::trace "TRACE: evaluating interface prefix $prefix for core $core_name"

    set role ""
    foreach candidate [list ${prefix}_arid ${prefix}_awid] {
      foreach port $ports {
        if {[dict get $port name] ne $candidate} {
          continue
        }
        if {[dict get $port dir] eq "input"} {
          set role slave
        } else {
          set role master
        }
        break
      }
      if {$role ne ""} {
        break
      }
    }
    if {$role ne ""} {
      ipm::trace "TRACE: detected AXI4 interface $prefix as $role"
      ipm::add_interface_by_prefix \
        $core_name $prefix "AXI4:AMBA:AMBA4:$role" $mod_data $prefix \
        -xptn_portlist $excluded \
        -allowed_suffixes [ipm::suffixes axi4] \
        -roles $opt(-roles)
      continue
    }

    foreach candidate [list ${prefix}_araddr ${prefix}_awaddr] {
      foreach port $ports {
        if {[dict get $port name] ne $candidate} {
          continue
        }
        if {[dict get $port dir] eq "input"} {
          set role slave
        } else {
          set role master
        }
        break
      }
      if {$role ne ""} {
        break
      }
    }
    if {$role ne ""} {
      ipm::trace "TRACE: detected AXI4-Lite interface $prefix as $role"
      ipm::add_interface_by_prefix \
        $core_name $prefix "AXI4:AMBA:AMBA4:$role" $mod_data $prefix \
        -xptn_portlist $excluded \
        -allowed_suffixes [ipm::suffixes axi4_lite] \
        -roles $opt(-roles)
      continue
    }

    foreach candidate [list ${prefix}_tvalid ${prefix}_tready] {
      foreach port $ports {
        if {[dict get $port name] ne $candidate} {
          continue
        }
        if {$candidate eq "${prefix}_tvalid"} {
          if {[dict get $port dir] eq "input"} {
            set role slave
          } else {
            set role master
          }
        } else {
          if {[dict get $port dir] eq "input"} {
            set role master
          } else {
            set role slave
          }
        }
        break
      }
      if {$role ne ""} {
        break
      }
    }
    if {$role ne ""} {
      ipm::trace "TRACE: detected AXI4-Stream interface $prefix as $role"
      ipm::add_interface_by_prefix \
        $core_name $prefix "AXI4Stream:AMBA:AMBA4:$role" $mod_data $prefix \
        -xptn_portlist $excluded \
        -allowed_suffixes [ipm::suffixes axi4_stream] \
        -roles $opt(-roles)
      continue
    }

    foreach candidate [list ${prefix}_valid ${prefix}_ready] {
      foreach port $ports {
        if {[dict get $port name] ne $candidate} {
          continue
        }
        if {$candidate eq "${prefix}_valid"} {
          if {[dict get $port dir] eq "input"} {
            set role slave
          } else {
            set role master
          }
        } else {
          if {[dict get $port dir] eq "input"} {
            set role master
          } else {
            set role slave
          }
        }
        break
      }
      if {$role ne ""} {
        break
      }
    }
    if {$role ne ""} {
      ipm::trace "TRACE: detected short AXI4-Stream interface $prefix as $role"
      ipm::add_interface_by_prefix \
        $core_name $prefix "AXI4Stream:AMBA:AMBA4:$role" $mod_data $prefix \
        -xptn_portlist $excluded \
        -allowed_suffixes [ipm::suffixes axi4_stream_short] \
        -t t \
        -roles $opt(-roles)
    }
  }
}

###############################################################################
## Internal helper: automatically adds APB interfaces from parsed module data.
#
# APB has no *_aclk anchor, so each interface group is anchored on its mandatory
# *_penable probe pin. The probe direction selects the role (input -> slave,
# output -> master), -roles overrides it (see ipm::add_interface_by_prefix).
# Signal membership is filtered by the `apb` suffix list, and
# the irregular PSELx logical name is mapped from the `psel`/`pselx` suffix.
# Clock/reset pins are naturally dropped because they are not in the suffix list.
###############################################################################
proc ipm::add_apb_interfaces {core_name mod_data args} {
  array set opt [list \
    -probe "penable" \
    -xptn_portlist {} \
    -roles {} \
    {*}$args]

  set ports [dict get $mod_data portlist]
  set probe_list {}
  foreach port $ports {
    set name [dict get $port name]
    if {[string match "*_${opt(-probe)}" $name]} {
      lappend probe_list $name
    }
  }

  foreach probe_name $probe_list {
    set prefix [string map [list _${opt(-probe)} ""] $probe_name]
    ipm::trace "TRACE: evaluating APB interface prefix $prefix for core $core_name"

    set role ""
    foreach port $ports {
      if {[dict get $port name] ne $probe_name} {
        continue
      }
      if {[dict get $port dir] eq "input"} {
        set role slave
      } else {
        set role master
      }
      break
    }
    if {$role eq ""} {
      continue
    }

    set excluded [list {*}$opt(-xptn_portlist) \
      ${prefix}_clk ${prefix}_pclk ${prefix}_presetn ${prefix}_prstn]
    ipm::trace "TRACE: detected APB interface $prefix as $role"
    ipm::add_interface_by_prefix \
      $core_name $prefix "APB:AMBA:AMBA2:$role" $mod_data $prefix \
      -xptn_portlist $excluded \
      -allowed_suffixes [ipm::suffixes apb] \
      -logical_overrides {psel PSELx pselx PSELx} \
      -roles $opt(-roles)
  }
}

if {[info exists ad_hdl_dir]} {
  ipm::refresh_mc_script_map
}
